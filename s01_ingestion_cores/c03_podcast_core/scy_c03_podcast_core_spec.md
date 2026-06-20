# 🎙️ SCY-PODCAST-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_PODCAST_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion Podcast (`c03_podcast_core`)** de SCY Forge. Le système doit être capable d'extraire, de structurer et d'indexer de manière entièrement automatique les métadonnées d'un *show* (flux RSS), les *show notes*, ainsi que les transcriptions temporelles **diarisées** (séparation des locuteurs hôte/invités) de chaque épisode audio — à partir d'une URL de flux RSS, d'un GUID d'épisode ou d'une URL audio directe. L'ingestion complète s'effectue à **coût d'infrastructure nul (0 $)** grâce à la transcription locale Whisper-tiny.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **Parsing RSS** : `feed-rs` (crate Rust) pour le parsing robuste des flux RSS/Atom, `@extractus/feed-extractor` côté Mastra TS pour la validation préalable.
* **Téléchargement audio** : client HTTP streaming + `ffmpeg ≥ 6.0` (extraction, conversion vers WAV 16 kHz mono, normalisation du volume via filtre `loudnorm`).
* **Transcription** : `whisper-tiny` (modèle ONNX quantifié en **INT8**) chargé localement sur CPU via **Candle** — *sidecar* local, zéro jeton d'API.
* **Diarization** : modèle **pyannote/segmentation-3.0** exécuté en sidecar local (poids open-source, CPU) via bindings ONNX/Candle pour identifier et étiqueter les locuteurs.
* **Nettoyage HTML** : `dom_smoothie` (réutilisé du core `c02_web_article_core`) pour convertir les *show notes* HTML en Markdown propre.

> **Rappel anti-hallucination** : tout composant listé ci-dessus est une dépendance réelle et vérifiable. Aucune API de transcription cloud payante n'est autorisée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement: Ingestion d'un Épisode Unique & Transcription Diarisée

#### Scénario : Extraction d'un épisode depuis un flux RSS valide
- **GIVEN** Un lien URL de flux RSS de podcast valide fourni par l'utilisateur, accompagné d'un GUID d'épisode cible.
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` lance le processus d'ingestion.
- **THEN** le système SHALL parser le flux RSS avec `feed-rs` pour récupérer les métadonnées du *show* (titre, auteur, illustration, description, catégories).
- **AND** le système SHALL localiser l'épisode cible par son GUID et extraire : le titre, la date de publication, la durée déclarée, l'URL d'enclosure audio et les *show notes* HTML.
- **AND** le système SHALL télécharger le flux audio via l'URL d'enclosure et le convertir en WAV 16 kHz mono via `ffmpeg`.
- **AND** le système SHALL transmettre l'audio au sidecar **Whisper-tiny** local pour produire une transcription temporelle segmentée avec horodatages.
- **AND** le système SHALL exécuter la **diarization** (pyannote) pour associer chaque segment à un locuteur identifié (`[Speaker 1]`, `[Speaker 2]`, …).
- **AND** le système SHALL structurer la transcription sous forme de blocs Markdown temporels : `[hh:mm:ss] [Speaker N] Texte sémantique`.
- **AND** le système SHALL nettoyer les *show notes* HTML en Markdown via `dom_smoothie`.
- **AND** le système SHALL écrire l'ensemble dans la table `mfg_project_sources` et indexer les embeddings dans Zilliz.

#### Scénario : Ingestion depuis une URL audio directe (sans flux RSS)
- **GIVEN** Une URL pointant directement vers un fichier audio (`.mp3`, `.m4a`, `.wav`) hébergé.
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` soumet cette URL.
- **THEN** le système SHALL télécharger l'audio, le convertir et le transcrire via Whisper-tiny comme dans le scénario précédent.
- **AND** le système SHALL marquer les métadonnées de *show* comme `absentes` (mode épisode autonome) sans échouer.
- **AND** le système SHALL NOT exiger un flux RSS valide pour traiter ce cas.

#### Scénario : Résilience face à un flux RSS malformé ou non podcast
- **GIVEN** Une URL qui n'est pas un flux RSS valide ou qui ne contient pas de balise `<enclosure>` audio.
- **WHEN** Le parser `feed-rs` échoue à identifier un contenu audio.
- **THEN** le système SHALL rejeter l'ingestion avec un code d'erreur explicite `INVALID_PODCAST_FEED`.
- **AND** le système SHALL journaliser l'erreur structurée (Correlation ID) et notifier l'Agent-07 DRIFT-GUARDIAN.
- **AND** le système SHALL NOT consommer de ressource de transcription.

---

### Requirement: Ingestion d'un Flux RSS Complet (Show Multi-Épisodes)

#### Scénario : Énumération récursive et dé-duplication
- **GIVEN** Un lien URL de flux RSS de podcast valide représentant un *show* complet.
- **WHEN** L'utilisateur demande l'ingestion du *show* entier.
- **THEN** le système SHALL énumérer l'intégralité des épisodes du flux avec leur GUID, date et URL d'enclosure.
- **AND** le système SHALL comparer chaque GUID + hash d'enclosure avec la table `mfg_shared_content_cache` pour identifier les épisodes déjà indexés.
- **AND** le système SHALL ignorer et ne pas dépenser de CPU ni de jetons sur les épisodes déjà en cache.
- **AND** le système SHALL planifier des tâches d'ingestion d'arrière-plan asynchrones individuelles (file `mfg_sync_queue`) pour chaque nouvel épisode.

---

### Requirement: Diarization & Qualité Sémantique

#### Scénario : Séparation fiable des locuteurs
- **GIVEN** Un épisode audio contenant au moins deux locuteurs (ex : hôte + invité).
- **WHEN** La transcription Whisper produit des segments temporels.
- **THEN** le système SHALL aligner la sortie de pyannote sur les segments Whisper pour produire une transcription annotée par locuteur.
- **AND** le système SHALL fusionner les segments consécutifs d'un même locuteur pour éviter le fragmentation excessive.
- **AND** le système SHALL calculer un **score d'intégrité DRACO ≥ 85/100** sur le document final (cohérence temporelle, complétude, netteté sémantique).

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Lancer des transcriptions synchrones sur l'API principale risquant de dépasser le timeout de 30 secondes. Tout traitement audio long DOIT être asynchrone (SAGA via `mfg_sync_queue`).
* 🚫 **SHALL NOT** : Appeler des APIs de transcription tierces payantes (OpenAI Whisper API, AssemblyAI, Deepgram, etc.). Toutes les transcriptions DOIVENT être traitées localement à coût nul par le sidecar Whisper-tiny.
* 🚫 **SHALL NOT** : Ré-ingérer ou re-transcrire un épisode déjà présent dans `mfg_shared_content_cache`.
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens définis dans `design.md` (pas de rouge ni de bleu fade non autorisés).
* ⚠️ **MUST** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (Happy Path RSS)** : Valider qu'une URL de flux RSS valide renvoie un document Markdown structuré avec des horodatages `[hh:mm:ss]`, des étiquettes de locuteur `[Speaker N]`, et un score DRACO ≥ 85/100.
* **Test Case 2 (Épisode Multi-Locuteurs)** : Valider que la diarization identifie au minimum 2 locuteurs distincts et que ≥ 90 % des segments portent une étiquette de locuteur valide.
* **Test Case 3 (Dé-duplication Show)** : Valider qu'un *show* contenant des épisodes déjà en cache ne génère des tâches d'ingestion que pour les nouveaux épisodes.
* **Test Case 4 (Flux Invalide)** : Valider qu'une URL non-RSS renvoie le code `INVALID_PODCAST_FEED` sans lever d'exception non gérée.

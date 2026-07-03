<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-PODCAST-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_PODCAST_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

Chaque tâche est conçue pour être codée en 15 à 30 minutes de manière unitaire et testable par nos agents de développement.

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 🧭 Liste des Tâches de Production

### 🚀 Tâche 3.1 : Coder le Parseur RSS `feed-rs` (Durée : 25 min)
* **Description** : Implémenter la fonction Rust qui reçoit une URL de flux RSS, la télécharge et retourne un objet structuré contenant les métadonnées du *show* et la liste des épisodes (GUID, titre, date, URL d'enclosure, *show notes* HTML).
* **Fichier de destination** : `backend_rs/src/cores/podcast/parser.rs`
* **Critère de Succès** : Un flux RSS de test valide renvoie un objet contenant `show_title`, un tableau `episodes[]` non vide, et chaque épisode possède une `enclosure_url` et un `guid`.

### 🚀 Tâche 3.2 : Valider le flux et rejeter les non-podcasts (Durée : 15 min)
* **Description** : Ajouter la garde de validation qui rejette tout flux sans balise `<enclosure>` audio avec le code `INVALID_PODCAST_FEED` et journalisation structurée (Correlation ID).
* **Fichier de destination** : `backend_rs/src/cores/podcast/parser.rs`
* **Critère de Succès** : Une URL HTML classique ou un flux RSS sans enclosue audio renvoie `Err(InvalidPodcastFeed)` sans panic.

### 🚀 Tâche 3.3 : Coder le Téléchargeur + Conversion `ffmpeg` (Durée : 25 min)
* **Description** : Coder la fonction qui télécharge l'audio d'une `enclosure_url`, le convertit en WAV 16 kHz mono via `ffmpeg` avec filtre `loudnorm`, et persiste le fichier temporaire.
* **Fichier de destination** : `backend_rs/src/cores/podcast/audio.rs`
* **Critère de Succès** : Pour un fichier MP3 de test, la fonction produit un `.wav` mono 16 kHz lisible, d'une taille bornée par épisode.

### 🚀 Tâche 3.4 : Intégrer le Sidecar Whisper-tiny (Durée : 30 min)
* **Description** : Coder le pont vers le sidecar Whisper-tiny (ONNX INT8 / Candle) qui transmet le WAV et reçoit une transcription segmentée avec horodatages `[start, end]` et texte.
* **Fichier de destination** : `backend_rs/src/cores/podcast/transcribe.rs`
* **Critère de Succès** : Un WAV de 30 secondes renvoie un tableau de segments `{start, end, text}` cohérents et chronologiques.

### 🚀 Tâche 3.5 : Intégrer la Diarization pyannote + Alignement (Durée : 30 min)
* **Description** : Coder l'appel au sidecar pyannote/segmentation-3.0 puis l'alignement de ses étiquettes de locuteur sur les segments Whisper, avec fusion des segments consécutifs d'un même locuteur.
* **Fichier de destination** : `backend_rs/src/cores/podcast/transcribe.rs`
* **Critère de Succès** : Sur un épisode à 2 locuteurs, ≥ 90 % des segments portent une étiquette `[Speaker N]` valide après fusion.

### 🚀 Tâche 3.6 : Nettoyer les Show Notes en Markdown (Durée : 15 min)
* **Description** : Réutiliser `dom_smoothie` (core `c02_web_article_core`) pour convertir le HTML des *show notes* de l'épisode en Markdown propre.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/podcastShowNotes.ts`
* **Critère de Succès** : Un bloc HTML de *show notes* renvoie un Markdown lisible sans balises résiduelles ni scripts.

### 🚀 Tâche 3.7 : Enqueue SAGA + Dé-duplication (Durée : 20 min)
* **Description** : Coder l'orchestrateur Mastra TS qui vérifie `mfg_shared_content_cache` (par `episode_guid` + `enclosure_sha256`) et, en cas de *miss*, planifie une tâche asynchrone dans `mfg_sync_queue` par épisode.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/podcastCore.ts`
* **Critère de Succès** : Un *show* de 5 épisodes dont 2 déjà en cache génère exactement 3 tâches asynchrones uniques.

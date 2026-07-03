<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎵 SCY-TIKTOK-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_TIKTOK_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

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

## 1. Purpose
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion TikTok (`c10_tiktok_core`)** de SCY Forge. Le système doit être capable, à partir d'une URL de vidéo TikTok, d'extraire les métadonnées (auteur, description, hashtags, musique, statistiques) via **scraping furtif (Scrapling)**, de télécharger la vidéo, d'en extraire l'audio et de produire une **transcription temporelle** via le sidecar **Whisper-tiny** local. L'ingestion s'effectue à **coût d'infrastructure nul (0 $)** (transcription locale, scraping sans API payante).

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **Scraping furtif** : **Scrapling** (+ `dom_smoothie`) — contournement anti-bot, extraction des métadonnées JSON embarquées (SIGI_STATE / `_UNIVERSAL_DATA`) et de l'URL de la vidéo.
* **Téléchargement vidéo** : `yt-dlp` (gère les protocoles TikTok) ou client HTTP direct sur l'URL média extraite.
* **Extraction audio** : `ffmpeg ≥ 6.0` (conversion vers WAV 16 kHz mono, normalisation `loudnorm`).
* **Transcription** : sidecar **Whisper-tiny** (ONNX quantifié INT8 / Candle) — transcription temporelle locale, zéro jeton d'API.
* **Nettoyage** : `dom_smoothie` pour la description/caption HTML → Markdown.

> **Rappel anti-hallucination** : tout composant listé ci-dessus est une dépendance réelle et vérifiable. Aucune API TikTok officielle payante n'est utilisée. La transcription DOIT être locale (Whisper-tiny). Le scraping respecte les limites raisonnables pour ne pas être bloqué.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Scraping des Métadonnées d'une Vidéo

#### Scénario : Extraction des métadonnées via Scrapling
- **GIVEN** Une URL de vidéo TikTok valide (ex : `https://www.tiktok.com/@user/video/{id}`).
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` lance l'ingestion.
- **THEN** le système SHALL scraper la page via Scrapling (mode furtif, contournement anti-bot).
- **AND** le système SHALL extraire les métadonnées depuis le JSON embarqué : auteur (`@username`), description, hashtags, musique utilisée, statistiques (vues, likes, partages), URL de la vidéo.
- **AND** le système SHALL rejeter les vidéos supprimées/privées avec le code `TIKTOK_UNAVAILABLE`.

---

### Requirement : Téléchargement & Transcription Audio

#### Scénario : Transcription Whisper d'une vidéo courte
- **GIVEN** Une vidéo TikTok valide dont l'URL média a été extraite.
- **WHEN** Le système télécharge la vidéo.
- **THEN** le système SHALL télécharger la vidéo via `yt-dlp` (ou HTTP direct sur l'URL média).
- **AND** le système SHALL extraire et convertir l'audio en WAV 16 kHz mono via `ffmpeg`.
- **AND** le système SHALL transmettre l'audio au sidecar **Whisper-tiny** local pour transcription temporelle.
- **AND** le système SHALL structurer la transcription en blocs Markdown `[hh:mm:ss] Texte`.
- **AND** le système SHALL combiner la transcription avec la description/caption et les hashtags en un document Markdown unifié.

---

### Requirement : Gestion du Contenu Sans Parole (Musical / Muet)

#### Scénario : Vidéo avec audio non parlé
- **GIVEN** Une vidéo TikTok dont l'audio est purement musical ou sans parole détectable.
- **WHEN** Whisper produit une transcription vide ou de très faible confiance.
- **THEN** le système SHALL détecter l'absence de parole (confiance moyenne < seuil).
- **AND** le système SHALL ingérer uniquement les métadonnées (description, hashtags, musique) sans forcer une transcription incohérente.
- **AND** le système SHALL annoter le document comme `audio_non_parlé` dans les métadonnées.

---

### Requirement : Dé-duplication & Cache

#### Scénario : Évitement des ré-ingestions
- **GIVEN** Une vidéo TikTok déjà indexée dans `mfg_shared_content_cache`.
- **WHEN** Une nouvelle ingestion de la même URL est demandée.
- **THEN** le système SHALL comparer le `video_id` avec le cache.
- **AND** le système SHALL ignorer la vidéo si déjà présente (zéro scraping, zéro transcription).

---

### Requirement : Résilience face aux Blocages Anti-Bot

#### Scénario : Contournement et repli
- **GIVEN** Une page TikTok qui bloque le scraper (CAPTCHA, rate limit).
- **WHEN** Scrapling échoue à récupérer le contenu après N tentatives.
- **THEN** le système SHALL appliquer un backoff exponentiel avec rotation d'en-têtes.
- **AND** le système SHALL ouvrir le Circuit Breaker en cas d'échecs répétés.
- **AND** le système SHALL renvoyer le code `TIKTOK_BLOCKED` et notifier l'utilisateur sans boucle infinie.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Appeler des APIs de transcription cloud payantes. Le sidecar Whisper-tiny local est obligatoire.
* 🚫 **FORBIDDEN** : Bombarder TikTok de requêtes de scraping (respect des limites, rotation, backoff).
* 🚫 **SHALL NOT** : Inventer du contenu de transcription pour les vidéos muettes/musicales.
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens définis dans `design.md`.
* ⚠️ **MUST** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (Happy Path)** : Une URL TikTok valide produit un Markdown combinant transcription temporelle + description + hashtags, score DRACO ≥ 80/100.
* **Test Case 2 (Vidéo Musicale)** : Une vidéo sans parole détectable est ingérée avec métadonnées uniquement et annotation `audio_non_parlé`.
* **Test Case 3 (Dé-duplication)** : Une vidéo déjà en cache est sautée sans scraping.
* **Test Case 4 (Blocage)** : Un blocage anti-bot répété déclenche le code `TIKTOK_BLOCKED` sans boucle infinie.
* **Test Case 5 (Indisponible)** : Une vidéo supprimée renvoie `TIKTOK_UNAVAILABLE` sans exception non gérée.

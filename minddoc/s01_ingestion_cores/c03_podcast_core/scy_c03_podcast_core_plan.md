<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-PODCAST-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_PODCAST_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

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

## 1. Architecture du Flux de Données

```
 [URL Flux RSS / GUID / URL Audio]
                  │
                  ▼
      [Mastra TS Ingestion Worker]
                  │
                  ├──► [Vérification mfg_shared_content_cache] ──► Hit ──► (Fin silencieuse)
                  │
                  └──► [Miss : Parsing RSS via feed-rs]
                              │
                 ┌────────────┴─────────────────┐
                 ▼                              ▼
        [Show multi-épisodes]           [Épisode unique / URL audio]
                 │                              │
        [Énumération GUID]                     │
        [Dé-duplication cache]                 │
                 │                              │
                 └──────────────┬───────────────┘
                                ▼
                   [File mfg_sync_queue] (SAGA asynchrone)
                                │
                 ┌──────────────┴───────────────┐
                 ▼ (par épisode)                 ▼
        [Téléchargement audio]          [Conversion ffmpeg WAV 16 kHz mono]
                 │                              │ (loudnorm)
                 └──────────────┬───────────────┘
                                ▼
                   [Sidecar Whisper-tiny ONNX INT8]  ── transcription temporelle
                                │
                                ▼
                   [Sidecar pyannote/segmentation-3.0] ── diarization
                                │
                                ▼
                   [Alignement segments ↔ locuteurs]
                                │
              ┌─────────────────┼─────────────────┐
              ▼                 ▼                 ▼
    [Markdown temporel]   [Show notes MD]   [Score DRACO]
    [hh:mm:ss][Speaker]   (dom_smoothie)     (≥ 85/100)
              └─────────────────┼─────────────────┘
                                ▼
            [Écriture PostgreSQL mfg_project_sources]
            [Indexation vectorielle Zilliz]
            [Arête sémantique COSMOS-MINDGRAPH → status: completed]
```

---

## 2. Dépendances Techniques Strictes
* **Runtimes serveurs** :
  - `ffmpeg` version `≥ 6.0` installé globalement dans le conteneur Docker Northflank.
  - Sidecar **Whisper-tiny** (ONNX quantifié INT8) chargé sur CPU via Candle.
  - Sidecar **pyannote/segmentation-3.0** (poids open-source) chargé sur CPU.
* **Packages Rust (moteur Axum)** :
  - `feed-rs` (parsing RSS/Atom robuste)
  - `reqwest` (téléchargement audio streaming)
  - `whisper-rs` (bindings Whisper) ou bindings Candle ONNX
* **Packages Node.js (Mastra)** :
  - `@extractus/feed-extractor` (validation préalable du flux côté TS)
  - `dom_smoothie` (nettoyage HTML des *show notes*)
* **Stockage** :
  - PostgreSQL (Northflank) : tables `mfg_project_sources`, `mfg_shared_content_cache`, `mfg_sync_queue`.
  - Zilliz Cloud (Serverless) : collection d'embeddings sémantiques des transcriptions.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/podcastCore.ts`** : Orchestration Mastra TS (réception URL, vérification cache, enqueue SAGA).
- **`backend_rs/src/cores/podcast/parser.rs`** : Parsing RSS via `feed-rs` + extraction métadonnées *show* / épisodes.
- **`backend_rs/src/cores/podcast/audio.rs`** : Téléchargement + conversion `ffmpeg` (WAV 16 kHz mono, `loudnorm`).
- **`backend_rs/src/cores/podcast/transcribe.rs`** : Appel sidecar Whisper-tiny + alignement diarization pyannote.
- **`mfg_project_sources`** : Stockage du Markdown diarisé, des *show notes* et des métadonnées d'épisode.
- **`mfg_shared_content_cache`** : Dé-duplication par `episode_guid` + `enclosure_sha256` pour éviter les ré-ingestions.
- **`mfg_sync_queue`** : File d'attente asynchrone SAGA pour les transcriptions longues (dépassement du timeout synchrone 30 s).

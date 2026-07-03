<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-TIKTOK-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_TIKTOK_PLAN  
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
 [URL Vidéo TikTok]
        │
        ▼
 [Mastra TS Ingestion Worker]
        │
        ├──► [Vérification mfg_shared_content_cache (video_id)] ──► Hit ──► (Fin silencieuse)
        │
        └──► [Miss : Scraping furtif Scrapling]
                    │
                    ▼
        [Extraction JSON embarqué (SIGI_STATE / _UNIVERSAL_DATA)]
        → auteur, description, hashtags, musique, stats, URL vidéo
                    │
            ┌───────┴────────┐
            ▼                ▼
     [Vidéo indisponible]  [Métadonnées OK]
     → TIKTOK_UNAVAILABLE       │
                                ▼
                  [Téléchargement vidéo : yt-dlp ou HTTP direct]
                                │
                                ▼
                  [ffmpeg : WAV 16 kHz mono (loudnorm)]
                                │
                                ▼
                  [Sidecar Whisper-tiny ONNX INT8]
                  → transcription temporelle
                                │
                    ┌───────────┴───────────┐
                    ▼                       ▼
            [Parole détectée]        [Audio non parlé (musique/muet)]
            → Markdown [hh:mm:ss]    → Métadonnées uniquement
                    │                 + annotation audio_non_parlé
                    └───────────┬───────────┘
                                ▼
                  [Combinaison : transcription + description + hashtags]
                  [Score d'intégrité DRACO]
                                │
                                ▼
        [Écriture PostgreSQL mfg_project_sources]
        [Indexation vectorielle Zilliz]
        [Arête sémantique COSMOS-MINDGRAPH → status: completed]
```

**Gestion anti-blocage** :

```
 [Scrapling (mode furtif)]
        │
        ├──► [Rotation en-têtes User-Agent]
        ├──► [Backoff exponentiel sur blocage]
        ├──► [N tentatives max → Circuit Breaker]
        └──► [Échec persistant → TIKTOK_BLOCKED]
```

---

## 2. Dépendances Techniques Strictes
* **Scraping** :
  - **Scrapling** (+ `dom_smoothie`) : contournement anti-bot, extraction du JSON embarqué TikTok.
  - Rotation d'en-têtes `User-Agent` + backoff.
* **Téléchargement & Audio** :
  - `yt-dlp` (prise en charge des protocoles TikTok) ou HTTP direct sur l'URL média.
  - `ffmpeg ≥ 6.0` (WAV 16 kHz mono, `loudnorm`).
* **Transcription** :
  - Sidecar **Whisper-tiny** (ONNX INT8 / Candle) — local, zéro jeton.
* **Runtimes** :
  - Rust Axum (moteur) + Mastra TS (orchestration).
  - Circuit Breaker (ARC-001) pour les blocages anti-bot répétés.
* **Stockage** :
  - PostgreSQL (Northflank) : `mfg_project_sources`, `mfg_shared_content_cache`, `mfg_sync_queue`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/tiktokCore.ts`** : Orchestration Mastra TS (cache, enqueue SAGA, repli anti-blocage).
- **`backend_rs/src/cores/tiktok/scraper.rs`** : Scrapling furtif + extraction JSON embarqué + Circuit Breaker.
- **`backend_rs/src/cores/tiktok/video_download.rs`** : Téléchargement vidéo (`yt-dlp` / HTTP) + extraction audio `ffmpeg`.
- **`backend_rs/src/cores/tiktok/transcribe.rs`** : Appel sidecar Whisper-tiny + détection parole vs audio non parlé.
- **`mfg_project_sources`** : Stockage du Markdown (transcription + métadonnées + hashtags).
- **`mfg_shared_content_cache`** : Dé-duplication par `video_id`.
- **`mfg_sync_queue`** : File d'attente asynchrone SAGA pour les transcriptions.

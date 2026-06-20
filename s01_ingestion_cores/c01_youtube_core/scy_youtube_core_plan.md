# 🛠️ SCY-YOUTUBE-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_YOUTUBE_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Architecture du Flux de Données

```
 [URL YouTube] ──► [Mastra TS Ingestion Worker]
                         │
                         ├──► [Vérification mfg_shared_content_cache] -> Hit -> (Fin)
                         │
                         └──► [Miss : Appel yt-dlp local Sidecar]
                                    │
                        ┌───────────┴───────────┐
                        ▼ (Sous-titres OK)      ▼ (Aucun sous-titre)
                  [Formatage MD]          [Download Audio & ffmpeg]
                        │                               │
                        │                               ▼
                        │                         [Whisper-tiny]
                        │                               │
                        └───────────┬───────────────────┘
                                    ▼
                [Écriture PostgreSQL & Indexation Vectorielle Zilliz]
```

---

## 2. Dépendances Techniques Strictes
* **Runtimes serveurs** :
  - `yt-dlp` installé globalement dans le conteneur Docker Northflank.
  - `ffmpeg` version $\ge 6.0$.
* **Packages Node.js (Mastra)** :
  - `youtube-transcript-api` ou `yt-transcript-rs`
  - `@google/youtube` v3 SDK
* **Modèle local** :
  - Whisper-tiny (ONNX quantifié en INT8) chargé localement sur CPU via Candle.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/youtubeCore.ts`** : Contient le code TypeScript de traitement de l'URL.
- **`mfg_project_sources`** : Table de stockage du Markdown extrait et des métadonnées de chapitres.
- **`mfg_shared_content_cache`** : Table de dé-duplication pour éviter les ré-ingestions.

<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-YOUTUBE-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_YOUTUBE_PLAN  
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

<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-GOOGLE-DRIVE-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_GOOGLE_DRIVE_PLAN  
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
 [Connexion OAuth Composio] ──► [Jeton chiffré AES-256-GCM stocké]
                │
                ▼
 [file_id / folder_id fourni par l'utilisateur]
                │
                ▼
     [Mastra TS Ingestion Worker]
                │
                ├──► [Vérification mfg_shared_content_cache] ──► Hit + non modifié ──► (Fin silencieuse)
                │
                └──► [Miss / modifié : Appel google-drive3]
                            │
               ┌────────────┴───────────────────────┐
               ▼                                    ▼
      [Fichier unique]                      [Dossier récursif]
               │                                    │
               │                         [Énumération files.list]
               │                         [Dé-duplication par file_id+modifiedTime]
               │                                    │
               └──────────────┬─────────────────────┘
                              ▼
                 [File mfg_sync_queue] (SAGA asynchrone, par fichier)
                              │
               ┌──────────────┴───────────────────────┐
               ▼                                       ▼
   [Fichier binaire : PDF/DOCX/PPTX]      [Export Google : HTML/CSV]
               │                                       │
               ▼                                       ▼
        [Docling Docker local]                 [dom_smoothie]
        (Markdown + tables + OCR)             (HTML → Markdown)
               │                                       │
               └──────────────┬────────────────────────┘
                              ▼
                  [Score d'intégrité DRACO]
                              │
                              ▼
        [Écriture PostgreSQL mfg_project_sources]
        [Indexation vectorielle Zilliz]
        [Arête sémantique COSMOS-MINDGRAPH → status: completed]
```

**Flux de Synchronisation Incrémentale (Background cron)** :

```
 [Tâche cron planifiée]
        │
        ▼
 [Lecture startPageToken conservé]
        │
        ▼
 [google-drive3 changes.list]
        │
        ├──► Fichier modifié  ──► Ré-ingestion (file_id + nouveau modifiedTime)
        ├──► Fichier créé     ──► Nouvelle ingestion
        ├──► Fichier supprimé ──► Marquage embeddings stale (rétention)
        └──► Fichier intact   ──► (Ignoré, zéro coût)
        │
        ▼
 [Mise à jour startPageToken pour prochain cycle]
```

---

## 2. Dépendances Techniques Strictes
* **OAuth / Session** :
  - **Composio** : handshake OAuth 2.0 Google Drive, gestion des jetons, rotation, multi-comptes.
  - Chiffrement au repos : AES-256-GCM (clé maître via gestionnaire de secrets Northflank).
* **API Google Drive (Rust)** :
  - `google-drive3` (crate) : `files.list`, `files.get`, `files.export`, `changes.list`, `changes.getStartPageToken`.
* **Parsing multi-format** :
  - **Docling** (conteneur Docker local) : PDF, DOCX, PPTX, XLSX, images → Markdown.
  - OCR intégré : Tesseract / RapidOCR (pour images et PDF scannés).
  - `dom_smoothie` : nettoyage HTML (exports Google Docs/Slides).
* **Runtimes** :
  - Docker Docling tournant en sidecar local sur le conteneur Northflank.
  - Rust Axum (moteur de calcul) + Mastra TS (orchestration).

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/googleDriveCore.ts`** : Orchestration Mastra TS (OAuth Composio, vérification cache, enqueue SAGA).
- **`backend_ts/src/normal_pipeline/cores/composioOauth.ts`** : Handshake OAuth 2.0 + gestion chiffrement jetons.
- **`backend_rs/src/cores/gdrive/list.rs`** : Énumération récursive de dossier + dé-duplication.
- **`backend_rs/src/cores/gdrive/download.rs`** : Téléchargement binaire + export Google.
- **`backend_rs/src/cores/gdrive/docling_client.rs`** : Pont HTTP vers Docling Docker + OCR.
- **`backend_rs/src/cores/gdrive/sync.rs`** : Synchronisation incrémentale (`changes.list`).
- **`mfg_project_sources`** : Stockage du Markdown converti et des métadonnées de fichier.
- **`mfg_shared_content_cache`** : Dé-duplication par `file_id` + `modifiedTime` (hash).
- **`mfg_sync_queue`** : File d'attente asynchrone SAGA pour les conversions Docling longues.
- **Nouvelle table `mfg_gdrive_sync_state`** : Stockage `startPageToken` par compte pour la synchro incrémentale.

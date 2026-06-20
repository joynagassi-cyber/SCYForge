# 🛠️ SCY-EPUB-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_EPUB_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Architecture du Flux de Données

```
 [Fichier .epub local]
        │
        ▼
 [Mastra TS Ingestion Worker]
        │
        ├──► [Vérification mfg_shared_content_cache (sha256 fichier)] ──► Hit identique ──► (Fin)
        │
        └──► [Miss : Ouverture crate epub (zip)]
                    │
         ┌──────────┴───────────┐
         ▼                      ▼
   [DRM détecté ?]        [Parsing OPF manifeste]
   → EPUB_DRM_PROTECTED   quick-xml → dc:title/creator
   (rejet, pas de         /language/publisher
    contournement)              │
                          ▼
                  [Table des matières]
                  NCX (EPUB 2) / NAV (EPUB 3)
                  → hiérarchie chapitres + ancres
                          │
                          ▼
                  [Parcours du spine (ordre)]
                  Pour chaque XHTML :
                  dom_smoothie → Markdown
                          │
              ┌───────────┴───────────┐
              ▼                       ▼
        [Segmentation             [Extraction images]
         par chapitre]            (couverture, illustrations)
        → un Markdown             → références locales
          par chapitre/section
              │                       │
              └───────────┬───────────┘
                          ▼
              [Score d'intégrité DRACO]
                          │
                          ▼
        [Écriture PostgreSQL mfg_project_sources]
        [Indexation vectorielle Zilliz]
        [Arête sémantique COSMOS-MINDGRAPH → status: completed]
```

---

## 2. Dépendances Techniques Strictes
* **Parsing EPUB** :
  - crate **`epub`** (lecture archive + manifeste OPF + TOC).
  - crate `zip` (décompression bas niveau si nécessaire, avec seuil anti-bombe).
  - `quick-xml` (parsing OPF Dublin Core).
* **Conversion XHTML → Markdown** :
  - `dom_smoothie` (HTML/XHTML → Markdown propre).
* **Détection DRM** :
  - Vérification de la présence de `encryption.xml` dans `META-INF` (indicateur DRM Adobe/autre).
* **Stockage** :
  - PostgreSQL (Northflank) : `mfg_project_sources`, `mfg_shared_content_cache`, `mfg_sync_queue`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/epubCore.ts`** : Orchestration Mastra TS (réception fichier, cache, enqueue SAGA).
- **`backend_rs/src/cores/epub/opener.rs`** : Ouverture EPUB + détection DRM + métadonnées OPF.
- **`backend_rs/src/cores/epub/toc.rs`** : Parsing de la table des matières (NCX/NAV) → hiérarchie.
- **`backend_rs/src/cores/epub/chapter_converter.rs`** : Parcours du spine + conversion XHTML → Markdown (`dom_smoothie`) + segmentation chapitrée.
- **`backend_rs/src/cores/epub/media.rs`** : Extraction images et ressources embarquées.
- **`mfg_project_sources`** : Stockage des chapitres Markdown + métadonnées + références images.
- **`mfg_shared_content_cache`** : Dé-duplication par hash SHA-256 du fichier.
- **`mfg_sync_queue`** : File d'attente asynchrone SAGA pour la conversion de gros EPUB multi-chapitres.

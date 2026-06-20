# 🛠️ SCY-SCIENCE-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_SCIENCE_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Architecture du Flux de Données

```
 [Identifiant arXiv (ex: 2401.12345)]
                 │
                 ▼
     [Mastra TS Ingestion Worker]
                 │
                 ├──► [Vérification mfg_shared_content_cache (arxiv_id + version)] ──► Hit + à jour ──► (Fin)
                 │
                 └──► [Miss / nouvelle version : API arXiv (reqwest + User-Agent + rate limit)]
                             │
              ┌──────────────┴───────────────────────────┐
              ▼                                           ▼
   [Métadonnées Atom XML]                    [Téléchargement contenu]
   (export.arxiv.org/api/query)              │
   quick-xml → titre/auteurs/abstract        ├─► [e-print LaTeX (prioritaire)]
              │                              │       arxiv.org/e-print/{id}
              │                              │       flate2 + tar → .tex
              │                              │       parsing LaTeX natif
              │                              │
              │                              └─► [PDF (fallback si source absente)]
              │                                      arxiv.org/pdf/{id}.pdf
              │                                      Docling → texte + formules + figures
              │                                           │
              └──────────────┬───────────────────────────┘
                             ▼
                [Figures + légendes (\caption)]
                [Tableaux → Markdown]
                [Formules préservées $$...$$ / $...$]
                [Score DRACO (réduit si fallback PDF)]
                             │
                             ▼
        [Écriture PostgreSQL mfg_project_sources]
        [Indexation vectorielle Zilliz]
        [Arête sémantique COSMOS-MINDGRAPH → status: completed]
```

---

## 2. Dépendances Techniques Strictes
* **API arXiv** (publique, gratuite) :
  - `export.arxiv.org/api/query?id_list={id}` — métadonnées Atom XML.
  - `arxiv.org/pdf/{id}.pdf` — PDF plein texte.
  - `arxiv.org/e-print/{id}` — source LaTeX (tarball).
  - Politique : max 1 requête / 3 s sur l'API de requête.
* **Runtimes Rust** :
  - `reqwest` (client HTTP + `User-Agent` + rate limiting).
  - `quick-xml` (parsing Atom XML des métadonnées).
  - `flate2` + `tar` (décompression du tarball source LaTeX).
  - `lopdf` (accès PDF bas niveau, si nécessaire).
* **Conversion scientifique** :
  - **Docling** (Docker local) : extraction texte + formules (MathML) + figures depuis PDF.
  - Parsing LaTeX natif : extraction directe des formules `$$...$$` et `$...$` depuis le `.tex`.
* **Stockage** :
  - PostgreSQL (Northflank) : `mfg_project_sources`, `mfg_shared_content_cache`, `mfg_sync_queue`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/scienceCore.ts`** : Orchestration Mastra TS (résolution arXiv ID, cache, enqueue SAGA).
- **`backend_rs/src/cores/science/arxiv_client.rs`** : Client HTTP arXiv (métadonnées + téléchargement source/PDF, rate limiting).
- **`backend_rs/src/cores/science/latex_extractor.rs`** : Décompression tarball + parsing `.tex` (texte + formules natives).
- **`backend_rs/src/cores/science/pdf_fallback.rs`** : Fallback Docling pour PDF (texte + MathML + figures).
- **`backend_rs/src/cores/science/figures.rs`** : Extraction figures + légendes + tableaux → Markdown.
- **`mfg_project_sources`** : Stockage du Markdown scientifique, formules préservées et figures.
- **`mfg_shared_content_cache`** : Dé-duplication par `arxiv_id` + `version`.
- **`mfg_sync_queue`** : File d'attente asynchrone SAGA pour les traitements Docling/extract longs.

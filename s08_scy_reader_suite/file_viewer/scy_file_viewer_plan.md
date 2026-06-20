# 🛠️ SCY-FILE-VIEWER — PLAN (PLAN)
**ID** : S08_READER_FILE_VIEWER_PLAN

## Flux / Layout 3 panneaux
```
┌──────────────┬────────────────────────────────┬──────────────────────────┐
│ NAVIGATION   │ LECTEUR PRINCIPAL              │ ENRICHISSEMENT IA        │
│ TOC/Signets/ │ (rendu fidèle format natif)    │ Résumé chapitre ($0)     │
│ Notes/Rech.  │ [contenu] [◀ Préc] X/N [Suiv▶] │ Concepts GLiNER (SMI)    │
│              │                                │ Mini COSMOS inline       │
│              │                                │ Cartes APEX liées        │
└──────────────┴────────────────────────────────┴──────────────────────────┘
[Source ingérée] → détection format → moteur rendu adapté (lazy) → TOC/zoom/recherche
  → sidebar enrichissement (résumé scy_chunks, GLiNER $0, mini COSMOS, APEX liées)
  → sélection texte → [Créer carte][Note][Définir] → scy_reader_annotations
  → progression → scy_reader_sessions
```
## Dépendances : `@react-pdf-viewer/core`, `epubjs`, `react-markdown`+`rehype-highlight`, `mammoth.js`, DOMPurify, KaTeX, cosmos.gl, GLiNER, react-data-grid, reveal.js. Tables : `scy_reader_sessions`, `scy_reader_annotations`.
## Fichiers : `frontend_react/src/reader/FileViewer.tsx`, `renderers/*.tsx`, `enrichment_sidebar.tsx`.

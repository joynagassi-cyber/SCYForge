# 🛠️ SCY-PAGE-GALLERY — PLAN (PLAN)
**ID** : S08_READER_PAGE_GALLERY_PLAN · **Décision** : RS-005

## Flux
```
[Document généré (N pages)]
   │
   ▼
[PDF.js renderPage() → canvas → WebP 80% CÔTÉ CLIENT ($0 serveur)]
   │
   ▼
[Virtual scroll @tanstack/react-virtual : lazy pages visibles + 2 suivantes]
[Cache localStorage 24h]
   │
   ▼
[4 modes affichage : Large(3) / Normal(4-5) / Compact(6-8) / Strip(tactile)]
   │
   ▼
[Hover → tooltip section | clic → Web Viewer page | boutons Reader Suite/PDF/Book Orchestrator]
```
## Dépendances : `pdfjs-dist` (PDF.js), `@tanstack/react-virtual`, localStorage. Table : `scy_page_gallery_cache`.
## Fichiers : `frontend_react/src/reader/PageGallery.tsx`, `thumbnail_generator.ts`.

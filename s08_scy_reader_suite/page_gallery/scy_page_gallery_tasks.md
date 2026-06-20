# 📋 SCY-PAGE-GALLERY — TÂCHES (TASKS)
**ID** : S08_READER_PAGE_GALLERY_TASKS · **Décision** : RS-005

### Tâche PG.1 : Coder la génération miniatures côté client (25 min)
* **Fichier** : `frontend_react/src/reader/thumbnail_generator.ts`
* **Description** : PDF.js `renderPage()` → canvas → WebP 80% côté client ($0 serveur).
* **Critère** : Miniatures générées sans coût serveur.

### Tâche PG.2 : Coder le virtual scroll + cache 24h (20 min)
* **Fichier** : `frontend_react/src/reader/PageGallery.tsx`
* **Description** : `@tanstack/react-virtual` (lazy pages visibles + 2 suivantes) + cache localStorage 24h.
* **Critère** : Lazy loading fluide ; cache actif.

### Tâche PG.3 : Coder les 4 modes + interactions (20 min)
* **Fichier** : `frontend_react/src/reader/PageGallery.tsx`
* **Description** : Large/Normal/Compact/Strip + hover tooltip + clic→Web Viewer page + boutons Reader Suite/PDF/Book Orchestrator.
* **Critère** : 4 modes disponibles ; interactions fonctionnelles.

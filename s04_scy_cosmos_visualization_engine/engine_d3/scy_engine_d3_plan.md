# 🛠️ SCY-ENGINE-D3 — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_D3_PLAN  
**Décision** : D-RENDER-008  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données

```
 [Données Graphology : axes parallèles / ordre linéaire / hiérarchie+dépendances / coordonnées cartésiennes]
                 │
                 ▼
   [Lazy-import dynamique : await import('d3...')]
                 │
                 ▼
   [Validation Zod + Web Worker pour calculs géométriques (≤5000 concepts M15)]
                 │
        ┌────────┼──────────────┬───────────────┬──────────────┐
        ▼        ▼              ▼               ▼              ▼
  [d3 Parallel  [d3 Arc        [d3 Edge        [d3-delaunay   [d3 Voronoi
   Coords M15]   Diagram M20]   Bundling M21]   (Voronoi M24)]
   (brushing)]   (arcs clampés) (slider tension, (cellules clampées)
                                 LOD > 2000)
        └────────┴──────────────┴───────────────┴──────────────┘
                       │
                       ▼
        [Rendu SVG bas niveau + cohérence palette design.md]
```

---

## 2. Dépendances Techniques Strictes
* **d3 v7** : `d3-scale`, `d3-shape`, `d3-brush`, `d3-delaunay`, `d3-hierarchy` (v7.x).
* **React 18** + **Web Worker** (calculs géométriques lourds).
* **Lazy-loading** : chunks indépendants.
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/cosmos/engines/d3_loader.ts`** : Lazy-import d3.
- **`frontend_react/src/cosmos/workers/geo_worker.ts`** : Calculs géométriques déportés.
- **`frontend_react/src/cosmos/modes/`** : composants M15/M20/M21/M24.

# 🧪 SCY-ENGINE-D3 — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_D3_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test D3.1 : Parallel Coordinates (M15)
* **Input** : Graphe sur 4 axes, brushing sur l'axe Difficulté [7-10].
* **Attendu** : Seules les trajectoires dans l'intervalle restent visibles.

### 🧪 Test D3.2 : Arc Diagram (M20)
* **Attendu** : Les arcs ne dépassent pas les limites du canvas (clamp).

### 🧪 Test D3.3 : Edge Bundling (M21)
* **Input** : > 2 000 nœuds périphériques.
* **Attendu** : Regroupement de branches (LOD 1) activé ; tension réglable.

### 🧪 Test D3.4 : Voronoi (M24)
* **Attendu** : Les cellules de bordure sont clampées au viewport.

### 🧪 Test D3.5 : Thread non bloqué
* **Attendu** : Les calculs géométriques lourds s'exécutent en Web Worker.

### 🧪 Test D3.6 : Lazy-Loading & Palette
* **Attendu** : d3 absent du bundle initial ; aucune couleur hors tokens `design.md`.

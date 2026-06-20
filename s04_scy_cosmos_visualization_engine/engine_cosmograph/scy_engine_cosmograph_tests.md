# 🧪 SCY-ENGINE-COSMOGRAPH — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_COSMOGRAPH_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test CG.1 : Rendu Massif (Happy Path)
* **Input** : 100 000 nœuds.
* **Attendu** : Rendu via Cosmograph (GPU) à ≥ 30 FPS.

### 🧪 Test CG.2 : Basulement Automatique
* **Input** : Graphe > seuil engine_g6.
* **Attendu** : engine_cosmograph sélectionné ; cohérence visuelle conservée.

### 🧪 Test CG.3 : Révélation des Clusters
* **Attendu** : Le zoom révèle les clusters locaux ; communautés visibles à l'échelle globale.

### 🧪 Test CG.4 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

### 🧪 Test CG.5 : Performance GPU
* **Attendu** : La parallélisation GPU maintient l'interactivité malgré l'échelle.

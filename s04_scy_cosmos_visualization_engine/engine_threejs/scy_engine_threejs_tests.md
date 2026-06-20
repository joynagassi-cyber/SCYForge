# 🧪 SCY-ENGINE-THREEJS — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_THREEJS_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test TJ.1 : Rendu Volumétrique (M23)
* **Input** : Coordonnées 3D valides + GPU check OK.
* **Attendu** : Sphères + cylindres + axes rendus à 60 FPS, palette `design.md`.

### 🧪 Test TJ.2 : Fly-To + Knowledge Card
* **Input** : Clic sur une sphère.
* **Attendu** : Animation fly-to + déploiement de la Knowledge Card 3D.

### 🧪 Test TJ.3 : GPU Check Négatif
* **Input** : Appareil sans WebGL2/GPU dédié.
* **Attendu** : M23 masqué ; fallback Mode 2 (Knowledge Graph 2D).

### 🧪 Test TJ.4 : Lazy-Loading
* **Attendu** : three.js (~450KB) absent du bundle initial.

### 🧪 Test TJ.5 : Axes Sémantiques
* **Attendu** : Les 3 axes orthogonaux (Concret↔Abstrait, Théorique↔Pratique, Fondamental↔Avancé) sont visibles.

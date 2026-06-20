# 🧪 SCY-ENGINE-TANSTACK-TABLE — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_TANSTACK_TABLE_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test TT.1 : Virtual Scroll
* **Input** : 10 000 concepts.
* **Attendu** : Affichage à 60 FPS sans charge GPU.

### 🧪 Test TT.2 : Tri Stabilité FSRS
* **Input** : Tri par Stabilité FSRS croissante.
* **Attendu** : Les concepts les plus proches de l'oubli apparaissent en haut.

### 🧪 Test TT.3 : Clic → Knowledge Card
* **Input** : Clic sur une ligne.
* **Attendu** : Un Drawer s'ouvre avec la Knowledge Card complète du concept.

### 🧪 Test TT.4 : Badge SMI
* **Attendu** : Les cellules SMI affichent un badge couleur (Rouge→Vert).

### 🧪 Test TT.5 : Compatibilité
* **Attendu** : Fonctionne sur liseuses e-ink et connexions bas débit (DOM pur).

### 🧪 Test TT.6 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

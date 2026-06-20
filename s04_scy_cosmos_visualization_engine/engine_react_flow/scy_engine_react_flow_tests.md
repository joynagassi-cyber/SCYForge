# 🧪 SCY-ENGINE-REACT-FLOW — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_REACT_FLOW_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test RF.1 : Rendu du DAG (Happy Path)
* **Input** : DAG ASCENT valide.
* **Attendu** : Affichage layout dirigé dagre avec statuts corrects.

### 🧪 Test RF.2 : Mise à Jour Temps Réel
* **Input** : Événement `NodeCompleted`.
* **Attendu** : Le statut du nœud passe à complété ; les dépendants se débloquent.

### 🧪 Test RF.3 : Interactivité
* **Attendu** : Zoom/pan/mini-map/sélection fonctionnels ; détail affiché.

### 🧪 Test RF.4 : Goulots & Chemins Critiques
* **Attendu** : Les goulots cognitifs et chemins critiques sont mis en évidence.

### 🧪 Test RF.5 : Cohérence des Prérequis
* **Attendu** : Un nœud dont les prérequis ne sont pas validés reste verrouillé.

### 🧪 Test RF.6 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

# 🧪 SCY-AG12-VISUAL-CRITIC — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG12_VISUAL_CRITIC_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test 12.1 : Détection de Surcharge
* **Input** : Graphe dense (nœuds/arêtes > seuil).
* **Attendu** : Surcharge signalée + recommandation (regroupement/filtrage/fisheye).

### 🧪 Test 12.2 : Conformité des Couleurs
* **Input** : Rendu avec couleur hors tokens `design.md`.
* **Attendu** : Couleur rejetée.

### 🧪 Test 12.3 : Contraste WCAG
* **Input** : Contraste insuffisant.
* **Attendu** : Signalé comme non accessible.

### 🧪 Test 12.4 : Justesse Sémantique
* **Input** : Arête ne reflétant pas la vraie relation.
* **Attendu** : Détection via AGENT-13.

### 🧪 Test 12.5 : Recommandations COSMOS
* **Attendu** : Des ajustements concrets sont émis au moteur de rendu COSMOS.

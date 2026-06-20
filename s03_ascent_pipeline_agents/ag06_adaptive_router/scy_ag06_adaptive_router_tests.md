# 🧪 SCY-AG06-ADAPTIVE-ROUTER — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG06_ADAPTIVE_ROUTER_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test 6.1 : Ajustement de Difficulté
* **Input** : SMI élevé vs SMI faible.
* **Attendu** : Difficulté augmentée / simplifiée en conséquence ; pacing ajusté.

### 🧪 Test 6.2 : Renforcement de Goulot
* **Pré-conditions** : Nœud signalé comme goulot (AGENT-03).
* **Attendu** : Renforcement prioritaire (exos/IMPRINT) ; régénération si SMI stagne.

### 🧪 Test 6.3 : Routage de Modèle
* **Input** : Tâche simple vs tâche complexe.
* **Attendu** : Modèle léger / avancé sélectionné via LlmRouter.

### 🧪 Test 6.4 : Respect du Budget
* **Attendu** : Aucune décision de routage ne dépasse le BudgetGuard.

### 🧪 Test 6.5 : Justification Chiffrée
* **Attendu** : Chaque régénération/ajustement est justifié par un signal mesuré (SMI, drift, goulot).

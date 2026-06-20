# 🧪 SCY-AG02-CONTENT-SCOUT — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG02_CONTENT_SCOUT_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test 2.1 : Découverte Multi-Core (Happy Path)
* **Input** : Nœud « Hooks React ».
* **Exécution** : `contentScoutStep(node)`.
* **Attendu** : Au moins une source pertinente est sélectionnée parmi les cores réels.

### 🧪 Test 2.2 : Réutilisation du Cache ($0)
* **Pré-conditions** : Source déjà dans `mfg_shared_content_cache`.
* **Input** : Nœud correspondant.
* **Attendu** : Cache hit, aucune ré-ingestion, coût $0.

### 🧪 Test 2.3 : Classement par Score
* **Input** : Plusieurs candidats.
* **Attendu** : Liste ordonnée par pertinence/qualité/coût, validée par `SourceListSchema`.

### 🧪 Test 2.4 : Résilience (Échec d'Ingestion)
* **Pré-conditions** : Une source défaillante.
* **Attendu** : Rétrogradation + repli sur la suivante ; au moins une source valide retenue.

### 🧪 Test 2.5 : Respect du Budget
* **Attendu** : La découverte ne dépasse pas le BudgetGuard ; coût journalisé Langfuse.

### 🧪 Test 2.6 : Aucune Source Inventée
* **Attendu** : Aucune URL/source non retournée par un core réel n'apparaît dans la sélection.

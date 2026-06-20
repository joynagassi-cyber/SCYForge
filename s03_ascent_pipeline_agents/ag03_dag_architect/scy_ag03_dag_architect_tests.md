# 🧪 SCY-AG03-DAG-ARCHITECT — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG03_DAG_ARCHITECT_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test 3.1 : Décomposition en Nœuds (Happy Path)
* **Input** : Objectif « React ».
* **Exécution** : `dagArchitectStep(goal)`.
* **Attendu** : DAG valide (nœuds + arêtes), validé par `DagSchema`.

### 🧪 Test 3.2 : Acyclicité Garantie
* **Pré-conditions** : Graphe construit.
* **Attendu** : Aucun cycle détecté (DFS) ; ordre topologique valide.

### 🧪 Test 3.3 : Ordre Topologique Correct
* **Attendu** : Pour toute arête A→B, A précède B dans l'ordre topologique.

### 🧪 Test 3.4 : Personnalisation par SMI
* **Pré-conditions** : Utilisateur avec nœuds au SMI ≥ seuil.
* **Attendu** : Ces nœuds sont marqués `acquired` et exclus du parcours actif.

### 🧪 Test 3.5 : Détection de Goulot Cognitif
* **Attendu** : Un nœud à forte dépendance entrante est signalé pour l'ADAPTIVE-ROUTER.

### 🧪 Test 3.6 : Rejet d'un Cycle
* **Pré-conditions** : Dépendances formant un cycle (cas extrême).
* **Attendu** : Le système rejette avec une erreur typée (pas de propagation d'un graphe invalide).

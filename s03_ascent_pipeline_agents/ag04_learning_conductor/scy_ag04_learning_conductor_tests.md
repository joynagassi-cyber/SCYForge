# 🧪 SCY-AG04-LEARNING-CONDUCTOR — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG04_LEARNING_CONDUCTOR_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test 4.1 : Génération de Contenu (NEURON-CHAINS)
* **Input** : Nœud + sources.
* **Exécution** : `learningConductorStep(node)`.
* **Attendu** : Documents pédagogiques générés, tracés vers les sources.

### 🧪 Test 4.2 : Session Active (Exercices + Flashcards)
* **Attendu** : Exercices et flashcards FSRS proposés ; `ExerciseCompleted` émis à la validation.

### 🧪 Test 4.3 : Planification de Rétention
* **Attendu** : `SessionEnded` émis avec durée et cartes ; révisions FSRS planifiées ; IMPRINT déclenché.

### 🧪 Test 4.4 : Validation & Déblocage
* **Pré-conditions** : Nœud au SMI cible (signal AGENT-05).
* **Attendu** : `NodeCompleted` émis ; nœuds dépendants débloqués.

### 🧪 Test 4.5 : Respect des Prérequis
* **Pré-conditions** : Nœud dont un prérequis n'est pas validé.
* **Attendu** : Le nœud n'est pas débloqué (`NodeUnlocked` non émis).

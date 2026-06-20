# 📋 SCY-AG04-LEARNING-CONDUCTOR — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG04_LEARNING_CONDUCTOR_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche 4.1 : Coder le Déclenchement NEURON-CHAINS (Durée : 20 min)
* **Description** : Coder l'appel à NEURON-CHAINS pour générer les documents pédagogiques d'un nœud à partir des sources ingérées.
* **Fichier** : `backend_ts/src/ascent/agents/ag04_learning_conductor.ts`
* **Critère de Succès** : Un nœud avec sources produit des documents pédagogiques tracés.

### 🚀 Tâche 4.2 : Coder la Présentation COSMOS + Exercices FSRS (Durée : 25 min)
* **Description** : Coder la présentation du parcours (mode roadmap COSMOS) et la proposition d'exercices/flashcards APEX/FSRS, avec émission de `ExerciseCompleted`.
* **Fichier** : `backend_ts/src/ascent/agents/ag04_learning_conductor.ts`
* **Critère de Succès** : Une session propose exercices et flashcards ; les validations émettent `ExerciseCompleted`.

### 🚀 Tâche 4.3 : Coder la Planification Rétention + IMPRINT (Durée : 20 min)
* **Description** : Coder l'émission de `SessionEnded`, la planification des révisions FSRS et le déclenchement d'une session IMPRINT pour les concepts clés.
* **Fichier** : `backend_ts/src/ascent/agents/ag04_learning_conductor.ts`
* **Critère de Succès** : `SessionEnded` émis ; révisions FSRS planifiées ; IMPRINT déclenché.

### 🚀 Tâche 4.4 : Coder la Validation de Nœud + Déblocage (Durée : 20 min)
* **Description** : Coder l'émission de `NodeCompleted` (sur signal SMI AGENT-05) et le déblocage des nœuds dépendants (`NodeUnlocked`) selon l'ordre topologique.
* **Fichier** : `backend_ts/src/ascent/agents/ag04_learning_conductor.ts`
* **Critère de Succès** : Un nœud validé débloque ses dépendants ; un nœud sans prérequis validé n'est pas débloqué.

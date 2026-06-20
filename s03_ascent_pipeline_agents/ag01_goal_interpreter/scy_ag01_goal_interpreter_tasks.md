# 📋 SCY-AG01-GOAL-INTERPRETER — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG01_GOAL_INTERPRETER_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

Chaque tâche est conçue pour être codée en 15 à 30 minutes de manière unitaire et testable.

---

## 🧭 Liste des Tâches de Production

### 🚀 Tâche 1.1 : Coder le Schéma Zod de l'Objectif (Durée : 20 min)
* **Description** : Définir `GoalSchema` (domaine, sous-compétences[], niveau_cible, contraintes {durée, fréquence}, critères[] mesurables) avec validation stricte.
* **Fichier de destination** : `backend_ts/src/ascent/schemas/goal_schema.ts`
* **Critère de Succès** : Un objet valide passe ; un objet incomplet est rejeté avec une erreur Zod typée.

### 🚀 Tâche 1.2 : Coder le Prompt Système (Cacheable) (Durée : 20 min)
* **Description** : Rédiger le prompt système d'interprétation d'objectif (décomposition, critères mesurables) destiné au caching.
* **Fichier de destination** : `backend_ts/src/ascent/prompts/goal_interpreter_prompt.ts`
* **Critère de Succès** : Le prompt produit une sortie conforme au `GoalSchema` sur un cas test (« React en 8 semaines »).

### 🚀 Tâche 1.3 : Intégrer COSMOS + Starter Evaluator (Durée : 25 min)
* **Description** : Coder la récupération du SMI existant et des prérequis depuis COSMOS, et la délégation au Starter Evaluator pour les nouveaux utilisateurs.
* **Fichier de destination** : `backend_ts/src/ascent/agents/ag01_goal_interpreter.ts`
* **Critère de Succès** : Un utilisateur existant récupère son SMI ; un nouvel utilisateur déclenche le Starter Evaluator.

### 🚀 Tâche 1.4 : Coder l'Appel LLM + Validation Zod + Retry (Durée : 25 min)
* **Description** : Coder l'appel LLM via LlmRouter (BudgetGuard, prompt caching), la validation de la sortie par `GoalSchema`, et le retry en cas d'échec de validation.
* **Fichier de destination** : `backend_ts/src/ascent/agents/ag01_goal_interpreter.ts`
* **Critère de Succès** : La sortie est validée ; un échec de validation déclenche un retry (max N) puis une erreur typée.

### 🚀 Tâche 1.5 : Coder la Persistance + Émission EventBus (Durée : 20 min)
* **Description** : Coder l'écriture dans `mfg_goals` (état `active`) via le pattern Outbox et l'émission de `GoalInterpreted` sur l'EventBus.
* **Fichier de destination** : `backend_ts/src/ascent/agents/ag01_goal_interpreter.ts`
* **Critère de Succès** : L'objectif est persisté atomiquement (Outbox) et l'événement est publié pour le hand-off vers AGENT-03.

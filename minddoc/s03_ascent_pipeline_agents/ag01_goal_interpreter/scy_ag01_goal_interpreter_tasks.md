<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-AG01-GOAL-INTERPRETER — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG01_GOAL_INTERPRETER_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

Chaque tâche est conçue pour être codée en 15 à 30 minutes de manière unitaire et testable.

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

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

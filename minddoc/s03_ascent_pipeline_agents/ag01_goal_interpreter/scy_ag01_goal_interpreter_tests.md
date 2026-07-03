<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG01-GOAL-INTERPRETER — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG01_GOAL_INTERPRETER_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

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

## 1. Scénarios de Validation Unitaires

### 🧪 Test 1.1 : Formalisation d'un Objectif (Happy Path)
* **Pré-conditions** : LlmRouter et BudgetGuard opérationnels.
* **Input** : « Je veux maîtriser React en 8 semaines ».
* **Règle d'Exécution** : Appeler `goalInterpreterStep(input)`.
* **Post-conditions (Attendu)** :
  - L'objet retourné a `domain = "React"`, une contrainte de 8 semaines, et `sub_skills` non vide.
  - La sortie est validée par `GoalSchema`.

### 🧪 Test 1.2 : Utilisateur Existant (SMI Préexistant)
* **Pré-conditions** : Utilisateur avec SMI enregistré dans COSMOS.
* **Input** : Objectif dans un domaine partiellement maîtrisé.
* **Règle d'Exécution** : Appeler `goalInterpreterStep(input)`.
* **Post-conditions (Attendu)** :
  - Le SMI de départ est récupéré depuis COSMOS.
  - Les prérequis déjà maîtrisés (SMI ≥ seuil) sont identifiés.

### 🧪 Test 1.3 : Nouvel Utilisateur (Starter Evaluator)
* **Pré-conditions** : Utilisateur sans historique.
* **Input** : Premier objectif.
* **Règle d'Exécution** : Appeler `goalInterpreterStep(input)`.
* **Post-conditions (Attendu)** :
  - Le Starter Evaluator est déclenché pour évaluer le niveau initial.

### 🧪 Test 1.4 : Critères de Réussite Mesurables
* **Pré-conditions** : Objectif formalisé.
* **Input** : Objectif avec niveau cible.
* **Règle d'Exécution** : Vérifier les critères générés.
* **Post-conditions (Attendu)** :
  - Chaque critère est mesurable et lié au SMI ou à la certification.

### 🧪 Test 1.5 : Validation Zod + Retry
* **Pré-conditions** : LLM pouvant produire une sortie invalide.
* **Input** : Cas provoquant une sortie non conforme.
* **Règle d'Exécution** : Appeler `goalInterpreterStep`.
* **Post-conditions (Attendu)** :
  - Le retry est déclenché (max N).
  - En cas d'échec persistant, une erreur typée est renvoyée (pas de propagation d'objet invalide).

### 🧪 Test 1.6 : Budget & Observabilité
* **Pré-conditions** : BudgetGuard et Langfuse actifs.
* **Input** : Un objectif.
* **Règle d'Exécution** : Appeler `goalInterpreterStep`.
* **Post-conditions (Attendu)** :
  - Le coût (tokens, $) est journalisé dans Langfuse.
  - Le BudgetGuard est consulté avant l'appel LLM.

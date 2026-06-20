# 🎯 SCY-AG01-GOAL-INTERPRETER — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG01_GOAL_INTERPRETER_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement de l'**AGENT-01 : GOAL-INTERPRETER**, premier agent de la pipeline ASCENT. Sa mission est de **transformer un objectif d'apprentissage déclaré en langage naturel** (ex : « Je veux maîtriser React en 8 semaines ») en un **objet d'objectif formalisé** : domaine, sous-compétences, niveau de départ (SMI existant), prérequis identifiés, critères de réussite mesurables et contraintes (durée, fréquence). Il est l'entrée unique de la pipeline.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step) + Vercel AI SDK (appel LLM).
* **Modèle LLM** : routage via le LlmRouter (DeepSeek / Claude, selon BudgetGuard) — `liter-llm`.
* **Validation** : modèles **Zod** stricts pour la sortie formalisée (objectif structuré).
* **Dépendances internes** :
  - **COSMOS Knowledge Graph** : consultation du SMI existant et des prérequis déjà maîtrisés par l'utilisateur.
  - **BRAIN/RAG** : recherche des connaissances existantes de l'utilisateur sur le domaine cible.
  - **Starter Evaluator** (onboarding) : niveau initial si nouvel utilisateur.
* **Persistence** : tables `mfg_goals`, profil utilisateur (PostgreSQL Northflank).

> **Rappel anti-hallucination** : tout composant listé ci-dessus est issu de la stack officielle SCY Forge. La sortie de l'agent est strictement validée par Zod avant propagation.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Interprétation de l'Objectif Naturel

#### Scénario : Formalisation d'un objectif déclaratif
- **GIVEN** Un utilisateur déclarant un objectif en langage naturel (ex : « Je veux maîtriser React en 8 semaines »).
- **WHEN** L'objectif est soumis au GOAL-INTERPRETER.
- **THEN** le système SHALL appeler le LLM (via LlmRouter) pour décomposer l'objectif en : domaine principal, sous-compétences, niveau cible, et contraintes temporelles.
- **AND** le système SHALL valider la sortie via un schéma **Zod** strict (rejet + retry si invalide).
- **AND** le système SHALL émettre l'événement `GoalInterpreted { user_id, goal_id, domain, sub_skills[] }` sur l'EventBus.

---

### Requirement : Évaluation du Niveau de Départ

#### Scénario : Intégration du SMI existant
- **GIVEN** Un objectif formalisé.
- **WHEN** Le système évalue le point de départ de l'utilisateur.
- **THEN** le système SHALL interroger le **COSMOS Knowledge Graph** pour récupérer le SMI actuel de l'utilisateur sur le domaine et ses prérequis.
- **AND** le système SHALL, pour un nouvel utilisateur, déléguer au **Starter Evaluator** (onboarding) l'évaluation du niveau initial.
- **AND** le système SHALL identifier les prérequis déjà maîtrisés (SMI ≥ seuil) pour éviter de les re-planifier.

---

### Requirement : Définition des Critères de Réussite Mesurables

#### Scénario : Génération de critères SMI-vérifiables
- **GIVEN** Un objectif formalisé avec niveau cible.
- **WHEN** Le système définit les critères de réussite.
- **THEN** le système SHALL produire des critères mesurables liés au SMI (ex : « SMI ≥ 70 sur le nœud X », « Proof of Skill validé »).
- **AND** le système SHALL inclure une définition de **compétence atteinte** (seuil global SMI + certification AGENT-09).
- **AND** le système SHALL persister l'objectif dans la table `mfg_goals` avec son état `active`.

---

### Requirement : Respect du Budget LLM

#### Scénario : Routage économique
- **GIVEN** Un appel LLM pour l'interprétation de l'objectif.
- **WHEN** Le système route le modèle.
- **THEN** le système SHALL consulter le BudgetGuard.
- **AND** le système SHALL utiliser un prompt mis en cache (prompt caching) pour les instructions système communes.
- **AND** le système SHALL journaliser le coût (tokens, $) via Langfuse.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Propager un objectif non validé par Zod (sortie doit toujours être structurée).
* 🚫 **SHALL NOT** : Décider du DAG d'apprentissage (rôle de l'AGENT-03 DAG-ARCHITECT) — GOAL-INTERPRETER ne produit que l'objectif formalisé.
* 🚫 **SHALL NOT** : Inventer des prérequis non présents dans COSMOS ou le référentiel de compétences.
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens définis dans `design.md`.
* ⚠️ **MUST** : Tout retour JSON s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (Formalisation)** : « Je veux maîtriser React en 8 semaines » produit un objet structuré (domaine=React, contrainte=8 semaines, sous-compétences non vide).
* **Test Case 2 (SMI Départ)** : Un utilisateur existant avec SMI préexistant voit ses prérequis maîtrisés identifiés.
* **Test Case 3 (Nouvel utilisateur)** : Un nouvel utilisateur déclenche le Starter Evaluator.
* **Test Case 4 (Critères)** : Les critères de réussite sont mesurables et liés au SMI.
* **Test Case 5 (Budget)** : Le coût de l'appel est journalisé dans Langfuse et respecte le BudgetGuard.

# 🛠️ SCY-AG01-GOAL-INTERPRETER — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG01_GOAL_INTERPRETER_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données de l'Agent

```
 [Objectif utilisateur (langage naturel)]
   ex: "Je veux maîtriser React en 8 semaines"
                 │
                 ▼
   [Step Mastra : goalInterpreterStep]
                 │
        ┌────────┴─────────┐
        ▼                  ▼
  [COSMOS KG :          [Starter Evaluator
   SMI existant +        (si nouvel utilisateur)
   prérequis]            → niveau initial]
        │                  │
        └────────┬─────────┘
                 ▼
   [Appel LLM (LlmRouter + BudgetGuard + prompt caching)]
   → décomposition : domaine, sous-compétences, niveau cible, contraintes
                 │
                 ▼
   [Validation Zod stricte (GoalSchema)]
   → échec : retry (max N) / sinon erreur typée
                 │
                 ▼
   [Définition critères de réussite (SMI + certification)]
                 │
                 ▼
   [Persistance table mfg_goals (état: active)]
                 │
                 ▼
   [Émission EventBus : GoalInterpreted { user_id, goal_id, domain, sub_skills[] }]
                 │
                 ▼
   [Hand-off → AGENT-03 DAG-ARCHITECT (construction du graphe)]
```

---

## 2. Dépendances Techniques Strictes
* **Workflow Mastra** : `goalInterpreterStep` (Step asynchrone, idempotent via IdempotencyGuard).
* **LlmRouter** : routage DeepSeek/Claude selon BudgetGuard, `liter-llm`.
* **Prompt caching** : instructions système communes mises en cache.
* **Zod** : `GoalSchema` (domaine, sous-compétences[], niveau_cible, contraintes, critères[]).
* **COSMOS / BRAIN-RAG** : lecture seule du SMI et des prérequis.
* **Langfuse** : observabilité (tokens, latence, $).

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag01_goal_interpreter.ts`** : Step Mastra (logique d'interprétation).
- **`backend_ts/src/ascent/schemas/goal_schema.ts`** : Schéma Zod de l'objectif formalisé.
- **`backend_ts/src/ascent/prompts/goal_interpreter_prompt.ts`** : Prompt système (mis en cache).
- **`mfg_goals`** : Table de persistance des objectifs (id, user_id, domain, sub_skills JSONB, level_target, constraints, criteria, status).
- **EventBus** : événement `GoalInterpreted`.

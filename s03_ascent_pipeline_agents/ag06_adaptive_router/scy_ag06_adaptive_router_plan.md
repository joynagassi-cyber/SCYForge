# 🛠️ SCY-AG06-ADAPTIVE-ROUTER — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG06_ADAPTIVE_ROUTER_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données de l'Agent

```
 [Signaux : SMI (AG05) + goulots (AG03) + drift (AG07)]
                 │
                 ▼
   [Step Mastra : adaptiveRouterStep]
                 │
        ┌────────┴───────────────┐
        ▼                        ▼
  [Ajustement difficulté/      [Routage modèle LlmRouter
   pacing selon SMI]            (léger vs avancé) + BudgetGuard]
        │                        │
        ▼                        ▼
  [Goulot ? → renforcement      [Régénération NEURON-CHAINS
   prioritaire (exos/IMPRINT)]   si SMI stagne (difficulté ajustée)]
        │                        │
        └────────┬───────────────┘
                 ▼
   [Validation Zod RoutingDecisionSchema]
                 │
                 ▼
   [Décisions consommées par AGENT-04 LEARNING-CONDUCTOR]
```

---

## 2. Dépendances Techniques Strictes
* **Signaux** : SMI (AGENT-05), goulots (AGENT-03), drift (AGENT-07).
* **LlmRouter + BudgetGuard** : routage économique.
* **NEURON-CHAINS** : régénération à difficulté ajustée.
* **Zod** : `RoutingDecisionSchema`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag06_adaptive_router.ts`** : Step Mastra (décisions de routage).
- **`backend_ts/src/ascent/schemas/routing_decision_schema.ts`** : Schéma Zod des décisions.
- **`backend_ts/src/ascent/router/difficulty_adjuster.ts`** : Logique d'ajustement difficulté/pacing.

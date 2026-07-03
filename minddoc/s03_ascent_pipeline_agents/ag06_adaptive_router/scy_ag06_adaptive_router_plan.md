<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-AG06-ADAPTIVE-ROUTER — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG06_ADAPTIVE_ROUTER_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

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

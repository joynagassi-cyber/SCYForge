<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-AG03-DAG-ARCHITECT — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG03_DAG_ARCHITECT_PLAN  
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
 [Objectif formalisé (AGENT-01)] + [Niveau de départ SMI]
                 │
                 ▼
   [Step Mastra : dagArchitectStep]
                 │
   [LLM : décomposition en nœuds de compétence]
                 │
                 ▼
   [Consultation COSMOS : prérequis canoniques entre concepts]
                 │
                 ▼
   [Construction arêtes de prérequis + ordre topologique]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [Vérification acyclicité    [Détection goulots cognitifs
   (cycle detection)]         (forte dépendance entrante)]
  → cycle = erreur typée       → alerte ADAPTIVE-ROUTER
        │                     │
        └────────┬────────────┘
                 ▼
   [Personnalisation : nœuds SMI ≥ seuil → marqués acquis]
                 │
                 ▼
   [Validation Zod DagSchema + persistance mfg_ascent_nodes/edges]
                 │
                 ▼
   [EventBus : DagBuilt { user_id, goal_id, node_count, edges_count }]
                 │
                 ▼
   [Hand-off → AGENT-02 CONTENT-SCOUT (sélection sources par nœud)]
```

---

## 2. Dépendances Techniques Strictes
* **LLM** : LlmRouter + BudgetGuard (décomposition de compétences).
* **COSMOS Knowledge Graph** : référentiel de prérequis canoniques.
* **Algorithmes graphe** : ordre topologique (Kahn), détection de cycles (DFS), calcul de degré entrant.
* **Zod** : `DagSchema`.
* **Persistence** : `mfg_ascent_nodes`, `mfg_ascent_edges`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag03_dag_architect.ts`** : Step Mastra (construction du DAG).
- **`backend_ts/src/ascent/schemas/dag_schema.ts`** : Schéma Zod du DAG.
- **`backend_ts/src/ascent/graph/topo_sort.ts`** : Ordre topologique + détection de cycles + détection de goulots.
- **`mfg_ascent_nodes`** : Nœuds (id, goal_id, label, smi_target, effort_estimate, acquired).
- **`mfg_ascent_edges`** : Arêtes de prérequis (source_id, target_id).

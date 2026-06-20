# 🛠️ SCY-AG03-DAG-ARCHITECT — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG03_DAG_ARCHITECT_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

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

# 🛠️ SCY-ENGINE-REACT-FLOW — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_REACT_FLOW_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données

```
 [DAG ASCENT (AGENT-03)] + [EventBus : DagBuilt / NodeCompleted / NodeUnlocked]
                 │
                 ▼
   [Validation Zod du DAG]
                 │
                 ▼
   [Composant React : AscentRoadmap.tsx (React Flow)]
                 │
   [Layout dirigé dagre (ordre topologique)]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [Statuts nœuds :          [Styles par statut
   acquis/débloqué/          + chemins critiques
   verrouillé/complété]      + goulots mis en évidence]
        │                     │
        └────────┬────────────┘
                 ▼
   [Interactivité : zoom / pan / mini-map / sélection → détail]
```

---

## 2. Dépendances Techniques Strictes
* **React Flow** : `@xyflow/react` (CustomNode, edges, MiniMap, Controls).
* **dagre** : layout dirigé (ordre topologique).
* **React 18** : composant `AscentRoadmap.tsx`.
* **EventBus** : `DagBuilt`, `NodeCompleted`, `NodeUnlocked`.
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/components/AscentRoadmap.tsx`** : Composant React Flow principal.
- **`frontend_react/src/cosmos/reactflow_nodes.tsx`** : Nœuds personnalisés (par statut).
- **`frontend_react/src/cosmos/dagre_layout.ts`** : Layout dirigé dagre.
- **`frontend_react/src/cosmos/schemas/dag_schema.ts`** : Validation Zod du DAG (partagé avec AGENT-03).

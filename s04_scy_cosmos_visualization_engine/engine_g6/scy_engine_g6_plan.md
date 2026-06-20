# 🛠️ SCY-ENGINE-G6 — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_G6_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données

```
 [Graphe COSMOS (nœuds + arêtes + poids)]
 [EventBus : KnowledgeGraphUpdated]
                 │
                 ▼
   [Validation Zod des données graphe]
                 │
                 ▼
   [Composant React : CosmosGraph2D.tsx]
                 │
   [AntV G6 v5 : Graph + layout force-directed (enveloppe axiale polaire)]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [Optimisations :          [Rendu WebGL
   LOD + Barnes-Hut +         (coupe axiale 2D)
   Object Pooling]            palette design.md]
        │                     │
        └────────┬────────────┘
                 ▼
   [Interactivité : zoom / pan / sélection nœud → détail]
```

---

## 2. Dépendances Techniques Strictes
* **AntV G6 v5** : `@antv/g6` (Graph API v5, layouts, renderer WebGL).
* **React 18** : composant `CosmosGraph2D.tsx`.
* **Optimisations** : LOD, Barnes-Hut, Object Pooling (G6 plugins/configs).
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/components/CosmosGraph2D.tsx`** : Composant React principal G6 v5.
- **`frontend_react/src/cosmos/g6_layout.ts`** : Configuration layout force-directed + enveloppe axiale.
- **`frontend_react/src/cosmos/g6_perf.ts`** : LOD + Barnes-Hut + Object Pooling.
- **`frontend_react/src/cosmos/schemas/graph_schema.ts`** : Validation Zod du graphe.

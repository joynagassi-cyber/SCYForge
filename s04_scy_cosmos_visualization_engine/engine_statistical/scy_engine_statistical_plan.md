# 🛠️ SCY-ENGINE-STATISTICAL — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_STATISTICAL_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données

```
 [Vues matérialisées PostgreSQL]
 mv_concept_correlations / mv_learning_trajectories / mv_user_smi_summary
                 │
                 ▼
   [Validation Zod des données analytiques]
                 │
        ┌────────┼──────────────┬───────────────┐
        ▼        ▼              ▼               ▼
  [Heatmap    [Sankey         [Distribution   [Rafraîchissement
   corrélations trajectoires]  SMI (histo/    (refresh des vues
   (G2)]        (G2)]          boxplot)]       matérialisées)]
        │        │              │               │
        └────────┴──────────────┴───────────────┘
                       │
                       ▼
        [Cohérence palette design.md]
```

---

## 2. Dépendances Techniques Strictes
* **AntV G2 v5** : heatmaps, Sankey/alluvial, distributions.
* **Vues matérialisées** : `mv_concept_correlations`, `mv_learning_trajectories`, `mv_user_smi_summary`.
* **React 18** : composants dédiés.
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/components/StatHeatmap.tsx`** : Heatmap corrélations.
- **`frontend_react/src/components/StatSankey.tsx`** : Sankey trajectoires.
- **`frontend_react/src/components/StatDistribution.tsx`** : Distribution SMI.
- **`frontend_react/src/cosmos/stat_queries.ts`** : Requêtes sur vues matérialisées.

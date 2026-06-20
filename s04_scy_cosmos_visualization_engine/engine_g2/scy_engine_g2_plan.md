# 🛠️ SCY-ENGINE-G2 — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_G2_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données

```
 [Données indicateurs (SMI AG05, XP/streak AG08)]
 [EventBus : CardReviewed / NodeCompleted]
                 │
                 ▼
   [Validation Zod des métriques]
                 │
                 ▼
   [Composants React : MetricChart.tsx (AntV G2 v5)]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [Graphiques génériques :   [Rafraîchissement temps réel
   barres / lignes /          (sans rechargement complet)
   aires / jauges]            + animations fluides]
```

---

## 2. Dépendances Techniques Strictes
* **AntV G2 v5** : `@antv/g2`.
* **React 18** : composant `MetricChart.tsx`.
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/components/MetricChart.tsx`** : Composant React G2 générique.
- **`frontend_react/src/cosmos/g2_charts.ts`** : Configurations de graphiques (barres/lignes/jauges).
- **`frontend_react/src/cosmos/schemas/metric_schema.ts`** : Validation Zod des métriques.

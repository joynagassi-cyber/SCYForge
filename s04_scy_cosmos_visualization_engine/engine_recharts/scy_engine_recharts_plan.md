# 🛠️ SCY-ENGINE-RECHARTS — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_RECHARTS_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données

```
 [Agrégations DuckDB-WASM (M7)] / [5 dimensions SMI AGENT-05 (M14)]
                 │
                 ▼
   [Validation Zod des données analytiques]
                 │
        ┌────────┴────────┐
        ▼                 ▼
  [recharts M7          [recharts M14
   Statistics :         Radar : polygone bleu
   barres/courbes/      (user) + polygone cible
   nuages]              (pointillés)]
  [clic point →         [clic sommet →
   filtre concepts]     concepts responsables]
  [circuit breaker      [valeurs bornées [0,100]]
   > 5s → fallback]
        └────────┬────────┘
                 ▼
   [Cohérence palette design.md]
```

---

## 2. Dépendances Techniques Strictes
* **recharts** : `recharts` v2.x.
* **React 18** : composants M7/M14.
* **DuckDB-WASM** : agrégations analytiques (M7).
* **AGENT-05 SMI** : 5 dimensions (M14).
* **Circuit breaker** : D-RESILIENCE-005.
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/cosmos/engines/recharts_loader.ts`** : Chargement recharts.
- **`frontend_react/src/cosmos/modes/`** : composants M7/M14.
- **`frontend_react/src/cosmos/analytics/duckdb_aggregator.ts`** : Agrégations (M7).

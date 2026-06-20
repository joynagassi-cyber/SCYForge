# 🛠️ SCY-MODE-07 — PLAN (PLAN)
**ID** : S04_COSMOS_MODE_07_PLAN · **Moteur** : recharts v2
## Flux : [agrégations DuckDB-WASM] → validation Zod → Mode07Statistics.tsx (barres/courbes/nuages recharts, indicateurs en-tête) → clic point → filtre concepts. Circuit breaker >5s → fallback statique (D-RESILIENCE-005).
## Dépendances : `recharts` v2, DuckDB-WASM. Fichiers : `frontend_react/src/cosmos/modes/Mode07Statistics.tsx`.

# 🛠️ SCY-AG05-PERFORMANCE-ANALYZER — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG05_PERFORMANCE_ANALYZER_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données de l'Agent

```
 [Événements : CardReviewed / ExerciseCompleted / SessionEnded / ARENA]
                 │
                 ▼
   [Step Mastra : performanceAnalyzerStep]
                 │
   [Recalcul SMI multi-dim (s11 neuro engine)]
   rétention (FSRS) + application + profondeur
                 │
        ┌────────┴───────────┐
        ▼                    ▼
  [Persistance             [Seuil atteint ?]
   mfg_ascent_nodes.smi]        │
        │               ┌───────┴───────┐
        │               ▼               ▼
        │        [NodeCompleted     [non → continuer
        │         smi_achieved]     accumulation]
        ▼
   [Maj vue matérialisée mv_user_smi_summary]
                 │
                 ▼
   [Export Parquet (Polars) pour analytics/recherche]
```

---

## 2. Dépendances Techniques Strictes
* **Moteur neuroscientifique** (`s11`) : formules SMI.
* **Polars + DuckDB** : agrégation et vues matérialisées.
* **Zod** : `SmiUpdateSchema`.
* **Tables** : `mfg_ascent_nodes`, `mv_user_smi_summary`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag05_performance_analyzer.ts`** : Step Mastra (recalcul SMI).
- **`backend_ts/src/ascent/smi/smi_calculator.ts`** : Calcul multi-dimensionnel (s11).
- **`mfg_ascent_nodes`** : Persistance du SMI par nœud.
- **`mv_user_smi_summary`** : Vue matérialisée agrégée.

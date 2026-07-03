<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-AG05-PERFORMANCE-ANALYZER — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG05_PERFORMANCE_ANALYZER_PLAN  
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

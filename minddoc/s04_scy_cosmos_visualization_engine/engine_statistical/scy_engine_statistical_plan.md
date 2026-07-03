<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ENGINE-STATISTICAL — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_STATISTICAL_PLAN  
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

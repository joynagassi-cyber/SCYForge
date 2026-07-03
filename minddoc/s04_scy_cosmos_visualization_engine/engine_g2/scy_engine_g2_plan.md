<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ENGINE-G2 — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_G2_PLAN  
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

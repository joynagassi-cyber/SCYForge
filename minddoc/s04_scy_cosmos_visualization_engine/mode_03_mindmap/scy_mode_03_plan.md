<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-MODE-03 — PLAN (PLAN)
**ID** : S04_COSMOS_MODE_03_PLAN · **Moteur** : G6 v5 Radial Tree (D-RENDER-001)
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

## Flux : [arbre Graphology racine unique] → validation petgraph (cycle? → Mode 2) → layout radial Web Worker → Mode03MindMap.tsx (couleur ∝ branche, Bézier, badges ✓/🔒) → clic collapse/expand 300ms ou feuille→Card → sélection parent → charge flashcards descendants.
## Dépendances : `@antv/g6` v5 Radial Tree, petgraph validation, Web Worker. Fichiers : `frontend_react/src/cosmos/modes/Mode03MindMap.tsx`.

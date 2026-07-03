<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-MODE-15 — PLAN (PLAN)
**ID** : S04_COSMOS_MODE_15_PLAN · **Moteur** : d3 v7 (D-RENDER-008)
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

## Flux : [graphe N axes ≤5000 concepts] → lazy-import d3 → Web Worker calculs trajectoires → Mode15ParallelCoords.tsx (axes verticaux + trajectoires couleur ∝ domaine) → drag-brush → grise hors intervalle (opacity 0.05).
## Dépendances : `d3` v7 lazy, Web Worker. Fichiers : `frontend_react/src/cosmos/modes/Mode15ParallelCoords.tsx`.

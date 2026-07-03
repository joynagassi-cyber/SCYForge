<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-MODE-22 — PLAN (PLAN)
**ID** : S04_COSMOS_MODE_22_PLAN · **Moteur** : Cosmos v3 (D-RENDER-001)
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

## Flux : [graphe volumétrie 3 LOD] → Mode22SemanticZoom.tsx (Cosmos v3 GPU shaders, LOD Macro/Intermédiaire/Micro, halo hors-champ) → double-clic cluster → Mode 2 G6 local. GPU indispo → fallback Mode 10 Sunburst.
## Dépendances : `@cosmograph/cosmos` v3 async. Fichiers : `frontend_react/src/cosmos/modes/Mode22SemanticZoom.tsx`.

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-MODE-10 — PLAN (PLAN)
**ID** : S04_COSMOS_MODE_10_PLAN · **Moteur** : G2 v5 (D-RENDER-006)
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

## Flux : [arborescence multiniveau] → lazy-import G2 → Mode10Sunburst.tsx (anneaux concentriques largeur ∝ volume, couleur ∝ SMI) → clic → drill-down 60 FPS + breadcrumb. LOW/COMPAT → profondeur max 3 + fallback liste. Clic secteur rouge → session APEX famille.
## Dépendances : `@antv/g2` v5 lazy. Fichiers : `frontend_react/src/cosmos/modes/Mode10Sunburst.tsx`.

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-MODE-06 — PLAN (PLAN)
**ID** : S04_COSMOS_MODE_06_PLAN · **Moteur** : React Custom + react-spring
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

## Flux : [événements + timestamps] → sanitization dates (NaN→rejet D-VALIDATION-001) → Mode06Timeline.tsx (cartes verticales sur axe horizontal SVG, couleur ∝ époque, badge alerte oubli) → clic → agrandissement + zoom axe + résumé. FSRS rappels sur dates.
## Dépendances : `react-spring`, SVG. Fichiers : `frontend_react/src/cosmos/modes/Mode06Timeline.tsx`.

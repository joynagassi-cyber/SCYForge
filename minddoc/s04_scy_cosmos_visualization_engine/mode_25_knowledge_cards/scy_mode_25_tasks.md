<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-MODE-25 — TÂCHES (TASKS)
**ID** : S04_COSMOS_MODE_25_TASKS 🔴 CRITIQUE
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

### Tâche M25.1 : Coder les cartes riches custom + pipelines animés (30 min)
* **Fichier** : `frontend_react/src/cosmos/modes/Mode25KnowledgeCards.tsx` · **Critère** : Cartes jauge SMI/FSRS/mini-radar/actions, pipelines SVG particules ∝ similarité, Shimmer loading.
### Tâche M25.2 : Coder MiniMap + focus actions + elkjs (25 min)
* **Critère** : MiniMap GPS ; focus carte → édition/Teach-Back/flashcard/Reader Suite ; layout elkjs Worker.

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-MODE-03 — TÂCHES (TASKS)
**ID** : S04_COSMOS_MODE_03_TASKS
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

### Tâche M3.1 : Coder le layout radial Web Worker + sémiologie (25 min)
* **Fichier** : `frontend_react/src/cosmos/modes/Mode03MindMap.tsx` · **Critère** : Couleur ∝ branche, Bézier depuis racine, badges ✓/🔒, thread non bloqué.
### Tâche M3.2 : Coder le collapse/expand + sélection parent (25 min)
* **Critère** : Clic → collapse/expand 300ms, feuille → Card ; parent → charge flashcards descendants.
### Tâche M3.3 : Coder la validation petgraph cycle (15 min)
* **Critère** : Cycle détecté → basculement Mode 2 (D-VALIDATION-002).

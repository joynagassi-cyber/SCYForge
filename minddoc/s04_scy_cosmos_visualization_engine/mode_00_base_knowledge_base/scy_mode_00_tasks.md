<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-MODE-00 — TÂCHES (TASKS)
**ID** : S04_COSMOS_MODE_00_TASKS

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

### Tâche M0.1 : Coder le composant Cosmos v3 + typed arrays (20 min)
* **Fichier** : `frontend_react/src/cosmos/modes/Mode00BaseKnowledge.tsx`
* **Critère** : 1M nœuds à 60 FPS via `await graph.ready` (D-RENDER-003).

### Tâche M0.2 : Coder le mapping graphologyToCosmos + sémiologie (20 min)
* **Description** : Taille ∝ PageRank, couleur ∝ domaine, arêtes opacity 0.1-0.3.
* **Critère** : Sémiologie conforme au blueprint.

### Tâche M0.3 : Coder le clic drill-down + FSRS opacity (20 min)
* **Description** : Clic → zoom + useProjectGraphStore + Knowledge Card simplifiée ; FSRS R<50% → opacité réduite.
* **Critère** : Drill-down charge le graphe projet.

### Tâche M0.4 : Coder les fallbacks (15 min)
* **Description** : Init>10s → G6 Canvas 2000 nœuds ; WebGL loss → setupWebGLRecovery.
* **Critère** : Fallbacks D-RESILIENCE-001/002 actifs.

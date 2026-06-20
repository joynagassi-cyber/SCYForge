# 📋 SCY-MODE-00 — TÂCHES (TASKS)
**ID** : S04_COSMOS_MODE_00_TASKS

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

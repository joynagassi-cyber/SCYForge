# 🛠️ SCY-MODE-00 — PLAN D'IMPLÉMENTATION (PLAN)
**ID** : S04_COSMOS_MODE_00_PLAN · **Moteur** : Cosmos v3 (D-RENDER-001)

## Flux
```
[Base connaissances] → graphologyToCosmos (Float32Array) → Cosmos v3 GPU @60FPS
   nœuds: taille ∝ PageRank, couleur ∝ domaine | arêtes: opacity 0.1-0.3
   clic nœud → zoom + suspend + useProjectGraphStore → Knowledge Card simplifiée
   FSRS R<50% → opacité réduite | init>10s/perte WebGL → G6 Canvas 2000 nœuds
```
## Dépendances : `@cosmograph/cosmos` v3, `graphologyToCosmos`, useProjectGraphStore (Zustand).
## Fichiers : `frontend_react/src/cosmos/modes/Mode00BaseKnowledge.tsx`, `graphologyToCosmos.ts`.

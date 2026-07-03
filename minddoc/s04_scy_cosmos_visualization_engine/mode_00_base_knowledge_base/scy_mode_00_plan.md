<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-MODE-00 — PLAN D'IMPLÉMENTATION (PLAN)
**ID** : S04_COSMOS_MODE_00_PLAN · **Moteur** : Cosmos v3 (D-RENDER-001)

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

## Flux
```
[Base connaissances] → graphologyToCosmos (Float32Array) → Cosmos v3 GPU @60FPS
   nœuds: taille ∝ PageRank, couleur ∝ domaine | arêtes: opacity 0.1-0.3
   clic nœud → zoom + suspend + useProjectGraphStore → Knowledge Card simplifiée
   FSRS R<50% → opacité réduite | init>10s/perte WebGL → G6 Canvas 2000 nœuds
```
## Dépendances : `@cosmograph/cosmos` v3, `graphologyToCosmos`, useProjectGraphStore (Zustand).
## Fichiers : `frontend_react/src/cosmos/modes/Mode00BaseKnowledge.tsx`, `graphologyToCosmos.ts`.

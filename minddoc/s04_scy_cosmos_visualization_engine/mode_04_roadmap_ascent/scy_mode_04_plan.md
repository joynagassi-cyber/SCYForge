<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-MODE-04 — PLAN (PLAN)
**ID** : S04_COSMOS_MODE_04_PLAN · **Moteur** : React Flow v12 (D-RENDER-001/004)
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

## Flux : [DAG scy_ascent_nodes validé petgraph] → layout dagre async (≤1000) → Mode04Roadmap.tsx (styles Verrouillé/Disponible/En cours/Complété, jauge SMI, pipelines SVG, halo vert actif) → clic → Bottom Sheet cours+exos+Teach-Back. Déblocage si SMI APEX ≥70.
## Dépendances : `@xyflow/react` v12, dagre, petgraph. Fichiers : `frontend_react/src/cosmos/modes/Mode04Roadmap.tsx`.

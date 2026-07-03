<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ENGINE-D3 — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_D3_PLAN  
**Décision** : D-RENDER-008  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

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

## 1. Flux de Données

```
 [Données Graphology : axes parallèles / ordre linéaire / hiérarchie+dépendances / coordonnées cartésiennes]
                 │
                 ▼
   [Lazy-import dynamique : await import('d3...')]
                 │
                 ▼
   [Validation Zod + Web Worker pour calculs géométriques (≤5000 concepts M15)]
                 │
        ┌────────┼──────────────┬───────────────┬──────────────┐
        ▼        ▼              ▼               ▼              ▼
  [d3 Parallel  [d3 Arc        [d3 Edge        [d3-delaunay   [d3 Voronoi
   Coords M15]   Diagram M20]   Bundling M21]   (Voronoi M24)]
   (brushing)]   (arcs clampés) (slider tension, (cellules clampées)
                                 LOD > 2000)
        └────────┴──────────────┴───────────────┴──────────────┘
                       │
                       ▼
        [Rendu SVG bas niveau + cohérence palette design.md]
```

---

## 2. Dépendances Techniques Strictes
* **d3 v7** : `d3-scale`, `d3-shape`, `d3-brush`, `d3-delaunay`, `d3-hierarchy` (v7.x).
* **React 18** + **Web Worker** (calculs géométriques lourds).
* **Lazy-loading** : chunks indépendants.
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/cosmos/engines/d3_loader.ts`** : Lazy-import d3.
- **`frontend_react/src/cosmos/workers/geo_worker.ts`** : Calculs géométriques déportés.
- **`frontend_react/src/cosmos/modes/`** : composants M15/M20/M21/M24.

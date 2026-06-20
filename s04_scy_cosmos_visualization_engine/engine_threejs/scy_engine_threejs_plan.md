# 🛠️ SCY-ENGINE-THREEJS — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_THREEJS_PLAN  
**Décision** : D-RENDER-009  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données

```
 [Coordonnées 3D (x,y,z) des concepts — 3 axes orthogonaux]
                 │
                 ▼
   [GPU check : WebGL2 + GPU dédié ?]
        │
        ├──► Non ──► Masquer M23 ──► Fallback Mode 2 (Knowledge Graph 2D)
        │
        ▼ (Oui)
   [Lazy-import dynamique : await import('three')  (~450KB)]
                 │
                 ▼
   [Validation Zod des coordonnées 3D]
                 │
                 ▼
   [Composant React : Brain3DGraph.tsx (three.js + OrbitControls)]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [Sphères lumineuses      [Cylindres de force
   (couleur ∝ domaine,     translucides
   diamètre ∝ importance)]  reliant les sphères]
  [Axes sémantiques 3D
   en arrière-plan]
        │                     │
        └────────┬────────────┘
                 ▼
   [Navigation Orbit + fly-to animation + Knowledge Card 3D @ 60 FPS]
```

---

## 2. Dépendances Techniques Strictes
* **three.js** : `three` (OrbitControls, WebGL2).
* **React 18** : composant `Brain3DGraph.tsx` (déjà présent dans spec_and_patterns).
* **GPU check** : feature detection WebGL2.
* **Lazy-loading** : chunk indépendant (D-RENDER-009).
* **Tokens design** : `design.md`.
* **Roadmap** : migration WebGPU Phase 3.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/components/Brain3DGraph.tsx`** : Composant React three.js principal.
- **`frontend_react/src/cosmos/engines/threejs_loader.ts`** : Lazy-import + GPU check.
- **`frontend_react/src/cosmos/modes/`** : composant M23.

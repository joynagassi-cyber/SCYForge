<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ENGINE-WEBGPU — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_WEBGPU_PLAN  
**Décisions** : D-PERF-006 (Phase 3), D-RENDER-009 (three.js WebGPU)  
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

## 1. Flux de Données — Gate d'Activation

```
 [Mode WebGPU-éligible demandé (M0 / M22 / M23)]
                 │
                 ▼
   ┌─────────────────────────────────────┐
   │  FEATURE DETECTION (gate bloquante) │
   │  1. navigator.gpu présent ?         │── non ──► FALLBACK WebGL 2
   │  2. requestAdapter() non null ?     │── non ──► FALLBACK WebGL 2
   │  3. requestDevice() OK ?            │── non ──► FALLBACK WebGL 2
   │  4. (option) compatibility mode ?   │
   └──────────────┬──────────────────────┘
                  │ oui
                  ▼
   [Lazy-import : const THREE = await import('three/webgpu')]
                 │
        ┌────────┴──────────────────────────┐
        ▼                                   ▼
  [M23 : THREE.WebGPURenderer()      [M0/M22 : Cosmos.gl fast-path
   await renderer.init()              GPU shaders WebGPU
   (async obligatoire)]               1M+ nœuds @ 60 FPS]
        │                                   │
        └──────────────┬────────────────────┘
                       │
            ┌──────────┴───────────────┐
            ▼                          ▼
     [Erreur runtime ?           [Rendu OK]
      (bug driver NVIDIA/AMD)]    
      → telemetry               → telemetry fast-path
      → FALLBACK WebGL 2          % journalisé
      → pas de retry session]
```

---

## 2. Dépendances Techniques Strictes
* **WebGPU W3C** : `navigator.gpu`, WGSL, backends Vulkan/Metal/D3D12.
* **three.js r171+** : `three/webgpu` (WebGPURenderer + fallback WebGL 2 intégré).
* **Cosmos.gl** : shaders GPU WebGPU pour M0/M22.
* **Feature detection** : cascade `navigator.gpu` → `requestAdapter` → `requestDevice`.
* **Compatibility mode** : `featureLevel: 'compatibility'` (Chrome 146+).
* **Lazy-loading** : chunk WebGPU indépendant (Phase 3).
* **Telemetry** : % fast-path, erreurs driver.
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/cosmos/engines/webgpu_detector.ts`** : Feature detection + cache de décision session.
- **`frontend_react/src/cosmos/engines/webgpu_loader.ts`** : Lazy-import `three/webgpu` + Cosmos fast-path.
- **`frontend_react/src/cosmos/engines/webgpu_fallback.ts`** : Repli WebGL 2 + telemetry.
- **`frontend_react/src/components/Brain3DGraph.tsx`** : Bascule conditionnelle WebGPURenderer (M23).
- **`frontend_react/src/cosmos/modes/Mode00/Mode22`** : Fast-path Cosmos WebGPU.
- **Telemetry table `mfg_webgpu_telemetry`** : user_id, detection_result, fast_path_active, driver_info, fallback_reason.

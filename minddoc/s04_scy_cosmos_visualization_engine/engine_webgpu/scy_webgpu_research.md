<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📑 SCY-WEBGPU — RECHERCHE VÉRIFIÉE (RESEARCH)
**ID Document** : S04_COSMOS_ENGINE_WEBGPU_RESEARCH  
**Date de recherche** : 2026-06-20  
**Objet** : Veille WebGPU (standard W3C « GPU for the Web ») et décision d'intégration COSMOS  
**Méthode** : recherche Internet multi-sources, recoupement, vérification des versions  

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

## 1. Définition
**WebGPU** est l'API JavaScript W3C (GPU for the Web Working Group) qui expose le GPU du système via Vulkan / Metal / Direct3D 12 pour le **rendu ET le calcul (compute shaders)**. Point d'entrée : `navigator.gpu`. Successeur de WebGL (ère 2011-2025).

---

## 2. Compatibilité Navigateur — vérifiée (juin 2026)

| Navigateur | Version minimale | Plateformes |
|-----------|------------------|-------------|
| Chrome / Edge (Chromium Dawn) | **113+** | Windows, macOS, ChromeOS |
| Chrome Android | 121+ | Android 12+ |
| Firefox (wgpu) | 141 (Win) / 145+ (macOS AS) / **147+ recommandé** | Windows, macOS Apple Silicon |
| Safari (WebKit → Metal) | **26** | macOS Tahoe 26, iOS 26, iPadOS 26, visionOS 26 |
| Opera / Samsung Internet | 99+ / 24+ | — |

- **Baseline cross-browser atteint janvier 2026** (Fin de l'ère WebGL).
- **Couverture globale ≈ 70 %** → **30 % des utilisateurs nécessitent un fallback WebGL**.

### Sources
- [WebGPU 2026 — ByteIota](https://byteiota.com/webgpu-2026-70-browser-support-15x-performance-gains/)
- [WebGPU Hits Critical Mass — WebGPU.com](https://www.webgpu.com/news/webgpu-hits-critical-mass-all-major-browsers/)
- [WebGPU Baseline 2026 — VR.org](https://vr.org/articles/webgpu-baseline-2026-three-js-webxr-default)
- [WebGPU Browser Support — TestMu AI](https://www.testmuai.com/learning-hub/webgpu-browser-support/)

---

## 3. Pattern de Détection de Compatibilité (officiel)

```js
// 1. Le navigateur expose-t-il WebGPU ?
if (!navigator.gpu) → WebGPU indisponible (fallback WebGL)

// 2. Un adaptateur GPU est-il disponible ?
const adapter = await navigator.gpu.requestAdapter();
if (!adapter) → API présente mais pas de GPU (fallback WebGL)

// 3. Un device logique peut-il être créé ?
const device = await adapter.requestDevice();  // prêt à l'usage
```

three.js r171+ gère automatiquement cette cascade (`three/webgpu` → fallback WebGL 2 intégré).

### Source
- [TestMu AI — détection navigator.gpu](https://www.testmuai.com/learning-hub/webgpu-browser-support/)

---

## 4. Gains de Performance (cas COSMOS pertinents)

| Cas d'usage | Gain WebGPU | Modes COSMOS concernés |
|-------------|-------------|------------------------|
| Rendu 3D (render bundles) | ~10× | **M23** (3D Knowledge Space) |
| Nuages de points massifs | ~100× (Segens.ai LiDAR) | **M0, M22** (Cosmos 1M nœuds) |
| Particules 100 000+ | viable | pipelines animés |
| Data viz 1M points @ 60 FPS | viable (ChartGPU) | M5/M15 grandes volumétries |
| Compute / AI inference | 80% performance native | — |

### Migration three.js (2 lignes)
```js
// Avant (WebGL)
import * as THREE from 'three';
const renderer = new THREE.WebGLRenderer();

// Après (WebGPU + fallback auto WebGL 2)
import * as THREE from 'three/webgpu';
const renderer = new THREE.WebGPURenderer();
await renderer.init();   // ⚠️ async obligatoire
```

### Sources
- [Three.js WebGPU Architecture — Intelligent Graphic & Code](https://www.intelligentgraphicandcode.com/development/threejs-interfaces/webgpu)
- [Three.js vs WebGPU 2026 — AlterSquare](https://altersquare.io/three-js-vs-webgpu-2026-large-scale-construction-viewers/)
- [WebGPU + Three.js Migration — Utsubo](https://www.utsubo.com/blog/webgpu-threejs-migration-guide)

---

## 5. Défis Confirmés (contraintes à documenter)

| Défi | Impact | Mitigation |
|------|--------|-----------|
| 45 % devices : pas de storage buffers vertex shaders | Features réduites | `featureLevel: 'compatibility'` (Chrome 146) |
| Bugs GPU vendors (NVIDIA 572.xx RTX 30/40, AMD HD 7700, Intel hangs) | Crashes/artefacts | Telemetry + fallback |
| Linux flag-gated | Activation manuelle | Détecter + WebGL fallback |
| Firefox Linux/Android | Couverture fragmentée | WebGL fallback |
| 30 % users sans WebGPU | Pas de fast-path | **WebGL 2 fallback obligatoire** |

### Sources
- [WebGPU in Production — TechBytes](https://techbytes.app/posts/webgpu-in-production-browser-ml-native-speed-2026/)
- [ByteIota — challenges](https://byteiota.com/webgpu-2026-70-browser-support-15x-performance-gains/)

---

## 6. Décision d'Intégration COSMOS

**Statut** : ✅ INTÉGRABLE — cohérent avec le PRD (`navigator.gpu` D-PERF-006 Phase 3, D-RENDER-009 roadmap three.js WebGPU).

**Stratégie retenue — Progressive Enhancement** :
1. WebGPU est un **engine optionnel** (Phase 3), **jamais** le défaut Phase 1.
2. Activation **uniquement après feature detection** `navigator.gpu` + `requestAdapter` + `requestDevice`.
3. three.js bascule sur `WebGPURenderer` quand compatible (M23, futur M0/M22).
4. **Fallback WebGL 2 automatique** préservé pour les 30 % incompatibles.
5. Aucune suppression de WebGL — coexistence indéfinie.

**Aucune contradiction** avec le PRD : WebGPU y est explicitement roadmap Phase 3.

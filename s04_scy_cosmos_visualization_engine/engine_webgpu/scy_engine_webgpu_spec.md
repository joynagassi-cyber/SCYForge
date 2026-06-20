# ⚡ SCY-ENGINE-WEBGPU — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_ENGINE_WEBGPU_SPEC  
**Décisions** : D-PERF-006 (Phase 3), D-RENDER-009 (roadmap three.js WebGPU)  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement du **moteur engine_webgpu**, basé sur le standard W3C **WebGPU** (`navigator.gpu`). Il fournit un **fast-path GPU moderne** (compute shaders, rendu bas overhead) pour les modes COSMOS intensifs : M0/M22 (Cosmos 1M+ nœuds) et M23 (3D Knowledge Space). **Engine optionnel Phase 3** activé **uniquement après feature detection navigateur**, avec **fallback WebGL 2 automatique** pour les 30 % d'utilisateurs incompatibles.

> **Base factuelle** : voir `scy_webgpu_research.md` (compatibilité vérifiée juin 2026, sources recoupées).

---

## 2. Tech Stack & Dependencies
* **API** : WebGPU W3C (`navigator.gpu` → `requestAdapter()` → `requestDevice()`).
* **Shaders** : WGSL (WebGPU Shading Language, type Rust).
* **Backends natifs** : Vulkan (Linux/Android), Metal (Apple), Direct3D 12 (Windows).
* **Intégration three.js** : r171+ `import * as THREE from 'three/webgpu'` + `THREE.WebGPURenderer()` (fallback WebGL 2 intégré).
* **Cosmos.gl** : fast-path GPU shaders pour M0/M22.
* **Lazy-loading** : module WebGPU chargé à la demande (Phase 3, après détection positive).
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : WebGPU est un standard W3C réel (Baseline janvier 2026, ~70 % couverture). Feature detection obligatoire — aucune activation aveugle. Palette stricte `design.md`.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Feature Detection Stricte (Gate d'Activation)

#### Scénario : Vérification de compatibilité navigateur
- **GIVEN** Une session utilisateur démarrant un mode WebGPU-éligible (M0/M22/M23).
- **WHEN** Le système évalue la compatibilité.
- **THEN** le système SHALL vérifier `navigator.gpu` (présence de l'API).
- **AND** le système SHALL appeler `requestAdapter()` (null si pas de GPU → incompatible).
- **AND** le système SHALL appeler `adapter.requestDevice()` (device logique requis).
- **AND** le système SHALL NE JAMAIS activer WebGPU si une seule de ces étapes échoue.

#### Scénario : Repli sur WebGL (30 % users)
- **GIVEN** `navigator.gpu` absent OU `requestAdapter()` null OU `requestDevice()` échoue.
- **WHEN** La détection est négative.
- **THEN** le système SHALL basculer silencieusement sur le moteur WebGL 2 (three.js `WebGLRenderer` / Cosmos WebGL).
- **AND** le système SHALL journaliser l'événement (telemetry) sans interrompre l'UX.

---

### Requirement : Activation Progressive (Phase 3)

#### Scénario : Bascule three.js sur WebGPURenderer
- **GIVEN** Feature detection positive ET Phase 3 active.
- **WHEN** M23 (3D Knowledge Space) est demandé.
- **THEN** le système SHALL instancier `THREE.WebGPURenderer()` via `import('three/webgpu')`.
- **AND** le système SHALL appeler `await renderer.init()` (initialisation async obligatoire).
- **AND** le système SHALL NE PAS bloquer si `init()` échoue (fallback WebGL 2).

#### Scénario : Fast-path Cosmos 1M nœuds
- **GIVEN** Feature detection positive.
- **WHEN** M0/M22 (Cosmos massif) est demandé.
- **THEN** le système SHALL privilégier les shaders GPU WebGPU de Cosmos.gl.
- **AND** le système SHALL maintenir 60 FPS sur 1M+ nœuds (vs seuils WebGL).

---

### Requirement : Gestion du Compatibility Mode

#### Scénario : Device sans storage buffers vertex shaders
- **GIVEN** Un device où les storage buffers en vertex shaders ne sont pas supportés (~45 % devices).
- **WHEN** Le système requête le device.
- **THEN** le système SHALL activer le `featureLevel: 'compatibility'` (Chrome 146+).
- **AND** le système SHALL réduire le sous-ensemble de features sans crasher.

---

### Requirement : Résilience Bugs GPU Vendors

#### Scénario : Crash driver (NVIDIA 572.xx / AMD HD 7700 / Intel hangs)
- **GIVEN** Un driver GPU instable connu.
- **WHEN** WebGPU produit une erreur runtime.
- **THEN** le système SHALL capter l'erreur (telemetry).
- **AND** le système SHALL basculer sur le fallback WebGL 2.
- **AND** le système SHALL NE PAS réessayer WebGPU pour cette session (cache de la décision).

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Activer WebGPU sans feature detection préalable (`navigator.gpu` + adapter + device).
* 🚫 **FORBIDDEN** : Supprimer WebGL — coexistence indéfinie (30 % fallback).
* 🚫 **FORBIDDEN** : Oublier `await renderer.init()` (three.js WebGPU async).
* 🚫 **SHALL NOT** : Utiliser WebGPU en Phase 1 (Phase 3 uniquement, D-PERF-006).
* 🚫 **MUST NOT** : Couleurs hors des tokens `design.md`.
* ⚠️ **MUST** : Telemetry sur le % de sessions atteignant le fast-path WebGPU.

---

## 5. Test cases & Validation
* **Test Case 1 (Détection+)** : Navigateur WebGPU-compatible → fast-path activé (WebGPURenderer M23, Cosmos shaders M0/M22).
* **Test Case 2 (Détection−)** : `navigator.gpu` absent ou adapter null → fallback WebGL 2 silencieux, UX préservée.
* **Test Case 3 (Async init)** : `await renderer.init()` respecté ; échec d'init → fallback.
* **Test Case 4 (Compatibility mode)** : Device sans storage buffers → `featureLevel: 'compatibility'` activé, pas de crash.
* **Test Case 5 (Bug driver)** : Crash runtime → capter + fallback WebGL + pas de retry session.
* **Test Case 6 (Perf)** : 1M nœuds M0/M22 @ 60 FPS en fast-path ; M23 ~10× plus rapide qu'en WebGL.
* **Test Case 7 (Telemetry)** : % fast-path journalisé ; palette `design.md`.

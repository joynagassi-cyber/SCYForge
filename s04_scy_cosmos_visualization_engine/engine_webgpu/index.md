# 🗺️ INDEX LOCAL : ENGINE_WEBGPU
Ce sous-répertoire documente le moteur de rendu **WebGPU** (standard W3C, D-PERF-006 Phase 3) — accès GPU moderne via Vulkan/Metal/D3D12. **Engine optionnel activé uniquement après feature detection navigateur.** Fast-path haute performance pour M0, M22 et M23, avec fallback WebGL 2 automatique.

## 📁 Gabarits de Sûreté d'Écriture (MANDATORY READ)
- `scy_webgpu_research.md` (Recherche vérifiée multi-sources — compatibilité, perfs, défis)
- `scy_engine_webgpu_spec.md` (Spécification de portée comportementale)
- `scy_engine_webgpu_plan.md` (Plan d'implémentation technique)
- `scy_engine_webgpu_tasks.md` (Liste de tâches atomiques de 15 min)
- `scy_engine_webgpu_tests.md` (Contrat de tests et cas limites)

## 🔗 Modes COSMOS bénéficiant du fast-path WebGPU
M0 Base Knowledge Base · M22 Semantic Zoom Graph · M23 3D Knowledge Space

## 🛡️ Règle d'activation
WebGPU ne s'active **JAMAIS** par défaut. Feature detection stricte : `navigator.gpu` → `requestAdapter()` → `requestDevice()`. En cas d'incompatibilité (30 % users), fallback WebGL 2 automatique (three.js) / Cosmos WebGL.

Référez-vous aux décisions **D-PERF-006** et **D-RENDER-009**, et à **`s00_architecture_standards/`**.

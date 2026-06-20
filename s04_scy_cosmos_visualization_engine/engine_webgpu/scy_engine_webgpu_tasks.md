# 📋 SCY-ENGINE-WEBGPU — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_WEBGPU_TASKS  
**Décisions** : D-PERF-006 (Phase 3), D-RENDER-009  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

Chaque tâche est conçue pour être codée en 15 à 30 minutes de manière unitaire et testable.

---

## 🧭 Liste des Tâches de Production

### 🚀 Tâche WG.1 : Coder le Détecteur de Compatibilité (Gate) (Durée : 25 min)
* **Description** : Coder `webgpu_detector.ts` : cascade `navigator.gpu` → `requestAdapter()` → `requestDevice()`, avec cache de la décision pour la session (pas de re-détection).
* **Fichier de destination** : `frontend_react/src/cosmos/engines/webgpu_detector.ts`
* **Critère de Succès** : Retourne `{ supported: true, device }` si compatible ; `{ supported: false }` sinon, sans exception non gérée.

### 🚀 Tâche WG.2 : Coder le Loader Lazy + init async three.js (Durée : 25 min)
* **Description** : Coder `webgpu_loader.ts` : lazy-import `three/webgpu`, instanciation `WebGPURenderer`, **`await renderer.init()`** (async obligatoire), gestion de l'échec d'init.
* **Fichier de destination** : `frontend_react/src/cosmos/engines/webgpu_loader.ts`
* **Critère de Succès** : `await init()` respecté ; échec → signal pour fallback.

### 🚀 Tâche WG.3 : Coder le Fallback WebGL 2 + Telemetry (Durée : 20 min)
* **Description** : Coder `webgpu_fallback.ts` : repli silencieux sur `WebGLRenderer` / Cosmos WebGL, journalisation telemetry (`mfg_webgpu_telemetry`), pas de retry WebGPU pour la session.
* **Fichier de destination** : `frontend_react/src/cosmos/engines/webgpu_fallback.ts`
* **Critère de Succès** : Repli silencieux, UX préservée, telemetry écrite.

### 🚀 Tâche WG.4 : Intégrer la Bascule M23 (Brain3DGraph) (Durée : 25 min)
* **Description** : Brancher `Brain3DGraph.tsx` (M23) sur la détection : WebGPURenderer si supporté, sinon WebGLRenderer existant.
* **Fichier de destination** : `frontend_react/src/components/Brain3DGraph.tsx`
* **Critère de Succès** : M23 utilise WebGPU quand compatible (~10× perf) ; sinon WebGL.

### 🚀 Tâche WG.5 : Intégrer le Fast-path Cosmos M0/M22 (Durée : 30 min)
* **Description** : Brancher Cosmos.gl sur les shaders GPU WebGPU pour M0/M22 quand supporté (1M+ nœuds @ 60 FPS).
* **Fichier de destination** : `frontend_react/src/cosmos/modes/Mode00BaseKnowledge.tsx`, `Mode22SemanticZoom.tsx`
* **Critère de Succès** : M0/M22 en fast-path WebGPU quand compatible ; sinon Cosmos WebGL existant.

### 🚀 Tâche WG.6 : Coder le Compatibility Mode (Durée : 20 min)
* **Description** : Activer `featureLevel: 'compatibility'` (Chrome 146+) pour les devices sans storage buffers vertex shaders (~45 %), réduisant le sous-ensemble sans crasher.
* **Fichier de destination** : `frontend_react/src/cosmos/engines/webgpu_loader.ts`
* **Critère de Succès** : Device limité → compatibility mode activé, pas de crash.

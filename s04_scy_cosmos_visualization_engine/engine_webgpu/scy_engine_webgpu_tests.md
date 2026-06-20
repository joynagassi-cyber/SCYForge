# 🧪 SCY-ENGINE-WEBGPU — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_WEBGPU_TESTS  
**Décisions** : D-PERF-006 (Phase 3), D-RENDER-009  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

## 1. Scénarios de Validation Unitaires

### 🧪 Test WG.1 : Détection Positive (Happy Path)
* **Pré-conditions** : Navigateur WebGPU-compatible (Chrome 113+ / Firefox 147+ / Safari 26), GPU disponible.
* **Règle d'Exécution** : Appeler `detectWebGPU()`.
* **Post-conditions (Attendu)** :
  - Retour `{ supported: true, device }`.
  - Le fast-path WebGPU est activé pour les modes éligibles.

### 🧪 Test WG.2 : Détection Négative — API absente
* **Pré-conditions** : `navigator.gpu` indéfini (navigateur ancien).
* **Règle d'Exécution** : Appeler `detectWebGPU()`.
* **Post-conditions (Attendu)** :
  - Retour `{ supported: false }`.
  - Bascule silencieuse sur WebGL 2.
  - UX préservée (pas d'exception).

### 🧪 Test WG.3 : Détection Négative — Pas d'adaptateur GPU
* **Pré-conditions** : `navigator.gpu` présent mais `requestAdapter()` retourne null.
* **Post-conditions (Attendu)** : Fallback WebGL 2 silencieux + telemetry.

### 🧪 Test WG.4 : init() async three.js
* **Pré-conditions** : Détection positive.
* **Règle d'Exécution** : Instancier `WebGPURenderer` puis `await renderer.init()`.
* **Post-conditions (Attendu)** :
  - Rendu opérationnel après `await`.
  - Si `init()` échoue → fallback WebGL 2.

### 🧪 Test WG.5 : Compatibility Mode (device limité)
* **Pré-conditions** : Device sans storage buffers vertex shaders.
* **Post-conditions (Attendu)** :
  - `featureLevel: 'compatibility'` activé.
  - Sous-ensemble réduit fonctionnel, pas de crash.

### 🧪 Test WG.6 : Bug Driver Runtime
* **Pré-conditions** : Crash WebGPU simulé (NVIDIA 572.xx / AMD / Intel).
* **Post-conditions (Attendu)** :
  - Erreur captée (telemetry).
  - Fallback WebGL 2.
  - Pas de retry WebGPU pour la session (cache décision).

### 🧪 Test WG.7 : Performance Fast-path
* **Pré-conditions** : Fast-path actif.
* **Règle d'Exécution** : Rendre M0/M22 (1M nœuds) et M23.
* **Post-conditions (Attendu)** :
  - M0/M22 : 60 FPS sur 1M+ nœuds.
  - M23 : ~10× plus rapide qu'en WebGL.

### 🧪 Test WG.8 : Telemetry & Palette
* **Post-conditions (Attendu)** :
  - % sessions fast-path journalisé dans `mfg_webgpu_telemetry`.
  - Aucune couleur hors tokens `design.md`.

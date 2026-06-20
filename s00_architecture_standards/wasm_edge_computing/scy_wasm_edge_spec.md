# 🔧 SCY-WASM-EDGE-COMPUTING — SPÉCIFICATION (SPEC)
**ID** : S00_WASM_EDGE_COMPUTING_SPEC · **Décisions** : D-OPT-001 (WASM Edge Computation) + D-OPT-060 (WASM Tool Sandboxing) · **Phase** : MVP+

## 1. Purpose
Le **WASM Edge Computing** compile le code Rust backend (FSRS scheduler + petgraph DAG validation) en **WebAssembly** pour l'exécuter **dans le navigateur**. Élimine la latence réseau, supprime la facturation CPU serveur, et permet un fonctionnement **100% hors-ligne** sans Electron (PWA offline-capable).

Le **WASM Tool Sandboxing** (D-OPT-060) standardise l'exécution des scripts d'outils tiers dans des **bacs à sable WASM isolés**, garantissant une étanchéité de sécurité absolue au runtime.

## 2. Tech Stack
* **wasm-bindgen** : Rust → WASM (mature, stable)
* **wasmer** : runtime WASM universel
* **wasm-pack** : packaging Rust WASM pour npm
* **wasmtime** : isolation sandboxing

## 3. Requirements (RFC 2119)

### D-OPT-001 — WASM Edge Computation
- **THEN** le système SHALL compiler le moteur FSRS et la validation petgraph en WASM.
- **AND** le système SHALL les exécuter localement dans le navigateur (zéro latence réseau, zéro coût serveur).
- **AND** le système SHALL fonctionner 100% offline (PWA).
- **AND** le système SHALL maintenir une unification de code 100% entre Cloud et Desktop/WASM.

### D-OPT-060 — WASM Tool Sandboxing
- **THEN** le système SHALL exécuter tout script d'outil tiers dans un bac à sable WASM isolé.
- **AND** le système SHALL garantir une étanchéité de sécurité absolue au runtime (pas d'accès non autorisé).

## 4. Tests
- TC1 : FSRS compilé en WASM → calcul navigateur (0 latence réseau). | TC2 : petgraph DAG validation WASM offline. | TC3 : PWA 100% offline. | TC4 : Tool tiers dans sandbox WASM isolé. | TC5 : Unification code Cloud/WASM.

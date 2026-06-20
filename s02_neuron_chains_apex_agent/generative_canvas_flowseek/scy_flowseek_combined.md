# 🛠️ SCY-FLOWSEEK — PLAN / TÂCHES / TESTS
**ID** : S02_NEURON_FLOWSEEK_PLAN / TASKS / TESTS · **Réf** : PRD §7.4.3bis H

## Flux : [concept structurel cours/slide] → NEURON-CHAINS émet flux JSON (nœuds+arêtes+labels) → frontend React Flow + elkjs dessine+anime 60 FPS en temps réel (coordonnées locales elkjs, 0$ serveur).
## Dépendances : React Flow (@xyflow/react), elkjs (Web Worker), NEURON-CHAINS streaming JSON. 
## Fichiers : `backend_rs/src/neurochain/flowseek/event_emitter.rs`, `frontend_react/src/components/GenerativeCanvas.tsx`.
## Tâches : FS.1 Coder l'émetteur JSON événements (NEURON-CHAINS) (25min) | FS.2 Coder le canvas React Flow + elkjs animé 60 FPS (30min) | FS.3 Intégrer dans slides ASCENT + pages cours (20min).
## Tests : TC1 graphe animé 60 FPS temps réel | TC2 elkjs local 0$ | TC3 synergie InfographicAI.

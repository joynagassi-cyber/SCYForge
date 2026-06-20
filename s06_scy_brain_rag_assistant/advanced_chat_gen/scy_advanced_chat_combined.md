# 🛠️ SCY-ADVANCED-CHAT-GEN — PLAN / TÂCHES / TESTS
**ID** : S06_BRAIN_ADVANCED_CHAT_PLAN / TASKS / TESTS

## Flux
```
[Requête utilisateur]
   │
   ├── Mode Normal ──► SCY-BRAIN (triple retrieval + RRF + SSE) ──► réponse claire/concise
   │
   └── Mode Agentique ──► APEX-AGENT + 18 tools NEURON-CHAINS
                            ├── livrables : PowerPoint G13 / rapports / veilles
                            ├── anti-hallucination 3 couches + score confiance/livrable
                            └── source : Base cumulative | Internet | Hybride
```
## Dépendances : Vercel AI SDK (SSE, UI générative), APEX-AGENT, 18 tools, triple retrieval. 
## Fichiers : `backend_ts/src/brain/chat/normal_mode.ts`, `agentique_mode.ts`, `livrable_generator.ts`.

## Tâches
- AC.1 : Coder le Mode Normal (SSE streaming, triple retrieval) (25 min).
- AC.2 : Coder le Mode Agentique (APEX-AGENT + livrables G13/rapports) (30 min).
- AC.3 : Coder le choix de source + score confiance/livrable (20 min).

## Tests
- TC1 : Mode Normal Q→R SSE. | TC2 : Mode Agentique livrable visualisable. | TC3 : 3 modes source. | TC4 : score confiance/livrable (anti-hallucination).

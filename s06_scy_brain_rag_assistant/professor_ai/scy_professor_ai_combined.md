# 🛠️ SCY-PROFESSOR-AI — PLAN / TÂCHES / TESTS
**ID** : S06_BRAIN_PROFESSOR_AI_PLAN / TASKS / TESTS · **Décisions** : D-OPT-021/022/027

## Flux
```
[Question utilisateur / nœud courant ASCENT]
   │
   ▼
[Sélection ton auto : Starter Evaluator → T41 ELI5 / T42 ELI PhD]
   │
   ▼
[Triple Retrieval (contexte RAG) + Thread-of-Thought (parents sémantiques, D-OPT-027)]
   │
   ▼
[Socratic Progressive Prompting (D-OPT-022) : max 2 paragraphes + 1 question socratique]
   │
   ▼
[SSE Streaming (Vercel AI SDK) → réponse + 3 suggestions (T16 DocSuggester, COSMOS 2-hop)]
   │
   ├── Fail-Safe (D-OPT-021) : créateur absent 24h → contenu socratique transitoire
   └── Anti-hallucination 3 couches
```
## Dépendances : Triple Retrieval, Starter Evaluator, T16 DocSuggester, Vercel AI SDK (SSE), LlmRouter+BudgetGuard. 
## Fichiers : `backend_rs/src/brain/professor/ton_selector.rs`, `socratic_prompter.rs`, `thread_of_thought.rs`, `fail_safe.rs`, `suggestion_engine.rs`.

## Tâches
- PA.1 : Coder la sélection ton auto (Starter Evaluator → T41/T42) (20 min).
- PA.2 : Coder Socratic Progressive Prompting (max 2 para + question, D-OPT-022) (25 min).
- PA.3 : Coder Thread-of-Thought Scaffolding (D-OPT-027) (25 min).
- PA.4 : Coder Fail-Safe Backup (D-OPT-021) + suggestions T16 (25 min).

## Tests
- TC1 : ton auto (novice→ELI5, expert→PhD). | TC2 : max 2 para + question socratique. | TC3 : Thread-of-Thought (non fragmenté). | TC4 : Fail-Safe créateur absent 24h. | TC5 : 3 suggestions/nœud (T16). | TC6 : anti-hallucination 3 couches.

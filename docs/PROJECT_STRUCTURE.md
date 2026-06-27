# SCY FORGE — PROJECT STRUCTURE
## Arborescence Réelle du Code de Production

> **Règle** : cette arborescence est **obligatoire**. L'agent de codage DOIT placer le code aux emplacements indiqués.

---

## 1. Arborescence Racine

```
SCYForge/                          ← Dépôt Git MindDoc.git (specs + code)
├── AGENTS.md                      ← Instructions permanentes pour l'agent
├── docs/                          ← Documents de codage (ce dossier)
│   ├── PROJECT_STRUCTURE.md       ← CE FICHIER
│   ├── BUILD_COMMANDS.md
│   ├── IMPLEMENTATION_ORDER.md
│   ├── CODE_STYLE.md
│   ├── DEPENDENCY_MANIFEST.md     ← Manifeste des dépendances (crates/npm/sidecars)
│   └── AUDIT_STRUCTURE.md         ← Audit structurel (référence)
│
├── minddoc/                       ← SPECS (590+ fichiers — LIRE, PAS CODER ICI)
│   ├── s00_architecture_standards/← Specs architecture (services, vision, LiveKit…)
│   ├── s00_prd/                   ← PRD (SOURCE DE VÉRITÉ, ne pas modifier)
│   ├── s00_design/                ← Maquettes HTML + design system
│   ├── s01_ingestion_cores/       ← Specs ingestion (13 cores + Web Search V2)
│   ├── s02_neuron_chains_apex_agent/  ← Specs NEURON-CHAINS (service transverse)
│   ├── s03_ascent_pipeline_agents/    ← Specs ASCENT (18 agents + QA + DAG + CHRONICLE)
│   ├── s04_scy_cosmos_visualization_engine/ ← Specs COSMOS (26 modes + engines)
│   ├── s05_apex_retention_system/ ← Specs APEX/FSRS (service transverse)
│   ├── s06_scy_brain_rag_assistant/← Specs BRAIN (service transverse + live web search)
│   ├── s07_scy_imprint_cognitive/ ← Specs IMPRINT
│   ├── s08_scy_reader_suite/      ← Specs Reader Suite
│   ├── s09_harmonist_validation_gates/ ← Specs Harmonist
│   ├── s10_normal_mode_ingestion/ ← Specs Normal Mode
│   ├── s11_neuroscientific_engine/← Specs Neuro Engine
│   └── s12_b2b_creator_console/   ← Specs B2B
│
├── backend_rs/                    ← CODE RUST (calculs lourds) — À CRÉER
├── backend_ts/                    ← CODE TYPESCRIPT (orchestration agents) — À CRÉER
├── frontend_react/                ← CODE REACT (UI) — À CRÉER
├── docker/                        ← Docker Compose + Dockerfiles — À CRÉER
└── .env.example                   ← Variables d'environnement (template) — À CRÉER
```

---

## 2. backend_rs/ — Rust (Moteur de Calcul)

```
backend_rs/
├── Cargo.toml                     ← Workspace Rust (crates)
├── Cargo.lock
├── Dockerfile
│
├── crates/                        ← Crates partagés (SERVICES TRANSVERSES)
│   │
│   ├── scy-eventbus/              ← Service 1 : EventBus (pub/sub)
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs
│   │       ├── event.rs           ← SCY ForgeEvent enum
│   │       ├── publisher.rs       ← Outbox publisher
│   │       └── dead_letter.rs     ← DLQ
│   │
│   ├── scy-ingestion/             ← Service 2 : Ingestion (13 cores)
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs
│   │       ├── cores/             ← Un module par core
│   │       │   ├── youtube.rs
│   │       │   ├── web_search.rs  ← Web Search Engine V2 (SearxNG+Perplexica)
│   │       │   ├── academic.rs
│   │       │   ├── drive.rs
│   │       │   ├── podcast.rs
│   │       │   ├── financial.rs
│   │       │   ├── twitter.rs
│   │       │   ├── wikipedia.rs
│   │       │   ├── science.rs
│   │       │   ├── tiktok.rs
│   │       │   ├── reddit.rs
│   │       │   ├── epub.rs
│   │       │   └── anki.rs
│   │       ├── scrapling_client.rs  ← Scraping furtif
│   │       ├── dom_smoothie.rs      ← Nettoyage HTML→MD
│   │       └── mapreduce.rs         ← Pipeline L0-L4
│   │
│   ├── scy-neuron-chains/         ← Service 3 : NEURON-CHAINS (génération)
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs
│   │       ├── apex_agent/        ← Méta-orchestrateur ReAct
│   │       │   ├── react_loop.rs
│   │       │   └── orchestrator.rs  ← JoinSet + CancellationToken
│   │       ├── chains/            ← 7 chaînes
│   │       │   ├── alpha/         ← Extraction & Synthèse
│   │       │   ├── beta/          ← Structuration
│   │       │   ├── gamma/         ← Enrichissement
│   │       │   ├── delta/         ← Validation
│   │       │   ├── epsilon/       ← Génération Documents
│   │       │   ├── zeta/          ← Révision Qualité
│   │       │   └── eta/           ← Export Final
│   │       ├── tools/             ← 18 tools (T01-T18)
│   │       │   ├── t01_doctype_detector.rs
│   │       │   ├── ...
│   │       │   └── t18_semantic_cache.rs
│   │       ├── anti_hallucination/ ← 3 couches
│   │       ├── pivotiq/           ← Réconciliation multi-sources
│   │       ├── citation/          ← CitationTracker + sourcing
│   │       └── flowseek/          ← Generative-Canvas-AI
│   │
│   ├── scy-apex-fsrs/             ← Service 4 : APEX/FSRS (rétention)
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs
│   │       ├── scheduler/         ← FSRS 5.0
│   │       │   ├── fsrs_engine.rs
│   │       │   ├── calibrator.rs
│   │       │   ├── forecast.rs
│   │       │   └── monte_carlo.rs ← Self-Consistency Checker
│   │       ├── cards/             ← 10 types B01-B10
│   │       │   ├── generator.rs
│   │       │   ├── leech_detector.rs
│   │       │   └── card_manager.rs
│   │       ├── smi/               ← SMI Calculator (5 dimensions)
│   │       │   └── smi_calculator.rs
│   │       ├── teachback/         ← STUDENT AI Teach-Back
│   │       └── mirror/            ← Miroir Cognitif 3 modes
│   │
│   ├── scy-cosmos-kg/             ← Service 5 : COSMOS (data layer graphe)
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs
│   │       ├── graph/             ← Knowledge Graph (graphology + PageRank)
│   │       ├── gap_detection.rs   ← Prérequis manquants
│   │       ├── auto_graph.rs      ← Connexions cosine > 0.75
│   │       ├── trust_system.rs    ← AI Confidence + Double Validation
│   │       ├── lenses.rs          ← 4 lentilles sémantiques
│   │       └── mcp_server.rs      ← MindGraph MCP (D-OPT-043)
│   │
│   ├── scy-brain-rag/             ← Service 6 : BRAIN (RAG + assistant)
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs
│   │       ├── retrieval/         ← Triple Retrieval (Dense+BM25+Graph+RRF)
│   │       │   ├── dense.rs
│   │       │   ├── sparse.rs
│   │       │   ├── graph_traversal.rs
│   │       │   └── rrf_fusion.rs
│   │       ├── professor/         ← Professor AI
│   │       │   ├── socratic_prompter.rs
│   │       │   ├── thread_of_thought.rs
│   │       │   └── fail_safe.rs
│   │       └── web_search.rs      ← Perplexica sidecar integration
│   │
│   ├── scy-imprint/               ← Service 7 : IMPRINT
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs
│   │       ├── cre/               ← 5 crans distillation
│   │       ├── garniture/         ← Tree Renderer ASCII
│   │       └── vocabulaire/       ← Empreinte Vocabulaire
│   │
│   ├── scy-reader/                ← Service 8 : Reader Suite
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs
│   │       ├── deep_links.rs      ← DeepLinkNavigator unifié
│   │       └── annotations.rs
│   │
│   └── scy-shared/                ← Types partagés + utils communs
│       ├── Cargo.toml
│       └── src/
│           ├── lib.rs
│           ├── types.rs           ← User, Goal, Node, Card, Concept...
│           ├── errors.rs          ← AppError enum
│           ├── ids.rs             ← UUID v7 helpers
│           └── config.rs          ← Configuration globale
│
├── src/                           ← Application Rust (point d'entrée)
│   ├── main.rs                    ← Axum server bootstrap
│   ├── api/                       ← REST/GraphQL/SSE routes
│   │   ├── routes.rs
│   │   ├── auth.rs
│   │   ├── ingestion.rs
│   │   ├── ascent.rs
│   │   ├── cosmos.rs
│   │   ├── apex.rs
│   │   ├── brain.rs
│   │   └── reader.rs
│   ├── db/                        ← Database layer
│   │   ├── mod.rs
│   │   ├── postgres.rs            ← Northflank PostgreSQL
│   │   ├── sqlite.rs              ← Desktop SQLite WAL
│   │   └── migrations/            ← Migrations SQL versionnées
│   │       ├── 001_init.sql
│   │       ├── 002_ascent.sql
│   │       └── ...
│   ├── infra/                     ← Infrastructure adapters
│   │   ├── llm_router.rs          ← LlmRouter (DeepSeek/Claude)
│   │   ├── budget_guard.rs        ← BudgetGuard monitoring
│   │   ├── circuit_breaker.rs     ← Circuit Breaker (ARC-001)
│   │   ├── searxng_client.rs      ← SearxNG sidecar
│   │   ├── perplexica_client.rs   ← Perplexica sidecar
│   │   ├── zilliz.rs              ← Zilliz Cloud vectoriel
│   │   └── telemetry.rs           ← OpenTelemetry + Langfuse
│   └── neuro/                     ← Moteur neuroscientifique
│       ├── forge/                 ← FORGE protocol
│       ├── friction/              ← FRICTION mode
│       ├── rif/                   ← Synaptic competition RIF
│       └── engram/                ← Engram decay vitality
│
└── tests/                         ← Tests d'intégration Rust
    ├── integration_test.rs
    └── property_tests.rs          ← proptest (FSRS, CPM, etc.)
```

---

## 3. backend_ts/ — TypeScript (Orchestration Agents)

```
backend_ts/
├── package.json
├── tsconfig.json
├── Dockerfile
│
└── src/
    ├── index.ts                   ← Mastra server bootstrap
    │
    ├── ascent/                    ← ASCENT Pipeline (consommateur)
    │   ├── agents/                ← 18 agents
    │   │   ├── ag01_goal_interpreter.ts
    │   │   ├── ag02_content_scout.ts
    │   │   ├── ag03_dag_architect.ts
    │   │   ├── ag04_learning_conductor.ts
    │   │   ├── ag05_performance_analyzer.ts
    │   │   ├── ag06_adaptive_router.ts
    │   │   ├── ag07_drift_guardian.ts
    │   │   ├── ag08_engagement_amplifier.ts
    │   │   ├── ag09_skill_certifier.ts
    │   │   ├── ag10_chronicle.ts
    │   │   ├── ag11_arena.ts
    │   │   ├── ag12_visual_critic.ts
    │   │   ├── ag13_cognitive_validator.ts
    │   │   ├── ag14_det_suggester.ts
    │   │   ├── ag15_axiomatizer.ts
    │   │   ├── ag16_hitl_proxy_sme.ts
    │   │   ├── ag17_work_mode_detector.ts
    │   │   └── ag18_conscious_agent.ts
    │   ├── qa_committee/          ← 6 agents QA
    │   │   ├── qa01_curriculum.ts
    │   │   ├── qa02_sme.ts
    │   │   ├── qa03_alignment.ts
    │   │   ├── qa04_cognitive_load.ts
    │   │   ├── qa05_validator.ts
    │   │   └── qa06_certifier.ts
    │   ├── retention/             ← 7 protocoles rétention science
    │   ├── schemas/               ← Zod schemas (GoalSchema, DagSchema, etc.)
    │   └── prompts/               ← Prompts système (cacheables)
    │
    ├── normal_mode/               ← Normal Mode (consommateur)
    │   └── orchestrator.ts
    │
    ├── b2b/                       ← B2B Console (consommateur)
    │   ├── dashboard/
    │   └── api/
    │
    ├── automation/                ← Progressive Automation engine
    │   ├── engine.ts              ← AutomationEngine
    │   └── types.ts               ← AutomationLevel, FeatureDomain
    │
    └── wisdom/                    ← Bibliothèque de sagesse + coaching
        ├── engine.ts
        └── principles.ts
```

---

## 4. frontend_react/ — React (UI)

```
frontend_react/
├── package.json
├── vite.config.ts
├── tailwind.config.ts
├── Dockerfile
│
└── src/
    ├── App.tsx                    ← Root app
    ├── main.tsx                   ← Entry point
    │
    ├── components/                ← Composants partagés
    │   ├── CitationMark.tsx       ← Citation [1][2] + preview + deep link
    │   ├── Bibliography.tsx       ← Liste références bas de document
    │   ├── MultiViewBlock.tsx     ← Toggle Math/Code/Sémantique/Graphique
    │   ├── AgentProposalBanner.tsx← Banner propositions agentiques
    │   └── DeepLinkNavigator.ts   ← Navigation deep links unifiée
    │
    ├── cosmos/                    ← COSMOS (26 modes + engines)
    │   ├── CosmosAgentAPI.ts      ← API pour agents (visualize/compare/highlight)
    │   ├── CosmosGraph2D.tsx      ← M02 Knowledge Graph (G6)
    │   ├── CosmosGraphMassive.tsx ← M00/M22 (Cosmograph)
    │   ├── AscentRoadmap.tsx      ← M04 Roadmap (React Flow)
    │   ├── Brain3DGraph.tsx       ← M23 3D (three.js)
    │   ├── modes/                 ← Composants par mode
    │   │   ├── Mode00BaseKnowledge.tsx
    │   │   ├── Mode01LexicalTags.tsx
    │   │   ├── ...
    │   │   └── Mode25KnowledgeCards.tsx
    │   ├── engines/               ← Lazy-loaders par engine
    │   │   ├── g6_loader.ts
    │   │   ├── nivo_loader.ts
    │   │   ├── d3_loader.ts
    │   │   ├── recharts_loader.ts
    │   │   ├── threejs_loader.ts
    │   │   ├── tanstack_loader.ts
    │   │   └── webgpu_loader.ts
    │   └── lenses/                ← Lentilles sémantiques
    │
    ├── apex/                      ← APEX (sessions, cartes, FSRS UI)
    │   ├── SessionView.tsx        ← Session de révision (4 feedbacks)
    │   ├── CardFlip.tsx           ← Retournement de carte
    │   ├── DueForecast.tsx        ← Forecast 30j (Recharts)
    │   └── StatsDashboard.tsx     ← Stats APEX
    │
    ├── dag/                       ← DAG Display (Kanban/Arbre/Gantt/Réseau)
    │   ├── KanbanBoard.tsx
    │   ├── ThematicTree.tsx
    │   ├── GanttChart.tsx
    │   └── WbsPanel.tsx
    │
    ├── brain/                     ← BRAIN (chat, Professor AI)
    │   ├── ChatInterface.tsx
    │   ├── ProfessorAI.tsx
    │   └── onboarding/
    │
    ├── reader/                    ← Reader Suite
    │   ├── FileViewer.tsx
    │   ├── WebViewer.tsx
    │   ├── BookOrchestrator.tsx
    │   ├── PageGallery.tsx
    │   └── renderers/             ← Renderers par format
    │
    ├── chronicle/                 ← CHRONICLE (chat WhatsApp/push)
    │   ├── ChronicleChat.tsx
    │   ├── HealthMonitor.tsx
    │   └── DailyPulse.tsx
    │
    ├── arena/                     ← ARENA (simulations)
    │   ├── ArenaSession.tsx
    │   └── ArenaDebrief.tsx
    │
    ├── settings/                  ← Paramètres
    │   ├── AutomationSettings.tsx ← Progressive Automation
    │   └── ProfileSettings.tsx
    │
    ├── dashboard/                  ← Dashboard accueil
    │   ├── HomeDashboard.tsx
    │   └── QuickActions.tsx
    │
    └── stores/                    ← Zustand stores
        ├── useProjectGraphStore.ts
        ├── useAscentStore.ts
        ├── useApexStore.ts
        └── useCosmosStore.ts
```

---

## 5. docker/ — Déploiement

```
docker/
├── docker-compose.yml             ← Compose complet (dev + prod)
├── docker-compose.dev.yml         ← Override dev (hot reload)
│
├── backend_rs.Dockerfile          ← Rust (zbpack auto-detect)
├── backend_ts.Dockerfile          ← TypeScript Node
├── frontend.Dockerfile            ← React Vite (ou Vercel)
│
├── searxng/
│   └── settings.yml               ← JSON format + Wolfram Alpha enabled
│
└── perplexica/
    └── .env.example               ← Config Perplexica sidecar
```

---

## 6. .env.example — Variables d'Environnement

```env
# Database
DATABASE_URL=postgresql://...@northflank:5432/scy_forge
SQLITE_PATH=./data/scy_forge.db

# Vectoriel
ZILLIZ_URI=https://...
ZILLIZ_TOKEN=...

# LLM Providers
DEEPSEEK_API_KEY=...
ANTHROPIC_API_KEY=...
OPENAI_API_KEY=...

# Search Sidecars
SEARXNG_API_URL=http://searxng:8080
PERPLEXICA_URL=http://perplexica:3001

# OAuth
GOOGLE_CLIENT_ID=...
GITHUB_CLIENT_ID=...

# Infra
NORTHFLANK_API_TOKEN=...
SENTRY_DSN=...
AXIOM_TOKEN=...
LANGFUSE_PUBLIC_KEY=...
LANGFUSE_SECRET_KEY=...

# JWT
JWT_SECRET=...
JWT_ACCESS_TTL=3600
JWT_REFRESH_TTL=2592000
```

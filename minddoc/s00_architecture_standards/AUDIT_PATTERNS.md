# AUDIT_PATTERNS.md — Table de tous les patterns architecturaux

> **Phase 1** — Livrable d'audit documentaire
> **Source** : `MASTER_AGENT_PROMPT_V2.md` §4.1.4
> **Date** : 2026-07-03
> **Auteur** : Architecte Documentaire SCY Forge

---

## 1. Patterns Architecture fondamentale (15 patterns)

| # | Pattern | Catégorie | Description | Source | Statut |
|---|---------|-----------|-------------|--------|--------|
| 1 | Architecture Hexagonale (Ports & Adapters) | Architecture | Séparation hermétique Domain (0 dépendance) / Ports (interfaces) / Adapters (Axum, sqlx, Mastra, UI) | D-001 | ✅ MVP |
| 2 | CQRS Léger | Architecture / Data | Séparation écritures transactionnelles (Commands sqlx) / lectures cache sémantique | D-002 | ✅ MVP |
| 3 | Event Sourcing ciblé | Architecture / Data | Mutations Ingestion + APEX FSRS enregistrées comme flux immuables rejouables | D-003 | ✅ MVP |
| 4 | Monolithe Unifié (Single-Process) | Architecture / Deployment | Node.js/TS + Rust co-locés (IPC/UNIX socket/FFI). Zéro microservice. | D-004 | ✅ MVP |
| 5 | Repository Pattern | Architecture / Data | Traits génériques Rust `Repository<T>` pour PostgreSQL, mock pour tests | D-005 | ✅ MVP |
| 6 | Unit of Work Pattern | Architecture / Data | Transactions atomiques PostgreSQL par Use Case | D-008 | ✅ MVP |
| 7 | Typestate Pattern ASCENT | Architecture / Testing | États Locked→Ready→Studying→Mastered comme types Rust stricts | D-011 | ✅ MVP |
| 8 | Specification Pattern | Architecture / Data | Filtres composables Rust pour sélection cartes APEX | D-016 | ✅ MVP |
| 9 | Reactive Streams + Backpressure | Architecture / Data | Backpressure ingestion massive, tokio async, chunk size 50, 4 workers | D-017 | ✅ MVP |
| 10 | Observability as Code | Architecture / Resilience | Métriques structurées typées, zéro log texte libre. OpenTelemetry + Langfuse. | D-018 | ✅ MVP |
| 11 | DCID (Domain Contract Interface Definition) | Architecture | Core agnostic, SemanticTreeProvider seul pont. Zéro terme métier cyber dans core. | D-019 | ✅ MVP |
| 12 | Domain Pack Contract (9 Providers) | Architecture | 9 providers canoniques. ValidationGuard=binaire, ProofRubric=graduel. | D-020 | ✅ MVP |
| 13 | Domain Pack = Médiateur (pas Curriculum) | Architecture | Le pack structure/aligne. L'entreprise définit le contenu. Si conflit → entreprise gagne. | D-023 | ✅ MVP |
| 14 | Extensibilité par Conception | Architecture | Core = squelette générique. Nouveau domaine = nouveau pack. Zéro réécriture noyau. Surpasse D-001 à D-022. | D-024 | ✅ MVP |
| 15 | COSMOS Agent-as-Canvas | Architecture / UX/UI | Agents créent/lancent/configurent modes COSMOS, pas juste clics utilisateur | PAT-09 | ✅ MVP |

## 2. Patterns ASCENT / Agentic (12 patterns)

| # | Pattern | Catégorie | Description | Source | Statut |
|---|---------|-----------|-------------|--------|--------|
| 16 | Observer Pattern / EventBus | Architecture | Communication asynchrone 18 agents, zéro appel direct | D-010, AP-002 | ✅ MVP |
| 17 | 13 Agents Autonomes (Plan C) | Architecture / AI | 13 agents IN_MVP, découplage responsabilités | AP-001 | ✅ MVP |
| 18 | Déterminisme à 70% | AI/LLM | Règles Rust/TS déterministes, LLM au strict nécessaire | AP-003 | ✅ MVP |
| 19 | SharedContentCache | Architecture / AI | Cache sémantique global (LanceDB), réduit appels LLM 80-99% | AP-005 | ✅ MVP |
| 20 | BudgetGuard (LLM Monitoring) | Architecture / Resilience | Télémétrie coût live, mode économie auto 80%, blocage 100% | AP-006 | ✅ MVP |
| 21 | State-First, Not Agent-First | Architecture / AI | Shared State Schema entre agents. Zéro conversation history brute. | multi-agent Pattern 1 | ✅ MVP |
| 22 | Strict I/O Contracts (Zod + Rust Structs) | Architecture / Testing | Validation stricte transitions agent-to-agent | multi-agent Pattern 2 | ✅ MVP |
| 23 | Parallel Fan-Out Execution | Architecture / Performance | Promise.all / tokio::spawn, réduction temps 80% | multi-agent Pattern 4 | ✅ MVP |
| 24 | Progressive Disclosure of Context (LOD) | Architecture / AI | 3 niveaux de contexte par agent | multi-agent Pattern 5 | ✅ MVP |
| 25 | MCP Access Isolation | Security / AI | Permissions verrouillées au niveau MCP, pas prompt | multi-agent Pattern 7 | ✅ MVP |
| 26 | Adversarial Prompt Guardrails | Security / AI | Pré-filtrage prompt-injection avant exécution | multi-agent Pattern 9 | ✅ MVP |
| 27 | Generator-Evaluator Model | Testing / AI | Génération ≠ Évaluation. Jamais le même agent. | multi-agent Pattern 13 | ✅ MVP |

## 3. Patterns Data / Persistence (14 patterns)

| # | Pattern | Catégorie | Description | Source | Statut |
|---|---------|-----------|-------------|--------|--------|
| 28 | GraphQL + DataLoader | API / Data | Batch N+1 queries, cache temporaire relations | D-006 | ✅ MVP |
| 29 | Temporal Queries PostgreSQL | Data | Historiques temporels, replay état à date passée | D-007 | V1 |
| 30 | Outbox Pattern | Data / Resilience | Écriture BDD + Event atomiques même transaction | ARC-007 | ✅ MVP |
| 31 | Dead Letter Queue (DLQ) | Resilience / Data | Events échoués → DLQ manuelle, zéro perte | ARC-004 | ✅ MVP |
| 32 | Materialized Views PG | Data | 4 vues matérialisées, -80% temps requêtes analytics | ARC-008 | ✅ MVP |
| 33 | Offline-First Local Sync Queue | Data / Resilience | IndexedDB local + synchro asynchrone, 100% offline | D-OPT-026 | ✅ MVP |
| 34 | Persistent IndexedDB WAL | Data / Resilience | WAL persistant, auto-réparation crash | D-OPT-031 | ✅ MVP |
| 35 | Seed Traceability (PROV + Bitemporal) | Data / AI | W3C PROV-DM + bitemporel, lignée immuable | D-022 | ✅ MVP |
| 36 | PackConfig Cascade Resolution | Data / Architecture | 3 niveaux : Learner → Organization → DomainPack | D-020, DAT-02 | ✅ MVP |
| 37 | Confidence = Source de vérité | Data | mastery_score/status dérivés de confidence (0.0-1.0) | PAT-02 | ✅ MVP |
| 38 | 3 Semantic Tree Instances | Data | DomainPack, Organization, Learner — même type | PAT-01 | ✅ MVP |
| 39 | Polars + DuckDB Analytics | Data | Cohort analytics in-memory, export Parquet | D-013 | V1 |
| 40 | Coverage Ratio 80/20 Leaf Grain | Data | coverage_ratio = covered_leaves / total_leaves | WP12 | ✅ MVP |
| 41 | Dual-Storage Auto-Save | Data / UX | localStorage + PostgreSQL, debounced 2s, LWW | UX spec | ✅ MVP |

## 4. Patterns Resilience / SRE (16 patterns)

| # | Pattern | Catégorie | Description | Source | Statut |
|---|---------|-----------|-------------|--------|--------|
| 42 | Circuit Breaker 3 états | Resilience | Closed→Open (5 échecs)→Half-Open. Per provider LLM. | ARC-001 | ✅ MVP |
| 43 | Idempotency Keys UUID v7 | Resilience / Data | Clés uniques 24h TTL, zéro duplication | ARC-002 | ✅ MVP |
| 44 | Timeout 3 Niveaux | Resilience | L1: 5s (LLM), L2: 30s (BDD), L3: 10s/60s (HTTP) | ARC-003 | ✅ MVP |
| 45 | Bulkhead Sémaphores | Resilience | Isolation ressources par domaine (Ingestion, APEX, COSMOS...) | ARC-005 | ✅ MVP |
| 46 | Graceful Shutdown 5 phases | Resilience / Deployment | Drain→Flush→Persist→Close→Exit | ARC-006 | ✅ MVP |
| 47 | Health Checks 3 niveaux | Resilience / API | /live (liveness), /ready (readiness), /deep (dépendances) | ARC-009 | ✅ MVP |
| 48 | Feature Flags avec RolloutStrategy | Deployment / Resilience | Déploiement progressif 5%→25%→100% | ARC-010 | V1 |
| 49 | Blue/Green Deployment | Deployment / Resilience | Rollback <2min, zéro downtime | ARC-011 | V1 |
| 50 | Fail-Safe Gate Anti-Avalanche | Resilience / AI | Seuil vitalité 25/100, amortissement RIF 90% | D-OPT-010 | ✅ MVP |
| 51 | Lazy Physics Suspension | Resilience / Performance | Verlet suspendu si vitesse <0.05px/frame, CPU→0% | D-OPT-018 | ✅ MVP |
| 52 | Quadtree Object Pooling | Resilience / Performance | Pool statique pré-alloué, zéro GC pause | D-OPT-019 | ✅ MVP |
| 53 | EventValidationGate (EIG) | Resilience / Security | 3 règles : requires_reply, owner_mismatch, rate_limit | WP03 | ✅ MVP |
| 54 | Local Telemetry Debouncing | Resilience / Data | Batch synaptic vitality updates sur 5s | D-OPT-020 | ✅ MVP |
| 55 | Offline-First Resilience | Resilience / Data | 100% offline PWA, IndexedDB WAL, Service Worker | D-OPT-026/031 | ✅ MVP |
| 56 | Bulkhead & Fault Isolation | Resilience | Isolation hermetique domaines, échec ingestion ne gèle pas APEX | multi-agent Pattern 17 | ✅ MVP |
| 57 | Trajectory Logging (Full Audit Trail) | Resilience / Security | Logs structurés Northflank, zéro texte libre | multi-agent Pattern 18 | ✅ MVP |

## 5. Patterns Testing / QA (10 patterns)

| # | Pattern | Catégorie | Description | Source | Statut |
|---|---------|-----------|-------------|--------|--------|
| 58 | Property-Based Testing (proptest) | Testing | Millions combinaisons FSRS, validation zéro NaN | ARC-012 | ✅ MVP |
| 59 | ASCENT-QA Validation Board | Testing / AI | 6 agents audit async, PQS ≥88/100 avant certification | D-OPT-032 | ✅ MVP |
| 60 | DRACO-Based Research Evaluation | Testing / AI | Perplexity DRACO benchmark, véracité/profondeur/style | D-OPT-033 | V1 |
| 61 | Metacognitive Self-Learning Loop | Testing / AI | Hermes Agent, PII stripping, closed-loop compétences | D-OPT-034 | V1 |
| 62 | SME HITL-Proxy Agent | Testing / AI | AGENT-16 simule expert sceptique, audit rigueur scientifique | D-OPT-036 | V1 |
| 63 | Dual Validation Seal | Testing / AI | AI consensus ≥85% + humain ≥90% avant certification | PAT-10 | V1 |
| 64 | Spec-Driven Development 4-Doc Kit | Testing / AI | spec + plan + tasks + tests, zéro code avant docs | SDLC spec | ✅ MVP |
| 65 | WHEN-THEN-AND Behavioral Scenarios | Testing | Format Gherkin adapté Markdown | SDLC spec | ✅ MVP |
| 66 | Constructive Alignment (Biggs) | Testing / AI | Alignement objectifs sémantiques ↔ questions SurveyJS | multi-agent Pattern 14 | V1 |
| 67 | Chaos Engineering (4 scénarios) | Testing / Resilience | Injection pannes planifiée (PostgreSQL, Zilliz, API) | ARC-013 | Phase 3 |

## 6. Patterns AI / LLM (48 patterns)

| # | Pattern | Catégorie | Description | Source | Statut |
|---|---------|-----------|-------------|--------|--------|
| 68 | GFE 3ème Pilier | AI/LLM | Pollination → Seed → Germination, savoir privé → connaissance neuve | D-021 | ✅ MVP (observatoire) |
| 69 | 4 Conditions Fertilité L1-L4 | AI/LLM | Distance, Pont logique, Non-existence, Alignement HELM | GFE-01 | ✅ MVP |
| 70 | Seed Anatomy 5 composants | AI/LLM | Proposition, Parenté, Arbre potentiel, Viability, Provenance | GFE-02 | ✅ MVP |
| 71 | 3 Mécanismes Émergence endogène | AI/LLM | SME (structure-mapping), Blending (Fauconnier-Turner), Link Prediction | GFE-03 | ✅ MVP |
| 72 | Seed State Machine | AI/LLM / Data | POLLINATED → VIABLE / DORMANT → GERMINATING | GFE-04 | ✅ MVP |
| 73 | Vision Helm | AI/LLM / Data | Vecteur k-dim + graphe objectifs, align() = cosinus | GFE-05 | ✅ MVP |
| 74 | Loop Engineering 4 boucles | AI/LLM (Governance) | Micro→Meso→Macro→Outcome, sortie déterministe | D-025 | ✅ MVP |
| 75 | Cognitive Runtime Policies 5 | AI/LLM (Governance) | OutputPressure, Friction, Consolidation, Sparring, Priority | D-026 | ✅ MVP |
| 76 | TriggerR2 4 kinds | AI/LLM (Governance) | Reschedule, Immediate, Sparring, Handoff | LOOP-02 | ✅ MVP |
| 77 | Dynamic Model Routing | AI/LLM / Resilience | Modèles légers pour routing, dense pour sémantique | multi-agent Pattern 10 | V1 |
| 78 | Prompt Caching Strategy | AI/LLM / Resilience | System prompts statiques en tête, données dynamiques en queue | multi-agent Pattern 11 | V1 |
| 79 | Lazy Evaluation & State Caching | Resilience / Architecture | Cache intermediate states, resume from last valid checkpoint | multi-agent Pattern 6 | MVP+ |
| 80 | Bounded Loop + BudgetGuard | AI/LLM / Resilience | MAX_LLM_CALLS=10, BudgetGuard coupe si risque infinite loop | multi-agent Pattern 12 | MVP+ |
| 81 | Meta-Axiomatization | AI/LLM / Testing | AXIOMATIZER cycle 7j, synthèse traces → Fundamental Laws | multi-agent Pattern 19 | MVP+ |
| 82 | 3-Mode Orchestration (ASCENT/Normal/B2B) | AI/LLM / Architecture | ASCENT=automated, Normal=direct, B2B=SOP→curriculum | PAT-07 | ✅ MVP |
| 83 | Progressive Automation — Override toujours dispo | AI/LLM / UX | Contrôle manuel TOUJOURS visible, jamais caché | PAT-07 | ✅ MVP |
| 84 | Humility Charter | AI/LLM (Governance) | "Pas de souci." Adaptation sans insister, override counter | PAT-08 | ✅ MVP |
| 85 | 2-Click Rule | UX/UI / AI | ≤2 interactions pour toute action | PAT-07 | ✅ MVP |
| 86 | Socratic Progressive Prompting | AI/LLM | Max 2 paragraphes + question ciblée, -40% tokens | D-OPT-022 | ✅ MVP |
| 87 | Dunning-Kruger Calibration | AI/LLM / Testing | Confiance haute + recall bas → Teach-Back immédiat | D-OPT-054 | ✅ MVP |
| 88 | Tiny Habit Re-Entry Protocol | AI/LLM / UX | Absence >3j → Mode Minimal 3 cartes prioritaires | D-OPT-055 | V1 |
| 89 | STUDENT-AI Teach-Back Diagnostics | AI/LLM / Testing | Score <40% → diagnostic sémantique/logique → remédiation | D-OPT-050 | ✅ MVP |
| 90 | STUDENT-AI Socratic Teach-Back | AI/LLM | Hagah, rôle socratique calibré SMI, Bloom 3 | D-OPT-056 | V1 |
| 91 | FSRS Stability Gate before ARENA | AI/LLM / Testing | Stabilité ≥3.0j requis avant simulation ARENA | D-OPT-051 | ✅ MVP |
| 92 | Leech-Blocking Cran-5 IMPRINT | AI/LLM | Cartes difficiles → écriture manuscrite IMPRINT (50-65 mots) | D-OPT-052 | V1 |
| 93 | Boost Sommeil Chronicle | AI/LLM | Micro-révision 2min avant coucher, consolidation hippocampale | D-OPT-048 | V1 |
| 94 | Cross-Domain Discovery | AI/LLM / Data | 15% probabilité/session, lien cross-domaine auto | agentic vision | Post-MVP |
| 95 | Dream Session (Hypnagogic) | AI/LLM | CHRONICLE 22:30, 30s review, consolidation nocturne | agentic vision | Post-MVP |
| 96 | ARENA Full-AI Simulated World | AI/LLM | Monde simulé peuplé IA, HSM Persona, 20-30min session | agentic vision | V1 |
| 97 | HSM Persona (Hierarchical State Machine) | AI/LLM / Architecture | 5 états psy (MÉFIANT→EN COLÈRE), mood score après CHAQUE message | agentic vision | V1 |
| 98 | Proof of Skill ARENA | AI/LLM / Testing | Theory + Practice (SMI≥70 + ARENA≥70), badge distinct | agentic vision | V1 |
| 99 | Voice-First Learning | AI/LLM / UX | 100% vocal hands-free, CHRONICLE sélectionne, APEX TTS | agentic vision | Post-MVP |
| 100 | Real-World Project Generator | AI/LLM / Testing | Capstone contextualisé, LLM-evaluated → Proof of Skill | agentic vision | Post-MVP |
| 101 | Hybrid Scientific Verification | AI/LLM / Testing | Niveau1: SageMath local ($0) + Niveau2: Wolfram Alpha cloud | D-OPT-038 | V1 |
| 102 | SCY-AXIOM Synthesis Engine | AI/LLM / Architecture | AXIOMATIZER (AGENT-15), traces cohorte → Fundamental Laws | D-OPT-035 | V1 |
| 103 | Metacognitive Self-Learning Loop | AI/LLM / Testing | Hermes Agent, PII stripping, closed-loop procedural skills | D-OPT-034 | V1 |
| 104 | 4-Tier LLM Segregation | Security / AI | Free=DeepSeek only, Lite=+Sonnet, Pro=+Opus DAG, Ultra=Opus all | pricing spec | ✅ MVP |
| 105 | Deterministic PII Stripping | Security / AI | Regex + NER avant écriture storage, GDPR | multi-agent Pattern 8 | ✅ MVP |
| 106 | Adversarial RAG Context Guardrail | Security / AI | Filtrage RAG chunks prompt-injection avant APEX-AGENT | D-OPT-025 | ✅ MVP |

## 7. Patterns Security (12 patterns)

| # | Pattern | Catégorie | Description | Source | Statut |
|---|---------|-----------|-------------|--------|--------|
| 107 | PostgreSQL RLS Multi-Tenant | Security / Data | RLS par user_id/organization_id, violation = build stop | infra spec | ✅ MVP |
| 108 | JWT + OAuth Authentication | Security / API | JWT 1h + refresh 30j httpOnly + OAuth Google/GitHub | infra spec | ✅ MVP |
| 109 | TLS 1.3 + HSTS + CSP | Security / Deployment | HTTP/WSS sécurisé TLS 1.3, HSTS, CSP headers | infra spec | ✅ MVP |
| 110 | OS Keychain AES-256 | Security | Desktop credentials stockés OS keychain (keyring 2.0) | infra spec | ✅ MVP |
| 111 | Deterministic Input Validation | Security / Testing | serde (Rust) + Zod (TS), zéro entrée non validée | infra spec | ✅ MVP |
| 112 | SQL Injection Prevention | Security / Data | Parameterized queries ONLY, string interpolation FORBIDDEN | infra spec | ✅ MVP |
| 113 | GDPR Export + Delete + Audit | Security / Data | Export complet, Delete Account cascade, audit trail immuable | infra spec | ✅ MVP |
| 114 | EU AI Act Traceability | Security / AI | scy_ai_decisions table, droit à l'explication | infra spec | ✅ MVP |
| 115 | Anti-Corruption Layer (ARC-015) | Security / Architecture | APIs tierces isolées, domaine protégé model leakage | ARC-015 | ✅ MVP |
| 116 | Nango Integration Hub | Architecture / API / Security | Self-hosted, 800+ templates, MCP built-in, OAuth sécurisé | integration hub | ✅ MVP |
| 117 | White-Label OAuth Connect UI | Security / UX | OAuth branding SCY Forge, pas Nango | integration hub | ✅ MVP |
| 118 | Tier-Based Rate Limiting | Security / Resilience | Free=10/h, Premium=100/h ingestor calls | infra spec | ✅ MVP |

## 8. Patterns Deployment (10 patterns)

| # | Pattern | Catégorie | Description | Source | Statut |
|---|---------|-----------|-------------|--------|--------|
| 119 | ISR Dashboard | Deployment | Régénération statique incrémentale, <10ms | D-015 | ✅ MVP |
| 120 | Electron Desktop + Rust Sidecar | Deployment / Architecture | Electron 33 + Rust sidecar + SQLite WAL offline-first | infra spec | ✅ MVP |
| 121 | Platform-Aware Build (3 targets) | Deployment / Architecture | Desktop (Electron+Rust), Web (React/Vercel/ISR), Mobile (PWA) | infra spec | ✅ MVP |
| 122 | Dual Deployment Profiles | Deployment / Security | MSSP/MDR vs SOC Interne Régulé, même Semantic Tree | DAT-01 | ✅ MVP |
| 123 | Profile-Aware 4 Providers | Architecture / Data | ProofRubric, ValidationGuard, Corpus, RoleTaxonomy adaptent par profil | DAT-02 | ✅ MVP |
| 124 | WASM Edge Computation | Deployment / Architecture | Rust→WASM in-browser, FSRS+petgraph, 0$ serveur | D-OPT-001 (WASM spec) | MVP+ |
| 125 | WASM Tool Sandboxing | Security / Deployment | Scripts tiers isolés WASM, sécurité runtime absolue | WASM spec | MVP+ |
| 126 | WASM 100% Code Unification | Deployment / Architecture | Cloud et Desktop partagent 100% code Rust via WASM | WASM spec | MVP+ |
| 127 | WASM 100% Offline PWA | Deployment / Architecture | Electron remplacé par WASM+PWA, économie licence | WASM spec | MVP+ |
| 128 | 4-Tier LLM Segregation by Pricing | Deployment / AI | Lock-down modèle par tier, marge >89% sur paid tiers | pricing spec | ✅ MVP |

## 9. Patterns UX/UI (8 patterns)

| # | Pattern | Catégorie | Description | Source | Statut |
|---|---------|-----------|-------------|--------|--------|
| 129 | WCAG 2.1 AA Accessibility | UX/UI / Security | Keyboard 100%, ARIA, contrast ≥4.5:1, focus ring 2px | UX spec | ✅ MVP |
| 130 | Hybrid Search Global (Tantivy + pgvector) | API / Data / UX | Tantivy full-text + pgvector semantic, 300ms autocomplete | UX spec | ✅ MVP |
| 131 | Hierarchical Tags 3-Level | Data / UX | Tech > Web > React, ML suggestion, AND/OR, drag&drop | UX spec | ✅ MVP |
| 132 | Hippocampal Spatial Zoom (COSMOS Mode 22) | AI/LLM / UX | Navigation spatiale micro→global, stimulation cellules lieu | D-OPT-053 | V1 |
| 133 | Progressive Rendering 4 Phases | UX/UI / Architecture | WebGL→Hubs→Cards→Stabilisation, zéro spinner | FLY-019 | ✅ MVP |
| 134 | Learning-Aware Graph (SMI aura) | UX/UI / Data | Aura électro-lumineuse nœuds selon SMI | FLY-020 | ✅ MVP |
| 135 | Source-Linked Nodes | UX/UI / Data | Lien direct vers document source (Reader Suite) | FLY-021 | ✅ MVP |
| 136 | Dual Validation Seal UX | UX/UI / Testing | Affichage dual gate AI≥85% + humain≥90% | PAT-10 | V1 |

## 10. Patterns spécifiques à des modules (8 patterns)

| # | Pattern | Catégorie | Description | Source | Statut |
|---|---------|-----------|-------------|--------|--------|
| 137 | 3-Mode Orchestration (ASCENT / Normal / B2B) | AI/LLM | 3 modes selon intent: automated, direct, SOP→curriculum | PAT-07 | ✅ MVP |
| 138 | PIVOTIQ Multi-Source Reconciliation | AI/LLM / Data | Réconciliation contradictions multi-sources | PAT-11 | Post-MVP |
| 139 | NotebookLM Exclusion | Architecture / API | NotebookLM exclu (pas API publique), BRAIN = alternative native | integration hub | Post-MVP |
| 140 | Ascendant 8 Cross-Service Transversal | Architecture | 8 services transverses (ST, APEX, COSMOS, BRAIN, INGESTION, READER, IMPRINT, EventBus) | PAT-04 | ✅ MVP |
| 141 | Services-Don't-Know-Consumers Rule | Architecture | scy-pack-ingestion ne connaît pas ASCENT. Services-only contracts. | PAT-06 | ✅ MVP |
| 142 | Epics 8 (Beachhead v2.0 + GFE) | Architecture | Epic 1-8 couvrant Infrastructure, Pack Ingestion, ST/ASCENT, COSMOS, Manager, Tactical AI, Onboarding, GFE | scy_epics_and_stories.md | ✅ MVP |
| 143 | 8 Beachhead Personas SOC | Architecture | P-SOC1, P-SOC2, P-DFIR, P-SEL, P-RSSI, P-JUNIOR, P-ITM | DCID-02 | ✅ MVP |
| 144 | LiveKit Voice Architecture A+B | API / AI/LLM | Arch A: OpenAI Realtime (ARENA/CHRONICLE). Arch B: STT+LLM+TTS (BRAIN/COSMOS) | LiveKit spec | Post-MVP |

## 11. Statistiques et synthèse

| Catégorie | Count | IN_MVP | Post-MVP / V1 / Phase 3 |
|-----------|-------|--------|------------------------|
| Architecture fondamentale | 15 | 13 | 2 (D-009 NEURON-CHAINS, D-014 SAGA Phase3) |
| ASCENT / Agentic | 12 | 12 | 0 |
| Data / Persistence | 14 | 12 | 2 (V1: D-007, D-013) |
| Resilience / SRE | 16 | 14 | 2 (Phase3: ARC-013) |
| Testing / QA | 10 | 6 | 4 (V1+Post-MVP) |
| AI / LLM | 39 | 22 | 17 (V1 + Post-MVP) |
| Security | 12 | 12 | 0 |
| Deployment | 10 | 7 | 3 (MVP+) |
| UX/UI | 8 | 5 | 3 (V1 + Post-MVP) |
| Module-specific | 8 | 5 | 3 (Post-MVP) |
| **TOTAL** | **144** | **98** | **46** |

> **Note** : Certains patterns apparaissent sous plusieurs IDs (ex: Circuit Breaker = ARC-001 + Pattern Resilience #42). Ce document liste chaque pattern UNE fois par catégorie, avec référence cross-ID.

---

*AUDIT_PATTERNS.md — SCY Forge — V1.0 — 2026-07-03*

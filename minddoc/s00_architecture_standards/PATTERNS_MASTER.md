# patterns_master.md — Tous les patterns architecturaux unifiés

> **Phase 2** — Livrable d'unification
> **Source** : Consolidation de tous les documents d'architecture SCY Forge
> **Date** : 2026-07-03
> **Auteur** : Architecte Documentaire SCY Forge
> **Règle** : Ce fichier est la référence unique. Toute implémentation doit respecter les patterns listés ici.

---

## Sommaire

1. [Architecture fondamentale](#1-architecture-fondamentale) — 15 patterns
2. [ASCENT / Agentic](#2-ascent--agentic) — 12 patterns
3. [Data / Persistence](#3-data--persistence) — 14 patterns
4. [Resilience / SRE](#4-resilience--sre) — 16 patterns
5. [Testing / QA](#5-testing--qa) — 10 patterns
6. [AI / LLM](#6-ai--llm) — 48 patterns
7. [Security](#7-security) — 12 patterns
8. [Deployment](#8-deployment) — 10 patterns
9. [UX/UI](#9-uxui) — 8 patterns
10. [Module-specific](#10-module-specific) — 8 patterns
11. [Index par décision d'architecture](#11-index-par-décision-darchitecture)
12. [Règles d'or — quick reference](#12-règles-dor--quick-reference)

---

## 1. Architecture fondamentale (15 patterns)

| # | Pattern | ID Décision | Description | Priorité |
|---|---------|------------|-------------|----------|
| 1 | Architecture Hexagonale | D-001 | Domain 0 dépendance / Ports interfaces / Adapters implémentations | MVP |
| 2 | CQRS Léger | D-002 | Écritures sqlx / lectures cache sémantique | MVP |
| 3 | Event Sourcing ciblé | D-003 | Flux immuables Ingestion + APEX FSRS | MVP |
| 4 | Monolithe Unifié | D-004 | Node.js/TS + Rust co-locés. Zéro microservice | MVP |
| 5 | Repository Pattern | D-005 | `Repository<T>` Rust. Mock pour tests | MVP |
| 6 | Unit of Work | D-008 | Transactions atomiques par Use Case | MVP |
| 7 | Typestate Pattern | D-011 | États type-safe Rust. Invalid transition = compile error | MVP |
| 8 | Specification Pattern | D-016 | Filtres composables Rust | MVP |
| 9 | Reactive Streams + Backpressure | D-017 | tokio async, chunk 50, 4 workers | MVP |
| 10 | Observability as Code | D-018 | Métriques structurées typées. Zéro log libre | MVP |
| 11 | DCID (Domain Contract Interface Definition) | D-019 | Core agnostic, SemanticTreeProvider seul pont | MVP |
| 12 | Domain Pack Contract — 9 Providers | D-020 | SemanticTreeProvider (PRIMARY) + 8 optionnels | MVP |
| 13 | Domain Pack = Médiateur | D-023 | Pack structure/aligne, entreprise définit contenu | MVP |
| 14 | Extensibilité par Conception | D-024 | Surpasse D-001 à D-022. Nouveau domaine = nouveau pack | MVP (RÈGLE SUPRÊME) |
| 15 | COSMOS Agent-as-Canvas | PAT-09 | Agents créent/lancent/configurent modes COSMOS | MVP |

---

## 2. ASCENT / Agentic (12 patterns)

| # | Pattern | ID Décision | Description | Priorité |
|---|---------|------------|-------------|----------|
| 16 | Observer / EventBus | D-010, AP-002 | Pub/sub async. Zéro appel direct | MVP |
| 17 | 18 Agents Autonomes Plan C | AP-001 | Découplage responsabilités. 13 IN_MVP + 5 POST_MVP | MVP |
| 18 | Déterminisme à 70% | AP-003 | Règles Rust/TS déterministes. LLM au strict nécessaire | MVP |
| 19 | SharedContentCache | AP-005 | Cache sémantique global LanceDB. -80-99% LLM calls | MVP |
| 20 | BudgetGuard | AP-006 | Télémétrie coût live. Mode économie auto | MVP |
| 21 | State-First, Not Agent-First | multi-agent P1 | Shared State Schema entre agents. Zéro raw history | MVP |
| 22 | Strict I/O Contracts | multi-agent P2 | Zod (TS) + Rust structs. Validation stricte transitions | MVP |
| 23 | Parallel Fan-Out Execution | multi-agent P4 | Promise.all / tokio::spawn. -80% temps | MVP |
| 24 | Progressive Disclosure of Context (LOD) | multi-agent P5 | 3 niveaux de contexte par agent | MVP |
| 25 | MCP Access Isolation | multi-agent P7 | Permissions verrouillées MCP, pas prompt | MVP |
| 26 | Adversarial Prompt Guardrails | multi-agent P9 | Pré-filtrage prompt-injection | MVP |
| 27 | Generator-Evaluator Model | multi-agent P13 | Génération ≠ Évaluation. Jamais même agent | MVP |

---

## 3. Data / Persistence (14 patterns)

| # | Pattern | ID Décision | Description | Priorité |
|---|---------|------------|-------------|----------|
| 28 | GraphQL + DataLoader | D-006 | Batch N+1 queries | MVP |
| 29 | Temporal Queries PostgreSQL | D-007 | Replay état à date passée | V1 |
| 30 | Outbox Pattern | ARC-007 | Écriture BDD + Event atomiques même transaction | MVP |
| 31 | Dead Letter Queue | ARC-004 | Events échoués → DLQ manuelle | MVP |
| 32 | Materialized Views PG | ARC-008 | 4 vues matérialisées. -80% temps requêtes | MVP |
| 33 | Offline-First Local Sync Queue | D-OPT-026 | IndexedDB + synchro asynchrone | MVP |
| 34 | Persistent IndexedDB WAL | D-OPT-031 | WAL persistant. Auto-réparation crash | MVP |
| 35 | Seed Traceability (PROV + Bitemporal) | D-022 | W3C PROV-DM + bitemporel. Lignée immuable | MVP |
| 36 | PackConfig Cascade Resolution | D-020 | Learner → Organization → DomainPack | MVP |
| 37 | Confidence = Source de vérité | PAT-02 | mastery_score/status dérivés de confidence (0.0-1.0) | MVP |
| 38 | 3 Semantic Tree Instances | PAT-01 | DomainPack, Organization, Learner — même type | MVP |
| 39 | Polars + DuckDB Analytics | D-013 | Cohort analytics in-memory. Export Parquet | V1 |
| 40 | Coverage Ratio 80/20 | WP12 | covered_leaves / total_leaves | MVP |
| 41 | Dual-Storage Auto-Save | UX spec | localStorage + PostgreSQL. Debounced 2s. LWW | MVP |

---

## 4. Resilience / SRE (16 patterns)

| # | Pattern | ID Décision | Description | Priorité |
|---|---------|------------|-------------|----------|
| 42 | Circuit Breaker 3 états | ARC-001 | Per LLM provider. Closed→Open→Half-Open | MVP |
| 43 | Idempotency Keys UUID v7 | ARC-002 | 24h TTL. Zéro duplication | MVP |
| 44 | Timeout 3 Niveaux | ARC-003 | L1:5s / L2:30s / L3:10s-60s | MVP |
| 45 | Bulkhead Sémaphores | ARC-005 | 6 domaines isolés. Échec ingestion ne gèle pas APEX | MVP |
| 46 | Graceful Shutdown 5 phases | ARC-006 | Drain→Flush→Persist→Close→Exit | MVP |
| 47 | Health Checks 3 niveaux | ARC-009 | /live /ready /deep | MVP |
| 48 | Feature Flags | ARC-010 | Rollout 5%→25%→100% | V1 |
| 49 | Blue/Green Deployment | ARC-011 | Rollback <2min | V1 |
| 50 | Fail-Safe Gate Anti-Avalanche | D-OPT-010 | Seuil 25/100. Amortissement RIF 90% | MVP |
| 51 | Lazy Physics Suspension | D-OPT-018 | Verlet si vitesse <0.05px/frame | MVP |
| 52 | Quadtree Object Pooling | D-OPT-019 | Pool statique. Zéro GC | MVP |
| 53 | EventValidationGate (EIG) | WP03 | requires_reply, owner, rate_limit | MVP |
| 54 | Local Telemetry Debouncing | D-OPT-020 | Batch synaptic updates sur 5s | MVP |
| 55 | Offline-First Resilience | D-OPT-026/031 | 100% offline. IndexedDB WAL. Service Worker | MVP |
| 56 | Bulkhead & Fault Isolation | P17 | Isolation hermétique domaines | MVP |
| 57 | Trajectory Logging | P18 | Logs structurés Northflank. Zéro texte libre | MVP |

---

## 5. Testing / QA (10 patterns)

| # | Pattern | ID Décision | Description | Priorité |
|---|---------|------------|-------------|----------|
| 58 | Property-Based Testing | ARC-012 | proptest millions combinaisons FSRS | MVP |
| 59 | ASCENT-QA Validation Board | D-OPT-032 | 6 agents audit async. PQS ≥88/100 | MVP |
| 60 | DRACO Research Evaluation | D-OPT-033 | Perplexity DRACO benchmark | V1 |
| 61 | Metacognitive Self-Learning | D-OPT-034 | Hermes Agent. PII stripping | V1 |
| 62 | SME HITL-Proxy Agent | D-OPT-036 | AGENT-16 simule expert sceptique | V1 |
| 63 | Dual Validation Seal | PAT-10 | AI ≥85% + humain ≥90% | V1 |
| 64 | Spec-Driven Development 4-Doc Kit | SDLC | spec + plan + tasks + tests | MVP |
| 65 | WHEN-THEN-AND Scenarios | SDLC | Format Gherkin adapté Markdown | MVP |
| 66 | Constructive Alignment | P14 | Objectifs ↔ questions SurveyJS | V1 |
| 67 | Chaos Engineering | ARC-013 | 4 scénarios pannes planifiés | Phase 3 |

---

## 6. AI / LLM (48 patterns)

| # | Pattern | ID Décision | Description | Priorité |
|---|---------|------------|-------------|----------|
| 68 | GFE 3ème Pilier | D-021 | Pollination → Seed → Germination | MVP (obs) |
| 69 | 4 Fertility Conditions L1-L4 | GFE-01 | Distance, Pont, Non-existence, Alignement HELM | MVP |
| 70 | Seed Anatomy 5 components | GFE-02 | Proposition, Parenté, Arbre potentiel, Viability, Provenance | MVP |
| 71 | 3 Mécanismes Émergence endogène | GFE-03 | SME, Blending, Link Prediction | MVP |
| 72 | Seed State Machine | GFE-04 | POLLINATED → VIABLE/DORMANT → GERMINATING | MVP |
| 73 | Vision Helm | GFE-05 | Vecteur k-dim + graphe objectifs. align() = cosinus | MVP |
| 74 | Loop Engineering 4 boucles | D-025 | Micro→Meso→Macro→Outcome | MVP |
| 75 | Cognitive Runtime Policies 5 | D-026 | OutputPressure, Friction, Consolidation, Sparring, Priority | MVP |
| 76 | TriggerR2 4 kinds | LOOP-02 | Reschedule, Immediate, Sparring, Handoff | MVP |
| 77 | Dynamic Model Routing | P10 | Léger pour routing, dense pour sémantique | V1 |
| 78 | Prompt Caching Strategy | P11 | System prompts statiques. -90% input cost | V1 |
| 79 | Lazy Evaluation & State Caching | P6 | Cache intermediate states. Resume last valid checkpoint | MVP+ |
| 80 | Bounded Loop + BudgetGuard | P12 | MAX_LLM_CALLS=10. BudgetGuard coupe infinite loop | MVP+ |
| 81 | Meta-Axiomatization | P19 | AXIOMATIZER cycle 7j. Fundamental Laws. Purge micro-skills | MVP+ |
| 82 | 3-Mode Orchestration | PAT-07 | ASCENT=auto, Normal=direct, B2B=SOP→curriculum | MVP |
| 83 | Progressive Automation | PAT-07 | Contrôle manuel TOUJOURS visible | MVP |
| 84 | Humility Charter | PAT-08 | "Pas de souci." Adaptation sans insister | MVP |
| 85 | 2-Click Rule | PAT-07 | ≤2 interactions pour toute action | MVP |
| 86 | Socratic Progressive Prompting | D-OPT-022 | Max 2 paragraphes + question ciblée | MVP |
| 87 | Dunning-Kruger Calibration | D-OPT-054 | Confiance haute + recall bas → Teach-Back | MVP |
| 88 | Tiny Habit Re-Entry | D-OPT-055 | Absence >3j → Mode Minimal 3 cartes | V1 |
| 89 | STUDENT-AI Teach-Back Diagnostics | D-OPT-050 | Score <40% → diagnostic → remédiation B06 | MVP |
| 90 | STUDENT-AI Socratic Teach-Back | D-OPT-056 | Hagah. Rôle socratique SMI. Bloom 3 | V1 |
| 91 | FSRS Stability Gate | D-OPT-051 | Stabilité ≥3.0j avant ARENA | MVP |
| 92 | Leech-Blocking Cran-5 IMPRINT | D-OPT-052 | Leech → IMPRINT manuscrite 50-65 mots | Post-MVP |
| 93 | Boost Sommeil Chronicle | D-OPT-048 | Micro-révision 2min coucher | Post-MVP |
| 94 | Cross-Domain Discovery | agentic vision | 15% probabilité. Lien cross-domaine auto | Post-MVP |
| 95 | Dream Session Hypnagogic | agentic vision | CHRONICLE 22:30. 30s review | Post-MVP |
| 96 | ARENA Full-AI Simulated World | agentic vision | Monde simulé IA. HSM Persona. 20-30min | V1 |
| 97 | HSM Persona | agentic vision | 5 états psy. Mood score après CHAQUE message | V1 |
| 98 | Proof of Skill ARENA | agentic vision | SMI≥70 + ARENA≥70. Badge distinct | V1 |
| 99 | Voice-First Learning | agentic vision | 100% vocal. CHRONICLE + APEX TTS | Post-MVP |
| 100 | Real-World Project Generator | agentic vision | Capstone contextualisé. LLM-evaluated | Post-MVP |
| 101 | Hybrid Scientific Verification | D-OPT-038 | SageMath local ($0) + Wolfram Alpha cloud | V1 |
| 102 | SCY-AXIOM Synthesis Engine | D-OPT-035 | AXIOMATIZER (AGENT-15). Traces → Fundamental Laws | V1 |
| 103 | Metacognitive Self-Learning | D-OPT-034 | Hermes Agent. PII stripping. Closed-loop | V1 |
| 104 | 4-Tier LLM Segregation | pricing spec | Free=DeepSeek, Lite=+Sonnet, Pro=+Opus, Ultra=all | MVP |
| 105 | Deterministic PII Stripping | multi-agent P8 | Regex + NER avant storage | MVP |
| 106 | Adversarial RAG Context Guardrail | D-OPT-025 | Filtrage prompt-injection dans RAG chunks | MVP |

---

## 7. Security (12 patterns)

| # | Pattern | ID Décision | Description | Priorité |
|---|---------|------------|-------------|----------|
| 107 | PostgreSQL RLS Multi-Tenant | SEC-01 | RLS par organization_id. Violation = build stop | MVP |
| 108 | JWT + OAuth Authentication | SEC-02 | JWT 1h + refresh 30j httpOnly. OAuth Google/GitHub | MVP |
| 109 | TLS 1.3 + HSTS + CSP | SEC-03 | HTTP/WSS sécurisé. CSP headers | MVP |
| 110 | OS Keychain AES-256 | SEC-04 | Desktop credentials OS keychain | MVP |
| 111 | Deterministic Input Validation | SEC-06 | serde + Zod. Zéro entrée non validée | MVP |
| 112 | SQL Injection Prevention | SEC-07 | Parameterized queries ONLY | MVP |
| 113 | GDPR Export + Delete + Audit | SEC-04 | Export, Delete cascade, audit immuable | MVP |
| 114 | EU AI Act Traceability | SEC-05 | `scy_ai_decisions` table. Droit à l'explication | MVP |
| 115 | Anti-Corruption Layer | ARC-015 | APIs tierces isolées. Domaine protégé | MVP |
| 116 | Nango Integration Hub | INT-01 | Self-hosted. 800+ templates. MCP built-in | MVP |
| 117 | White-Label OAuth Connect UI | INT-01 | Branding SCY Forge, pas Nango | MVP |
| 118 | Tier-Based Rate Limiting | SEC-07 | Free=10/h, Premium=100/h | MVP |

---

## 8. Deployment (10 patterns)

| # | Pattern | ID Décision | Description | Priorité |
|---|---------|------------|-------------|----------|
| 119 | ISR Dashboard | D-015 | Régénération statique incrémentale <10ms | MVP |
| 120 | Electron Desktop + Rust Sidecar | DEP-03 | Electron 33 + Rust + SQLite WAL offline-first | MVP |
| 121 | Platform-Aware Build (3 targets) | DEP-02 | Desktop / Web / Mobile (PWA→React Native) | MVP |
| 122 | Dual Deployment Profiles | DAT-01 | MSSP/MDR vs SOC Interne Régulé | MVP |
| 123 | Profile-Aware 4 Providers | DAT-02 | ProofRubric, ValidationGuard, Corpus, RoleTaxonomy adaptent | MVP |
| 124 | WASM Edge Computation | WASM spec | Rust→WASM. FSRS+petgraph in-browser. 0$ serveur | MVP+ |
| 125 | WASM Tool Sandboxing | WASM spec | Scripts tiers isolés WASM | MVP+ |
| 126 | WASM 100% Code Unification | WASM spec | Cloud/Desktop partagent 100% code Rust | MVP+ |
| 127 | WASM 100% Offline PWA | WASM spec | Electron→WASM+PWA | MVP+ |
| 128 | 4-Tier LLM Segregation | pricing spec | Lock-down modèle par tier. Marge >89% | MVP |

---

## 9. UX/UI (8 patterns)

| # | Pattern | ID Décision | Description | Priorité |
|---|---------|------------|-------------|----------|
| 129 | WCAG 2.1 AA | UX-01 | Keyboard 100%, ARIA, contrast ≥4.5:1 | MVP |
| 130 | Hybrid Search Global | UX-02 | Tantivy + pgvector. 300ms autocomplete | MVP |
| 131 | Hierarchical Tags 3-Level | UX-03 | Tech > Web > React. ML suggestion | MVP |
| 132 | Hippocampal Spatial Zoom | D-OPT-053 | COSMOS Mode 22. Navigation spatiale | V1 |
| 133 | Progressive Rendering 4 Phases | FLY-019 | WebGL→Hubs→Cards→Stabilisation | MVP |
| 134 | Learning-Aware Graph (SMI aura) | FLY-020 | Aura électro-lumineuse nœuds | MVP |
| 135 | Source-Linked Nodes | FLY-021 | Lien vers document source | MVP |
| 136 | Dual Validation Seal UX | PAT-10 | AI≥85% + humain≥90% display | V1 |

---

## 10. Module-specific (8 patterns)

| # | Pattern | Catégorie | Description | Priorité |
|---|---------|-----------|-------------|----------|
| 137 | 3-Mode Orchestration (ASCENT/Normal/B2B) | AI/LLM | 3 modes selon intent | MVP |
| 138 | PIVOTIQ Multi-Source Reconciliation | AI/LLM | Réconciliation contradictions multi-sources | Post-MVP |
| 139 | NotebookLM Exclusion | Architecture | NotebookLM exclu. BRAIN = alternative native | Post-MVP |
| 140 | 8 Cross-Service Transversal Services | Architecture | ST, APEX, COSMOS, BRAIN, INGESTION, READER, IMPRINT, EventBus | MVP |
| 141 | Services-Don't-Know-Consumers | Architecture | Services-only contracts. Zéro connaissance consommateurs | MVP |
| 142 | Epics 8 (Beachhead v2.0 + GFE) | Architecture | Epic 1-8 complets | MVP |
| 143 | 8 Beachhead Personas SOC | Architecture | P-SOC1/2, P-DFIR, P-SEL, P-RSSI, P-JUNIOR, P-ITM | MVP |
| 144 | LiveKit Voice Architecture A+B | AI/LLM | ArchA: OpenAI Realtime (ARENA/CHRONICLE). ArchB: STT+LLM+TTS (BRAIN/COSMOS) | Post-MVP |

---

## 11. Index par décision d'architecture

Tous les patterns ci-dessus sont référencés vers une décision d'architecture. Utilisez cet index pour trouver les décisions correspondantes :

| Pattern # | ID Décision(s) | Pattern # | ID Décision(s) |
|-----------|---------------|-----------|---------------|
| 1 | D-001 | 73 | D-021, GFE-05 |
| 2 | D-002 | 74 | D-025 |
| 3 | D-003 | 75 | D-026 |
| 4 | D-004 | 76 | LOOP-02 |
| 5 | D-005 | 77 | multi-agent P10 |
| 6 | D-008 | 78 | multi-agent P11 |
| 7 | D-011 | 79 | multi-agent P6 |
| 8 | D-016 | 80 | multi-agent P12 |
| 9 | D-017 | 81 | multi-agent P19 |
| 10 | D-018 | 82 | PAT-07 |
| 11 | D-019 | 83 | PAT-07 |
| 12 | D-020 | 84 | PAT-08 |
| 13 | D-023 | 85 | PAT-07 |
| 14 | D-024 | 86 | D-OPT-022 |
| 15 | PAT-09 | 87 | D-OPT-054 |
| 16 | D-010, AP-002 | 88 | D-OPT-055 |
| 17 | AP-001 | 89 | D-OPT-050 |
| 18 | AP-003 | 90 | D-OPT-056 |
| 19 | AP-005 | 91 | D-OPT-051 |
| 20 | AP-006 | 92 | D-OPT-052 |
| 21 | multi-agent P1 | 93 | D-OPT-048 |
| 22 | multi-agent P2 | 94 | agentic vision |
| 23 | multi-agent P4 | 95 | agentic vision |
| 24 | multi-agent P5 | 96 | agentic vision |
| 25 | multi-agent P7 | 97 | agentic vision |
| 26 | multi-agent P9 | 98 | agentic vision |
| 27 | multi-agent P13 | 99 | agentic vision |
| 28 | D-006 | 100 | agentic vision |
| 29 | D-007 | 101 | D-OPT-038 |
| 30 | ARC-007 | 102 | D-OPT-035 |
| 31 | ARC-004 | 103 | D-OPT-034 |
| 32 | ARC-008 | 104 | pricing spec |
| 33 | D-OPT-026 | 105 | multi-agent P8 |
| 34 | D-OPT-031 | 106 | D-OPT-025 |
| 35 | D-022 | 107 | SEC-01 |
| 36 | D-020 | 108 | SEC-02 |
| 37 | PAT-02 | 109 | SEC-03 |
| 38 | PAT-01 | 110 | SEC-04 |
| 39 | D-013 | 111 | SEC-06 |
| 40 | WP12 | 112 | SEC-07 |
| 41 | UX spec | 113 | SEC-04 |
| 42 | ARC-001 | 114 | SEC-05 |
| 43 | ARC-002 | 115 | ARC-015 |
| 44 | ARC-003 | 116 | INT-01 |
| 45 | ARC-005 | 117 | INT-01 |
| 46 | ARC-006 | 118 | SEC-07 |
| 47 | ARC-009 | 119 | D-015 |
| 48 | ARC-010 | 120 | DEP-03 |
| 49 | ARC-011 | 121 | DEP-02 |
| 50 | D-OPT-010 | 122 | DAT-01 |
| 51 | D-OPT-018 | 123 | DAT-02 |
| 52 | D-OPT-019 | 124 | WASM spec |
| 53 | WP03 | 125 | WASM spec |
| 54 | D-OPT-020 | 126 | WASM spec |
| 55 | D-OPT-026/031 | 127 | WASM spec |
| 56 | multi-agent P17 | 128 | pricing spec |
| 57 | multi-agent P18 | 129 | UX-01 |
| 58 | ARC-012 | 130 | UX-02 |
| 59 | D-OPT-032 | 131 | UX-03 |
| 60 | D-OPT-033 | 132 | D-OPT-053 |
| 61 | D-OPT-034 | 133 | FLY-019 |
| 62 | D-OPT-036 | 134 | FLY-020 |
| 63 | PAT-10 | 135 | FLY-021 |
| 64 | SDLC | 136 | PAT-10 |
| 65 | SDLC | 137 | PAT-07 |
| 66 | P14 | 138 | PAT-11 |
| 67 | ARC-013 | 139 | INT-01 |
| 68 | D-021 | 140 | PAT-04 |
| 69 | GFE-01 | 141 | PAT-06 |
| 70 | GFE-02 | 142 | epics doc |
| 71 | GFE-03 | 143 | DCID-02 |
| 72 | GFE-04 | 144 | LiveKit spec |

---

## 12. Règles d'or — Quick Reference

| # | Règle | Pattern #s associés | Violation |
|---|-------|---------------------|-----------|
| R1 | Zéro terme métier cyber dans le core | 11, 38, 140 | Build stop |
| R2 | Tout seuil est pack-défini | 36, 74, 75 | Build stop |
| R3 | Extensibilité par conception | 14, 38 | Build stop |
| R4 | EventBus obligatoire | 16, 30-34, 53-57 | Build stop |
| R5 | 9 Providers DCID | 12, 36 | Build stop |
| R6 | 3 instances Semantic Tree | 38 | Build stop |
| R7 | Seed Lifecycle préservé | 35, 72 | Build stop |
| R8 | Confiance = source de vérité | 37 | Build stop |
| R9 | Typestate Pattern | 7 | Build stop |
| R10 | Spécifications d'abord | 64, 65 | Build stop |

---

*patterns_master.md — SCY Forge — V1.0 — 2026-07-03*
*Référence unique de tous les patterns architecturaux SCY Forge*
*144 patterns consolidés, zéro doublon, 98 IN_MVP / 46 Post-MVP ou V1*

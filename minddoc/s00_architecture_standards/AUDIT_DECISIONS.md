# AUDIT_DECISIONS.md — Table de toutes les décisions d'architecture

> **Phase 1** — Livrable d'audit documentaire
> **Source** : `MASTER_AGENT_PROMPT_V2.md` §4.1.2
> **Date** : 2026-07-03
> **Auteur** : Architecte Documentaire SCY Forge

---

## 1. Décisions numérotées (D-xxx, AP-xxx, NC-xxx, FLY-xxx, ARC-xxx, D-OPT-xxx)

### D-xxx — Architecture Decisions (26)

| ID | Titre | Source | Ligne | Statut |
|----|-------|--------|-------|--------|
| D-001 | Architecture Hexagonale — Séparation hermétique Domain/Ports/Adapters | `scy_architectural_blueprint_master.md` | 64 | ✅ Actif |
| D-002 | CQRS Léger — Séparation écritures transactionnelles / lectures cache | `scy_architectural_blueprint_master.md` | 65 | ✅ Actif |
| D-003 | Event Sourcing ciblé — Ingestion + APEX FSRS | `scy_architectural_blueprint_master.md` | 66 | ✅ Actif |
| D-004 | Monolithe Unifié — Single-process Node.js/TS + Rust co-locaux | `scy_architectural_blueprint_master.md` | 67 | ✅ Actif |
| D-005 | Repository Pattern — Traits génériques Rust pour PostgreSQL | `scy_architectural_blueprint_master.md` | 68 | ✅ Actif |
| D-006 | GraphQL + DataLoader — Batch N+1 queries | `scy_architectural_blueprint_master.md` | 69 | ✅ Actif |
| D-007 | Temporal Queries PG — Historiques temporels pour replay | `scy_architectural_blueprint_master.md` | 70 | ✅ Actif |
| D-008 | Unit of Work Pattern — Transactions atomiques PostgreSQL | `scy_architectural_blueprint_master.md` | 71 | ✅ Actif |
| D-009 | L0-L4 MapReduce Pipeline — NEURON-CHAINS séquentiel | `scy_architectural_blueprint_master.md` | 72 | ⏸️ Post-MVP |
| D-010 | Observer / EventBus — 18 agents ASCENT découplés (13 IN_MVP + 5 POST_MVP) | `scy_architectural_blueprint_master.md` | 73 | ✅ Actif |
| D-011 | Typestate Pattern ASCENT — États Locked→Ready→Studying→Mastered | `scy_architectural_blueprint_master.md` | 74 | ✅ Actif |
| D-012 | Distributed Tracing — OpenTelemetry → Langfuse | `scy_architectural_blueprint_master.md` | 75 | ✅ Actif |
| D-013 | Polars + DuckDB Analytics — Cohort analytics in-memory | `scy_architectural_blueprint_master.md` | 76 | ✅ Actif |
| D-014 | SAGA Pattern Workflows — Orchestration Mastra | `scy_architectural_blueprint_master.md` | 77 | ✅ Actif (Phase 3) |
| D-015 | ISR Dashboard — Régénération statique incrémentale | `scy_architectural_blueprint_master.md` | 78 | ✅ Actif |
| D-016 | Specification Pattern — Filtres composables Rust | `scy_architectural_blueprint_master.md` | 79 | ✅ Actif |
| D-017 | Reactive Streams — Backpressure ingestion massive | `scy_architectural_blueprint_master.md` | 80 | ✅ Actif |
| D-018 | Observability as Code — Métriques structurées typées | `scy_architectural_blueprint_master.md` | 81 | ✅ Actif |
| D-019 | DCID — Domain Contract Interface Definition — Core agnostic au domaine | `scy_architectural_blueprint_master.md` | 82 | ✅ Actif |
| D-020 | Domain Pack Contract — 9 providers canoniques (dont PackConfigProvider + PackJsonSchemaProvider) | `scy_architectural_blueprint_master.md` | 83 | ✅ Actif |
| D-021 | Generative Forest Engine — 3ème pilier (mode observatoire M0-M36) | `scy_architectural_blueprint_master.md` | 84 | ✅ Actif (observatoire) |
| D-022 | Seed Traceability — PROV-DM + bitemporel + machine à états | `scy_architectural_blueprint_master.md` | 85 | ✅ Actif (observatoire) |
| D-023 | Domain Pack = Médiateur, pas Curriculum — L'entreprise gagne en cas de conflit | `scy_architectural_blueprint_master.md` | 86 | ✅ Actif |
| D-024 | Extensibilité par Conception — Surpasse D-001 à D-022 en cas de conflit | `scy_architectural_blueprint_master.md` | 87 | ✅ Actif (règle suprême) |
| D-025 | Loop Engineering — 4 boucles imbriquées (Micro→Meso→Macro→Outcome) | `scy_architectural_blueprint_master.md` | 88 | ✅ Actif |
| D-026 | Cognitive Runtime Policies — 5 policies (OutputPressure, Friction, Consolidation, Sparring, Priority) | `scy_architectural_blueprint_master.md` | 89 | ✅ Actif |

### AP-xxx — Architecture Patterns / Agents (6)

| ID | Titre | Source | Ligne | Statut |
|----|-------|--------|-------|--------|
| AP-001 | 13 Agents Autonomes ASCENT — Découplage responsabilités (MAJ : 18 agents — 13 IN_MVP + 5 POST_MVP) | `scy_architectural_blueprint_master.md` | 451 | ✅ Actif |
| AP-002 | EventBus central — Communication asynchrone zéro appel direct | `scy_architectural_blueprint_master.md` | 452 | ✅ Actif |
| AP-003 | Déterminisme à 70% — Règles Rust/TS déterministes limitent LLM au strict nécessaire | `scy_architectural_blueprint_master.md` | 453 | ✅ Actif |
| AP-004 | Typestate machine — Transitions invalides impossibles à la compilation | `scy_architectural_blueprint_master.md` | 454 | ✅ Actif |
| AP-005 | SharedContentCache — Cache sémantique global réduit coûts LLM 80–99% | `scy_architectural_blueprint_master.md` | 455 | ✅ Actif |
| AP-006 | BudgetGuard — Télémétrie coût live, mode économie auto à 80% budget | `scy_architectural_blueprint_master.md` | 456 | ✅ Actif |

### NC-xxx — NEURON-CHAINS Decisions (5)

| ID | Titre | Source | Ligne | Statut |
|----|-------|--------|-------|--------|
| NC-001 | 18 Outils natifs Rust — RAG, validation, compression, fact-checking <1ms | `scy_architectural_blueprint_master.md` | 462 | ⏸️ Post-MVP |
| NC-002 | Génération Section par Section — Retry ciblé par section | `scy_architectural_blueprint_master.md` | 463 | ⏸️ Post-MVP |
| NC-003 | Anti-Hallucination 3 Couches — RAG strict + Cross-Check + Scoring | `scy_architectural_blueprint_master.md` | 464 | ✅ Actif |
| NC-005 | LLMLingua-2 local — Compression prompt Candle ONNX 0$ | `scy_architectural_blueprint_master.md` | 468 | ✅ Actif |
| NC-006 | LanceDB in-process — Cache sémantique embeddings local | `scy_architectural_blueprint_master.md` | 469 | ✅ Actif |

> **NC-004 gap** : Numérotation incomplète — NC-004 n'existe dans aucun fichier. À clarifier si NC-004 était prévu ou si NC-005/NC-006 deviennent NC-004/NC-005.

### FLY-xxx — COSMOS Rendering Decisions (6)

| ID | Titre | Source | Ligne | Statut |
|----|-------|--------|-------|--------|
| FLY-010 | Rendu Bi-Moteur G6 & G2 — Graphes topologiques + statistiques | `scy_architectural_blueprint_master.md` | 475 | ✅ Actif |
| FLY-016 | HiDPI + Font Stack Universel — Netteyé Retina + troncature CJK/Emoji | `scy_architectural_blueprint_master.md` | 476 | ✅ Actif |
| FLY-019 | Progressive Rendering 4 Phases — Spinner interdit, apparition progressive | `scy_architectural_blueprint_master.md` | 477 | ✅ Actif |
| FLY-020 | Learning-Aware Graph — SMI intégré aux nœuds (aura électro-lumineuse) | `scy_architectural_blueprint_master.md` | 479 | ✅ Actif |
| FLY-021 | Source-Linked Nodes — Lien direct vers document source (Reader Suite) | `scy_architectural_blueprint_master.md` | 480 | ✅ Actif |
| FLY-022 | Persistent GPU Buffers — Coordonnées jamais ré-uploadées GPU | `scy_architectural_blueprint_master.md` | 481 | ✅ Actif |

### ARC-xxx — Resilience / SRE Decisions (15)

| ID | Titre | Source | Ligne | Statut |
|----|-------|--------|-------|--------|
| ARC-001 | Circuit Breaker 3 états — Appels LLM, Closed→Open→Half-Open | `scy_architectural_blueprint_master.md` | 431 | ✅ Actif |
| ARC-002 | Idempotency Keys UUID v7 — Clés uniques 24h TTL | `scy_architectural_blueprint_master.md` | 432 | ✅ Actif |
| ARC-003 | Timeout 3 Niveaux — 5s/30s/60s anti-cascade | `scy_architectural_blueprint_master.md` | 433 | ✅ Actif |
| ARC-004 | Dead Letter Queue — Events échoués → DLQ manuelle | `scy_architectural_blueprint_master.md` | 434 | ✅ Actif |
| ARC-005 | Bulkhead Sémaphores — Isolation ressources exécution | `scy_architectural_blueprint_master.md` | 435 | ✅ Actif |
| ARC-006 | Graceful Shutdown 5 phases — Drain→Flush→Persist→Close→Exit | `scy_architectural_blueprint_master.md` | 436 | ✅ Actif |
| ARC-007 | Outbox Pattern — Écriture BDD + Event atomiques même transaction | `scy_architectural_blueprint_master.md` | 437 | ✅ Actif |
| ARC-008 | Materialized Views PG — 4 vues matérialisées analytics | `scy_architectural_blueprint_master.md` | 438 | ✅ Actif |
| ARC-009 | Health Checks 3 niveaux — /live /ready /deep | `scy_architectural_blueprint_master.md` | 439 | ✅ Actif |
| ARC-010 | Feature Flags — Déploiement progressif 5%→25%→100% | `scy_architectural_blueprint_master.md` | 440 | ✅ Actif |
| ARC-011 | Blue/Green Deployment — Rollback <2min | `scy_architectural_blueprint_master.md` | 441 | ✅ Actif |
| ARC-012 | Property-Based Testing — proptest millions combinaisons FSRS | `scy_architectural_blueprint_master.md` | 442 | ✅ Actif |
| ARC-013 | Chaos Engineering — 4 scénarios panne planifiés | `scy_architectural_blueprint_master.md` | 443 | ⏸️ Phase 3 |
| ARC-014 | Strangler Fig Pattern — Migration v2→v3 progressive | `scy_architectural_blueprint_master.md` | 444 | ✅ Actif |
| ARC-015 | Anti-Corruption Layer — APIs tierces isolées du domaine | `scy_architectural_blueprint_master.md` | 445 | ✅ Actif |

### D-OPT-xxx — Optimization / Algorithmic Decisions (27)

| ID | Titre | Source | Ligne | Statut |
|----|-------|--------|-------|--------|
| D-OPT-009 | Sigmoïde de Vitalité Robust — Lissage déclin ENGRAM | `scy_architectural_blueprint_master.md` | 490 | ✅ Actif |
| D-OPT-010 | Fail-Safe Gate Anti-Avalanche — Seuil vitalité 25.0/100 | `scy_architectural_blueprint_master.md` | 492 | ✅ Actif |
| D-OPT-011 | Barnes-Hut Approximation — O(N log N) pour constellation | `scy_architectural_blueprint_master.md` | 494 | ✅ Actif |
| D-OPT-012 | Softening Epsilon Anti-NaN — ε = 10⁻⁶ | `scy_architectural_blueprint_master.md` | 496 | ✅ Actif |
| D-OPT-018 | Lazy Physics Suspension — Verlet suspendu si vitesse <0.05px/frame | `scy_architectural_blueprint_master.md` | 498 | ✅ Actif |
| D-OPT-019 | Quadtree Object Pooling — Pool statique pré-alloué, zéro GC | `scy_architectural_blueprint_master.md` | 500 | ✅ Actif |
| D-OPT-022 | Socratic Progressive Prompting — Max 2 paragraphes + question ciblée | `scy_architectural_blueprint_master.md` | 502 | ✅ Actif |
| D-OPT-026 | Offline-First Local Sync Queue — IndexedDB + synchro asynchrone | `scy_architectural_blueprint_master.md` | 504 | ✅ Actif |
| D-OPT-029 | GDPR Anonymization — k-anonymat k≥10 | `scy_architectural_blueprint_master.md` | 506 | ✅ Actif |
| D-OPT-031 | Persistent IndexedDB WAL — File sync WAL persistant | `scy_architectural_blueprint_master.md` | 508 | ✅ Actif |
| D-OPT-032 | ASCENT-QA Validation Board — 6 agents audit async PQS ≥ 88/100 | `scy_architectural_blueprint_master.md` | 508 | ✅ Actif |
| D-OPT-033 | DRACO-Based Research Evaluation — Perplexity DRACO benchmark | `scy_architectural_blueprint_master.md` | 509 | ✅ Actif |
| D-OPT-034 | Metacognitive Self-Learning Loop — Hermes Agent, PII stripping | `scy_architectural_blueprint_master.md` | 510 | ✅ Actif |
| D-OPT-035 | SCY-AXIOM Synthesis Engine — AXIOMATIZER AGENT-15 | `scy_architectural_blueprint_master.md` | 511 | ✅ Actif |
| D-OPT-036 | SME HITL-Proxy Agent — AGENT-16 audit rigueur scientifique | `scy_architectural_blueprint_master.md` | 512 | ✅ Actif |
| D-OPT-037 | Dual Student Pathway Split — Parcours A (assimilation) / B (certifiant) | `scy_architectural_blueprint_master.md` | 513 | ✅ Actif |
| D-OPT-038 | Hybrid Scientific Verification — SageMath local + Wolfram Alpha cloud | `scy_architectural_blueprint_master.md` | 514 | ✅ Actif |
| D-OPT-043 | MindGraph MCP Server — COSMOS-MINDGRAPH via CTE SQL récursives | `scy_architectural_blueprint_master.md` | 515 | ✅ Actif |
| D-OPT-048 | Boost Sommeil Chronicle — Micro-révision 2min avant coucher | `scy_architectural_blueprint_master.md` | 516 | ✅ Actif |
| D-OPT-049 | Interleaved Adaptive Routing — 70% cible / 30% connexes | `scy_architectural_blueprint_master.md` | 517 | ✅ Actif |
| D-OPT-050 | STUDENT-AI Teach-Back Diagnostics — Score <40% → remédiation | `scy_architectural_blueprint_master.md` | 518 | ✅ Actif |
| D-OPT-051 | FSRS Stability Gate before ARENA — Stabilité ≥ 3.0 jours requis | `scy_architectural_blueprint_master.md` | 519 | ✅ Actif |
| D-OPT-052 | Leech-Blocking Cran-5 IMPRINT — Cartes difficiles → écriture manuscrite | `scy_architectural_blueprint_master.md` | 520 | ✅ Actif |
| D-OPT-053 | Hippocampal Spatial Zoom — Mode Semantic Zoom COSMOS | `scy_architectural_blueprint_master.md` | 521 | ✅ Actif |
| D-OPT-054 | Dunning-Kruger Calibration — Confiance haute + recall bas → Teach-Back | `scy_architectural_blueprint_master.md` | 522 | ✅ Actif |
| D-OPT-055 | Tiny Habit Re-Entry Protocol — Absence >3j → Mode Minimal 3 cartes | `scy_architectural_blueprint_master.md` | 523 | ✅ Actif |
| D-OPT-056 | STUDENT-AI Socratic Teach-Back — Hagah, rôle socratique calibré SMI | `scy_architectural_blueprint_master.md` | 524 | ✅ Actif |

### D-COSMOS-xxx — COSMOS Visualization Decisions (1)

| ID | Titre | Source | Ligne | Statut |
|----|-------|--------|-------|--------|
| D-COSMOS-012 | Mode Auto-Suggest COSMOS — Agent-03 choisit mode optimal automatiquement | `scy_agentic_vision_complete.md` (cite `scy_prd_part_3_neuron_chains.md`) | 183 | ✅ Actif |

> **D-COSMOS-001 à D-COSMOS-011** : Définis dans `minddoc/s00_prd/scy_prd_part_3_neuron_chains.md` (Non examiné dans ce scan — à vérifier séparément).

---

## 2. Décisions non numérotées (identifiées mais sans ID formel)

| # | Titre | Source | Ligne | Phases concernées |
|---|-------|--------|-------|-------------------|
| DCID-01 | 2 DCID Invariants — Core agnostic, Pack isolation, SemanticTreeProvider seul pont, MASTERY_THRESHOLD pack-défini, RLS par org_id | `scy_architectural_blueprint_master.md` §2bis.3 | multiple | P0-P1 |
| DCID-02 | Beachhead Persona Pattern — 7 personas SOC (P-SOC1, P-SOC2, P-DFIR, P-SEL, P-RSSI, P-JUNIOR, P-ITM) | `scy_architectural_blueprint_master.md` §2bis.5 | multiple | P0 |
| GFE-01 | 4 Conditions Fertilité L1-L4 — Distance, Pont logique, Non-existence, Alignement HELM | `scy_architectural_blueprint_master.md` D-021 section | 84 | P0 |
| GFE-02 | Seed Anatomy 5 composants — Proposition, Parenté, Arbre potentiel, Viability, Provenance | `scy_architectural_blueprint_master.md` D-021 section | 84 | P0 |
| GFE-03 | 3 Mécanismes Émergence endogène — SME, Blending, Link Prediction | `scy_architectural_blueprint_master.md` D-021 section | 84 | P0 |
| GFE-04 | Seed State Machine — POLLINATED → VIABLE / DORMANT → GERMINATING | `scy_architectural_blueprint_master.md` D-022 section | 85 | P0 |
| GFE-05 | Vision Helm — Vecteur k-dim + graphe objectifs, align() = cosinus | `scy_architectural_blueprint_master.md` D-021 section | 84 | P0 |
| PAT-01 | 3 Semantic Tree Instances — DomainPack, Organization, Learner (même type) | `PROJECT_CONTEXT.md` | 108 | P0 |
| PAT-02 | Confidence = Source de vérité — mastery_score/status dérivés, jamais stockés | `PROJECT_CONTEXT.md` | 110 | P0 |
| PAT-03 | Seed Lifecycle préservé — DORMANT ≠ mort, aucune Seed détruite | `PROJECT_CONTEXT.md` | 109 | P0 |
| PAT-04 | 3 Pillars Architecture — ST+DCID, ASCENT, GFE | `scy_service_architecture_map.md` | multiple | P0 |
| PAT-05 | 8 Cross-Service Transversal Services — Pattern obligatoire | `scy_service_architecture_map.md` | multiple | P0 |
| PAT-06 | Services-Don't-Know-Consumers — Règle architecturale | `scy_service_architecture_map.md` | multiple | P0 |
| PAT-07 | 2-Click Rule — Zéro friction utilisateur | `scy_service_architecture_map.md` | multiple | P0 |
| PAT-08 | Humility Charter — "Pas de souci.", adaptation sans insister | `scy_service_architecture_map.md` | multiple | P0 |
| PAT-09 | COSMOS Agent-as-Canvas — Agents créent/lancent/configurent modes | `scy_service_architecture_map.md` | multiple | P0 |
| PAT-10 | Dual Validation Seal — AI consensus ≥85% + humain ≥90% | `scy_service_architecture_map.md` | multiple | V1 |
| PAT-11 | Nango Integration Hub — Self-hosted, 800+ templates, MCP built-in | `scy_integration_hub_architecture.md` | multiple | P0 |
| DAT-01 | Dual Deployment Profiles — MSSP/MDR vs SOC Interne Régulé | `scy_deployment_profiles_spec.md` | 6 | P0 |
| DAT-02 | Profile-Aware 4 Providers — ProofRubric, ValidationGuard, Corpus, RoleTaxonomy | `scy_deployment_profiles_spec.md` | multiple | P0 |
| DAT-03 | 4-Tier LLM Segregation — Free/Pro/Lite/Ultra locked | `pricing_tiers/scy_pricing_tiers_spec.md` | multiple | P0 |
| DAT-04 | Electron Desktop + Rust Sidecar + SQLite WAL | `infrastructure_securite/scy_infra_sec_spec.md` | multiple | P0 |
| DAT-05 | PostgreSQL RLS Multi-Tenant — Contractuel, violation = build stop | `infrastructure_securite/scy_infra_sec_spec.md` | multiple | P0 |
| DAT-06 | Typestate Machine Pattern — États machines Rust type-safe | `WORK_PACKAGE_01_DCID_TRAITS.md` | multiple | P0 |
| EVT-01 | 18 EventBus EventTypes — 18 événements typés, zéro générique | `WORK_PACKAGE_03_EVENTBUS_CRATE.md` | multiple | P0 |
| EVT-02 | EventBus Trait Abstraction — InMemoryEventBus (MVP) + PostgresEventBus | `WORK_PACKAGE_03_EVENTBUS_CRATE.md` | multiple | P0 |
| EVT-03 | EventValidationGate — 3 règles bloquantes (requires_reply, owner, rate limit) | `WORK_PACKAGE_03_EVENTBUS_CRATE.md` | multiple | P0 |
| EVT-04 | Subscriber Read-Only Rule — Mutation impossible depuis subscriber | `WORK_PACKAGE_03_EVENTBUS_CRATE.md` | multiple | P0 |
| EVT-05 | Unsubscribe Is Forbidden — Handlers live forever | `WORK_PACKAGE_03_EVENTBUS_CRATE.md` | multiple | P0 |
| LOOP-01 | LoopEvaluator Pattern — evaluate() unifié, dispatche par niveau | `WORK_PACKAGE_09_LOOP_ENGINEERING.md` | multiple | P0 |
| LOOP-02 | TriggerR2 — 4 kinds (Reschedule, Immediate, Sparring, Handoff) | `WORK_PACKAGE_09_LOOP_ENGINEERING.md` | multiple | P0 |
| D9-01 | D9 Weighted Coverage — R1×R2×R3, target ≥80% | `WORK_PACKAGE_12_D9_COVERAGE.md` | multiple | P0 |
| D9-02 | Era Multiplier — New2026 = +20% boost R2 | `WORK_PACKAGE_12_D9_COVERAGE.md` | multiple | P0 |
| D9-03 | FidelityLevel L1-L4 — Déclaratif(0.25)→Compréhension(0.5)→Application(0.85)→Maîtrise(1.0) | `WORK_PACKAGE_12_D9_COVERAGE.md` | multiple | P0 |

---

## 3. Statistiques

| Catégorie | Nombre total | IN_MVP | Post-MVP | En doublon |
|-----------|-------------|--------|----------|------------|
| D-xxx | 26 | 24 | 2 (D-009) | 0 |
| AP-xxx | 6 | 6 | 0 | 0 |
| NC-xxx | 5 | 4 | 1 (NC-001) | 0 |
| FLY-xxx | 6 | 6 | 0 | 0 |
| ARC-xxx | 15 | 13 | 2 (ARC-013) | 0 |
| D-OPT-xxx | 27 | 20 | 7 (D-OPT-048/052/053/054/055/056) | 0 |
| D-COSMOS-xxx | 1 | 1 | 0 | 0 |
| Non numérotées | 34 | 28 | 6 | 0 |
| **TOTAL** | **120** | **102** | **18** | **0** |

---

## 4. Notes de cohérence

- **AP-001 corrigé** : "13 agents" → "18 agents (13 IN_MVP + 5 POST_MVP)" — cohérent avec D-010.
- **D-020 enrichi** : PackConfigProvider + PackJsonSchemaProvider ajoutés aux 9 providers — cohérent avec WP01/WP04.
- **ValidationGuard vs ProofRubric** : Frontière clarifiée dans D-020 — binaire vs graduel.
- **INC-M-02** : LiveKit badgegé POST_MVP — cohérent avec D-OPT-048+ (Post-MVP voice).
- **INC-A-04/05** : COSMOS v5 actif, plugin abandonné — FLY-xxx inchangés (rendu, pas architecture plugin).
- **NC-004 gap** : Numérotation incomplète — à vérifier dans `scy_prd_part_3_neuron_chains.md`.

---

*AUDIT_DECISIONS.md — SCY Forge — V1.0 — 2026-07-03*

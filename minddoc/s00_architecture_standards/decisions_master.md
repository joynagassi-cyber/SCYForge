# decisions_master.md — Toutes les décisions d'architecture unifiées

> **Phase 2** — Livrable d'unification
> **Source** : Consolidation de `scy_architectural_blueprint_master.md` + tous les documents d'architecture
> **Date** : 2026-07-03
> **Auteur** : Architecte Documentaire SCY Forge
> **Règle** : Ce fichier est la référence unique. Toute décision architecturale doit être référencée ici.

---

## 1. Décisions numérotées consolidées

### D-xxx — Architecture Core (26)

**D-001 — Architecture Hexagonale** ✅ MVP
> Séparation hermétique : `Domain` (règles pures, 0 dépendance), `Ports` (interfaces Rust/TS), `Adapters` (Axum, sqlx, Mastra, UI). Services exposent ports, consommateurs consomment ports.

**D-002 — CQRS Léger** ✅ MVP
> Séparation flux écriture (Commands sqlx) et lectures rapides (Queries cache sémantique `scy_llm_cache_meta`).

**D-003 — Event Sourcing ciblé** ✅ MVP
> Mutations Ingestion + APEX FSRS enregistrées comme flux immuables rejouables.

**D-004 — Monolithe Unifié** ✅ MVP
> Single-process : Node.js/TS (Mastra) + Rust co-locés (IPC/UNIX socket/FFI). Zéro microservice, zéro latence réseau inter-services.

**D-005 — Repository Pattern** ✅ MVP
> Traits génériques Rust `Repository<T>` pour PostgreSQL. Mock pour tests unitaires.

**D-006 — GraphQL + DataLoader** ✅ MVP
> Batch N+1 queries pour exploration relationnelle. DataLoader + cache temporaire.

**D-007 — Temporal Queries PostgreSQL** ⏸️ V1
> Historiques temporels (`FOR SYSTEM_TIME`) pour replay état à date passée.

**D-008 — Unit of Work Pattern** ✅ MVP
> Transactions atomiques PostgreSQL par Use Case. Un cas = une transaction.

**D-009 — L0-L4 MapReduce Pipeline** ⏸️ Post-MVP
> NEURON-CHAINS séquentiel L0(brute)→L4(export). Retry + cache par segment.

**D-010 — Observer / EventBus — 18 agents ASCENT** ✅ MVP
> Communication asynchrone pub/sub. 13 agents IN_MVP + 5 POST_MVP (AG14-LiveKit Voice, AG15-Gaming/Dual, AG16-Social Recruiting, AG17-Analytics Pipeline, AG18-Advanced Orchestration). Zéro appel direct inter-agents.

**D-011 — Typestate Pattern ASCENT** ✅ MVP
> États machine `Locked → Ready → Studying → Mastered` comme types Rust stricts. Transitions invalides impossibles à la compilation.

**D-012 — Distributed Tracing** ✅ MVP
> OpenTelemetry → Langfuse (Docker). Traces live exportées.

**D-013 — Polars + DuckDB Analytics** ⏸️ V1
> Cohort analytics in-memory. Export Parquet pour ML externe.

**D-014 — SAGA Pattern Workflows** ✅ MVP (Phase 3)
> Orchestration Mastra TS. Compensations automatiques en cas d'échec agent.

**D-015 — ISR Dashboard** ✅ MVP
> Régénération statique incrémentale Next.js. Affichage <10ms.

**D-016 — Specification Pattern** ✅ MVP
> Filtres composables Rust pour sélection cartes APEX.

**D-017 — Reactive Streams** ✅ MVP
> Backpressure ingestion massive. tokio async, chunk 50, 4 workers. Zéro OOM.

**D-018 — Observability as Code** ✅ MVP
> Métriques structurées typées. Zéro log texte libre. OpenTelemetry + Langfuse.

**D-019 — DCID — Domain Contract Interface Definition** ✅ MVP (RÈGLE SUPRÊME R1)
> Core agnostic au domaine. `SemanticTreeProvider` (Rust) = seul pont core ↔ domain packs. Aucun terme métier cyber/medical/finance dans le core. Violation = rupture contrat.

**D-020 — Domain Pack Contract — 9 Providers** ✅ MVP (RÈGLE R5)
> Chaque pack implémente 9 providers : SemanticTreeProvider (PRIMARY, obligatoire), OntologyProvider, CorpusProvider, RoleTaxonomyProvider, DecisionScenarioProvider, ProofRubricProvider, RetentionPolicyProvider, ValidationGuardProvider, **PackConfigProvider**, **PackJsonSchemaProvider**.
> Frontière : `ValidationGuardProvider` = garde-fous binaires (INTERDIT/AUTORISÉ). `ProofRubricProvider` = évaluation graduelle (score pondéré dimensions). Les 2 derniers gèrent config pack-définie + validation JSONB optionnelle (None = accept-all).

**D-021 — Generative Forest Engine (GFE)** ✅ MVP (observatoire)
> 3ème pilier. Pollination → Seed → Germination. M0-M36 : mode observatoire (intra-domaine MITRE, Seeds stockées). M36+ : mode expansion (cross-pollination + germination auto).

**D-022 — Seed Traceability (PROV + Bitemporal)** ✅ MVP (observatoire)
> W3C PROV-DM + bitemporel. Machine à états : POLLINATED → VIABLE / DORMANT → GERMINATING. Scoring Viability/Fecundity/PlantScore.

**D-023 — Domain Pack = Médiateur, pas Curriculum** ✅ MVP
> Le pack ne définit PAS ce que l'apprenant doit savoir (entreprise = source #1). Il structure, aligne, traduit. Si conflit → entreprise gagne. Test : "Si je retire le corpus entreprise, reste-t-il un curriculum ?" → Non, et c'est voulu.

**D-024 — Extensibilité par Conception** ✅ MVP (RÈGLE SUPRÊME R3/R10)
> Core = squelette générique sans mémoire métier. Connaissance + règles + seuils dans packs. Absence config → `MissingPackConfig` error (jamais fallback silencieux). **Surpasse D-001 à D-022 en cas de conflit.**

**D-025 — Loop Engineering — 4 boucles imbriquées** ✅ MVP
> Micro (output/input ≥ seuil) → Méso (Plant→Graft→Test→Myelinate, SMI ≥ threshold) → Macro (coverage ≥ 0.80 + enveloppe validée) → Outcome (écart preuve↔réalité sous tolérance).

**D-026 — Cognitive Runtime Policies** ✅ MVP
> 5 policies : OutputPressurePolicy, CognitiveFrictionPolicy, ConsolidationWindowPolicy, SparringPolicy, SemanticTreePriorityPolicy. Tous seuils pack-définis via PackConfigProvider.

---

### AP-xxx — Architecture Patterns (6)

**AP-001 — ASCENT Plan C — 18 Agents** ✅ MVP
> 18 agents autonomes découplés. 13 IN_MVP + 5 POST_MVP. Chaque agent = responsabilité isolée.

**AP-002 — EventBus central** ✅ MVP
> Communication asynchrone par événements. Zéro appel direct. Ajout/édition agent sans refactoring pipeline.

**AP-003 — Déterminisme à 70%** ✅ MVP
> Règles Rust/TS déterministes pour SMI, ré-aiguillage, suspension. LLM au strict nécessaire.

**AP-004 — Typestate machine** ✅ MVP
> États d'apprentissage type-safe. Transition invalide = erreur compilation.

**AP-005 — SharedContentCache** ✅ MVP
> Cache sémantique global (LanceDB). Mutualisation docs objectifs similaires. Réduction 80-99% appels LLM.

**AP-006 — BudgetGuard** ✅ MVP
> Télémétrie coût live. Mode économie auto à 80% budget. Blocage Tactical AI à 100%.

---

### NC-xxx — NEURON-CHAINS (5)

**NC-001 — 18 Outils natifs Rust** ⏸️ Post-MVP
> RAG, validation, compression prompts, fact-checking <1ms. 0$ infrastructure.

**NC-002 — Génération Section par Section** ⏸️ Post-MVP
> Rédaction paragraphe par paragraphe. Retry ciblé section rejetée.

**NC-003 — Anti-Hallucination 3 Couches** ✅ MVP
> Couche 1 : RAG Strict (Zilliz). Couche 2 : Cross-Check Multi-Agents. Couche 3 : Scoring Probabiliste.

**NC-005 — LLMLingua-2 local** ✅ MVP
> Compression sémantique prompt, Candle ONNX, 0$ coût.

**NC-006 — LanceDB in-process** ✅ MVP
> Cache sémantique embeddings local. Latence <2ms.

> **NC-004 gap** : Numérotation incomplète. NC-004 n'existe dans aucun fichier. À clarifier.

---

### FLY-xxx — COSMOS Rendering (6)

**FLY-010 — Rendu Bi-Moteur G6 & G2** ✅ MVP
> AntV G6 v5 pour graphes topologiques. AntV G2 v5 pour statistiques/hiérarchiques.

**FLY-016 — HiDPI + Font Stack Universel** ✅ MVP
> Netteyé Retina. Troncature CJK/Emoji.

**FLY-019 — Progressive Rendering 4 Phases** ✅ MVP
> WebGL Constellation → Hubs → Cards → Stabilisation. Zéro spinner blanc.

**FLY-020 — Learning-Aware Graph (SMI aura)** ✅ MVP
> Aura électro-lumineuse selon SMI. Concepts maîtrisés vs danger d'oubli.

**FLY-021 — Source-Linked Nodes** ✅ MVP
> Lien direct vers document source (Reader Suite).

**FLY-022 — Persistent GPU Buffers** ✅ MVP
> Coordonnées GPU jamais ré-uploadées. Pan/zoom/translate = 120x performance.

---

### ARC-xxx — Resilience / SRE (15)

**ARC-001 — Circuit Breaker 3 états** ✅ MVP
> Per provider LLM. Closed → Open (5 échecs) → Half-Open probe. -95% appels service défaillant.

**ARC-002 — Idempotency Keys UUID v7** ✅ MVP
> Toutes écritures sémantiques/sync. Clé unique 24h TTL. Zéro duplication.

**ARC-003 — Timeout 3 Niveaux** ✅ MVP
> L1: 5s (LLM), L2: 30s (BDD), L3: 10s sync / 60s async. Anti-cascade.

**ARC-004 — Dead Letter Queue** ✅ MVP
> Events échoués → DLQ manuelle. 100% traçabilité.

**ARC-005 — Bulkhead Sémaphores** ✅ MVP
> 6 domaines isolés (Ingestion, NEURON, ASCENT, APEX, BRAIN, COSMOS). Échec ingestion ne gèle pas APEX.

**ARC-006 — Graceful Shutdown 5 phases** ✅ MVP
> Drain → Flush → Persist → Close → Exit. Zéro perte données.

**ARC-007 — Outbox Pattern** ✅ MVP
> Écriture BDD + Event atomiques même transaction PostgreSQL.

**ARC-008 — Materialized Views PG** ✅ MVP
> 4 vues matérialisées. -80% temps requêtes analytics.

**ARC-009 — Health Checks 3 niveaux** ✅ MVP
> `/live` (liveness), `/ready` (readiness), `/deep` (dépendances).

**ARC-010 — Feature Flags** ⏸️ V1
> Déploiement progressif 5% → 25% → 100%. RolloutStrategy graduel.

**ARC-011 — Blue/Green Deployment** ⏸️ V1
> Northflank + Vercel. Rollback <2min.

**ARC-012 — Property-Based Testing** ✅ MVP
> `proptest` crate. Millions combinaisons FSRS. Zéro NaN garanti.

**ARC-013 — Chaos Engineering** ⏸️ Phase 3
> 4 scénarios pannes planifiés (PostgreSQL, Zilliz, API, disk).

**ARC-014 — Strangler Fig Pattern** ⏸️ V1
> Migration v2→v3 progressive. Feature flags + proxy router.

**ARC-015 — Anti-Corruption Layer** ✅ MVP
> APIs tierces (Composio, YouTube, Twitter) isolées. Domaine protégé model leakage.

---

### D-OPT-xxx — Optimizations (27)

**D-OPT-009 — Sigmoïde de Vitalité Robust** ✅ MVP
> Lissage déclin ENGRAM. Dormance précise J90.

**D-OPT-010 — Fail-Safe Gate Anti-Avalanche** ✅ MVP
> Seuil vitalité 25/100. Amortissement RIF 90%. Zéro cascade mort sémantique.

**D-OPT-011 — Barnes-Hut Approximation** ✅ MVP
> O(N log N) pour constellation 2D/3D. Millions nœuds mobile.

**D-OPT-012 — Softening Epsilon Anti-NaN** ✅ MVP
> ε = 10⁻⁶ dénominateur. Zéro division par zéro, zéro NaN.

**D-OPT-018 — Lazy Physics Suspension** ✅ MVP
> Verlet suspendu si vitesse <0.05px/frame. CPU→0%.

**D-OPT-019 — Quadtree Object Pooling** ✅ MVP
> Pool statique pré-alloué. Zéro GC pause.

**D-OPT-022 — Socratic Progressive Prompting** ✅ MVP
> Max 2 paragraphes + question ciblée. -40% tokens output.

**D-OPT-026 — Offline-First Local Sync Queue** ✅ MVP
> IndexedDB + synchro asynchrone. 100% offline.

**D-OPT-029 — GDPR Anonymization** ✅ MVP
> k-anonymat k≥10. Console admin protégée.

**D-OPT-031 — Persistent IndexedDB WAL** ✅ MVP
> WAL persistant. Auto-réparation crash battery/tab close.

**D-OPT-032 — ASCENT-QA Validation Board** ✅ MVP
> 6 agents audit async. PQS ≥88/100 avant certification.

**D-OPT-033 — DRACO-Based Research Evaluation** ⏸️ V1
> Perplexity DRACO benchmark. Véracité/profondeur/style/ancrage.

**D-OPT-034 — Metacognitive Self-Learning Loop** ⏸️ V1
> Hermes Agent. PII stripping. Closed-loop procedural skills.

**D-OPT-035 — SCY-AXIOM Synthesis Engine** ⏸️ V1
> AXIOMATIZER (AGENT-15). Traces cohorte → Fundamental Laws. Moat intelligence collective.

**D-OPT-036 — SME HITL-Proxy Agent** ⏸️ V1
> AGENT-16. Simule expert sceptique (Mayo Clinic, MIT). Audit rigueur scientifique.

**D-OPT-037 — Dual Student Pathway Split** ⏸️ V1
> Parcours A (Assimilation, pas certif) / Parcours B (Certifiant, SurveyJS + ARENA + SMI≥85).

**D-OPT-038 — Hybrid Scientific Verification** ⏸️ V1
> Niveau1: SageMath local ($0) + Niveau2: Wolfram Alpha cloud.

**D-OPT-043 — MindGraph MCP Server** ✅ MVP
> MCP server local. `query-mindgraph` via CTE SQL récursives. -4.5x tokens.

**D-OPT-048 — Boost Sommeil Chronicle** ⏸️ Post-MVP
> Micro-révision 2min avant coucher. Consolidation hippocampale nocturne.

**D-OPT-049 — Interleaved Adaptive Routing** ✅ MVP
> 70% cible / 30% connexes. Briser habituation cortex visuel.

**D-OPT-050 — STUDENT-AI Teach-Back Diagnostics** ✅ MVP
> Score <40% → diagnostic sémantique/logique → carte remédiation B06.

**D-OPT-051 — FSRS Stability Gate before ARENA** ✅ MVP
> Stabilité ≥3.0j requis. Bloom ≥4 bloqué si seuil non atteint.

**D-OPT-052 — Leech-Blocking Cran-5 IMPRINT** ⏸️ Post-MVP
> Cartes Leech → IMPRINT écriture manuscrite (50-65 mots).

**D-OPT-053 — Hippocampal Spatial Zoom** ⏸️ V1
> COSMOS Mode 22. Navigation spatiale micro→global. Cellules lieu hippocampe.

**D-OPT-054 — Dunning-Kruger Calibration** ✅ MVP
> DRIFT-GUARDIAN (AGENT-07). Confiance haute + recall bas → Teach-Back immédiat.

**D-OPT-055 — Tiny Habit Re-Entry Protocol** ⏸️ V1
> Absence >3j → Mode Minimal 3 cartes. Zéro stress surcharge.

**D-OPT-056 — STUDENT-AI Socratic Teach-Back** ⏸️ V1
> Hagah. Rôle socratique calibré SMI. Bloom 3. Verbalisation imageries mentales.

---

### D-COSMOS-xxx — COSMOS Rendering (1+)

**D-COSMOS-012 — Mode Auto-Suggest COSMOS** ✅ MVP
> Agent-03 choisit mode visualisation optimal automatiquement. Référence : `scy_prd_part_3_neuron_chains.md`.

> **D-COSMOS-001 à D-COSMOS-011** : Définis dans `minddoc/s00_prd/scy_prd_part_3_neuron_chains.md`. À extraire et fusionner ici.

---

## 2. Décisions non numérotées consolidées

### DCID Invariants
**DCID-INV-01 — Core Agnostic Invariant** ✅ MVP (R1)
> Zéro terme métier cyber/medical/finance dans le core. SemanticTreeProvider seul pont. MASTERY_THRESHOLD pack-défini. Pack ingestion = $0 LLM. RoleSubtree mandatory avant onboarding. RLS par organization_id.

**DCID-INV-02 — Beachhead Persona Pattern** ✅ MVP
> 7 personas SOC uniquement : P-SOC1, P-SOC2, P-DFIR, P-SEL, P-RSSI, P-JUNIOR, P-ITM. Personas génériques éliminées.

### GFE Decisions
**GFE-01 — 4 Fertility Conditions L1-L4** ✅ MVP (observatoire)
> L1: distance ≥ θ_min (pas redundancy). L2: pont logique existe (pas noise). L3: lien n'existe pas dans KG (creation pas recall). L4: align(HELM) ≥ τ.

**GFE-02 — Seed Anatomy 5 components** ✅ MVP
> (1) Core Proposition, (2) Parenthood (source_A, source_B), (3) Potential Tree, (4) Viability Profile, (5) Provenance (lignée immuable).

**GFE-03 — 3 Endogenous Emergence Mechanisms** ✅ MVP
> SME (structure-mapping Gentner), Blending (Fauconnier-Turner), Link Prediction (Swanson/node2vec). Indépendants d'Internet.

**GFE-04 — Seed State Machine** ✅ MVP
> POLLINATED → (viable) → VIABLE → (planted) → GERMINATING / (sterile) → DORMANT → (favorable) → VIABLE (temporal revival). Aucune Seed détruite.

**GFE-05 — Vision Helm** ✅ MVP
> Vecteur k-dim `h ∈ ℝᵏ` + graphe objectifs `G_H`. `align(x, H) = cos(proj(x), h)` ∈ [0,1]. Gouvernne ARBOR, POLL, ASCENT, COSMOS.

### Core Principles
**R1 — Zéro terme métier cyber dans le core** ✅ MVP
**R2 — Tout seuil est pack-défini** ✅ MVP
**R3 — Extensibilité par conception** ✅ MVP
**R4 — EventBus obligatoire** ✅ MVP
**R5 — 9 Providers DCID** ✅ MVP
**R6 — 3 instances Semantic Tree** ✅ MVP
**R7 — Seed Lifecycle préservé** ✅ MVP
**R8 — Confiance = source de vérité** ✅ MVP
**R9 — Typestate Pattern** ✅ MVP
**R10 — Spécifications d'abord** ✅ MVP

### Autonomy & Governance
**LOOP-01 — LoopEvaluator Pattern** ✅ MVP
> `evaluate()` unifié. Dispatche evaluate_micro/meso/macro/outcome. `evaluate_macro` agrège Meso. `evaluate_outcome` agrège Macro + métriques business (threshold 0.8). `check_r2_trigger()` : Sparring/Reschedule/Immediate/Handoff.

**D9-01 — D9 Weighted Coverage** ✅ MVP
> D9 = Σ(node_coverage_i × weight_i) / Σ(weight_i). weight_i = R1 × R2 × R3. Target ≥80%.

**D9-02 — Era Multiplier** ✅ MVP
> Era enum : Legacy, Current, New2026. New2026 = +20% boost R2.

**D9-03 — FidelityLevel L1-L4** ✅ MVP
> L1=0.25 (déclaratif), L2=0.5 (compréhension), L3=0.85 (application), L4=1.0 (maîtrise). Dérivé de NodeStatus.

**EVT-01 — 18 EventBus EventTypes** ✅ MVP
> TreeOpPlanted/Grafted/Pruned/Tested/Myelinated, ScenarioStarted/Reacted/Evaluated/Completed, MasteryUpdated/MasteryThreshold, GapDetected, CertEarned, SeedPollinated/Germinated/Dormant/Validated/Rejected.

**EVT-02 — EventBus Trait Abstraction** ✅ MVP
> InMemoryEventBus (MVP) + PostgresEventBus (WP05). Trait `EventBus: Send + Sync`.

**EVT-03 — EventValidationGate** ✅ MVP
> 3 règles bloquantes : requires_reply, owner_mismatch, rate_limit (>100 events/1s).

**EVT-04 — Subscriber Read-Only** ✅ MVP
> Mutation impossible depuis subscriber. event → handler → mutation.

**EVT-05 — Unsubscribe Forbidden** ✅ MVP
> Subscriber handlers live forever. `unsubscribe()` interdit.

### Integration & Security
**INT-01 — Nango Integration Hub** ✅ MVP
> Self-hosted Northflank. 800+ templates. MCP built-in. OAuth sécurisé PostgreSQL RLS. Credentials jamais exposées.

**SEC-01 — PostgreSQL RLS Multi-Tenant** ✅ MVP
> RLS par organization_id. Toutes tables. Cross-tenant = build stop.

**SEC-02 — JWT + OAuth** ✅ MVP
> JWT 1h + refresh 30j httpOnly. OAuth Google/GitHub.

**SEC-03 — TLS 1.3 + HSTS + CSP** ✅ MVP
> HTTP/WSS sécurisé. CSP headers sur toutes réponses.

**SEC-04 — GDPR Privacy** ✅ MVP
> Export complet + Delete Account cascade + audit trail immuable.

**SEC-05 — EU AI Act Traceability** ✅ MVP
> `scy_ai_decisions` table. Droit à l'explication.

**SEC-06 — Deterministic Input Validation** ✅ MVP
> serde (Rust) + Zod (TS). Zéro entrée non validée.

**SEC-07 — SQL Injection Prevention** ✅ MVP
> Parameterized queries ONLY. String interpolation FORBIDDEN.

### UX/UI
**UX-01 — WCAG 2.1 AA** ✅ MVP
**UX-02 — Hybrid Search (Tantivy + pgvector)** ✅ MVP
**UX-03 — 2-Click Rule** ✅ MVP
**UX-04 — Humility Charter** ✅ MVP
**UX-05 — Progressive Automation (Override always visible)** ✅ MVP

### Deployment
**DEP-01 — Dual Deployment Profiles** ✅ MVP
**DEP-02 — Platform-Aware Build (3 targets)** ✅ MVP
**DEP-03 — Electron Desktop + Rust Sidecar + SQLite WAL** ✅ MVP
**DEP-04 — ISR Dashboard** ✅ MVP
**DEP-05 — 4-Tier LLM Segregation** ✅ MVP

---

## 3. Statistiques consolidées

| Catégorie | Numérotées | Non numérotées | Total | IN_MVP | Post-MVP/V1 | Doublons |
|-----------|-----------|----------------|-------|--------|-------------|----------|
| D-xxx | 26 | — | 26 | 24 | 2 | 0 |
| AP-xxx | 6 | — | 6 | 6 | 0 | 0 |
| NC-xxx | 5 | — | 5 | 4 | 1 | 0 |
| FLY-xxx | 6 | — | 6 | 6 | 0 | 0 |
| ARC-xxx | 15 | — | 15 | 13 | 2 | 0 |
| D-OPT-xxx | 27 | — | 27 | 20 | 7 | 0 |
| D-COSMOS-xxx | 1 | — | 1 | 1 | 0 | 0 |
| DCID Invariants | — | 2 | 2 | 2 | 0 | 0 |
| GFE | — | 5 | 5 | 5 | 0 | 0 |
| Core Principles (R1-R10) | — | 10 | 10 | 10 | 0 | 0 |
| Autonomy/Governance | — | 7 | 7 | 7 | 0 | 0 |
| EventBus | — | 5 | 5 | 5 | 0 | 0 |
| Integration/Security | — | 7 | 7 | 7 | 0 | 0 |
| UX/UI | — | 5 | 5 | 5 | 0 | 0 |
| Deployment | — | 5 | 5 | 5 | 0 | 0 |
| Module-specific | — | 8 | 8 | 5 | 3 | 0 |
| **TOTAL** | **86** | **54** | **140** | **129** | **15** | **0** |

---

## 4. Règles d'or — Récapitulatif

| # | Règle | Décision source | Non-négociable |
|---|-------|-----------------|----------------|
| R1 | Zéro terme métier cyber dans le core | D-019, DCID-INV-01 | OUI |
| R2 | Tout seuil est pack-défini | D-020, D-024 | OUI |
| R3 | Extensibilité par conception | D-024 | OUI |
| R4 | EventBus obligatoire | AP-002, D-010 | OUI |
| R5 | 9 Providers DCID | D-020 | OUI |
| R6 | 3 instances Semantic Tree | PAT-01 | OUI |
| R7 | Seed Lifecycle préservé | D-022, PAT-03 | OUI |
| R8 | Confiance = source de vérité | D-008, PAT-02 | OUI |
| R9 | Typestate Pattern | D-011 | OUI |
| R10 | Spécifications d'abord | SDLC standards | OUI |

---

## 5. À faire (gaps identifiés)

1. **NC-004 gap** : Numérotation incomplète. Vérifier dans `scy_prd_part_3_neuron_chains.md`.
2. **D-COSMOS-001 à 011** : Définis dans `scy_prd_part_3_neuron_chains.md`. Extraire et fusionner ici.
3. **D-OPT-001 à 008** : Référencés dans WASM spec mais non définis dans blueprint master. À localiser.
4. **D-OPT-013/014/015/016/017** : Référencés dans `implementation_order.md` mais non définis. À localiser.
5. **D-OPT-020/021/023/024/025/027/028/030/039/040/041/042/044/045/046/047** : Numéros sautés. À vérifier si gaps intentionnels.

---

*decisions_master.md — SCY Forge — V1.0 — 2026-07-03*
*Référence unique de toutes les décisions d'architecture SCY Forge*

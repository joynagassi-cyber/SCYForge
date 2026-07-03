<!--
BEACHHEAD PIVOT v2.0 — Roadmap MVP 28 jours
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Aligné avec : IMPLEMENTATION_ORDER.md, WP01-WP14, scyforge_mvp_golden_master.md
Date : 2026-07-03
-->

# SCY FORGE — ROADMAP MVP 28 JOURS (Cyber SOC/Blue-Team Beachhead)

> **Objectif** : Roadmap jour-par-jour pour les 28 jours du MVP.
> **Contexte** : Beachhead Cyber SOC/Blue-Team. Le cœur reste générique. Toute adaptation cyber vit dans `packs/cyber/`.
> **Source** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md` §5 + `minddoc/s00_architecture_standards/work_packages/`

---

## Vue d'ensemble

```
Semaine 1  ──► Semaine 2  ──► Semaine 3  ──► Semaine 4
  J1-2        J3-8          J9-14          J15-16      J17-28
  │           │             │              │           │
Infra      Tree+Pack      ARENA-lite     Onboarding  Pré-Production
Sprint 0   Sprint 1       Sprint 2        Polish      Tests+Deploy
```

### Jours 1-16 — Build MVP (4 sprints × 4 jours)

| Sprint | Jours | Focus | WP | Livrables |
|--------|-------|-------|-----|-----------|
| **Sprint 0** | J1-2 | Infrastructure | WP01, WP02, WP03 | DB migrations, Axum /health, EventBus, scy-shared |
| **Sprint 1** | J3-8 | Semantic Tree + Pack Loader | WP04, WP05, WP06 | DCID traits, PostgresTreeAdapter, DomainPackLoader, CyberPack chargé |
| **Sprint 2** | J9-14 | ARENA-lite + Onboarding | WP07, WP08, WP09 | AutonomyEnvelope, CognitivePolicies, ARENA APT29, 3 branches |
| **Sprint 3** | J15-16 | Polish + démo | WP10, WP11 | ProviderMatrix, C1-C7 validation, Gap Detection, SMI Dashboard |

### Jours 17-28 — Pré-Production

| Période | Focus | Activités |
|---------|-------|-----------|
| J17-20 | Tests | E2E Playwright (onboard→tree→scenario→mastery), load test 100 users |
| J21-23 | Production hardening | Monitoring (Sentry + OpenTelemetry), Review sécurité, code freeze |
| J24-26 | Beta | Customer validation (2-3 SOC teams beta), fix bugs critiques |
| J27-28 | Deploy | Northflank (backend) + Vercel (frontend), Go/No-Go final |

---

## SPRINT 0 — FONDATION (Jours 1-2)

### Objectif
Infrastructure de base opérationnelle. Go/No-Go à J3.

### WP liés
- **WP01** : DCID Traits (contrat de domaine)
- **WP02** : SQL Migrations (schema core)
- **WP03** : EventBus crate

### Jour 1

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | Créer migrations SQL 001_init | `backend_rs/migrations/001_init.sql` | — |
| 2 | Tables core : users, sources, documents, chunks, concepts | `001_init.sql` | #1 |
| 3 | RLS multi-tenant policies | `001_init.sql` | #2 |
| 4 | Axum server health endpoints (/live, /ready, /deep) | `backend_rs/src/main.rs` | — |
| 5 | scy-shared crate (types User, Goal, Node, Card, Concept, AppError) | `backend_rs/src/shared/types.rs` | — |
| 6 | POC Test 1 : G6 v5 + Louvain 1000 concepts < 10s | script + bench | — |

### Jour 2

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | scy-eventbus crate (SCYForgeEvent enum, publisher, DLQ) | `backend_rs/src/eventbus/` | #J1-4 |
| 2 | EventValidationGate (D-OPT-052) | `backend_rs/src/eventbus/gate.rs` | #1 |
| 3 | 17 événements typés + schémas JSON | `backend_rs/src/eventbus/events.rs` | #1 |
| 4 | Déployer PostgreSQL Northflank + pgvector | infra/ | — |
| 5 | POC Tests 2-4 (DeepSeek NER < 3s, Typst PDF < 2s, FTS < 100ms) | bench/ | — |
| 6 | **Go/No-Go Sprint 0** | — | #4 (4 GO requis) |

### Critère de sortie Sprint 0
- ✅ DB migrée + Axum /health/* répond
- ✅ EventBus compile + DLQ opérationnelle
- ✅ 4 POC tests passés (G6, NER, Typst, FTS)

---

## SPRINT 1 — SEMANTIC TREE + PACK LOADER (Jours 3-8)

### Objectif
Semantic Tree PostgreSQL opérationnel avec Domain Pack Cyber chargé.

### WP liés
- **WP04** : Pack Providers (DCID contract)
- **WP05** : Postgres Adapter (SemanticTreeProvider impl)
- **WP06** : Seed & Status (learner states, tree operations)

### Jour 3

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | DCID trait SemanticTreeProvider dans scy-shared | `shared/ports.rs` | Sprint 0 |
| 2 | 5 opérations canoniques (plant, graft, prune, test, myelinate) | `shared/ports.rs` | #1 |
| 3 | Shared types (SemanticNode, TreeEdge, LearnerNodeState) | `shared/tree.rs` | #1 |

### Jour 4

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | PostgresTreeAdapter — impl SemanticTreeProvider | `backend_rs/src/adapters/postgres_tree.rs` | J3 |
| 2 | implémenter load_tree() + nodes() | `postgres_tree.rs` | #1 |
| 3 | implémenter learner_state() | `postgres_tree.rs` | #1 |
| 4 | Tests unitaires InMemoryTreeAdapter | `backend_rs/src/adapters/in_memory_tree.rs` | J3 |

### Jour 5

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | implémenter plant() — insérer root nodes | `postgres_tree.rs` | J4 |
| 2 | implémenter graft() — insérer child edges | `postgres_tree.rs` | J4 |
| 3 | implémenter prune() + is_unlockable() | `postgres_tree.rs` | J4 |
| 4 | Endpoints REST /api/tree/* | `backend_rs/src/routes/tree.rs` | J3 |

### Jour 6

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | DomainPackLoader — lire pack.manifest.json | `backend_rs/src/pack/loader.rs` | J5 |
| 2 | Validation du contract 9 providers | `pack/loader.rs` | #1 |
| 3 | Charger hierarchy.json → semantic_tree | `pack/loader.rs` | #1 |
| 4 | Charger density.json → criticality weights | `pack/loader.rs` | #1 |

### Jour 7

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | Charger role_taxonomy → role_subtrees table | `pack/loader.rs` | J6 |
| 2 | Role→sous-arbre (SOC L1 = 6 tactiques, SOC L2 = 10, DFIR = 14) | `pack/loader.rs` | #1 |
| 3 | Charger apt29_chain.json → scenario store | `pack/loader.rs` | J6 |
| 4 | Endpoints /api/packs/* + /api/roles/{id}/subtree | `backend_rs/src/routes/packs.rs` | J6 |

### Jour 8

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | Tests d'intégration PostgresTreeAdapter | tests/ | J7 |
| 2 | Beth Trunk Validator (Datalog Horn rules) | `backend_rs/src/pack/validator.rs` | WP04 |
| 3 | EventBus : TreeOpPlanted + TreeOpGrafted events | `eventbus/events.rs` | J5 |
| 4 | **Review Sprint 1** + ajustements | — | — |

### Critère de sortie Sprint 1
- ✅ Cyber pack chargé (14 troncs ATT&CK, 130+ feuilles)
- ✅ /api/tree/* répond (plant, graft, prune, nodes, learner_state)
- ✅ /api/roles/{id}/subtree retourne sous-arbre correct
- ✅ Beth Trunk Validator passe

---

## SPRINT 2 — ARENA-LITE + AUTONOMY (Jours 9-14)

### Objectif
Scénario ARENA APT29 jouable avec évaluation de maîtrise.

### WP liés
- **WP07** : Autonomy Envelope (ProofRubric + ValidationGuard)
- **WP08** : Cognitive Policies (5 policies runtime)
- **WP09** : Loop Engineering (4 boucles imbriquées)

### Jour 9

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | ARENA Engine — charger apt29_chain.json | `backend_rs/src/arena/engine.rs` | Sprint 1 |
| 2 | 3 branches décisionnelles APT29 | `arena/scenarios/apt29.rs` | #1 |
| 3 | Step state machine (current_step, choices, score) | `arena/engine.rs` | #1 |
| 4 | Endpoint POST /api/scenarios/apt29/{id} | `routes/scenarios.rs` | #1 |

### Jour 10

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | Endpoint POST /api/scenarios/{id}/react | `routes/scenarios.rs` | J9 |
| 2 | Score de décision (+ feedback immédiat) | `arena/scoring.rs` | J9 |
| 3 | ProofRubricProvider (graduel, 5 critères) | `backend_rs/src/arena/rubric.rs` | WP07 |
| 4 | ValidationGuardProvider (binaire INTERDIT/AUTORISÉ) | `arena/guard.rs` | WP07 |

### Jour 11

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | AutonomyEnvelope (wrapper ProofRubric + ValidationGuard) | `arena/envelope.rs` | WP07 |
| 2 | Cognitive Runtime Policies (5 policies) | `backend_rs/src/policies/mod.rs` | WP08 |
| 3 | Policy : BudgetPolicy, AttentionPolicy, DriftPolicy, MasteryPolicy, AutonomyPolicy | `policies/` | #2 |
| 4 | Integration Policy→ARENA (policy checks before each step) | `arena/engine.rs` | #1 |

### Jour 12

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | Loop Engineering — 4 boucles imbriquées | `backend_rs/src/loops/mod.rs` | WP09 |
| 2 | Micro-loop (step-level), Méso-loop (session), Macro-loop (weekly), Outcome-loop | `loops/` | #1 |
| 3 | Integration Loop→ARENA (scores propagent) | `arena/engine.rs` | J11 |
| 4 | EventBus : ScenarioEvaluated + MasteryUpdated events | `eventbus/events.rs` | Sprint 1 |

### Jour 13

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | COSMOS-lite — 4 modes | `backend_rs/src/cosmos/lite.rs` | Sprint 1 |
| 2 | Mode-Roadmap (arbre SVG via G6 v5 ou SVG natif) | `cosmos/modes/roadmap.rs` | #1 |
| 3 | Mode-Gap-Detect (nœuds rouges = prérequis manquants) | `cosmos/modes/gap_detect.rs` | #1 |
| 4 | Mode-SMI-Radar (radar SMI par tactique) | `cosmos/modes/smi_radar.rs` | #1 |
| 5 | Mode-Raw (vue brute JSON) | `cosmos/modes/raw.rs` | #1 |

### Jour 14

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | Endpoints COSMOS /api/cosmos/{mode} | `routes/cosmos.rs` | J13 |
| 2 | Tests d'intégration ARENA (playthrough complet APT29) | tests/ | J12 |
| 3 | Tests COSMOS-lite (4 modes) | tests/ | J13 |
| 4 | **Review Sprint 2** + ajustements | — | — |

### Critère de sortie Sprint 2
- ✅ Scénario APT29 jouable de bout en bout (< 20 min)
- ✅ 3 branches décisionnelles fonctionnelles
- ✅ Scoring + ProofRubric validés
- ✅ COSMOS-lite 4 modes répondent
- ✅ Learner state (locked→ready→studying→mastered) fonctionnel

---

## SPRINT 3 — ONBOARDING + POLISH (Jours 15-16)

### Objectif
Onboarding complet (< 5 min TTFV) + dashboard SMI + Gap Detection.

### WP liés
- **WP10** : Provider Matrix
- **WP11** : C1-C7 Validator (Proof of Skill)
- **WP12** : D9 Coverage Model

### Jour 15

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | Role-Based Onboarding (4 rôles SOC) | `frontend_react/src/onboarding/` | Sprint 2 |
| 2 | Sélection rôle → chargement sous-arbre | `onboarding/RoleSelector.tsx` | #1 |
| 3 | Dashboard SMI (global + par tactique) | `frontend_react/src/dashboard/SMIDashboard.tsx` | Sprint 2 |
| 4 | Gap Detection (nœuds rouges → prérequis manquants) | `backend_rs/src/routes/gaps.rs` | WP12 |

### Jour 16

| # | Tâche | Fichier cible | Dépendance |
|---|-------|---------------|------------|
| 1 | Frontend polish (transitions, micro-animations, design tokens) | `frontend_react/src/` | #J15 |
| 2 | TTFV < 5 min (Time To First Value) | bench/ | #1 |
| 3 | Scénario APT29 complet en < 20 min | bench/ | Sprint 2 |
| 4 | D9 Coverage Map (R1 × R2 × R3) | WP12 impl | Sprint 2 |
| 5 | **Review Sprint 3** + démo interne | — | — |

### Critère de sortie Sprint 3
- ✅ Onboarding < 5 min (rôle → sous-arbre → première action)
- ✅ Dashboard SMI (global + par tactique + gaps)
- ✅ ARENA APT29 complet en < 20 min
- ✅ D9 Coverage Map fonctionnelle

---

## SPRINT 4 — PRÉ-PRODUCTION (Jours 17-28)

### Objectif
Tests, monitoring, déploiement. Le produit est prêt pour les beta users.

### Jour 17-20 — Tests E2E

| # | Tâche | Outil | Critère |
|---|-------|-------|---------|
| 1 | Parcours E2E Playwright : onboard → tree → scenario → mastery | Playwright | Green |
| 2 | Load test 100 users concurrents | k6 / Artillery | P99 < 500ms |
| 3 | Tests de sécurité (RLS, auth, injection SQL) | — | 0 fail |
| 4 | Property-based testing (FSRS math, D9 weights) | proptest | 1000+ passes |

### Jour 21-23 — Production Hardening

| # | Tâche | Service | Critère |
|---|-------|---------|---------|
| 1 | Monitoring : Sentry + OpenTelemetry minimal | Sentry + OTel | Alerting configuré |
| 2 | TLS 1.3 + JWT auth sur tous endpoints sensibles | Axum middleware | Green |
| 3 | GDPR compliance (k-anonymat D-OPT-029) | — | Legal sign-off |
| 4 | AI Act EU compliance (transparence algorithmique) | — | Legal sign-off |
| 5 | Code freeze + security review | — | 0 P0/P1 |

### Jour 24-26 — Beta

| # | Tâche | Critère |
|---|-------|---------|
| 1 | Deploy backend Northflank (staging) | Green |
| 2 | Deploy frontend Vercel (staging) | Green |
| 3 | Beta : 2-3 SOC teams | Feedback collecté |
| 4 | Fix bugs critiques (P0/P1) | < 5 bugs ouverts |

### Jour 27-28 — Go/No-Go Final

| # | Tâche | Critère |
|---|-------|---------|
| 1 | Déploiement production Northflank + Vercel | Green |
| 2 | TTFV < 5 min en production | Confirmé |
| 3 | APT29 complété en < 20 min en production | Confirmé |
| 4 | **Go/No-Go** : tous les critères remplis ? | GO ou STOP |

---

## Go/No-Go Checkpoints

| Checkpoint | Jour | Critère | Action si NO-GO |
|------------|------|---------|-----------------|
| **Sprint 0 POC** | J2 | 4 POC tests passés (G6, NER, Typst, FTS) | Fallback ou STOP |
| **Sprint 1** | J8 | Pack cyber chargé + Tree API répond | Debug +1 jour |
| **Sprint 2** | J14 | ARENA jouable + COSMOS 4 modes | Simplifier features |
| **Sprint 3** | J16 | TTFV < 5min + APT29 < 20min | Optimiser |
| **Production** | J28 | Tous les Go/No-Go passés | Lancement |

---

## Dépendances Bottom-Up

```
Sprint 0 (fondation)
  └── scy-eventbus ─────┐
  └── scy-shared ───────┐
  └── DB migrations ────┤
                         ├──► Sprint 1 (Semantic Tree + Pack)
                         │     ├── PostgresTreeAdapter
                         │     ├── DomainPackLoader
                         │     └── BethTrunkValidator
                         │           │
                         │           ├──► Sprint 2 (ARENA + Autonomy)
                         │           │     ├── ARENA Engine (APT29)
                         │           │     ├── ProofRubric + ValidationGuard
                         │           │     ├── Cognitive Policies
                         │           │     ├── Loop Engineering
                         │           │     └── COSMOS-lite 4 modes
                         │           │           │
                         │           │           ├──► Sprint 3 (Onboarding + Polish)
                         │           │           │     ├── Role-Based Onboarding
                         │           │           │     ├── Dashboard SMI + Gaps
                         │           │           │     └── D9 Coverage
                         │           │           │           │
                         │           │           │           └──► Sprint 4 (Pré-Production)
                         │           │           │                 ├── Tests E2E
                         │           │           │                 ├── Monitoring
                         │           │           │                 ├── Deploy
                         │           │           │                 └── Beta
                         │           │           │
```

---

## Post-MVP — Extension (M36+)

> Voir `minddoc/s00_prd/scyforge_post_mvp_roadmap.md` pour les critères de réactivation.

| Feature | M36+ | Critère |
|---------|------|---------|
| NEURON-CHAINS (7 chaînes LLM) | M36+ | Expansion multi-domaines |
| ARENA 6 domaines | M36+ | APT29 completion > 70% |
| CHRONICLE (coéquipier quotidien) | M36+ | Adoption B2B stable |
| 11 Ingestion Cores | M36+ | Normal Mode activé |
| B2B Creator Console | M36+ | SOC Manager demande création scénarios |
| Reader Suite + IMPRINT | M36+ | Demande utilisateurs contenu long-form |
| STUDENT AI P8-P9 | M36+ | Usage intensif prouvé |
| LiveKit Voice | M36+ | Budget vocal disponible |

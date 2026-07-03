# index.md — Navigation centralisée de l'architecture SCY Forge

> **🛑 DIRECTIVE DE SÛRETÉ CRITIQUE**  
> Il est formellement interdit de modifier ou de rédiger la moindre ligne de code pour SCY Forge sans avoir lu, assimilé et implémenté les standards de ce répertoire. Tout code non conforme aux patterns définis ci-dessous sera rejeté par les validations CI d'Harmonist.

---

## 1. Navigation rapide — Quel fichier lire ?

| Besoin | Fichier | Description |
|--------|---------|-------------|
| **Comprendre SCY Forge en 10 min** | `minddoc/project_context.md` | Contexte partageable — lire ABSOLUMENT avant toute action |
| **Toutes les décisions D-xxx consolidées** | `scy_architectural_blueprint_master.md` | Blueprint master — 50+ décisions D-xxx, règles d'or, vocabulaire |
| **Cartographie des services** | `scy_service_architecture_map.md` | Carte de tous les services, consumers, événements |
| **Toutes les incohérences connues** | `audit_incoherences.md` | 12 incohérences documentées avec corrections appliquées |
| **Specs d'un Work Package** | `work_packages/WP01` → `WP14` | Specifications atomiques par feature (voir section 7) |
| **Standards Rust (crates)** | `crates_standards/scy_crates_standards_spec.md` | Naming, structure, dependencies Rust |
| **Standards TypeScript** | `scy_agentic_sdlc_standards.md` | AI-SDLC, WHEN-THEN-AND format, RFC 2119 |
| **Patterns multi-agents** | `scy_multi_agent_pipeline_patterns.md` | G6/Three.js, LLMLingua-2, budgets, isolation |
| **LiveKit Voice (POST_MVP)** | `scy_livekit_voice_spec.md` | Voice agent pipeline — Hors beachhead IN_MVP |
| **Pricing tiers** | `pricing_tiers/scy_pricing_tiers_spec.md` | B2C/B2B pricing model |
| **Log de toutes les migrations** | `s99_migration_logs/migration_log.md` | Historique complet des déplacements/suppressions |

---

## 2. Arborescence complète

```
s00_architecture_standards/
├── index.md                          ← CE FICHIER — Navigation centralisée (LIRE EN PREMIER)
├── audit_decisions.md                ← P1 — Table de toutes les décisions D-xxx/AP-xxx/NC-xxx/FLY-xxx/ARC-xxx/D-OPT-xxx (120 décisions)
├── audit_features.md                 ← P1 — Table de toutes les features MVP/Post-MVP (155+ features)
├── audit_patterns.md                 ← P1 — Table de tous les patterns architecturaux (144 patterns)
├── audit_incoherences.md             ← P1 — Rapport d'incohérences (12 incohérences, corrections appliquées)
├── decisions_master.md               ← P2 — Toutes les décisions unifiées (140 décisions consolidées)
├── patterns_master.md                ← P2 — Tous les patterns unifiés (144 patterns, zéro doublon)
├── VALIDATION_CROISEE.md             ← P9 — Rapport de validation finale
│
├── 📋 STANDARDS FONDAMENTAUX
│   ├── scy_architectural_blueprint_master.md    ← D-001 à D-040+ — Toutes les décisions d'architecture consolidées
│   ├── scy_service_architecture_map.md          ← Cartographie services, events, flux inter-services
│   ├── scy_agentic_sdlc_standards.md            ← AI-SDLC : WHEN-THEN-AND, RFC 2119, Spec-Driven Dev
│   ├── scy_multi_agent_pipeline_patterns.md     ← Patterns 18 agents ASCENT, budgets, isolation
│   ├── scy_progressive_automation_spec.md       ← Progressive Automation : niveaux d'autonomie
│   ├── scy_integration_hub_architecture.md      ← Integration Hub — APIs tierces, connectors
│   ├── scy_agentic_vision_complete.md           ← Vision agentique complète SCY Forge
│
├── 📋 SPÉCIFICATIONS DÉPLOIEMENT & SÉCURITÉ
│   ├── scy_deployment_profiles_spec.md          ← Profils de déploiement (Northflank, Vercel, on-prem)
│   ├── scy_livekit_voice_spec.md                ← 🎙️ Voice Agent Pipeline — POST_MVP (M36+)
│   │
│   ├── crates_standards/
│   │   └── scy_crates_standards_spec.md         ← Standards Rust crates (naming, structure, deps)
│   ├── engineering_safeguards/
│   │   └── scy_engineering_safeguards_spec.md   ← Garde-fous ingénierie (CI gates, lints, coverage)
│   ├── infrastructure_securite/
│   │   └── scy_infra_sec_spec.md                ← Infrastructure sécurité (RLS, secrets, access)
│   ├── pricing_tiers/
│   │   └── scy_pricing_tiers_spec.md            ← Pricing model (Trial/Team/Enterprise/Industry/Gov)
│   ├── ux_ui_features/
│   │   └── scy_ux_ui_spec.md                    ← UX/UI standards (design tokens, composants)
│   └── wasm_edge_computing/
│       └── scy_wasm_edge_spec.md                ← WASM + Edge Computing specs
│
├── 📋 WORK PACKAGES — Specifications par feature
│   └── work_packages/
│       ├── WP01_DCID_TRAITS.md          ← 🔴 P0 — SemanticTreeProvider trait + DCID
│       ├── WP02_SQL_MIGRATIONS.md       ← 🔴 P0 — Schéma PostgreSQL (scy_tree_nodes, edges, seeds)
│       ├── WP03_EVENTBUS_CRATE.md       ← 🔴 P0 — EventBus 18 events + DLQ + ValidationGate
│       ├── WP04_PACK_PROVIDERS.md       ← 🔴 P0 — PackConfigProvider + PackJsonSchemaProvider
│       ├── WP05_POSTGRES_ADAPTER.md     ← 🔴 P0 — SemanticTreeProvider Postgres impl
│       ├── WP06_SEED_STATUS.md          ← 🟠 P1 — Seed lifecycle (DORMANT ≠ mort)
│       ├── WP07_AUTONOMY_ENVELOPE.md    ← 🟠 P1 — Autonomy Envelope matrix
│       ├── WP08_COGNITIVE_POLICIES.md   ← 🟠 P1 — 5 Cognitive Runtime Policies
│       ├── WP09_LOOP_ENGINEERING.md     ← 🟠 P1 — 4 boucles imbriquées (Micro/Meso/Macro/Outcome)
│       ├── WP10_PROVIDER_MATRIX.md      ← 🟠 P1 — Feature → Provider mapping
│       ├── WP11_C1C7_VALIDATOR.md       ← 🟡 P2 — C1-C7 Use Case validators
│       ├── WP12_D9_COVERAGE.md          ← 🟡 P2 — D9 weighted coverage model
│       ├── WP13_DEPLOYMENT_PROFILES.md  ← 🟡 P2 — Profiles de déploiement
│       └── WP14_CYBER_PACK.md           ← 🟡 P2 — MITRE ATT&CK Domain Pack
│
└── 📋 MIGRATION LOGS
    └── s99_migration_logs/
        └── migration_log.md             ← Historique de toutes les migrations documentaires
```

---

## 3. Standards fondamentaux — Description détaillée

### 3.1 `scy_architectural_blueprint_master.md` — Le guide maître

**Contenu** :
- Toutes les décisions d'architecture (D-001 à D-040+)
- 10 règles d'or (R1-R10) — NON-NÉGOCIABLES
- Vocabulaire canonique (50+ termes)
- Les 3 piliers
- Stack technique
- Beachhead MVP (Jours 1-28)
- Ordre d'implémentation bottom-up

**Ordre de lecture** : LIRE EN DEUXIÈME, après `minddoc/project_context.md`.

### 3.2 `scy_service_architecture_map.md` — La carte des services

**Contenu** :
- 7 services core (EventBus, Semantic Tree, APEX/FSRS, COSMOS, Tactical AI, BudgetGuard, GFE)
- 3 consommateurs (ASCENT 18 agents, Certifier, COSMOS UI)
- 18 événements EventBus + flux
- Consumer layer (API Gateway, Auth, Dashboards)
- Data layer (PostgreSQL, Zilliz, SearxNG)
- Event catalog détaillé

### 3.3 `scy_agentic_sdlc_standards.md` — AI-SDLC

**Contenu** :
- WHEN-THEN-AND format (remplace Gherkin)
- RFC 2119 vocabulary (MUST, SHOULD, MAY)
- Spec-Driven Development flow
- Template de spec standardisé
- Critères d'acceptation

### 3.4 `scy_multi_agent_pipeline_patterns.md` — Patterns agents

**Contenu** :
- 18 agents ASCENT (13 IN_MVP + 5 POST_MVP)
- Patterns d'orchestration (Mastra)
- Budgets LLM par agent
- Isolation d'accessibilité
- LLMLingua-2 local
- Retry + DLQ patterns

### 3.5 `scy_progressive_automation_spec.md` — Progressive Automation

**Contenu** :
- Niveaux d'autonomie (N1 → N5)
- Règle : zéro friction, 2 clics
- Classe d'alerte × Risque → Mode
- Autonomy Envelope

---

## 4. Spécialisations — Où trouver quoi

| Domaine | Fichier |
|---------|---------|
| **Crates Rust** | `crates_standards/scy_crates_standards_spec.md` — naming CamelCase/PascalCase, visibilité, error handling |
| **Engineering Safeguards** | `engineering_safeguards/` — CI gates, clippy, test coverage ≥ 80%, property-based testing |
| **Infrastructure Sécurité** | `infrastructure_securite/` — RLS, secrets management, access tokens |
| **Pricing Tiers** | `pricing_tiers/` — B2C vs B2B, Trial/Team/Enterprise/Industry/Government |
| **UX/UI** | `ux_ui_features/` — Design tokens, composants APEX UI, conventions Tailwind |
| **WASM/Edge** | `wasm_edge_computing/` — WASM deployment, edge functions |
| **LiveKit Voice** | `scy_livekit_voice_spec.md` — Voice pipeline ARENA/BRAIN/CHRONICLE/COSMOS/DAG (**POST_MVP**) |

---

## 5. Work Packages — Ordre d'implémentation

LesWP sont ordonnés **bottom-up** (fondation d'abord, consommateurs ensuite) :

```
Dépendances :
WP01 → WP02 → WP03 → WP04 → WP05 (chaîne fondation)
                                  ↓
WP06 ← WP05 (Seed lifecycle)
WP07 ← WP05 (Autonomy Envelope)
WP08 ← WP05 (Cognitive Policies)
WP09 ← WP07 (Loop Engineering)
WP10 ← WP05-WP09 (Provider Matrix)
WP11 ← WP10 (C1-C7 Validators)
WP12 ← WP05 (D9 Coverage)
WP13 ← WP12 (Deployment Profiles)
WP14 ← WP01-WP05 (Cyber Pack)
```

**Criticité** :
- 🔴 P0 : Bloquant pour tout le reste (WP01-WP05)
- 🟠 P1 : Dépend de P0 (WP06-WP10)
- 🟡 P2 : Dépend de P1 (WP11-WP14)

---

## 6. Où sont les décisions d'architecture ?

| Notation | Fichier | Exemple |
|----------|---------|---------|
| D-xxx | `scy_architectural_blueprint_master.md` | D-019 (DCID), D-020 (Domain Pack Contract) |
| AP-xxx | `scy_architectural_blueprint_master.md` | AP-001 (architecture pattern) |
| NC-xxx | `scy_architectural_blueprint_master.md` | NC-004 (nomenclature gap) |
| D-OPT-xxx | `scy_architectural_blueprint_master.md` | D-OPT-030 (optimization decision) |
| ARC-xxx | `scy_architectural_blueprint_master.md` | ARC-001 (architectural record) |
| FLY-xxx | `scy_architectural_blueprint_master.md` | FLY-010 (flyweight pattern) |

**Règle** : Toute décision D-xxx/AP-xxx/NC-xxx doit être référencée dans le blueprint master. Si une décision existe dans un autre document, elle a été unifiée dans le blueprint master.

---

## 7. Lecture séquentielle recommandée

**Pour un nouvel agent** :
1. `minddoc/project_context.md` (10 min — vision, stack, règles d'or)
2. `scy_architectural_blueprint_master.md` (30 min — décisions D-001 à D-040)
3. `scy_service_architecture_map.md` (15 min — services, events, flux)
4. `work_packages/WP01_DCID_TRAITS.md` (spec avant implémentation)
5. `work_package_02_sql_migrations.md` → `WP03_EVENTBUS_CRATE.md` → ... (ordre bottom-up)

**Pour l'Architecte Documentaire** (cette phase) :
1. `audit_incoherences.md` (toutes les corrections appliquées)
2. `s99_migration_logs/migration_log.md` (traçabilité des migrations)
3. Tous les sous-dossiers spécialisés (crates, safeguards, infra, UX)

---

## 8. Règles de navigation

- ✅ **TOUJOURS** commencer par `index.md` (ce fichier)
- ✅ **TOUJOURS** lire `minddoc/project_context.md` avant de coder
- ✅ **TOUJOURS** vérifier la section Work Packages avant d'implémenter une feature
- ❌ **JAMAIS** modifier un WP sans validation humaine
- ❌ **JAMAIS** coder avant d'avoir lu le WP correspondant
- ❌ **JAMAIS** ignorer les dépendances entre WP

---

*index.md — SCY Forge Architecture Standards — V2.0 — 2026-07-02*
*Généré pendant la Phase 2 (Unification Architecture)*

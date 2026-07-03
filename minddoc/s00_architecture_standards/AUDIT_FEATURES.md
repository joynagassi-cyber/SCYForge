# AUDIT_FEATURES.md — Table de toutes les features MVP et Post-MVP

> **Phase 1** — Livrable d'audit documentaire
> **Source** : `MASTER_AGENT_PROMPT_V2.md` §4.1.3
> **Date** : 2026-07-03
> **Auteur** : Architecte Documentaire SCY Forge

---

## 1. Features IN_MVP (Jours 1-28 — Cyber Beachhead)

### 1.1 Semantic Tree + DCID Infrastructure

| # | Feature | Priorité | Dépendances | Description | Source |
|---|---------|----------|-------------|-------------|--------|
| 1 | Semantic Tree + DCID | P0 | — | Core agnostic au domaine, DAG de nœuds sémantiques | Blueprint D-019/D-020 |
| 2 | SemanticTreeProvider Trait (DCID Bridge) | P0 | WP01 | 5 opérations canoniques : plant_tree, graft_node, test_node, prune_node, myelinate_node | WP01 |
| 3 | 9 DCID Providers | P0 | WP01 | SemanticTreeProvider (PRIMARY) + 8 providers optionnels | Blueprint D-020 |
| 4 | DomainFilterProvider (C1-C7) | P0 | WP01 | Validation seed 7 critères (Grounded, Pivot, Criticality, Decision, Provable, Bounded, Reproducible) | WP01 |
| 5 | PackConfig Cascade Resolution | P0 | WP04 | Résolution cascade Learner → Organization → DomainPack | WP01, WP04 |
| 6 | 3 Semantic Tree Instances | P0 | WP05 | DomainPack, Organization, Learner — même type | Blueprint D-020 |
| 7 | EdgeKind Composite (7 kinds) | P0 | WP01 | Trunk/Branch/Leaf + Prereq/Relates/Contradicts/Supersedes | WP01 |
| 8 | Confidence = Source de vérité | P0 | WP01 | mastery_score et status dérivés de confidence | Blueprint D-008 |
| 9 | Core Agnostic Rule (R1) | P0 | WP01 | Zéro terme métier cyber dans le core | Blueprint D-019 |

### 1.2 ASCENT Pipeline — Plan C (13 Agents IN_MVP)

| # | Feature | Priorité | Dépendances | Description | Source |
|---|---------|----------|-------------|-------------|--------|
| 10 | ASCENT Plan C — 13 Agents | P0 | WP01-WP05 | Pipeline 13 agents orchestrés via EventBus | Blueprint D-010 |
| 11 | AGENT-01 Goal-Interpreter | P0 | WP01 | Parse objectif → LearningGoal, Starter Evaluator, Dynamic Graph Splitting | PRD §4.2 |
| 12 | AGENT-02 Content-Scout | P0 | WP01 | Auto-découverte sources, SharedContentCache, Semantic dedup | PRD §4.2 |
| 13 | AGENT-03 DAG-Architect | P0 | WP01-WP05 | Build CompetenceDAG, orchestre NEURON-CHAINS, APEX, BRAIN | PRD §4.2 |
| 14 | AGENT-04 Learning-Conductor | P0 | WP01-WP09 | Orchestrateur sessions, Twin-Engine FSRS↔Bloom, Habit Formation J1-J30 | PRD §4.2 |
| 15 | AGENT-05 Performance-Analyzer | P0 | WP01-WP09 | SMI 5-dim (R/D/M/C/H), Flow State, SDT Satisfaction | PRD §4.2 |
| 16 | AGENT-06 Adaptive-Router | P0 | WP01-WP09 | Routing: Fast-Track/Normal/Consolidation/Remediation, Interleaved 70/30 | PRD §4.2, D-OPT-049 |
| 17 | AGENT-07 Drift-Guardian | P0 | WP01-WP09 | 8 signaux abandon, interventions L1-L4, Dunning-Kruger Calibration | PRD §4.2, D-OPT-054 |
| 18 | AGENT-08 Engagement-Amplifier | P0 | WP01-WP09 | SDT gamification (XP, streak, badges), Variable Reward, Weekly Report | PRD §4.2 |
| 19 | AGENT-09 Skill-Certifier | P0 | WP01-WP05 | Proof of Skill PDF, LinkedIn badge, SurveyJS exam, manager sign-off | PRD §4.2 |
| 20 | EventBus 18 Events | P0 | WP03 | Pub/sub async, zéro appel direct inter-services | WP03, Blueprint D-010 |
| 21 | Token Optimization Pipeline | P0 | WP03 | LLMLingua-2, Batch API, SharedContentCache, SemanticCache, ModelRouter | PRD §7.1 |
| 22 | BudgetGuard | P0 | WP03 | Télémétrie coût live, mode économie auto à 80%, blocage à 100% | Blueprint AP-006 |

### 1.3 COSMOS V5 — VizSpec Catalog (Cyber 4 Modes)

| # | Feature | Priorité | Dépendances | Description | Source |
|---|---------|----------|-------------|-------------|--------|
| 23 | COSMOS V5 VizSpec Catalog | P0 | WP01-WP05 | Remplace plugin architecture. 6 viz noyau, 8 Use Case Intentions C1-C8 | `s04/SCY_COSMOS_V5_VIZSPEC_CATALOG.md` |
| 24 | Mode Mission Tree | P0 | WP05, COSMOS | Hiérarchie tactiques ATT&CK en arbre navigable | PRD §5, WP05 |
| 25 | Mode SMI Radar | P0 | WP09, COSMOS | Radar 5-dimensions maîtrise techniques | PRD §5, WP09 |
| 26 | Mode Threat Terrain | P0 | WP05, COSMOS | Cartes relations techniques ATT&CK | PRD §5, WP05 |
| 27 | Mode Tactical Zoom | P0 | WP05, COSMOS | Zoom sémantique Enterprise→Tactic→Technique→Sub-technique | PRD §5, WP05 |
| 28 | COSMOS Agent-as-Canvas | P0 | COSMOS | Agents créent/lancent/configurent modes automatiquement | Blueprint PAT-09 |
| 29 | Progressive Rendering 4 Phases | P0 | COSMOS | WebGL Constellation → Hubs → Cards → Stabilisation | FLY-019 |

### 1.4 APEX / FSRS — Retention Engine

| # | Feature | Priorité | Dépendances | Description | Source |
|---|---------|----------|-------------|-------------|--------|
| 30 | APEX FSRS Retention Engine | P0 | WP01-WP03 | FSRS 5.0, Twin-Engine FSRS↔Bloom Loop | PRD §4.5, WP08 |
| 31 | APEX B11-B14 Cards (Cyber) | P0 | WP14 | IOC (B11), Kill Chain (B12), Chain-of-Custody (B13), Artifact Correlation (B14) | PRD §4.5 |
| 32 | FSRS Stability Gate before ARENA | P0 | WP08 | Stabilité ≥ 3.0 jours requis avant simulation ARENA | D-OPT-051 |

### 1.5 Tactical AI

| # | Feature | Priorité | Dépendances | Description | Source |
|---|---------|----------|-------------|-------------|--------|
| 33 | Tactical AI Chat | P0 | WP01 | Chat contextuel DeepSeek V4 Free ($0) | PRD §4.3 |
| 34 | Tactical AI Hints | P0 | WP01 | Hints contextuels adaptés au niveau utilisateur | PRD §4.3 |

### 1.6 SOC Manager Dashboard

| # | Feature | Priorité | Dépendances | Description | Source |
|---|---------|----------|-------------|-------------|--------|
| 35 | SOC Manager Dashboard | P0 | WP09-WP12 | Coverage Map, Gap Detection, Team Readiness Report | PRD §4.6 |
| 36 | Coverage Map | P0 | WP12 | D9 weighted coverage, target ≥80% | WP12 |
| 37 | Gap Detection | P0 | WP09 | Écart prérequis manquants, ≤5% faux négatifs | WP09 |
| 38 | Readiness Score | P0 | WP09 | Score ≥85% avant certification Proof of Skill | PRD §4.6 |

### 1.7 Role-Based Onboarding

| # | Feature | Priorité | Dépendances | Description | Source |
|---|---------|----------|-------------|-------------|--------|
| 39 | Role-Based Onboarding | P0 | WP01-WP05 | SOC L1/L2/DFIR en <5min, Role Subtrees auto-générés | PRD §4.7 |
| 40 | SOC L1 Subtree (6 tactics) | P0 | WP14 | Reconnaissance → Privilege Escalation | PRD §2.2 |
| 41 | SOC L2 Subtree (10 tactics) | P0 | WP14 | 10 tactiques core | PRD §2.2 |
| 42 | DFIR Subtree (14 tactics) | P0 | WP14 | 14 tactiques complètes | PRD §2.2 |

### 1.8 Certification

| # | Feature | Priorité | Dépendances | Description | Source |
|---|---------|----------|-------------|-------------|--------|
| 43 | Proof of Skill Cert | P0 | WP09, WP14 | Manager sign-off, 5 formats, APT29 cert scenario | PRD §4.8, WP11 |
| 44 | LinkedIn Badge (Open Badges) | P0 | WP14 | Certification exportable standard Open Badges | PRD §4.8 |

### 1.9 Generative Forest Engine — Mode Observatoire

| # | Feature | Priorité | Dépendances | Description | Source |
|---|---------|----------|-------------|-------------|--------|
| 45 | GFE — Pollination Intra-domaine MITRE | P0 | WP06 | Croisement structuré branches MITRE, Seeds stockées | Blueprint D-021 |
| 46 | GFE — Seed Lifecycle | P0 | WP06 | POLLINATED → VIABLE / DORMANT → GERMINATING | WP06, Blueprint D-022 |
| 47 | Seed Explorer Interface | P0 | WP06 | Interface visualisation Seeds, Viability/Fecundity scores | PRD §2.6 |
| 48 | Seed Traceability (PROV + Bitemporal) | P0 | WP06 | Lignée immuable W3C PROV-DM + bitemporel | Blueprint D-022 |
| 49 | Vision Helm | P0 | WP06 | Vecteur k-dim + graphe objectifs, align() | Blueprint D-021 |

### 1.10 Stud

# scyforge_mvp_golden_master.md — PRD consolidé MVP (Jours 1-28)

> **Source de vérité unique** pour le MVP SCY Forge — Cyber SOC/Blue-Team Beachhead
> **Date** : 2026-07-03
> **Version** : V3.0 (aligné architecture D-010, D-019, D-020, D-021, D-022, D-024, D-025, D-026)
> **Règle** : Ce document remplace tous les PRD partiels précédents. Toute contradiction avec ce document = erreur.

---

## 1. Vision (3 phrases)

SCY Forge est une infrastructure de maîtrise opérationnelle cyber : un SOC Manager déclare un rôle à former, SCY Forge charge un Domain Pack (MITRE ATT&CK), construit un Semantic Tree, et orchestre la conversion du savoir privé de l'entreprise en autonomie vérifiable pour les recrues.

Le système combine un **Semantic Tree** (substrat unique : cerveau apprenant + savoir entreprise + architecture produit), des **Domain Packs chargeables** (le cœur ne sait RIEN de la cybersécurité), et une **pipeline ASCENT** (18 agents consommateurs de contracts domaine) pour la rétention FSRS, la visualisation COSMOS V5 et la certification Proof of Skill.

**Value Proposition** : *"Votre SOC recrute. SCYForge transforme ses SOPs en autonomie opérationnelle prouvée — sans dépendre des seniors."*

---

## 2. Beachhead MVP

**Marché cible** : Cyber SOC / Blue-Team (Pure-players + Corporate)
**Personas** : SOC Analyst L1, SOC Analyst L2, DFIR, Security Enablement Lead
**Source de contenu** : MITRE ATT&CK (pré-ingéré, $0 LLM)
**Durée** : Jours 1-28
**Statut** : IN_MVP

### 2.1 Features IN_MVP (8 modules)

| # | Module | Description | Priorité |
|---|--------|-------------|----------|
| 1 | Semantic Tree + DCID | Core agnostic, DAG nœuds sémantiques, 9 providers DCID | P0 |
| 2 | ASCENT Pipeline (13 agents) | 13 agents IN_MVP orchestrés via EventBus | P0 |
| 3 | COSMOS V5 | VizSpec catalog — 4 modes cyber (Mission Tree, SMI Radar, Threat Terrain, Tactical Zoom) | P0 |
| 4 | APEX B11-B14 | Cartes cyber (IOC, Kill Chain, Chain-of-Custody, Artifact Correlation) | P0 |
| 5 | Tactical AI | Chat contextuel DeepSeek V4 Free ($0) + hints | P0 |
| 6 | SOC Manager Dashboard | Coverage Map, Gap Detection, Readiness Score | P0 |
| 7 | Role-Based Onboarding | SOC L1/L2/DFIR en <5min | P0 |
| 8 | Proof of Skill Cert | Manager sign-off, 5 formats, LinkedIn badge | P0 |
| 9 | GFE (mode observatoire) | Pollination intra-domaine MITRE + Seeds stockées | P0 |
| 10 | STUDENT AI (7 improvements) | MSS, concept depth 0-7, pedagogical/LLM separation, metacognition, report visualization, extended FSRS, explanation profiles | P0 |

### 2.2 Features différées Post-MVP

| Feature | Raison | Réactivation |
|---------|--------|-------------|
| NEURON-CHAINS (7 chaînes LLM) | Contenu pré-construit dans pack MVP | M36+ |
| ARENA (roleplay Full-AI) | Campus virtuel + HSM Persona | M36+ |
| CHRONICLE (coéquipier quotidien) | Voice-first + micro-révisions | M36+ |
| 11 Ingestion Cores | YouTube, Reddit, TikTok, etc. | M36+ |
| Normal Mode + B2B Creator Console | Expansion B2B créateurs | M36+ |
| Reader Suite + IMPRINT | Lecture active + écriture motrice | M36+ |
| Finance Suite | Module métier dédié | M36+ |
| Gamification complète | XP, niveaux, badges étendus | M36+ |
| STUDENT AI P8 (Presentation Mode) | Mode présentation | M36+ |
| STUDENT AI P9 (Collective Intelligence) | Intelligence collective | M36+ |
| LiveKit Voice Pipeline | Voice Agent Pipeline | M36+ |
| B2C Consumer pricing | Marché grand public | M36+ |
| Analytics Pipeline (AG17) | Pipeline analytics avancé | M36+ |

---

## 3. Architecture

### 3.1 Stack technique

| Couche | Technologie | Version |
|--------|-------------|---------|
| Backend calcul | Rust + Axum + Tokio | Edition 2021 |
| Backend orchestration | TypeScript + Mastra | Node 20+ |
| Frontend | React 18 + Vite + TailwindCSS | React 18.3 |
| DB Cloud | PostgreSQL 15+ (Northflank) + pgvector | — |
| DB Desktop | SQLite WAL (rusqlite 0.31) | — |
| Vectoriel | Zilliz Cloud (Serverless) / Milvus Lite | — |
| LLM | DeepSeek V4 (Free) / Claude (Premium) | — |
| Déploiement | Northflank (backend) + Vercel (frontend) | — |

### 3.2 Les 3 Piliers

| # | Pilier | Code | Rôle |
|---|---|---|---|
| 1 | Semantic Tree + DCID | Pilier 1 | Structure du savoir |
| 2 | ASCENT Pipeline | Pilier 2 | Transmission du savoir — 18 agents (13 IN_MVP + 5 POST_MVP) |
| 3 | Generative Forest Engine | Pilier 3 | Création de savoir nouveau — mode observatoire MVP |

### 3.3 Décisions clés (top 10)

| ID | Décision | Impact |
|----|----------|--------|
| D-019 | DCID — Core agnostic, SemanticTreeProvider seul pont | Contractuel |
| D-020 | 9 Providers DCID — ValidationGuard=binaire, ProofRubric=graduel | Contractuel |
| D-010 | 18 agents ASCENT via EventBus — zéro appel direct | Architecture |
| D-024 | Extensibilité par conception — surpasse D-001 à D-022 | Règle suprême |
| D-025 | Loop Engineering — 4 boucles imbriquées | Governance |
| D-026 | Cognitive Runtime Policies — 5 policies | Governance |
| D-021 | GFE mode observatoire — Seeds stockées, pas germination auto | MVP |
| D-011 | Typestate Pattern — Locked→Ready→Studying→Mastered | Type-safe |
| D-004 | Monolithe Unifié — Node.js/TS + Rust co-locés | Deployment |
| D-001 | Architecture Hexagonale — Domain/Ports/Adapters | Architecture |

---

## 4. Ordre d'implémentation (Bottom-Up)

```
Phase 0 (fondation) :
1. EventBus (tout le monde en dépend)
2. PostgreSQL + Zilliz + RLS
3. scy-semantic-tree (SemanticTreeProvider trait + DCID)

Phase 1 (services core) :
4. scy-pack-ingestion (MITRE STIX parser + Semantic Tree builder)
5. scy-apex-fsrs (FSRS + B11-B14 cards)
6. scy-cosmos-kg (4 modes cyber — COSMOS V5)

Phase 2 (services interactifs) :
7. scy-tactical-ai (DeepSeek V4 Free chat + hints)
8. scy-budgetguard (LLM monitoring)
9. scy-gfe (Generative Forest Engine — mode observatoire)

Phase 3 (consumers) :
10. ASCENT Pipeline (13 agents IN_MVP)
11. Certifier (Proof of Skill + manager sign-off)
12. pack-cyber/ (implémentation MITRE du trait)
```

---

## 5. Règles d'or (NON-NÉGOCIABLES)

| # | Règle | Pourquoi |
|---|-------|----------|
| R1 | Zéro terme métier cyber dans le core | Le core doit être générique (finance, santé, etc.) |
| R2 | Tout seuil est pack-défini | mastery_threshold, weights, helm_axes viennent du pack |
| R3 | Extensibilité par conception | Un nouveau domaine = un nouveau pack. Zéro réécriture du noyau. |
| R4 | EventBus obligatoire | Zéro appel direct inter-services. |
| R5 | 9 Providers DCID | Chaque domain pack implémente 9 providers canoniques. |
| R6 | 3 instances du Semantic Tree | DomainPack, Organization, Learner — même type. |
| R7 | Seed Lifecycle préservé | Aucune Seed n'est détruite. DORMANT ≠ mort. |
| R8 | Confiance = source de vérité | confidence (0.0-1.0) est source. mastery_score et status sont dérivés. |
| R9 | Typestate Pattern | Transitions d'état type-safe au niveau Rust. |
| R10 | Spécifications d'abord | spec → plan → tasks → tests → code. |

---

## 6. Métriques cibles

| Métrique | Cible |
|----------|-------|
| Time-to-Autonomy (SOC L1) | < 90 jours |
| SMI Global moyen (équipe) | 0.0 → 0.70 en 28 jours |
| Senior Mentoring Hours économisées | -60% |
| Coverage ATT&CK (rôle) | 100% tactiques requises à SMI ≥ 0.70 |
| Readiness Score | ≥ 85% avant certification |
| NPS SOC Manager | > 50 |
| Rétention J30 | > 60% |
| Coût infrastructure initial | ~$35/mois |

---

## 7. Pricing IN_MVP

| Tier | Prix/an | Cible | Inclus | Statut |
|------|---------|-------|--------|--------|
| Trial | 0 $ (30j) | 5 analysts | 1 pack MITRE, 1 secteur | ✅ IN_MVP |
| Team | 5 000 $ | 5-20 analysts | MITRE + 1 secteur, Manager dashboard | ✅ IN_MVP |
| Enterprise | 25 000 $ | 20-100 analysts | Multi-pack, SSO/SAML, analytics avancés | ✅ IN_MVP |
| Industry | 50 000 $+ | RSSI + tous employés | Custom sector pack + B2B2C deployment | ⏸️ POST_MVP |
| Government | Custom | Secteur public | On-prem, FedRAMP, custom ontology | ⏸️ POST_MVP |
| B2C Consumer | — | Grand public | — | ⏸️ POST_MVP |

---

## 8. Feuille de route Post-MVP (M36+)

| Phase | Features |
|-------|----------|
| M36+ | NEURON-CHAINS (7 chaînes LLM), ARENA (roleplay Full-AI), CHRONICLE (coéquipier quotidien) |
| M36+ | 11 Ingestion Cores, Normal Mode + B2B Creator Console |
| M36+ | Reader Suite + IMPRINT, Finance Suite, Gamification complète |
| M36+ | STUDENT AI P8-P9, LiveKit Voice Pipeline, B2C Consumer |
| M36+ | ASCENT AG14-AG18 (5 agents POST_MVP) |

---

## 9. Structure de la documentation

```
minddoc/
├── s00_architecture_standards/    ← Architecture unifiée (INDEX, DECISIONS_MASTER, PATTERNS_MASTER)
├── s00_prd/                       ← PRD (CE DOCUMENT + audit_prd_vs_architecture.md)
├── s00_design/                    ← Maquettes + design system
├── s01_semantic_tree/             ← Specs Semantic Tree + DCID
├── s02_neuron_chains_apex_agent/  ← Specs NEURON-CHAINS (Post-MVP)
├── s03_ascent_pipeline_agents/    ← Specs ASCENT (18 agents)
├── s04_scy_cosmos_visualization_engine/ ← Specs COSMOS V5
├── s05_apex_retention_system/     ← Specs APEX/FSRS
├── s06_scy_brain_rag_assistant/   ← Specs BRAIN (Post-MVP)
├── s07_scy_imprint_cognitive/     ← Specs IMPRINT (Post-MVP)
├── s08_scy_reader_suite/          ← Specs Reader Suite (Post-MVP)
├── s09_harmonist_validation_gates/ ← Specs Harmonist
├── s10_normal_mode_ingestion/     ← Specs Normal Mode (Post-MVP)
├── s11_neuroscientific_engine/    ← Specs Neuro Engine (Post-MVP)
├── s12_b2b_creator_console/       ← Specs B2B (Post-MVP)
└── s13_pivotiq_reconciliation/    ← Specs PIVOTIQ (Post-MVP)
```

---

## 10. Ordre d'implémentation Bottom-Up

**Phase 0 (fondation)** : EventBus → PostgreSQL + Zilliz → Semantic Tree
**Phase 1 (services core)** : Pack Ingestion → APEX/FSRS → COSMOS V5
**Phase 2 (services interactifs)** : Tactical AI → BudgetGuard → GFE
**Phase 3 (consumers)** : ASCENT 13 agents → Certifier → pack-cyber

---

*scyforge_mvp_golden_master.md — SCY Forge — V3.0 — 2026-07-03*
*Source de vérité unique MVP. Toute contradiction avec ce document = erreur.*

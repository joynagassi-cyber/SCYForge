# scyforge_post_mvp_roadmap.md — Features différées Post-MVP (M36+)

> **Phase 3** — Livrable d'alignement PRD + Architecture
> **Date** : 2026-07-03
> **Version** : V1.0
> **Règle** : Toute feature Post-MVP doit avoir un critère de réactivation clair.

---

## 1. Features différées

### 1.1 NEURON-CHAINS (7 chaînes LLM)

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | Contenu pré-construit dans pack cyber MVP. Génération LLM à la volée différée. |
| **Critère réactivation** | M36+ — expansion multi-domaines nécessitant génération de contenu à la volée |
| **Dépendances** | NC-001, NC-002, NC-003, NC-005, NC-006 |
| **Référence** | `scy_prd_part_3_neuron_chains.md` (DEFERRED) |

**Contenu** : 7 chaînes LLM (Alpha → Zeta), 18 outils natifs Rust, L0-L4 MapReduce pipeline, anti-hallucination 3 couches.

### 1.2 ARENA (roleplay Full-AI)

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | Campus virtuel + HSM Persona — complexité élevée, MVP = contenu pré-construit |
| **Critère réactivation** | M36+ — Proof of Skill ARENA (Theory + Practice cert) |
| **Dépendances** | D-OPT-051 (FSRS Stability Gate), LiveKit Voice (AG14), APEX FSRS |
| **Référence** | `scy_agentic_vision_complete.md` (Phase 0) |

**Contenu** : Monde simulé peuplé IA, HSM Persona 5 états, sessions 20-30min, debrief avec score + APEX remediation cards.

### 1.3 CHRONICLE (coéquipier quotidien)

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | Voice-first + micro-révisions — dépend de LiveKit Voice |
| **Critère réactivation** | M36+ — si adoption B2B stable + budget vocal disponible |
| **Dépendances** | AG14-LiveKit Voice, D-OPT-048 (Boost Sommeil), D-OPT-055 (Tiny Habit) |
| **Référence** | `scy_livekit_voice_spec.md` (POST_MVP) |

**Contenu** : Coéquipier quotidien, micro-révisions, Dream Session hypnagogique, Cross-Domain Discovery, Voice-First Learning.

### 1.4 11 Ingestion Cores

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | MVP = MITRE ATT&CK pré-ingéré ($0). Cores externes = coût LLM. |
| **Critère réactivation** | M36+ — Normal Mode + expansion multi-domaines |
| **Dépendances** | D-017 (Reactive Streams), Nango Integration Hub |
| **Référence** | `minddoc/s01_ingestion_cores/` (13 cores documentées) |

**Contenu** : YouTube, Reddit, TikTok, Wikipedia, Twitter/X, Google Drive, Podcast, Academic, Financial, Science, ePub, Anki.

### 1.5 Normal Mode + B2B Creator Console

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | MVP = ASCENT Mode (agent-driven). Normal Mode = B2B créateurs indépendants. |
| **Critère réactivation** | M36+ — si marché B2C validé |
| **Dépendances** | PIVOTIQ Multi-Source Reconciliation, 11 Ingestion Cores |
| **Référence** | `minddoc/s10_normal_mode_ingestion/` |

### 1.6 Reader Suite + IMPRINT

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | MVP = Tactical AI chat. Reader Suite = lecture active approfondie. |
| **Critère réactivation** | M36+ — si demande utilisateurs pour contenu long-form |
| **Dépendances** | D-OPT-052 (Leech-Blocking Cran-5 IMPRINT), FLY-021 (Source-Linked Nodes) |
| **Référence** | `minddoc/s08_scy_reader_suite/`, `minddoc/s07_scy_imprint_cognitive/` |

### 1.7 Finance Suite

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | Module métier dédié — MVP concentré sur cyber beachhead |
| **Critère réactivation** | M36+ — expansion secteur finance |
| **Référence** | `minddoc/s14_finance_suite/` |

### 1.8 Gamification complète

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | MVP = XP/streak/badges basiques (AG-08). Gamification complète = modes avancés. |
| **Critère réactivation** | M36+ — si rétention J30 < 60% nécessite renforcement |
| **Référence** | AG-08 Engagement-Amplifier (IN_MVP basique) |

### 1.9 STUDENT AI P8-P9 (Post-MVP)

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | P1-P7 IN_MVP. P8 (Presentation Mode) + P9 (Collective Intelligence) = Post-MVP |
| **Critère réactivation** | M36+ — si adoption B2B stable |
| **Référence** | `minddoc/s03_ascent_pipeline_agents/student_ai/student_ai_improvements.md` |

### 1.10 LiveKit Voice Pipeline

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | Voice Agent Pipeline — hors beachhead IN_MVP |
| **Critère réactivation** | M36+ — si adoption vocale justifiée |
| **Dépendances** | AG14-LiveKit Voice, AG15-Gaming/Dual, AG16-Social Recruiting |
| **Référence** | `scy_livekit_voice_spec.md` |

### 1.11 B2C Consumer Pricing

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | Marché grand public — MVP concentré B2B SOC |
| **Critère réactivation** | M36+ — si infrastructure B2B mature et scalable |
| **Référence** | `scyforge_pivot_architecture.md` §9.5 |

### 1.12 Analytics Pipeline (AG17)

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | 5e agent POST_MVP — analytics avancés au-delà du dashboard SOC Manager |
| **Critère réactivation** | M36+ — si volume données nécessite analytics prédictifs |
| **Référence** | `decisions_master.md` D-010 |

### 1.13 Advanced Orchestration (AG18)

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | 5e agent POST_MVP — orchestration avancée multi-objectifs |
| **Critère réactivation** | M36+ — si complexité multi-domaines le justifie |
| **Référence** | `decisions_master.md` D-010 |

### 1.14 Gaming/Dual Mode (AG15)

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | Mode jeu sérieux — hors scope beachhead SOC |
| **Critère réactivation** | M36+ — si gamification complète activée |
| **Référence** | `decisions_master.md` D-010 |

### 1.15 Social Recruiting (AG16)

| Attribut | Valeur |
|----------|--------|
| **Statut** | ⏸️ POST_MVP (M36+) |
| **Raison** | Recrutement social — hors scope beachhead SOC |
| **Critère réactivation** | M36+ — si module RH intégré |
| **Référence** | `decisions_master.md` D-010 |

---

## 2. Critères de réactivation globaux

| Critère | Condition |
|---------|-----------|
| Adoption B2B | ≥ 50 SOCs clients actifs |
| Revenus récurrents | ARR ≥ 500K$ |
| Rétention J30 | > 60% confirmé sur cohorte |
| Infrastructure mature | CI/CD vert, coverage ≥ 80%, zéro P0 bug |
| Demande utilisateur | ≥ 20% users demandent la feature |

---

## 3. Mapping Post-MVP → Décisions architecture

| Feature | Décisions concernées |
|---------|---------------------|
| NEURON-CHAINS | D-009, NC-001, NC-002, NC-003 |
| ARENA | D-OPT-051, D-OPT-052, HSM Persona pattern |
| CHRONICLE | D-OPT-048, D-OPT-055, LiveKit Voice |
| 11 Ingestion Cores | D-017, Nango Integration Hub |
| Normal Mode + B2B | PAT-07 (3-Mode Orchestration), PIVOTIQ pattern |
| Reader Suite + IMPRINT | D-OPT-052, FLY-021 |
| Finance Suite | D-019 (DCID) — nouveau domain pack |
| Gamification | AP-003 (Déterminisme), D-026 (Cognitive Policies) |
| STUDENT AI P8-P9 | D-OPT-050, D-OPT-056 |
| LiveKit Voice | D-OPT-048+, LiveKit spec, AG14 |
| B2C Consumer | Pricing spec, 4-Tier LLM Segregation |
| AG14-AG18 | D-010 (EventBus 18 agents) |

---

*scyforge_post_mvp_roadmap.md — SCY Forge — V1.0 — 2026-07-03*
*15 features différées M36+. Chaque feature a un critère de réactivation explicite.*

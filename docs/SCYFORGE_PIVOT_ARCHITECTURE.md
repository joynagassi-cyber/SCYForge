<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Doc pilote pivot architecture.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# SCYFORGE — PIVOT ARCHITECTURE v1.0
---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or #1** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.
> **Règle d'or #2** : un nœud n'est accessible que si son parent est **maîtrisé** (SMI ≥ mastery_threshold). Le seuil est **pack-défini** (0.70 pour le cyber pack). C'est le *tronc-avant-feuilles*, codé dans le runtime. Aucun seuil hardcodé dans le core.

---

## Du Générique au Monopole Beachhead Cyber

> **Doc ID** : ARCH-PIVOT-V1
> **Date** : 2026-07-01
> **Statut** : 🔴 FONDAMENTAL — Réf pour toute décision d'architecture post-pivot
> **Prérequis** : Strategic Masterplan, Domain Pack Contract, Feature Patterning, Semantic Tree Infrastructure

---

## 0. TL;DR — Le Pivot en 3 Phrases

1. **Avant** : SCYForge ingère du contenu (YouTube, Podcast, TikTok, Web) → génère des cours → spaced repetition → gamification. C'est un **moteur de contenu**.
2. **Après** : SCYForge charge un **Domain Pack** (ontologie + corpus + rôles + scénarios) → construit un **Semantic Tree** (14 troncs, 130 feuilles en cyber) → orchester la **conversion du savoir privé en autonomie opérationnelle**. C'est un **moteur de maîtrise**.
3. **Ce qui ne change pas** : Le cœur (ASCENT, APEX, COSMOS, BRAIN, IMPRINT) reste **domain-agnostique**. Seul l'adapter change. Le contrat `SemanticTreeProvider` est le point d'entrée unique vers tout le savoir.

---

## 1. Le Changement d'Invariant Architecturaux

### 1.1 Invariants QUI RESTENT (sacro-saints)

| Invariant | Description | Pourquoi immuable |
|-----------|-------------|-------------------|
| **Cœur domain-agnostique** | Le cœur ne sait RIEN de la cybersécurité | C'est le moat multi-domaines |
| **Hexagonal Architecture** | Ports/adapters, jamais de logique métier dans l'infra | Testabilité, évolutivité |
| **Semantic Tree comme substrat unique** | Un seul graphe pour (a) cerveau apprenant, (b) savoir entreprise, (c) architecture produit | Triple coïncidence = moat |
| **Observer Pattern / EventBus** | Zéro appel direct inter-services (ASCENT consomme events, pas des appels) | Découplage total |
| **Typestate Pattern** | États machine (`Locked`→`Ready`→`Studying`→`Mastered`) types Rust stricts | Impossible d'avoir un état invalide à la compilation |
| **Bottom-Up** | Infrastructure avant services, services avant consommateurs | Implémentation ordonnée |

### 1.2 Invariants QUI CHANGENT (pivot)

| Avant | Après | Impact |
|-------|-------|--------|
| **Ingestion est le point d'entrée principal** | **Domain Pack Loader est le point d'entrée principal** | Le pack pré-chargé remplace MapReduce L0-L4 pour le beachhead |
| **Objectif utilisateur = sujet à apprendre** (ex: "apprendre React") | **Objectif utilisateur = rôle à former** (ex: "SOC L1 analyste Montréal") + **pack chargé** | Onboarding simplifié : choix du rôle → chargement du sous-arbre |
| **Contenu généré par NEURON-CHAINS** (LLM) | **Scénarios pré-construits** (APT29) + **corpus fondateur** (documents de base) | Réduction drastique des coûts LLM au démarrage = $0 initial |
| **Gamification générale** (streaks, XP, badges) | **Gamification Blue Team** (données à définir via pack) | À repenser en termes SOC/DFIR (ex: "taux de détection" au lieu de "streak") |
| **13 agents ASCENT généraux** | **13 agents ASCENT consommateurs de contracts domaine** (Plan C) | Les agents ne contiennent plus de knowledge cyber en dur |
| **MASTERY_THRESHOLD = 0.70 global** | **MASTERY_THRESHOLD pack-défini uniquement** | Le core ne connaît aucun seuil. Le pack cyber définit 0.70 via `PackConfig`. Absence de config → `MissingPackConfig` error, jamais de fallback silencieux. |
| **POC Day 4** (4 tests perf) | **POC Beachhead** (1 test → autonomie mesurable en < 30 min) | Réduit le go/no-go à UN critère mesurable |

---

## 2. Architecture Cible — Diagramme ASCII

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    BEACHHEAD ARCHITECTURE — CYBER PACK                  │
│                    Le cœur ne sait RIEN de la cybersécurité             │
└─────────────────────────────────────────────────────────────────────────┘

                         ┌───────────────────┐
                         │   UTILISATEUR     │
                         │   SOC Manager /   │
                         │   Security Enable.│
                         └────────┬──────────┘
                                  │ "Je veux former 3 SOC L1"
                                  ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         FRONTEND REACT (Vercel)                          │
│                                                                          │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────┐  │
│   │ Onboarding   │  │ Semantic     │  │ ARENA        │  │ Dashboard│  │
│   │ (rôle →      │  │ Tree Viewer  │  │ (APT29       │  │ (SMI,    │  │
│   │  sous-arbre) │  │ COSMOS-lite  │  │  décisions)  │  │  gaps)   │  │
│   └──────────────┘  └──────────────┘  └──────────────┘  └──────────┘  │
└──────────────────────────────────┬──────────────────────────────────────┘
                                   │ REST / WebSocket
                                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    BACKEND RUST + TS (Northflank)                        │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ AXUM SERVER (Sprint 0)                                          │   │
│  │   GET  /health/live  → liveness                                 │   │
│  │   GET  /health/ready → readiness (DB + Zilliz)                  │   │
│  │   GET  /health/deep  → deep (EventBus + sidecar)                │   │
│  │   POST /api/packs/load          → charger un Domain Pack        │   │
│  │   POST /api/packs/{id}/tree     → Semantic Tree (propriétaire)  │   │
│  │   POST /api/tree/plant           → TreeOpResult (roots nodes)   │   │
│  │   POST /api/tree/graft           → greffer un nouveau nœud       │   │
│  │   POST /api/tree/prune           → élaguer branches mortes       │   │
│  │   GET  /api/roles/{id}/subtree   → sous-arbre de rôle            │   │
│  │   POST /api/scenarios/apt29/{id} → lancer scénario ARENA         │   │
│  │   POST /api/scenarios/{id}/react → décision joueur ARENA         │   │
│  │   POST /api/mastery/evaluate     → SMI après évaluation           │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                   │                                      │
│  ┌────────────────────────────────┼────────────────────────────────┐   │
│  │           LAYER SERVICES       │         LAYER CONSUMERS          │   │
│  │                                │                                  │   │
│  │  ┌─────────────┐  ┌─────────┐ │  ┌──────────┐  ┌──────────┐    │   │
│  │  │ Domain Pack │  │Semantic │ │  │ ASCENT   │  │  COSMOS  │    │   │
│  │  │ Loader      │  │ Tree    │ │  │ Agents   │  │   Lite   │    │   │
│  │  │ (Cyber)     │  │ Adapter │ │  │ (Mastra) │  │ (G6, SVG)│    │   │
│  │  │             │  │(Postgres)│ │  │          │  │          │    │   │
│  │  └─────────────┘  └─────────┘ │  └──────────┘  └──────────┘    │   │
│  │         │              │      │         │           │             │   │
│  │         ▼              ▼      │         ▼           ▼             │   │
│  │  ┌─────────────────────────┐ │  ┌──────────────────────────┐     │   │
│  │  │ EventBus (scy-eventbus) │ │  │ Role-Mastery Projections │     │   │
│  │  │ TreeOpPlanted           │ │  │ (SMI par nœud par rôle)  │     │   │
│  │  │ TreeOpGrafted           │ │  │ (gap detection)          │     │   │
│  │  │ ScenarioEvaluated       │ │  │                          │     │   │
│  │  └─────────────────────────┘ │  └──────────────────────────┘     │   │
│  └──────────────────────────────┴──────────────────────────────────┘   │
└──────────────────────────────────┬──────────────────────────────────────┘
                                   │ SQL / Vector
                                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         INFRASTRUCTURE                                    │
│                                                                          │
│   PostgreSQL (Northflank) │  Milvus Lite / Zilliz  │  SearxNG (Docker)  │
│   ┌─────────────────────┐  ┌──────────────────┐  ┌──────────────────┐  │
│   │ semantic_trees       │  │ embeddings       │  │ Search sidecar   │  │
│   │ tree_edges           │  │ (corpus chunks)  │  │ (recherche web)  │  │
│   │ learner_states       │  │                  │  │                  │  │
│   │ role_subtrees        │  │                  │  │                  │  │
│   │ scenario_instances   │  │                  │  │                  │  │
│   │ mastery_evaluations  │  │                  │  │                  │  │
│   └─────────────────────┘  └──────────────────┘  └──────────────────┘  │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                    PACK CYBER v0.2 (hors cœur)                           │
│                                                                          │
│   Ontology  → MITRE ATT&CK (14 troncs, 130 feuilles)                     │
│   Corpus    → SigmaHQ (3136 rules), OTRF, CISA IR                        │
│   Roles     → SOC L1/L2/L3, DFIR, Detection Eng., Threat Hunter          │
│   Scenarios → APT29 chain (79 steps, 3 branched ARENA scenarios)         │
│   Rubric    → 5-criteria Proof-of-Skill                                 │
│   Retention → FSRS weights (criticality derived from Sigma density)       │
│   Validation→ Datalog Horn rules (Beth Trunk Validator)                 │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Ce qui est ELIMINÉ pour le Beachhead MVP

> **Principe** : pour arriver au marché + vite, on maximise le temps de travail sur la valeur perçue et on minimise le temps sur ce que l'acheteur ne voit pas.

| Feature | Statut | Raison |
|---------|--------|--------|
| **13 ingestion cores** (YouTube, Podcast, TikTok, etc.) | ❌ Éliminé du MVP | Le pack chargera du contenu **pré-curé**. Pas d'ingestion générique au démarrage. |
| **NEURON-CHAINS (génération LLM)** | ⚡ Différé | Les scénarios APT29 et le corpus fondateur sont pré-construits. NEURON-CHAINS devient utile pour l'expansion multi-domaines. |
| **FSRS scheduler complet** | ⚡ Simplifié | On garde le `SemanticTreeProvider` + SMI calcul, mais le scheduler FSRS 5.0 complet attend que le corpus soit suffisamment dense. |
| **18 tools T01-T18** | ⚡ Différé | Pas de LLM au départ = pas de tools. |
| **ARENA avec 6 domaines** | 🔄 Réduit | SaGaPACK UN SEUL scénario APT29 au MVP. Les 5 autres domaines (Vente, Management, etc.) sont pour l'expansion. |
| **COSMOS 26 modes** | 🔄 Réduit à 4 | MVP : `Mode-Roadmap` (arbre), `Mode-Gap-Detect` (récents rouges), `Mode-SMI-Radar` (radar SMI), `Mode-Raw` (vue brute). |
| **BRAIN (triple retrieval + Professor AI)** | ⚡ Différé | Un Q&A simplifié via BM25 PostgreSQL FTS suffit au MVP. Triple retrieval + Reranking attend le stade Phase 2. |
| **IMPRINT (CRE + Garniture)** | ⚡ Différé | Après 100+ nœuds maîtrisés. |
| **CHRONICLE (Knowledge Guardian)** | ⚡ Différé | Phase 1 : pas de multi-tenant KB cumulée. Phase 2+ quand l'entreprise aura accumulé des incidents à greffer. |
| **Normal Mode** | ❌ Éliminé du MVP | C'est la voie générique. Le beachhead est **role-based onboarding**, pas "déposez un PDF". |
| **B2B Creator Console** | ⚡ Différé | S2+ quand le SOC manager voudra créer ses propres scénarios. |
| **Finance Suite (s14)** | ❌ Éliminé | n'existe que comme marqueur d'expansion Phase 4. |
| **PivotIQ Reconciliation (s13)** | ⚡ Différé | Utile quand plusieurs packs coexisteront (multi-domain). MVP = 1 pack. |
| **RecursiveMAS** | ❌ Supprimé du MVP | Couche de coordination multi-agent complexe. Plan C (13 agents domain-contract) suffit sans RecursiveMAS. |
| **WASM Edge Computing** | ❌ Hors MVP | Desktop offline-first est Phase 2. Le MVP est cloud-first (Northflank + Vercel). |
| **Electron / Mobile (Capacitor)** | ❌ Hors MVP | Web SaaS uniquement au beachhead. Native apps viendront après product-market fit. |
| **Polars + DuckDB Analytics** | ❌ Hors MVP | Analytics cohorte = V1. MVP = SQL PostgreSQL simple. |
| **LiveKit (voix)** | ❌ Hors MVP | Pas de voice au MVP (sauf peut-être debrief ARENA). |

**Ligne directrice** : si ce n'est pas hackable au SOC Manager pour **constater la valeur en < 30 min**, c'est différé.

---

## 4. Ce qui est CONSERVÉ et CYBER-GROUNDÉ

| Feature | Ce qui change | Cyber Grounding |
|---------|---------------|-----------------|
| **Semantic Tree** | Rempli par pack, pas par ingestion | 14 troncs ATT&CK, densité Sigma, APT29 chain |
| **Domain Pack Loader** | NOUVEAU — point d'entrée principal | `packs/cyber/pack.manifest.json` + `cyber_semantic_tree.json` |
| **Role-Based Onboarding** | Remplaçe Objective-Based | SOC L1 → sous-arbre Detection + Prevention, SOC L2 → + Response, DFIR → + Investigation |
| **ARENA APT29** | Seul scénario au MVP | 79 steps, 3 branches décisionnelles, proof rubric cybersec |
| **Mastery Evaluation** | Réalisé via scénarios ARENA, pas seulement FSRS | Proof-of-Skill : 5 formats (décision tree, writeup, evidence, interview analog, field test) |
| **COSMOS Lite (4 modes)** | Réduit de 26 à 4 | Tree Roadmap, Gap Detection, SMI Radar, Raw |
| **EventBus** | Gardé, événements adaptés | `TreeOpPlanted`, `TreeOpGrafted`, `ScenarioEvaluated`, `MasteryUpdated` |
| **SemanticTreeProvider port** | Gardé, implémenté par Postgres adapter | `load_tree`, `plant`, `graft`, `prune`, `learner_state`, `is_unlockable` |
| **Beth Trunk Validator** | Gardé, règles cyberspecifiques | Datalog Horn rules sur hierarchy ATT&CK |
| **RCL Protocol** | Gardé, simplifié | Communication interne ASCENT (peut attendre Phase 1+ pour external proof) |

---

## 5. Séquence Minimum Viable — Zero-to-One Cyber

> **Objectif** : un SOC Manager ajoute 3 recrues, charge le pack cyber, et en 30 min voit un apprentissage démarer avec un arbre d'ATT&CK, une progression de maîtrise, et un scénario APT29 jouable.

### Phase MVP (Semaines 1-4)

```
JOUR 1-2 : Infrastructure
├── PostgreSQL Northflank (migrations 001_init)
├── Axum server + /health (live/ready/deep)
├── scy-eventbus crate (SCYForgeEvent + publisher + DLQ)
└── scy-shared (déjà fait)
    └── ports.rs + tree.rs (déjà fait)

JOUR 3-5 : Semantic Tree Adapter (Postgres)
├── Implémenter SemanticTreeProvider pour PostgreSQL
├── Charger cyber_semantic_tree.json (Plant 14 troncs ATT&CK)
├── endpoints /api/tree/*
└── Health check "deep" valide

JOUR 6-8 : Domain Pack Loader
├── Lire pack.manifest.json → valider contract
├── Charger hierarchy + density + scenarios
├── Role → sous-arbre (SOC L1 = 6 tactiques core, SOC L2 = 10, DFIR = 14)
└── endpoints /api/packs/* + /api/roles/{id}/subtree

JOUR 9-12 : ARENA-lite (APT29)
├── Moteur scénario (charger apt29_chain.json)
├── 3 branches décisionnelles
├── Score de décision + feedback
└── COSMOS-lite : vue arbre simple (G6 ou SVG)

JOUR 13-14 : Onboarding Flow
├── Sélection rôle (SOC L1/L2/L3, DFIR, Detection Eng)
├── Chargement sous-arbre approprié
├── Dashboard SMI (SMI global + par tactique)
└── Gap Detection (nœuds rouges = prérequis manquants)

JOUR 15-16 : Polish + démo
├── Smooth transitions + micro-animations
├── Onboarding < 5 min (TTFV)
├── Scénario APT29 complet en < 20 min
└── Mastery évaluée et affichable
```

### Jours 17-28 : Pré-Production

```
├── Documentation utilisateur (SOC Manager Guide)
├── Tests E2E Playwright (parcours critique : onboard → tree → scenario → mastery)
├── Load test (100 concurrent users)
├── Monitoring (Sentry + OpenTelemetry minimal)
├── Deploy Northflank + Vercel
└── Customer validation (2-3 beta SOC teams)
```

### Règles de Décision pendant les 28 jours

| Décision | Critère |
|----------|---------|
| **Doit-on ajouter NEURON-CHAINS ?** | Si le pack n'a pas de contenu suffisant pour maintenir l'apprenant > 10h. |
| **Doit-on ajouter un 2ème scenario ARENA ?** | Si APT29 a un taux de complétion > 70% chez les beta users. |
| **Doit-on ouvrir Normal Mode ?** | Après 3 clients payants. |
| **Doit-on implémenter B2B Console ?** | Quand un SOC Manager demande "je veux créer mon propre scénario". |
| **Doit-on ajouter WASM/Desktop ?** | Quand l'offline-first devient un critère d'achat (pas avant). |

---

## 6. Architecture des Données — Relations Cyber-Spécialisées

### 6.1 Tables Nouvelles (non présentes dans le PRD générique)

```sql
-- Registry des Domain Packs chargés
CREATE TABLE scy_domain_packs (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  pack_id TEXT NOT NULL UNIQUE,            -- 'cyber', 'medical', ...
  version TEXT NOT NULL,                   -- '0.2.0'
  pivot_ontology TEXT,                     -- 'mitre_attack'
  status TEXT NOT NULL DEFAULT 'active',   -- 'loading' | 'active' | 'deprecated'
  loaded_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL DEFAULT extract(epoch from now())::INTEGER
);

-- Semantic Tree — une instance par pack/organization/learner
-- (déjà décrit dans implementation_order, complété ici)
CREATE TABLE scy_semantic_trees (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  owner_kind TEXT NOT NULL,                -- 'domain_pack' | 'organization' | 'learner'
  owner_id UUID NOT NULL,
  domain_pack TEXT NOT NULL REFERENCES scy_domain_packs(pack_id),
  root_nodes UUID[] NOT NULL DEFAULT '{}',
  created_at INTEGER NOT NULL
);

-- Arêtes typées (OwnerKind×EdgeKind×TreeOp)
CREATE TABLE scy_tree_edges (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  tree_id UUID NOT NULL REFERENCES scy_semantic_trees(id),
  from_node UUID NOT NULL,
  to_node UUID NOT NULL,
  kind TEXT NOT NULL,                      -- 'trunk' | 'branch' | 'leaf' | 'prereq' | 'relates' | 'contradicts' | 'supersedes'
  criticality REAL NOT NULL DEFAULT 0.0,   -- 0.0–1.0 (dérivé de densité Sigma)
  superseded_at INTEGER,                   -- NULL = vivante | ts = historisée
  created_at INTEGER NOT NULL
);

-- États de maîtrise par apprenant
CREATE TABLE scy_learner_node_states (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  learner_id UUID NOT NULL REFERENCES scy_users(id),
  tree_id UUID NOT NULL REFERENCES scy_semantic_trees(id),
  node_id UUID NOT NULL,
  confidence REAL NOT NULL DEFAULT 0.0,    -- 0.0–1.0 (prouvée par test, source de vérité)
  mastery_score REAL,                       -- STORED: score de maîtrise calculé (GENERATED ALWAYS AS par trigger pack-défini)
  status TEXT,                              -- STORED: 'locked'|'ready'|'studying'|'mastered' (GENERATED ALWAYS AS)
  unlocked BOOLEAN NOT NULL DEFAULT false, -- tronc-avant-feuilles
  last_reviewed_at INTEGER,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(learner_id, tree_id, node_id)
);

-- Index GIN sur root_nodes pour requêtes "est-ce que ce nœud est racine ?"
CREATE index idx_semantic_trees_root_nodes ON scy_semantic_trees USING GIN(root_nodes);

-- Sous-arbre de rôle (projection d'un arbre complet vers les nœuds qu'un rôle doit maîtriser)
CREATE TABLE scy_role_subtrees (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  role_id TEXT NOT NULL,                   -- 'soc_l1' | 'soc_l2' | 'dfir' | 'detection_eng'
  tree_id UUID NOT NULL REFERENCES scy_semantic_trees(id),
  required_node_ids UUID[] NOT NULL,       -- sous-ensemble de l'arbre complet
  criticality_overrides JSONB,             -- {node_id: weight} pour surcharger la densité Sigma
  created_at INTEGER NOT NULL,
  UNIQUE(role_id, tree_id)
);

-- Instances de scénarios ARENA (jouables)
CREATE TABLE scy_scenario_instances (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  pack_id TEXT NOT NULL,                   -- 'cyber'
  scenario_id TEXT NOT NULL,               -- 'apt29_chain_v1'
  learner_id UUID NOT NULL REFERENCES scy_users(id),
  status TEXT NOT NULL DEFAULT 'in_progress', -- 'in_progress' | 'completed' | 'abandoned'
  current_step INTEGER NOT NULL DEFAULT 0,
  choices JSONB NOT NULL DEFAULT '[]',     -- [{step_id, choice_id, timestamp}]
  score REAL,                              -- score global 0.0–1.0
  started_at INTEGER NOT NULL,
  completed_at INTEGER
);

-- Résultats d'évaluation de maîtrise (Proof-of-Skill)
CREATE TABLE scy_mastery_evaluations (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  learner_id UUID NOT NULL REFERENCES scy_users(id),
  tree_id UUID NOT NULL REFERENCES scy_semantic_trees(id),
  smi_score REAL NOT NULL,                 -- Skill Mastery Index 0.0–1.0
  format TEXT NOT NULL,                    -- 'scenario' | 'writeup' | 'evidence' | 'interview' | 'field_test'
  rubric_criteria JSONB NOT NULL,          -- {criterion: {score, max_score, weight}}
  evaluator TEXT NOT NULL,                 -- 'ia' | 'human' | 'hybrid'
  created_at INTEGER NOT NULL
);

-- Log des operations Tree (Plant/Graft/Test/Prune/Myelinate) — EventBus traçabilité
CREATE TABLE scy_tree_operations (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  tree_id UUID NOT NULL REFERENCES scy_semantic_trees(id),
  operation TEXT NOT NULL,                 -- 'plant' | 'graft' | 'test' | 'prune' | 'myelinate'
  actor TEXT NOT NULL,                     -- 'system' | 'user' | 'agent_03' | 'agent_07'
  node_ids UUID[] NOT NULL,
  metadata JSONB,
  created_at INTEGER NOT NULL
);
```

### 6.2 Tables Existantes à NE PAS MODIFIER (héritées de Sprint 0 générique)

```
scy_users
scy_sources
scy_documents
scy_chunks
scy_concepts
scy_cards              ← réutilisé tel quel (APEX/FSRS)
scy_sync_queue
scy_imprint_registers
scy_imprint_trees
scy_shared_content_cache
scy_llm_cache_meta
scy_outbox
scy_sync_queue
scy_ascent_nodes       ← migré vers scy_semantic_trees
```

> **Note** : `scy_ascent_nodes` est migré vers `scy_semantic_trees`. Pas de suppression — dépréciation progressive avec alias de compatibilité.

### 6.3 RLS Multi-Tenant (Row Level Security)

```sql
-- Toutes les tables learner-spécifiques sont filtrées par user_id
ALTER TABLE scy_learner_node_states ENABLE ROW LEVEL SECURITY;
ALTER TABLE scy_scenario_instances ENABLE ROW LEVEL SECURITY;
ALTER TABLE scy_mastery_evaluations ENABLE ROW LEVEL SECURITY;

-- Policy : un apprenant ne voit que ses propres données
CREATE POLICY learner_isolation ON scy_learner_node_states
  USING (learner_id = current_setting('app.current_user_id')::UUID);

CREATE POLICY learner_isolation ON scy_scenario_instances
  USING (learner_id = current_setting('app.current_user_id')::UUID);

CREATE POLICY learner_isolation ON scy_mastery_evaluations
  USING (learner_id = current_setting('app.current_user_id')::UUID);
```

---

## 7. DCID (Domain Contract Interface Definition) — Le Point-Nœud

> **Tout code dans le cœur SCYForge interagit avec un pack via `SemanticTreeProvider`.**
> C'est le seul pont. Si un agent ASCENT a besoin de données cyber, il demande au port — jamais au pack directement.

### 7.1 Le Port Unique (directement dans `scy-shared/ports.rs`)

```rust
/// Point d'entrée UNIQUE du cœur vers n'IMPORTE QUEL Domain Pack.
/// Le cœur ne connaît pas "cyber" ni "medical" — seulement cette interface.
#[async_trait]
pub trait SemanticTreeProvider: Send + Sync {
    // ── Lecture ──
    async fn load_tree(&self, owner_kind: OwnerKind, owner_id: Uuid)
        -> AppResult<SemanticTree>;
    async fn nodes(&self, tree_id: Uuid, depth: Option<u32>)
        -> AppResult<Vec<SemanticNode>>;
    async fn live_edges(&self, tree_id: Uuid)
        -> AppResult<Vec<TreeEdge>>;
    async fn learner_state(&self, learner_id: Uuid, tree_id: Uuid)
        -> AppResult<Vec<LearnerNodeState>>;

    // ── Écriture (5 opérations canoniques) ──
    async fn plant(&self, tree_id: Uuid, roots: Vec<Uuid>)
        -> AppResult<TreeOpResult>;
    async fn graft(&self, tree_id: Uuid, parent: Uuid, child: SemanticNode)
        -> AppResult<TreeOpResult>;
    async fn prune(&self, tree_id: Uuid, dead_nodes: Vec<Uuid>)
        -> AppResult<TreeOpResult>;
    async fn test(&self, learner_id: Uuid, node_id: Uuid, evidence: TestEvidence)
        -> AppResult<TreeOpResult>;
    async fn myelinate(&self, learner_id: Uuid, node_id: Uuid)
        -> AppResult<TreeOpResult>;

    // ── Gating ──
    async fn is_unlockable(&self, learner_id: Uuid, child_node: Uuid)
        -> AppResult<bool>;
}
```

### 7.2 Implémentations Connexes (via implémentation du port)

```
SemanticTreeProvider trait
    ├── PostgresTreeAdapter      ← implémentation PostgreSQL (default, MVP)
    │     └── lit/writ dans scy_semantic_trees, scy_tree_edges, scy_learner_node_states
    │
    ├── InMemoryTreeAdapter      ← pour tests unitaires (mock)
    │     └── HashMap<Uuid, SemanticNode>
    │
    └── LazyPackTreeAdapter      ← chargement à la demande du pack (Phase 2+)
          └── lit depuis le filesystem du pack (JSON + manifest)
```

### 7.3 Flow de Chargement d'un Pack

```
                      ┌──────────────┐
                      │ pack.manifest │
                      │    .json     │
                      └──────┬───────┘
                             │ 1. POST /api/packs/cyber/load
                             ▼
                      ┌──────────────┐
                      │ DomainPack   │
                      │  Loader      │
                      │  (Rust)      │
                      └──────┬───────┘
                             │ 2. valide manifest (9 providers)
                             │ 3. charge hierarchy.json → semantic_tree
                             │ 4. charge density.json → criticality weights
                             │ 5. charge apt29_chain.json → scenario store
                             │ 6. charge role_taxonomy → role_subtrees
                             │
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
       ┌──────────┐ ┌──────────┐ ┌──────────┐
       │ Semantic  │ │ Role     │ │ Scenario │
       │ Tree      │ │ Subtrees │ │ Store    │
       │ (14       │ │ (4 rôles │ │ (3       │
       │  troncs)  │ │  cyber)  │ │  ARENA)  │
       └──────────┘ └──────────┘ └──────────┘
                             │
                             ▼
                      ┌──────────────┐
                      │  Semantick   │
                      │  TreeProvider │
                      │  (Plant 14   │
                      │   troncs)    │
                      └──────┬───────┘
                             │
                             ▼
                      ┌──────────────┐
                      │ EventBus     │
                      │ TreeOpPlanted│
                      └──────────────┘
```

---

## 8. Gamification Blue Team — Pourquoi ça doit être SOC-Native

> **Règle** : toute mécanique de gamification du beachhead doit être dérivée du pack, pas du cœur.
> Le cœur propose un système de points/récompenses générique. Le pack cyber définit **ce qui est remarquable en SOC**.

### 8.1 Drivers de Motivation SOC

| Mécanique cœur | Traduction cyber (pack) | Exemple |
|----------------|-------------------------|---------|
| **Streak** (jours consécutifs) | `DetectionStreak` | Nombre de jours consécutifs où une détection a été validée dans le scénario |
| **Mastery Radar** | `TacticCoverage` | % des tactiques ATT&CK du rôle couvertes à ≥ 0.70 SMI |
| **Proof-of-Skill** | `APT29Certification` | Badge SOC Analyst Certifié (scored APT29 ≥ 0.85) |
| **Gap Detection** | `RedNodesAlert` | Nœuds rouges = prérequis maîtrisés → manager voit où la recrue bloque |
| **Speed-to-Decision** | `DecisionLatency` | Temps entre réception d'un stimulus ARENA et décision (< 30s = A, < 60s = B, > 60s = C) |
| **Drift Detection** | `ProcedureDeviation` | Agent-07 DRIFT-GUARDIAN signale les écarts aux SOPs connues |

### 8.2 Ce que le cœur NE FAIT PAS

- Le cœur ne sait pas ce qu'est un "APT29" ou une "MITRE technique"
- Le cœur ne sait pas ce qu'est un "streak SOC" vs. un "streak médical"
- Le cœur propose un **framework de scoring abstrait** (`scoring.rs`) — le pack injecte la vérité métier via `ProofRubricProvider`

---

## 9. Marchés Cibles — Beachhead SOC + Peak Corporate (TAM x10)

> **[PIVOT]** SCY Forge cible **DEUX marchés complémentaires**, pas un seul :
> 1. **Pure-players cyber** (SOC teams tech) — beachhead initial, personas P-SOC1/P-SOC2/P-DFIR/P-SEL
> 2. **Corporate IT/Cyber non-tech** (banques, hôpitaux, usines, retail, assurances) — Peak-Opportunity, personas P-RSSI/P-JUNIOR/P-ITM
>
> Le marché #2 a une douleur **maximale** (équipe minuscule, RSSI épuisé, risque mortel) et un TAM **10x supérieur**. Les deux marchés partagent le même core produit (MITRE ATT&CK + Semantic Tree + ASCENT). La seule différence = le **sector pack** injecté dans le Domain Pack Contract.

### 9.1 Pourquoi les Deux Marchés se Cumulent

| Dimension | Pure-Player Cyber (SOC) | Corporate IT/Cyber (non-tech) |
|-----------|------------------------|-------------------------------|
| Taille équipe | 10-50 analysts | 2-3 personnes |
| Senior disponible pour former | Oui (10+ seniors) | **NON** (RSSI seul, 70h/semaine) |
| Conséquence d'une erreur junior | Détectée par pairs | **Ransomware, arrêt d'activité** |
| ROI de la formation | "Nice to have" | **Fraction du coût d'une attaque** |
| Compliance spécifique | Générique | **Sectorielle (HDS, PCI-DSS, NIS2)** |
| Lock-in potentiel | Faible | **Massif** (règles métier intégrées) |
| Expansion B2B2C | Non applicable | **Oui** (former tous les employés) |
| TAM (FR) | ~50 SOCs tech | ~10 000 entreprises non-tech |
| ACV | ~5 000 $/an | **15 000-50 000 $/an** |

**TAM total FR** : ~10 050 entreprises × ~10K $ ACV moyen = **~100M $ ARR potentiel**

### 9.2 Personas — Deux Marchés, Même Core

Les 4 personas SOC (P-SOC1/2, P-DFIR, P-SEL) restent les personas **principales** du beachhead.
Les 3 personas Corporate (P-RSSI, P-JUNIOR, P-ITM) sont les personas **Peak-Opportunity** (Phase 1+).

| Persona | ID | Marché | Rôle | Pain Point |
|---------|----|--------|------|------------|
| **SOC L1 Analyste** | P-SOC1 | Pure-player | Nouvelle recrue blue-team | Trop de docs, pas de structure, senior overloadé |
| **SOC L2 Analyste** | P-SOC2 | Pure-player | Analyste 1-2 ans expérience | Gap théorie ATT&CK vs pratique incident |
| **DFIR / IR Analyste** | P-DFIR | Pure-player | Spécialiste réponse incidents | Manque scénarios réalistes sur données internes |
| **Security Enablement Lead** | P-SEL | Pure-player | Manager qui forme les recrues | Pas de visibilité progression, pas de certification |
| **RSSI / Security Manager** *(PEAK)* | P-RSSI | Corporate non-tech | Responsable sécurité (hôpital, banque, retail) | Équipe 2-3 personnes, zéro temps pour former |
| **Junior Cyber Analyst** *(PEAK)* | P-JUNIOR | Corporate non-tech | Nouvelle recrue équipe cyber interne | Pas de mentor senior, pas de structure |
| **IT Manager (non-cyber)** *(PEAK)* | P-ITM | Corporate non-tech | IT Manager qui gère aussi la sécurité | Compétences cyber limitées, conformité obligatoire |

### 9.3 Le Monopole Sectoriel : Adaptation au Métier du Client

**Principe** : SCY Forge ne vend pas du contenu générique MITRE. Elle vend **du contenu MITRE + les règles spécifiques au secteur du client**.

Le même core produit (Semantic Tree + ASCENT + APEX + COSMOS) sert les deux marchés. La seule variable = le **sector pack** injecté via le Domain Pack Contract (DCID).

Exemples sector packs :
- **Banque** : MITRE ATT&CK + PCI-DSS + SWIFT + Bâle III
- **Hôpital** : MITRE ATT&CK + HDS + scénarios ransomware CHU
- **Grande Distribution** : MITRE ATT&CK + PCI-DSS + paiement (ex: Casino, Carrefour)
- **Assurance** : MITRE ATT&CK + RGPD + fuite de données clients
- **Industrie** : MITRE ATT&CK + IEC 62443 + OT/ICS

### 9.4 Le Flywheel B2B2C (Corporate uniquement)

Une fois que SCY Forge a prouvé sa valeur sur l'équipe cyber (5-10 personnes), le RSSI dit :

> "Ça marche pour mes experts. Déployons-le pour former nos 200 employés aux règles d'or de la sécurité."

**Étapes du flywheel** :
1. **B2B niche** : SOC interne (5 analysts) → ~5 000 $/an
2. **B2B2C expansion** : Tous les employés (200 personnes) → ~20 000 $/an
3. **Monopole sectoriel** : 3 banques → contenu bancaire propriétaire → barrière à l'entrée massive
4. **Référence** : Les secteurs satisfaits vantent SCY Forge → acquisition dans d'autres secteurs

### 9.5 Pricing — Deux Marchés, Deux Grilles

| Tier | Prix/an | Marché | Statut | Inclus |
|------|---------|--------|--------|--------|
| **Trial** | 0 $ (30j) | B2B SOC (MSSP + Corporate) | ✅ IN_MVP | 1 pack MITRE, 1 secteur |
| **Team** | 5 000 $ | B2B SOC (MSSP + Corporate) | ✅ IN_MVP | MITRE + 1 secteur, Manager dashboard |
| **Enterprise** | 25 000 $ | B2B SOC (MSSP + Corporate) | ✅ IN_MVP | Multi-pack, SSO/SAML, analytics avancés |
| **Industry** | 50 000 $+ | B2B2C Corporate (RSSI + tous employés) | ⏸️ POST_MVP | Custom sector pack + B2B2C deployment |
| **Government** | Custom | Secteur public | ⏸️ POST_MVP | On-prem, FedRAMP, custom ontology |
| **Consumer** | TBD | B2C Grand Public (étudiant, autodidacte) | ⏸️ POST_MVP | Mode Normal, ingestion libre, Normal Mode |

> **Règle** : B2B SOC (MSSP/MDR + Corporate interne) = IN_MVP. B2C (consommateur individuel) et B2B2C (tous-employés) = POST_MVP. Les tiers IN_MVP sont les seuls à coder au beachhead.

### 9.6 Feature Roadmap — Deux Marchés

| Feature | Priorité | Marché | Description |
|---------|----------|--------|-------------|
| **MITRE Pack Core** | P0 | Les deux | Domain Pack MITRE ATT&CK pré-ingéré |
| **Role Subtrees (SOC L1/L2/DFIR)** | P0 | Pure-player | 6/10/14 tactics selon rôle |
| **Tactical AI** | P0 | Les deux | Chat contextuel DeepSeek V4 Free |
| **APEX B11-B14** | P0 | Les deux | Cartes cyber (IOC, Kill Chain, Chain-of-Custody) |
| **COSMOS 4 modes** | P0 | Les deux | Mission Tree, SMI Radar, Threat Terrain, Tactical Zoom |
| **Role Subtrees Corporate** | P1 | Corporate | Subtree adapté secteur (HDS, PCI-DSS, NIS2) |
| **Sector Pack Builder** | P1 | Corporate | RSSI ajoute règles sectorielles à MITRE |
| **Compliance Mapping** | P1 | Corporate | Mapping automatique MITRE → contrôles sectoriels |
| **Phishing Simulator** | P1 | Corporate | Formation tous-employés |
| **Incident Report Generator** | P2 | Corporate | Rapports d'incident conformes secteur |
| **External Dashboard RSSI** | P2 | Corporate | Vue readiness globale + compliance gap |

---

## 10. Interface Frontend — Recalibration Cyber

### 10.1 Personas Cyber-Uniques (Beachhead SOC + Peak Corporate)

| Persona | ID | Description | Objectif | Pain Point |
|---------|----|-------------|----------|------------|
| **SOC L1 Analyste** | P-SOC1 | Nouvelle recrue blue-team | Atteindre autonomie opérationnelle en 90 jours | Trop de docs, pas de structure, senior overloadé |
| **SOC L2 Analyste** | P-SOC2 | Analyste avec 1-2 ans d'expérience | Maîtriser les tactiques avancées + investigation | Gap entre théorie ATT&CK et pratique incident |
| **DFIR / IR Analyste** | P-DFIR | Spécialiste réponse aux incidents | Investigation forensique + chaine kill | Manque de scénarios réalistes sur données internes |
| **Security Enablement Lead** | P-SEL | Manager qui forme les recrues | Réduire charge senior + prouver readiness | Pas de visibilité sur progression, pas de certification |
| **RSSI / Security Manager** *(PEAK)* | P-RSSI | Responsable sécurité dans entreprise non-tech (hôpital, banque, retail) | Former équipe minuscule + prouver compliance | Équipe 2-3 personnes, zéro temps pour former, risque d'arrêt d'activité |
| **Junior Cyber Analyst** *(PEAK)* | P-JUNIOR | Nouvelle recrue dans équipe cyber interne (non-tech) | Autonomie rapide sans mentor senior | Pas de senior disponible, pas de structure d'apprentissage |
| **IT Manager (non-cyber)** *(PEAK)* | P-ITM | Responsable IT qui doit gérer la sécurité | Comprendre et appliquer règles sécurité | Compétences cyber limitées, conformité obligatoire |

### 9.2 User Journeys Critiques (Beachhead)

**Journey 1 — Onboarding SOC L1 (TTFV < 5 min)**
```
1. SOC Manager crée un espace (organization)
2. Ajoute 3 recrues (learner accounts)
3. Sélectionne "Cyber Pack v0.2" → charge
4. Pour chaque recrue : sélectionne rôle "SOC L1" → sous-arbre auto-généré
5. Recrue voit : arbre ATT&CK (6 tactiques core) + 1er scenario "APT29 Intro"
6. Click → commence scenario → arbre se colore au fur et à mesure
```

**Journey 2 — Scénario ARENA (Time-to-Autonomy measurable)**
```
1. Recrue SOC L1 reçoit notification "APT29 Scenario 1 ready"
2. Ouvre scenario → contexte : "Vous êtes analyste SOC, alerte EDR..."
3. Chaque étape = décision à prendre (3 options)
4. Après choix → feedback immédiat (bien/pas bien + explication)
5. Score calculé à la fin → certificat Proof-of-Skill
6. Si score ≥ 0.70 → tronc validé → branches suivantes déverrouillées
7. Si score < 0.70 → Prune + Graft (retour aux prérequis)
```

**Journey 3 — Manager Dashboard (Visibility)**
```
1. SEL ouvre dashboard
2. Voit 3 vues:
   a. Coverage Map: % de l'arbre ATT&CK maîtrisé par recrue
   b. Gap Map: nœuds rouges (prereq manqués) + temps estimé pour combler
   c. Readiness Score: SMI global par rapport au profil de rôle cible
3. Export: PDF "Readiness Report" pour chaque recrue
```

---

## 9bis. Generative Forest Engine (GFE) — Le Troisième Pilier

> **[D-021 — D-022]** Le GFE est le **moteur de créativité générative** de SCY Forge, ancré comme 3ème pilier à côté de l'ASCENT Pipeline (Pilier 2) et du Semantic Tree + DCID (Pilier 1).
> Référence : `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` §1ter + `docs/SCYFORGE_GENERATIVE_*_MODEL.md`

### 9bis.1 Principe Fondamental

> **"Le fruit, on le mange. La graine, on la plante."**

SCY Forge ne se contente pas de transmettre du savoir (ASCENT). Il **produit de la connaissance neuve** à partir du savoir existant.

Le GFE prend le savoir privé de l'entreprise (Semantic Tree + Knowledge Graph bitemporel) et, par croisement structuré entre branches éloignées, produit des **graines plantables** — des propositions neuves qui peuvent germer en nouveaux sous-arbres de savoir.

**Propriété souveraine** : La créativité naît de la structure du savoir privé. Aucun Internet n'est nécessaire pour polliniser. Le résultat est **non-copiable** par un concurrent car il dépend du corpus spécifique de chaque client.

### 9bis.2 Nomenclature Canonique

| Concept | Nom Canonique | Alias | Définition |
|---------|---------------|-------|------------|
| Arbre sémantique | **Semantic Tree** / **Knowledge Tree** | `STB` | Structure dirigée tronc→branches→feuilles |
| Arborisation | **Arborization** | `ARBOR` | Transformer un graphe plat (KG) en arbre dirigé |
| Pollinisation (opérateur) | **Pollination** | `POLL` | Croisement fécondant entre branches éloignées : `Pollination(A, B, context) → Seed \| ∅` |
| Cross-pollination | **Cross-Pollination** | `XPOLL` | Pollinisation inter-STB sectoriels différents |
| Graine | **Seed** | — | Résultat génératif : contient un arbre en puissance |
| Viabilité | **Seed Viability** | — | Probabilité qu'une graine germe en valeur réelle |
| Fécondité | **Fecundity** | — | Potentiel génératif (combien d'arbres une graine peut produire) |
| Germination | **Germination** | — | Déploiement d'une graine en nouveau sous-arbre |
| Gouvernail de vision | **Vision Helm** | `HELM` | Vecteur k-dimensionnel + graphe d'objectifs. Aligne tout le système |
| Moteur global | **Generative Forest Engine** | `GFE` | L'ensemble : ARBOR → POLL → Seed → Germinate |

### 9bis.3 Les 4 Conditions de Fécondité d'une Pollinisation

Toute pollinisation doit satisfaire **les 4 conditions simultanément** :

| # | Condition | Formule | Rationale |
|---|-----------|---------|-----------|
| **L1** | **Distance suffisante** | `distance(A, B) ≥ θ_min` | Trop proches = redondance, pas de nouveauté |
| **L2** | **Compatible** | `∃ pont logique entre A et B` | Trop éloignés sans pont = bruit |
| **L3** | **Nouvelle** | Lien A↔B n'existe pas dans le KG | Sinon rappel, pas création |
| **L4** | **Alignée Vision Helm** | `align(A⊕B, VisionHelm) ≥ τ` | Graine non alignée = stérile |

**Zone féconde** : `θ_min ≤ distance(A,B) ≤ θ_max` avec pont logique.

### 9bis.4 Anatomie d'une Seed (5 composants)

```
SEED
├─ ① CORE PROPOSITION  : l'idée/décision/méthode neuve (le "quoi")
├─ ② PARENTHOOD        : (source_A, source_B) qui l'ont engendrée (le "d'où")
├─ ③ POTENTIAL TREE    : l'arbre en puissance qu'elle peut déployer (le "vers quoi")
├─ ④ VIABILITY PROFILE : viability + fecundity (le "peut-elle germer ?")
└─ ⑤ PROVENANCE        : la lignée datée immuable (le "comment le prouver")
```

**Formules de scoring** :
- `Viability(s) = feasibility × alignment × non_redundancy × resource_fit`
- `Fecundity(s) = potential_subtrees × strategic_reach`
- `PlantScore(s) = Viability^γ × Fecundity^(1−γ)` [γ = curseur prudence/ambition]

### 9bis.5 Vision Helm — Le Gouvernail

Le Vision Helm gouverne **tout le système** :
- **Vecteur pondéré** `h ∈ ℝᵏ` : k axes stratégiques pondérés → calcul rapide `align()` en temps réel
- **Graphe d'objectifs** `G_H` : objectifs → sous-objectifs → KPIs → raisonnement + traçabilité

`align(x, H) = cos( proj(x), h ) ∈ [−1,1] → renormalisé [0,1]`

Le Helm pilote :
- L'arborization (direction de l'arbre)
- La pollinisation (condition L4)
- L'ASCENT Pipeline (priorisation des objectifs)
- COSMOS (highlighting stratégique)

### 9bis.6 Émergence Endogène — Le Cœur du 0→1

3 mécanismes de créativité **indépendants d'Internet** :

```
SAVOIR PRIVÉ (STB + KG bitemporel)
     │
 ① SME → candidats par analogie structurelle (Gentner)
     │
 ② BLENDING → fusionne en structure émergente (Fauconnier-Turner)
     │
 ③ LINK-PREDICTION → score plausibilité + nouveauté (Swanson/node2vec)
     │
 FILTRE : conditions L1-L4 + Viability + align(H)
     │
 SEED viable (endogène, datée, prouvée)
```

| Mécanisme | Base scientifique | Rôle GFE |
|-----------|-------------------|---------|
| **SME (Gentner)** | Structure-Mapping Theory | Trouve paires éloignées au sens mais identiques en structure |
| **Blending (Fauconnier-Turner)** | Conceptual Blending (4 espaces) | Fusionne 2 inputs → structure émergente absente des inputs |
| **Link Prediction (Swanson/node2vec)** | Literature-Based Discovery | Prédit liens latents plausibles sur le graphe privé |

**Internet n'intervient qu'après** la génération, jamais pour générer. L'émergence découle de la **structure unique** du savoir privé → non-copiable.

### 9bis.7 Cycle de Vie d'une Seed

```
   POLLINATED ──(viability ≥ seuil)──► VIABLE ──(plantée)──► GERMINATING ──► NEW SUBTREE
        │                                  │
        └──(stérile)──► DORMANT ◄──────────┘ (rétrogradée si contexte change)
        DORMANT ──(contexte favorable)──► VIABLE   (réveil bitemporel)
```

**Règle** : Aucune graine n'est détruite. Dormant ≠ mort. Une graine stérile aujourd'hui peut germer demain.

### 9bis.8 Traceabilité — W3C PROV-DM + Bitemporel

Toute Seed est traçable selon W3C PROV-DM :
- `wasDerivedFrom(source_A, source_B)` : parenthood immuable
- `wasGeneratedBy(agent_id)` : quel agent a produit la Seed
- **Bitemporel** : event time (création) + ingestion time (découverte) = 2 timestamps

### 9bis.9 Implication pour le Beachhead MVP

Sur le cyber beachhead M0-M36, le GFE est en **mode observatoire** :
- Le Semantic Tree Cyber (MITRE ATT&CK) est planté et stabilisé
- La pollinisation **intra-domaine** opère : croisements entre tactiques MITRE éloignées pour produire des Seeds de nouveaux scenarios (ex: Reconnaissance + Exfiltration → *"Indicators of Compromise par canaux inhabituels"*)
- Les Seeds sont **stockées** mais pas encore germinées avant validation produit
- Le Vision Helm Cyber est configuré : axes = [DetectionRate, ResponseVelocity, Coverage, Compliance, FalsePositiveRate]

Post-MVP (corporate PEAK, M36+), le GFE passe en **mode expansion** :
- Cross-pollination inter-STB (MITRE + secteur HDS/PCI-DSS/NIS2)
- Pollinisation avec les Seeds du RSSI (son savoir privé = formatif sectoriel)
- Germination automatique : Seeds valides → nouveaux sous-arbres de formation sectoriels

### 9bis.10 GFE dans l'Architecture des 3 Piliers

```
┌──────────────────────────────────────────────────────────────────┐
│                    SCY FORGE — 3 PILIERS                          │
│                                                                  │
│  PILIER 1          PILIER 2            PILIER 3                   │
│  Semantic Tree      ASCENT Pipeline     Generative Forest Engine  │
│  + DCID             (13 agents)         (GFE)                     │
│                                                                  │
│  "Ce que l'on       "Comment on le      "Ce que l'on crée à      │
│   sait"             transmet"           partir de ce que l'on    │
│                                    sait"                        │
│                                                                  │
│  ┌──────────┐    ┌──────────────┐    ┌────────────────────┐    │
│  │ STB      │    │ ASCENT       │    │ ARBOR → POLL       │    │
│  │ Domain   │    │ Agent-01..13 │    │ Seed → Germinate   │    │
│  │ Pack     │    │ Plan C       │    │ Vision Helm        │    │
│  │ Cyber    │    │              │    │                    │    │
│  └──────────┘    └──────────────┘    └────────────────────┘    │
│       │                  │                      │                │
│       └──────────────────┴──────────────────────┘                │
│                    EventBus (D-010)                               │
└──────────────────────────────────────────────────────────────────┘
```

---

> Ces règles survivent au pivot, à la beachhead, et à l'expansion multi-domaines.

1. **Le cœur ne contient AUCUN terme métier** en dur. Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans `backend_rs/crates/scy-{shared,eventbus,...}/` → **violation**.
2. **Un nœud n'est accessible que si son parent est maîtrisé** (SMI ≥ mastery_threshold). Le seuil est **pack-défini** (0.70 pour le cyber pack), zéro hardcodé dans le core. C'est le *tronc-avant-feuilles*, codé dans le runtime.
3. **Toute communication inter-services passe par l'EventBus**. Zéro appel direct.
4. **Toute donnée de maîtrise est immutable** (append-only). On ajoute des évaluations, on ne modifie jamais un score.
5. **Les migrations SQL sont versionnées et rollbackables**. `${timestamp}_description.up.sql` / `.down.sql`.
6. **Toute erreur est typée** (`AppError` avec `thiserror`). Pas de `.unwrap()` en production.
7. **Toute donnée JSONB est validée** (serde en Rust, Zod en TS). Pas de JSON non structuré.
8. **Le design system est figé** jusqu'à WDS-8 (évolution produit). Pas de couleur hors `design-artifacts/D-Design-System/`.

---

## 11. Questions Ouvertes (à résoudre avant le code)

| # | Question | Propriétaire | Décision avant |
|---|----------|--------------|----------------|
| Q1 | Faut-il laisser l'admin créer un scenario custom dans le MVP ? | Product | J15 |
| Q2 | APT29 suffit-il comme seul scenario, ou faut-il un 2ème scénario plus court (< 10 min) pour onboarding rapide ? | Product + Content | J10 |
| Q3 | Quelle est la granularité du scoring ARENA : par étape ou global ? | Engineering | J12 |
| Q4 | La gamification (streaks, badges) doit-elle être présente au MVP ou après validation ? | Product | J17 |
| Q5 | Faut-il intégrer un vrai LMS (LTI) ou garder l'authentification maison ? | Engineering | J5 |
| Q6 | Combien de rôles SOC au MVP : 4 (L1/L2/L3/DFIR) ou 2 (L1/L2) ? | Product | J8 |
| Q7 | Le MemoryTree (CHRONICLE) doit-il être présent même en mode simplifié (introspection apprenant) ? | Architecture | J14 |

---

## 12. Matrice de Décision — Sprint 0 vs Beachhead

| Composant | Plan Original (Générique) | Beachhead Cyber | Action |
|-----------|---------------------------|-----------------|--------|
| Point d'entrée | Ingestion Cores (13 sources) | Domain Pack Loader (1 pack) | 🔄 **REMPLACÉ** |
| Contenu initial | Généré par LLM (NEURON-CHAINS) | Pré-construit (pack) | 🔄 **REMPLACÉ** |
| Cible utilisateur | Learner générique | SOC/Blue Team | 🔄 **SPECIALISÉ** |
| Gamification | Générique (XP, streaks) | Blue Team native (DetectionStreak, TacticCoverage) | 🔄 **REPENSÉE** |
| Authentication | Standard (email/password) | SSO + Organization (SAML/OIDC) | ➕ **AJOUTÉ** |
| Onboarding | Goal déclaré par user | Rôle sélectionné par manager | 🔄 **REMPLACÉ** |
| Bloom/Révision | Spaced repetition générique | FSRS + densité Sigma (criticality weights) | 🟢 **ADAPTÉ** |
| COSMOS | 26 modes | 4 modes | 🔄 **RÉDUIT** |
| ARENA | 6 domaines | 1 scenario (APT29) | 🔄 **RÉDUIT** |
| NEURON-CHAINS | 7 chains + 18 tools | Différé | ⏸️ **DIFFÉRÉ** |
| scy-eventbus | ✅ Gardé | ✅ Gardé | 🟢 **INCHANGÉ** |
| scy-shared | ✅ Gardé | ✅ Gardé + ports.rs + tree.rs | 🟢 **INCHANGÉ** |
| Hexagonal Arch | ✅ Gardé | ✅ Gardé | 🟢 **INCHANGÉ** |

---

## 13. D9 — Modèle de Couverture Pondérée (PACK_COVERAGE_MEASUREMENT v1.0)

> **Décision (D9) : la couverture « 80% » est pondérée par règles, pas par comptage de nœuds.**
> Référence : `SCYFORGE_ARENA_SIMULATION_ENGINE.md §12`, `SCYFORGE_PACK_COVERAGE_MEASUREMENT.md`

### 13.1 Les 3 règles de pondération

Chaque règle s'appuie sur une dimension **déjà présente** dans l'ontologie ou le Semantic Tree :

| Règle | Dimension source | Effet | Justification |
|---|---|---|---|
| **R1 — Criticité marché** | `trunkPriority` ★ (1→5) | Multiplie le poids du nœud de ×1.0 (★) à ×3.0 (★★★★★) | Un nœud critique (★★★★★) validé en L3+ vaut 3× plus qu'un nœud marginal. |
| **R2 — Nouveauté 2026** | `skill_era: new_2026` | +20% sur le poids final du nœud | Compétences émergentes = différentiel salarial marché 2026. |
| **R3 — Fidélité atteinte** | barreau L1..L4 | L1=0.25 / L2=0.50 / L3=0.85 / L4=1.0 | Être couvert en L1 (QCM) ne vaut pas 100% d'un nœud. |

### 13.2 Formules

```
weight(N) = (trunkPriority(N) / 5 × 2 + 1) × (1 + 0.2 × 1[skill_era = new_2026])
score(N) = weight(N) × fidelityCoeff(N)
score_max(N) = weight(N) × 1.0
coverage(pack) = Σ score(N) / Σ score_max(N)
```

**Seuil cible MVP** : `coverage(Cyber Pack) ≥ 0.80`

### 13.3 États de couverture Cyber SOC L1 (20 nœuds tronc)

| État | Couverture | Conditions | Nœuds clés manquants |
|---|---|---|---|
| **État A** (MVP honnête) | **69.2%** | 1 vertical live-fire (SCN-EDR-03), L3 pour SCN-*, L1/L2 pour fondations | T-16, T-17, T-18 en L2/L1 |
| **État B** (5 SCN en L4) | **75.4%** | Les 5 scénarios `SCN-*` en live-fire complet | T-16, T-17, T-18 en L2/L1 (plancher structurel) |
| **Cible** (T-16/17/18 → L3) | **81.3%** | +3 scénarios L3 déterministes (bon marché) | Aucun — seuil franchi |

**Conclusion de pilotage** : la route vers 80% ne passe pas par plus d'infra live-fire coûteuse, mais par **3 scénarios L3 déterministes** sur les gestes transverses (T-16 doc, T-17 alert fatigue, T-18 playbooks). C'est l'arbitrage rationnel que D9 rend visible.

### 13.4 Marquage `skill_era` des nœuds (alimente R2)

| Nœud | `skill_era` | Justification |
|---|---|---|
| T-06 (MFA fatigue) | **new_2026** | Vecteur 2026 (fatigue MFA, impossible travel) |
| T-09 (Évasion IA-assistée) | **new_2026** | Évasion générée/assistée par IA |
| T-11 (Beaconing chiffré) | **new_2026** | Canaux chiffrés / DGA récents |
| T-14 (Corrélation IA) | **new_2026** | Corrélation assistée IA = glissement de compétence 2026 |
| T-17 (Alert fatigue IA) | **new_2026** | Priorisation file assistée IA 2026 |
| T-12 (EDR malware) | traditional | Accélération de menace ≠ geste L1 |

---

## 14. Proof Metrics — Les 3 Thèses (PROOF_METRICS v1.0)

> **Référence** : `scyforge_proof_metrics.md`
> Règle d'or : **aucune métrique de vanité**. Chaque chiffre est auditable, attribuable, et refuse le faux positif pédagogique.

### 14.1 Les 3 Thèses

| # | Thèse | Ce qu'elle prouve |
|---|---|---|
| **A — Autonomisation** | Nous rendons une recrue autonome sur son rôle, plus vite et de façon mesurable, avec transfert prouvé du simulé vers le réel. | **Preuve de survie** du produit |
| **B — Moteur d'innovation (GFE)** | La plateforme génère de l'exploration et de la nouveauté exploitable (Seeds plantables, germination, sous-arbres). | **Preuve de valeur durable** |
| **C — Semantic Tree comme infrastructure** | L'arbre est un substrat unique qui se creuse dans le temps (moat composé). Diff(org) − Diff(pack) = valeur privée irréductible. | **Preuve de défendabilité** |

### 14.2 Tableau de bord unique (9 métriques)

| # | Métrique | Cible | Niveau | Tue le projet si… |
|---|---|---|---|---|
| 0 | **Time-to-Perceived-Value** (gate pivot) | < 30 min | P0 | > 60 min |
| 1 | **Transfer Ratio (G1)** | ≥ 0.80 | P2 | < 0.65 |
| 2 | TTA médian SOC L1 | ≤ 8 sem. | P2 | réduction < 20% vs témoin |
| 3 | % surface rôle autonome | ≥ 70% | P2 | < 50% |
| 4 | **Seed Yield** + Viability moyenne | ≥ 10% / ≥ 0.60 | P1→P2 | ≈ 0 Seed viable |
| 5 | Pente TTA inter-cohorte | −10%/cohorte | P3 | plate ou positive |
| 6 | Couverture pondérée pack | 81% | P1 | plafonne < 70% |
| 7 | **Taux de greffe / semaine** | ≥ 5 | P1→P2 | ≈ 0 (arbre figé) |
| 8 | **Delta souverain** Diff(org)−Diff(pack) | croissance monotone | P2→P3 | plat (pas de moat) |

### 14.3 Protocole de preuve (90 jours, 1 design partner)

| Semaines | Phase | Activité |
|---|---|---|
| S1 | **Activation (A0)** | Vérifier gates pivot : TTFV < 5 min, valeur perçue < 30 min, APT29 jouable |
| S1 | **Instrumentation (P0)** | Câbler les 9 métriques, établir cohorte témoin |
| S2–S4 | **Preuve en sim (P1)** | 1 rôle SOC L1, 5 scénarios hero, ~69% couverture. GFE en mode observatoire. |
| S5–S8 | **Preuve du transfert (P2)** | Basculer sur vraies alertes. **Point de contrôle G1** : si Transfer Ratio < 0.65 → arrêt et pivot. |
| S9–S12 | **Preuve de la boucle (P2→P3)** | TTA réel vs témoin, valider Seeds VIABLE, amorcer cohorte N+1, suivre taux de greffe + Delta souverain. |

> **Ordre non négociable** : transfert d'abord (P2), échelle ensuite (P1/P3). On ne contractualise le "80%" et le profil régulé qu'après validation P2 de G1.

---

## 15. Autonomy Envelope — Spécification Formelle

> **Référence** : `SCYFORGE_FEATURE_REPORT.md §13`

### 15.1 Le modèle mental : une grille, pas un booléen

L'enveloppe est une **matrice `classe d'alerte × niveau de risque`**, chaque cellule portant un **mode d'autonomie** courant. La progression se fait **cellule par cellule**.

### 15.2 Les 4 modes

| Mode | Sens | Qui décide | Trace requise |
|---|---|---|---|
| `shadow` | la recrue observe / propose, un senior exécute | senior | proposition loggée |
| `guarded` | la recrue agit, validation humaine **avant** effet | recrue + validateur | validation tracée |
| `autonomous` | la recrue agit seule dans cette cellule | recrue | note de triage rejouable |
| `handoff` | interdit à ce rôle — escalade/transfert obligatoire | escalade | motif de handoff |

### 15.3 Transitions

```
shadow ──[gate franchi + N passages]──▶ guarded ──[gate + 0 erreur critique]──▶ autonomous
   ▲                                                                                  │
   └──────────────── DRIFT-GUARDIAN (Ag-07) : dérive / illusion de compétence ────────┘
                     OutcomeFeedbackPolicy (G3) : verdict terrain négatif → rétrograde
```

- **Montée** : gérée par `SKILL-CERTIFIER (Ag-09)`, qui lit le vecteur de poids `ProofRubric` du profil + les traces. Jamais au-dessus de `ceilingMode`.
- **Descente** : `DRIFT-GUARDIAN (Ag-07)` rétrograde sur dérive ; `OutcomeFeedbackPolicy` (G3) rétrograde sur verdict terrain négatif.
- **Borne profil** : en régulé, `ceilingMode` de « TP moyenne sévérité » = `guarded` (oversight humain loggé obligatoire).

### 15.4 Structure de données

```ts
type AutonomyMode = "shadow" | "guarded" | "autonomous" | "handoff"

interface EnvelopeCell {
  alertClass: string        // ex. "phishing", "edr_malware", "brute_force"
  riskLevel: "low" | "medium" | "high" | "critical"
  mode: AutonomyMode
  ceilingMode: AutonomyMode // plafond autorisé par le profil
  gate: RubricRef           // seuils à franchir pour monter d'un cran
  evidence: string[]        // AutonomyTrace ids ayant justifié le mode courant
}

interface AutonomyEnvelope {
  userId: string
  role: string
  profileRef: "mssp_mdr" | "regulated_internal"
  cells: EnvelopeCell[]
  computedAt: Date
}
```

### 15.5 Binding avec les 2 profils de déploiement

| Classe d'alerte / risque | MSSP/MDR (large, orienté débit) | SOC interne régulé (strict, orienté audit) |
|---|---|---|
| FP évident / bruit connu | auto-close autonome | auto-close autonome **avec log signé** |
| TP faible sévérité, playbook clair | remédiation autonome | remédiation **assistée** (validation humaine tracée) |
| TP moyenne sévérité | escalade autonome | escalade **obligatoire + oversight humain loggé** |
| Haute sévérité / incident majeur | escalade + notification interne | **escalade + horloge réglementaire** (DORA 4 h / NIS2 24 h) |
| Donnée réglementée / hors résidence | triage autorisé | **refus/handoff** (ValidationGuard bloque) |

---

## 16. Tests de Vérité — Invariants Architecturaux (D-023)

> **Référence** : D-023 (Domain Pack = Médiateur, pas Curriculum)

### 16.1 Test de vérité — Noyau (primaire)

> « Si je retire totalement le Pack Cyber, est-ce qu'ASCENT garde sa structure, son contrat et son sens ? »
> — Si oui = plateforme. Si non = solution de niche déguisée. **C'est le critère d'acceptation de toute modélisation d'ASCENT.**

### 16.2 Test de médiation — Pack (secondaire)

> « Si je retire le corpus de l'entreprise, reste-t-il un curriculum ? »
> — **Non, et c'est voulu.** Le pack ne fabrique pas de savoir, il **médie** le savoir de l'entreprise.
> Implique : `seed_hash` inclut `corpus_snapshot_id` ; deux entreprises = deux vérités = deux arbres, même pack.

---

## 17. Domain Pack as MEDIATOR — Deux Sources de Vérité

> **Référence** : D-023, `SCYFORGE_FEATURE_REPORT.md §4.6`

Le Domain Pack est un **médiateur**, pas le curriculum :

| | **Vérité pédagogique — « QUOI »** | **Vérité de médiation — « COMMENT structurer »** |
|---|---|---|
| **Détenteur** | **L'entreprise** (fournie explicitement) | **Le Domain Pack** (notre apport) |
| **Nature** | Docs, SOP, playbooks, postmortems, politiques | Ontologie ATT&CK, grammaire tronc/branches/feuilles, rubriques, garde-fous |
| **Autorité** | **Autoritative et non négociable** | **Contextuelle** — donne un cadre solide, aligne, désambiguïse |
| **Si conflit** | **L'entreprise gagne toujours** | le pack s'efface / signale l'écart |

**Implications concrètes** :
- `CorpusProvider` : documents entreprise = source primaire ; sources publiques = échafaudage de médiation
- `OntologyProvider` : grille d'alignement, pas la liste des choses à savoir
- `seed_hash` : `corpus_snapshot_id` = hash des docs entreprise (couche 1 corpus)
- **Formule** : *Pack (contexte + alignement) × Corpus entreprise (vérité du quoi) → parcours de maîtrise → preuve d'autonomie*

---

*Fin du document. Ce doc pilote toutes les décisions d'architecture post-pivot.
Toute PR qui contredit ce doc est à rejeter jusqu'à mise à jour de ce doc.*

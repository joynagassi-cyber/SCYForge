<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
C4 model architecture.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# SCYFORGE — C4 MODEL
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

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## Diagrammes d'Architecture Détaillés — Beachhead Cyber

> **Doc ID** : ARCH-C4-V1
> **Date** : 2026-07-01
> **Statut** : 🔴 FONDEMENT — Réf pour toute PR d'architecture

---

## LÉGENDE

```
┌─────────┐     ───►      relation directe (1:1, 1:N)
[    ]    Container / composant isolable
(    )    Base de données / store
⏺        Event / message
```

---

## NIVEAU 1 — CONTEXT

**Question** : SCYForge dans son écosystème — que contient le système, qui l'utilise, quelles sont les dépendances externes ?

```
┌──────────────────────────────────────────────────────────────────────┐
│                         ÉCOSYSTÈME SCYFORGE                           │
│                                                                      │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────────────┐   │
│  │ SOC Manager  │    │ SOC Analyste │    │ Security Enablement  │   │
│  │              │    │  (L1/L2/     │    │ Lead (SEL)           │   │
│  │ - Créer      │    │   DFIR)      │    │                      │   │
│  │   org        │    │ - Learn      │    │ - Monitor progress   │   │
│  │ - Charger    │    │ - Practice   │    │ - Export reports     │   │
│  │   pack       │    │ - Evaluate   │    │ - Assign roles       │   │
│  │ - Assigner   │    │ - ARENA      │    │                      │   │
│  │   rôles      │    │              │    │                      │   │
│  └──────┬───────┘    └──────┬───────┘    └──────────┬───────────┘   │
│         │                   │                       │                │
│         │   HTTPS/WSS        │   HTTPS/WSS           │   HTTPS/WSS    │
│         ▼                   ▼                       ▼                │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │                      SCY FORGE PLATFORM                         │  │
│  │                                                                │  │
│  │  Frontend (Vercel)  │  Backend (Northflank)  │  Sidecars (Docker)│  │
│  └──────────────────┬─────────────────────────────────────────────┘  │
│                     │                                                │
│   ┌─────────────────┼─────────────────┐                              │
│   │                 │                 │                              │
│   ▼                 ▼                 ▼                               │
│ ┌──────────┐  ┌──────────┐   ┌────────────────┐                      │
│ │Northflank│  │ Zilliz   │   │ SearxNG Docker │                      │
│ │PostgreSQL│  │ Cloud    │   │ (recherche web)│                      │
│ │+ pgvector│  │ (vector) │   │                │                      │
│ └──────────┘  └──────────┘   └────────────────┘                      │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                    PACK CYBER v0.2 (chargé à la demande)      │    │
│  │  Ontologie MITRE ATT&CK  │  SigmaHQ  │  APT29 Scenarios      │    │
│  │  Role Taxonomy           │  Corpus   │  Proof Rubrics          │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                   PACKS FUTURS (non actifs)                   │    │
│  │  Medical │ Law │ Finance │ Aviation  (après beachhead)        │    │
│  └─────────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────┘
```

### Frontières du Système

| Frontière | Ce qui est DEDANS | Ce qui est DEHORS |
|-----------|-------------------|-------------------|
| **Cœur SCYForge** | Axum + Mastra + scy-* crates | Tout ce qui est spécifique à un domaine |
| **Pack Cyber** | Ontologie, rôles, scénarios, corpus | Le cœur ne touche pas les fichiers du pack directement |
| **Sidecars** | SearxNG (Docker) | Zilliz (cloud), Northflank (cloud) |

---

## NIVEAU 2 — CONTAINER

**Question** : Quels sont les grands blocs techniques et comment communiquent-ils ?

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         FRONTEND REACT (Vercel)                          │
│                                                                          │
│  ┌────────────┐  ┌─────────────┐  ┌───────────┐  ┌─────────────────┐   │
│  │ Onboarding │  │  Semantic   │  │  ARENA    │  │   Dashboard     │   │
│  │  Flow      │  │  Tree View  │  │  Engine   │  │   (SMI + Gaps)  │   │
│  │            │  │  (COSMOS    │  │  (APT29   │  │                 │   │
│  │            │  │   lite)     │  │   tree)   │  │                 │   │
│  └─────┬──────┘  └──────┬──────┘  └─────┬─────┘  └────────┬────────┘   │
│        │                │                │                  │           │
│   React Router    G6.js / SVG     Zustand Store      TanStack Query    │
│   + TailwindCSS   (graph lite)    (local state)      (server state)    │
└────────────────────────┬───────────────┬──────────────────────┬─────────┘
                         │ REST API      │ WebSocket            │ REST API
                         ▼               ▼                      ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         AUTH SERVICE (Axum)                              │
│                                                                          │
│  POST /auth/register  POST /auth/login  POST /auth/refresh              │
│  JWT tokens (access + refresh) + Organization mapping                   │
│                                                                          │
│  OIDC / SAML (Phase 2)   │   Email/password (MVP)                      │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    API GATEWAY / ROUTER (Axum)                           │
│                                                                          │
│  POST /api/packs/load            → charger Domain Pack                  │
│  GET  /api/packs/{id}/tree       → Semantic Tree (propriétaire)        │
│  POST /api/tree/plant            → TreeOpResult (roots)               │
│  POST /api/tree/graft            → greffer nœud                       │
│  POST /api/tree/prune            → élaguer                             │
│  GET  /api/roles/{id}/subtree    → sous-arbre de rôle                  │
│  POST /api/scenarios/{id}/start  → initier ARENA                       │
│  POST /api/scenarios/{id}/react  → décision joueur                     │
│  POST /api/mastery/evaluate      → SMI après évaluation                │
│  POST /api/learners/{id}/state   → état de maîtrise                    │
│  GET  /health/live               → liveness                            │
│  GET  /health/ready              → readiness (DB + Zilliz)             │
│  GET  /health/deep               → deep (EventBus + sidecars)          │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │
          ┌─────────────────┼─────────────────┐
          ▼                 ▼                 ▼
┌─────────────────┐ ┌───────────────┐ ┌────────────────┐
│ scy-eventbus     │ │ scy-shared    │ │ scy-apex-fsrs  │
│ (pub/sub)        │ │ (types)       │ │ (SMI calc)     │
│                  │ │ + ports.rs    │ │ (simplifié)    │
│ Events:          │ │ + tree.rs     │ │                │
│ - TreeOpPlanted  │ │               │ │                │
│ - TreeOpGrafted  │ │               │ │                │
│ - ScenarioEv    │ │               │ │                │
│ - MasteryUpd     │ │               │ │                │
└──────────────────┘ └───────────────┘ └────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    PostgreSQL (Northflank)                                │
│                                                                          │
│  (voir section 6 de PIVOT_ARCHITECTURE.sql pour schema complet)         │
│                                                                          │
│  Tables clés beachhead :                                                 │
│  • scy_users              • scy_semantic_trees                           │
│  • scy_domain_packs       • scy_tree_edges                               │
│  • scy_learner_node_states• scy_role_subtrees                            │
│  • scy_scenario_instances • scy_mastery_evaluations                      │
│                                                                          │
│  + pgvector (embeddings) + RLS (RLS policies)                            │
└─────────────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    Zilliz Cloud (Serverless)                              │
│                                                                          │
│  Collection : scy_embeddings                                             │
│  • Vecteurs de chunks de corpus cyber                                    │
│  • Embeddings de requêtes BRAIN (Phase 2+)                               │
│  • Pas utilisé pour Semantic Tree (Postgres stocke ce graphe)            │
└─────────────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    SEARXNG (Docker Sidecar)                              │
│                                                                          │
│  Recherche web en temps réel                                             │
│  • Complétion contexte ARENA (ex: "Qu'est-ce que CVE-2021-44228 ?")    │
│  • Activable via paramètre scenario                                     │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## NIVEAU 3 — COMPONENT

**Question** : Quels sont les composants internes du composant principal (API Gateway) ?

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      API GATEWAY / ROUTER (Axum)                         │
│                                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────────┐  │
│  │   AUTH       │  │  PACK CTRL   │  │  SEMANTIC TREE HANDLER       │  │
│  │              │  │              │  │                              │  │
│  │ POST /login  │  │ POST /load   │  │ POST /plant (14 troncs)     │  │
│  │ POST /reg    │  │ GET /{id}    │  │ POST /graft                 │  │
│  │ POST /refrsh │  │ VALIDATE     │  │ POST /prune                 │  │
│  │ JWT middleware│ │ contract     │  │ POST /test                  │  │
│  │              │  │              │  │ GET /nodes/{id}             │  │
│  │              │  │ Validates:   │  │ GET /edges                  │  │
│  │              │  │ - manifest   │  │ GET /learner/{id}/state     │  │
│  │              │  │ - contract   │  │ POST /myelinate             │  │
│  │              │  │ - integrity  │  │                              │  │
│  └──────────────┘  └──────────────┘  └──────────────────────────────┘  │
│                                                                          │
│  ┌─────────────────┐  ┌──────────────────┐  ┌───────────────────────┐  │
│  │ ROLE PROJECTION │  │ ARENA ENGINE     │  │ MASTERY SERVICE       │  │
│  │                 │  │                  │  │                       │  │
│  │ GET /roles/{id} │  │ POST /scenarios/ │  │ POST /evaluate        │  │
│  │ /subtree        │  │   {id}/start     │  │ GET /learners/{id}/   │  │
│  │                 │  │ POST /scenarios/ │  │   smi                 │  │
│  │ Filters tree    │  │   {id}/react     │  │ POST /certify         │  │
│  │ by role rules   │  │                  │  │                       │  │
│  │ (SOC L1 = 6     │  │ Loads:           │  │ Calculates:           │  │
│  │  core tactics)  │  │ - apt29_chain    │  │ - SMI (weighted avg)  │  │
│  │                 │  │ - 3 branches     │  │ - Gap detection       │  │
│  │ Caches:         │  │ - scoring rubric │  │ - Readiness score     │  │
│  │ role_subtrees    │  │                  │  │                       │  │
│  └─────────────────┘  └──────────────────┘  └───────────────────────┘  │
│                                                                          │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                    HEALTH SERVICES                                 │  │
│  │  GET /health/live   → 200 OK (always, unless process dead)        │  │
│  │  GET /health/ready  → 200 if DB + Zilliz reachable               │  │
│  │  GET /health/deep   → 200 if + EventBus + SearxNG reachable      │  │
│  └───────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## NIVEAU 4 — DEPLOYMENT

**Question** : Comment le système est-il déployé en production ?

```
┌──────────────────────────────────────────────────────────────────────────┐
│                        PRODUCTION DEPLOYMENT                              │
│                                                                           │
│  ┌─────────────────────────────────────────┐  ┌───────────────────────┐   │
│  │         VERCEL EDGE NETWORK              │  │    NORTHFLANK         │   │
│  │                                         │  │                       │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────┐ │  │  ┌─────────────────┐ │   │
│  │  │ Frontend │  │ Frontend │  │Edge  │ │  │  │ Axum Server     │ │   │
│  │  │ (Web)    │  │ (Mobile) │  │Funcs │ │  │  │ (Rust 1.75)     │ │   │
│  │  │ React 18 │  │ Capacitor│  │      │ │  │  │ Tokio runtime   │ │   │
│  │  │ + Vite   │  │ (Phase2) │  │      │ │  │  │                 │ │   │
│  │  └────┬─────┘  └────┬─────┘  └──┬───┘ │  │  │ Endpoints:      │ │   │
│  │       │             │           │     │  │  │ /health/*        │ │   │
│  │       └─────────────┴───────────┘     │  │  │ /api/packs/*     │ │   │
│  │        CDN global < 50ms p95         │  │  │ /api/tree/*      │ │   │
│  │                                         │  │  │ /api/scenarios/* │ │   │
│  │        SSL auto-managed by Vercel     │  │  │ /api/mastery/*   │ │   │
│  │        Preview deploy per PR           │  │  │ └─────────────────┘ │   │
│  │                                         │  │       │              │   │
│  └────────────────────────┬────────────────┘  │  ┌────▼─────────────┐ │   │
│                            │                    │  │ PostgreSQL 15+  │ │   │
│                            │                    │  │ (Northflank)    │ │   │
│                            │                    │  │                 │ │   │
│                            │                    │  │ + pgvector      │ │   │
│                            │                    │  │ + RLS           │ │   │
│                            │                    │  │                 │ │   │
│                            │                    │  │ Tables:         │ │   │
│                            │                    │  │ scy_users        │ │   │
│                            │                    │  │ scy_semantic_    │ │   │
│                            │                    │  │   trees          │ │   │
│                            │                    │  │ scy_tree_edges   │ │   │
│                            │                    │  │ scy_learner_     │ │   │
│                            │                    │  │   node_states    │ │   │
│                            │                    │  │ scy_role_        │ │   │
│                            │                    │  │   subtrees       │ │   │
│                            │                    │  │ scy_scenario_    │ │   │
│                            │                    │  │   instances      │ │   │
│                            │                    │  │ scy_mastery_     │ │   │
│                            │                    │  │   evaluations    │ │   │
│                            │                    │  └─────────────────┘ │   │
│                            │                    │                       │   │
│                            │                    │  ┌─────────────────┐ │   │
│                            │                    │  │ Zilliz Cloud    │ │   │
│                            │                    │  │ (Serverless)    │ │   │
│                            │                    │  │                 │ │   │
│                            │                    │  │ Collection:     │ │   │
│                            │                    │  │ scy_embeddings  │ │   │
│                            │                    │  │ (corpus chunks) │ │   │
│                            │                    │  └─────────────────┘ │   │
│                            │                    │                       │   │
│                            │                    │  ┌─────────────────┐ │   │
│                            │                    │  │ SearxNG Docker  │ │   │
│                            │                    │  │ (Northflank     │ │   │
│                            │                    │  │  container)     │ │   │
│                            │                    │  │ Port: 8888      │ │   │
│                            │                    │  └─────────────────┘ │   │
│                            │                    │                       │   │
└────────────────────────────┼────────────────────┼───────────────────────┘   │
                             │                    │                         │
              HTTPS/WSS <─────┘                    └─────────────────────────┘
```

### Infrastructure Détaillée

| Composant | Provider | Rôle | Coût estimé |
|-----------|----------|------|-------------|
| **Axum Server** | Northflank (container) | API backend Rust | ~$20/mois |
| **PostgreSQL + pgvector** | Northflank managed | Données + vecteurs | ~$15/mois |
| **Zilliz Cloud** | Zilliz (serverless) | Embeddings (Phase 2+) | $0 initial (pay-per-use) |
| **SearxNG** | Northflank (Docker sidecar) | Recherche web | Inclus dans container |
| **Frontend** | Vercel | React SPA | $0 (Hobby) |
| **SSL** | Let's Encrypt (auto Vercel) | HTTPS | $0 |

**Coût infrastructure MVP** : **~$35/mois** (Northflank only).

---

## 5. Découpage par Équipe (si multi-dev avant code)

### Équipe A — Infrastructure & Data

```
Livrables:
├── migrations SQL 001 à 007 (voir PIVOT_ARCHITECTURE §6)
├── Axum server skeleton (/health + middleware)
├── scy-eventbus crate complet
├── PostgreSQLTreeAdapter (impl SemanticTreeProvider)
└── Pack Loader service
```

### Équipe B — Frontend Cyber

```
Livrables:
├── Onboarding flow (rôle → sous-arbre)
├── Semantic Tree viewer (G6.js, 4 modes)
├── ARENA-lite (APT29 decision tree UI)
└── Dashboard SMI + Gaps
```

### Équipe C — Gamification & Business Logic

```
Livrables:
├── Mastery Evaluator (SMI calculation)
├── Role-based subtree projector
├── Proof-of-Skill certificate generator
└── Gap Detection algorithm
```

### Équipe D — Integrations & Docs

```
Livrables:
├── SearxNG integration (sidecar client)
├── Zilliz client (pour Phase 2+)
├── Documentation SOC Manager
└── Tests E2E Playwright
```

*Note : si une seule personne code tout, prioriser Équipe A → Équipe C → Équipe B → Équipe D.*

---

*Fin du document. Ce doc est le reflet fidèle de l'architecture SCYForge post-pivot.
Toute modification du système doit être tracée ici.*

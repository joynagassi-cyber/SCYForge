# PROJECT_CONTEXT.md — Contexte SCY Forge

> **Usage** : Ce fichier est conçu pour être partagé avec un nouvel agent (ou un humain) pour comprendre SCY Forge en **10 minutes**.
> **Version** : V1.0 (2026-07-02)
> **Référence** : `MASTER_AGENT_PROMPT_V2.md` pour les détails complets.

---

## 1. Vision (3 phrases)

SCY Forge est une plateforme d'apprentissage **agentique** où l'utilisateur déclare un objectif et des agents IA orchestrent automatiquement l'ingestion, la génération, la rétention et la certification.

Le **produit différenciant** n'est pas un LMS, pas un chatbot documentaire, pas une plateforme de labs. C'est une **infrastructure de maîtrise opérationnelle** : elle transforme le savoir interne d'une organisation en **autonomie prouvée**.

La promesse utilisateur : **"Zéro friction. Règle des 2 clics."** L'utilisateur décrit, l'agent fait tout.

---

## 2. Les 3 Piliers

| # | Pilier | Code | Rôle |
|---|---|---|---|
| 1 | Semantic Tree + DCID | Pilier 1 | Structure du savoir — un seul arbre pour (a) cerveau apprenant, (b) savoir entreprise, (c) architecture produit |
| 2 | ASCENT Pipeline | Pilier 2 | Transmission du savoir — 13 agents orchestrent objectif → preuve d'autonomie |
| 3 | Generative Forest Engine | Pilier 3 | Création de savoir nouveau — pollinisation entre branches → Seeds plantables |

---

## 3. Beachhead MVP (Jours 1-28)

**Marché cible** : Cyber SOC / Blue-Team
**Personas** : SOC Analyst L1, SOC Analyst L2, Digital Forensic Investigator, Security Enablement Lead
**Source de contenu** : MITRE ATT&CK (pré-ingéré, $0 LLM)

**Features MVP** :
- Semantic Tree + DCID (MITRE ATT&CK)
- ASCENT Plan C (13 agents, refactorisé via SemanticTreeProvider)
- COSMOS 4 modes cyber (Mission Tree, SMI Radar, Threat Terrain, Tactical Zoom)
- APEX B11-B14 cards cyber
- Tactical AI (DeepSeek V4 Free — chat + hints)
- SOC Manager Dashboard (coverage + gap detection)
- Role-Based Onboarding (SOC L1/L2/DFIR en <5min)
- Proof of Skill cert (manager sign-off)

**Features différées Post-MVP** :
- NEURON-CHAINS (7 chaînes LLM)
- ARENA (roleplay Full-AI générique)
- CHRONICLE (coéquipier quotidien)
- 11 Ingestion Cores (YouTube, Reddit, TikTok, etc.)
- Normal Mode + B2B Creator Console
- Reader Suite + IMPRINT
- Finance Suite
- Gamification complète

---

## 4. Stack Technique

| Couche | Technologie | Version |
|---|---|---|
| Backend calcul | Rust + Axum + Tokio | Edition 2021 |
| Backend orchestration | TypeScript + Mastra | Node 20+ |
| Frontend | React 18 + Vite + TailwindCSS | React 18.3 |
| DB Cloud | PostgreSQL 15+ (Northflank) + pgvector | — |
| DB Desktop | SQLite WAL (rusqlite 0.31) | — |
| Vectoriel | Zilliz Cloud (Serverless) / Milvus Lite | — |
| Search sidecar | SearxNG + Perplexica/Vane (Docker) | — |
| LLM | DeepSeek V4 (Free) / Claude (Premium) | — |
| Déploiement | Northflank (backend) + Vercel (frontend) | — |

---

## 5. Structure du code cible

```
backend_rs/     → Rust (calculs lourds, FSRS, petgraph, RAG, NEURON-CHAINS)
backend_ts/     → TypeScript (agents ASCENT, Mastra orchestration)
frontend_react/ → React (COSMOS, APEX UI, Reader Suite, Dashboard)
```

```
backend_rs/crates/
├── scy-eventbus/        ← Service 1 : EventBus (pub/sub)
├── scy-shared/          ← Types partagés (Node, Edge, Seed, LearnerNodeState)
├── scy-semantic-tree/   ← Service 2 : SemanticTreeProvider trait + DCID
├── scy-apex-fsrs/       ← Service 3 : APEX/FSRS retention engine
├── scy-cosmos-kg/       ← Service 4 : COSMOS visualization (4 modes cyber)
├── scy-tactical-ai/     ← Service 5 : DeepSeek V4 Free chat + hints
├── scy-budgetguard/     ← Service 6 : LLM monitoring + alertes
├── scy-gfe/             ← Service 7 : Generative Forest Engine
├── src/
│   ├── ascent/          ← Consommateur (13 agents ASCENT)
│   ├── pack-cyber/      ← Domain Pack implémentation (MITRE ATT&CK)
│   └── certifier/       ← Consommateur (Proof of Skill + manager sign-off)
```

---

## 6. Règles d'or (NON-NÉGOCIABLES)

| # | Règle | Pourquoi |
|---|---|---|
| R1 | **Zéro terme métier cyber dans le core** | Le core doit être générique (finance, santé, etc.) |
| R2 | **Tout seuil est pack-défini** | `mastery_threshold`, weights, helm_axes viennent du pack |
| R3 | **Extensibilité par conception** | Un nouveau domaine = un nouveau pack. Zéro réécriture du noyau. |
| R4 | **EventBus obligatoire** | Zéro appel direct inter-services. |
| R5 | **9 Providers DCID** | Chaque domain pack implémente 9 providers canoniques. |
| R6 | **3 instances du Semantic Tree** | DomainPack, Organization, Learner — même type. |
| R7 | **Seed Lifecycle préservé** | Aucune Seed n'est détruite. DORMANT ≠ mort. |
| R8 | **Confiance = source de vérité** | `confidence` (0.0-1.0) est source. `mastery_score` et `status` sont dérivés. |
| R9 | **Typestate Pattern** | Transitions d'état type-safe au niveau Rust. |
| R10 | **Spécifications d'abord** | spec → plan → tasks → tests → code. |

---

## 7. Vocabulaire canonique

| Terme FR | Terme EN | Alias | Définition |
|---|---|---|---|
| Arbre sémantique | Semantic Tree | STB | Structure dirigée tronc→branches→feuilles |
| Arborisation | Arborization | ARBOR | Transformer un graphe plat en arbre dirigé |
| Pollinisation | Pollination | POLL | Croisement fécondant entre branches éloignées |
| Graine | Seed | — | Résultat génératif, contient un arbre en puissance |
| Viabilité | Seed Viability | — | Probabilité qu'une graine germe |
| Fécondité | Fecundity | — | Potentiel génératif |
| Germination | Germination | — | Déploiement d'une graine en nouveau sous-arbre |
| Gouvernail | Vision Helm | HELM | Vecteur k-dimensionnel + graphe d'objectifs |
| Moteur génératif | Generative Forest Engine | GFE | ARBOR → POLL → Seed → Germinate |
| Maîtrise | Mastery | — | Niveau de compétence prouvé par test (0.0–1.0) |
| Indice de maîtrise | Skill Mastery Index | SMI | Score composite 0-100 |
| Enveloppe d'autonomie | Autonomy Envelope | — | Périmètre borné d'autonomie par rôle/classe d'alerte |
| Domaine Pack | Domain Pack | — | Collection de providers qui injectent la vérité métier |
| DCID | Domain Contract Interface Definition | — | Contrat entre core et domain packs (9 providers) |

---

## 8. Architecture Hexagonale (D-001)

SCY Forge suit une **architecture hexagonale** (ports & adapters) :

- **Domain** : Règles métier pures, 0 dépendance externe
- **Ports** : Traits Rust (interfaces) définis dans `scy-shared`
- **Adapters** : Implémentations concrètes (Postgres, Zilliz, Mastra, UI)

Les **services transverses** (EventBus, APEX/FSRS, COSMOS, GFE) exposent des ports.
Les **consumers** (ASCENT, Certifier, COSMOS UI) consomment ces ports.

Règle d'or : Un service ne connaît pas ses consommateurs.

---

## 9. DCID — 9 Providers (D-020)

Chaque Domain Pack implémente 9 providers :

| # | Provider | Rôle | Obligatoire |
|---|---|---|---|
| 1 | `SemanticTreeProvider` | Pont unique core ↔ pack | ✅ Oui |
| 2 | `OntologyProvider` | Concepts + relations du domaine | Non |
| 3 | `CorpusProvider` | Chunks de texte source | Non |
| 4 | `RoleTaxonomyProvider` | Rôles + sous-arbres par rôle | Non |
| 5 | `DecisionScenarioProvider` | Scénarios ARENA/évaluation | Non |
| 6 | `ProofRubricProvider` | Grilles d'évaluation Proof-of-Skill | Non |
| 7 | `RetentionPolicyProvider` | Règles FSRS/criticality par domaine | Non |
| 8 | `PackConfigProvider` | `mastery_threshold`, smi_weights, helm_axes | Non |
| 9 | `PackJsonSchemaProvider` | Validation optionnelle JSONB (None = accept-all) | Non |

---

## 10. Ordre d'implémentation (Bottom-Up)

**Phase 0 (fondation)** :
1. EventBus (tout le monde en dépend)
2. PostgreSQL + Zilliz + RLS
3. scy-semantic-tree (SemanticTreeProvider trait + DCID)

**Phase 1 (services core)** :
4. scy-pack-ingestion (MITRE STIX parser + Semantic Tree builder)
5. scy-apex-fsrs (FSRS + B11-B14 cards)
6. scy-cosmos-kg (4 modes cyber)

**Phase 2 (services interactifs)** :
7. scy-tactical-ai (DeepSeek V4 Free chat + hints)
8. scy-budgetguard (LLM monitoring)
9. scy-gfe (Generative Forest Engine)

**Phase 3 (consumers)** :
10. ASCENT Pipeline (13 agents)
11. Certifier (Proof of Skill + manager sign-off)
12. pack-cyber/ (implémentation MITRE du trait)

---

## 11. Structure de la documentation

```
minddoc/
├── PROJECT_CONTEXT.md          ← CE FICHIER — contexte partageable
├── PROJECT_CONTEXT_SHORT.md    ← Version 2 min
├── s00_architecture_standards/ ← Architecture unifiée
│   ├── INDEX.md
│   ├── AUDIT_*.md
│   ├── DECISIONS_MASTER.md
│   ├── PATTERNS_MASTER.md
│   ├── work_packages/
│   └── s99_migration_logs/
├── s00_prd/                    ← PRD (Golden Master + Post-MVP)
├── s00_design/                 ← Maquettes + design system
├── s01_semantic_tree/          ← Specs Semantic Tree + DCID
├── s02_neuron_chains_apex_agent/ ← Specs NEURON-CHAINS (Post-MVP)
├── s03_ascent_pipeline_agents/ ← Specs ASCENT (13 agents)
├── s04_scy_cosmos_visualization_engine/ ← Specs COSMOS
├── s05_apex_retention_system/  ← Specs APEX/FSRS
├── s06_scy_brain_rag_assistant/ ← Specs BRAIN (Post-MVP)
├── s07_scy_imprint_cognitive/  ← Specs IMPRINT (Post-MVP)
├── s08_scy_reader_suite/       ← Specs Reader Suite (Post-MVP)
├── s09_harmonist_validation_gates/ ← Specs Harmonist
├── s10_normal_mode_ingestion/  ← Specs Normal Mode (Post-MVP)
├── s11_neuroscientific_engine/ ← Specs Neuro Engine (Post-MVP)
├── s12_b2b_creator_console/    ← Specs B2B (Post-MVP)
└── s13_pivotiq_reconciliation/ ← Specs PIVOTIQ (Post-MVP)

docs/  ← Fichiers opérationnels uniquement (roadmap, build, style, structure)
```

---

## 12. Loi de modification

> **Rappel** : Avant toute modification de ce fichier, valider avec l'humain.
> Ce fichier est la **source de vérité unique** du contexte projet.

---

*PROJECT_CONTEXT.md — SCY Forge — V1.0 — 2026-07-02*

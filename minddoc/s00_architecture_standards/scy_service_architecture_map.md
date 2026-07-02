<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Standards architecturaux — ajouter section beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🏗️ SCY-FORGE — CARTOGRAPHIE ARCHITECTURALE DES SERVICES
**ID Document** : S00_ARCH_SERVICE_MAP  
**Date** : 2026-06-26  
**Statut** : 🔴 FONDEMENT ARCHITECTURAL — DOIT ÊTRE LU AVANT TOUT CODAGE  
**Portée** : Ce document cartographie les **8 services transverses** de SCY Forge, leurs consommateurs, leurs dépendances, et l'ordre d'implémentation. Il corrige la perception selon laquelle certains modules seraient isolés.

---

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

## 1. LE PROBLÈME ARCHITECTURAL

Plusieurs modules du dépôt (s01, s02, s04, s05, s06, s07, s08) ne sont **PAS des modules indépendants**. Ce sont des **SERVICES TRANSVERSES** consommés par de multiples autres modules. Les traiter comme isolés provoque :

- ❌ **Doublons de code** (chaque consommateur réimplémente la logique)
- ❌ **Dépendances circulaires** (A dépend de B qui dépend de A)
- ❌ **Impossibilité de tester** (service non isolable)
- ❌ **Confusion pour l'agent de codage** (où mettre le code ?)

**La solution** : comprendre que SCY Forge suit une **architecture hexagonale** (D-001) où les services transverses sont des **ports/adapters** partagés, et les agents ASCENT (13 agents) + COSMOS + APEX sont les **consumers**.
**[PIVOT-BEACHHEAD]** Normal Mode, B2B Creator Console, et finance/consumer features sont **éliminées** du beachhead. Seuls ASCENT, COSMOS (4 modes), APEX (B11-B14), et Tactical AI sont les consumers MVP.

---

## 2. LES 8 SERVICES TRANSVERSES

### Vue d'ensemble

```
┌─────────────────────────────────────────────────────────────────┐
│                    COUCHE CONSOMMATEURS (MVP)                   │
│                                                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐   │
│  │ ASCENT   │  │ COSMOS   │  │ APEX     │  │ TACTICAL AI  │   │
│  │ Pipeline │  │ 4 modes  │  │ B11-B14  │  │ (chat + hints│   │
│  │ (13 agents│  │ cyber    │  │ cards    │  │  DeepSeek)   │   │
│  │  Plan C) │  │ native)  │  │ cyber)   │  │              │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └──────┬───────┘   │
│       │             │             │                │           │
└────────┼─────────────┼─────────────┼────────────────┼───────────┘
         │             │             │                │
         ▼             ▼             ▼                ▼
┌─────────────────────────────────────────────────────────────────┐
│              COUCHE SERVICES TRANSVERSES (MVP)                  │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 1. SEMANTIC TREE / DCID (Core - Domain Agnostic)        │   │
│  │    SemanticTreeProvider trait + Domain Pack Cyber        │   │
│  │    → Arbre MITRE ATT&CK + Role Subtrees                  │   │
│  │    → 9 providers (SemanticTree + Ontology, Corpus, RoleTaxonomy, Scenarios, Rubric, Retention, Validation + PackConfig + PackJsonSchema)     │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 2. APEX / FSRS (Rétention)                             │   │
│  │    FSRS 5.0 + B11-B14 cards cyber + SMI Calculator      │   │
│  │    → Cartes dues, mastery tracking, Proof of Skill       │   │
│  │    → Couleur nœuds COSMOS (Retrievability)               │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 3. COSMOS Engine (Visualisation 4 modes)                │   │
│  │    Mission Tree + SMI Radar + Threat Terrain + Tactical  │   │
│  │    Zoom                                                   │   │
│  │    → Roadmap ASCENT, mastery radar, gap visualization     │   │
│  │    → Auto-linking IOC → ATT&CK → Playbook → Artifact     │   │
│  └──────────────────────────────────────────────────────────┘   │
│  │    → DAG display (Kanban/Arbre/Gantt/Réseau)             │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 4. BRAIN (RAG + Assistant Conversationnel)              │   │
│  │    Triple Retrieval + Professor AI + Chat Agentique     │   │
│  │    → Réponses contextuelles pendant session ASCENT       │   │
│  │    → Évaluation Teach-Back, Miroir Cognitif              │   │
│  │    → Recherche web live (Perplexica sidecar)             │   │
│  │    → Chat CHRONICLE (WhatsApp/Telegram)                  │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 5. INGESTION CORES (13 sources)                         │   │
│  │    YouTube, Web Search Engine, Academic, Drive, etc.    │   │
│  │    → SOURCE pour NEURON-CHAINS (matière brute)           │   │
│  │    → SOURCE pour COSMOS (concepts/relations)             │   │
│  │    → SOURCE pour BRAIN (chunks RAG)                      │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 6. READER SUITE (Lecture Enrichie)                      │   │
│  │    File Viewer + Web Viewer + Reader Suite + Gallery     │   │
│  │    → Destination des Deep Links (COSMOS, APEX, Citations)│   │
│  │    → Enrichissement IA contextuel (BRAIN)                │   │
│  │    → IMPRINT inline (sessions de lecture)                │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 7. IMPRINT (Mémorisation Profonde)                      │   │
│  │    CRE 5 crans + Garniture Tree + Empreinte Vocabulaire │   │
│  │    → Déclenché par ASCENT Agent-04 (3 succès)            │   │
│  │    → Déclenché par APEX (Leech → Cran 5 forcé)           │   │
│  │    → Génère contenu via NEURON-CHAINS (étymo DELTA)      │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 8. EventBus (Communication Inter-Services)              │   │
│  │    SCY ForgeEvent (pub/sub asynchrone)                  │   │
│  │    → CardReviewed, NodeCompleted, DriftDetected...       │   │
│  │    → Découplage total entre services                     │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
         │             │             │              │
         ▼             ▼             ▼              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   COUCHE INFRASTRUCTURE                         │
│                                                                 │
│  PostgreSQL (Northflank)  │  Zilliz Cloud (vectoriel)          │
│  Redis (Phase 3)          │  SearxNG/Perplexica (Docker sidecar)│
│  Northflank (compute)     │  Vercel (frontend)                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. MATRICE DE CONSOMMATION (MVP Beachhead)

> **[PIVOT-BEACHHEAD]** Les services legacy (NEURON-CHAINS, BRAIN, INGESTION CORES, IMPRINT, ARENA, CHRONICLE, Normal Mode, B2B Creator Console) sont éliminés/différés du MVP.
> Nouveaux services : Semantic Tree/DCID, Tactical AI, BudgetGuard, Domain Pack Ingestion.

### Service 1 — SEMANTIC TREE / DCID (Pont Core ↔ Domain Packs)

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT Agent-01** (Goal-Interpreter) | Appel direct | Formalise objectif selon role_subtree |
| **ASCENT Agent-02** (Content-Scout) | Appel direct | Trouve scenarios + playbooks dans pack |
| **ASCENT Agent-03** (DAG-Architect) | Appel direct | Construit DAG depuis Semantic Tree |
| **ASCENT Agent-04** (Learning-Conductor) | Appel direct | Orchestre sessions selon prereqs |
| **ASCENT Agent-05** (Performance-Analyzer) | Lecture | Calcule SMI par nœud sémantique |
| **ASCENT Agent-06** (Adaptive-Router) | Lecture | Route selon mastery + prereqs |
| **COSMOS** | Lecture | Peuple 4 modes avec nodes + edges |
| **APEX** | Lecture | Crée cartes B11-B14 par nœud |
| **BudgetGuard** | Lecture | Compte tokens/coûts par org |
| **Tactical AI** | Lecture/Écriture | Contextualise réponses sur Semantic Tree |

### Service 2 — APEX / FSRS (Rétention B11-B14)

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT Agent-04** | Lecture | Sélectionne cartes dues pour session |
| **ASCENT Agent-05** | Lecture | Calcule SMI dimension Rétention (35%) |
| **ASCENT Agent-06** | Écriture | Intensifie/réduit intervals selon mastery |
| **COSMOS** | Lecture | Couleur nœuds (Retrievability mastery score) |
| **Certification Service** | Lecture | Éligibilité Proof of Skill (mastery ≥ pack_config.mastery_threshold) |
| **Tactical AI** | Lecture | Hints basés sur cartes révisées/échouées |

### Service 3 — COSMOS Engine (4 Modes Cyber)

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT** (tous agents) | Lecture KG | Vérifier prérequis, mastery, gaps |
| **APEX** | Stats Dashboard | Mode Radar SMI |
| **Tactical AI** | Mini-COSMOS inline | Graphe contextuel dans chat |
| **Manager Dashboard** | Lecture | Coverage % par tactic, gaps d'équipe |
| **Certification Service** | Lecture | Visualisation progression vers cert |

### Service 4 — TACTICAL AI (Chat Contextuel SOC)

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT Agent-04** | Chat hints | Réponse adaptative pendant scénario |
| **ASCENT Agent-06** | Chat remediation | Aide ciblée si mastery < threshold |
| **SOC Manager** | Chat direct | Questions sur équipe, gaps, compliance |
| **Certification** | Chat brief | Briefing CISO (premium, Claude Sonnet) |

### Service 5 — DOMAIN PACK INGESTION (MITRE ATT&CK)

> **[D-023 — Médiateur, pas Curriculum]** Le Domain Pack ne définit PAS ce que l'apprenant doit savoir. Il est le **médiateur** qui structure, aligne et traduit le savoir de l'entreprise en parcours de maîtrise mesurable. Deux sources de vérité : (1) **QUOI** = documents de l'entreprise (source primaire authoritative), (2) **COMMENT** = le pack (ontologie, grammaire arbre/feuilles, rubriques, garde-fous).

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT Agent-02** | Appel direct | Trouve la matière première via `CorpusProvider` (entreprise d'abord, public en échafaudage) |
| **Manager Onboarding** | Appel direct | Crée Role Subtrees (SOC L1/L2/DFIR) via `RoleTaxonomyProvider` |
| **Semantic Tree** | En amont | Peuple scy_semantic_trees + scy_tree_edges via `SemanticTreeProvider` |
| **ValidationGuard** | En aval | Vérifie intégrité du pack avant activation via `ValidationGuardProvider` |
| **GFE** | En aval | Alimente `OntologyProvider` + `CorpusProvider` pour la pollinisation intra-domaine |

**Règle de préséance (corpus)** :
1. Documents entreprise (couche 1) → **TOUJOURS prioritaire**
2. Sources publiques (Sigma, CISA, MITRE Emulation) → échafaudage de médiation, jamais autoritatif

**Test de médiation** : « Si je retire le corpus de l'entreprise, reste-t-il un curriculum ? » → **Non, et c'est voulu.**

### Service 6 — BUDGETGUARD (LLM Monitoring)

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **Tactical AI** | Bloqueur | Bascule en lecture seule si plafond atteint |
| **Manager Dashboard** | Monitoring | Affiche coût LLM courant vs plafond 150$/mois |
| **Stripe billing** | Alertes | Notifie si budget LLM dépasse X% du MRR |

### Service 7 — EventBus

| Événements | Consommateurs |
|-------------|---------------|
| `TreeOpPlanted` | ASCENT tous agents, COSMOS, GFE |
| `TreeOpGrafted` | ASCENT Performance-Analyzer, GFE |
| `TreeOpPruned` | COSMOS, GFE |
| `TreeOpTested` | ASCENT Adaptive-Router, GFE |
| `TreeOpMyelinated` | APEX, Certification, GFE |
| `ScenarioEvaluated` | Gamification, Manager Dashboard, GFE |
| `MasteryUpdated` | COSMOS (refresh), Tactical AI, GFE |
| `GapDetected` | Manager Dashboard, Tactical AI, GFE |
| `BudgetThreshold` | BudgetGuard, Stripe |
| `SeedPollinated` | GFE Engine, Seed Explorer, ASCENT |
| `SeedViable` | GFE Engine, Manager Dashboard, Seed Explorer |
| `SeedDormant` | GFE Engine (archive, réveil bitemporel) |
| `SeedGerminated` | ASCENT Agent-03, COSMOS (refresh), APEX |
| `PackConfigChanged` | Tous services (invalidation cache) |
| `AutonomyCellUpgraded` | SKILL-CERTIFIER, Dashboard, ADAPTIVE-ROUTER |
| `AutonomyCellDowngraded` | DRIFT-GUARDIAN, Dashboard |
| `AutonomyEnvelopeRecomputed` | SKILL-CERTIFIER, ARENA |
| `OutputPressureApplied` | GOAL, DAG, ADAPTIVE-ROUTER, SKILL-CERTIFIER |
| `FrictionAdjusted` | ARENA, PERFORMANCE-ANALYZER |
| `ConsolidationWindowStarted` | APEX/FSRS, LEARNING-CONDUCTOR |
| `SparringModeActivated` | SKILL-CERTIFIER, ARENA |
| `SemanticTreePriorityEnforced` | DAG-ARCHITECT, ADAPTIVE-ROUTER |
| `OutcomeFeedbackReceived` | DRIFT-GUARDIAN, SKILL-CERTIFIER, CHRONICLE |

### Service 8 — GENERATIVE FOREST ENGINE (GFE) — Phase 2

**[PIVOT-GFE]** Le GFE est le 3ème pilier de SCY Forge : il produit des graines plantables (extensions, reconversions, innovations) à partir du savoir privé de l'entreprise.
Référence : `docs/SCYFORGE_GENERATIVE_TREE_POLLINATION_SEED.md`, `docs/SCYFORGE_GENERATIVE_ENGINE_LOGICAL_MODEL.md`, `docs/SCYFORGE_GENERATIVE_ENGINE_MATH_FORMALIZATION.md`.

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT Agent-10** (Cross-Pollinator) | Appel direct | Détecte croisements féconds entre branches éloignées du STB |
| **SOC Manager (P-SEL)** | Dashboard | Voit les graines générées pour son équipe + décide de les planter |
| **RSSI (P-RSSI)** | Dashboard | Voit les graines stratégiques alignées sur sa vision + compliance |
| **COSMOS** | Lecture | Met en évidence les branches à fort potentiel de pollination |
| **Vision Helm** | Filtre | Aligne toutes les graines sur la stratégie de l'entreprise |

| Événements | Consommateurs |
|-------------|---------------|
| `SeedPollinated` | ASCENT Cross-Pollinator, COSMOS |
| `SeedViable` | SOC Manager Dashboard, RSSI Dashboard |
| `SeedGerminated` | ASCENT (nouveau sous-arbre), COSMOS (refresh) |
| `SeedDormant` | Archive (réveil bitemporel possible) |

---

### Service 8 — AUTONOMY ENVELOPE (Périmètre d'Autonomie)

[PIVOT-AUTONOMY] L'Autonomy Envelope est un **objet de 1re classe** qui certifie ce qu'une recrue peut faire seule, sous supervision, ou pas encore. La preuve d'autonomie ne dit jamais « autonome » en absolu — elle certifie un **périmètre borné** : *ce rôle est autonome sur telles classes d'alerte à tel niveau de risque*.

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT Agent-09** (SKILL-CERTIFIER) | Écriture | Certifie les cellules de l'enveloppe (shadow → guarded → autonomous) |
| **ASCENT Agent-07** (DRIFT-GUARDIAN) | Écriture | Rétrograde cellules sur dérive / illusion de compétence |
| **ASCENT Agent-06** (ADAPTIVE-ROUTER) | Lecture | Route remédiation selon mode courant de chaque cellule |
| **ASCENT Agent-11** (ARENA) | Lecture | Vérifie ceilingMode avant de proposer un scénario L4 |
| **SOC Manager (P-SEL)** | Dashboard | Voit la carte d'autonomie de chaque recrue |
| **RSSI (P-RSSI)** | Dashboard | Voit l'enveloppe + conformité réglementaire |

| Événements | Consommateurs |
|-------------|---------------|
| `AutonomyCellUpgraded` | SKILL-CERTIFIER, Dashboard, ADAPTIVE-ROUTER |
| `AutonomyCellDowngraded` | DRIFT-GUARDIAN, Dashboard |
| `AutonomyEnvelopeRecomputed` | SKILL-CERTIFIER, ARENA |

**Matrice `classe d'alerte × niveau de risque`** (2 profils de déploiement) :

| Classe d'alerte / risque | MSSP/MDR | SOC interne régulé |
|---|---|---|
| FP évident / bruit connu | auto-close autonome | auto-close autonome **avec log signé** |
| TP faible sévérité, playbook clair | remédiation autonome | remédiation **assistée** (validation humaine tracée) |
| TP moyenne sévérité | escalade autonome | escalade **obligatoire + oversight humain loggé** |
| Haute sévérité / incident majeur | escalade + notification interne | **escalade + horloge réglementaire** (DORA 4h / NIS2 24h) |
| Donnée réglementée / hors résidence | triage autorisé | **refus/handoff** (ValidationGuard bloque) |

---

## 4. LES 3 PILIERS (Pillars) — BEACHHEAD vs GFE

> **[PIVOT-GFE]** SCY Forge repose sur 3 piliers distincts :
> - **Pilier 1** : Semantic Tree + DCID (structure du savoir)
> - **Pilier 2** : ASCENT Pipeline (transmission du savoir)
> - **Pilier 3** : GFE — Generative Forest Engine (création de savoir nouveau)
>
> Pour le beachhead MVP M0-M36, le GFE est en **mode observatoire** (pollinisation intra-domaine, Seeds stockées).
> Mode B (Normal Mode) et Mode C (B2B Creator Console) sont **éliminés** du MVP.

### Pilier A — Semantic Tree + DCID (Structure du Savoir)

```
SemanticTreeProvider (trait DCID D-019)
    ↓ plant_tree("MITRE-ATT&CK-v14.1")
Semantic Tree (14 troncs, 20 branches, 130 feuilles)
    ↓ graft_node / prune_node / myelinate_node
Arbre vivant + Knowledge Graph bitemporel
```

### Pilier B — ASCENT Pipeline (Transmission du Savoir)

```
SOC Manager déclare objectif
    → Agent-01 formalise (org, roles, pack MITRE)
    → Agent-02 charge pack Cyber (pré-ingéré, $0 LLM)
    → Agent-03 construit Role Subtrees (SemanticTreeProvider::graft_node)
    → Agent-04 orchestre sessions (APEX/FSRS + COSMOS + Tactical AI)
    → Agent-05 calcule SMI (via APEX/FSRS)
    → Agent-06 route (fast-track/normal/remédiation selon mastery)
    → Agent-07 surveille drift
    → Agent-09 certifie (Proof of Skill avec manager sign-off)
    → COSMOS affiche Mission Tree automatiquement
    → Tactical AI accompagne en contexte
```

### Pilier C — GFE — Generative Forest Engine (Création de Savoir Nouveau)

```
Semantic Tree (STB) + Knowledge Graph bitemporel
    ↓
POLLINATION (Pollination(A, B, ctx) → Seed | ∅)
    Conditions L1-L4 : distance ≥ θ_min + pont logique + nouveauté + align(H) ≥ τ
    ↓
SEED (5 composants : Core Proposition, Parenthood, Potential Tree, Viability Profile, Provenance)
    ↓
SCORING : Viability × Fecundity → PlantScore
    ↓
VIABLE (PlantScore ≥ 0.40) → Germination → Nouveau sous-arbre
DORMANT (PlantScore < 0.40) → Archive (réveil bitemporel possible)
```

> **[BEACHHEAD]** Le GFE est en **mode observatoire** : pollinisation intra-domaine MITRE, Seeds stockées, germination manuelle par SOC Manager.
> **Post-MVP M36+** : GFE passe en **mode expansion** — cross-pollination inter-STB + germination auto.

### Mode B **[ELIMINATED]** — Normal Mode (Ingestion directe)

```
SOC Manager déclare objectif
    → Agent-01 formalise (org, roles, pack MITRE)
    → Agent-02 charge pack Cyber ( pré-ingéré, $0 LLM)
    → Agent-03 construit Role Subtrees (SemanticTreeProvider::graft_node)
    → Agent-04 orchestre sessions (APEX/FSRS + COSMOS + Tactical AI)
    → Agent-05 calcule SMI (via APEX/FSRS)
    → Agent-06 route (fast-track/normal/remédiation selon mastery)
    → Agent-07 surveille drift
    → Agent-09 certifie (Proof of Skill avec manager sign-off)
    → COSMOS affiche Mission Tree automatiquement
    → Tactical AI accompagne en contexte
```

### Mode B **[ELIMINATED]** — Normal Mode (Ingestion directe)
*[PIVOT-BEACHHEAD — ELIMINATED]* Normal Mode (consumer direct ingestion) éliminé.
Raison : Beachhead B2B uniquement. Pas d'utilisateurs consumers.

### Mode C **[ELIMINATED]** — B2B Creator Console
*[PIVOT-BEACHHEAD — ELIMINATED]* B2B Creator Console éliminée.
Raison : SCY Forge vend parcours pré-construits MITRE, pas création de contenu.
Retour Phase 3 si expansion multi-domaine (Finance, Medical).

---

## 5. IMPLICATIONS POUR LE CODAGE — Beachhead MVP

### Règle 1 — Crates MVP (7 services)

```
backend_rs/
├── crates/
│   ├── scy-eventbus/          ← Service (pub/sub EventBus D-010)
│   ├── scy-pack-ingestion/    ← Service (MITRE STIX parser + Semantic Tree builder)
│   ├── scy-semantic-tree/     ← Service (SemanticTreeProvider trait + DCID D-019)
│   ├── scy-apex-fsrs/         ← Service (FSRS + B11-B14 cards)
│   ├── scy-cosmos-kg/         ← Service (4 modes cyber only)
│   ├── scy-tactical-ai/       ← Service (DeepSeek V4 Free chat + hints)
│   ├── scy-budgetguard/       ← Service (LLM monitoring + alertes)
│   └── scy-gfe/               ← Service (Generative Forest Engine D-021 + Seed Traceability D-022)
├── src/
│   ├── ascent/                ← Consommateur (13 agents Plan C)
│   ├── certifier/             ← Consommateur (Proof of Skill + manager sign-off)
│   ├── pack-cyber/            ← Domain Pack implémentation (MITRE ATT&CK)
│   └── gfe-core/              ← Core générique GFE (domain-agnostic : pollination, scoring, Vision Helm)
```

### Règle 2 — Ordre de dépendance (bottom-up) — Beachhead

```
Phase 0 (fondation) :
  1. EventBus          (tout le monde en dépend)
  2. PostgreSQL + Zilliz + RLS (persistance + vector)
  3. scy-semantic-tree/ (SemanticTreeProvider trait + DCID D-019)

Phase 1 (services core) :
  4. scy-pack-ingestion/ (MITRE STIX → Semantic Tree)
  5. scy-apex-fsrs/ (FSRS + B11-B14)
  6. scy-cosmos-kg/ (4 modes cyber)

Phase 2 (services interactifs + GFE observatoire) :
  7. scy-tactical-ai/ (DeepSeek V4 Free)
  8. scy-budgetguard/ (LLM monitoring)
  9. scy-gfe/ (Generative Forest Engine — pollinisation intra-domaine + Seeds + Vision Helm)

Phase 3 (consommateurs) :
  10. ASCENT Pipeline  (13 agents consomment tous les services)
  11. Certifier       (Proof of Skill + manager sign-off)
  12. pack-cyber/     (implémentation MITRE du trait)
```

### Règle 3 — Un service ne connaît pas ses consommateurs

Le `scy-pack-ingestion/` ne sait pas que ASCENT va l'utiliser. Il expose uniquement le trait `SemanticTreeProvider`.
Le `scy-apex-fsrs/` ne sait pas que COSMOS va lire les scores. Il expose uniquement `get_due_cards()` + `calculate_smi()`.

### Règle 4 — Zéro terme métier dans le core

```
✅ scy-semantic-tree/src/lib.rs
   - tree_kind: "Trunk" | "Branch" | "Leaf"          ← GENERIC
   - edge_kind: "Prereq" | "Relates" | "Contradicts" ← GENERIC

❌ JAMAIS dans le core :
   - MASTERY_THRESHOLD (fourni par PackConfigProvider) ← PACK-DÉFINI
   - "MITRE", "TACTIC", "TECHNIQUE"                   ← CYBER
   - "SOC", "DFIR", "IOC"                             ← CYBER
   - "Sigma", "CVE"                                   ← CYBER
```

Tout terme cyber vit dans `pack-cyber/` uniquement.

### Règle 5 — DCID Contract (9 Providers)

Chaque domain pack implémente 9 providers via le trait `SemanticTreeProvider` (PRIMARY, obligatoire) + 8 providers optionnels :

| # | Provider | Rôle | Obligatoire |
|---|----------|------|-------------|
| 1 | `SemanticTreeProvider` | Pont unique core ↔ pack (plant/graft/prune/test/myelinate/load) | ✅ Oui |
| 2 | `OntologyProvider` | Concepts + relations du domaine | Non |
| 3 | `CorpusProvider` | Chunks de texte source | Non |
| 4 | `RoleTaxonomyProvider` | Rôles + sous-arbres par rôle | Non |
| 5 | `DecisionScenarioProvider` | Scénarios ARENA/évaluation | Non |
| 6 | `ProofRubricProvider` | Grilles d'évaluation Proof-of-Skill | Non |
| 7 | `RetentionPolicyProvider` | Règles FSRS/criticality par domaine | Non |
| 8 | `PackConfigProvider` | **mastery_threshold, smi_weights, helm_axes, criticality_formula**. Le core ne connaît aucun seuil. Absence → `MissingPackConfig`. | Non |
| 9 | `PackJsonSchemaProvider` | Validation optionnelle du JSONB custom. `None` = le core accepte tout JSONB valide sans validation de structure. | Non |

```rust
pub trait DomainPack {
    type Tree: SemanticTreeProvider;           // PRIMARY
    type Ontology: OntologyProvider;
    type Corpus: CorpusProvider;
    type RoleTaxonomy: RoleTaxonomyProvider;
    type Scenarios: DecisionScenarioProvider;
    type Rubric: ProofRubricProvider;
    type Retention: RetentionPolicyProvider;
    type Validation: ValidationGuardProvider;
    type PackConfig: PackConfigProvider;       // ← NOUVEAU
    type JsonSchema: PackJsonSchemaProvider;   // ← NOUVEAU
}
```

Le pack Cyber implémente ces 9 providers avec MITRE ATT&CK comme ontology.

L'EventBus garantit le découplage :
- NEURON-CHAINS publie `DocumentGenerated` → il ne sait PAS qui va le consommer (ASCENT ? Normal Mode ? BRAIN ?)
- APEX publie `CardReviewed` → il ne sait PAS qui l'écoute (ASCENT Agent-05 ? COSMOS ? CHRONICLE ?)
- **Zéro couplage direct** entre services (D-010 Observer Pattern)

---

## 6. CE QUE ÇA CHANGE POUR LES SPECS

Les specs que nous avons écrites restent **valables sur le comportement** (le "quoi"). Mais pour le codage, l'agent doit comprendre :

| Spec dit | Agent doit comprendre |
|----------|----------------------|
| "NEURON-CHAINS génère des cartes pour APEX" | NEURON-CHAINS est un **service partagé**, pas un module d'APEX. APEX **appelle** NEURON-CHAINS. |
| "Agent-04 déclenche IMPRINT" | Agent-04 est un **consommateur** qui appelle le service IMPRINT. |
| "COSMOS affiche les couleurs FSRS" | COSMOS **lit** l'état FSRS via EventBus ou API, il ne calcule pas FSRS. |
| "BRAIN évalue le Teach-Back" | BRAIN est un **service RAG** appelé par APEX pour l'évaluation, pas l'inverse. |

---

## 7. PROCHAINES ÉTAPES

Ce document est le **pont** entre les specs (le "quoi") et les 5 documents de codage (le "comment"). Il doit être lu **avant** :
1. `AGENTS.md` (instructions permanentes pour l'agent)
2. `PROJECT_STRUCTURE.md` (arborescence réelle du code)
3. `BUILD_COMMANDS.md` (commandes build/test/lint)
4. `IMPLEMENTATION_ORDER.md` (ordre séquencé des sprints)
5. `CODE_STYLE.md` (conventions de code)

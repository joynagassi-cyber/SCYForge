# 🏗️ SCY-FORGE — CARTOGRAPHIE ARCHITECTURALE DES SERVICES
**ID Document** : S00_ARCH_SERVICE_MAP  
**Date** : 2026-06-26  
**Statut** : 🔴 FONDEMENT ARCHITECTURAL — DOIT ÊTRE LU AVANT TOUT CODAGE  
**Portée** : Ce document cartographie les **8 services transverses** de SCY Forge, leurs consommateurs, leurs dépendances, et l'ordre d'implémentation. Il corrige la perception selon laquelle certains modules seraient isolés.

---

## 1. LE PROBLÈME ARCHITECTURAL

Plusieurs modules du dépôt (s01, s02, s04, s05, s06, s07, s08) ne sont **PAS des modules indépendants**. Ce sont des **SERVICES TRANSVERSES** consommés par de multiples autres modules. Les traiter comme isolés provoque :

- ❌ **Doublons de code** (chaque consommateur réimplémente la logique)
- ❌ **Dépendances circulaires** (A dépend de B qui dépend de A)
- ❌ **Impossibilité de tester** (service non isolable)
- ❌ **Confusion pour l'agent de codage** (où mettre le code ?)

**La solution** : comprendre que SCY Forge suit une **architecture hexagonale** (D-001) où les services transverses sont des **ports/adapters** partagés, et les agents ASCENT + Normal Mode + B2B sont les **consumers**.

---

## 2. LES 8 SERVICES TRANSVERSES

### Vue d'ensemble

```
┌─────────────────────────────────────────────────────────────────┐
│                    COUCHE CONSOMMATEURS                         │
│                                                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ ASCENT   │  │ NORMAL   │  │ B2B      │  │ CHRONICLE│      │
│  │ Pipeline  │  │ Mode     │  │ Console  │  │ Guardian │      │
│  │ (18 agents│  │(ingestion│  │(créateurs│  │(omniprés)│      │
│  │  + QA)   │  │ directe) │  │ DRH)     │  │          │      │
│  └─────┬────┘  └─────┬────┘  └─────┬────┘  └─────┬────┘      │
│        │             │             │              │            │
└────────┼─────────────┼─────────────┼──────────────┼────────────┘
         │             │             │              │
         ▼             ▼             ▼              ▼
┌─────────────────────────────────────────────────────────────────┐
│              COUCHE SERVICES TRANSVERSES                        │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 1. NEURON-CHAINS (Génération)                           │   │
│  │    APEX-AGENT + 7 chaînes + 18 tools + anti-halluc     │   │
│  │    → Cours, cartes APEX, exercices, étymologie IMPRINT  │   │
│  │    → Documents Normal Mode, livrables BRAIN agentique   │   │
│  │    → Scénarios ARENA, rapports hebdo, réécriture QA     │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 2. APEX / FSRS (Rétention Mémoire)                      │   │
│  │    FSRS 5.0 + 10 types cartes + SMI Calculator          │   │
│  │    → Cartes dues, Health Score CHRONICLE                 │   │
│  │    → Couleur nœuds COSMOS (Retrievability)               │   │
│  │    → Recalibration Teach-Back, trigger IMPRINT           │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ 3. COSMOS (Visualisation)                               │   │
│  │    26 modes + 12 engines + WebGPU + Knowledge Graph      │   │
│  │    → Roadmap ASCENT, SMI radar, decay visualization      │   │
│  │    → Mini COSMOS inline (Reader Suite, File Viewer)      │   │
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

## 3. MATRICE DE CONSOMMATION (Qui appelle Qui)

### Service 1 — NEURON-CHAINS (le plus consommé)

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT Agent-03** (DAG-ARCHITECT) | Appel direct | Génère docs + cartes par nœud DAG (12 cartes/nœud, cours, résumés) |
| **ASCENT Agent-04** (LEARNING-CONDUCTOR) | Appel direct | Génère contenu supplémentaire si besoin pendant session |
| **ASCENT Agent-06** (ADAPTIVE-ROUTER) | Appel direct | Régénère contenu avec ton différent si blocage |
| **ASCENT Agent-08** (ENGAGEMENT) | Appel direct | Génère rapports hebdomadaires (type B01) |
| **ASCENT Agent-12** (VISUAL-CRITIC) | Appel retour | Renvoie sections défaillantes (score < 85) pour correction NEURON-CHAINS |
| **ASCENT-QA Comité** | Appel retour | Renvoie contenu rejeté (PQS < 88) pour réécriture APEX-AGENT |
| **APEX (s05)** | Chaîne EPSILON | Génère les 10 types de cartes (B01-B10) + exercices (C01-C20) |
| **IMPRINT (s07)** | Chaîne DELTA + GAMMA-3 | Génère étymologie, définitions, exemples pour Empreinte Vocabulaire + Cran 5 FORGE |
| **Normal Mode (s10)** | Appel direct post-ingestion | **CAS PRINCIPAL** : génère cours, cartes, résumés immédiatement après ingestion ($0 attente) |
| **BRAIN (s06)** | APEX-AGENT + 18 tools | Chat agentique : génère livrables (PowerPoint G13, rapports, veilles) |
| **Reader Suite (s08)** | Book Orchestrator | Orchestre la génération selon l'intention utilisateur (7 intentions) |
| **ARENA (ag11)** | Appel direct | Génère scénarios de simulation + debriefs + exercices ciblés |

> **Conclusion** : NEURON-CHAINS est un **service central** appelé par 12+ consommateurs. Il DOIT être implémenté en tant que **bibliothèque/service partagé**, pas comme un module isolé.

### Service 2 — APEX/FSRS

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT Agent-03** | Appel direct | Crée 12 cartes par nœud DAG |
| **ASCENT Agent-04** | Lecture | Sélectionne cartes dues pour session |
| **ASCENT Agent-05** | Lecture historique | Calcule SMI dimension Rétention (35% du score) |
| **ASCENT Agent-06** | Écriture | Intensifie/réduit les intervals selon SMI |
| **ASCENT Agent-07** | Lecture | Surveille "sessions tronquées" (drift) |
| **ASCENT Agent-09** | Lecture | SMI pour certification Proof of Skill |
| **ASCENT Agent-10** (CHRONICLE) | Lecture agrégée | Health Score, Daily Pulse, Resurrection Protocol |
| **COSMOS (s04)** | Lecture R par nœud | Couleur des nœuds (R<50% → estompé) |
| **IMPRINT (s07)** | Lecture | Trigger après 3 succès consécutifs APEX |
| **Normal Mode (s10)** | Activation immédiate | Cartes FSRS activées dès ingestion ($0 attente) |
| **Reader Suite (s08)** | Lecture | Cartes APEX liées dans sidebar File Viewer |
| **Teach-Back (STUDENT AI)** | Écriture | Recalibration FSRS depuis l'enseignement (well-explained → Stability +15%) |

### Service 3 — COSMOS

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT** (tous agents) | Lecture KG | Vérifier prérequis, SMI existant, Gap Detection |
| **APEX** | Stats Dashboard | Mode 7 (Statistics), Mode 14 (Radar SMI) |
| **BRAIN** | Mini COSMOS inline | Graphe chapitre dans File Viewer sidebar |
| **Reader Suite** | Graphiques intégrés | 1-3 visualisations COSMOS dans Reader Suite |
| **Normal Mode** | Activation immédiate | Visualisation immédiate du graphe post-ingestion |
| **DAG Display** | Mode 4 (Roadmap) | Visualisation Kanban/Arbre/Gantt/Réseau |

### Service 4 — BRAIN

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT Agent-01** | Starter Evaluator | Évaluation niveau initial (signaux passifs BRAIN) |
| **ASCENT Agent-04** | Assistant contextuel | Réponses pendant session d'apprentissage |
| **ASCENT Agent-06** | Pair tutor | Mode coach empathique en remédiation |
| **APEX** | Évaluation | Teach-Back B07 (BRAIN évalue la qualité), Miroir Cognitif mode 2 |
| **CHRONICLE** | Canal chat | Conversation native WhatsApp/Telegram |
| **Reader Suite** | Insights | Résumés progressifs, insights IA contextuels |
| **ARENA** | Questions | Génère questions socratiques dans les simulations |

### Service 5 — INGESTION CORES

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT Agent-02** | Appel direct | Recherche + ingestion automatique des sources par nœud |
| **Normal Mode** | Appel direct | Ingestion directe utilisateur (URL/upload) |
| **Reader Suite** | Lecture fichiers | File Viewer affiche les fichiers ingérés |
| **B2B Console** | Ingestion privée | Upload SOP entreprise (SOP→SMI) |
| **NEURON-CHAINS** | En aval | Consomme la matière brute pour générer contenu |
| **COSMOS** | En aval | Consomme concepts/relations pour peupler le KG |
| **BRAIN** | En aval | Consomme chunks pour le RAG |

### Service 6 — READER SUITE

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **COSMOS** | Deep links | Clic nœud → Reader Suite à la position exacte |
| **APEX** | Deep links (D-OPT-002) | Clic carte → Reader Suite source exacte |
| **Citations [1][2]** | Deep links | Clic citation → Reader Suite position source |
| **BRAIN** | Ouverture docs | Réponses avec lien vers document original |
| **Book Orchestrator** | Transition | Orchestre l'expérience lecture depuis Web Viewer |

### Service 7 — IMPRINT

| Consommateur | Comment | Pour quoi |
|-------------|---------|-----------|
| **ASCENT Agent-04** | Déclenchement | Après 3 succès + SMI > 75% + nœud complexe |
| **APEX** | Déclenchement forcé | Leech → Cran 5 IMPRINT (D-OPT-052) |
| **Reader Suite** | IMPRINT inline | Cran 5 proposé dans session de lecture |
| **NEURON-CHAINS** | En amont | DELTA génère étymologie, GAMMA-3 définitions |

### Service 8 — EventBus

| Consommateur | Événements |
|-------------|------------|
| **TOUS les agents ASCENT** | `GoalInterpreted`, `DagBuilt`, `NodeCompleted`, `NodeUnlocked`, `CardReviewed`, `DriftDetected`, `SessionEnded` |
| **COSMOS** | `KnowledgeGraphUpdated` → mise à jour graphe |
| **APEX** | `CardReviewed` → recalcul SMI |
| **CHRONICLE** | `DriftDetected`, `BudgetThresholdReached` → interventions |
| **NEURON-CHAINS** | `SourceIngested` → déclenchement génération, `DocumentGenerated` → score confiance |

---

## 4. LES 3 FONCTIONNEMENTS (Modes) QUI ORCHESTRENT TOUT

### Mode A — ASCENT Pipeline (parcours structuré)
```
Utilisateur déclare objectif
    → Agent-01 formalise
    → Agent-02 ingère sources (via INGESTION CORES)
    → Agent-03 construit DAG + déclenche NEURON-CHAINS (génère cours/cartes/exos)
    → Agent-04 orchestre sessions (APEX/FSRS + BRAIN + COSMOS + IMPRINT)
    → Agent-05 calcule SMI (via APEX/FSRS)
    → Agent-06 route (fast-track/normal/remédiation)
    → Agent-07 surveille drift
    → Agent-08 gamifie
    → Agent-09 certifie (Proof of Skill)
    → [Premium] Agent-10 CHRONICLE accompagne
    → [Premium] Agent-11 ARENA simule
    → Agent-12/13 valident visuel/cognitif
    → QA Comité audit pédagogique (Parcours B)
```

### Mode B — Normal Mode (ingestion directe, sans ASCENT)
```
Utilisateur ingère une source (URL/upload via INGESTION CORES)
    → NEURON-CHAINS génère immédiatement cours + cartes + résumés ($0 attente)
    → APEX/FSRS active les cartes immédiatement
    → COSMOS visualise le graphe immédiatement
    → BRAIN est disponible pour questions
    → IMPRINT disponible si trigger
    → PAS de certification (Parcours A, zéro certificat)
```

### Mode C — B2B Console (créateur/entreprise)
```
Créateur upload SOP/manuel (via INGESTION CORES privée)
    → NEURON-CHAINS transforme en cursus actif
    → QA Comité + AGENT-16 auditent (Parcours B, PQS ≥ 88)
    → Cohorte suit le cursus (via ASCENT ou Normal Mode)
    → Creator Dashboard suit SMI de cohorte (Agent-13 goulots)
    → Micro-clarifications créateur → Zilliz (Synaptic Loop)
```

---

## 5. IMPLICATIONS POUR LE CODAGE

### Règle 1 — Les services transverses sont des CRATES/BIBLIOTHÈQUES partagés

```
backend_rs/
├── crates/
│   ├── scy-neuron-chains/     ← Service (pas un module isolé)
│   ├── scy-apex-fsrs/         ← Service
│   ├── scy-cosmos-kg/         ← Service (data layer du graphe)
│   ├── scy-brain-rag/         ← Service
│   ├── scy-ingestion/         ← Service
│   ├── scy-reader/            ← Service
│   ├── scy-imprint/           ← Service
│   └── scy-eventbus/          ← Service
├── src/
│   ├── ascent/                ← Consommateur (appelle les services)
│   ├── normal_mode/           ← Consommateur
│   └── b2b/                   ← Consommateur
```

### Règle 2 — Ordre de dépendance (bottom-up)

Les services DOIVENT être codés dans cet ordre car les consommateurs en dépendent :

```
Phase 0 (fondation) :
  1. EventBus          (tout le monde en dépend)
  2. INGESTION CORES   (source de matière brute)
  3. PostgreSQL + Zilliz (persistance)

Phase 1 (services core) :
  4. NEURON-CHAINS     (génère tout le contenu)
  5. APEX/FSRS         (rétention mémoire)
  6. COSMOS            (visualisation + KG)

Phase 2 (services secondaires) :
  7. BRAIN             (RAG + assistant, dépend de NEURON-CHAINS + INGESTION)
  8. READER SUITE      (dépend de INGESTION + BRAIN)
  9. IMPRINT           (dépend de NEURON-CHAINS + APEX)

Phase 3 (consommateurs) :
  10. ASCENT Pipeline  (consomme TOUS les services)
  11. Normal Mode      (consomme INGESTION + NEURON + APEX + COSMOS + BRAIN)
  12. B2B Console      (consomme INGESTION + NEURON + QA + COSMOS)

Phase 4 (Premium) :
  13. CHRONICLE        (consomme APEX + BRAIN + EventBus)
  14. ARENA            (consomme NEURON + BRAIN + APEX)
```

### Règle 3 — Un service ne connaît pas ses consommateurs

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

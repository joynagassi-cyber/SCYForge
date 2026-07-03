<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🚀 SCY FORGE — ASCENT AUTONOMOUS PIPELINE
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

## Architecture Agentique Autonome : SCY Forge comme Machine à Compétences

---

**Document ID** : ARCH-ASCENT-AUTONOMOUS-V1  
**Date** : 2026-06-08  
**Statut** : 🔵 ARCHITECTURE DE RÉFÉRENCE  
**Objectif Absolu** : *"Si tu déclares un objectif dans SCY Forge, tu l'atteins — garanti par les agents."*  
**Promesse** : *"Si tu complètes ASCENT sur un objectif, tu as la compétence — vérifiable."*

---

## Table des Matières

1. [Vision Système — SCY Forge comme Organisme Vivant](#1-vision-système)
2. [Vue d'Ensemble — La Pipeline Agentique Complète](#2-vue-densemble)
3. [Les 13 Agents Autonomes ASCENT](#3-les-9-agents-autonomes-ascent)
4. [Orchestration Inter-Features — Comment les Agents Pilotent Tout](#4-orchestration-inter-features)
5. [Cycle de Vie Complet d'un Parcours](#5-cycle-de-vie-complet-dun-parcours)
6. [Le Moteur de Décision Adaptatif](#6-le-moteur-de-décision-adaptatif)
7. [Système de Détection et Intervention](#7-système-de-détection-et-intervention)
8. [Proof of Skill — Vérification Finale de Compétence](#8-proof-of-skill)
9. [Implémentation Rust — Structures Clés](#9-implémentation-rust)
10. [Schéma Base de Données Évolué](#10-schéma-base-de-données-évolué)
11. [Communication Temps-Réel & UX Agentique](#11-communication-temps-réel--ux-agentique)
12. [Métriques & Observabilité](#12-métriques--observabilité)

---

## 1. Vision Système

### 1.0 L'Écosystème Unifié de Sûreté & d'Orchestration (Mastra, Composio, Graphiti, Langfuse)

Pour que la pipeline à **13 agents autonomes d'ASCENT** fonctionne comme un organisme vivant cohérent et sans faille, SCY Forge unifie ses briques open-source d'élite au sein d'une **architecture de raccordement sémantique unique (Unified Agentic Pipeline)** :

```
[Onboarding Request] ──► [Mastra Workflows Engine (Northflank)] ──► [Langfuse Trace (0$)]
                                    │
         ┌──────────────────────────┼──────────────────────────┐
         ▼                          ▼                          ▼
 [Composio Ingestion]        [Graphiti Temporal]       [Zod Schema Guard]
 (Drive/Notion APIs - 0$)   (Postgres/Zilliz - 0$)     (Auto-Retries - 0$)
```

1. **L'Orchestrateur Durable (Mastra Workflows — TS/Node)** : Tous nos agents (de `AGENT-01` à `AGENT-13`) et leurs transitions d'états d'apprentissage sont structurés sous la forme de **graphes de machines à états durables (Workflows)** à l'aide de Mastra.
2. **L'Enforcement Mécanique (Harmonist - MIT)** : Chaque transition de step dans la pipeline Mastra est interceptée par des crochets logiciels (hooks). Si le `VISUAL-CRITIC (AGENT-12)` n'a pas validé l'intégrité du graphe, la transaction est rejetée de manière mécanique, empêchant tout affichage d'hallucination à l'utilisateur.
3. **L'Ingestion Universelle (Composio SDK - 0$)** : `AGENT-02` (CONTENT-SCOUT) n'écrit plus de code d'APIs tierces. Il s'appuie sur le SDK de Composio pour connecter Google Drive, Notion et Slack en 1 ligne de code avec gestion d'OAuth automatique hébergée sur nos serveurs.
4. **La Mémoire Temporelle (Graphiti / Zep - 0$)** : Le `PERFORMANCE-ANALYZER` (`AGENT-05`) pousse chaque événement en base Graphiti raccordée à **Northflank PostgreSQL** pour suivre l'évolution chronologique du modèle mental de l'utilisateur, ajustant dynamiquement le FSRS d'APEX.
5. **La Sûreté de Schémas (Zod-Mastra Validation - 0$)** : Les sorties de `AGENT-12` et `AGENT-13` sont définies comme des schémas Zod stricts. Si l'IA produit une erreur de format, Mastra intercepte l'erreur en local et effectue un auto-retry ciblé immédiat.
6. **L'Observabilité Globale (Langfuse - 0$)** : Déployé sous forme de conteneur Docker léger à ressources isolées connecté à Northflank, il trace, indexe et logue chaque appel de jeton, de latence et de coût de nos 13 agents sur un cockpit de pilotage en direct.

---

### 1.1 Le Changement de Paradigme

Aujourd'hui, SCY Forge est une **collection de features excellentes** (Ingestion, NEURON-CHAINS, COSMOS, APEX, ASCENT, BRAIN, IMPRINT) — chacune étant forte individuellement, mais fonctionnant de façon relativement isolée, pilotée par l'utilisateur.

La vision est radicalement différente : **SCY Forge devient un organisme vivant** dont le seul but est de faire atteindre la compétence à l'utilisateur, en orchestrant automatiquement toutes ses features comme des organes au service d'un cerveau central.

```
AVANT (actuel)              APRÈS (autonome)
─────────────────           ─────────────────────────────────────
User → [Ingestion]          User : "Je veux maîtriser React"
User → [ASCENT]                        ↓
User → [APEX]               ASCENT-ORCHESTRATOR (cerveau)
User → [BRAIN]                         ↓
User → [COSMOS]              ┌─────────────────────────────┐
                            │  Pilote automatiquement :   │
(Chaque feature est         │  • Ingestion (11 cores)     │
 un silo que l'user         │  • NEURON-CHAINS (docs)     │
 doit activer lui-même)     │  • APEX (révisions FSRS)    │
                            │  • BRAIN (Q&A assistant)    │
                            │  • COSMOS (visualisation)    │
                            │  • IMPRINT (mémorisation)   │
                            │  • Gamification             │
                            │  • Drift Detection          │
                            └─────────────────────────────┘
                                         ↓
                            User atteint la compétence ✅
                            SMI ≥ 70 sur tous les nœuds
                            Proof of Skill généré
```

### 1.2 Principe Fondamental

**L'utilisateur ne devrait jamais avoir à réfléchir à "quelle feature utiliser maintenant".**

L'ASCENT-ORCHESTRATOR sait à chaque instant :
- Où en est l'utilisateur dans son parcours (nœud DAG actuel)
- Quel est son état cognitif (FSRS stability, SMI, sessions récentes)
- Quelle action a le plus d'impact sur sa progression
- Quand intervenir, comment, avec quel outil

### 1.3 Ce que SCY Forge Orchestre Automatiquement

| Feature | Rôle dans l'autonomie |
|---------|----------------------|
| **Ingestion (11 cores)** | L'agent trouve et ingère le contenu parfait pour chaque nœud |
| **NEURON-CHAINS (24 agents)** | L'agent génère les documents d'apprentissage adaptés au niveau |
| **APEX/FSRS** | L'agent planifie les révisions au bon moment, ni trop tôt ni trop tard |
| **BRAIN/RAG** | L'agent répond aux questions de l'utilisateur en temps réel |
| **COSMOS (8 modes)** | L'agent guide la visualisation des concepts maîtrisés/à maîtriser |
| **IMPRINT** | L'agent déclenche les sessions de mémorisation profonde aux moments clés |
| **Drift Detector** | L'agent intervient avant que l'utilisateur abandonne |
| **Proof of Skill** | L'agent certifie la compétence de façon multi-dimensionnelle |
| **Notifications** | L'agent maintient l'engagement avec le bon message au bon moment |

---

## 2. Vue d'Ensemble

### 2.1 Architecture Globale de la Pipeline Agentique

```
╔═══════════════════════════════════════════════════════════════════════════════╗
║              SCY FORGE — ASCENT AUTONOMOUS PIPELINE v1                        ║
║         "Une seule entrée, un seul objectif : la compétence"                  ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║                                                                               ║
║  INPUT UTILISATEUR                                                            ║
║  ┌─────────────────────────────────────────────────────────────────────────┐  ║
║  │  "Je veux devenir développeur Full-Stack React/Rust en 3 mois"         │  ║
║  │  [ou] Template prédéfini sélectionné                                   │  ║
║  │  [ou] Import roadmap existante                                         │  ║
║  └───────────────────────────────┬─────────────────────────────────────────┘  ║
║                                  │                                            ║
║  ┌───────────────────────────────▼─────────────────────────────────────────┐  ║
║  │              AGENT-01 : GOAL-INTERPRETER                                │  ║
║  │  • Parse l'objectif en langage naturel                                  │  ║
║  │  • Évalue faisabilité (Scope Classifier : 3-200h)                      │  ║
║  │  • Construit le profil utilisateur (niveau, temps dispo, style)        │  ║
║  │  • OUTPUT → Profil structuré + Objectif formalisé                      │  ║
║  └───────────────────────────────┬─────────────────────────────────────────┘  ║
║                                  │                                            ║
║  ┌───────────────────────────────▼─────────────────────────────────────────┐  ║
║  │              AGENT-02 : CONTENT-SCOUT                                   │  ║
║  │  • Interroge les 11 cores d'ingestion pour trouver le meilleur contenu  │  ║
║  │  • Priorise les sources par qualité, fraîcheur, pertinence              │  ║
║  │  • Ingestion automatique des sources GOLD identifiées                  │  ║
║  │  • OUTPUT → Sources ingérées + JSON Cognitif 360°                      │  ║
║  └───────────────────────────────┬─────────────────────────────────────────┘  ║
║                                  │                                            ║
║  ┌───────────────────────────────▼─────────────────────────────────────────┐  ║
║  │              AGENT-03 : DAG-ARCHITECT                                   │  ║
║  │  • Génère le DAG de compétences (SINKT + validation 4 passes)          │  ║
║  │  • Auto-positionne l'utilisateur dans le DAG (niveau existant)         │  ║
║  │  • Commande NEURON-CHAINS pour générer les docs de chaque nœud         │  ║
║  │  • OUTPUT → DAG validé + Documents générés par nœud                    │  ║
║  └───────────────────────────────┬─────────────────────────────────────────┘  ║
║                                  │                                            ║
║  ┌───────────────────────────────▼─────────────────────────────────────────┐  ║
║  │              AGENT-04 : LEARNING-CONDUCTOR ← CERVEAU PRINCIPAL          │  ║
║  │                                                                         │  ║
║  │  Orchestre en temps réel la progression nœud par nœud :                │  ║
║  │                                                                         │  ║
║  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │  ║
║  │  │  APEX/FSRS  │  │  BRAIN/RAG  │  │   COSMOS     │  │   IMPRINT   │  │  ║
║  │  │  Révisions  │  │  Assistant  │  │  Graphe KG  │  │  Mémorisa.  │  │  ║
║  │  │  spacées    │  │  contextuel │  │  temps réel │  │  profonde   │  │  ║
║  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘  │  ║
║  │                                                                         │  ║
║  │  Décisions automatiques à chaque interaction :                         │  ║
║  │  • Quelle carte réviser maintenant ? (FSRS scheduling)                 │  ║
║  │  • Quel exercice proposer ? (niveau adapté)                            │  ║
║  │  • Quel document générer pour ce nœud ? (NEURON-CHAINS)               │  ║
║  │  • Quand déclencher IMPRINT ? (après 3 bonnes réponses)               │  ║
║  │  • Mettre à jour COSMOS KG ? (après chaque concept maîtrisé)           │  ║
║  └───────────────────────────────┬─────────────────────────────────────────┘  ║
║                                  │                                            ║
║  ┌───────────────────────────────▼─────────────────────────────────────────┐  ║
║  │              AGENT-05 : PERFORMANCE-ANALYZER                            │  ║
║  │  • Calcule SMI en continu (5 dimensions)                                │  ║
║  │  • Analyse patterns de performance (HiTSKT sessions)                   │  ║
║  │  • Détecte les signaux de drift (8 signaux)                            │  ║
║  │  • OUTPUT → Score SMI actuel + Décision progression                    │  ║
║  └───────────────────────────────┬─────────────────────────────────────────┘  ║
║                                  │                                            ║
║  ┌───────────────────────────────▼─────────────────────────────────────────┐  ║
║  │              AGENT-06 : ADAPTIVE-ROUTER                                 │  ║
║  │  • SMI > 85% → Fast-track (skip nœuds, accélérer)                     │  ║
║  │  • SMI 70-85% → Progression normale (nœud suivant)                    │  ║
║  │  • SMI 60-70% → Consolidation (plus d'exercices, plus de révisions)   │  ║
║  │  • SMI < 60% → Remédiation (contenu alternatif + APEX intensif)       │  ║
║  │  • Plateau → Changement stratégie pédagogique                         │  ║
║  └───────────────────────────────┬─────────────────────────────────────────┘  ║
║                                  │                                            ║
║  ┌───────────────────────────────▼─────────────────────────────────────────┐  ║
║  │              AGENT-07 : DRIFT-GUARDIAN                                  │  ║
║  │  • Surveillance continue 24/7 (background daemon)                      │  ║
║  │  • 8 signaux d'alerte (inactivité, échecs, déclin SMI, skips...)       │  ║
║  │  • Interventions proactives (notification, email, message in-app)      │  ║
║  │  • Réactivation personnalisée selon profil utilisateur                 │  ║
║  └───────────────────────────────┬─────────────────────────────────────────┘  ║
║                                  │                                            ║
║  ┌───────────────────────────────▼─────────────────────────────────────────┐  ║
║  │              AGENT-08 : ENGAGEMENT-AMPLIFIER                            │  ║
║  │  • Gamification intelligente (XP, badges, streaks, niveaux)            │  ║
║  │  • Notifications push au bon moment (FSRS predictions)                 │  ║
║  │  • Célébration des milestones (confetti, badges, partage social)       │  ║
║  │  • Rapport hebdomadaire automatique (progression, prédiction ETA)      │  ║
║  └───────────────────────────────┬─────────────────────────────────────────┘  ║
║                                  │                                            ║
║  ┌───────────────────────────────▼─────────────────────────────────────────┐  ║
║  │              AGENT-09 : SKILL-CERTIFIER                                 │  ║
║  │  • Détecte automatiquement quand tous les nœuds sont complétés         │  ║
║  │  • Déclenche l'évaluation finale (Proof of Skill)                      │  ║
║  │  • Calcule le SMI global multi-dimensionnel                            │  ║
║  │  • Génère le certificat de compétence exportable (PDF Typst)           │  ║
║  │  • Suggère les objectifs d'approfondissement suivants                  │  ║
║  └───────────────────────────────┬─────────────────────────────────────────┘  ║
║                                  │                                            ║
║  OUTPUT FINAL                    ▼                                            ║
║  ┌─────────────────────────────────────────────────────────────────────────┐  ║
║  │  ✅ COMPÉTENCE ATTEINTE                                                 │  ║
║  │  📊 SMI Global: 87/100 — React/Rust Full-Stack Developer               │  ║
║  │  🏆 Proof of Skill Certificate (PDF exportable)                        │  ║
║  │  📈 Timeline: 94 jours (prévu: 90 jours)                              │  ║
║  │  🔗 LinkedIn / CV exportable                                           │  ║
║  │  🎯 Suggestions : "Node.js Backend", "Cloud AWS", "DevOps"             │  ║
║  └─────────────────────────────────────────────────────────────────────────┘  ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```

---

## 3. Les 13 Agents Autonomes ASCENT

### AGENT-01 : GOAL-INTERPRETER 🎯
**Mission** : Transformer un objectif en langage naturel en un plan d'apprentissage formalisé.

```rust
pub struct GoalInterpreterAgent {
    llm: Arc<LlmRouter>,
    scope_classifier: ScopeClassifier,
    profile_builder: UserProfileBuilder,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LearningGoal {
    pub raw_intent: String,                  // "Je veux maîtriser React"
    pub formalized_title: String,            // "React Developer — Niveau Intermédiaire"
    pub domain: LearningDomain,              // Tech, Business, Academic, Spiritual...
    pub estimated_hours: f32,               // 80h
    pub weekly_availability_hours: f32,     // 10h/semaine
    pub target_completion_weeks: u16,       // 8 semaines
    pub current_level: SkillLevel,          // Débutant / Intermédiaire / Avancé
    pub prerequisites_met: Vec<String>,     // ["JavaScript", "HTML/CSS"]
    pub prerequisites_missing: Vec<String>, // ["Node.js basics"]
    pub learning_style: LearningStyle,      // Visual / Hands-on / Reading / Mixed
    pub priority_type: PriorityType,        // Professionnel / Personnel / Académique
}

impl GoalInterpreterAgent {
    pub async fn interpret(&self, raw_goal: &str, user_id: &Uuid) -> Result<LearningGoal> {
        // 1. Analyser l'intention avec LLM (DeepSeek Reasoning pour cette tâche)
        let intent_analysis = self.llm.complete_reasoning(
            &self.build_interpretation_prompt(raw_goal),
            TaskType::Reasoning,
        ).await?;
        
        // 2. Classifier la portée (3-200h) — LE SERMENT DE RIGUEUR ET DE TRANSPARENCE COGNITIVE
        // SCY Forge refuse de mentir à l'utilisateur en lui promettant une maîtrise d'expert en 3 mois.
        // Si l'objectif est trop massif (ex: "Devenir Data Scientist", qui requiert un cursus académique de 3 ans),
        // l'agent refuse l'instanciation linéaire globale et renvoie une décomposition en Micro-Certifications / Micro-Goals précis.
        let scope = self.scope_classifier.estimate(&intent_analysis)?;
        if scope.hours > 150.0 {
            return Err(AgentError::GoalTooLarge { 
                suggested_splits: self.suggest_goal_splits(raw_goal).await?,
                explanation: "Un parcours d'expert digne de ce nom ne se bâcle pas en quelques semaines. SCY Forge décompose votre grand objectif en plusieurs jalons de compétences ciblés et transparents pour vous garantir une véritable maîtrise.".to_string(),
            });
        }
        
        // 3. Construire le profil utilisateur (questionnaire adaptatif)
        let profile = self.profile_builder.build_from_history(user_id).await?;
        
        // 4. Vérifier prérequis via COSMOS Knowledge Graph
        let kg_prerequisites = self.check_kg_prerequisites(&intent_analysis, user_id).await?;
        
        Ok(LearningGoal {
            raw_intent: raw_goal.to_string(),
            formalized_title: intent_analysis.title,
            domain: intent_analysis.domain,
            estimated_hours: scope.hours,
            weekly_availability_hours: profile.weekly_hours,
            target_completion_weeks: (scope.hours / profile.weekly_hours).ceil() as u16,
            current_level: profile.skill_level,
            prerequisites_met: kg_prerequisites.met,
            prerequisites_missing: kg_prerequisites.missing,
            learning_style: profile.learning_style,
            priority_type: intent_analysis.priority_type,
        })
    }
}
```

**Interactions avec les autres features :**
- → **COSMOS Knowledge Graph** : Vérifier quels concepts l'utilisateur maîtrise déjà (SMI existant)
- → **BRAIN/RAG** : Rechercher dans la base de connaissances existante de l'user les prérequis
- → **APEX/FSRS** : Récupérer l'historique de révisions pour estimer le niveau réel

---

### AGENT-02 : CONTENT-SCOUT 🔍
**Mission** : Trouver et ingérer automatiquement le meilleur contenu disponible pour le parcours.

```rust
pub struct ContentScoutAgent {
    ingestion_orchestrator: Arc<IngestionOrchestrator>, // 11 cores
    source_ranker: SourceRanker,
    cache: Arc<SemanticCache>,
}

#[derive(Debug, Clone)]
pub struct ContentScouting {
    pub goal: LearningGoal,
    pub sources_found: Vec<RankedSource>,
    pub sources_ingested: Vec<IngestedSource>,
    pub coverage_by_node: HashMap<String, f32>, // node_id → % coverage
    pub gaps_detected: Vec<ContentGap>,         // Nœuds sans contenu suffisant
}

impl ContentScoutAgent {
    pub async fn scout_and_ingest(&self, goal: &LearningGoal) -> Result<ContentScouting> {
        // 1. Générer les requêtes de recherche par sous-domaine
        let search_queries = self.generate_search_queries(goal).await?;
        
        // 2. Interroger les 11 cores en parallèle
        let source_candidates = tokio::join!(
            self.ingestion_orchestrator.search_youtube(&search_queries),
            self.ingestion_orchestrator.search_web(&search_queries),
            self.ingestion_orchestrator.search_academic(&search_queries),
            self.ingestion_orchestrator.search_drive(goal.user_id),
            // ... 7 autres cores
        );
        
        // 3. Classer les sources (qualité × fraîcheur × pertinence)
        let ranked = self.source_ranker.rank_all(source_candidates.flatten().collect()).await?;
        
        // 4. Sélectionner le top 25 sources (optimisation budget tokens)
        let top_sources = ranked.into_iter().take(25).collect::<Vec<_>>();
        
        // 5. Ingérer en parallèle (avec cache sémantique — évite doublons)
        let ingested = stream::iter(top_sources)
            .map(|source| self.ingest_source_with_cache(source))
            .buffer_unordered(5) // 5 ingestions simultanées max
            .collect::<Vec<_>>()
            .await;
        
        // 6. Calculer la couverture par nœud du DAG
        let coverage = self.calculate_dag_coverage(&ingested, &goal.dag_template).await?;
        
        // 7. Identifier les gaps (nœuds mal couverts < 60%)
        let gaps = coverage.iter()
            .filter(|(_, cov)| *cov < 0.6)
            .map(|(node_id, _)| ContentGap { node_id: node_id.clone(), severity: "low_coverage" })
            .collect();
        
        Ok(ContentScouting {
            goal: goal.clone(),
            sources_found: ranked,
            sources_ingested: ingested.into_iter().flatten().collect(),
            coverage_by_node: coverage,
            gaps_detected: gaps,
        })
    }
    
    // Stratégie de recherche intelligente par domaine
    fn generate_search_queries(&self, goal: &LearningGoal) -> Vec<SearchQuery> {
        let base_queries = vec![
            SearchQuery::youtube(format!("{} tutorial beginner", goal.formalized_title)),
            SearchQuery::youtube(format!("{} course complete", goal.formalized_title)),
            SearchQuery::web(format!("{} guide 2026", goal.formalized_title)),
            SearchQuery::academic(format!("{} fundamentals", goal.domain.to_str())),
        ];
        
        // Requêtes spécifiques par nœud du DAG (si disponible)
        // Seront générées après AGENT-03
        base_queries
    }
}
```

**Interactions avec les autres features :**
- → **11 Ingestion Cores** : YouTube, Web, Academic, Drive, Podcast, Reddit, etc.
- → **MapReduce L0-L4** : Processing automatique de chaque source ingérée
- → **NEURON-CHAINS** : Déclenchement de la génération documentaire post-ingestion
- → **COSMOS** : Mise à jour du Knowledge Graph avec les nouveaux concepts extraits
- → **SemanticCache (LanceDB)** : Évite de ré-ingérer du contenu déjà présent

---

### AGENT-03 : DAG-ARCHITECT 🏗️
**Mission** : Construire le graphe de compétences et générer tous les contenus pédagogiques associés.

```rust
pub struct DagArchitectAgent {
    dag_generator: DagGenerator,
    sinkt_positioner: SinktPositioner,  // PAPER-009
    neuron_chains: Arc<NeuronChainOrchestrator>,
    validator: DagValidator,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CompetenceDAG {
    pub goal_id: Uuid,
    pub nodes: Vec<SkillNode>,
    pub edges: Vec<DependencyEdge>,
    pub critical_path: Vec<Uuid>,           // Chemin critique (plus long)
    pub estimated_total_hours: f32,
    pub user_entry_point: Uuid,             // Nœud de départ (SINKT)
    pub validation_passes: DagValidation,   // 4 passes: cycles, deps, coverage, cohérence
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SkillNode {
    pub id: Uuid,
    pub name: String,                       // "React Hooks — useEffect"
    pub description: String,
    pub complexity: u8,                     // 1-5
    pub estimated_hours: f32,
    pub status: NodeStatus,                 // locked/available/in_progress/completed/skipped
    pub smi_required: f32,                  // Seuil pour avancer (default: 70.0)
    pub smi_achieved: f32,                  // Score actuel utilisateur
    
    // Contenu généré par NEURON-CHAINS
    pub documents: Vec<NodeDocument>,       // Cours, résumés, guides générés
    pub flashcards: Vec<Uuid>,             // Cards APEX associées
    pub exercises: Vec<NodeExercise>,       // Exercices Gold Template
    pub brain_context: Vec<Uuid>,          // Chunks RAG pertinents pour ce nœud
    
    // Métadonnées pédagogiques
    pub learning_objectives: Vec<String>,  // Objectifs SMART
    pub bloom_level: BloomLevel,           // Remember/Understand/Apply/Analyze/Evaluate/Create
    pub key_concepts: Vec<String>,         // Concepts clés à maîtriser
}

impl DagArchitectAgent {
    pub async fn build_full_dag(&self, goal: &LearningGoal, scouting: &ContentScouting) -> Result<CompetenceDAG> {
        
        // PHASE 1: Génération du DAG brut
        let raw_dag = self.dag_generator.generate(
            &goal.formalized_title,
            &goal.domain,
            &scouting.sources_ingested,
            goal.current_level,
        ).await?;
        
        // PHASE 2: Validation en 4 passes
        let validated_dag = self.validator.validate_four_passes(&raw_dag)?;
        // Pass 1: Détection cycles (petgraph)
        // Pass 2: Validation dépendances (tous les prérequis sont dans le DAG)
        // Pass 3: Coverage (chaque nœud a du contenu suffisant)
        // Pass 4: Cohérence pédagogique (progression logique Bloom)
        
        // PHASE 3: Auto-positionnement SINKT (PAPER-009)
        let entry_point = self.sinkt_positioner
            .position_user(&goal.user_id, &validated_dag, &goal.prerequisites_met)
            .await?;
        
        // PHASE 4: Génération des contenus pour CHAQUE nœud (NEURON-CHAINS en parallèle)
        let enriched_nodes = stream::iter(&validated_dag.nodes)
            .map(|node| self.generate_node_content(node, scouting))
            .buffer_unordered(3) // 3 NEURON-CHAINS en parallèle
            .collect::<Vec<_>>()
            .await;
        
        // PHASE 5: Création des cartes APEX pour chaque concept clé
        for node in &enriched_nodes {
            self.create_apex_cards_for_node(node, &goal.user_id).await?;
        }
        
        // PHASE 6: Indexation dans COSMOS Knowledge Graph
        self.update_cosmos_graph(&enriched_nodes, &goal.user_id).await?;
        
        Ok(CompetenceDAG {
            goal_id: goal.id,
            nodes: enriched_nodes,
            edges: validated_dag.edges,
            critical_path: validated_dag.critical_path,
            estimated_total_hours: validated_dag.total_hours,
            user_entry_point: entry_point,
            validation_passes: validated_dag.validation,
        })
    }
    
    /// Génère tout le contenu d'un nœud via NEURON-CHAINS
    async fn generate_node_content(&self, node: &SkillNode, scouting: &ContentScouting) -> Result<SkillNode> {
        let relevant_sources = scouting.get_sources_for_node(&node.id);
        
        // Sélectionner la chaîne NEURON-CHAIN appropriée selon le domaine
        let chain = match node.bloom_level {
            BloomLevel::Remember | BloomLevel::Understand => NeuronChain::Alpha,  // Résumés/synthèses
            BloomLevel::Apply => NeuronChain::Gamma,           // Guides pratiques
            BloomLevel::Analyze => NeuronChain::Eta,           // Documents analytiques
            BloomLevel::Evaluate | BloomLevel::Create => NeuronChain::Zeta, // Haute complexité
        };
        
        // Générer les documents (cours magistral + résumé + guide pratique)
        let documents = self.neuron_chains.generate_node_bundle(
            node,
            &relevant_sources,
            chain,
            NodeDocBundle {
                summary: true,           // A01 - Résumé du nœud
                full_course: node.estimated_hours > 2.0, // A06 si nœud long
                practical_guide: node.bloom_level >= BloomLevel::Apply,
                exercises: true,         // C01-C04 selon difficulté
            },
        ).await?;
        
        // Générer les exercices Gold Template (6 sections)
        let exercises = self.generate_gold_exercises(node, &relevant_sources).await?;
        
        // Créer les chunks RAG pour BRAIN
        let brain_chunks = self.index_node_for_brain(node, &documents).await?;
        
        Ok(SkillNode {
            documents,
            exercises,
            brain_context: brain_chunks,
            flashcards: vec![], // Créées séparément par APEX
            ..node.clone()
        })
    }
}
```

**Interactions avec les autres features :**
- → **NEURON-CHAINS (7 chaînes, 24 agents)** : Génération de tous les contenus par nœud
- → **APEX/FSRS** : Création des flashcards pour chaque concept clé
- → **BRAIN/RAG** : Indexation des chunks pour le Q&A contextuel
- → **COSMOS** : Population du Knowledge Graph avec concepts + relations
- → **petgraph** : Validation DAG (cycles, dépendances)
- → **SINKT** : Auto-positionnement utilisateur dans le DAG

---

### AGENT-04 : LEARNING-CONDUCTOR 🎼
**Mission** : Orchestrer en temps réel la progression de l'utilisateur, nœud par nœud.

C'est le **cerveau principal** — il tourne en permanence et décide de chaque action.

```rust
pub struct LearningConductorAgent {
    apex_scheduler: Arc<ApexFsrsScheduler>,
    brain_assistant: Arc<BrainRagEngine>,
    cosmos_manager: Arc<CosmosManager>,
    imprint_engine: Arc<ImprintEngine>,
    neuron_chains: Arc<NeuronChainOrchestrator>,
    event_bus: Arc<EventBus>,
}

/// État courant de l'utilisateur dans son parcours
#[derive(Debug, Clone)]
pub struct LearnerState {
    pub user_id: Uuid,
    pub goal_id: Uuid,
    pub current_node: SkillNode,
    pub dag_position: DagPosition,
    pub session_type: SessionType,          // Morning / Evening / Weekend / Micro
    pub available_minutes: u16,             // Minutes disponibles (détectées ou saisies)
    pub cognitive_load: CognitiveLoad,      // Fresh / Moderate / Fatigued
    pub fsrs_due_cards: Vec<Uuid>,          // Cartes dues maintenant
    pub recent_performance: PerformanceWindow, // 7 derniers jours
}

#[derive(Debug, Clone)]
pub enum LearnerAction {
    // Actions d'apprentissage
    StartExercise { exercise_id: Uuid, node_id: Uuid },
    ReviewFlashcard { card_id: Uuid },
    ReadDocument { doc_id: Uuid, section: Option<String> },
    AskBrain { query: String },
    DoImprint { concept: String },
    
    // Actions de progression
    NodeCompleted { node_id: Uuid, smi_achieved: f32 },
    NodeSkipped { node_id: Uuid, reason: SkipReason },
    RequestRemediation { node_id: Uuid },
    
    // Actions de visualisation
    ViewKnowledgeGraph { filter: Option<String> },
    ViewRoadmap,
    ViewStats,
}

impl LearningConductorAgent {
    /// Point d'entrée principal — appelé à chaque interaction utilisateur
    pub async fn conduct_session(
        &self, 
        state: &LearnerState,
    ) -> Result<ConductorDecision> {
        
        // 1. Analyser l'état et décider la meilleure action
        let decision = self.decide_next_action(state).await?;
        
        // 2. Exécuter la décision (orchestrer les features)
        self.execute_decision(&decision, state).await?;
        
        // 3. Mettre à jour COSMOS en temps réel
        self.sync_cosmos_state(state).await?;
        
        Ok(decision)
    }
    
    /// Algorithme de décision — cœur du conductor
    async fn decide_next_action(&self, state: &LearnerState) -> Result<ConductorDecision> {
        
        // PRIORITÉ 1: Y a-t-il des cartes FSRS dues et critiques ?
        if !state.fsrs_due_cards.is_empty() && state.available_minutes >= 5 {
            let critical_cards = self.apex_scheduler
                .get_overdue_cards(&state.user_id, max: 10)
                .await?;
            if !critical_cards.is_empty() {
                return Ok(ConductorDecision::StartApexRevision { 
                    cards: critical_cards,
                    reason: "Révisions FSRS en retard — rétention menacée",
                    estimated_minutes: critical_cards.len() as u16 * 2,
                });
            }
        }
        
        // PRIORITÉ 2: L'utilisateur est-il prêt pour le nœud suivant ?
        if state.current_node.smi_achieved >= state.current_node.smi_required {
            let next_node = self.get_next_available_node(state).await?;
            if let Some(node) = next_node {
                return Ok(ConductorDecision::UnlockNextNode {
                    completed_node_id: state.current_node.id,
                    next_node,
                    celebration: self.build_celebration(&state.current_node),
                });
            }
        }
        
        // PRIORITÉ 3: Quel type de session selon le temps disponible ?
        match state.available_minutes {
            0..=10 => {
                // Micro-session → 1-2 flashcards APEX
                Ok(ConductorDecision::MicroSession {
                    action: self.select_micro_action(state).await?,
                    reason: "Session courte — révision rapide",
                })
            }
            11..=30 => {
                // Session normale → exercice + révisions
                Ok(ConductorDecision::StandardSession {
                    exercise: self.select_best_exercise(state).await?,
                    cards: self.apex_scheduler.get_due_cards(&state.user_id, max: 10).await?,
                    reason: "Session standard",
                })
            }
            31..=60 => {
                // Session longue → nouveau contenu + exercices + révisions
                Ok(ConductorDecision::DeepSession {
                    document: self.select_next_document(state).await?,
                    exercises: self.select_exercise_sequence(state).await?,
                    cards: self.apex_scheduler.get_due_cards(&state.user_id, max: 20).await?,
                    imprint_trigger: self.should_trigger_imprint(state),
                    reason: "Session complète",
                })
            }
            _ => {
                // Marathon → session complète avec IMPRINT et KG exploration
                Ok(ConductorDecision::MarathonSession {
                    full_node_plan: self.build_full_node_plan(state).await?,
                    reason: "Longue session — apprentissage complet du nœud",
                })
            }
        }
    }
    
    /// Décider si IMPRINT doit être déclenché
    fn should_trigger_imprint(&self, state: &LearnerState) -> Option<ImprintTrigger> {
        // IMPRINT déclenché après :
        // 1. 3 exercices réussis consécutifs sur un concept
        // 2. SMI d'un concept > 75% pour la première fois
        // 3. Fin d'un nœud complexe (complexity >= 4)
        if state.current_node.complexity >= 4 
            && state.recent_performance.consecutive_successes >= 3 {
            Some(ImprintTrigger {
                concept: state.current_node.name.clone(),
                cran_level: self.select_imprint_level(state),
                reason: "Nœud complexe + bonnes performances = moment idéal pour IMPRINT",
            })
        } else {
            None
        }
    }
    
    /// Synchroniser COSMOS après chaque progression
    async fn sync_cosmos_state(&self, state: &LearnerState) -> Result<()> {
        // Mettre à jour les scores SMI dans le Knowledge Graph
        self.cosmos_manager.update_node_smi(
            &state.user_id,
            &state.current_node.id,
            state.current_node.smi_achieved,
        ).await?;
        
        // Changer la couleur du nœud dans la roadmap COSMOS
        let node_color = match state.current_node.smi_achieved as u8 {
            0..=39   => NodeColor::Red,      // Non maîtrisé
            40..=69  => NodeColor::Yellow,   // En cours
            70..=84  => NodeColor::Green,    // Maîtrisé
            85..=100 => NodeColor::Gold,     // Expert
            _        => NodeColor::Gray,
        };
        
        self.cosmos_manager.update_node_color(
            &state.user_id,
            &state.current_node.id,
            node_color,
        ).await?;
        
        // Mettre à jour les relations dans le KG (nouvelles connexions détectées)
        self.cosmos_manager.auto_graph_update(&state.user_id).await?;
        
        Ok(())
    }
}
```

**Interactions avec les autres features :**
- → **APEX/FSRS** : Scheduling des révisions, sélection des cartes à réviser
- → **BRAIN/RAG** : Déclenchement de l'assistant contextuel pendant l'apprentissage
- → **COSMOS** : Mise à jour du Knowledge Graph en temps réel
- → **IMPRINT** : Déclenchement des sessions de mémorisation profonde
- → **NEURON-CHAINS** : Génération de contenu supplémentaire si besoin
- → **EventBus** : Notification des autres agents des changements d'état

---

### AGENT-05 : PERFORMANCE-ANALYZER 📊
**Mission** : Calculer et surveiller le SMI (Score de Maîtrise Intégrée) en continu.

```rust
pub struct PerformanceAnalyzerAgent {
    smi_calculator: SmiCalculator,
    hitskt_analyzer: HiTSKTAnalyzer,  // PAPER-008
    aakt_processor: AAKTProcessor,     // PAPER-029
}

/// SMI — 5 dimensions (0-100 chacune, pondération finale)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SmiScore {
    pub node_id: Uuid,
    pub user_id: Uuid,
    pub timestamp: i64,
    
    // 5 dimensions
    pub retention: f32,        // FSRS stability + recall rate (35% du SMI)
    pub depth: f32,            // Capacité à expliquer + exercices avancés (25%)
    pub mirror: f32,           // Enseignement à d'autres (Feynman Technique) (20%)
    pub metacognition: f32,    // Calibration de sa propre connaissance (10%)
    pub consistency: f32,      // Régularité des révisions sur le temps (10%)
    
    // Score global pondéré
    pub global: f32,           // SMI /100
    pub trend: SmiTrend,       // Improving / Stable / Declining
    pub confidence_interval: (f32, f32), // [67, 85] = "probablement entre 67 et 85"
}

impl PerformanceAnalyzerAgent {
    pub async fn analyze_full(&self, user_id: &Uuid, node_id: &Uuid) -> Result<SmiScore> {
        // Dimension 1: RETENTION (35%)
        // Source: historique FSRS — stability, recall, lapses
        let retention = self.calculate_retention(user_id, node_id).await?;
        
        // Dimension 2: DEPTH (25%)
        // Source: scores exercices avancés (complexity 3-5), qualité réponses
        let depth = self.calculate_depth(user_id, node_id).await?;
        
        // Dimension 3: MIRROR (20%)
        // Source: résultats "Teaching cards" (carte type B07)
        // L'user doit expliquer le concept comme s'il l'enseignait
        let mirror = self.calculate_mirror_score(user_id, node_id).await?;
        
        // Dimension 4: METACOGNITION (10%)
        // Source: D-006 Calibration Métacognitive
        // Comparaison confiance déclarée vs performance réelle
        let metacognition = self.calculate_metacognition(user_id, node_id).await?;
        
        // Dimension 5: CONSISTENCY (10%)
        // Source: Timeline COSMOS — régularité des sessions
        let consistency = self.calculate_consistency(user_id, node_id).await?;
        
        let global = retention * 0.35 + depth * 0.25 + mirror * 0.20 
                    + metacognition * 0.10 + consistency * 0.10;
        
        // HiTSKT — Analyse des patterns de session (PAPER-008)
        let session_patterns = self.hitskt_analyzer.analyze_sessions(user_id, node_id).await?;
        let trend = self.calculate_trend(&session_patterns);
        
        Ok(SmiScore {
            node_id: *node_id,
            user_id: *user_id,
            timestamp: Utc::now().timestamp(),
            retention,
            depth,
            mirror,
            metacognition,
            consistency,
            global,
            trend,
            confidence_interval: self.estimate_confidence_interval(global, &session_patterns),
        })
    }
}
```

---

### AGENT-06 : ADAPTIVE-ROUTER ⚡
**Mission** : Décider de la trajectoire optimale dans le DAG en fonction du SMI.

```rust
pub struct AdaptiveRouterAgent {
    dag_repository: Arc<dyn DagRepository>,
    remediation_engine: RemediationEngine,
}

#[derive(Debug, Clone)]
pub enum RoutingDecision {
    // Avancement rapide
    FastTrack {
        skip_nodes: Vec<Uuid>,
        reason: String,
        time_saved_hours: f32,
    },
    // Progression normale
    NormalProgression {
        next_node: Uuid,
        estimated_hours: f32,
    },
    // Consolidation (SMI entre 60-70%)
    Consolidation {
        current_node: Uuid,
        additional_exercises: Vec<Uuid>,
        additional_cards: Vec<Uuid>,
        target_smi: f32,
    },
    // Remédiation (SMI < 60%)
    Remediation {
        current_node: Uuid,
        remediation_type: RemediationType,
        new_content: Option<Uuid>,
    },
    // Changement de stratégie (plateau)
    StrategyChange {
        current_node: Uuid,
        old_strategy: LearningStrategy,
        new_strategy: LearningStrategy,
        reason: String,
    },
}

#[derive(Debug, Clone)]
pub enum RemediationType {
    ApexIntensive,          // Plus de révisions FSRS
    AlternativeContent,     // Nouvelle source pour le même nœud
    AlternativeExercise,    // Exercice différent, même concept
    VideoTutorial,          // Rechercher vidéo explicative (Content-Scout)
    PairProgrammingSimulated, // BRAIN en mode "pair tutor"
}

impl AdaptiveRouterAgent {
    pub async fn route(&self, smi: &SmiScore, dag: &CompetenceDAG) -> Result<RoutingDecision> {
        match smi.global as u8 {
            // 🟡 FAST-TRACK: L'user connaît déjà bien
            86..=100 => {
                let skippable = self.find_skippable_nodes(dag, &smi.node_id).await?;
                Ok(RoutingDecision::FastTrack {
                    skip_nodes: skippable,
                    reason: format!("SMI {:.0}/100 — nœuds basiques ignorés", smi.global),
                    time_saved_hours: skippable.len() as f32 * 1.5,
                })
            }
            // 🟢 NORMAL: Progression standard
            70..=85 => {
                let next = self.dag_repository.get_next_available_node(&smi.node_id, dag).await?;
                Ok(RoutingDecision::NormalProgression {
                    next_node: next.id,
                    estimated_hours: next.estimated_hours,
                })
            }
            // 🟠 CONSOLIDATION: Besoin de renforcement
            60..=69 => {
                let exercises = self.generate_consolidation_exercises(&smi.node_id).await?;
                let cards = self.select_review_cards(&smi.node_id, &smi.user_id).await?;
                Ok(RoutingDecision::Consolidation {
                    current_node: smi.node_id,
                    additional_exercises: exercises,
                    additional_cards: cards,
                    target_smi: 70.0,
                })
            }
            // 🔴 REMEDIATION: L'user est bloqué
            _ => {
                let remediation_type = self.select_remediation_type(smi).await?;
                
                // Si besoin de nouveau contenu → re-déclencher Content-Scout
                let new_content = if matches!(remediation_type, RemediationType::AlternativeContent) {
                    Some(self.trigger_content_scout_for_node(&smi.node_id, &smi.user_id).await?)
                } else {
                    None
                };
                
                Ok(RoutingDecision::Remediation {
                    current_node: smi.node_id,
                    remediation_type,
                    new_content,
                })
            }
        }
    }
    
    /// Détecter un plateau (même SMI pendant 3+ sessions)
    async fn detect_plateau(&self, user_id: &Uuid, node_id: &Uuid) -> Option<StrategyChange> {
        let recent_smis = self.dag_repository
            .get_smi_history(user_id, node_id, last_n: 5)
            .await.ok()?;
        
        if recent_smis.len() >= 3 {
            let variance = calculate_variance(&recent_smis);
            if variance < 2.0 {
                // Plateau détecté → changer de stratégie
                return Some(StrategyChange {
                    reason: "Plateau SMI détecté sur 5 sessions".to_string(),
                    // Changer de ton, de type d'exercice, de source
                });
            }
        }
        None
    }
}
```

---

### AGENT-07 : DRIFT-GUARDIAN 🛡️
**Mission** : Détecter les signaux d'abandon et intervenir de façon proactive.

```rust
pub struct DriftGuardianAgent {
    signal_detector: DriftSignalDetector,
    intervention_engine: InterventionEngine,
    notification_service: Arc<NotificationService>,
}

/// Les 8 signaux de drift selon le PRD
#[derive(Debug, Clone)]
pub enum DriftSignal {
    Inactivity { days_since_last: u16 },          // > 2 jours sans activité
    RepeatedFailures { consecutive: u8 },          // > 3 échecs consécutifs
    SmiDecline { from: f32, to: f32, delta_days: u16 }, // SMI en baisse
    TruncatedSessions { ratio: f32 },              // > 50% sessions abandonnées
    NegativeFeedback { count: u8 },                // > 2 feedbacks négatifs
    RhythmChange { old_sessions_per_week: f32, new: f32 }, // Baisse > 50%
    NodeSkips { consecutive_skips: u8 },           // > 3 nœuds ignorés
    StagnationTime { days_on_node: u16 },          // > 5 jours sur le même nœud
}

#[derive(Debug, Clone)]
pub struct DriftIntervention {
    pub signal: DriftSignal,
    pub severity: DriftSeverity,             // Low / Medium / High / Critical
    pub action: InterventionAction,
    pub message: String,                     // Message personnalisé
    pub scheduled_at: i64,
}

#[derive(Debug, Clone)]
pub enum InterventionAction {
    // Low: Encouragement passif
    SendMotivationalNotification { tone: NotificationTone },
    
    // Medium: Réorientation douce
    SuggestMicroSession { duration_minutes: u8 },
    SimplifyCurrentNode,
    GenerateEasierExercise { node_id: Uuid },
    
    // High: Intervention active
    SendPersonalizedEmail { template: EmailTemplate },
    TriggerBrainCheckIn,        // BRAIN en mode "coach — tu vas bien ?"
    ResetNodeToEasierEntry,
    
    // Critical: Restructuration du parcours
    RestructureDag { reason: String },
    SuggestGoalSplit { sub_goals: Vec<String> },
    ScheduleHumanFollowUp,      // Optionnel: notifier un coach humain
}

impl DriftGuardianAgent {
    /// Tournée en background toutes les 4 heures
    pub async fn patrol(&self, user_id: &Uuid) -> Result<Vec<DriftIntervention>> {
        let signals = self.signal_detector.detect_all(user_id).await?;
        let mut interventions = vec![];
        
        for signal in signals {
            let severity = self.classify_severity(&signal);
            let action = self.select_intervention(&signal, &severity, user_id).await?;
            let message = self.craft_personalized_message(user_id, &signal, &action).await?;
            
            let intervention = DriftIntervention {
                signal: signal.clone(),
                severity,
                action,
                message,
                scheduled_at: self.optimal_send_time(user_id).await?,
            };
            
            // Enregistrer l'intervention
            self.record_intervention(user_id, &intervention).await?;
            interventions.push(intervention);
        }
        
        // Exécuter les interventions
        for intervention in &interventions {
            self.intervention_engine.execute(intervention, user_id).await?;
        }
        
        Ok(interventions)
    }
    
    /// Trouver le moment optimal pour envoyer (selon habitudes user)
    async fn optimal_send_time(&self, user_id: &Uuid) -> Result<i64> {
        // Analyser les patterns de connexion depuis Timeline COSMOS
        let activity_patterns = self.analyze_user_activity_patterns(user_id).await?;
        // Envoyer 30min avant la plage habituelle d'activité
        Ok(activity_patterns.next_likely_session_time - 1800)
    }
}
```

---

### AGENT-08 : ENGAGEMENT-AMPLIFIER 🎮
**Mission** : Maintenir la motivation via la gamification intelligente et les rapports automatiques.

```rust
pub struct EngagementAmplifierAgent {
    gamification_engine: GamificationEngine,
    report_generator: WeeklyReportGenerator,
    social_sharer: SocialShareEngine,
}

impl EngagementAmplifierAgent {
    /// Déclenché après chaque action significative
    pub async fn on_achievement(&self, event: &LearningEvent, user_id: &Uuid) -> Result<()> {
        match event {
            LearningEvent::NodeCompleted { node_id, smi } => {
                // 1. XP + Level up si applicable
                let xp_gained = self.gamification_engine.award_xp(user_id, XpEvent::NodeCompleted(*smi)).await?;
                
                // 2. Badge si milestone atteint
                let badge = self.gamification_engine.check_and_award_badge(user_id, event).await?;
                
                // 3. Confetti dans l'UI (WebSocket push)
                self.push_celebration(user_id, CelebrationLevel::NodeComplete, badge).await?;
                
                // 4. Mise à jour Timeline COSMOS (milestone visible)
                self.update_cosmos_timeline(user_id, event).await?;
                
                // 5. Option partage social (LinkedIn: "J'ai maîtrisé React Hooks!")
                if *smi >= 85.0 {
                    self.offer_social_share(user_id, event).await?;
                }
            }
            
            LearningEvent::StreakDay { streak_days } => {
                let badge = match streak_days {
                    7  => Some(Badge::BronzeStreak),
                    30 => Some(Badge::SilverStreak),
                    100 => Some(Badge::GoldStreak),
                    _ => None,
                };
                if let Some(b) = badge {
                    self.push_streak_celebration(user_id, *streak_days, b).await?;
                }
            }
            
            LearningEvent::RoadmapCompleted { goal_id } => {
                // Déclencher AGENT-09 (Skill-Certifier)
                self.event_bus.publish(Event::TriggerSkillCertification(*goal_id, *user_id)).await?;
            }
            _ => {}
        }
        
        Ok(())
    }
    
    /// Rapport hebdomadaire automatique (généré par NEURON-CHAINS)
    pub async fn generate_weekly_report(&self, user_id: &Uuid) -> Result<WeeklyReport> {
        let stats = self.collect_week_stats(user_id).await?;
        
        // Générer le rapport via NEURON-CHAINS (type B01 - Rapport hebdomadaire)
        let report_content = self.neuron_chains.generate_learning_report(&stats).await?;
        
        // Export PDF Typst
        let pdf = typst::compile(&self.to_typst_report(&report_content, &stats))?;
        
        Ok(WeeklyReport {
            user_id: *user_id,
            period: stats.period,
            nodes_completed: stats.nodes_completed,
            smi_evolution: stats.smi_by_week,
            time_invested: stats.total_minutes,
            cards_reviewed: stats.cards_reviewed,
            eta_completion: stats.predicted_completion_date,
            pdf_url: self.upload_report_pdf(pdf, user_id).await?,
        })
    }
}
```

---

### AGENT-09 : SKILL-CERTIFIER 🏆
**Mission** : Vérifier et certifier la compétence acquise à la completion du parcours.

```rust
pub struct SkillCertifierAgent {
    proof_of_skill_engine: ProofOfSkillEngine,
    certificate_generator: CertificateGenerator,
    next_goal_suggester: NextGoalSuggester,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProofOfSkill {
    pub user_id: Uuid,
    pub goal_id: Uuid,
    pub certification_id: Uuid,
    pub title: String,                          // "React Developer Certifié"
    pub earned_date: i64,
    
    // SMI Breakdown complet
    pub overall_smi: f32,                       // Score global /100
    pub dimension_scores: SmiDimensions,
    pub node_scores: Vec<NodeSmiSummary>,       // Score par nœud
    
    // Preuves
    pub exercises_passed: u32,
    pub exercises_total: u32,
    pub pass_rate: f32,
    pub average_session_quality: f32,
    pub consistency_score: f32,
    
    // Exports
    pub pdf_url: Option<String>,                // Typst PDF
    pub linkedin_badge_url: Option<String>,     // LinkedIn badge
    pub json_export: serde_json::Value,         // Machine-readable
    
    // Prochaines étapes
    pub suggested_next_goals: Vec<GoalSuggestion>,
}

impl SkillCertifierAgent {
    pub async fn certify(&self, goal_id: &Uuid, user_id: &Uuid) -> Result<ProofOfSkill> {
        
        // 1. Vérifier que TOUS les nœuds sont complétés (SMI >= smi_required)
        let dag = self.dag_repository.get_goal_dag(goal_id).await?;
        let incomplete_nodes: Vec<_> = dag.nodes.iter()
            .filter(|n| n.smi_achieved < n.smi_required)
            .collect();
        
        if !incomplete_nodes.is_empty() {
            // Pas encore prêt — renvoyer vers LEARNING-CONDUCTOR
            return Err(AgentError::CertificationNotReady {
                incomplete_nodes: incomplete_nodes.iter().map(|n| n.name.clone()).collect(),
                suggestion: "Continuer le parcours — X nœuds restants",
            });
        }
        
        // 2. Évaluation finale — test synthétique multi-nœuds
        let final_assessment = self.run_final_assessment(goal_id, user_id).await?;
        
        // 3. Calculer le SMI global
        let overall_smi = self.proof_of_skill_engine
            .calculate_overall_smi(user_id, goal_id)
            .await?;
        
        // 4. Générer le certificat (PDF Typst professionnel)
        let certificate_content = self.build_certificate_content(user_id, goal_id, overall_smi).await?;
        let pdf_bytes = typst::compile(&certificate_content)?;
        let pdf_url = self.storage.upload(pdf_bytes, format!("certs/{}/{}.pdf", user_id, goal_id)).await?;
        
        // 5. Suggestions des objectifs suivants
        let next_goals = self.next_goal_suggester
            .suggest_based_on_completed_goal(goal_id, user_id)
            .await?;
        
        // 6. Créer le badge LinkedIn
        let linkedin_url = self.generate_linkedin_badge(user_id, goal_id, overall_smi).await.ok();
        
        Ok(ProofOfSkill {
            user_id: *user_id,
            goal_id: *goal_id,
            certification_id: Uuid::new_v7(),
            title: format!("{} — Certifié SCY Forge", dag.goal_title),
            earned_date: Utc::now().timestamp(),
            overall_smi,
            dimension_scores: self.get_dimension_breakdown(user_id, goal_id).await?,
            node_scores: self.get_all_node_scores(user_id, goal_id).await?,
            exercises_passed: final_assessment.passed,
            exercises_total: final_assessment.total,
            pass_rate: final_assessment.rate,
            average_session_quality: final_assessment.quality,
            consistency_score: final_assessment.consistency,
            pdf_url: Some(pdf_url),
            linkedin_badge_url: linkedin_url,
            json_export: serde_json::to_value(&final_assessment)?,
            suggested_next_goals: next_goals,
        })
    }
}
```

---

### AGENT-10 : CHRONICLE 🤝 `[Premium uniquement]`
**Mission** : Vivre avec l'utilisateur au quotidien, adapter le plan d'apprentissage à sa réalité et gérer sans friction les imprévus (Protocole de ré-entrée sans friction Tiny Habits).

---

### AGENT-11 : ARENA 🎭 `[Premium uniquement]`
**Mission** : Valider la compétence théorique par une épreuve du feu en simulation interactive de roleplay basée sur une machine à états émotionnels (HSM).

---

### AGENT-12 : VISUAL-CRITIC 🛡️
**Mission** : Auditer l'intégrité logique, sémantique et géométrique de chaque schéma généré par NEURON-CHAINS (0 cycle, 0 hallucination visuelle, traçabilité absolue) avant affichage.

---

### AGENT-13 : COGNITIVE-VALIDATOR 🧠
**Mission** : Calibrer le niveau de complexité, la taille et le vocabulaire du visuel ou de la carte de cours (shimmers) en fonction du profil d'apprentissage et du score SMI de l'utilisateur.

---

## 4. Orchestration Inter-Features

### 4.1 Carte Complète des Interactions

Voici comment chaque agent orchestre TOUTES les features de SCY Forge :

```
┌─────────────────────────────────────────────────────────────────────────────┐
│           CARTE DES INTERACTIONS AGENTS ↔ FEATURES                          │
├────────────────┬────────────────────────────────────────────────────────────┤
│ AGENT          │ FEATURES ORCHESTRÉES                                        │
├────────────────┼────────────────────────────────────────────────────────────┤
│ GOAL-          │ • COSMOS KG → vérifier prérequis existants                  │
│ INTERPRETER    │ • BRAIN RAG → recherche connaissance existante user         │
│                │ • APEX FSRS → estimer niveau réel depuis historique         │
│                │ • NEURON-CHAINS → générer questionnaire adaptatif           │
├────────────────┼────────────────────────────────────────────────────────────┤
│ CONTENT-       │ • 11 Ingestion Cores → recherche + ingestion sources        │
│ SCOUT          │ • MapReduce L0-L4 → processing automatique                  │
│ (Agent-02)     │ • NEURON-CHAINS → génération docs post-ingestion            │
│                │ • COSMOS → update KG avec nouveaux concepts                  │
│                │ • SemanticCache → déduplication sources                     │
│                │ • Tantivy/pgvector → indexation pour BRAIN                  │
├────────────────┼────────────────────────────────────────────────────────────┤
│ DAG-           │ • NEURON-CHAINS (7 chaînes) → docs par nœud                │
│ ARCHITECT      │ • APEX/FSRS → création flashcards par concept               │
│ (Agent-03)     │ • BRAIN → indexation chunks RAG par nœud                   │
│                │ • COSMOS → population KG + Roadmap mode 4                   │
│                │ • petgraph → validation DAG                                 │
│                │ • SINKT (Paper-009) → auto-positionnement user              │
│                │ • GLiNER NER → extraction concepts pour KG                  │
├────────────────┼────────────────────────────────────────────────────────────┤
│ LEARNING-      │ • APEX/FSRS → scheduling révisions + sélection cartes      │
│ CONDUCTOR      │ • BRAIN RAG → assistant contextuel temps réel               │
│ (Agent-04)     │ • COSMOS (8 modes) → visualisation progression              │
│                │ • IMPRINT → déclenchement mémorisation profonde             │
│                │ • NEURON-CHAINS → génération contenu supplémentaire         │
│                │ • EventBus → notifications autres agents                    │
│                │ • Dashboard → mise à jour stats ISR                         │
├────────────────┼────────────────────────────────────────────────────────────┤
│ PERFORMANCE-   │ • APEX/FSRS → données rétention (stability, lapses)        │
│ ANALYZER       │ • ASCENT Exercices → scores exercices                       │
│ (Agent-05)     │ • COSMOS Timeline → patterns régularité                     │
│                │ • D-006 Calibration Métacognitive → confiance vs réalité   │
│                │ • HiTSKT (Paper-008) → analyse sessions                    │
├────────────────┼────────────────────────────────────────────────────────────┤
│ ADAPTIVE-      │ • DAG Repository → modification dynamique du parcours      │
│ ROUTER         │ • Content-Scout → re-déclencher si contenu insuffisant     │
│ (Agent-06)     │ • NEURON-CHAINS → contenu alternatif si blocage            │
│                │ • APEX → intensification révisions si SMI < 60%            │
│                │ • BRAIN → mode "pair tutor" si remédiation                 │
├────────────────┼────────────────────────────────────────────────────────────┤
│ DRIFT-         │ • COSMOS Timeline → détecter inactivité                     │
│ GUARDIAN       │ • APEX → détecter échecs répétés                           │
│ (Agent-07)     │ • NotificationService → push/email/in-app                  │
│                │ • BRAIN → mode "coach empathique" si critical              │
│                │ • NEURON-CHAINS → générer message personnalisé             │
│                │ • Adaptive-Router → simplifier parcours si nécessaire      │
├────────────────┼────────────────────────────────────────────────────────────┤
│ ENGAGEMENT-    │ • Gamification → XP, badges, streaks, levels               │
│ AMPLIFIER      │ • COSMOS Timeline → milestones visibles                     │
│ (Agent-08)     │ • NEURON-CHAINS → génération rapport hebdomadaire          │
│                │ • Typst → export PDF rapport / certificat                  │
│                │ • WebSocket → push célébrations temps réel                 │
│                │ • Social Share → partage LinkedIn/Twitter                  │
├────────────────┼────────────────────────────────────────────────────────────┤
│ SKILL-         │ • APEX → évaluation finale multi-nœuds                    │
│ CERTIFIER      │ • SMI Calculator → score global 5 dimensions              │
│ (Agent-09)     │ • NEURON-CHAINS → génération certificat (B01)              │
│                │ • Typst → PDF certificat professionnel                     │
│                │ • Northflank Storage → stockage certificat                   │
│                │ • Next Goal Suggester → continuité apprentissage           │
└────────────────┴────────────────────────────────────────────────────────────┘
```

---

## 5. Cycle de Vie Complet d'un Parcours

### 5.1 Timeline Détaillée — "Maîtriser React en 8 semaines"

```
╔══════════════════════════════════════════════════════════════════════════╗
║  JOUR 1 — ONBOARDING (GOAL-INTERPRETER + CONTENT-SCOUT + DAG-ARCHITECT)  ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  09:00 User: "Je veux maîtriser React en 8 semaines"                    ║
║         ↓                                                                ║
║  09:01 GOAL-INTERPRETER:                                                 ║
║        • Analyse: domaine Tech, 80h estimées, niveau Intermédiaire JS   ║
║        • Profil: 10h/sem disponibles, style visuel + pratique            ║
║        • COSMOS Query: concepts JS déjà maîtrisés? SMI=72 ✅             ║
║        • Prérequis: HTML/CSS ✅, JS ✅, Node.js ⚠️ (partiel)           ║
║         ↓                                                                ║
║  09:03 CONTENT-SCOUT (auto, background):                                 ║
║        • YouTube: 12 vidéos React 2026 trouvées (Fireship, Theo...)     ║
║        • Web: 8 articles react.dev + blogs                              ║
║        • Drive: 2 docs personnels sur JS (déjà dans la base)            ║
║        • Ingestion parallèle: 5 sources simultanées                     ║
║        • MapReduce L0-L4: ~3min de processing                           ║
║        • COSMOS KG: 47 nouveaux concepts indexés                         ║
║         ↓                                                                ║
║  09:08 DAG-ARCHITECT:                                                    ║
║        • DAG généré: 15 nœuds, chemin critique = 72h                   ║
║        • SINKT positionnement: User commence au nœud 3 (JS avancé OK)  ║
║        • NEURON-CHAINS: génération parallèle des docs pour 15 nœuds    ║
║          - 3 NEURON-CHAINS simultanées (BETA, GAMMA, EPSILON)           ║
║          - ~8min de génération                                          ║
║        • APEX: 180 flashcards créées (12 par nœud × 15)                ║
║        • COSMOS Roadmap: DAG visible (mode 4 — React Flow)               ║
║         ↓                                                                ║
║  09:17 RÉSULTAT AFFICHÉ À L'USER:                                       ║
║        "✅ Votre roadmap React est prête!                               ║
║         15 compétences · 72h estimées · 15 nœuds                      ║
║         Vous démarrez au nœud 3 (JS avancé maîtrisé 💪)               ║
║         Premier nœud: React Fundamentals — Components & JSX"           ║
║         [Commencer maintenant →]                                        ║
║                                                                          ║
╠══════════════════════════════════════════════════════════════════════════╣
║  JOURS 2-7 — APPRENTISSAGE (LEARNING-CONDUCTOR principal)                ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  Chaque session (20-60min):                                             ║
║                                                                          ║
║  LEARNING-CONDUCTOR décide:                                              ║
║  1. Vérifie cartes FSRS dues → 5 cartes à réviser (2min)               ║
║  2. Présente le document "React Components" (lu en 15min)               ║
║  3. Propose exercice pratique (créer un composant) (20min)              ║
║  4. BRAIN disponible en sidebar → Q&A contextuel                        ║
║  5. Met à jour COSMOS KG en temps réel                                   ║
║  6. Score exercice → 78/100 → PERFORMANCE-ANALYZER calcule SMI        ║
║                                                                          ║
║  PERFORMANCE-ANALYZER:                                                   ║
║  • Retention: 0.72 (3 révisions FSRS, good+easy)                       ║
║  • Depth: 0.78 (score exercice 78/100)                                  ║
║  • Mirror: 0.65 (pas encore évalué)                                     ║
║  • Metacognition: 0.80 (calibration proche réalité)                    ║
║  • Consistency: 0.90 (5 jours consécutifs)                             ║
║  → SMI nœud 3 = 74.7 ✅ (>70 = nœud passé!)                          ║
║                                                                          ║
║  ADAPTIVE-ROUTER: SMI 74.7 → Progression normale                        ║
║  → Nœud suivant: "React Hooks — useState & useEffect"                  ║
║  → COSMOS Roadmap: nœud 3 passe au vert ✅                              ║
║  → ENGAGEMENT-AMPLIFIER: XP +150, badge "Premier nœud complété!"       ║
║                                                                          ║
╠══════════════════════════════════════════════════════════════════════════╣
║  JOUR 12 — DRIFT DÉTECTÉ (DRIFT-GUARDIAN intervient)                    ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  Signal: 3 jours sans activité + nœud 7 (useContext) bloquant          ║
║  SMI nœud 7: 52/100 après 4 tentatives                                 ║
║                                                                          ║
║  DRIFT-GUARDIAN intervient:                                              ║
║  Sévérité: HIGH                                                          ║
║  Action: ADAPTIVE-ROUTER → RemediationType::AlternativeContent          ║
║                                                                          ║
║  CONTENT-SCOUT re-déclenché:                                             ║
║  → Trouve 3 nouvelles vidéos "useContext explained simply 2026"         ║
║  → Ingère + génère résumé simplifié (ton ELI5 T41)                     ║
║  → NEURON-CHAINS génère exercice alternatif (niveau plus facile)        ║
║                                                                          ║
║  Notification envoyée:                                                   ║
║  "🧠 Tu bloques sur useContext depuis quelques jours.                   ║
║   J'ai trouvé une nouvelle approche qui simplifie le concept.           ║
║   5 minutes, et ça va tout changer. [Voir →]"                          ║
║                                                                          ║
╠══════════════════════════════════════════════════════════════════════════╣
║  SEMAINE 7 — IMPRINT DÉCLENCHÉ (LEARNING-CONDUCTOR)                     ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  Après 3 succès consécutifs sur "React Performance & Memo":             ║
║  IMPRINT déclenché (nœud complexité 4)                                  ║
║                                                                          ║
║  CRE Level 3 activé:                                                     ║
║  • Garniture Engine: 6 insights essentiels extraits                     ║
║  • Tree Renderer: Arbre conceptuel généré                               ║
║  • Modal IMPRINT: affiché sans export (friction intentionnelle)         ║
║  "📝 Reconstruis cet arbre de mémoire dans ton carnet."                ║
║                                                                          ║
╠══════════════════════════════════════════════════════════════════════════╣
║  JOUR 53 — CERTIFICATION (SKILL-CERTIFIER)                               ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  15 nœuds complétés, SMI moyen: 81/100                                 ║
║                                                                          ║
║  SKILL-CERTIFIER:                                                        ║
║  1. Évaluation finale: 15 questions cross-nœuds → 87/100               ║
║  2. SMI Global calculé: 84/100                                          ║
║  3. PDF Typst généré: "React Developer Certifié — SCY Forge"           ║
║  4. Badge LinkedIn proposé                                              ║
║  5. Suggestions: "Next.js", "TypeScript Avancé", "Testing React"        ║
║                                                                          ║
║  🎉 CONFETTI — CÉLÉBRATION COMPLÈTE                                     ║
║  "✅ Tu maîtrises React! SMI 84/100 — en 53 jours (vs 56 prévu)"      ║
║  [Télécharger certificat] [Partager LinkedIn] [Prochain objectif →]    ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

### 5.2 Le Serment de Rigueur & La Décomposition Modulaire d'Onboarding

SCY Forge se dote d'une politique de **Transparence Absolue** (éthique pédagogique) :
1. **Le Message de Clarté d'Onboarding** : Lorsqu'un utilisateur sans prérequis déclare un objectif de plus de 150 heures (ex: "Devenir Data Scientist"), `AGENT-01` (GOAL-INTERPRETER) intercepte la requête et affiche un avertissement de rigueur pédagogique : *"Devenir Data Scientist requiert en moyenne 1500h d'étude et de pratique. SCY Forge refuse de vous mentir en vous promettant de le devenir en 3 mois. Nous avons décomposé votre rêve en 5 micro-goals d'expert successifs. Commençons par le Jalon 1 : Analyse de données fondamentales avec Python (25h)."*
2. **Le Contrat d'Engagement Pratique** : L'apprenant doit valider l'avertissement et accepter le fait que la véritable maîtrise sémantique et synaptique s'acquiert avec du **temps (Spacing)** et de la **pratique délibérée (Active Practice)**.

---

## 6. Le Moteur de Décision Adaptatif

### 6.1 Machine à États du Parcours

```rust
/// Typestate pattern — States du parcours ASCENT
pub mod ascent_states {
    pub struct Initializing;    // GOAL-INTERPRETER + CONTENT-SCOUT
    pub struct DagBuilding;     // DAG-ARCHITECT
    pub struct Learning;        // LEARNING-CONDUCTOR (état principal)
    pub struct Consolidating;   // ADAPTIVE-ROUTER (SMI 60-70%)
    pub struct Remediating;     // ADAPTIVE-ROUTER (SMI < 60%)
    pub struct FastTracking;    // ADAPTIVE-ROUTER (SMI > 85%)
    pub struct Drifting;        // DRIFT-GUARDIAN intervention
    pub struct Certifying;      // SKILL-CERTIFIER
    pub struct Completed;       // Parcours terminé
}

/// Machine à états type-safe Rust
pub struct AscentJourney<State> {
    goal: LearningGoal,
    dag: CompetenceDAG,
    current_node: SkillNode,
    user_id: Uuid,
    _state: PhantomData<State>,
}

// Transitions de states — vérifiées à la compilation
impl AscentJourney<Initializing> {
    pub async fn build_dag(self) -> Result<AscentJourney<DagBuilding>> { ... }
}

impl AscentJourney<DagBuilding> {
    pub async fn start_learning(self) -> Result<AscentJourney<Learning>> { ... }
}

impl AscentJourney<Learning> {
    pub async fn on_smi_update(self, smi: f32) -> NextState { 
        match smi as u8 {
            86..=100 => NextState::FastTracking(self.into()),
            70..=85  => NextState::Learning(self),           // Rester
            60..=69  => NextState::Consolidating(self.into()),
            _        => NextState::Remediating(self.into()),
        }
    }
    pub async fn on_drift_detected(self) -> AscentJourney<Drifting> { ... }
    pub async fn on_all_nodes_complete(self) -> AscentJourney<Certifying> { ... }
}
```

---

## 7. Système de Détection et Intervention

### 7.1 EventBus — Communication entre Agents

```rust
/// Bus d'événements central — tous les agents communiquent via lui
pub struct SCY ForgeEventBus {
    subscribers: Arc<DashMap<EventType, Vec<Box<dyn EventHandler>>>>,
}

#[derive(Debug, Clone)]
pub enum SCY ForgeEvent {
    // APEX events
    CardReviewed { user_id: Uuid, card_id: Uuid, rating: Rating, smi_delta: f32 },
    ExerciseCompleted { user_id: Uuid, node_id: Uuid, score: f32 },
    SessionEnded { user_id: Uuid, duration_minutes: u16, cards_reviewed: u32 },
    
    // ASCENT events
    NodeCompleted { user_id: Uuid, node_id: Uuid, smi_achieved: f32 },
    NodeUnlocked { user_id: Uuid, node_id: Uuid },
    GoalCompleted { user_id: Uuid, goal_id: Uuid },
    
    // BRAIN events
    BrainQueried { user_id: Uuid, query: String, context_node: Uuid },
    
    // COSMOS events
    KnowledgeGraphUpdated { user_id: Uuid, new_concepts: Vec<String> },
    
    // IMPRINT events
    ImprintCompleted { user_id: Uuid, concept: String, cran_level: u8 },
    
    // Drift events
    InactivityDetected { user_id: Uuid, days: u16 },
    FailureStreakDetected { user_id: Uuid, node_id: Uuid, consecutive: u8 },
    
    // System events
    IngestionCompleted { user_id: Uuid, source_id: Uuid, concepts_extracted: u32 },
    NeuronChainCompleted { node_id: Uuid, doc_type: String, confidence_score: u8 },
}

// Exemple d'abonnement: PERFORMANCE-ANALYZER écoute APEX
impl SCY ForgeEventBus {
    pub fn setup_agent_subscriptions(&self, agents: &AgentRegistry) {
        // PERFORMANCE-ANALYZER ← APEX events
        self.subscribe(EventType::CardReviewed, agents.performance_analyzer.clone());
        self.subscribe(EventType::ExerciseCompleted, agents.performance_analyzer.clone());
        
        // DRIFT-GUARDIAN ← Session events
        self.subscribe(EventType::SessionEnded, agents.drift_guardian.clone());
        self.subscribe(EventType::InactivityDetected, agents.drift_guardian.clone());
        
        // ENGAGEMENT-AMPLIFIER ← Achievement events
        self.subscribe(EventType::NodeCompleted, agents.engagement_amplifier.clone());
        self.subscribe(EventType::GoalCompleted, agents.engagement_amplifier.clone());
        
        // ADAPTIVE-ROUTER ← Performance events (via PERFORMANCE-ANALYZER)
        self.subscribe(EventType::SmiUpdated, agents.adaptive_router.clone());
        
        // COSMOS ← Concept events
        self.subscribe(EventType::KnowledgeGraphUpdated, agents.cosmos_manager.clone());
        
        // LEARNING-CONDUCTOR ← Tous les events (orchestrateur principal)
        self.subscribe(EventType::All, agents.learning_conductor.clone());
    }
}
```

---

## 8. Proof of Skill

### 8.0 Évaluation Finale & Génération de Formulaires (Rétention & Validation)

Pour l'évaluation finale (Gate 3) et la collecte de quiz sémantiques, SCY Forge s'appuie sur une architecture de rendu de formulaires dynamiques pilotée par schéma (JSON-driven) hautement optimisée en coûts :
* **Rendu d'Examens (SurveyJS Form Library - 100% Gratuit & MIT)** : Nous utilisons uniquement la bibliothèque de rendu (le runner) de SurveyJS qui est sous Licence MIT gratuite. Elle convertit instantanément les schémas JSON d'examens générés par `NEURON-CHAINS` en formulaires d'examens responsives et interactifs (avec minuteur, multi-pages et validations) à **0$**.
* **Visualisation & Analytics (Recharts - 100% Gratuit & MIT)** : Au lieu d'utiliser le module payant de SurveyJS, nous exploitons la bibliothèque **Recharts** déjà présente dans COSMOS pour dessiner nos propres graphiques statistiques de réussite directement en React, éliminant les frais de licence.
* **Export PDF (Typst / jspdf - 100% Gratuit & MIT)** : L'export des examens corrigés se fait localement via la bibliothèque gratuite `jspdf` ou compilé via le moteur `typst-pdf` en backend Rust, sans utiliser le module PDF payant de SurveyJS.

#### 🛠️ L'Écosystème de Création d'Examens de Cursus (Survey Creator & Ace Editor — Client-side) :
Pour permettre à nos concepteurs de cours d'évaluations et d'examens d'éditer ou d'affiner visuellement et à **0$ de coût serveur** les schémas de questionnaires auto-générés par `NEURON-CHAINS` :
1. **Édition Visuelle de Formulaire (Survey Creator — 100% Côté Client)** : Nous intégrons l'éditeur visuel drag-and-drop `Survey Creator` au sein de la console Administrateur de l'application React. Bien que l'outil possède sa propre licence, **l'exécution s'effectue à 100% côté client (dans le navigateur du concepteur)**. Aucune ressource de calcul serveur n'est consommée.
2. **Coloration Syntaxique du JSON (Ace Editor — 100% Côté Client)** : L'onglet d'édition brute du JSON intègre l'éditeur **`Ace`** (chargé via un CDN public) pour offrir une coloration et une validation syntaxique instantanée en direct pendant la saisie textuelle du JSON du questionnaire, facilitant le travail de revue technique à coût nul.

### 8.1 Structure Complète du Certificat

```
╔══════════════════════════════════════════════════════════════════════╗
║                    SCY FORGE PROOF OF SKILL                           ║
║                                                                        ║
║  ┌─────────────────────────────────────────────────────────────────┐  ║
║  │  👤 Jean-Baptiste Doe                                           │  ║
║  │  🎯 React Developer — Niveau Confirmé                           │  ║
║  │  📅 Certifié le 08 Juin 2026                                   │  ║
║  │  🔑 ID: SCY-2026-06-08-REACT-84                                │  ║
║  └─────────────────────────────────────────────────────────────────┘  ║
║                                                                        ║
║  SCORE GLOBAL: 84/100 🏆                                             ║
║                                                                        ║
║  DÉTAIL 5 DIMENSIONS:                                                 ║
║  ████████████████████░ Rétention       88/100  (35%)                 ║
║  ████████████████░░░░░ Profondeur      80/100  (25%)                 ║
║  █████████████░░░░░░░░ Miroir Cogn.   78/100  (20%)                 ║
║  █████████████████░░░░ Métacognition  82/100  (10%)                 ║
║  ████████████████████░ Cohérence      86/100  (10%)                 ║
║                                                                        ║
║  COMPÉTENCES MAÎTRISÉES (15/15 nœuds):                              ║
║  ✅ React Fundamentals (SMI: 87)    ✅ Hooks avancés (SMI: 81)      ║
║  ✅ State Management (SMI: 85)      ✅ Performance (SMI: 79)        ║
║  ✅ Testing (SMI: 83)               ... 10 autres nœuds             ║
║                                                                        ║
║  STATISTIQUES PARCOURS:                                              ║
║  ⏱️ Durée: 53 jours (prévu: 56j — 3j d'avance)                     ║
║  📚 Sources: 12 YouTube + 8 articles + 2 docs personnels            ║
║  🃏 Flashcards révisées: 1,847                                      ║
║  💪 Exercices complétés: 89/92 (97%)                                ║
║  🔥 Streak max: 14 jours consécutifs                                ║
║  🧠 Sessions IMPRINT: 3                                             ║
║                                                                        ║
║  VÉRIFICATION:                                                        ║
║  🔗 scy_forge.app/verify/SCY-2026-06-08-REACT-84                    ║
║  📎 Données vérifiables — Score calculé par algorithme FSRS 5.0     ║
║                                                                        ║
╚══════════════════════════════════════════════════════════════════════╝
```

### 8.2 La Feuille de Route d'Accréditation Globale (Reconnaissance Universelle)

Pour donner une valeur d'embauche et une légitimité académique indiscutable à nos diplômes *Proof of Skill*, SCY Forge suit une feuille de route d'accréditation progressive en 3 Tiers (décrite en détail dans le document d'ingénierie `uploads/scy_forge_accreditation_roadmap.md`) :

1. **Tier 1 : La Confiance Cryptographique (J0-J30)** : Utilisation du standard W3C **Open Badges 3.0** encapsulant les métadonnées de compétences directement dans le certificat, et déploiement de la page publique de vérification décentralisée `/verify/{id}` avec preuves de projets concrets visibles.
2. **Tier 2 : L'Accréditation Professionnelle (Mois 3-9)** : Obtention de l'accréditation **IACET** pour émettre des **CEU (Continuing Education Units)** officiels (10h d'étude = 1.0 CEU) acceptés par les départements d'éducation et les entreprises, audit de conformité internationale **ISO 29993:2017**, et intégration aux registres de financements publics (Qualiopi/CPF en France, State Departments aux USA).
3. **Tier 3 : L'Équivalence Académique Universitaire (Mois 9+)** : Partenariats de co-branding avec des universités et écoles d'ingénieurs accréditées pour valider nos programmes ASCENT et délivrer des relevés de notes officiels d'équivalences de crédits universitaires (**ECTS** en Europe, **Graduate Credits** aux USA).



# Diagnostic du problème identifié

Tu soulèves un point critique qui est en **contradiction directe** avec la promesse centrale d'ASCENT.

```
┌─────────────────────────────────────────────────────────────────┐
│                    LE PROBLÈME RÉEL                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  CONSTAT :                                                      │
│  Les sources actuellement cartographiées couvrent              │
│  quasi-exclusivement les domaines TECH                         │
│                                                                  │
│  Google Developers → Tech                                      │
│  AWS Training → Tech                                           │
│  Microsoft Learn → Tech                                        │
│  Kubernetes → Tech                                             │
│  Rust Book → Tech                                              │
│  MDN → Tech                                                    │
│  Linux Foundation → Tech                                       │
│                                                                  │
│  CONSÉQUENCE DIRECTE :                                         │
│  ASCENT ne peut tenir sa promesse que pour                     │
│  ~15% des objectifs d'apprentissage humains                    │
│                                                                  │
│  Un utilisateur qui veut maîtriser :                          │
│  → La négociation commerciale → Pas de sources Gold           │
│  → La prise de parole en public → Pas de sources Gold         │
│  → La gestion financière → Pas de sources Gold                │
│  → Le management d'équipe → Pas de sources Gold               │
│  → Une langue étrangère → Pas de sources Gold                 │
│                                                                  │
│  ASCENT lui dirait : "Sources insuffisantes (< 85%)"          │
│  Et refuserait de démarrer.                                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Cartographie complète — Ce qui manque

```
┌─────────────────────────────────────────────────────────────────┐
│         DOMAINES NON COUVERTS vs DEMANDE UTILISATEUR           │
├──────────────────────────┬──────────────────────────────────────┤
│  DOMAINE                 │  POURQUOI C'EST CRITIQUE            │
├──────────────────────────┼──────────────────────────────────────┤
│  Business & Management   │  50% des objectifs pros            │
│  Langues étrangères      │  Marché massif, universel           │
│  Sciences (Physique,     │  Étudiants, reconversions           │
│  Chimie, Biologie)       │                                     │
│  Arts & Créativité       │  Design, musique, écriture          │
│  Finance personnelle      │  Besoin universel                   │
│  Soft skills             │  Leadership, communication          │
│  Santé & Bien-être       │  Nutrition, sport, psychologie      │
│  Droit & Compliance      │  Entrepreneuriat, citoyenneté       │
│  Histoire & Philosophie  │  Culture générale, pensée critique  │
│  Mathématiques pures     │  Parcours académiques               │
└──────────────────────────┴──────────────────────────────────────┘
```

---

## Solution — Extension de la cartographie sources

### NIVEAU 1 GOLD — Domaines non-tech

```
┌─────────────────────────────────────────────────────────────────┐
│              SOURCES GOLD — BUSINESS & MANAGEMENT              │
├──────────────────────────────┬──────────────────────────────────┤
│  SOURCE                      │  DOMAINES COUVERTS              │
├──────────────────────────────┼──────────────────────────────────┤
│  Harvard Business School     │  Strategy, Leadership,          │
│  hbr.org (articles gratuits) │  Management, Finance            │
├──────────────────────────────┼──────────────────────────────────┤
│  Google Project Management   │  PM, Agile, Scrum,              │
│  (Coursera cert. gratuite)   │  Gestion de projet              │
├──────────────────────────────┼──────────────────────────────────┤
│  HubSpot Academy             │  Marketing, Vente,              │
│  academy.hubspot.com         │  CRM, Inbound                   │
├──────────────────────────────┼──────────────────────────────────┤
│  Salesforce Trailhead        │  CRM, Sales, Marketing          │
│  trailhead.salesforce.com    │  Cloud Business                 │
├──────────────────────────────┼──────────────────────────────────┤
│  Meta Blueprint              │  Social Media Marketing,        │
│  facebook.com/blueprint      │  Publicité digitale             │
└──────────────────────────────┴──────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│              SOURCES GOLD — LANGUES & COMMUNICATION            │
├──────────────────────────────┬──────────────────────────────────┤
│  SOURCE                      │  DOMAINES COUVERTS              │
├──────────────────────────────┼──────────────────────────────────┤
│  Duolingo for Schools        │  Langues (30+ langues)          │
│  schools.duolingo.com        │  Curriculum officiel            │
├──────────────────────────────┼──────────────────────────────────┤
│  Alliance Française          │  Français langue étrangère      │
│  ressources officielles      │  DELF/DALF préparation          │
├──────────────────────────────┼──────────────────────────────────┤
│  British Council             │  Anglais, IELTS, TOEFL          │
│  learnenglish.britishcouncil │  Business English               │
├──────────────────────────────┼──────────────────────────────────┤
│  Goethe Institut             │  Allemand, culture              │
│  goethe.de/ressources        │  Certifications officielles     │
└──────────────────────────────┴──────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│              SOURCES GOLD — SCIENCES & ACADÉMIQUE              │
├──────────────────────────────┬──────────────────────────────────┤
│  SOURCE                      │  DOMAINES COUVERTS              │
├──────────────────────────────┼──────────────────────────────────┤
│  Khan Academy                │  Maths, Physique, Chimie        │
│  (déjà Silver → upgrade Gold)│  Biologie, Économie             │
│  khanacademy.org             │  + Histoire, Grammaire          │
├──────────────────────────────┼──────────────────────────────────┤
│  MIT OpenCourseWare          │  Sciences exactes               │
│  (déjà Silver → upgrade Gold)│  Ingénierie, Économie           │
│  ocw.mit.edu                 │  Architecture, Urbanisme        │
├──────────────────────────────┼──────────────────────────────────┤
│  PubMed / NIH                │  Médecine, Biologie             │
│  pubmed.ncbi.nlm.nih.gov     │  Nutrition, Santé publique      │
├──────────────────────────────┼──────────────────────────────────┤
│  NASA Open Data              │  Astronomie, Physique           │
│  nasa.gov/learning-resources │  Sciences de la Terre           │
├──────────────────────────────┼──────────────────────────────────┤
│  WHO / OMS                   │  Santé, Nutrition               │
│  who.int/education           │  Épidémiologie, Médecine        │
└──────────────────────────────┴──────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│              SOURCES GOLD — FINANCE & ÉCONOMIE                 │
├──────────────────────────────┬──────────────────────────────────┤
│  SOURCE                      │  DOMAINES COUVERTS              │
├──────────────────────────────┼──────────────────────────────────┤
│  CFA Institute               │  Finance, Investissement        │
│  cfainstitute.org/resources  │  Analyse financière             │
├──────────────────────────────┼──────────────────────────────────┤
│  Banque de France            │  Économie, Finance perso        │
│  banque-france.fr/education  │  Gestion budgétaire             │
├──────────────────────────────┼──────────────────────────────────┤
│  AMF (Autorité Marchés Fin.) │  Investissement, Bourse         │
│  amf-france.org/education    │  Réglementation financière      │
├──────────────────────────────┼──────────────────────────────────┤
│  OCDE / PISA                 │  Économie mondiale              │
│  oecd.org/education          │  Politiques publiques           │
└──────────────────────────────┴──────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│              SOURCES GOLD — ARTS & CRÉATIVITÉ                  │
├──────────────────────────────┬──────────────────────────────────┤
│  SOURCE                      │  DOMAINES COUVERTS              │
├──────────────────────────────┼──────────────────────────────────┤
│  Adobe Education Exchange    │  Design, Photographie           │
│  edex.adobe.com              │  Vidéo, Motion Design           │
├──────────────────────────────┼──────────────────────────────────┤
│  Canva Design School         │  Design graphique               │
│  canva.com/learn/design-     │  Communication visuelle         │
│  school                      │  Brand identity                 │
├──────────────────────────────┼──────────────────────────────────┤
│  Berklee Online (gratuit)    │  Musique, Composition           │
│  online.berklee.edu/courses  │  Production musicale            │
│  (cours gratuits sélectifs)  │  Théorie musicale               │
├──────────────────────────────┼──────────────────────────────────┤
│  MoMA Learning               │  Histoire de l'art              │
│  moma.org/learn              │  Design, Architecture           │
└──────────────────────────────┴──────────────────────────────────┘
```

---

## Mise à jour du SQS — Paramètres par domaine

```
┌─────────────────────────────────────────────────────────────────┐
│         SOURCE QUALITY SCORE — AJUSTEMENTS PAR DOMAINE         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PROBLÈME DU SQS ACTUEL :                                      │
│  Le critère "Fraîcheur" pénalise injustement                   │
│  les domaines stables et académiques.                          │
│                                                                  │
│  Un cours de philosophie de Platon                             │
│  n'a pas besoin d'être mis à jour.                            │
│  Un manuel de physique de 3 ans reste valide.                  │
│                                                                  │
│  SOLUTION : SQS pondéré par type de domaine                    │
│                                                                  │
├──────────────────┬────────────────────────────────────────────  │
│  TYPE DOMAINE    │  PONDÉRATION CRITÈRE FRAÎCHEUR              │
├──────────────────┼──────────────────────────────────────────── │
│  Tech évolutif   │  ×2.0 (Cloud, IA, Frameworks)              │
│  (Cloud, IA,     │  Source > 1 an → pénalité forte            │
│  Web, Sécurité)  │                                             │
├──────────────────┼──────────────────────────────────────────── │
│  Business        │  ×1.2 (Management, Marketing)              │
│  & Management    │  Source > 3 ans → légère pénalité          │
├──────────────────┼──────────────────────────────────────────── │
│  Sciences        │  ×0.8 (Maths, Physique, Chimie)            │
│  exactes         │  Source > 5 ans → pénalité minime          │
├──────────────────┼──────────────────────────────────────────── │
│  Langues         │  ×0.5 (Grammaire, Littérature)             │
│  & Linguistique  │  Source > 10 ans → pas de pénalité         │
├──────────────────┼──────────────────────────────────────────── │
│  Humanités       │  ×0.0 (Histoire, Philo, Art)               │
│  & Culture       │  Fraîcheur non pertinente                  │
└──────────────────┴────────────────────────────────────────────  │
│                                                                  │
│  NOUVEAU CRITÈRE — Pertinence domaine (0-15 points)           │
│  ──────────────────────────────────────────────────            │
│  Source primaire du domaine (institution centrale) → 15 pts   │
│  Source secondaire reconnue (université)           → 10 pts   │
│  Source praticien expert                           →  7 pts   │
│  Source généraliste couvrant le domaine            →  3 pts   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Impact sur l'architecture ASCENT

```
┌─────────────────────────────────────────────────────────────────┐
│         CE QUI CHANGE DANS LA LOGIQUE ASCENT                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  DÉTECTION DU DOMAINE (nouveau module)                         │
│  ──────────────────────────────────────                         │
│  Quand l'user définit son objectif ASCENT :                   │
│  "Je veux maîtriser la négociation commerciale"               │
│                                                                  │
│  ASCENT classe automatiquement :                               │
│  → Domaine principal : Business / Soft Skills                 │
│  → Sous-domaine : Communication / Négociation                 │
│  → Type : Stable (pas tech évolutif)                          │
│  → Sources prioritaires : HBR, Coursera Business,            │
│                           Stanford negotiation, etc.          │
│  → SQS fraîcheur : pondéré ×1.0                              │
│                                                                  │
│  PUIS vérifie couverture ≥ 85%                                │
│  avec les sources du bon domaine                              │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ADAPTATION DES EXERCICES PAR DOMAINE                          │
│  ────────────────────────────────────                           │
│                                                                  │
│  Tech → Code à écrire + output vérifiable                     │
│  Business → Étude de cas + argumentation                      │
│  Langues → Production orale/écrite + correction               │
│  Sciences → Problèmes à résoudre + démonstration              │
│  Arts → Production créative + rubrique évaluation             │
│  Soft skills → Simulation de situation + feedback             │
│                                                                  │
│  Le SMI × 5 dimensions reste identique                        │
│  Seule la FORME des exercices change selon le domaine         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Mise à jour de la checklist ASCENT

```
┌─────────────────────────────────────────────────────────────────┐
│         CHECKLIST ASCENT — MISE À JOUR                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  SOURCES ✓                                                     │
│  ☐ Domaine détecté et classifié correctement                  │
│  ☐ Sources Gold du domaine spécifique disponibles             │
│  ☐ Couverture ≥ 85% avec sources adaptées au domaine         │
│  ☐ SQS fraîcheur pondéré selon type de domaine               │
│  ☐ Pas de contradictions non résolues                         │
│                                                                  │
│  CONTENU ✓                                                     │
│  ☐ Format des exercices adapté au domaine                     │
│  ☐ Analogies contextuellement pertinentes                     │
│  ☐ Exemples issus du vrai monde du domaine                   │
│  ☐ Progression Bloom respectée                                │
│                                                                  │
│  [Le reste des critères reste inchangé]                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Priorité d'implémentation recommandée

```
┌─────────────────────────────────────────────────────────────────┐
│              ORDRE LOGIQUE D'EXPANSION                         │
├────────┬────────────────────────────────┬──────────────────────┤
│  ORDRE │  DOMAINE                       │  RAISON              │
├────────┼────────────────────────────────┼──────────────────────┤
│   1    │  Business & Management         │  Demande massive,    │
│        │  (HBR, HubSpot, Salesforce)   │  sources Gold dispo  │
├────────┼────────────────────────────────┼──────────────────────┤
│   2    │  Sciences (Khan + MIT Gold)    │  Déjà Silver,        │
│        │                               │  upgrade facile      │
├────────┼────────────────────────────────┼──────────────────────┤
│   3    │  Langues (British Council,    │  Marché gigantesque  │
│        │  Goethe, Alliance Française)  │  différenciateur     │
├────────┼────────────────────────────────┼──────────────────────┤
│   4    │  Finance                       │  High value,         │
│        │  (CFA, AMF, Banque de France) │  peu de concurrents  │
├────────┼────────────────────────────────┼──────────────────────┤
│   5    │  Arts & Créativité             │  Adobe, Canva        │
│        │                               │  sources intégrables │
└────────┴────────────────────────────────┴──────────────────────┘
```

---

**En résumé** : le problème que tu identifies est réel et bloquant. La solution n'est pas de modifier l'architecture d'ASCENT — elle est solide — mais d'**étendre systématiquement la cartographie des sources** à tous les domaines d'apprentissage humains, avec un **SQS adapté à chaque type de domaine**. Sans ça, ASCENT reste un excellent outil pour les développeurs, pas la promesse universelle qu'il est censé tenir.
## A.3 — BRAIN — Professeur Cognitif Complet

```
┌─────────────────────────────────────────────────────────────────┐
│  VISION COMPLÈTE (mise à jour)                                  │
│  BRAIN n'est pas un chatbot.                                   │
│  C'est un professeur qui connaît exactement                    │
│  où en est l'utilisateur et ce qu'il vient d'apprendre.       │
└─────────────────────────────────────────────────────────────────┘

CAPACITÉS COMPLÈTES :

  1. RÉPONSE CONTEXTUELLE
     → Connaît le nœud actuel, le SMI par dimension
     → Connaît les sources utilisées pour ce nœud
     → Calibre sa réponse au niveau Bloom actuel
     → Ne répond jamais hors contexte du parcours

  2. AUTO-SUGGESTIONS DE QUESTIONS
     → À chaque nœud, BRAIN génère automatiquement
       3 à 5 questions pertinentes que l'utilisateur
       devrait se poser mais ne pense pas à formuler
     → Questions classées par niveau Bloom
     → "Tu devrais aussi te demander..."
     → Cliquables directement pour lancer la réponse

  3. MODE SOCRATIQUE
     → Ne donne jamais la réponse directement
     → Pose des questions guidantes
     → Fait trouver la réponse à l'utilisateur
     → Déclenché automatiquement si :
       • L'user pose 3× la même question sur le même concept
       • Remediation Type 5 activée
       • Demande explicite de l'utilisateur

  4. MIROIR COGNITIF
     → BRAIN joue le rôle d'un débutant complet
     → L'utilisateur doit lui expliquer le concept
     → BRAIN pose des questions "naïves" calibrées
     → Score D5 (Enseignement) du SMI généré

  5. CONTEXTE INJECTÉ À CHAQUE ÉCHANGE
     → Nœud actuel (N8/25)
     → SMI actuel par dimension
     → Bloom level du nœud
     → Sources utilisées
     → Historique questions BRAIN sur ce nœud
     → Score dernier exercice
```

## A.4 — ASCENT Slides — Présentation Pédagogique

```
┌─────────────────────────────────────────────────────────────────┐
│  TEMPLATE PAR NŒUD (8-10 slides)                               │
├─────────────────────────────────────────────────────────────────┤
│  Slide 1  — Accroche : question + visuel impactant            │
│  Slide 2  — Le Problème : analogie monde réel                 │
│  Slide 3  — Le Concept : définition + code/formule            │
│  Slide 4  — Décomposition : step by step animé                │
│  Slide 5  — Exemple Concret : cas réel                        │
│  Slide 6  — Erreurs Communes : pièges à éviter                │
│  Slide 7  — Comparaison : vs autres approches                 │
│  Slide 8  — Résumé Visuel : mind map                          │
│  Slide 9  — Vérification : micro-quiz 3 questions             │
│  Slide 10 — Connexion : lien vers nœud suivant               │

MODES DE NAVIGATION :
  🎯 Rapide ────── 5 slides essentiels
  📚 Standard ──── 10 slides complets
  🔬 Approfondi ── 15 slides + sources + exemples extra

ADAPTATION SMI AUTOMATIQUE :
  Si D1 < 50 → slide révision prérequis ajoutée
  Si D3 < 50 → 2 exemples supplémentaires ajoutés
  Si D5 < 50 → slide "comment l'expliquer à quelqu'un"

INTERACTIVITÉ PAR SLIDE :
  [▶ Voir dans la vidéo source] ← timestamp intelligent
  [💬 Poser une question BRAIN]
  [📝 Prendre une note]
  [⚡ Créer une flashcard]

GÉNÉRATION VISUELLE :
  MVP ──── Mermaid.js + D3.js + Prism.js (coût 0$)
  V2 ───── Stable Diffusion / DALL-E 3 (~0.04$/image)
  LT ───── Bibliothèque 10 000 illustrations réutilisables
```

## A.5 — Timestamps Intelligents Vidéo

```
FONCTIONNEMENT :
  → Ingestion YouTube : transcript découpé par timestamp
  → Chaque concept extrait lié à son timestamp exact
  → Dans le nœud : bouton [▶ Voir à 12:34]
  → Clic → vidéo démarre exactement au bon moment

TABLE : scy_content_timestamps
  ├── content_hash
  ├── concept_id
  ├── timestamp_start (secondes)
  ├── timestamp_end (secondes)
  └── relevance_score (0.0 à 1.0)

REDIRECTION SOURCES NON-EMBED :
  → Deep Link avec Context Card
  → "SCY Forge a extrait les points clés pour toi"
  → [Ouvrir dans nouvel onglet]
  → Détection de retour : "Tu as regardé la vidéo ?"
  → Adaptation de l'exercice selon la réponse
```

## A.6 — ASCENT Software Sprint

```
┌─────────────────────────────────────────────────────────────────┐
│  PRINCIPE FONDATEUR                                             │
│  Loi de Pareto appliquée au logiciel :                        │
│  20% des fonctionnalités = 80% des usages réels              │
│  Résultat : opérationnel sur le cœur en 3-5 jours            │
└─────────────────────────────────────────────────────────────────┘

ARCHITECTURE EN 2 PHASES :

  PHASE 1 — TRONC COMMUN (Jours 1-4, obligatoire)
  → 18-25 nœuds maximum
  → 1 nœud = 1 workflow réel dans le logiciel
  → SMI ≥ 70/100 = déclaré OPÉRATIONNEL

  PHASE 2 — BRANCHES MÉTIER (à la demande)
  → Dialogue BRAIN : "Je suis hydrologue"
  → DAG de 8-12 nœuds généré instantanément
  → S'appuie sur le tronc commun déjà maîtrisé
  → Chaque logiciel = N branches selon les métiers

3 PILIERS VISUELS :

  PILIER 1 — Slides + Screenshots annotés
  → Boites rouges sur les clics
  → Flèches sur les menus
  → Labels sur les panneaux

  PILIER 2 — Documentation officielle = Source Gold prioritaire
  → SQS Autorité : 40 pts (vs 30 autres domaines)
  → Coefficient fraîcheur ×3.0
  → Vérification version explicite dans chaque nœud
  → Crawler surveille les changelogs

  PILIER 3 — Bibliothèque visuelle versionnée
  TABLE scy_software_assets :
  ├── software_id
  ├── version
  ├── workflow_id
  ├── screenshot_url (CDN)
  ├── annotations JSON
  ├── source_doc_url
  └── last_validated_date

RÈGLE LÉGALE :
  Tous les screenshots sont GÉNÉRÉS par SCY Forge
  Jamais scrapés → propriété intellectuelle propre

VALIDATION SPÉCIALE LOGICIEL :
  → User upload screenshot de son résultat
  → GPT-4o Vision compare au résultat attendu
  → Validation objective, pas déclarative

PIPELINE DE CRÉATION (5-7 jours par logiciel) :
  Étape 1 : Parser docs officielles → identifier workflows fondamentaux
  Étape 2 : Cartographie 80/20 via IA
  Étape 3 : Génération visuelle (VM + script + capture)
  Étape 4 : Génération slides avec screenshots annotés
  Étape 5 : Exercice pratique + validation GPT-4o Vision

MVP MANUEL (avant automatisation) :
  → Screenshots faits à la main
  → Annotations dans Figma
  → 2-4 semaines par logiciel
  → Automatisation progressive après validation du modèle

DOMAINES CIBLÉS :
  SIG & Télédétection  : QGIS, ArcGIS Pro, ENVI, GRASS GIS
  CAO & Ingénierie     : AutoCAD, SolidWorks, CATIA, FreeCAD
  Développement        : VS Code + Git, IntelliJ, Docker
  DevOps               : Kubernetes, Terraform, Jenkins
  3D & Créatif         : Blender, Cinema 4D, Figma, Adobe XD
  Data Science         : Jupyter, RStudio, MATLAB, Tableau
  ERP & Business       : SAP, Salesforce, HubSpot CRM
  Électronique         : KiCad, Altium, MATLAB/Simulink
```

## A.7 — Goals Prédéfinis + Preuve Sociale

```
┌─────────────────────────────────────────────────────────────────┐
│  DÉFINITION                                                     │
│  Parcours ASCENT complets construits de A à Z par SCY Forge.  │
│  Validés par experts. Testés sur utilisateurs réels.          │
│  L'utilisateur clique "Commencer". Friction zéro.             │
└─────────────────────────────────────────────────────────────────┘

DONNÉES AFFICHÉES (page du Goal) :
  → Titre + description compétence visée
  → Durée estimée (jours + min/jour)
  → Nœuds / milestones / projet final
  → Certification + alignement standard officiel
  → Nombre de complétions (temps réel)
  → SMI moyen obtenu
  → Taux de certification
  → Satisfaction moyenne
  → Durée médiane réelle
  → Témoignages (prénom, statut pro, SMI obtenu)
  → Progression typique semaine par semaine
  → Prérequis avec SMI requis
  → Branches spécialisation disponibles (logiciels)

BLOC "EN CE MOMENT" (pour user en cours) :
  → X personnes apprennent ce Goal maintenant
  → Y personnes ont complété cette semaine
  → Z apprenants au même nœud aujourd'hui

PROCESSUS DE CRÉATION ET VALIDATION :
  Phase 1 : Génération IA (sources Gold SQS ≥ 80)
  Phase 2 : Validation expert humain (2-3 jours)
  Phase 3 : Beta test 50 utilisateurs (gratuit)
  Phase 4 : Publication avec données réelles
  Phase 5 : Amélioration continue automatique
             → SMI moyen nœud < 55 → contenu revu
             → Abandon massif → remédiation ajoutée
             → Sources obsolètes → mise à jour auto

CATALOGUE INITIAL :
  Tech    : Python, SQL, Data Science, Rust async,
            Docker + Kubernetes, AWS Cloud Practitioner
  Marketing: Google Ads, SEO 2025, Social Media,
             Email Marketing, Excel/Sheets avancé
  Finance : Finance perso, Comptabilité, Créer entreprise
  Soft    : Prise de parole, Management, Négociation,
            Productivité personnelle
  Langues : Anglais Business B2, Espagnol A2
  Software: QGIS, Blender, VS Code + Git, Docker
```

## A.8 — Source Quality Score (SQS) — Complet

```
CRITÈRES DE SCORING :

  Autorité          0-40 pts (logiciels) / 0-30 pts (autres)
  Fraîcheur         0-25 pts × coefficient domaine
  Pédagogie         0-25 pts
  Validation comm.  0-20 pts
  Pertinence domaine 0-15 pts (nouveau critère)

COEFFICIENTS FRAÎCHEUR PAR DOMAINE :
  Logiciel / Tech IA    ×3.0
  Cloud / Web / Sécu    ×2.0
  Business / Management ×1.2
  Sciences exactes      ×0.8
  Langues               ×0.5
  Humanités / Culture   ×0.0

SEUILS :
  SQS ≥ 80  → Gold   → utilisée sans restriction
  SQS 60-79 → Silver → utilisée avec mention
  SQS 40-59 → Bronze → utilisée en complément
  SQS < 40  → Rejetée

RÈGLE DE COUVERTURE :
  Avant tout Goal : couverture domaine ≥ 85%
  Minimum 3 sources Gold (SQS ≥ 80)
  Si < 85% → ASCENT refuse de démarrer
# SCY FORGE — DOCUMENTATION FEATURES & STRATÉGIE
# Analyse et Recommandations Stratégiques

## Diagnostic du problème identifié

Tu soulèves un point critique qui est en **contradiction directe** avec la promesse centrale d'ASCENT.

```
┌─────────────────────────────────────────────────────────────────┐
│                    LE PROBLÈME RÉEL                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  CONSTAT :                                                      │
│  Les sources actuellement cartographiées couvrent              │
│  quasi-exclusivement les domaines TECH                         │
│                                                                  │
│  Google Developers → Tech                                      │
│  AWS Training → Tech                                           │
│  Microsoft Learn → Tech                                        │
│  Kubernetes → Tech                                             │
│  Rust Book → Tech                                              │
│  MDN → Tech                                                    │
│  Linux Foundation → Tech                                       │
│                                                                  │
│  CONSÉQUENCE DIRECTE :                                         │
│  ASCENT ne peut tenir sa promesse que pour                     │
│  ~15% des objectifs d'apprentissage humains                    │
│                                                                  │
│  Un utilisateur qui veut maîtriser :                          │
│  → La négociation commerciale → Pas de sources Gold           │
│  → La prise de parole en public → Pas de sources Gold         │
│  → La gestion financière → Pas de sources Gold                │
│  → Le management d'équipe → Pas de sources Gold               │
│  → Une langue étrangère → Pas de sources Gold                 │
│                                                                  │
│  ASCENT lui dirait : "Sources insuffisantes (< 85%)"          │
│  Et refuserait de démarrer.                                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Cartographie complète — Ce qui manque

```
┌─────────────────────────────────────────────────────────────────┐
│         DOMAINES NON COUVERTS vs DEMANDE UTILISATEUR           │
├──────────────────────────┬──────────────────────────────────────┤
│  DOMAINE                 │  POURQUOI C'EST CRITIQUE            │
├──────────────────────────┼──────────────────────────────────────┤
│  Business & Management   │  50% des objectifs pros            │
│  Langues étrangères      │  Marché massif, universel           │
│  Sciences (Physique,     │  Étudiants, reconversions           │
│  Chimie, Biologie)       │                                     │
│  Arts & Créativité       │  Design, musique, écriture          │
│  Finance personnelle      │  Besoin universel                   │
│  Soft skills             │  Leadership, communication          │
│  Santé & Bien-être       │  Nutrition, sport, psychologie      │
│  Droit & Compliance      │  Entrepreneuriat, citoyenneté       │
│  Histoire & Philosophie  │  Culture générale, pensée critique  │
│  Mathématiques pures     │  Parcours académiques               │
└──────────────────────────┴──────────────────────────────────────┘
```

---

## Solution — Extension de la cartographie sources

### NIVEAU 1 GOLD — Domaines non-tech

```
┌─────────────────────────────────────────────────────────────────┐
│              SOURCES GOLD — BUSINESS & MANAGEMENT              │
├──────────────────────────────┬──────────────────────────────────┤
│  SOURCE                      │  DOMAINES COUVERTS              │
├──────────────────────────────┼──────────────────────────────────┤
│  Harvard Business School     │  Strategy, Leadership,          │
│  hbr.org (articles gratuits) │  Management, Finance            │
├──────────────────────────────┼──────────────────────────────────┤
│  Google Project Management   │  PM, Agile, Scrum,              │
│  (Coursera cert. gratuite)   │  Gestion de projet              │
├──────────────────────────────┼──────────────────────────────────┤
│  HubSpot Academy             │  Marketing, Vente,              │
│  academy.hubspot.com         │  CRM, Inbound                   │
├──────────────────────────────┼──────────────────────────────────┤
│  Salesforce Trailhead        │  CRM, Sales, Marketing          │
│  trailhead.salesforce.com    │  Cloud Business                 │
├──────────────────────────────┼──────────────────────────────────┤
│  Meta Blueprint              │  Social Media Marketing,        │
│  facebook.com/blueprint      │  Publicité digitale             │
└──────────────────────────────┴──────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│              SOURCES GOLD — LANGUES & COMMUNICATION            │
├──────────────────────────────┬──────────────────────────────────┤
│  SOURCE                      │  DOMAINES COUVERTS              │
├──────────────────────────────┼──────────────────────────────────┤
│  Duolingo for Schools        │  Langues (30+ langues)          │
│  schools.duolingo.com        │  Curriculum officiel            │
├──────────────────────────────┼──────────────────────────────────┤
│  Alliance Française          │  Français langue étrangère      │
│  ressources officielles      │  DELF/DALF préparation          │
├──────────────────────────────┼──────────────────────────────────┤
│  British Council             │  Anglais, IELTS, TOEFL          │
│  learnenglish.britishcouncil │  Business English               │
├──────────────────────────────┼──────────────────────────────────┤
│  Goethe Institut             │  Allemand, culture              │
│  goethe.de/ressources        │  Certifications officielles     │
└──────────────────────────────┴──────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│              SOURCES GOLD — SCIENCES & ACADÉMIQUE              │
├──────────────────────────────┬──────────────────────────────────┤
│  SOURCE                      │  DOMAINES COUVERTS              │
├──────────────────────────────┼──────────────────────────────────┤
│  Khan Academy                │  Maths, Physique, Chimie        │
│  (déjà Silver → upgrade Gold)│  Biologie, Économie             │
│  khanacademy.org             │  + Histoire, Grammaire          │
├──────────────────────────────┼──────────────────────────────────┤
│  MIT OpenCourseWare          │  Sciences exactes               │
│  (déjà Silver → upgrade Gold)│  Ingénierie, Économie           │
│  ocw.mit.edu                 │  Architecture, Urbanisme        │
├──────────────────────────────┼──────────────────────────────────┤
│  PubMed / NIH                │  Médecine, Biologie             │
│  pubmed.ncbi.nlm.nih.gov     │  Nutrition, Santé publique      │
├──────────────────────────────┼──────────────────────────────────┤
│  NASA Open Data              │  Astronomie, Physique           │
│  nasa.gov/learning-resources │  Sciences de la Terre           │
├──────────────────────────────┼──────────────────────────────────┤
│  WHO / OMS                   │  Santé, Nutrition               │
│  who.int/education           │  Épidémiologie, Médecine        │
└──────────────────────────────┴──────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│              SOURCES GOLD — FINANCE & ÉCONOMIE                 │
├──────────────────────────────┬──────────────────────────────────┤
│  SOURCE                      │  DOMAINES COUVERTS              │
├──────────────────────────────┼──────────────────────────────────┤
│  CFA Institute               │  Finance, Investissement        │
│  cfainstitute.org/resources  │  Analyse financière             │
├──────────────────────────────┼──────────────────────────────────┤
│  Banque de France            │  Économie, Finance perso        │
│  banque-france.fr/education  │  Gestion budgétaire             │
├──────────────────────────────┼──────────────────────────────────┤
│  AMF (Autorité Marchés Fin.) │  Investissement, Bourse         │
│  amf-france.org/education    │  Réglementation financière      │
├──────────────────────────────┼──────────────────────────────────┤
│  OCDE / PISA                 │  Économie mondiale              │
│  oecd.org/education          │  Politiques publiques           │
└──────────────────────────────┴──────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│              SOURCES GOLD — ARTS & CRÉATIVITÉ                  │
├──────────────────────────────┬──────────────────────────────────┤
│  SOURCE                      │  DOMAINES COUVERTS              │
├──────────────────────────────┼──────────────────────────────────┤
│  Adobe Education Exchange    │  Design, Photographie           │
│  edex.adobe.com              │  Vidéo, Motion Design           │
├──────────────────────────────┼──────────────────────────────────┤
│  Canva Design School         │  Design graphique               │
│  canva.com/learn/design-     │  Communication visuelle         │
│  school                      │  Brand identity                 │
├──────────────────────────────┼──────────────────────────────────┤
│  Berklee Online (gratuit)    │  Musique, Composition           │
│  online.berklee.edu/courses  │  Production musicale            │
│  (cours gratuits sélectifs)  │  Théorie musicale               │
├──────────────────────────────┼──────────────────────────────────┤
│  MoMA Learning               │  Histoire de l'art              │
│  moma.org/learn              │  Design, Architecture           │
└──────────────────────────────┴──────────────────────────────────┘
```

---

## Mise à jour du SQS — Paramètres par domaine

```
┌─────────────────────────────────────────────────────────────────┐
│         SOURCE QUALITY SCORE — AJUSTEMENTS PAR DOMAINE         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PROBLÈME DU SQS ACTUEL :                                      │
│  Le critère "Fraîcheur" pénalise injustement                   │
│  les domaines stables et académiques.                          │
│                                                                  │
│  Un cours de philosophie de Platon                             │
│  n'a pas besoin d'être mis à jour.                            │
│  Un manuel de physique de 3 ans reste valide.                  │
│                                                                  │
│  SOLUTION : SQS pondéré par type de domaine                    │
│                                                                  │
├──────────────────┬────────────────────────────────────────────  │
│  TYPE DOMAINE    │  PONDÉRATION CRITÈRE FRAÎCHEUR              │
├──────────────────┼──────────────────────────────────────────── │
│  Tech évolutif   │  ×2.0 (Cloud, IA, Frameworks)              │
│  (Cloud, IA,     │  Source > 1 an → pénalité forte            │
│  Web, Sécurité)  │                                             │
├──────────────────┼──────────────────────────────────────────── │
│  Business        │  ×1.2 (Management, Marketing)              │
│  & Management    │  Source > 3 ans → légère pénalité          │
├──────────────────┼──────────────────────────────────────────── │
│  Sciences        │  ×0.8 (Maths, Physique, Chimie)            │
│  exactes         │  Source > 5 ans → pénalité minime          │
├──────────────────┼──────────────────────────────────────────── │
│  Langues         │  ×0.5 (Grammaire, Littérature)             │
│  & Linguistique  │  Source > 10 ans → pas de pénalité         │
├──────────────────┼──────────────────────────────────────────── │
│  Humanités       │  ×0.0 (Histoire, Philo, Art)               │
│  & Culture       │  Fraîcheur non pertinente                  │
└──────────────────┴────────────────────────────────────────────  │
│                                                                  │
│  NOUVEAU CRITÈRE — Pertinence domaine (0-15 points)           │
│  ──────────────────────────────────────────────────            │
│  Source primaire du domaine (institution centrale) → 15 pts   │
│  Source secondaire reconnue (université)           → 10 pts   │
│  Source praticien expert                           →  7 pts   │
│  Source généraliste couvrant le domaine            →  3 pts   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Impact sur l'architecture ASCENT

```
┌─────────────────────────────────────────────────────────────────┐
│         CE QUI CHANGE DANS LA LOGIQUE ASCENT                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  DÉTECTION DU DOMAINE (nouveau module)                         │
│  ──────────────────────────────────────                         │
│  Quand l'user définit son objectif ASCENT :                   │
│  "Je veux maîtriser la négociation commerciale"               │
│                                                                  │
│  ASCENT classe automatiquement :                               │
│  → Domaine principal : Business / Soft Skills                 │
│  → Sous-domaine : Communication / Négociation                 │
│  → Type : Stable (pas tech évolutif)                          │
│  → Sources prioritaires : HBR, Coursera Business,            │
│                           Stanford negotiation, etc.          │
│  → SQS fraîcheur : pondéré ×1.0                              │
│                                                                  │
│  PUIS vérifie couverture ≥ 85%                                │
│  avec les sources du bon domaine                              │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ADAPTATION DES EXERCICES PAR DOMAINE                          │
│  ────────────────────────────────────                           │
│                                                                  │
│  Tech → Code à écrire + output vérifiable                     │
│  Business → Étude de cas + argumentation                      │
│  Langues → Production orale/écrite + correction               │
│  Sciences → Problèmes à résoudre + démonstration              │
│  Arts → Production créative + rubrique évaluation             │
│  Soft skills → Simulation de situation + feedback             │
│                                                                  │
│  Le SMI × 5 dimensions reste identique                        │
│  Seule la FORME des exercices change selon le domaine         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Mise à jour de la checklist ASCENT

```
┌─────────────────────────────────────────────────────────────────┐
│         CHECKLIST ASCENT — MISE À JOUR                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  SOURCES ✓                                                     │
│  ☐ Domaine détecté et classifié correctement                  │
│  ☐ Sources Gold du domaine spécifique disponibles             │
│  ☐ Couverture ≥ 85% avec sources adaptées au domaine         │
│  ☐ SQS fraîcheur pondéré selon type de domaine               │
│  ☐ Pas de contradictions non résolues                         │
│                                                                  │
│  CONTENU ✓                                                     │
│  ☐ Format des exercices adapté au domaine                     │
│  ☐ Analogies contextuellement pertinentes                     │
│  ☐ Exemples issus du vrai monde du domaine                   │
│  ☐ Progression Bloom respectée                                │
│                                                                  │
│  [Le reste des critères reste inchangé]                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Priorité d'implémentation recommandée

```
┌─────────────────────────────────────────────────────────────────┐
│              ORDRE LOGIQUE D'EXPANSION                         │
├────────┬────────────────────────────────┬──────────────────────┤
│  ORDRE │  DOMAINE                       │  RAISON              │
├────────┼────────────────────────────────┼──────────────────────┤
│   1    │  Business & Management         │  Demande massive,    │
│        │  (HBR, HubSpot, Salesforce)   │  sources Gold dispo  │
├────────┼────────────────────────────────┼──────────────────────┤
│   2    │  Sciences (Khan + MIT Gold)    │  Déjà Silver,        │
│        │                               │  upgrade facile      │
├────────┼────────────────────────────────┼──────────────────────┤
│   3    │  Langues (British Council,    │  Marché gigantesque  │
│        │  Goethe, Alliance Française)  │  différenciateur     │
├────────┼────────────────────────────────┼──────────────────────┤
│   4    │  Finance                       │  High value,         │
│        │  (CFA, AMF, Banque de France) │  peu de concurrents  │
├────────┼────────────────────────────────┼──────────────────────┤
│   5    │  Arts & Créativité             │  Adobe, Canva        │
│        │                               │  sources intégrables │
└────────┴────────────────────────────────┴──────────────────────┘
```

---

**En résumé** : le problème que tu identifies est réel et bloquant. La solution n'est pas de modifier l'architecture d'ASCENT — elle est solide — mais d'**étendre systématiquement la cartographie des sources** à tous les domaines d'apprentissage humains, avec un **SQS adapté à chaque type de domaine**. Sans ça, ASCENT reste un excellent outil pour les développeurs, pas la promesse universelle qu'il est censé tenir.
## A.3 — BRAIN — Professeur Cognitif Complet

```
┌─────────────────────────────────────────────────────────────────┐
│  VISION COMPLÈTE (mise à jour)                                  │
│  BRAIN n'est pas un chatbot.                                   │
│  C'est un professeur qui connaît exactement                    │
│  où en est l'utilisateur et ce qu'il vient d'apprendre.       │
└─────────────────────────────────────────────────────────────────┘

CAPACITÉS COMPLÈTES :

  1. RÉPONSE CONTEXTUELLE
     → Connaît le nœud actuel, le SMI par dimension
     → Connaît les sources utilisées pour ce nœud
     → Calibre sa réponse au niveau Bloom actuel
     → Ne répond jamais hors contexte du parcours

  2. AUTO-SUGGESTIONS DE QUESTIONS
     → À chaque nœud, BRAIN génère automatiquement
       3 à 5 questions pertinentes que l'utilisateur
       devrait se poser mais ne pense pas à formuler
     → Questions classées par niveau Bloom
     → "Tu devrais aussi te demander..."
     → Cliquables directement pour lancer la réponse

  3. MODE SOCRATIQUE
     → Ne donne jamais la réponse directement
     → Pose des questions guidantes
     → Fait trouver la réponse à l'utilisateur
     → Déclenché automatiquement si :
       • L'user pose 3× la même question sur le même concept
       • Remediation Type 5 activée
       • Demande explicite de l'utilisateur

  4. MIROIR COGNITIF
     → BRAIN joue le rôle d'un débutant complet
     → L'utilisateur doit lui expliquer le concept
     → BRAIN pose des questions "naïves" calibrées
     → Score D5 (Enseignement) du SMI généré

  5. CONTEXTE INJECTÉ À CHAQUE ÉCHANGE
     → Nœud actuel (N8/25)
     → SMI actuel par dimension
     → Bloom level du nœud
     → Sources utilisées
     → Historique questions BRAIN sur ce nœud
     → Score dernier exercice
```

## A.4 — ASCENT Slides — Présentation Pédagogique

```
┌─────────────────────────────────────────────────────────────────┐
│  TEMPLATE PAR NŒUD (8-10 slides)                               │
├─────────────────────────────────────────────────────────────────┤
│  Slide 1  — Accroche : question + visuel impactant            │
│  Slide 2  — Le Problème : analogie monde réel                 │
│  Slide 3  — Le Concept : définition + code/formule            │
│  Slide 4  — Décomposition : step by step animé                │
│  Slide 5  — Exemple Concret : cas réel                        │
│  Slide 6  — Erreurs Communes : pièges à éviter                │
│  Slide 7  — Comparaison : vs autres approches                 │
│  Slide 8  — Résumé Visuel : mind map                          │
│  Slide 9  — Vérification : micro-quiz 3 questions             │
│  Slide 10 — Connexion : lien vers nœud suivant               │

MODES DE NAVIGATION :
  🎯 Rapide ────── 5 slides essentiels
  📚 Standard ──── 10 slides complets
  🔬 Approfondi ── 15 slides + sources + exemples extra

ADAPTATION SMI AUTOMATIQUE :
  Si D1 < 50 → slide révision prérequis ajoutée
  Si D3 < 50 → 2 exemples supplémentaires ajoutés
  Si D5 < 50 → slide "comment l'expliquer à quelqu'un"

INTERACTIVITÉ PAR SLIDE :
  [▶ Voir dans la vidéo source] ← timestamp intelligent
  [💬 Poser une question BRAIN]
  [📝 Prendre une note]
  [⚡ Créer une flashcard]

GÉNÉRATION VISUELLE :
  MVP ──── Mermaid.js + D3.js + Prism.js (coût 0$)
  V2 ───── Stable Diffusion / DALL-E 3 (~0.04$/image)
  LT ───── Bibliothèque 10 000 illustrations réutilisables
```

## A.5 — Timestamps Intelligents Vidéo

```
FONCTIONNEMENT :
  → Ingestion YouTube : transcript découpé par timestamp
  → Chaque concept extrait lié à son timestamp exact
  → Dans le nœud : bouton [▶ Voir à 12:34]
  → Clic → vidéo démarre exactement au bon moment

TABLE : scy_content_timestamps
  ├── content_hash
  ├── concept_id
  ├── timestamp_start (secondes)
  ├── timestamp_end (secondes)
  └── relevance_score (0.0 à 1.0)

REDIRECTION SOURCES NON-EMBED :
  → Deep Link avec Context Card
  → "SCY Forge a extrait les points clés pour toi"
  → [Ouvrir dans nouvel onglet]
  → Détection de retour : "Tu as regardé la vidéo ?"
  → Adaptation de l'exercice selon la réponse
```

## A.6 — ASCENT Software Sprint

```
┌─────────────────────────────────────────────────────────────────┐
│  PRINCIPE FONDATEUR                                             │
│  Loi de Pareto appliquée au logiciel :                        │
│  20% des fonctionnalités = 80% des usages réels              │
│  Résultat : opérationnel sur le cœur en 3-5 jours            │
└─────────────────────────────────────────────────────────────────┘

ARCHITECTURE EN 2 PHASES :

  PHASE 1 — TRONC COMMUN (Jours 1-4, obligatoire)
  → 18-25 nœuds maximum
  → 1 nœud = 1 workflow réel dans le logiciel
  → SMI ≥ 70/100 = déclaré OPÉRATIONNEL

  PHASE 2 — BRANCHES MÉTIER (à la demande)
  → Dialogue BRAIN : "Je suis hydrologue"
  → DAG de 8-12 nœuds généré instantanément
  → S'appuie sur le tronc commun déjà maîtrisé
  → Chaque logiciel = N branches selon les métiers

3 PILIERS VISUELS :

  PILIER 1 — Slides + Screenshots annotés
  → Boites rouges sur les clics
  → Flèches sur les menus
  → Labels sur les panneaux

  PILIER 2 — Documentation officielle = Source Gold prioritaire
  → SQS Autorité : 40 pts (vs 30 autres domaines)
  → Coefficient fraîcheur ×3.0
  → Vérification version explicite dans chaque nœud
  → Crawler surveille les changelogs

  PILIER 3 — Bibliothèque visuelle versionnée
  TABLE scy_software_assets :
  ├── software_id
  ├── version
  ├── workflow_id
  ├── screenshot_url (CDN)
  ├── annotations JSON
  ├── source_doc_url
  └── last_validated_date

RÈGLE LÉGALE :
  Tous les screenshots sont GÉNÉRÉS par SCY Forge
  Jamais scrapés → propriété intellectuelle propre

VALIDATION SPÉCIALE LOGICIEL :
  → User upload screenshot de son résultat
  → GPT-4o Vision compare au résultat attendu
  → Validation objective, pas déclarative

PIPELINE DE CRÉATION (5-7 jours par logiciel) :
  Étape 1 : Parser docs officielles → identifier workflows fondamentaux
  Étape 2 : Cartographie 80/20 via IA
  Étape 3 : Génération visuelle (VM + script + capture)
  Étape 4 : Génération slides avec screenshots annotés
  Étape 5 : Exercice pratique + validation GPT-4o Vision

MVP MANUEL (avant automatisation) :
  → Screenshots faits à la main
  → Annotations dans Figma
  → 2-4 semaines par logiciel
  → Automatisation progressive après validation du modèle

DOMAINES CIBLÉS :
  SIG & Télédétection  : QGIS, ArcGIS Pro, ENVI, GRASS GIS
  CAO & Ingénierie     : AutoCAD, SolidWorks, CATIA, FreeCAD
  Développement        : VS Code + Git, IntelliJ, Docker
  DevOps               : Kubernetes, Terraform, Jenkins
  3D & Créatif         : Blender, Cinema 4D, Figma, Adobe XD
  Data Science         : Jupyter, RStudio, MATLAB, Tableau
  ERP & Business       : SAP, Salesforce, HubSpot CRM
  Électronique         : KiCad, Altium, MATLAB/Simulink
```

## A.7 — Goals Prédéfinis + Preuve Sociale

```
┌─────────────────────────────────────────────────────────────────┐
│  DÉFINITION                                                     │
│  Parcours ASCENT complets construits de A à Z par SCY Forge.  │
│  Validés par experts. Testés sur utilisateurs réels.          │
│  L'utilisateur clique "Commencer". Friction zéro.             │
└─────────────────────────────────────────────────────────────────┘

DONNÉES AFFICHÉES (page du Goal) :
  → Titre + description compétence visée
  → Durée estimée (jours + min/jour)
  → Nœuds / milestones / projet final
  → Certification + alignement standard officiel
  → Nombre de complétions (temps réel)
  → SMI moyen obtenu
  → Taux de certification
  → Satisfaction moyenne
  → Durée médiane réelle
  → Témoignages (prénom, statut pro, SMI obtenu)
  → Progression typique semaine par semaine
  → Prérequis avec SMI requis
  → Branches spécialisation disponibles (logiciels)

BLOC "EN CE MOMENT" (pour user en cours) :
  → X personnes apprennent ce Goal maintenant
  → Y personnes ont complété cette semaine
  → Z apprenants au même nœud aujourd'hui

PROCESSUS DE CRÉATION ET VALIDATION :
  Phase 1 : Génération IA (sources Gold SQS ≥ 80)
  Phase 2 : Validation expert humain (2-3 jours)
  Phase 3 : Beta test 50 utilisateurs (gratuit)
  Phase 4 : Publication avec données réelles
  Phase 5 : Amélioration continue automatique
             → SMI moyen nœud < 55 → contenu revu
             → Abandon massif → remédiation ajoutée
             → Sources obsolètes → mise à jour auto

CATALOGUE INITIAL :
  Tech    : Python, SQL, Data Science, Rust async,
            Docker + Kubernetes, AWS Cloud Practitioner
  Marketing: Google Ads, SEO 2025, Social Media,
             Email Marketing, Excel/Sheets avancé
  Finance : Finance perso, Comptabilité, Créer entreprise
  Soft    : Prise de parole, Management, Négociation,
            Productivité personnelle
  Langues : Anglais Business B2, Espagnol A2
  Software: QGIS, Blender, VS Code + Git, Docker
```

## A.8 — Source Quality Score (SQS) — Complet

```
CRITÈRES DE SCORING :

  Autorité          0-40 pts (logiciels) / 0-30 pts (autres)
  Fraîcheur         0-25 pts × coefficient domaine
  Pédagogie         0-25 pts
  Validation comm.  0-20 pts
  Pertinence domaine 0-15 pts (nouveau critère)

COEFFICIENTS FRAÎCHEUR PAR DOMAINE :
  Logiciel / Tech IA    ×3.0
  Cloud / Web / Sécu    ×2.0
  Business / Management ×1.2
  Sciences exactes      ×0.8
  Langues               ×0.5
  Humanités / Culture   ×0.0

SEUILS :
  SQS ≥ 80  → Gold   → utilisée sans restriction
  SQS 60-79 → Silver → utilisée avec mention
  SQS 40-59 → Bronze → utilisée en complément
  SQS < 40  → Rejetée

RÈGLE DE COUVERTURE :
  Avant tout Goal : couverture domaine ≥ 85%
  Minimum 3 sources Gold (SQS ≥ 80)
  Si < 85% → ASCENT refuse de démarrer

SOURCES GOLD PAR DOMAINE :
  [Voir documentation principale — Chapitre 6.3]
```

---
```

---

## 9. Implémentation Rust — Structures Clés

### 9.1 Cargo.toml — Dépendances Pipeline Agentique

```toml
[package]
name = "scy_forge-ascent-pipeline"
version = "1.0.0"
edition = "2021"

[dependencies]
# === RUNTIME ===
tokio = { version = "1.37", features = ["full", "rt-multi-thread"] }
async-trait = "0.1"
futures = "0.3"

# === LLM ===
liter_llm = "1.1"
tiktoken-rs = "0.6"

# === FSRS ===
fsrs = "0.6"

# === DAG ===
petgraph = "0.6"       # Validation + chemin critique

# === ML LOCAL ===
candle-core = "0.4"    # LLMLingua-2
ort = "1.16"           # GLiNER NER (ONNX)

# === VECTOR STORE ===
lancedb = "0.4"        # Cache sémantique

# === SEARCH ===
tantivy = "0.22"       # BM25

# === STATE MACHINE ===
# Typestate pattern (natif Rust, pas de crate externe)

# === EVENTS ===
dashmap = "5.5"        # EventBus concurrent
tokio-stream = "0.1"  # Reactive streams

# === SÉRIALISATION ===
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
uuid = { version = "1.8", features = ["v7"] }
chrono = "0.4"

# === PDF ===
typst = "0.11"
typst-pdf = "0.11"

# === MONITORING ===
tracing = "0.1"
opentelemetry = "0.22"

# === NOTIFICATIONS ===
reqwest = { version = "0.12", features = ["json"] }

[features]
full = ["all-agents"]
minimal = ["core-agents-only"]
```

### 9.2 Structure du Module Agentique

```
src/
├── ascent_pipeline/
│   ├── mod.rs                     # Pipeline principale + coordination
│   ├── agents/
│   │   ├── mod.rs
│   │   ├── goal_interpreter.rs    # Agent-01
│   │   ├── content_scout.rs       # Agent-02
│   │   ├── dag_architect.rs       # Agent-03
│   │   ├── learning_conductor.rs  # Agent-04 ← CERVEAU PRINCIPAL
│   │   ├── performance_analyzer.rs # Agent-05
│   │   ├── adaptive_router.rs     # Agent-06
│   │   ├── drift_guardian.rs      # Agent-07
│   │   ├── engagement_amplifier.rs # Agent-08
│   │   └── skill_certifier.rs     # Agent-09
│   ├── orchestrator.rs            # Coordinateur des 13 agents
│   ├── event_bus.rs               # Bus d'événements central
│   ├── state_machine.rs           # Typestate pattern ASCENT
│   ├── decision_engine.rs         # Algorithme de décision centralisé
│   └── models/
│       ├── learning_goal.rs
│       ├── competence_dag.rs
│       ├── smi_score.rs
│       ├── drift_signals.rs
│       └── proof_of_skill.rs
├── integrations/                  # Adapters vers les features existantes
│   ├── apex_adapter.rs            # → APEX/FSRS
│   ├── brain_adapter.rs           # → BRAIN/RAG
│   ├── cosmos_adapter.rs           # → COSMOS 8 modes
│   ├── imprint_adapter.rs         # → SCY-IMPRINT
│   ├── neuron_chain_adapter.rs    # → NEURON-CHAINS
│   └── ingestion_adapter.rs       # → 11 Ingestion Cores
```

---

## 10. Schéma Base de Données Évolué

### 10.1 Nouvelles Tables pour la Pipeline Agentique

```sql
-- Journal des décisions agentiques (observabilité complète)
CREATE TABLE scy_agent_decisions (
    id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id UUID NOT NULL REFERENCES scy_users(id),
    goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
    agent_name TEXT NOT NULL,              -- 'learning-conductor', 'adaptive-router'...
    decision_type TEXT NOT NULL,           -- 'standard_session', 'remediation', 'fast_track'...
    input_state JSONB NOT NULL,            -- État utilisateur au moment de la décision
    output_action JSONB NOT NULL,          -- Action décidée
    reasoning TEXT,                        -- Justification de la décision
    smi_at_decision REAL,
    execution_time_ms INTEGER,
    outcome TEXT,                          -- 'success', 'skipped', 'user_ignored'
    created_at INTEGER NOT NULL
);

-- Historique des interventions Drift Guardian
CREATE TABLE scy_drift_interventions (
    id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id UUID NOT NULL REFERENCES scy_users(id),
    goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
    signal_type TEXT NOT NULL,             -- 'inactivity', 'repeated_failures'...
    signal_data JSONB NOT NULL,            -- Détails du signal
    severity TEXT NOT NULL,               -- 'low', 'medium', 'high', 'critical'
    action_taken TEXT NOT NULL,
    message_sent TEXT,
    user_responded BOOLEAN,               -- L'user a-t-il réagi?
    resumed_within_hours INTEGER,         -- Combien d'heures après reprise
    created_at INTEGER NOT NULL
);

-- Proof of Skill certificates
CREATE TABLE scy_proof_of_skill (
    id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id UUID NOT NULL REFERENCES scy_users(id),
    goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
    certification_id TEXT UNIQUE NOT NULL, -- 'SCY-2026-06-08-REACT-84'
    
    -- Scores
    overall_smi REAL NOT NULL,
    retention_score REAL,
    depth_score REAL,
    mirror_score REAL,
    metacognition_score REAL,
    consistency_score REAL,
    
    -- Statistiques parcours
    total_days INTEGER,
    nodes_completed INTEGER,
    exercises_passed INTEGER,
    exercises_total INTEGER,
    cards_reviewed INTEGER,
    total_study_minutes INTEGER,
    max_streak_days INTEGER,
    imprint_sessions INTEGER,
    
    -- Exports
    pdf_url TEXT,
    linkedin_url TEXT,
    verification_url TEXT,
    
    -- Suggestions suivantes
    next_goals_suggested JSONB,
    
    earned_at INTEGER NOT NULL,
    created_at INTEGER NOT NULL
);

-- Routing adaptatif historique
CREATE TABLE scy_routing_history (
    id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id UUID NOT NULL REFERENCES scy_users(id),
    node_id UUID NOT NULL REFERENCES scy_ascent_nodes(id),
    routing_decision TEXT NOT NULL,       -- 'normal', 'fast_track', 'consolidation', 'remediation'
    smi_before REAL,
    smi_target REAL,
    additional_content_generated BOOLEAN DEFAULT false,
    strategy_changed BOOLEAN DEFAULT false,
    old_strategy TEXT,
    new_strategy TEXT,
    decided_at INTEGER NOT NULL
);

-- Gamification events
CREATE TABLE scy_gamification_events (
    id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id UUID NOT NULL REFERENCES scy_users(id),
    event_type TEXT NOT NULL,             -- 'xp_gained', 'badge_earned', 'level_up', 'streak'
    value INTEGER,                        -- XP gagnés, streak jours...
    badge_id TEXT,                        -- ID du badge si applicable
    metadata JSONB,
    created_at INTEGER NOT NULL
);

-- Scores gamification utilisateur
CREATE TABLE scy_user_gamification (
    user_id UUID PRIMARY KEY REFERENCES scy_users(id),
    total_xp INTEGER DEFAULT 0,
    current_level INTEGER DEFAULT 1,
    current_streak_days INTEGER DEFAULT 0,
    max_streak_days INTEGER DEFAULT 0,
    badges_earned TEXT[] DEFAULT '{}',
    last_activity_at INTEGER,
    updated_at INTEGER NOT NULL
);

-- Index performance
CREATE INDEX idx_agent_decisions_user_goal ON scy_agent_decisions(user_id, goal_id, created_at DESC);
CREATE INDEX idx_drift_interventions_user ON scy_drift_interventions(user_id, created_at DESC);
CREATE INDEX idx_proof_of_skill_user ON scy_proof_of_skill(user_id);
CREATE INDEX idx_routing_history_node ON scy_routing_history(node_id, decided_at DESC);
```

---

## 11. Communication Temps-Réel & UX Agentique

### 11.1 WebSocket — Events Temps-Réel vers le Frontend

```rust
/// Messages poussés en temps réel vers l'UI React
#[derive(Debug, Clone, Serialize)]
#[serde(tag = "type", rename_all = "snake_case")]
pub enum WsMessage {
    // Progression nœud
    SmiUpdate { node_id: Uuid, smi: f32, trend: String },
    NodeUnlocked { node_id: Uuid, name: String, celebration: bool },
    NodeCompleted { node_id: Uuid, name: String, time_saved_hours: Option<f32> },
    
    // Décisions agentiques (transparence)
    AgentDecision { agent: String, decision: String, reason: String },
    
    // APEX
    CardsReady { count: u32, estimated_minutes: u8 },
    RevisionDue { urgent: bool, overdue_count: u32 },
    
    // COSMOS
    KnowledgeGraphUpdated { new_nodes: u32, new_edges: u32 },
    
    // Engagement
    XpGained { amount: u32, total: u32 },
    BadgeEarned { badge_id: String, name: String, description: String },
    StreakUpdated { current: u32, milestone: Option<u32> },
    Celebration { level: String, confetti: bool, message: String },
    
    // Drift interventions
    DriftIntervention { severity: String, message: String, action_url: Option<String> },
    
    // Certification
    CertificationReady { proof_of_skill_id: Uuid, overall_smi: f32 },
    
    // Système
    AgentWorking { agent: String, task: String, progress_percent: u8 },
    Error { code: String, message: String, recoverable: bool },
}
```

### 11.2 UX — Transparence de l'Agent

L'utilisateur voit toujours ce que l'agent fait et pourquoi :

```
╔═══════════════════════════════════════════════════════════╗
║  🤖 LEARNING-CONDUCTOR — Ce que je fais pour toi         ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  ✅ Ce matin:                                             ║
║  • 5 révisions FSRS planifiées (rétention optimisée)     ║
║  • Exercice "useReducer" préparé (niveau adapté)         ║
║  • BRAIN contextuel activé pour ce nœud                  ║
║                                                           ║
║  🎯 Ton objectif aujourd'hui:                            ║
║  • Compléter le nœud "React Context" (SMI actuel: 62)   ║
║  • Cible: SMI 70 → 3 exercices + 8 révisions            ║
║                                                           ║
║  📈 En arrière-plan:                                     ║
║  • Drift Guardian: tout va bien, streak=5 jours 🔥      ║
║  • COSMOS KG: 3 nouveaux liens détectés                  ║
║  • Prochaine révision FSRS: dans 2h                      ║
║                                                           ║
║  [Commencer ma session] [Modifier les préférences]       ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
```

---

## 12. Métriques & Observabilité

### 12.1 KPIs Pipeline Agentique

```rust
pub struct AgentPipelineMetrics {
    // Efficacité agents
    pub goal_to_dag_time_p95_seconds: f64,   // Cible: < 600s (10min)
    pub content_scout_coverage_avg: f64,     // Cible: > 80% des nœuds couverts
    pub dag_validation_pass_rate: f64,       // Cible: > 95% sans retry
    
    // Performance apprentissage
    pub avg_smi_at_completion: f64,          // Cible: > 75/100
    pub ascent_completion_rate: f64,         // Cible: > 70%
    pub avg_days_to_completion: f64,         // vs estimation initiale
    pub remediation_success_rate: f64,       // % users qui récupèrent après drift
    
    // Engagement
    pub drift_intervention_response_rate: f64, // % users qui réagissent
    pub avg_streak_days: f64,               // Cible: > 7j
    pub imprint_trigger_rate: f64,          // % sessions avec IMPRINT
    
    // Économie
    pub tokens_saved_by_pipeline: f64,      // vs baseline sans optimisation
    pub cache_hit_rate_content_scout: f64,  // % sources déjà en cache
    
    // Qualité
    pub proof_of_skill_avg_smi: f64,        // Cible: > 78/100
    pub user_satisfaction_nps: f64,         // Cible: > 40
}
```

---

## Résumé — Ce que cette Architecture Change

```
SCY FORGE AVANT                        SCY FORGE APRÈS
────────────────────────────────────   ────────────────────────────────────
User pilote les features               Features pilotées par 13 agents

User ingère manuellement              CONTENT-SCOUT ingère automatiquement
User construit son parcours           DAG-ARCHITECT construit + valide
User choisit quoi réviser             LEARNING-CONDUCTOR décide et programme
User voit les stats passivement       PERFORMANCE-ANALYZER analyse + agit
User subit l'abandon                  DRIFT-GUARDIAN intervient avant
Motivation externe nécessaire         ENGAGEMENT-AMPLIFIER la crée
Compétence non vérifiable             SKILL-CERTIFIER la prouve + certifie

RÉSULTAT:                              RÉSULTAT:
"J'ai utilisé l'app"                  "J'ai ATTEINT la compétence"

Taux complétion: ~15% (industrie)     Taux complétion cible: >70%
Value Prop: "outil pratique"          Value Prop: "compétence garantie"
Différenciation: faible               Différenciation: UNIQUE sur le marché
```

---

**Document rédigé par** : Architecture Assistant — Arena.ai  
**Date** : 2026-06-08  
**Version** : 1.0  
**Confiance** : 97%  
**Statut** : ✅ PRÊT POUR IMPLÉMENTATION  
**Priorité** : 🔴 CRITIQUE — C'est ce qui transforme SCY Forge en produit irremplaçable

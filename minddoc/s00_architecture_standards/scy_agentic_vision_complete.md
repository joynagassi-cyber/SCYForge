<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Standards architecturaux — ajouter section beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🚀 SCY-FORGE — VISION AGENTIQUE TOTALE & INVENTAIRE COMPLET
**ID Document** : S00_AGENTIC_VISION_COMPLETE  
**Date** : 2026-06-26  
**Statut** : 🔴 DOCUMENT FONDATEUR — PRÉCÈDE TOUT CODAGE  

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

## 1. LE PRINCIPE FONDATEUR : "DÉCRIS ET L'AGENT FAIT TOUT"

> **SCY Forge n'est PAS une application où l'on clique sur des boutons.**
> **C'est une plateforme agentique où l'utilisateur DÉCRIT ce qu'il veut, et les agents ORCHESTRENT TOUT.**

### Le contraste avec les concurrents

| Plateforme | Expérience utilisateur | Problème |
|------------|----------------------|----------|
| **Notion** | L'utilisateur passe 2h à designer un template, place des blocs, configure des vues | Le template dort. Friction énorme. |
| **Obsidian** | L'utilisateur crée manuellement notes, liens, graphes, plugins | Volume énorme, tout devient dormant |
| **Anki** | L'utilisateur crée manuellement ses cartes, choisit quand réviser | Fastidieux, abandonment 85% |
| **NotebookLM** | L'utilisateur upload, pose des questions | Ne maintient pas la connaissance dans le temps |
| **SCY Forge** | L'utilisateur **parle** : « Je veux maîtriser React en 8 semaines » → **TOUT est automatisé** | ✅ Zéro friction |

### Le flux agentique idéal — Cyber Beachhead

```
SOC Manager : "Je veux onliner mon équipe SOC (5 analysts) sur MITRE ATT&CK"
     │
     ▼ (1 message, zéro clic)
     │
ASCENT-ORCHESTRATOR prend le relais :
     ├── Agent-01 : formalise l'objectif (org "Acme Corp", roles SOC L1/L2/DFIR)
     ├── Agent-02 : charge le pack Cyber MITRE ATT&CK (pré-ingéré, $0 LLM)
     │     └── Domain Pack Provider : SemanticTreeProvider::plant_tree("MITRE-ATT&CK-v14.1")
     ├── Agent-03 : construit les Role Subtrees (SOC L1: 6 tactics, SOC L2: 10, DFIR: 14)
     │     └── SemanticTreeProvider::graft_node() pour chaque tactic/technique
     ├── Agent-04 : propose le premier scénario d'évaluation (prêt à démarrer)
     │     └── Scenario: "APT29 Initial Access — Identify the Phishing Vector"
     ├── COSMOS : affiche automatiquement le Mission Tree (meilleur mode sélectionné)
     └── Tactical AI : « Votre équipe est prête. Commencez par le scénario APT29 ? »
     
     ↓ Le SOC Manager n'a RIEN fait d'autre que DÉCRIRE son besoin.
     ↓ Chaque analyste reçoit son onboarding en <5min après clic sur le lien.
```

> **[PIVOT-BEACHHEAD]** Ce flux diffère du flux générique original :
> - Pas d'ingestion de 11 cores (YouTube, Reddit, etc.) → **Pack MITRE pré-ingéré**
> - Pas de NEURON-CHAINS (génération LLM) → **Contenu pré-construit**
> - Pas de CHRONICLE (coéquipier quotidien) → **Tactical AI inline**
> - Pas de ARENA (roleplay Full-AI) → **Évaluations automatisées + Cyber Range (Phase 3)**

---

## 2. INVENTAIRE COMPLET — TOUTES LES FEATURES DE SCY FORGE

### 2.1 Les 18 Agents ASCENT

| Agent | Rôle | Automatisation |
|-------|------|----------------|
| **Agent-01** GOAL-INTERPRETER | Transforme un objectif naturel en plan formalisé | 100% auto (1 message user → plan prêt) |
| **Agent-02** CONTENT-SCOUT | Cherche, sélectionne, ingère les sources | 100% auto (parallèle multi-cores) |
| **Agent-03** DAG-ARCHITECT | Construit le graphe + déclenche génération | 100% auto |
| **Agent-04** LEARNING-CONDUCTOR | Orchestre chaque session d'apprentissage | 100% auto (règles Rust $0) |
| **Agent-05** PERFORMANCE-ANALYZER | Calcule SMI en continu (5 dimensions) | 100% auto ($0 LLM) |
| **Agent-06** ADAPTIVE-ROUTER | Route la progression (fast-track/normal/remédiation) | 100% auto ($0 LLM) |
| **Agent-07** DRIFT-GUARDIAN | Détecte l'abandon (8 signaux SHAP) + intervient | 100% auto (background) |
| **Agent-08** ENGAGEMENT-AMPLIFIER | Gamification (XP, badges, streaks, quêtes) | 100% auto |
| **Agent-09** SKILL-CERTIFIER | Certifie la compétence (Proof of Skill) | Auto au seuil + ARENA |
| **Agent-10** CHRONICLE | Knowledge Guardian Vivant (WhatsApp/push/in-app) | 100% auto (proactif) |
| **Agent-11** ARENA | Simulations pratiques Full-AI (roleplay) | Auto quand SMI ≥ 70 [Premium] |
| **Agent-12** VISUAL-CRITIC | Audit visuel COSMOS (intégrité géométrique) | 100% auto (gate) |
| **Agent-13** COGNITIVE-VALIDATOR | Calibration charge cognitive + Bloom | 100% auto (gate) |
| **Agent-14** DET-SUGGESTER | Suggestions de documents (<5ms, $0) | 100% auto |
| **Agent-15** AXIOMATIZER | Distille les traces en lois fondamentales | 100% auto (background async) |
| **Agent-16** HITL-PROXY-SME | Expert virtuel sceptique (audit scientifique) | 100% auto (gate Parcours B) |
| **Agent-17** WORK-MODE-DETECTOR | Détecte le mode de travail (Traditional/AI-Native) | Auto + détection comportementale |
| **Agent-18** CONSCIOUS-AGENT | Recherche web temps réel (contexte marché 2026) | Auto au démarrage parcours |

### 2.2 Le Comité ASCENT-QA (6 sous-agents)

| QA Agent | Rôle | Déclenchement |
|----------|------|---------------|
| **QA-01** Curriculum Designer | Cohérence/progression DAG | Auto après génération |
| **QA-02** Subject Matter Expert | Véracité technique (LaTeX, code, définitions) | Auto |
| **QA-03** Alignment Orchestrator | Couverture 100% syllabus (CEU/ECTS/CFA/AWS) | Auto |
| **QA-04** Cognitive Load Guarantor | Densité (Sweller), "1 idée = 1 bloc", ELI5 | Auto |
| **QA-05** Content Validator | Clarté, markdown, LaTeX, calcul PQS | Auto |
| **QA-06** Academic Certifier | Alignement constructif (Biggs) cours↔examen | Auto |

### 2.3 Les 8 Services Transverses

| Service | Rôle | Consommateurs |
|---------|------|---------------|
| **NEURON-CHAINS** | Génération (7 chaînes + 18 tools + APEX-AGENT) | ASCENT, APEX, IMPRINT, Normal Mode, BRAIN, Reader Suite, ARENA, QA |
| **APEX/FSRS** | Rétention mémoire (FSRS 5.0, 10 cartes, SMI) | ASCENT ag03-10, COSMOS, IMPRINT, Normal Mode, Reader, Teach-Back |
| **COSMOS** | Visualisation (26 modes + 12 engines + WebGPU) | ASCENT, APEX, BRAIN, Reader Suite, Normal Mode, DAG Display |
| **BRAIN** | RAG + Assistant (Triple Retrieval, Professor AI) | ASCENT ag01/04/06, APEX Teach-Back, CHRONICLE, Reader, ARENA |
| **INGESTION** | 13 cores sources + Web Search Engine V2 | ASCENT ag02, Normal Mode, B2B, NEURON-CHAINS, COSMOS, BRAIN |
| **READER SUITE** | Lecture enrichie (File/Web Viewer, Book Orch.) | COSMOS deep links, APEX deep links, Citations, BRAIN |
| **IMPRINT** | Mémorisation profonde (CRE 5 crans, vocabulaire) | ASCENT ag04 trigger, APEX leech, Reader inline |
| **EventBus** | Communication inter-services (pub/sub) | TOUS |

### 2.4 Les Features Premium

| Feature | Rôle | Automatisation |
|---------|------|----------------|
| **ARENA** (Agent-11) | Roleplay Full-AI (vente, management, médecine...) | Auto quand SMI ≥ 70 + Stability ≥ 3.0 |
| **CHRONICLE** (Agent-10) | Knowledge Guardian Vivant (7 piliers, humilité) | 100% proactif (WhatsApp/Telegram/push) |
| **HSM Persona** (ARENA) | Machine à états hiérarchique pour personas | 100% auto (-40% tokens via cache) |
| **Proof of Skill ARENA** | Certification pratique supérieure | Auto après ARENA score ≥ 70 |
| **Conscious Agent** | Recherche web temps réel (marché 2026) | Auto au démarrage + veille 30j |

### 2.5 Les Features Transverses

| Feature | Rôle |
|---------|------|
| **Citation Sourcing** | Citations [1][2] superscript cliquables + preview + deep links |
| **Deep Links Unifiés** | Navigation vers position exacte (timestamp/page/paragraphe) |
| **PIVOTIQ** | Réconciliation multi-sources contradictoires |
| **Generative-Canvas (FlowSeek)** | Diagrammes animés live dans slides/pages cours |
| **Multi-View Toggles** | Bascule Math/Sémantique/Code/Graphique/Diagramme (Notion-style) |
| **MindGraph MCP Server** | Requêtes SQL CTE sur COSMOS (-4.5× tokens) |
| **Gap Detection** | Prérequis manquants (nœuds rouges COSMOS) |
| **Auto-Graph** | Connexions automatiques cosine > 0.75 |
| **AI Confidence System** | Badge confiance multi-signaux sur arêtes IA |
| **Double Validation Sceau** | Consensus doré IA ≥ 85% + Humain ≥ 90% |
| **Neural Ignition Reveal** | Cinématique d'ouverture 4 phases |
| **Semantic Lenses** | 4 lentilles (Temporelle/Épistémique/Émotionnelle/ASCENT) |
| **Reveal by Relevance** | Top 150 concepts pertinents contextuels |
| **Prescriptive Insights** | Max 3 recommandations actionnables (Rust $0) |

### 2.6 Les 3 Modes d'Orchestration

| Mode | Utilisateur dit... | Agents font... |
|------|-------------------|----------------|
| **ASCENT** | « Je veux maîtriser React en 8 semaines » | Tout : ingestion → DAG → génération → sessions → certification |
| **Normal** | « Ingère cette vidéo YouTube et fais-moi des cartes » | Ingestion → NEURON-CHAINS → APEX → COSMOS immédiat ($0 attente) |
| **B2B** | « Transforme ce manuel SOP en cursus pour mon équipe » | Ingestion → NEURON-CHAINS → QA audit → cohort dashboard |

---

## 3. COSMOS COMME CANVAS AGENTIQUE (pas juste des modes cliquables)

### Le problème actuel de la spécification COSMOS

Jusqu'ici, les 26 modes COSMOS sont décrits comme des **vues que l'utilisateur sélectionne** (dropdown, onglets). C'est l'approche classique (Notion, Obsidian). **Mais SCY Forge est agentique** — les modes COSMOS doivent pouvoir être **créés, lancés et configurés par les AGENTS**, pas seulement par l'utilisateur.

### 3.1 Comment un mode COSMOS est lancé — 3 voies

#### Voie 1 — Automatique (l'agent choisit le meilleur mode)
```rust
// Agent-03 ou Agent-04 sélectionne automatiquement le meilleur mode COSMOS
// selon le type de données et le contexte (D-COSMOS-012)

pub fn select_optimal_cosmos_mode(context: &LearningContext) -> CosmosMode {
    match context {
        // Structure hiérarchique → Sunburst
        c if c.structure == Hierarchical && c.chapter_count > 5 => CosmosMode::M10,
        // Beaucoup de concepts → Concept Map  
        c if c.concept_count > 20 => CosmosMode::M09,
        // Document chronologique → Timeline
        c if c.has_timeline_markers => CosmosMode::M06,
        // SMI bas → Radar lacunes
        c if c.user_smi_avg < 50.0 => CosmosMode::M14,
        // Réseau dense → Knowledge Graph
        c if c.relation_count > 50 => CosmosMode::M02,
        // Apprentissage actif → Knowledge Cards
        c if c.is_active_learning => CosmosMode::M25,
        _ => CosmosMode::M02, // défaut
    }
}
```

L'utilisateur ne choisit rien. L'agent **sait** quel mode est optimal.

#### Voie 2 — Conversationnelle (l'utilisateur décrit)
```
Utilisateur : « Montre-moi mes lacunes en React »
     │
     ▼
CHRONICLE / BRAIN : sélectionne automatiquement le Mode 14 (Radar Comparaison)
                     filtre sur le domaine React
                     affiche les axes SMI les plus faibles
                     → "Tu vois ? Rétention à 52% sur les Hooks. Le reste est au vert."
```

```
Utilisateur : « Montre-moi mon parcours comme une timeline »
     │
     ▼
Agent : bascule sur la vue Timeline Gantt
        → "Voilà tes 8 semaines. Tu es en Semaine 3. En avance sur useState."
```

#### Voie 3 — Manuelle (l'utilisateur clique — fallback)
L'utilisateur peut toujours sélectionner manuellement un mode via le sélecteur `[📋 Kanban] [🌳 Arbre] [⏱️ Gantt] [🕸️ Réseau]...`. Mais c'est le **fallback**, pas le défaut.

### 3.2 Le COSMOS Agent Visualizer — Comment les agents CRÉENT des visualisations

#### Concept : un agent peut **générer une visualisation COSMOS à la volée**

```rust
// Un agent peut demander à COSMOS de créer une visualisation spécifique
// sans que l'utilisateur n'ait à configurer quoi que ce soit.

pub struct CosmosVisualizationRequest {
    requested_by: AgentId,           // Quel agent demande
    mode: CosmosMode,                // Quel mode afficher
    data_filter: DataFilter,         // Filtrer les données (domaine, nœud, SMI...)
    layout_config: LayoutConfig,     // Configuration du layout
    annotation: Option<String>,      // Annotation/commentaire de l'agent
    auto_switch: bool,               // Basculer automatiquement l'UI vers cette vue
}

// Exemples d'utilisation par les agents :

// Agent-05 (PERFORMANCE-ANALYZER) : "Voici ton radar SMI"
cosmos.visualize(CosmosVisualizationRequest {
    requested_by: AgentId::PerformanceAnalyzer,
    mode: CosmosMode::M14,          // Radar
    data_filter: DataFilter::Domain("React"),
    annotation: Some("Rétention faible sur les Hooks. On bosse ça ?"),
    auto_switch: true,              // Bascule l'UI automatiquement
});

// Agent-07 (DRIFT-GUARDIAN) : "Voici les concepts qui meurent"
cosmos.visualize(CosmosVisualizationRequest {
    requested_by: AgentId::DriftGuardian,
    mode: CosmosMode::M07,          // Statistics (decay)
    data_filter: DataFilter::RetrievabilityBelow(0.5),
    annotation: Some("3 concepts en danger. 2 min pour les sauver ?"),
    auto_switch: true,
});

// CHRONICLE : "Voici ta santé cognitive globale"
cosmos.visualize(CosmosVisualizationRequest {
    requested_by: AgentId::Chronicle,
    mode: CosmosMode::M22,          // Semantic Zoom (vue macro)
    data_filter: DataFilter::All,
    annotation: Some("Ta base de connaissances globale. Les zones sombres = oubli."),
    auto_switch: true,
});

// Agent-03 (DAG-ARCHITECT) : "Voici ton roadmap"
cosmos.visualize(CosmosVisualizationRequest {
    requested_by: AgentId::DagArchitect,
    mode: CosmosMode::M04,          // Roadmap ASCENT
    data_filter: DataFilter::Goal("React"),
    annotation: Some("12 nœuds. Tu commences par useState."),
    auto_switch: true,
});
```

#### L'API COSMOS pour les agents

```typescript
// frontend_react/src/cosmos/CosmosAgentAPI.ts

export class CosmosAgentAPI {
  // Un agent demande à afficher une visualisation
  async visualize(request: CosmosVisualizationRequest): Promise<void> {
    // 1. Sélectionner le moteur de rendu approprié
    const engine = this.selectEngine(request.mode);
    
    // 2. Filtrer les données selon la requête
    const data = await this.filterData(request.data_filter);
    
    // 3. Charger le moteur (lazy-load si nécessaire)
    await this.loadEngine(engine);
    
    // 4. Rendre la visualisation
    this.render(engine, data, request.layout_config);
    
    // 5. Afficher l'annotation de l'agent (si présente)
    if (request.annotation) {
      this.showAgentAnnotation(request.requested_by, request.annotation);
    }
    
    // 6. Basculer l'UI automatiquement (si demandé)
    if (request.auto_switch) {
      this.switchToView(request.mode);
    }
  }
  
  // Un agent demande à COMPARER deux vues côte à côte
  async compare(modeA: CosmosMode, modeB: CosmosMode, filter: DataFilter): Promise<void> {
    // Exemple : Radar SMI (avant/après) côte à côte
  }
  
  // Un agent demande à ANIMER une transition entre deux modes
  async animateTransition(from: CosmosMode, to: CosmosMode): Promise<void> {
    // Exemple : transition fluide de Knowledge Graph → Sunburst
  }
  
  // Un agent demande à SURLIGNER des nœuds spécifiques
  async highlightNodes(nodeIds: UUID[], mode: CosmosMode): Promise<void> {
    // Exemple : CHRONICLE surligne les concepts en danger (rouge clignotant)
  }
  
  // Un agent demande à GÉNÉRER une nouvelle visualisation personnalisée
  async generateCustom(spec: VisualizationSpec): Promise<void> {
    // L'agent décrit ce qu'il veut visualiser en langage naturel
    // → le système crée une visualisation custom (React Flow + elkjs)
    // Exemple : "Montre-moi les dépendances entre mes cours React et mes cours Python"
  }
}
```

### 3.3 Les 26 Modes COSMOS — Comment Chacun est Lancé

| Mode | Nom | Lancé par l'agent quand... | Lancé par l'utilisateur quand... |
|------|-----|---------------------------|-------------------------------|
| **M00** | Base Knowledge Base | L'utilisateur ouvre COSMOS (défaut global) | Clic sur "Vue globale" |
| **M01** | Lexical Tags | Peu de concepts, structure plate | « Montre-moi par tags » |
| **M02** | Knowledge Graph | Nœuds avec relations (défaut projet) | « Montre-moi le graphe » |
| **M03** | MindMap | Structure arborescente (1 parent/nœud) | « Montre-moi en arbre » |
| **M04** | Roadmap ASCENT | DAG généré (auto Agent-03) | « Montre-moi mon parcours » |
| **M05** | Concepts Grid | Beaucoup de nœuds tabulaires | « Montre-moi en tableau » |
| **M06** | Timeline | Données chronologiques | « Montre-moi le calendrier » |
| **M07** | Statistics | Agent-05 veut montrer SMI | « Montre-moi mes stats » |
| **M08** | DataFlow | NEURON-CHAINS en cours d'exécution | « Montre-moi le pipeline » |
| **M09** | Concept Map | Concepts avec relations étiquetées | « Montre-moi les connexions » |
| **M10** | Sunburst | Taxonomie hiérarchique profonde | « Montre-moi par domaine » |
| **M11** | Treemap | Comparaison volume par sous-domaine | « Montre-moi la répartition » |
| **M12** | Chord | Relations bidirectionnelles entre concepts | « Montre-moi les croisements » |
| **M13** | Sankey | Trajectoires d'apprentissage | « Montre-moi les flux » |
| **M14** | Radar | Agent-05 veut montrer SMI 5D | « Montre-moi mon profil » |
| **M15** | Parallel Coords | Beaucoup de dimensions à filtrer | « Montre-moi les filtres » |
| **M16** | Heatmap | Matrice de corrélations | « Montre-moi les redondances » |
| **M17** | Argument Map | Débat/raisonnement logique | « Montre-moi les arguments » |
| **M18** | Causal Loop | Système dynamique avec feedback | « Montre-moi les causes » |
| **M19** | Circle Packing | Classification imbriquée | « Montre-moi les bulles » |
| **M20** | Arc Diagram | Dépendances ordonnées linéairement | « Montre-moi les arcs » |
| **M21** | Edge Bundling | Ontologie dense | « Montre-moi les faisceaux » |
| **M22** | Semantic Zoom | Base massive (exploration multi-échelle) | « Montre-moi tout / zoom » |
| **M23** | 3D Knowledge Space | Palais de mémoire (GPU requis) | « Mode 3D » |
| **M24** | Voronoi | Territoires de compétence | « Montre-moi mes territoires » |
| **M25** | Knowledge Cards | Apprentissage actif (dashboard spatial) | « Mode cartes » |
| **M26** *(thermodynamique)* | Temperature Graph | Vitalité synaptique (D-OPT-016) | « Montre-moi la température » |

> **Règle** : L'utilisateur PEUT demander n'importe quel mode en langage naturel (« montre-moi en arbre »). L'agent interprète et bascule. L'utilisateur ne JAMAIS avoir à connaître les numéros de mode.

---

## 4. ARENA — Le Monde des Simulations Pratiques

### 4.1 Ce qu'ARENA fait réellement

ARENA n'est pas juste un "quiz pratique". C'est un **monde simulé peuplé d'agents IA** qui incarnent des personnages réalistes pour confronter l'utilisateur à des situations professionnelles authentiques.

```
Utilisateur : « Je veux pratiquer la vente »
     │
     ▼ (zéro clic, l'agent fait tout)
     │
ARENA-ANALYZER :
     ├── Analyse les compétences apprises (nœuds ASCENT SMI ≥ 70)
     ├── Identifie le domaine pratique (vente, management, médecine...)
     └── Vérifie FSRS Stability ≥ 3.0 (D-OPT-051)
     │
     ▼
ARENA-PERSONA (Full-AI) :
     ├── Construit un personnage COMPLET :
     │   ├── Rôle (ex : "DSI PME tech, budget serré")
     │   ├── Psychologie profonde (motivations, peurs, style décision)
     │   ├── Résistances calibrées (Flow Theory : ni trop facile ni trop dur)
     │   ├── Triggers positifs (ce qui fait basculer la décision)
     │   └── État émotionnel dynamique (HSM, évolue en temps réel)
     │
     ▼
SESSION LIVE (20-30 min de roleplay) :
     ├── Le persona répond authentiquement (HSM mood score)
     ├── L'utilisateur interagit (chat vocal ou texte)
     ├── Le persona change d'humeur selon les réponses (Méfiant → Intéressé → Convaincu)
     └── Tout est transcrit pour le debrief
     │
     ▼
ARENA-EVALUATOR (debrief structuré) :
     ├── Score global (0-100)
     ├── Points forts (ex : "Reformulation parfaite de l'objection prix")
     ├── Opportunités manquées (ex : "N'as pas demandé le critère de décision")
     ├── Erreurs critiques (ex : "Monologue 45s sans question → persona décroché")
     └── Exercices générés automatiquement dans ASCENT (3 cartes APEX ciblées)
```

### 4.2 Les Domaines ARENA

| Domaine | Phase | Scénarios |
|---------|-------|-----------|
| **Vente & Négociation** | Phase 0 ✅ | Cold call, objection prix, closing, client mécontent |
| **Management & Leadership** | Phase 0 ✅ | Feedback difficile, conflit équipe, délégation |
| **Prise de Parole & Pitch** | Phase 1 | Pitch investisseur, présentation Board, TEDx |
| **Communication Médicale** | Phase 2 | Annonce diagnostic, patient non-compliant |
| **Pédagogie & Formation** | Phase 2 | Expliquer à un débutant, animer groupe hétérogène |
| **Musique & Arts** | Phase 3+ | Improvisation, performance, critique |

### 4.3 Le HSM Persona (D-OPT-008)

La machine à états hiérarchique garantit que le persona **ne dérive jamais** de son rôle :

```
États psychologiques (HSM) :
├── MÉFIANT (froid, bref, aucune offre sans reformulation)
├── INTÉRESSÉ (pose des questions, écoute)
├── CONVAINCU (ouvert, prêt à signer)
├── FERMÉ (coup court, fin de conversation)
└── EN COLÈRE (si l'utilisateur est irrespectueux)

Mood Score (-1.0 à +1.0) :
     -1.0 (hostile) ←──────────→ +1.0 (convaincu)
     
     Mis à jour après CHAQUE message utilisateur (classification sémantique ultra-rapide).
     Prompt envoyé au LLM = uniquement la consigne de l'état actif (pas le prompt complet).
     → Conserve 100% du Prompt Caching DeepSeek (-40% tokens/message).
```

### 4.4 Le Proof of Skill ARENA

```
Proof of Skill Standard   = Théorie ASCENT (SMI ≥ 70 tous nœuds)
Proof of Skill ARENA      = Théorie + Pratique (SMI ≥ 70 + Score ARENA ≥ 70)
                           → Badge distinct : "Compétence Vérifiée en Conditions Réelles"
                           → Visible sur certificat LinkedIn avec mention ARENA
```

---

## 5. LES FEATURES CRÉATIVES À LIBÉRER

### 5.1 Voice-First Learning (Apprentissage Vocal)

```
Utilisateur (en conduisant, micro casque) :
« Chronicle, apprends-moi les closures JavaScript pendant que je conduis »

CHRONICLE :
     ├── Sélectionne le nœud closures (SMI actuel : 45%)
     ├── Active 3 cartes APEX (B02 Définition, B04 Short Answer, B06 Analogie)
     └── Mode vocal TTS :
         « OK. Une closure, c'est une fonction qui se souvient des variables
          de l'endroit où elle a été créée. Même après que cet endroit ait disparu.
          Exemple : tu crées un compteur. La fonction compteur se souvient
          du nombre, même si tu sors de la fonction qui l'a créée.
         
          Question : à ton avis, pourquoi on appelle ça une "closure" ? »
         
Utilisateur : « Parce que ça ferme sur les variables ? »
         
CHRONICLE : « Exactement. Ça "clôt" l'accès aux variables du parent.
             Tu l'avais. Ça remonte à 85%. »

→ Aucun écran. Aucun clic. Apprentissage 100% vocal, mains-libbres.
```

### 5.2 Dream Session (Apprentissage Hypnagogique)

```
CHRONICLE (22h30, détecte le coucher) :
« Avant de dormir — 1 concept en 30 secondes ? 
 Le cerveau consolide la nuit. C'est gratuit. 
 Ou pas, tu dors aussi. »

Utilisateur : « Vas-y »

CHRONICLE :
« useEffect. Règle d'or : le cleanup tourne AVANT chaque re-render.
 Pas après. Avant. Dorms bien. »

→ Le concept est ciblé pour la consolidation hippocampale nocturne (D-OPT-048).
→ Le lendemain, R est 15-20% plus élevé que sans la Dream Session.
```

### 5.3 Cross-Domain Discovery (Découverte Inter-Domaine)

```
CHRONICLE (Variable Reward, 15% probabilité/session) :
« Tiens, pendant que tu révisais React...
 Ton concept "useEffect" ressemble étrangement à un concept Python 
 que tu connais : les "context managers" (__enter__/__exit__).
 
 Les deux gèrent un cycle de vie : setup → action → cleanup.
 Tu vois le lien ? »

→ L'utilisateur découvre des connexions inattendues entre ses domaines.
→ Auto-Graph (cosine > 0.75) crée l'arête cross-domain orange.
→ Augmente la motivation (curiosité, dopamine).
```

### 5.4 Learning Party (Session Collaborative) [Phase 3+]

```
Utilisateur : « Chronicle, organise une session de révision avec Marc et Sarah sur React »

CHRONICLE :
     ├── Invite Marc et Sarah (partage lien UUID)
     ├── Crée une session partagée (3 cartes chacun, tour par tour)
     ├── Mode compétition bienveillante (pas de classement forcé, SDT-G2)
     └── À la fin : « Tout le monde a amélioré son SMI. Sarah +12, Marc +8, toi +15. Bien. »

→ L'apprentissage devient social, sans la toxicité des leaderboards.
```

### 5.5 Concept Remix (Créativité Bloom Level 6)

```
Utilisateur : « Crée-moi quelque chose avec useEffect et les closures »

NEURON-CHAINS (chaîne GAMMA + niveau Bloom Create) :
« Challenge : écris un hook React personnalisé qui utilise une closure
 pour mémoriser l'historique des valeurs d'un state.
 
 Indice : useState stocke la valeur. Une closure peut stocker l'historique.
 
 Commence. Je te guide. »

→ Bloom Level 6 (Create). L'utilisateur CRÉE, pas juste consomme.
→ Si réussi : SMI dimension Profondeur boosté.
```

### 5.6 Real-World Project Generator

```
Utilisateur (fin de parcours ASCENT) : « Donne-moi un projet réel pour pratiquer »

Agent-09 + NEURON-CHAINS :
     ├── Génère un projet capstone contextualisé au domaine
     ├── Fournit : cahier des charges, contraintes, données, livrables attendus
     ├── grading rubric (critères d'évaluation)
     ├── Si Work Mode C (AI-Native) : inclut un contexte IA (ex : "l'IA propose X, trouve l'erreur")
     └── Soumission → évaluation LLM → Proof of Skill
```

---

## 6. LE PRINCIPE "ZERO FRICTION" APPLIQUÉ PARTOUT

### Table de friction par feature

| Feature | Friction actuelle (concurrents) | SCY Forge (agentique) |
|---------|-------------------------------|----------------------|
| Créer un parcours | Configurer manuellement modules, ordre, durée | **Dire « Je veux maîtriser X »** → Agent fait tout |
| Créer des cartes | Écrire manuellement recto/verso | **Automatique** (NEURON-CHAINS génère 12 cartes/nœud) |
| Choisir quand réviser | Ouvrir l'app, aller dans le deck, démarrer | **CHRONICLE propose au bon moment** (WhatsApp/push) |
| Visualiser son savoir | Choisir un mode, configurer filtres | **Agent sélectionne le meilleur mode automatiquement** |
| Trouver des sources | Chercher manuellement Google, copier URLs | **Agent-02 cherche et ingère automatiquement** (25 sources) |
| Comprendre un concept difficile | Relire, chercher sur Google | **Demander à BRAIN** (« explique-moi X simplement ») |
| Pratiquer une compétence | Pas de solution (ou quiz basique) | **ARENA simule un vrai scénario** (roleplay Full-AI) |
| Suivre sa progression | Regarder des stats complexes | **CHRONICLE dit où on en est** (« 78%, 3 concepts à sauver ») |
| Mémoriser en profondeur | Copier-coller, relire | **IMPRINT distille + écrit manuscrite** (auto-trigger) |
| Réviser en mobilité | Ouvrir l'app, naviguer | **CHRONICLE WhatsApp** (« réponds 1, 2 ou 3 ») |

### La Règle des 2 Clics

> **Toute action dans SCY Forge doit pouvoir être accomplie en ≤ 2 interactions utilisateur.**
> - 1 interaction = 1 message vocal/texte OU 1 clic
> - Si > 2 interactions → l'agent doit automatiser le reste
> - L'exception : les sessions actives (révision, Teach-Back, ARENA) qui sont volontairement immersives

---

## 7. MATRICE COMPLÈTE — QUI FAIT QUOI AUTOMATIQUEMENT

| L'utilisateur dit... | Agent(s) qui agissent | Services mobilisés | Résultat |
|---------------------|----------------------|-------------------|---------|
| « Je veux maîtriser React » | Agent-01→09, 14, 18 | INGESTION, NEURON, APEX, COSMOS, BRAIN | Parcours complet prêt en <20 min |
| « Ingère cette vidéo » | Agent-02 (Normal Mode) | INGESTION YouTube, NEURON, APEX, COSMOS | Cours + cartes + graphe immédiats |
| « Explique-moi useEffect » | BRAIN (Professor AI) | BRAIN RAG, NEURON (FlowSeek diagram) | Explication socratique + schéma animé |
| « Montre-moi mes lacunes » | Agent-05, CHRONICLE | COSMOS (Gap Detection + Radar M14) | Visualisation des faiblesses |
| « Pratique la vente » | Agent-11 (ARENA) | NEURON (scénario), BRAIN (questions), APEX (exos) | Simulation roleplay + debrief |
| « Rappelle-moi Redux » | CHRONICLE | APEX/FSRS (Resurrection), NEURON (Cran 5) | 3 cartes essentielles, 90s |
| « Crée un projet pour pratiquer » | Agent-09, NEURON | NEURON (Capstone) | Cahier des charges + rubric |
| « Comment je m'en sors ? » | CHRONICLE | APEX (Health Score), COSMOS (Stats) | Bulletin de santé sobre |
| « Compare React et Vue » | BRAIN + PIVOTIQ | INGESTION (search), PIVOTIQ (réconciliation) | Synthèse unifiée + contradictions |
| « Apprends-moi en conduisant » | CHRONICLE (Voice) | APEX (cartes TTS), BRAIN (réponses) | Session vocale mains-libres |
| « Transforme ce SOP en cursus » | B2B + QA Comité | INGESTION, NEURON, QA (PQS ≥ 88) | Cursus certifiable pour cohorte |

---

## 8. PROGRESSIVE AUTOMATION — Les 3 Niveaux de Contrôle

SCY Forge ne force JAMAIS un seul mode d'interaction. L'utilisateur choisit son niveau d'implication. Le mode agentique est puissant mais **le mode manuel reste TOUJOURS disponible**.

### 8.1 Les 3 Niveaux

| Niveau | Profil | Expérience | Exemple |
|--------|--------|-----------|---------|
| **🤖 Agentique** (option) | "Faites tout pour moi" | L'utilisateur décrit → l'agent fait tout → il valide | « Je veux maîtriser React » → parcours complet prêt |
| **🔀 Hybride** (DÉFAUT) | "Proposez, j'ajuste" | Agentique par défaut + reprise manuelle à tout moment | Agent génère le parcours → l'utilisateur ajuste/rejette/modifie |
| **🎛️ Manuel** (option) | "Je contrôle tout" | L'utilisateur clique, configure, sélectionne chaque étape | Il choisit ses sources, construit son DAG, sélectionne ses modes COSMOS |

### 8.2 Équivalent Manuel pour Chaque Feature Automatisée

| Feature | Mode Agentique | Mode Manuel (toujours disponible) |
|---------|---------------|----------------------------------|
| Mode COSMOS | Agent choisit le mode optimal | Dropdown `[📋][🌳][⏱️][🕸️]` toujours visible |
| Création DAG | Agent-03 génère automatiquement | Éditeur DAG manuel (ajouter/réordonner/supprimer nœuds) |
| Choix sources | Agent-02 cherche et ingère | Upload/URL manuel + suppression sources |
| Création cartes | NEURON-CHAINS (12/nœud) | Bouton "Créer carte" manuel (B01-B10) |
| Sessions révision | CHRONICLE propose au bon moment | Bouton "Réviser maintenant" toujours disponible |
| Routage ASCENT | Agent-06 décide (fast-track/remédiation) | Override manuel ("forcer mode normal") |
| Proof of Skill | Agent-09 déclenche au seuil | Bouton "Je veux me certifier" quand l'utilisateur veut |
| IMPRINT | Agent-04 déclenche (3 succès) | Bouton "Lancer IMPRINT" manuel |
| ARENA | Déclenché quand SMI ≥ 70 | Bouton "Pratiquer" (si prérequis Stability ≥ 3.0) |
| Mode COSMOS | Agent sélectionne (Radar/Stats/Roadmap...) | Sélecteur de mode toujours visible + recherche vocale |

### 8.3 Le Toggle Global d'Autonomie

```
⚙️ Paramètres > Autonomie Agentique

○ 🤖 Agentique maximal (l'agent décide tout, je valide simplement)
● 🔀 Hybride (l'agent propose, j'ajuste si besoin) ← DÉFAUT
○ 🎛️ Manuel (je contrôle tout, l'agent m'aide sur demande seulement)
```

**Granulaire** : l'utilisateur peut configurer l'autonomie par domaine :
- Ingestion : 🤖 Agentique (Agent-02 cherche tout seul)
- Création de cartes : 🎛️ Manuel (je veux écrire mes propres cartes)
- COSMOS : 🔀 Hybride (l'agent suggère mais je choisis)
- Sessions : 🤖 Agentique (CHRONICLE gère le timing)

### 8.4 La Règle d'Override

> **L'agent propose, l'utilisateur dispose.**
> L'agent n'impose JAMAIS une décision sans possibilité d'override.
> Toute automatisation a un bouton/bypass manuel.
> Si l'utilisateur rejette une suggestion de l'agent → l'agent s'adapte sans insister (Charte Humilité).

```typescript
// Chaque action agentique a un override manuel
interface AgentAction {
  automated: boolean;       // L'agent peut-il le faire automatiquement ?
  user_override: boolean;   // L'utilisateur peut-il refuser/modifier ?
  manual_alternative: boolean; // Y a-t-il un chemin manuel complet ?
}
// Toutes les actions : automated=true, user_override=true, manual_alternative=true
```

### 8.5 Détection du Niveau Préféré

Le système détecte progressivement si l'utilisateur préfère le mode agentique ou manuel :
- Si l'utilisateur **accepte souvent** les suggestions agentiques → propose de passer en Agentique maximal
- Si l'utilisateur **override souvent** → reste en Hybride ou suggère Manuel
- Si l'utilisateur **ne touche jamais** aux settings → reste Hybride (défaut)

---

## 9. CE QUI RESTE À IMAGINER (R&D Phase 3+)

| Idée | Concept | Phase |
|------|---------|-------|
| **AR Knowledge Overlay** | COSMOS en réalité augmentée (téléphone → voit le graphe sur son bureau) | Phase 4+ |
| **Biometric FSRS** | FSRS ajusté par rythme cardiaque / EEG (concentration réelle mesurée) | Phase 5 R&D |
| **Dream Replay** | CHRONICLE rejoue les concepts pendant le sommeil paradoxal (sons subliminaux) | Phase 5 R&D |
| **Collective Intelligence** | Les Axiomes (AGENT-15) de tous les users créent un cerveau global émergent | Phase 4 |
| **Skill DNA** | Profil unique d'apprentissage (comment TU apprends, pas les autres) | Phase 3 |
| **Knowledge Trading** | Marketplace où les users échangent des decks de cartes qualité | Phase 4 |
| **Live Mentor Matching** | SCY Forge connecte 2 users (un qui maîtrise, un qui apprend) en temps réel | Phase 4+ |
| **Emotional Learning** | Les cartes s'adaptent à l'humeur détectée (stressé → cartes douces, confiant → challenges) | Phase 3+ |

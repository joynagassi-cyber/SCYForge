**Principe fondateur** : *"La meilleure façon d'apprendre quelque chose est de l'enseigner"* — Feynman, 1985. STUDENT AI industrialise ce principe à l'échelle.

---

**### Concept Central**

L'utilisateur **enseigne à l'IA** ce qu'il vient d'apprendre, dans ses propres mots, sans structure imposée. L'IA joue le rôle d'un **élève calibré** : curieux, posant des questions naïves, détectant les incohérences, signalant les oublis — sans jamais corriger frontalement (pour ne pas interrompre le flux d'enseignement).

Ce n'est pas un quiz. Ce n'est pas un chatbot. C'est une **session d'enseignement inversée** où l'utilisateur devient le professeur et l'IA l'étudiant attentif.

---

**### Pourquoi c'est game-changer**

| Méthode classique | STUDENT AI |
|------------------|-----------|
| L'IA pose des questions → user répond | User explique librement → IA écoute et questionne |
| Évaluation binaire correcte/incorrecte | Détection nuancée : incohérences, lacunes, sur-simplifications |
| Feedback immédiat → mémorisation court terme | Enseignement actif → compréhension profonde durable |
| Format imposé (MCQ, QCM) | Format libre (l'user choisit comment expliquer) |
| Pénalise les erreurs | Révèle les zones d'ombre sans humilier |
| Calibre la rétention | Calibre la **compréhension réelle** |

**Fondation scientifique** :
- **Effet Protégé de Génération** (Slamecka & Graf, 1978) : Générer soi-même > recevoir = +40% rétention long terme
- **Peer Teaching Effect** (Roscoe & Chi, 2008) : Enseigner améliore la compréhension plus que réviser seul (+25-35%)
- **Interleaving Retrieval** (Kornell & Bjork, 2008) : Alterner rappel libre et questions → meilleur ancrage

---

**### Architecture STUDENT AI**

```
┌─────────────────────────────────────────────────────────────┐
│                    STUDENT AI SESSION                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  CONTEXTE INJECTÉ (invisible pour user) :                   │
│  • Contenu du nœud ASCENT actuel                           │
│  • Documents générés par NEURON-CHAINS (vérité de fond)    │
│  • SMI actuel (calibre l'exigence des questions)           │
│  • Concepts clés attendus (checklist interne)              │
│                                                              │
│  PERSONA IA (affiché à l'user) :                           │
│  "Je suis ton élève. Explique-moi [concept] comme si       │
│   j'étais quelqu'un qui ne sait rien. Je poserai des       │
│   questions si je ne comprends pas."                        │
│                                                              │
│  USER EXPLIQUE LIBREMENT                                    │
│       ↓                                                      │
│  STUDENT AI ANALYSIS ENGINE (Rust + LLM)                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  1. Concept Coverage Tracker                        │   │
│  │     → Quels concepts clés ont été mentionnés ?     │   │
│  │     → Lesquels sont absents ?                      │   │
│  │                                                     │   │
│  │  2. Coherence Detector                              │   │
│  │     → Contradictions internes dans l'explication ? │   │
│  │     → Confusion entre deux concepts proches ?      │   │
│  │                                                     │   │
│  │  3. Depth Evaluator                                 │   │
│  │     → Explication superficielle vs profonde ?      │   │
│  │     → Analogies utilisées ? Exemples concrets ?    │   │
│  │                                                     │   │
│  │  4. Misconception Detector                          │   │
│  │     → Croyances incorrectes détectées ?            │   │
│  │     → Généralisations abusives ?                   │   │
│  └─────────────────────────────────────────────────────┘   │
│       ↓                                                      │
│  QUESTIONS SOCRATIQUES GÉNÉRÉES                             │
│  (calibrées selon analyse, jamais correctrices)             │
│       ↓                                                      │
│  RAPPORT FINAL + RECALIBRATION FSRS                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

**### Features Détaillées**

**A — Déclenchement Contextuel**

- ✅ Déclenché automatiquement par Agent-04 (LEARNING-CONDUCTOR) après :
  - 5 révisions FSRS Good/Easy consécutives sur un concept
  - Fin d'un nœud ASCENT (avant de valider le passage au suivant)
  - SMI ≥ 65% (l'utilisateur pense maîtriser → bon moment de tester)
  - Sur demande explicite de l'utilisateur ("Je veux expliquer ce que j'ai compris")
- ✅ Interface dédiée (modal plein écran, pas d'interruptions)
- ✅ Durée suggérée : 3 à 10 minutes selon complexité nœud

**B — Persona STUDENT AI Adaptatif**

L'IA joue un rôle différent selon le domaine et le SMI :

| SMI actuel | Persona |
|-----------|---------|
| SMI < 40% | Élève très curieux, questions très basiques ("C'est quoi exactement ?") |
| SMI 40-70% | Étudiant qui suit, pose des questions de clarification ("Attends, ça veut dire que...?") |
| SMI 70-85% | Collègue junior, questions techniques ("Et dans ce cas-là, ça fait quoi ?") |
| SMI ≥ 86% | Pair expert, questions challengeantes ("Tu ne serais pas en train de confondre avec X ?") |

- ✅ Persona adapté au domaine :
  - Tech → Collègue dev curieux
  - Business → Stagiaire brillant
  - Académique → Doctorant d'une autre spécialité
  - Médecine → Étudiant en médecine en 3e année
  - Spirituel → Membre de la communauté attentif

**C — Analysis Engine (Rust + LLM, invisible)**

L'engine analyse en temps réel ce que l'utilisateur dit sans le lui montrer.

```rust
pub struct TeachBackAnalysis {
    // Concepts clés du nœud qui doivent apparaître
    expected_concepts: Vec<String>,
    // Concepts effectivement mentionnés par l'user
    mentioned_concepts: Vec<String>,
    // Incohérences détectées
    coherence_issues: Vec<CoherenceIssue>,
    // Profondeur d'explication
    depth_score: f32,  // 0.0-1.0
    // Misconceptions détectées
    misconceptions: Vec<Misconception>,
    // Questions socratiques à poser
    socratic_questions: Vec<SocraticQuestion>,
}

pub enum CoherenceIssue {
    // "Tu viens de dire A puis juste après tu as dit le contraire"
    Contradiction { first_claim: String, second_claim: String },
    // "Tu confonds deux concepts distincts"
    ConceptConfusion { concept_a: String, concept_b: String },
    // "Tu as défini X, mais ton explication ne correspond pas à ta définition"
    DefinitionMismatch { definition: String, usage: String },
}

pub struct SocraticQuestion {
    // Type de question (jamais corrective)
    question_type: QuestionType,
    question_text: String,
    // Concept ciblé par la question
    targets_concept: String,
    // Timing optimal (après quelle partie de l'explication)
    trigger_after: String,
}

pub enum QuestionType {
    Clarification,      // "Quand tu dis X, tu veux dire... ?"
    Extension,          // "Et dans le cas de Y, ça donne quoi ?"
    ConcreteExample,    // "Tu peux me donner un exemple concret ?"
    EdgeCase,           // "Qu'est-ce qui se passe si... ?"
    WhyQuestion,        // "Pourquoi est-ce que c'est comme ça ?"
    AnalogyClarification, // "C'est un peu comme Z, c'est ça ?"
}
```

**D — Détection des Lacunes Sans Humilier**

L'IA ne dit jamais "Tu as tort" ou "Tu oublies quelque chose". Elle pose des questions qui *naturellement* amènent l'utilisateur à réaliser lui-même ce qu'il manque.

*Exemples de questions STUDENT AI :*

```
Lacune détectée : L'utilisateur n'a pas mentionné le "learning rate"
→ STUDENT AI : "Super ! Mais dis-moi... quand tu dis que le modèle 'apprend',
  il apprend à quelle vitesse ? Est-ce qu'il y a un paramètre qui contrôle ça ?"

Incohérence détectée : L'user dit "gradient descent descend toujours" 
                      puis "parfois ça monte"
→ STUDENT AI : "Attends, j'ai du mal à suivre. Tu as dit que ça descend 
  toujours, mais après tu as dit que parfois ça monte. 
  Comment les deux sont possibles en même temps ?"

Misconception : L'user confond overfitting et underfitting
→ STUDENT AI : "Mmh intéressant. Donc si je comprends bien, un modèle qui 
  mémorise trop les données d'entraînement, il sera mauvais sur 
  de nouvelles données ? C'est bien ça le problème ?"
  [→ l'user se rend compte lui-même de la distinction]
```

**E — Rapport de Session Teach-Back**

Après chaque session, un rapport privé (visible uniquement par l'user) :

```markdown
## 📊 Rapport Teach-Back — "Gradient Descent"

**Durée** : 7 minutes 32 secondes
**Concepts couverts** : 7/9 (78%)

### ✅ Concepts bien expliqués
- Définition gradient descent ✅
- Direction opposée au gradient ✅
- Fonction de coût ✅
- Convergence locale ✅

### ⚠️ Concepts non mentionnés
- **Learning rate** → Zone d'ombre identifiée
- **Batch size** → Non abordé

### 🔴 Incohérences détectées
- Tu as dit que le gradient descent "descend toujours" 
  puis évoqué un cas où "ça peut remonter" → À clarifier

### 💡 Qualité d'explication
- Analogies utilisées : 2 (bonne pratique ✅)
- Exemples concrets : 1 (peut mieux faire)
- Profondeur : 6/10

### 🔧 Impact sur FSRS
- "Learning rate" : Interval réduit -40% → carte remontée en priorité
- "Batch size" : Nouvelles cartes créées automatiquement
- "Gradient direction" : Stability boostée +15% (bien expliqué)
```

**F — Recalibration FSRS depuis l'enseignement**

C'est **la feature la plus innovante** : les performances lors du Teach-Back **recalibrent les paramètres FSRS** de façon plus précise que les révisions classiques.

```rust
pub fn recalibrate_fsrs_from_teachback(
    analysis: &TeachBackAnalysis,
    current_fsrs_states: &mut Vec<CardFsrsState>,
) {
    for card in current_fsrs_states.iter_mut() {
        let concept = &card.associated_concept;
        
        // Concept bien expliqué → boost Stability
        if analysis.mentioned_concepts.contains(concept) 
            && analysis.depth_score > 0.7 {
            card.stability *= 1.15;  // +15% durée avant prochain rappel
        }
        
        // Concept non mentionné → réduire interval
        if !analysis.mentioned_concepts.contains(concept) {
            card.stability *= 0.60;  // Revue beaucoup plus tôt
            card.scheduled_days = 1; // Dès demain
        }
        
        // Incohérence sur ce concept → reset quasi-complet
        if analysis.coherence_issues.iter()
            .any(|issue| issue.involves_concept(concept)) {
            card.stability *= 0.30;  // Presque relearning
            card.lapses += 1;
        }
        
        // Misconception → flag leech potentiel + remediation
        if analysis.misconceptions.iter()
            .any(|m| m.affects_concept(concept)) {
            card.is_flagged_for_remediation = true;
            // Agent-06 ADAPTIVE-ROUTER déclenche remédiation
        }
    }
}
```

**G — Impact sur SMI**

La dimension "Mirror" du SMI (20% du score total) est directement alimentée par les scores Teach-Back :

```
SMI_mirror = (teach_back_depth_avg × 0.50)
           + (concept_coverage_rate × 0.30)
           + (zero_misconceptions_bonus × 0.20)
```

**H — Données générées → Amélioration continue**

Les patterns Teach-Back agrégés (anonymisés, k-anonymity ≥ 100) permettent :
- ✅ Identifier les concepts systématiquement mal compris dans un domaine
- ✅ Améliorer les prompts NEURON-CHAINS (meilleurs exemples, meilleures analogies)
- ✅ Adapter les DAG ASCENT (certains nœuds trop complexes pour leur position)
- ✅ Créer de meilleures cartes APEX automatiquement

**Schéma BDD — Tables STUDENT AI :**

```sql
-- Sessions d'enseignement inversé
CREATE TABLE scy_teachback_sessions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  node_id UUID NOT NULL REFERENCES scy_ascent_nodes(id),
  trigger_type TEXT NOT NULL, -- 'auto_post_review','auto_node_end','manual'
  duration_seconds INTEGER,
  
  -- Analyse concepts
  expected_concepts TEXT[] NOT NULL,       -- Concepts clés du nœud
  mentioned_concepts TEXT[] NOT NULL,      -- Ce que l'user a couvert
  concept_coverage_rate REAL,             -- 0.0-1.0
  
  -- Qualité explication
  depth_score REAL,                       -- 0.0-1.0
  analogies_count INTEGER DEFAULT 0,
  concrete_examples_count INTEGER DEFAULT 0,
  
  -- Problèmes détectés
  coherence_issues JSONB DEFAULT '[]',    -- [{type, description, concepts}]
  misconceptions JSONB DEFAULT '[]',      -- [{concept, wrong_belief, correct}]
  
  -- Questions posées par l'IA
  questions_asked JSONB NOT NULL,         -- [{type, text, triggered_by}]
  
  -- Impact FSRS
  fsrs_adjustments JSONB DEFAULT '[]',   -- [{card_id, old_stability, new_stability, reason}]
  
  -- SMI impact
  mirror_score_contribution REAL,        -- Contribution à dimension Mirror du SMI
  
  started_at INTEGER NOT NULL,
  ended_at INTEGER,
  created_at INTEGER NOT NULL
);

-- Transcription complète (pour analyse et amélioration)
CREATE TABLE scy_teachback_transcripts (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  session_id UUID NOT NULL REFERENCES scy_teachback_sessions(id),
  speaker TEXT NOT NULL CHECK (speaker IN ('user','student_ai')),
  message TEXT NOT NULL,
  timestamp_offset_seconds INTEGER, -- Secondes depuis début session
  analysis_snapshot JSONB,          -- État analyse au moment du message
  created_at INTEGER NOT NULL
);

-- Patterns agrégés (anonymisés, amélioration continue)
CREATE TABLE scy_teachback_concept_patterns (
  concept_name TEXT NOT NULL,
  domain TEXT NOT NULL,
  total_sessions INTEGER DEFAULT 0,
  avg_coverage_rate REAL,
  avg_depth_score REAL,
  common_misconceptions JSONB DEFAULT '[]',
  common_gaps JSONB DEFAULT '[]',         -- Concepts souvent oubliés
  updated_at INTEGER NOT NULL,
  PRIMARY KEY (concept_name, domain)
);
```

---

#### 7.5.17 AI-Era Work Mode Detector — Validation Adaptée 2026 🤖🔍

**Phase** : V1  
**Contexte** : En 2026, la majorité des professionnels utilisent l'IA au quotidien. Valider les compétences comme en 2015 (mémorisation pure, écriture de code à la main) n'a plus de sens dans de nombreux domaines. SCY Forge détecte le mode de travail réel de l'utilisateur et adapte ses critères de validation en conséquence.

---

**### Le Problème**

Un développeur en 2026 ne tape plus de code de A à Z. Il :
- Décrit le problème à Claude/GPT → obtient du code
- Revoit, comprend, adapte, teste
- Debugge les cas d'usage non couverts par l'IA
- Prend des décisions d'architecture que l'IA ne peut pas prendre seule

Si on évalue ce développeur sur "écrire une fonction de tri en Python", on rate complètement ce qui constitue sa vraie compétence 2026.

**La vraie compétence 2026 dans un monde IA :**
- **Ingénierie du problème** : Transformer un problème métier en instructions précises pour l'IA
- **Validation critique** : Détecter ce que l'IA hallucine ou rate
- **Architecture de décision** : Choisir la bonne approche (pas l'implémenter)
- **Raisonnement sur les edge cases** : Ce que l'IA manque systématiquement
- **Méta-compétence** : Savoir quand NE PAS utiliser l'IA

---

**### Architecture — AI-Era Work Mode Detector**

```
┌───────────────────────────────────────────────────────────────┐
│              AI-ERA WORK MODE DETECTOR                         │
├───────────────────────────────────────────────────────────────┤
│                                                                │
│  PHASE 1 : DÉTECTION DU MODE DE TRAVAIL (onboarding + live)  │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │  Questions onboarding (3 questions adaptatives) :       │  │
│  │  "Dans ton travail quotidien, utilises-tu l'IA ?"      │  │
│  │  "Pour quelles tâches ?" (liste multi-choix + libre)   │  │
│  │  "Quel est ton rôle exact ?" (influence les critères)  │  │
│  │                                                         │  │
│  │  Détection comportementale (continue, passive) :        │  │
│  │  • Temps passé sur exercices pratiques vs théoriques   │  │
│  │  • Types de questions posées à BRAIN                   │  │
│  │  • Patterns dans les Teach-Back sessions               │  │
│  └─────────────────────────────────────────────────────────┘  │
│                          ↓                                     │
│  PHASE 2 : CLASSIFICATION DU MODE                             │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │  MODE A — Traditional (faible usage IA)                 │  │
│  │    → Critères classiques (mémorisation + application)  │  │
│  │                                                         │  │
│  │  MODE B — AI-Assisted (usage IA modéré)                │  │
│  │    → Critères mixtes (compréhension + usage IA correct) │  │
│  │                                                         │  │
│  │  MODE C — AI-Native (usage IA intensif)                │  │
│  │    → Critères axés raisonnement + décision             │  │
│  └─────────────────────────────────────────────────────────┘  │
│                          ↓                                     │
│  PHASE 3 : ADAPTATION CRITÈRES VALIDATION                     │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │  Exercices ASCENT adaptés au mode                      │  │
│  │  Questions Teach-Back adaptées au mode                 │  │
│  │  Critères SMI repondérés                               │  │
│  │  Proof of Skill conditionnel au mode                   │  │
│  └─────────────────────────────────────────────────────────┘  │
│                          ↓                                     │
│  PHASE 4 : CONSCIOUS AGENT (recherche internet temps réel)    │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │  L'agent fait des recherches autonomes sur :            │  │
│  │  • Ce que font réellement les pros du domaine en 2026  │  │
│  │  • Quels outils IA sont utilisés dans ce secteur       │  │
│  │  • Quelles compétences sont le plus valorisées         │  │
│  │  → Adapte le parcours ASCENT en conséquence            │  │
│  └─────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────┘
```

---

**### Les 3 Modes de Travail**

**MODE A — Traditional (critères classiques)**

*Profil* : Domaines où l'IA est peu ou pas utilisée (artisanat, sport, certaines professions réglementées), ou utilisateurs qui choisissent délibérément de ne pas utiliser l'IA.

*Critères de validation ASCENT* :
- Mémorisation des concepts clés (FSRS standard)
- Capacité à répondre sans aide
- Application dans des contextes nouveaux
- Explication à autrui (Teach-Back standard)

**MODE B — AI-Assisted (critères mixtes)**

*Profil* : Utilisateurs qui utilisent l'IA pour certaines tâches mais pas toutes (rédacteurs qui utilisent Grammarly, designers qui utilisent Midjourney, avocats qui utilisent des outils de recherche IA).

*Critères de validation ASCENT* :
- Compréhension conceptuelle (peut expliquer pourquoi, pas juste comment)
- Capacité à évaluer les outputs IA (détecter erreurs et biais)
- Connaissance des limites de l'IA dans leur domaine
- Usage stratégique de l'IA (quand l'utiliser, quand ne pas)

**MODE C — AI-Native (critères adaptés 2026)**

*Profil* : Développeurs, data scientists, marketeurs, consultants qui intègrent l'IA dans 70%+ de leur workflow quotidien.

*Critères de validation ASCENT* :
- **Raisonnement ingénierie** > mémorisation syntaxe
- **Qualité du prompt engineering** (transformer un problème en instruction IA précise)
- **Validation critique output IA** (détecter hallucinations, erreurs logiques)
- **Architecture de décision** (justifier le choix d'approche, pas l'implémentation)
- **Gestion des edge cases** (identifier ce que l'IA rate systématiquement)
- **Méta-compétence** : Savoir quand l'IA est contre-productive

*Exemple concret — Dev en MODE C :*
```
EXERCICE CLASSIQUE (mode A) :
"Implémente un algorithme de tri fusion en Python"

EXERCICE MODE C pour le même concept :
"Tu as un dataset de 10M de lignes à trier. Tu dois choisir entre 
merge sort, quicksort, et timsort. L'IA vient de te proposer 
timsort avec ce justification : [explication partiellement incorrecte].
1. Identifie l'erreur dans le raisonnement de l'IA
2. Explique pourquoi timsort est quand même le bon choix ici
3. Réécris le prompt que tu aurais dû donner pour obtenir
   une explication correcte dès le départ"
```

---

**### CONSCIOUS AGENT — L'Agent qui Fait des Recherches pour l'Utilisateur**

C'est l'agent le plus innovant : un agent conscient de l'état du monde professionnel en 2026, qui fait des **recherches internet en temps réel** pour adapter le parcours de l'utilisateur.

```rust
pub struct ConsciousContextAgent {
    web_searcher: WebSearchClient,  // Recherche internet temps réel
    domain_analyzer: DomainAnalyzer,
    profile_adapter: ProfileAdapter,
}

impl ConsciousContextAgent {
    /// Recherche active ce qui se passe dans le domaine de l'user
    pub async fn research_domain_context(
        &self,
        user_profile: &UserProfile,
        goal: &LearningGoal,
    ) -> DomainContext {
        // Recherches autonomes (sans que l'user le voie)
        let searches = vec![
            format!("What skills do {} need in 2026?", goal.domain),
            format!("{} AI tools used by professionals 2026", goal.domain),
            format!("What {} companies look for in candidates 2026", goal.domain),
            format!("{} future trends skills required", goal.domain),
        ];
        
        let mut context = DomainContext::default();
        for query in &searches {
            let results = self.web_searcher.search(query, top_k: 5).await?;
            context.merge(results);
        }
        
        // Distillation des insights (LLM)
        let insights = self.extract_domain_insights(&context).await?;
        
        context.insights = insights;
        context
    }
    
    /// Génère des questions adaptées à la réalité du marché
    pub async fn generate_context_aware_questions(
        &self,
        concept: &str,
        domain_context: &DomainContext,
        work_mode: WorkMode,
    ) -> Vec<ContextualQuestion> {
        // L'agent sait ce qui se passe dans le secteur
        // et pose des questions ancrées dans cette réalité
        
        match work_mode {
            WorkMode::AiNative => {
                // Questions axées sur l'usage réel de l'IA dans ce domaine
                vec![
                    ContextualQuestion {
                        text: format!(
                            "En 2026, les devs de {} utilisent Copilot/Claude pour {}. 
                             Comment est-ce que ta compréhension de {} t'aide à 
                             mieux diriger ces outils ?", 
                            domain_context.current_top_companies,
                            domain_context.ai_tools_in_use,
                            concept
                        ),
                        validates_dimension: "engineering_reasoning",
                        difficulty: Difficulty::Adaptive(domain_context.market_sophistication),
                    }
                ]
            }
            WorkMode::Traditional => {
                // Questions classiques mais ancrées dans des cas réels actuels
                vec![/* ... */]
            }
            WorkMode::AiAssisted => {
                // Questions mixtes
                vec![/* ... */]
            }
        }
    }
}
```

**Features CONSCIOUS AGENT :**

- ✅ **Recherche web temps réel** au démarrage d'un nouveau parcours ASCENT
  - "Quelles compétences recherchent les entreprises en [domaine] en 2026 ?"
  - "Quels outils IA sont utilisés dans [domaine] actuellement ?"
  - "Quel est le niveau de salaire moyen pour [profil] ?"
- ✅ **Veille continue** : Re-recherche tous les 30 jours pour un parcours actif
- ✅ **Insights intégrés dans le DAG** : Certains nœuds ASCENT sont ajoutés/retirés dynamiquement selon le marché actuel
- ✅ **Questions ancrées dans la réalité** : Les exercices font référence à des outils, entreprises, cas d'usage réels de 2026
- ✅ **Alerte skill gap** : "Attention, [compétence] que tu apprends est en train d'être automatisée. Voici la compétence adjacente plus durable."
- ✅ **Coût** : Recherche web légère, 10 requêtes max par démarrage de parcours (~$0.001)

**Schéma BDD — Work Mode :**

```sql
-- Profil mode de travail utilisateur
CREATE TABLE scy_user_work_mode (
  user_id UUID PRIMARY KEY REFERENCES scy_users(id),
  work_mode TEXT NOT NULL DEFAULT 'traditional', -- 'traditional','ai_assisted','ai_native'
  ai_usage_domains TEXT[],           -- Domaines où l'user utilise l'IA
  ai_tools_used TEXT[],              -- Ex: ['Claude', 'Copilot', 'Midjourney']
  role_description TEXT,             -- Description libre du rôle
  ai_usage_percentage INTEGER,       -- Estimation % tâches avec IA (0-100)
  detected_automatically BOOLEAN DEFAULT false,
  detection_confidence REAL,
  last_reviewed_at INTEGER,
  updated_at INTEGER NOT NULL
);

-- Contexte domaine (Conscious Agent)
CREATE TABLE scy_domain_contexts (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  domain TEXT NOT NULL,
  goal_id UUID REFERENCES scy_ascent_goals(id),
  search_queries TEXT[],
  raw_results JSONB,                 -- Résultats bruts des recherches
  distilled_insights JSONB NOT NULL, -- Insights extraits
  market_trends TEXT[],              -- Tendances actuelles
  ai_tools_in_domain TEXT[],        -- Outils IA du secteur
  in_demand_skills TEXT[],          -- Compétences recherchées
  at_risk_skills TEXT[],            -- Compétences en voie d'automatisation
  researched_at INTEGER NOT NULL,
  expires_at INTEGER NOT NULL       -- TTL 30 jours
);

-- Exercices adaptés au mode
CREATE TABLE scy_mode_adapted_exercises (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  original_exercise_id UUID REFERENCES scy_ascent_exercises(id),
  work_mode TEXT NOT NULL,
  adapted_prompt TEXT NOT NULL,      -- Version adaptée au mode
  validation_criteria JSONB NOT NULL, -- Critères selon mode
  ai_context TEXT,                   -- Contexte IA injecté (mode C)
  created_at INTEGER NOT NULL
);
```

---

#### 7.5.18 Techniques Cognitives Avancées — Mode Apprentissage Expert

**Phase** : Phase 1-2 (option configurable dans Settings ASCENT)

**Contexte** : Ces techniques, validées par la recherche cognitive (Kornell & Bjork 2008, Bransford 1999), sont implémentables directement dans ASCENT (Agent-04) et NEURON-CHAINS sans coût LLM additionnel.

**A — Interleaving (Mélange de Domaines)**

Au lieu de réviser tous les concepts d'un domaine en bloc, l'Agent-04 (LEARNING-CONDUCTOR) mélange les sujets entre différents nœuds ASCENT.

```
Sans Interleaving : [React Hooks] [React Hooks] [React Hooks] [Redux] [Redux]
Avec Interleaving  : [React Hooks] [Redux] [React Hooks] [CSS Grid] [Redux]

Impact mesuré : +25% rétention long terme vs révision en bloc
               (Kornell & Bjork, 2008)
```

**Activation** : Settings ASCENT → "Mode Interleaving" (ON/OFF)  
**Agent concerné** : Agent-04 (LEARNING-CONDUCTOR) — ordre des nœuds de session  
**APEX** : Scheduler FSRS interleaved entre decks de domaines différents  
**Coût LLM** : $0.00 (règle Rust pure dans Agent-04)

**B — Desirable Difficulty (Difficulté Intentionnelle)**

Introduire intentionnellement de la difficulté pour renforcer l'apprentissage à long terme.

```
Implémentations dans SCY Forge :
✅ Varier les formulations des mêmes cartes APEX (NEURON-CHAINS génère N variantes)
✅ Augmenter l'espacement des révisions au-delà du seuil minimum FSRS (mode agressif)
✅ Introduire des cartes "contexte différent" pour le même concept (transfer learning)
✅ Mélanger types de cartes B02→B04→B05 progressivement sur le même concept
```

**Activation** : Settings APEX → "Mode Difficulté Avancée"  
**Phase recommandée** : Phase 2

**C — Elaborative Interrogation (Questions "Pourquoi")**

Forcer l'apprenant à expliquer POURQUOI un fait est vrai, plutôt que de simplement mémoriser.

```
Impact mesuré : +40% rétention vs questions factuelles directes
               (Pressley et al., 1992)

Implémentation NEURON-CHAINS :
Template spécial dans génération cartes B04 (Short Answer) :
→ "POURQUOI [concept] fonctionne-t-il ainsi ?"
→ "Quelle est la RAISON pour laquelle [mécanisme] existe ?"
→ "Expliquez le FONDEMENT de [principe]"

Distinction avec STUDENT AI :
STUDENT AI        = L'user enseigne à l'IA
Elaborative Inter. = NEURON-CHAINS génère des questions "Pourquoi" dans les cartes
```

**Activation** : Option dans génération NEURON-CHAINS + paramètre Settings  
**Phase recommandée** : Phase 1 (enrichissement prompt NEURON-CHAINS, coût quasi-nul)

---

#### 7.5.19 Personnalisation Adaptative

**Phase** : Phase 1-2

**A — Chronotype (Heures Optimales de Révision)**

```sql
-- Calcul automatique depuis scy_apex_reviews (0 LLM)
SELECT 
  EXTRACT(HOUR FROM to_timestamp(reviewed_at)) as hour,
  AVG(CASE WHEN rating IN ('good','easy') THEN 1.0 ELSE 0.0 END) as success_rate,
  COUNT(*) as review_count
FROM scy_apex_reviews
WHERE user_id = $1 AND reviewed_at > extract(epoch from now() - interval '30 days')
GROUP BY hour
HAVING COUNT(*) >= 3
ORDER BY success_rate DESC;
-- → "Vos meilleures révisions sont entre 21h et 23h (taux succès 87%)"
```

**Usage** :
- Agent-07 (DRIFT-GUARDIAN) envoie rappels à l'heure optimale détectée
- Dashboard → "Votre moment idéal de révision : 21h-23h 🌙"
- Opt-out : l'utilisateur peut ignorer la suggestion ou fixer ses propres horaires

**B — Adaptation du Ton**

```
Settings → Ton de communication
├── Formel    : "Il convient de noter que..."
├── Neutre    : "Note que..."  (défaut)
└── Décontracté : "Hé, sache que..."

Impact :
- T02 ToneSelector (tool NEURON-CHAINS) reçoit la préférence utilisateur
- BRAIN adapte son registre linguistique
- Toutes les cartes générées respectent le ton choisi
Coût : $0.00 (injection paramètre dans prompts existants)
```

**C — Langue par Domaine**

```
Exemple :
Domaine "Développement React" → langue génération : Anglais (docs officielles)
Domaine "Marketing Digital"   → langue génération : Français
Domaine "Machine Learning"    → langue génération : Anglais

Settings → Par objectif ASCENT → Langue de génération NEURON-CHAINS
Coût : $0.00 (paramètre prompt)
```

**D — Détection Style d'Apprentissage (Phase 3 R&D)**

Détection automatique style (visuel/auditif/kinesthésique) via patterns comportementaux :
- Types de cartes consommées en priorité (image_occlusion vs short_answer vs audio)
- Temps passé sur médias vs texte dans File Viewer
- Patterns d'exercices préférés dans ASCENT

**Complexité** : Élevée (classification ML) → **Phase 3 R&D**  
**Output** : Sélection automatique du type dominant de cartes en génération NEURON-CHAINS

### 7.6 Module ASCENT — Apprentissage Adaptatif DAG + Proof of Skill Complet

*Note : En SCY Forge v2, ASCENT est piloté par la Pipeline Agentique (section 4). Les 8 modules deviennent des composants orchestrés par les agents.*

#### 7.6.1 Les 8 Modules ASCENT

1. **Scope Classifier** → Agent-01 (GOAL-INTERPRETER) : 3-200h, détection scope creep
2. **Goal Parser** → Agent-01 : Profil personnalisé (niveau, temps, style, prérequis)
3. **Auto-Ingestion Orchestrator** → Agent-02 (CONTENT-SCOUT) : 25+ sources GOLD
4. **DAG Generator** → Agent-03 (DAG-ARCHITECT) : 4 passes validation, petgraph
5. **Exercise Generator** → Agent-03 + EPSILON chain : Template Gold 6 sections
6. **Validation Engine** → Agent-05 + Agent-06 : SMI ≥70% + exercise ≥80% = unlock
7. **Remediation Router** → Agent-06 (ADAPTIVE-ROUTER) : 5 types correctives
8. **Drift Detector** → Agent-07 (DRIFT-GUARDIAN) : 8 signaux + interventions

**Adaptation Temps-Réel (PATTERN-005) :**
- SMI >85% : Fast-track (skip nœuds simples)
- SMI 60-85% : Progression normale
- SMI <60% : Remédiation intensive
- Plateau détecté : Changement stratégie pédagogique

---

#### 7.6.2 Proof of Skill — Système Complet de Certification

**Phase** : V2  
**Description** : Le Proof of Skill est la promesse centrale de SCY Forge — *"Si tu complètes ASCENT, tu as la compétence — vérifiable."* Ce n'est pas un simple certificat PDF. C'est un système multi-couches avec soumissions de preuves concrètes, évaluation multi-modale et vérification publique.

---

**A — Architecture du Proof of Skill**

```
┌──────────────────────────────────────────────────────────────────┐
│                    PROOF OF SKILL PIPELINE                        │
├──────────────────────────────────────────────────────────────────┤
│                                                                    │
│  DÉCLENCHEUR : Tous nœuds SMI ≥ smi_required                     │
│                          ↓                                        │
│  GATE 1 — Vérification Préalable (automatique, Agent-09)          │
│  • Tous les nœuds du DAG sont au statut "completed" ?            │
│  • SMI moyen ≥ 70 sur l'ensemble des nœuds ?                     │
│  • Aucun nœud en état "remediation_required" actif ?             │
│                          ↓ (si tout OK)                           │
│  GATE 2 — Soumission de Preuves (active, par l'user)              │
│  • Choix du format de soumission selon domaine                   │
│  • Upload ou lien vers la preuve                                 │
│  • Description contexte (500 mots max)                           │
│                          ↓                                        │
│  GATE 3 — Évaluation Finale Cross-Nœuds (Agent-09 + LLM)         │
│  • 15 questions synthétiques couvrant tous les nœuds             │
│  • Teach-Back sur 3 concepts clés                                │
│  • Validation preuve soumise                                     │
│                          ↓                                        │
│  GATE 4 — Calcul SMI Global (Agent-05, 0 LLM)                    │
│  • 5 dimensions agrégées sur tout le parcours                    │
│  • Score minimum requis : 70/100 global                          │
│                          ↓                                        │
│  OUTPUT — Certificat Multi-Formats                                │
│  • PDF Typst professionnel                                       │
│  • Badge LinkedIn (Open Badges standard)                         │
│  • URL de vérification publique                                  │
│  • JSON machine-readable (portabilité)                           │
│  • QR Code vérification employeurs                               │
│                                                                    │
└──────────────────────────────────────────────────────────────────┘
```

---

**B — Les Formats de Soumission de Preuves**

*La soumission d'une preuve concrète est obligatoire pour tout parcours de plus de 20h. C'est ce qui distingue SCY Forge d'un simple quiz de certification.*

**FORMAT 1 — Projet Pratique (le plus valorisé)**

L'utilisateur soumet un projet réel démontrant la compétence.

```
Sous-formats acceptés :
├── Code
│   ├── GitHub repository (lien public ou privé partagé)
│   ├── Repl.it / CodeSandbox (lien direct)
│   ├── ZIP archive du projet
│   └── Notebook Jupyter (.ipynb)
├── Design
│   ├── Figma/Sketch lien partage
│   ├── PDF design book
│   └── Images haute résolution (PNG/JPG)
├── Document
│   ├── PDF (rapport, étude de cas, analyse)
│   ├── Notion page (lien partagé)
│   └── Google Doc (lien partagé)
├── Média
│   ├── Vidéo démonstration (YouTube/Loom lien, max 10min)
│   ├── Présentation enregistrée (Slides + voix)
│   └── Podcast/Audio explicatif (MP3, max 15min)
└── Multi-modal
    └── Combinaison de plusieurs formats ci-dessus
```

**Évaluation du projet :**
- ✅ Évaluation par LLM via rubrique adaptée au domaine + niveau
- ✅ Critères différenciés selon Work Mode (A/B/C)
- ✅ Score 0-100 sur : Fonctionnalité, Qualité, Originalité, Documentation
- ✅ Feedback détaillé par critère (pas juste un score global)
- ✅ Possibilité de re-soumettre 1× (délai 48h minimum entre soumissions)

**FORMAT 2 — Exercice Capstone**

Un exercice final de grande ampleur, généré spécifiquement par NEURON-CHAINS pour ce parcours.

```
Structure Capstone (Template Gold étendu — 9 sections) :
1. Contexte Riche         : Situation réelle, entreprise fictive crédible
2. Problème Central       : Défi principal à résoudre
3. Contraintes            : Limitations réalistes (budget, temps, outils)
4. Données/Ressources     : Tout ce qui est fourni
5. Livrables Attendus     : Liste précise de ce qui doit être produit
6. Critères Évaluation    : Rubrique détaillée visible par l'user
7. Indices Progressifs    : 3 niveaux d'aide (optionnels)
8. Solution Référence     : Visible après soumission
9. Extensions Optionnelles: Pour ceux qui veulent aller plus loin

Types Capstone selon domaine :
├── Développement      → Application fonctionnelle avec tests
├── Data Science       → Analyse complète d'un dataset réel (Kaggle/UCI)
├── Marketing          → Stratégie complète pour une marque fictive
├── Finance            → Analyse et recommandation d'investissement
├── Design             → Système de design complet
├── Management         → Plan stratégique d'une situation de crise
├── Académique         → Revue de littérature + positionnement recherche
└── Spirituel          → Prédication/enseignement documenté
```

**FORMAT 3 — Teach-Back Enregistré (vidéo)**

L'utilisateur enregistre une vidéo de 5 à 15 minutes où il enseigne les concepts clés du parcours à un public imaginaire.

```
Critères d'évaluation Teach-Back vidéo :
├── Clarté d'explication (25%)
├── Couverture des concepts clés (25%)
├── Qualité des exemples/analogies (20%)
├── Précision factuelle (20%)
└── Capacité à anticiper les questions (10%)

Processus :
1. User enregistre sa vidéo (Loom, YouTube unlisted, ou upload direct)
2. NEURON-CHAINS transcrit la vidéo (Whisper API)
3. LLM évalue selon la rubrique du domaine
4. Score calculé + feedback actionnable généré
5. Comparaison avec les concepts clés attendus du nœud
```

**FORMAT 4 — Peer Review (Phase 3)**

*Disponible quand la base d'utilisateurs est suffisante (>5000 users actifs).*

```
Principe :
• L'user soumet son travail
• 3 pairs anonymes du même domaine l'évaluent (k-anonymity)
• La note finale = moyenne pondérée évaluation IA + peers
• L'user doit aussi évaluer 2 travaux d'autres users

Avantages :
✅ Feedback humain = plus riche que IA seule
✅ Crée une communauté d'apprenants
✅ Network effects renforcés (plus d'users = meilleurs reviews)
✅ Validité externe (pas juste l'IA qui certifie)
```

**FORMAT 5 — Portfolio de Micro-Preuves**

Pour les parcours longs (>50h), plutôt qu'une seule grande preuve :

```
Structure :
• 1 preuve par cluster de nœuds (3-5 nœuds)
• Format libre par cluster
• Agrégation automatique en portfolio PDF
• Timeline visuelle des preuves (COSMOS Timeline mode 6)

Avantages :
✅ Moins d'intimidation qu'un unique grand projet
✅ Progression visible au fil du temps
✅ Documentation complète du parcours d'apprentissage
✅ Portfolio professionnel réutilisable
```

---

**C — Critères de Validation selon Work Mode**

| Dimension | Mode A (Traditional) | Mode B (AI-Assisted) | Mode C (AI-Native) |
|-----------|---------------------|---------------------|-------------------|
| **Mémorisation** | 40% poids | 20% poids | 5% poids |
| **Compréhension conceptuelle** | 30% poids | 30% poids | 25% poids |
| **Application pratique** | 20% poids | 25% poids | 20% poids |
| **Raisonnement/Décision** | 10% poids | 15% poids | 30% poids |
| **Validation output IA** | N/A | 10% poids | 20% poids |
| **Teach-Back qualité** | Bonus | Obligatoire | Obligatoire |
| **Score minimum global** | 70/100 | 72/100 | 75/100 |

---

**D — Le Certificat Proof of Skill — Contenu Complet**

```
╔══════════════════════════════════════════════════════════════╗
║           SCY FORGE — PROOF OF SKILL CERTIFICATE             ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  👤 [Nom Utilisateur]                                        ║
║  🎯 [Titre du Parcours]                                      ║
║  📅 Certifié le [Date]                                       ║
║  🔑 ID : SCY-AAAA-MM-JJ-[DOMAINE]-[SCORE]                  ║
║                                                               ║
║  SCORE GLOBAL : [XX]/100                                     ║
║                                                               ║
║  DÉTAIL 5 DIMENSIONS :                                       ║
║  Rétention     [████░] [XX]/100  (35%)                      ║
║  Profondeur    [███░░] [XX]/100  (25%)                      ║
║  Enseignement  [████░] [XX]/100  (20%)                      ║
║  Métacognition [███░░] [XX]/100  (10%)                      ║
║  Cohérence     [████░] [XX]/100  (5%)                       ║
║                                                               ║
║  MODE DE VALIDATION : [Traditional/AI-Assisted/AI-Native]   ║
║  FORMAT PREUVE : [Projet/Capstone/Teach-Back/Portfolio]     ║
║                                                               ║
║  PARCOURS COMPLÉTÉ :                                         ║
║  • [N] nœuds de compétence validés                          ║
║  • [N] heures d'apprentissage actif                         ║
║  • [N] exercices complétés ([%] taux de réussite)           ║
║  • [N] cartes de révision maîtrisées                        ║
║  • [N] sessions Teach-Back réalisées                        ║
║  • Streak maximum : [N] jours consécutifs                   ║
║                                                               ║
║  COMPÉTENCES MAÎTRISÉES :                                   ║
║  [Liste nœuds avec scores individuels]                      ║
║                                                               ║
║  PREUVE SOUMISE :                                           ║
║  Type : [Format] | Score preuve : [XX]/100                  ║
║  Lien : [URL ou "Archive privée"]                           ║
║                                                               ║
║  VÉRIFICATION :                                             ║
║  🔗 scy_forge.app/verify/SCY-XXXX                           ║
║  📱 [QR Code]                                               ║
║  📋 Données vérifiables — Score calculé par FSRS 5.0        ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
```

---

**E — Exports du Certificat**

- ✅ **PDF Typst** : Layout professionnel, PDF/A archivage
- ✅ **Badge PNG** : Format carré optimisé réseaux sociaux (1200×1200px)
- ✅ **LinkedIn Badge** : Open Badges 2.0 standard, apparaît dans section "Certifications"
- ✅ **JSON machine-readable** : Tous les scores + métadonnées (portabilité, ATS RH)
- ✅ **URL de vérification publique** : scy_forge.app/verify/SCY-XXXX
  - Affiche score, date, compétences validées
  - Employeurs peuvent vérifier sans compte SCY Forge
  - QR Code intégré dans le PDF
- ✅ **Lien partageable** : Via email, WhatsApp, LinkedIn message

---

**F — Schéma BDD — Proof of Skill Complet**

```sql
-- Soumissions de preuves
CREATE TABLE scy_skill_proof_submissions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  submission_format TEXT NOT NULL CHECK (submission_format IN (
    'project_code','project_design','project_document',
    'project_media','capstone','teachback_video',
    'peer_review','portfolio'
  )),
  -- Contenu soumis
  title TEXT NOT NULL,
  description TEXT,                    -- Contexte user (500 mots max)
  submission_url TEXT,                 -- Lien GitHub, YouTube, Figma...
  file_storage_path TEXT,             -- Si upload direct (Northflank Storage)
  work_mode TEXT NOT NULL,            -- 'traditional','ai_assisted','ai_native'
  
  -- Évaluation automatique (LLM)
  evaluation_rubric JSONB NOT NULL,    -- Critères selon domaine + mode
  auto_score REAL,                    -- Score LLM (0-100)
  auto_feedback JSONB,                -- Feedback par critère
  functionality_score REAL,
  quality_score REAL,
  originality_score REAL,
  documentation_score REAL,
  
  -- Peer review (Phase 3)
  peer_reviews JSONB DEFAULT '[]',    -- [{reviewer_id, score, feedback, date}]
  peer_avg_score REAL,
  
  -- Score final
  final_score REAL,                   -- Moyenne pondérée auto + peer
  passed BOOLEAN,                     -- Seuil minimum atteint
  
  -- Resoumission
  attempt_number INTEGER DEFAULT 1,
  previous_submission_id UUID REFERENCES scy_skill_proof_submissions(id),
  
  submitted_at INTEGER NOT NULL,
  evaluated_at INTEGER,
  created_at INTEGER NOT NULL
);

-- Évaluation finale cross-nœuds (Gate 3 - Piloté par le Moteur SurveyJS)
-- Le schéma d'examen est stocké sous forme de JSON et rendu par le runner SurveyJS
CREATE TABLE scy_skill_final_assessments (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  
  -- 15 questions cross-nœuds
  questions JSONB NOT NULL,            -- [{node_id, question, type, expected_answer}]
  user_answers JSONB NOT NULL,        -- [{question_id, answer, score}]
  total_score REAL,
  pass_threshold REAL DEFAULT 80.0,
  passed BOOLEAN,
  
  -- 3 Teach-Back concepts clés
  teachback_session_ids UUID[],       -- Liens vers scy_teachback_sessions
  teachback_avg_score REAL,
  
  attempt_number INTEGER DEFAULT 1,
  completed_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL
);

-- Certificats émis (table principale Proof of Skill)
CREATE TABLE scy_proof_of_skill (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  submission_id UUID REFERENCES scy_skill_proof_submissions(id),
  final_assessment_id UUID REFERENCES scy_skill_final_assessments(id),
  
  -- Identifiant unique vérifiable
  certification_id TEXT UNIQUE NOT NULL, -- 'SCY-2026-06-08-REACT-84'
  verification_url TEXT UNIQUE NOT NULL,
  
  -- Scores SMI 5 dimensions
  overall_smi REAL NOT NULL,
  retention_score REAL,
  depth_score REAL,
  mirror_score REAL,
  metacognition_score REAL,
  consistency_score REAL,
  
  -- Mode de validation
  work_mode TEXT NOT NULL,
  proof_format TEXT NOT NULL,
  proof_score REAL,
  
  -- Statistiques parcours

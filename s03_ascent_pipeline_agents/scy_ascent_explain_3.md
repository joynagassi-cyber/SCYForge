# SPEC — AGENT-10 CHRONICLE & AGENT-11 ARENA
## Spécification Complète — Deux Nouveaux Agents ASCENT Premium

---

**Document ID** : SPEC-CHRONICLE-ARENA-V1  
**Date** : 2026-06-09  
**Statut** : ✅ VALIDÉ — Prêt intégration PRD §4 ASCENT + §7.1  
**Tier** : Premium uniquement  
**Agents** : CHRONICLE (Agent-10) + ARENA (Agent-11)

---

## AGENT-10 : CHRONICLE — Le Coéquipier IA Quotidien

### 10.1 Vision & Philosophie

> *"L'humain n'a pas besoin de plus de réflexion. Il a besoin d'un coéquipier qui pense à sa place sur la planification, pour que lui puisse utiliser toute son énergie à apprendre."*

**CHRONICLE** est le premier agent de SCY Forge qui **vit avec l'utilisateur** — pas seulement quand il ouvre l'app. Il connaît sa vie, son rythme, ses contraintes, ses habitudes. Il adapte le plan d'apprentissage à la réalité quotidienne sans que l'utilisateur ait à y réfléchir.

**La différence fondamentale avec les autres agents** :
- Agents 01-09 : Réagissent quand l'utilisateur utilise SCY Forge
- **CHRONICLE** : Existe même quand l'utilisateur n'est pas dans SCY Forge

### 10.2 Ce que CHRONICLE Fait Concrètement

**Scénario A — L'Imprévu** :
```
User → CHRONICLE (n'importe quand, n'importe comment) :
"J'ai un imprévu demain, je peux pas faire ma session"

CHRONICLE analyse :
  - Quelle session était prévue ? (DAG actuel)
  - Quel est le délai de la formation ? (Date Proof of Skill cible)
  - Combien de sessions ont déjà été ratées ce mois ?
  - Quel est le SMI actuel ? (tension si retard = risque)

CHRONICLE propose (en quelques secondes) :
Option 1 : "OK, on décale. Voici le nouveau planning sur 3 jours pour rattraper :"
           → [Lundi : 2 sessions / Mardi : session + exercice / Mercredi : révision]
           
Option 2 : "La date de ta certification reste le 15 juillet si tu fais 2 sessions
           de 20 min mercredi et jeudi. Tu confirmes ?"
           
Option 3 : "Tu veux qu'on crée un bootcamp intensif ce week-end pour absorber
           le retard ? 3h samedi matin + 2h dimanche = tout est rattrapé."
```

**Scénario B — La Journée Normale** :
```
CHRONICLE (proactif, à l'heure que l'user a définie) :
"Bonjour [Prénom]. Ta session du jour : useEffect — 15 min.
Tu as prévu ça à 20h après le travail. 
La météo dit qu'il fera mauvais donc parfait pour une session longue si tu veux 😄
Je t'attends là-bas à 20h ou tu veux avancer ?"

Options : [Confirmer 20h] [Avancer maintenant] [Décaler à 21h] [J'ai besoin d'aide]
```

**Scénario C — La Semaine Décalée** :
```
User : "J'ai raté 5 jours cette semaine"

CHRONICLE :
"Pas de panique. Voici les 3 options selon ce que tu veux :

🔵 Option SOUPLE : On allonge la formation de 1 semaine. 
   Tu maintiens ton rythme actuel. Proof of Skill = 22 juillet au lieu du 15.

🟠 Option STANDARD : Bootcamp de rattrapage sur 3 jours (Sat/Sun/Lun).
   Sessions de 45 min. Formation = date inchangée.

🔴 Option INTENSIF : Je réorganise les 2 prochaines semaines avec des sessions
   plus courtes mais plus fréquentes (2 × 20 min/jour vs 1 × 40 min).
   Date inchangée, effort quotidien légèrement augmenté.

Qu'est-ce qui te convient le mieux ?"
```

**Scénario D — L'Oubli Quotidien** :
```
CHRONICLE détecte : 21h30, session prévue à 19h non faite

CHRONICLE (1 seul message, pas de harcèlement) :
"Tu as oublié ta session ce soir. Il te reste 30 minutes avant que ce soit trop 
tard pour ton cerveau d'absorber ça correctement.
5 cartes = 3 minutes. Tu peux le faire maintenant ? [Oui, maintenant] [Demain matin]"
```

### 10.3 Architecture CHRONICLE

#### Mémoire Contextuelle Persistante

C'est le cœur de CHRONICLE — ce qui le rend unique.

```rust
// CHRONICLE Memory — Persistante, personnelle, évolutive
pub struct ChronicleMemory {
    // Rythme de vie (appris au fil du temps, pas déclaré uniquement)
    life_rhythm: LifeRhythm,
    
    // Événements récurrents détectés automatiquement
    recurring_constraints: Vec<RecurringConstraint>,
    
    // Humeur et énergie patterns
    energy_patterns: EnergyProfile,
    
    // Historique des imprévus et comment l'user les a gérés
    disruption_history: Vec<DisruptionEvent>,
    
    // Préférences de communication (révélées comportementalement)
    communication_style: CommunicationPreferences,
    
    // Engagements pris et tenus (pour calibrer les propositions)
    commitment_track_record: CommitmentMetrics,
}

pub struct LifeRhythm {
    optimal_learning_hours: Vec<TimeSlot>,     // Détecté depuis les sessions
    low_energy_days: Vec<Weekday>,             // "Les lundis tu rates souvent"
    high_energy_slots: Vec<TimeSlot>,          // "Tu perfomes mieux le soir"
    declared_schedule: WeeklySchedule,         // Ce que l'user a dit à l'onboarding
    observed_schedule: WeeklySchedule,         // Ce que l'user fait vraiment
}

pub struct RecurringConstraint {
    day_of_week: Weekday,
    description: String,             // "Mercredi = surchargé au travail"
    learning_capacity: f32,          // 0.0 = impossible, 1.0 = plein
    detected_from: String,           // "Observé sur 4 semaines"
    user_confirmed: bool,
}

pub struct CommunicationPreferences {
    preferred_tone: Tone,            // Bienveillant / Direct / Humoristique
    notification_style: NotifStyle, // Discret / Normal / Proactif
    response_verbosity: Verbosity,  // Court / Standard / Détaillé
    // Tous ces champs évoluent selon le comportement de l'user
}
```

#### Moteur d'Adaptation Planning

```rust
pub struct ChroniclePlanningEngine {
    dag: CompetenceDAG,             // Via Agent-03
    current_smi: HashMap<NodeId, f32>, // Via Agent-05
    target_date: Date,              // Proof of Skill cible
    available_time: TimeSlot,       // Ce que l'user a défini + ajusté
}

pub enum ReschedulingStrategy {
    // Étendre la durée de la formation
    ExtendDuration { new_end_date: Date, explanation: String },
    
    // Créer un bootcamp de rattrapage
    IntensiveBootcamp {
        dates: Vec<Date>,
        sessions_per_day: u8,
        minutes_per_session: u32,
    },
    
    // Redistribuer intelligemment les sessions restantes
    SmartRedistribution {
        new_plan: Vec<DayPlan>,
        rationale: String,
    },
    
    // Micro-sessions pour les périodes chargées (Tiny Habits)
    MicroSessionMode {
        cards_per_session: u8,    // 5-10 cartes
        frequency: u8,            // fois/jour
        duration_days: u32,
    },
}

pub fn propose_rescheduling(
    chronicle: &ChronicleMemory,
    planning: &ChroniclePlanningEngine,
    disruption: &DisruptionEvent,
) -> Vec<ReschedulingProposal> {
    // Toujours proposer 2-3 options (SDT : autonomie)
    // Ordonner par probabilité de succès selon CommitmentMetrics
    // Ne jamais proposer ce que l'user a refusé les 3 dernières fois
    // Calibrer selon l'energie_patterns (pas de bootcamp si l'user est en période difficile)
    let options = vec![
        gentle_option(planning, disruption),    // L'option douce (extension)
        balanced_option(planning, disruption),  // L'option équilibrée
        intensive_option(planning, disruption), // L'option intensive (si pattern le permet)
    ];
    
    // Filtrer selon feasibility + user history
    options.into_iter()
        .filter(|opt| is_feasible(opt, &chronicle.commitment_track_record))
        .collect()
}
```

#### Modes d'Interaction Adaptatifs

CHRONICLE ne force pas un mode. Il apprend comment l'user communique.

```rust
pub enum InteractionMode {
    // Détecté comportementalement
    ChatFree,            // L'user écrit librement, CHRONICLE interprète
    StructuredCheckIn,   // L'user préfère les options numérotées
    ProactiveOnly,       // L'user veut que CHRONICLE contacte en premier
    Minimal,             // L'user veut le minimum de contact
}

pub struct AdaptiveInteraction {
    current_mode: InteractionMode,
    
    // Détecter le mode depuis le comportement
    fn detect_mode_from_behavior(history: &InteractionHistory) -> InteractionMode {
        let response_rate = history.proactive_messages_answered_rate();
        let avg_message_length = history.avg_user_message_length();
        let initiated_by_user = history.user_initiated_ratio();
        
        match (response_rate, avg_message_length, initiated_by_user) {
            (rate, _, _) if rate < 0.3 => InteractionMode::Minimal,
            (_, length, _) if length > 50.0 => InteractionMode::ChatFree,
            (_, _, ratio) if ratio > 0.7 => InteractionMode::StructuredCheckIn,
            _ => InteractionMode::ProactiveOnly,
        }
    }
    
    // Le ton s'adapte aussi (Coach / Partenaire / Chef de projet)
    fn detect_tone_preference(history: &InteractionHistory) -> Tone {
        // Si l'user utilise des emojis → Friendly
        // Si l'user répond par bullet points → Professional
        // Si l'user partage des détails personnels → Warm
        // Si l'user ne répond qu'aux messages courts → Direct
    }
}
```

### 10.4 Coût LLM CHRONICLE

```
Check-in proactif quotidien (règles Rust)  : $0.00 (heure, message type, options)
Détection disruption + analyse options     : $0.00 (calcul planning pur)
Message personnalisé si disruption         : ~$0.0002 (1 appel × ~600 tokens)
Réponse à message libre de l'user         : ~$0.0003 (1 appel × ~800 tokens)

Estimation mensuelle par user actif        : 
  ~4-6 disruptions/mois × $0.0002 = $0.001
  ~8-12 conversations libres/mois × $0.0003 = $0.003
  ─────────────────────────────────────────────
  TOTAL CHRONICLE/mois                     : ~$0.004/user/mois
```

### 10.5 Ce qui Rend CHRONICLE Unique

| Feature | CHRONICLE | Duolingo | Coursera | Notion | Anki |
|---------|-----------|----------|----------|--------|------|
| Reprogramme si imprévu | ✅ | ❌ | ❌ | ❌ | ❌ |
| Mémoire vie quotidienne | ✅ | ❌ | ❌ | ❌ | ❌ |
| Propose options de rattrapage | ✅ | ❌ | ❌ | ❌ | ❌ |
| Adapte son mode de comm. | ✅ | ❌ | ❌ | ❌ | ❌ |
| Contacte proactivement | ✅ | ⚠️ Notif | ❌ | ❌ | ⚠️ Notif |
| Détecte patterns vie réelle | ✅ | ❌ | ❌ | ❌ | ❌ |

### 10.6 Schéma BDD CHRONICLE

```sql
-- Mémoire persistante CHRONICLE
CREATE TABLE scy_chronicle_memory (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID UNIQUE NOT NULL REFERENCES scy_users(id),
  
  -- Rythme de vie (observé + déclaré)
  declared_schedule JSONB,           -- {weekday: {slots: [{start, end}]}}
  observed_schedule JSONB,           -- Calculé depuis les sessions réelles
  optimal_hours JSONB,               -- Heures où la performance est meilleure
  low_energy_days TEXT[],            -- ['monday', 'wednesday']
  
  -- Contraintes récurrentes détectées
  recurring_constraints JSONB,       -- [{day, description, capacity, confirmed}]
  
  -- Préférences communication (évolutives)
  interaction_mode TEXT DEFAULT 'proactive', -- 'chat_free'|'structured'|'proactive'|'minimal'
  preferred_tone TEXT DEFAULT 'warm',        -- 'warm'|'direct'|'professional'|'friendly'
  response_verbosity TEXT DEFAULT 'standard',
  
  -- Historique engagements
  commitments_made INTEGER DEFAULT 0,
  commitments_kept INTEGER DEFAULT 0,
  avg_disruptions_per_month REAL DEFAULT 0,
  
  -- Profil énergie
  energy_profile JSONB,              -- Distribution énergie par heure/jour
  
  updated_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL
);

-- Disruptions et reprises
CREATE TABLE scy_chronicle_disruptions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  
  disruption_type TEXT NOT NULL,     -- 'imprévu'|'oubli'|'fatigue'|'maladie'|'voyage'
  sessions_missed INTEGER,
  days_inactive INTEGER,
  
  -- Proposition CHRONICLE
  options_proposed JSONB,            -- [{type, description, effort, end_date}]
  option_chosen TEXT,                -- Type d'option choisie par l'user
  user_response TEXT,                -- Message libre si l'user a écrit
  
  -- Résultat
  successfully_recovered BOOLEAN,
  recovery_days_needed INTEGER,
  
  created_at INTEGER NOT NULL
);

-- Conversations quotidiennes CHRONICLE
CREATE TABLE scy_chronicle_conversations (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  
  initiated_by TEXT NOT NULL,        -- 'chronicle' | 'user'
  context TEXT NOT NULL,             -- 'daily_check_in'|'disruption'|'motivation'|'free'
  
  chronicle_message TEXT NOT NULL,
  user_response TEXT,
  
  -- Actions déclenchées
  actions_taken JSONB,               -- [{agent, action, params}]
  plan_modified BOOLEAN DEFAULT false,
  
  created_at INTEGER NOT NULL
);

-- Nouveau Planning après disruption
CREATE TABLE scy_chronicle_plans (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  disruption_id UUID REFERENCES scy_chronicle_disruptions(id),
  
  plan_type TEXT NOT NULL,           -- 'extension'|'bootcamp'|'redistribution'|'micro'
  original_end_date DATE,
  new_end_date DATE,
  
  daily_plan JSONB NOT NULL,         -- [{date, sessions: [{type, duration_min, nodes}]}]
  total_extra_sessions INTEGER,
  
  started_at INTEGER,
  completed BOOLEAN DEFAULT false,
  completion_rate REAL,              -- % des sessions du plan faites
  
  created_at INTEGER NOT NULL
);
```

---

## AGENT-11 : ARENA — L'Agent de Validation Pratique

### 11.1 Vision & Philosophie

> *"La théorie sans la pratique ne crée pas de compétence. ARENA transforme SCY Forge en salle d'entraînement où la réalité est simulée — avant que l'utilisateur affronte la vraie."*

**ARENA** est l'agent qui résout le problème fondamental de toute formation pratique : **comment valider qu'on sait vraiment faire, pas juste qu'on sait en parler**.

Pour la vente, c'est ne pas savoir si tu peux convaincre — pas mémoriser les techniques. Pour la médecine, c'est pas mémoriser les symptômes — c'est poser le bon diagnostic en conversation réelle. Pour la musique, c'est pas connaître les gammes — c'est improviser.

ARENA crée des **expériences de simulation haute-fidélité** où l'utilisateur doit mobiliser tout ce qu'il a appris dans ASCENT face à une IA qui joue le monde réel.

### 11.2 Fonctionnement Complet — Le Cycle ARENA

```
ASCENT détecte →  Nœuds théoriques suffisants (SMI ≥ 70 sur concepts clés)
                  + Profil user indique domaine pratique nécessaire
                  
                      ↓
                      
ARENA-ANALYZER   →  Analyse ce que l'user a appris (via ASCENT DAG + SMI)
                   Analyse le domaine et le niveau
                   Détermine le scenario le plus réaliste et formateur
                   
                      ↓
                      
ARENA-PERSONA    →  Construit la personnalité complète du personnage
                   (psychologie, historique, besoins, résistances, triggers)
                   
                      ↓
                      
SESSION ROLEPLAY →  Conversation/interaction réelle
                   L'user pratique, ARENA réagit authentiquement
                   
                      ↓
                      
ARENA-EVALUATOR  →  Debriefing structuré
                   Analyse technique + émotionnelle
                   Recommendations précises
                   
                      ↓
                      
ASCENT FEEDBACK  →  SMI Profondeur + Miroir mis à jour
                   Nouveaux exercices ciblés sur faiblesses
                   Ou : Proof of Skill partiel (compétence pratique)
```

### 11.3 L'Intelligence du Persona — Ce qui Rend ARENA Unique

ARENA ne joue pas un personnage générique. Il construit un persona **complet et cohérent** :

```rust
pub struct ArenaPersona {
    // Identité
    role: String,                    // "Directeur Commercial, PME tech 50 personnes"
    name: Option<String>,            // Optionnel — rend le roleplay plus réel
    
    // Psychologie profonde
    core_motivation: String,         // "Protéger son budget, éviter les erreurs passées"
    fears: Vec<String>,              // ["Être mal jugé par son DG", "Perdre du temps"]
    decision_style: DecisionStyle,   // Analytique / Intuitif / Délégateur / Procédural
    
    // Contexte situationnel (ce qui le rend unique)
    current_situation: String,       // "A été déçu par un prestataire il y a 6 mois"
    pain_points: Vec<String>,        // Problèmes réels qu'il cherche à résoudre
    
    // Résistances calibrées selon le niveau de l'user
    resistance_level: ResistanceLevel, // Easy / Medium / Hard / Expert
    resistance_patterns: Vec<ResistanceType>,
    
    // Triggers positifs (ce qui peut le convaincre)
    positive_triggers: Vec<String>,  // "Chiffres concrets", "Références similaires"
    
    // Comportements authentiques
    communication_style: String,     // "Direct, sceptique, coupe souvent la parole"
    body_language_hints: Vec<String>, // "Croisant les bras", "Regarde son téléphone"
    
    // État émotionnel dynamique (évolue pendant la session)
    current_mood: f32,              // -1.0 (hostile) à +1.0 (convaincu)
    mood_trajectory: Vec<MoodPoint>, // Historique de l'humeur pendant la session
}

// Constructeur Full-AI selon le contexte ASCENT
pub fn build_arena_persona(
    user_context: &UserContext,
    domain: &Domain,
    learned_skills: &Vec<SkillNode>,
    difficulty_target: DifficultyTarget,
) -> ArenaPersona {
    // 1. Analyser ce que l'user a appris → choisir les résistances
    //    qui vont forcer l'utilisation des techniques apprises
    
    // 2. Choisir un scenario réaliste dans le domaine
    //    → Pas inventé de toutes pièces, basé sur des patterns réels
    
    // 3. Calibrer la difficulté selon le SMI actuel
    //    → Trop facile = pas formateur / Trop dur = décourageant (Flow Theory)
    
    // 4. Intégrer des "opportunities" que l'user peut saisir
    //    → Si l'user a appris la technique X, créer un moment où X peut s'appliquer
    
    // 5. Rendre la psychologie cohérente et prévisible (dans le bon sens)
    //    → Le persona a sa propre logique interne — pas aléatoire
}
```

### 11.4 Domaines & Scenarios

ARENA s'adapte à **tout domaine pratique**. La distinction fondamentale :

```
THÉORIQUE (ASCENT classique) → Savoir que / Savoir comment
PRATIQUE (ARENA) → Pouvoir faire sous pression / avec les émotions / dans le vrai monde
```

#### Domaines Disponibles dès le Lancement

**1. VENTE & NÉGOCIATION**
```
Scenarios :
• Cold call — 60 secondes pour accrocher
• Démonstration produit face à un client sceptique  
• Objection sur le prix — justifier la valeur
• Closing difficile — décision retardée
• Négociation contrat — compromis gagnant-gagnant
• Client mécontent — transformer la situation

Personas possibles :
• DSI PME tech sceptique (budget serré, mauvaises expériences)
• Directeur Achat Corporate (procédures strictes, 3 soumissionnaires)
• Startup founder pressé (15 min max, décision rapide)
• Client existant insatisfait (à fidéliser absolument)
```

**2. MANAGEMENT & LEADERSHIP**
```
Scenarios :
• Feedback difficile à un collaborateur (sous-performance)
• Conflit entre deux membres d'équipe (arbitrage)
• Annonce d'une décision impopulaire
• Entretien d'embauche — évaluer un candidat
• Délégation — expliquer les attentes clairement
• One-on-one — motiver un collaborateur démotivé

Personas :
• Collaborateur senior résistant aux changements
• Candidat très qualifié mais arrogant
• Équipe frustrée après une décision top-down
```

**3. COMMUNICATION MÉDICALE** *(Phase 2+)*
```
Scenarios :
• Annonce diagnostic difficile à un patient
• Recueillir un historique médical complet
• Expliquer un traitement complexe simplement
• Patient non-compliant — comprendre et convaincre

Personas :
• Patient anxieux qui minimise ses symptômes
• Famille d'un patient âgé avec questions nombreuses
• Patient expert (qui a "tout lu sur Internet")
```

**4. FORMATION & PÉDAGOGIE** *(Phase 2+)*
```
Scenarios :
• Expliquer un concept complexe à un débutant
• Recadrer un apprenant qui stagne sans le décourager
• Animer une discussion de groupe difficile

Personas :
• Étudiant qui ne comprend pas mais refuse de le montrer
• Groupe hétérogène avec niveaux très différents
```

**5. PRISE DE PAROLE & PITCH** *(Phase 2+)*
```
Scenarios :
• Pitch investisseur en 3 minutes
• Présentation Board — questions difficiles
• TEDx style — captiver un audience diverse

Personas :
• Investisseur VC — ROI-obsessed, questions incisives
• Journaliste sceptique
• Public non-expert
```

### 11.5 La Session ARENA — Déroulement Technique

```rust
pub struct ArenaSession {
    id: Uuid,
    user_id: Uuid,
    goal_id: Uuid,
    
    // Configuration
    domain: Domain,
    scenario: ArenaScenario,
    persona: ArenaPersona,
    difficulty: DifficultyLevel,
    
    // Session live
    transcript: Vec<ArenaMessage>,
    persona_mood_timeline: Vec<f32>,  // Évolution humeur pendant session
    
    // Évaluation en temps réel (invisible pour l'user)
    live_analysis: LiveAnalysis,
    
    // Résultats
    session_score: Option<ArenaScore>,
    debrief: Option<ArenaDebrief>,
}

pub struct ArenaMessage {
    speaker: Speaker,           // User | Arena
    content: String,
    timestamp: u64,
    
    // Analyse invisible (pour le debrief final)
    technique_used: Option<String>,  // "Technique de l'accord partiel"
    opportunity_missed: Option<String>, // "Occasion de reformuler l'objection"
    persona_reaction: PersonaReaction,  // Comment le persona a réagi intérieurement
}

// Évaluateur temps réel — invisible pendant la session
pub struct LiveAnalysis {
    techniques_applied: Vec<TechniqueApplication>,
    opportunities_missed: Vec<MissedOpportunity>,
    emotional_intelligence: f32,     // EQ score
    structure_adherence: f32,        // Respect de la méthode apprise
    adaptability_score: f32,         // Adaptation aux réactions imprévues
    
    // Pour calibrer les réactions du persona
    user_performance_so_far: f32,    // Si bien → persona se détend légèrement
}
```

### 11.6 Le Debrief ARENA — Le Moment le Plus Précieux

Le debrief transforme l'expérience en apprentissage consolidé.

```
╔═══════════════════════════════════════════════════════════════════╗
║           ARENA DEBRIEF — Simulation "Cold Call B2B"              ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  SCORE GLOBAL : 68/100  [████████░░] Bon niveau, à approfondir   ║
║                                                                    ║
║  DIMENSIONS                                                        ║
║  Techniques apprises utilisées  : 72% [████████░░]               ║
║  Intelligence émotionnelle       : 65% [███████░░░]               ║
║  Adaptation aux résistances      : 71% [████████░░]               ║
║  Structure et clarté            : 74% [████████░░]               ║
║                                                                    ║
║  ✅ CE QUE TU AS BIEN FAIT                                        ║
║  • Reformulation de l'objection prix (min 1:23) — parfait         ║
║  • Demande de permission pour continuer — bonne pratique          ║
║  • Référence client similaire — a clairement rassuré [Marc]       ║
║                                                                    ║
║  ⚠️ OPPORTUNITÉS MANQUÉES                                        ║
║  • Min 0:47 : [Marc] a dit "on a déjà un prestataire" →          ║
║    Tu aurais pu demander "Qu'est-ce qui vous ferait envisager     ║
║    de changer ?" au lieu de continuer à pitcher                   ║
║                                                                    ║
║  • Min 2:15 : Sa voix s'est radoucie → Signal d'ouverture        ║
║    Tu n'as pas exploité ce moment (pas de question de closing)    ║
║                                                                    ║
║  🔴 CE QUI A NUIT                                                  ║
║  • Monologue de 45 secondes sans question (min 1:05-1:50)        ║
║    → [Marc] a commencé à regarder son téléphone                  ║
║  • "Notre solution est la meilleure du marché" → trop assertif   ║
║    → A déclenché de la résistance immédiate                      ║
║                                                                    ║
║  📚 EXERCICES RECOMMANDÉS                                         ║
║  → 3 nouvelles cartes APEX sur "Écoute active en vente"          ║
║  → Exercice ASCENT : "Techniques de closing indirect"            ║
║  → Rejouer le même scenario dans 3 jours (mémorisation)          ║
║                                                                    ║
║  🏆 PROCHAINE SESSION                                             ║
║  → Même scenario, difficulté +1 quand SMI ≥ 75%                 ║
║  → Ou : Nouveau scenario "Objection sur les délais"              ║
║                                                                    ║
║  [Rejouer maintenant] [Session ASCENT recommandée] [Partager]    ║
╚═══════════════════════════════════════════════════════════════════╝
```

### 11.7 Impact sur le SMI & Proof of Skill

ARENA alimente directement les dimensions SMI :

```rust
pub fn update_smi_from_arena(
    session: &ArenaSession,
    current_smi: &mut SmiState,
) {
    let score = session.session_score.as_ref().unwrap();
    
    // Dimension Profondeur (+25%) — Appliquer les techniques = prouver la compréhension profonde
    current_smi.depth = blend(
        current_smi.depth,
        score.techniques_applied_score,
        weight: 0.4  // 40% de la mise à jour vient d'ARENA
    );
    
    // Dimension Miroir (+20%) — Enseigner/Appliquer = dimension miroir
    current_smi.mirror = blend(
        current_smi.mirror,
        score.emotional_intelligence_score,
        weight: 0.3
    );
    
    // Dimension Métacognition (+10%) — Auto-évaluation pré/post session
    if session.user_predicted_score.is_some() {
        let calibration = measure_calibration(
            session.user_predicted_score.unwrap(),
            score.global_score,
        );
        current_smi.metacognition = blend(current_smi.metacognition, calibration, 0.5);
    }
}
```

**Proof of Skill ARENA** (composante pratique) :

```
Proof of Skill Standard = Théorie ASCENT (SMI ≥ 70 sur tous nœuds)
Proof of Skill ARENA    = Théorie + Pratique (SMI ≥ 70 + Score ARENA ≥ 70)

Pour les domaines pratiques (Vente, Management, etc.) :
→ Proof of Skill ARENA = PREUVE SUPÉRIEURE au Proof of Skill standard
→ Badge distinct : "Compétence Vérifiée en Conditions Réelles"
→ Visible sur le certificat LinkedIn avec mention ARENA
```

### 11.8 Coût LLM ARENA

```
Analyse contexte + construction persona  : ~$0.003 (1 appel LLM long)
Session roleplay (20-30 min)             : ~$0.008 (10-15 échanges × ~400 tokens)
Live analysis (invisible)                : $0.000 (algorithme Rust, scoring)
Debrief structuré                        : ~$0.004 (1 appel LLM analyse complète)
                                         ──────────────────────────────────────
TOTAL par session ARENA                  : ~$0.015 par session complète
Sessions/user/mois (estimation)          : 2-4 sessions
COÛT MENSUEL ARENA/user                  : ~$0.030-0.060/mois
```

### 11.9 Schéma BDD ARENA

```sql
-- Configuration session ARENA
CREATE TABLE scy_arena_sessions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  node_id UUID REFERENCES scy_ascent_nodes(id),  -- Nœud pratique concerné
  
  domain TEXT NOT NULL,              -- 'sales'|'management'|'medical'|'speaking'|'other'
  scenario_type TEXT NOT NULL,
  scenario_description TEXT NOT NULL,
  difficulty_level TEXT NOT NULL,    -- 'easy'|'medium'|'hard'|'expert'
  
  -- Persona généré
  persona_config JSONB NOT NULL,     -- Psychologie complète du personnage
  
  -- Déroulement
  transcript JSONB NOT NULL DEFAULT '[]',  -- [{speaker, content, timestamp, analysis}]
  persona_mood_timeline REAL[],      -- Évolution humeur -1.0 à +1.0
  session_duration_seconds INTEGER,
  
  -- Scores
  global_score REAL,                 -- 0-100
  techniques_score REAL,
  emotional_score REAL,
  adaptability_score REAL,
  structure_score REAL,
  
  -- Débrief
  debrief JSONB,                    -- {strong_points, missed_opportunities, issues, exercises}
  
  -- Impact sur apprentissage
  smi_impact JSONB,                 -- {depth_delta, mirror_delta, metacog_delta}
  exercises_generated UUID[],       -- Nouvelles cartes APEX créées
  
  -- État
  status TEXT NOT NULL DEFAULT 'active',  -- 'active'|'completed'|'abandoned'
  started_at INTEGER NOT NULL,
  ended_at INTEGER,
  created_at INTEGER NOT NULL
);

-- Personas persistants (réutilisables entre sessions)
CREATE TABLE scy_arena_personas (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  domain TEXT NOT NULL,
  scenario_type TEXT NOT NULL,
  difficulty_level TEXT NOT NULL,
  
  persona_template JSONB NOT NULL,   -- Template de base du persona
  
  -- Statistiques d'utilisation
  times_used INTEGER DEFAULT 0,
  avg_user_score REAL,
  avg_session_duration_s INTEGER,
  
  -- Versioning (le persona peut s'améliorer)
  version INTEGER DEFAULT 1,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- Proof of Skill ARENA
CREATE TABLE scy_arena_proof_records (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  
  domain TEXT NOT NULL,
  best_arena_score REAL,             -- Meilleur score sur ce domaine
  sessions_completed INTEGER,
  avg_score REAL,
  
  -- Certification
  practical_certified BOOLEAN DEFAULT false,
  certified_at INTEGER,
  certification_level TEXT,          -- 'foundational'|'proficient'|'advanced'
  
  -- Inclus dans Proof of Skill global
  included_in_pos UUID REFERENCES scy_proof_of_skill(id),
  
  created_at INTEGER NOT NULL
);

-- Indexes
CREATE INDEX idx_arena_sessions_user ON scy_arena_sessions(user_id, goal_id);
CREATE INDEX idx_arena_sessions_status ON scy_arena_sessions(status, created_at);
CREATE INDEX idx_arena_personas_domain ON scy_arena_personas(domain, difficulty_level);
CREATE INDEX idx_chronicle_memory_user ON scy_chronicle_memory(user_id);
CREATE INDEX idx_chronicle_disruptions_user ON scy_chronicle_disruptions(user_id, created_at DESC);
```

---

## SYNTHÈSE — Positionnement des 2 Nouveaux Agents

```
ASCENT v2 — 11 Agents Totaux (9 existants + 2 nouveaux)

Agents 01-09 : TOUS les tiers (Free + Premium)
┌─────────────────────────────────────────────────────┐
│  01 GOAL-INTERPRETER  →  Parse l'objectif           │
│  02 CONTENT-SCOUT     →  Ingestion sources           │
│  03 DAG-ARCHITECT     →  Construit le parcours       │
│  04 LEARNING-CONDUCTOR →  Orchestre chaque session   │
│  05 PERFORMANCE-ANALYZER → Calcule le SMI           │
│  06 ADAPTIVE-ROUTER   →  Route la progression       │
│  07 DRIFT-GUARDIAN    →  Détecte l'abandon          │
│  08 ENGAGEMENT-AMPLIFIER → Gamification             │
│  09 SKILL-CERTIFIER   →  Proof of Skill             │
└─────────────────────────────────────────────────────┘

Agent-10 CHRONICLE : PREMIUM uniquement
┌─────────────────────────────────────────────────────┐
│  → Coéquipier quotidien                             │
│  → Mémoire de la vie de l'user                     │
│  → Reprogramme si imprévu                           │
│  → S'adapte à chaque mode de communication         │
│  → Coût : ~$0.004/user/mois                        │
└─────────────────────────────────────────────────────┘

Agent-11 ARENA : PREMIUM uniquement
┌─────────────────────────────────────────────────────┐
│  → Validation pratique par simulation               │
│  → Persona Full-AI adapté au contexte user         │
│  → Tout domaine pratique (vente, management, etc.) │
│  → Debrief structuré + Impact SMI                  │
│  → Proof of Skill "Compétence en Conditions Réelles"│
│  → Coût : ~$0.015/session (~$0.04/user/mois)       │
└─────────────────────────────────────────────────────┘

TOTAL COÛT 11 AGENTS/USER PREMIUM/MOIS :
  Agents 01-09 : $0.006/parcours (déjà calculé)
  Agent-10     : +$0.004/mois
  Agent-11     : +$0.040/mois (2-4 sessions)
  ─────────────────────────────────────────
  TOTAL        : ~$0.050/user Premium/mois
  MARGE        : $10 - $0.050 = $9.95 (99.5% marge) ✅
```

---

**FIN SPEC CHRONICLE + ARENA V1**  
**Date** : 2026-06-09  
**Statut** : ✅ Prêt intégration PRD §4 ASCENT + §7 Features + §8 BDD + §11 Métriques  

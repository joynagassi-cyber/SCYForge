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

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
PRD source de vérité — adapter pour cyber beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

- → APEX/FSRS : Estimer niveau depuis historique révisions

**Output** : `LearningGoal` (domaine, heures estimées, niveau, prérequis, style)

**Coût LLM** : 1 appel × ~3K tokens = **$0.0003** (1 seule fois par parcours)

**[OPTIMISATION ASCENT-01 — DYNAMIC GRAPH SPLITTING (RÉSOLUTION HIÉRARCHIQUE PROGRESSIVE)]** :
Pour réduire la latence initiale de génération et la surcharge cognitive de l'utilisateur, le `GOAL-INTERPRETER` n'instancie pas l'intégralité du parcours s'il dépasse 15h d'apprentissage estimé. Il produit un graphe macro-conceptuel de haut niveau (3 à 5 grands jalons de compétences) et ne détaille sous forme de sous-graphe de basse résolution (5 à 8 nœuds concrets) que le premier jalon actif. Les jalons suivants restent des "nœuds enveloppes" de haute abstraction qui seront détaillés à la volée lorsque l'utilisateur s'en approchera.
- **Gain de performance** : Le temps jusqu'à la première valeur d'onboarding (TTFV) est réduit de 3 min à **moins de 20 secondes**.
- **Marge d'économie** : Division par 4 du coût initial LLM de génération.

**Sous-fonctionnalités d'entrée** *(v2 — voir SPEC-BRAIN-ONBOARDING-V1)* :

**[LE SERMENT DE RIGUEUR & TRANSPARENCE DE SCY FORGE]** :
SCY Forge refuse d'éditer des formations "miracles" superficielles. Si l'utilisateur a 0 prérequis et veut un objectif massif (ex: "Data Scientist"), `AGENT-01` refuse d'instancier un cours unique mensonger. Il décompose le cursus de 3 ans en un enchaînement de **Micro-Goals / Micro-Certifications précis (max 120h d'apprentissage actif par jalon)**. Il affiche un avertissement de transparence : *"Pour atteindre ce niveau pro, vous devez valider ces 4 jalons successifs sur 12 mois. La maîtrise s'acquiert par la pratique et l'espacement temporel."* L'utilisateur valide cet engagement avant de démarrer.

*A. Clarification (Intent Elucidator)* — tout début du parcours :
- Sous-agent dédié à l'élucidation précise de l'intention (prévention de la confusion en aval)
- Questions **auto-générées**, claires et directes
- Réponses par **options numérotées 1 à 5** (+ champ libre optionnel)
- **Clarifications successives** jusqu'à un score de clarté suffisant (défaut ≥ 80, max 5 tours)
- Timer d'auto-validation 30 s → option par défaut

*B. Starter Evaluator (Évaluation de niveau)* — après les clarifications :
- **Questions stratégiques et ciblées** (difficulté adaptative)
- Exploite d'abord les signaux passifs (COSMOS KG, APEX historique, BRAIN) — 0 token
- **Classification** : `Débutant` / `Intermédiaire` / `Avancé` / `Expert` (+ intervalle de confiance)
- Détermine la **présentation et l'adaptation** du contenu (pédagogie personnalisée)
- Handoff → auto-positionnement DAG (SINKT, Agent-03)

#### AGENT-02 : CONTENT-SCOUT
**Mission** : Trouver et ingérer automatiquement les meilleures sources

**Features orchestrées** :
- → 11 Ingestion Cores : Recherche parallèle YouTube, Web, Academic, Drive...
- → MapReduce L0-L4 : Processing automatique de chaque source
- → NEURON-CHAINS : Déclenchement génération documentaire post-ingestion
- → COSMOS : Mise à jour KG avec nouveaux concepts extraits
- → SemanticCache (LanceDB) : Déduplication, évite ré-ingestion

**Output** : `ContentScouting` (sources ingérées, couverture par nœud DAG, gaps)

**Coût LLM** : Cache mutualisé → 0 appel si objectif populaire / ~6K tokens si nouveau = **$0.0006**

#### AGENT-03 : DAG-ARCHITECT
**Mission** : Construire le graphe de compétences + générer tous les contenus

**Features orchestrées** :
- → NEURON-CHAINS (7 chaînes) : Génération docs par nœud (cours, résumés, guides)
- → APEX/FSRS : Création flashcards pour chaque concept clé
- → BRAIN : Indexation chunks RAG par nœud (Q&A contextuel)
- → COSMOS : Population Knowledge Graph + Roadmap mode 4
- → petgraph : Validation DAG (4 passes : cycles, dépendances, coverage, cohérence)
- → SINKT (PAPER-009) : Auto-positionnement user dans le DAG

**Output** : `CompetenceDAG` validé, 15 nœuds typiques, contenus générés

**Coût LLM** : Batch processing + cache mutualisé → **~$0.0032** pour 15 nœuds

**[OPTIMISATION ASCENT-03 — PROGRESSIVE INSTANTIATION & BATCH API]** :
Le `DAG-ARCHITECT` utilise la technique de génération progressive couplée au *Dynamic Graph Splitting*. Au lieu de compiler et de générer les documents NEURON-CHAINS et les cartes APEX pour les 15 nœuds dès le premier jour, il génère les contenus pour le premier jalon de compétence actif. Le reste est pré-généré de manière asynchrone via la **DeepSeek Batch API** (bénéficiant de -50% de coût LLM supplémentaire) en arrière-plan pendant que l'utilisateur réalise sa première session d'étude.

#### AGENT-04 : LEARNING-CONDUCTOR ← CERVEAU PRINCIPAL
**Mission** : Orchestrer chaque session d'apprentissage en temps réel

**Features orchestrées** :
- → APEX/FSRS : Scheduling révisions, sélection cartes dues
- → BRAIN/RAG : Assistant contextuel pendant l'apprentissage
- → COSMOS (26 modes) : Mise à jour visualisation progression — mode auto-suggéré selon structure cognitive
- → IMPRINT : Déclenchement mémorisation profonde (après 3 succès + nœud complexe)
- → NEURON-CHAINS : Génération contenu supplémentaire si besoin
- → EventBus : Notification des autres agents

**Décision algorithmique (AUCUN appel LLM)** :

```
Temps disponible → Type session :
  0-10 min → Tiny Session (5 cartes — Fogg Tiny Habits, maintien de la chaîne)
  11-30 min → Session standard (exercice + révisions)
  31-60 min → Session longue (nouveau doc + exercices + révisions + IMPRINT si trigger)
  60+ min → Marathon (plan nœud complet)

Chaque décision = règle Rust déterministe, ZÉRO token LLM
```

**[RETENTION SCIENCE — ASCENT-RET-004] Habit Formation Engine J1-J30** :
- Protocole 30 premiers jours (période critique — 5× rétention à J90 si habitude formée)
  - J1-J7 : Sessions ≤ 10 cartes, heure fixe, rappel ancré au comportement existant
  - J8-J21 : Sessions 15-20 cartes + Variable Rewards (badges mystères aléatoires)
  - J22-J30 : Sessions normales + célébration "21 jours = habitude formée neurologiquement"
- Anchor Behavior (BJ Fogg) : "After I [café/transport/dîner], I will [5 cartes APEX]"
- Tiny Session toujours disponible pour les jours difficiles ("Juste 5 cartes, 3 min")
- Variable Reward System : Insight COSMOS surprise (15% prob./session) + Badge mystère + Cross-domain discovery

**[RETENTION SCIENCE — ASCENT-RET-008] Metacognitive Prompt PRÉ-session** :
- Avant chaque session : "Sur ce concept, vous vous sentez à quel point confiant ? (1-5)"
- Alerte Dunning-Kruger si confiance >> performance réelle (+15% outcomes — ACM 2025)
- Résultat stocké → calibration Métacognition SMI

**[RETENTION SCIENCE — ASCENT-RET-009] Weekly Proximal Goal** :
- Chaque lundi : Génération automatique objectif proximal de la semaine
- Visible dashboard principal (pas seulement dans l'agent)
- Ajustable par l'user (SDT : autonomie)
- Célébration dimanche si atteint (confetti + message)

**[OPTIMISATION ASCENT-04 — DOUBLE-ENGINE FSRS ↔ BLOOM LOOP]** :
<!-- PIVOT-BEACHHEAD: apprenant générique → opérateurs cyber P-SOC1 (L1/L2 analyst) et P-SOC2 (L3+ analyst senior) -->
Le `LEARNING-CONDUCTOR` synchronise l'état FSRS de l'opérateur P-SOC1/P-SOC2 avec la taxonomie de Bloom des nœuds d'apprentissage (Niveau 1 : Se souvenir, Niveau 2 : Comprendre, Niveau 3 : Appliquer, Niveau 4 : Analyser, Niveau 5 : Évaluer, Niveau 6 : Créer). 
- **Principe** : L'accès aux exercices et simulations d'application de niveau de Bloom supérieur (≥ 3) sur un concept donné est bloqué tant que la stabilité FSRS locale calculée par APEX n'a pas atteint un seuil minimal de consolidation ($\text{Stability} \ge 3.0$ jours, assurant un ancrage sémantique suffisant).
- **Routage de secours** : Si l'utilisateur commet des échecs récurrents sur les exercices pratiques (SMI de profondeur < 60), le système émet automatiquement un signal de remédiation qui réactive les cartes de mémorisation associées à ce concept pour reconstruire les fondations cognitives.

```rust
// Routage déterministe Rust ($0 LLM) de synchronisation FSRS ↔ Bloom
pub fn determine_session_path(
    user_smi: &SmiProfile,
    node_bloom_level: BloomLevel,
    fsrs_stability: f64
) -> StudySessionType {
    if fsrs_stability < 3.0 && node_bloom_level >= BloomLevel::Apply {
        // Tente d'appliquer sans mémorisation solide -> Remédiation d'ancrage
        StudySessionType::ConsolidationReview { target_concepts: vec![] }
    } else if user_smi.retention_score >= 85.0 && user_smi.depth_score < 50.0 {
        // Parfait par cœur, mais blocage pratique -> Session d'Application Intensive
        StudySessionType::ActivePractice { difficulty_multiplier: 1.2 }
    } else {
        StudySessionType::StandardSession
    }
}
```

**Coût LLM** : **$0.00** (orchestration pure par règles Rust)

#### AGENT-05 : PERFORMANCE-ANALYZER
**Mission** : Calculer le SMI en continu (5 dimensions) + estimer l'état Flow de l'utilisateur

**SMI = Score de Maîtrise Intégrée /100 (Formalisation Mathématique Rigoureuse)** :
Pour assurer la validité scientifique et la confiance des recruteurs dans la certification *Proof of Skill*, le SMI est calculé de manière continue par l'algorithme déterministe de l'architecture Rust ($0 LLM) selon la formule suivante pour un utilisateur $u$, sur un nœud $n$ à un instant $t$ :

$$SMI_n(u, t) = w_r \cdot R_n(u, t) + w_d \cdot D_n(u) + w_m \cdot M_n(u) + w_c \cdot C_n(u) + w_h \cdot H(u)$$

Où les coefficients de pondération empiriques sont définis par :
- $w_r = 0.35$ (Rétention cognitive)
- $w_d = 0.25$ (Profondeur d'application)
- $w_m = 0.20$ (Miroir de transmission)
- $w_c = 0.10$ (Justesse métacognitive)
- $w_h = 0.10$ (Cohérence de l'habitude d'étude)

##### Les 5 Composants Algorithmiques :

1. **Rétention ($R_n \in [0, 100]$)** : Équivaut à la retrievability moyenne estimée par FSRS 5.0 pour toutes les cartes associées au nœud :
   $$R_n(u, t) = \frac{100}{|C_n|} \sum_{c \in C_n} e^{-\frac{\Delta t_c}{S_c}}$$
   *(Où $C_n$ est l'ensemble des cartes liées au nœud, $S_c$ est la stabilité FSRS de la carte $c$, et $\Delta t_c$ le temps écoulé depuis sa dernière révision).*

2. **Profondeur ($D_n \in [0, 100]$)** : Moyenne de réussite pondérée par la complexité et la difficulté des exercices pratiques validés sur le nœud :
   $$D_n(u) = 100 \cdot \frac{\sum_{e \in E_n} \text{score}(e) \cdot \text{diff}(e)}{\sum_{e \in E_n} \text{diff}(e)}$$
   *(Où $E_n$ est l'ensemble des exercices complétés, $\text{score}(e) \in [0, 1]$ le score obtenu, et $\text{diff}(e) \in [1, 5]$ le niveau de complexité de l'exercice).*

3. **Miroir ($M_n \in [0, 100]$)** : Évaluation de la capacité à enseigner et transmettre le concept (Teach-Back STUDENT AI + simulations ARENA si Premium) :
   $$M_n(u) = 0.5 \cdot \text{Score}_{\text{TeachBack}}(u) + 0.5 \cdot \text{Score}_{\text{Arena}}(u)$$

4. **Métacognition ($C_n \in [0, 100]$)** : Évalue la justesse de l'auto-évaluation de l'opérateur P-SOC1/P-SOC2 pour contrecarrer l'effet Dunning-Kruger :
   $$C_n(u) = 100 \cdot \left(1 - \min\left(1, \; \left| \frac{\text{Confiance}_{\text{Déclarée}}(u) - SMI_{\text{Objectif}}(u)}{100} \right| \right)\right)$$

5. **Cohérence ($H \in [0, 100]$)** : Mesure de la régularité d'apprentissage (implémentation de la science des habitudes) :
   $$H(u) = 100 \cdot \left(1 - e^{-\lambda \cdot f}\right)$$
   *(Où $f$ est la fréquence hebdomadaire des sessions, et $\lambda = 0.5$ un facteur d'échelle régulant l'ancrage de l'habitude).*

**[RETENTION SCIENCE — ASCENT-RET-001] Flow State Estimator** :
Basé sur Flow Theory (Csikszentmihalyi, 30 ans de recherche) :
```
flow_zone = f(error_rate, response_time, session_duration, return_frequency)

error_rate optimal : 15-30% (assez difficile pour engager, pas trop pour décourager)
→ Anxiety Zone (>35% erreurs) : Signal vers Agent-06 → réduire difficulté
→ Flow Zone (15-30%) : Maintenir le cap
→ Boredom Zone (<10% erreurs) : Signal vers Agent-06 → augmenter difficulté / Fast-Track
```

**[RETENTION SCIENCE — ASCENT-RET-002] SDT Satisfaction Monitor** :
Mesure continue des 3 Besoins Psychologiques (Self-Determination Theory) :
- **Autonomie** : L'user modifie-t-il ses horaires/objectifs ? (customisation = autonomie satisfaite)
- **Compétence** : SMI progresse ? Milestones atteints ? (sens du progrès réel)
- **Relatedness** : Teach-Back, partage Proof of Skill, feedback communautaire (Phase 2+)
→ Si SDT global < 0.4 pendant 14j → Signal prioritaire vers DRIFT-GUARDIAN + CHRONICLE

**Coût LLM** : **$0.00** (algorithme mathématique Rust pur, 1800 révisions = $0)

#### AGENT-06 : ADAPTIVE-ROUTER
**Mission** : Décider la trajectoire optimale selon le SMI ET l'état Flow

```
SMI ≥ 86 → FAST-TRACK : Skip nœuds simples (+heures économisées)
SMI 70-85 → NORMAL : Progression standard vers nœud suivant
SMI 60-69 → CONSOLIDATION : Exercices additionnels + révisions intensives
SMI < 60  → REMEDIATION : 5 types actions correctives
Plateau (variance SMI <2 sur 5 sessions) → STRATÉGIE CHANGE
```

**[RETENTION SCIENCE] Routing enrichi par Flow + Goal Setting** :

```
Flow = Anxiety (erreurs > 35%) → Réduire difficulté immédiatement
  + proposer ProximalGoalDecomposition (sous-objectif micro atteignable)
  + passer à Tiny Session si session tronquée détectée

Flow = Boredom (erreurs < 10%) → Augmenter difficulté
  + proposer Fast-Track ou ARENA (si Premium + nœuds théoriques OK)
  + nouveau challenge (exercice complexité +1)

Goal Setting (ASCENT-RET-005) :
  Chaque lundi → génère Weekly Proximal Goal (ambitieux +15% vs baseline, ajustable)
  Chaque jour  → alerte si objectif proximal du jour non commencé après heure optimale

SDT Guard-Rails (ASCENT-RET-002) :
  JAMAIS "Vous allez perdre votre streak" comme message principal
  JAMAIS Leaderboard sur chemin critique (opt-in uniquement)
  TOUJOURS montrer le POURQUOI d'un badge avant de le délivrer
```

**Features orchestrées** :
- → DAG Repository : Modification dynamique parcours
- → Content-Scout : Re-déclencher si contenu insuffisant
- → NEURON-CHAINS : Contenu alternatif si blocage (ton différent)
- → APEX : Intensification révisions si SMI < 60%
- → BRAIN : Mode "pair tutor" si remédiation CRITICAL
- → ARENA (Premium) : Déclencher session pratique si SMI théorique ≥ 70
- → CHRONICLE (Premium) : Informer du changement de trajectoire

**Coût LLM** : **$0.00** (règles déterministes Rust)

#### AGENT-07 : DRIFT-GUARDIAN
**Mission** : Détecter les signaux d'abandon et intervenir proactivement avec une précision scientifique

**[RETENTION SCIENCE — ASCENT-RET-003] Signaux avec poids SHAP empiriques**
<!-- PIVOT-BEACHHEAD: apprenants → opérateurs cyber P-SOC1/P-SOC2 -->
_(Source : TRIAD-Drop arXiv 2507.05285 — 89% accuracy, F1 0.88, validé sur 4 423 opérateurs P-SOC1)_

| Rang | Signal | Poids SHAP | Seuil Alerte |
|------|--------|-----------|-------------|
| #1 | Désengagement exercices / skips | 0.28 | 2-3 skips consécutifs |
| #2 | Réduction durée sessions | 0.22 | -40% vs baseline 7j |
| #3 | Diminution fréquence interactions | 0.18 | < 50% fréquence habituelle |
| #4 | Sessions tronquées | 0.15 | > 50% sessions abandonnées |
| #5 | SMI en déclin | 0.08 | -15 pts sur 14j |
| #6 | Sentiment négatif (si BRAIN actif) | 0.05 | Score sentiment < -0.3 |
| #7 | Skips nœuds | 0.04 | 3 consécutifs |
| #8 | Changement rythme | 0.00 | Signal combinatoire seulement |

**Urgence d'intervention selon risque + inactivité** :
```
Risque > 0.80 ET inactif > 48h → Intervenir dans 2h (CRITIQUE)
Risque > 0.60 ET inactif > 24h → Intervenir dans 8h (HIGH)
Risque > 0.40             → Intervenir dans 24h (MEDIUM)
Risque < 0.40             → Surveiller (LOW)
```

**[RETENTION SCIENCE] Interventions Evidence-Based** _(+25-37% reprise, CIO 2025)_ :

- **LOW** : Notification motivationnelle personnalisée + Progress Reframe ("Tu as déjà maîtrisé X concepts")
- **MEDIUM** : Simplifier nœud + Tiny Session proposée + ProximalGoalDecomposition (micro-objectif)
- **HIGH** : Email personnalisé + BRAIN mode coach empathique + Anchor Behavior reminder (CHRONICLE)
- **CRITICAL** : Restructurer DAG + proposer sous-objectif + [Premium] CHRONICLE reprogramme tout le plan

**[OPTIMISATION ASCENT-07 — PROTOCOLE DE RÉ-ENTRÉE SANS FRICTION (FRICTIONLESS RE-ENTRY)]** :
Lorsqu'un opérateur P-SOC1/P-SOC2 décroche (absence > 7 jours), l'envoi de relances traditionnelles ou l'exposition brutale d'une pile énorme de révisions dues induit l'**effet d'évitement de l'échec** (le stress de la montagne de travail provoque l'abandon définitif).
- **Le Protocole** : Dès que le score de dérive de l'utilisateur dépasse $0.80$ (risque critique d'abandon), `DRIFT-GUARDIAN` et `CHRONICLE` activent le **Mode Minimal / Tiny Habit (BJ Fogg)**.
- **Logique d'engagement** : Le backlog massif de flashcards est masqué. Le système s'engage à exiger un micro-effort d'une simplicité désarmante : *"Ton parcours est gelé pour te laisser souffler. Faisons juste 3 cartes prioritaires aujourd'hui (90 secondes) pour garder le contact avec le sujet."*
- **Dopamine Trigger** : Dès que l'utilisateur valide ces 3 cartes, un **Variable Reward** surprise (ex: un badge mystère ou une insight COSMOS inédite) est débloqué pour générer une micro-décharge de dopamine et lui redonner envie de poursuivre de lui-même.

**Nouvelles interventions ajoutées (retention science)** :
- **MetacognitivePromptPreSession** : Avant session → calibrer confiance (prévient abandon par frustration)
- **TinySession** : 5 cartes = 3 min → "Juste maintenir la chaîne aujourd'hui"
- **VariableRewardSurprise** : Récompense inattendue si retour après gap > 3j (effet dopamine)
- **ProgressReframe** : Montrer CE QUI EST ACQUIS, pas ce qui manque

**Coût LLM** : 3 appels max si drift détecté × ~500 tokens = **$0.00015** (rare)

<!-- PIVOT-BEACHHEAD: ENGAGEMENT-AMPLIFIER refactor Plan C (contrat domaine, pas savoir cyber hardcodé) -->
<!-- DEFERRED BEYOND BEACHHEAD MVP -->
#### AGENT-08 : ENGAGEMENT-AMPLIFIER
**Mission** : Maintenir la motivation via gamification scientifiquement calibrée et rapports

**Système Gamification SDT-Compliant** _(SDT Guard-Rails — Self-Determination Theory)_ :

**Récompenses GARANTIES (motivation de base)** :
- XP gagnés (actions → points)
- Niveaux (Novice → Explorer → Scholar → Master → Legend)
- Badges milestones (streaks 7/30/100j, nœuds complétés, vitesse progression)
- Confetti effect (milestones importants via WebSocket push)

**[RETENTION SCIENCE — ASCENT-RET-007] Variable Reward System** :
_(Dopamine variable ratio reinforcement — PMC 2025 — le schedule le plus puissant)_
- 🎲 **Insight Surprise COSMOS** (15% prob./session complète) : Connexion inattendue révélée entre deux concepts
- 🏅 **Badge Mystère** : Pool de badges inconnus, révélés sans annonce préalable
- ⚡ **Performance Surprise** : "Votre mémorisation est dans le top 10% aujourd'hui !"
- 🌉 **Cross-Domain Discovery** : "Votre technique MITRE ATT&CK T1566.001 ressemble à [T1059 que vous maîtrisez]"

**[RETENTION SCIENCE] SDT Guard-Rails obligatoires** :
```
RÈGLE SDT-G1 : Jamais "Vous allez perdre votre streak" — dire "Votre parcours continue demain"
RÈGLE SDT-G2 : Leaderboards OPT-IN uniquement, jamais sur chemin critique
RÈGLE SDT-G3 : Streak Freeze = "protection du parcours" pas "sauvetage du score"
RÈGLE SDT-G4 : Toujours le POURQUOI du badge avant sa délivrance
RÈGLE SDT-G5 : Gamification qui contrôle = détruit motivation intrinsèque → bannir
```

**[RETENTION SCIENCE — ASCENT-RET-006] Soft Commitment Device** _(+37% rétention 12 mois)_ :
- À l'onboarding J1 : "Je m'engage à maîtriser [Objectif] d'ici le [Date]"
- Email de confirmation de l'engagement envoyé à J1
- Weekly Check-in automatique (dimanche) : bilan semaine + objectif semaine suivante
- Slider auto-évaluation hebdomadaire (confiance 1-5) → calibration métacognition

**Rapports automatiques :**
- Rapport hebdomadaire généré par NEURON-CHAINS (type B01) — avec Weekly Proximal Goal atteint/non atteint
- Export PDF Typst professionnel
- SMI evolution chart (Recharts) — avec comparaison semaine précédente
- ETA completion prédictive (basé FSRS forecast + Flow score actuel)

**Partage social :**
- LinkedIn : "J'ai maîtrisé la détection d'APT29 — SMI 87/100 (SCY Forge)"
- Twitter : Partage milestone + lien vérification

**Coût LLM** : 4 appels/mois × ~750 tokens = **$0.0003/mois**

#### AGENT-09 : SKILL-CERTIFIER
**Mission** : Vérifier et certifier la compétence atteinte

**Déclenchement** : Automatique quand tous les nœuds SMI ≥ seuil requis

**Processus :**
1. Vérification complétude (tous nœuds ≥ smi_required)
2. Évaluation finale cross-nœuds (15 questions synthétiques)
3. Calcul SMI global 5 dimensions
4. Génération Proof of Skill (PDF Typst professionnel)
5. Badge LinkedIn (Open Badges standard)
6. Suggestions objectifs suivants (graphe continuité)

**Proof of Skill inclut :**
- ID unique vérifiable (scy_forge.app/verify/SCY-XXXX)
- Score global /100 + breakdown 5 dimensions
- Statistiques parcours (jours, sources, exercices, streaks)
- QR Code vérification employeurs
- Export JSON machine-readable (API-ready)

**Coût LLM** : 2 appels finaux × ~2.5K tokens = **$0.0005** (1 seule fois)

---

<!-- PIVOT-BEACHHEAD: CHRONICLE deferred — pas de contexte personnel cyber MVP, extension post-MVP -->
<!-- DEFERRED BEYOND BEACHHEAD MVP -->
#### AGENT-10 : CHRONICLE — Coéquipier IA Quotidien 🤝 `[Premium uniquement]`

**Mission** : Vivre avec l'utilisateur au quotidien — connaître sa vie, adapter le plan d'apprentissage à sa réalité, reprogrammer sans friction quand la vie interfère.

**Philosophie** : L'humain n'a pas besoin de plus de réflexion. Il a besoin d'un coéquipier qui pense la planification à sa place, pour qu'il puisse utiliser toute son énergie à apprendre.

**Ce que CHRONICLE fait (les autres agents ne font pas)** :
- Existe même quand l'utilisateur n'est PAS dans SCY Forge
- Mémorise le rythme de vie réel (détecté, pas seulement déclaré)
- Reprogramme automatiquement quand un imprévu est signalé
- Propose 2-3 options concrètes (extension / bootcamp / redistribution)
- S'adapte au mode de communication de chaque utilisateur

**[INTÉGRATION AVEC DRIFT-GUARDIAN — PROTOCOLE FRICTIONLESS RE-ENTRY]** :
En cas d'absence prolongée de l'utilisateur, `CHRONICLE` prend en charge l'exécution du protocole de ré-entrée sans friction (Mode Tiny Habit). Il contacte l'utilisateur en lui proposant la session minimale (3 cartes) pour réenclencher l'habitude en douceur, préservant ainsi la rétention cognitive sans provoquer l'anxiété de la charge de travail accumulée.

**3 scénarios typiques** :

*Scénario A — L'Imprévu* :
```
User : "J'ai un imprévu demain, je peux pas faire ma session"
CHRONICLE analyse : DAG actuel + date Proof of Skill cible + historique retards
CHRONICLE propose :
  → Option 1 : "On décale. Nouveau planning sur 3 jours pour rattraper."
  → Option 2 : "La date reste le 15 juillet si tu fais 2×20min mercredi-jeudi."
  → Option 3 : "Bootcamp ce week-end (3h Sam + 2h Dim) = tout rattrapé. OK ?"
```

*Scénario B — L'Oubli* :
```
CHRONICLE détecte (21h30) : session prévue 19h non faite
CHRONICLE (1 seul message) :
"Tu as oublié ce soir. 5 cartes = 3 minutes. Tu peux maintenant ?
[Oui, maintenant] [Demain matin]"
```

*Scénario C — La Semaine Décalée* :
```
User : "J'ai raté 5 jours cette semaine"
CHRONICLE : "3 options selon ce que tu préfères :
🔵 SOUPLE : +1 semaine formation. Même rythme.
🟠 STANDARD : Bootcamp 3 jours (Sat/Sun/Lun). Date inchangée.
🔴 INTENSIF : 2×20min/jour pendant 2 semaines. Date inchangée."
```

**Mémoire Contextuelle Persistante** :
- Rythme de vie observé (pas seulement déclaré) : jours creux, heures optimales, patterns récurrents
- Historique imprévus : type, fréquence, comment l'user les a gérés
- Préférences communication : ton, verbosité, mode préféré (proactif / réactif / minimal)
- Track record engagements : pour calibrer les propositions réalistes

**Modes d'Interaction Adaptatifs** (détectés comportementalement, pas imposés) :
- ChatFree : L'user écrit librement, CHRONICLE interprète
- StructuredCheckIn : L'user préfère des options numérotées
- ProactiveOnly : CHRONICLE contacte en premier à l'heure prévue
- Minimal : L'user veut le minimum de contact

**Personnalité adaptative selon le contexte** :
- Coach exigeant : quand l'user a besoin d'être poussé (retard répété, plateau)
- Partenaire bienveillant : quand l'user galère (période difficile, fatigue)
- Chef de projet : quand l'user veut du concret sans discussion

**Coût LLM** :
```
Check-in proactif / détection (règles Rust)   : $0.00
Message personnalisé si disruption            : $0.0002 (1 appel ~600 tokens)
Réponse à message libre de l'user            : $0.0003 (1 appel ~800 tokens)
Estimation mensuelle (4-6 disruptions/mois)  : ~$0.004/user/mois
```

**Tier** : Premium uniquement — différenciateur clé justifiant le pricing

---

<!-- PIVOT-BEACHHEAD: ARENA MVP = APT29 scenario uniquement. IR Triage, DFIR Investigation, CISO Briefing deferred Post-MVP -->
<!-- DEFERRED BEYOND BEACHHEAD MVP (APT29 scenario retained for MVP) -->
#### AGENT-11 : ARENA — Agent de Validation Pratique 🎭 `[Premium uniquement]`

**Mission** : Transformer la théorie en compétence réelle à travers des simulations haute-fidélité où l'IA incarne le monde réel — un attaquant APT29, un analyste IR sous pression, un enquêteur DFIR, un DSI en crise.

**Le problème résolu** : Pour les opérations SOC/DFIR/CIRT, la théorie ne suffit pas. On ne peut pas prouver qu'on sait répondre à un incident APT29 avec un QCM. ARENA crée l'épreuve du feu avant la vraie.

**Le Cycle ARENA** :
```
ASCENT détecte → SMI ≥ 70 sur nœuds théoriques + domaine pratique identifié
                            ↓
ARENA-ANALYZER  → Analyse compétences apprises + domaine + niveau
                            ↓
ARENA-PERSONA   → Construit psychologie complète du personnage (Full-AI)
                            ↓
SESSION LIVE    → Roleplay haute-fidélité cyber (APT29 social engineering, IR Triage, DFIR Investigation, CISO Briefing)
                            ↓
ARENA-EVALUATOR → Debrief structuré : forces, opportunités manquées, axes amélioration
                            ↓
ASCENT FEEDBACK → SMI Profondeur + Miroir mis à jour + nouveaux exercices ciblés
                  OU : Proof of Skill "Compétence en Conditions Réelles"
```

**Le Persona Full-AI** : ARENA analyse le contexte de l'opérateur (niveau SOC, MITRE techniques maîtrisées, type d'environnement défensif) et construit un persona cyber complet :
- Rôle et situation précise ("DSI PME tech, budget serré, vient de subir une compromission APT29")
- Psychologie cyber (motivations professionnelles, peurs conformité/breach, style de décision sécurité)
- Résistances calibrées selon le niveau de l'opérateur (Flow Theory — ni trop facile, ni trop difficile)
- Triggers positifs (ce qui peut faire basculer la décision d'investigation)
- État émotionel dynamique (évolue selon les réponses de l'opérateur)

<!-- PIVOT-BEACHHEAD: APT29 scenario ONLY at MVP. IR Triage, DFIR Investigation, CISO Briefing deferred to POST-MVP expansion -->

**[OPTIMISATION TECHNIQUE ARENA — ARCHITECTURE HSM DE PERSONA (HIERARCHICAL STATE MACHINE)]** :
Pour éliminer les risques de dérive du personnage (l'IA oubliant sa posture et devenant trop coopérative ou sortant de son rôle) et minimiser l'usage de tokens, ARENA structure son persona sous forme de **machine à états finis hiérarchique** (HSM).
- **Principe** : Le comportement et le ton du personnage sont dictés par un état psychologique actif (ex: *Méfiant*, *Intéressé*, *Convaincu*, *Fermé*) ré-évalué en continu par l'application Rust ($0 LLM).
- **Humeur dynamique** : L'état évolue sur un axe de score émotionnel (Mood score) mis à jour après chaque message de l'utilisateur via une classification sémantique ultra-rapide réalisée par DeepSeek V4.
- **Rendement en cache** : Au lieu d'envoyer un prompt système gigantesque à chaque échange, le prompt envoyé au LLM ne contient qu'une courte consigne correspondant à l'état actif actuel (ex: *"Tu es dans l'état MÉFIANT. Réponds brièvement avec froideur, n'accepte aucune offre sans reformulation d'objection"*). Cela permet de **conserver à 100% le Prompt Caching de DeepSeek**, abaissant l'utilisation de tokens système de **-40% par message**.

<!-- PIVOT-BEACHHEAD: Vente/Médecine/Arts → Cyber scenarios (APT29, IR Triage, DFIR Investigation, CISO Briefing) -->
**Domaines disponibles** :

| Domaine | Lancement | Scenarios Clés |
|---------|-----------|---------------|
| <!-- PIVOT-BEACHHEAD: Vente & Négociation → APT29 Social Engineering Simulation --> **APT29 Social Engineering** | ✅ Phase 0 | Phishing ciblé, pretexting, spear-phishing, credential harvesting |
| <!-- PIVOT-BEACHHEAD: Management → IR Triage --> **IR Triage** | ✅ Phase 0 | Classification incident, priorisation, escalation, communication crise |
| <!-- PIVOT-BEACHHEAD: Communication Médicale → DFIR Investigation --> **DFIR Investigation** | ✅ Phase 0 | Analyse forensique, timeline reconstruction, malware analysis, rapport final |
| <!-- PIVOT-BEACHHEAD: Pédagogie → CISO Briefing --> **CISO Briefing** | Phase 2 | Explication risque cyber au board, demande budget SOC, présentation conformité |

**Le Debrief ARENA** — ce qui rend la session précieuse :
```
SCORE GLOBAL : 68/100
✅ Identification correcte de l'IoC (indicateur de compromission) (min 1:23) — parfait
✅ Corrélation avec le MITRE ATT&CK T1059 — a clairement renforcé la Threat Intelligence
⚠️ Opportunité manquée (min 0:47) : "Processus de containment immédiat"
   → Aurais pu proposer l'isolation du endpoint avant l'escalade
🔴 45s sans question de clarification (min 1:05-1:50) → persona a décroché
   → Technique "Questionnement systématique sur la timeline" non appliquée

📚 Exercices générés automatiquement dans ASCENT :
   3 nouvelles cartes APEX sur "Analyse forensique Windows Event Logs"
   + Exercice "Rédaction de rapport d'incident DFIR"
```

**Proof of Skill ARENA** (composante pratique supérieure) :
```
Proof of Skill Standard   = Théorie ASCENT (SMI ≥ 70 tous nœuds)
Proof of Skill ARENA      = Théorie + Pratique (SMI ≥ 70 + Score ARENA ≥ 70)
→ Badge distinct : "Compétence Vérifiée en Conditions Réelles"
→ Visible sur certificat LinkedIn avec mention ARENA
→ Pour domaines pratiques : preuve supérieure au certificat classique
```

**Coût LLM** :
```
Analyse contexte + construction persona  : $0.003 (1 appel LLM long)
Session roleplay (20-30 min)             : $0.008 (10-15 échanges)
Debrief structuré                        : $0.004 (1 appel analyse complète)
─────────────────────────────────────────────────────────
TOTAL par session ARENA                  : ~$0.015/session
Sessions/user/mois (estimation Premium) : 2-4 sessions
COÛT MENSUEL ARENA/user                  : ~$0.030-0.060/mois
```

**Tier** : Premium uniquement

---

#### AGENT-12 : VISUAL-CRITIC (L'Agent Critique Visuel) 🔴 CRITIQUE

**Mission** : Auditer l'intégrité logique, sémantique et géométrique de chaque schéma, graphe ou diagramme généré (COSMOS ou FlowSeek) avant son affichage à l'utilisateur, afin d'éliminer toute approximation, erreur de tracé ou hallucination visuelle.

**Features orchestrées & Règles d'Audit** :
- **Détection de dépendances circulaires** : Vérifie qu'aucun cycle de prérequis invalide (A $\rightarrow$ B $\rightarrow$ A) n'est créé dans le DAG (validation asynchrone via `petgraph` local, coût 0$).
- **Sémantique de liaison** : Audite la cohérence logique et sémantique des verbes d'arêtes du Concept Map (M9) ou de l'Argument Map (M17) par rapport au corpus d'origine (ex: *"useContext [bloque] le rendu"* est identifié comme une hallucination par rapport aux sources d'origine et rejeté).
- **Encombrement géométrique (Clutter check)** : Évalue si le nombre de nœuds et d'arêtes va provoquer une surcharge visuelle pour le client et impose des limites dynamiques ou des fusions de clusters.
- **Vérification de provenance** : S'assure que chaque nœud ou arête s'accompagne d'une ligne d'ancrage sémantique immuable liée à une source d'origine dans la base de données.

**Output** : `VisualAuditReport` (Score 0-100). Si le score de l'audit est inférieur à 85/100, la liaison ou la section défaillante est rejetée et renvoyée automatiquement aux chaînes de génération (NEURON-CHAINS) pour correction ciblée.

**Coût LLM** : Majoritairement 0$ (règles et validations locales). Pour l'évaluation sémantique complexe : 1 micro-appel DeepSeek V4 (200 tokens) = **$0.00002**.

---

#### AGENT-13 : COGNITIVE-VALIDATOR (L'Agent de Validation Cognitive) 🔴 CRITIQUE

**Mission** : Valider et adapter le niveau de complexité, la taille et le vocabulaire de la visualisation générée en fonction du profil d'apprentissage et du score SMI actuel de l'utilisateur pour garantir une charge cognitive optimale.

**Features orchestrées & Règles de Personnalisation** :
- **Enforcement du Tier d'Expertise (Sweller Law)** : Limite le nombre de concepts affichés simultanément à l'écran selon le profil détecté de l'utilisateur (Discoverer = max 50 nœuds, Analyst = max 300, Explorer = sans limite) pour maintenir la charge cognitive sous le seuil optimal de sa mémoire de travail.
- **Alignement taxonomique de Bloom** : S'assure qu'un utilisateur débutant sur un nœud n'est pas exposé à des structures complexes de feedback (comme le Causal Loop M18 ou l'Arc Diagram M20) mais bénéficie d'échafaudages d'ancrage simples (MindMap M3, Concept Map M9).
- **Calibration de Vocabulaire** : Ajuste les explications internes des cartes sémantiques (Knowledge Cards M25) au niveau sémantique actuel de l'utilisateur (ELI5 pour les novices, ELI PhD pour les experts).

**Output** : `CognitiveValidationReport` (Score 0-100, liste de simplifications de vocabulaire, de filtres de zoom et de suggestions de modes COSMOS).

**Coût LLM** : **$0.00** (Règles déterministes basées sur le score SMI calculé par l'Agent-05).

---

### 4.3 Cycle de Vie Complet — Vue Macro (13 Agents)

```
PHASE 1 — SETUP (Jour 1, ~17 minutes automatiques)
  Agent-01 : Parse objectif → profil (1 appel LLM)
  Agent-02 : Scout + ingère 25 sources (parallèle, 5 sources/batch)
  Agent-03 : Génère DAG 15 nœuds + tous documents (batch NEURON-CHAINS)
  → User reçoit : Roadmap prête + première session proposée
  → [PREMIUM] Agent-10 CHRONICLE <!-- DEFERRED BEYOND BEACHHEAD MVP --> : Capture anchor behavior + planning hebdo J1

PHASE 2 — APPRENTISSAGE ACTIF (Jours 2 à N)
  Agent-04 : Orchestre chaque session (0 LLM, règles Rust)
  Agent-05 : Calcule SMI après chaque action (0 LLM, mathématiques)
  Agent-06 : Route progression (0 LLM, conditions déterministes)
  Agent-07 : Surveille en background (0 LLM sauf si drift)
  Agent-08 : Gamifie et rapporte (1 appel LLM/semaine pour rapport)
  → [PREMIUM] Agent-10 CHRONICLE : Check-in quotidien + gestion imprévus (continu)
  → [PREMIUM] Agent-11 ARENA <!-- DEFERRED BEYOND BEACHHEAD MVP (APT29 retained) --> : Sessions pratique quand SMI ≥ 70 sur nœuds théoriques

PHASE 3 — CERTIFICATION (Jour N+1)
  Agent-09 : Évaluation finale + PDF Proof of Skill (2 appels LLM)
  → [PREMIUM] Agent-11 ARENA : Proof of Skill "Conditions Réelles" si domaine pratique
  → User reçoit : Certificat + badge LinkedIn + suggestions suite
```

### 4.4 Coût Total LLM par Parcours (Après Optimisations)

```
Agent-01 (setup) :        $0.0003
Agent-02 (content) :      $0.0006  (cache mutualisé, souvent $0)
Agent-03 (dag + docs) :   $0.0032  (batch + compression + cache)
Agent-04 (sessions) :     $0.0000  (règles Rust pures)
Agent-05 (smi) :          $0.0000  (algorithme mathématique)
Agent-06 (routing) :      $0.0000  (conditions déterministes)
Agent-07 (drift) :        $0.0002  (rare, seulement si drift)
Agent-08 (engagement) :   $0.0012  (4 rapports hebdo × 12 semaines)
Agent-09 (certif) :       $0.0005  (1 fois, fin parcours)
─────────────────────────────────────────────────────────────────
TOTAL PARCOURS 90 JOURS (Free) : $0.006
VS PIPELINE NAÏVE :              $1.78
ÉCONOMIE :                       -99.7%

[PREMIUM UNIQUEMENT]
Agent-10 CHRONICLE :      $0.004/mois  (disruptions + conversations)
Agent-11 ARENA :          $0.030-0.060/mois (2-4 sessions pratiques)
─────────────────────────────────────────────────────────────────
TOTAL Premium 90 JOURS :  $0.006 + ($0.034-0.064 × 3 mois) = ~$0.108-0.198
MARGE Premium $10/mois :  $9.80-9.89/mois = 98-99% marge brute LLM ✅
```

---

## 5. NEURON-CHAINS Autonomes v2 `[Rôle : AI & LLM Engineer]`

### 5.1 Évolution NEURON-CHAINS v1 → v2

Les NEURON-CHAINS passent d'un pipeline **statique déclenché manuellement** à un système **autonome orchestré par APEX-AGENT** avec 18 tool callings natifs Rust.

**NEURON-CHAINS v1 (avant)** :
- Chaînes préconfigurées, séquence d'agents fixes
- Génération déclenchée manuellement par l'utilisateur
- Validation post-génération uniquement
- Score global unique /100 sans traçabilité

**NEURON-CHAINS v2 (après)** :
- APEX-AGENT pilote la sélection de chaîne automatiquement
- Génération déclenchée par Agent-03 (DAG-ARCHITECT) et Agent-06 (ADAPTIVE-ROUTER)
- Validation continue par section (boucle critique interne)
- Score confiance par section + rapport lisible + anti-hallucination 3 couches

### 5.2 APEX-AGENT — Méta-Orchestrateur NEURON-CHAINS

L'APEX-AGENT (distinct de l'ASCENT-ORCHESTRATOR) est le cerveau interne des NEURON-CHAINS. Il pilote la génération documentaire via une boucle ReAct (Reason → Act → Observe).

**Boucle de décision :**
```
INPUT : "Générer le contenu du nœud MITRE ATT&CK — T1059 Command and Scripting Interpreter"
           ↓
APEX-AGENT RAISONNE :
  - Type doc optimal ? → A06 (Cours magistral) pour nœud complexe
  - Ton optimal ? → T11 (Didactique) pour opérateurs cyber P-SOC1/P-SOC2 intermédiaires
  - Sources RAG ? → Récupérer top 15 chunks via T06 (RAGRetriever)
  - Budget tokens ? → 8K tokens alloués (T04 TokenBudgeter)
  - Modèle ? → DeepSeek V4 (T05 ModelRouter, tâche Complex)
           ↓
APEX-AGENT AGIT :
  → Compresse prompts (T09 PromptCompressor, -60%)
  → Génère section par section (anti-dérive)
  → Score chaque section (T10 SectionScorer, 5 dimensions)
  → Fact-check assertions risquées (T11 FactChecker)
           ↓
APEX-AGENT OBSERVE :
  Score global 89/100 → Export direct
  Score 72/100 → Réécriture ciblée sections < 70
  Score 45/100 → Alerte + rapport problèmes
```

### 5.3 Les 18 Tool Callings Natifs Rust

#### GROUPE 1 — Planification & Routage
| Tool | Code | Rôle | LLM requis |
|------|------|------|------------|
| DocTypeDetector | T01 | Auto-détecte type doc optimal (règles + LLM mini) | ⚠️ Mini (1 appel) |
| ToneSelector | T02 | Sélectionne ton parmi 50 (matrice statique) | ❌ Règles |
| OutlinePlanner | T03 | Plan sections + budget tokens par section | ❌ Algorithme |
| TokenBudgeter | T04 | Calcule/surveille budget tokens temps réel | ❌ Calcul |
| ModelRouter | T05 | Route vers modèle optimal (coût/qualité) | ❌ Règles |

#### GROUPE 2 — Contexte & Retrieval
| Tool | Code | Rôle | LLM requis |
|------|------|------|------------|
| RAGRetriever | T06 | Hybrid BM25 + pgvector + Graph + RRF | ❌ Index local |
| SourceVerifier | T07 | Vérifie fiabilité sources (JSON Cognitif) | ❌ Algorithme |
| CitationTracker | T08 | Lie chaque assertion à une source | ❌ Embeddings |
| PromptCompressor | T09 | LLMLingua-2 via candle ONNX (-60% tokens) | ❌ Modèle local |

#### GROUPE 3 — Génération & Qualité
| Tool | Code | Rôle | LLM requis |
|------|------|------|------------|
| SectionScorer | T10 | Score 5 dimensions par section générée | ❌ Algorithme |
| FactChecker | T11 | Vérifie assertions risquées via RAG | ❌ Retrieval |
| ConfidenceCalc | T12 | Score global pondéré + rapport lisible | ❌ Calcul |
| StructureValidator | T13 | Conformité au type de document attendu | ❌ Règles |
| StyleEnforcer | T14 | Cohérence stylistique ton sur tout le doc | ⚠️ Léger |

#### GROUPE 4 — Output & Continuité
| Tool | Code | Rôle | LLM requis |
|------|------|------|------------|
| ExportFormatter | T15 | PDF Typst + DOCX + Markdown + JSON | ❌ Compilation |
| DocSuggester | T16 | 3 docs logiquement suivants (graphe continuité) | ❌ Graph |

#### GROUPE 5 — Monitoring & Contrôle
| Tool | Code | Rôle | LLM requis |
|------|------|------|------------|
| BudgetGuard | T17 | Surveille tokens, active mode économie si besoin | ❌ Monitoring |
| SemanticCache | T18 | Cache LanceDB, lookup/store (threshold 0.87) | ❌ Embeddings |

**Résultat : 14 tools sur 18 ne consomment AUCUN token LLM externe.**

### 5.4 Anti-Hallucination — 3 Couches de Protection

#### Couche 1 : Ancrage RAG Strict (Prévention)
- Tout prompt de génération contient UNIQUEMENT des chunks récupérés des sources ingérées
- Instruction système : "N'écris QUE ce qui est dans le contexte fourni. Jamais d'invention."
- Chunks filtrés : similarity_score > 0.70 (Tantivy + pgvector)
- Sources vérifiées : reliability_score > 0.60 (T07 SourceVerifier)

#### Couche 2 : Cross-Check Multi-Agents (Détection)
- T08 CitationTracker : Lie chaque phrase à une source (similarity assertion↔source)
- Seuil : similarité < 0.60 → marqué `HallucinationRisk::High`
- T11 FactChecker : Vérifie assertions High-risk via nouveau retrieval RAG
  - Verified → maintenu
  - Unsupported → réécrit ou supprimé avec note éditoriale
  - Contradicted → supprimé

#### Couche 3 : Scoring Probabiliste (Quantification)
- T10 SectionScorer : Score "anti-hallucination" dimension 5 (0-100)
- T12 ConfidenceCalc : Score global + pénalités assertions non vérifiées

**Seuils d'action :**
```
Score ≥ 85 → Export direct ✅
Score 70-84 → Réécriture sections problématiques (1 cycle) ⚠️
Score 50-69 → Réécriture complète (1 cycle max) 🔄
Score < 50 → Alerte utilisateur + rapport détaillé 🚨
```

### 5.5 Score de Confiance — Format Rapport Utilisateur

```markdown
## 📊 Rapport de Confiance — "Introduction aux MITRE ATT&CK — T1059 Command and Scripting Interpreter"

**Score Global: 91/100** 🟢 Excellent

| Section | Score | Sources | Hallucinations | Ton |
|---------|-------|---------|----------------|-----|
| Introduction | 94 | 96% | 0 | ✅ |
| T1059.001 PowerShell | 89 | 91% | 1 faible | ✅ |
| T1059.003 Windows Command Shell | 93 | 95% | 0 | ✅ |
| Règles d'exécution | 88 | 88% | 2 faibles | ✅ |
| Exercices | 92 | 94% | 0 | ✅ |

**Sources** : 8 rapports MITRE ATT&CK ✅ + 4 analyses NIST SP 800-161 ✅
**Citations tracées** : 173/180 assertions liées à une source (96%)
**⚠️ Points attention** : 3 assertions support partiel (sections T1059.001 et Règles d'exécution)
```

### 5.6 Économie Tokens NEURON-CHAINS v2

```
Génération 1 document (cours magistral, 20 pages) :

NAÏF (v1) :
  MapReduce : 18 000 tokens bruts
  Génération : 13 000 tokens
  Validation : 1 500 tokens
  TOTAL : ~32 500 tokens → $0.10

OPTIMISÉ (v2) :
  MapReduce après LLMLingua-2 : 18 000 × 0.40 = 7 200 tokens
  Cache hit 35% : 7 200 × 0.65 = 4 680 tokens effectifs
  Génération section/section : 13 000 × 0.40 = 5 200 tokens
  Routing 60% DeepSeek : coût moyen ×0.30 vs GPT-4
  TOTAL EFFECTIF : ~9 880 tokens → $0.003

ÉCONOMIE : -97% sur génération documentaire
```

---

## 6. Stack Technologique Complète `[Rôle : Backend / Frontend / Infra]`

### 6.1 Backend Rust — Dépendances Complètes `[Rôle : Backend & Data]`

#### Core Runtime
```toml
tokio         = { version = "1.37", features = ["full"] }  # Runtime async OBLIGATOIRE
axum          = "0.7"    # HTTP + WebSocket + SSE
tower-http    = "0.5"    # Middleware CORS, tracing
async-trait   = "0.1"    # Traits async
serde         = { version = "1.0", features = ["derive"] }
serde_json    = "1.0"
uuid          = { version = "1.8", features = ["v7"] }
chrono        = "0.4"
reqwest       = { version = "0.12", features = ["json"] }
```

#### IA & ML
```toml
reqwest       = "0.12"   # Client HTTP pointant vers notre Proxy LiteLLM
tiktoken-rs   = "0.6"    # Token counting
fsrs          = "0.6"    # FSRS 5.0 spaced repetition
petgraph      = "0.6"    # DAG validation ASCENT
# ort et GLiNER ONNX supprimés au profit d'appels API ultra-cheap DeepSeek V4 (0.0001$/1K)
candle-core   = "0.4"    # Hugging Face Rust ML (LLMLingua-2)
candle-transformers = "0.4"
lancedb       = "0.4"    # Vector DB in-process (cache sémantique)
```

#### Search & Retrieval
```toml
# tantivy supprimé au profit de PostgreSQL Full-Text Search (FTS) natif avec index GIN
# pgvector géré côté PostgreSQL (extension)
```

#### Ingestion Cores
```toml
scraper             = "0.19"    # HTML parsing
article_scraper     = "1.x"    # Web content extraction
feed-rs             = "1.x"    # RSS/Atom podcasts
docx-parser         = "0.4"    # DOCX parsing
calamine            = "0.24"   # Excel parsing
epub                = "2.x"    # EPUB parsing
roux                = "2.x"    # Reddit API
google-drive3       = "7.x"    # Google Drive API
google-youtube3     = "7.x"    # YouTube Data API
yt-transcript-rs    = "0.1.8"  # Transcriptions YouTube
```

#### PDF Stack (3 Niveaux)
```toml
pdf_oxide           = "0.1"    # L1 - Markdown native
lopdf               = "0.32"   # L3 - Content Stream bas niveau
oxidize-pdf         = "0.1"    # L3 - Complément lopdf
```

#### Export Documents
```toml
typst               = "0.11"   # PDF layout professionnel
typst-pdf           = "0.11"   # PDF rendering
docx = { package = "docx", version = "0.4" }  # ⚠️ PAS docx-rs (abandonné)
zip                 = "2.1"    # Archive ⚠️ PAS zip-rs (déprécié)
rust_xlsxwriter     = "latest" # Excel export
tera                = "1.x"    # HTML templates
```

#### Intégrations Externes
```toml
notion-client       = "0.9"    # Notion API
notify              = "6"      # File watcher (Obsidian/Logseq)
pulldown-cmark      = "0.13"   # Markdown parser CommonMark
gray_matter         = "0.2"    # Frontmatter YAML
csv                 = "1"      # CSV parsing
quick-xml           = "0.36"   # Evernote .enex
keyring             = "2"      # Secrets OS keychain
```

#### Database
```toml
rusqlite            = "0.31"   # SQLite Desktop (WAL mode)
# sqlx ou client PostgreSQL pour Cloud Northflank
```

#### Monitoring
```toml
tracing             = "0.1"
tracing-subscriber  = "0.3"
opentelemetry       = "0.22"
opentelemetry-otlp  = "0.15"
```

#### CQRS / Architecture
```toml
dashmap             = "5.5"    # HashMap concurrent (EventBus)
once_cell           = "1.19"   # Lazy static (registres statiques)
```

**⚠️ CRATES À ÉVITER ABSOLUMENT :**
- ❌ `docx-rs` → ABANDONNÉ 2024. Utiliser `{ package = "docx", version = "0.4" }`
- ❌ `zip-rs` → DÉPRÉCIÉ. Utiliser `zip = "2.1"`
- ❌ `printpdf` → OBSOLÈTE. Utiliser `typst` + `typst-pdf`

### 6.2 Frontend React — Dépendances Complètes `[Rôle : Frontend & UI-UX]`

#### Core
```json
{
  "react": "18.3",
  "typescript": "5.4",
  "vite": "5.2",
  "zustand": "4.5",
  "react-router-dom": "6.22",
  "tailwindcss": "3.4",
  "@northflank/sdk": "latest"
}
```

#### Visualisation COSMOS v3 (26 modes — Bundle total ~1.4MB lazy-loaded)
```json
{
  "@cosmograph/cosmos": "3.x",
  "@cosmograph/react": "3.x",
  "@antv/g6": "5.x",
  "@antv/g2": "5.x",
  "@xyflow/react": "12.x",
  "recharts": "2.x",
  "nivo": "0.87.x",
  "d3": "7.x",
  "graphology": "0.25.x",
  "graphology-communities-louvain": "2.x",
  "graphology-metrics": "2.x",
  "graphology-layout-forceatlas2": "0.10.x",
  "@duckdb/duckdb-wasm": "latest"
}
```

**Nouvelles bibliothèques (v3)** :
- `@antv/g2` v5 : Sunburst, Treemap, Heatmap hiérarchique (~180KB lazy)
- `nivo` v0.87 : Sankey, Chord, Circle Packing, Heatmap (~120KB lazy)
- `d3` v7 : Parallel Coordinates, Arc Diagram, Edge Bundling, Voronoi (~80KB lazy)
- `three.js` (optionnel) : 3D Knowledge Space (~450KB lazy, Phase V3)

**Bundle COSMOS v3** : ~1.4MB lazy-loaded (vs ~810KB v2), initial bundle ~220KB (vs ~200KB v2)

#### Table & Animations
```json
{
  "@tanstack/react-table": "8.x",
  "@tanstack/react-virtual": "3.x",
  "react-spring": "9.x",
  "react-window": "1.x",
  "survey-react-ui": "latest",
  "survey-core": "latest",
  "survey-creator-react": "latest",
  "survey-creator-core": "latest",
  "ace-builds": "latest"
}
```

**Nouvelles dépendances v4 COSMOS (solutions terrain) :**
```json
{
  "opfs-worker": "latest"
}
```
*Fonts (Google Fonts CDN ou self-hosted, pas npm) :*
- `Inter Variable` (woff2) — Latin + subsets
- `Noto Sans SC`, `Noto Sans JP`, `Noto Sans KR` (woff2) — CJK
- `Noto Color Emoji` (woff2) — Emoji universel

*APIs navigateur nativement disponibles (sans dépendance) :*
- `BroadcastChannel` — Cross-tab sync (D-UX-012)
- `Web Locks API` — Leader election (D-UX-012)
- `navigator.storage.getDirectory()` — OPFS (D-DATA-005)
- `Intl.Segmenter` — Truncation CJK-aware (D-QUAL-002)
- `navigator.gpu` — WebGPU feature detection (D-PERF-006, Phase 3)

**❌ BIBLIOTHÈQUES RETIRÉES :**
- ❌ `sigma.js` → Remplacé par cosmos.gl + G6
- ❌ `cytoscape` + `react-cytoscapejs` → Remplacé par G6 v5
- ❌ `react-chrono` → Remplacé par Timeline custom (-120KB bundle)

### 6.3 Infrastructure `[Rôle : DevOps & SRE]`

#### Backend : Northflank (Primaire)
- Support Rust natif (zbpack auto-détecte Cargo.toml)
- Cold start <500ms, binary caching intelligent
- Tier gratuit : 512MB RAM, 1 vCPU (Phase 0-1)
- Backup : Railway (Docker, 60min pivot) / Fly.io (fallback)

#### Database & Auth : Northflank
- PostgreSQL 15+ (pgvector extension, RLS multi-tenant)
- Auth JWT + OAuth2 (Google, GitHub)
- Storage objets (audio MP3, exports PDF)
- Tier gratuit : 500MB DB + 1GB storage (Phase 0-1)

#### Frontend : Vercel (Primaire)
- React 18 optimisé, ISR dashboard (<100ms load)
- CDN global 180+ locations
- Preview deployments automatiques
- Backup : Netlify (swap DNS <5min)

#### Monitoring : Sentry + Axiom (Tier gratuit Phase 0-1)
- Sentry : Error tracking Rust + React (5K events/mois gratuit)
- Axiom : Logs structurés OpenTelemetry (100GB/mois gratuit)

### 6.4 Multi-Model AI Strategy

| Task | Complexité | Free Tier | Premium Tier | $$/1K tokens |
|------|-----------|-----------|-------------|-------------|
| Règles/calculs | Zéro | **Rust natif** | **Rust natif** | **$0.00** |
| Classification simple | Très faible | DeepSeek V4 | Claude Haiku | $0.0001-0.0003 |
| Résumés, extraction | Faible | DeepSeek V4 | Claude Haiku | $0.0001-0.0003 |
| Génération docs | Moyenne | DeepSeek V4 | Claude Sonnet | $0.001-0.003 |
| Long context output | Haute | Kimi K2.6 (128K) | GPT-4.5 | $0.003-0.01 |
| Raisonnement profond | Très haute | DeepSeek R1 | GPT-o1 | $0.015-0.06 |

---

## 7. Inventaire Features — 12 Modules `[Rôle : Product Owner / Tech Team]`

### 7.1 Module ASCENT Autonomous Pipeline (NOUVEAU v2)

**Phase** : MVP Phase 0 (core agents) + V1 (agents avancés)

**Agents MVP (Phase 0) :**
- ✅ GOAL-INTERPRETER : Parse objectif, profil, prérequis
- ✅ CONTENT-SCOUT : Scout + ingestion auto sources
- ✅ DAG-ARCHITECT : DAG + génération contenus
- ✅ LEARNING-CONDUCTOR : Orchestration sessions
- ✅ PERFORMANCE-ANALYZER : Calcul SMI continu
- ✅ ADAPTIVE-ROUTER : Fast-track / Normal / Remédiation

**Agents V1 (Phase 1) :**
- ✅ DRIFT-GUARDIAN : 8 signaux + interventions proactives
- ✅ ENGAGEMENT-AMPLIFIER : Gamification + rapports hebdo

**Agent V2 (Phase 2) :**
- ✅ SKILL-CERTIFIER : Proof of Skill + PDF + LinkedIn
- ✅ VISUAL-CRITIC : Audit logique & sémantique des visuels (D-UX-014)
- ✅ COGNITIVE-VALIDATOR : Calibration de la charge cognitive & de la taxonomie de Bloom

**Agents Premium — NOUVEAUX v2.4 :**
- ✅ **CHRONICLE (Agent-10)** : Coéquipier IA quotidien — mémoire vie réelle, reprogrammation imprévus, check-in adaptatif [Premium]
- ✅ **ARENA (Agent-11)** : Validation pratique par simulation Full-AI — APT29 social engineering, IR Triage, DFIR Investigation, CISO Briefing + Proof of Skill "Conditions Réelles" [Premium]

**Infrastructure pipeline :**
- ✅ EventBus SCY ForgeEvent (communication inter-agents)
- ✅ TokenOptimizationPipeline (7 mécanismes anti-goulot)
- ✅ BudgetGuard (alertes coûts temps réel)
- ✅ SharedContentCache (mutualisé cross-users)
- ✅ Typestate machine ASCENT (états type-safe Rust)
- ✅ ChronicleMemory (mémoire contextuelle persistante par user Premium)
- ✅ ArenaPersonaBuilder (construction Full-AI des personas de simulation)

### 7.2 Module Ingestion — 11 Cores Multi-Sources `[Rôle : Backend & Data]`

**Phase MVP (HIGH priority) :**
- **YouTube** : youtube-dl + yt-transcript-rs + google-youtube3
  - Métadonnées, transcriptions multilingues, horodatages, chapitres, playlists
- **Web/Article** : scraper + article_scraper + dom_smoothie (readability)
  - Extraction contenu propre, OpenGraph, images, paywalls
- **Academic** : 9 sources (ArXiv, PubMed, IEEE, Springer, Nature, Science, JSTOR, Scholar, ResearchGate)
  - DOI/ISBN, citations APA/MLA, graphe citations inter-papers
- **Google Drive** : google-drive3 (Docs, Slides, Sheets, sync automatique)

**Phase V1 (MEDIUM priority) :**
- **Podcast** : feed-rs + Whisper API (RSS, MP3, transcription, diarization)
- **Financial** : Yahoo Finance, Bloomberg, Reuters, SEC EDGAR, Earnings Calls
- **Twitter/X** : API v2 (threads récursifs, médias, hashtags)

**Phase V2 (LOW priority) :**
- **Wikipedia** : MediaWiki API (structured, wikilinks → graph)
- **Science** : NASA API, Nature API, arXiv API (formules LaTeX, figures)
- **TikTok** : Web scraping + Whisper (transcription)
- **Reddit** : roux crate (threads, comments arborescents)
- **EPUB** : `epub 2.x` (déjà dans dépendances §6.1) — Livres numériques complets, chapitres + TOC + metadata Dublin Core. Découpage par chapitres pour MapReduce. Usage principal : manuels techniques cyber (NIST, MITRE, guides DFIR).

**Import/Export Anki — Spécification Complète (Phase MVP) :**
- **Import .apkg** : Lire structure SQLite interne du .apkg (`zip 2.1` + `rusqlite 0.31`), mapper états SM-2 → FSRS 5.0 via formule de conversion, importer cartes types B02 (définitions) et B08 (cloze). Préservation intervalles existants.
- **Export .apkg** : Générer .apkg standard depuis cartes FSRS SCY Forge, permettre retour Anki, bundling médias (images/audio)
- **Conversion SM-2 ↔ FSRS** : `stability = ease_factor * interval / 2.5` (approximation conservative)
- **Crates** : `zip = "2.1"` + `rusqlite = "0.31"` (déjà présents §6.1)

### 7.3 Module NEURON-CHAINS — 7 Chaînes v2 (24 Agents + 18 Tools)

<!-- PIVOT-BEACHHEAD: AGENT-17 et AGENT-18 sont des SLOTS RÉSERVÉS pour expansion cyber post-MVP (ex: AGENT-17 = Threat-Intel-Correlator, AGENT-18 = Compliance-Validator). Non définis dans le beachhead MVP. -->

### 7.3.bis Plan C — Refactor Architecture Domain Contracts `[PIVOT BEACHHEAD]`

**Objectif** : Découpler le cœur SCY Forge de tout savoir métier cyber. Les agents consomment des **contrats de domaine** (domain contracts) via une interface normalisée, pas du savoir cyber hardcodé.

**Problème résolu** : Le cœur contient aujourd'hui des termes métier (MITRE, SOC, SIEM, Sigma...). Plan C déplace toute cette connaissance dans `packs/cyber/` sous forme de contrats consommables.

**Architecture cible** :

```
Cœur SCY Forge (Rust, domain-agnostic)
  │
  ├── SemanticTreeProvider (DCID)         ← Interface normalisée
  │     ├── get_taxonomy()                 ← Fournit la hiérarchie du domaine
  │     ├── get_techniques()               ← Techniques / concepts atomiques
  │     ├── get_scoring_criteria()         ← Critères d'évaluation par technique
  │     └── get_persona_templates()        ← Templates personas Full-AI
  │
  ├── Agent-03 (DAG-ARCHITECT)            ← Consommateur DCID
  ├── Agent-11 (ARENA)                    ← Consommateur DCID
  ├── Agent-16 (HITL-PROXY-SME)           ← Consommateur DCID
  └── NEURON-CHAINS (BETA-1 Taxonomiste)  ← Consommateur DCID

packs/cyber/ (contrats de domaine)
  ├── taxonomy.yaml                       ← Hiérarchie MITRE ATT&CK
  ├── techniques.yaml                     ← Techniques avec scores Bloom/FSRS
  ├── scoring_criteria.yaml               ← Critères d'évaluation DFIR
  ├── persona_templates.yaml              ← Templates APT29 / IR Triage / DFIR
  └── domain_contract.json                ← Contrat global (DCID v1)
```

**Contrat DCID (Domain Contract Interface Definition)** :
```yaml
# domain_contract.json — Interface de contrat entre le cœur et un pack de domaine
interface: SemanticTreeProvider
version: "1.0"

methods:
  - name: get_taxonomy
    returns: HierarchicalTree
    description: "Arborescence des concepts du domaine (ex: MITRE ATT&CK tactics → techniques → sub-techniques)"

  - name: get_techniques
    params: [level: BloomLevel, stability_min: f64]
    returns: List[Technique]
    description: "Techniques atomiques éligibles selon le profil FSRS/Bloom de l'opérateur"

  - name: get_scoring_criteria
    params: [technique_id: String]
    returns: ScoringCriteria
    description: "Critères d'évaluation pour une technique (ex: temps de détection, précision IOC)"

  - name: get_persona_templates
    params: [scenario: ScenarioType, difficulty: Difficulty]
    returns: List[PersonaTemplate]
    description: "Templates Full-AI pour les simulations ARENA (APT29, IR Triage...)"
```

**Règle d'or (maintenue)** : Le cœur SCY Forge ne contient **aucun terme métier cyber** en dur. Tout terme spécifique (APT29, MITRE T1059, Sigma rule, CVE) vit exclusivement dans `packs/cyber/`.

**Migration Plan C** :
- Phase 1 (Jours 1-14) : Définir DCID v1 + implémenter `SemanticTreeProvider` pour MITRE ATT&CK
- Phase 2 (Jours 15-28) : Migrer Agent-03 et NEURON-CHAINS (BETA-1) pour consommer DCID
- Phase 3 (Post-MVP) : Migrer Agent-11 (ARENA) et Agent-16 (HITL-PROXY-SME)
- Phase 4 (Post-MVP) : Ajouter packs additionnels (NIST CSF, ISO 27035, Threat Intel)

**Gain attendu** :
- Cœur purifié → testable sans données cyber
- Nouveaux domaines (juridique, finance) → nouveau pack YAML, 0% code Rust modifié
- DCID → interface stable, versionnée, consommée par tous les agents

#### Architecture Pipeline MapReduce L0-L4

```
L0 : Ingestion brute (contenu source brut)
L1 : Map parallèle — Chunking sémantique (500-2000 tokens, overlap 10%)
     Parallélisation 10-50 chunks simultanés (tokio async)
L2 : Reduce — Résumés locaux par chunk (ALPHA-3 × N chunks)
L3 : Reduce — Synthèse globale + Relations + Hiérarchie (BETA chain)
L4 : Post-processing optionnel — Enrichissement + Validation + Export
```

#### Chaîne ALPHA — Extraction & Synthèse (MVP)
- ALPHA-1 : Extracteur Brut (DOM, OCR, transcription audio)
- ALPHA-2 : Chunker Intelligent (sémantique, 500-2000 tokens, overlap 10%)
- ALPHA-3 : Résumeur Multi-Niveaux (L1=5 lignes, L2=2 paragraphes, L3=1 page)

#### Chaîne BETA — Structuration (MVP)
<!-- PIVOT-BEACHHEAD: domaines génériques (Arts, CS...) → MITRE ATT&CK Cyber Kill Chain + framework cyber (NIST, ISO 27035) -->
- BETA-1 : Taxonomiste (10 domaines cybersécurité : MITRE ATT&CK, NIST CSF, ISO 27035, Lockheed Martin Kill Chain, CVE/CWE, Threat Intel, SIEM/SOAR, DFIR, SOC Operations, Compliance)
- BETA-2 : Extracteur Relations (is_a, part_of, prerequisite_of, example_of, contradicts)
- BETA-3 : Architecte Hiérarchie (arbre concepts + scoring PageRank)

#### Chaîne GAMMA — Enrichissement (Post-MVP V1)
- GAMMA-1 : Contextualiseur (historique, applications réelles)
- GAMMA-2 : Générateur Analogies (métaphores pédagogiques)
- GAMMA-3 : Créateur Exemples (cas concrets, contre-exemples, edge cases)

#### Chaîne DELTA — Validation (Post-MVP V1)
- DELTA-1 : Fact-Checker (Wikipedia, papers, RAG vérification)
- DELTA-2 : Auditeur Cohérence (contradictions internes)
- DELTA-3 : Validateur Citations (APA/MLA/Vancouver formats)

#### Chaîne EPSILON — Génération Documents (MVP)
- EPSILON-1 : Générateur Cartes Révision (5 types)
- EPSILON-2 : Créateur Exercices (Template Gold 6 sections, 4 niveaux difficulté)
- EPSILON-3 : Assembleur Questions (MCQ 4 choix, distracteurs intelligents)

#### Chaîne ZETA — Révision Qualité (Post-MVP V2)
- ZETA-1 : Harmoniseur Style (terminologie cohérente)
- ZETA-2 : Optimiseur Clarté (simplification, jargon)
- ZETA-3 : Adaptateur Tons (application 50 tons T01-T50)

#### Chaîne ETA — Export Final (Post-MVP V2)
- ETA-1 : Formateur Multi-Formats (9 formats)
- ETA-2 : Enrichisseur Métadonnées (Dublin Core, Schema.org)
- ETA-3 : Générateur JSON Cognitif 360° (12 dimensions)

#### Les 100 Types de Documents (Familles A-H)

**FAMILLE A — Résumés (A01-A15)** : Ultra-court, Exécutif, Synthèse complète, Hiérarchique, Chronologique + 10 variantes domaine

**FAMILLE B — Cartes Révision (B01-B10)** : Exposition, Définition, MCQ, Short Answer, Application, Analogie, Teaching (Feynman), Cloze, Image Occlusion, Audio

**FAMILLE C — Exercices (C01-C20)** : Facile, Moyen, Difficile, Expert, QCM Formatif, QCM Sommatif, Problème Ouvert, Étude de Cas, Debug Challenge, Projet Mini + 10 variantes

**FAMILLE D — Synthèses (D01-D15)** : Mindmap, Comparaison, Chronologie, Liens Interdisciplinaires, FAQ + 10 variantes

**FAMILLE E — Visualisations (E01-E10)** : Diagramme Concepts, Timeline, Heatmap, Tree, Graphe Citation + 5 variantes COSMOS (étendues à 26 modes — voir §7.4)

**FAMILLE F — Audio (F01-F05)** : Podcast Résumé, Cours Audio, Flashcards Audio, Interview Simulée, ASMR Study

**FAMILLE G — Exports (G01-G15)** : PDF Typst, DOCX, HTML, Markdown, LaTeX, Anki .apkg, Notion CSV, Obsidian Vault, Roam JSON, JSON Structuré, Parquet, Excel, PowerPoint, ZIP, GitHub Repo

**FAMILLE H — Templates (H01-H10)** : Cornell Notes, Zettelkasten, Feynman Technique, SQ3R, Bloom Taxonomy + 5 variantes méthodes étude

#### Les 50 Tons Éditoriaux (T01-T50)

**Académiques (T01-T10)** : Académique Formel, Académique Accessible, Technique Précis, Pédagogique Clair, Socratique, Encyclopédique, Analytique Critique, Didactique Progressif, Méthodique Rigoureux, Comparatif Nuancé

**Conversationnels (T11-T20)** : Amical, Storytelling, Humoristique, Motivationnel, Empathique, Curieux Exploratoire, Pragmatique Direct, Minimaliste Concis, Poétique Métaphorique, Philosophique Contemplatif



### 4.2.bis Le Comité Pédagogique d'Audit "ASCENT-QA" (Nouveau v3.5)

Pour garantir des certifications (Proof of Skill) d'une rigueur équivalente ou supérieure à des cursus certifiants (Coursera, Udemy, ECTS), les Knowledge Cards et examens d'un nœud subissent obligatoirement l'audit d'un sous-pipeline de 6 agents pédagogiques experts <!-- PIVOT-BEACHHEAD: étudiants → P-SOC1 (L1/L2 SOC analyst) et P-SOC2 (L3 senior analyst) -->
avant d'être débloqués pour l'opérateur P-SOC1/P-SOC2 :

1. **`QA-AGENT-01 : THE SENIOR CURRICULUM DESIGNER`** : Garantit la cohérence didactique et la progressivité du chemin d'apprentissage (Bloom Levels).
2. **`QA-AGENT-02 : THE SUBJECT MATTER EXPERT` (SME)** : Fact-checke rigoureusement les équations LaTeX, les définitions et les codes sources par rapport aux standards mondiaux d'ingénierie et de science.
<!-- PIVOT-BEACHHEAD: AWS/CFA/CEU → certifs cybersécurité (SANS GSEC, CISSP, CEH, GCIH, OSCP, CySA+) -->
3. **`QA-AGENT-03 : THE ALIGNMENT ORCHESTRATOR`** : S'assure que 100% du syllabus requis pour l'accréditation professionnelle (SANS GSEC, CISSP, CEH, GCIH, OSCP, CySA+) est couvert, déclenchant des recherches d'ingestion complémentaires si nécessaire.
4. **`QA-AGENT-04 : THE COGNITIVE LOAD GUARANTOR`** : Audite la densité des fiches concepts (Sweller, Miller) et force le respect de l'accessibilité "1 idée = 1 bloc".
5. **`QA-AGENT-05 : THE RIGOROUS CONTENT VALIDATOR`** : Relit le matériel sémantique section-par-section, valide les formules et calcule le **Pedagogical Quality Score (PQS)**.
6. **`QA-AGENT-06 : THE ACADEMIC CERTIFIER`** : Garantit l'alignement constructif de John Biggs entre les leçons enseignées et l'examen final SurveyJS.

### 4.2.ter Les Agents Cognitifs de Méta-Évolution et d'Expertise Virtuelle

SCY Forge intègre deux nouveaux agents de très haut niveau s'exécutant en arrière-plan :

<!-- PIVOT-BEACHHEAD: AXIOMATIZER refactor Plan C — agents consomment contrats domaine, pas savoir cyber hardcodé -->
<!-- DEFERRED BEYOND BEACHHEAD MVP -->
* **`AGENT-15 : AXIOMATIZER` (L'Axiomatiseur de Connaissances)** :  
  Il résout le problème de l'inflation de micro-skills en s'exécutant de manière asynchrone côté serveur (Rust). Il capture les traces de réussite (`scy_procedural_traces`), les abstrait, et les fusionne en une seule **Loi ou Méthode Fondamentale** unique (écrite dans `scy_axioms` et partagée globalement de manière invisible). Une fois l'Axiome validé, il purge l'intégralité des micro-règles d'origine, éradiquant le cache.
<!-- PIVOT-BEACHHEAD: HITL-PROXY-SME refactor Plan C — consommateur contrat domaine, pas expert cyber hardcodé -->
<!-- DEFERRED BEYOND BEACHHEAD MVP -->
* **`AGENT-16 : HITL-PROXY-SME` (L'Expert Virtuel Human-in-the-Loop)** :  
  Pour éviter le coût et le temps de recrutement d'experts humains au lancement, cet agent simule un **auditeur humain sceptique et ultra-qualifié** dans le domaine exact de la formation ingérée (ex: *Cardiologue de la Mayo Clinic*, *Ingénieur système MIT*). Adoptant scrupuleusement son persona de relecteur ("Red Team"), il critique les leçons de la Neuro-Chain et valide la cohérence constructive d'examens avant signature électronique.

### 4.2.quater La Séparation des Deux Parcours Élèves (Parcours A et B)

SCY Forge structure l'orientation de l'apprentissage en deux parcours d'études distincts :

1. **Parcours A : L'Assimilation Active (Deep Understanding & Fast Competence)** :  
   - *Objectif* : Compréhension profonde, pratique intensive et mémorisation autonome sans s'encombrer d'un diplôme superflu. Conforme aux exigences des recruteurs modernes qui valorisent les compétences réelles au diplôme.
   - *Fonctionnement* : **Conserve l'intégralité de la complexité, de la rigueur et de l'audit d'exactitude scientifique du Parcours B**. Le cours est soumis de manière obligatoire à l'audit du Comité `ASCENT-QA` et de l'expert virtuel `AGENT-16 (HITL-PROXY-SME v2.0)` (seuil PQS $\ge 88/100$).
   - *La différence* : L'opérateur P-SOC1 étudie un matériel pédagogique d'une qualité absolue, **mais aucun certificat officiel Proof of Skill n'est délivré à la fin**, ce qui préserve l'élite des diplômes de SCY Forge.
   - *Sûreté* : Un filtre d'intégrité minimal (anti-NaN, anti-division par zéro `softening_epsilon`) tourne de façon transparente en arrière-plan sans bloquer l'opérateur P-SOC1.  
   - *Objectif* : Compréhension rapide, pratique intensive et mémorisation autonome sans subir de barrières ou d'examens académiques.
   - *Fonctionnement* : COSMOS, les cartes FSRS, et BRAIN s'activent **immédiatement** à 0$ de temps d'attente dès la fin de l'ingestion brute.
   - *Sûreté* : Un filtre d'intégrité minimal (anti-NaN, anti-division par zéro) tourne de façon transparente en arrière-plan sans bloquer l'opérateur P-SOC1.
   - *Certification* : **ZÉRO CERTIFICAT DÉLIVRÉ**, préservant l'élite des diplômes SCY Forge.
2. **Parcours B : L'Accréditation Professionnelle (Accredited Certification)** :  
   - *Objectif* : Obtenir un certificat professionnel Proof of Skill d'une valeur équivalente ou supérieure à des cursus de l'industrie (Coursera/Udemy/ECTS).
   - *Fonctionnement* : Le cours subit obligatoirement l'audit d'intégrité scientifique d'`AGENT-16` (HITL-Proxy) et du Comité d'agents `ASCENT-QA`. Le cours ne s'ouvre que si le **PQS est $\ge 88/100$**.
   - *Évaluation* : L'opérateur P-SOC1/P-SOC2 doit accomplir son parcours, réussir le SurveyJS exam et passer la session pratique de roleplay **ARENA** avec un **SMI de sortie $\ge 85/100$** pour générer sa Proof of Skill cryptée.


Pour garantir des certifications (Proof of Skill) d'une rigueur équivalente ou supérieure à des cursus certifiants (Coursera, Udemy, ECTS), les Knowledge Cards et examens d'un nœud subissent obligatoirement l'audit d'un sous-pipeline de 6 agents pédagogiques experts <!-- PIVOT-BEACHHEAD: étudiants → P-SOC1 (L1/L2 SOC analyst) et P-SOC2 (L3 senior analyst) -->
avant d'être débloqués pour l'opérateur P-SOC1/P-SOC2 :

1. **`QA-AGENT-01 : THE SENIOR CURRICULUM DESIGNER`** : Garantit la cohérence didactique et la progressivité du chemin d'apprentissage (Bloom Levels).
2. **`QA-AGENT-02 : THE SUBJECT MATTER EXPERT` (SME)** : Fact-checke rigoureusement les équations LaTeX, les définitions et les codes sources par rapport aux standards mondiaux d'ingénierie et de science.
<!-- PIVOT-BEACHHEAD: AWS/CFA/CEU → certifs cybersécurité (SANS GSEC, CISSP, CEH, GCIH, OSCP, CySA+) -->
3. **`QA-AGENT-03 : THE ALIGNMENT ORCHESTRATOR`** : S'assure que 100% du syllabus requis pour l'accréditation professionnelle (SANS GSEC, CISSP, CEH, GCIH, OSCP, CySA+) est couvert, déclenchant des recherches d'ingestion complémentaires si nécessaire.
4. **`QA-AGENT-04 : THE COGNITIVE LOAD GUARANTOR`** : Audite la densité des fiches concepts (Sweller, Miller) et force le respect de l'accessibilité "1 idée = 1 bloc".
5. **`QA-AGENT-05 : THE RIGOROUS CONTENT VALIDATOR`** : Relit le matériel sémantique section-par-section, valide les formules et calcule le **Pedagogical Quality Score (PQS)**.
6. **`QA-AGENT-06 : THE ACADEMIC CERTIFIER`** : Garantit l'alignement constructif de John Biggs entre les leçons enseignées et l'examen final SurveyJS.

* **Seuil de Sûreté PQS >= 88/100** : Si le score calculé est inférieur à 88, la transaction est bloquée par Harmonist, et l'APEX-AGENT en Rust ré-écrit et ré-ajuste le matériel pédagogique selon les retours d'audits.


# SCYForge — Feature-to-Provider Matrix

## But du document

Ce document fait la jonction entre :
- la vision stratégique de SCYForge comme **cognitive kernel + domain packs**,
- le **Pack Cyber** comme premier pack opérationnel,
- et le **refactor réel** des features / agents ASCENT.

L’objectif n’est pas de redécrire le produit.
L’objectif est de dire, **feature par feature**, ce qui doit devenir :
1. invariant noyau,
2. dépendance à un provider domaine,
3. artefact cyber consommé,
4. point de refactor prioritaire,
5. risque de hardcoding ou de dérive wrapper.

---

# Légende de lecture

## Colonnes clés
- **Famille** : une des 7 familles canoniques définies dans `SCYFORGE_FEATURE_PATTERNING_ARCHITECTURE.md`
- **Providers** : contrats domaine que la feature doit consommer
- **Artefacts cyber** : ce que le Pack Cyber injecte concrètement
- **À rendre agnostique** : ce qui ne doit surtout pas rester codé en dur
- **Risque** : principal risque d’architecture / produit si la feature reste mal structurée
- **Priorité** : ordre de refactor recommandé

## Providers de référence
- `OntologyProvider`
- `CorpusProvider`
- `RoleTaxonomyProvider`
- `DecisionScenarioProvider`
- `ProofRubricProvider`
- `RetentionPolicyProvider`
- `ValidationGuardProvider`

---

# 1. Matrice exécutive — vue synthétique

| Feature / Agent | Rôle cible | Famille | Providers clés | Artefacts cyber dominants | Risque principal | Priorité |
|---|---|---|---|---|---|---|
| GOAL-INTERPRETER | Goal Compiler | Mastery Graph | RoleTaxonomy, Ontology, ProofRubric | rôles SOC, niveaux AWARE/APPLY/MASTER | objectif interprété avec heuristiques génériques ou cyber hardcodé | P0 |
| CONTENT-SCOUT | Evidence Scout | Ingestion | Corpus, Ontology, ValidationGuard | Sigma, OTRF, ATT&CK, runbooks, postmortems | collecte documentaire sans hiérarchie de vérité | P0 |
| DAG-ARCHITECT | Mastery Graph Compiler | Mastery Graph | Ontology, RoleTaxonomy, ProofRubric | taxonomie SOC, ATT&CK, criticité, preuves | DAG sémantique au lieu d’un graphe de compétence | P0 |
| LEARNING-CONDUCTOR | Intervention Orchestrator | Adaptive Orchestration | RoleTaxonomy, RetentionPolicy, DecisionScenario, ValidationGuard | politiques de difficulté SOC, exercices d’alertes, gates | optimisation engagement au lieu de maîtrise | P0 |
| PERFORMANCE-ANALYZER | Evidence Aggregator | Proof of Skill | ProofRubric, ValidationGuard, RoleTaxonomy | barème 5 dimensions cyber, erreurs éliminatoires | score générique non défendable pour readiness | P0 |
| ADAPTIVE-ROUTER | Trajectory Policy Engine | Adaptive Orchestration | RetentionPolicy, DecisionScenario, RoleTaxonomy, ValidationGuard | remédiation sur faux positifs, complexité triage | routage basé uniquement sur score brut | P1 |
| DRIFT-GUARDIAN | Mastery Erosion Sentinel | Retention & Drift | RetentionPolicy, ValidationGuard, ProofRubric | dérives critiques SOC, oubli procédural | ne détecte que l’inactivité, pas l’érosion réelle | P1 |
| ENGAGEMENT-AMPLIFIER | Motivation Layer | Adaptive Orchestration | RetentionPolicy, RoleTaxonomy | milestones readiness, gamification par maîtrise | gamification décorative qui pollue le signal | P3 |
| SKILL-CERTIFIER | Readiness Verdict Engine | Proof of Skill | ProofRubric, ValidationGuard, RoleTaxonomy, DecisionScenario | autonomie par classe d’alertes, proof records | “certification” non bornée ni auditée | P0 |
| CHRONICLE | Learning Ledger / Manager Timeline | Explainability & Governance | Corpus, ProofRubric, ValidationGuard | traces de scénario, historique readiness | joli log sans utilité managériale | P1 |
| ARENA | Scenario Runtime | Arena Simulation | DecisionScenario, ProofRubric, ValidationGuard | APT29, triage, escalation, containment | roleplay libre sans vérité métier | P0 |
| VISUAL-CRITIC | Visual Integrity Guard | Explainability & Governance | ValidationGuard, Ontology | schémas ATT&CK / graphe de maîtrise | beau visuel faux ou incohérent | P2 |
| COGNITIVE-VALIDATOR | Cognitive Fit Guard | Adaptive Orchestration | RoleTaxonomy, RetentionPolicy, ValidationGuard | calibration par rôle/niveau SOC | adaptation cognitive sans contrainte métier | P2 |
| BRAIN | Contextual Professor | Ingestion + Orchestration | Corpus, Ontology, ValidationGuard | chunks source-grounded, runbooks, techniques | chatbot RAG banal | P1 |
| APEX / FSRS / IMPRINT | Mastery Preservation Engine | Retention & Drift | RetentionPolicy, ProofRubric, ValidationGuard | politiques de criticité cyber, cartes discriminantes | mémoire mnésique sans jugement procédural | P1 |
| COSMOS | Knowledge Visual Runtime | Explainability & Governance | Ontology, RoleTaxonomy, Corpus | graphes techniques, progression par rôle | visualisation décorative détachée de la maîtrise | P2 |

---

# 2. Matrice détaillée par feature / agent

## 2.1 GOAL-INTERPRETER → Goal Compiler

| Champ | Détail |
|---|---|
| Mission actuelle | interpréter l’objectif utilisateur en objectif de formation |
| Mission cible | compiler un objectif brut en `GoalSpec` + hypothèse de graphe de maîtrise + périmètre de preuve |
| Inputs noyau | intention brute, niveau, temps, contraintes, historique utilisateur |
| Outputs cibles | `GoalSpec`, `RoleResolution`, `TargetMasteryProfile`, `InitialMasteryNodeCandidates` |
| Famille | Mastery Graph Construction |
| Providers consommés | `RoleTaxonomyProvider`, `OntologyProvider`, `ProofRubricProvider` |
| Artefacts cyber consommés | taxonomie SOC L1/L2/Threat Hunter/IR, niveaux AWARE/APPLY/MASTER, criticité par rôle |
| Invariants | un objectif doit produire un rôle, un niveau cible, un horizon, un scope de preuve ; aucun rôle ne doit être inventé sans mapping explicite |
| À rendre agnostique | détection de rôle, interprétation domaine, prérequis métier, vocabulaire spécifique |
| Risques de hardcoding | “SOC analyst”, “incident”, “alert”, “phishing triage” encodés dans les prompts / règles du cœur |
| Refactor concret | remplacer les heuristiques de rôle par un appel au `RoleTaxonomyProvider.resolveRole()` puis enrichissement via `OntologyProvider.mapGoalIntent()` |
| Priorité | P0 |

### Lecture franche
Si GOAL-INTERPRETER reste semi-générique et semi-cyber implicite, tu n’as pas une plateforme. Tu as un front-door intelligent relié à un tunnel métier caché.

---

## 2.2 CONTENT-SCOUT → Evidence Scout

| Champ | Détail |
|---|---|
| Mission actuelle | trouver et ingérer du contenu pertinent |
| Mission cible | construire un ensemble de preuves exploitables, versionnées, scorées, reliées à l’ontologie et filtrées par garde-fous métier |
| Inputs noyau | `GoalSpec`, gaps de couverture, contexte rôle, politique sources |
| Outputs cibles | `EvidenceBundle`, `CoverageMap`, `SourceTrustMap`, `GapReport` |
| Famille | Knowledge Ingestion & Canonicalization |
| Providers consommés | `CorpusProvider`, `OntologyProvider`, `ValidationGuardProvider` |
| Artefacts cyber consommés | Sigma rules, hunts OTRF, ATT&CK hierarchy, APT29 chain, runbooks internes, postmortems |
| Invariants | toute assertion doit être traçable à une source ; toute source doit être scorée ; toute couverture doit être explicitée par nœud ou domaine ref |
| À rendre agnostique | ranking de sources, logique d’extraction, mapping sémantique, scoring confiance |
| Risques de hardcoding | règles spéciales “si ATT&CK alors…”, “si Sigma alors…” disséminées dans le moteur général |
| Refactor concret | introduire `SourceEvidence`, `EvidenceClaim`, `CoverageByDomainRef`; appeler `ValidationGuardProvider.classifySourceRisk()` avant de promouvoir une source au rang de preuve |
| Priorité | P0 |

### Lecture franche
CONTENT-SCOUT ne doit pas être une moissonneuse de documents. Il doit devenir un **fabricant de vérité exploitable**. Sinon SCYForge retombe au niveau “RAG pipeline bien fait”.

---

## 2.3 DAG-ARCHITECT → Mastery Graph Compiler

| Champ | Détail |
|---|---|
| Mission actuelle | générer le DAG du parcours |
| Mission cible | compiler un **graphe de maîtrise** où chaque nœud représente une capacité prouvable et non un simple thème |
| Inputs noyau | `GoalSpec`, `EvidenceBundle`, rôle cible, prérequis, rubriques de preuve |
| Outputs cibles | `MasteryGraph`, `MasteryNode[]`, `PrerequisiteEdges`, `ProofPlan` |
| Famille | Mastery Graph Construction |
| Providers consommés | `OntologyProvider`, `RoleTaxonomyProvider`, `ProofRubricProvider` |
| Artefacts cyber consommés | familles ATT&CK, techniques critiques, taxonomie SOC, classes de décision, erreurs critiques |
| Invariants | chaque nœud doit avoir un type de maîtrise, un niveau cible, une criticité, un mode de preuve ; le DAG ne doit pas être une simple taxonomie |
| À rendre agnostique | découpage de l’objectif, structure de nœud, règles de dépendance, mapping objectif -> preuve |
| Risques de hardcoding | utiliser directement ATT&CK comme graphe pédagogique ; confondre ontologie d’attaque et graphe de compétence |
| Refactor concret | créer `MasteryNode.mastery_type`, `failure_modes`, `proof_requirements`, `criticality` ; séparer `domain_ref_graph` et `mastery_graph` |
| Priorité | P0 |

### Lecture franche
Le danger ici est majeur : beaucoup de produits “IA éducation” croient faire un graphe de compétence alors qu’ils ne font qu’un plan de contenu. C’est exactement la frontière entre produit impressionnant et infrastructure de maîtrise.

---

## 2.4 LEARNING-CONDUCTOR → Intervention Orchestrator

| Champ | Détail |
|---|---|
| Mission actuelle | décider quoi faire pendant la session |
| Mission cible | arbitrer la meilleure intervention suivante pour maximiser la maîtrise réelle et minimiser le risque d’illusion de compétence |
| Inputs noyau | `LearnerState`, `MasteryGraph`, `ProofState`, `RetentionState`, `ScenarioReadiness` |
| Outputs cibles | `InterventionDecision`, `SessionPlan`, `EscalationToScenario`, `RemediationPlan` |
| Famille | Adaptive Learning Orchestration |
| Providers consommés | `RoleTaxonomyProvider`, `RetentionPolicyProvider`, `DecisionScenarioProvider`, `ValidationGuardProvider` |
| Artefacts cyber consommés | scénarios de triage, politiques d’escalade, difficulté par rôle, faux positifs réalistes |
| Invariants | une intervention doit viser un nœud de maîtrise précis ; le système peut ralentir l’utilisateur volontairement ; aucune optimisation d’engagement ne doit dégrader la vérité du signal |
| À rendre agnostique | logique d’orchestration, sélection du type d’intervention, score de friction utile |
| Risques de hardcoding | décider qu’un domaine “doit lire plus”, “doit faire des quiz”, “doit simuler” sans politique domaine |
| Refactor concret | introduire `InterventionPolicy` résolue via providers ; séparer `content intervention`, `practice intervention`, `proof intervention`, `retention intervention` |
| Priorité | P0 |

### Lecture franche
C’est le cerveau. Si ce cerveau optimise la fluidité UX au lieu de la compétence réelle, tout le château s’effondre.

---

## 2.5 PERFORMANCE-ANALYZER → Evidence Aggregator

| Champ | Détail |
|---|---|
| Mission actuelle | calculer le SMI et analyser la performance |
| Mission cible | agréger les preuves par nœud, par dimension, par contexte, et produire un état de maîtrise défendable |
| Inputs noyau | exercices, explications, décisions, simulations, rétention, calibrations métacognitives |
| Outputs cibles | `MasteryState`, `NodeEvidenceSummary`, `DimensionScores`, `ConfidenceIntervals` |
| Famille | Assessment / Proof of Skill |
| Providers consommés | `ProofRubricProvider`, `ValidationGuardProvider`, `RoleTaxonomyProvider` |
| Artefacts cyber consommés | rubric 5 dimensions, erreurs éliminatoires, seuils readiness par rôle |
| Invariants | score multidimensionnel ; distinction mémoire / jugement / procédure / décision ; confiance du verdict toujours explicitée |
| À rendre agnostique | structure du scoring, fusion de preuves, gestion des intervalles de confiance |
| Risques de hardcoding | pondérations figées pour tous domaines ; SMI universel sans adaptation domaine |
| Refactor concret | ajouter `rubric_dimensions[]`, `evidence_types[]`, `confidence_by_dimension`; externaliser les weights et eliminations dans `ProofRubricProvider` |
| Priorité | P0 |

### Lecture franche
Le score n’a de valeur que s’il est **défendable devant un manager métier**. En cyber, “76/100” ne veut rien dire. “Fiable sur triage phishing standard, pas fiable sur credential theft ambigu” commence à avoir une valeur.

---

## 2.6 ADAPTIVE-ROUTER → Trajectory Policy Engine

| Champ | Détail |
|---|---|
| Mission actuelle | accélérer, consolider ou remédier selon SMI |
| Mission cible | choisir la trajectoire de progression la plus robuste selon état de preuve, criticité, oubli et difficulté décisionnelle |
| Inputs noyau | `MasteryState`, `RetentionState`, `FailurePatterns`, `ScenarioEligibility` |
| Outputs cibles | `RoutingDecision`, `NodePriorityChanges`, `RemediationBundle`, `FastTrackDecision` |
| Famille | Adaptive Learning Orchestration |
| Providers consommés | `RetentionPolicyProvider`, `DecisionScenarioProvider`, `RoleTaxonomyProvider`, `ValidationGuardProvider` |
| Artefacts cyber consommés | faux positifs récurrents, niveaux de gravité, scénarios éligibles, politiques d’escalade |
| Invariants | jamais de fast-track sans preuve suffisante ; la consolidation doit cibler une faiblesse identifiée ; les remédiations doivent être typées |
| À rendre agnostique | logique de fast-track, remédiation, stratégie de plateau |
| Risques de hardcoding | seuils fixes identiques pour tous rôles et tous domaines |
| Refactor concret | remplacer le simple mapping SMI->routing par `RoutingPolicy.resolve(role, node_criticality, evidence_gaps, retention_risk)` |
| Priorité | P1 |

---

## 2.7 DRIFT-GUARDIAN → Mastery Erosion Sentinel

| Champ | Détail |
|---|---|
| Mission actuelle | détecter abandon et signaux de drift |
| Mission cible | détecter l’érosion de maîtrise, la dérive procédurale et les illusions de compétence avant qu’elles ne deviennent opérationnelles |
| Inputs noyau | historique de performance, rythme, erreurs, rétention, métacognition |
| Outputs cibles | `DriftSignals`, `InterventionTriggers`, `ReactivationPlan`, `RiskFlags` |
| Famille | Retention, Memory & Drift |
| Providers consommés | `RetentionPolicyProvider`, `ValidationGuardProvider`, `ProofRubricProvider` |
| Artefacts cyber consommés | procédures critiques rares, signaux d’escalade ratés, confusions fréquentes, techniques mission critical |
| Invariants | drift comportemental ≠ juste inactivité ; détecter aussi les retours de réponses plausibles mais dangereuses |
| À rendre agnostique | taxonomie des signaux, stratégie d’intervention, priorisation des risques |
| Risques de hardcoding | modèle trop centré SaaS/B2C ; notifications plutôt que préservation réelle de compétence |
| Refactor concret | introduire `DriftSignalType = inactivity | retention_drop | procedural_regression | overconfidence | repeated_false_positive_pattern ...` |
| Priorité | P1 |

---

## 2.8 ENGAGEMENT-AMPLIFIER → Motivation Layer

| Champ | Détail |
|---|---|
| Mission actuelle | gamification, streaks, rapports, célébrations |
| Mission cible | augmenter la persistance sans contaminer la mesure de maîtrise |
| Inputs noyau | milestones, complétions, difficulté, fatigue, cohérence d’effort |
| Outputs cibles | `EngagementEvents`, `MotivationNudges`, `MilestoneReports` |
| Famille | Adaptive Learning Orchestration |
| Providers consommés | `RetentionPolicyProvider`, `RoleTaxonomyProvider` |
| Artefacts cyber consommés | milestones readiness, montée d’autonomie par rôle, campagnes de réactivation respectant criticité |
| Invariants | la récompense doit suivre un progrès réel ; pas de système qui récompense l’activité vide |
| À rendre agnostique | types de récompense, narration de progression, rythme des feedbacks |
| Risques de hardcoding | streaks et badges qui créent une illusion de progrès |
| Refactor concret | rattacher toute célébration à un `ProofEvent` ou `MasteryMilestone`, jamais à une simple métrique vanity |
| Priorité | P3 |

### Lecture franche
Cette couche doit rester **subordonnée** à la maîtrise. Si elle devient motrice, elle détruit la crédibilité du produit.

---

## 2.9 SKILL-CERTIFIER → Readiness Verdict Engine

| Champ | Détail |
|---|---|
| Mission actuelle | certifier une compétence à la fin d’un parcours |
| Mission cible | rendre un verdict borné, explicable, auditable, lié à un périmètre précis d’autonomie |
| Inputs noyau | `ProofRecord[]`, `MasteryState`, `ScenarioResults`, `RolePolicy`, `EliminationRules` |
| Outputs cibles | `ReadinessVerdict`, `ProofOfSkill`, `ScopeOfAutonomy`, `NotReadyReasons` |
| Famille | Assessment / Proof of Skill |
| Providers consommés | `ProofRubricProvider`, `ValidationGuardProvider`, `RoleTaxonomyProvider`, `DecisionScenarioProvider` |
| Artefacts cyber consommés | scénarios APT29, barème 5 dimensions, erreurs éliminatoires, autonomie par classe d’alertes |
| Invariants | jamais de certification globale vague ; verdict toujours borné par rôle, type de tâche, niveau de risque ; preuves traçables |
| À rendre agnostique | modèle de verdict, format certificat, périmètre d’autonomie |
| Risques de hardcoding | certificat générique marketing sans valeur managériale |
| Refactor concret | créer `ReadinessVerdict { scope, allowed_autonomy, blocked_areas, evidence_refs, confidence }` |
| Priorité | P0 |

---

## 2.10 CHRONICLE → Learning Ledger / Manager Timeline

| Champ | Détail |
|---|---|
| Mission actuelle | historique, rapport, chronologie |
| Mission cible | ledger d’apprentissage auditable, consultable par l’apprenant, le manager et le système |
| Inputs noyau | décisions agentiques, preuves, événements de progression, drift, scénarios |
| Outputs cibles | `TimelineEvents`, `ManagerDigest`, `AuditTrail`, `LearnerNarrative` |
| Famille | Explainability & Governance |
| Providers consommés | `CorpusProvider`, `ProofRubricProvider`, `ValidationGuardProvider` |
| Artefacts cyber consommés | liens source -> technique -> nœud -> scénario -> verdict |
| Invariants | aucune décision majeure sans trace ; aucune progression critique sans lien vers preuve |
| À rendre agnostique | format de timeline, vues consommateur, stockage narratif |
| Risques de hardcoding | timeline inspirante mais non auditable |
| Refactor concret | distinguer `SystemEvent`, `ProofEvent`, `ScenarioEvent`, `ManagerFacingEvent` |
| Priorité | P1 |

---

## 2.11 ARENA → Scenario Runtime

| Champ | Détail |
|---|---|
| Mission actuelle | simulation / roleplay / épreuve du feu |
| Mission cible | runtime de scénarios pilotés par blueprint, avec branches, décisions observables et scoring borné |
| Inputs noyau | `ScenarioBlueprint`, `LearnerState`, `ProofRubric`, `ValidationPolicy` |
| Outputs cibles | `ScenarioTrace`, `DecisionEvents`, `ScenarioScore`, `ProofRecord` |
| Famille | Active Practice & Arena Simulation |
| Providers consommés | `DecisionScenarioProvider`, `ProofRubricProvider`, `ValidationGuardProvider` |
| Artefacts cyber consommés | APT29 scenarios, alert bundles, branch rules, elimination errors |
| Invariants | pas de scénario critique improvisé librement ; pas de score sans rubric ; pas de claim sans trace de décision |
| À rendre agnostique | moteur de branches, capture de décisions, score runtime |
| Risques de hardcoding | simulation “cinématique” mais sans vérité métier ni conséquence réaliste |
| Refactor concret | imposer `ScenarioBlueprint` comme entrée obligatoire ; journaliser `DecisionEvent { prompt, learner_action, inferred_intent, consequence }` |
| Priorité | P0 |

### Lecture franche
ARENA est une machine à crédibilité ou à bullshit. Sans blueprints et rubriques, c’est du théâtre. Avec eux, c’est un moteur de proof-of-skill.

---

## 2.12 VISUAL-CRITIC → Visual Integrity Guard

| Champ | Détail |
|---|---|
| Mission actuelle | valider schémas / visuels générés |
| Mission cible | garantir que toute représentation visuelle reste fidèle à la vérité du graphe, du scénario ou de l’ontologie |
| Inputs noyau | schéma généré, graph source, contraintes de rendu, sources |
| Outputs cibles | `VisualValidationReport`, `RenderApproval`, `DefectFlags` |
| Famille | Explainability & Governance |
| Providers consommés | `ValidationGuardProvider`, `OntologyProvider` |
| Artefacts cyber consommés | hiérarchie ATT&CK, graphes de maîtrise cyber, cartes de progression |
| Invariants | un visuel ne peut pas introduire une relation non supportée ; les labels doivent être cohérents avec l’ontologie |
| À rendre agnostique | critères de validation logique / géométrique |
| Risques de hardcoding | traitement spécial pour certains graphes cyber au lieu d’un validateur structurel universel |
| Refactor concret | séparer `structural validation`, `semantic validation`, `source-link validation` |
| Priorité | P2 |

---

## 2.13 COGNITIVE-VALIDATOR → Cognitive Fit Guard

| Champ | Détail |
|---|---|
| Mission actuelle | calibrer le visuel ou la carte au niveau de l’utilisateur |
| Mission cible | garantir l’adéquation entre forme pédagogique, charge cognitive et exigence métier |
| Inputs noyau | profil apprenant, état de maîtrise, type de contenu, rôle cible |
| Outputs cibles | `CognitiveRenderingPolicy`, `ComplexityAdjustment`, `ExplanationLevel` |
| Famille | Adaptive Learning Orchestration |
| Providers consommés | `RoleTaxonomyProvider`, `RetentionPolicyProvider`, `ValidationGuardProvider` |
| Artefacts cyber consommés | niveaux par rôle, criticité des techniques, contraintes de précision |
| Invariants | simplifier ne doit jamais falsifier ; adapter la difficulté ne doit jamais changer le contenu métier essentiel |
| À rendre agnostique | calibration cognitive, stratégies de simplification |
| Risques de hardcoding | ton cyber expert appliqué à tous ; simplification unsafe pour contenus sensibles |
| Refactor concret | ajouter politiques `explanation_depth`, `allowed_simplifications`, `must_preserve_terms` |
| Priorité | P2 |

---

## 2.14 BRAIN → Contextual Professor

| Champ | Détail |
|---|---|
| Mission actuelle | assistant Q&A / RAG contextuel |
| Mission cible | professeur contextuel source-grounded, capable d’expliquer, interroger, simplifier, faire pratiquer, sans sortir du cadre de vérité |
| Inputs noyau | contexte nœud, sources, historique, SMI, mode socratique |
| Outputs cibles | `GroundedAnswer`, `GuidedQuestionSequence`, `ClarificationTrace`, `KnowledgeGapSignal` |
| Famille | Ingestion + Adaptive Orchestration |
| Providers consommés | `CorpusProvider`, `OntologyProvider`, `ValidationGuardProvider` |
| Artefacts cyber consommés | chunks runbooks, rapports, techniques ATT&CK, procédure interne |
| Invariants | toute réponse actionnable est source-grounded ; toute réponse faible confiance est marquée ; le mode socratique reste borné |
| À rendre agnostique | grounding, retrieval, tutoring style, gap detection |
| Risques de hardcoding | chatbot “smart” qui fabule ou qui se contente de search-in-docs |
| Refactor concret | faire pointer chaque réponse vers `source_ids[]`, `domain_refs[]`, `confidence`, `answer_mode` |
| Priorité | P1 |

---

## 2.15 APEX / FSRS / IMPRINT → Mastery Preservation Engine

| Champ | Détail |
|---|---|
| Mission actuelle | répétition espacée, mémorisation, imprint, cartes |
| Mission cible | préserver la maîtrise sur concepts, discriminations, procédures, jugements et réflexes |
| Inputs noyau | cartes, nœuds, preuves, erreurs récentes, criticité |
| Outputs cibles | `RetentionPlan`, `ReviewQueue`, `CriticalRefreshPlan`, `DriftAlerts` |
| Famille | Retention, Memory & Drift |
| Providers consommés | `RetentionPolicyProvider`, `ProofRubricProvider`, `ValidationGuardProvider` |
| Artefacts cyber consommés | techniques critiques, erreurs fréquentes, procédures rares mais vitales |
| Invariants | réviser aussi des décisions et procédures, pas juste des faits ; la criticité doit peser le planning |
| À rendre agnostique | politique FSRS enrichie, types de cartes, déclencheurs d’imprint |
| Risques de hardcoding | mémoire documentaire sans lien avec la readiness |
| Refactor concret | lier chaque carte / trigger à `MasteryNode` + `criticality` + `evidence_type` |
| Priorité | P1 |

---

## 2.16 COSMOS → Knowledge Visual Runtime

| Champ | Détail |
|---|---|
| Mission actuelle | visualisations et graphes |
| Mission cible | runtime de représentation visuelle du graphe de maîtrise, de l’ontologie et de la progression prouvée |
| Inputs noyau | `MasteryGraph`, `OntologyGraph`, `ProofState`, `LearnerState` |
| Outputs cibles | vues roadmap, concept map, criticity heatmaps, readiness maps |
| Famille | Explainability & Governance |
| Providers consommés | `OntologyProvider`, `RoleTaxonomyProvider`, `CorpusProvider` |
| Artefacts cyber consommés | ATT&CK hierarchy, role map, scenario progression, source links |
| Invariants | la vue doit représenter une structure réelle ; chaque couleur / statut doit correspondre à une métrique ou une preuve |
| À rendre agnostique | moteurs de visualisation, mapping structure -> vue |
| Risques de hardcoding | graphiques impressionnants mais déconnectés des objets du noyau |
| Refactor concret | faire de COSMOS un consommateur de `MasteryGraph` et `ProofState`, pas un générateur d’état parallèle |
| Priorité | P2 |

---

# 3. Matrice des objets universels par feature

| Objet universel | GOAL | CONTENT | DAG | CONDUCTOR | PERF | ROUTER | DRIFT | CERTIFIER | ARENA | CHRONICLE |
|---|---|---|---|---|---|---|---|---|---|---|
| `DomainReference` | lit | écrit/lie | lit | lit | lit | lit | lit | lit | lit | lit |
| `MasteryNode` | propose | mappe couverture | écrit | lit | lit | lit | lit | lit | lit | lit |
| `ScenarioBlueprint` | - | - | référence | lit | lit | lit | lit | lit | écrit trace | lit |
| `ProofRecord` | - | - | planifie | écrit parfois | écrit | lit | lit | lit/agrège | écrit | lit |
| `ReadinessVerdict` | - | - | - | lit pour gating | lit | lit | lit | écrit | alimente | lit |

### Conclusion opérable
Si une feature importante ne lit ni n’écrit aucun de ces objets, elle risque de dériver en sous-système parallèle.

---

# 4. Mapping des providers vers les features

## 4.1 `OntologyProvider`
Consommé prioritairement par :
- GOAL-INTERPRETER
- CONTENT-SCOUT
- DAG-ARCHITECT
- VISUAL-CRITIC
- BRAIN
- COSMOS

### Rôle exact
Donner la grammaire métier : concepts, hiérarchies, relations, identifiants pivots, synonymes, classes de décision.

## 4.2 `CorpusProvider`
Consommé prioritairement par :
- CONTENT-SCOUT
- BRAIN
- CHRONICLE
- COSMOS

### Rôle exact
Donner l’accès aux corpus autorisés, versionnés, segmentés, et à leur politique de provenance.

## 4.3 `RoleTaxonomyProvider`
Consommé prioritairement par :
- GOAL-INTERPRETER
- DAG-ARCHITECT
- LEARNING-CONDUCTOR
- PERFORMANCE-ANALYZER
- SKILL-CERTIFIER
- COGNITIVE-VALIDATOR

### Rôle exact
Définir les rôles, sous-rôles, niveaux, responsabilités, attentes de preuve, et scopes d’autonomie.

## 4.4 `DecisionScenarioProvider`
Consommé prioritairement par :
- LEARNING-CONDUCTOR
- ADAPTIVE-ROUTER
- SKILL-CERTIFIER
- ARENA

### Rôle exact
Exposer des scénarios blueprinted avec décisions requises, branches, erreurs éliminatoires, conséquences.

## 4.5 `ProofRubricProvider`
Consommé prioritairement par :
- GOAL-INTERPRETER
- DAG-ARCHITECT
- PERFORMANCE-ANALYZER
- SKILL-CERTIFIER
- CHRONICLE
- ARENA
- APEX / IMPRINT

### Rôle exact
Définir ce qui compte comme preuve, comment scorer, quels seuils appliquer et quelles erreurs annulent un verdict.

## 4.6 `RetentionPolicyProvider`
Consommé prioritairement par :
- LEARNING-CONDUCTOR
- ADAPTIVE-ROUTER
- DRIFT-GUARDIAN
- ENGAGEMENT-AMPLIFIER
- APEX / FSRS / IMPRINT
- COGNITIVE-VALIDATOR

### Rôle exact
Définir la fréquence, l’intensité, la modalité et la criticité de la réactivation.

## 4.7 `ValidationGuardProvider`
Consommé par pratiquement tout le monde.

### Rôle exact
C’est le garde-frontière. Il borne :
- ce qu’on peut affirmer,
- ce qu’on peut générer,
- ce qu’on peut certifier,
- ce qui doit être marqué incertain,
- ce qui doit être refusé.

### Verdict franc
Tant que ce provider n’est pas complété sérieusement, l’architecture reste conceptuellement brillante mais insuffisamment blindée.

---

# 5. Ce qui est encore trop couplé et doit être cassé

## Couplage #1 — contenu vs compétence
Risque : confondre un thème ou une source avec une capacité.

### À casser
- `content node` ≠ `mastery node`
- `ATT&CK technique` ≠ `skill proof`

## Couplage #2 — score global vs readiness bornée
Risque : croire qu’un SMI unique suffit à certifier.

### À casser
- score agrégé ≠ permission d’autonomie

## Couplage #3 — simulation libre vs scénario blueprinted
Risque : ARENA produit du théâtre non défendable.

### À casser
- roleplay génératif libre ≠ épreuve pratique validante

## Couplage #4 — FSRS documentaire vs préservation de jugement
Risque : l’utilisateur mémorise sans devenir sûr en situation.

### À casser
- carte mémoire ≠ rétention décisionnelle

## Couplage #5 — visualisation vs vérité du système
Risque : COSMOS devient une façade de graphes jolies.

### À casser
- vue graphique ≠ état de référence métier

---

# 6. Ordre de refactor recommandé

## P0 — ce qui définit la plateforme
1. GOAL-INTERPRETER
2. CONTENT-SCOUT
3. DAG-ARCHITECT
4. LEARNING-CONDUCTOR
5. PERFORMANCE-ANALYZER
6. SKILL-CERTIFIER
7. ARENA

## P1 — ce qui stabilise la crédibilité produit
8. ADAPTIVE-ROUTER
9. DRIFT-GUARDIAN
10. CHRONICLE
11. BRAIN
12. APEX / IMPRINT / FSRS

## P2 — ce qui industrialise l’explicabilité et la qualité d’interface
13. VISUAL-CRITIC
14. COGNITIVE-VALIDATOR
15. COSMOS

## P3 — ce qui optimise la persistance sans changer le cœur de vérité
16. ENGAGEMENT-AMPLIFIER

---

# 7. Verdict final

Le refactor ne doit pas partir de la question :

> “Comment brancher la cybersécurité sur nos features ?”

Il doit partir de :

> “Quelle vérité métier une feature consomme-t-elle, et par quel provider ?”

Si tu tiens cette discipline, alors :
- le **Pack Cyber** devient le premier théâtre de vérité métier profonde,
- le **noyau SCYForge** reste général et puissant,
- et l’extension à d’autres domaines devient une opération de pack, pas une réécriture du cerveau.

Le vrai test n’est pas “est-ce que ça marche pour la cyber ?”
Le vrai test est :

> “si je retire totalement le Pack Cyber, est-ce que la feature garde sa structure, son contrat et son sens ?”

Si oui, tu construis une plateforme.
Si non, tu construis encore une solution de niche déguisée.

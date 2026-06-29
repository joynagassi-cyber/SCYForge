# SCYForge — Workflows

> Audience: agent de codage ou humain qualifie.  
> Objectif: comprendre les workflows par role et par mode operationnel sans relire l’integralite des specs du depot.

---

## 1. Roles applicatifs

### 1.1 Apprenant / etudiant
Objectifs:
- declarer un objectif d’apprentissage
- ingerer des sources
- reviser avec retention
- visualiser son savoir
- interroger un assistant
- recevoir une certification si eligible

Services associes:
- ASCENT Agent-01 a Agent-09
- APEX / FSRS
- COSMOS
- BRAIN
- IMPRINT en declenchement conditionnel
- ARENA en mode premium

### 1.2 Createur / coach / administrateur B2B
Objectifs:
- creer des cursus ou des contenus
- suivre des cohortes
- auditer la qualite des parcours
- proposer des clarifications
- mesurer les performances de groupe

Services associes:
- B2B Creator Console
- ASCENT QA Comite
- Agent-16 HITL-Proxy-SME
- Agent-13 Cognitive Validator
- tables B2B: `scy_creator_cohorts`, `scy_creator_insights`, `scy_creator_clarifications`

### 1.3 Administrateur plateforme
Objectifs:
- surveiller l’etat systeme
- controler les depenses LLM
- gerer les features flags
- gerer la securite et la conformite

Services associes:
- health checks `/health/*`
- BudgetGuard
- circuit breakers
- politique RLS et anonymisation eventuelle

---

## 2. Modes operationnels

### 2.1 ASCENT Pipeline
Cible: apprenant qui declare un objectif structurant

Etendue:
- backend_ts orchestre ASCENT
- backend_rs fournit NEURON-CHAINS, APEX, COSMOS, BRAIN, Reader Suite, IMPRINT
- PostgreSQL stocke DAG, cartes, SMI, vitalite, logs agents

Regles d’implementation utiles:
- le DAG est construit avant toute generation de contenu
- la generation est lancee par nœud et consomme `/neuron-chains/*`
- les cartes sont generees par APEX et rattachees aux nœuds et a l’utilisateur
- les sessions de revision mettent a jour SMI et publient des events via EventBus
- la certification Proof of Skill est bloquee tant que PQS < 88 et SMI < 85 selon le parcours cible

### 2.2 Normal Mode
Cible: apprenant qui veut une exploitation immediate sans parcours agentique complet

Etendue:
- backend_ts orchestre Normal Mode
- backend_rs realise ingestion -> generation -> retention -> visualisation immediates
- pas de DAG complet, pas de QA comite, pas de certification long terme

Regles d’implementation utiles:
- garder le contrat d’API identique a ASCENT quand c’est possible pour mutualiser les adapters
- stocker l’etat projet dans `scy_projects`, `scy_project_sources`, `scy_project_suggestions`, `scy_project_deliverables`
- garantir que IMPRINT, BRAIN, COSMOS sont actifs immediatement apres generation
- tout ajout de service supplementaire doit se justifier par un gain utilisateur

### 2.3 B2B Creator Console
Cible: createur et ses apprenants

Etendue:
- backend_ts orchestre B2B
- backend_rs fournit les donnees de cohortes via les memes services transverses
- ASCENT QA Comite joue un role d’audit pedagogique

Regles d’implementation utiles:
- l’isolation est double: `creator_id` sur `scy_creator_cohorts`, puis verification transitive sur `scy_creator_insights` et `scy_creator_clarifications`
- le Creator Dashboard ne doit jamais exposer les textes prives des apprenants sans respecter un seuil k-anonymat documente
- les insights doivent etre rattaches a un `node_id` ou concept pour garder une action corrective exploitable

---

## 3. Flows module par module

### 3.1 Goal -> DAG -> Contenu
1. l’utilisateur soumet un objectif
2. Agent-01 normalise le goal
3. Agent-02 recherche et ingere des sources
4. Agent-03 construit le DAG et valide l’acyclicite
5. Agent-03 declenche les generations NEURON-CHAINS par nœud
6. APEX genere les cartes associees
7. COSMOS construit et actualise le Knowledge Graph

### 3.2 Session de revision
1. Agent-04 selectionne les cartes dues
2. APEX retourne une carte et attend un feedback
3. l’utilisateur revele la carte puis choisit un feedback
4. APEX recalcule FSRS, SMI et publie les events eventuels
5. Agent-05 lit les metriques SMI
6. Agent-06 decide d’un remede ou d’une acceleration
7. Agent-07 detecte un drift si sessions tronquees
8. Agent-08 peut proposer un engagement supplementaire

### 3.3 Certification
1. Agent-09 verifie les preconditions
2. ASCENT QA Comite rend un PQS
3. SurveyJS delivre l’examen final
4. ARENA peut etre declenchee si eligible
5. un Proof of Skill est emis quand SMI >= 85 et PQS >= 88

### 3.4 Assistant et lecture
1. BRAIN recoit une question
2. il interroge dense, sparse, graphe, puis fusionne avec RRF
3. il enrichit avec le contexte de Reader Suite
4. IMPRINT peut etre declenche pour creer une synthese courte
5. toute citation expose un deep link vers le document source

---

## 4. Conditions de declenchement des services secondaires

- IMPRINT cran 1 a 4: declenche automatique apres 3 succes consecutifs sur un nœud juge complexe, SMI > 75
- IMPRINT cran 5: declenche obligatoire pour une carte leech
- ARENA: declenche seulement quand FSRS stability >= 3.0 jours sur les concepts requis
- CHRONICLE Daily Pulse: declenche selon fuseau et habitudes utilisateur
- Boost sommeil: declenche 2 minutes avant le coucher pour les concepts complexes

---

## 5. Transitions autorisees et interdites par role

Apprenant:
- peut lire et modifier son propre etat
- ne peut pas modifier un DAG construit par ASCENT sans re-build explicite
- ne peut pas supprimer les decisions agents ou les spend logs

Createur:
- peut creer et modifier ses propres cohortes
- peut ajouter une clarification sur un insight de ses cohortes
- ne peut pas acceder aux donnees privees des apprenants en dessous du seuil k-anonymat valide

Admin:
- peut consulter les health checks, budgets et incidents
- peut modifier les features flags
- ne peut pas lire le contenu prive des utilisateurs sans procedure documentee

---

## 6. Workflows auxiliaires

### 6.1 Onboarding
1. Guest mode disponible
2. Evaluateur initial fourni par BRAIN
3. objectif minimal requis
4. premier contenu genere avec cible d’attente < 90s

### 6.2 Progressive Automation
1. niveau 0: actions explicites, aucune automation
2. niveau 1: suggestions automatiques, validation utilisateur
3. niveau 2: actions automatiques avec annulation possible
4. niveau 3: actions automatiques sans confirmation par domaine valide

### 6.3 Automatisation B2B
1. upload SOP entreprise
2. parsing et transformation
3. auto curation avec seuil qualite documente
4. diffusion cohorte avec suivi SMI

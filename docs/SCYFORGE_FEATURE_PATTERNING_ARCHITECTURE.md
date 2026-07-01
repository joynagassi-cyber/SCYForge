# SCYForge — Patterning des features actuelles pour la cybersécurité **et** l’extensibilité multi-domaines

## Thèse centrale

Le bon modèle pour SCYForge n’est pas :
- un produit cyber codé en dur,
- ni un moteur générique vide qui ne sait rien faire de concret,
- ni un simple RAG habillé avec quelques agents.

Le bon modèle est :

> **un noyau cognitif invariant** qui transforme du savoir privé en compréhension, rétention, maîtrise, preuve de compétence et autonomie opérationnelle, **augmenté par des Domain Packs** qui injectent la réalité métier d’un domaine donné.

Autrement dit :
- **le cœur ne doit jamais “savoir la cybersécurité” en dur** ;
- **le cœur doit savoir comment fabriquer la maîtrise** ;
- **le Pack Cyber doit apprendre au cœur ce que signifie être compétent en cyber**.

C’est cette séparation qui permet à SCYForge :
1. d’être **violentement pertinent** dans une niche initiale comme le SOC / blue team,
2. sans se condamner à devenir une société de services cyber maquillée,
3. et sans réécrire le produit quand tu voudras ouvrir un pack Vente, Support, Finance, Ops, Médical ou autre.

---

# 1. Le principe d’architecture : séparer **mécanique d’apprentissage** et **vérité métier**

## 1.1 Ce qui est invariant dans tous les domaines

Les mécanismes suivants doivent être considérés comme **des primitives du noyau SCYForge** :

1. **Déclarer un objectif**
2. **Décomposer cet objectif en graphe de maîtrise**
3. **Ingerer et normaliser des sources privées**
4. **Construire une représentation exploitable du savoir**
5. **Diagnostiquer le niveau réel de l’utilisateur**
6. **Choisir la meilleure intervention suivante**
7. **Créer une expérience d’apprentissage active**
8. **Mesurer compréhension, rétention, jugement, exécution**
9. **Détecter les dérives, illusions de compétence et oublis**
10. **Produire une preuve de compétence défendable**
11. **Boucler sur la progression jusqu’à autonomie**

Aucun de ces mécanismes n’est intrinsèquement cyber.

Ils valent aussi pour :
- un SDR,
- un chargé de support,
- un analyste crédit,
- un technicien qualité,
- un opérateur industriel,
- un chef de projet réglementaire,
- un agent de conformité médicale.

## 1.2 Ce qui varie selon le domaine

Ce qui change radicalement d’un domaine à l’autre, ce n’est pas le moteur de maîtrise.

Ce qui change, c’est la réponse aux questions suivantes :
- quels concepts comptent ?
- quels rôles existent ?
- quelles erreurs sont graves ?
- quels signaux sont fiables ?
- quels scénarios sont réalistes ?
- qu’est-ce qu’une bonne décision ?
- quel niveau de preuve est acceptable ?
- quel oubli est tolérable ?
- quelles sources sont légitimes ?
- quel rythme de révision est nécessaire ?

C’est exactement le rôle du **Domain Pack**.

---

# 2. Modèle de patterning : chaque feature = **Kernel + Domain Contract + Domain Artifact + Runtime Policy**

Chaque feature actuelle de SCYForge doit être repensée selon le patron suivant :

## 2.1 Les 4 couches

### A. Kernel Capability
La capacité universelle, indépendante du domaine.

Exemples :
- générer un graphe de maîtrise,
- router un apprenant,
- évaluer une réponse,
- planifier la révision,
- orchestrer un scénario,
- calculer un score de confiance,
- produire une trace de progression.

### B. Domain Contract
L’interface par laquelle un domaine vient injecter sa vérité métier.

Exemples :
- `OntologyProvider`
- `RoleTaxonomyProvider`
- `DecisionScenarioProvider`
- `ProofRubricProvider`
- `RetentionPolicyProvider`
- `ValidationGuardProvider`

### C. Domain Artifact
Les données / règles / graphes / scénarios réels apportés par un pack.

Exemples cyber :
- hiérarchie ATT&CK,
- densité Sigma,
- taxonomie SOC L1/L2,
- scénarios APT29,
- rubriques de preuve de compétence,
- garde-fous anti-hallucination.

### D. Runtime Policy
Les règles d’exécution qui adaptent la feature à un contexte client / rôle / niveau / risque.

Exemples :
- stricte source-grounding obligatoire,
- impossibilité de certifier sans scénario branché,
- politique de révision plus dense sur les techniques critiques,
- exigence d’explication avant action,
- seuil de mastery plus élevé pour l’IR que pour le triage L1.

---

# 3. La bonne abstraction : SCYForge ne livre pas des features, il livre des **capacités cognitives spécialisables**

Si tu penses “feature list”, tu risques de produire un patchwork.
Si tu penses “capabilités cognitives spécialisables”, tu construis une plateforme.

Donc les features actuelles doivent être reclassées en **7 familles de capacités**.

---

# 4. Les 7 familles de capacités à paterniser

## 4.1 Family 1 — Knowledge Ingestion & Canonicalization

### Mission
Transformer des corpus bruts, hétérogènes et privés en matière exploitable par le système.

### Features actuelles concernées
- ingestion multi-sources,
- normalisation contenu,
- extraction concepts / sources,
- mapping sur objectifs,
- composio / connecteurs,
- mémoire source-grounded,
- BRAIN / base Q&A.

### Pattern noyau
**Kernel capability**
- parser des sources,
- chunker / lier / versionner,
- extraire entités / claims / procédures,
- rattacher le contenu à des `Source`, `Concept`, `Node`, `Goal`,
- calculer confiance et fraîcheur,
- conserver provenance stricte.

**Domain contract nécessaire**
- `CorpusProvider`
- `OntologyProvider`
- `ValidationGuardProvider`

**Artifacts cyber**
- règles Sigma,
- hunts OTRF,
- techniques ATT&CK,
- playbooks IR internes,
- postmortems SOC,
- runbooks SIEM / EDR.

**Invariants multi-domaines**
- toute information actionnable doit être reliée à une source,
- toute extraction doit conserver provenance et version,
- toute assertion non supportée doit être marquée comme faible confiance ou rejetée.

**Spécialisation cyber**
- déduire les liaisons `source -> technique -> détection -> décision -> procédure`,
- enrichir avec tags ATT&CK,
- distinguer signal, faux positif, procédure d’escalade, artefact forensic,
- marquer les zones où une hallucination est dangereuse.

### Ce que ça devient dans un autre domaine
Exemple vente :
- sources = call recordings, battlecards, scripts, objections, CRM notes, win/loss reviews,
- ontologie = persona, objection, segment, deal stage, competitor, pricing logic,
- validation = pas d’invention de pricing, pas d’affirmation hors playbook.

---

## 4.2 Family 2 — Mastery Graph Construction

### Mission
Transformer un objectif vague en carte explicite de maîtrise.

### Features actuelles concernées
- GOAL-INTERPRETER,
- DAG-ARCHITECT,
- graphes de concepts,
- nodes / prerequisites,
- pathways ASCENT,
- modes Cosmos de visualisation.

### Pattern noyau
**Kernel capability**
- convertir un objectif en sous-capacités,
- modéliser prérequis, dépendances, profondeur,
- relier connaissance déclarative, procédurale et décisionnelle,
- créer un graphe pilotable par progression.

**Domain contract nécessaire**
- `OntologyProvider`
- `RoleTaxonomyProvider`
- `ProofRubricProvider`

**Artifacts cyber**
- familles ATT&CK,
- techniques critiques par rôle,
- taxonomie SOC L1/L2 / Threat Hunter / IR,
- niveaux AWARE / APPLY / MASTER.

**Invariants multi-domaines**
- un objectif ne doit jamais rester une phrase ; il doit devenir un graphe vérifiable,
- chaque nœud doit avoir : description, preuve attendue, niveau de difficulté, prérequis, source,
- le graphe doit séparer savoir, jugement, action, erreur critique.

**Spécialisation cyber**
Pour “rendre autonome une recrue SOC L1” le graphe ne doit pas être “connaître le SOC”, mais quelque chose comme :
- reconnaître patterns d’exécution suspects,
- lire les signaux EDR/SIEM,
- distinguer activité admin légitime vs tradecraft,
- escalader au bon seuil,
- documenter proprement,
- éviter les faux positifs structurants,
- appliquer les playbooks sans se figer.

### Ce que ça devient dans un autre domaine
Exemple support :
- comprendre le produit,
- diagnostiquer symptôme vs cause,
- reproduire un bug,
- prioriser,
- communiquer au client,
- escalader à l’ingénierie avec le bon niveau de preuve.

---

## 4.3 Family 3 — Adaptive Learning Orchestration

### Mission
Décider quoi faire apprendre, dans quel ordre, sous quelle forme, à quel rythme.

### Features actuelles concernées
- LEARNING-CONDUCTOR,
- ADAPTIVE-ROUTER,
- ENGAGEMENT-AMPLIFIER,
- modes ASCENT,
- chemins personnalisés,
- routage par performance / confusion / fatigue.

### Pattern noyau
**Kernel capability**
- choisir l’intervention suivante,
- alterner explication, test, simulation, révision, correction,
- adapter la difficulté,
- gérer progression et friction,
- arbitrer vitesse vs maîtrise.

**Domain contract nécessaire**
- `RoleTaxonomyProvider`
- `RetentionPolicyProvider`
- `ValidationGuardProvider`
- `DecisionScenarioProvider`

**Artifacts cyber**
- scénarios de triage,
- exercices d’analyse d’alertes,
- seuils de complexité par rôle,
- politique de répétition plus forte sur décisions à fort impact,
- garde-fous contre “réponse plausible mais dangereuse”.

**Invariants multi-domaines**
- le système ne doit pas optimiser l’engagement aux dépens de la maîtrise,
- il doit favoriser les interventions qui révèlent le niveau réel,
- il doit pouvoir ralentir volontairement un apprenant qui survole.

**Spécialisation cyber**
En cyber, l’orchestrateur doit comprendre qu’une bonne progression ne ressemble pas à “lire plus de docs”, mais à :
- passer d’indicateurs simples à alertes ambiguës,
- passer d’explication assistée à jugement autonome,
- introduire des faux positifs réalistes,
- créer des situations de pression et d’incertitude,
- valider l’escalade et la documentation.

### Ce que ça devient dans un autre domaine
Exemple vente :
- objections simples → objections piégeuses,
- pitch assisté → discovery autonome,
- qualification → négociation → multi-threading → closing discipline.

---

## 4.4 Family 4 — Active Practice & Arena Simulation

### Mission
Faire pratiquer, pas seulement exposer à l’information.

### Features actuelles concernées
- ARENA,
- scénarios immersifs,
- branching,
- dialogues dynamiques,
- confrontation de décisions,
- visual critic / cognitive validator.

### Pattern noyau
**Kernel capability**
- instancier un scénario,
- injecter contexte, rôles, contraintes, signaux,
- capturer les décisions de l’apprenant,
- faire évoluer l’environnement en fonction de ses choix,
- enregistrer la trace comportementale.

**Domain contract nécessaire**
- `DecisionScenarioProvider`
- `ProofRubricProvider`
- `ValidationGuardProvider`

**Artifacts cyber**
- chaîne APT29,
- alertes ambiguës,
- télémétrie simulée,
- choix d’escalade,
- procédures de confinement,
- erreurs éliminatoires.

**Invariants multi-domaines**
- le scénario doit avoir un but, des conditions de réussite, des erreurs critiques,
- la simulation doit tester des décisions, pas uniquement la mémoire,
- les branches doivent refléter des conséquences métier plausibles.

**Spécialisation cyber**
Le pattern cyber n’est pas “QCM ATT&CK”.
Le pattern cyber est :
- tu vois un signal,
- tu dois l’interpréter,
- tu dois éviter les mauvaises conclusions,
- tu dois agir avec procédure,
- tu dois justifier ton choix,
- le système évalue ta lucidité, pas juste ta mémoire.

### Ce que ça devient dans un autre domaine
Exemple support :
- un client décrit un incident,
- les logs sont incomplets,
- plusieurs hypothèses sont plausibles,
- il faut guider, rassurer, reproduire, prioriser, escalader proprement.

---

## 4.5 Family 5 — Assessment, Proof of Skill & Certification Engine

### Mission
Dire si quelqu’un est réellement prêt, et pouvoir le défendre.

### Features actuelles concernées
- PERFORMANCE-ANALYZER,
- SKILL-CERTIFIER,
- score SMI,
- proof-of-skill,
- barèmes,
- chronicle des performances.

### Pattern noyau
**Kernel capability**
- mesurer performance sur plusieurs dimensions,
- agréger preuve déclarative + procédurale + situationnelle,
- calculer niveau de maîtrise et confiance,
- produire un verdict explicable,
- historiser l’évolution.

**Domain contract nécessaire**
- `ProofRubricProvider`
- `ValidationGuardProvider`
- `RoleTaxonomyProvider`

**Artifacts cyber**
- barème 5 dimensions déjà défini,
- erreurs éliminatoires,
- seuils par rôle,
- correspondance compétence -> autonomie autorisée.

**Invariants multi-domaines**
- la certification ne peut pas dépendre d’un seul format d’épreuve,
- il faut distinguer savoir, jugement, exécution, robustesse sous ambiguïté,
- le verdict doit être traçable à des preuves observables.

**Spécialisation cyber**
En cyber, il faut explicitement distinguer :
- savoir reconnaître,
- savoir qualifier,
- savoir escalader,
- savoir documenter,
- savoir agir sans créer de dommage.

Le système doit pouvoir dire :
- “compétent pour triage L1 standard”,
- “pas encore fiable sur faux positifs ambigus”,
- “dangereux sur décisions de containment”,
- “autonome sur telle classe d’alertes, supervision requise sur telle autre”.

### Ce que ça devient dans un autre domaine
Exemple vente :
- autonome sur discovery SMB,
- non fiable sur objection pricing enterprise,
- bon en produit mais faible en multi-threading politique.

---

## 4.6 Family 6 — Retention, Memory & Drift Control

### Mission
Faire durer la maîtrise et détecter l’érosion.

### Features actuelles concernées
- IMPRINT,
- FSRS / APEX,
- DRIFT-GUARDIAN,
- mémoire temporelle,
- réactivation ciblée,
- détection oubli / dérive.

### Pattern noyau
**Kernel capability**
- estimer probabilité d’oubli,
- programmer la révision,
- sélectionner quoi réactiver,
- détecter dérive conceptuelle ou procédurale,
- ré-entraîner localement des faiblesses.

**Domain contract nécessaire**
- `RetentionPolicyProvider`
- `ProofRubricProvider`
- `ValidationGuardProvider`

**Artifacts cyber**
- techniques critiques à réviser plus souvent,
- faux positifs typiques,
- procédures rares mais vitales,
- signaux de dérive : confusion persistence/execution, escalade prématurée, excès de confiance.

**Invariants multi-domaines**
- la rétention ne doit pas être purement mnésique,
- le système doit réactiver aussi le jugement et la procédure,
- les compétences fragiles mais critiques doivent avoir un poids supérieur.

**Spécialisation cyber**
En cyber, oublier une taxonomie n’est pas le principal risque.
Le principal risque est de perdre :
- la discipline d’investigation,
- la lecture correcte de signaux partiels,
- la séquence de décision,
- la mémoire des cas piégeux.

Donc la rétention doit porter sur :
- concepts,
- discriminations,
- procédures,
- réflexes d’escalade,
- documentation.

### Ce que ça devient dans un autre domaine
Exemple médecine :
- signaux rouges,
- protocoles d’exception,
- diagnostics différentiels,
- séquences de sécurité patient.

---

## 4.7 Family 7 — Explainability, Chronicle & Governance

### Mission
Rendre le système auditable, pilotable et crédible en B2B.

### Features actuelles concernées
- CHRONICLE,
- observabilité,
- trace des décisions agents,
- source grounding,
- dashboards B2B,
- explicabilité des scores.

### Pattern noyau
**Kernel capability**
- journaliser décisions et preuves,
- exposer pourquoi une intervention a été choisie,
- montrer quelles sources soutiennent un verdict,
- isoler ce qui vient du noyau vs du pack,
- fournir des vues admin / manager / auditeur.

**Domain contract nécessaire**
- `ValidationGuardProvider`
- `ProofRubricProvider`
- `CorpusProvider`

**Artifacts cyber**
- mapping source -> technique -> scénario -> score,
- politique d’audit formation SOC,
- justification d’autonomie accordée ou refusée,
- limites connues du pack.

**Invariants multi-domaines**
- tout verdict important doit être explicable,
- toute certification doit être auditable,
- toute recommandation sensible doit être traçable à des sources.

**Spécialisation cyber**
C’est ici que SCYForge devient vendable à un Directeur SOC.
Il ne veut pas juste “un apprenant qui a fait 82%”.
Il veut pouvoir voir :
- sur quels types d’alertes la recrue est fiable,
- où elle échoue,
- quels scénarios l’ont mise en défaut,
- si elle peut être lâchée seule ou non.

---

# 5. Tableau de patterning global

| Famille | Promesse noyau | Contrats domaine clés | Spécialisation cyber | Invariant d’extensibilité |
|---|---|---|---|---|
| Ingestion & Canonicalization | Transformer corpus privé en savoir exploitable | Corpus, Ontology, ValidationGuard | ATT&CK, Sigma, hunts, runbooks, IR | provenance stricte, versioning, confiance |
| Mastery Graph | Transformer objectif en carte de maîtrise | Ontology, RoleTaxonomy, ProofRubric | SOC L1/L2, techniques, prérequis, erreurs critiques | graphe explicite, preuve par nœud |
| Adaptive Orchestration | Choisir la meilleure intervention suivante | RoleTaxonomy, RetentionPolicy, DecisionScenario, ValidationGuard | triage, ambiguïté, pression, escalation | optimisation maîtrise > engagement |
| Arena Simulation | Faire pratiquer en situation | DecisionScenario, ProofRubric, ValidationGuard | alertes, investigations, containment, reporting | conséquences plausibles, décisions testées |
| Proof of Skill | Déterminer si la personne est prête | ProofRubric, RoleTaxonomy, ValidationGuard | autonomie par classe d’alertes, erreurs éliminatoires | verdict traçable, multi-signal |
| Retention & Drift | Faire durer la compétence | RetentionPolicy, ProofRubric, ValidationGuard | faux positifs, signaux faibles, procédures critiques | révision cognitive, pas seulement mémoire |
| Explainability & Governance | Rendre le système pilotable et crédible | ValidationGuard, Corpus, ProofRubric | audit readiness SOC, justification du niveau | auditabilité de bout en bout |

---

# 6. Les patterns de données à imposer partout

Pour rester extensible, il faut maintenant imposer quelques objets universels.

## 6.1 Objet `DomainReference`

Chaque artefact métier doit être référencé de façon uniforme.

```ts
interface DomainReference {
  id: string;
  domain: string;              // cyber, sales, support...
  type: string;                // technique, scenario, role, policy, procedure
  external_key?: string;       // ex: T1059.001
  title: string;
  description?: string;
  source_ids: string[];
  tags: string[];
  confidence?: number;
  version: string;
}
```

### Pourquoi c’est vital
Parce qu’un nœud de maîtrise, une carte FSRS, une simulation ou un verdict doivent tous pouvoir pointer vers une même grammaire de référence, indépendamment du domaine.

---

## 6.2 Objet `MasteryNode`

```ts
interface MasteryNode {
  id: string;
  goal_id: string;
  domain_refs: string[];
  label: string;
  mastery_type: 'knowledge' | 'discrimination' | 'procedure' | 'decision' | 'communication';
  level_target: 'aware' | 'apply' | 'master';
  prerequisites: string[];
  failure_modes: string[];
  proof_requirements: string[];
  criticality: 'low' | 'medium' | 'high' | 'mission_critical';
}
```

### Pourquoi c’est vital
Parce que tu veux éviter un graphe purement sémantique.
Le graphe doit être **un graphe de compétence**, pas juste un graphe de concepts.

---

## 6.3 Objet `ScenarioBlueprint`

```ts
interface ScenarioBlueprint {
  id: string;
  title: string;
  domain: string;
  role_targets: string[];
  trigger_refs: string[];
  objective: string;
  context: string;
  signals: string[];
  required_decisions: string[];
  branch_rules: string[];
  elimination_errors: string[];
  scoring_rubric_id: string;
  source_ids: string[];
}
```

### Pourquoi c’est vital
Parce que la simulation doit être générée à partir d’un plan de vérité, pas improvisée à chaque fois.

---

## 6.4 Objet `ProofRecord`

```ts
interface ProofRecord {
  id: string;
  learner_id: string;
  goal_id: string;
  node_id?: string;
  scenario_id?: string;
  evidence_type: 'quiz' | 'explanation' | 'decision' | 'procedure' | 'simulation' | 'retention';
  score: number;
  confidence: number;
  rubric_dimensions: Array<{
    dimension: string;
    score: number;
    rationale: string;
  }>;
  source_ids: string[];
  evaluator_trace_ids: string[];
  verdict: 'insufficient' | 'developing' | 'operational' | 'autonomous';
}
```

### Pourquoi c’est vital
Parce que la vraie valeur B2B n’est pas juste une expérience d’apprentissage.
La valeur, c’est une **preuve exploitable de préparation réelle**.

---

# 7. Comment les features actuelles doivent être refactorées

Maintenant, parlons concrètement de **paternisation des features existantes**.

## 7.1 GOAL-INTERPRETER

### Aujourd’hui
Interprète l’objectif utilisateur.

### Demain
Doit devenir un **Goal Compiler** domain-aware via contrat, pas via logique cyber en dur.

### Pattern cible
- input : objectif brut,
- kernel : extraction intention, rôle, niveau, horizon,
- pack : enrichissement par taxonomie métier,
- output : `GoalSpec` structuré + premiers `MasteryNode` candidats.

### Règle
Le Goal Interpreter n’a pas le droit de contenir “SOC analyst” en dur.
Il doit demander au `RoleTaxonomyProvider` ce que signifie ce rôle.

---

## 7.2 CONTENT-SCOUT

### Aujourd’hui
Cherche et rassemble des contenus.

### Demain
Doit devenir un **Evidence Scout**.

### Pattern cible
- recherche des sources,
- score leur fiabilité,
- extrait claims / procédures / signaux,
- les mappe sur l’ontologie du pack,
- rejette ou marque les trous de preuve.

### Cyber
Doit savoir que :
- un blog random n’a pas le même statut qu’un playbook interne,
- une règle Sigma peut informer la détection mais pas suffire pour une procédure IR,
- un hunt OTRF peut alimenter un scénario mais doit être contextualisé.

---

## 7.3 DAG-ARCHITECT

### Aujourd’hui
Construit les parcours.

### Demain
Doit devenir un **Mastery Graph Compiler**.

### Pattern cible
- convertit objectifs + ontologie + rôle + rubriques de preuve en DAG de compétence,
- sépare explicitement connaissances, discriminations, procédures, décisions,
- associe chaque nœud à des formes d’épreuve.

### Cyber
Le DAG ne doit pas être un syllabus ATT&CK.
Il doit être une carte de capacité opérationnelle.

---

## 7.4 LEARNING-CONDUCTOR + ADAPTIVE-ROUTER

### Demain
Unifiés conceptuellement comme **Intervention Policy Engine**.

### Pattern cible
Décide si l’apprenant a besoin :
- d’explication,
- de reformulation,
- de test ciblé,
- de simulation,
- de révision FSRS,
- d’un cas contradictoire,
- d’un frein parce que confiance > compétence réelle.

### Cyber
Il faut optimiser la réduction du risque opérationnel futur, pas juste la progression apparente.

---

## 7.5 PERFORMANCE-ANALYZER + SKILL-CERTIFIER

### Demain
Unifiés conceptuellement comme **Readiness Verdict Engine**.

### Pattern cible
- collecte les preuves,
- score par dimension,
- applique règles éliminatoires,
- produit un verdict contextualisé par rôle et périmètre.

### Cyber
Doit pouvoir dire :
- “autonome sur phishing triage standard”,
- “non autonome sur credential theft multi-signal”,
- “bon niveau explicatif mais mauvais niveau de décision”.

---

## 7.6 DRIFT-GUARDIAN + IMPRINT / FSRS

### Demain
Unifiés conceptuellement comme **Mastery Preservation Engine**.

### Pattern cible
- surveille l’érosion,
- relance des épreuves ciblées,
- compare performance récente à performance historique,
- détecte illusion de maîtrise.

### Cyber
Doit repérer les compétences qui “semblent connues” mais cassent sous ambiguïté.

---

## 7.7 CHRONICLE

### Demain
Doit devenir le **Learning Ledger** du produit.

### Pattern cible
- stocke toutes les preuves,
- journalise les décisions agentiques,
- permet audit, justification, reporting manager,
- alimente moat de télémétrie d’apprentissage.

### Cyber
C’est la couche qui transforme SCYForge en système de readiness managérial, pas en simple app de formation.

---

# 8. Les invariants non négociables pour éviter la dérive “wrapper LLM”

Voici les règles à imposer dans toutes les features.

## Invariant 1 — Source-grounding strict sur tout contenu sensible
Pas de verdict, pas de scénario critique, pas de recommandation opérationnelle sans source traçable.

## Invariant 2 — Domain truth injectable, jamais hardcodée dans le noyau
Le noyau ne connaît aucun domaine en dur.

## Invariant 3 — La plus petite unité de valeur n’est pas le document, c’est le nœud de maîtrise prouvable
Tu ne vends pas l’accès à l’info. Tu vends la montée en autonomie.

## Invariant 4 — Toute évaluation importante doit mélanger mémoire, jugement et action
Sinon tu certifies des gens qui récitent.

## Invariant 5 — Les simulations doivent être blueprintées par artefacts domaine
Pas d’improvisation libre pour les cas critiques.

## Invariant 6 — Les verdicts doivent être bornés par périmètre
Jamais “compétent en cyber”.
Toujours “prêt pour tel rôle, tel contexte, tel niveau de risque”.

## Invariant 7 — Les données d’apprentissage doivent enrichir le moat sans polluer la vérité métier globale
Les télémétries privées d’un client enrichissent des politiques et modèles, mais ne doivent pas contaminer les artefacts d’un autre tenant.

---

# 9. Le pattern de spécialisation cyber exact

Le Pack Cyber ne doit pas juste fournir du contenu.
Il doit fournir **la grammaire opérationnelle cyber**.

## 9.1 Ce qu’il doit injecter

### Ontologie
- tactiques,
- techniques,
- sous-techniques,
- familles de détection,
- types de signaux,
- types d’erreurs,
- procédures IR,
- classes de décisions.

### Taxonomie des rôles
- SOC L1,
- SOC L2,
- Threat Hunter,
- Incident Responder,
- attentes par niveau.

### Graphe de criticité
- ce qui est fréquent,
- ce qui est rare mais grave,
- ce qui est rôle-spécifique,
- ce qui est bloquant pour autonomie.

### Blueprints de scénarios
- triage,
- privilege escalation,
- credential access,
- persistence,
- lateral movement,
- faux positifs courants,
- cas contradictoires.

### Rubriques de preuve
- détection,
- discernement,
- décision,
- procédure,
- rétention.

### Garde-fous
- pas de procédure inventée,
- pas de claim de readiness sans simulation,
- pas de recommandation forte sans source suffisante,
- marquage explicite de l’incertitude.

## 9.2 Le résultat
Quand le noyau SCYForge rencontre le Pack Cyber, il ne devient pas “un LMS cyber”.
Il devient :

> un moteur capable de transformer les corpus, procédures, incidents et référentiels d’une organisation en trajectoires de maîtrise opérationnelle cyber, avec preuve d’autonomie contextualisée.

C’est beaucoup plus fort.

---

# 10. Le pattern d’extensibilité exact

Pour qu’un autre domaine soit possible sans souffrance, il faut qu’un nouveau pack n’ait qu’à répondre à la question suivante :

> “Qu’est-ce qu’être compétent dans ce domaine, et comment le prouver ?”

Si le cœur est bien conçu, ajouter un domaine devient :
1. brancher l’ontologie,
2. brancher la taxonomie des rôles,
3. brancher les scénarios,
4. brancher les rubriques de preuve,
5. brancher les politiques de rétention et de validation,
6. injecter les corpus clients.

Pas réécrire ASCENT.

---

# 11. Le test de solidité de ton architecture

Ton architecture est bonne si les phrases suivantes deviennent vraies :

## Test 1
On peut retirer totalement le Pack Cyber, brancher un Pack Sales, et le noyau continue de fonctionner.

## Test 2
On peut faire évoluer l’ontologie cyber sans casser les moteurs de maîtrise.

## Test 3
On peut ajouter une nouvelle classe de scénario cyber sans réécrire l’évaluation.

## Test 4
On peut changer les règles de preuve d’un rôle donné sans recompiler tout le produit.

## Test 5
On peut isoler ce qui relève de la vérité métier du client vs de la vérité métier globale du pack.

## Test 6
On peut expliquer tout verdict important en remontant à :
- sources,
- nœuds de maîtrise,
- scénarios,
- rubriques,
- traces d’exécution.

Si un seul de ces tests échoue, tu n’as pas encore une plateforme. Tu as un assemblage.

---

# 12. Modèle cible de layering produit

## Layer 1 — Cognitive Kernel
Ce que SCYForge sait faire universellement.
- compiler objectifs,
- compiler graphes,
- orchestrer interventions,
- générer évaluations,
- conduire simulations,
- calculer rétention,
- produire verdicts,
- journaliser preuves.

## Layer 2 — Domain Capability Contracts
Les ports par lesquels un domaine déclare sa vérité.
- ontologie,
- rôles,
- corpus,
- scénarios,
- rubriques,
- politiques,
- garde-fous.

## Layer 3 — Domain Packs
Ex : Cyber Pack, Sales Pack, Support Pack.

## Layer 4 — Tenant Knowledge Layer
Le savoir privé de l’entreprise cliente.
- runbooks,
- procédures,
- incidents passés,
- FAQs,
- documentation interne,
- cas spécifiques.

## Layer 5 — Learning Telemetry Layer
Les données d’apprentissage accumulées.
- erreurs fréquentes,
- temps à maîtrise,
- illusions de compétence,
- scénarios discriminants,
- nœuds difficiles.

C’est cette couche 5 qui nourrit le moat sans violer la séparation de tenants.

---

# 13. Ce qu’il faut faire maintenant dans le produit

## Priorité 1 — Définir la taxonomie canonique des capacités noyau
Il faut nommer officiellement les 7 familles et rattacher chaque agent / feature actuelle à l’une d’elles.

## Priorité 2 — Formaliser les objets universels
`DomainReference`, `MasteryNode`, `ScenarioBlueprint`, `ProofRecord`, plus `GoalSpec` et `ReadinessVerdict`.

## Priorité 3 — Refactorer les agents pour dépendre des providers, pas du domaine
Chaque agent doit appeler des contrats, jamais des heuristiques cyber codées en dur.

## Priorité 4 — Compléter le Cyber Pack comme premier pack “vérité métier complète”
Notamment :
- ValidationGuardProvider complet,
- bibliothèque de blueprints de scénarios,
- mapping runbook interne -> proof requirements,
- politiques de rétention par criticité.

## Priorité 5 — Prouver l’extensibilité avec un mini second pack
Pas un pack complet.
Un **thin slice** suffit.
Exemple : `sales-lite` avec :
- 1 ontologie,
- 2 rôles,
- 3 scénarios,
- 1 rubrique de preuve.

Pourquoi ?
Parce que tant que tu n’as qu’un pack cyber, ton extensibilité reste une promesse.
Avec un mini-pack secondaire, elle devient crédible.

---

# 14. Conclusion franche

La bonne manière de paterniser les features actuelles de SCYForge, ce n’est pas de se demander :

> “Comment adapter nos features à la cybersécurité ?”

La bonne question est :

> “Quelles sont les capacités cognitives universelles de SCYForge, et comment un pack domaine leur injecte une définition locale de la compétence ?”

La cybersécurité doit être :
- **le premier théâtre où SCYForge prouve sa puissance**,
- pas **la prison conceptuelle** du produit.

Donc ton pattern cible est :

> **Kernel cognitif invariant** → **Contracts domaine** → **Pack Cyber** → **Savoir privé du client** → **Télémétrie de maîtrise**.

C’est ce modèle qui te permet d’avoir à la fois :
- un wedge ultra-fort en cybersécurité,
- une vraie cohérence produit,
- une architecture d’extension crédible,
- et un moat qui s’épaissit avec le temps.

---

# 15. Prochaine étape recommandée

Le meilleur move maintenant, c’est de produire un **document complémentaire ultra-opérationnel** :

## `SCYFORGE_FEATURE_TO_PROVIDER_MATRIX.md`

Avec, pour **chaque feature/agent actuel** :
- mission,
- input/output,
- invariants,
- providers consommés,
- artefacts cyber consommés,
- parties à rendre domain-agnostic,
- risques de hardcoding,
- priorité de refactor.

C’est ce document qui fera la jonction entre la vision stratégique et le refactor produit réel.

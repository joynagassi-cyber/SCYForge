# SCYForge — RCL Implementation Backlog
## Backlog d’implémentation en tenant compte des acquis cognitifs du jour

## But du document

Ce backlog traduit RCL en travail exécutable **en intégrant explicitement les acquis conceptuels apportés aujourd’hui** par les documents joints sur :
- ACTOR,
- Arbre sémantique,
- Protocole 3C,
- ratio output > input,
- génération active,
- IA comme sparring-partner,
- cycles biologiques de consolidation,
- testing sandwich,
- feedback ACE,
- OCEAN,
- AIM / MAP.

Le point important est le suivant :

> ces acquis ne doivent pas rester des notes pédagogiques externes.
> Ils doivent devenir des **contraintes de design de SCYForge**, donc des objets, policies, packets, triggers et règles d’orchestration.

Autrement dit, ce document ne fait pas juste un backlog RCL.
Il fait un backlog RCL **informé par ta philosophie d’apprentissage radicale**.

---

# 1. Les acquis du jour à intégrer dans le produit

## 1.1 Acquis structurants extraits des documents

### A. ACTOR comme protocole de transformation lecture → maîtrise
- `Aim`
- `Compress`
- `Test`
- `Own`
- `Run`

### B. Arbre sémantique
- tronc avant feuilles,
- principes fondamentaux avant détails,
- hiérarchisation 80/20,
- connaissance comme structure porteuse.

### C. Protocole 3C
- compresser,
- compiler,
- consolider.

### D. Output > input
- ratio recommandé de production supérieur à consommation,
- apprentissage profond dans l’output, pas dans la lecture passive.

### E. Friction utile / Generation Effect
- l’effort n’est pas un bug, c’est le signal du câblage.

### F. IA comme sparring-partner
- l’IA doit poser les questions critiques,
- pointer les suppositions cachées,
- produire du contre-argument,
- pas juste résumer.

### G. Consolidation biologique
- cycles de focus / repos,
- micro-pauses,
- NSDR,
- répétition espacée,
- replay neuronal.

### H. Pyramide 3A / ACE / OCEAN
- réponse d’abord,
- feedback structuré,
- output original, concret, évident, assertif, narratif.

---

## 1.2 Conséquence produit

Ces principes doivent se refléter dans :
- les providers,
- les objets noyau,
- les messages RCL,
- les policies d’orchestration,
- les critères de preuve,
- les routines de rétention,
- les simulations,
- les vues manager.

Sinon SCYForge dira “nous croyons à la maîtrise”, mais son moteur réel continuera d’optimiser de la consommation de contenu.

---

# 2. Nouvelles primitives conceptuelles à introduire dans le backlog

## 2.1 `LearningIntentFrame`
Inspiré de ACTOR / AIM.

```ts
interface LearningIntentFrame {
  missionStatement: string;
  targetAction: string;
  targetDecision?: string;
  targetProblem?: string;
  shadowMission?: string;
  strategicQuestions: string[];
}
```

### Pourquoi
Parce qu’un objectif ASCENT ne doit pas être seulement un but vague.
Il doit porter une **mission d’extraction et d’action**.

---

## 2.2 `SemanticTreeProfile`
Inspiré de l’Arbre Sémantique.

```ts
interface SemanticTreeProfile {
  trunkRefIds: string[];
  branchRefIds: string[];
  leafRefIds: string[];
  essentialTwentyPercentRefIds: string[];
  unresolvedTrunkGaps: string[];
}
```

### Pourquoi
Parce que le moteur doit distinguer :
- les fondations,
- les structures intermédiaires,
- les détails.

Sinon il traite toute information comme équivalente.

---

## 2.3 `OutputPressurePolicy`
Inspiré du ratio input/output.

```ts
interface OutputPressurePolicy {
  minOutputToInputRatio: number;
  forceTeachbackAfterRead: boolean;
  forceApplicationAfterConcept: boolean;
  allowPassiveConsumptionOnlyWhen: string[];
}
```

### Pourquoi
Parce que SCYForge ne doit pas laisser un apprenant “consommer proprement” tout en croyant qu’il progresse.

---

## 2.4 `CognitiveFrictionPolicy`
Inspiré du Generation Effect.

```ts
interface CognitiveFrictionPolicy {
  desiredDifficultyBand: 'low' | 'moderate' | 'high';
  triggerRecallBeforeReveal: boolean;
  triggerCounterArgument: boolean;
  prohibitImmediateAnsweringInCertainModes: boolean;
}
```

### Pourquoi
Pour empêcher que le produit réduise toute friction alors que certaines frictions sont précisément le moteur de la maîtrise.

---

## 2.5 `ConsolidationWindowPolicy`
Inspiré des cycles ultradiens et de la consolidation.

```ts
interface ConsolidationWindowPolicy {
  focusMinutes: number;
  recoveryMinutes: number;
  microPauseSeconds: number;
  triggerNSDRSuggestion: boolean;
  spacedReviewOffsets: string[];
}
```

---

# 3. Impacts sur RCL — nouveaux packet types à ajouter

## 3.1 `goal.intent_frame.v1`
À émettre par GOAL-INTERPRETER.

### Rôle
Transporter la mission explicite de l’apprenant.

### Utilité
Empêche le système de réduire le but à un simple titre de roadmap.

---

## 3.2 `graph.semantic_tree_profile.v1`
À émettre par DAG-ARCHITECT.

### Rôle
Dire explicitement quels nœuds sont :
- tronc,
- branches,
- feuilles.

### Utilité
Permet à CONDUCTOR, BRAIN et APEX de traiter les fondations différemment des détails.

---

## 3.3 `brain.counter_argument_request.v1`
À émettre par BRAIN ou LEARNING-CONDUCTOR.

### Rôle
Déclencher le mode sparring.

### Utilité
Faire vivre “Test” et non seulement “Explain”.

---

## 3.4 `proof.output_pressure_signal.v1`
À émettre par PERFORMANCE-ANALYZER.

### Rôle
Détecter qu’il y a trop d’input et pas assez d’output.

### Utilité
Empêcher l’illusion de progression.

---

## 3.5 `retention.consolidation_window.v1`
À émettre par APEX / DRIFT / CONDUCTOR.

### Rôle
Piloter les bons moments de pause, de refresh et de récupération.

---

# 4. Backlog technique par lot

---

# LOT A — Fondations RCL enrichies par les acquis cognitifs

## Ticket A1 — Étendre `GoalSpec` avec l’intention d’usage

### À faire
Ajouter une structure `LearningIntentFrame` dans ou à côté de `GoalSpec`.

### Justification
Un goal sans mission est trop passif et trop flou.
ACTOR exige une visée.

### Critère de done
- tout nouveau goal peut embarquer `missionStatement`,
- les strategic questions peuvent être persistées,
- la shadow mission existe comme champ.

---

## Ticket A2 — Étendre `MasteryNode` avec la place dans l’arbre sémantique

### À faire
Ajouter un champ du type :
- `semantic_role: trunk | branch | leaf`

### Justification
Le moteur doit savoir ce qui est structurel.

### Critère de done
- chaque `MasteryNode` peut être classé,
- les nœuds trunk reçoivent une criticité pédagogique spécifique.

---

## Ticket A3 — Introduire `SemanticTreeProfile`

### À faire
Créer un objet global de profil sémantique au niveau d’un graph ou d’un goal.

### Justification
Il faut pouvoir piloter 80/20, sequencing et rétention à partir d’une structure explicite.

### Critère de done
- le profil est généré au moins pour les goals cyber,
- le DAG peut l’exposer via RCL.

---

# LOT B — Messages RCL nouveaux / étendus

## Ticket B1 — Ajouter `goal.intent_frame.v1`

### Émetteur
GOAL-INTERPRETER

### Récepteurs
DAG-ARCHITECT, CONTENT-SCOUT, BRAIN

### Contenu
- mission statement,
- shadow mission,
- questions stratégiques.

### Critère de done
- le packet existe,
- il est loggué,
- il influence au moins un downstream behavior.

---

## Ticket B2 — Ajouter `graph.semantic_tree_profile.v1`

### Émetteur
DAG-ARCHITECT

### Récepteurs
LEARNING-CONDUCTOR, APEX, BRAIN, COSMOS

### Critère de done
- trunk / branch / leaf circulent dans RCL,
- le conductor et la rétention les utilisent.

---

## Ticket B3 — Ajouter `proof.output_pressure_signal.v1`

### Émetteur
PERFORMANCE-ANALYZER

### But
Signaler qu’un apprenant lit trop et produit trop peu.

### Critère de done
- calcul minimal du ratio input/output,
- déclenchement de teach-back ou d’application.

---

## Ticket B4 — Ajouter `brain.counter_argument_request.v1`

### Émetteur
LEARNING-CONDUCTOR ou BRAIN

### But
Passer BRAIN du mode assistant au mode adversaire utile.

### Critère de done
- un mode sparring existe,
- un contre-argument peut être demandé automatiquement.

---

## Ticket B5 — Ajouter `retention.consolidation_window.v1`

### Émetteur
APEX / CONDUCTOR

### But
Faire entrer la biologie de la consolidation dans le runtime.

### Critère de done
- focus block,
- micro-pause,
- recovery recommendation,
- spaced refresh offsets.

---

# LOT C — Refactor agent par agent influencé par les acquis du jour

## Ticket C1 — GOAL-INTERPRETER doit produire une mission, pas seulement un titre

### Nouveau comportement attendu
Le goal compiler doit générer :
- une mission explicite,
- une shadow mission,
- 3 questions de cadrage.

### Inspiration directe
ACTOR + AIM.

---

## Ticket C2 — DAG-ARCHITECT doit distinguer tronc / branches / feuilles

### Nouveau comportement attendu
Le graphe produit doit avoir une stratification cognitive.

### Inspiration directe
Arbre sémantique.

---

## Ticket C3 — LEARNING-CONDUCTOR doit imposer du output

### Nouveau comportement attendu
Après certains blocs de lecture, il doit exiger :
- teach-back,
- analogie personnelle,
- mini décision,
- mini application.

### Inspiration directe
ratio output > input, Own, Run.

---

## Ticket C4 — BRAIN doit avoir un mode “sparring partner” natif

### Nouveau comportement attendu
BRAIN doit savoir :
- attaquer un raisonnement,
- relever les suppositions cachées,
- demander la thèse inverse,
- produire la meilleure contre-évidence.

### Inspiration directe
IA comme adversaire utile.

---

## Ticket C5 — PERFORMANCE-ANALYZER doit mesurer l’illusion de compétence

### Nouveau comportement attendu
Détecter :
- consommation sans restitution,
- familiarité sans preuve,
- confiance déclarée > performance réelle.

### Inspiration directe
illusion de fluidité, testing sandwich, teach to learn.

---

## Ticket C6 — APEX / IMPRINT doivent protéger le tronc avant les feuilles

### Nouveau comportement attendu
- réviser les trunk concepts plus tôt,
- protéger les discriminations structurantes,
- prioriser les nœuds fondationnels.

### Inspiration directe
Arbre sémantique + répétition espacée.

---

## Ticket C7 — DRIFT-GUARDIAN doit reconnaître la fatigue de consolidation

### Nouveau comportement attendu
Différencier :
- paresse,
- surcharge,
- besoin de repos,
- oubli réel,
- effondrement du tronc.

### Inspiration directe
cycles ultradiens, NSDR, myélinisation, cadenas de l’amygdale.

---

# LOT D — Policies nouvelles à créer

## Ticket D1 — `OutputPressurePolicy`

### But
Définir à partir de quand la passivité devient interdite.

### Exemple
- après 12 minutes de lecture active,
- forcer un recall,
- après 1 concept trunk, forcer une restitution.

---

## Ticket D2 — `CognitiveFrictionPolicy`

### But
Éviter que le moteur “lisse” trop l’apprentissage.

### Exemple
- ne pas révéler immédiatement une réponse,
- faire générer une hypothèse,
- demander la thèse inverse avant l’explication finale.

---

## Ticket D3 — `ConsolidationWindowPolicy`

### But
Piloter focus / pauses / récupération / répétition.

### Exemple
- 90 min / 20 min,
- micro-pause 10–20 sec,
- refresh J+1h, J+24h, J+1w, J+1m.

---

# LOT E — Shadow trace enrichie pédagogiquement

## Ticket E1 — tracer si un cycle ACTOR a été respecté

### À logger
- mission définie ?
- trunk identifié ?
- contradiction testée ?
- restitution produite ?
- action / décision générée ?

## Ticket E2 — tracer le ratio input/output

### À logger
- temps lecture,
- temps production,
- nombre d’outputs cognitifs utiles,
- ratio final.

## Ticket E3 — tracer les moments de consolidation recommandés

### À logger
- pause suggérée,
- pause effectuée,
- review programmée,
- effet sur rétention ultérieure.

---

# 5. MVP backlog recommandé

## MVP RCL + acquis cognitifs
Je recommande de ne pas tout faire d’un coup.

### MVP-1
- `LearningIntentFrame`
- `goal.intent_frame.v1`
- `SemanticTreeProfile`
- `graph.semantic_tree_profile.v1`

### MVP-2
- `OutputPressurePolicy`
- `proof.output_pressure_signal.v1`
- teach-back obligatoire sur certains nœuds trunk

### MVP-3
- `brain.counter_argument_request.v1`
- mode sparring de BRAIN

### MVP-4
- `ConsolidationWindowPolicy`
- `retention.consolidation_window.v1`

---

# 6. Tests à écrire absolument

## Test 1
Un goal sans mission explicite est enrichi automatiquement.

## Test 2
Le DAG classe correctement trunk / branch / leaf.

## Test 3
Une séquence trop passive déclenche `proof.output_pressure_signal.v1`.

## Test 4
BRAIN peut passer en mode contre-argument sur demande système.

## Test 5
Un nœud trunk oublié remonte au-dessus d’un détail leaf mieux noté.

## Test 6
Une session longue peut générer une recommandation de consolidation et non seulement plus d’input.

---

# 7. KPIs supplémentaires à suivre

En plus des KPIs RCL classiques, suivre :
- ratio input/output moyen par workflow,
- part des nœuds trunk réellement maîtrisés,
- temps jusqu’à première restitution active,
- taux de teach-back réussi,
- nombre de contre-arguments générés,
- taux de correction d’illusion de compétence,
- effet des pauses / consolidations sur la rétention réelle.

---

# 8. Décision produit forte à prendre

SCYForge doit choisir explicitement ceci :

> est-ce que le produit optimise la consommation fluide,
> ou est-ce qu’il optimise la transformation réelle du cerveau et du jugement ?

Les documents d’aujourd’hui imposent une réponse claire :

> SCYForge doit optimiser la transformation réelle, même si cela implique parfois plus de friction utile.

Cette décision doit vivre :
- dans les messages,
- dans les policies,
- dans les critères de progression,
- dans les verdicts.

---

# 9. Verdict final

En prenant en compte les acquis d’aujourd’hui, RCL ne doit pas être seulement un protocole de communication technique.

Il doit devenir :

> **le système nerveux d’un moteur d’apprentissage radical**, où chaque message transporte non seulement de l’état logiciel, mais aussi une philosophie de maîtrise :
- mission,
- structure,
- contradiction,
- restitution,
- action,
- consolidation.

C’est cette couche-là qui différenciera réellement SCYForge d’un outil d’orchestration agentique banal.

---

# 10. Prochaine étape recommandée

Le meilleur document suivant maintenant serait :

## `SCYFORGE_COGNITIVE_RUNTIME_POLICIES.md`

Pour formaliser précisément :
- `OutputPressurePolicy`
- `CognitiveFrictionPolicy`
- `ConsolidationWindowPolicy`
- `SparringPolicy`
- `SemanticTreePriorityPolicy`

C’est la pièce qui permettra de transformer les acquis cognitifs en règles runtime du produit.

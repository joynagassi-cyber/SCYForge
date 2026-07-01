# SCYForge — Cognitive Runtime Policies
## Transformer les acquis cognitifs en règles runtime du produit

## But du document

Ce document formalise les **policies runtime cognitives** qui doivent gouverner SCYForge.

Le backlog RCL a déjà introduit les objets, packets et tickets nécessaires.
Ici, on définit la couche plus profonde :

> **les règles comportementales du moteur**

Autrement dit :
- quand le système doit laisser avancer,
- quand il doit ralentir,
- quand il doit forcer la restitution,
- quand il doit générer de la friction utile,
- quand il doit protéger le tronc sémantique,
- quand il doit recommander consolidation ou repos,
- quand l’IA doit être coach, professeur, contradicteur ou évaluateur.

Ce document transforme donc les acquis d’aujourd’hui en **système de gouvernance cognitive du runtime**.

---

# 1. Thèse centrale

Le problème de la plupart des produits d’apprentissage assistés par IA est qu’ils optimisent :
- la fluidité,
- la satisfaction immédiate,
- la vitesse perçue,
- la densité de contenu,
- la réduction de friction.

SCYForge ne doit pas optimiser cela en premier.

SCYForge doit optimiser :
- la structuration,
- la récupération active,
- la consolidation,
- le jugement,
- la preuve,
- l’autonomie.

Donc le runtime doit être gouverné par une règle simple :

> **ce qui semble plus agréable n’est pas forcément ce qui produit la maîtrise.**

Le moteur doit parfois protéger l’apprenant contre sa préférence pour la passivité.

---

# 2. Les 5 policies runtime fondamentales

Je recommande de formaliser au moins 5 policies noyau.

1. `OutputPressurePolicy`
2. `CognitiveFrictionPolicy`
3. `ConsolidationWindowPolicy`
4. `SparringPolicy`
5. `SemanticTreePriorityPolicy`

Ces 5 policies doivent être consommées au minimum par :
- LEARNING-CONDUCTOR
- PERFORMANCE-ANALYZER
- ADAPTIVE-ROUTER
- BRAIN
- APEX / IMPRINT / DRIFT-GUARDIAN

---

# 3. OutputPressurePolicy

## 3.1 Intuition

L’apprentissage profond n’a pas lieu dans la simple exposition.
Il a lieu dans la **production** :
- reformulation,
- explication,
- application,
- décision,
- contre-argument,
- enseignement.

Donc le runtime doit surveiller un phénomène dangereux :

> **l’accumulation d’input sans output suffisant**.

---

## 3.2 Objet recommandé

```ts
export interface OutputPressurePolicy {
  minOutputToInputRatio: number;
  maxPassiveConsumptionMinutes: number;
  forceRecallAfterContentBlock: boolean;
  forceTeachbackAfterTrunkNode: boolean;
  forceApplicationAfterDecisionNode: boolean;
  allowedPassiveModes: Array<'preview' | 'orientation' | 'first_contact'>;
  escalationIfPassiveOverrun: 'recall_prompt' | 'teachback' | 'micro_quiz' | 'scenario_light';
}
```

---

## 3.3 Règles recommandées

### Règle O1 — plafond de passivité
Au-delà d’un certain temps de consommation passive, le moteur doit interrompre le flux.

### Règle O2 — output obligatoire après tronc
Tout nœud `semantic_role = trunk` doit être suivi d’une restitution ou d’une reformulation.

### Règle O3 — application obligatoire après décision
Tout nœud de type `decision` ou `procedure` doit déclencher une mini mise en situation ou une micro-décision.

### Règle O4 — le système ne doit pas récompenser la lecture seule
La progression visible ne doit pas reposer uniquement sur le temps ou le défilement.

---

## 3.4 Déclencheurs runtime

### Trigger 1
`passive_minutes > maxPassiveConsumptionMinutes`
→ déclencher `proof.output_pressure_signal.v1`

### Trigger 2
`trunk_node_read = true && no_output_generated`
→ déclencher teach-back ou rappel forcé

### Trigger 3
`high_familiarity_confidence && weak_recall_evidence`
→ bloquer l’avancement tant qu’un output n’est pas généré

---

## 3.5 Effets concrets côté produit

- fermer temporairement le mode lecture continue,
- afficher une carte “explique-le avec tes mots”,
- demander une analogie,
- proposer une mini décision,
- faire verbaliser le tronc avant d’ouvrir les feuilles.

---

# 4. CognitiveFrictionPolicy

## 4.1 Intuition

Toute friction n’est pas mauvaise.
Certaines frictions sont **desirable difficulties** :
elles augmentent la rétention, la structuration et la profondeur du jugement.

SCYForge doit donc distinguer :
- friction parasite,
- friction utile.

---

## 4.2 Objet recommandé

```ts
export interface CognitiveFrictionPolicy {
  desiredDifficultyBand: 'low' | 'moderate' | 'high';
  triggerRecallBeforeReveal: boolean;
  triggerCounterArgument: boolean;
  triggerDelayBeforeAnswerReveal: boolean;
  allowImmediateExplanationWhen: string[];
  confusionToleranceBand: number;
  antiIllusionMode: boolean;
}
```

---

## 4.3 Règles recommandées

### Règle F1 — recall avant révélation
Quand un concept important a déjà été vu, le système doit d’abord tenter une récupération avant de remontrer la réponse.

### Règle F2 — contradiction avant confort
Quand un apprenant semble trop sûr trop tôt, le moteur doit injecter une contradiction, une nuance ou un contre-cas.

### Règle F3 — difficulté calibrée, pas sadique
La friction doit rester dans une bande supportable.
Le but n’est pas d’écraser, mais de provoquer du recâblage.

### Règle F4 — ne pas expliquer trop tôt
Révéler immédiatement la bonne réponse peut tuer l’apprentissage.

---

## 4.4 Déclencheurs runtime

### Trigger 1
`same_concept_seen_before && confidence_high && recall_not_tested`
→ mini recall obligatoire

### Trigger 2
`learner_answer_confidence >> real_score`
→ activer `antiIllusionMode`

### Trigger 3
`consecutive_correct_easy_patterns`
→ injecter un cas ambigu, contradictoire ou faux positif

---

## 4.5 Effets concrets côté produit

- cacher la solution avant tentative,
- poser une question de transfert,
- demander la thèse inverse,
- injecter un faux positif réaliste,
- obliger à justifier une décision.

---

# 5. ConsolidationWindowPolicy

## 5.1 Intuition

Le système ne doit pas traiter l’apprentissage comme un flux continu illimité.
Il doit gérer :
- focus,
- récupération,
- replay neuronal,
- répétition espacée,
- repos profond.

---

## 5.2 Objet recommandé

```ts
export interface ConsolidationWindowPolicy {
  focusMinutes: number;
  recoveryMinutes: number;
  microPauseSeconds: number;
  recommendNSDR: boolean;
  spacedReviewOffsets: string[];
  triggerPauseAfterComplexityBand: 'low' | 'moderate' | 'high';
  triggerRecoveryIfSignals: string[];
}
```

---

## 5.3 Règles recommandées

### Règle C1 — pas de marathon cognitif non borné
Une session ne doit pas accumuler des blocs intenses sans respirations structurées.

### Règle C2 — micro-pauses après bloc dense
Après un bloc particulièrement complexe, déclencher une mini pause ou une suspension active.

### Règle C3 — la révision doit être temporellement intelligente
Le système doit planifier des retours selon criticité, oubli probable et type de compétence.

### Règle C4 — consolidation > ajout de nouveaux inputs
Quand les signaux de saturation montent, le système doit privilégier stabilisation plutôt qu’empilement.

---

## 5.4 Déclencheurs runtime

### Trigger 1
`high_complexity_block_completed`
→ suggérer micro-pause ou recap actif

### Trigger 2
`session_duration > focusMinutes`
→ proposer recovery / NSDR / bascule en review légère

### Trigger 3
`retention_risk_high && trunk_node`
→ programmer spaced refresh prioritaire

### Trigger 4
`emotional_load_high || repeated_failures || fatigue_signals`
→ couper le flux de nouveauté et passer en mode consolidation

---

## 5.5 Effets concrets côté produit

- proposer une pause guidée,
- repousser un nouveau nœud,
- passer en mode réactivation,
- recommander NSDR,
- ajuster la densité de session.

---

# 6. SparringPolicy

## 6.1 Intuition

L’IA dans SCYForge ne doit pas être seulement :
- explicative,
- rassurante,
- résumante.

Elle doit aussi être :
- contradictrice,
- révélatrice d’angles morts,
- génératrice de contre-évidence,
- stress-testeuse de raisonnement.

---

## 6.2 Objet recommandé

```ts
export interface SparringPolicy {
  enabled: boolean;
  autoTriggerOnOverconfidence: boolean;
  autoTriggerOnDecisionNode: boolean;
  forceCounterArgumentBeforeCertification: boolean;
  preferredSparringMode: 'counter_argument' | 'hidden_assumption' | 'reverse_thesis' | 'edge_case';
  maxSparringTurns: number;
}
```

---

## 6.3 Règles recommandées

### Règle S1 — contradiction avant certification forte
Avant d’accorder une readiness importante, le système doit au moins avoir testé la résistance du raisonnement sur un contre-cas ou une objection sérieuse.

### Règle S2 — angles morts obligatoires sur décision
Les nœuds décisionnels doivent presque toujours rencontrer un mode sparring.

### Règle S3 — l’IA ne doit pas flatter trop vite
En mode sparring, elle ne doit pas conforter ; elle doit forcer la clarification.

---

## 6.4 Déclencheurs runtime

### Trigger 1
`decision_node && evidence_depth_low`
→ lancer contre-argument ou thèse inverse

### Trigger 2
`self_reported_confidence_high && metacognition_gap_high`
→ mode hidden assumption

### Trigger 3
`pre_certification_state`
→ injecter edge case ou objection forte

---

## 6.5 Effets concrets côté produit

- demander “quelle croyance protèges-tu ?”,
- exiger trois arguments de la thèse inverse,
- injecter un faux positif ou cas limite,
- tester une justification sous contrainte.

---

# 7. SemanticTreePriorityPolicy

## 7.1 Intuition

C’est probablement la policy la plus structurante pour SCYForge.

Si le système ne sait pas distinguer :
- le tronc,
- les branches,
- les feuilles,

alors il ne peut pas aider un apprenant à construire une architecture durable de connaissance.

Et surtout, il ne peut pas faire de SCYForge un système qui **accumule les nouveaux acquis d’entreprise dans une structure cognitive vivante**.

---

## 7.2 Objet recommandé

```ts
export interface SemanticTreePriorityPolicy {
  forceTrunkBeforeLeaves: boolean;
  minimumTrunkMasteryScore: number;
  leafAccessRequiresTrunkStability: boolean;
  prioritizeBranchIntegrationBeforeLeafExpansion: boolean;
  trunkRefreshPriorityBoost: number;
  treeGapEscalationMode: 'block' | 'warn' | 'reroute';
}
```

---

## 7.3 Règles recommandées

### Règle T1 — pas de feuilles sans tronc
Un apprenant ne doit pas s’enfoncer dans les détails si les fondations sont encore instables.

### Règle T2 — les branches servent de ponts d’intégration
Le système doit favoriser les liens structurants avant les anecdotes ou détails.

### Règle T3 — un oubli du tronc est beaucoup plus grave qu’un oubli de feuille
La criticité pédagogique du tronc doit être supérieure.

### Règle T4 — les nouveaux acquis entreprise doivent être rattachés à un arbre existant
On n’ajoute pas des savoirs comme des documents flottants.
On les ajoute comme :
- nouveau tronc,
- nouvelle branche,
- nouvelle feuille,
- ou modification d’une branche existante.

---

## 7.4 Déclencheurs runtime

### Trigger 1
`trunk_mastery < minimumTrunkMasteryScore`
→ bloquer ou limiter l’exploration des feuilles

### Trigger 2
`new_corpus_ingested`
→ forcer classification sémantique trunk / branch / leaf

### Trigger 3
`leaf_density_high && trunk_gaps_present`
→ reroute vers nœuds fondationnels

### Trigger 4
`company_knowledge_update_detected`
→ lancer workflow d’intégration dans l’arbre sémantique existant

---

## 7.5 Effets concrets côté produit

- gating de progression,
- rerouting vers fondations,
- réindexation des nouveaux savoirs d’entreprise,
- priorisation de refresh du tronc,
- visualisation de l’architecture cognitive évolutive.

---

# 8. Policy interactions

Les policies ne doivent pas vivre isolément.

## Interaction 1
`SemanticTreePriorityPolicy` + `OutputPressurePolicy`

### Effet
Le système force plus d’output sur les nœuds trunk que sur les feuilles.

## Interaction 2
`CognitiveFrictionPolicy` + `SparringPolicy`

### Effet
Les nœuds décisionnels critiques reçoivent des contre-cas et contradictions avant validation.

## Interaction 3
`ConsolidationWindowPolicy` + `SemanticTreePriorityPolicy`

### Effet
Le tronc est revu plus souvent, avec priorité haute en spaced review.

## Interaction 4
`OutputPressurePolicy` + `ConsolidationWindowPolicy`

### Effet
Après un bloc d’output intense, le système propose stabilisation et récupération plutôt qu’un nouveau bombardement d’input.

---

# 9. Consumption matrix par agent

| Agent | Policies consommées en priorité |
|---|---|
| GOAL-INTERPRETER | OutputPressure, SemanticTreePriority |
| CONTENT-SCOUT | SemanticTreePriority |
| DAG-ARCHITECT | SemanticTreePriority, OutputPressure |
| LEARNING-CONDUCTOR | toutes |
| PERFORMANCE-ANALYZER | OutputPressure, Sparring, SemanticTreePriority |
| ADAPTIVE-ROUTER | OutputPressure, Consolidation, SemanticTreePriority |
| DRIFT-GUARDIAN | Consolidation, SemanticTreePriority |
| BRAIN | CognitiveFriction, Sparring, OutputPressure |
| APEX / IMPRINT | Consolidation, SemanticTreePriority |
| SKILL-CERTIFIER | Sparring, SemanticTreePriority, OutputPressure |
| ARENA | Sparring, CognitiveFriction, OutputPressure |

---

# 10. KPIs par policy

## OutputPressure
- ratio input/output,
- temps jusqu’à première restitution,
- progression après output forcé.

## CognitiveFriction
- taux de rappel avant révélation,
- taux de réussite après friction,
- détection d’illusion de compétence corrigée.

## ConsolidationWindow
- adherence aux pauses,
- performances post-consolidation,
- rétention à J+1 / J+7 / J+30.

## Sparring
- nombre de contre-arguments générés,
- amélioration du raisonnement après contradiction,
- baisse des erreurs éliminatoires.

## SemanticTreePriority
- taux de stabilité du tronc,
- ratio trunk/branch/leaf maîtrisé,
- temps d’intégration des nouveaux savoirs entreprise dans l’arbre.

---

# 11. Décision structurante pour la suite

Ce document prépare directement la prochaine profondeur sur le **Semantic Tree**.

Pourquoi ?
Parce que la `SemanticTreePriorityPolicy` commence déjà à traiter le savoir d’entreprise comme :
- une structure cognitive vivante,
- extensible,
- cumulative,
- reclassifiable,
- et non comme une pile documentaire.

C’est exactement là que SCYForge peut devenir radicalement différent.

---

# 12. Verdict final

Les runtime policies sont la traduction opérationnelle de ta philosophie d’apprentissage.

Sans elles, SCYForge resterait :
- un bon assemblage d’agents,
- avec de bons documents,
- mais sans volonté cognitive interne stable.

Avec elles, SCYForge peut devenir :

> **un système qui gouverne activement la transformation du savoir en architecture mentale, puis l’entretien de cette architecture à mesure que l’entreprise évolue.**

Et c’est précisément ce qui ouvre la porte au prochain chantier majeur :

> **approfondir le Semantic Tree comme principe d’apprentissage, d’accumulation de savoir d’entreprise et de différenciation infrastructurelle de SCYForge.**

---

# 13. Prochaine étape recommandée

Le meilleur document suivant est maintenant :

## `SCYFORGE_SEMANTIC_TREE_INFRASTRUCTURE.md`

Pour répondre en profondeur à :
- comment SCYForge aide un apprenant à construire un arbre sémantique mental vivant,
- comment les nouveaux acquis entreprise s’y greffent dans le temps,
- comment appliquer le Semantic Tree à tout le système,
- et pourquoi cela devient le facteur différenciant infrastructurel de SCYForge.

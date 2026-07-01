# SCYForge — RCL Message Catalog
## Catalogue opératoire des messages de la Recursive Communication Layer

## But du document

Ce document transforme le protocole RCL en catalogue exécutable.

Le fichier `SCYFORGE_RCL_PROTOCOL_SPEC.md` définit :
- les principes,
- les modes,
- les objets généraux,
- les invariants.

Ce fichier-ci définit :
- **qui émet quoi**,
- **vers qui**,
- **avec quel schéma de payload**,
- **dans quel mode**,
- **avec quelles règles d’escalade**,
- **et quelles métriques logger**.

Autrement dit :

> `RCL_PROTOCOL_SPEC` = la constitution
> `RCL_MESSAGE_CATALOG` = le manuel de circulation

---

# 1. Convention de nommage

## Format recommandé

```text
<domain_of_work>.<intent>.<version>
```

### Exemples
- `goal.resolution.v1`
- `content.coverage_map.v1`
- `graph.mastery_delta.v1`
- `proof.gap_vector.v1`
- `scenario.eligibility.v1`
- `verdict.blockers.v1`

---

# 2. Champs communs minimaux

Tous les messages RCL doivent embarquer :

```ts
interface BaseRclMessage {
  packetId: string;
  workflowId: string;
  round: number;
  senderAgent: string;
  receiverAgent: string;
  packetMode: 'text_trace' | 'structured_compact' | 'recursive_state';
  packetType: string;
  domainId: string;
  tenantId: string;
  goalId?: string;
  learnerId?: string;
  nodeIds?: string[];
  scenarioId?: string;
  domainRefIds?: string[];
  confidence?: number;
  uncertaintyFlags?: string[];
  requestedAction?: string;
  traceRefs?: string[];
  createdAt: string;
}
```

---

# 3. Catalogue par agent

---

# 3.1 GOAL-INTERPRETER

## Mission RCL
Transformer un intent brut en résolution de rôle, niveau, contraintes et refs domaine candidates.

## Émetteurs principaux
- `GOAL-INTERPRETER`

## Récepteurs principaux
- `DAG-ARCHITECT`
- `CONTENT-SCOUT`
- `COGNITIVE-VALIDATOR`

---

## Message 1 — `goal.resolution.v1`

### Mode recommandé
- `structured_compact`

### Émis quand
- un nouvel objectif est compilé,
- un objectif ambigu a été partiellement résolu,
- un changement de rôle cible est détecté.

### Payload schema

```ts
interface GoalResolutionPayload {
  rawIntent: string;
  normalizedTitle: string;
  resolvedRoleIds: string[];
  targetLevel: 'aware' | 'apply' | 'master';
  resolvedDomainRefIds: string[];
  constraints: string[];
  unresolvedAmbiguities: string[];
  expectedProofAreas: string[];
}
```

### Escalade vers `text_trace`
- si `unresolvedAmbiguities.length > 0` et impacte rôle ou niveau,
- si `confidence < 0.60`,
- si plusieurs rôles incompatibles restent ouverts.

### Métriques à logger
- temps de résolution,
- nombre d’ambiguïtés résiduelles,
- taux de révision ultérieure du goal,
- confiance moyenne par catégorie d’objectif.

---

## Message 2 — `goal.scope_warning.v1`

### Mode recommandé
- `text_trace`

### Émis quand
- l’objectif est trop vaste,
- les prérequis sont très insuffisants,
- le rôle cible est mal spécifié.

### Payload schema

```ts
interface GoalScopeWarningPayload {
  warningType: 'too_broad' | 'missing_prerequisites' | 'role_ambiguity' | 'unsafe_scope';
  message: string;
  suggestedSplits: string[];
  recommendedNextStep: string;
}
```

### Métriques à logger
- fréquence par type de warning,
- taux d’acceptation des splits suggérés.

---

# 3.2 CONTENT-SCOUT

## Mission RCL
Exprimer la couverture réelle du corpus par rapport aux besoins de maîtrise.

## Récepteurs principaux
- `DAG-ARCHITECT`
- `LEARNING-CONDUCTOR`
- `VISUAL-CRITIC`

---

## Message 1 — `content.coverage_map.v1`

### Mode recommandé
- `structured_compact`

### Émis quand
- la collecte initiale est terminée,
- un enrichissement de corpus a été fait,
- une remédiation contenu est demandée.

### Payload schema

```ts
interface CoverageMapPayload {
  sourceSummaries: Array<{
    sourceId: string;
    trustTier: 'gold' | 'silver' | 'bronze' | 'rejected';
    authorityScore: number;
  }>;
  coveredDomainRefIds: string[];
  uncoveredDomainRefIds: string[];
  coverageByRef: Record<string, number>;
  highRiskSourceIds: string[];
  notes?: string[];
}
```

### Escalade vers `text_trace`
- si des sources high-risk couvrent des zones critiques,
- si la couverture de refs critiques est sous seuil,
- si contradiction forte entre sources.

### Métriques à logger
- couverture moyenne des refs critiques,
- ratio Gold/Silver/Bronze,
- nombre de gaps critiques,
- coût token ou latence par collecte.

---

## Message 2 — `content.gap_alert.v1`

### Mode recommandé
- `text_trace`

### Émis quand
- la couverture ne permet pas de produire un graphe ou un scénario crédible.

### Payload schema

```ts
interface ContentGapAlertPayload {
  missingAreas: string[];
  criticality: 'low' | 'medium' | 'high' | 'blocking';
  affectedGoalOrNodeIds: string[];
  recommendation: string;
}
```

---

# 3.3 DAG-ARCHITECT

## Mission RCL
Transmettre l’évolution du graphe de maîtrise et ses raffinements.

## Récepteurs principaux
- `LEARNING-CONDUCTOR`
- `PERFORMANCE-ANALYZER`
- `COGNITIVE-VALIDATOR`
- `COSMOS`

---

## Message 1 — `graph.mastery_delta.v1`

### Mode recommandé
- `recursive_state`

### Émis quand
- de nouveaux `MasteryNode` sont générés,
- une passe de raffinement modifie prérequis / criticité / preuves.

### Payload schema

```ts
interface MasteryGraphDeltaPayload {
  addedNodeIds: string[];
  updatedNodeIds: string[];
  removedNodeIds: string[];
  changedDependencies: Array<{
    fromNodeId: string;
    toNodeId: string;
    changeType: 'added' | 'removed';
  }>;
  changedCriticalities: Record<string, 'low' | 'medium' | 'high' | 'mission_critical'>;
  unresolvedGraphIssues: string[];
}
```

### Escalade vers `text_trace`
- si `unresolvedGraphIssues` persistent au round final,
- si cycles, trous pédagogiques ou conflits de preuve apparaissent,
- si la criticité d’un nœud clé change fortement.

### Métriques à logger
- nombre de rounds avant convergence,
- nombre moyen de nœuds par goal,
- taux de révision du graphe après validation,
- taux de conflits détectés.

---

## Message 2 — `graph.proof_plan.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface GraphProofPlanPayload {
  nodeProofMap: Record<string, string[]>;
  scenarioRequiredNodeIds: string[];
  memoryOnlyNodeIds: string[];
  mixedEvidenceNodeIds: string[];
}
```

---

# 3.4 LEARNING-CONDUCTOR

## Mission RCL
Distribuer des décisions d’intervention précises.

## Récepteurs principaux
- `ADAPTIVE-ROUTER`
- `ARENA`
- `APEX`
- `BRAIN`
- `CHRONICLE`

---

## Message 1 — `intervention.proposal.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface InterventionProposalPayload {
  interventionType:
    | 'explain'
    | 'practice'
    | 'simulate'
    | 'review'
    | 'remediate'
    | 'certify';
  targetNodeIds: string[];
  targetScenarioIds?: string[];
  rationale: string;
  urgency: 'low' | 'medium' | 'high';
  blockingIfIgnored: boolean;
}
```

### Escalade vers `text_trace`
- si plusieurs interventions concurrentes sont plausibles,
- si l’intervention dépend d’un jugement sensible,
- si le système entre dans une zone de remédiation complexe.

### Métriques à logger
- taux d’acceptation des interventions,
- effet de l’intervention sur la progression réelle,
- délai entre proposition et exécution.

---

## Message 2 — `session.transition.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface SessionTransitionPayload {
  previousNodeId?: string;
  nextNodeId?: string;
  transitionType: 'unlock' | 'consolidate' | 'retry' | 'escalate_to_scenario';
  reasonCodes: string[];
}
```

---

# 3.5 PERFORMANCE-ANALYZER

## Mission RCL
Exprimer les preuves, les gaps et les mises à jour de maîtrise.

## Récepteurs principaux
- `ADAPTIVE-ROUTER`
- `SKILL-CERTIFIER`
- `LEARNING-CONDUCTOR`
- `DRIFT-GUARDIAN`

---

## Message 1 — `proof.gap_vector.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface ProofGapVectorPayload {
  nodeId?: string;
  missingEvidenceTypes: string[];
  weakRubricDimensions: Array<{
    dimensionId: string;
    score: number;
    threshold: number;
  }>;
  eliminationFlags: string[];
  remediationPriority: 'low' | 'medium' | 'high' | 'critical';
}
```

### Escalade vers `text_trace`
- si une règle éliminatoire est déclenchée,
- si le gap bloque une certification,
- si la confiance sur le diagnostic est trop faible.

### Métriques à logger
- distribution des gaps par dimension,
- fréquence des flags éliminatoires,
- temps moyen de fermeture d’un gap.

---

## Message 2 — `proof.mastery_update.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface MasteryUpdatePayload {
  nodeId: string;
  masteryState: 'insufficient' | 'developing' | 'operational' | 'autonomous';
  overallScore: number;
  dimensionScores: Record<string, number>;
  confidence: number;
}
```

---

# 3.6 ADAPTIVE-ROUTER

## Mission RCL
Exprimer les ajustements de trajectoire et demandes de remédiation.

## Récepteurs principaux
- `LEARNING-CONDUCTOR`
- `APEX`
- `BRAIN`
- `ARENA`

---

## Message 1 — `route.trajectory_adjustment.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface TrajectoryAdjustmentPayload {
  routeType: 'fast_track' | 'normal' | 'consolidation' | 'remediation' | 'hold';
  affectedNodeIds: string[];
  reasonCodes: string[];
  requiredActions: string[];
}
```

### Escalade vers `text_trace`
- si `routeType = hold` sur zone critique,
- si le routage entre en contradiction avec une policy précédente,
- si le système hésite entre consolidation et simulation.

### Métriques à logger
- fréquence des route types,
- efficacité de chaque route type,
- faux fast-tracks détectés a posteriori.

---

## Message 2 — `route.remediation_request.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface RemediationRequestPayload {
  nodeId: string;
  remediationType:
    | 'content_alt'
    | 'practice_alt'
    | 'review_intensive'
    | 'scenario_light'
    | 'explanation_reframe';
  targetWeaknesses: string[];
}
```

---

# 3.7 DRIFT-GUARDIAN

## Mission RCL
Exprimer le risque de dérive / érosion de maîtrise.

## Récepteurs principaux
- `LEARNING-CONDUCTOR`
- `ADAPTIVE-ROUTER`
- `CHRONICLE`
- `APEX`

---

## Message 1 — `drift.risk_signal.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface DriftRiskSignalPayload {
  signalType:
    | 'inactivity'
    | 'retention_drop'
    | 'procedural_regression'
    | 'overconfidence'
    | 'false_positive_pattern'
    | 'stagnation';
  severity: 'low' | 'medium' | 'high' | 'critical';
  affectedNodeIds: string[];
  rationaleCodes: string[];
  recommendedReaction: string;
}
```

### Escalade vers `text_trace`
- si `severity = critical`,
- si la dérive touche une compétence mission-critical,
- si plusieurs signaux convergent.

### Métriques à logger
- fréquence par signal type,
- taux de récupération après intervention,
- temps de détection avant échec visible.

---

## Message 2 — `drift.reactivation_priority.v1`

### Payload schema

```ts
interface ReactivationPriorityPayload {
  prioritizedNodeIds: string[];
  recommendedModality: 'cards' | 'scenario' | 'micro_case' | 'explanation';
  reason: string;
}
```

---

# 3.8 APEX / IMPRINT / FSRS

## Mission RCL
Exprimer les priorités de rétention et les activités de rafraîchissement.

## Récepteurs principaux
- `LEARNING-CONDUCTOR`
- `DRIFT-GUARDIAN`
- `ADAPTIVE-ROUTER`

---

## Message 1 — `retention.priority.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface RetentionPriorityPayload {
  prioritizedNodeIds: string[];
  refreshTypes: Array<{
    nodeId: string;
    refreshType: 'concept' | 'discrimination' | 'procedure' | 'decision';
    criticality: 'low' | 'medium' | 'high' | 'mission_critical';
  }>;
  dormancyRiskByNode: Record<string, number>;
}
```

### Métriques à logger
- oublis évités par priorité critique,
- performances post-refresh,
- ratio cartes factuelles vs refreshs décisionnels.

---

## Message 2 — `retention.imprint_trigger.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface ImprintTriggerPayload {
  nodeId: string;
  triggerReason: string;
  suggestedFormat: 'tree' | 'feynman' | 'mnemonic' | 'code_scribing';
}
```

---

# 3.9 BRAIN

## Mission RCL
Exprimer les besoins de clarification et les signaux de gap issus des échanges tutoriels.

## Récepteurs principaux
- `LEARNING-CONDUCTOR`
- `PERFORMANCE-ANALYZER`
- `CHRONICLE`

---

## Message 1 — `brain.clarification_signal.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface BrainClarificationSignalPayload {
  nodeId?: string;
  queriedRefIds: string[];
  confusionPattern: 'definition' | 'distinction' | 'procedure' | 'decision' | 'transfer';
  recurrenceCount: number;
  suggestedFollowUp: string;
}
```

### Escalade vers `text_trace`
- si la confusion concerne une procédure sensible,
- si la clarification manque de source,
- si la question révèle une contradiction de corpus.

### Métriques à logger
- questions par nœud,
- récurrence par type de confusion,
- effet des clarifications sur les preuves ultérieures.

---

## Message 2 — `brain.teachback_result.v1`

### Payload schema

```ts
interface BrainTeachbackResultPayload {
  nodeId: string;
  estimatedDepthScore: number;
  missingConcepts: string[];
  overconfidenceDetected: boolean;
}
```

---

# 3.10 SKILL-CERTIFIER

## Mission RCL
Exprimer les blocages de verdict et la readiness finale.

## Récepteurs principaux
- `LEARNING-CONDUCTOR`
- `CHRONICLE`
- frontière externe / audit

---

## Message 1 — `verdict.blockers.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface VerdictBlockersPayload {
  roleScopeIds: string[];
  blockedScope: string[];
  blockerTypes: Array<{
    type: 'missing_evidence' | 'elimination_rule' | 'missing_scenario' | 'low_confidence';
    detail: string;
  }>;
  recommendedRemediations: string[];
}
```

### Escalade vers `text_trace`
- toujours si le verdict final est refusé,
- toujours si une règle éliminatoire est la cause,
- toujours si revue humaine souhaitée.

### Métriques à logger
- taux de blocage par type,
- temps jusqu’à résolution,
- répartition par rôle et scope.

---

## Message 2 — `verdict.ready_signal.v1`

### Mode recommandé
- `structured_compact` puis `text_trace` dérivé

### Payload schema

```ts
interface VerdictReadySignalPayload {
  verdict: 'not_ready' | 'conditionally_ready' | 'operational' | 'autonomous';
  autonomyScope: string[];
  blockedScope: string[];
  confidence: number;
  evidenceRecordIds: string[];
}
```

---

# 3.11 CHRONICLE

## Mission RCL
Transformer les flux RCL en narration système et audit trail.

## Récepteurs principaux
- stockage / dashboards / manager views

---

## Message 1 — `trace.digest.v1`

### Mode recommandé
- `text_trace`

### Payload schema

```ts
interface TraceDigestPayload {
  workflowType: string;
  roundsCompleted: number;
  keyEvents: string[];
  blockers: string[];
  finalStateSummary: string;
}
```

### Métriques à logger
- temps de génération des digests,
- densité de trace,
- complétude audit par workflow.

---

# 3.12 ARENA

## Mission RCL
Exprimer l’éligibilité, la progression de scénario et les sorties de preuve.

## Récepteurs principaux
- `LEARNING-CONDUCTOR`
- `PERFORMANCE-ANALYZER`
- `SKILL-CERTIFIER`
- `CHRONICLE`

---

## Message 1 — `scenario.eligibility.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface ScenarioEligibilityPayload {
  eligibleScenarioIds: string[];
  blockedScenarioIds: Array<{
    scenarioId: string;
    reason: string;
  }>;
  minimumReadinessHints: string[];
}
```

### Escalade vers `text_trace`
- si tous les scénarios utiles sont bloqués,
- si les raisons de blocage sont conflictuelles,
- si l’agent tente d’ouvrir un scénario critique sans préconditions.

---

## Message 2 — `scenario.trace_delta.v1`

### Mode recommandé
- `recursive_state`

### Payload schema

```ts
interface ScenarioTraceDeltaPayload {
  scenarioId: string;
  decisionEvents: Array<{
    stepId: string;
    decisionType: string;
    outcomeTag: 'good' | 'weak' | 'dangerous' | 'eliminating';
  }>;
  unresolvedEvaluationAreas: string[];
}
```

---

## Message 3 — `scenario.proof_recorded.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface ScenarioProofRecordedPayload {
  scenarioId: string;
  proofRecordIds: string[];
  passedEliminationCheck: boolean;
  dominantWeaknesses: string[];
}
```

---

# 3.13 VISUAL-CRITIC

## Mission RCL
Exprimer l’intégrité structurelle d’un rendu.

## Récepteurs principaux
- `COSMOS`
- `COGNITIVE-VALIDATOR`
- `CHRONICLE`

---

## Message — `visual.validation_report.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface VisualValidationReportPayload {
  renderId: string;
  accepted: boolean;
  brokenConstraints: string[];
  affectedRefIds: string[];
}
```

---

# 3.14 COGNITIVE-VALIDATOR

## Mission RCL
Exprimer les ajustements cognitifs sûrs.

## Récepteurs principaux
- `LEARNING-CONDUCTOR`
- `COSMOS`
- `BRAIN`

---

## Message — `cognitive.adjustment.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface CognitiveAdjustmentPayload {
  targetNodeIds: string[];
  explanationDepth: 'brief' | 'standard' | 'deep';
  preserveTerms: string[];
  allowedSimplifications: string[];
}
```

---

# 3.15 COSMOS

## Mission RCL
Exprimer les changements de vue ou de cartographie.

## Récepteurs principaux
- UI / CHRONICLE / VISUAL-CRITIC

---

## Message — `cosmos.view_state.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface CosmosViewStatePayload {
  viewType: 'roadmap' | 'concept_map' | 'heatmap' | 'timeline' | 'scenario_map';
  boundObjectIds: string[];
  derivedFrom: 'mastery_graph' | 'ontology' | 'proof_state';
}
```

---

# 3.16 ENGAGEMENT-AMPLIFIER

## Mission RCL
Exprimer des nudges alignés avec la maîtrise réelle.

## Récepteurs principaux
- UI / CHRONICLE / LEARNING-CONDUCTOR

---

## Message — `engagement.nudge.v1`

### Mode recommandé
- `structured_compact`

### Payload schema

```ts
interface EngagementNudgePayload {
  nudgeType: 'celebration' | 'reminder' | 'milestone' | 'consistency_reinforcement';
  linkedProofEventIds: string[];
  linkedNodeIds: string[];
  urgency: 'low' | 'medium';
}
```

### Escalade vers `text_trace`
- rarement nécessaire,
- seulement si message humain complet requis.

---

# 4. Catalogue des workflows récursifs recommandés

## 4.1 `goal_to_graph_compilation`

### Agents impliqués
- GOAL-INTERPRETER
- CONTENT-SCOUT
- DAG-ARCHITECT
- COGNITIVE-VALIDATOR

### Messages dominants
- `goal.resolution.v1`
- `content.coverage_map.v1`
- `graph.mastery_delta.v1`

### Mode dominant
- `recursive_state`

### Max rounds recommandé
- 2 à 3

---

## 4.2 `scenario_blueprint_generation`

### Agents impliqués
- CONTENT-SCOUT
- DAG-ARCHITECT
- ARENA
- VALIDATION layer

### Messages dominants
- `content.coverage_map.v1`
- `graph.proof_plan.v1`
- `scenario.eligibility.v1`
- `scenario.trace_delta.v1`

### Max rounds recommandé
- 2

---

## 4.3 `readiness_verdict_refinement`

### Agents impliqués
- PERFORMANCE-ANALYZER
- SKILL-CERTIFIER
- LEARNING-CONDUCTOR
- CHRONICLE

### Messages dominants
- `proof.gap_vector.v1`
- `verdict.blockers.v1`
- `verdict.ready_signal.v1`

### Max rounds recommandé
- 2

---

# 5. Règles d’escalade globales

## Escalade automatique vers `text_trace` si
- confiance < seuil configuré,
- ambiguïté non résolue après round final,
- certification refusée,
- scénario critique bloqué,
- recommendation procédure sensible,
- contradiction entre providers.

---

# 6. Observabilité minimale à implémenter

Pour chaque message RCL, logger au minimum :
- `packetType`
- `senderAgent`
- `receiverAgent`
- `workflowId`
- `round`
- `packetMode`
- `confidence`
- `uncertaintyFlags`
- `createdAt`
- taille de payload
- temps de traitement downstream

---

# 7. Ordre de mise en œuvre recommandé

## Étape 1
Implémenter les messages de :
- GOAL
- CONTENT
- DAG
- PERFORMANCE
- CERTIFIER

## Étape 2
Implémenter :
- LEARNING-CONDUCTOR
- ROUTER
- APEX
- DRIFT

## Étape 3
Implémenter :
- ARENA
- CHRONICLE
- BRAIN

## Étape 4
Implémenter :
- VISUAL / COGNITIVE / COSMOS / ENGAGEMENT

---

# 8. Verdict final

Ce catalogue fait passer RCL de :
- concept prometteur,
- à protocole opérable,
- puis à backlog implicite d’implémentation.

Il donne enfin une réponse claire à la question :

> “comment nos agents doivent-ils se parler concrètement ?”

Et cette réponse est suffisamment précise pour guider le code sans enfermer prématurément l’architecture.

---

# 9. Prochaine étape recommandée

Le meilleur fichier suivant serait :

## `SCYFORGE_RCL_IMPLEMENTATION_BACKLOG.md`

Avec :
- tickets par agent,
- structures/types à créer,
- ordre d’implémentation,
- tests à écrire,
- instrumentation à brancher.

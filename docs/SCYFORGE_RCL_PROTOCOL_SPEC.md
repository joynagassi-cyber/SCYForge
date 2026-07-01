# SCYForge — RCL Protocol Specification
## Recursive Communication Layer pour la coordination interne des agents

## But du document

Ce document spécifie le protocole interne recommandé pour SCYForge afin de faire collaborer les agents ASCENT de manière :
- plus compacte,
- plus récursive,
- plus stable,
- moins coûteuse en tokens,
- sans sacrifier l’auditabilité B2B.

Ce protocole est **inspiré** par l’intuition de RecursiveMAS, mais **n’essaie pas de copier son mécanisme latent pur**.

SCYForge n’a pas besoin d’un clone académique.
SCYForge a besoin d’un **substrat de communication agentique industriel**.

Le nom recommandé est :

> **RCL — Recursive Communication Layer**

---

# 1. Thèse du protocole

Le problème que RCL résout est simple :

Dans un système multi-agent classique, les agents se parlent trop souvent :
- en texte trop long,
- avec trop de redondance,
- avec trop de contexte sérialisé,
- avec trop de perte de signal métier,
- et trop peu de distinction entre ce qui est :
  - utile à la coordination interne,
  - utile à la preuve externe.

RCL introduit donc une séparation explicite entre :

## A. Communication interne de coordination
Dense, compacte, typée, récursive, optimisée pour le coût et la stabilité.

## B. Communication externe de preuve
Lisible, traçable, explicable, optimisée pour l’audit et la vente B2B.

### Formule directrice

> **compress inside, justify outside**

---

# 2. Ce que RCL n’est pas

RCL n’est pas :
- un protocole public inter-entreprises,
- un remplacement total des events système,
- un remplacement des objets métier universels,
- un système de messagerie humain,
- un vrai latent bridge différentiable au sens du papier RecursiveMAS.

RCL est :

> **une couche de handoff récursif interne entre agents de SCYForge**.

---

# 3. Les objectifs fonctionnels de RCL

## Objectif 1 — Réduire la taxe textuelle inter-agent
Moins de prose, plus d’état utile.

## Objectif 2 — Préserver le signal métier
Le handoff doit transmettre :
- les gaps,
- les contraintes,
- les refs domaine,
- les niveaux de confiance,
- les objets pivots,
- sans dilution narrative.

## Objectif 3 — Permettre des rounds récursifs contrôlés
Un même sous-circuit d’agents doit pouvoir raffiner un état sur 2–3 tours.

## Objectif 4 — Conserver une shadow trace explicable
Chaque séquence RCL doit pouvoir être auditée a posteriori.

## Objectif 5 — Supporter plusieurs granularités de coût
Un handoff peut être :
- très compact,
- semi-structuré,
- ou textuel si nécessaire.

---

# 4. Architecture logique de RCL

## 4.1 Les 4 couches

### Layer 1 — Workflow Context
Le contexte macro du workflow ASCENT.

Exemples :
- goal courant,
- tenant,
- domaine,
- rôle cible,
- nœud actif,
- round courant,
- politiques appliquées.

### Layer 2 — Agent State Packet
L’unité standard de transmission entre agents.

### Layer 3 — Recursive Round Control
Le mécanisme qui décide si la boucle continue, converge, ou s’arrête.

### Layer 4 — Shadow Trace
La trace explicable dérivée du trafic RCL pour audit, debug, gouvernance.

---

# 5. Modes de communication RCL

RCL doit supporter 3 modes principaux dès le départ.

## 5.1 Mode `text_trace`

### Usage
Quand l’échange doit rester lisible ou inspectable facilement.

### Cas typiques
- debug,
- explication humaine,
- export de trace,
- handoff exceptionnel avec ambiguité élevée.

### Avantage
Interprétable.

### Inconvénient
Cher et verbeux.

---

## 5.2 Mode `structured_compact`

### Usage
Mode recommandé par défaut.

### Principe
Les agents s’échangent des objets compacts et typés.

### Cas typiques
- goal → dag,
- coverage → graph,
- proof gaps → router,
- scenario eligibility → conductor,
- verdict blockers → certifier.

### Avantage
Faible coût, forte stabilité sémantique.

### Inconvénient
Moins intuitif à lire pour un humain brut.

---

## 5.3 Mode `recursive_state`

### Usage
Pour les sous-circuits qui ont besoin de plusieurs tours de raffinement.

### Principe
On passe non pas un simple message, mais un **bundle d’état cumulatif** raffiné par plusieurs agents successifs.

### Cas typiques
- compilation de mastery graph,
- génération de scénario,
- consolidation de readiness verdict,
- remédiation adaptative complexe.

### Avantage
Permet la récursion contrôlée.

### Inconvénient
Demande des règles de convergence strictes.

---

# 6. L’objet central : `AgentStatePacket`

```ts
export interface AgentStatePacket {
  packetId: string;
  workflowId: string;
  conversationId?: string;
  round: number;
  senderAgent: string;
  receiverAgent: string;
  packetMode: 'text_trace' | 'structured_compact' | 'recursive_state';

  domainId: string;
  tenantId: string;
  learnerId?: string;
  goalId?: string;
  nodeIds?: string[];
  scenarioId?: string;
  domainRefIds?: string[];

  packetType: string;
  payload: Record<string, unknown>;
  confidence?: number;
  uncertaintyFlags?: string[];
  requestedAction?: string;
  traceRefs?: string[];
  parentPacketIds?: string[];

  createdAt: string;
}
```

## Pourquoi cet objet est important
Parce qu’il impose un minimum de discipline :
- qui parle à qui,
- dans quel workflow,
- à quel round,
- à propos de quoi,
- avec quel niveau de confiance,
- et vers quelle action attendue.

---

# 7. Types de packets recommandés

## 7.1 `goal_resolution`
Utilisé par GOAL-INTERPRETER.

### Payload attendu
- rôle cible,
- niveau cible,
- ambiguïtés,
- refs domaine candidates,
- contraintes.

---

## 7.2 `coverage_map`
Utilisé par CONTENT-SCOUT.

### Payload attendu
- sources sélectionnées,
- trust tiers,
- refs couvertes,
- gaps de couverture,
- niveau de confiance.

---

## 7.3 `mastery_graph_delta`
Utilisé par DAG-ARCHITECT.

### Payload attendu
- nouveaux nœuds,
- nœuds révisés,
- dépendances,
- criticités,
- proof requirements.

---

## 7.4 `intervention_proposal`
Utilisé par LEARNING-CONDUCTOR.

### Payload attendu
- type d’intervention,
- cible,
- raison,
- contrainte de séquence,
- priorité.

---

## 7.5 `proof_gap_vector`
Utilisé par PERFORMANCE-ANALYZER ou CERTIFIER.

### Payload attendu
- dimensions insuffisantes,
- preuves manquantes,
- erreurs éliminatoires déclenchées,
- confiance du diagnostic.

---

## 7.6 `scenario_eligibility`
Utilisé par ARENA / CONDUCTOR.

### Payload attendu
- scénarios autorisés,
- scénarios bloqués,
- raisons,
- preconditions manquantes.

---

## 7.7 `retention_priority`
Utilisé par APEX / DRIFT / ROUTER.

### Payload attendu
- nœuds à réactiver,
- priorité,
- raison de criticité,
- modalité de refresh recommandée.

---

## 7.8 `verdict_blockers`
Utilisé par CERTIFIER.

### Payload attendu
- scopes bloqués,
- règles éliminatoires,
- types de preuves manquantes,
- recommandations de remédiation.

---

# 8. Les bundles d’état récursifs

Quand le mode `recursive_state` est utilisé, les agents ne s’échangent pas des messages disjoints.
Ils raffinent un **bundle partagé**.

## 8.1 Objet `RecursiveWorkflowState`

```ts
export interface RecursiveWorkflowState {
  workflowId: string;
  domainId: string;
  tenantId: string;
  round: number;
  maxRounds: number;
  stateType: string;

  goalId?: string;
  learnerId?: string;
  primaryNodeIds?: string[];
  scenarioId?: string;

  statePayload: Record<string, unknown>;
  convergence: ConvergenceState;
  packetHistoryIds: string[];
  traceIds: string[];
  createdAt: string;
  updatedAt: string;
}

export interface ConvergenceState {
  score?: number;
  deltaFromPreviousRound?: number;
  unresolvedIssues: string[];
  stopReason?: string;
}
```

---

## 8.2 Exemples de `stateType`
- `goal_to_graph_compilation`
- `scenario_blueprint_generation`
- `readiness_verdict_refinement`
- `adaptive_remediation_loop`

---

# 9. Contrôle de récursion

Il faut une boucle stricte. Sinon tu fabriques un système qui bavarde avec lui-même.

## 9.1 Primitive : `RecursiveRoundController`

```ts
export interface RecursiveRoundController {
  runRound(state: RecursiveWorkflowState): Promise<RecursiveWorkflowState>;
  shouldContinue(state: RecursiveWorkflowState): boolean;
  shouldEscalateToTextTrace(state: RecursiveWorkflowState): boolean;
  finalize(state: RecursiveWorkflowState): Promise<FinalizedAgentOutcome>;
}
```

---

## 9.2 Conditions d’arrêt recommandées

### Arrêt 1 — `max_rounds_reached`
Par défaut : **2 ou 3 rounds max** sur la plupart des sous-circuits.

### Arrêt 2 — `convergence_reached`
Si le delta de changement entre deux rounds devient inférieur à un seuil.

### Arrêt 3 — `guard_failure`
Si un garde-fou métier critique échoue.

### Arrêt 4 — `ambiguity_escalation`
Si l’état devient trop ambigu pour rester en mode compact.
On repasse en `text_trace`.

### Arrêt 5 — `sufficient_confidence`
Si un état validé dépasse un seuil de confiance suffisant.

---

# 10. Shadow Trace

C’est la partie indispensable pour SCYForge.
Sans shadow trace, RCL devient une boîte noire peu vendable.

## 10.1 Principe
Chaque échange RCL doit pouvoir générer une **trace dérivée** plus lisible.

Cette shadow trace ne sert pas à la coordination.
Elle sert à :
- debug,
- audit,
- reproductibilité,
- support,
- explicabilité managériale.

---

## 10.2 Objet `AgentTraceEvent`

```ts
export interface AgentTraceEvent {
  traceId: string;
  workflowId: string;
  round: number;
  agentName: string;
  eventType:
    | 'packet_sent'
    | 'packet_received'
    | 'state_refined'
    | 'round_completed'
    | 'workflow_finalized'
    | 'workflow_blocked';
  summary: string;
  packetId?: string;
  referencedObjectIds?: string[];
  confidence?: number;
  timestamp: string;
}
```

---

## 10.3 Règle d’or
La shadow trace doit être :
- moins verbeuse que le texte brut,
- plus lisible que le packet compact,
- suffisante pour reconstituer la logique du workflow.

---

# 11. Routing policy de RCL

Tous les agents n’ont pas besoin du même mode.
Il faut un routeur de communication.

## 11.1 `CommunicationPolicy`

```ts
export interface CommunicationPolicy {
  defaultMode: 'text_trace' | 'structured_compact' | 'recursive_state';
  escalateToTextWhen:
    | 'low_confidence'
    | 'high_ambiguity'
    | 'human_review_required'
    | 'certification_boundary'
    | 'sensitive_procedure';
  maxRoundsByStateType: Record<string, number>;
}
```

---

## 11.2 Politique recommandée par famille de tâche

### Goal resolution
- mode par défaut : `structured_compact`
- récursion : faible

### Mastery graph compilation
- mode par défaut : `recursive_state`
- récursion : 2–3 rounds

### Scenario generation
- mode par défaut : `recursive_state`
- shadow trace obligatoire

### Readiness certification
- mode par défaut : `structured_compact`
- escalade en `text_trace` au moment du verdict final

### Drift / retention
- mode par défaut : `structured_compact`
- récursion limitée

---

# 12. RCL par agent

## 12.1 GOAL-INTERPRETER
### Entrée RCL
- intent brut ou `GoalState`

### Sortie RCL
- `goal_resolution`

### Mode recommandé
- `structured_compact`

---

## 12.2 CONTENT-SCOUT
### Sortie RCL
- `coverage_map`
- `evidence_source_selection`

### Mode recommandé
- `structured_compact`

---

## 12.3 DAG-ARCHITECT
### Sortie RCL
- `mastery_graph_delta`

### Mode recommandé
- `recursive_state`

---

## 12.4 LEARNING-CONDUCTOR
### Sortie RCL
- `intervention_proposal`
- `session_transition`

### Mode recommandé
- `structured_compact`

---

## 12.5 PERFORMANCE-ANALYZER
### Sortie RCL
- `proof_gap_vector`
- `mastery_state_update`

### Mode recommandé
- `structured_compact`

---

## 12.6 ADAPTIVE-ROUTER
### Sortie RCL
- `trajectory_adjustment`
- `remediation_request`

### Mode recommandé
- `structured_compact`

---

## 12.7 DRIFT-GUARDIAN
### Sortie RCL
- `drift_risk_signal`
- `reactivation_priority`

### Mode recommandé
- `structured_compact`

---

## 12.8 SKILL-CERTIFIER
### Sortie RCL
- `verdict_blockers`
- `verdict_ready_signal`

### Mode recommandé
- `structured_compact`, puis `text_trace` au bord externe

---

## 12.9 CHRONICLE
### Sortie RCL
- principalement trace / ledger

### Mode recommandé
- lit tout, écrit surtout shadow trace et digests

---

## 12.10 ARENA
### Sortie RCL
- `scenario_eligibility`
- `scenario_trace_delta`
- `scenario_proof_recorded`

### Mode recommandé
- `recursive_state` pour préparation,
- `structured_compact` pour scoring,
- `text_trace` pour export débrief si besoin

---

# 13. Invariants non négociables

## Invariant 1
Aucun packet RCL ne doit exister sans `workflowId`, `senderAgent`, `receiverAgent`, `packetType`, `createdAt`.

## Invariant 2
Tout packet critique doit porter un niveau de confiance ou des flags d’incertitude.

## Invariant 3
Tout workflow récursif doit avoir un `maxRounds` explicite.

## Invariant 4
Tout passage à une frontière de certification doit pouvoir être remonté en `text_trace` explicable.

## Invariant 5
RCL ne remplace pas les objets universels. Il les transporte, les résume ou les raffine.

## Invariant 6
Toute information sensible ou auditable doit être reconstructible via shadow trace.

---

# 14. Sécurité et gouvernance

## 14.1 Pourquoi c’est critique
SCYForge vend de la readiness et de la preuve.
Donc une couche de communication interne ne doit jamais empêcher :
- l’audit,
- l’explication,
- la reconstruction du raisonnement système.

## 14.2 Règle recommandée
Les décisions suivantes doivent forcer une trace explicable :
- verdict readiness,
- blocage de certification,
- proposition d’autonomie,
- recommandation procédure sensible,
- scénario critique.

---

# 15. Déploiement progressif recommandé

## Phase RCL-1
Introduire `AgentStatePacket` et `AgentTraceEvent`.

## Phase RCL-2
Brancher GOAL → DAG → VALIDATOR en `structured_compact`.

## Phase RCL-3
Introduire `RecursiveWorkflowState` pour la compilation de graph.

## Phase RCL-4
Brancher scénario / verdict.

## Phase RCL-5
Mesurer coût, latence, cohérence, qualité de convergence.

## Phase RCL-6
Évaluer si certains sous-circuits méritent plus tard un bridge quasi-latent sur open models locaux.

---

# 16. KPIs recommandés pour RCL

- tokens inter-agent par workflow,
- latence inter-agent totale,
- taux de convergence avant `maxRounds`,
- nombre moyen de packets par workflow,
- taux d’escalade vers `text_trace`,
- taux de workflows bloqués par ambiguïté,
- cohérence perçue des outputs finaux,
- taux d’acceptation du verdict final par validator.

---

# 17. Exemple concret — Compilation cyber d’un graphe de maîtrise

## Workflow
`goal_to_graph_compilation`

### Round 1
- GOAL envoie `goal_resolution`
- CONTENT envoie `coverage_map`
- DAG construit premier `mastery_graph_delta`
- VALIDATOR signale ambiguïtés

### Round 2
- DAG raffine les nœuds,
- VALIDATOR revérifie,
- PERFORMANCE anticipe proof gaps.

### Finalisation
- le système fige le `MasteryGraph`,
- CHRONICLE écrit la shadow trace,
- CONDUCTOR peut commencer à orchestrer.

### Intérêt
Tu as une vraie récursion utile, sans faire bavarder les agents en prose à chaque étape.

---

# 18. Verdict final

RCL est la bonne traduction industrielle de l’intuition RecursiveMAS pour SCYForge.

Pas parce qu’il copie le papier.
Mais parce qu’il reprend son idée forte :

> **la performance d’un système multi-agent dépend aussi du médium de communication entre agents.**

Pour SCYForge, la bonne réponse n’est pas la communication latente pure.
La bonne réponse est :

> **une communication interne compacte, typée, récursive et mesurable, avec une sortie externe explicable.**

C’est ça que RCL formalise.

---

# 19. Prochaine étape recommandée

Le prochain meilleur document à écrire maintenant serait :

## `SCYFORGE_RCL_MESSAGE_CATALOG.md`

Avec pour chaque agent :
- les packet types exacts,
- les payload schemas,
- les conditions d’émission,
- les conditions d’escalade vers text trace,
- les métriques à logguer.

C’est lui qui transformera le protocole en backlog d’implémentation.

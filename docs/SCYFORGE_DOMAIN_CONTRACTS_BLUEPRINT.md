# SCYForge — Blueprint technique des interfaces Domain Contracts

## But du document

Ce document transforme la vision d’extensibilité de SCYForge en **contrats techniques presque implémentables**.

Il sert à définir :
- les **interfaces canoniques** entre le noyau cognitif et les Domain Packs,
- les **objets universels** à faire vivre dans le cœur,
- la frontière claire entre :
  - ce que le **Kernel** sait faire,
  - ce qu’un **Pack Domaine** doit fournir,
  - ce qu’un **tenant** injecte comme savoir privé,
  - et ce que le runtime doit journaliser comme preuve.

Le document est rédigé comme un **blueprint de ports/adapters** orienté TypeScript/Rust.

---

# 1. Principe de design

## 1.1 Règle maîtresse

Le noyau SCYForge ne doit jamais contenir :
- une ontologie métier codée en dur,
- un rôle métier codé en dur,
- une règle de preuve codée en dur,
- une simulation métier codée en dur,
- une politique de rétention métier codée en dur.

Il doit uniquement contenir :
- des **objets universels**,
- des **moteurs de traitement**,
- des **invariants cognitifs**,
- des **ports** pour demander la vérité métier.

---

# 2. Couches contractuelles

## Layer A — Cognitive Kernel
Responsable de :
- goal compilation,
- mastery graph compilation,
- orchestration d’interventions,
- calcul de rétention,
- exécution de scénarios,
- agrégation de preuves,
- rendu de verdicts,
- audit trail.

## Layer B — Domain Contracts
Responsable de fournir la vérité métier injectable.

## Layer C — Domain Pack
Responsable d’implémenter les contracts pour un domaine donné.

## Layer D — Tenant Knowledge Layer
Responsable de fournir les corpus privés, policies tenant, particularismes locaux.

## Layer E — Telemetry & Proof Layer
Responsable de journaliser apprentissage, décisions, simulations, verdicts.

---

# 3. Objets universels du noyau

## 3.1 `GoalSpec`

```ts
export interface GoalSpec {
  id: string;
  tenantId: string;
  learnerId: string;
  domainId: string;
  rawIntent: string;
  normalizedTitle: string;
  targetRoleIds: string[];
  targetLevel: 'aware' | 'apply' | 'master';
  timeframeDays?: number;
  constraints: string[];
  successDefinition?: string;
  sourceContextIds: string[];
  createdAt: string;
}
```

## 3.2 `DomainReference`

```ts
export interface DomainReference {
  id: string;
  domainId: string;
  refType:
    | 'concept'
    | 'technique'
    | 'role'
    | 'scenario'
    | 'procedure'
    | 'policy'
    | 'signal'
    | 'error_mode'
    | 'proof_requirement';
  externalKey?: string;
  title: string;
  description?: string;
  parentIds: string[];
  tagIds: string[];
  sourceIds: string[];
  confidence?: number;
  version: string;
}
```

## 3.3 `MasteryNode`

```ts
export interface MasteryNode {
  id: string;
  goalId: string;
  title: string;
  description: string;
  domainRefIds: string[];
  masteryType:
    | 'knowledge'
    | 'discrimination'
    | 'procedure'
    | 'decision'
    | 'communication';
  targetLevel: 'aware' | 'apply' | 'master';
  prerequisiteNodeIds: string[];
  failureModes: string[];
  proofRequirementIds: string[];
  criticality: 'low' | 'medium' | 'high' | 'mission_critical';
  status?: 'locked' | 'available' | 'in_progress' | 'validated';
}
```

## 3.4 `ScenarioBlueprint`

```ts
export interface ScenarioBlueprint {
  id: string;
  domainId: string;
  title: string;
  description: string;
  roleTargetIds: string[];
  triggerRefIds: string[];
  objective: string;
  preconditions: string[];
  context: string;
  signalRefs: string[];
  requiredDecisionRefs: string[];
  branchRules: BranchRule[];
  eliminationErrorRefs: string[];
  rubricId: string;
  sourceIds: string[];
  version: string;
}

export interface BranchRule {
  id: string;
  when: string;
  then: string;
  consequenceType: 'context_shift' | 'risk_increase' | 'success_path' | 'failure_path';
}
```

## 3.5 `ProofRecord`

```ts
export interface ProofRecord {
  id: string;
  tenantId: string;
  learnerId: string;
  goalId: string;
  nodeId?: string;
  scenarioId?: string;
  evidenceType:
    | 'quiz'
    | 'explanation'
    | 'decision'
    | 'procedure'
    | 'simulation'
    | 'retention'
    | 'observation';
  score: number;
  confidence: number;
  rubricDimensions: RubricDimensionScore[];
  sourceIds: string[];
  domainRefIds: string[];
  evaluatorTraceIds: string[];
  verdict: 'insufficient' | 'developing' | 'operational' | 'autonomous';
  capturedAt: string;
}

export interface RubricDimensionScore {
  dimensionId: string;
  score: number;
  rationale: string;
}
```

## 3.6 `ReadinessVerdict`

```ts
export interface ReadinessVerdict {
  id: string;
  learnerId: string;
  goalId: string;
  roleScopeIds: string[];
  autonomyScope: string[];
  blockedScope: string[];
  verdict: 'not_ready' | 'conditionally_ready' | 'operational' | 'autonomous';
  confidence: number;
  evidenceRecordIds: string[];
  blockingReasons: string[];
  grantedAt: string;
}
```

---

# 4. Contrats domaine canoniques

## 4.1 `OntologyProvider`

### Rôle
Expose la grammaire métier : concepts, relations, hiérarchies, synonymes, pivots, références.

```ts
export interface OntologyProvider {
  getDomainId(): string;
  getVersion(): string;
  listRootReferences(): Promise<DomainReference[]>;
  getReferenceById(id: string): Promise<DomainReference | null>;
  getReferenceByExternalKey(externalKey: string): Promise<DomainReference | null>;
  searchReferences(query: string, limit?: number): Promise<DomainReference[]>;
  expandNeighborhood(refIds: string[], depth?: number): Promise<DomainReference[]>;
  mapTextToReferences(input: {
    text: string;
    context?: string;
    roleIds?: string[];
  }): Promise<ReferenceMappingResult>;
}

export interface ReferenceMappingResult {
  matches: Array<{
    refId: string;
    confidence: number;
    rationale: string;
  }>;
  unresolvedTerms: string[];
}
```

### Invariants
- aucune référence retournée sans version,
- tout mapping doit donner une confiance,
- toute ambiguïté doit pouvoir être signalée.

### Pack Cyber — exemple
- `T1059.001` → PowerShell,
- `SOC_L1` → rôle,
- `false_positive_pattern` → classe d’erreur,
- `escalate_to_l2` → procédure / décision.

---

## 4.2 `CorpusProvider`

### Rôle
Fournir les corpus autorisés, leur provenance, leur segmentation et leur niveau de confiance.

```ts
export interface CorpusProvider {
  getDomainId(): string;
  listSources(input: SourceQuery): Promise<DomainSource[]>;
  getSourceById(sourceId: string): Promise<DomainSource | null>;
  fetchChunks(input: ChunkQuery): Promise<SourceChunk[]>;
  mapChunksToReferences(input: {
    chunkIds: string[];
    refIds?: string[];
  }): Promise<ChunkReferenceMap[]>;
  getCoverage(input: CoverageQuery): Promise<CoverageResult>;
}

export interface DomainSource {
  id: string;
  title: string;
  sourceType: 'official' | 'internal' | 'community' | 'generated' | 'external_dataset';
  authorityScore: number;
  freshnessScore?: number;
  trustTier: 'gold' | 'silver' | 'bronze' | 'rejected';
  version?: string;
  uri?: string;
  tags: string[];
}

export interface SourceChunk {
  id: string;
  sourceId: string;
  text: string;
  refIds: string[];
  metadata: Record<string, unknown>;
}
```

### Invariants
- toute source doit être classée par trust tier,
- tout chunk doit garder son `sourceId`,
- un chunk généré ne doit jamais se faire passer pour une source primaire.

---

## 4.3 `RoleTaxonomyProvider`

### Rôle
Déclarer ce que sont les rôles, responsabilités, niveaux d’autonomie et attentes de preuve.

```ts
export interface RoleTaxonomyProvider {
  getDomainId(): string;
  listRoles(): Promise<DomainRole[]>;
  getRoleById(roleId: string): Promise<DomainRole | null>;
  resolveRole(input: {
    rawIntent: string;
    hints?: string[];
  }): Promise<RoleResolution>;
  getRoleExpectations(roleId: string, targetLevel: 'aware' | 'apply' | 'master'): Promise<RoleExpectationProfile>;
}

export interface DomainRole {
  id: string;
  title: string;
  description: string;
  parentRoleId?: string;
  allowedAutonomyScopes: string[];
  coreRefIds: string[];
}

export interface RoleResolution {
  roleIds: string[];
  confidence: number;
  rationale: string;
  unresolvedAmbiguities: string[];
}

export interface RoleExpectationProfile {
  roleId: string;
  targetLevel: 'aware' | 'apply' | 'master';
  requiredNodeTypes: string[];
  requiredScenarioTypes: string[];
  criticalFailureModes: string[];
}
```

### Invariants
- la résolution de rôle ne peut pas être purement lexicale,
- tout rôle doit exposer ses scopes d’autonomie.

---

## 4.4 `DecisionScenarioProvider`

### Rôle
Exposer les scénarios et leurs règles de branchement.

```ts
export interface DecisionScenarioProvider {
  getDomainId(): string;
  listScenarioBlueprints(input: ScenarioQuery): Promise<ScenarioBlueprint[]>;
  getScenarioBlueprint(scenarioId: string): Promise<ScenarioBlueprint | null>;
  resolveEligibleScenarios(input: {
    roleIds: string[];
    nodeIds: string[];
    targetLevel: 'aware' | 'apply' | 'master';
  }): Promise<ScenarioEligibilityResult>;
}

export interface ScenarioEligibilityResult {
  eligibleScenarioIds: string[];
  blockedScenarioIds: Array<{
    scenarioId: string;
    reason: string;
  }>;
}
```

### Invariants
- un scénario doit toujours venir avec ses préconditions,
- toute éligibilité doit pouvoir expliquer ses refus.

---

## 4.5 `ProofRubricProvider`

### Rôle
Définir comment évaluer et certifier.

```ts
export interface ProofRubricProvider {
  getDomainId(): string;
  listRubrics(): Promise<ProofRubric[]>;
  getRubricById(rubricId: string): Promise<ProofRubric | null>;
  getRubricForNode(nodeId: string): Promise<ProofRubric | null>;
  getRubricForScenario(scenarioId: string): Promise<ProofRubric | null>;
  getReadinessPolicy(input: {
    roleIds: string[];
    targetLevel: 'aware' | 'apply' | 'master';
  }): Promise<ReadinessPolicy>;
}

export interface ProofRubric {
  id: string;
  title: string;
  dimensions: RubricDimension[];
  eliminationRules: EliminationRule[];
  scoringModel: 'weighted_sum' | 'gated' | 'hybrid';
}

export interface RubricDimension {
  id: string;
  label: string;
  weight: number;
  description: string;
}

export interface EliminationRule {
  id: string;
  description: string;
  trigger: string;
  consequence: 'invalidate_attempt' | 'cap_verdict' | 'require_remediation';
}

export interface ReadinessPolicy {
  roleIds: string[];
  minimumEvidenceTypes: string[];
  requiredScenarioCount: number;
  minimumDimensionScores: Record<string, number>;
  blockedByEliminationRule: boolean;
}
```

### Invariants
- pas de readiness sans policy explicite,
- pas de rubric sans dimensions,
- pas de certificat sans trace des règles éliminatoires.

---

## 4.6 `RetentionPolicyProvider`

### Rôle
Donner la logique de réactivation et de préservation de maîtrise.

```ts
export interface RetentionPolicyProvider {
  getDomainId(): string;
  getRetentionPolicyForNode(nodeId: string): Promise<RetentionPolicy>;
  getRetentionPolicyForRole(roleId: string): Promise<RetentionPolicy>;
  prioritizeReview(input: ReviewPrioritizationInput): Promise<ReviewPriorityResult>;
}

export interface RetentionPolicy {
  criticalityBias: number;
  reviewCadenceHint: string;
  decisionRefreshRequired: boolean;
  procedureRefreshRequired: boolean;
  maxDormancyDays?: number;
}

export interface ReviewPrioritizationInput {
  learnerId: string;
  nodeIds: string[];
  recentFailures: string[];
  forgettingRiskByNode: Record<string, number>;
}

export interface ReviewPriorityResult {
  orderedNodeIds: string[];
  rationale: string;
}
```

### Invariants
- les nœuds critiques doivent pouvoir remonter dans la file même si l’oubli estimé est modéré,
- la politique peut privilégier procédure ou décision selon domaine.

---

## 4.7 `ValidationGuardProvider`

### Rôle
Borner ce que le système a le droit de faire, affirmer, générer, recommander ou certifier.

```ts
export interface ValidationGuardProvider {
  getDomainId(): string;
  validateGeneratedClaim(input: GeneratedClaimInput): Promise<ClaimValidationResult>;
  validateScenarioOutput(input: ScenarioValidationInput): Promise<ScenarioValidationResult>;
  validateReadinessVerdict(input: VerdictValidationInput): Promise<VerdictValidationResult>;
  classifySourceRisk(input: SourceRiskInput): Promise<SourceRiskResult>;
}

export interface GeneratedClaimInput {
  text: string;
  sourceIds: string[];
  refIds: string[];
  operationType: 'explanation' | 'recommendation' | 'procedure' | 'certification';
}

export interface ClaimValidationResult {
  accepted: boolean;
  confidence: number;
  issues: string[];
  requiredDowngrade?: 'mark_uncertain' | 'require_source' | 'reject';
}

export interface ScenarioValidationInput {
  scenarioId: string;
  generatedBranchTrace: string[];
  inferredConsequences: string[];
}

export interface ScenarioValidationResult {
  accepted: boolean;
  brokenRules: string[];
}

export interface VerdictValidationInput {
  verdict: ReadinessVerdict;
  proofRecords: ProofRecord[];
}

export interface VerdictValidationResult {
  accepted: boolean;
  reasons: string[];
}

export interface SourceRiskInput {
  sourceId: string;
  sourceType: string;
  useCase: 'learning' | 'decision' | 'procedure' | 'certification';
}

export interface SourceRiskResult {
  riskLevel: 'low' | 'medium' | 'high' | 'prohibited';
  rationale: string;
}
```

### Invariants
- aucune certification ne sort si le verdict n’est pas validé,
- aucune recommandation sensible ne sort sans source suffisante,
- toute validation doit être explicable.

### Verdict franc
Ce provider est le cœur de l’anti-wrapperisation.

---

# 5. Contrats du noyau qui consomment les providers

## 5.1 `GoalCompiler`

```ts
export interface GoalCompiler {
  compile(input: {
    rawIntent: string;
    learnerId: string;
    tenantId: string;
    domainId: string;
  }): Promise<GoalSpec>;
}
```

### Dépendances obligatoires
- `RoleTaxonomyProvider`
- `OntologyProvider`
- `ProofRubricProvider`

---

## 5.2 `MasteryGraphCompiler`

```ts
export interface MasteryGraphCompiler {
  compile(input: {
    goal: GoalSpec;
    evidenceBundleId: string;
  }): Promise<MasteryNode[]>;
}
```

### Dépendances obligatoires
- `OntologyProvider`
- `RoleTaxonomyProvider`
- `ProofRubricProvider`

---

## 5.3 `InterventionPolicyEngine`

```ts
export interface InterventionPolicyEngine {
  decideNext(input: {
    learnerId: string;
    goalId: string;
    currentNodeId?: string;
  }): Promise<InterventionDecision>;
}

export interface InterventionDecision {
  interventionType:
    | 'explain'
    | 'practice'
    | 'simulate'
    | 'review'
    | 'remediate'
    | 'certify';
  targetNodeIds: string[];
  rationale: string;
}
```

### Dépendances obligatoires
- `RoleTaxonomyProvider`
- `RetentionPolicyProvider`
- `DecisionScenarioProvider`
- `ValidationGuardProvider`

---

## 5.4 `ScenarioRuntime`

```ts
export interface ScenarioRuntime {
  start(input: {
    learnerId: string;
    scenarioId: string;
  }): Promise<ScenarioSession>;

  submitDecision(input: {
    sessionId: string;
    learnerAction: string;
  }): Promise<ScenarioStepResult>;

  finalize(sessionId: string): Promise<ProofRecord[]>;
}

export interface ScenarioSession {
  id: string;
  scenarioId: string;
  learnerId: string;
  startedAt: string;
}

export interface ScenarioStepResult {
  nextStateSummary: string;
  consequenceSummary: string;
  hiddenTraceEventIds: string[];
}
```

### Dépendances obligatoires
- `DecisionScenarioProvider`
- `ProofRubricProvider`
- `ValidationGuardProvider`

---

## 5.5 `ReadinessVerdictEngine`

```ts
export interface ReadinessVerdictEngine {
  evaluate(input: {
    learnerId: string;
    goalId: string;
    roleIds: string[];
  }): Promise<ReadinessVerdict>;
}
```

### Dépendances obligatoires
- `ProofRubricProvider`
- `RoleTaxonomyProvider`
- `ValidationGuardProvider`
- `DecisionScenarioProvider`

---

# 6. Registry et résolution de providers

## 6.1 Registry côté TypeScript

```ts
export interface DomainPackRegistry {
  getOntologyProvider(domainId: string): OntologyProvider;
  getCorpusProvider(domainId: string): CorpusProvider;
  getRoleTaxonomyProvider(domainId: string): RoleTaxonomyProvider;
  getDecisionScenarioProvider(domainId: string): DecisionScenarioProvider;
  getProofRubricProvider(domainId: string): ProofRubricProvider;
  getRetentionPolicyProvider(domainId: string): RetentionPolicyProvider;
  getValidationGuardProvider(domainId: string): ValidationGuardProvider;
}
```

### Règle
Un service noyau ne reçoit jamais un pack complet.
Il reçoit uniquement les interfaces dont il a besoin.

---

## 6.2 Exemple d’orchestration Mastra / TS

```ts
async function compileCyberGoal(
  registry: DomainPackRegistry,
  rawIntent: string,
  learnerId: string,
  tenantId: string,
) {
  const domainId = 'cyber';

  const goalCompiler = makeGoalCompiler({
    roles: registry.getRoleTaxonomyProvider(domainId),
    ontology: registry.getOntologyProvider(domainId),
    rubric: registry.getProofRubricProvider(domainId),
  });

  return goalCompiler.compile({
    rawIntent,
    learnerId,
    tenantId,
    domainId,
  });
}
```

---

# 7. Blueprint Rust — ports côté backend

```rust
pub trait OntologyProvider: Send + Sync {
    fn domain_id(&self) -> &str;
    fn version(&self) -> &str;
    fn get_reference_by_id(&self, id: &str) -> anyhow::Result<Option<DomainReference>>;
    fn search_references(&self, query: &str, limit: usize) -> anyhow::Result<Vec<DomainReference>>;
}

pub trait ProofRubricProvider: Send + Sync {
    fn domain_id(&self) -> &str;
    fn get_rubric_for_node(&self, node_id: &str) -> anyhow::Result<Option<ProofRubric>>;
    fn get_readiness_policy(&self, role_ids: &[String], target_level: &str) -> anyhow::Result<ReadinessPolicy>;
}

pub trait ValidationGuardProvider: Send + Sync {
    fn validate_generated_claim(&self, input: GeneratedClaimInput) -> anyhow::Result<ClaimValidationResult>;
    fn validate_readiness_verdict(&self, verdict: &ReadinessVerdict, proofs: &[ProofRecord]) -> anyhow::Result<VerdictValidationResult>;
}
```

### Recommandation d’architecture
Les ports doivent vivre dans le noyau, les implémentations dans les packs ou adapters.

---

# 8. Contrat de pack domaine

## 8.1 Manifest runtime attendu

```ts
export interface DomainPackManifest {
  packId: string;
  version: string;
  displayName: string;
  coreApiVersion: string;
  domainId: string;
  provides: {
    ontology: boolean;
    corpus: boolean;
    roleTaxonomy: boolean;
    decisionScenarios: boolean;
    proofRubric: boolean;
    retentionPolicy: boolean;
    validationGuard: 'none' | 'partial' | 'full';
  };
  entrypoints: {
    ontology?: string;
    corpus?: string;
    roles?: string;
    scenarios?: string;
    rubric?: string;
    retention?: string;
    validation?: string;
  };
}
```

## 8.2 Règles d’acceptation d’un pack
Un pack n’est pas “production ready” si :
- `validationGuard !== full`
- `proofRubric` absent
- `decisionScenarios` absent pour un domaine à proof pratique
- `roleTaxonomy` absent

### Verdict franc
Un pack sans validation complète est un **pack de contenu**, pas un pack de compétence.

---

# 9. Contrat tenant

Le domaine ne suffit pas. Le client injecte aussi sa vérité privée.

## 9.1 `TenantKnowledgeAdapter`

```ts
export interface TenantKnowledgeAdapter {
  tenantId: string;
  listTenantSources(): Promise<DomainSource[]>;
  fetchTenantChunks(query: ChunkQuery): Promise<SourceChunk[]>;
  getTenantPolicies(): Promise<TenantOperationalPolicy[]>;
}

export interface TenantOperationalPolicy {
  id: string;
  title: string;
  policyType: 'escalation' | 'procedure' | 'compliance' | 'tooling' | 'naming';
  content: string;
  sourceIds: string[];
}
```

### Règle critique
Le pack fournit la vérité métier générique du domaine.
Le tenant fournit la vérité locale de l’organisation.
Le moteur doit savoir fusionner les deux sans confusion.

---

# 10. Journalisation et audit

## 10.1 `EvidenceTrace`

```ts
export interface EvidenceTrace {
  id: string;
  learnerId: string;
  eventType:
    | 'goal_compiled'
    | 'source_ingested'
    | 'node_generated'
    | 'intervention_selected'
    | 'scenario_decision'
    | 'proof_recorded'
    | 'verdict_granted';
  relatedIds: string[];
  rationale?: string;
  timestamp: string;
}
```

## 10.2 `AgentDecisionTrace`

```ts
export interface AgentDecisionTrace {
  id: string;
  agentName: string;
  inputSnapshotId: string;
  outputSnapshotId: string;
  policyIds: string[];
  rationale: string;
  timestamp: string;
}
```

### Règle
Pas de verdict sérieux sans chaîne d’audit reconstituable.

---

# 11. Invariants d’implémentation non négociables

## Invariant 1
Aucune interface noyau ne retourne un objet non versionné quand il touche au domaine.

## Invariant 2
Aucune réponse critique générée ne peut sortir sans possibilité de remonter à ses `sourceIds`.

## Invariant 3
Aucune certification ne peut être calculée à partir d’un seul type de preuve.

## Invariant 4
Aucun scénario de haute criticité ne peut être exécuté sans blueprint.

## Invariant 5
Le noyau ne doit jamais dépendre d’un identifiant métier spécifique comme `T1059.001`.

## Invariant 6
Tout provider doit être remplaçable par un autre pack sans casser la signature du service noyau.

---

# 12. Exemple concret — Pack Cyber branché sur le noyau

## 12.1 Goal
Entrée :
> “Je veux rendre autonome une recrue SOC L1 sur le triage des alertes PowerShell suspectes.”

## 12.2 Résolution attendue
- `RoleTaxonomyProvider` → `SOC_L1`
- `OntologyProvider` → refs `T1059`, `T1059.001`, `alert_triage`, `false_positive_admin_activity`
- `ProofRubricProvider` → rubric cyber 5 dimensions
- `DecisionScenarioProvider` → scénarios éligibles “PowerShell suspicious execution triage”
- `RetentionPolicyProvider` → cadence renforcée sur discrimination faux positif / vrai signal
- `ValidationGuardProvider` → interdit toute recommandation d’escalade non source-grounded

### Résultat
Le noyau reste identique.
Seul le pack injecte la définition de la compétence.

---

# 13. Exemple concret — Pack Sales branché sur le même noyau

Entrée :
> “Je veux rendre autonome un SDR sur les objections pricing SMB.”

Le même noyau consomme :
- `RoleTaxonomyProvider` → `SDR`
- `OntologyProvider` → objection, persona, segment SMB, pricing logic
- `DecisionScenarioProvider` → call objection scenarios
- `ProofRubricProvider` → découverte, écoute, reformulation, objection handling, next step discipline

### Point capital
Si un seul service noyau doit être réécrit pour que cet exemple fonctionne, l’architecture n’est pas encore assez pure.

---

# 14. Priorités d’implémentation recommandées

## Phase 1 — Fondations obligatoires
1. Objets universels du noyau
2. Registry de providers
3. Interfaces `OntologyProvider`, `RoleTaxonomyProvider`, `ProofRubricProvider`, `ValidationGuardProvider`
4. Refactor GOAL / DAG / CERTIFIER pour dépendre de ces ports

## Phase 2 — Industrialisation du runtime
5. `DecisionScenarioProvider`
6. `RetentionPolicyProvider`
7. `ScenarioRuntime`
8. `ReadinessVerdictEngine`

## Phase 3 — Démonstration d’extensibilité
9. pack cyber complet `validationGuard: full`
10. mini pack `sales-lite`
11. tests de remplacement de pack

---

# 15. Conclusion franche

L’extensibilité de SCYForge ne sera pas prouvée par un discours.
Elle sera prouvée quand :
- les agents consommeront des **ports domaine** au lieu de prompts implicites,
- les objets universels porteront la preuve et la maîtrise,
- un second pack minimal pourra se brancher sans réécrire le cerveau.

Le but n’est pas de faire un “plugin system”.
Le but est de faire :

> **un noyau cognitif universel qui sait fabriquer la maîtrise, et des packs qui déclarent ce que signifie être compétent dans un monde donné.**

C’est cette phrase qui doit devenir vraie techniquement, pas juste stratégiquement.

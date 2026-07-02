# SCY FORGE — EVENTBUS SCHEMAS & CONTRACTS (RFC-2119)
**Document ID** : S01_EVENTBUS_SCHEMAS  
**Date** : 2026-07-01  
**Statut** : 🟢 NORMATIF — Réf pour toute implémentation EventBus  
**Pilier** : Pilier 1 (Semantic Tree) + Pilier 2 (ASCENT) + Pilier 3 (GFE)

---

## 1. Contexte et Principe

> **D-010** : Dé-couplage total via EventBus. Zéro appel direct inter-services.
> **D-024** : Le core ne contient jamais de termes métier cyber en dur dans les schemas.

L'EventBus est le système nerveux central de SCY Forge. Toute communication inter-services passe par des événements **typés, versionnés, et validés**.

### Principes directeurs

```
1. Un événement = un fait immuable (append-only)
2. Un consommateur ne connaît JAMAIS l'émetteur (pub/sub anonyme)
3. Chaque événement a un schema strict (RFC-2119 MUST/SHOULD/MAY)
4. Les événements métier (TreeOp*, Seed*, Scenario*) sont distincts des événements d'infrastructure
5. Ordre des événements garanti par tree_id + event_id (causal ordering)
6. Aucun événement ne transporte de "commande" (read-only) — les commands sont des appels directs aux ports
```

### Catégories d'événements

| Catégorie | Préfixe | Description |
|-----------|---------|-------------|
| **Tree Operations** | `TreeOp*` | Opérations canoniques du Semantic Tree |
| **Seed Lifecycle** | `Seed*` | GFE — cycle de vie des Seeds |
| **Mastery** | `Mastery*` | Évaluations de maîtrise |
| **Scenario** | `Scenario*` | Instances ARENA |
| **Pack** | `Pack*` | Chargement/validation des Domain Packs |
| **Infrastructure** | `Sys*` | Santé système, DLQ, health checks |

---

## 2. EventBus Core Schema

```rust
/// EventBus — événement canonique SCY Forge.
///
/// Tous les événements du système implémentent ce trait.
#[async_trait::async_trait]
pub trait SCYForgeEvent: Send + Sync + Serialize + Deserialize<'static> {
    /// Identifiant unique de l'événement (UUID v7 — tri chronologique natif).
    fn event_id(&self) -> Uuid;

    /// Type de l'événement (pour routing + filtrage).
    fn event_type(&self) -> &'static str;

    /// Timestamp de création (Unix epoch seconds).
    fn created_at(&self) -> i64;

    /// Partition logique (pour ordering + DLQ).
    fn partition_key(&self) -> String;

    /// Headers optionnels (trace ID, tenant ID, etc.).
    fn headers(&self) -> HashMap<String, String>;

    /// Sérialisation binaire (pour persistence DLQ).
    fn to_bytes(&self) -> AppResult<Vec<u8>>;

    /// Désérialisation.
    fn from_bytes(bytes: &[u8]) -> AppResult<Self> where Self: Sized;
}
```

### EventBus — Publication (Producer)

```rust
#[async_trait::async_trait]
pub trait EventBusPublisher: Send + Sync {
    /// Publie un événement. Retourne le event_id pour traçabilité.
    async fn publish<E: SCYForgeEvent>(&self, event: E) -> AppResult<Uuid>;

    /// Publie un événement avec retention garantie (DLQ en cas d'échec).
    async fn publish_persistent<E: SCYForgeEvent>(&self, event: E) -> AppResult<Uuid>;

    /// Accusé de réception (ack) pour événements critiques.
    async fn publish_with_ack<E: SCYForgeEvent>(&self, event: E) -> AppResult<EmitResult>;
}
```

### EventBus — Souscription (Consumer)

```rust
#[async_trait::async_trait]
pub trait EventBusConsumer: Send + Sync {
    /// Souscrit à un type d'événement.
    async fn subscribe(&self, event_type: &'static str, handler: impl Handler) -> AppResult<SubscriptionId>;

    /// Souscrit avec filtre (ex: seulement les événements d'un tree_id donné).
    async fn subscribe_filtered<F: Filter>(&self, event_type: &'static str, filter: F, handler: impl Handler) -> AppResult<SubscriptionId>;

    /// Désinscription.
    async fn unsubscribe(&self, subscription_id: SubscriptionId) -> AppResult<()>;
}
```

---

## 3. SECTION 1 — TREE OPERATIONS EVENTS

### MUST — tree_op_planted

**RFC-2119 MUST** : émis systématiquement après un `plant()` réussi.

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TreeOpPlanted {
    pub event_id: Uuid,
    pub created_at: i64,
    pub tree_id: Uuid,
    pub actor: TreeOpActor,
    pub roots: Vec<Uuid>,
    pub owner_kind: String,         // "domain_pack" | "organization" | "learner"
    pub owner_id: Uuid,
    pub domain_pack_id: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum TreeOpActor {
    System,
    User,
    Agent(String),          // "agent_03", "pack_loader", etc.
    PackLoader,
}
```

**Consommateurs** : ASCENT (tous agents), COSMOS, GFE.

---

### MUST — tree_op_grafted

**RFC-2119 MUST** : émis systématiquement après un `graft()` réussi.

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TreeOpGrafted {
    pub event_id: Uuid,
    pub created_at: i64,
    pub tree_id: Uuid,
    pub owner_kind: String,         // "domain_pack" | "organization" | "learner"
    pub owner_id: Uuid,
    pub actor: TreeOpActor,
    pub parent_node_id: Uuid,
    pub child_node_id: Uuid,
    pub edge_kind: String,           // "trunk" | "branch" | "leaf" | "prereq" | "relates" | "contradicts" | "supersedes"
    pub criticality: f32,
    pub is_unlock_prerequisite: bool, // true si cette edge débloque le child
}
```

**Consommateurs** : ASCENT Agent-05 (Performance-Analyzer), GFE (détection de nouvelles paires éligibles).

---

### MUST — tree_op_pruned

**RFC-2119 MUST** : émis systématiquement après un `prune()` réussi.

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TreeOpPruned {
    pub event_id: Uuid,
    pub created_at: i64,
    pub tree_id: Uuid,
    pub owner_kind: String,         // "domain_pack" | "organization" | "learner"
    pub owner_id: Uuid,
    pub actor: TreeOpActor,
    pub edge_id: Uuid,
    pub from_node: Uuid,
    pub to_node: Uuid,
    pub superseded_at: i64,
    pub reason: String,              // Optionnel : "contradicted" | "outdated" | "replaced"
}
```

**Consommateurs** : GFE (évite de re-polliniser sur arêtes supersedées), COSMOS (rafraîchit le graphe).

---

### MUST — tree_op_tested

**RFC-2119 MUST** : émis après chaque évaluation de nœud (`test()` réussi).

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TreeOpTested {
    pub event_id: Uuid,
    pub created_at: i64,
    pub tree_id: Uuid,
    pub owner_kind: String,         // "domain_pack" | "organization" | "learner"
    pub owner_id: Uuid,
    pub learner_id: Uuid,
    pub node_id: Uuid,
    pub actor: TreeOpActor,
    pub evidence_type: String,       // pack-défini (ex: "apt29_step", "b11_card", "writeup")
    pub score: f32,                  // 0.0–1.0
    pub rubric_criteria: Vec<RubricCriterionScore>,
}
```

**Consommateurs** : ASCENT Agent-04 (Learning-Conductor), GFE (conditions L3).

---

### MUST — tree_op_myelinated

**RFC-2119 MUST** : émis quand un nœud passe à `MASTERED`.

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TreeOpMyelinated {
    pub event_id: Uuid,
    pub created_at: i64,
    pub tree_id: Uuid,
    pub owner_kind: String,         // "domain_pack" | "organization" | "learner"
    pub owner_id: Uuid,
    pub learner_id: Uuid,
    pub node_id: Uuid,
    pub actor: TreeOpActor,
    pub mastery_score: f32,           // ≥ pack_config.mastery_threshold
    pub confidence: f32,
    /// Nœuds qui deviennent unlockables grâce à cette maîtrise
    pub newly_unlockable: Vec<Uuid>,
}
```

**Consommateurs** : APEX (scheduler FSRS), Certification Service, GFE (nouvelles branches éligibles à pollination).

---

## 4. SECTION 2 — SEED LIFECYCLE EVENTS (GFE — PILIER 3)

### MUST — seed_pollinated

**RFC-2119 MUST** : émis après chaque `Pollination(A, B, ctx)` réussie (les 4 conditions sont satisfaites).

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedPollinated {
    pub event_id: Uuid,
    pub created_at: i64,
    pub seed_id: Uuid,
    pub source_a_id: Uuid,
    pub source_b_id: Uuid,
    pub pollination_conditions: PollinationConditions,
    pub initial_viability: f32,
    pub initial_fecundity: f32,
    pub initial_plant_score: f32,
    pub pollination_context: serde_json::Value,
    pub tree_id: Uuid,
}
```

**Consommateurs** : GFE Engine (scoring complet), ASCENT Cross-Pollinator, COSMOS (highlight branches).

---

### MUST — seed_viable

**RFC-2119 MUST** : émis quand le PlantScore ≥ γ_seuil (0.40 pour beachhead).

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedViable {
    pub event_id: Uuid,
    pub created_at: i64,
    pub seed_id: Uuid,
    pub viability: f32,
    pub fecundity: f32,
    pub plant_score: f32,
    pub gamma: f32,                   // curseur prudence/ambition (0.6 beachhead)
    pub viability_breakdown: ViabilityBreakdown,
    pub fecundity_breakdown: FecundityBreakdown,
    pub tree_id: Uuid,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ViabilityBreakdown {
    pub feasibility: f32,
    pub alignment: f32,
    pub non_redundancy: f32,
    pub resource_fit: f32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FecundityBreakdown {
    pub potential_subtrees: f32,
    pub strategic_reach: f32,
}
```

**Consommateurs** : SOC Manager Dashboard, RSSI Dashboard, Seed Explorer.

---

### MUST — seed_dormant

**RFC-2119 MUST** : émis quand une Seed passe en DORMANT (stérile ou rejetée ou rétrogradée).

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedDormant {
    pub event_id: Uuid,
    pub created_at: i64,
    pub seed_id: Uuid,
    pub previous_status: SeedStatus,
    pub dormancy_reason: DormancyReason,
    pub previous_plant_score: f32,
    pub can_reactivate: bool,         // true si contexte favorable possible
    pub wake_conditions: Option<WakeConditions>,
    pub tree_id: Uuid,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum DormancyReason {
    Sterile,                  // PlantScore < γ_seuil
    RejectedByManager,        // Manager a rejeté
    ContextChanged,           // Vision Helm a changé, alignement perdu
    GerminationFailed,        // Germination a échoué
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WakeConditions {
    pub min_alignment: f32,           // align ≥ τ pour réactivation
    pub min_context_similarity: f32,  // similarité contexte minimum
}
```

**Consommateurs** : GFE Archive (stockage long terme), Bitemporal Wake Scheduler.

---

### MUST — seed_germinated

**RFC-2119 MUST** : émis quand une Seed passe de GERMINATING à NEW SUBTREE (germination complète).

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedGerminated {
    pub event_id: Uuid,
    pub created_at: i64,
    pub seed_id: Uuid,
    pub new_subtree_id: Uuid,
    pub germination_actor: TreeOpActor,
    pub nodes_created: u32,
    pub edges_created: u32,
    pub tree_id: Uuid,               // arbre parent
}
```

**Consommateurs** : ASCENT Agent-03 (DAG-Architect), COSMOS (rafraîchit le graphe), APEX (nouvelles cartes B11-B14).

---

## 5. SECTION 3 — MASTERY EVENTS

### MUST — mastery_evaluated

**RFC-2119 MUST** : émis après chaque évaluation de maîtrise (scenario, writeup, interview, field_test, evidence).

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MasteryEvaluated {
    pub event_id: Uuid,
    pub created_at: i64,
    pub evaluation_id: Uuid,
    pub learner_id: Uuid,
    pub tree_id: Uuid,
    pub smi_score: f32,               // Skill Mastery Index 0.0–1.0
    pub format: EvaluationFormat,     // "scenario" | "writeup" | "evidence" | "interview" | "field_test"
    pub rubric_criteria: Vec<RubricCriterionScore>,
    pub evaluator: String,            // "ia" | "human" | "hybrid"
    pub affected_nodes: Vec<Uuid>,    // nœuds dont le mastery_score a changé
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum EvaluationFormat {
    Scenario,
    Writeup,
    Evidence,
    Interview,
    FieldTest,
}
```

**Consommateurs** : COSMOS (refresh SMI Radar), Certification Service (Proof of Skill), APEX (FSRS update).

---

### SHOULD — mastery_updated

**RFC-2119 SHOULD** : émis quand le SMI global d'un learner est recalculé (batch update).

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MasteryUpdated {
    pub event_id: Uuid,
    pub created_at: i64,
    pub learner_id: Uuid,
    pub tree_id: Uuid,
    pub global_smi: f32,
    pub smi_by_tactic: HashMap<String, f32>,  // tactic_id → SMI
    pub gaps_detected: Vec<GapInfo>,
    pub coverage_percent: f32,
}
```

---

## 6. SECTION 4 — SCENARIO EVENTS

### MUST — scenario_evaluated

**RFC-2119 MUST** : émis quand un scenario ARENA est évalué (complété ou abandonné).

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ScenarioEvaluated {
    pub event_id: Uuid,
    pub created_at: i64,
    pub scenario_instance_id: Uuid,
    pub learner_id: Uuid,
    pub pack_id: String,
    pub scenario_id: String,
    pub status: ScenarioStatus,       // "completed" | "abandoned"
    pub score: Option<f32>,           // 0.0–1.0 (None si abandonné)
    pub steps_completed: u32,
    pub total_steps: u32,
    pub choices: Vec<ScenarioChoice>,
    pub started_at: i64,
    pub completed_at: Option<i64>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ScenarioChoice {
    pub step_id: Uuid,
    pub choice_id: String,
    pub timestamp: i64,
    pub score_delta: f32,
}
```

**Consommateurs** : ASCENT Agent-05, Certification Service, Manager Dashboard, GFE.

---

## 7. SECTION 5 — PACK EVENTS

### MUST — pack_loaded

**RFC-2119 MUST** : émis quand un Domain Pack est chargé avec succès.

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PackLoaded {
    pub event_id: Uuid,
    pub created_at: i64,
    pub pack_id: String,
    pub version: String,
    pub domain_pack_id: Uuid,
    pub nodes_created: u32,
    pub edges_created: u32,
    pub roles_loaded: Vec<String>,
    pub scenarios_loaded: Vec<String>,
    pub validation_passed: bool,
}
```

### MUST — pack_validation_failed

**RFC-2119 MUST** : émis quand la validation du pack échoue.

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PackValidationFailed {
    pub event_id: Uuid,
    pub created_at: i64,
    pub pack_id: String,
    pub errors: Vec<ValidationError>,
    pub fatal: bool,                  // true = pack rejeté, false = warning
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ValidationError {
    pub error_type: String,           // "orphan_node" | "invalid_edge_kind" | "cycle_detected" | "missing_provider"
    pub node_id: Option<Uuid>,
    pub message: String,
}
```

---

## 8. SECTION 6 — GAP & COVERAGE EVENTS

### SHOULD — gap_detected

**RFC-2119 SHOULD** : émis quand un gap de maîtrise est détecté (pour un learner ou une équipe).

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GapDetected {
    pub event_id: Uuid,
    pub created_at: i64,
    pub learner_id: Option<Uuid>,     // None = gap d'équipe
    pub tree_id: Uuid,
    pub gap_type: GapType,
    pub affected_node_ids: Vec<Uuid>,
    pub severity: GapSeverity,
    pub remediation_suggestion: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum GapType {
    MasteryBelowThreshold,    // mastery < threshold
    PrerequisiteMissing,      // parent pas maîtrisé
    CoverageIncomplete,       // % de l'arbre couvert < objectif
    DriftDetected,            // écart aux SOPs connues
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum GapSeverity {
    Critical,   // bloquant pour certification
    Warning,    // nécessite attention
    Info,       // informatif
}
```

---

## 9. Matrice de Routing (EventBus Consumers)

| Événement | Consommateurs obligatoires | Consommateurs optionnels |
|-----------|---------------------------|-------------------------|
| `TreeOpPlanted` | ASCENT (tous), COSMOS, GFE | — |
| `TreeOpGrafted` | ASCENT Agent-05, GFE | COSMOS |
| `TreeOpPruned` | COSMOS, GFE | ASCENT Agent-03 |
| `TreeOpTested` | ASCENT Adaptive-Router, GFE | APEX |
| `TreeOpMyelinated` | APEX, Certification, GFE | COSMOS |
| `SeedPollinated` | GFE Engine, COSMOS | ASCENT Cross-Pollinator |
| `SeedViable` | Manager Dashboard, Seed Explorer | COSMOS |
| `SeedDormant` | GFE Archive | — |
| `SeedGerminated` | ASCENT Agent-03, COSMOS, APEX | — |
| `MasteryEvaluated` | COSMOS, Certification | Tactical AI |
| `MasteryUpdated` | COSMOS, Manager Dashboard | — |
| `ScenarioEvaluated` | ASCENT all, Manager Dashboard, GFE | Tactical AI |
| `PackLoaded` | ASCENT Agent-02, Semantic Tree Adapter | — |
| `PackValidationFailed` | Admin Alert | — |
| `GapDetected` | Manager Dashboard, Tactical AI | ASCENT Agent-04 |

---

## 10. Ordre et Durabilité

### Ordering Garanti

```
Causal order est garanti par :
- event_id (UUID v7 → timestamp natif triable)
- partition_key = tree_id ou learner_id (événements d'un même arbre ordonnés)
- Consumer Offset : chaque consommateur avance son offset après ACK

Pas de garantie globale entre événements de partitions différentes,
mais causal order INTRA-partition est garanti (same tree_id = same timeline).
```

### DLQ (Dead Letter Queue)

```
Si un événement échoue à être consommé (crash handler, erreur irrécupérable) :
1. L'événement est poussé dans scy_outbox (PostgreSQL)
2. Retry exponentiel : 1s → 2s → 4s → 8s → 16s (max 5 retries)
3. Si 5 retries échouent → DLQ permanente + alerte admin
4. Aucune perte d'événement garantie (Outbox Pattern D-007)
```

### Acknowledgment Levels

| Niveau | Description | Cas d'usage |
|--------|-------------|-------------|
| **Fire-and-Forget** | publish() sans attente | Événements non critiques (metrics) |
| **Persistent** | publish_persistent() avec DLQ | TreeOps, Seeds, Mastery |
| **Ack-Required** | publish_with_ack() bloquant | ScenarioEvaluated, PackLoaded (action utilisateur) |

---

## 11. EVENTBUS CONTRACT — Règles d'Or

```
1. MUST (RFC-2119) : tous les TreeOps (plant/graft/prune/test/myelinate) émettent leur événement avant de retourner au caller
2. MUST : les Seeds émettent SeedPollinated après scoring, SeedViable après validation PlantScore ≥ seuil
3. MUST : un événement ne contient JAMAIS de logique métier — c'est un fait, pas une commande
4. SHOULD : GapDetected est émis au moins une fois par heure par learner (batch)
5. SHOULD : MasteryUpdated est émis après chaque batch d'évaluations (pas après chaque test individuel)
6. MAY : un événement peut transporter des métadonnées arbitraires dans un champ `custom: HashMap<String, JsonValue>`
7. MAY : un consumer peut ignorer un événement (no-op) s'il n'est pas concerné
8. MUST NOT : un consumer ne modifie JAMAIS l'état d'un événement (append-only)
9. MUST NOT : un producer ne fait JAMAIS de supposition sur qui va consommer l'événement
10. MUST NOT : un événement ne contient JAMAIS de terme métier hardcodé (D-024) — le champ `evidence_type` est un String libre pack-défini
```

---

*Fin du document. Ce document RFC-2119 fige les contracts EventBus pour Pilier 1+2+3. Toute PR qui ajoute un nouvel événement doit ajouter son schema dans ce document. Toute divergence est une violation du contrat d'architecture.*

//! # DCID — Domain Contract Interface Definitions
//!
//! Les traits DCID sont les **seuls ponts** entre le core SCYForge et les Domain Packs.
//! D-024 : zéro terme métier en dur dans ces traits. Ce sont des CONTRATS, pas des implémentations.
//! D-019 : SemanticTreeProvider est le pont PRIMARY. Les 9 providers suivants sont OPTIONNELS.
//!
//! Un Domain Pack implémente les traits dont il a besoin.
//! Le core compile contre les traits, jamais contre les implémentations.
//!
//! Réf : `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` D-019/D-020

use serde::{Deserialize, Serialize};
use uuid::Uuid;

pub use crate::semantic_node::{
    AppResult, DomainPackManifest, EdgeKind, HelmAxis, JsonSchema, LearnerNodeState, PackConfig,
    PackEntrypoints, SemanticNode, TestEvidence, Thresholds, TreeOp, TreeOpResult,
};

// === SemanticTreeProvider (PRIMARY) ===

/// Trait PRIMARY — le seul pont obligatoire pour un Domain Pack fonctionnel.
/// D-019/D-024 : le core ne sait RIEN de MITRE, SOC, Sigma, CVE.
/// Tout appel au domaine passe par ce trait.
#[async_trait::async_trait]
pub trait SemanticTreeProvider: Send + Sync {
    // === LECTURE ===

    async fn load_tree(&self, owner_kind: crate::tree::OwnerKind, owner_id: Uuid) -> AppResult<SemanticTree>;

    async fn nodes(&self, tree_id: Uuid, depth: Option<u32>) -> AppResult<Vec<SemanticNode>>;

    async fn live_edges(&self, tree_id: Uuid) -> AppResult<Vec<crate::tree::TreeEdge>>;

    async fn learner_state(&self, learner_id: Uuid, tree_id: Uuid) -> AppResult<Vec<LearnerNodeState>>;

    async fn learner_node_state(&self, learner_id: Uuid, node_id: Uuid) -> AppResult<LearnerNodeState>;

    // === ÉCRITURE (5 opérations canoniques) ===

    async fn plant(&self, tree_id: Uuid, roots: Vec<Uuid>) -> AppResult<TreeOpResult>;

    async fn graft(&self, tree_id: Uuid, parent: Uuid, child: SemanticNode) -> AppResult<TreeOpResult>;

    async fn test(&self, learner_id: Uuid, node_id: Uuid, evidence: TestEvidence) -> AppResult<TreeOpResult>;

    async fn prune(&self, tree_id: Uuid, node_ids: Vec<Uuid>, reason: String) -> AppResult<TreeOpResult>;

    async fn myelinate(&self, learner_id: Uuid, node_id: Uuid) -> AppResult<TreeOpResult>;

    // === GATING ===

    async fn is_unlockable(&self, learner_id: Uuid, node_id: Uuid) -> AppResult<bool>;

    // === CONFIG PACK (EXTENSIBLE FIRST) ===

    async fn pack_config(&self) -> AppResult<PackConfig>;
}

// === SemanticTree (wrapper avec legacy compat) ===

/// L'arbre sémantique — wrapper autour de `tree::SemanticTree` avec owner_kind pack-friendly.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SemanticTree {
    pub id: Uuid,
    pub owner_kind: crate::tree::OwnerKind,
    pub owner_id: Uuid,
    pub domain_pack_id: Uuid,
    pub domain_pack: String,
    pub root_nodes: Vec<Uuid>,
    pub root_node_id: Option<Uuid>,
    pub created_at: i64,
}

// === 9 Providers optionnels (interfaces seulement) ===

// --- OntologyProvider ---

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Concept {
    pub id: Uuid,
    pub label: String,
    pub definition: String,
    pub metadata: serde_json::Value,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Relation {
    pub id: Uuid,
    pub source_id: Uuid,
    pub target_id: Uuid,
    pub relation_type: String,
    pub weight: f32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ValidationResult {
    pub valid: bool,
    pub errors: Vec<String>,
}

#[async_trait::async_trait]
pub trait OntologyProvider: Send + Sync {
    async fn concepts(&self) -> AppResult<Vec<Concept>>;
    async fn relations(&self) -> AppResult<Vec<Relation>>;
    async fn validate(&self, concept: &Concept) -> AppResult<ValidationResult>;
}

// --- CorpusProvider ---

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Source {
    pub id: Uuid,
    pub core: String,
    pub url: Option<String>,
    pub raw_content: String,
    pub metadata: serde_json::Value,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Chunk {
    pub id: Uuid,
    pub source_id: Uuid,
    pub text: String,
    pub embedding: Option<Vec<f32>>,
    pub position: i32,
}

#[async_trait::async_trait]
pub trait CorpusProvider: Send + Sync {
    async fn sources(&self) -> AppResult<Vec<Source>>;
    async fn chunks(&self, source_id: Uuid) -> AppResult<Vec<Chunk>>;
    async fn is_up_to_date(&self) -> AppResult<bool>;
}

// --- RoleTaxonomyProvider ---

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Role {
    pub id: String,
    pub display_name: String,
    pub description: String,
    pub required_tactics: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RoleSubtree {
    pub role_id: String,
    pub tree_id: Uuid,
    pub required_node_ids: Vec<Uuid>,
    pub mastery_threshold: f32,
    pub criticality_overrides: serde_json::Value,
}

#[async_trait::async_trait]
pub trait RoleTaxonomyProvider: Send + Sync {
    async fn roles(&self) -> AppResult<Vec<Role>>;
    async fn role_subtree(&self, role_id: &str, tree_id: Uuid) -> AppResult<RoleSubtree>;
    async fn required_nodes(&self, role_id: &str, tree_id: Uuid) -> AppResult<Vec<Uuid>>;
}

// --- DecisionScenarioProvider ---

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Scenario {
    pub id: String,
    pub pack_id: String,
    pub display_name: String,
    pub format: String,
    pub difficulty: f32,
    pub estimated_minutes: i32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ScenarioStep {
    pub id: String,
    pub scenario_id: String,
    pub step_index: i32,
    pub prompt: String,
    pub choices: Vec<Choice>,
    pub correct_choice_id: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Choice {
    pub id: String,
    pub label: String,
    pub consequence: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EvaluationResult {
    pub correct: bool,
    pub score: f32,
    pub feedback: String,
}

#[async_trait::async_trait]
pub trait DecisionScenarioProvider: Send + Sync {
    async fn scenarios(&self) -> AppResult<Vec<Scenario>>;
    async fn scenario_steps(&self, scenario_id: &str) -> AppResult<Vec<ScenarioStep>>;
    async fn evaluate_choice(
        &self,
        scenario_id: &str,
        step_id: &str,
        choice: &Choice,
    ) -> AppResult<EvaluationResult>;
}

// --- ProofRubricProvider ---

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Rubric {
    pub id: String,
    pub format: String,
    pub criteria: Vec<RubricCriterion>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RubricCriterion {
    pub id: String,
    pub description: String,
    pub max_score: f32,
    pub weight: f32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Submission {
    pub learner_id: Uuid,
    pub rubric_id: String,
    pub scores: Vec<CriterionScore>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CriterionScore {
    pub criterion_id: String,
    pub score: f32,
    pub evidence: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProofResult {
    pub passed: bool,
    pub verdict: crate::tree::LegacyTreeOp, // TODO: replace with proper Verdict enum
    pub total_score: f32,
    pub max_score: f32,
}

#[async_trait::async_trait]
pub trait ProofRubricProvider: Send + Sync {
    async fn rubric(&self, format: &str) -> AppResult<Rubric>;
    async fn validate_submission(&self, rubric: &Rubric, submission: &Submission) -> AppResult<ProofResult>;
    async fn verdict(&self, score: f32) -> AppResult<ProofResult>;
}

// --- RetentionPolicyProvider ---

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SrsState {
    pub stability: f32,
    pub difficulty: f32,
    pub interval_days: f32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Review {
    pub node_id: Uuid,
    pub scheduled_at: i64,
    pub review_type: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ReviewSchedule {
    pub reviews: Vec<Review>,
    pub next_review_at: i64,
}

#[async_trait::async_trait]
pub trait RetentionPolicyProvider: Send + Sync {
    async fn review_schedule(&self, node_id: Uuid, learner_id: Uuid) -> AppResult<ReviewSchedule>;
    async fn next_review(&self, srs_state: &SrsState) -> AppResult<Option<Review>>;
}

// --- ValidationGuardProvider ---

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GeneratedOutput {
    pub output_type: String,
    pub content: String,
    pub sources: Vec<Source>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HallucinationResult {
    pub is_safe: bool,
    pub claims_checked: i32,
    pub unsupported_claims: Vec<String>,
}

#[async_trait::async_trait]
pub trait ValidationGuardProvider: Send + Sync {
    async fn validate_output(&self, output: &GeneratedOutput) -> AppResult<ValidationResult>;
    async fn hallucination_check(&self, claim: &str, sources: &[Source]) -> AppResult<HallucinationResult>;
}

// === PackConfigProvider (EXTENSIBLE) ===

#[async_trait::async_trait]
pub trait PackConfigProvider: Send + Sync {
    /// Retourne la config du pack.
    /// D-024 : Si le pack n'a pas de config → retourne None.
    /// Le core NE fait JAMAIS de fallback silencieux vers des valeurs hardcodées.
    async fn config(&self) -> AppResult<Option<PackConfig>>;

    /// Retourne les seuils pour un rôle donné (ou global si None).
    async fn thresholds(&self, role_id: Option<&str>) -> AppResult<Thresholds>;

    /// Retourne les poids SMI (doivent sommer à 1.0).
    async fn smi_weights(&self) -> AppResult<[f32; 5]>;
}

// === PackJsonSchemaProvider (EXTENSIBLE) ===

#[async_trait::async_trait]
pub trait PackJsonSchemaProvider: Send + Sync {
    /// Retourne le schéma JSONB pour metadata des nœuds.
    /// D-024 : Si None → le core accepte tout JSONB valide (pas de validation).
    async fn node_metadata_schema(&self) -> AppResult<Option<JsonSchema>>;

    /// Retourne le schéma JSONB pour rubric_criteria.
    async fn rubric_criteria_schema(&self) -> AppResult<Option<JsonSchema>>;

    /// Retourne le schéma JSONB pour metadata d'une opération d'arbre.
    async fn tree_operation_metadata_schema(&self, operation: TreeOp) -> AppResult<Option<JsonSchema>>;
}

// === ScoringFn (EXTENSIBLE — GFE Pilier 3 bridge) ===

/// Fonction de scoring pluggable par pack.
/// D-024 : le core appelle cette fonction, il ne sait pas ce qu'elle calcule.
pub trait ScoringFn<V> {
    fn calculate(&self, value: V) -> f32;
}

// === DistanceFn (EXTENSIBLE — GFE Pilier 3 bridge) ===

/// Fonction de distance pluggable par pack.
/// D-024 : le core appelle cette fonction, il ne sait pas comment elle calcule la distance.
pub trait DistanceFn<A, B> {
    fn distance(&self, a: &A, b: &B) -> f32;
}

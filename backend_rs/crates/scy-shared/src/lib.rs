//! # scy-shared
//!
//! Types, erreurs, helpers et configuration partagés par tous les crates SCY Forge.
//!
//! Ce crate est la **fondation bottom-up** (Sprint 0) : tous les services transverses
//! (`scy-eventbus`, `scy-ingestion`, `scy-neuron-chains`...) en dépendent.
//!
//! Réf : `docs/PROJECT_STRUCTURE.md` §2 (scy-shared), `docs/CODE_STYLE.md`

pub mod config;
pub mod errors;
pub mod ids;
pub mod ports;
pub mod semantic_node;
pub mod tree;
pub mod types;

pub use config::Config;
pub use errors::AppError;
pub use ids::new_id;
pub use ports::{SemanticTreeProvider, TreeOpResult};

// === Nouveaux types canoniques (Pilier 1 model v2) ===
// Ces types sont la source de vérité post-HITL.
// tree.rs contient les types legacy en cours de migration.
pub use semantic_node::{
    AppResult, DomainPackManifest, EdgeKind as SemanticEdgeKind, HierarchyKind, HelmAxis,
    JsonSchema, LearnerNodeState as SemanticLearnerNodeState, PackCapabilities, PackConfig,
    PackEntrypoints, RelationKind, RoleThreshold, SemanticNode, TestEvidence, Thresholds,
    TreeOp as SemanticTreeOp, TreeOpResult as SemanticTreeOpResult,
};

pub use tree::{
    EdgeKind as LegacyEdgeKind, LearnerNodeState as LegacyLearnerNodeState, MASTERY_THRESHOLD,
    OwnerKind, SemanticTree, TreeEdge as LegacyTreeEdge, TreeOp as LegacyTreeOp,
};
pub use types::{Card, Concept, Goal, Node, Source, User};

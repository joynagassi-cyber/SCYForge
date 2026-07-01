//! # Ports (architecture hexagonale)
//!
//! Définit les **interfaces** (ports) que les adaptateurs (Postgres, Graphiti/Zep, in-memory…)
//! devront implémenter. Le noyau dépend de ces traits, jamais d'une techno concrète.
//!
//! Réf : `docs/SCYFORGE_SEMANTIC_TREE_INFRASTRUCTURE.md` §10,
//!       `minddoc/s00_architecture_standards/scy_service_architecture_map.md`.

use crate::errors::AppError;
use crate::tree::{LearnerNodeState, SemanticTree, TreeEdge, TreeOp};
use crate::types::Node;

/// Résultat d'une opération d'arbre. Compact en interne (RCL `compress inside`),
/// justifiable en externe (`justify outside`).
#[derive(Debug, Clone)]
pub struct TreeOpResult {
    pub op: TreeOp,
    /// Nœuds affectés par l'opération.
    pub affected_nodes: Vec<uuid::Uuid>,
    /// Justification auditable (manager-ready) — externe.
    pub justification: String,
}

/// Port du Semantic Tree : les cinq opérations canoniques (Plant/Graft/Test/Prune/Myelinate)
/// + lecture de l'arbre et de l'état apprenant.
///
/// `async_trait` est attendu côté implémentation ; ici on garde des signatures sync-friendly
/// au niveau type (les adaptateurs peuvent envelopper en async via `async_trait`).
pub trait SemanticTreeProvider {
    /// Charge un arbre (Pack / Organization / Learner).
    fn load_tree(&self, tree_id: uuid::Uuid) -> Result<SemanticTree, AppError>;

    /// Liste les nœuds d'un arbre.
    fn nodes(&self, tree_id: uuid::Uuid) -> Result<Vec<Node>, AppError>;

    /// Liste les arêtes **vivantes** (superseded_at == None) d'un arbre.
    fn live_edges(&self, tree_id: uuid::Uuid) -> Result<Vec<TreeEdge>, AppError>;

    /// **Plant** : pose les troncs (3–7 racines 80/20) d'un arbre.
    fn plant(&self, tree_id: uuid::Uuid, trunks: &[Node]) -> Result<TreeOpResult, AppError>;

    /// **Graft** : greffe un nœud neuf sous un parent existant.
    /// Échoue si le parent n'est pas assez mûr (verrou tronc-avant-feuilles).
    fn graft(
        &self,
        tree_id: uuid::Uuid,
        parent: uuid::Uuid,
        child: &Node,
        criticality: f32,
    ) -> Result<TreeOpResult, AppError>;

    /// **Prune** : historise une arête obsolète/contradictoire (anneau de croissance).
    fn prune(&self, edge_id: uuid::Uuid, at: i64) -> Result<TreeOpResult, AppError>;

    /// État apprenant d'un nœud (confiance prouvée + verrou de déverrouillage).
    fn learner_state(
        &self,
        learner_tree_id: uuid::Uuid,
        node_id: uuid::Uuid,
    ) -> Result<LearnerNodeState, AppError>;

    /// Vrai si toutes les branches parentes de `node_id` sont maîtrisées (SMI ≥ seuil).
    /// Garantit *tronc avant feuilles* au niveau runtime.
    fn is_unlockable(
        &self,
        learner_tree_id: uuid::Uuid,
        node_id: uuid::Uuid,
    ) -> Result<bool, AppError>;
}

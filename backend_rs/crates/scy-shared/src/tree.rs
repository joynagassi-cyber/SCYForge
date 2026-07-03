//! # Semantic Tree — objets système de premier ordre
//!
//! Le Semantic Tree est le **substrat unique** de SCYForge : un même invariant
//! structure (a) le cerveau de l'apprenant, (b) le savoir vivant de l'organisation,
//! et (c) l'architecture interne du produit.
//!
//! Réf : `docs/SCYFORGE_SEMANTIC_TREE_INFRASTRUCTURE.md`.
//!
//! D-024 (Extensible First) : zéro terme métier en dur.
//! - `OwnerKind` est générique (DomainPack / Organization / Learner)
//! - `EdgeKind` est composite (Hierarchical | Relational) — les variantes pack-spécifiques
//!   sont gérées par le pack, pas par le core.
//! - `MASTERY_THRESHOLD` retiré du core — le seuil vient du pack via PackConfig (HITL Q8).
//!   Les types canoniques sont désormais dans `semantic_node.rs`.

use serde::{Deserialize, Serialize};

/// À qui appartient un arbre. Un seul type `SemanticTree`, trois instances.
///
/// `Diff(Organization) − Diff(DomainPack) = la valeur privée irréductible` de l'entreprise.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum OwnerKind {
    /// Arbre canonique d'un domaine (ex. cyber dérivé d'ATT&CK + Sigma). Partagé.
    DomainPack,
    /// Arbre de l'organisation = arbre du pack + greffons privés (incidents, règles internes).
    Organization,
    /// Projection maîtrisée de l'arbre d'organisation dans une tête (confidence propre).
    Learner,
}

/// Nature d'une arête de l'arbre.
///
/// D-024 : EdgeKind est composite. Les variantes pack-spécifiques sont gérées en metadata.
/// L'arbre porte la **pédagogie** (Trunk/Branch/Leaf) ; les **lianes**
/// (Prereq/Relates/Contradicts/Supersedes) portent la réalité opérationnelle.
///
/// NOTE : Cette definition legacy est conservée pour compatibilité.
/// La definition cano nique post-HITL est `semantic_node::EdgeKind` (composite Hierarchical | Relational).
/// Migration : `LegacyEdgeKind` → `SemanticEdgeKind` (semantic_node.rs).
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum LegacyEdgeKind {
    /// Racine d'un domaine : pas de parent (le tronc, le 80/20).
    Trunk,
    /// Parent = nœud d'arbre (sous-domaine).
    Branch,
    /// Parent = nœud, cible = concept opérable (le détail).
    Leaf,
    /// Liane bloquante : `from` doit précéder `to` (séquence pédagogique).
    Prereq,
    /// Liane transverse non bloquante.
    Relates,
    /// Conflit à arbitrer (signalé par DRIFT-GUARDIAN).
    Contradicts,
    /// Remplacement versionné : `from` supersède `to` (anneau de croissance).
    Supersedes,
}

/// Une arête de l'arbre = relation typée entre deux nœuds, pondérée par criticité.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LegacyTreeEdge {
    pub id: uuid::Uuid,
    /// L'arbre auquel appartient l'arête (par apprenant OU organisation OU pack).
    pub tree_id: uuid::Uuid,
    pub from_node: uuid::Uuid,
    pub to_node: uuid::Uuid,
    pub kind: LegacyEdgeKind,
    /// Pondération 80/20 : poids du chemin (0.0–1.0). En cyber, dérivé de la densité Sigma.
    pub criticality: f32,
    pub created_at: i64,
    /// `None` = arête vivante ; `Some(ts)` = historisée (anneau de croissance).
    pub superseded_at: Option<i64>,
}

/// L'arbre sémantique : substrat unique, décliné en trois `OwnerKind` sans changer de type.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SemanticTree {
    pub id: uuid::Uuid,
    pub owner_kind: OwnerKind,
    pub owner_id: uuid::Uuid,
    /// Les troncs (nœuds-racines sans parent).
    pub root_nodes: Vec<uuid::Uuid>,
    /// Le pack de domaine source ("cyber" pour le wedge).
    pub domain_pack: String,
    pub created_at: i64,
}

/// Confiance par nœud **propre à un apprenant** (projection `Learner`).
///
/// D-024 : `confidence` est la source de vérité. `mastery_score` et `status` sont DÉRIVÉS.
/// Le seuil de maîtrise vient du pack (PackConfig.mastery_threshold), pas d'une constante core.
///
/// NOTE : Cette definition legacy est conservée pour compatibilité.
/// La definition cano nique post-HITL est `semantic_node::SemanticLearnerNodeState` avec
/// mastery_score et status comme colonnes GENERATED ALWAYS AS (STORED).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LegacyLearnerNodeState {
    pub learner_tree_id: uuid::Uuid,
    pub node_id: uuid::Uuid,
    /// Confiance maîtrisée 0.0–1.0 (prouvée par test, pas par couverture visuelle).
    pub confidence: f32,
    /// `true` une fois la branche parente franchie.
    pub unlocked: bool,
    pub last_reviewed_at: i64,
}

// NOTE: MASTERY_THRESHOLD retiré du core (HITL Q8 validé par utilisateur).
// Le seuil de maîtrise vient du pack via PackConfig.mastery_threshold.
// Si pack_config() == None → MissingPackConfig error (jamais de fallback silencieux).
//
// Ancienne constante (retirée) :
// pub const MASTERY_THRESHOLD: f32 = 0.70;

impl LegacyLearnerNodeState {
    /// Vérifie si le nœud est maîtrisé — nécessite le seuil du pack.
    /// D-024 : pas de constante hardcodée. Appeler avec mastery_threshold du pack.
    pub fn is_mastered_with_threshold(&self, mastery_threshold: f32) -> bool {
        self.confidence >= mastery_threshold
    }
}

/// Les cinq opérations canoniques de construction d'arbre (mappées sur ASCENT).
///
/// - `Plant`     : poser 3–7 troncs (80/20) avant tout détail.
/// - `Graft`     : suspendre un nœud neuf à un parent **déjà solide**.
/// - `Test`      : faire **reconstruire** la branche (active recall / teach-back).
/// - `Prune`     : élaguer branches mortes / mal accrochées (drift).
/// - `Myelinate` : répétition espacée le long des branches critiques.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum LegacyTreeOp {
    Plant,
    Graft,
    Test,
    Prune,
    Myelinate,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn mastery_threshold_gates_unlock() {
        // NOTE : test adapté — utilise un seuil fourni en paramètre (pas de constante core).
        let below = LegacyLearnerNodeState {
            learner_tree_id: uuid::Uuid::nil(),
            node_id: uuid::Uuid::nil(),
            confidence: 0.69,
            unlocked: false,
            last_reviewed_at: 0,
        };
        assert!(!below.is_mastered_with_threshold(0.70));

        let at = LegacyLearnerNodeState {
            confidence: 0.70,
            ..below.clone()
        };
        assert!(at.is_mastered_with_threshold(0.70));
    }

    #[test]
    fn owner_kind_serialization() {
        let kind = OwnerKind::DomainPack;
        let json = serde_json::to_string(&kind).unwrap();
        assert_eq!(json, "\"domain_pack\"");
    }

    #[test]
    fn edge_kind_composite_roundtrip() {
        use crate::semantic_node::{EdgeKind, HierarchyKind, RelationKind};

        let edge = EdgeKind::Hierarchical(HierarchyKind::Trunk);
        let json = serde_json::to_string(&edge).unwrap();
        let restored: EdgeKind = serde_json::from_str(&json).unwrap();
        assert!(restored.is_hierarchical());

        let rel = EdgeKind::Relational(RelationKind::Prereq);
        let json2 = serde_json::to_string(&rel).unwrap();
        let restored2: EdgeKind = serde_json::from_str(&json2).unwrap();
        assert!(restored2.is_relational());
    }
}


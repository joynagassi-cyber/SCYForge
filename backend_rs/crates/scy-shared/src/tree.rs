//! # Semantic Tree — objets système de premier ordre
//!
//! Le Semantic Tree est le **substrat unique** de SCYForge : un même invariant
//! structure (a) le cerveau de l'apprenant, (b) le savoir vivant de l'organisation,
//! et (c) l'architecture interne du produit.
//!
//! Réf : `docs/SCYFORGE_SEMANTIC_TREE_INFRASTRUCTURE.md`.
//!
//! Extension **non destructive** : on ne touche pas à `Node` / `Concept` (cf. `types.rs`).
//! - `Node`    reste le nœud d'arbre (tronc / branche) ; `Node.confidence` est le verrou
//!             *tronc-avant-feuilles* déjà présent.
//! - `Concept` reste la feuille atomique rattachée à un nœud.
//! - Ici on ajoute les **arêtes typées**, l'**arbre** et ses trois instances.

use serde::{Deserialize, Serialize};

/// À qui appartient un arbre. Un **seul** type `SemanticTree`, trois instances.
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
/// L'arbre porte la **pédagogie** (Trunk/Branch/Leaf) ; les **lianes**
/// (Prereq/Relates/Contradicts/Supersedes) portent la réalité opérationnelle.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum EdgeKind {
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
pub struct TreeEdge {
    pub id: uuid::Uuid,
    /// L'arbre auquel appartient l'arête (par apprenant OU organisation OU pack).
    pub tree_id: uuid::Uuid,
    pub from_node: uuid::Uuid,
    pub to_node: uuid::Uuid,
    pub kind: EdgeKind,
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
/// Gouverne le verrou *tronc-avant-feuilles* : on ne déverrouille une feuille que si
/// la branche parente atteint `MASTERY_THRESHOLD`.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LearnerNodeState {
    pub learner_tree_id: uuid::Uuid,
    pub node_id: uuid::Uuid,
    /// Confiance maîtrisée 0.0–1.0 (prouvée par test, pas par couverture visuelle).
    pub confidence: f32,
    /// `true` une fois la branche parente franchie.
    pub unlocked: bool,
    pub last_reviewed_at: i64,
}

/// Seuil de maîtrise SMI (Skill Mastery Index) — partagé tout le système (cf. promesse ASCENT).
pub const MASTERY_THRESHOLD: f32 = 0.70;

impl LearnerNodeState {
    /// Une branche est maîtrisée si sa confiance prouvée franchit le seuil SMI.
    #[must_use]
    pub fn is_mastered(&self) -> bool {
        self.confidence >= MASTERY_THRESHOLD
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
pub enum TreeOp {
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
        let below = LearnerNodeState {
            learner_tree_id: uuid::Uuid::nil(),
            node_id: uuid::Uuid::nil(),
            confidence: 0.69,
            unlocked: false,
            last_reviewed_at: 0,
        };
        assert!(!below.is_mastered());

        let at = LearnerNodeState {
            confidence: 0.70,
            ..below.clone()
        };
        assert!(at.is_mastered());
    }
}

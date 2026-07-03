//! # Semantic Node — Types du Pilier 1 (Semantic Tree + DCID)
//!
//! Ce module définit les types canoniques du Semantic Tree.
//! D-024 : zéro terme métier en dur. Tout ce qui est domaine-spécifique vit dans les packs.
//! D-023 : Extensible First — les enums sont #[non_exhaustive], les champs JSONB sont ouverts.

use serde::{Deserialize, Serialize};
use uuid::Uuid;

// === AppResult — alias générique ===

/// Résultat d'une opération — alias générique (pas de AppError métier en dur).
pub type AppResult<T> = Result<T, crate::errors::AppError>;

// === SemanticNode — Le nœud de l'arbre sémantique ===

/// Nœud de l'arbre sémantique — entité canonique du Pilier 1.
/// D-024 : ce struct ne contient AUCUN terme métier en dur.
/// `metadata` et `kind` sont extensibles par pack.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SemanticNode {
    /// Identifiant unique du nœud
    pub id: Uuid,
    /// Arbre auquel ce nœud appartient
    pub tree_id: Uuid,
    /// Nœud parent (None = racine/trunk)
    pub parent_id: Option<Uuid>,
    /// Position dans la hiérarchie (0 = trunk racine)
    pub depth: u32,
    /// Titre lisible — défini par le pack
    pub title: String,
    /// Résumé sémantique du nœud
    pub summary: String,
    /// Indice de confiance du learner sur ce nœud (0.0–1.0)
    /// Source de vérité unique.
    pub confidence: f32,
    /// Métadonnées pack-spécifiques (JSONB ouvert)
    /// D-024 : le core ne sait pas ce qu'il y a dedans.
    pub metadata: serde_json::Value,
    /// Timestamp de création (Unix epoch seconds)
    pub created_at: i64,
}

// === HierarchyKind — Position dans la hiérarchie arborescente ===

/// Position hiérarchique d'un nœud dans l'arbre.
/// D-024 : #[non_exhaustive] — les packs peuvent ajouter des variantes via serde tag.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[non_exhaustive]
#[serde(rename_all = "snake_case")]
pub enum HierarchyKind {
    /// Racine de l'arbre (80/20 — tronc principal)
    Trunk,
    /// Branche intermédiaire (sous-domaine)
    Branch,
    /// Feuille opérable (concept atomique)
    Leaf,
    // Les packs peuvent ajouter via serde tag dans leur propre enum étendu.
    // Ex cyber : Technique, SubTechnique
    // Ex medical : Symptom, Diagnosis, Treatment
}

// === RelationKind — Type de relation entre nœuds ===

/// Nature d'une relation sémantique entre deux nœuds.
/// D-024 : #[non_exhaustive] — les packs peuvent ajouter des variantes.
/// Différent de HierarchyKind : relation != position.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[non_exhaustive]
#[serde(rename_all = "snake_case")]
pub enum RelationKind {
    /// Bloquant : `from` doit être maîtrisé avant `to`
    Prereq,
    /// Non-bloquant : lien transverse
    Relates,
    /// Conflit à arbitrer (DRIFT-GUARDIAN signale)
    Contradicts,
    /// Remplacement versionné (growth ring)
    Supersedes,
    // Les packs peuvent ajouter via serde tag dans leur propre enum étendu.
    // Ex cyber : Enables, Detects
    // Ex medical : Contraindicates, Follows
}

// === EdgeKind — Composite (hiérarchie ∪ relation) ===

/// Type d'arête = hiérarchie OU relation. Jamais les deux.
/// D-024 : composite. Le core traite Hierarchical et Relational.
/// Toute autre variante est opaque pour le core (conservé en metadata) et traité par le pack.
/// Les packs gèrent leurs propres variants côté pack — pas dans le core (HITL Q1 résolu).
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(tag = "type", content = "value")]
pub enum EdgeKind {
    /// Hiérarchie arborescente (position dans le STB)
    Hierarchical(HierarchyKind),
    /// Relations sémantiques (connexions transverses)
    Relational(RelationKind),
}

impl EdgeKind {
    /// Vérifie si c'est une arête hiérarchique.
    pub fn is_hierarchical(&self) -> bool {
        matches!(self, EdgeKind::Hierarchical(_))
    }

    /// Vérifie si c'est une arête relationnelle.
    pub fn is_relational(&self) -> bool {
        matches!(self, EdgeKind::Relational(_))
    }
}

// === EdgeKind serde helpers ===

impl HierarchyKind {
    /// Convertit en string pour stockage SQL (hierarchical_trunk, hierarchical_branch, hierarchical_leaf)
    pub fn as_str(&self) -> &'static str {
        match self {
            HierarchyKind::Trunk => "hierarchical_trunk",
            HierarchyKind::Branch => "hierarchical_branch",
            HierarchyKind::Leaf => "hierarchical_leaf",
        }
    }
}

impl RelationKind {
    /// Convertit en string pour stockage SQL (relational_prereq, relational_relates, etc.)
    pub fn as_str(&self) -> &'static str {
        match self {
            RelationKind::Prereq => "relational_prereq",
            RelationKind::Relates => "relational_relates",
            RelationKind::Contradicts => "relational_contradicts",
            RelationKind::Supersedes => "relational_supersedes",
        }
    }
}

// === LearnerNodeState — État d'un nœud pour un learner ===

/// État d'un nœud pour un learner donné.
/// D-024 : `confidence` est la source de vérité. `mastery_score` et `status` sont DÉRIVÉS.
/// En SQL : `mastery_score` et `status` sont des colonnes GENERATED ALWAYS AS (STORED).
/// Si pack_config() == None → erreur MissingPackConfig (pas de fallback silencieux, HITL Q8).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LearnerNodeState {
    pub id: Uuid,
    pub learner_id: Uuid,
    pub tree_id: Uuid,
    pub node_id: Uuid,
    // --- Source de vérité ---
    pub confidence: f32,    // 0.0–1.0 (proven by test)
    // --- Dérivés (STORED en SQL, recalculés par trigger pack-défini si besoin) ---
    pub mastery_score: f32, // DÉRIVÉ : confidence mappé sur échelle SMI
    pub status: String,     // DÉRIVÉ : "locked" | "ready" | "studying" | "mastered"
    // --- Gating ---
    pub unlocked: bool,     // true = prérequis satisfaits (trunk-before-leaves)
    pub unlockable: bool,   // true = peut être débloqué maintenant
    // --- Temporalité ---
    pub last_reviewed_at: Option<i64>,
    pub created_at: i64,
    pub updated_at: i64,
}

// NOTE: MASTERY_THRESHOLD retiré du core (HITL Q8).
// Le seuil vient du pack via PackConfig.mastery_threshold.
// Si le pack n'a pas de config → MissingPackConfig error.

impl LearnerNodeState {
    /// Vérifie si le nœud est maîtrisé — nécessite le seuil du pack (pas de constante hardcodée).
    /// D-024 : cette méthode nécessite PackConfig. Sans config → erreur.
    pub fn is_mastered(&self, mastery_threshold: f32) -> bool {
        self.confidence >= mastery_threshold
    }

    /// Vérifie si tous les ancêtres sont maîtrisés (pour is_unlockable).
    /// D-024 : la logique de déblocage (un seul parent vs tous) est pack-définie.
    /// Cette méthode vérifie TOUS les ancêtres — le pack peut override via trait.
    pub fn are_all_ancestors_mastered(
        &self,
        ancestor_states: &[LearnerNodeState],
        mastery_threshold: f32,
    ) -> bool {
        ancestor_states.iter().all(|ancestor| ancestor.is_mastered(mastery_threshold))
    }
}

// === TreeOp — Les 5 opérations canoniques ===

/// Les 5 opérations canoniques sur un Semantic Tree.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum TreeOp {
    Plant,      // Créer 3–7 troncs (80/20) avant tout détail
    Graft,      // Greffer un nœud sous un parent déjà solide
    Test,       // Évaluer un learner sur un nœud (active recall / teach-back)
    Prune,      // Élaguer branches mortes / désalignées (drift)
    Myelinate,  // Espacer révisions sur branches critiques (FSRS)
}

// === TreeOpResult — Résultat d'une opération ===

/// Résultat d'une opération (Plant/Graft/Test/Prune/Myelinate).
#[derive(Debug, Clone)]
pub struct TreeOpResult {
    pub operation: TreeOp,
    /// Nœuds impactés par l'opération
    pub affected_nodes: Vec<Uuid>,
    /// Justification auditable (pour EventBus + audit log)
    pub justification: String,
}

// === TestEvidence — Preuve d'évaluation d'un nœud ===

/// Preuve qu'un learner a été évalué sur un nœud.
/// D-024 : `evidence_type` est une String libre — chaque pack définit ses types (HITL Q4 validé).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TestEvidence {
    pub node_id: Uuid,
    pub learner_id: Uuid,
    /// Score brut de l'évaluation (0.0–1.0)
    pub score: f32,
    /// Résultats par critère — pack-défini
    pub rubric_results: serde_json::Value,
    /// Timestamp de l'évaluation (Unix epoch)
    pub timestamp: i64,
    /// Type d'évidence — STRING LIBRE, pack-défini. Pas d'enum fermé (D-024).
    /// Ex cyber : "apt29_scenario", "sigma_rule_validation"
    /// Ex medical : "case_study", "simulation_patient"
    pub evidence_type: String,
    /// Qui a évalué : "ia" | "human" | "hybrid"
    pub evaluated_by: String,
    /// Métadonnées additionnelles — pack-défini
    pub metadata: serde_json::Value,
}

// === PackConfig — Configuration pack-définie (EXTENSIBLE) ===

/// Configuration d'un Domain Pack — définie par le pack, consommée par le core.
/// D-024 : le core ne sait pas ce qu'il y a dedans. Il demande la config, il ne la définit pas.
/// PackConfigProvider (trait) = le contrat ; PackConfig (struct) = la donnée (HITL Q5 clarifié).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PackConfig {
    /// Seuil de maîtrise par défaut (override par rôle dans role_subtrees)
    /// D-024 : zéro 0.70 hardcodé. Le pack définit sa valeur.
    pub mastery_threshold: f32,
    /// Poids des 5 dimensions SMI (doivent sommer à 1.0)
    pub smi_weights: [f32; 5],
    /// Formule de calcul de criticalité — le pack fournit une fonction, le core l'appelle
    pub criticality_formula: String,
    /// Axes du Vision Helm (pour GFE Pilier 3) — pack-définis
    pub helm_axes: Vec<HelmAxis>,
    /// Schéma JSONB pour metadata des nœuds (validation par PackJsonSchemaProvider)
    pub node_metadata_schema: Option<serde_json::Value>,
    /// Schéma JSONB pour rubric_criteria des évaluations
    pub rubric_schema: Option<serde_json::Value>,
    // --- EXTENSIBLE : HashMap ouvert pour params pack-spécifiques ---
    /// D-024 : tout ce qui n'est pas dans les champs typés vit ici.
    pub custom: std::collections::HashMap<String, serde_json::Value>,
}

/// Axe du Vision Helm — pack-défini.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HelmAxis {
    /// Nom de l'axe (ex: "DetectionRate")
    pub name: String,
    /// Poids dans le vecteur h
    pub weight: f32,
    /// Comment calculer cet axe : "embedding" | "metric" | "manual"
    pub source: String,
}

// === PackCapabilities — Ce que le pack implémente ===

/// Capacités implémentées par un Domain Pack.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PackCapabilities {
    pub ontology: bool,
    pub corpus: bool,
    pub role_taxonomy: bool,
    pub decision_scenario: bool,
    pub proof_rubric: bool,
    pub retention_policy: bool,
    pub validation_guard: bool,
    pub pack_config: bool,
    pub json_schemas: bool,
}

/// Entrées (chemins vers les adapters) d'un Domain Pack.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PackEntrypoints {
    pub semantic_tree_provider: String,
    pub ontology_provider: Option<String>,
    pub corpus_provider: Option<String>,
    pub role_taxonomy_provider: Option<String>,
    pub decision_scenario_provider: Option<String>,
    pub proof_rubric_provider: Option<String>,
    pub retention_policy_provider: Option<String>,
    pub validation_guard_provider: Option<String>,
    pub pack_config_provider: Option<String>,
    pub json_schema_provider: Option<String>,
}

/// Manifest complet d'un Domain Pack.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DomainPackManifest {
    pub pack_id: String,
    pub version: String,
    pub display_name: String,
    pub core_api_version: String,
    pub domain_id: String,
    pub pivot_ontology: Option<String>,
    pub provides: PackCapabilities,
    pub entrypoints: PackEntrypoints,
    pub data_sovereignty: String,
    pub license: String,
    pub custom_metadata: std::collections::HashMap<String, serde_json::Value>,
}

// === Thresholds — Seuils pack-définis ===

/// Seuils de maîtrise par rôle — pack-définis.
/// D-024 : le core ne définit aucun seuil. Il demande au pack.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Thresholds {
    /// Seuil global (override par rôle)
    pub global_threshold: f32,
    /// Overrides par rôle (optionnel)
    pub role_overrides: std::collections::HashMap<String, RoleThreshold>,
}

/// Seuil pour un rôle spécifique.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RoleThreshold {
    pub mastery_threshold: f32,
    pub tactics_required: Vec<String>,
}

impl Thresholds {
    /// Retourne le seuil pour un rôle donné (fallback sur global_threshold).
    pub fn for_role(&self, role_id: &str) -> f32 {
        self.role_overrides
            .get(role_id)
            .map(|r| r.mastery_threshold)
            .unwrap_or(self.global_threshold)
    }
}

// === JsonSchema — Validation JSONB ===

/// Schéma JSON pour validation de champs JSONB pack-spécifiques.
/// D-024 : le pack définit le schéma, le core applique la validation.
/// Si None → le core accepte tout JSONB valide (HITL Q6).
pub type JsonSchema = serde_json::Value;

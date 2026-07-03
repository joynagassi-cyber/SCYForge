# WORK PACKAGE 01 — DCID Traits Rust (SemanticTreeProvider + 9 Providers)

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Fondation bloquante pour tout le reste
> **Dépendances** : Aucune (dépend de scy-shared types)
> **Références** : `MASTER_AGENT_PROMPT.md`, `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` (D-019, D-020), `minddoc/s00_architecture_standards/scy_service_architecture_map.md` (Règle 5)

---

## 1. Objectif

Implémenter les **traits DCID** dans `backend_rs/crates/scy-shared/src/ports.rs` et créer les types de base dans `semantic_node.rs`.

**Livrable** : Le code compile (`cargo check` passe), les traits sont documentés, les types Rust correspondent exactement aux spécifications.

---

## 2. Contexte (lis ABSOLUMENT ces sections avant de coder)

1. `MASTER_AGENT_PROMPT.md` — entier
2. `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` — sections D-019, D-020, D-024
3. `minddoc/s00_architecture_standards/scy_service_architecture_map.md` — sections Règle 4, Règle 5
4. `minddoc/s01_semantic_tree/scy_state_machines.md` — sections 9 (provider×owner_kind) et 10 (inheritance)
5. `minddoc/s01_semantic_tree/scy_eventbus_schemas.md` — sections TreeOp events
6. `minddoc/s03_generative_forest_engine/scy_gfe_parameters.md` — sections 12.4 (provider×owner_kind matrix)

---

## 3. Contraintes NON-NÉGOCIABLES (tu NE peux PAS violer celles-ci)

1. **Zéro terme métier cyber** dans le core. Le trait `SemanticTreeProvider` ne contient JAMAIS "MITRE", "SOC", "Sigma", "CVE", "alert", "phishing", etc.
2. **Tout seuil est pack-défini**. Aucune constante numérique pour mastery_threshold, weights, etc. dans le core.
3. **EventBus obligatoire** pour toute mutation d'état. Un `graft()` qui ne publie pas `TreeOpGrafted` est incorrect.
4. **owner_kind est une propriété de l'arbre**, pas du nœud. Tous les TreeOp events doivent transporter `owner_kind` + `owner_id`.
5. **PackJsonSchemaProvider` None = accept-all**. Si le pack retourne None, le core accepte tout JSONB valide.
6. **PackConfig absent = MissingPackConfig error**. Jamais de fallback silencieux (pas de `unwrap_or(0.70)`).

---

## 4. Architecture cible

```
backend_rs/crates/scy-shared/src/
├── lib.rs              # Préambule + exports
├── ports.rs            # ⭐ TOUS les traits DCID (9 providers)
├── tree.rs             # SemanticTree, TreeEdge, EdgeKind, OwnerKind, TreeOpResult
├── semantic_node.rs    # SemanticNode, LearnerNodeState, PackConfig
├── dcid.rs             # DCID contract, domain_filter trait, SeedValidator
├── types.rs            # RoleTaxonomy, ScenarioSpec, RubricCriterionScore, etc.
└── error.rs            # AppError + DCID-specific errors
```

---

## 5. Livrable détaillé — File par File

### 5.1 `ports.rs` — Les 9 Traits DCID

**Contenu attendu** :

```rust
//! Domain Contract Interface Definition (DCID) — Les 9 traits canoniques.
//! Référence : D-020, D-024.
//! Règle d'or : ZERO terme métier dans le core. Ces traits sont generics.

use async_trait::async_trait;
use uuid::Uuid;
use serde::{Deserialize, Serialize};
use crate::tree::{SemanticTree, TreeEdge, SemanticNode};
use crate::semantic_node::{LearnerNodeState, PackConfig};
use crate::{AppError, AppResult};

// ──────────────────────────────────────────────────────────────
// TRAIT 1 (PRIMARY) — SemanticTreeProvider
// ──────────────────────────────────────────────────────────────

/// Point d'entrée UNIQUE du cœur vers n'IMPORTE QUEL Domain Pack.
/// Le cœur ne connaît pas "cyber" ni "medical" — seulement cette interface.
#[async_trait]
pub trait SemanticTreeProvider: Send + Sync {
    // ── Lecture ──
    async fn load_tree(&self, owner_kind: OwnerKind, owner_id: Uuid) -> AppResult<SemanticTree>;
    async fn nodes(&self, tree_id: Uuid, depth: Option<u32>) -> AppResult<Vec<SemanticNode>>;
    async fn live_edges(&self, tree_id: Uuid) -> AppResult<Vec<TreeEdge>>;
    async fn learner_state(&self, learner_id: Uuid, tree_id: Uuid) -> AppResult<Vec<LearnerNodeState>>;

    // ── Écriture (5 opérations canoniques) ──
    async fn plant(&self, tree_id: Uuid, roots: Vec<Uuid>) -> AppResult<TreeOpResult>;
    async fn graft(&self, tree_id: Uuid, parent: Uuid, child: SemanticNode) -> AppResult<TreeOpResult>;
    async fn prune(&self, tree_id: Uuid, dead_nodes: Vec<Uuid>) -> AppResult<TreeOpResult>;
    async fn test(&self, learner_id: Uuid, node_id: Uuid, evidence: TestEvidence) -> AppResult<TreeOpResult>;
    async fn myelinate(&self, learner_id: Uuid, node_id: Uuid) -> AppResult<TreeOpResult>;

    // ── Gating ──
    async fn is_unlockable(&self, learner_id: Uuid, child_node: Uuid) -> AppResult<bool>;
}

// ──────────────────────────────────────────────────────────────
// TRAITS 2-9 — Providers optionnels
// ──────────────────────────────────────────────────────────────

#[async_trait]
pub trait OntologyProvider: Send + Sync {
    /// Retourne tous les concepts du domaine (générique — pas "ATT&CK techniques")
    async fn concepts(&self) -> AppResult<Vec<OntologyConcept>>;
    /// Retourne les relations entre concepts
    async fn relations(&self, concept_id: Uuid) -> AppResult<Vec<OntologyRelation>>;
    /// Retourne l'ontologie racine (ex: "mitre_attack")
    async fn root_ontology(&self) -> AppResult<String>;
}

#[async_trait]
pub trait CorpusProvider: Send + Sync {
    /// Retourne les chunks de texte pour un nœud donné
    async fn chunks_for_node(&self, node_id: Uuid) -> AppResult<Vec<CorpusChunk>>;
    /// Retourne le snapshot du corpus (pour seed_hash / C7)
    async fn corpus_snapshot(&self) -> AppResult<String>;
    /// Recherche plein-texte (MVP: BM25 FTS)
    async fn search(&self, query: &str, limit: u32) -> AppResult<Vec<SearchResult>>;
}

#[async_trait]
pub trait RoleTaxonomyProvider: Send + Sync {
    /// Retourne tous les rôles définis par le pack
    async fn roles(&self) -> AppResult<Vec<Role>>;
    /// Retourne le sous-arbre requis pour un rôle
    async fn subtree_for_role(&self, role_id: &str) -> AppResult<Vec<Uuid>>;
    /// Retourne les bornes d'autonomie par classe d'alerte pour un rôle
    async fn autonomy_bounds(&self, role_id: &str, profile_ref: Option<&str>) -> AppResult<Vec<AutonomyBound>>;
}

#[async_trait]
pub trait DecisionScenarioProvider: Send + Sync {
    /// Retourne tous les scénarios disponibles
    async fn scenarios(&self) -> AppResult<Vec<ScenarioSpec>>;
    /// Retourne un scénario par ID
    async fn scenario_by_id(&self, scenario_id: &str) -> AppResult<ScenarioSpec>;
    /// Retourne les injects pour un nœud donné (pour ARENA)
    async fn injects_for_node(&self, node_id: Uuid) -> AppResult<Vec<ScenarioInject>>;
}

#[async_trait]
pub trait ProofRubricProvider: Send + Sync {
    /// Retourne la grille d'évaluation pour un scénario
    async fn rubric_for_scenario(&self, scenario_id: &str) -> AppResult<RubricSpec>;
    /// Retourne les dimensions de preuve pour un rôle
    async fn proof_dimensions(&self, role_id: &str, profile_ref: Option<&str>) -> AppResult<Vec<ProofDimension>>;
    /// Calcule le score de preuve
    async fn calculate_score(&self, evidence: &[EvidenceItem], rubric: &RubricSpec) -> AppResult<ProofScore>;
}

#[async_trait]
pub trait RetentionPolicyProvider: Send + Sync {
    /// Retourne les paramètres FSRS pour un nœud
    async fn fsrs_params(&self, node_id: Uuid) -> AppResult<FSRSParams>;
    /// Retourne le poids de criticité d'un nœud
    async fn criticality_weight(&self, node_id: Uuid) -> AppResult<f32>;
    /// Retourne la politique de révision pour un rôle
    async fn review_policy(&self, role_id: &str) -> AppResult<ReviewPolicy>;
}

#[async_trait]
pub trait PackConfigProvider: Send + Sync {
    /// Retourne la config du pack (mastery_threshold, smi_weights, helm_axes, criticality_formula)
    async fn pack_config(&self) -> AppResult<PackConfig>;
    /// Retourne un paramètre spécifique (avec fallback pack racine)
    async fn get_param(&self, key: &str, owner_kind: OwnerKind, owner_id: Uuid) -> AppResult<Option<JsonValue>>;
}

#[async_trait]
pub trait PackJsonSchemaProvider: Send + Sync {
    /// Retourne le schéma JSON pour les métadonnées de nœud
    /// None = le core accepte tout JSONB valide (pas de rejet)
    async fn node_metadata_schema(&self) -> AppResult<Option<JsonSchema>>;
    /// Retourne le schéma JSON pour les critères de rubrique
    async fn rubric_criteria_schema(&self) -> AppResult<Option<JsonSchema>>;
    /// Retourne le schéma JSON pour les métadonnées d'opération d'arbre
    async fn tree_operation_metadata_schema(&self, operation: TreeOp) -> AppResult<Option<JsonSchema>>;
}
```

**Règles associées** :
- `PackConfigProvider` : absence → `MissingPackConfig` error. Jamais de fallback.
- `PackJsonSchemaProvider` : `None` = accept-all.
- Les 9 providers sont **indépendants** : un pack peut implémenter seulement 3 providers.

---

### 5.2 `tree.rs` — SemanticTree, TreeEdge, EdgeKind, OwnerKind

**Contenu attendu** :

```rust
//! Types du Semantic Tree — le substrat unique de SCY Forge.
//! Référence : SEMANTIC_TREE_INFRASTRUCTURE §4.2, D-019, D-020.

use serde::{Deserialize, Serialize};
use uuid::Uuid;

// ──────────────────────────────────────────────────────────────
// OwnerKind — 3 instances du même arbre
// ──────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum OwnerKind {
    /// Arbre canonique du domaine (ex: MITRE ATT&CK)
    DomainPack,
    /// Arbre de l'entreprise = pack + greffons privés
    Organization,
    /// Projection maîtrisée de l'Organization dans une tête
    Learner,
}

impl std::fmt::Display for OwnerKind {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            OwnerKind::DomainPack => write!(f, "domain_pack"),
            OwnerKind::Organization => write!(f, "organization"),
            OwnerKind::Learner => write!(f, "learner"),
        }
    }
}

// ──────────────────────────────────────────────────────────────
// EdgeKind — Composite (D-020)
// ──────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum EdgeKind {
    // Hiérarchique (pédagogie)
    Hierarchical(HierarchyKind),
    // Relationnel (réalité opérationnelle — "lianes")
    Relational(RelationKind),
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum HierarchyKind {
    Trunk,    // racine d'un domaine (pas de parent)
    Branch,   // parent = nœud d'arbre
    Leaf,     // parent = concept opérable
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum RelationKind {
    Prereq,       // A doit précéder B
    Relates,      // lien transverse non bloquant
    Contradicts,  // conflit à arbitrer (drift)
    Supersedes,   // remplacement versionné (anneau de croissance)
}

impl EdgeKind {
    pub fn as_str(&self) -> &'static str {
        match self {
            EdgeKind::Hierarchical(h) => match h {
                HierarchyKind::Trunk => "hierarchical_trunk",
                HierarchyKind::Branch => "hierarchical_branch",
                HierarchyKind::Leaf => "hierarchical_leaf",
            },
            EdgeKind::Relational(r) => match r {
                RelationKind::Prereq => "relational_prereq",
                RelationKind::Relates => "relational_relates",
                RelationKind::Contradicts => "relational_contradicts",
                RelationKind::Supersedes => "relational_supersedes",
            },
        }
    }
}

// ──────────────────────────────────────────────────────────────
// TreeEdge
// ──────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TreeEdge {
    pub id: Uuid,
    pub tree_id: Uuid,
    pub from_node: Uuid,
    pub to_node: Uuid,
    pub kind: EdgeKind,
    pub criticality: f32,        // 0.0–1.0 (dérivé de densité Sigma / trunkPriority)
    pub created_at: i64,
    pub superseded_at: Option<i64>, // null = vivante; sinon = anneau historisé
}

// ──────────────────────────────────────────────────────────────
// SemanticTree
// ──────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SemanticTree {
    pub id: Uuid,
    pub owner_kind: OwnerKind,   // DomainPack | Organization | Learner
    pub owner_id: Uuid,
    pub domain_pack: String,     // "cyber" pour le beachhead
    pub root_nodes: Vec<Uuid>,   // les troncs (3–7 nœuds 80/20)
    pub created_at: i64,
}

// ──────────────────────────────────────────────────────────────
// TreeOpResult — retour standard de toutes les opérations
// ──────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TreeOpResult {
    pub op: TreeOp,
    pub affected_nodes: Vec<Uuid>,
    pub justification: String,
    pub validation_guard_result: Option<JsonValue>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum TreeOp {
    Plant,
    Graft,
    Prune,
    Test,
    Myelinate,
}
```

**Règles associées** :
- `TreeEdge` est immuable après création (pas de UPDATE autorisé — trigger PostgreSQL).
- `superseded_at` est la seule colonne mutable (marquage historique).
- `SemanticTree` possède exactement 3 `owner_kind` possibles — pas d'autre valeur autorisée.

---

### 5.3 `semantic_node.rs` — SemanticNode, LearnerNodeState, PackConfig

**Contenu attendu** :

```rust
//! Types des nœuds sémantiques et états d'apprenant.
//! Référence : scy_state_machines.md (SM-1), D-011, D-024.

use serde::{Deserialize, Serialize};
use uuid::Uuid;
use crate::tree::EdgeKind;

// ──────────────────────────────────────────────────────────────
// SemanticNode — un nœud dans l'arbre de maîtrise
// ──────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SemanticNode {
    pub id: Uuid,
    pub tree_id: Uuid,
    pub title: String,
    pub summary: String,
    pub depth: u32,              // 0 = racine (tronc), profondeur dans l'arbre
    pub node_kind: NodeKind,     // Trunk, Branch, Leaf
    pub domain_ref: Option<DomainRef>, // ex: {ontology: "mitre_attack", id: "T1566"}
    pub metadata: JsonValue,     // pack-défini (validé par PackJsonSchemaProvider)
    pub created_at: i64,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum NodeKind {
    Trunk,    // racine pédagogique (80/20)
    Branch,   // sous-domaine
    Leaf,     // détail opérable (décision réelle)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DomainRef {
    pub ontology: String,    // ex: "mitre_attack"
    pub id: String,          // ex: "T1566.001"
    pub label: Option<String>,
}

// ──────────────────────────────────────────────────────────────
// LearnerNodeState — état de maîtrise par apprenant (SM-1)
// ──────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LearnerNodeState {
    pub id: Uuid,
    pub learner_id: Uuid,
    pub tree_id: Uuid,
    pub node_id: Uuid,
    pub confidence: f32,        // 0.0–1.0 — SOURCE DE VÉRITÉ
    pub mastery_score: f32,     // DÉRIVÉ — GENERATED ALWAYS AS (STORED)
    pub status: NodeStatus,     // DÉRIVÉ — GENERATED ALWAYS AS (STORED)
    pub unlocked: bool,         // tronc-avant-feuilles
    pub last_reviewed_at: Option<i64>,
    pub created_at: i64,
    pub updated_at: i64,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum NodeStatus {
    Locked,      // prérequis non maîtrisés
    Ready,       // prérequis OK, pas encore commencé
    Studying,    // en cours d'apprentissage
    Mastered,    # SMI ≥ pack_config.mastery_threshold
}

// ──────────────────────────────────────────────────────────────
// PackConfig — configuration pack-définie (D-024)
// ──────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PackConfig {
    pub owner_kind: OwnerKind,
    pub owner_id: Uuid,
    pub inherited_from: Option<(OwnerKind, Uuid)>, // None = racine pack
    pub mastery_threshold: f32,    // ex: 0.70 — pack-défini, jamais hardcodé
    pub smi_weights: SMIWeights,
    pub helm_axes: Vec<HelmAxis>,
    pub criticality_formula: String,
    pub custom: JsonValue,         // champs pack-spécifiques (non interprétés par le core)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SMIWeights {
    pub retention: f32,    // 0.35 par défaut (pack-défini)
    pub fluency: f32,      // 0.25 par défaut
    pub gap: f32,          // 0.25 par défaut
    pub depth: f32,        // 0.15 par défaut
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HelmAxis {
    pub name: String,
    pub weight: f32,
}

// ──────────────────────────────────────────────────────────────
// TestEvidence — preuve d'une évaluation de nœud
// ──────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TestEvidence {
    pub evidence_type: String,   // pack-défini (ex: "apt29_step", "b11_card")
    pub score: f32,              // 0.0–1.0
    pub rubric_criteria: Vec<RubricCriterionScore>,
    pub raw_output: Option<JsonValue>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RubricCriterionScore {
    pub criterion: String,
    pub score: f32,
    pub max_score: f32,
    pub weight: f32,
}
```

**Règles associées** :
- `confidence` est la **source de vérité** — `mastery_score` et `status` sont **dérivés**.
- `mastery_score` et `status` sont stockés en DB comme colonnes `GENERATED ALWAYS AS` (STORED) — trigger pack-défini.
- `PackConfig` a un système de résolution en cascade : Learner → Organization → DomainPack.

---

### 5.4 `dcid.rs` — DCID Contract + Domain Filter

**Contenu attendu** :

```rust
//! DCID Contract — validation et contrats entre core et Domain Packs.
//! Référence : D-019, D-020, D-024, C1-C7.

use serde::{Deserialize, Serialize};
use crate::ports::*;
use crate::tree::*;
use crate::semantic_node::*;

// ──────────────────────────────────────────────────────────────
// Trait optionnel — Domain Filter (C1-C7)
// ──────────────────────────────────────────────────────────────

#[async_trait]
pub trait DomainFilterProvider: Send + Sync {
    /// Valide une Seed candidate selon les critères C1-C7 du domaine.
    /// Retourne (true, vec of violations) — un Seed est accepté si violations.is_empty().
    async fn validate_seed_criteria(&self, seed: &SeedCandidate) -> AppResult<(bool, Vec<C1C7Violation>)>;
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedCandidate {
    pub core_proposition: String,
    pub source_a_id: Uuid,
    pub source_b_id: Uuid,
    pub context: JsonValue,
    pub domain_refs: Vec<DomainRef>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct C1C7Violation {
    pub criterion: C1C7Criterion,
    pub message: String,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum C1C7Criterion {
    C1Grounded,       // nœud sans sources[]
    C2PivotAnchored,  // nœud sans domain_ref
    C3Criticality,    // priorité non calculable
    C4DecisionBearing, // feuille sans décision
    C5Provable,       // pas de ProofCriterion
    C6Bounded,        // scope non borné
    C7Reproducible,   // génération non reproductible
}

// ──────────────────────────────────────────────────────────────
// DomainPackConfig — contrat global d'un pack
// ──────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DomainPackConfig {
    pub pack_id: String,
    pub version: String,
    pub ontology_root: String,
    pub providers: ProviderConfig,
    pub domain_filter_enabled: bool,  // C1-C7 obligatoire pour cyber
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProviderConfig {
    pub ontology: bool,
    pub corpus: bool,
    pub role_taxonomy: bool,
    pub decision_scenario: bool,
    pub proof_rubric: bool,
    pub retention_policy: bool,
    pub validation_guard: bool,
    pub pack_config: bool,
    pub json_schema: bool,
}
```

---

### 5.5 `error.rs` — Erreurs typées (D-024)

**Contenu attendu** :

```rust
//! Erreurs typées du core — jamais de .unwrap() en production.
//! Référence : D-024, Règle d'or #6.

use thiserror::Error;

#[derive(Error, Debug, Clone, Serialize, Deserialize)]
pub enum AppError {
    #[error("Pack configuration missing: {0}")]
    MissingPackConfig(String),

    #[error("Invalid state transition: {from:?} -> {to:?}")]
    InvalidStateTransition { from: String, to: String },

    #[error("Node not unlockable: {node_id} (prerequisites not mastered)")]
    NodeNotUnlockable { node_id: Uuid },

    #[error("Owner kind not allowed for operation: {operation} on {owner_kind}")]
    InvalidOwnerKind { operation: String, owner_kind: String },

    #[error("Schema validation failed: {0}")]
    SchemaValidationFailed(String),

    #[error("Pack not found: {0}")]
    PackNotFound(String),

    #[error("Tree not found: {0}")]
    TreeNotFound(Uuid),

    #[error("Node not found: {0}")]
    NodeNotFound(Uuid),

    #[error("EventBus publishing failed: {0}")]
    EventBusPublishFailed(String),

    #[error("Domain filter violation: {0:?}")]
    DomainFilterViolation(#[from] C1C7Violation),
}

pub type AppResult<T> = Result<T, AppError>;
```

---

## 6. Tests à fournir

### 6.1 `ports.rs` — tests de compilation

```bash
# Ces commandes DOIVENT passer :
cargo check -p scy-shared
cargo check -p scy-shared --features "test-utils"
```

**Test de contrat DCID** (compilation) :
```rust
// Ce code DOIT compiler (prouve que le trait est bien défini) :
// Il sera dans tests/dcid_contract_test.rs
#[test]
fn test_semantic_tree_provider_trait_compiles() {
    // Le trait doit être implémentable par un mock
    // Ce test vérifie que le trait ne contient PAS de terme métier
}
```

### 6.2 `tree.rs` — tests EdgeKind

```rust
#[test]
fn edge_kind_as_str_roundtrip() {
    let kinds = vec![
        EdgeKind::Hierarchical(HierarchyKind::Trunk),
        EdgeKind::Hierarchical(HierarchyKind::Branch),
        EdgeKind::Hierarchical(HierarchyKind::Leaf),
        EdgeKind::Relational(RelationKind::Prereq),
        EdgeKind::Relational(RelationKind::Relates),
        EdgeKind::Relational(RelationKind::Contradicts),
        EdgeKind::Relational(RelationKind::Supersedes),
    ];
    for kind in kinds {
        let s = kind.as_str();
        // Doit être parseable en SQL CHECK constraint
        assert!(s.starts_with("hierarchical_") || s.starts_with("relational_"));
    }
}
```

### 6.3 `semantic_node.rs` — tests PackConfig

```rust
#[test]
fn pack_config_missing_is_error() {
    // Vérifier que l'absence de PackConfig retourne MissingPackConfig
    // Pas de fallback silencieux
}

#[test]
fn pack_config_cascade_learner_org_pack() {
    // Learner → Organization → DomainPack
    // Vérifier que la cascade est correcte
}
```

---

## 7. Checklist de livraison

- [ ] `ports.rs` — 9 traits DCID complets et documentés
- [ ] `tree.rs` — SemanticTree, TreeEdge, EdgeKind composite, OwnerKind, TreeOpResult
- [ ] `semantic_node.rs` — SemanticNode, LearnerNodeState, PackConfig, TestEvidence
- [ ] `dcid.rs` — DomainFilterProvider, DomainPackConfig
- [ ] `error.rs` — AppError avec MissingPackConfig + variants DCID
- [ ] `cargo check` passe sans erreur
- [ ] Tests unitaires pour EdgeKind, PackConfig cascade, DCID contract
- [ ] Aucun terme métier cyber dans les fichiers implémentés
- [ ] Aucun `unwrap()` dans le code de production

---

## 8. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter l'adapter Postgres (WORK_PACKAGE_05)
- ❌ Implémenter l'EventBus (WORK_PACKAGE_03)
- ❌ Implémenter les migrations SQL (WORK_PACKAGE_02)
- ❌ Implémenter le Seed lifecycle (WORK_PACKAGE_06)
- ❌ Implémenter l'Autonomy Envelope (WORK_PACKAGE_07)
- ❌ Modifier des fichiers existants dans `backend_rs/` (sauf `scy-shared/src/*.rs`)
- ❌ Ajouter des dépendances Cargo sans validation

---

*Fin du WORK PACKAGE 01. Implémente UNIQUEMENT ce qui est dans ce fichier. Si tu as un doute, demande.*

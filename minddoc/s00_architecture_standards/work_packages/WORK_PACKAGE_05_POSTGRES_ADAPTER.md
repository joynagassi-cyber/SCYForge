# WORK PACKAGE 05 — SemanticTree Adapter Postgres (CRUD Operations)

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Bloquant pour WP06 (Seed) et WP12 (D9 Coverage)
> **Dépendances** : WP01 (types), WP02 (migrations), WP03 (EventBus), WP04 (PackProviders)
> **Références** : `MASTER_AGENT_PROMPT.md` (Règle #5 EventBus), `work_package_02_sql_migrations.md`, `docs/SCYFORGE_PIVOT_ARCHITECTURE.md` (§12)

---

## 1. Objectif

Implémenter l'adapter Postgres pour `SemanticTreeProvider` — le trait PRIMARY qui implémente toutes les opérations CRUD du Semantic Tree.

**Livrable** : `backend_rs/crates/scy-postgres/src/semantic_tree_adapter.rs` + tests d'intégration, `cargo check` passe.

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `work_package_01_dcid_traits.md` — SemanticTreeProvider trait + contraintes
2. `work_package_02_sql_migrations.md` — schema DB exact (colonnes, indexes, triggers)
3. `work_package_03_eventbus_crate.md` — EventBus trait + 18 événements
4. `work_package_04_pack_providers.md` — PackConfigProvider résolution cascade

---

## 3. Contraintes NON-NÉGOTIABLES

1. **Toute mutation publie un EventBus**. `graft()` → publie `TreeOpGrafted`. `plant()` → publie `TreeOpPlanted`. etc.
2. **`owner_kind` est filter à la lecture**. Jamais de lecture cross-owner sans filtre explicite.
3. **TreeEdge immuable**. Pas de UPDATE autorisé — trigger SQL en WP02. L'adapter ne tente JAMAIS un UPDATE sur `scy_tree_edges`.
4. **PackConfigProvider appelé pour toute lecture de threshold**. Le `is_unlockable()` ne contient PAS de constante.
5. **Transaction par opération**. Chaque opération d'écriture est dans une transaction SQL.
6. **RLS respected**. L'adapter passe `user_id` via `SET LOCAL app.user_id = ...` dans chaque transaction.

---

## 4. Architecture cible

```
backend_rs/crates/scy-postgres/src/
├── lib.rs                      # Préambule + exports
├── pool.rs                     # Connection pool (sqlx)
├── semantic_tree_adapter.rs    # ⭐ SemanticTreeProvider impl
├── learner_state_adapter.rs    # LearnerNodeState CRUD
├── pack_config_adapter.rs      # PackConfigProvider Postgres impl
├── schema_adapter.rs           # PackJsonSchemaProvider Postgres impl
└── event_log_adapter.rs        # EventBus event persistence (DLQ)
```

---

## 5. Livrable détaillé — File par File

### 5.1 `semantic_tree_adapter.rs` — SemanticTreeProvider impl

```rust
//! Adapter Postgres pour SemanticTreeProvider.
//! Référence : D-019, D-020, D-024, WP01.
//! NOTE: Toute mutation publie un EventBus event (Règle #5).

use async_trait::async_trait;
use sqlx::{PgPool, Row};
use uuid::Uuid;
use crate::ports::*;
use crate::tree::*;
use crate::semantic_node::*;
use crate::eventbus::{Event, EventBus, EventType, EventPayload};
use crate::error::AppError;

pub struct PostgresSemanticTreeProvider {
    pool: PgPool,
    event_bus: Arc<dyn EventBus>,
}

impl PostgresSemanticTreeProvider {
    pub fn new(pool: PgPool, event_bus: Arc<dyn EventBus>) -> Self {
        Self { pool, event_bus }
    }

    // ── Helpers ──

    fn owner_filter(&self, owner_kind: OwnerKind, owner_id: Uuid) -> String {
        format!("owner_kind = '{}' AND owner_id = '{}'", owner_kind, owner_id)
    }

    async fn publish_tree_event(&self, event_type: EventType, payload: EventPayload, owner_kind: OwnerKind, owner_id: Uuid) -> AppResult<()> {
        let event = Event {
            id: Uuid::new_v4(),
            event_type,
            timestamp: chrono::Utc::now().timestamp(),
            sender_id: "semantic_tree_adapter".to_string(),
            requires_reply: false,
            replied: false,
            context: vec![
                ("owner_kind".to_string(), owner_kind.to_string()),
                ("owner_id".to_string(), owner_id.to_string()),
            ].into_iter().collect(),
            payload,
        };
        self.event_bus.publish(event).await?;
        Ok(())
    }
}

// ──────────────────────────────────────────────────────────────
// SemanticTreeProvider impl
// ──────────────────────────────────────────────────────────────

#[async_trait]
impl SemanticTreeProvider for PostgresSemanticTreeProvider {

    // ── Lecture ──

    async fn load_tree(&self, owner_kind: OwnerKind, owner_id: Uuid) -> AppResult<SemanticTree> {
        let row = sqlx::query!(
            "SELECT id, owner_kind, owner_id, domain_pack, root_nodes, created_at
             FROM scy_semantic_trees
             WHERE owner_kind = $1 AND owner_id = $2",
            owner_kind.to_string(),
            owner_id
        )
        .fetch_optional(&self.pool)
        .await?;

        row.ok_or_else(|| AppError::TreeNotFound(Uuid::new_v4())) // TODO: proper error
            .map(|r| SemanticTree {
                id: r.id,
                owner_kind,
                owner_id,
                domain_pack: r.domain_pack.unwrap_or_default(),
                root_nodes: r.root_nodes.unwrap_or_default(),
                created_at: r.created_at.unwrap_or(0),
            })
    }

    async fn nodes(&self, tree_id: Uuid, depth: Option<u32>) -> AppResult<Vec<SemanticNode>> {
        let rows = if let Some(d) = depth {
            sqlx::query!(
                "SELECT id, tree_id, title, summary, depth, node_kind, domain_ref, metadata, created_at
                 FROM scy_semantic_nodes
                 WHERE tree_id = $1 AND depth <= $2
                 ORDER BY depth ASC, title ASC",
                tree_id, d as i32
            )
            .fetch_all(&self.pool)
            .await?
        } else {
            sqlx::query!(
                "SELECT id, tree_id, title, summary, depth, node_kind, domain_ref, metadata, created_at
                 FROM scy_semantic_nodes
                 WHERE tree_id = $1
                 ORDER BY depth ASC, title ASC",
                tree_id
            )
            .fetch_all(&self.pool)
            .await?
        };

        Ok(rows.into_iter().map(|r| SemanticNode {
            id: r.id,
            tree_id,
            title: r.title.unwrap_or_default(),
            summary: r.summary.unwrap_or_default(),
            depth: r.depth.unwrap_or(0) as u32,
            node_kind: parse_node_kind(&r.node_kind.unwrap_or_default())?,
            domain_ref: r.domain_ref.map(|j| serde_json::from_value(j).unwrap_or_default()),
            metadata: r.metadata.unwrap_or_default(),
            created_at: r.created_at.unwrap_or(0),
        }).collect())
    }

    async fn live_edges(&self, tree_id: Uuid) -> AppResult<Vec<TreeEdge>> {
        let rows = sqlx::query!(
            "SELECT id, tree_id, from_node, to_node, kind, criticality, created_at, superseded_at
             FROM scy_tree_edges
             WHERE tree_id = $1 AND superseded_at IS NULL
             ORDER BY created_at ASC",
            tree_id
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows.into_iter().map(|r| TreeEdge {
            id: r.id,
            tree_id,
            from_node: r.from_node,
            to_node: r.to_node,
            kind: parse_edge_kind(&r.kind.unwrap_or_default())?,
            criticality: r.criticality.unwrap_or(0.0),
            created_at: r.created_at.unwrap_or(0),
            superseded_at: r.superseded_at,
        }).collect())
    }

    async fn learner_state(&self, learner_id: Uuid, tree_id: Uuid) -> AppResult<Vec<LearnerNodeState>> {
        let rows = sqlx::query!(
            "SELECT id, learner_id, tree_id, node_id, confidence, mastery_score,
                    status, unlocked, last_reviewed_at, created_at, updated_at
             FROM scy_learner_node_states
             WHERE learner_id = $1 AND tree_id = $2",
            learner_id, tree_id
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows.into_iter().map(|r| LearnerNodeState {
            id: r.id,
            learner_id,
            tree_id,
            node_id: r.node_id,
            confidence: r.confidence.unwrap_or(0.0),
            mastery_score: r.mastery_score.unwrap_or(0.0),
            status: parse_node_status(&r.status.unwrap_or_default())?,
            unlocked: r.unlocked.unwrap_or(false),
            last_reviewed_at: r.last_reviewed_at,
            created_at: r.created_at.unwrap_or(0),
            updated_at: r.updated_at.unwrap_or(0),
        }).collect())
    }

    // ── Écriture (5 opérations canoniques) ──

    async fn plant(&self, tree_id: Uuid, roots: Vec<Uuid>) -> AppResult<TreeOpResult> {
        // Récupérer l'arbre pour owner_kind/owner_id
        let tree = self.load_tree(OwnerKind::DomainPack, tree_id).await?;

        let mut tx = self.pool.begin().await?;

        // Marquer les nœuds racines
        for root_id in &roots {
            sqlx::query!(
                "UPDATE scy_semantic_nodes SET node_kind = 'trunk' WHERE id = $1",
                root_id
            )
            .execute(&mut *tx)
            .await?;
        }

        tx.commit().await?;

        // Publier l'événement
        self.publish_tree_event(
            EventType::TreeOpPlanted,
            EventPayload::TreeOpPlanted {
                tree_id,
                owner_kind: tree.owner_kind.to_string(),
                owner_id: tree.owner_id,
                actor: "system".to_string(),
                root_node_id: roots.first().copied().unwrap_or_default(),
                pack_id: tree.domain_pack,
            },
            tree.owner_kind,
            tree.owner_id,
        ).await?;

        Ok(TreeOpResult {
            op: TreeOp::Plant,
            affected_nodes: roots,
            justification: format!("Planted {} root nodes", roots.len()),
            validation_guard_result: None,
        })
    }

    async fn graft(&self, tree_id: Uuid, parent: Uuid, child: SemanticNode) -> AppResult<TreeOpResult> {
        let tree = self.load_tree(OwnerKind::DomainPack, tree_id).await?;

        // 1. Vérifier que le child n'existe pas déjà (unicité)
        let existing = sqlx::query!(
            "SELECT id FROM scy_semantic_nodes WHERE id = $1",
            child.id
        )
        .fetch_optional(&self.pool)
        .await?;

        let child_id = if existing.is_some() {
            child.id // réutiliser l'existant
        } else {
            // 2. Insérer le child node
            sqlx::query!(
                "INSERT INTO scy_semantic_nodes (id, tree_id, title, summary, depth, node_kind, domain_ref, metadata)
                 VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
                child.id, tree_id, child.title, child.summary,
                child.depth as i32, child.node_kind.to_string(),
                serde_json::to_value(child.domain_ref).ok(),
                child.metadata
            )
            .execute(&self.pool)
            .await?;
            child.id
        };

        // 3. Créer l'edge (IMMUABLE — pas d'UPDATE possible)
        let edge_id = Uuid::new_v4();
        sqlx::query!(
            "INSERT INTO scy_tree_edges (id, tree_id, from_node, to_node, kind, criticality)
             VALUES ($1, $2, $3, $4, $5, $6)",
            edge_id, tree_id, parent, child_id,
            "hierarchical_branch", // TODO: EdgeKind du SemanticNode
            child.depth as f32 / 10.0 // criticalité simplifiée MVP
        )
        .execute(&self.pool)
        .await?;

        // 4. Publier TreeOpGrafted (OBLIGATOIRE — Règle #5)
        self.publish_tree_event(
            EventType::TreeOpGrafted,
            EventPayload::TreeOpGrafted {
                tree_id,
                owner_kind: tree.owner_kind.to_string(),
                owner_id: tree.owner_id,
                actor: "system".to_string(),
                parent_node_id: parent,
                child_node_id: child_id,
                edge_kind: "hierarchical_branch".to_string(),
                criticality: child.depth as f32 / 10.0,
                is_unlock_prerequisite: false,
            },
            tree.owner_kind,
            tree.owner_id,
        ).await?;

        Ok(TreeOpResult {
            op: TreeOp::Graft,
            affected_nodes: vec![parent, child_id],
            justification: format!("Grafted {} onto {}", child_id, parent),
            validation_guard_result: None,
        })
    }

    async fn prune(&self, tree_id: Uuid, dead_nodes: Vec<Uuid>) -> AppResult<TreeOpResult> {
        // Soft-prune : marquer les edges comme superseded_at
        let now = chrono::Utc::now().timestamp();
        let tree = self.load_tree(OwnerKind::DomainPack, tree_id).await?;

        for node_id in &dead_nodes {
            sqlx::query!(
                "UPDATE scy_tree_edges
                 SET superseded_at = $1
                 WHERE to_node = $2 AND tree_id = $3 AND superseded_at IS NULL",
                now, node_id, tree_id
            )
            .execute(&self.pool)
            .await?;
        }

        // Publier TreeOpPruned
        self.publish_tree_event(
            EventType::TreeOpPruned,
            EventPayload::TreeOpPruned {
                tree_id,
                owner_kind: tree.owner_kind.to_string(),
                owner_id: tree.owner_id,
                actor: "system".to_string(),
                dead_node_ids: dead_nodes.clone(),
                reason: "soft_prune".to_string(),
            },
            tree.owner_kind,
            tree.owner_id,
        ).await?;

        Ok(TreeOpResult {
            op: TreeOp::Prune,
            affected_nodes: dead_nodes,
            justification: "Soft-pruned nodes (superseded edges)".to_string(),
            validation_guard_result: None,
        })
    }

    async fn test(&self, learner_id: Uuid, node_id: Uuid, evidence: TestEvidence) -> AppResult<TreeOpResult> {
        // 1. Récupérer le nœud pour tree_id
        let node = sqlx::query!(
            "SELECT tree_id FROM scy_semantic_nodes WHERE id = $1",
            node_id
        )
        .fetch_optional(&self.pool)
        .await?
        .ok_or(AppError::NodeNotFound(node_id))?;

        let tree_id = node.tree_id;
        let tree = self.load_tree(OwnerKind::DomainPack, tree_id).await?;

        // 2. Calculer le nouveau confidence (pack-défini via PackConfigProvider)
        // MVP: moyenne pondérée par rubric_criteria
        let total_weight: f32 = evidence.rubric_criteria.iter().map(|c| c.weight).sum();
        let new_confidence = if total_weight > 0.0 {
            evidence.rubric_criteria.iter()
                .map(|c| c.score * c.weight / total_weight)
                .sum()
        } else {
            evidence.score
        };

        // 3. Upsert learner_node_state
        sqlx::query!(
            "INSERT INTO scy_learner_node_states (id, learner_id, tree_id, node_id, confidence)
             VALUES ($1, $2, $3, $4, $5)
             ON CONFLICT (learner_id, node_id)
             DO UPDATE SET confidence = EXCLUDED.confidence",
            Uuid::new_v4(), learner_id, tree_id, node_id, new_confidence
        )
        .execute(&self.pool)
        .await?;

        // 4. Publier TreeOpTested
        self.publish_tree_event(
            EventType::TreeOpTested,
            EventPayload::TreeOpTested {
                tree_id,
                owner_kind: tree.owner_kind.to_string(),
                owner_id: tree.owner_id,
                learner_id,
                node_id,
                test_type: evidence.evidence_type,
                result_summary: vec![].into_iter().collect(),
                rubric_scores: evidence.rubric_criteria,
            },
            tree.owner_kind,
            tree.owner_id,
        ).await?;

        Ok(TreeOpResult {
            op: TreeOp::Test,
            affected_nodes: vec![node_id],
            justification: format!("Tested node {}: confidence → {}", node_id, new_confidence),
            validation_guard_result: None,
        })
    }

    async fn myelinate(&self, learner_id: Uuid, node_id: Uuid) -> AppResult<TreeOpResult> {
        // Myelination = confidence boosted via SMI (simplifié MVP)
        let node = sqlx::query!(
            "SELECT lns.tree_id, lns.confidence FROM scy_learner_node_states lns
             WHERE lns.learner_id = $1 AND lns.node_id = $2",
            learner_id, node_id
        )
        .fetch_optional(&self.pool)
        .await?
        .ok_or(AppError::NodeNotFound(node_id))?;

        // Confidence boost (+10% MVP)
        let confidence_before = node.confidence.unwrap_or(0.0);
        let confidence_after = (confidence_before + 0.10).min(1.0);

        sqlx::query!(
            "UPDATE scy_learner_node_states
             SET confidence = $1, updated_at = extract(epoch FROM now())::bigint
             WHERE learner_id = $2 AND node_id = $3",
            confidence_after, learner_id, node_id
        )
        .execute(&self.pool)
        .await?;

        let tree_id = node.tree_id;
        let tree = self.load_tree(OwnerKind::DomainPack, tree_id).await?;

        // Publier TreeOpMyelinated
        self.publish_tree_event(
            EventType::TreeOpMyelinated,
            EventPayload::TreeOpMyelinated {
                tree_id,
                owner_kind: tree.owner_kind.to_string(),
                owner_id: tree.owner_id,
                learner_id,
                node_id,
                confidence_before,
                confidence_after,
            },
            tree.owner_kind,
            tree.owner_id,
        ).await?;

        Ok(TreeOpResult {
            op: TreeOp::Myelinate,
            affected_nodes: vec![node_id],
            justification: format!("Myelinated: {} → {}", confidence_before, confidence_after),
            validation_guard_result: None,
        })
    }

    // ── Gating ──

    async fn is_unlockable(&self, learner_id: Uuid, child_node: Uuid) -> AppResult<bool> {
        // 1. Récupérer les prérequis du nœud
        let prereqs = sqlx::query!(
            "SELECT from_node FROM scy_tree_edges
             WHERE to_node = $1 AND kind = 'relational_prereq' AND superseded_at IS NULL",
            child_node
        )
        .fetch_all(&self.pool)
        .await?;

        if prereqs.is_empty() {
            return Ok(true); // pas de prérequis = déblocable
        }

        // 2. Vérifier que tous les prérequis sont maîtrisés
        for prereq in &prereqs {
            let state = sqlx::query!(
                "SELECT status FROM scy_learner_node_states
                 WHERE learner_id = $1 AND node_id = $2",
                learner_id, prereq.from_node
            )
            .fetch_optional(&self.pool)
            .await?;

            if let Some(s) = state {
                if s.status.as_deref() != Some("mastered") {
                    return Ok(false);
                }
            } else {
                return Ok(false); // pas de state = pas maîtrisé
            }
        }

        Ok(true)
    }
}

// ──────────────────────────────────────────────────────────────
// Helpers de parsing (privés)
// ──────────────────────────────────────────────────────────────

fn parse_node_kind(s: &str) -> AppResult<NodeKind> {
    match s {
        "trunk" => Ok(NodeKind::Trunk),
        "branch" => Ok(NodeKind::Branch),
        "leaf" => Ok(NodeKind::Leaf),
        _ => Err(AppError::SchemaValidationFailed(format!("Invalid node_kind: {}", s))),
    }
}

fn parse_node_status(s: &str) -> AppResult<NodeStatus> {
    match s {
        "locked" => Ok(NodeStatus::Locked),
        "ready" => Ok(NodeStatus::Ready),
        "studying" => Ok(NodeStatus::Studying),
        "mastered" => Ok(NodeStatus::Mastered),
        _ => Err(AppError::SchemaValidationFailed(format!("Invalid node_status: {}", s))),
    }
}

fn parse_edge_kind(s: &str) -> AppResult<EdgeKind> {
    match s {
        "hierarchical_trunk" => Ok(EdgeKind::Hierarchical(HierarchyKind::Trunk)),
        "hierarchical_branch" => Ok(EdgeKind::Hierarchical(HierarchyKind::Branch)),
        "hierarchical_leaf" => Ok(EdgeKind::Hierarchical(HierarchyKind::Leaf)),
        "relational_prereq" => Ok(EdgeKind::Relational(RelationKind::Prereq)),
        "relational_relates" => Ok(EdgeKind::Relational(RelationKind::Relates)),
        "relational_contradicts" => Ok(EdgeKind::Relational(RelationKind::Contradicts)),
        "relational_supersedes" => Ok(EdgeKind::Relational(RelationKind::Supersedes)),
        _ => Err(AppError::SchemaValidationFailed(format!("Invalid edge_kind: {}", s))),
    }
}
```

---

### 5.2 `pack_config_adapter.rs` — PackConfigProvider Postgres

```rust
//! Adapter Postgres pour PackConfigProvider.
//! Référence : WP04, D-024.

use async_trait::async_trait;
use sqlx::PgPool;
use uuid::Uuid;
use crate::ports::*;
use crate::semantic_node::*;
use crate::error::AppError;

pub struct PostgresPackConfigProvider {
    pool: PgPool,
}

impl PostgresPackConfigProvider {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
}

#[async_trait]
impl PackConfigProvider for PostgresPackConfigProvider {
    async fn pack_config(&self) -> AppResult<PackConfig> {
        // Appelé avec owner_kind + owner_id défini par le contexte
        // L'adapter résout la cascade via resolve_pack_config()
        // Simplified MVP: retourne le domain_pack config directement
        let row = sqlx::query!(
            "SELECT id, owner_kind, owner_id, domain_pack,
                    mastery_threshold, smi_retention_weight, smi_fluency_weight,
                    smi_gap_weight, smi_depth_weight, criticality_formula, custom
             FROM scy_pack_configs
             WHERE owner_kind = 'domain_pack'
             LIMIT 1"
        )
        .fetch_optional(&self.pool)
        .await?;

        row.ok_or_else(|| AppError::MissingPackConfig("cyber".to_string()))
            .map(|r| PackConfig {
                owner_kind: parse_owner_kind(&r.owner_kind.unwrap_or_default())?,
                owner_id: r.owner_id.unwrap_or_default(),
                inherited_from: None,
                mastery_threshold: r.mastery_threshold.unwrap_or(0.70),
                smi_weights: SMIWeights {
                    retention: r.smi_retention_weight.unwrap_or(0.35),
                    fluency: r.smi_fluency_weight.unwrap_or(0.25),
                    gap: r.smi_gap_weight.unwrap_or(0.25),
                    depth: r.smi_depth_weight.unwrap_or(0.15),
                },
                helm_axes: vec![],
                criticality_formula: r.criticality_formula.unwrap_or_default(),
                custom: r.custom.unwrap_or_default(),
            })
    }

    async fn get_param(&self, key: &str, owner_kind: OwnerKind, owner_id: Uuid) -> AppResult<Option<JsonValue>> {
        let row = sqlx::query!(
            "SELECT custom FROM scy_pack_configs
             WHERE owner_kind = $1 AND owner_id = $2",
            owner_kind.to_string(), owner_id
        )
        .fetch_optional(&self.pool)
        .await?;

        Ok(row.and_then(|r| r.custom.and_then(|c| c.get(key).cloned())))
    }
}
```

---

### 5.3 Tests d'intégration (`tests/integration_test.rs`)

```rust
//! Tests d'intégration SemanticTree Adapter Postgres.
//! Référence : D-019, D-020.

use sqlx::{PgPool, Row};
use uuid::Uuid;

async fn setup_test_db() -> PgPool {
    // Pool de test vers Supabase local ou test container
    PgPool::connect(&std::env::var("TEST_DATABASE_URL").unwrap()).await.unwrap()
}

#[tokio::test]
async fn test_plant_publishes_tree_op_planted_event() {
    let pool = setup_test_db().await;
    let bus = Arc::new(InMemoryEventBus::new(100));
    let adapter = PostgresSemanticTreeProvider::new(pool.clone(), bus.clone());

    let tree_id = Uuid::new_v4();
    let root_id = Uuid::new_v4();

    // Insérer l'arbre + nœud d'abord
    sqlx::query!(
        "INSERT INTO scy_semantic_trees (id, owner_kind, owner_id, domain_pack, root_nodes)
         VALUES ($1, $2, $3, $4, $5)",
        tree_id, "domain_pack", Uuid::new_v4(), "cyber", vec![root_id]
    )
    .execute(&pool)
    .await
    .unwrap();

    sqlx::query!(
        "INSERT INTO scy_semantic_nodes (id, tree_id, title, summary, node_kind)
         VALUES ($1, $2, $3, $4, $5)",
        root_id, tree_id, "Root", "Root summary", "trunk"
    )
    .execute(&pool)
    .await
    .unwrap();

    // plant() → publie TreeOpPlanted
    let result = adapter.plant(tree_id, vec![root_id]).await;
    assert!(result.is_ok());

    // Vérifier l'événement
    let events = bus.events_for_type(EventType::TreeOpPlanted).await;
    assert_eq!(events.len(), 1);
}

#[tokio::test]
async fn test_graft_creates_node_and_edge() {
    // ...
}

#[tokio::test]
async fn test_graft_publishes_tree_op_grafted() {
    // ...
}

#[tokio::test]
async fn test_prune_supersedes_edges() {
    // ...
}

#[tokio::test]
async fn test_is_unlockable_respects_prerequisites() {
    // ...
}

#[tokio::test]
async fn test_owner_kind_filter_respected() {
    // Un learner ne peut pas voir l'arbre d'un autre learner
}
```

---

## 6. Checklist de livraison

- [ ] `semantic_tree_adapter.rs` — SemanticTreeProvider impl complet
- [ ] `pack_config_adapter.rs` — PackConfigProvider Postgres impl
- [ ] Tests de parsing (node_kind, edge_kind, node_status)
- [ ] Tests d'intégration (plant, graft, prune, test, myelinate)
- [ ] Tests EventBus (événements publiés pour chaque mutation)
- [ ] Tests owner_kind filter
- [ ] `cargo check -p scy-postgres` passe
- [ ] Aucun UPDATE sur scy_tree_edges
- [ ] Aucune constante hardcodée dans les opérations métier

---

## 7. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter schema_adapter.rs (PackJsonSchemaProvider)
- ❌ Implémenter event_log_adapter.rs
- ❌ Créer des migrations SQL (WP02)
- ❌ Modifier les types Rust (WP01)
- ❌ Implémenter le Seed lifecycle (WP06)
- ❌ Implémenter learner_state_adapter.rs (fait dans WP05 aussi, mais séparé)

---

*Fin du WORK PACKAGE 05. Implémente UNIQUEMENT ce qui est dans ce fichier.*

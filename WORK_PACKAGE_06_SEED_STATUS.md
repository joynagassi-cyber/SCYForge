# WORK PACKAGE 06 — SeedStatus SM-2 + Seed Struct + compute_seed_hash

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Bloquant pour WP11 (C1-C7 Validator) et WP12 (D9 Coverage)
> **Dépendances** : WP01 (types), WP02 (migrations), WP03 (EventBus), WP04 (PackProviders)
> **Références** : `MASTER_AGENT_PROMPT.md` (Règle #4 EventBus), `minddoc/s03_generative_forest_engine/SCY_GFE_PARAMETERS.md` (§12), `WORK_PACKAGE_01_DCID_TRAITS.md`

---

## 1. Objectif

Implémenter le lifecycle complet du **Seed** dans la GFE (Generative Forest Engine) : `SeedStatus` SM-2, struct `Seed`, `compute_seed_hash`, table `scy_seeds`, adapter Postgres.

**Livrable** : Types Rust complets + migration SQL v004 + adapter Postgres + tests, `cargo check` passe.

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `minddoc/s03_generative_forest_engine/SCY_GFE_PARAMETERS.md` — sections 4.7 (C1-C7), 4.8 (seed_hash), 4.9 (Post-Germination D9), 12 (SeedStatus SM-2, Seed struct, compute_seed_hash)
2. `WORK_PACKAGE_01_DCID_TRAITS.md` — SemanticTreeProvider trait + DomainFilterProvider
3. `WORK_PACKAGE_02_SQL_MIGRATIONS.md` — schema DB, trigram index
4. `WORK_PACKAGE_03_EVENTBUS_CRATE.md` — EventType SeedPlanted/SeedPollinated/SeedScored/SeedStatusChanged

---

## 3. Contraintes NON-NÉGOTIABLES

1. **SM-2 strict** : POLLINATED → VIABLE → (GERMINATING | DORMANT). Pas d'autre transition autorisée.
2. **`seed_hash = SHA-256(role_id + objectif + ontology_version + corpus_snapshot_id + weights + validator_version + seed_id)`**. Toujours ce 7-tuple exactement.
3. **`potential_tree` stocké en JSONB**. Pas de table séparée pour l'arbre potentiel (MVP).
4. **`domain_refs` est un array de JSONB**. Pas de table de liaison.
5. **`C1-C7 validation` en Rust, pas en SQL** (SQL fait C1-C4 seulement en WP02 v003).
6. **EventBus obligatoire** pour chaque transition de status.
7. **`fecundity = viability × novelty`**. Les deux composants sont stockés séparément.
8. **`seed_id` est UUID v7**. Généré à la création, jamais dérivé du hash.

---

## 4. State Machine SM-2 — SeedStatus

```
POLLINATED ──[germination_trigger]──► VIABLE
                                        │
                    ┌───────────────────┴───────────────────┐
                    ▼                                       ▼
             GERMINATING ──[germination_success]──► MASTERED
                    │                                       │
                    └──[germination_failure]──► DORMANT ────┘
                            ▲                       │
                            │                       ▼
                            └──[re_seed]──────── GERMINATING
```

| Transition | Condition | Event publié |
|------------|-----------|-------------|
| POLLINATED → VIABLE | `germination_trigger` (pack-défini) | `SeedStatusChanged` |
| VIABLE → GERMINATING | `germination_trigger` | `SeedStatusChanged` |
| VIABLE → DORMANT | Jamais — DORMANT n'est accessible que depuis GERMINATING | — |
| GERMINATING → MASTERED | `germination_success` | `SeedStatusChanged` |
| GERMINATING → DORMANT | `germination_failure` | `SeedStatusChanged` |
| DORMANT → GERMINATING | `re_seed` | `SeedStatusChanged` |

---

## 5. Types Rust à implémenter

### 5.1 `SeedStatus` (déjà dans SCY_GFE_PARAMETERS.md, rappel)

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum SeedStatus {
    Pollinated,
    Viable,
    Germinating,
    Dormant,
}
```

### 5.2 `Seed` (déjà dans SCY_GFE_PARAMETERS.md, rappel)

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Seed {
    pub id: Uuid,
    pub seed_hash: String,                    // SHA-256 7-tuple
    pub status: SeedStatus,
    pub tree_id: Uuid,
    pub organization_id: Uuid,
    pub domain_pack_id: String,
    pub core_proposition: String,
    pub parenthood: SeedParenthood,
    pub potential_tree: Option<JsonValue>,    // JSONB en DB
    pub viability_profile: ViabilityProfile,
    pub provenance: SeedProvenance,
    pub pollination_context: Option<JsonValue>,
    pub created_at: i64,
    pub updated_at: i64,
}
```

### 5.3 Types auxiliaires (NOUVEAUX — à créer en WP06)

```rust
// ── SeedParenthood ──
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedParenthood {
    pub parent_a: Option<Uuid>,     // None = auto-polliné (root)
    pub parent_b: Option<Uuid>,
    pub pollination_operator: PollinationOperator,
    pub generation: u32,            // 0 = root, 1 = F1, 2 = F2…
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum PollinationOperator {
    Cross,           // A × B (2 parents différents)
    Self,            // A × A (auto-pollination)
    Hybrid,          // seed × tree_node (grafting)
    Mutation,        // A avec mutation aléatoire
    Import,          // importé d'un autre système
}

// ── ViabilityProfile ──
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ViabilityProfile {
    pub viability: f32,             // 0.0–1.0 (fecundity × viability)
    pub fecundity: f32,             // 0.0–1.0 (potentiel de croisement)
    pub novelty: f32,               // 0.0–1.0 (différence vs parents)
    pub structural_coherence: f32,  // 0.0–1.0 (C7)
    pub pollination_confidence: f32,// 0.0–1.0 (confiance du pollinator)
}

impl ViabilityProfile {
    pub fn fecundity(&self) -> f32 {
        self.fecundity * (1.0 - self.novelty * 0.3) // fecundity × (1 - novelty_penalty)
    }

    pub fn plant_score(&self) -> f32 {
        self.fecundity() * self.viability
    }
}

// ── SeedProvenance ──
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedProvenance {
    pub source_domain_pack: String,
    pub ontology_version: String,
    pub corpus_snapshot_id: String,
    pub weights_snapshot: String,
    pub validator_version: String,
    pub created_by: String,         // agent/service qui a créé le seed
}

// ── GerminationContext ──
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GerminationContext {
    pub learner_id: Uuid,
    pub target_depth: u32,
    pub prerequisites_met: Vec<Uuid>,
    pub c1_c7_passed: bool,
    pub d9_score: Option<f32>,
}

// ── TreeGenerationConfig ──
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TreeGenerationConfig {
    pub seed_id: Uuid,
    pub max_depth: u32,
    pub branching_factor: u32,
    pub criticality_threshold: f32,
    pub expansion_policy: ExpansionPolicy,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum ExpansionPolicy {
    BreadthFirst,   // élargir avant d'approfondir
    DepthFirst,     // approfondir avant élargir
    CriticalityFirst, // développer les nœuds critiques d'abord
    LearnerDriven,  # l'apprenant choisit la branche
}
```

---

### 5.4 `compute_seed_hash` (déjà dans SCY_GFE_PARAMETERS.md, rappel)

```rust
pub fn compute_seed_hash(
    role_id: &str,
    objectif: &str,
    ontology_version: &str,
    corpus_snapshot_id: &str,
    weights: &str,
    validator_version: &str,
    seed_id: Uuid,
) -> String {
    let input = format!(
        "{}{}{}{}{}{}{}",
        role_id, objectif, ontology_version, corpus_snapshot_id, weights, validator_version, seed_id
    );
    sha256::digest(input.as_bytes())
}
```

**Note** : `weights` est une sérialisation canonique des `SMIWeights` (ex: `"0.35,0.25,0.25,0.15"`).

---

## 6. Migration SQL v004 — scy_seeds table

**`up.sql`** :

```sql
-- ============================================================
-- V004 — GFE Seeds Table
-- Crée: scy_seeds
-- Référence: SCY_GFE_PARAMETERS.md §12, D-024, WP06
-- ============================================================

CREATE TABLE IF NOT EXISTS scy_seeds (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seed_hash               TEXT NOT NULL UNIQUE,
    status                  TEXT NOT NULL DEFAULT 'pollinated'
                                CHECK (status IN ('pollinated', 'viable', 'germinating', 'dormant')),
    tree_id                 UUID NOT NULL REFERENCES scy_semantic_trees(id) ON DELETE CASCADE,
    organization_id         UUID NOT NULL,
    domain_pack_id          TEXT NOT NULL,
    core_proposition        TEXT NOT NULL,
    parenthood              JSONB NOT NULL,
    potential_tree          JSONB,
    viability_profile       JSONB NOT NULL,
    provenance              JSONB NOT NULL,
    pollination_context     JSONB,
    created_at              INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint),
    updated_at              INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint)
);

-- ── Indexes ──

CREATE INDEX IF NOT EXISTS idx_seeds_hash ON scy_seeds (seed_hash);
CREATE INDEX IF NOT EXISTS idx_seeds_tree ON scy_seeds (tree_id);
CREATE INDEX IF NOT EXISTS idx_seeds_status ON scy_seeds (status);
CREATE INDEX IF NOT EXISTS idx_seeds_org ON scy_seeds (organization_id);
CREATE INDEX IF NOT EXISTS idx_seeds_pack ON scy_seeds (domain_pack_id);
CREATE INDEX IF NOT EXISTS idx_seeds_parents
    ON scy_seeds USING GIN ((parenthood->'parent_a'), (parenthood->'parent_b'));

-- ── Fonction — validaiton seed_hash automatique ──
CREATE OR REPLACE FUNCTION validate_seed_hash()
RETURNS TRIGGER AS $$
DECLARE
    v_expected TEXT;
BEGIN
    -- Le seed_hash est calculé en Rust, on vérifie ici en SQL (C7)
    -- Note: En production, le calcul est fait dans l'adapter Rust.
    -- Ce trigger est un safety net.
    IF NEW.seed_hash IS NULL OR length(NEW.seed_hash) != 64 THEN
        RAISE EXCEPTION 'Invalid seed_hash: must be SHA-256 (64 chars), got: %', NEW.seed_hash;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_seed_hash_validate
    BEFORE INSERT OR UPDATE ON scy_seeds
    FOR EACH ROW
    EXECUTE FUNCTION validate_seed_hash();

-- ── Fonction — transition SM-2 validation ──
CREATE OR REPLACE FUNCTION validate_seed_status_transition()
RETURNS TRIGGER AS $$
BEGIN
    -- SM-2: POLLINATED → VIABLE → GERMINATING, GERMINATING → MASTERED/DORMANT, DORMANT → GERMINATING
    IF TG_OP = 'UPDATE' THEN
        IF OLD.status = 'pollinated' AND NEW.status NOT IN ('viable') THEN
            RAISE EXCEPTION 'Invalid transition: pollinated → %', NEW.status;
        END IF;
        IF OLD.status = 'viable' AND NEW.status NOT IN ('germinating', 'dormant') THEN
            RAISE EXCEPTION 'Invalid transition: viable → %', NEW.status;
        END IF;
        IF OLD.status = 'germinating' AND NEW.status NOT IN ('mastered', 'dormant') THEN
            RAISE EXCEPTION 'Invalid transition: germinating → %', NEW.status;
        END IF;
        IF OLD.status = 'dormant' AND NEW.status NOT IN ('germinating') THEN
            RAISE EXCEPTION 'Invalid transition: dormant → %', NEW.status;
        END IF;
        IF OLD.status = 'mastered' THEN
            RAISE EXCEPTION 'Invalid transition: mastered is terminal (no outgoing transitions)';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_seed_status_transition
    BEFORE UPDATE OF status ON scy_seeds
    FOR EACH ROW
    EXECUTE FUNCTION validate_seed_status_transition();

-- ── RLS ──
ALTER TABLE scy_seeds ENABLE ROW LEVEL SECURITY;

CREATE POLICY seeds_org_access ON scy_seeds
    FOR ALL USING (organization_id::text = current_setting('app.user_id', true));
```

**`down.sql`** :

```sql
DROP TRIGGER IF EXISTS trg_seed_status_transition ON scy_seeds;
DROP TRIGGER IF EXISTS trg_seed_hash_validate ON scy_seeds;
DROP TABLE IF EXISTS scy_seeds CASCADE;
```

---

## 7. Adapter Postgres — SeedRepository

```rust
//! Repository Postgres pour Seed lifecycle.
//! Référence: WP06, SCY_GFE_PARAMETERS.md §12.

use async_trait::async_trait;
use sqlx::PgPool;
use uuid::Uuid;
use crate::tree::OwnerKind;
use crate::eventbus::{Event, EventType, EventPayload};
use crate::seed::{Seed, SeedStatus, SeedParenthood, PollinationOperator, ViabilityProfile, SeedProvenance, GerminationContext};
use crate::error::AppError;

pub struct SeedRepository {
    pool: PgPool,
    event_bus: Arc<dyn EventBus>,
}

impl SeedRepository {
    pub fn new(pool: PgPool, event_bus: Arc<dyn EventBus>) -> Self {
        Self { pool, event_bus }
    }

    // ── CREATE ──

    async fn plant_seed(
        &self,
        tree_id: Uuid,
        domain_pack_id: String,
        core_proposition: String,
        parenthood: SeedParenthood,
        viability_profile: ViabilityProfile,
        provenance: SeedProvenance,
        role_id: &str,
        ontology_version: &str,
    ) -> AppResult<Seed> {
        let seed_id = Uuid::new_v4();

        // compute_seed_hash
        let weights_str = format!(
            "{},{},{},{}",
            provenance.weights_snapshot, // déjà au format "r,f,g,d"
            provenance.weights_snapshot,
            provenance.weights_snapshot,
            provenance.weights_snapshot
        );
        let seed_hash = compute_seed_hash(
            role_id,
            &core_proposition,
            ontology_version,
            &provenance.corpus_snapshot_id,
            &weights_str,
            &provenance.validator_version,
            seed_id,
        );

        let seed = Seed {
            id: seed_id,
            seed_hash: seed_hash.clone(),
            status: SeedStatus::Pollinated,
            tree_id,
            organization_id: Uuid::new_v4(), // TODO: resolved from context
            domain_pack_id,
            core_proposition,
            parenthood,
            potential_tree: None,
            viability_profile,
            provenance,
            pollination_context: None,
            created_at: chrono::Utc::now().timestamp(),
            updated_at: chrono::Utc::now().timestamp(),
        };

        // INSERT
        sqlx::query!(
            "INSERT INTO scy_seeds (id, seed_hash, status, tree_id, organization_id,
                    domain_pack_id, core_proposition, parenthood, potential_tree,
                    viability_profile, provenance, pollination_context)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)",
            seed.id,
            seed.seed_hash,
            "pollinated",
            seed.tree_id,
            seed.organization_id,
            seed.domain_pack_id,
            seed.core_proposition,
            serde_json::to_value(&seed.parenthood).unwrap(),
            seed.potential_tree,
            serde_json::to_value(&seed.viability_profile).unwrap(),
            serde_json::to_value(&seed.provenance).unwrap(),
            seed.pollination_context,
        )
        .execute(&self.pool)
        .await?;

        // Publier SeedPlanted
        self.publish_seed_event(
            EventType::SeedPlanted,
            seed.id,
            serde_json::json!({
                "seed_hash": seed.seed_hash,
                "determined_by": "seed_repository"
            }),
        ).await?;

        Ok(seed)
    }

    // ── Pollinate ──

    async fn pollinate_seed(
        &self,
        seed_id: Uuid,
        pollinator_type: PollinationOperator,
        parent_a: Option<Uuid>,
        parent_b: Option<Uuid>,
    ) -> AppResult<Seed> {
        let mut seed = self.find_by_id(seed_id).await?;

        // Vérifier transition SM-2
        if seed.status != SeedStatus::Pollinated {
            return Err(AppError::InvalidStateTransition {
                from: format!("{:?}", seed.status),
                to: "Viable".to_string(),
            });
        }

        // Mettre à jour parenthood
        seed.parenthood = SeedParenthood {
            parent_a,
            parent_b,
            pollination_operator: pollinator_type,
            generation: seed.parenthood.generation + 1,
        };

        // Calculer viability/noveauté
        seed.viability_profile.novelty = self.compute_novelty(parent_a, parent_b).await?;
        seed.viability_profile.fecundity = self.compute_fecundity(parent_a, parent_b).await?;

        // Transition SM-2: POLLINATED → VIABLE
        seed.status = SeedStatus::Viable;
        seed.updated_at = chrono::Utc::now().timestamp();

        sqlx::query!(
            "UPDATE scy_seeds SET status = 'viable', parenthood = $1,
                    viability_profile = $2, updated_at = $3
             WHERE id = $4",
            serde_json::to_value(&seed.parenthood).unwrap(),
            serde_json::to_value(&seed.viability_profile).unwrap(),
            seed.updated_at,
            seed_id,
        )
        .execute(&self.pool)
        .await?;

        // Publier SeedPollinated
        self.publish_seed_event(
            EventType::SeedPollinated,
            seed_id,
            serde_json::json!({
                "pollinator_type": format!("{:?}", pollinator_type),
                "parent_a": parent_a,
                "parent_b": parent_b,
            }),
        ).await?;

        Ok(seed)
    }

    // ── Score ──

    async fn score_seed(&self, seed_id: Uuid) -> AppResult<Seed> {
        let seed = self.find_by_id(seed_id).await?;
        let viability = seed.viability_profile.viability;
        let fecundity = seed.viability_profile.fecundity();
        let novelty = seed.viability_profile.novelty;
        let growth = (fecundity * 0.5 + novelty * 0.5).min(1.0);
        let stability = viability * (1.0 - novelty * 0.3);
        let score_sum = viability + fecundity + novelty + growth + stability;

        // Publier SeedScored
        self.publish_seed_event(
            EventType::SeedScored,
            seed_id,
            serde_json::json!({
                "score_sum": score_sum,
                "score_geo": viability,
                "score_neighbors": fecundity,
                "score_growth": growth,
                "score_stability": stability,
            }),
        ).await?;

        Ok(seed)
    }

    // ── Status transition (SM-2) ──

    async fn transition_status(
        &self,
        seed_id: Uuid,
        new_status: SeedStatus,
        context: Option<GerminationContext>,
    ) -> AppResult<Seed> {
        let seed = self.find_by_id(seed_id).await?;
        let old_status = seed.status;

        // Valider la transition via SQL trigger (safety net)
        // La vraie validation SM-2 est en Rust ici
        let allowed = match (old_status, new_status) {
            (SeedStatus::Pollinated, SeedStatus::Viable) => true,
            (SeedStatus::Viable, SeedStatus::Germinating) => true,
            (SeedStatus::Viable, SeedStatus::Dormant) => true,
            (SeedStatus::Germinating, SeedStatus::Mastered) => true,
            (SeedStatus::Germinating, SeedStatus::Dormant) => true,
            (SeedStatus::Dormant, SeedStatus::Germinating) => true,
            _ => false,
        };

        if !allowed {
            return Err(AppError::InvalidStateTransition {
                from: format!("{:?}", old_status),
                to: format!("{:?}", new_status),
            });
        }

        // Mettre à jour
        sqlx::query!(
            "UPDATE scy_seeds SET status = $1, updated_at = $2 WHERE id = $3",
            format!("{:?}", new_status).to_lowercase(),
            chrono::Utc::now().timestamp(),
            seed_id,
        )
        .execute(&self.pool)
        .await?;

        // Publier SeedStatusChanged
        self.publish_seed_event(
            EventType::SeedStatusChanged,
            seed_id,
            serde_json::json!({
                "old_status": format!("{:?}", old_status),
                "new_status": format!("{:?}", new_status),
                "transition": vec![format!("{:?}", old_status), format!("{:?}", new_status)],
            }),
        ).await?;

        Ok(seed)
    }

    // ── READ ──

    async fn find_by_id(&self, seed_id: Uuid) -> AppResult<Seed> {
        let row = sqlx::query!(
            "SELECT id, seed_hash, status, tree_id, organization_id, domain_pack_id,
                    core_proposition, parenthood, potential_tree, viability_profile,
                    provenance, pollination_context, created_at, updated_at
             FROM scy_seeds WHERE id = $1",
            seed_id
        )
        .fetch_optional(&self.pool)
        .await?
        .ok_or(AppError::PackNotFound(format!("Seed {}", seed_id)))?;

        Ok(Seed {
            id: row.id,
            seed_hash: row.seed_hash,
            status: parse_seed_status(&row.status.unwrap_or_default())?,
            tree_id: row.tree_id,
            organization_id: row.organization_id,
            domain_pack_id: row.domain_pack_id.unwrap_or_default(),
            core_proposition: row.core_proposition.unwrap_or_default(),
            parenthood: serde_json::from_value(row.parenthood.unwrap_or_default()).unwrap_or_default(),
            potential_tree: row.potential_tree,
            viability_profile: serde_json::from_value(row.viability_profile.unwrap_or_default()).unwrap_or_default(),
            provenance: serde_json::from_value(row.provenance.unwrap_or_default()).unwrap_or_default(),
            pollination_context: row.pollination_context,
            created_at: row.created_at.unwrap_or(0),
            updated_at: row.updated_at.unwrap_or(0),
        })
    }

    async fn list_by_tree(&self, tree_id: Uuid) -> AppResult<Vec<Seed>> {
        let rows = sqlx::query!(
            "SELECT id FROM scy_seeds WHERE tree_id = $1 ORDER BY created_at ASC",
            tree_id
        )
        .fetch_all(&self.pool)
        .await?;

        let mut seeds = Vec::new();
        for row in rows {
            seeds.push(self.find_by_id(row.id).await?);
        }
        Ok(seeds)
    }

    async fn list_by_status(&self, status: SeedStatus) -> AppResult<Vec<Seed>> {
        let rows = sqlx::query!(
            "SELECT id FROM scy_seeds WHERE status = $1 ORDER BY created_at ASC",
            format!("{:?}", status).to_lowercase()
        )
        .fetch_all(&self.pool)
        .await?;

        let mut seeds = Vec::new();
        for row in rows {
            seeds.push(self.find_by_id(row.id).await?);
        }
        Ok(seeds)
    }

    // ── Helpers ──

    async fn compute_novelty(&self, parent_a: Option<Uuid>, parent_b: Option<Uuid>) -> AppResult<f32> {
        // MVP: novelty = distance entre potential_tree des parents
        if let (Some(a), Some(b)) = (parent_a, parent_b) {
            let seed_a = self.find_by_id(a).await?;
            let seed_b = self.find_by_id(b).await?;

            let tree_a = seed_a.potential_tree.as_ref();
            let tree_b = seed_b.potential_tree.as_ref();

            if let (Some(a), Some(b)) = (tree_a, tree_b) {
                // Distance Jaccard sur les clés de l'arbre potentiel
                let keys_a: std::collections::HashSet<_> = a.as_object().map(|o| o.keys().cloned().collect()).unwrap_or_default();
                let keys_b: std::collections::HashSet<_> = b.as_object().map(|o| o.keys().cloned().collect()).unwrap_or_default();
                let intersection = keys_a.intersection(&keys_b).count();
                let union = keys_a.union(&keys_b).count();
                if union > 0 {
                    return Ok(1.0 - (intersection as f32 / union as f32));
                }
            }
        }
        // Pas de parents = auto-pollination → novelty = 0.3 (mutation basale)
        Ok(0.3)
    }

    async fn compute_fecundity(&self, parent_a: Option<Uuid>, parent_b: Option<Uuid>) -> AppResult<f32> {
        // Fecundity = moyenne de viability_profile des parents
        if let (Some(a), Some(b)) = (parent_a, parent_b) {
            let seed_a = self.find_by_id(a).await?;
            let seed_b = self.find_by_id(b).await?;
            Ok((seed_a.viability_profile.viability + seed_b.viability_profile.viability) / 2.0)
        } else if let Some(a) = parent_a {
            let seed = self.find_by_id(a).await?;
            Ok(seed.viability_profile.viability * 0.8) // auto = -20%
        } else {
            Ok(0.5) // racine
        }
    }

    #[allow(dead_code)]
    async fn publish_seed_event(&self, event_type: EventType, seed_id: Uuid, data: JsonValue) -> AppResult<()> {
        let event = Event {
            id: Uuid::new_v4(),
            event_type,
            timestamp: chrono::Utc::now().timestamp(),
            sender_id: "seed_repository".to_string(),
            requires_reply: false,
            replied: false,
            context: vec![("seed_id".to_string(), seed_id.to_string())].into_iter().collect(),
            payload: EventPayload::SeedPlanted { seed_id, seed_hash: String::new(), determined_by: String::new() },
            // TODO: Use proper payload variant based on event_type
        };
        self.event_bus.publish(event).await?;
        Ok(())
    }
}
```

---

## 8. Tests à fournir

### 8.1 `tests/compute_seed_hash_test.rs`

```rust
#[test]
fn compute_seed_hash_deterministic() {
    let hash1 = compute_seed_hash("role1", "obj1", "v1", "cs1", "w1", "v1", Uuid::new_v4());
    let hash2 = compute_seed_hash("role1", "obj1", "v1", "cs1", "w1", "v1", Uuid::new_v4());
    // Même seed_id → même hash
    // Différents seed_id → différents hashes (avec haute probabilité)
}

#[test]
fn compute_seed_hash_length_is_64() {
    let hash = compute_seed_hash("role1", "obj1", "v1", "cs1", "w1", "v1", Uuid::new_v4());
    assert_eq!(hash.len(), 64); // SHA-256 hex = 64 chars
}

#[test]
fn compute_seed_hash_changes_with_input() {
    let base = compute_seed_hash("role1", "obj1", "v1", "cs1", "w1", "v1", Uuid::new_v4());
    let changed = compute_seed_hash("role1", "obj1_v2", "v1", "cs1", "w1", "v1", Uuid::new_v4());
    assert_ne!(base, changed);
}
```

### 8.2 `tests/seed_status_sm2_test.rs`

```rust
#[test]
fn sm2_pollinated_to_viable() {
    let repo = SeedRepository::new(/* mock */);
    let seed = repo.plant_seed(/* ... */).await.unwrap();
    assert_eq!(seed.status, SeedStatus::Pollinated);

    seed = repo.transition_status(seed.id, SeedStatus::Viable, None).await.unwrap();
    assert_eq!(seed.status, SeedStatus::Viable);
}

#[test]
fn sm2_invalid_transition_rejected() {
    // VIABLE → DORMANT doit être rejeté
    let result = repo.transition_status(seed.id, SeedStatus::Dormant, None).await;
    assert!(result.is_err());
}
```

### 8.3 `tests/viability_profile_test.rs`

```rust
#[test]
fn fecundity_penalizes_novelty() {
    let vp = ViabilityProfile {
        viability: 0.8,
        fecundity: 0.9,
        novelty: 0.5,
        structural_coherence: 0.85,
        pollination_confidence: 0.9,
    };
    assert!(vp.fecundity() < vp.fecundity); // 0.9 * (1 - 0.5*0.3) = 0.865
    approx::assert_relative_eq!(vp.fecundity(), 0.865, epsilon = 0.001);
}

#[test]
fn plant_score_formula() {
    let vp = ViabilityProfile { viability: 0.8, fecundity: 0.9, novelty: 0.5, structural_coherence: 0.85, pollination_confidence: 0.9 };
    let score = vp.plant_score(); // fecundity() * viability = 0.865 * 0.8 = 0.692
    approx::assert_relative_eq!(score, 0.692, epsilon = 0.001);
}
```

---

## 9. Checklist de livraison

- [ ] `SeedStatus` enum (POLLINATED, VIABLE, GERMINATING, DORMANT)
- [ ] `Seed` struct complet avec tous les champs
- [ ] `SeedParenthood` struct + `PollinationOperator` enum
- [ ] `ViabilityProfile` struct + `fecundity()` + `plant_score()`
- [ ] `SeedProvenance` struct
- [ ] `GerminationContext` struct
- [ ] `TreeGenerationConfig` struct + `ExpansionPolicy` enum
- [ ] `compute_seed_hash()` — exactement 7-tuple SHA-256
- [ ] Migration SQL v004 (scy_seeds + indexes + triggers + RLS)
- [ ] `SeedRepository` impl (plant, pollinate, score, transition, find, list)
- [ ] SM-2 validation en Rust (pas seulement en SQL)
- [ ] `novelty` computation (Jaccard sur potential_tree)
- [ ] `fecundity` computation (moyenne viability parents)
- [ ] Tests compute_seed_hash (deterministic, length, input sensitivity)
- [ ] Tests SM-2 transitions (valid + invalid)
- [ ] Tests viability_profile (fecundity(), plant_score())
- [ ] Tests seed repository (plant, pollinate, score, transition)
- [ ] `cargo check -p scy-postgres` passe
- [ ] Aucun terme métier cyber dans les noms de types

---

## 10. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter C1-C7 DomainFilterProvider (WP11)
- ❌ Implémenter D9 Coverage Evaluator (WP12)
- ❌ Créer des tables autres que scy_seeds
- ❌ Modifier les migrations existantes (WP02)
- ❌ Modifier les types Rust de WP01

---

*Fin du WORK PACKAGE 06. Implémente UNIQUEMENT ce qui est dans ce fichier.*

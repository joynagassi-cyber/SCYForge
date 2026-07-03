# WORK PACKAGE 12 — D9 Coverage Evaluator Rust Implementation

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Bloquant pour WP14 (Cyber Pack) et WP15 (Dashboard)
> **Dépendances** : WP01 (types), WP10 (Provider matrix), WP11 (C1-C7 Validator), WP02 (SQL migrations)
> **Références** : `MASTER_AGENT_PROMPT.md` (Règle #1), `docs/SCYFORGE_PIVOT_ARCHITECTURE.md` (§12 D9 Coverage), `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` (D-023), `WORK_PACKAGE_02_SQL_MIGRATIONS.md`

---

## 1. Objectif

Implémenter l"**évaluateur D9 Coverage** — la métrique de couverture pondérée du Domain Pack qui mesure quelle fraction du curriculum/matrice est couverte par les apprentissages d"un utilisateur.

**Livrable** : `D9CoverageEvaluator` + types de score + SQL functions + tests, `cargo check` passe.

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `docs/SCYFORGE_PIVOT_ARCHITECTURE.md` — §12 (D9 Coverage detail: pondération R1, R2, R3)
2. `WORK_PACKAGE_01_DCID_TRAITS.md` — SemanticTree, LearnerNodeState
3. `WORK_PACKAGE_11_C1C7_VALIDATOR.md` — C1-C7 validation
4. `WORK_PACKAGE_02_SQL_MIGRATIONS.md` — `resolve_pack_config()`, `scy_semantic_trees`

---

## 3. Formule D9 Coverage

```
D9 = Σ(node_coverage_i × weight_i) / Σ(weight_i)

Où:
  node_coverage_i = mastery(node_i) × coverage_ratio(node_i)

  mastery(node_i) = confidence de l'apprenant sur ce nœud
                    (0.0 à 1.0)

  coverage_ratio(node_i) = covered_leaves(node_i) / total_leaves(node_i)
                    (graine d'arbre 80/20)

  weight_i = R1(node_i) × R2(era) × R3(fidelity)

Avec:
  R1 = trunkPriority × densité Sigma  (criticité du nœud)
  R2 = (era == new_2026) ? 1.2 : 1.0  (+20% pour era 2026)
  R3 = fidelity_score(node_i)         (L1=0.25, L2=0.50, L3=0.85, L4=1.0)
```

---

## 4. Types Rust à créer

### 4.1 `D9Score`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct D9Score {
    pub overall_coverage: f32,          // 0.0–1.0
    pub weighted_mastery: f32,          // mastery pondéré par R1×R2×R3
    pub total_weight: f32,              // somme des weights
    pub nodes_evaluated: u32,           // nb de nœuds évalués
    pub nodes_total: u32,               // nb total de nœuds dans le curriculum
    pub r1_contributions: Vec<(Uuid, f32)>, // (node_id, r1_weight)
    pub era: String,                    // ex: "new_2026"
    pub by_node: HashMap<Uuid, NodeD9Score>,
    pub evaluated_at: i64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NodeD9Score {
    pub node_id: Uuid,
    pub mastery: f32,
    pub coverage_ratio: f32,
    pub r1: f32,
    pub r2: f32,
    pub r3: f32,
    pub weight: f32,
    pub contribution: f32, // mastery × coverage_ratio × weight
}
```

### 4.2 `Era`

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Era {
    Legacy,
    Current,
    #[serde(rename = "new_2026")]
    New2026,
}

impl Era {
    pub fn r2_multiplier(&self) -> f32 {
        match self {
            Era::Legacy | Era::Current => 1.0,
            Era::New2026 => 1.2, // +20% pour era 2026
        }
    }
}
```

### 4.3 `FidelityLevel`

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum FidelityLevel {
    L1,  // 0.25 (connaissance déclarative)
    L2,  // 0.50 (compréhension)
    L3,  // 0.85 (application)
    L4,  // 1.00 (maîtrise)
}

impl FidelityLevel {
    pub fn r3_factor(&self) -> f32 {
        match self {
            FidelityLevel::L1 => 0.25,
            FidelityLevel::L2 => 0.50,
            FidelityLevel::L3 => 0.85,
            FidelityLevel::L4 => 1.00,
        }
    }
}
```

---

## 5. D9CoverageEvaluator — Implémentation

```rust
//! Évaluateur de couverture D9.
//! Référence: PIVOT_ARCHITECTURE §12, D-023.

pub struct D9CoverageEvaluator {
    pub tree_provider: Arc<dyn SemanticTreeProvider>,
    pub pack_config_provider: Arc<dyn PackConfigProvider>,
    pub tree_provider_supplier: Arc<dyn OnDemandTreeProviderSupplier>,
}

impl D9CoverageEvaluator {
    pub fn new(
        tree_provider: Arc<dyn SemanticTreeProvider>,
        pack_config_provider: Arc<dyn PackConfigProvider>,
        tree_provider_supplier: Arc<dyn OnDemandTreeProviderSupplier>,
    ) -> Self {
        Self { tree_provider, pack_config_provider, tree_provider_supplier }
    }

    /// Évaluer la couverture D9 pour un apprenant sur un arbre.
    pub async fn evaluate(
        &self,
        learner_id: Uuid,
        tree_id: Uuid,
        era: Era,
    ) -> AppResult<D9Score> {
        // 1. Charger le curriculum (tous les nodes de l'arbre)
        let all_nodes = self.tree_provider.nodes(tree_id, None).await?;
        let leaf_nodes: Vec<SemanticNode> = all_nodes.iter().filter(|n| n.node_kind == "leaf").cloned().collect();

        // 2. Charger l'état de l'apprenant
        let learner_states = self.tree_provider.learner_state(learner_id, tree_id).await?;
        let state_map: HashMap<Uuid, LearnerNodeState> = learner_states.iter()
            .map(|s| (s.node_id, s.clone()))
            .collect();

        // 3. Pack config (pour R1 formula)
        let pack_config = self.pack_config_provider.pack_config().await?;

        // 4. Évaluer chaque nœud
        let mut total_numerator = 0.0;
        let mut total_denominator = 0.0;
        let mut by_node = HashMap::new();
        let mut r1_contributions = Vec::new();

        for node in &all_nodes {
            // R1: criticité (trunkPriority × sigma_density)
            let trunk_priority = self.compute_trunk_priority(&node, &pack_config);
            let sigma_density = self.compute_sigma_density(node.id, tree_id).await?;
            let r1 = trunk_priority * sigma_density;

            // R2: era multiplier
            let r2 = era.r2_multiplier();

            // R3: fidelity (dérivé du NodeStatus)
            let r3 = self.compute_fidelity(&state_map.get(&node.id));

            // Weight
            let weight = r1 * r2 * r3;

            // Mastery
            let mastery = state_map.get(&node.id).map(|s| s.confidence).unwrap_or(0.0);

            // Coverage ratio (feuilles couvertes / total feuilles de ce sous-arbre)
            let coverage_ratio = if node.node_kind == NodeKind::Leaf {
                mastery // pour une feuille, coverage = mastery
            } else {
                self.compute_coverage_ratio(node.id, &state_map).await?
            };

            // Contribution
            let contribution = mastery * coverage_ratio * weight;

            total_numerator += contribution;
            total_denominator += weight;

            by_node.insert(node.id, NodeD9Score {
                node_id: node.id,
                mastery,
                coverage_ratio,
                r1,
                r2,
                r3,
                weight,
                contribution,
            });

            r1_contributions.push((node.id, r1));
        }

        let overall_coverage = if total_denominator > 0.0 {
            (total_numerator / total_denominator).clamp(0.0, 1.0)
        } else {
            0.0
        };

        Ok(D9Score {
            overall_coverage,
            weighted_mastery: total_numerator,
            total_weight: total_denominator,
            nodes_evaluated: all_nodes.len() as u32,
            nodes_total: all_nodes.len() as u32,
            r1_contributions,
            era: format!("{:?}", era),
            by_node,
            evaluated_at: chrono::Utc::now().timestamp(),
        })
    }

    fn compute_trunk_priority(&self, node: &SemanticNode, pack_config: &PackConfig) -> f32 {
        // Selon criticality_formula du pack (pack-défini)
        // MVP: depth-based (0.0 pour trunk, croît avec depth)
        let depth_factor = (node.depth as f32 + 1.0) / 10.0;
        depth_factor.clamp(0.0, 1.0)
    }

    async fn compute_sigma_density(&self, node_id: Uuid, tree_id: Uuid) -> AppResult<f32> {
        // Densité Sigma = nb de relations (edges) / nb max possible
        // Simplifié MVP: edges entrantes / degré max
        let edges = self.tree_provider.live_edges(tree_id).await?;
        let incoming = edges.iter().filter(|e| e.to_node == node_id).count();
        let outgoing = edges.iter().filter(|e| e.from_node == node_id).count();
        let total = incoming + outgoing;

        // sigma_density = total_relations / (2 × avg_degree)
        let avg_degree = if edges.len() > 0 {
            (2.0 * edges.len() as f32) / (self.tree_provider.nodes(tree_id, None).await?.len() as f32)
        } else {
            0.0
        };

        if avg_degree > 0.0 {
            Ok((total as f32 / avg_degree).clamp(0.0, 1.0))
        } else {
            Ok(0.0) // arbre vide → densité 0
        }
    }

    async fn compute_coverage_ratio(&self, node_id: Uuid, state_map: &HashMap<Uuid, LearnerNodeState>) -> AppResult<f32> {
        // Pour un nœud non-feuille: proportion de feuilles maîtrisées dans son sous-arbre
        // Simplifié MVP: 1.0 (on suppose couverture complète si mastery > 0)
        let state = state_map.get(&node_id);
        match state {
            Some(s) if s.confidence > 0.0 => Ok(1.0),
            Some(_) => Ok(0.0),
            None => Ok(0.0),
        }
    }

    fn compute_fidelity(&self, state: Option<&LearnerNodeState>) -> f32 {
        match state {
            Some(s) => match s.status {
                NodeStatus::Mastered => FidelityLevel::L4.r3_factor(),  // 1.0
                NodeStatus::Studying => FidelityLevel::L3.r3_factor(),  // 0.85
                NodeStatus::Ready => FidelityLevel::L2.r3_factor(),    // 0.50
                NodeStatus::Locked => FidelityLevel::L1.r3_factor(),   // 0.25
            },
            None => FidelityLevel::L1.r3_factor(), // 0.25 (jamais commencé)
        }
    }
}
```

---

## 6. SQL Functions for D9 (extension WP02 v003 ou nouvelle migration)

```sql
-- Fonction SQL pour calculer D9 coverage directement en base
-- (pour dashboards et requêtes temps réel)

CREATE OR REPLACE FUNCTION calculate_d9_coverage(
    p_learner_id UUID,
    p_tree_id UUID,
    p_era TEXT DEFAULT 'current'
) RETURNS TABLE (
    overall_coverage REAL,
    nodes_mastered INTEGER,
    nodes_total INTEGER,
    avg_confidence REAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COALESCE(AVG(lns.confidence), 0.0)::REAL AS overall_coverage,
        COUNT(CASE WHEN lns.status = 'mastered' THEN 1 END)::INTEGER AS nodes_mastered,
        COUNT(lns.id)::INTEGER AS nodes_total,
        COALESCE(AVG(lns.confidence), 0.0)::REAL AS avg_confidence
    FROM scy_learner_node_states lns
    WHERE lns.learner_id = p_learner_id
      AND lns.tree_id = p_tree_id;
END;
$$ LANGUAGE plpgsql STABLE;

-- Vue matérialisée pour D9 dashboard (RAFRAÎCHISSÉE via EventBus)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_d9_coverage_dashboard AS
SELECT
    lns.learner_id,
    lns.tree_id,
    COALESCE(AVG(lns.confidence), 0.0) AS coverage_rate,
    COUNT(CASE WHEN lns.status = 'mastered' THEN 1 END) AS mastered_count,
    COUNT(lns.id) AS total_count,
    COUNT(CASE WHEN lns.status = 'locked' THEN 1 END) AS locked_count,
    COUNT(CASE WHEN lns.status = 'studying' THEN 1 END) AS studying_count,
    now() AS refreshed_at
FROM scy_learner_node_states lns
GROUP BY lns.learner_id, lns.tree_id;
```

---

## 7. Tests à fournir

### 7.1 `tests/d9_coverage_test.rs`

```rust
#[test]
fn d9_all_mastered_gives_1_0() {
    // Tous les nœuds mastery = 1.0 → D9 = 1.0
    let evaluator = D9CoverageEvaluator::new(/* ... */);
    // Mock: tous les nodes ont confidence = 1.0
    let score = futures::executor::block_on(evaluator.evaluate(learner_id, tree_id, Era::Current)).unwrap();
    assert!((score.overall_coverage - 1.0).abs() < 0.01);
}

#[test]
fn d9_none_mastered_gives_near_0() {
    // Tous les nœuds mastery = 0.0 → D9 ≈ 0.0
    let score = futures::executor::block_on(evaluator.evaluate(learner_id, tree_id, Era::Current)).unwrap();
    assert!(score.overall_coverage < 0.05);
}

#[test]
fn d9_new_2026_era_gives_20_percent_boost() {
    // Era new_2026 → R2 = 1.2 → boost de 20% sur les weights
    let score_current = futures::executor::block_on(evaluator.evaluate(learner_id, tree_id, Era::Current)).unwrap();
    let score_2026 = futures::executor::block_on(evaluator.evaluate(learner_id, tree_id, Era::New2026)).unwrap();
    assert!(score_2026.weighted_mastery > score_current.weighted_mastery);
}

#[test]
fn fidelity_l4_gives_higher_weight() {
    // masteré (L4=1.0) > studying (L3=0.85) > ready (L2=0.50) > locked (L1=0.25)
    assert!(FidelityLevel::L4.r3_factor() > FidelityLevel::L3.r3_factor());
    assert!(FidelityLevel::L3.r3_factor() > FidelityLevel::L2.r3_factor());
    assert!(FidelityLevel::L2.r3_factor() > FidelityLevel::L1.r3_factor());
}

#[testfn compute_seed_hash_deterministic() {
    let hash1 = compute_seed_hash("role1", "obj1", "v1", "cs1", "w1", "v1", Uuid::new_v4());
    let hash2 = compute_seed_hash("role1", "obj1", "v1", "cs1", "w1", "v1", Uuid::new_v4());
    // With same seed_id, hashes must be equal
    // Different seed_id should produce different hash (high probability)
}
```

---

## 8. Checklist de livraison

- [ ] `D9Score` struct
- [ ] `NodeD9Score` struct
- [ ] `Era` enum + `r2_multiplier()`
- [ ] `FidelityLevel` enum + `r3_factor()`
- [ ] `D9CoverageEvaluator` — `evaluate()` async
- [ ] `compute_trunk_priority()` — pack-défini via criticality_formula
- [ ] `compute_sigma_density()` — densité du Semantic Tree
- [ ] `compute_coverage_ratio()` — feuilles maîtrisées / total
- [ ] `compute_fidelity()` — dérivé de NodeStatus
- [ ] SQL function `calculate_d9_coverage()`
- [ ] Materialized view `mv_d9_coverage_dashboard`
- [ ] Tests D9 (all mastered, none mastered, era boost, fidelity levels)
- [ ] `cargo check -p scy-shared` passe
- [ ] `cargo check -p scy-postgres` passe

---

## 9. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter le Dashboard SCY COSMOS (WP15)
- ❌ Implémenter le deployment profile (WP13)
- ❌ Créer des tables supplémentaires
- ❌ Modifier les types Rust des WP précédents (seulement ajout)
- ❌ Implémenter le Cyber Pack complet (WP14)

---

*Fin du WORK PACKAGE 12. Implémente UNIQUEMENT ce qui est dans ce fichier.*

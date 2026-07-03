# WORK PACKAGE 08 — Cognitive Runtime Policies (Trait + Config + EventBus)

> **Statut** : À implémenter
> **Priorité** : 🟡 P1 — Nécessaire pour WP09 (Loop Engineering)
> **Dépendances** : WP01 (types), WP03 (EventBus), WP07 (Autonomy Envelope)
> **Références** : `MASTER_AGENT_PROMPT.md` (Règle #6), `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` (D-026), `work_package_03_eventbus_crate.md`

---

## 1. Objectif

Implémenter les **5 Cognitive Runtime Policies** : OutputPressure, CognitiveFriction, ConsolidationWindow, Sparring, SemanticTreePriority. Chaque policy est un trait optionnel dans le core.

**Livrable** : Types Rust `CognitivePoliciesConfig` + trait `CognitivePolicyEvaluator` + config par déploiement + EventBus events, `cargo check` passe.

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` — section D-026 (Cognitive Runtime Policies)
2. `work_package_03_eventbus_crate.md` — EventType OutputPressureApplied, FrictionAdjusted
3. `work_package_07_autonomy_envelope.md` — AutonomyMode + AlertClass

---

## 3. Les 5 Policies (D-026)

| # | Policy | Rôle | Trigger | Action |
|---|--------|------|---------|--------|
| 1 | **OutputPressure** | Pression vers la sortie | Grille autonomie L3+ | OutputPressureApplied event |
| 2 | **CognitiveFriction** | Difficulté d"apprentissage | confidence dans [0.3, 0.6] | FrictionAdjusted event |
| 3 | **ConsolidationWindow** | Fenêtre de consolidation | Timestamp-based (pack-défini) | Delay next stimulus |
| 4 | **Sparring** | Opposant pédagogique | confidence > 0.7 (maîtrise) | SparringProposed event |
| 5 | **SemanticTreePriority** | Priorisation arbre | trunkPriority + densité Sigma | Graft/Prune suggestion |

---

## 4. Types Rust à créer dans `types.rs`

### 4.1 `OutputPressurePolicy`

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum OutputPressurePolicy {
    Standard,    // Output standard
    Strict,      // Pression vers sortie concrète
    Blocked,     # Bloqué — aucune sortie autonome
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OutputPressureConfig {
    pub policy: OutputPressurePolicy,
    pub trigger_threshold: f32,   // autonomie L3 → 0.6 par défaut
    pub cooldown_sec: u64,        // 300s (5min) entre deux applications
    pub max_daily: u32,           // 10/jour max
}
```

### 4.2 `CognitiveFrictionConfig`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CognitiveFrictionConfig {
    pub low_zone: (f32, f32),     // (0.0, 0.3) → frustration → baisser friction
    pub optimal_zone: (f32, f32), // (0.3, 0.6) → maintenir
    pub high_zone: (f32, f32),    // (0.6, 1.0) → ennui → augmenter friction
    pub friction_step: f32,       // ±0.1 par ajustement
    pub max_friction: f32,        // 1.0 plafond
    pub min_friction: f32,        // 0.0 plancher
}
```

### 4.3 `ConsolidationWindowConfig`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ConsolidationWindowConfig {
    pub window_sec: u64,          // durée de la fenêtre (pack-défini)
    pub min_confidence: f32,      // confidence minimum pour entrer
    pub max_reviews: u32,         // nb max de reviews dans la fenêtre
}
```

### 4.4 `SparringConfig`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SparringConfig {
    pub mastery_threshold: f32,   // confidence > threshold → sparring proposé
    pub opponent_role: String,    // rôle de l'opposant
    pub max_duration_sec: u64,    # durée max du sparring
}
```

### 4.5 `SemanticTreePriorityConfig`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SemanticTreePriorityConfig {
    pub trunk_weight: f32,        // poids du trunkPriority
    pub sigma_weight: f32,        # poids de la densité Sigma
    pub decay_factor: f32,        // facteur de décroissance par profondeur
    pub max_depth_boost: f32,     // boost max pour profondeur
}
```

### 4.6 `CognitivePoliciesConfig`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CognitivePoliciesConfig {
    pub output_pressure: OutputPressureConfig,
    pub friction: CognitiveFrictionConfig,
    pub consolidation: ConsolidationWindowConfig,
    pub sparring: SparringConfig,
    pub tree_priority: SemanticTreePriorityConfig,
    pub pack_id: String,
    pub profile_ref: Option<String>,
}

impl CognitivePoliciesConfig {
    /// Config par défaut (MVP)
    pub fn default_for(pack_id: &str) -> Self {
        Self {
            output_pressure: OutputPressureConfig {
                policy: OutputPressurePolicy::Standard,
                trigger_threshold: 0.6,
                cooldown_sec: 300,
                max_daily: 10,
            },
            friction: CognitiveFrictionConfig {
                low_zone: (0.0, 0.3),
                optimal_zone: (0.3, 0.6),
                high_zone: (0.6, 1.0),
                friction_step: 0.1,
                max_friction: 1.0,
                min_friction: 0.0,
            },
            consolidation: ConsolidationWindowConfig {
                window_sec: 86400, // 24h
                min_confidence: 0.5,
                max_reviews: 5,
            },
            sparring: SparringConfig {
                mastery_threshold: 0.85, // pack-défini
                opponent_role: "opponent".to_string(),
                max_duration_sec: 600,
            },
            tree_priority: SemanticTreePriorityConfig {
                trunk_weight: 0.5,
                sigma_weight: 0.3,
                decay_factor: 0.9,
                max_depth_boost: 0.2,
            },
            pack_id: pack_id.to_string(),
            profile_ref: None,
        }
    }
}
```

---

## 5. Trait `CognitivePolicyEvaluator`

```rust
//! Trait optionnel pour les Cognitive Runtime Policies.
//! Référence: D-026.
//! Chaque policy est indépendante — un pack peut implémenter seulement 3 policies.

use async_trait::async_trait;
use uuid::Uuid;

#[async_trait]
pub trait CognitivePolicyEvaluator: Send + Sync {
    // ── Output Pressure ──
    async fn apply_output_pressure(
        &self,
        node_id: Uuid,
        learner_id: Uuid,
        config: &OutputPressureConfig,
    ) -> AppResult<Option<OutputPressureResult>>;

    // ── Cognitive Friction ──
    async fn adjust_friction(
        &self,
        node_id: Uuid,
        learner_id: Uuid,
        confidence: f32,
        config: &CognitiveFrictionConfig,
    ) -> AppResult<Option<FrictionAdjustment>>;

    // ── Consolidation Window ──
    async fn is_in_consolidation_window(
        &self,
        node_id: Uuid,
        learner_id: Uuid,
        config: &ConsolidationWindowConfig,
    ) -> AppResult<bool>;

    // ── Sparring ──
    async fn propose_sparring(
        &self,
        learner_id: Uuid,
        node_id: Uuid,
        confidence: f32,
        config: &SparringConfig,
    ) -> AppResult<Option<SparringProposition>>;

    // ── Semantic Tree Priority ──
    async fn calculate_priority(
        &self,
        node_id: Uuid,
        tree_id: Uuid,
        sigma_density: f32,
        trunk_priority: f32,
        depth: u32,
        config: &SemanticTreePriorityConfig,
    ) -> AppResult<f32>;
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OutputPressureResult {
    pub applied: bool,
    pub policy: OutputPressurePolicy,
    pub pressure_level: f32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FrictionAdjustment {
    pub old_friction: f32,
    pub new_friction: f32,
    pub zone: FrictionZone,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum FrictionZone {
    Low,       // confidence < 0.3 → baisser friction
    Optimal,   // 0.3-0.6 → maintenir
    High,      // > 0.6 → augmenter friction
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SparringProposition {
    pub proposition_id: Uuid,
    pub learner_id: Uuid,
    pub node_id: Uuid,
    pub opponent_role: String,
    pub scenario_spec: JsonValue,
}
```

---

## 6. EventBus Events (extensions)

### 6.1 OutputPressureApplied

```rust
// EventPayload variant (ajout à WP03)
OutputPressureApplied {
    policy: OutputPressurePolicy,
    target_node_id: Uuid,
    pressure_level: f32,
    triggered_by: AlertClass,
}
```

### 6.2 FrictionAdjusted

```rust
// EventPayload variant (ajout à WP03)
FrictionAdjusted {
    target_kind: String,       // "node" | "learner"
    target_id: Uuid,
    old_friction: f32,
    new_friction: f32,
    zone: FrictionZone,
}
```

---

## 7. Logique des policies (implémentation guide)

### 7.1 Output Pressure

```
TRIGGER: autonomie >= L3 (gotten via AutonomyDecisionEngine)
ACTION: OutputPressureApplied event publié
EFFET: L'apprenant DOIT produire une sortie avant de continuer
```

### 7.2 Cognitive Friction

```
TRIGGER: confidence dans [0.3, 0.6] (zone optimale) → friction maintenue
         confidence < 0.3 (zone basse) → friction baissée de 0.1
         confidence > 0.6 (zone haute) → friction augmentée de 0.1
ACTION: FrictionAdjusted event publié
CLAMP: friction toujours dans [0.0, 1.0]
```

### 7.3 Consolidation Window

```
TRIGGER: 24h pack-définies sans review du nœud
ACTION: Le nœud entre en fenêtre de consolidation
EFFET: Reviews supplémentaires bloquées pendant la fenêtre
```

### 7.4 Sparring

```
TRIGGER: confidence > mastery_threshold (pack-défini)
ACTION: SparringProposed event publié + keep-alive pour buyer (D-005)
NORME: Le buyer ne peut pas mourir tant que seller n'a pas le listing
```

### 7.5 Semantic Tree Priority

```
PRIORITÉ = trunk_weight × trunk_priority
         + sigma_weight × sigma_density × decay_factor^depth
         + max_depth_boost × (1.0 - depth / MAX_DEPTH)

HIGHEST PRIORITY NODE = celui avec la plus haute priorité
```

---

## 8. Tests à fournir

### 8.1 `tests/output_pressure_test.rs`

```rust
#[test]
fn output_pressure_applied_event_published() {
    let policy = OutputPressureConfig::default();
    let result = engine.apply_output_pressure(node_id, learner_id, &policy).await;
    assert!(result.is_ok());
    // Vérifier que OutputPressureApplied a été publié
}

#[test]
fn output_pressure_respects_cooldown() {
    // Deux appels dans le cooldown (300s) → le deuxième ne fait rien
}
```

### 8.2 `tests/friction_adjustment_test.rs`

```rust
#[test]
fn low_confidence_decreases_friction() {
    let adjustment = engine.adjust_friction(node_id, learner_id, 0.2, &config).await;
    assert_eq!(adjustment.new_friction, old_friction - 0.1);
}

#[test]
fn high_confidence_increases_friction() {
    let adjustment = engine.adjust_friction(node_id, learner_id, 0.8, &config).await;
    assert_eq!(adjustment.new_friction, old_friction + 0.1);
}

#[test]
fn optimal_zone_preserves_friction() {
    let adjustment = engine.adjust_friction(node_id, learner_id, 0.45, &config).await;
    assert_eq!(adjustment.zone, FrictionZone::Optimal);
}
```

### 8.3 `tests/tree_priority_test.rs`

```rust
#[test]
fn trunk_node_has_higher_priority_than_leaf_same_depth() {
    let trunk_priority = calculate_priority(trunk_node, tree, 0.5, 1.0, 0, &config);
    let leaf_priority = calculate_priority(leaf_node, tree, 0.5, 0.1, 1, &config);
    assert!(trunk_priority > leaf_priority);
}
```

---

## 9. Checklist de livraison

- [ ] `OutputPressurePolicy` enum + `OutputPressureConfig`
- [ ] `CognitiveFrictionConfig` + `FrictionZone` enum
- [ ] `ConsolidationWindowConfig`
- [ ] `SparringConfig` + `SparringProposition`
- [ ] `SemanticTreePriorityConfig`
- [ ] `CognitivePoliciesConfig` + `default_for()` builder
- [ ] `CognitivePolicyEvaluator` trait (5 méthodes)
- [ ] `OutputPressureResult`, `FrictionAdjustment` structs
- [ ] EventPayload variants: OutputPressureApplied, FrictionAdjusted
- [ ] Logique Output Pressure (trigger + cooldown)
- [ ] Logique Cognitive Friction (3 zones)
- [ ] Logique Consolidation Window
- [ ] Logique Sparring (keep-alive + master threshold)
- [ ] Logique Semantic Tree Priority (formule)
- [ ] Tests friction zones (low/optimal/high)
- [ ] Tests tree priority (trunk vs leaf)
- [ ] Tests cooldown output pressure
- [ ] `cargo check -p scy-shared` passe

---

## 10. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter l"Autonomy Decision Engine complet (WP07)
- ❌ Implémenter Loop Engineering (WP09)
- ❌ Créer des migrations SQL
- ❌ Modifier les types Rust de WP01
- ❌ Implémenter Deployment Profiles (WP13)

---

*Fin du WORK PACKAGE 08. Implémente UNIQUEMENT ce qui est dans ce fichier.*

# WORK PACKAGE 09 — Loop Engineering Types + Macro Loop Evaluator

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Bloquant pour WP14+ (orchestration Mastra, ARENA simulation)
> **Dépendances** : WP01 (types), WP03 (EventBus), WP07 (Autonomy Envelope), WP08 (Cognitive Policies)
> **Références** : `MASTER_AGENT_PROMPT.md` (Règle #6), `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` (D-025, D-026), `work_package_03_eventbus_crate.md`

---

## 1. Objectif

Implémenter le système **Loop Engineering** de SCY Forge : 4 boucles imbriquées (Micro/Meso/Macro/Outcome) avec évaluateur Macro loop, EventBus events associés, et intégration avec les Cognitive Runtime Policies.

**Livrable** : Types Rust `LoopEngineeringConfig` + `LoopEvaluator` + EventBus events (LoopEvaluated, TriggerHit, SparringProposed, SparringExecuted, SpyReportReceived) + tests, `cargo check` passe.

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` — section D-025 (Loop Engineering) et D-026 (Cognitive Runtime Policies)
2. `work_package_03_eventbus_crate.md` — EventType LoopEvaluated, TriggerHit, SparringProposed, SparringExecuted, SpyReportReceived
3. `work_package_07_autonomy_envelope.md` — AlertClass, AutonomyMode
4. `work_package_08_cognitive_policies.md` — OutputPressure, Sparring config

---

## 3. Les 4 Boucles (D-025)

```
╔══════════════════════════════════════════════════════════════╗
║                    LOOP ENGINEERING (D-025)                   ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  ║
║  │  OUTCOME     │    │    MACRO     │    │    MESO      │  ║
║  │   LOOP       │◄──►│    LOOP      │◄──►│    LOOP      │  ║
║  │              │    │              │    │              │  ║
║  │ Résultat de  │    │ Institution  │    │ Enchaîne-    │  ║
║  │ corps        │    │ (R1-R5)      │    │ ment         │  ║
║  │ (SM-3)       │    │ (D-025)      │    │ (D-007)      │  ║
║  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘  ║
║         │                   │                   │          ║
║         │    ┌──────────────┘                   │          ║
║         │    │    ┌──────────────────────────────┘          ║
║         │    │    │    ┌──────────────────────────────────┐ ║
║         │    │    │    │          MICRO LOOP             │ ║
║         │    │    │    │   Geste opératoire (SEVIA)      │ ║
║         │    │    │    │   R1 Trigger → R2 Action → R3   │ ║
║         │    │    │    │   Proof → Mastery → Sparring    │ ║
║         │    │    │    └──────────────────────────────────┘ ║
║         │    │    │                                        ║
║  Chaque niveaux "remplit" le niveau supérieur               ║
║  (Outcome ← Macro ← Meso ← Micro)                          ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
```

| Niveau | Nom | Scope | Granularité | Output |
|--------|-----|-------|-------------|--------|
| **Micro** | Geste opératoire | Une action unitaire | Seconde | Skill验证 |
| **Meso** | Enchaînement | Séquence de gestes | Minute | Procedure验证 |
| **Macro** | Institution | Processus métier | Heure/Jour | Capability验证 |
| **Outcome** | Corps | Résultat business | Semaine/Mois | ROI验证 |

---

## 4. Types Rust à créer dans `types.rs`

### 4.1 `LoopLevel` (déjà en WP03, rappel)

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum LoopLevel {
    Micro,   // geste opératoire
    Meso,    // enchaînement
    Macro,   // institution
    Outcome, // résultat de corps
}
```

### 4.2 `LoopId` (8 processus métier, déjà en WP03)

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum LoopId {
    InvestigatorMgmt,
    InvestigationProc,
    Feasibility,
    BusinessAnalysis,
    RequirementAnalysis,
    SecurityRequirements,
    Procurement,
    Development,
}
```

### 4.3 `LoopEvaluation` + `LoopContext`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LoopEvaluation {
    pub loop_id: LoopId,
    pub loop_level: LoopLevel,
    pub evaluated_at: i64,
    pub confidence: f32,
    pub mastery_score: f32,
    pub is_mastered: bool,
    pub trigger_r2: bool,           // R2 déclenché (action requise)
    pub next_review_epoch_ms: u64,
    pub evidence_summary: JsonValue,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LoopContext {
    pub loop_id: LoopId,
    pub loop_level: LoopLevel,
    pub parent_loop: Option<(LoopId, LoopLevel)>, // boucle parente (si applicable)
    pub child_loops: Vec<(LoopId, LoopLevel)>,     // boucles filles
    pub skill_nodes: Vec<Uuid>,  // SemanticNode IDs appartenant à cette boucle
    pub sparring_active: bool,
}

impl LoopContext {
    pub fn new(loop_id: LoopId, loop_level: LoopLevel) -> Self {
        Self {
            loop_id,
            loop_level,
            parent_loop: None,
            child_loops: vec![],
            skill_nodes: vec![],
            sparring_active: false,
        }
    }
}
```

### 4.4 `TriggerR2` (D-007 / D-008)

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TriggerR2 {
    pub triggered: bool,
    pub trigger_kind: String,        // "reschedule" | "immediate" | "sparring" | "handoff"
    pub trigger_reason: String,
    pub loop_id: LoopId,
    pub loop_level: LoopLevel,
    pub triggered_at: i64,
    pub meta: HashMap<String, String>, // max 2 niveaux (Règle EventBus #7)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum TriggerKind {
    Reschedule,   // re-programmer
    Immediate,    // action immédiate
    Sparring,     // opposant pédagogique
    Handoff,      // transfert humain
}
```

### 4.5 `SparringTrack`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SparringTrack {
    pub id: Uuid,
    pub proposition_id: Uuid,
    pub learner_id: Uuid,
    pub node_id: Uuid,
    pub opponent_role: String,
    pub scenario_spec: JsonValue,
    pub started_at: i64,
    pub ended_at: Option<i64>,
    pub outcome: SparringOutcome,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum SparringOutcome {
    Pending,
    LearnerWon,
    LearnerLost,
    Draw,
    Cancelled,
}
```

### 4.6 `SpyReport` (D-003)

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SpyReport {
    pub id: Uuid,
    pub scope: TriggerScope,
    pub report_type: String,     // "score" | "competition" | "audit"
    pub data: JsonValue,          // max 2 niveaux de profondeur
    pub receiver_id: Uuid,
    pub received_at: i64,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum TriggerScope {
    Corporate,    // intra-organisation
    Private,      // inter-organisation
    CoreLedger,   // plateforme
}
```

### 4.7 `LoopEngineeringConfig`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LoopEngineeringConfig {
    pub pack_id: String,
    pub micro_eval_interval_sec: u64,
    pub meso_eval_interval_sec: u64,
    pub macro_eval_interval_sec: u64,
    pub outcome_eval_interval_sec: u64,
    pub r2_trigger_confidence: f32,     // confidence > threshold → R2
    pub sparring_mastery_threshold: f32, // confidence > threshold → sparring
    pub handoff_alert_threshold: AlertClass,
    pub consolidation_window_sec: u64,
}
```

---

## 5. LoopEvaluator — Macro Loop Evaluator

```rust
//! Évaluateur de boucles Macro (institution).
//! Référence: D-025 (Loop Engineering), D-007 (R1/R2).

use async_trait::async_trait;
use std::collections::HashMap;

pub struct LoopEvaluator {
    packs: HashMap<String, LoopEngineeringConfig>,
    evaluations: HashMap<(LoopId, LoopLevel), LoopEvaluation>,
}

impl LoopEvaluator {
    pub fn new() -> Self {
        Self {
            packs: HashMap::new(),
            evaluations: HashMap::new(),
        }
    }

    pub fn register_pack(&mut self, config: LoopEngineeringConfig) {
        self.packs.insert(config.pack_id.clone(), config);
    }

    /// Évaluer un nœud dans le contexte de sa boucle.
    /// Retourne une LoopEvaluation avec trigger_r2 si applicable.
    pub fn evaluate_node(
        &self,
        node_id: Uuid,
        confidence: f32,
        loop_id: LoopId,
        loop_level: LoopLevel,
        pack_id: &str,
    ) -> AppResult<LoopEvaluation> {
        let config = self.packs.get(pack_id)
            .ok_or_else(|| AppError::PackNotFound(pack_id.to_string()))?;

        let is_mastered = confidence >= config.r2_trigger_confidence;
        let trigger_r2 = confidence > config.r2_trigger_confidence;

        // Calculer next_review_epoch_ms (FSRS-inspired)
        let next_review_ms = self.calculate_next_review(confidence, loop_level, config);

        Ok(LoopEvaluation {
            loop_id,
            loop_level,
            evaluated_at: chrono::Utc::now().timestamp(),
            confidence,
            mastery_score: confidence, // MVP: identity, puis SMI pondéré
            is_mastered,
            trigger_r2,
            next_review_epoch_ms: next_review_ms,
            evidence_summary: JsonValue::Null,
        })
    }

    /// Évaluer une Macro loop complète (tous les Meso loops enfants).
    pub fn evaluate_macro(
        &self,
        macro_loop: LoopId,
        meso_evals: &[LoopEvaluation],
        pack_id: &str,
    ) -> AppResult<LoopEvaluation> {
        let config = self.packs.get(pack_id)
            .ok_or_else(|| AppError::PackNotFound(pack_id.to_string()))?;

        // Moyenne des Meso evaluations (MVP)
        let avg_confidence = if meso_evals.is_empty() {
            0.0
        } else {
            meso_evals.iter().map(|e| e.confidence).sum::<f32>() / meso_evals.len() as f32
        };

        let is_mastered = avg_confidence >= config.r2_trigger_confidence;
        let triggered_r2 = is_mastered && meso_evals.iter().any(|e| e.trigger_r2);

        Ok(LoopEvaluation {
            loop_id: macro_loop,
            loop_level: LoopLevel::Macro,
            evaluated_at: chrono::Utc::now().timestamp(),
            confidence: avg_confidence,
            mastery_score: avg_confidence,
            is_mastered,
            trigger_r2: triggered_r2,
            next_review_epoch_ms: self.calculate_next_review(avg_confidence, LoopLevel::Macro, config),
            evidence_summary: JsonValue::Null,
        })
    }

    fn calculate_next_review(&self, confidence: f32, loop_level: LoopLevel, config: &LoopEngineeringConfig) -> u64 {
        let base_interval = match loop_level {
            LoopLevel::Micro => config.micro_eval_interval_sec,
            LoopLevel::Meso => config.meso_eval_interval_sec,
            LoopLevel::Macro => config.macro_eval_interval_sec,
            LoopLevel::Outcome => config.outcome_eval_interval_sec,
        };

        // FSRS-inspired: intervalle exponentiel basé sur confidence
        // interval = base × (1 + confidence × 2)
        let multiplier = 1.0 + confidence * 2.0;
        (base_interval as f32 * multiplier) as u64
    }

    /// Vérifier si R2 doit être déclenché pour un nœud donné.
    pub fn check_r2_trigger(&self, node_id: Uuid, confidence: f32, loop_id: LoopId, pack_id: &str) -> AppResult<Option<TriggerR2>> {
        let config = self.packs.get(pack_id)
            .ok_or_else(|| AppError::PackNotFound(pack_id.to_string()))?;

        if confidence > config.r2_trigger_confidence {
            let trigger_kind = if confidence > 0.9 {
                TriggerKind::Sparring
            } else if confidence > 0.85 {
                TriggerKind::Reschedule
            } else {
                TriggerKind::Immediate
            };

            Ok(Some(TriggerR2 {
                triggered: true,
                trigger_kind: format!("{:?}", trigger_kind),
                trigger_reason: format!("confidence {} > threshold {}", confidence, config.r2_trigger_confidence),
                loop_id,
                loop_level: LoopLevel::Meso,
                triggered_at: chrono::Utc::now().timestamp(),
                meta: vec![("node_id".to_string(), node_id.to_string())].into_iter().collect(),
            }))
        } else {
            Ok(None)
        }
    }
}
```

### 5.1 `LoopEvaluator` — `evaluate()` point d'entrée unifié

```rust
/// Point d'entrée unifié pour évaluer n'importe quel niveau de boucle.
pub fn evaluate(
    &self,
    loop_id: LoopId,
    loop_level: LoopLevel,
    confidence: f32,
    pack_id: &str,
) -> AppResult<LoopEvaluation> {
    match loop_level {
        LoopLevel::Micro => self.evaluate_micro(loop_id, confidence, pack_id),
        LoopLevel::Meso => self.evaluate_meso(loop_id, confidence, pack_id),
        LoopLevel::Macro => self.evaluate_macro_composite(loop_id, confidence, pack_id),
        LoopLevel::Outcome => self.evaluate_outcome(loop_id, confidence, pack_id),
    }
}

fn evaluate_micro(&self, loop_id: LoopId, confidence: f32, pack_id: &str) -> AppResult<LoopEvaluation> {
    // Micro: évaluation par geste unitaire
    // R2 si confidence > 0.7
    let config = self.packs.get(pack_id).ok_or_else(|| AppError::PackNotFound(pack_id.to_string()))?;
    let trigger_r2 = confidence > config.r2_trigger_confidence;

    Ok(LoopEvaluation {
        loop_id,
        loop_level: LoopLevel::Micro,
        evaluated_at: chrono::Utc::now().timestamp(),
        confidence,
        mastery_score: confidence,
        is_mastered: confidence >= config.r2_trigger_confidence,
        trigger_r2,
        next_review_epoch_ms: self.calculate_next_review(confidence, LoopLevel::Micro, config),
        evidence_summary: JsonValue::Null,
    })
}

fn evaluate_meso(&self, loop_id: LoopId, confidence: f32, pack_id: &str) -> AppResult<LoopEvaluation> {
    // Meso: évaluation par enchaînement de gestes
    // Agrège les micro evaluations
    let micro_evals = self.get_micro_evaluations_for_loop(loop_id);
    let avg_confidence = if micro_evals.is_empty() {
        confidence
    } else {
        micro_evals.iter().map(|e| e.confidence).sum::<f32>() / micro_evals.len() as f32
    };

    let config = self.packs.get(pack_id).ok_or_else(|| AppError::PackNotFound(pack_id.to_string()))?;
    let trigger_r2 = avg_confidence > config.r2_trigger_confidence;

    Ok(LoopEvaluation {
        loop_id,
        loop_level: LoopLevel::Meso,
        evaluated_at: chrono::Utc::now().timestamp(),
        confidence: avg_confidence,
        mastery_score: avg_confidence,
        is_mastered: avg_confidence >= config.r2_trigger_confidence,
        trigger_r2,
        next_review_epoch_ms: self.calculate_next_review(avg_confidence, LoopLevel::Meso, config),
        evidence_summary: JsonValue::Null,
    })
}

fn evaluate_macro_composite(&self, loop_id: LoopId, confidence: f32, pack_id: &str) -> AppResult<LoopEvaluation> {
    // Macro: évaluation composite des Meso loops
    let meso_evals = self.get_meso_evaluations_for_macro(loop_id);
    self.evaluate_macro(loop_id, &meso_evals, pack_id)
}

fn evaluate_outcome(&self, loop_id: LoopId, confidence: f32, pack_id: &str) -> AppResult<LoopEvaluation> {
    // Outcome: agrège les Macro evaluations + métriques business
    let macro_evals = self.get_macro_evaluations_for_outcome(loop_id);
    let avg_confidence = if macro_evals.is_empty() {
        confidence
    } else {
        macro_evals.iter().map(|e| e.confidence).sum::<f32>() / macro_evals.len() as f32
    };

    Ok(LoopEvaluation {
        loop_id,
        loop_level: LoopLevel::Outcome,
        evaluated_at: chrono::Utc::now().timestamp(),
        confidence: avg_confidence,
        mastery_score: avg_confidence,
        is_mastered: avg_confidence >= 0.8, // outcome threshold = 0.8 par défaut (pack-défini)
        trigger_r2: false, // Outcome ne déclenche pas R2 directement
        next_review_epoch_ms: 0, // Outcome = pas de re-review programmée
        evidence_summary: JsonValue::Null,
    })
}
```

---

## 6. EventBus Events (extensions WP03)

### 6.1 LoopEvaluated

```rust
// EventPayload variant
LoopEvaluated {
    loop_id: LoopId,
    loop_level: LoopType,
    trigger_r2: bool,
    evaluated_at: i64,
}
```

### 6.2 TriggerHit

```rust
// EventPayload variant
TriggerHit {
    scope: TriggerScope,
    trigger_kind: String,    // "reschedule" | "immediate" | "sparring" | "handoff"
    triggered_at: i64,
    meta: HashMap<String, String>,  // max 2 niveaux
}
```

### 6.3 SparringProposed

```rust
// EventPayload variant (déjà en WP03, rappel)
SparringProposed {
    proposition_id: Uuid,
    seller_id: Uuid,
    buyer_kind: String,
    buyer_id: Uuid,
}
```

### 6.4 SparringExecuted

```rust
// EventPayload variant (déjà en WP03, rappel)
SparringExecuted {
    proposition_id: Uuid,
    auction_running: bool,
    seller_invoiced: bool,
}
```

### 6.5 SpyReportReceived

```rust
// EventPayload variant (déjà en WP03, rappel)
SpyReportReceived {
    scope: TriggerScope,
    report: HashMap<String, String>,
    receiver_id: Uuid,
}
```

---

## 7. Intégration avec Cognitive Runtime Policies

Le LoopEvaluator interagit avec les 5 policies de WP08 :

| Policy | Interaction avec Loop Engineering |
|--------|----------------------------------|
| **OutputPressure** | Si `trigger_r2` sur Macro loop → OutputPressureApplied |
| **CognitiveFriction** | Si confidence dans zone haute de Macro → friction augmentée |
| **ConsolidationWindow** | Si `next_review_epoch_ms` < maintenant → consolidation window |
| **Sparring** | Si `trigger_r2` + confidence > mastery_threshold → SparringProposed |
| **SemanticTreePriority** | Priority = f(loop_level, mastery_score, trunkPriority) |

```rust
impl LoopEvaluator {
    /// Intégration Cognitive Policies : après évaluation, déclencher les policies.
    pub async fn evaluate_with_policies(
        &self,
        node_id: Uuid,
        confidence: f32,
        loop_id: LoopId,
        loop_level: LoopLevel,
        pack_id: &str,
        policies: &CognitivePoliciesConfig,
        event_bus: &Arc<dyn EventBus>,
    ) -> AppResult<LoopEvaluation> {
        let eval = self.evaluate_node(node_id, confidence, loop_id, loop_level, pack_id)?;

        // Sparring si mastery + R2
        if eval.trigger_r2 && confidence > policies.sparring.mastery_threshold {
            let _ = event_bus.publish(Event {
                event_type: EventType::SparringProposed,
                payload: EventPayload::SparringProposed {
                    proposition_id: Uuid::new_v4(),
                    seller_id: node_id,
                    buyer_kind: "learner".to_string(),
                    buyer_id: Uuid::new_v4(),
                },
                ..Default::default()
            }).await;
        }

        // Output Pressure si R2 sur Macro/Outcome
        if eval.trigger_r2 && loop_level >= LoopLevel::Macro {
            let _ = event_bus.publish(Event {
                event_type: EventType::OutputPressureApplied,
                payload: EventPayload::OutputPressureApplied {
                    policy: OutputPressurePolicy::Standard,
                    target_node_id: node_id,
                    pressure_level: confidence,
                    triggered_by: AlertClass::L3,
                },
                ..Default::default()
            }).await;
        }

        // LoopEvaluated event
        let _ = event_bus.publish(Event {
            event_type: EventType::LoopEvaluated,
            payload: EventPayload::LoopEvaluated {
                loop_id,
                loop_type: LoopType::Meso,  // FIXME: use loop_level
                trigger_r2: eval.trigger_r2,
                evaluated_at: eval.evaluated_at,
            },
            ..Default::default()
        }).await;

        Ok(eval)
    }
}
```

---

## 8. Tests à fournir

### 8.1 `tests/loop_evaluator_test.rs`

```rust
#[test]
fn micro_loop_triggers_r2_above_threshold() {
    let evaluator = LoopEvaluator::new();
    let eval = evaluator.evaluate_micro(LoopId::InvestigatorMgmt, 0.8, "cyber").unwrap();
    assert!(eval.trigger_r2);
    assert!(eval.is_mastered);
}

#[test]
fn macro_loop_aggregates_meso_evaluations() {
    let evaluator = LoopEvaluator::new();
    let meso_evals = vec![
        LoopEvaluation { confidence: 0.8, ..default() },
        LoopEvaluation { confidence: 0.6, ..default() },
    ];
    let eval = evaluator.evaluate_macro(LoopId::InvestigatorMgmt, &meso_evals, "cyber").unwrap();
    assert!((eval.confidence - 0.7).abs() < 0.01);
}

#[test]
fn next_review_increases_with_confidence() {
    let evaluator = LoopEvaluator::new();
    let low = evaluator.calculate_next_review(0.3, LoopLevel::Micro, &default_config());
    let high = evaluator.calculate_next_review(0.9, LoopLevel::Micro, &default_config());
    assert!(high > low);
}
```

### 8.2 `tests/loop_context_test.rs`

```rust
#[test]
fn loop_context_has_correct_level() {
    let ctx = LoopContext::new(LoopId::Development, LoopLevel::Macro);
    assert_eq!(ctx.loop_level, LoopLevel::Macro);
    assert_eq!(ctx.loop_id, LoopId::Development);
}
```

---

## 9. Checklist de livraison

- [ ] `LoopLevel` enum (4 variants)
- [ ] `LoopId` enum (8 variants)
- [ ] `LoopEvaluation` struct
- [ ] `LoopContext` struct
- [ ] `TriggerR2` struct + `TriggerKind` enum
- [ ] `SparringTrack` struct + `SparringOutcome` enum
- [ ] `SpyReport` struct + `TriggerScope` enum
- [ ] `LoopEngineeringConfig` struct
- [ ] `LoopEvaluator` — `evaluate()`, `evaluate_micro()`, `evaluate_meso()`, `evaluate_macro_composite()`, `evaluate_outcome()`
- [ ] `LoopEvaluator::check_r2_trigger()`
- [ ] `LoopEvaluator::evaluate_with_policies()` — intégration Cognitive Policies
- [ ] `LoopEvaluator::calculate_next_review()` — FSRS-inspired
- [ ] EventPayload variants: LoopEvaluated, TriggerHit, SpyReportReceived
- [ ] Tests loop evaluator (micro R2, macro aggregate, next review)
- [ ] Tests loop context
- [ ] `cargo check -p scy-shared` passe
- [ ] `cargo check -p scy-postgres` passe

---

## 10. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter le Macro Loop avec Sparklines (ARENA simulation engine)
- ❌ Implémenter les agents ASCENT qui consomment les LoopEvaluated events
- ❌ Créer des migrations SQL (déjà fait en WP02)
- ❌ Modifier les types Rust de WP01
- ❌ Implémenter le Deployment Profiles complet (WP13)
- ❌ Implémenter MeshWork/Keep-alive (D-005)

---

*Fin du WORK PACKAGE 09. Implémente UNIQUEMENT ce qui est dans ce fichier. Si tu as un doute, demande.*

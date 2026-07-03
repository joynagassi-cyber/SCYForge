# WORK PACKAGE 07 — AutonomyEnvelopeSpec + DB Schema + EventBus Events

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Bloquant pour le déploiement (ValidationGuard, Autonomy Envelope)
> **Dépendances** : WP01 (types), WP02 (migrations), WP03 (EventBus), WP06 (Seed)
> **Références** : `MASTER_AGENT_PROMPT.md` (Règle #8), `docs/SCYFORGE_PIVOT_ARCHITECTURE.md` (§15), `docs/SCYFORGE_DEPLOYMENT_PROFILES_SPEC.md`, `WORK_PACKAGE_02_SQL_MIGRATIONS.md`

---

## 1. Objectif

Implémenter l"Autonomy Envelope — la couche de sécurité défensive qui régule l"autonomie opérationnelle des agents IA selon 4 modes et une grille classe d"alerte × risque.

**Livrable** : Types Rust `AutonomyEnvelopeSpec` + migration SQL v005 (scy_autonomy_logs) + EventBus events (OutputPressureApplied, FrictionAdjusted) + tests, `cargo check` passe.

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `docs/SCYFORGE_PIVOT_ARCHITECTURE.md` — §15 (Autonomy Envelope spec complète)
2. `docs/SCYFORGE_DEPLOYMENT_PROFILES_SPEC.md` — §4 (Autonomy Envelope ceilings par profile)
3. `WORK_PACKAGE_02_SQL_MIGRATIONS.md` — pattern de migration SQL
4. `WORK_PACKAGE_03_EVENTBUS_CRATE.md` — EventType OutputPressureApplied, FrictionAdjusted

---

## 3. Contraintes NON-NÉNÉGOTIABLES

1. **4 modes d"autonomie** : `shadow` / `guarded` / `autonomous` / `handoff`. Chaque mode a un ceiling différent.
2. **Grille classe d"alerte × risque** : 4×4 = 16 combinaisons. Chaque cellule = action obligatoire (block/warn/log/escalate).
3. **Déploiement profile-aware** : MSSP/MDR vs regulated_internal ont des ceilings différents.
4. **Toute décision est loggée** dans `scy_autonomy_logs` (pas d"action sans trace).
5. **EventBus obligatoire** pour chaque action d"autonomie (OutputPressureApplied, FrictionAdjusted).
6. **Zéro logique métier cyber dans le core**. L"Autonomy Envelope ne sait pas ce qu"est un "phishing" — seulement "alerte_niveau" et "risque_niveau".
7. **Rollback automatique** : si une action échoue > 3 fois, l"Autonomy Envelope force le mode `guarded`.

---

## 4. Architecture du mode Autonomy

```
┌──────────────────────────────────────────────────────┐
│              AUTONOMY ENVELOPE                        │
│                                                       │
│  ┌─────────────┐      ┌──────────────────┐           │
│  │ 4 Modes     │      │ 5 Alert Classes  │           │
│  │             │      │ × Risk Levels    │           │
│  │ shadow      │      │                  │           │
│  │ guarded     │◄────►│ log (L1/R1)     │           │
│  │ autonomous  │      │ warn (L2/R2)    │           │
│  │ handoff     │      │ block (L3/R3)   │           │
│  └─────────────┘      │ escalate (L4)   │           │
│       ▲                │ criticality=L4  │           │
│       │                └──────────────────┘           │
│       │                                                 │
│  Ceiling par deploy profile                            │
│  MSSP/MDR: shadow ≥ L2, guarded ≥ L3                 │
│  regulated_internal: shadow ≥ L1, guarded ≥ L2       │
│                                                       │
│  Rollback: >3 fail → forced guarded                   │
└──────────────────────────────────────────────────────┘
```

---

## 5. Types Rust à créer dans `types.rs` (WP01 extended)

### 5.1 `AutonomyMode`

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum AutonomyMode {
    /// Shadow: observe uniquement, aucune action autonome
    Shadow,
    /// Guarded: actions dans périmètre défini, validation humaine fournie
    Guarded,
    /// Autonomous: actions dans périmètre défini, pas de validation humaine
    Autonomous,
    /// Handoff: transfert automatique vers intervenant humain
    Handoff,
}

impl std::fmt::Display for AutonomyMode {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            AutonomyMode::Shadow => write!(f, "shadow"),
            AutonomyMode::Guarded => write!(f, "guarded"),
            AutonomyMode::Autonomous => write!(f, "autonomous"),
            AutonomyMode::Handoff => write!(f, "handoff"),
        }
    }
}
```

### 5.2 `AlertClass` (5 niveaux, pas 4)

```
DÉFINITION DES CLASSES D'ALERTE (référence: autonomie framework):

L1 — Information:      Aucune action requise, simple logging
L2 — Attention:        Action possible, avertissement fourni
L3 — Intervention:     Intervention nécessaire, action bloquée sans validation
L4 — Critique:         Escalation automatique, arrêt du workflow
L5 — Critique Unique:  Circulation perturbée sur 2+ organes, contrat stratégique affecté
```

**Note** : L4 et L5 sont distincts. L5 implique L4 + impact multi-organes.

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum AlertClass {
    L1,  // Information
    L2,  // Attention
    L3,  // Intervention
    L4,  // Critique
    L5,  // Critique Unique (multi-organes)
}
```

### 5.3 `RiskLevel`

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum RiskLevel {
    R1,  # Faible
    R2,  # Modéré
    R3,  # Élevé
    R4,  // Critique
}
```

### 5.4 `AutonomyDecision`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AutonomyDecision {
    pub id: Uuid,
    pub timestamp: i64,
    pub mode: AutonomyMode,
    pub alert_class: AlertClass,
    pub risk_level: RiskLevel,
    pub action: AutonomyAction,
    pub outcome: AutonomyOutcome,
    pub context: JsonValue,        // max 2 niveaux (Règle EventBus #7)
    pub actor: String,             // agent/service qui a demandé l'action
    pub reviewer: Option<String>,  // humain qui a validé (si guarded)
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum AutonomyAction {
    Log,          // Enregistrer l'événement
    Warn,         // Avertir l'utilisateur
    Block,        # Bloquer l'action, demander validation
    Escalate,     // Escalader vers intervenant
    Execute,      // Exécuter l'action autonome
    Handoff,      // Transférer à un humain
    Rollback,     # Annuler l'action précédente
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum AutonomyOutcome {
    Pending,      // En attente de décision
    Approved,     # Approuvé (humain ou système)
    Rejected,     # Rejeté
    Executed,     # Exécuté avec succès
    Failed,       # Échec (déclenche rollback si > 3)
    Escalated,    # Escaladé vers L4/L5
    RolledBack,   # Rollback effectué
}
```

### 5.5 `AutonomyEnvelopeSpec`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AutonomyEnvelopeSpec {
    pub id: Uuid,
    pub profile_ref: String,           // "mssp_mdr" ou "regulated_internal"
    pub mode: AutonomyMode,
    pub alert_risk_grid: AlertRiskGrid, // 5×4 = 20 cellules
    pub rollback_threshold: u32,       // nb d'échecs avant forced guarded (défaut: 3)
    pub max_autonomous_duration_sec: u64, // durée max sans checkin humain
    pub created_at: i64,
    pub updated_at: i64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AlertRiskGrid {
    pub cells: HashMap<(AlertClass, RiskLevel), AutonomyAction>,
}

impl AlertRiskGrid {
    pub fn mssp_mdr() -> Self {
        let mut cells = HashMap::new();
        // MSSP/MDR — moins restrictif
        cells.insert((AlertClass::L1, RiskLevel::R1), AutonomyAction::Log);
        cells.insert((AlertClass::L1, RiskLevel::R2), AutonomyAction::Log);
        cells.insert((AlertClass::L2, RiskLevel::R1), AutonomyAction::Warn);
        cells.insert((AlertClass::L2, RiskLevel::R2), AutonomyAction::Warn);
        cells.insert((AlertClass::L3, RiskLevel::R1), AutonomyAction::Execute);
        cells.insert((AlertClass::L3, RiskLevel::R2), AutonomyAction::Execute);
        cells.insert((AlertClass::L4, RiskLevel::R1), AutonomyAction::Block);
        cells.insert((AlertClass::L4, RiskLevel::R2), AutonomyAction::Escalate);
        cells.insert((AlertClass::L5, RiskLevel::R1), AutonomyAction::Escalate);
        // R3-R4 = toujours Escalate
        for l in [AlertClass::L2, AlertClass::L3, AlertClass::L4, AlertClass::L5] {
            cells.insert((l, RiskLevel::R3), AutonomyAction::Escalate);
            cells.insert((l, RiskLevel::R4), AutonomyAction::Escalate);
        }
        Self { cells }
    }

    pub fn regulated_internal() -> Self {
        let mut cells = HashMap::new();
        // Regulated internal — plus restrictif
        cells.insert((AlertClass::L1, RiskLevel::R1), AutonomyAction::Log);
        cells.insert((AlertClass::L1, RiskLevel::R2), AutonomyAction::Warn);
        cells.insert((AlertClass::L2, RiskLevel::R1), AutonomyAction::Warn);
        cells.insert((AlertClass::L2, RiskLevel::R2), AutonomyAction::Block);
        cells.insert((AlertClass::L3, RiskLevel::R1), AutonomyAction::Block);
        cells.insert((AlertClass::L3, RiskLevel::R2), AutonomyAction::Escalate);
        // L4/L5 et R3/R4 = toujours Block/Escalate
        for l in [AlertClass::L3, AlertClass::L4, AlertClass::L5] {
            cells.insert((l, RiskLevel::R3), AutonomyAction::Escalate);
            cells.insert((l, RiskLevel::R4), AutonomyAction::Escalate);
        }
        for r in [RiskLevel::R3, RiskLevel::R4] {
            cells.insert((AlertClass::L4, r), AutonomyAction::Escalate);
            cells.insert((AlertClass::L5, r), AutonomyAction::Escalate);
        }
        Self { cells }
    }
}
```

---

## 6. Migration SQL v005 — scy_autonomy_logs

**`up.sql`** :

```sql
-- ============================================================
-- V005 — Autonomy Envelope
-- Crée: scy_autonomy_logs, scy_autonomy_envelopes
-- Référence: D-004, D-005, PIVOT_ARCHITECTURE §15
-- ============================================================

-- ── scy_autonomy_envelopes ──
CREATE TABLE IF NOT EXISTS scy_autonomy_envelopes (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_ref                 TEXT NOT NULL CHECK (profile_ref IN ('mssp_mdr', 'regulated_internal')),
    mode                        TEXT NOT NULL CHECK (mode IN ('shadow', 'guarded', 'autonomous', 'handoff')),
    alert_risk_grid             JSONB NOT NULL,
    rollback_threshold          INTEGER NOT NULL DEFAULT 3,
    max_autonomous_duration_sec BIGINT NOT NULL DEFAULT 3600,
    created_at                  INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint),
    updated_at                  INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint),

    UNIQUE(profile_ref)
);

-- ── scy_autonomy_logs ──
CREATE TABLE IF NOT EXISTS scy_autonomy_logs (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    envelope_id         UUID NOT NULL REFERENCES scy_autonomy_envelopes(id) ON DELETE CASCADE,
    timestamp           INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint),
    mode                TEXT NOT NULL,
    alert_class         TEXT NOT NULL,
    risk_level          TEXT NOT NULL,
    action              TEXT NOT NULL,
    outcome             TEXT NOT NULL,
    actor               TEXT NOT NULL,
    reviewer            TEXT,
    context             JSONB NOT NULL DEFAULT '{}',

    CHECK (alert_class IN ('L1', 'L2', 'L3', 'L4', 'L5')),
    CHECK (risk_level IN ('R1', 'R2', 'R3', 'R4')),
    CHECK (action IN ('log', 'warn', 'block', 'escalate', 'execute', 'handoff', 'rollback')),
    CHECK (outcome IN ('pending', 'approved', 'rejected', 'executed', 'failed', 'escalated', 'rolled_back'))
);

-- ── Indexes ──
CREATE INDEX IF NOT EXISTS idx_autonomy_logs_envelope ON scy_autonomy_logs (envelope_id);
CREATE INDEX IF NOT EXISTS idx_autonomy_logs_timestamp ON scy_autonomy_logs (timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_autonomy_logs_outcome ON scy_autonomy_logs (outcome);
CREATE INDEX IF NOT EXISTS idx_autonomy_logs_alert_risk
    ON scy_autonomy_logs (alert_class, risk_level);

-- ── RLS ──
ALTER TABLE scy_autonomy_envelopes ENABLE ROW LEVEL SECURITY;
ALTER TABLE scy_autonomy_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY envelope_read ON scy_autonomy_envelopes FOR SELECT USING (true);
CREATE POLICY envelope_write ON scy_autonomy_envelopes FOR ALL USING (true);

CREATE POLICY autonomy_logs_insert ON scy_autonomy_logs
    FOR INSERT WITH CHECK (true);
CREATE POLICY autonomy_logs_select ON scy_autonomy_logs
    FOR SELECT USING (true);
```

**`down.sql`** :

```sql
DROP TABLE IF EXISTS scy_autonomy_logs CASCADE;
DROP TABLE IF EXISTS scy_autonomy_envelopes CASCADE;
```

---

## 7. EventBus Events (extensions WP03)

### 7.1 OutputPressureApplied

```rust
// EventPayload variant
OutputPressureApplied {
    policy: OutputPressurePolicy,  // Standard | Strict | Blocked
    target_node_id: Uuid,
    pressure_level: f32,           // 0.0–1.0
    triggered_by: AlertClass,      // quelle alerte a déclenché la pression
}
```

### 7.2 FrictionAdjusted

```rust
// EventPayload variant
FrictionAdjusted {
    target_kind: String,           // "agent" | "workflow" | "node"
    target_id: Uuid,
    old_friction: f32,
    new_friction: f32,
    reason: String,                // ex: "consecutive_failures_3"
}
```

---

## 8. Logique de décision Autonomy Envelope

```rust
//! Moteur de décision Autonomy Envelope.
//! Référence: PIVOT_ARCHITECTURE §15.

pub struct AutonomyDecisionEngine {
    envelope: AutonomyEnvelopeSpec,
    failure_count: HashMap<String, u32>, // actor → nb échecs consécutifs
}

impl AutonomyDecisionEngine {
    /// Point d'entrée unique: évalue une demande d'action.
    /// Retourne une AutonomyDecision (avec action et outcome).
    pub async fn evaluate(&mut self, request: AutonomyRequest) -> AppResult<AutonomyDecision> {
        // 1. Vérifier rollback threshold
        let failures = self.failure_count.entry(request.actor.clone()).or_insert(0);
        if *failures >= self.envelope.rollback_threshold {
            // Forcé en guarded
            self.envelope.mode = AutonomyMode::Guarded;
            *failures = 0; // reset après rollback
        }

        // 2. Chercher l'action dans la grille
        let cell = self.envelope.alert_risk_grid.cells;
        let action = cell.get(&(request.alert_class, request.risk_level))
            .copied()
            .unwrap_or(AutonomyAction::Block); // défaut = block

        // 3. Appliquer le mode courant
        let final_action = self.apply_mode_constraint(action, self.envelope.mode);

        // 4. Créer la décision
        let decision = AutonomyDecision {
            id: Uuid::new_v4(),
            timestamp: chrono::Utc::now().timestamp(),
            mode: self.envelope.mode,
            alert_class: request.alert_class,
            risk_level: request.risk_level,
            action: final_action,
            outcome: AutonomyOutcome::Pending,
            context: request.context,
            actor: request.actor,
            reviewer: None,
        };

        // 5. Logger
        self.log_decision(&decision).await?;

        // 6. Publier EventBus
        self.publish_decision_events(&decision).await?;

        Ok(decision)
    }

    fn apply_mode_constraint(&self, action: AutonomyAction, mode: AutonomyMode) -> AutonomyAction {
        match mode {
            AutonomyMode::Shadow => {
                // Shadow: jamais Execute, jamais Handoff direct
                match action {
                    AutonomyAction::Execute => AutonomyAction::Warn,
                    AutonomyAction::Handoff => AutonomyAction::Log,
                    _ => action,
                }
            }
            AutonomyMode::Guarded => {
                // Guarded: Execute nécessite reviewer
                match action {
                    AutonomyAction::Execute => AutonomyAction::Block,
                    _ => action,
                }
            }
            AutonomyMode::Autonomous => action,
            AutonomyMode::Handoff => {
                // Handoff: tout devient Handoff vers humain
                AutonomyAction::Handoff
            }
        }
    }

    async fn log_decision(&self, decision: &AutonomyDecision) -> AppResult<()> {
        // INSERT INTO scy_autonomy_logs ...
        Ok(())
    }

    async fn publish_decision_events(&self, decision: &AutonomyDecision) -> AppResult<()> {
        // Publier OutputPressureApplied et/ou FrictionAdjusted selon l'action
        Ok(())
    }

    /// Après exécution d'une action, enregistrer le résultat.
    pub fn record_outcome(&mut self, decision_id: Uuid, outcome: AutonomyOutcome) {
        if outcome == AutonomyOutcome::Failed {
            // Incrémenter failure_count pour rollback
        }
    }
}
```

---

## 9. Tests à fournir

### 9.1 `tests/autonomy_mode_test.rs`

```rust
#[test]
fn mssp_mdr_grid_allows_execute_at_l2_r1() {
    let grid = AlertRiskGrid::mssp_mdr();
    let action = grid.cells.get(&(AlertClass::L2, RiskLevel::R1));
    assert_eq!(*action, Some(AutonomyAction::Warn));
}

#[test]
fn regulated_internal_grid_blocks_at_l2_r2() {
    let grid = AlertRiskGrid::regulated_internal();
    let action = grid.cells.get(&(AlertClass::L2, RiskLevel::R2));
    assert_eq!(*action, Some(AutonomyAction::Block));
}

#[test]
fn shadow_mode_downgrades_execute_to_warn() {
    let engine = AutonomyDecisionEngine::new(grid, AutonomyMode::Shadow);
    let decision = engine.evaluate(request_with_action(AutonomyAction::Execute)).await;
    assert_eq!(decision.action, AutonomyAction::Warn);
}

#[test]
fn rollback_after_3_failures_forces_guarded() {
    let mut engine = AutonomyDecisionEngine::new(grid, AutonomyMode::Autonomous);
    for _ in 0..3 {
        engine.record_outcome(decision_id, AutonomyOutcome::Failed);
    }
    let decision = engine.evaluate(request).await;
    assert_eq!(decision.mode, AutonomyMode::Guarded);
}
```

---

## 10. Checklist de livraison

- [ ] `AutonomyMode` enum (4 variants)
- [ ] `AlertClass` enum (5 variants: L1-L5)
- [ ] `RiskLevel` enum (4 variants: R1-R4)
- [ ] `AutonomyAction` enum (7 variants)
- [ ] `AutonomyOutcome` enum (7 variants)
- [ ] `AutonomyDecision` struct
- [ ] `AutonomyEnvelopeSpec` struct
- [ ] `AlertRiskGrid` struct + `mssp_mdr()` + `regulated_internal()` builders
- [ ] Migration SQL v005 (scy_autonomy_envelopes, scy_autonomy_logs)
- [ ] `AutonomyRequest` struct (entrée du moteur)
- [ ] `AutonomyDecisionEngine` — evaluate(), apply_mode_constraint(), record_outcome()
- [ ] EventBus events: OutputPressureApplied, FrictionAdjusted
- [ ] Tests mode (mssp_mdr grid, regulated_internal grid)
- [ ] Tests rollback threshold (>3 failures → forced guarded)
- [ ] `cargo check -p scy-shared` passe
- [ ] `cargo check -p scy-postgres` passe

---

## 11. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter les adapters Postgres pour Autonomy (fait ici)
- ❌ Implémenter le Deployment Profiles complet (WP13)
- ❌ Modifier les migrations existantes
- ❌ Créer des tables autres que scy_autonomy_envelopes et scy_autonomy_logs

---

*Fin du WORK PACKAGE 07. Implémente UNIQUEMENT ce qui est dans ce fichier.*

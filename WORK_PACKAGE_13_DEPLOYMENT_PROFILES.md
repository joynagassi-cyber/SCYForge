# WORK PACKAGE 13 — 2 Deployment Profiles Implementation (Rust + TypeScript)

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Validé avant WP14 (Cyber Pack onboarding)
> **Dépendances** : WP07 (Autonomy Envelope), WP08 (Cognitive Policies), WP12 (D9 Coverage)
> **Références** : `MASTER_AGENT_PROMPT.md` (Règle #1, #3), `docs/SCYFORGE_DEPLOYMENT_PROFILES_SPEC.md` (complet), `WORK_PACKAGE_07_AUTONOMY_ENVELOPE.md`, `WORK_PACKAGE_08_COGNITIVE_POLICIES.md`

---

## 1. Objectif

Implémenter les **2 Deployment Profiles** (MSSP/MDR vs regulated_internal) — le contexte réglementaire et opérationnel qui configure automatiquement 4 providers, les weights des ProofRubrics, les règles ValidationGuard et les plafonds Autonomy Envelope.

**Livrable** : `DeploymentProfile` types Rust + binding TypeScript backend_ts + tests, `cargo check` + `tsc` passent.

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `docs/SCYFORGE_DEPLOYMENT_PROFILES_SPEC.md` — entier
2. `WORK_PACKAGE_07_AUTONOMY_ENVELOPE.md` — AutonomyMode, AlertRiskGrid
3. `WORK_PACKAGE_08_COGNITIVE_POLICIES.md` — CognitivePoliciesConfig
4. `minddoc/s00_architecture_standards/scy_service_architecture_map.md` — Service 19 (ValidationGuard)

---

## 3. Les 2 Profils

### 3.1 `mssp_mdr`

| Attribute | Valeur |
|-----------|--------|
| Compliance | SOC2, ISO27001, client-specific |
| Evidence retention | 90 jours |
| Max learner sessions | Unlimited |
| Output pressure | Strict |
| Sparring | Enabled (buyer_invoiced) |
| Approval chain | Tiered (L1→L2→L3) |
| Audit logging | Full |
| Alert class ceiling | L4 |
| Learner access | Time-boxed |

### 3.2 `regulated_internal`

| Attribute | Valeur |
|-----------|--------|
| Compliance | NIS2, DORA, GDPR, sectorial |
| Evidence retention | Permanent (legal hold) |
| Max learner sessions | Org-defined |
| Output pressure | Strict |
| Sparring | Disabled |
| Approval chain | Board-level L4+ |
| Audit logging | Full + immutable |
| Alert class ceiling | L4 (L5 = board) |
| Learner access | Continuous |

---

## 4. Types Rust à créer

### 4.1 `DeploymentProfile`

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum DeploymentProfile {
    MsspMdr,
    RegulatedInternal,
}

impl std::fmt::Display for DeploymentProfile {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            DeploymentProfile::MsspMdr => write!(f, "mssp_mdr"),
            DeploymentProfile::RegulatedInternal => write!(f, "regulated_internal"),
        }
    }
}
```

### 4.2 `ProfileConfig`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProfileConfig {
    pub profile: DeploymentProfile,
    pub organization_id: Uuid,
    pub compliance_frameworks: Vec<String>,
    pub evidence_retention_days: u32,
    pub max_learner_sessions: Option<u32>,
    pub output_pressure_policy: OutputPressurePolicy,
    pub sparring_enabled: bool,
    pub approval_tiers: Vec<ApprovalTier>,
    pub audit_logging: AuditLoggingConfig,
    pub alert_class_ceiling: AlertClass,
    pub learner_access_mode: LearnerAccessMode,
    pub proof_rubric_weights: ProofRubricWeightVector,
    pub validation_guard_rules: Vec<ValidationGuardRule>,
    pub autonomy_envelope_ceiling: AutonomyMode,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ApprovalTier {
    pub level: u32,
    pub required_alert_class: AlertClass,
    pub approver_role: String,
    pub timeout_sec: u64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AuditLoggingConfig {
    pub full_logging: bool,
    pub immutable: bool,
    pub retention_days: u32,
    pub export_format: String,      // "json" | "pdf" | "both"
    pub real_time_export: bool,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum LearnerAccessMode {
    TimeBoxed,     // sessions limitées (MSSP)
    Continuous,    // accès continu (regulated)
    Scheduled,     # horaires fixes
}
```

### 4.3 `ProofRubricWeightVector`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProofRubricWeightVector {
    pub name: String,
    pub profile: DeploymentProfile,
    pub dimensions: Vec<DimensionWeight>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DimensionWeight {
    pub dimension: String,   // "technical" | "procedural" | "judgment" | "transfer"
    pub weight: f32,
    pub min_acceptable: f32,
}

impl ProofRubricWeightVector {
    pub fn mssp_mdr() -> Self {
        Self {
            name: "default_mssp_mdr".to_string(),
            profile: DeploymentProfile::MsspMdr,
            dimensions: vec![
                DimensionWeight { dimension: "technical".to_string(), weight: 0.35, min_acceptable: 0.4 },
                DimensionWeight { dimension: "procedural".to_string(), weight: 0.25, min_acceptable: 0.3 },
                DimensionWeight { dimension: "judgment".to_string(), weight: 0.25, min_acceptable: 0.3 },
                DimensionWeight { dimension: "transfer".to_string(), weight: 0.15, min_acceptable: 0.2 },
            ],
        }
    }

    pub fn regulated_internal() -> Self {
        Self {
            name: "default_regulated_internal".to_string(),
            profile: DeploymentProfile::RegulatedInternal,
            dimensions: vec![
                DimensionWeight { dimension: "technical".to_string(), weight: 0.25, min_acceptable: 0.3 },
                DimensionWeight { dimension: "procedural".to_string(), weight: 0.15, min_acceptable: 0.2 },
                DimensionWeight { dimension: "judgment".to_string(), weight: 0.25, min_acceptable: 0.4 },
                DimensionWeight { dimension: "transfer".to_string(), weight: 0.20, min_acceptable: 0.3 },
                DimensionWeight { dimension: "compliance".to_string(), weight: 0.15, min_acceptable: 0.8 },
            ],
        }
    }

    pub fn total_weight(&self) -> f32 {
        self.dimensions.iter().map(|d| d.weight).sum()
    }

    pub fn validate(&self) -> Result<(), String> {
        let total = self.total_weight();
        if (total - 1.0).abs() > 1e-4 {
            return Err(format!("Weights must sum to 1.0, got: {}", total));
        }
        let min_ok = self.dimensions.iter().all(|d| d.min_acceptable >= 0.0 && d.min_acceptable <= 1.0);
        if !min_ok {
            return Err("min_acceptable must be in [0.0, 1.0]".to_string());
        }
        Ok(())
    }
}
```

### 4.4 `ValidationGuardRule`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ValidationGuardRule {
    pub rule_id: String,
    pub profile: DeploymentProfile,
    pub condition: String,        // ex: "alert_class = L4 AND risk_level >= R3"
    pub action: ValidationGuardAction,
    pub message: String,
    pub severity: ViolationSeverity,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum ValidationGuardAction {
    Block,
    Escalate,
    Warn,
    Log,
}

impl ValidationGuardRule {
    pub fn default_for_mssp_mdr() -> Vec<Self> {
        vec![
            ValidationGuardRule {
                rule_id: "mssp_block_l4_r3".to_string(),
                profile: DeploymentProfile::MsspMdr,
                condition: "alert_class >= L4 AND risk_level >= R3".to_string(),
                action: ValidationGuardAction::Block,
                message: "L4/R3 action requires board approval in MSSP mode".to_string(),
                severity: ViolationSeverity::Blocking,
            },
            ValidationGuardRule {
                rule_id: "mssp_limit_sessions".to_string(),
                profile: DeploymentProfile::MsspMdr,
                condition: "learner_sessions_per_day > 8".to_string(),
                action: ValidationGuardAction::Warn,
                message: "Approaching daily session limit".to_string(),
                severity: ViolationSeverity::Warning,
            },
        ]
    }

    pub fn default_for_regulated_internal() -> Vec<Self> {
        vec![
            ValidationGuardRule {
                rule_id: "regulated_block_l5".to_string(),
                profile: DeploymentProfile::RegulatedInternal,
                condition: "alert_class >= L5".to_string(),
                action: ValidationGuardAction::Block,
                message: "L5 alert requires board-level approval in regulated mode".to_string(),
                severity: ViolationSeverity::Blocking,
            },
            ValidationGuardRule {
                rule_id: "regulated_immutable_audit".to_string(),
                profile: DeploymentProfile::RegulatedInternal,
                condition: "audit_log_mutation_detected = true".to_string(),
                action: ValidationGuardAction::Escalate,
                message: "Audit log tampering detected — legal hold triggered".to_string(),
                severity: ViolationSeverity::Blocking,
            },
            ValidationGuardRule {
                rule_id: "regulated_compliance_check".to_string(),
                profile: DeploymentProfile::RegulatedInternal,
                condition: "compliance_dimension_score < 0.8".to_string(),
                action: ValidationGuardAction::Block,
                message: "Compliance dimension below threshold — board approval required".to_string(),
                severity: ViolationSeverity::Blocking,
            },
        ]
    }
}
```

### 4.5 `AutonomyMode` per Profile (Déjà en WP07)

```rust
// Rappel WP07
impl ProfileConfig {
    pub fn mssp_mdr(organization_id: Uuid) -> Self {
        Self {
            profile: DeploymentProfile::MsspMdr,
            organization_id,
            compliance_frameworks: vec!["SOC2".to_string(), "ISO27001".to_string()],
            evidence_retention_days: 90,
            max_learner_sessions: None,
            output_pressure_policy: OutputPressurePolicy::Strict,
            sparring_enabled: true,
            approval_tiers: vec![
                ApprovalTier { level: 1, required_alert_class: AlertClass::L2, approver_role: "supervisor".to_string(), timeout_sec: 300 },
                ApprovalTier { level: 2, required_alert_class: AlertClass::L3, approver_role: "manager".to_string(), timeout_sec: 600 },
                ApprovalTier { level: 3, required_alert_class: AlertClass::L4, approver_role: "director".to_string(), timeout_sec: 3600 },
            ],
            audit_logging: AuditLoggingConfig {
                full_logging: true,
                immutable: true,
                retention_days: 90,
                export_format: "json".to_string(),
                real_time_export: true,
            },
            alert_class_ceiling: AlertClass::L4,
            learner_access_mode: LearnerAccessMode::TimeBoxed,
            proof_rubric_weights: ProofRubricWeightVector::mssp_mdr(),
            validation_guard_rules: ValidationGuardRule::default_for_mssp_mdr(),
            autonomy_envelope_ceiling: AutonomyMode::Autonomous, // MSSP peut être autonome
        }
    }

    pub fn regulated_internal(organization_id: Uuid) -> Self {
        Self {
            profile: DeploymentProfile::RegulatedInternal,
            organization_id,
            compliance_frameworks: vec!["NIS2".to_string(), "DORA".to_string(), "GDPR".to_string()],
            evidence_retention_days: 0, // permanent (0 = never delete)
            max_learner_sessions: None,
            output_pressure_policy: OutputPressurePolicy::Strict,
            sparring_enabled: false,
            approval_tiers: vec![
                ApprovalTier { level: 1, required_alert_class: AlertClass::L3, approver_role: "ciso".to_string(), timeout_sec: 600 },
                ApprovalTier { level: 2, required_alert_class: AlertClass::L4, approver_role: "board".to_string(), timeout_sec: 86400 },
                ApprovalTier { level: 3, required_alert_class: AlertClass::L5, approver_role: "regulator".to_string(), timeout_sec: 604800 },
            ],
            audit_logging: AuditLoggingConfig {
                full_logging: true,
                immutable: true,
                retention_days: 0, // 0 = permanent
                export_format: "both".to_string(),
                real_time_export: true,
            },
            alert_class_ceiling: AlertClass::L5,
            learner_access_mode: LearnerAccessMode::Continuous,
            proof_rubric_weights: ProofRubricWeightVector::regulated_internal(),
            validation_guard_rules: ValidationGuardRule::default_for_regulated_internal(),
            autonomy_envelope_ceiling: AutonomyMode::Guarded, // regulated = jamais autonome
        }
    }
}
```

---

## 5. Migration SQL v006 — scy_deployment_profiles

```sql
-- ============================================================
-- V006 — Deployment Profiles
-- Crée: scy_deployment_profiles, scy_approval_tiers
-- Référence: SCYFORGE_DEPLOYMENT_PROFILES_SPEC.md
-- ============================================================

CREATE TABLE IF NOT EXISTS scy_deployment_profiles (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id         UUID NOT NULL,
    profile                 TEXT NOT NULL CHECK (profile IN ('mssp_mdr', 'regulated_internal')),
    compliance_frameworks   TEXT[] NOT NULL DEFAULT '{}',
    evidence_retention_days INTEGER NOT NULL DEFAULT 0, -- 0 = permanent
    max_learner_sessions    INTEGER, -- null = unlimited
    output_pressure_policy  TEXT NOT NULL DEFAULT 'strict',
    sparring_enabled        BOOLEAN NOT NULL DEFAULT true,
    alert_class_ceiling     TEXT NOT NULL CHECK (alert_class_ceiling IN ('L1', 'L2', 'L3', 'L4', 'L5')),
    learner_access_mode     TEXT NOT NULL DEFAULT 'timeboxed',
    autonomy_envelope_ceiling TEXT NOT NULL DEFAULT 'guarded',
    proof_rubric_weights    JSONB NOT NULL,
    validation_guard_rules  JSONB NOT NULL DEFAULT '[]',
    audit_logging_config    JSONB NOT NULL,
    approval_tiers          JSONB NOT NULL DEFAULT '[]',
    custom                  JSONB NOT NULL DEFAULT '{}',
    created_at              INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint),
    updated_at              INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint),

    UNIQUE(organization_id)
);

-- ── Indexes ──
CREATE INDEX IF NOT EXISTS idx_deployment_profiles_org ON scy_deployment_profiles (organization_id);
CREATE INDEX IF NOT EXISTS idx_deployment_profiles_profile ON scy_deployment_profiles (profile);

-- ── RLS ──
ALTER TABLE scy_deployment_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY deployment_profile_read ON scy_deployment_profiles FOR SELECT USING (true);
CREATE POLICY deployment_profile_write ON scy_deployment_profiles FOR ALL USING (true);
```

**`down.sql`** :

```sql
DROP TABLE IF EXISTS scy_deployment_profiles CASCADE;
```

---

## 6. TypeScript Types (backend_ts)

### 6.1 `DeploymentProfile` zod schema

```typescript
// backend_ts/src/types/deployment-profile.ts

import { z } from "zod";

export const DeploymentProfileSchema = z.enum(["mssp_mdr", "regulated_internal"]);

export const AlertClassSchema = z.enum(["L1", "L2", "L3", "L4", "L5"]);

export const AutonomyModeSchema = z.enum(["shadow", "guarded", "autonomous", "handoff"]);

export const OutputPressurePolicySchema = z.enum(["standard", "strict", "blocked"]);

export const LearnerAccessModeSchema = z.enum(["timeboxed", "continuous", "scheduled"]);

export const ApprovalTierSchema = z.object({
  level: z.number().int().positive(),
  required_alert_class: AlertClassSchema,
  approver_role: z.string(),
  timeout_sec: z.number().int().positive(),
});

export const AuditLoggingConfigSchema = z.object({
  full_logging: z.boolean(),
  immutable: z.boolean(),
  retention_days: z.number().int().nonnegative(), // 0 = permanent
  export_format: z.enum(["json", "pdf", "both"]),
  real_time_export: z.boolean(),
});

export const DimensionWeightSchema = z.object({
  dimension: z.string(),
  weight: z.number().min(0).max(1),
  min_acceptable: z.number().min(0).max(1),
});

export const ProofRubricWeightVectorSchema = z.object({
  name: z.string(),
  profile: DeploymentProfileSchema,
  dimensions: z.array(DimensionWeightSchema),
});

export const ValidationGuardRuleSchema = z.object({
  rule_id: z.string(),
  profile: DeploymentProfileSchema,
  condition: z.string(),
  action: z.enum(["block", "escalate", "warn", "log"]),
  message: z.string(),
  severity: z.enum(["blocking", "warning", "info"]),
});

export const ProfileConfigSchema = z.object({
  profile: DeploymentProfileSchema,
  organization_id: z.string().uuid(),
  compliance_frameworks: z.array(z.string()),
  evidence_retention_days: z.number().int().nonnegative(),
  max_learner_sessions: z.number().int().positive().nullable(),
  output_pressure_policy: OutputPressurePolicySchema,
  sparring_enabled: z.boolean(),
  approval_tiers: z.array(ApprovalTierSchema),
  audit_logging: AuditLoggingConfigSchema,
  alert_class_ceiling: AlertClassSchema,
  learner_access_mode: LearnerAccessModeSchema,
  proof_rubric_weights: ProofRubricWeightVectorSchema,
  validation_guard_rules: z.array(ValidationGuardRuleSchema),
  autonomy_envelope_ceiling: AutonomyModeSchema,
  custom: z.record(z.any()).optional(),
});

export type DeploymentProfile = z.infer<typeof DeploymentProfileSchema>;
export type ProfileConfig = z.infer<typeof ProfileConfigSchema>;
export type ProofRubricWeightVector = z.infer<typeof ProofRubricWeightVectorSchema>;
export type ValidationGuardRule = z.infer<typeof ValidationGuardRuleSchema>;
```

### 6.2 `ProfileConfigService` (backend_ts)

```typescript
// backend_ts/src/services/deployment-profile.service.ts

import { supabase } from "../lib/supabase";
import { ProfileConfigSchema, type ProfileConfig } from "../types/deployment-profile";

export class DeploymentProfileService {
  async getProfile(organizationId: string): Promise<ProfileConfig | null> {
    const { data, error } = await supabase
      .from("scy_deployment_profiles")
      .select("*")
      .eq("organization_id", organizationId)
      .single();

    if (error || !data) return null;

    return ProfileConfigSchema.parse({
      ...data,
      organization_id: data.organization_id,
    });
  }

  async setProfile(organizationId: string, config: Partial<ProfileConfig>): Promise<ProfileConfig> {
    const validated = ProfileConfigSchema.partial().parse(config);

    const { data, error } = await supabase
      .from("scy_deployment_profiles")
      .upsert({
        organization_id: organizationId,
        ...validated,
        updated_at: Math.floor(Date.now() / 1000),
      })
      .select()
      .single();

    if (error) throw new Error(`Failed to set deployment profile: ${error.message}`);

    return ProfileConfigSchema.parse(data);
  }

  async getDefaultForProfile(profile: "mssp_mdr" | "regulated_internal"): Promise<ProfileConfig> {
    switch (profile) {
      case "mssp_mdr":
        return {
          profile: "mssp_mdr",
          organization_id: crypto.randomUUID(),
          compliance_frameworks: ["SOC2", "ISO27001"],
          evidence_retention_days: 90,
          max_learner_sessions: null,
          output_pressure_policy: "strict",
          sparring_enabled: true,
          approval_tiers: [
            { level: 1, required_alert_class: "L2", approver_role: "supervisor", timeout_sec: 300 },
            { level: 2, required_alert_class: "L3", approver_role: "manager", timeout_sec: 600 },
            { level: 3, required_alert_class: "L4", approver_role: "director", timeout_sec: 3600 },
          ],
          audit_logging: { full_logging: true, immutable: true, retention_days: 90, export_format: "json", real_time_export: true },
          alert_class_ceiling: "L4",
          learner_access_mode: "timeboxed",
          proof_rubric_weights: {
            name: "default_mssp_mdr",
            profile: "mssp_mdr",
            dimensions: [
              { dimension: "technical", weight: 0.35, min_acceptable: 0.4 },
              { dimension: "procedural", weight: 0.25, min_acceptable: 0.3 },
              { dimension: "judgment", weight: 0.25, min_acceptable: 0.3 },
              { dimension: "transfer", weight: 0.15, min_acceptable: 0.2 },
            ],
          },
          validation_guard_rules: [
            { rule_id: "mssp_block_l4_r3", profile: "mssp_mdr", condition: "alert_class >= L4 AND risk_level >= R3", action: "block", message: "L4/R3 action requires board approval", severity: "blocking" },
          ],
          autonomy_envelope_ceiling: "autonomous",
        };

      case "regulated_internal":
        return {
          profile: "regulated_internal",
          organization_id: crypto.randomUUID(),
          compliance_frameworks: ["NIS2", "DORA", "GDPR"],
          evidence_retention_days: 0,
          max_learner_sessions: null,
          output_pressure_policy: "strict",
          sparring_enabled: false,
          approval_tiers: [
            { level: 1, required_alert_class: "L3", approver_role: "ciso", timeout_sec: 600 },
            { level: 2, required_alert_class: "L4", approver_role: "board", timeout_sec: 86400 },
            { level: 3, required_alert_class: "L5", approver_role: "regulator", timeout_sec: 604800 },
          ],
          audit_logging: { full_logging: true, immutable: true, retention_days: 0, export_format: "both", real_time_export: true },
          alert_class_ceiling: "L5",
          learner_access_mode: "continuous",
          proof_rubric_weights: {
            name: "default_regulated_internal",
            profile: "regulated_internal",
            dimensions: [
              { dimension: "technical", weight: 0.25, min_acceptable: 0.3 },
              { dimension: "procedural", weight: 0.15, min_acceptable: 0.2 },
              { dimension: "judgment", weight: 0.25, min_acceptable: 0.4 },
              { dimension: "transfer", weight: 0.20, min_acceptable: 0.3 },
              { dimension: "compliance", weight: 0.15, min_acceptable: 0.8 },
            ],
          },
          validation_guard_rules: [
            { rule_id: "regulated_block_l5", profile: "regulated_internal", condition: "alert_class >= L5", action: "block", message: "L5 alert requires board approval", severity: "blocking" },
            { rule_id: "regulated_compliance_check", profile: "regulated_internal", condition: "compliance_dimension_score < 0.8", action: "block", message: "Compliance dimension below threshold", severity: "blocking" },
          ],
          autonomy_envelope_ceiling: "guarded",
        };
    }
  }
}
```

---

## 7. 4 Profile-aware Providers

Ces 4 providers changent de comportement selon le profile :

| Provider | Comportement MSSP/MDR | Comportement regulated_internal |
|----------|----------------------|--------------------------------|
| `ProofRubricProvider` | 4 dimensions, compliance = 0 | 5 dimensions, compliance = 0.15, min_acceptable = 0.8 |
| `RetentionPolicyProvider` | 90 jours | Permanent (0 = never delete) |
| `ValidationGuardProvider` | 2 rules (L4/R3 block, session limit) | 3 rules (L5 block, audit immutability, compliance check) |
| `PackConfigProvider` | `autonomy_envelope_ceiling = autonomous` | `autonomy_envelope_ceiling = guarded` |

---

## 8. Tests à fournir

### 8.1 Rust tests

```rust
#[test]
fn mssp_mdr_profile_has_correct_weights() {
    let weights = ProofRubricWeightVector::mssp_mdr();
    assert_eq!(weights.dimensions.len(), 4);
    assert_eq!(weights.dimensions[0].dimension, "technical");
    assert_eq!(weights.dimensions[0].weight, 0.35);
    assert!(weights.validate().is_ok());
}

#[test]
fn regulated_profile_has_compliance_dimension() {
    let weights = ProofRubricWeightVector::regulated_internal();
    assert_eq!(weights.dimensions.len(), 5);
    assert!(weights.dimensions.iter().any(|d| d.dimension == "compliance"));
}

#[test]
fn regulated_profile_compliance_min_is_0_8() {
    let weights = ProofRubricWeightVector::regulated_internal();
    let compliance = weights.dimensions.iter().find(|d| d.dimension == "compliance").unwrap();
    assert_eq!(compliance.min_acceptable, 0.8);
}

#[test]
fn mssp_sparring_enabled() {
    let config = ProfileConfig::mssp_mdr(Uuid::new_v4());
    assert!(config.sparring_enabled);
}

#[test]
fn regulated_sparring_disabled() {
    let config = ProfileConfig::regulated_internal(Uuid::new_v4());
    assert!(!config.sparring_enabled);
}

#[test]
fn regulated_evidence_retention_is_permanent() {
    let config = ProfileConfig::regulated_internal(Uuid::new_v4());
    assert_eq!(config.evidence_retention_days, 0);
}

#[test]
fn regulated_autonomy_ceiling_is_guarded() {
    let config = ProfileConfig::regulated_internal(Uuid::new_v4());
    assert_eq!(config.autonomy_envelope_ceiling, AutonomyMode::Guarded);
}
```

### 8.2 TypeScript tests

```typescript
describe("DeploymentProfileService", () => {
  test("mssp_mdr config validates", () => {
    const config = DeploymentProfileService.getDefaultForProfile("mssp_mdr");
    expect(ProfileConfigSchema.parse(config)).toBeDefined();
  });

  test("regulated_internal config validates", () => {
    const config = DeploymentProfileService.getDefaultForProfile("regulated_internal");
    expect(ProfileConfigSchema.parse(config)).toBeDefined();
  });

  test("weights sum to 1.0", () => {
    const mssp = DeploymentProfileService.getDefaultForProfile("mssp_mdr");
    const total = mssp.proof_rubric_weights.dimensions.reduce((sum, d) => sum + d.weight, 0);
    expect(total).toBeCloseTo(1.0, 2);
  });
});
```

---

## 9. Checklist de livraison

- [ ] `DeploymentProfile` enum
- [ ] `ProfileConfig` struct + builders `mssp_mdr()` + `regulated_internal()`
- [ ] `ProofRubricWeightVector` + `mssp_mdr()` + `regulated_internal()`
- [ ] `ValidationGuardRule` + `default_for_mssp_mdr()` + `default_for_regulated_internal()`
- [ ] `ApprovalTier` struct
- [ ] `AuditLoggingConfig` struct
- [ ] `LearnerAccessMode` enum
- [ ] Migration SQL v006 (scy_deployment_profiles)
- [ ] `ProfileConfigService` TypeScript (backend_ts)
- [ ] Zod schemas TypeScript
- [ ] Tests Rust (weights, sparring, retention, autonomy ceiling)
- [ ] Tests TypeScript (validation, defaults, weights sum)
- [ ] `cargo check` passe
- [ ] `tsc --noEmit` passe

---

## 10. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter le Cyber Pack complet (WP14)
- ❌ Implémenter l'Autonomy Decision Engine (WP07)
- ❌ Implémenter le Dashboard (WP15)
- ❌ Modifier les types Rust des WP précédents (seulement ajout)
- ❌ Créer des tables autres que scy_deployment_profiles

---

*Fin du WORK PACKAGE 13. Implémente UNIQUEMENT ce qui est dans ce fichier. Si tu as un doute, demande.*

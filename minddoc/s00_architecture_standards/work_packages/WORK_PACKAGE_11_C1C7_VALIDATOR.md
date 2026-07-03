# WORK PACKAGE 11 — C1-C7 Seed Validator Rust Implementation

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Bloquant pour WP12 (D9 Coverage) et WP14 (Cyber Pack)
> **Dépendances** : WP01 (DCID traits, DomainFilterProvider), WP06 (Seed types), WP10 (Provider matrix)
> **Références** : `MASTER_AGENT_PROMPT.md` (Règle #1), `minddoc/s03_generative_forest_engine/SCY_GFE_PARAMETERS.md` (§4.7 C1-C7), `WORK_PACKAGE_01_DCID_TRAITS.md`, `WORK_PACKAGE_06_SEED_STATUS.md`

---

## 1. Objectif

Implémenter le **validateur C1-C7** pour les Seeds de la GFE. Chaque Seed candidat doit passer les 7 critères avant d"être accepté dans le pipeline de germination.

**Livrable** : `DomainFilterProvider` Rust impl + `C1C7Validator` + `SeedCandidate` types + tests, `cargo check` passe.

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `minddoc/s03_generative_forest_engine/SCY_GFE_PARAMETERS.md` — §4.7 (C1-C7 Seed Validation Hook)
2. `WORK_PACKAGE_01_DCID_TRAITS.md` — DomainFilterProvider trait + C1C7Violation
3. `WORK_PACKAGE_06_SEED_STATUS.md` — Seed types + ViabilityProfile

---

## 3. Les 7 Critères C1-C7

| # | Critère | Condition de rejet | Poids |
|---|---------|-------------------|-------|
| C1 | **Grounded** | `sources[]` vide | Bloquant |
| C2 | **Pivot Anchored** | `domain_ref = NONE` | Bloquant |
| C3 | **Criticality** | `trunk_priority = UNDEFINED` | Bloquant |
| C4 | **Decision Bearing** | `core_proposition` < 50 chars | Bloquant |
| C5 | **Provable** | Pas de `ProofCriterion` | Bloquant |
| C6 | **Bounded** | `scope` non borné | Bloquant |
| C7 | **Reproducible** | `seed_hash` invalide | Bloquant |

**Note** : C1-C4 sont également validés en SQL (WP02 v003 `validate_cyber_seed()`). Le Rust validator fait C1-C7 complet.

---

## 4. Types Rust à créer

### 4.1 `C1C7Criterion` (déjà en WP01 dcid.rs, rappel)

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum C1C7Criterion {
    C1Grounded,        // sources[] vide
    C2PivotAnchored,   // domain_ref = NONE
    C3Criticality,     // trunk_priority indéfini
    C4DecisionBearing, // proposition trop courte
    C5Provable,        // pas de ProofCriterion
    C6Bounded,         // scope non borné
    C7Reproducible,    // seed_hash invalide
}
```

### 4.2 `C1C7Violation` (déjà en WP01 dcid.rs, rappel)

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct C1C7Violation {
    pub criterion: C1C7Criterion,
    pub message: String,
    pub severity: ViolationSeverity,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum ViolationSeverity {
    Blocking,   // Seed rejeté
    Warning,    # Accepté mais loggé
    Info,       # Informational
}
```

### 4.3 `SeedCandidate` (déjà en WP01 dcid.rs, rappel)

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedCandidate {
    pub id: Uuid,
    pub core_proposition: String,
    pub sources: Vec<String>,
    pub domain_refs: Vec<DomainRef>,
    pub trunk_priority: Option<f32>,
    pub proof_criteria: Vec<ProofCriterion>,
    pub scope: JsonValue,
    pub seed_hash: Option<String>,
    pub context: JsonValue,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProofCriterion {
    pub id: String,
    pub dimension: String,  // "technical" | "procedural" | "judgment" | "transfer"
    pub measurable: bool,
    pub weight: f32,
}
```

### 4.4 `C1C7Result`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct C1C7Result {
    pub passed: bool,
    pub violations: Vec<C1C7Violation>,
    pub critera_scores: HashMap<C1C7Criterion, f32>, // 0.0 = échec, 1.0 = passe
    pub validated_at: i64,
}
```

---

## 5. C1C7Validator — Implémentation

```rust
//! Validateur C1-C7 pour les Seeds GFE.
//! Référence: SCY_GFE_PARAMETERS.md §4.7, D-024.

pub struct C1C7Validator {
    strict_mode: bool,
}

impl C1C7Validator {
    pub fn new(strict_mode: bool) -> Self {
        Self { strict_mode }
    }

    /// Valider un Seed candidat selon les 7 critères.
    /// Retourne C1C7Result avec violations détaillées.
    pub fn validate(&self, candidate: &SeedCandidate) -> C1C7Result {
        let mut violations = Vec::new();
        let mut scores = HashMap::new();

        // C1: Grounded
        scores.insert(C1C7Criterion::C1Grounded, self.validate_c1(candidate, &mut violations));

        // C2: Pivot Anchored
        scores.insert(C1C7Criterion::C2PivotAnchored, self.validate_c2(candidate, &mut violations));

        // C3: Criticality
        scores.insert(C1C7Criterion::C3Criticality, self.validate_c3(candidate, &mut violations));

        // C4: Decision Bearing
        scores.insert(C1C7Criterion::C4DecisionBearing, self.validate_c4(candidate, &mut violations));

        // C5: Provable
        scores.insert(C1C7Criterion::C5Provable, self.validate_c5(candidate, &mut violations));

        // C6: Bounded
        scores.insert(C1C7Criterion::C6Bounded, self.validate_c6(candidate, &mut violations));

        // C7: Reproducible
        scores.insert(C1C7Criterion::C7Reproducible, self.validate_c7(candidate, &mut violations));

        let passed = violations.is_empty() || !self.strict_mode;
        C1C7Result {
            passed,
            violations,
            critera_scores: scores,
            validated_at: chrono::Utc::now().timestamp(),
        }
    }

    // ── Critères individuels ──

    fn validate_c1(&self, candidate: &SeedCandidate, violations: &mut Vec<C1C7Violation>) -> f32 {
        if candidate.sources.is_empty() {
            violations.push(C1C7Violation {
                criterion: C1C7Criterion::C1Grounded,
                message: "Seed must have at least one source in sources[]".to_string(),
                severity: ViolationSeverity::Blocking,
            });
            0.0
        } else {
            1.0
        }
    }

    fn validate_c2(&self, candidate: &SeedCandidate, violations: &mut Vec<C1C7Violation>) -> f32 {
        if candidate.domain_refs.is_empty() {
            violations.push(C1C7Violation {
                criterion: C1C7Criterion::C2PivotAnchored,
                message: "Seed must have at least one domain_ref (pivot anchor)".to_string(),
                severity: ViolationSeverity::Blocking,
            });
            0.0
        } else {
            1.0
        }
    }

    fn validate_c3(&self, candidate: &SeedCandidate, violations: &mut Vec<C1C7Violation>) -> f32 {
        if candidate.trunk_priority.is_none() {
            violations.push(C1C7Violation {
                criterion: C1C7Criterion::C3Criticality,
                message: "Seed must have trunk_priority defined for criticality formula".to_string(),
                severity: ViolationSeverity::Blocking,
            });
            0.0
        } else {
            let priority = candidate.trunk_priority.unwrap();
            if priority < 0.0 || priority > 1.0 {
                violations.push(C1C7Violation {
                    criterion: C1C7Criterion::C3Criticality,
                    message: format!("trunk_priority must be in [0.0, 1.0], got: {}", priority),
                    severity: ViolationSeverity::Blocking,
                });
                0.0
            } else {
                1.0
            }
        }
    }

    fn validate_c4(&self, candidate: &SeedCandidate, violations: &mut Vec<C1C7Violation>) -> f32 {
        let min_chars = 50;
        if candidate.core_proposition.len() < min_chars {
            violations.push(C1C7Violation {
                criterion: C1C7Criterion::C4DecisionBearing,
                message: format!(
                    "Core proposition too short ({} chars), minimum: {} chars. Must carry operational decision weight.",
                    candidate.core_proposition.len(), min_chars
                ),
                severity: ViolationSeverity::Blocking,
            });
            0.0
        } else {
            1.0
        }
    }

    fn validate_c5(&self, candidate: &SeedCandidate, violations: &mut Vec<C1C7Violation>) -> f32 {
        if candidate.proof_criteria.is_empty() {
            violations.push(C1C7Violation {
                criterion: C1C7Criterion::C5Provable,
                message: "Seed must have at least one proof criterion".to_string(),
                severity: ViolationSeverity::Blocking,
            });
            0.0
        } else {
            // Vérifier qu"au moins un critère est measurable
            let measurable = candidate.proof_criteria.iter().any(|c| c.measurable);
            if !measurable {
                violations.push(C1C7Violation {
                    criterion: C1C7Criterion::C5Provable,
                    message: "At least one proof criterion must be measurable".to_string(),
                    severity: ViolationSeverity::Warning,
                });
                0.5
            } else {
                1.0
            }
        }
    }

    fn validate_c6(&self, candidate: &SeedCandidate, violations: &mut Vec<C1C7Violation>) -> f32 {
        // C6: scope doit être borné par au moins une dimension
        let scope = &candidate.scope;
        if scope.is_null() || scope.as_object().map(|o| o.is_empty()).unwrap_or(true) {
            violations.push(C1C7Violation {
                criterion: C1C7Criterion::C6Bounded,
                message: "Seed scope must be bounded (non-empty JSON object)".to_string(),
                severity: ViolationSeverity::Blocking,
            });
            0.0
        } else {
            1.0
        }
    }

    fn validate_c7(&self, candidate: &SeedCandidate, violations: &mut Vec<C1C7Violation>) -> f32 {
        // C7: seed_hash doit être un SHA-256 valide (64 chars hex)
        match &candidate.seed_hash {
            Some(hash) if hash.len() == 64 && hash.chars().all(|c| c.is_ascii_hexdigit()) => 1.0,
            Some(hash) => {
                violations.push(C1C7Violation {
                    criterion: C1C7Criterion::C7Reproducible,
                    message: format!("Invalid seed_hash: expected 64 hex chars, got: {} chars", hash.len()),
                    severity: ViolationSeverity::Blocking,
                });
                0.0
            }
            None => {
                violations.push(C1C7Violation {
                    criterion: C1C7Criterion::C7Reproducible,
                    message: "Seed must have a seed_hash (reproducibility check)".to_string(),
                    severity: ViolationSeverity::Blocking,
                });
                0.0
            }
        }
    }
}

// ──────────────────────────────────────────────────────────────
// DomainFilterProvider impl (pour l'adapter Postgres)
// Référence: WP01, WP06
// ──────────────────────────────────────────────────────────────

#[async_trait]
impl DomainFilterProvider for PostgresSemanticTreeProvider {
    async fn validate_seed_criteria(&self, seed: &SeedCandidate) -> AppResult<(bool, Vec<C1C7Violation>)> {
        let validator = C1C7Validator::new(true); // strict mode
        let result = validator.validate(seed);
        Ok((result.passed, result.violations))
    }
}
```

---

## 6. Intégration avec le SeedRepository (WP06)

```rust
// Dans SeedRepository (WP06) — modification de plant_seed()

async fn plant_seed_with_validation(
    &self,
    tree_id: Uuid,
    domain_pack_id: String,
    core_proposition: String,
    parenthood: SeedParenthood,
    viability_profile: ViabilityProfile,
    provenance: SeedProvenance,
    role_id: &str,
    ontology_version: &str,
    sources: Vec<String>,
    domain_refs: Vec<DomainRef>,
    trunk_priority: f32,
    proof_criteria: Vec<ProofCriterion>,
) -> AppResult<Seed> {
    // 1. Créer le candidat
    let seed_id = Uuid::new_v4();
    let weights_str = format!("{},{},{},{}", /* SMI weights */);
    let seed_hash = compute_seed_hash(
        role_id, &core_proposition, ontology_version,
        &provenance.corpus_snapshot_id, &weights_str,
        &provenance.validator_version, seed_id,
    );

    let candidate = SeedCandidate {
        id: seed_id,
        core_proposition: core_proposition.clone(),
        sources,
        domain_refs,
        trunk_priority: Some(trunk_priority),
        proof_criteria,
        scope: JsonValue::Null, // pack-défini
        seed_hash: Some(seed_hash),
        context: JsonValue::Null,
    };

    // 2. Valider C1-C7
    let validator = C1C7Validator::new(true);
    let result = validator.validate(&candidate);

    if !result.passed {
        let errors: Vec<String> = result.violations.iter()
            .filter(|v| v.severity == ViolationSeverity::Blocking)
            .map(|v| format!("{}: {}", v.criterion, v.message))
            .collect();
        return Err(AppError::DomainFilterViolation(C1C7Violation {
            criterion: C1C7Criterion::C1Grounded, // placeholder
            message: format!("C1-C7 validation failed: {:?}", errors),
            severity: ViolationSeverity::Blocking,
        }));
    }

    // 3. Planter le seed (WP06 logic)
    self.plant_seed(/* ... */).await
}
```

---

## 7. Tests à fournir

### 7.1 `tests/c1c7_validator_test.rs`

```rust
#[test]
fn c1_grounded_rejects_empty_sources() {
    let validator = C1C7Validator::new(true);
    let candidate = SeedCandidate {
        sources: vec![],
        domain_refs: vec![DomainRef { ontology: "test".into(), id: "1".into(), label: None }],
        core_proposition: "A valid proposition with enough characters to pass C4".to_string(),
        trunk_priority: Some(0.5),
        proof_criteria: vec![ProofCriterion { id: "p1".into(), dimension: "technical".into(), measurable: true, weight: 1.0 }],
        seed_hash: Some("a".repeat(64)),
        scope: json!({"bounded": true}),
        context: JsonValue::Null,
        id: Uuid::new_v4(),
    };

    let result = validator.validate(&candidate);
    assert!(!result.passed);
    assert!(result.violations.iter().any(|v| v.criterion == C1C7Criterion::C1Grounded));
}

#[test]
fn c2_rejects_empty_domain_refs() {
    let validator = C1C7Validator::new(true);
    let candidate = SeedCandidate {
        sources: vec!["src1".into()],
        domain_refs: vec![],
        // ... reste valide
    };

    let result = validator.validate(&candidate);
    assert!(!result.passed);
    assert!(result.violations.iter().any(|v| v.criterion == C1C7Criterion::C2PivotAnchored));
}

#[test]
fn c3_rejects_missing_trunk_priority() {
    let validator = C1C7Validator::new(true);
    let candidate = SeedCandidate {
        trunk_priority: None,
        // ... reste valide
    };

    let result = validator.validate(&candidate);
    assert!(!result.passed);
    assert!(result.violations.iter().any(|v| v.criterion == C1C7Criterion::C3Criticality));
}

#[test]
fn c4_rejects_short_proposition() {
    let validator = C1C7Validator::new(true);
    let candidate = SeedCandidate {
        core_proposition: "short".to_string(),
        // ... reste valide
    };

    let result = validator.validate(&candidate);
    assert!(!result.passed);
    assert!(result.violations.iter().any(|v| v.criterion == C1C7Criterion::C4DecisionBearing));
}

#[test]
fn c5_rejects_missing_proof_criteria() {
    let validator = C1C7Validator::new(true);
    let candidate = SeedCandidate {
        proof_criteria: vec![],
        // ... reste valide
    };

    let result = validator.validate(&candidate);
    assert!(!result.passed);
    assert!(result.violations.iter().any(|v| v.criterion == C1C7Criterion::C5Provable));
}

#[test]
fn c6_rejects_null_scope() {
    let validator = C1C7Validator::new(true);
    let candidate = SeedCandidate {
        scope: JsonValue::Null,
        // ... reste valide
    };

    let result = validator.validate(&candidate);
    assert!(!result.passed);
    assert!(result.violations.iter().any(|v| v.criterion == C1C7Criterion::C6Bounded));
}

#[test]
fn c7_rejects_invalid_seed_hash() {
    let validator = C1C7Validator::new(true);
    let candidate = SeedCandidate {
        seed_hash: Some("not_a_valid_hex_hash!!".to_string()),
        // ... reste valide
    };

    let result = validator.validate(&candidate);
    assert!(!result.passed);
    assert!(result.violations.iter().any(|v| v.criterion == C1C7Criterion::C7Reproducible));
}

#[test]
fn valid_seed_passes_all_criteria() {
    let validator = C1C7Validator::new(true);
    let candidate = SeedCandidate {
        sources: vec!["src1".into()],
        domain_refs: vec![DomainRef { ontology: "test".into(), id: "1".into(), label: None }],
        core_proposition: "A valid operational decision proposition with enough characters to pass C4 validation".to_string(),
        trunk_priority: Some(0.7),
        proof_criteria: vec![ProofCriterion { id: "p1".into(), dimension: "technical".into(), measurable: true, weight: 1.0 }],
        seed_hash: Some("a".repeat(64)),
        scope: json!({"bounded": true, "domain": "cyber"}),
        context: JsonValue::Null,
        id: Uuid::new_v4(),
    };

    let result = validator.validate(&candidate);
    assert!(result.passed);
    assert!(result.violations.is_empty());
    assert_eq!(result.critera_scores.len(), 7);
    assert!(result.critera_scores.values().all(|&v| v == 1.0));
}
```

---

## 8. Checklist de livraison

- [ ] `C1C7Criterion` enum (7 variants: C1-C7)
- [ ] `ViolationSeverity` enum (Blocking, Warning, Info)
- [ ] `ProofCriterion` struct
- [ ] `SeedCandidate` struct (étendu depuis WP01)
- [ ] `C1C7Result` struct
- [ ] `C1C7Validator` — `validate()` + 7 méthodes `validate_c1` à `validate_c7`
- [ ] `DomainFilterProvider` impl pour `PostgresSemanticTreeProvider`
- [ ] Intégration avec `SeedRepository::plant_seed_with_validation()`
- [ ] Tests C1-C7 individuels (7 tests, chacun rejette un critère)
- [ ] Test seed valide passe tous les critères
- [ ] `cargo check -p scy-shared` passe
- [ ] `cargo check -p scy-postgres` passe

---

## 9. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter D9 Coverage Evaluator (WP12)
- ❌ Implémenter le `validate_cyber_seed()` SQL trigger (déjà en WP02 v003)
- ❌ Créer des migrations SQL
- ❌ Modifier les types Rust de WP01 (seulement ajout)
- ❌ Implémenter le Deployment Profiles (WP13)
- ❌ Implémenter le Cyber Pack complet (WP14)

---

*Fin du WORK PACKAGE 11. Implémente UNIQUEMENT ce qui est dans ce fichier.*

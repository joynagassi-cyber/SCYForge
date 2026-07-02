# WORK PACKAGE 14 — SCYFORGE_CYBER Ontology Pack Implementation

> **Statut** : À implémenter
> **Priorité** : 🟡 P1 — Premier Domain Pack (beachhead), bloqué par WP01-WP13
> **Dépendances** : WP01-WP13 (tous les foundations) + MASTER_AGENT_PROMPT.md
> **Références** : `C:\Users\joyda\Downloads\SCYFORGE_CYBER_ONTOLOGY.md` (v1.3), `C:\Users\joyda\Downloads\SCYFORGE_FEATURE_REPORT.md` (§4.1), `minddoc/s00_architecture_standards/scy_deployment_profiles_spec.md`

---

## 1. Objectif

Implémenter le **Domain Pack `cyber`** — le premier beachhead de SCY Forge. Ce pack implémente les 9 DCID providers avec une ontologie MITRE ATT&CK simplifiée, un rôle taxonomie, un corpus de référence, un ProofRubric et une RetentionPolicy.

**Livrable** : 9 providers implémentés + tests d'intégration + sample data, `cargo check` + `pnpm test` passent.

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `C:\Users\joyda\Downloads\SCYFORGE_CYBER_ONTOLOGY.md` — v1.3 complet (CYBER_ONTOLOGY)
2. `C:\Users\joyda\Downloads\SCYFORGE_FEATURE_REPORT.md` — §4.1 (9 providers)
3. `WORK_PACKAGE_01_DCID_TRAITS.md` — 9 traits DCID
4. `WORK_PACKAGE_10_PROVIDER_MATRIX.md` — matrice provider×owner_kind
5. `WORK_PACKAGE_11_C1C7_VALIDATOR.md` — validation C1-C7

---

## 3. Architecture cible

```
backend_rs/crates/scy-packs/cyber/
├── Cargo.toml
├── src/
│   ├── lib.rs                  # Préambule + exports
│   ├── ontology_provider.rs    # TRAIT 2
│   ├── corpus_provider.rs      # TRAIT 3
│   ├── role_taxonomy_provider.rs # TRAIT 4
│   ├── scenario_provider.rs    # TRAIT 5
│   ├── proof_rubric_provider.rs # TRAIT 6
│   ├── retention_provider.rs   # TRAIT 7
│   ├── pack_config.rs          # TRAIT 8
│   └── json_schema_provider.rs # TRAIT 9
└── tests/
    └── cyber_pack_integration_test.rs
```

---

## 4. Livrable — Provider par Provider

### 4.1 `ontology_provider.rs` — OntologyProvider

```rust
//! Ontologie MITRE ATT&CK simplifiée pour le pack cyber.
//! Référence: CYBER_ONTOLOGY.md §4, D-029.

use async_trait::async_trait;
use crate::{OntologyProvider, OntologyConcept, OntologyRelation, AppResult};

pub struct CyberOntologyProvider;

#[async_trait]
impl OntologyProvider for CyberOntologyProvider {
    async fn concepts(&self) -> AppResult<Vec<OntologyConcept>> {
        // 30 techniques MITRE ATT&CK simplifiées (MVP beachhead)
        Ok(vec![
            OntologyConcept {
                id: Uuid::new_v4(),
                label: "Phishing".to_string(),
                concept_type: "technique".to_string(),
                mitre_id: Some("T1566".to_string()),
                tactic: Some("Initial Access".to_string()),
                parent_id: None,
            },
            // ... 29 autres techniques
        ])
    }

    async fn relations(&self, concept_id: Uuid) -> AppResult<Vec<OntologyRelation>> {
        // Relations entre concepts (prerequisites, relates)
        Ok(vec![])
    }

    async fn root_ontology(&self) -> AppResult<String> {
        Ok("mitre_attack_v14".to_string())
    }
}
```

### 4.2 `corpus_provider.rs` — CorpusProvider

```rust
//! Corpus de référence pour le pack cyber (BM25 FTS MVP).
//! Référence: CYBER_ONTOLOGY.md §5

pub struct CyberCorpusProvider {
    chunks: Vec<CorpusChunk>,
    snapshot_id: String,
}

impl CyberCorpusProvider {
    pub fn new() -> Self {
        Self {
            chunks: vec![
                CorpusChunk {
                    id: Uuid::new_v4(),
                    node_id: Uuid::new_v4(), // lié au SemanticNode
                    content: "Phishing is a technique where attackers send fraudulent communications...".to_string(),
                    chunk_type: "definition".to_string(),
                    source: "mitre_attack_v14".to_string(),
                    created_at: chrono::Utc::now().timestamp(),
                },
                // ... 50+ chunks MVP
            ],
            snapshot_id: "corpus_v2026_01".to_string(),
        }
    }
}
```

### 4.3 `role_taxonomy_provider.rs` — RoleTaxonomyProvider

```rust
//! 3 rôles MVP: SOC Analyst, Incident Responder, Security Engineer.
//! Référence: CYBER_ONTOLOGY.md §6

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CyberRole {
    pub id: String,
    pub label: String,
    pub required_nodes: Vec<Uuid>,
    pub subtree_depth: u32,
}

impl RoleTaxonomyProvider for CyberRoleTaxonomyProvider {
    async fn roles(&self) -> AppResult<Vec<Role>> {
        Ok(vec![
            Role { id: "soc_analyst".to_string(), name: "SOC Analyst".to_string(), description: "..." },
            Role { id: "incident_responder".to_string(), name: "Incident Responder".to_string(), description: "..." },
            Role { id: "security_engineer".to_string(), name: "Security Engineer".to_string(), description: "..." },
        ])
    }

    async fn subtree_for_role(&self, role_id: &str) -> AppResult<Vec<Uuid>> {
        match role_id {
            "soc_analyst" => Ok(vec![/* 15 node IDs */]),
            "incident_responder" => Ok(vec![/* 20 node IDs */]),
            "security_engineer" => Ok(vec![/* 25 node IDs */]),
            _ => Err(AppError::PackNotFound(role_id.to_string())),
        }
    }

    async fn autonomy_bounds(&self, role_id: &str, profile_ref: Option<&str>) -> AppResult<Vec<AutonomyBound>> {
        // L1-L4 per role
        Ok(vec![
            AutonomyBound { role: role_id.to_string(), alert_class: "L1".to_string(), max_autonomous: true },
            AutonomyBound { role: role_id.to_string(), alert_class: "L2".to_string(), max_autonomous: true },
            AutonomyBound { role: role_id.to_string(), alert_class: "L3".to_string(), max_autonomous: false }, // need approval
            AutonomyBound { role: role_id.to_string(), alert_class: "L4".to_string(), max_autonomous: false },
        ])
    }
}
```

### 4.4 `scenario_provider.rs` — DecisionScenarioProvider

```rust
//! 8+ scénarios MVP avec injects.
//! Référence: CYBER_ONTOLOGY.md §7

pub struct CyberScenarioProvider;

#[async_trait]
impl DecisionScenarioProvider for CyberScenarioProvider {
    async fn scenarios(&self) -> AppResult<Vec<ScenarioSpec>> {
        Ok(vec![
            ScenarioSpec {
                id: "phishing_response".to_string(),
                title: "Phishing Response".to_string(),
                description: "Respond to a phishing campaign targeting executives".to_string(),
                difficulty: 0.6,
                estimated_duration_sec: 600,
            },
            // ... 7 autres scénarios
        ])
    }

    async fn scenario_by_id(&self, scenario_id: &str) -> AppResult<ScenarioSpec> {
        self.scenarios().await?.into_iter()
            .find(|s| s.id == scenario_id)
            .ok_or_else(|| AppError::PackNotFound(scenario_id.to_string()))
    }

    async fn injects_for_node(&self, node_id: Uuid) -> AppResult<Vec<ScenarioInject>> {
        Ok(vec![])
    }
}
```

### 4.5 `proof_rubric_provider.rs` — ProofRubricProvider

```rust
//! ProofRubric avec 4 profils-aware dimensions.
//! Référence: WP13, CYBER_ONTOLOGY.md §8

pub struct CyberProofRubricProvider {
    profile: DeploymentProfile,
}

impl CyberProofRubricProvider {
    pub fn with_profile(profile: DeploymentProfile) -> Self {
        Self { profile }
    }

    pub fn rubric_for_scenario(&self, scenario_id: &str) -> AppResult<RubricSpec> {
        let weights = match self.profile {
            DeploymentProfile::MsspMdr => ProofRubricWeightVector::mssp_mdr(),
            DeploymentProfile::RegulatedInternal => ProofRubricWeightVector::regulated_internal(),
        };

        Ok(RubricSpec {
            scenario_id: scenario_id.to_string(),
            dimensions: weights.dimensions,
            criteria: vec![
                RubricCriterion {
                    id: "technical_correctness".to_string(),
                    dimension: "technical".to_string(),
                    description: "Technical accuracy of response".to_string(),
                    max_score: 5,
                    weight: weights.dimensions.iter().find(|d| d.dimension == "technical").unwrap().weight,
                },
                // ... criteria par dimension
            ],
        })
    }

    pub async fn calculate_score(&self, evidence: &[EvidenceItem], rubric: &RubricSpec) -> AppResult<ProofScore> {
        let mut total = 0.0;
        for criterion in &rubric.criteria {
            let item = evidence.iter().find(|e| e.criterion_id == criterion.id);
            let score = item.map(|i| i.score / criterion.max_score).unwrap_or(0.0);
            total += score * criterion.weight;
        }
        Ok(ProofScore { total_score: total.min(1.0), dimension_scores: HashMap::new() })
    }
}
```

### 4.6 `retention_provider.rs` — RetentionPolicyProvider

```rust
//! FSRS params + review policy pour le pack cyber.
//! Référence: CYBER_ONTOLOGY.md §9, D-011

pub struct CyberRetentionProvider {
    profile: DeploymentProfile,
}

impl CyberRetentionProvider {
    pub fn with_profile(profile: DeploymentProfile) -> Self {
        Self { profile }
    }

    pub fn fsrs_params(&self, node_id: Uuid) -> AppResult<FSRSParams> {
        // FSRS-5 params simplifiés (MVP)
        Ok(FSRSParams {
            stability: 1.0,
            difficulty: 2.0,
            forgetting_rate: 0.3,
            learning_rate: 0.2,
        })
    }

    pub fn criticality_weight(&self, node_id: Uuid) -> AppResult<f32> {
        // pack-défini: trunk nodes = 1.0, branch = 0.6, leaf = 0.3
        Ok(0.5) // MVP: uniform
    }

    pub fn review_policy(&self, role_id: &str) -> AppResult<ReviewPolicy> {
        let retention_days = match self.profile {
            DeploymentProfile::MsspMdr => 90,
            DeploymentProfile::RegulatedInternal => 0, // permanent
        };
        Ok(ReviewPolicy {
            role_id: role_id.to_string(),
            retention_days,
            review_interval_sec: 86400, // 24h
            mastery_threshold: 0.70,
            d9_target: 0.80,
        })
    }
}
```

### 4.7 `pack_config.rs` — PackConfigProvider

```rust
//! PackConfig pour cyber — mastery_threshold, smi_weights, helm_axes.
//! Référence: WP04, D-024

pub struct CyberPackConfigProvider {
    profile: DeploymentProfile,
}

impl CyberPackConfigProvider {
    pub fn with_profile(profile: DeploymentProfile) -> Self {
        Self { profile }
    }
}

#[async_trait]
impl PackConfigProvider for CyberPackConfigProvider {
    async fn pack_config(&self) -> AppResult<PackConfig> {
        // Les mastersymbiosis_weights somment toujours à 1.0
        let smi_weights = match self.profile {
            DeploymentProfile::MsspMdr => SMIWeights {
                retention: 0.35,
                fluency: 0.25,
                gap: 0.25,
                depth: 0.15,
            },
            DeploymentProfile::RegulatedInternal => SMIWeights {
                retention: 0.40,
                fluency: 0.20,
                gap: 0.20,
                depth: 0.20, // plus de profondeur en régulé
            },
        };

        Ok(PackConfig {
            domain_pack: "cyber".to_string(),
            version: "1.0.0".to_string(),
            mastery_threshold: 0.70,
            smi_weights,
            helm_axes: vec![
                HelmAxis { name: "retention".to_string(), weight: 0.35 },
                HelmAxis { name: "fluency".to_string(), weight: 0.25 },
                HelmAxis { name: "gap".to_string(), weight: 0.25 },
                HelmAxis { name: "depth".to_string(), weight: 0.15 },
            ],
            criticality_formula: "trunk_priority * sigma_density".to_string(),
        })
    }
}
```

### 4.8 `json_schema_provider.rs` — PackJsonSchemaProvider

```rust
//! Schémas JSON pour le pack cyber.
//! Référence: WP04

pub struct CyberSchemaProvider;

#[async_trait]
impl PackJsonSchemaProvider for CyberSchemaProvider {
    async fn node_metadata_schema(&self) -> AppResult<Option<JsonSchema>> {
        Ok(Some(JsonSchema {
            schema_version: "draft-07".to_string(),
            schema: json!({
                "type": "object",
                "properties": {
                    "mitre_id": { "type": "string" },
                    "tactic": { "type": "string" },
                    "detection_difficulty": { "type": "number", "minimum": 0, "maximum": 1 },
                },
                "required": ["mitre_id", "tactic"],
            }),
            description: Some("Cyber node metadata schema".to_string()),
        }))
    }

    async fn rubric_criteria_schema(&self) -> AppResult<Option<JsonSchema>> {
        Ok(Some(JsonSchema {
            schema_version: "draft-07".to_string(),
            schema: json!({
                "type": "object",
                "properties": {
                    "dimension": { "type": "string" },
                    "score": { "type": "number" },
                    "max_score": { "type": "number" },
                },
                "required": ["dimension", "score"],
            }),
            description: Some("Cyber rubric criteria schema".to_string()),
        }))
    }

    async fn tree_operation_metadata_schema(&self, operation: TreeOp) -> AppResult<Option<JsonSchema>> {
        Ok(None) // accept-all pour opérations d'arbre
    }
}
```

---

## 5. CyberPack — Assemblage central

```rust
//! CyberPack — assemblage de tous les providers pour le domain_pack "cyber".
//! Référence: CYBER_ONTOLOGY.md, WP10.

pub struct CyberPack {
    pub ontology: Arc<dyn OntologyProvider>,
    pub corpus: Arc<dyn CorpusProvider>,
    pub role_taxonomy: Arc<dyn RoleTaxonomyProvider>,
    pub scenarios: Arc<dyn DecisionScenarioProvider>,
    pub proof_rubric: Arc<dyn ProofRubricProvider>,
    pub retention: Arc<dyn RetentionPolicyProvider>,
    pub pack_config: Arc<dyn PackConfigProvider>,
    pub json_schema: Arc<dyn PackJsonSchemaProvider>,
    pub profile: DeploymentProfile,
}

impl CyberPack {
    pub fn new(profile: DeploymentProfile) -> Self {
        Self {
            ontology: Arc::new(CyberOntologyProvider),
            corpus: Arc::new(CyberCorpusProvider::new()),
            role_taxonomy: Arc::new(CyberRoleTaxonomyProvider),
            scenarios: Arc::new(CyberScenarioProvider),
            proof_rubric: Arc::new(CyberProofRubricProvider::with_profile(profile)),
            retention: Arc::new(CyberRetentionProvider::with_profile(profile)),
            pack_config: Arc::new(CyberPackConfigProvider::with_profile(profile)),
            json_schema: Arc::new(CyberSchemaProvider),
            profile,
        }
    }

    /// Retourner tous les providers pour injection dans le EventBus + SemanticTree
    pub fn providers(&self) -> Vec<Arc<dyn Any + Send + Sync>> {
        vec![
            self.ontology.clone(),
            self.corpus.clone(),
            self.role_taxonomy.clone(),
            self.scenarios.clone(),
            self.proof_rubric.clone(),
            self.retention.clone(),
            self.pack_config.clone(),
            self.json_schema.clone(),
        ]
    }
}
```

---

## 6. Sample Data Migration

```sql
-- ============================================================
-- V007 — Cyber Pack Sample Data
-- Référence: CYBER_ONTOLOGY.md §4-9
-- ============================================================

-- ── Pack Config (racine) ──
INSERT INTO scy_pack_configs (owner_kind, owner_id, domain_pack, mastery_threshold,
    smi_retention_weight, smi_fluency_weight, smi_gap_weight, smi_depth_weight)
VALUES ('domain_pack', gen_random_uuid(), 'cyber', 0.70, 0.35, 0.25, 0.25, 0.15);

-- ── 30 techniques MITRE ATT&CK (simplifiées) ──
INSERT INTO scy_semantic_nodes (id, tree_id, title, summary, depth, node_kind, domain_ref)
VALUES
    (gen_random_uuid(), '<root_tree_id>', 'Initial Access', 'TA0001 - The adversary is trying to get into your network.', 0, 'trunk', '{"ontology": "mitre_attack", "id": "TA0001"}'),
    (gen_random_uuid(), '<root_tree_id>', 'Execution', 'TA0002 - The adversary is trying to run malicious code.', 0, 'trunk', '{"ontology": "mitre_attack", "id": "TA0002"}'),
    (gen_random_uuid(), '<root_tree_id>', 'Phishing', 'T1566 - Adversaries send fraudulent communications.', 1, 'branch', '{"ontology": "mitre_attack", "id": "T1566"}'),
    (gen_random_uuid(), '<root_tree_id>', 'Spearphishing Attachment', 'T1566.001 - Spearphishing with malicious attachment.', 2, 'leaf', '{"ontology": "mitre_attack", "id": "T1566.001"}');
    -- ... 26 autres nodes

-- ── Semantic Tree (pack racine) ──
INSERT INTO scy_semantic_trees (id, owner_kind, owner_id, domain_pack, root_nodes)
SELECT gen_random_uuid(), 'domain_pack', gen_random_uuid(), 'cyber',
    ARRAY(SELECT id FROM scy_semantic_nodes WHERE depth = 0 AND tree_id = '<root_tree_id>');

-- ── 3 Rôles ──
INSERT INTO scy_roles (id, name, description, domain_pack)
VALUES
    (gen_random_uuid(), 'SOC Analyst', 'Monitors and analyzes security alerts', 'cyber'),
    (gen_random_uuid(), 'Incident Responder', 'Responds to and manages security incidents', 'cyber'),
    (gen_random_uuid(), 'Security Engineer', 'Designs and implements security controls', 'cyber');
```

---

## 7. Tests à fournir

### 7.1 CyberPack integration test

```rust
#[tokio::test]
async fn cyber_pack_provides_all_9_providers() {
    let pack = CyberPack::new(DeploymentProfile::MsspMdr);
    assert!(pack.ontology.is_some());
    assert!(pack.corpus.is_some());
    assert!(pack.role_taxonomy.is_some());
    assert!(pack.scenarios.is_some());
    assert!(pack.proof_rubric.is_some());
    assert!(pack.retention.is_some());
    assert!(pack.pack_config.is_some());
    assert!(pack.json_schema.is_some());
}

#[tokio::test]
async fn cyber_ontology_returns_30_techniques() {
    let provider = CyberOntologyProvider;
    let concepts = provider.concepts().await.unwrap();
    assert_eq!(concepts.len(), 30);
}

#[tokio::test]
async fn cyber_role_taxonomy_returns_3_roles() {
    let provider = CyberRoleTaxonomyProvider;
    let roles = provider.roles().await.unwrap();
    assert_eq!(roles.len(), 3);
}

#[tokio::test]
async fn cyber_proof_rubric_respects_profile() {
    let mssp = CyberProofRubricProvider::with_profile(DeploymentProfile::MsspMdr);
    let reg = CyberProofRubricProvider::with_profile(DeploymentProfile::RegulatedInternal);

    let mssp_rubric = mssp.rubric_for_scenario("phishing_response").unwrap();
    let reg_rubric = reg.rubric_for_scenario("phishing_response").unwrap();

    assert_eq!(mssp_rubric.dimensions.len(), 4);
    assert_eq!(reg_rubric.dimensions.len(), 5);
    assert!(reg_rubric.dimensions.iter().any(|d| d.dimension == "compliance"));
}

#[tokio::test]
async fn cyber_retention_differs_by_profile() {
    let mssp = CyberRetentionProvider::with_profile(DeploymentProfile::MsspMdr);
    let reg = CyberRetentionProvider::with_profile(DeploymentProfile::RegulatedInternal);

    let mssp_policy = mssp.review_policy("soc_analyst").unwrap();
    let reg_policy = reg.review_policy("soc_analyst").unwrap();

    assert_eq!(mssp_policy.retention_days, 90);
    assert_eq!(reg_policy.retention_days, 0); // permanent
}
```

---

## 8. Checklist de livraison

- [ ] `CyberOntologyProvider` — 30 concepts MITRE ATT&CK
- [ ] `CyberCorpusProvider` — 50+ chunks avec BM25 FTS
- [ ] `CyberRoleTaxonomyProvider` — 3 rôles + autonomy_bounds
- [ ] `CyberScenarioProvider` — 8 scénarios avec injects
- [ ] `CyberProofRubricProvider` — profile-aware (4 vs 5 dimensions)
- [ ] `CyberRetentionProvider` — FSRS params + retention policy
- [ ] `CyberPackConfigProvider` — mastery_threshold + SMIWeights per profile
- [ ] `CyberSchemaProvider` — node_metadata_schema + rubric_schema
- [ ] `CyberPack` — assemblage central
- [ ] `Cargo.toml` pour crate `scy-packs/cyber`
- [ ] Migration SQL V007 (sample data: config + 30 nodes + 3 roles)
- [ ] Tests intégration (9 providers, 30 concepts, 3 roles, profile-aware rubric)
- [ ] `cargo check -p scy-packs-cyber` passe
- [ ] `cargo test -p scy-packs-cyber` passe

---

## 9. Ce que tu NE fais PAS dans ce work package

- ❌ Ajouter de nouvelles dépendances Cargo sans validation
- ❌ Implémenter 100+ techniques MITRE (30 suffisent pour le MVP)
- ❌ Créer des migrations autres que V007
- ❌ Modifier les types Rust des WP précédents
- ❌ Implémenter le Dashboard (WP15)
- ❌ Implémenter les agents ASCENT (WP18+)

---

## 10. Référence rapide — CYBER_ONTOLOGY §4

```
ONTOLOGIE (CYBER_ONTOLOGY.md §4):
┌────────────────────────────────────────────────────┐
│  TACTICS (TA###) [TRUNK] — 5-8                    │
│  ├── Initial Access (TA0001)                       │
│  ├── Execution (TA0002)                            │
│  ├── Persistence (TA0003)                          │
│  ├── Privilege Escalation (TA0004)                 │
│  ├── Defense Evasion (TA0005)                      │
│  ├── Credential Access (TA0006)                    │
│  ├── Discovery (TA0007)                            │
│  └── Impact (TA0009)                               │
│                                                    │
│  TECHNIQUES (T####) [BRANCH] — 30                 │
│  └── T1566 Phishing                                │
│      ├── T1566.001 Spearphishing Attachment [LEAF] │
│      └── T1566.002 Spearphishing Link [LEAF]       │
└────────────────────────────────────────────────────┘
```

---

*Fin du WORK PACKAGE 14. Implémente UNIQUEMENT ce qui est dans ce fichier. Si tu as un doute, demande.*

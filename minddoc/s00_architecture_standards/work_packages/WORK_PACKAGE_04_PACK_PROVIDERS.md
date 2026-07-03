# WORK PACKAGE 04 — PackConfigProvider + PackJsonSchemaProvider Traits

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Obligatoire avant WP05 (adapter Postgres) et WP13 (deployment profiles)
> **Dépendances** : WP01 (DCID traits) doit exister
> **Références** : `MASTER_AGENT_PROMPT.md` (Règle #3), `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` (D-024), `work_package_01_dcid_traits.md`

---

## 1. Objectif

Finaliser les deux traits optionnels `PackConfigProvider` et `PackJsonSchemaProvider` définis dans WP01, avec leurs types de retour précis et les règles de résolution.

**Livrable** : Les deux traits complets dans `ports.rs` + tests de compilation + tests de comportement (PackConfig absent = error, PackJsonSchemaProvider None = accept-all).

---

## 2. Contraintes NON-NÉGOTIABLES

1. **`PackConfigProvider::pack_config()` absent = `MissingPackConfig` error**. Jamais de fallback silencieux (pas de `unwrap_or(0.70)`).
2. **`PackJsonSchemaProvider::node_metadata_schema()` retourne `Option<JsonSchema>`**. `None` = le core accepte tout JSONB valide.
3. **Cascade de résolution** : Learner → Organization → DomainPack. Chaque niveau peut hériter du niveau supérieur via `inherited_from`.
4. **Les paramètres de pack sont pack-définis**. Aucune constante dans le core.
5. **SMIWeights DOIVENT sommer à 1.0**. Validation dans le trait.

---

## 3. Types à créer dans `types.rs`

### 3.1 `PackConfig` (déjà en WP01, rappel)

```rust
// Déjà défini dans semantic_node.rs WP01 — rappel ici pour WP04
pub struct PackConfig {
    pub owner_kind: OwnerKind,
    pub owner_id: Uuid,
    pub inherited_from: Option<(OwnerKind, Uuid)>,
    pub mastery_threshold: f32,
    pub smi_weights: SMIWeights,
    pub helm_axes: Vec<HelmAxis>,
    pub criticality_formula: String,
    pub custom: JsonValue,
}

pub struct SMIWeights {
    pub retention: f32,
    pub fluency: f32,
    pub gap: f32,
    pub depth: f32,
}

impl SMIWeights {
    pub fn total(&self) -> f32 {
        self.retention + self.fluency + self.gap + self.depth
    }

    pub fn validate(&self) -> Result<(), String> {
        let total = self.total();
        if (total - 1.0).abs() < 1e-4 {
            Ok(())
        } else {
            Err(format!("SMIWeights must sum to 1.0, got {}", total))
        }
    }
}

pub struct HelmAxis {
    pub name: String,
    pub weight: f32,
}
```

### 3.2 `JsonSchema` (wrapper minimal)

```rust
// Wrapper minimal pour un schéma JSON (pour PackJsonSchemaProvider)
// Le core ne valide PAS le contenu du schéma — il le passe tel quel
// à l'adapter qui le transmet au validateur JSON Schema.

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct JsonSchema {
    pub schema_version: String,    // ex: "draft-07"
    pub schema: JsonValue,          // le schéma proprement dit
    pub description: Option<String>,
}
```

---

## 4. Implémentation des traits dans `ports.rs`

### 4.1 `PackConfigProvider` — contrat final

```rust
// Dans ports.rs — SECTION TRAIT 8 (PackConfigProvider)

#[async_trait]
pub trait PackConfigProvider: Send + Sync {
    /// Retourne la config du pack.
    /// ERROR: Retourne Err(MissingPackConfig) si le pack n'a pas de config.
    /// RÈGLE: Pas de fallback silencieux. Jamais de unwrap_or().
    async fn pack_config(&self) -> AppResult<PackConfig>;

    /// Retourne un paramètre spécifique avec résolution cascade.
    /// Cherche dans l'ordre: self → parent (inherited_from) → None.
    /// Retourne None si personne ne le possède.
    async fn get_param(&self, key: &str, owner_kind: OwnerKind, owner_id: Uuid) -> AppResult<Option<JsonValue>>;
}
```

### 4.2 `PackJsonSchemaProvider` — contrat final

```rust
// Dans ports.rs — SECTION TRAIT 9 (PackJsonSchemaProvider)

#[async_trait]
pub trait PackJsonSchemaProvider: Send + Sync {
    /// Schéma JSON pour les métadonnées de nœud.
    /// NONE = le core accepte tout JSONB valide (pas de rejet).
    async fn node_metadata_schema(&self) -> AppResult<Option<JsonSchema>>;

    /// Schéma JSON pour les critères de rubrique (ProofRubricProvider).
    async fn rubric_criteria_schema(&self) -> AppResult<Option<JsonSchema>>;

    /// Schéma JSON pour les métadonnées d'opération d'arbre.
    async fn tree_operation_metadata_schema(&self, operation: TreeOp) -> AppResult<Option<JsonSchema>>;
}
```

---

## 5. Résolution cascade PackConfig (logique métier du trait)

Le trait ne fournit PAS la logique de résolution — c'est au **Repository/Adapter** (WP05) de l'implémenter en SQL via `resolve_pack_config()`. Mais le contrat est défini ici :

```
Résolution cascade (D-024 §Inheritance Rules):

1. LearnerPackConfig(learner_id, domain_pack)
   ├─ Si existe → utilisé DIRECTEMENT
   ├─ Sinon → chercher OrganizationPackConfig(org_id, domain_pack)
   │             où org_id appartient au learner
   └─ Sinon → DomainPackConfig(domain_pack) [obligatoire]

2. OrganizationPackConfig(org_id, domain_pack)
   ├─ Si inherited_from est défini → résoudre vers ce parent
   └─ Sinon → valeurs propres de l'organisation

3. DomainPackConfig(domain_pack)
   └─ Racine — pas de parent. Toujours obligatoire.
```

---

## 6. Ajout à `error.rs`

```rust
// Ajouter ces variants dans AppError:

#[error("Pack configuration missing for pack: {0}")]
MissingPackConfig(String),

#[error("JSON schema validation failed: {0}")]
SchemaValidationFailed(String),

#[error("SMI weights do not sum to 1.0: {0}")]
InvalidSMIWeights(String),
```

---

## 7. Tests à fournir

### 7.1 `tests/pack_config_provider_test.rs`

```rust
#[test]
fn pack_config_absent_returns_missing_pack_config_error() {
    // Un PackConfigProvider qui retourne None DOIT retourner
    // AppError::MissingPackConfig, jamais un fallback silencieux.
    let provider = EmptyPackConfigProvider {};
    let result = futures::executor::block_on(provider.pack_config());
    assert!(result.is_err());
    match result.unwrap_err() {
        AppError::MissingPackConfig(_) => {} // attendu
        _ => panic!("Expected MissingPackConfig error"),
    }
}

#[test]
fn smi_weights_validation_fails_if_not_sum_to_one() {
    let weights = SMIWeights {
        retention: 0.5,
        fluency: 0.3,
        gap: 0.3,
        depth: 0.1,
    };
    assert!(weights.validate().is_err()); // 1.2 > 1.0
}

#[test]
fn smi_weights_validation_passes_if_sum_to_one() {
    let weights = SMIWeights {
        retention: 0.35,
        fluency: 0.25,
        gap: 0.25,
        depth: 0.15,
    };
    assert!(weights.validate().is_ok());
}
```

### 7.2 `tests/pack_json_schema_provider_test.rs`

```rust
#[test]
fn json_schema_provider_none_means_accept_all() {
    // Si node_metadata_schema() retourne None,
    // le core ne doit PAS rejeter de JSONB.
    let provider = AcceptAllSchemaProvider {};
    let result = futures::executor::block_on(provider.node_metadata_schema());
    assert!(result.is_ok());
    assert!(result.unwrap().is_none()); // accept-all
}
```

---

## 8. Checklist de livraison

- [ ] `PackConfigProvider` — trait complet avec `pack_config()` et `get_param()`
- [ ] `PackJsonSchemaProvider` — trait complet avec 3 méthodes
- [ ] `SMIWeights` — struct + impl avec `total()` et `validate()`
- [ ] `JsonSchema` — wrapper minimal
- [ ] `MissingPackConfig`, `SchemaValidationFailed`, `InvalidSMIWeights` ajoutés à `AppError`
- [ ] `PackConfig` cascade documentée (section 5)
- [ ] Tests `pack_config_absent_returns_error`
- [ ] Tests `smi_weights_validation`
- [ ] Tests `json_schema_provider_none_means_accept_all`
- [ ] `cargo check -p scy-shared` passe
- [ ] Aucune constante hardcodée (threshold, weights…) dans le core

---

## 9. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter l'adapter Postgres pour PackConfigProvider (WP05)
- ❌ Implémenter la résolution cascade en SQL (WP05)
- ❌ Modifier `scy-shared/Cargo.toml`
- ❌ Créer de nouveaux fichiers en dehors de `scy-shared/src/`
- ❌ Implémenter le deployment profiles (WP13)

---

*Fin du WORK PACKAGE 04. Implémente UNIQUEMENT ce qui est dans ce fichier.*

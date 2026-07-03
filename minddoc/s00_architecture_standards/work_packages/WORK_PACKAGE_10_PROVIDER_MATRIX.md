# WORK PACKAGE 10 — Provider × owner_kind Matrix Implementation in Rust

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Bloquant pour WP11 (C1-C7) et WP12 (D9 Coverage)
> **Dépendances** : WP01 (DCID traits), WP03 (EventBus), WP05 (Postgres Adapter)
> **Références** : `MASTER_AGENT_PROMPT.md`, `minddoc/s01_semantic_tree/SCY_STATE_MACHINES.md` (§9, §10), `minddoc/s01_semantic_tree/SCY_EVENTBUS_SCHEMAS.md`, `minddoc/s03_generative_forest_engine/SCY_GFE_PARAMETERS.md` (§12.5)

---

## 1. Objectif

Implémenter la **matrice Provider × owner_kind** qui spécifie quel provider est disponible pour quelle instance (DomainPack/Organization/Learner) et avec quelles règles d"héritage.

**Livrable** : `ProviderMatrix` trait + impl + tests, `cargo check` passe.

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `minddoc/s01_semantic_tree/SCY_STATE_MACHINES.md` — §9 (provider×owner_kind matrix), §10 (inheritance rules)
2. `WORK_PACKAGE_01_DCID_TRAITS.md` — 9 providers DCID
3. `WORK_PACKAGE_03_EVENTBUS_CRATE.md` — EventBus events avec owner_kind
4. `WORK_PACKAGE_04_PACK_PROVIDERS.md` — PackConfigProvider cascade

---

## 3. La Matrice (9 Providers × 3 owner_kind)

```
Provider                  DomainPack    Organization    Learner
─────────────────────────────────────────────────────────────────
SemanticTreeProvider       ✅ REQUIRED   ✅ REQUIRED       ✅ REQUIRED
OntologyProvider           ✅ OPTIONAL   ✅ INHERITED       ❌ INHERITED
CorpusProvider             ✅ OPTIONAL   ✅ INHERITED       ❌ INHERITED
RoleTaxonomyProvider       ✅ OPTIONAL   ✅ INHERITED       ✅ INHERITED
DecisionScenarioProvider   ✅ OPTIONAL   ✅ INHERITED       ❌ INHERITED
ProofRubricProvider        ✅ OPTIONAL   ✅ INHERITED       ✅ INHERITED
RetentionPolicyProvider    ✅ OPTIONAL   ✅ INHERITED       ✅ INHERITED
PackConfigProvider         ✅ REQUIRED   ✅ REQUIRED        ✅ REQUIRED
PackJsonSchemaProvider     ✅ OPTIONAL   ✅ INHERITED       ❌ INHERITED

Légende:
  ✅ REQUIRED   → Obligatoire, pas d'héritage
  ✅ OPTIONAL   → Optionnel, peut être surchargé
  ✅ INHERITED  → Hérité du niveau supérieur (pack → org → learner)
  ❌ INHERITED  → Jamais direct (toujours via org)
```

**Règles d"héritage** :
- Organization hérite de DomainPack (surcharge possible)
- Learner hérite de Organization (surcharge possible)
- Si Learner surcharge un provider, Organization n"est pas consulté pour ce provider

---

## 4. Types Rust à créer

### 4.1 `ProviderAvailability`

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum ProviderAvailability {
    Required,      // Obligatoire, pas d'héritage
    Optional,      // Optionnel, peut être surchargé
    Inherited,     // Hérité du niveau supérieur
    NotAvailable,  # Jamais disponible pour ce owner_kind
}
```

### 4.2 `ProviderCapability`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProviderCapability {
    pub provider: DCIDProvider,
    pub domain_pack: ProviderAvailability,
    pub organization: ProviderAvailability,
    pub learner: ProviderAvailability,
}

impl ProviderCapability {
    pub fn for_owner_kind(&self, owner_kind: OwnerKind) -> ProviderAvailability {
        match owner_kind {
            OwnerKind::DomainPack => self.domain_pack,
            OwnerKind::Organization => self.organization,
            OwnerKind::Learner => self.learner,
        }
    }

    pub fn is_available_for(&self, owner_kind: OwnerKind) -> bool {
        match self.for_owner_kind(owner_kind) {
            ProviderAvailability::Required | ProviderAvailability::Optional | ProviderAvailability::Inherited => true,
            ProviderAvailability::NotAvailable => false,
        }
    }
}
```

### 4.3 `ProviderRegistry`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProviderRegistry {
    pub capabilities: HashMap<DCIDProvider, ProviderCapability>,
    pub pack_id: String,
}

impl ProviderRegistry {
    pub fn default_for(pack_id: &str) -> Self {
        let mut capabilities = HashMap::new();

        capabilities.insert(DCIDProvider::SemanticTree, ProviderCapability {
            provider: DCIDProvider::SemanticTree,
            domain_pack: ProviderAvailability::Required,
            organization: ProviderAvailability::Required,
            learner: ProviderAvailability::Required,
        });

        capabilities.insert(DCIDProvider::Ontology, ProviderCapability {
            provider: DCIDProvider::Ontology,
            domain_pack: ProviderAvailability::Optional,
            organization: ProviderAvailability::Inherited,
            learner: ProviderAvailability::Inherited,
        });

        capabilities.insert(DCIDProvider::Corpus, ProviderCapability {
            provider: DCIDProvider::Corpus,
            domain_pack: ProviderAvailability::Optional,
            organization: ProviderAvailability::Inherited,
            learner: ProviderAvailability::Inherited,
        });

        capabilities.insert(DCIDProvider::RoleTaxonomy, ProviderCapability {
            provider: DCIDProvider::RoleTaxonomy,
            domain_pack: ProviderAvailability::Optional,
            organization: ProviderAvailability::Inherited,
            learner: ProviderAvailability::Inherited,
        });

        capabilities.insert(DCIDProvider::DecisionScenario, ProviderCapability {
            provider: DCIDProvider::DecisionScenario,
            domain_pack: ProviderAvailability::Optional,
            organization: ProviderAvailability::Inherited,
            learner: ProviderAvailability::Inherited,
        });

        capabilities.insert(DCIDProvider::ProofRubric, ProviderCapability {
            provider: DCIDProvider::ProofRubric,
            domain_pack: ProviderAvailability::Optional,
            organization: ProviderAvailability::Inherited,
            learner: ProviderAvailability::Inherited,
        });

        capabilities.insert(DCIDProvider::RetentionPolicy, ProviderCapability {
            provider: DCIDProvider::RetentionPolicy,
            domain_pack: ProviderAvailability::Optional,
            organization: ProviderAvailability::Inherited,
            learner: ProviderAvailability::Inherited,
        });

        capabilities.insert(DCIDProvider::PackConfig, ProviderCapability {
            provider: DCIDProvider::PackConfig,
            domain_pack: ProviderAvailability::Required,
            organization: ProviderAvailability::Required,
            learner: ProviderAvailability::Required,
        });

        capabilities.insert(DCIDProvider::PackJsonSchema, ProviderCapability {
            provider: DCIDProvider::PackJsonSchema,
            domain_pack: ProviderAvailability::Optional,
            organization: ProviderAvailability::Inherited,
            learner: ProviderAvailability::NotAvailable,
        });

        Self { capabilities, pack_id: pack_id.to_string() }
    }
}
```

### 4.4 `DCIDProvider`

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum DCIDProvider {
    SemanticTree,
    Ontology,
    Corpus,
    RoleTaxonomy,
    DecisionScenario,
    ProofRubric,
    RetentionPolicy,
    PackConfig,
    PackJsonSchema,
}
```

### 4.5 `ProviderResolution`

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProviderResolution {
    pub provider: DCIDProvider,
    pub resolved_at: OwnerKind,    // niveau où il a été trouvé
    pub resolved_id: Uuid,         // owner_id du niveau résolu
    pub inherited: bool,           // true = hérité d'un niveau supérieur
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProviderResolutionResult {
    pub resolutions: HashMap<DCIDProvider, ProviderResolution>,
    pub missing_required: Vec<DCIDProvider>, // providers REQUIRED manquants
}
```

---

## 5. ProviderResolver — Résolution de la matrice

```rust
//! Résolveur de providers — trouve le bon impl pour un owner_kind donné.
//! Référence: SCY_STATE_MACHINES.md §9-10.

pub struct ProviderResolver {
    registry: ProviderRegistry,
    pack_configs: HashMap<(OwnerKind, Uuid), PackConfig>,
}

impl ProviderResolver {
    pub fn new(registry: ProviderRegistry) -> Self {
        Self {
            registry,
            pack_configs: HashMap::new(),
        }
    }

    /// Résoudre tous les providers disponibles pour un owner_kind + owner_id.
    pub fn resolve_all(
        &self,
        owner_kind: OwnerKind,
        owner_id: Uuid,
        domain_pack: &str,
    ) -> AppResult<ProviderResolutionResult> {
        let mut resolutions = HashMap::new();
        let mut missing_required = Vec::new();

        for (provider, capability) in &self.registry.capabilities {
            match capability.for_owner_kind(owner_kind) {
                ProviderAvailability::Required => {
                    // Chercher dans le niveau courant d'abord
                    if let Some(config) = self.pack_configs.get(&(owner_kind, owner_id)) {
                        resolutions.insert(*provider, ProviderResolution {
                            provider: *provider,
                            resolved_at: owner_kind,
                            resolved_id: owner_id,
                            inherited: false,
                        });
                    } else {
                        missing_required.push(*provider);
                    }
                }
                ProviderAvailability::Optional => {
                    if let Some(config) = self.pack_configs.get(&(owner_kind, owner_id)) {
                        resolutions.insert(*provider, ProviderResolution {
                            provider: *provider,
                            resolved_at: owner_kind,
                            resolved_id: owner_id,
                            inherited: false,
                        });
                    } else {
                        // Essayer d'hériter du niveau supérieur
                        self.resolve_inherited(*provider, owner_kind, owner_id, domain_pack, &mut resolutions);
                    }
                }
                ProviderAvailability::Inherited => {
                    self.resolve_inherited(*provider, owner_kind, owner_id, domain_pack, &mut resolutions);
                }
                ProviderAvailability::NotAvailable => {
                    // Skip — pas disponible
                }
            }
        }

        Ok(ProviderResolutionResult { resolutions, missing_required })
    }

    fn resolve_inherited(
        &self,
        provider: DCIDProvider,
        owner_kind: OwnerKind,
        owner_id: Uuid,
        domain_pack: &str,
        resolutions: &mut HashMap<DCIDProvider, ProviderResolution>,
    ) {
        // Cascade: si Organization → chercher DomainPack
        //          si Learner → chercher Organization d'abord, puis DomainPack
        let parent_kind = match owner_kind {
            OwnerKind::Learner => Some(OwnerKind::Organization),
            OwnerKind::Organization => Some(OwnerKind::DomainPack),
            OwnerKind::DomainPack => None,
        };

        if let Some(parent_kind) = parent_kind {
            // Chercher le parent via l'arbre d"appartenance
            // (simplifié MVP: lookup direct dans pack_configs)
            for ((kind, id), _) in &self.pack_configs {
                if *kind == parent_kind && _pack_matches_domain(*id, domain_pack) {
                    resolutions.insert(provider, ProviderResolution {
                        provider,
                        resolved_at: *kind,
                        resolved_id: *id,
                        inherited: true,
                    });
                    return;
                }
            }
        }

        // Si pas trouvé du tout → pas de résolution (ce n'est pas une error, c'est "absent")
    }

    /// Obtenir la liste des providers disponibles pour un owner_kind.
    pub fn available_providers(&self, owner_kind: OwnerKind) -> Vec<DCIDProvider> {
        self.registry.capabilities.iter()
            .filter(|(_, cap)| cap.is_available_for(owner_kind))
            .map(|(provider, _)| *provider)
            .collect()
    }
}
```

---

## 6. Tests à fournir

### 6.1 `tests/provider_matrix_test.rs`

```rust
#[test]
fn default_registry_has_required_providers() {
    let registry = ProviderRegistry::default_for("cyber");
    assert!(registry.capabilities[&DCIDProvider::SemanticTree].is_available_for(OwnerKind::DomainPack));
    assert!(registry.capabilities[&DCIDProvider::PackConfig].is_available_for(OwnerKind::DomainPack));
    assert!(registry.capabilities[&DCIDProvider::PackConfig].is_available_for(OwnerKind::Organization));
    assert!(registry.capabilities[&DCIDProvider::PackConfig].is_available_for(OwnerKind::Learner));
}

#[test]
fn pack_json_schema_not_available_for_learner() {
    let registry = ProviderRegistry::default_for("cyber");
    assert!(!registry.capabilities[&DCIDProvider::PackJsonSchema].is_available_for(OwnerKind::Learner));
}

#[test]
fn ontology_inherited_for_learner() {
    let registry = ProviderRegistry::default_for("cyber");
    assert_eq!(
        registry.capabilities[&DCIDProvider::Ontology].for_owner_kind(OwnerKind::Learner),
        ProviderAvailability::Inherited
    );
}

#[test]
fn resolution_finds_required_provider() {
    let registry = ProviderRegistry::default_for("cyber");
    let resolver = ProviderResolver::new(registry);
    let result = resolver.resolve_all(OwnerKind::DomainPack, domain_pack_id, "cyber").unwrap();
    assert!(result.missing_required.is_empty());
    assert!(result.resolutions.contains_key(&DCIDProvider::SemanticTree));
}

#[test]
fn resolution_marks_missing_required() {
    let registry = ProviderRegistry::default_for("cyber");
    let resolver = ProviderResolver::new(registry);
    let result = resolver.resolve_all(OwnerKind::Learner, learner_id, "cyber").unwrap();
    // SemanticTree, PackConfig, RoleTaxonomy, ProofRubric, RetentionPolicy requis
    // Ils doivent être résolus (hérités ou directs)
    assert!(result.missing_required.is_empty() || result.missing_required.len() <= 2);
}
```

---

## 7. Checklist de livraison

- [ ] `DCIDProvider` enum (9 variants)
- [ ] `ProviderAvailability` enum (4 variants)
- [ ] `ProviderCapability` struct + `for_owner_kind()` + `is_available_for()`
- [ ] `ProviderRegistry` struct + `default_for()` builder
- [ ] `ProviderResolver` struct + `resolve_all()` + `resolve_inherited()`
- [ ] `ProviderResolution` struct + `ProviderResolutionResult`
- [ ] Matrice par défaut correcte (9 lignes × 3 colonnes)
- [ ] Tests resolution (required found, inherited worked, missing detected)
- [ ] Tests available_providers()
- [ ] `cargo check -p scy-shared` passe

---

## 8. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter les 9 providers concrets (faits par les pack builders)
- ❌ Créer des migrations SQL pour la matrice
- ❌ Implémenter l"EventBus (WP03)
- ❌ Modifier les types Rust de WP01
- ❌ Implémenter le Deployment Profiles (WP13)

---

*Fin du WORK PACKAGE 10. Implémente UNIQUEMENT ce qui est dans ce fichier.*

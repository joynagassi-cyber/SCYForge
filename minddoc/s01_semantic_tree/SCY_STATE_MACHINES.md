# SCY FORGE — MACHINES À ÉTATS (STATE MACHINES)
**Document ID** : S01_STATE_MACHINES  
**Date** : 2026-07-01  
**Statut** : 🟢 NORMATIF — Réf pour toute implémentation de machines à états  
**Pilier** : Pilier 1 (Semantic Tree + DCID) + Pilier 3 (GFE)

---

## 1. Vue d'Ensemble

SCY Forge utilise **5 machines à états principales**, toutes implémentées en Rust via le **Typestate Pattern** (D-011) pour les états critiques, et via **enum + validation runtime** pour les états moins contraintes.

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SCY FORGE — 5 STATE MACHINES                      │
│                                                                     │
│  SM-1 │ LearnerNodeState    │ Locked → Ready → Studying → Mastered  │
│  SM-2 │ SeedLifecycle       │ POLLINATED → VIABLE → GERMINATING    │
│       │                     │                  ↘ DORMANT            │
│  SM-3 │ DomainPack          │ Loading → Active → Deprecated         │
│  SM-4 │ TreeEdge            │ Active → Superseded (IMMUTABLE)       │
│  SM-5 │ ScenarioInstance    │ Draft → Active → Completed/Abandoned  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. SM-1 — LearnerNodeState (Typestate Pattern D-011)

> **Principe** : Un nœud n'est accessible que si son parent est maîtrisé (SMI ≥ mastery_threshold). Le seuil est **pack-défini** (D-024). Zéro hardcode dans le core.

### États canoniques

```
┌──────────┐    parent mastered ≥ threshold    ┌──────────┐
│  LOCKED  │ ────────────────────────────────→ │  READY   │
│          │                                    │          │
│ Nœud non │    learner_state.score ≥ 0.70      │ Prêt à  │
│ déverrou │    (pack-configurable)             │ étudier  │
└──────────┘                                    └────┬─────┘
                                                   │
                                              test() appelé
                                                   │
                                                   ▼
┌──────────┐    mastery ≥ threshold              ┌──────────┐
│ master*  │ ←─────────────────────────── │ STUDYING │
│ (terminal│                                │          │
│  state)  │    mastery_score STORED         │ En cours │
└──────────┘    (GENERATED ALWAYS AS)        └──────────┘
         ▲
         │   Rétrogradation possible (triggers)
         │   Si confidence chute (oubli FSRS)
         │
    ┌────┴────┐
    │  GAP    │ (retour à Studying ou Ready)
    └─────────┘
```

### États détaillés

| État | Code Rust | Description | Transitions autorisées |
|------|-----------|-------------|----------------------|
| **Locked** | `LOCKED` | Nœud non déverrouillé. Le tronc-avant-feuilles bloque l'accès. | → `READY` (si tous les parents sont `MASTERED`) |
| **Ready** | `READY` | Parent maîtrisé, nœud déverrouillé. L'apprenant peut commencer l'étude. | → `STUDYING` (première exposition), → `LOCKED` (si parent rétrograde) |
| **Studying** | `STUDING` | Nœud en cours d'étude. Apprenant expose le contenu, révise les cartes APEX. | → `MASTERED` (si `mastery_score ≥ pack_config.mastery_threshold`), → `READY` (si rétrogradation) |
| **Mastered** | `MASTERED` | Nœud maîtrisé. **État terminal** — mais rétrogradable (append-only). | → `STUDYING` (si `confidence` chute en dessous du seuil, FSRS oubli) |

### Invariants

```
1. Un nœud ne passe de LOCKED → READY que si TOUS ses parents directs sont MASTERED
2. mastery_score est STORED en DB (colonne GENERATED ALWAYS AS par trigger pack-défini)
3. status est STORED en DB (colonne GENERATED ALWAYS AS)
4. confidence est la SOURCE DE VÉRITÉ — mastery_score et status sont DÉRIVÉS
5. La rétrogradation MASTERED → STUDYING est autorisée (oubli FSRS)
6. La rétrogradation ne modifie JAMAIS les scores passés (append-only)
7. Aucune transition n'est autorisée sans appel au SemanticTreeProvider
```

### Implémentation Rust (Typestate Pattern D-011)

```rust
/// LearnerNodeState — machine à états typée au niveau DB,
/// runtime-checked au niveau applicatif via SemanticTreeProvider.
///
/// Le Typestate Pattern complet (type-level state machine) est appliqué
/// dans les adapters (PostgresTreeAdapter) via des méthodes dédiées :
/// - try_unlock()        : LOCKED → READY
/// - start_studying()    : READY → STUDYING
/// - evaluate_mastery()  : STUDYING → MASTERED (si ≥ threshold)
/// - decay_if_needed()   : MASTERED → STUDYING (si oubli FSRS)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LearnerNodeState {
    pub id: Uuid,
    pub learner_id: Uuid,
    pub tree_id: Uuid,
    pub node_id: Uuid,
    pub confidence: f32,              // 0.0–1.0 — SOURCE DE VÉRITÉ
    pub mastery_score: Option<f32>,   // STORED — dérivé de confidence
    pub status: NodeStatus,           // STORED — dérivé de confidence
    pub unlocked: bool,               // tronc-avant-feuilles
    pub unlockable: bool,             // calculé runtime (tous parents mastered)
    pub last_reviewed_at: Option<i64>,
    pub created_at: i64,
    pub updated_at: i64,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "lowercase")]
pub enum NodeStatus {
    Locked,
    Ready,
    Studying,
    Mastered,
}

impl LearnerNodeState {
    /// Vérifie si le nœud est maîtrisé selon le seuil pack-défini.
    /// D-024 : zéro hardcode dans le core. Le seuil vient de PackConfig.
    pub fn is_mastered_with_threshold(&self, mastery_threshold: f32) -> bool {
        self.confidence >= mastery_threshold
    }
}
```

### SQL Trigger Pack-Défini (Postgres Adapter)

Le `mastery_score` et `status` sont calculés par un trigger PostgreSQL que le pack peut surcharger.

```sql
-- Trigger par défaut (core) : confidence ≥ threshold → mastered
-- Le pack cyber peut fournir un trigger alternatif :
--   mastery_score = confidence × sigma_density_factor

CREATE OR REPLACE FUNCTION calculate_learner_status() RETURNS TRIGGER AS $$
BEGIN
    -- mastery_threshold vient de PackConfig (injecté par le pack)
    NEW.mastery_score := NEW.confidence;  -- base: 1:1 mapping
    IF NEW.confidence >= pack_config.mastery_threshold THEN
        NEW.status := 'mastered';
    ELSIF NEW.unlocked THEN
        NEW.status := 'studying';
    ELSIF NEW.confidence > 0.0 THEN
        NEW.status := 'ready';
    ELSE
        NEW.status := 'locked';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_learner_status
    BEFORE INSERT OR UPDATE OF confidence ON scy_learner_node_states
    FOR EACH ROW EXECUTE FUNCTION calculate_learner_status();
```

> **Note D-024** : Ce trigger est la **version par défaut du core**. Un pack peut le remplacer par un trigger personnalisé (ex: `confidence × sigma_density_factor` pour le cyber pack).

---

## 3. SM-2 — SeedLifecycle (GFE — Pilier 3)

> **Principe** : Aucune graine n'est détruite. Dormant ≠ mort.

```
   POLLINATED ──(viability ≥ γ_seuil)──► VIABLE ──(validée par manager)──► GERMINATING ──► NEW SUBTREE
        │                                     │
        │                                     └──(rejetée)──► DORMANT
        │
        └──(stérile)──► DORMANT ◄──────────────┘ (rétrogradée si contexte change)
        DORMANT ──(contexte favorable + vision helm ≥ τ)──► VIABLE   (réveil bitemporel)
```

### États détaillés

| État | Code | Description | Transitions |
|------|------|-------------|-------------|
| **POLLINATED** | `POLLINATED` | Seed créée par Pollination(A, B, ctx). En attente de scoring. | → `VIABLE` (si PlantScore ≥ γ_seuil), → `DORMANT` (si stérile) |
| **VIABLE** | `VIABLE` | Seed viable (PlantScore ≥ γ_seuil). Présentée au SOC Manager / RSSI. | → `GERMINATING` (si validée), → `DORMANT` (si rejetée) |
| **GERMINATING** | `GERMINATING` | Seed en cours de germination — déploiement en nouveau sous-arbre. | → `NEW SUBTREE` (si germination complète), → `DORMANT` (si échec) |
| **DORMANT** | `DORMANT` | Seed stockée mais inactive. Réveil possible si contexte change. | → `VIABLE` (si contexte favorable + align(H) ≥ τ) |

### Invariants

```
1. Aucune Seed n'est jamais supprimée (append-only)
2. Parenthood (source_A, source_B) est immuable après création
3. Provenance inclut : wasDerivedFrom, wasGeneratedBy, event_time, ingestion_time
4. Le réveil DORMANT → VIABLE nécessite : align(new_context, VisionHelm) ≥ τ
5. PlantScore est calculé une fois et stocké — jamais recalculé (immutable)
```

### Implémentation Rust

```rust
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "lowercase")]
pub enum SeedStatus {
    Pollinated,
    Viable,
    Germinating,
    Dormant,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Seed {
    pub id: Uuid,
    pub status: SeedStatus,
    pub core_proposition: String,
    pub parenthood: SeedParenthood,
    pub potential_tree: Option<PotentialTree>,
    pub viability_profile: ViabilityProfile,
    pub provenance: SeedProvenance,
    pub created_at: i64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedParenthood {
    pub source_a_id: Uuid,  // nœud ou Seed parent A
    pub source_b_id: Uuid,  // nœud ou Seed parent B
    pub pollination_context: serde_json::Value,
    pub pollination_conditions: PollinationConditions, // L1-L4 results
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PollinationConditions {
    pub l1_distance_ok: bool,      // distance ≥ θ_min
    pub l2_compatibility_ok: bool,  // ∃ pont logique
    pub l3_novelty_ok: bool,        // lien n'existe pas dans KG
    pub l4_alignment_ok: bool,      // align ≥ τ
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ViabilityProfile {
    pub viability: f32,     // feasibility × alignment × non_redundancy × resource_fit
    pub fecundity: f32,     // potential_subtrees × strategic_reach
    pub plant_score: f32,   // Viability^γ × Fecundity^(1−γ)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedProvenance {
    pub was_derived_from: (Uuid, Uuid),   // (source_A, source_B) — immuable
    pub was_generated_by: String,          // agent_id qui a produit la Seed
    pub event_time: i64,                   // création Seed (horodatage événement)
    pub ingestion_time: i64,               // découverte dans le KG (horodatage ingestion)
}
```

---

## 4. SM-3 — DomainPack (Cycle de Vie du Pack)

```
┌──────────┐    manifest validé    ┌──────────┐    serveurs actifs   ┌──────────────┐
│ LOADING  │ ───────────────────→ │  ACTIVE  │ ──────────────────→ │ DEPRECATED   │
│          │                       │          │                       │              │
│ Pack en  │                       │ Pack en  │                       │ Pack obsolète│
│ chargement│                       │ service  │                       │ (migrer vers)│
└──────────┘                       └────┬─────┘                       └──────────────┘
                                         │
                                    erreur critique
                                         │
                                         ▼
                                  ┌──────────┐
                                  │  FAILED  │
                                  │          │
                                  │ Erreur   │
                                  │ irrécup. │
                                  └──────────┘
```

| État | Description | Actions |
|------|-------------|---------|
| **LOADING** | Pack en cours de chargement (validation manifest + org tree). | `POST /api/packs/load` |
| **ACTIVE** | Pack opérationnel. Semantic Tree chargé, providers actifs. | Toutes les opérations |
| **DEPRECATED** | Pack obsolète (nouvelle version disponible). Lecture seule. | Migration vers nouvelle version |
| **FAILED** | Erreur irrécupérable lors du chargement. | Rollback, alerte admin |

---

## 5. SM-4 — TreeEdge (Cycle de Vie d'une Arête)

> **Principe Q7 (HITL)** : Immutabilité totale. `superseded_at` est une fois écrit, jamais modifié. `restored_at` est **refusé**.

```
┌──────────┐    graft()           ┌──────────┐    prune()            ┌─────────────┐
│  ACTIVE  │ ←────────────────── │ (created)│ ────────────────────→ │ SUPERSEDED  │
│          │                       │          │                       │             │
│ Arête    │                       │ Superseded│                       │ Historisée. │
│ vivante  │                       │ at = NULL │                       │ Jamais      │
│ (courant)│                       │           │                       │ modifiable. │
└──────────┘                       └───────────┘                       └─────────────┘
                                                                              │
                                                                     Pour "restaurer" :
                                                                     créer un NOUVEAU graft
                                                                     (trace le fait que la
                                                                      restauration s'est
                                                                      produite à T)
```

### Invariants (Q7 HITL)

```
1. superseded_at est IMMUTABLE — écrit une seule fois, jamais NULL→value
2. Aucun flag restored_at — restaurer = créer un nouveau graft
3. Les arêtes supersedées ne sont jamais supprimées (annuel de croissance)
4. Un graft ne peut pas référencer un node_id orphelin
```

---

## 6. SM-5 — ScenarioInstance (Cycle d'un Scénario ARENA)

```
┌──────────┐    learner start      ┌──────────┐    all steps done     ┌──────────┐
│  DRAFT   │ ───────────────────→ │IN_PROGRESS│ ───────────────────→ │ COMPLETED│
│          │                       │           │                       │          │
│ Scénario │                       │ Learner   │                       │ Score    │
│ prêt,    │                       │ en cours  │                       │ final +  │
│ pas     │                       │ d'exécution│                       │ certif.  │
│ encore  │                       └────┬──────┘                       └──────────┘
│ joué    │                            │
└──────────┘                            │ abandon
                                         ▼
                                  ┌───────────┐
                                  │ ABANDONED │
                                  │           │
                                  │ Learner   │
                                  │ quitte    │
                                  │ scenario  │
                                  └───────────┘
```

| État | Description | Transitions |
|------|-------------|-------------|
| **DRAFT** | Scénario créé mais pas encore disponible. | → `IN_PROGRESS` |
| **IN_PROGRESS** | Learner en cours d'exécution. | → `COMPLETED`, → `ABANDONED` |
| **COMPLETED** | Scénario terminé avec score. | Terminal |
| **ABANDONED** | Learner a abandonné. Peut être repris (reprise = nouveau DRAFT). | → `DRAFT` (retry) |

---

## 7. Matrice de Transitions Rapide

| Machine | De | Vers | Condition | Déclencheur |
|---------|----|------|-----------|-------------|
| SM-1 | LOCKED | READY | Tous parents MASTERED | `is_unlockable()` |
| SM-1 | READY | STUDYING | Première exposition | `start_studying()` |
| SM-1 | STUDYING | MASTERED | `mastery_score ≥ pack_config.mastery_threshold` | `evaluate_mastery()` |
| SM-1 | MASTERED | STUDYING | `confidence` chute (oubli FSRS) | `decay_if_needed()` |
| SM-2 | POLLINATED | VIABLE | PlantScore ≥ γ_seuil (0.40) | `score_seed()` |
| SM-2 | POLLINATED | DORMANT | Stérile (PlantScore < seuil) | `score_seed()` |
| SM-2 | VIABLE | GERMINATING | Validé par manager | `germinate()` |
| SM-2 | VIABLE | DORMANT | Rejeté par manager | `reject_seed()` |
| SM-2 | GERMINATING | NEW SUBTREE | Germination complète | `finalize_germination()` |
| SM-2 | DORMANT | VIABLE | Contexte favorable + align(H) ≥ τ | `wake_seed()` |
| SM-3 | LOADING | ACTIVE | Manifest validé + tree planté | `activate_pack()` |
| SM-3 | LOADING | FAILED | Erreur critique | `fail_pack()` |
| SM-3 | ACTIVE | DEPRECATED | Nouvelle version disponible | `deprecate_pack()` |
| SM-4 | ACTIVE | SUPERSEDED | prune() appelé | `prune_edge()` |
| SM-5 | DRAFT | IN_PROGRESS | Learner clique "Start" | `start_scenario()` |
| SM-5 | IN_PROGRESS | COMPLETED | Toutes étapes complétées | `complete_scenario()` |
| SM-5 | IN_PROGRESS | ABANDONED | Learner abandonne | `abandon_scenario()` |

---

## 8. Règles de Validation

### Validation obligatoire pour SM-1 (LearnerNodeState)

```rust
/// Validates a state transition for a learner node.
/// Returns Err(AppError::InvalidStateTransition) if transition is illegal.
pub fn validate_transition(
    from: NodeStatus,
    to: NodeStatus,
    context: &TransitionContext,
) -> Result<(), AppError> {
    match (from, to) {
        // LOCKED → READY : tous parents doivent être MASTERED
        (NodeStatus::Locked, NodeStatus::Ready) => {
            ensure!(context.all_parents_mastered, InvalidTransition);
            Ok(())
        }
        // READY → STUDYING : unlockable requis
        (NodeStatus::Ready, NodeStatus::Studying) => {
            ensure!(context.unlockable, InvalidTransition);
            Ok(())
        }
        // STUDYING → MASTERED : mastery_score ≥ threshold (pack-configurable)
        (NodeStatus::Studying, NodeStatus::Mastered) => {
            ensure!(
                context.mastery_score >= context.pack_config.mastery_threshold,
                InvalidTransition
            );
            Ok(())
        }
        // MASTERED → STUDYING : rétrogradation autorisée (oubli FSRS)
        (NodeStatus::Mastered, NodeStatus::Studying) => {
            // Autorise la rétrogradation — append-only
            Ok(())
        }
        // Toutes autres transitions : invalides
        _ => Err(AppError::InvalidStateTransition { from, to }),
    }
}
```

### Validation pour SM-2 (SeedLifecycle)

```rust
pub fn validate_seed_transition(
    from: SeedStatus,
    to: SeedStatus,
    context: &SeedTransitionContext,
) -> Result<(), AppError> {
    match (from, to) {
        // DORMANT → VIABLE : besoin de contexte favorable + align(H) ≥ τ
        (SeedStatus::Dormant, SeedStatus::Viable) => {
            ensure!(
                context.vision_alignment >= context.pack_config.helm_alignment_threshold,
                InvalidSeedTransition
            );
            Ok(())
        }
        // VIABLE → GERMINATING : validation manager requise
        (SeedStatus::Viable, SeedStatus::Germinating) => {
            ensure!(context.manager_approved, InvalidSeedTransition);
            Ok(())
        }
        // Autres transitions validées par le moteur GFE
        _ => Ok(()), // GFE engine handles its own transitions
    }
}
```

---

## 9. Règles d'Or (Non-Negotiable)

```
1. Jamais de transition d'état sans passer par le SemanticTreeProvider
2. Jamais de suppression d'état — append-only pour tous les scores et Seeds
3. Jamais de hardcode de seuil dans le core — mastery_threshold vient de PackConfig
4. SM-1 (LearnerNodeState) : tronc-avant-feuilles garanti à chaque transition LOCKED → READY
5. SM-2 (SeedLifecycle) : Dormant ≠ mort — la réactivation ne nécessite pas de nouvelle pollination
6. SM-4 (TreeEdge) : superseded_at est immuable — pas de restored_at
7. Toutes les transitions invalides lèvent AppError::InvalidStateTransition — jamais de silent fallback
```

---

## 10. Implémentation Pratique

### Typestate Pattern (Rust)

Pour SM-1 (LearnerNodeState), le Typestate Pattern complet (au niveau type Rust) est optionnel :

```
Code actuel (runtime-checked) :
    LearnerNodeState { status: NodeStatus::Locked, ... }
        ↓ [runtime validation]
    LearnerNodeState { status: NodeStatus::Ready, ... }

Alternative (compile-time Typestate Pattern) :
    LockedNode { ... }     → ReadyNode { ... }   → StudyingNode { ... } → MasteredNode { ... }
```

**Décision** : Runtime-checked pour SM-1 (suffisant, moins de friction).  
Typestate Pattern (compile-time) réservé pour les 5 opérations canoniques du SemanticTreeProvider (`plant`, `graft`, `prune`, `test`, `myelinate`) qui doivent être **impossibles à appeler dans le mauvais ordre** à la compilation.

### SQL Constraints

```sql
-- LearnerNodeState : UNIQUE par learner+tree+node
CREATE UNIQUE index idx_learner_node_unique 
    ON scy_learner_node_states(learner_id, tree_id, node_id);

-- TreeEdge : superseded_at immuable (pas de UPDATE autorisé)
-- Implémenté via trigger PostgreSQL qui rejette les UPDATE de superseded_at

-- Seed : parenthood immuable (pas de UPDATE de parenthood)
-- Implémenté via trigger PostgreSQL
```

---

## 9. Matrice Provider × owner_kind (DCID 9-providers)

> **D-020** : chaque Domain Pack implémente 9 providers canoniques. 
> **D-024** : le core est générique — les providers servent les 3 instances du Semantic Tree (DomainPack, Organization, Learner) selon des périmètres définis ci-dessous.

| Provider | DomainPack | Organization | Learner | Justification |
|---|---|---|---|---|
| SemanticTreeProvider | ✅ PRIMARY | ✅ PRIMARY | ✅ PRIMARY | Opérations canoniques sur tout arbre |
| PackConfigProvider | ✅ source | ✅ héritage | ✅ override | Seuils définis par pack → surchargeables par org → learner |
| PackJsonSchemaProvider | ✅ | ✅ | ✅ | Validation JSONB sur nœuds/edges de toute instance |
| OntologyProvider | ✅ | ❌ | ❌ | Concepts/relations du domaine canonique uniquement |
| CorpusProvider | ✅ | ✅ (accès) | ❌ | Sources brutes pack + corpus privés org |
| RoleTaxonomyProvider | ✅ (défaut) | ✅ (override) | ✅ (projection) | Rôles définis par pack, customisables par org |
| DecisionScenarioProvider | ✅ | ✅ | ✅ | Scénarios pack + scénarios privés org |
| ProofRubricProvider | ✅ | ✅ | ✅ | Rubrics pack + rubrics org |
| RetentionPolicyProvider | ✅ (défaut) | ✅ (override) | ✅ (appliqué) | Politiques pack-définies → surchargeables |
| ValidationGuardProvider | ✅ | ✅ | ❌ | Validation sorties générées (pack/org) — learner = consommateur |

**Règles d'invocation par owner_kind** :
- `plant()` : autorisé sur DomainPack + Organization (jamais Learner directement)
- `graft()` : autorisé sur DomainPack + Organization (jamais Learner)
- `test()` : autorisé sur Learner uniquement
- `myelinate()` : autorisé sur Learner uniquement
- `prune()` : autorisé sur DomainPack + Organization

---

## 10. Règles d'Héritage entre les 3 Instances

> **Semantic Tree Infrastructure §4.2** : le même type `SemanticTree` se décline en 3 `owner_kind`. L'héritage est défini ci-dessous.

| Attribut | Hérité de | Override autorisé |
|---|---|---|
| `root_nodes` | DomainPack → Organization → Learner | Organization peut ajouter des racines privées |
| `EdgeKind` structural | DomainPack | Organization peut ajouter des lianes privées |
| `PackConfig` | DomainPack → Organization → Learner | Chaque niveau peut surcharger `mastery_threshold` |
| `Node.confidence` | NON | Learner uniquement (propre à la tête) |
| `Corpus` | NON | Organization ajoute son corpus privé au corpus pack |

**Règle d'or** : un Learner n'est jamais un sous-arbre de son Organization. C'est une projection avec `confidence` par nœud. Supprimer le Learner ne supprime pas l'Organization.

---

*Fin du document. Toute implémentation de machine à états doit se conformer à ce spec. Toute divergence est une violation du contrat d'architecture (D-011, D-019, D-024).*

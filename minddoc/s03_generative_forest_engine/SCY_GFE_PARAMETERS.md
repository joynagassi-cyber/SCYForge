# SCY FORGE — GFE PARAMETERS & ALGORITHMS (PILIER 3)
**Document ID** : S03_GFE_PARAMETERS  
**Date** : 2026-07-01  
**Statut** : 🟡 EN REVISION — Soumis à HITL utilisateur  
**Pilier** : Pilier 3 (Generative Forest Engine)

---

## 1. Principe Fondateur des Paramètres

> **D-024** : Le core est un squelette générique sans mémoire métier ; la connaissance, les règles et les seuils vivent dans les packs — extensibilité par conception.

**Règle d'or** : Tout paramètre du GFE est classé dans l'une des deux catégories suivantes :

| Catégorie | Symbole | Description | Exemple |
|-----------|---------|-------------|---------|
| **CORE-FIXED** | 🔒 | Valeur immuable, définie par l'algorithme mathématique. Le pack ne peut pas la modifier. | Exposants de viabilité (4 facteurs × 1), structure Seed (5 composants) |
| **PACK-CONFIGURABLE** | 🔧 | Valeur fournie par `PackConfigProvider`. Le core ne connaît aucune valeur par défaut. Absence → `MissingPackConfig` error. | θ_min, θ_max, τ, γ, γ_seuil, helm axes, scoring weights |

---

## 2. Résolution SME — Advisory Mode (Contradiction Résolue)

### Le Problème (Contradiction Initiale)

La section `SCY_SEMANTIC_TREE_MODEL.md §1.11 (Émergence Endogène)` listait 3 mécanismes :
1. **SME (Gentner)** : Structure-Mapping Theory
2. **Blending (Fauconnier-Turner)** : Conceptual Blending
3. **Link Prediction (Swanson/node2vec)** : Literature-Based Discovery

**Contradiction identifiée** : Si un SME (expert métier) participe à la pollinisation (SME → candidats A,B), et que les Seeds produites sont incorporées dans le Semantic Tree (germination), alors le SME est dans une **boucle de rétroaction** : ses contributions deviennent du savoir officiel, qu'il valide ensuite. Risque d'auto-validation circulaire.

### Résolution Validée : Advisory Mode

```
┌─────────────────────────────────────────────────────────────────┐
│                    GFE — 3 NIVEAUX D'INTERVENTION                │
│                                                                 │
│  NIVEAU 1 │ CORE (algorithme)                                   │
│  ─────────┼─────────────────────────────────────────────────   │
│           │ Blending (Fauconnier-Turner) : automatique           │
│           │ Link Prediction (Swanson/node2vec) : automatique     │
│           │ Ni l'un ni l'autre ne dépend d'un humain             │
│                                                                 │
│  NIVEAU 2 │ ADVISORY (pack-level, optionnel)                    │
│  ─────────┼─────────────────────────────────────────────────   │
│           │ SME Advisory : le pack peut définir un "SME Proxy"  │
│           │ → suggère des paires A,B à polliniser               │
│           │ → le core évalue ces paires via L1-L4               │
│           │ → le SME NE valide PAS ses propres Seeds            │
│           │ → séparation stricte : suggestion ≠ incorporation  │
│                                                                 │
│  NIVEAU 3 │ VALIDATION (manager/human-in-the-loop)              │
│  ─────────┼─────────────────────────────────────────────────   │
│           │ SOC Manager valide les Seeds VIABLES                │
│           │ → décision de germination                           │
│           │ → jamais automatisé au beachhead                     │
└─────────────────────────────────────────────────────────────────┘
```

### Règles Anti-Cycle

```
1. Un SME ne peut PAS valider ses propres suggestions (segregation of duties)
2. Les Seeds produites par suggestion SME sont tracées avec provenance "sme_advisory"
3. Le SME Advisory est un PROVIDER OPTIONNEL (SmeAdvisoryProvider) — pas dans le core obligatoire
4. Au beachhead MVP : SME Advisory est DÉSACTIVÉ par défaut (mode purement algorithmique)
5. Post-MVP : SME Advisory peut être activé par le pack cyber via configuration
```

### Implémentation Rust (Advisory Provider)

```rust
/// Provider optionnel — le pack peut implémenter ce trait pour fournir
/// des suggestions de paires à polliniser via expertise métier.
///
/// D-024 : ce provider est OPTIONNEL. Le core ne dépend pas de lui.
#[async_trait::async_trait]
pub trait SmeAdvisoryProvider: Send + Sync {
    /// Le SME suggère des paires de nœuds à polliniser.
    /// Retourne une liste de candidats (A_id, B_id, rationale).
    async fn suggest_pollination_pairs(
        &self,
        tree_id: Uuid,
        context: PollinationContext,
    ) -> AppResult<Vec<(Uuid, Uuid, String)>>;

    /// Le SME valide ou rejette une Seed candidate (HITL externe).
    /// Le SME NE valide JAMAIS ses propres suggestions (anti-cycle).
    async fn validate_seed_candidate(
        &self,
        seed: &SeedCandidate,
        sme_id: Uuid,
    ) -> AppResult<SmeValidation>;
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SmeValidation {
    pub sme_id: Uuid,
    pub approved: bool,
    pub confidence: f32,
    pub rationale: String,
    pub suggested_modifications: Option<SeedModification>,
}
```

> **Note** : `SmeAdvisoryProvider` n'est PAS dans la liste des 9 providers DCID. C'est un provider optionnel additionnel (#10), activable par pack.

---

## 3. Paramètres GFE — Catalogue Complet

### 3.1 Pollination Parameters (Conditions L1-L4)

| Paramètre | Symbole | Catégorie | Défaut Beachhead | Range | Description |
|-----------|---------|-----------|-----------------|-------|-------------|
| **Distance min** | `θ_min` | 🔧 | 0.40 | [0.0, 1.0] | Distance sémantique minimum entre A et B (L1). Trop proche = redondance. |
| **Distance max** | `θ_max` | 🔧 | 0.85 | [0.0, 1.0] | Distance sémantique maximum (sweet spot). Trop loin = bruit sans pont. |
| **Alignment min** | `τ` (tau) | 🔧 | 0.60 | [0.0, 1.0] | Alignement minimum avec Vision Helm (L4). |
| **Novelty check** | — | 🔒 | ON | bool | L3 : vérifie que le lien A↔B n'existe pas dans le KG. Toujours activé, pas de toggle. |
| **Bridge detection** | — | 🔒 | ON | bool | L2 : vérifie ∃ pont logique entre A et B. Toujours activé. |

### 3.2 Scoring Parameters (Viability + Fecundity + PlantScore)

| Paramètre | Symbole | Catégorie | Défaut Beachhead | Range | Description |
|-----------|---------|-----------|-----------------|-------|-------------|
| **Gamma** | `γ` | 🔧 | 0.60 | [0.0, 1.0] | Curseur prudence/ambition. γ élevé = prudent (viability prioritaire). γ bas = ambitieux (fecundity prioritaire). |
| **Viability threshold** | `γ_seuil` | 🔧 | 0.40 | [0.0, 1.0] | Seuil minimum de PlantScore pour VIABLE. En dessous → DORMANT. |
| **Feasibility weight** | `w_f` | 🔧 | 0.25 | [0.0, 1.0] | Poids de "peut-on la réaliser ?" dans Viability. |
| **Alignment weight** | `w_a` | 🔧 | 0.30 | [0.0, 1.0] | Poids de "est-elle alignée Vision Helm ?" dans Viability. |
| **Non-redundancy weight** | `w_nr` | 🔧 | 0.25 | [0.0, 1.0] | Poids de "est-elle nouvelle ?" dans Viability. |
| **Resource fit weight** | `w_rf` | 🔧 | 0.20 | [0.0, 1.0] | Poids de "avons-nous les ressources ?" dans Viability. |
| **Potential subtrees factor** | `k_st` | 🔧 | 1.0 | [0.1, 10.0] | Facteur d'échelle pour potential_subtrees dans Fecundity. |
| **Strategic reach factor** | `k_sr` | 🔧 | 1.0 | [0.1, 10.0] | Facteur d'échelle pour strategic_reach dans Fecundity. |

> **Validation** : `w_f + w_a + w_nr + w_rf = 1.0` (normalisé par le core).

### 3.3 Distance Function Parameters

| Paramètre | Symbole | Catégorie | Défaut Beachhead | Description |
|-----------|---------|-----------|-----------------|-------------|
| **Vector weight** | `α` | 🔧 | 0.50 | Poids de la distance vectorielle (embeddings) dans la distance hybride. |
| **Graph weight** | `β = 1 - α` | 🔧 | 0.50 | Poids de la distance graphe (shortest path) dans la distance hybride. |
| **Embedding dim** | `k` | 🔒 | 384 | Dimension du vecteur d'embedding (défini par le modèle utilisé, ex: sentence-transformers). |
| **Graph depth** | `d_max` | 🔧 | 4 | Profondeur max pour le calcul de distance graphe (BFS limité). |

**Formule de distance hybride** :

```
distance(A, B) = α × distance_vector(A, B) + β × distance_graph(A, B)

où :
  distance_vector(A, B) = cosine_distance(embedding_A, embedding_B) ∈ [0, 1]
  distance_graph(A, B) = shortest_path_length(A, B) / d_max ∈ [0, 1]
```

### 3.4 Vision Helm Parameters

| Paramètre | Symbole | Catégorie | Défaut Beachhead | Description |
|-----------|---------|-----------|-----------------|-------------|
| **Axes** | `H = {h₁, h₂, ..., hₖ}` | 🔧 | 5 axes cyber | Vecteur k-dimensionnel du Vision Helm. |
| **Axis weights** | `w₁, w₂, ..., wₖ` | 🔧 | Égalité (1/k) | Poids de chaque axe (somme = 1.0). |
| **Alignment threshold** | `τ` | 🔧 | 0.60 | Minimum pour L4 (alignement Vision Helm). Même valeur que L4. |
| **Goal hierarchy depth** | `d_GH` | 🔧 | 3 | Profondeur max du graphe d'objectifs G_H. |
| **Reactivation alignment threshold** | `τ_wake` | 🔧 | 0.55 | Seuil pour réactiver une graine DORMANT → VIABLE (légèrement plus bas que τ pour permettre le réveil). |

**Vision Helm Cyber (Défaut Beachhead)** :

```
Axes Cyber (k=5) :
  h₁ = DetectionRate       (détection d'incidents)
  h₂ = ResponseVelocity    (vitesse de réponse)
  h₃ = Coverage            (couverture tactiques ATT&CK)
  h₄ = Compliance          (conformité réglementaire)
  h₅ = FalsePositiveRate   (taux de faux positifs)

Weights (défaut) : [0.25, 0.20, 0.25, 0.20, 0.10]
(Detection + Coverage prioritaires pour SOC L1)
```

---

## 4. Formules Canoniques (Core-Fixed)

### 4.1 Distance Hybride (Core-Fixed)

```
distance(A, B) = α × d_vec(A, B) + β × d_graph(A, B)
                 ↑                            ↑
                 pack-configurable             pack-configurable

d_vec(A, B) = 1 - cosine_similarity(embedding_A, embedding_B)
d_graph(A, B) = shortest_path_length(A, B) / d_max
```

### 4.2 Viability (Core-Fixed)

```
Viability(s) = feasibility × alignment × non_redundancy × resource_fit

où :
  feasibility    : Évalué par le core (0.0–1.0) — qualité de la combinaison A⊕B
  alignment       : cos(proj(core_proposition(s)), h) — alignement Vision Helm
  non_redundancy  : 1.0 si lien A↔B n'existe pas dans KG, 0.0 sinon (L3)
  resource_fit    : Évalué par le core (0.0–1.0) — adéquation avec les ressources du pack
```

### 4.3 Fecundity (Core-Fixed)

```
Fecundity(s) = min(potential_subtrees × k_st, 1.0) × min(strategic_reach × k_sr, 1.0)

où :
  potential_subtrees : Nombre de sous-arbres que s peut générer (évalué par core)
  strategic_reach    : Portée stratégique (évalué par core)
  k_st, k_sr         : Facteurs d'échelle pack-configurables
```

### 4.4 PlantScore (Core-Fixed)

```
PlantScore(s) = Viability(s)^γ × Fecundity(s)^(1−γ)

γ = 0.60 (beachhead : prudence prioritaire)
1−γ = 0.40 (ambition secondaire)
```

**Interprétation de γ** :
- γ → 1.0 : ultra-conservateur (seule la viabilité compte)
- γ → 0.0 : ultra-ambitieux (seule la fécondité compte)
- γ = 0.60 (beachhead) : priorité à la viabilité, mais la fécondité influence encore 40%

### 4.5 Alignment Vision Helm (Core-Fixed)

```
align(x, H) = cos(proj(x), h) ∈ [−1, 1] → renormalisé [0, 1]

où :
  proj(x)    : projection de x sur les k axes du Vision Helm
  h          : vecteur pondéré du Vision Helm
  cos()      : similarité cosinus entre proj(x) et h

Si cos < 0 → align = 0 (inversement de la Vision Helm = stérile)
Si cos ≥ 0 → align = cos (normalisé [0, 1])
```

### 4.6 Pollination Operator (Core-Fixed)

```
Pollination(A, B, context) → Seed | ∅

HOOK :
  L1 ← distance(A, B) ≥ θ_min  [pack-configurable]
      AND distance(A, B) ≤ θ_max
  L2 ← ∃ bridge(A, B)           [core-fixed: shortest path in KG]
  L3 ← ∃ edge(A, B) == false    [core-fixed: KG lookup]
  L4 ← align(A⊕B, H) ≥ τ        [pack-configurable]

RESULT :
  Si HOOK == true → Seed { core_proposition, parenthood, potential_tree, viability_profile, provenance }
  Sinon → ∅ (stérile)
```

### 4.7 C1-C7 Seed Validation Hook (Pack-Defined)

> **Pont CYBER_ONTOLOGY** : les 4 conditions L1-L4 filtrent la **compatibilité combinatoire** de deux nœuds en entrée (distance, pont, nouveauté, alignement). Les **7 critères C1-C7** valident la **pertinence métier** d'une Seed en sortie (germination). Les deux systèmes sont **orthogonaux et complémentaires**.

```
POLLINATION COMPLÈTE :
  L1-L4 (combinaison A⊕B viable) → Seed candidate
       │
       ▼
  C1-C7 (domain_filter, optionnel) → Seed validée | Seed rejetée
       │
       ▼
  Seed valide → statut = VIABLE → prête pour germination
```

| Critère CYBER | Rend le résultat… | Test de rejet | Où s'applique |
|---|---|---|---|
| **C1** Grounded | déterministe | nœud sans `sources[]` | Post-pollination, avant VIABLE |
| **C2** Pivot-anchored | reproductible | nœud sans `ontology_ref` | Post-pollination |
| **C3** Criticality-weighted | impactant | priorité non calculable | Post-pollination |
| **C4** Decision-bearing | orienté autonomie | feuille sans décision | Post-pollination |
| **C5** Provable | certifiable | pas de `ProofCriterion` | Post-pollination |
| **C6** Bounded | livrable | scope non borné | Post-pollination |
| **C7** Reproducible | reproductible | génération non déterministe | Post-pollination |

**Règle** : C1-C7 est un **hook optionnel** fourni par le pack via `PackConfigProvider`. 
- Si le pack fournit un `domain_filter` (C1-C7) → toute Seed doit satisfaire les 7 critères pour atteindre le statut `VIABLE`.
- Si le pack ne fournit pas de `domain_filter` → L1-L4 seul fait foi (mode générique).
- **Cybersécurité (cyber pack)** : C1-C7 est **obligatoire**. UnSeed qui échoue à un critèreC1-C7 ne peut pas germer dans le tronc SOC L1.

**Flux complet Cyber Pack** :
```
Pollination(A, B, context) [L1-L4] 
    → Seed candidate 
    → domain_filter C1-C7 [obligatoire cyber] 
    → Seed validée / Seed rejetée
    → Si validée : VIABLE → germination → greffe Semantic Tree
```

### 4.8 seed_hash — Reproducibilité & Identité

Toute Seed GFE possède **deux identités** :

| Identité | Format | Rôle | Source |
|---|---|---|---|
| `seed.id` | UUID v7 | Clé de stockage, ordre chronologique | scy_gfe_parameters (EventBus) |
| `seed_hash` | SHA-256 | Fingerprint logique déterministe | CYBER_ONTOLOGY §8 + scy_gfe_parameters |

```
seed_hash = sha256( 
    role_id 
  + objectif 
  + ontology_version 
  + corpus_snapshot_id 
  + weights 
  + validator_version 
  + seed.id
)
```

**Propriété** : deux générations avec le même `seed_hash` produisent un Seed isomorphe. Toute divergence = bug de déterminisme.

> **Note** : `seed.id` (UUID v7) garantit l'unicité événementielle ; `seed_hash` garantit la reproductibilité logique. Les deux coexistent : l'UUID pour l'EventBus et le stockage, le hash pour l'audit et le SeedValidator.

### 4.9 Post-Germination Weighting — R1/R2/R3 (D9)

> **Pont ARENA** : une Seed greffée dans le Semantic Tree hérite des règles de pondération D9 pour le calcul de couverture.

```
Seed germinée → nouveau nœud dans Semantic Tree
    │
    ▼
  weight(N) = (trunkPriority(N) / 5 × 2 + 1) × (1 + 0.2 × 1[skill_era = new_2026])
    │
    ▼
  score(N) = weight(N) × fidelityCoeff(N)
    │
    ▼
  coverage(pack) = Σ score(N) / Σ score_max(N)
```

**Règle** : le `PlantScore` de la Seed (GFE) et le `trunkPriority` du nœud (D9) sont **deux métriques distinctes et complémentaires** :
- `PlantScore` (GFE) : évalue la **faisabilité générative** d'une idée (Viability × Fecundity).
- `trunkPriority` (D9) : évalue la **criticité pédagogique** d'un nœud dans le tronc SOC L1 (Σ sigma × fréquence × impact × coût_erreur).

**Intégration** : quand une Seed germe en nouveau sous-arbre, les nœuds du sous-arbre reçoivent un `trunkPriority` calculé par le pack via `PackConfigProvider.criticality_formula`. Le `PlantScore` de la Seed parente **n'est pas fusionné** avec `trunkPriority` — il reste dans `seed.viability_profile` comme métadonnée générative.

---

## 5. Paramètres Pack vs Core — Décision de Désignation

### Règle de Décision

```
EST-CE QUE CE PARAMÈTRE DÉPEND DU DOMAINE MÉTIER ?
│
├─ OUI → PACK-CONFIGURABLE (🔧)
│        Exemples : θ_min cyber, Vision Helm axes, Viability weights
│
└─ NON → CORE-FIXED (🔒)
         Exemples : formule PlantScore, structure Seed (5 composants),
                    formule distance hybride, alignment cosinus
```

### Table de Classification Complète

| Paramètre | 🔒 Core-Fixed | 🔧 Pack-Configurable | Justification |
|-----------|:---:|:---:|------|
| Structure Seed (5 composants) | ✅ | — | Invariant structurel |
| Formule PlantScore (Viability^γ × Fecundity^(1−γ)) | ✅ | — | Invariant mathématique |
| Formule Viability (4 facteurs) | ✅ | — | Structure fixe |
| Formule Fecundity (2 facteurs) | ✅ | — | Structure fixe |
| Formule Distance Hybride (α×d_vec + β×d_graph) | ✅ | — | Structure fixe |
| Formule Alignment (cosinus) | ✅ | — | Structure fixe |
| Pollination Operator (L1-L4 structure) | ✅ | — | Logique fixe |
| Cycle de vie Seed (4 états) | ✅ | — | Invariant |
| W3C PROV-DM (provenance) | ✅ | — | Standard externe |
| Bitemporel (event_time + ingestion_time) | ✅ | — | Standard temps |
| θ_min (distance minimum) | — | ✅ | Dépend du domaine (cyber ≠ finance) |
| θ_max (distance maximum) | — | ✅ | Dépend du domaine |
| τ (alignment min, L4) | — | ✅ | Dépend de la stratégie du client |
| τ_wake (reactivation threshold) | — | ✅ | Dépend du domaine |
| γ (curseur prudence/ambition) | — | ✅ | Dépend de la maturité du pack |
| γ_seuil (PlantScore threshold VIABLE) | — | ✅ | Dépend du risque acceptable |
| w_f, w_a, w_nr, w_rf (Viability weights) | — | ✅ | Dépend des priorities métier |
| k_st, k_sr (Fecundity scale factors) | — | ✅ | Dépend du scaling souhaité |
| α, β (distance vector/graph weights) | — | ✅ | Dépend de la densité du KG |
| d_max (graph depth) | — | ✅ | Dépend de la taille du KG |
| Vision Helm axes (k, labels) | — | ✅ | Dépend de la stratégie du client |
| Vision Helm weights | — | ✅ | Dépend des priorities métier |
| Embedding dimension (k) | ✅ | — | Dépend du modèle utilisé (fixé par l'infra) |

---

## 6. Algorithms — Pseudocode

### 6.1 Pollination Algorithm

```rust
async fn pollinate(
    &self,
    source_a: &SemanticNode,
    source_b: &SemanticNode,
    context: PollinationContext,
) -> AppResult<Option<Seed>> {
    // ── L1 : Distance suffisante ──
    let d = hybrid_distance(source_a, source_b, self.params).await?;
    if d < self.params.theta_min || d > self.params.theta_max {
        return Ok(None); // Stérile : distance hors zone féconde
    }

    // ── L2 : Compatibilité (pont logique) ──
    let has_bridge = self.kg.has_bridge(source_a.id, source_b.id).await?;
    if !has_bridge {
        return Ok(None); // Stérile : pas de pont logique
    }

    // ── L3 : Nouveauté ──
    let exists = self.kg.edge_exists(source_a.id, source_b.id).await?;
    if exists {
        return Ok(None); // Stérile : lien existe déjà (rappel, pas création)
    }

    // ── Blending (Fauconnier-Turner) — core-fixed ──
    let core_proposition = self.blender.blend(source_a, source_b, &context).await?;

    // ── L4 : Alignement Vision Helm ──
    let alignment = self.helm.align(&core_proposition).await?;
    if alignment < self.params.tau {
        return Ok(None); // Stérile : hors Vision Helm
    }

    // ── Évaluation Fecundity (Link Prediction) ──
    let (potential_subtrees, strategic_reach) = self
        .link_predictor
        .predict_potential(source_a.id, source_b.id, &core_proposition)
        .await?;

    // ── Scoring ──
    let feasibility = self.evaluate_feasibility(&core_proposition, context.clone()).await?;
    let non_redundancy = 1.0; // L3 already confirmed
    let resource_fit = self.evaluate_resource_fit(&core_proposition).await?;

    let viability = feasibility * alignment * non_redundancy * resource_fit;
    let fecundity = (potential_subtrees * self.params.k_st).min(1.0)
                  * (strategic_reach * self.params.k_sr).min(1.0);
    let plant_score = viability.powf(self.params.gamma)
                    * fecundity.powf(1.0 - self.params.gamma);

    // ── Création Seed ──
    let seed = Seed {
        id: Uuid::now_v7(),
        status: if plant_score >= self.params.gamma_seuil {
            SeedStatus::Viable
        } else {
            SeedStatus::Dormant
        },
        core_proposition,
        parenthood: SeedParenthood {
            source_a_id: source_a.id,
            source_b_id: source_b.id,
            pollination_context: context.serialize(),
            pollination_conditions: PollinationConditions {
                l1_distance_ok: true,
                l2_compatibility_ok: true,
                l3_novelty_ok: true,
                l4_alignment_ok: true,
            },
        },
        potential_tree: None, // rempli à germination
        viability_profile: ViabilityProfile {
            viability,
            fecundity,
            plant_score,
        },
        provenance: SeedProvenance {
            was_derived_from: (source_a.id, source_b.id),
            was_generated_by: self.agent_id.clone(),
            event_time: now_unix(),
            ingestion_time: now_unix(), // même timestamp si pas de délai de découverte
        },
        created_at: now_unix(),
    };

    // ── Émission EventBus ──
    if seed.status == SeedStatus::Viable {
        self.event_bus.publish(SeedViable { ... }).await?;
    } else {
        self.event_bus.publish(SeedDormant { ... }).await?;
    }

    Ok(Some(seed))
}
```

### 6.2 Germination Algorithm

```rust
async fn germinate(
    &self,
    seed: &Seed,
    actor: TreeOpActor,
) -> AppResult<TreeOpResult> {
    // 1. Vérifier que la Seed est VIABLE
    ensure!(seed.status == SeedStatus::Viable, SeedNotViable);

    // 2. Créer le sous-arbre depuis PotentialTree
    let subtree_nodes = self.expand_potential_tree(&seed.potential_tree).await?;

    // 3. Greffer les nœuds via SemanticTreeProvider
    let mut grafted = vec![];
    for node in subtree_nodes {
        let result = self.tree_provider.graft(seed.tree_id, node.parent_id, node).await?;
        grafted.extend(result.affected_nodes);
    }

    // 4. Mettre à jour le status de la Seed
    // Note: La Seed elle-même n'est PAS modifiée (immutable).
    // On crée un SeedEvent "germinated" qui référence la Seed originale.

    // 5. Émission EventBus
    self.event_bus.publish(SeedGerminated {
        event_id: Uuid::now_v7(),
        created_at: now_unix(),
        seed_id: seed.id,
        new_subtree_id: subtree_id,
        germination_actor: actor,
        nodes_created: subtree_nodes.len() as u32,
        edges_created: subtree_edges.len() as u32,
        tree_id: seed.tree_id,
    }).await?;

    Ok(TreeOpResult {
        op: TreeOp::Germinate { seed_id: seed.id },
        affected_nodes: grafted,
        justification: format!("Germination de Seed {} → {} nœuds", seed.id, grafted.len()),
    })
}
```

### 6.3 Wake Dormant Seed Algorithm

```rust
async fn try_wake_dormant(
    &self,
    seed_id: Uuid,
    current_context: &VisionHelmContext,
) -> AppResult<Option<SeedStatus>> {
    let seed = self.seed_store.get(seed_id).await?;

    // 1. Calculer l'alignement avec le contexte actuel
    let current_alignment = self.helm.align_with_context(
        &seed.core_proposition,
        current_context,
    ).await?;

    // 2. Vérifier si le contexte est suffisamment favorable
    if current_alignment >= self.params.tau_wake {
        // 3. Recalculer viability/fecundity avec nouveau contexte
        let new_viability = self.recompute_viability(&seed, current_context).await?;
        let new_fecundity = self.recompute_fecundity(&seed).await?;
        let new_plant_score = new_viability.powf(self.params.gamma)
                            * new_fecundity.powf(1.0 - self.params.gamma);

        if new_plant_score >= self.params.gamma_seuil {
            // 4. Réactiver la Seed
            return Ok(Some(SeedStatus::Viable));
        }
    }

    Ok(None) // Reste DORMANT
}
```

### 6.4 Blending Algorithm (Fauconnier-Turner — Core-Fixed)

```rust
async fn blend(
    &self,
    source_a: &SemanticNode,
    source_b: &SemanticNode,
    context: &PollinationContext,
) -> AppResult<String> {
    // Espace 1 : Input A (structure source_a)
    // Espace 2 : Input B (structure source_b)
    // Espace générique : patterns communs abstraits
    // Espace émergent : structure absente des inputs

    // Étape 1 : Extraire les frames sémantiques
    let frame_a = self.extract_frame(source_a).await?;
    let frame_b = self.extract_frame(source_b).await?;

    // Étape 2 : Identifier les Generic Spaces (points communs)
    let generic = self.find_generic_space(&frame_a, &frame_b).await?;

    // Étape 3 : Composer l'espace émergent (impossible-space → possible-space)
    let emergent = self.compose_emergent_space(&generic, &frame_a, &frame_b, context).await?;

    // Étape 4 : Formuler la Core Proposition
    Ok(emergent.to_core_proposition())
}
```

### 6.5 Link Prediction Algorithm (node2vec — Core-Fixed)

```rust
async fn predict_potential(
    &self,
    node_a: Uuid,
    node_b: Uuid,
    core_proposition: &str,
) -> AppResult<(f32, f32)> {
    // 1. Générer les embeddings via marche aléatoire (node2vec)
    let embeddings = self.node2vec.generate_walk_embeddings(&[node_a, node_b]).await?;

    // 2. Calculer la plausibilité du lien latent
    let latent_score = self.link_predictor.score_link(node_a, node_b, &embeddings).await?;

    // 3. Calculer la nouveauté (σ(A,B))
    let novelty = self.kg.compute_novelty(node_a, node_b).await?;

    // 4. Potential subtrees = combien de sous-arbres peuvent naître de ce lien
    let potential_subtrees = self.estimate_subtrees(node_a, node_b, latent_score).await?;

    // 5. Strategic reach = portée stratégique dans la hiérarchie
    let strategic_reach = self.compute_strategic_reach(node_a, node_b).await?;

    Ok((potential_subtrees, strategic_reach))
}
```

---

## 7. SME Advisory — Configuration Pack-Définie

### Activation / Désactivation

```rust
// Dans PackConfig (PackConfigProvider)
pub struct PackConfig {
    pub mastery_threshold: f32,
    pub smi_weights: SMIWeights,
    pub helm_axes: Vec<HelmAxis>,
    pub criticality_formula: String,
    pub custom: HashMap<String, serde_json::Value>,

    // === OPTIONNEL : SME Advisory ===
    pub sme_advisory: Option<SmeAdvisoryConfig>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SmeAdvisoryConfig {
    pub enabled: bool,                // false par défaut (beachhead)
    pub sme_role_id: String,          // rôle du SME (ex: "senior_analyst")
    pub max_suggestions_per_session: u32,  // rate limiting
    pub anti_cycle_rule: bool,        // true = SME ne valide pas ses propres Seeds
    pub suggestion_scope: SuggestionScope,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum SuggestionScope {
    IntraTree,               // suggestions dans le même STB
    CrossTree,               // suggestions entre STB (post-MVP)
    ExternalKnowledge,       // suggestions avec base de connaissances externe (post-MVP)
}
```

### Anti-Cycle Enforcement

```rust
/// Garantit qu'un SME ne valide JAMAIS ses propres suggestions.
pub async fn validate_sme_anti_cycle(
    &self,
    seed: &Seed,
    sme_id: Uuid,
) -> AppResult<()> {
    // Récupérer les suggestions du SME pour cette session
    let sme_suggestions = self.sme_advisory_store
        .get_suggestions_by_sme(sme_id, seed.created_at - 3600, seed.created_at)
        .await?;

    let seed_parents = (&seed.parenthood.source_a_id, &seed.parenthood.source_b_id);

    // Vérifier qu'aucun parent ne provient d'une suggestion du SME
    for suggestion in &sme_suggestions {
        if suggestion.node_a == *seed_parents.0 || suggestion.node_b == *seed_parents.1 {
            return Err(AppError::SmeAntiCycleViolation {
                sme_id,
                seed_id: seed.id,
                reason: "SME ne peut pas valider ses propres suggestions",
            });
        }
    }

    Ok(())
}
```

---

## 8. Paramètres MVP (Beachhead) — Configuration par Défaut

### Config Minimale pour Cyber Pack

```toml
# packs/cyber/config/gfe_params.toml

[gfe_core]
# Paramètres core-fixed (lecture seule, pas de modification possible)
gamma = 0.60                      # prudence pour beachhead
gamma_seuil = 0.40                # seuil VIABLE
viability_factors = ["feasibility", "alignment", "non_redundancy", "resource_fit"]

[gfe_distance]
alpha = 0.50                      # 50% vector, 50% graph
beta = 0.50                       # 1 - alpha
d_max = 4                         # profondeur BFS max

[gfe_pollination]
theta_min = 0.40                  # distance minimum
theta_max = 0.85                  # distance maximum (sweet spot)
tau = 0.60                        # alignement Vision Helm minimum (L4)
tau_wake = 0.55                   # réactivation DORMANT (légerement plus bas)

[gfe_fecundity]
k_st = 1.0                        # potential_subtrees scale
k_sr = 1.0                        # strategic_reach scale

[gfe_viability]
w_f = 0.25                        # feasibility weight
w_a = 0.30                        # alignment weight
w_nr = 0.25                       # non_redundancy weight
w_rf = 0.20                       # resource_fit weight

[gfe_vision_helm]
axes = ["DetectionRate", "ResponseVelocity", "Coverage", "Compliance", "FalsePositiveRate"]
weights = [0.25, 0.20, 0.25, 0.20, 0.10]
goal_hierarchy_depth = 3

[gfe_sme_advisory]
enabled = false                   # DÉSACTIVÉ au beachhead MVP
sme_role_id = ""                  # pas de SME au MVP
max_suggestions_per_session = 0
anti_cycle_rule = true
suggestion_scope = "intra_tree"
```

### Validation des Paramètres

```rust
/// Valide que les paramètres GFE sont cohérents (invariants).
pub fn validate_gfe_params(params: &GFEParameters) -> Result<(), GFEValidationError> {
    // 1. Les poids de viability doivent sommer à 1.0
    let w_sum = params.w_f + params.w_a + params.w_nr + params.w_rf;
    if (w_sum - 1.0).abs() > 0.001 {
        return Err(GFEValidationError::WeightsNotNormalized { sum: w_sum });
    }

    // 2. α + β = 1.0
    if (params.alpha + params.beta - 1.0).abs() > 0.001 {
        return Err(GFEValidationError::DistanceWeightsNotNormalized {
            alpha: params.alpha,
            beta: params.beta,
        });
    }

    // 3. θ_min < θ_max
    if params.theta_min >= params.theta_max {
        return Err(GFEValidationError::ThetaRangeInvalid {
            min: params.theta_min,
            max: params.theta_max,
        });
    }

    // 4. γ ∈ [0, 1]
    if !(0.0..=1.0).contains(&params.gamma) {
        return Err(GFEValidationError::GammaOutOfRange { gamma: params.gamma });
    }

    // 5. γ_seuil ∈ [0, 1]
    if !(0.0..=1.0).contains(&params.gamma_seuil) {
        return Err(GFEValidationError::GammaSeuilOutOfRange);
    }

    // 6. τ ∈ [0, 1], τ_wake ≤ τ
    if !(0.0..=1.0).contains(&params.tau) {
        return Err(GFEValidationError::TauOutOfRange);
    }
    if params.tau_wake > params.tau {
        return Err(GFEValidationError::TauWakeGreaterThanTau {
            tau_wake: params.tau_wake,
            tau: params.tau,
        });
    }

    // 7. Vision Helm weights somment à 1.0
    let helm_sum: f32 = params.helm_weights.iter().sum();
    if (helm_sum - 1.0).abs() > 0.001 {
        return Err(GFEValidationError::HelmWeightsNotNormalized { sum: helm_sum });
    }

    Ok(())
}
```

---

## 9. Paramètres Post-MVP (Expansion)

### Paramètres activés au mode expansion (M36+)

| Paramètre | Statut MVP | Statut Post-MVP | Activation |
|-----------|-----------|-----------------|------------|
| **SME Advisory** | ❌ Désactivé | ✅ Activé | Pack fournit `SmeAdvisoryConfig { enabled: true }` |
| **XPOLL (Cross-Pollination)** | ❌ Différé | ✅ Activé | Multi-pack déployé |
| **Germination Auto** | ❌ Manuel (manager) | ✅ Automatique | PlantScore ≥ γ_seuil + validation auto |
| **Germination Poids** | γ = 0.60 (prudent) | γ = 0.40 (ambitieux) | Pack ajuste γ |
| **Wake Scheduling** | Manuel | Automatique (bitemporel) | Cron job + contexte favorable |

---

## 10. HITL — Questions en Attente de Validation

| # | Question | Impact si changé |
|---|----------|-----------------|
| **HITL-1** | SME Advisory : activé au MVP ou post-MVP ? | Si activé MVP : implémenter provider + anti-cycle. Si post-MVP : différer. |
| **HITL-2** | γ (curseur) : 0.60 est-il le bon équilibre beachhead ? | Trop prudent → Seeds rares. Trop ambitieux → Seeds de mauvaise qualité. |
| **HITL-3** | Vision Helm axes : les 5 axes cyber sont-ils corrects ? | Le RSSI corporate voudra likely ajouter "Compliance" en priorité, réduire "FalsePositiveRate". |
| **HITL-4** | Germination : manuelle (manager valide) ou semi-auto ? | Manuelle = plus de contrôle, semi-auto = plus rapide. |
| **HITL-5** | Seed sleep/wake : intervalle de réévaluation du contexte ? | 24h ? 7j ? Pack-configurable ? |

---

## 11. Règles d'Or (Non-Negotiable)

```
1. Jamais de modification de paramètre core-fixed par un pack (🔒 = immuable)
2. Absence de paramètre pack-configurable → MissingPackConfig error, jamais de fallback
3. SME Advisory : toujours séparé de la validation de Seeds (anti-cycle garanti)
4. Distance hybride : α + β = 1.0 toujours (vérifié à la validation)
5. Viability weights : somme = 1.0 toujours (vérifié à la validation)
6. All Seeds sont append-only — aucun score n'est jamais recalculé après création
7. γ_seuil < γ_seuil_wake < τ (hiérarchie : germination > réveil > alignement)
8. Blending et Link Prediction sont core-fixed (pas de toggle pack)
9. Les paramètres pack sont validés avant activation du pack (ValidationGuardProvider)
10. Toute modification de paramètre post-déploiement nécessite un événement PackConfigChanged sur l'EventBus
```

---

## 12. Types Rust — Seed & SeedStatus (Référence Implémentation)

### 12.1 SeedStatus — Machine à états (SM-2)

```rust
/// Cycle de vie d'une Seed GFE (SM-2).
/// Règle d'or : aucune Seed n'est détruite. DORMANT ≠ mort.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum SeedStatus {
    /// Seed créée par pollinisation, en attente d'évaluation L1-L4 + C1-C7
    Pollinated,
    /// Seed ayant satisfait L1-L4 + C1-C7, prête pour germination
    Viable,
    /// Seed en cours de germination (sous-arbre en construction)
    Germinating,
    /// Seed stérile ou non priorisée — conservée, jamais détruite
    Dormant,
}

/// Transitions autorisées :
///   POLLINATED ──(L1-L4 + C1-C7 pass)──▶ VIABLE
///   POLLINATED ──(échec)──▶ DORMANT
///   VIABLE ──(germination)──▶ GERMINATING
///   VIABLE ──(contexte défavorable)──▶ DORMANT
///   GERMINATING ──(succès)──▶ NEW SUBTREE
///   DORMANT ──(contexte favorable)──▶ VIABLE  (réveil bitemporel)
```

### 12.2 Seed — Structure complète (5 composants + seed_hash)

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Seed {
    pub id: Uuid,                    // UUID v7 — clé de stockage, ordre chronologique
    pub seed_hash: String,           // SHA-256 — fingerprint logique déterministe (reproductibilité C7)
    pub status: SeedStatus,          // SM-2 : POLLINATED → VIABLE → GERMINATING / DORMANT
    pub tree_id: Uuid,               // l'arbre dans lequel la Seed peut germer
    pub organization_id: Uuid,       // organisation propriétaire
    pub domain_pack_id: String,      // pack qui a produit la Seed

    // ① CORE PROPOSITION
    pub core_proposition: String,    // l'idée/décision/méthode neuve

    // ② PARENTHOOD
    pub parenthood: SeedParenthood,  // (source_A, source_B) + contexte + conditions L1-L4

    // ③ POTENTIAL TREE
    pub potential_tree: Option<JsonValue>, // arbre en puissance (nullable jusqu'à germination)

    // ④ VIABILITY PROFILE
    pub viability_profile: ViabilityProfile, // viability + fecundity + plant_score + breakdown

    // ⑤ PROVENANCE
    pub provenance: SeedProvenance,  // lignée datée immuable + corpus_snapshot_id

    pub pollination_context: Option<JsonValue>, // contexte de la pollinisation
    pub created_at: i64,             // timestamp création
    pub updated_at: i64,             // timestamp dernière modification
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedParenthood {
    pub source_a_id: Uuid,
    pub source_b_id: Uuid,
    pub pollination_context: JsonValue,
    pub pollination_conditions: PollinationConditions, // L1-L4 bools
    pub seed_hash: String,           // hash de la parenthood (intègre corpus_snapshot_id)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PollinationConditions {
    pub l1_distance_ok: bool,
    pub l2_compatibility_ok: bool,
    pub l3_novelty_ok: bool,
    pub l4_alignment_ok: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ViabilityProfile {
    pub viability: f32,              // feasibility × alignment × non_redundancy × resource_fit
    pub fecundity: f32,              // potential_subtrees × strategic_reach
    pub plant_score: f32,            // Viability^γ × Fecundity^(1−γ)
    pub breakdown: ViabilityBreakdown,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ViabilityBreakdown {
    pub feasibility: f32,
    pub alignment: f32,
    pub non_redundancy: f32,
    pub resource_fit: f32,
    pub potential_subtrees: f32,
    pub strategic_reach: f32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeedProvenance {
    pub was_derived_from: (Uuid, Uuid),  // (source_A, source_B)
    pub was_generated_by: String,        // agent_id qui a produit la Seed
    pub corpus_snapshot_id: String,      // hash du corpus entreprise (CYBER_ONTOLOGY §8)
    pub event_time: i64,                 // timestamp création
    pub ingestion_time: i64,             // timestamp découverte
    pub validator_version: String,       // version du SeedValidator (C1-C7)
}
```

### 12.3 seed_hash — Calcul déterministe (C7)

```rust
/// Calcule le seed_hash déterministe pour la reproductibilité C7.
/// Deux Seeds avec même seed_hash doivent être isomorphes.
pub fn compute_seed_hash(
    role_id: &str,
    objectif: &str,
    ontology_version: &str,
    corpus_snapshot_id: &str,
    weights: &str,
    validator_version: &str,
    seed_id: Uuid,
) -> String {
    let input = format!(
        "{}{}{}{}{}{}{}",
        role_id, objectif, ontology_version, corpus_snapshot_id,
        weights, validator_version, seed_id
    );
    sha256::digest(input.as_bytes())
}
```

### 12.4 Provider × owner_kind — Matrice de responsabilité

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
| ValidationGuardProvider | ✅ | ✅ | ❌ | Validation sorties générées (pack/org) — learner = consommateur, pas générateur |

**Règles d'invocation par owner_kind** :
- `plant()` : autorisé sur DomainPack + Organization (jamais Learner directement)
- `graft()` : autorisé sur DomainPack + Organization (jamais Learner)
- `test()` : autorisé sur Learner uniquement
- `myelinate()` : autorisé sur Learner uniquement
- `prune()` : autorisé sur DomainPack + Organization

---

*Fin du document. Ce document fige les paramètres, algorithmes et formules du GFE. Soumis à HITL validation pour les 5 questions en §10. Toute modification de paramètre doit être tracée via EventBus (PackConfigChanged).*

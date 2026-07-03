# SCY FORGE — FORMULAS & CONSTANTS (CANONICAL)
**Document ID** : S01_FORMULAS  
**Date** : 2026-07-01  
**Statut** : 🟢 NORMATIF — Source de vérité pour toutes les formules  
**Pilier** : Pilier 1 (Semantic Tree) + Pilier 2 (ASCENT/APEX) + Pilier 3 (GFE)

---

## 1. Principe Fondateur

> **D-024** : Le core est un squelette générique sans mémoire métier ; la connaissance, les règles et les seuils vivent dans les packs — extensibilité par conception.

**Règle d'or** : Toute formule ci-dessous est soit **CORE-FIXED** (invariant mathématique), soit **PACK-CONFIGURABLE** (seuils, poids, axes fournis par PackConfigProvider). Aucune constante métier n'est hardcodée dans le core.

---

## 2. Symboles et Notation

| Symbole | Définition | Unité |
|---------|-----------|-------|
| `τ` (tau) | Seuil d'alignement Vision Helm (L4) | [0,1] |
| `θ_min` | Distance sémantique minimum (L1) | [0,1] |
| `θ_max` | Distance sémantique maximum (sweet spot) | [0,1] |
| `γ` (gamma) | Curseur prudence/ambition (PlantScore) | [0,1] |
| `γ_seuil` | Seuil PlantScore pour VIABLE | [0,1] |
| `α` (alpha) | Poids distance vectorielle (hybride) | [0,1] |
| `β` (beta) | Poids distance graphe (hybride), `β = 1 − α` | [0,1] |
| `h ∈ ℝᵏ` | Vecteur Vision Helm (k axes pondérés) | — |
| `k` | Dimension embedding / nombre axes Vision Helm | entier |
| `d_max` | Profondeur max BFS pour distance graphe | entier |
| `w_f, w_a, w_nr, w_rf` | Poids Viability (feasibility, alignment, non_redundancy, resource_fit) | [0,1], somme = 1 |
| `k_st, k_sr` | Facteurs d'échelle Fecundity | [0.1, 10] |
| `SMI` | Skill Mastery Index | [0,1] |
| `θ_mastery` | mastery_threshold pack-défini | [0,1] |
| `conf` | confidence (prouvée par test) | [0,1] |

---

## 3. SMI — Skill Mastery Index (Pilier 1 + Pilier 2)

### 3.1 Formule Canonique

```
SMI(learner, node) = w_r × SMI_r(learner, node)
                   + w_f × SMI_f(learner, node)
                   + w_g × SMI_g(learner, node)
                   + w_d × SMI_d(learner, node)
```

**4 dimensions** :

| Dimension | Symbole | Définition | Poids défaut |
|-----------|---------|-----------|-------------|
| **Rétention** | `SMI_r` | Performance FSRS (cartes dues, taux de réussite) | `w_r = 0.35` |
| **Fluency** | `SMI_f` | Nombre d'expositions × taux de succès (fluidité) | `w_f = 0.25` |
| **Gap** | `SMI_g` | % prérequis maîtrisés (tronc-avant-feuilles) | `w_g = 0.25` |
| **Depth** | `SMI_d` | Profondeur de maîtrise dans l'arbre (feuilles vs tronc) | `w_d = 0.15` |

### 3.2 Chaque Dimension Calculée

```
SMI_r(learner, node) = mean({card.score | card in due_cards(node)})  // FSRS
                     ∥ 0.0 si aucune carte due

SMI_f(learner, node) = success_count / exposure_count
                     ∥ 0.0 si exposure_count == 0

SMI_g(learner, node) = mastered_parents(node) / total_parents(node)

SMI_d(learner, node) = 1.0 − (depth(node) / max_depth(tree))
                     // tronc = 1.0, feuilles = ~0.0
```

### 3.3 SMI Global d'un Learner

```
SMI_global(learner, tree) = Σ_{node ∈ mastered_scope(learner)} SMI(learner, node)
                           / |mastered_scope(learner)|
```

Où `mastered_scope(learner)` = ensemble des nœuds du rôle_subtree du learner où `SMI(learner, node) ≥ θ_mastery`.

### 3.4 Mastery d'un Nœud (Core-Side)

```
is_mastered(learner, node) = SMI(learner, node) ≥ θ_mastery
```

**D-024** : `θ_mastery` est fourni par `PackConfigProvider`. Le core ne connaît aucune valeur par défaut. Absence → `MissingPackConfig` error.

---

## 4. Distance Functions (Pilier 3 — GFE)

### 4.1 Distance Hybride (Core-Fixed)

```
distance(A, B) = α × d_vector(A, B) + β × d_graph(A, B)

contrainte : α + β = 1.0
```

### 4.2 Distance Vectorielle (Cosine)

```
d_vector(A, B) = 1 − cosine_similarity(embedding_A, embedding_B)
               = 1 − (embedding_A · embedding_B) / (||embedding_A|| × ||embedding_B||)
```

Résultat ∈ [0, 1] (0 = identiques, 1 = opposés).

### 4.3 Distance Graphe (Shortest Path Normalisé)

```
d_graph(A, B) = shortest_path_length(A, B) / d_max

contrainte : si pas de chemin → d_graph = 1.0 (distance maximale)
```

### 4.4 Zone Féconde (L1)

```
zone_feconde(A, B) = (θ_min ≤ distance(A, B) ≤ θ_max)
                   AND has_bridge(A, B)           // L2
                   AND NOT edge_exists(A, B)      // L3
```

---

## 5. Viability, Fecundity, PlantScore (Pilier 3 — GFE)

### 5.1 Viability (4 facteurs)

```
Viability(s) = feasibility × alignment × non_redundancy × resource_fit

où :
  feasibility    ∈ [0,1] : qualité de la combinaison A⊕B (évalué par Blending)
  alignment       ∈ [0,1] : cos(proj(core_proposition(s)), h) — Vision Helm
  non_redundancy  ∈ [0,1] : 1.0 si L3 passé (lien nouveau), 0.0 sinon
  resource_fit    ∈ [0,1] : adéquation avec les ressources du pack
```

### 5.2 Fecundity (2 facteurs)

```
Fecundity(s) = min(potential_subtrees × k_st, 1.0) × min(strategic_reach × k_sr, 1.0)

où :
  potential_subtrees : nombre de sous-arbres que s peut générer (Link Prediction)
  strategic_reach    : portée stratégique dans la hiérarchie (nombre de tactiques couvertes)
  k_st, k_sr         : facteurs d'échelle pack-configurables
```

### 5.3 PlantScore (Core-Fixed)

```
PlantScore(s) = Viability(s)^γ × Fecundity(s)^(1−γ)

γ = curseur prudence/ambition
   γ → 1.0 : ultra-conservateur (seule viability compte)
   γ → 0.0 : ultra-ambitieux (seule fecondity compte)
   γ = 0.60 (beachhead défaut) : prudent mais ambitieux
```

### 5.4 Classification

```
if PlantScore(s) ≥ γ_seuil → status = VIABLE
else                        → status = DORMANT
```

---

## 6. Vision Helm Alignment (Pilier 3 — GFE)

### 6.1 Alignement d'une Proposition

```
align(x, H) = cos(proj_k(x), h) ∈ [−1, 1]
            → renormalisé :
                si cos < 0 → align = 0.0 (inversé = stérile)
                si cos ≥ 0 → align = cos (normalisé [0,1])
```

### 6.2 Projection sur le Vision Helm

```
proj_k(x) = (score(x, axis₁), score(x, axis₂), ..., score(x, axisₖ))

où score(x, axis_i) ∈ [0,1] : adéquation de x avec l'axe i
```

### 6.3 Vecteur Vision Helm

```
h = (w₁·axis₁, w₂·axis₂, ..., wₖ·axisₖ)

où :
  Σ weights = 1.0 (normalisé)
  k = nombre d'axes (5 pour cyber beachhead)
```

---

## 7. Pollination Operator (Pilier 3 — GFE)

### 7.1 Les 4 Conditions (L1-L4)

```
Pollination(A, B, context) → Seed | ∅

L1 ← distance(A, B) ∈ [θ_min, θ_max]       // zone féconde
L2 ← has_bridge(A, B)                        // pont logique
L3 ← NOT edge_exists(A, B)                   // nouveauté
L4 ← align(A⊕B, H) ≥ τ                       // alignement Vision Helm

HOOK = L1 AND L2 AND L3 AND L4

SI HOOK == true → Seed viable
SINON → ∅ (stérile)
```

### 7.2 First-Principles Composition (Core-Fixed)

```
compose_from_invariants(A, B, context) = emergent_proposition

Étapes :
  1. Remonter A et B vers leur tronc commun / invariant atomique
  2. Identifier ce qui reste vrai quand les détails de surface sont retirés
  3. Composer une proposition depuis ces invariants, pas depuis une analogie de surface
  4. Rejeter toute proposition qui ne peut pas rattacher sa parenthood au tronc

core_proposition = compress(emergent_space, context)
```

**Règle de cohérence** : le blending conceptuel peut inspirer la représentation, mais il n'est pas la source de validité scientifique du GFE. La validité vient du couple `root_depth` + invariant + traçabilité + validation L1-L4.

### 7.3 Link Prediction / Co-occurrence (Scoring auxiliaire, non générateur)

```
predict(A, B) → (potential_subtrees, strategic_reach)

1. Générer embeddings via marche aléatoire node2vec
2. Calculer latent_score = score_link(A, B, embeddings)
3. Calculer novelty = 1.0 − max_similarity(A, B, existing_edges)
4. potential_subtrees = estimate_subtrees(A, B, latent_score)
5. strategic_reach = compute_strategic_reach(A, B) // profondeur hiérarchique
```

**Règle de cohérence** : la prédiction de lien ne crée pas une Seed. Elle sert à estimer `Fecundity`, à construire des baselines et à détecter les redondances. Une Seed ne peut être promue que si elle passe la composition par invariants, L1-L4, la provenance et la validation métier.

---

## 8. SCY FORGE PRICING — TABLES & FORMULAS

> Cette section fige les grilles tarifaires. Toute modification nécessite une mise à jour du PRD Part 1 + PIVOT_ARCHITECTURE §9.4.

### 8.1 Pure-Player Cyber (B2B SOC)

| Tier | Prix/an | Analysts | Packs MITRE | Secteurs | Features |
|------|---------|----------|-------------|----------|----------|
| **Trial** | 0 $ | 5 | 1 | 0 | Onboarding, Semantic Tree, 1 scenario |
| **Team** | 5 000 $ | 5-20 | 1 | +1 secteur | Manager Dashboard, Role Subtrees, Tactical AI |
| **Enterprise** | 25 000 $ | 20-100 | Multi | Multi | SSO/SAML, analytics avancés, custom scenarios |
| **Government** | Custom | ∞ | Custom | Custom | On-prem, FedRAMP, custom ontology |

### 8.2 Corporate Non-Tech (Peak-Opportunity)

| Tier | Prix/an | Employees | Packs | Features |
|------|---------|-----------|-------|----------|
| **Trial** | 0 $ | 10 | 1 MITRE + 1 secteur | Basic onboarding, compliance mapping |
| **Industry** | 50 000 $+ | 50+ | Multi-sector | Sector Pack Builder, B2B2C deployment, Phishing Sim |
| **Enterprise Corp** | 25 000 $ | 50+ | MITRE + secteurs | SSO/SAML, analytics, incident reports |

### 8.3 ACV (Annual Contract Value) Targets

```
ACV moyen cible M6  : ~5 000 $/an/client (mix Trial→Team)
ACV moyen cible M18 : ~15 000 $/an/client (+ Corporate tier)
MRR cible M6        : 50 K$ (100 SOCs × avg ACV/12)
MRR cible M18       : 200 K$ (100 SOCs B2B + 20 Corporate)
```

### 8.4 Ticket Mobilité (Formule d'estimation)

```
ticket_mobilite = (ACV_pack × stack_depth × user_count) / learning_retention_rate

où :
  ACV_pack        : prix du pack annuel
  stack_depth     : profondeur moyenne du Semantic Tree maîtrisé (0.0-1.0)
  user_count      : nombre d'analysts
  learning_retention_rate : taux de rétention 6 mois (0.0-1.0)
```

Cette formule permet au SOC Manager de justifier l'investissement :
> "Former 5 analysts sur un stack depth de 0.60 avec un ACV de 5K$ = valeur créée × rétention."

---

## 9. FSRS-Inspired Constants (APEX/Retention)

> **Note** : Ces constantes sont des **DEFAULTS PACK-CONFIGURABLES**. Le pack cyber peut les surcharger.

### 9.1 Stabilité (S) — Probabilité de Rappel

```
S(t) = CF × (1 + t / τ)^(−β)

où :
  CF   : Courbe Facteur (0.0-1.0, difficulté initiale)
  t    : temps depuis dernière révision (jours)
  τ    : demi-vie (jours) — pack-configurable
  β    : facteur d'aplatissement — pack-configurable
```

### 9.2 Intervalle de Révision (FSRS 5.0 inspired)

```
interval = τ × (S_desired / S_current)^(−1/β)

où :
  S_desired : stabilité cible (ex: 0.90)
  S_current : stabilité actuelle (calculée)
```

### 9.3 Criticality (Peso d'un Nœud)

```
criticality(node) = Σ_{child ∈ children(node)} depth(child) × density(child)

density(child) = edge_count(child) / max_possible_edges  // 0.0-1.0
```

**D-024** : Cette formule est le **défaut du core**. Un pack peut fournir une formule alternative via `PackConfigProvider.criticality_formula`.

---

## 10. Gap Detection Formula

```
Gap(learner, node) = {
    type: MasteryBelowThreshold,
    severity: Critical,
    remediation: "Study prerequisites"
} IF SMI(learner, node) < θ_mastery
  AND all_parents(node).all(p → is_mastered(learner, p))

type: PrerequisiteMissing
IF ∃ parent p of node : NOT is_mastered(learner, p)

type: CoverageIncomplete
IF |mastered_nodes(learner)| / |role_subtree| < coverage_target
```

---

## 11. Constantes Mathématiques (Core-Fixed)

| Constante | Symbole | Valeur | Usage |
|-----------|---------|--------|-------|
| **Epsilon anti-NaN** | `ε` | 10⁻⁶ | D-OPT-012 : softening au dénominateur |
| **Gamma beachhead** | `γ` | 0.60 | PlantScore : prudence |
| **Gamma seuil VIABLE** | `γ_seuil` | 0.40 | Seuil PlantScore pour VIABLE |
| **Tau L4** | `τ` | 0.60 | Alignement Vision Helm minimum |
| **Tau wake** | `τ_wake` | 0.55 | Réactivation DORMANT (légerement plus bas) |
| **Theta min** | `θ_min` | 0.40 | Distance min pollination (L1) |
| **Theta max** | `θ_max` | 0.85 | Distance max pollination (sweet spot) |
| **Alpha distance** | `α` | 0.50 | Poids vectoriel distance hybride |
| **Beta distance** | `β` | 0.50 | Poids graphe distance hybride |
| **Embedding dim** | `k` | 384 | Dimension embeddings (dépend du modèle) |
| **Graph depth max** | `d_max` | 4 | BFS limité pour distance graphe |
| **Viability w_f** | `w_f` | 0.25 | Poids feasibility |
| **Viability w_a** | `w_a` | 0.30 | Poids alignment |
| **Viability w_nr** | `w_nr` | 0.25 | Poids non_redundancy |
| **Viability w_rf** | `w_rf` | 0.20 | Poids resource_fit |
| **SMI w_r** | `w_r` | 0.35 | Poids rétention |
| **SMI w_f** | `w_f` | 0.25 | Poids fluency |
| **SMI w_g** | `w_g` | 0.25 | Poids gap |
| **SMI w_d** | `w_d` | 0.15 | Poids depth |

> **Rappel** : Les constantes marquées 🔧 ci-dessus sont des **défauts pack-configurables**. Le core ne les utilise que si le pack ne les fournit pas → `MissingPackConfig` error, jamais de silent fallback.

---

*Fin du document. Toute implémentation qui utilise ces formules doit citer ce document. Toute modification de formule nécessite une mise à jour de ce document + notification EventBus (PackConfigChanged).*

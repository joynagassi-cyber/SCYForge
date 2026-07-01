# SCYForge — Index & Consolidation de la pile Génératif + Beth

> **Statut** : document de consolidation (index + passe de cohérence). **Aucun code.**
> **But** : donner une vue unique sur les 7 documents qui composent le **moteur génératif** et son
> **Validateur de Tronc (Beth)**, vérifier que notations / scores / flux concordent, et exposer la
> chaîne de bout en bout : *du savoir privé → à la graine prouvée fondée*.

---

## 1. Carte des documents (ordre de lecture recommandé)

| # | Document | Rôle dans la pile |
|---|---|---|
| 1 | `SCYFORGE_GENERATIVE_TREE_POLLINATION_SEED.md` | **Concept** : Pollination + Seed appliqués au semantic tree (émergence) |
| 2 | `SCYFORGE_GENERATIVE_ENGINE_LOGICAL_MODEL.md` | **Logique** : pollination/seed, viability, Vision Helm, provenance (PROV + bitemporel) |
| 3 | `SCYFORGE_GENERATIVE_ENGINE_MATH_FORMALIZATION.md` | **Math** : distance hybride, `root_depth`, `Π`, viability, `PlantScore`, First-Principles via Semantic Tree |
| 4 | `SCYFORGE_BETH_TRUNK_VALIDATOR.md` | **Preuve** : Validateur de Tronc par Arbres de Beth, `Foundationality` |
| 5 | `SCYFORGE_BETH_LOGICAL_REPRESENTATION_CYBER.md` | **Formalisation** : Datalog-like, exemple T1059.001/Sigma, score hybride formel/tacite |
| 6 | `SCYFORGE_BETH_ASCENT_AGENT_COUPLING.md` | **Intégration** : agent AG16 TRUNK-VALIDATOR, couplage AG15/AG13 |
| 7 | `minddoc/.../ag16_trunk_validator/` (spec/plan/tasks/tests) | **Spec agent** : contrat ASCENT complet d'AG16 |

---

## 2. La chaîne de bout en bout (flux unifié)

```
  SAVOIR PRIVÉ (DomainPack / Org / Learner — Semantic Tree Base)
        │
   [1-2] POLLINATION : croisement de sous-arbres distants au tronc commun profond
        │            potentiel  Π = D · root_depth   (loin en surface, racine commune profonde = fécond)
        ▼
   [3] DÉCOMPOSITION par premiers principes (First-Principles via Semantic Tree, PAS analogie)
        │            remontée jusqu'aux invariants atomiques du tronc
        ▼
   [4-7] AG16 TRUNK-VALIDATOR (Arbres de Beth)
        │            prouve  T ⊢ K  →  Foundationality = w_f·formel + w_t·tacite  ∈ [0,1]
        │            formel = Derivability · Irreducibility · Consistency
        │            tacite = moy(root_depth, feynman, sop_grounding, coverage)
        ▼
   [3] BLENDING depuis l'invariant (Fauconnier-Turner, ancré sur invariants décomposés)
        │
        ▼
   SEED  →  Viability = feasibility · alignment · non_redundancy · resource_fit
        │            feasibility  ⟵ pondéré par Foundationality du tronc d'origine
        │   Fecundity = potential_subtrees · strategic_reach
        │   PlantScore = Viability^γ · Fecundity^(1-γ)
        ▼
   GRAINE PLANTÉE (traçable : PROV wasDerivedFrom + bitemporel event/ingestion time)
```

> **Le point de jonction Beth ↔ génératif** : la `Foundationality` (doc 4-5) **pondère `feasibility`** (doc 2-3), qui est un facteur de `Viability`, qui entre dans `PlantScore`. Une graine issue d'un tronc **prouvé** est mécaniquement plus viable. **Cohérence vérifiée.**

---

## 3. Glossaire unifié des notations (source de vérité unique)

| Symbole | Définition | Doc source | Plage |
|---|---|---|---|
| `D` | distance hybride `α·d_sem + β·d_struct` | 3 | ≥ 0 |
| `root_depth(A,B)` | profondeur du tronc commun (LCA) | 3 | ≥ 0 |
| `Π` | potentiel de pollination `D · root_depth` | 3 | ≥ 0 |
| `Viability` | `feasibility · alignment · non_redundancy · resource_fit` | 2,3 | [0,1] |
| `Fecundity` | `potential_subtrees · strategic_reach` | 3 | ≥ 0 |
| `PlantScore` | `Viability^γ · Fecundity^(1-γ)` | 3 | ≥ 0 |
| `Foundationality` | `w_f·Score_formel + w_t·Score_tacite` | 4,5 | [0,1] |
| `Score_formel` | `Derivability · Irreducibility · Consistency` | 4,5 | [0,1] |
| `Score_tacite` | moy. pond. (`root_depth`,`feynman`,`sop_grounding`,`coverage`) | 5 | [0,1] |
| `τ` | curseur pollination dirigée↔ouverte (cyber ≈ 0.2) | 3 | [0,1] |
| `h ∈ ℝᵏ` | vecteur Vision Helm (pour `align`) | 3 | — |
| `Dmax`,`Bmax` | bornes de profondeur/branches de l'arbre de Beth | 5,7 | entiers |
| `w_f`,`w_t` | poids formel/tacite (`w_f+w_t=1`) | 5,7 | [0,1] |

### Note de cohérence (à harmoniser)
- ⚠️ **Casse** : `Foundationality` (docs 4-5) et `foundationality` (champ Zod, docs 6-7) désignent **la même grandeur** — la majuscule = concept, la minuscule = champ de données. Convention adoptée : **Concept = Majuscule, champ/variable = minuscule.** Aucun conflit sémantique.
- ✅ `root_depth` apparaît à la fois comme moteur de pollination (doc 3) ET comme proxy tacite (doc 5) — **usage cohérent** (même grandeur topologique, deux usages).
- ✅ `feasibility` est l'unique point d'injection de `Foundationality` dans la viabilité — **un seul couplage, pas de double comptage.**

---

## 4. Invariants de conception (à ne jamais violer)

1. **First-Principles, pas analogie** : l'émergence naît de la décomposition au tronc + blending depuis invariants. L'analogie (improvements répliquables) est **bannie** comme générateur.
2. **Émergence endogène** : générée depuis le **seul savoir privé**. Internet = contextualisation/validation, jamais source de créativité.
3. **Beth = score, pas verrou** : `Foundationality` module la confiance, ne barre pas le pipeline (le blocage = rôle d'AG13).
4. **Transparence du score hybride** : formel (prouvé) et tacite (estimé) **toujours affichés séparément**.
5. **Aucune invention** : ni concept central, ni premier principe absent du tronc, ni axiome sans traces.
6. **Traçabilité triple** : PROV (`wasDerivedFrom`) + bitemporel (event/ingestion) + arbre de preuve Beth = **preuve non-copiable**.

---

## 5. Questions ouvertes consolidées (transverses)

| # | Question | Doc(s) concerné(s) | Statut |
|---|---|---|---|
| Q1 | Source des règles de Horn `P1..P6` : figées DomainPack ou apprises ? | 5,6 | ouverte |
| Q2 | Calibration `w_f/w_t` : fixe ou fonction de la part formalisée ? | 5,7 | ouverte |
| Q3 | Valeurs par défaut `Dmax/Bmax` + dégradation gracieuse | 5,7 | ouverte |
| Q4 | Runtime AG16 : **tranché** = async + cache par tronc, granularité Living Node | 7 | ✅ décidé |
| Q5 | Calibration `γ` du `PlantScore` (poids viability/fecundity) | 3 | ouverte |
| Q6 | Politique d'affichage `undecided_in_budget` côté investisseur | 6,7 | partiellement décidé (statut neutre) |

---

## 6. Verdict de la passe de cohérence

✅ **Notations** : concordantes (un seul glossaire fait foi, §3).
✅ **Scores** : la chaîne `Foundationality → feasibility → Viability → PlantScore` est cohérente, un seul point d'injection (pas de double comptage).
✅ **Flux** : le pipeline de bout en bout (§2) relie pollination → décomposition → preuve Beth → blending → seed sans rupture.
✅ **Invariants** : les 6 invariants de conception sont respectés dans les 7 docs.
⚠️ **À harmoniser** (cosmétique, non bloquant) : casse `Foundationality`/`foundationality` (convention §3 adoptée).

---

*Document de consolidation. Aucun code.*
*Couvre : docs génératifs 1-3, trilogie Beth 4-6, spec agent AG16 (7).*

# SCYForge — Couplage du Validateur de Tronc (Beth) avec le pipeline ASCENT

> **Statut** : architecture. **Aucun code.**
> **But** : décider QUEL agent ASCENT porte le Beth Trunk Validator (BTV), définir son contrat d'I/O,
> son déclenchement dans le pipeline, et son interaction avec les agents existants.
> **Décisions amont** : BTV = preuve `T ⊢ K` par Arbres de Beth (`SCYFORGE_BETH_TRUNK_VALIDATOR.md`) ;
> représentation Datalog-like + score **hybride** formel/tacite (`SCYFORGE_BETH_LOGICAL_REPRESENTATION_CYBER.md`).
> **Sortie BTV = score de fondationnalité ∈ [0,1], NON bloquant.**

---

## 1. Le test de placement : à quel agent appartient le BTV ?

On compare la **nature de l'opération** du BTV avec les deux candidats existants (specs réelles du repo).

| Critère | AG15 AXIOMATIZER | AG13 COGNITIVE-VALIDATOR | **Beth Trunk Validator** |
|---|---|---|---|
| Type de raisonnement | **Induction** (traces → axiome) | Vérification multi-couches | **Déduction** (`T ⊢ K`, tableaux Beth) |
| Entrée | `scy_procedural_traces` (réussites) | contenu généré (NEURON-CHAINS, ARENA) | tronc candidat `T` + connaissance `K` |
| Sortie | 1 axiome distillé (purge micro-règles) | verdict `valid/revise/reject` + score conf. | **score fondationnalité [0,1]** + branches ouvertes |
| Bloquant ? | non (async, arrière-plan) | **OUI** (gate de qualité bloquante) | **NON** (score, module la confiance) |
| Exécution | asynchrone serveur (Rust/Tokio) | gate synchrone dans le workflow | à la décomposition/avant blending |
| Rôle de l'axiome | **produit** des axiomes | n.a. | **consomme** des axiomes/principes comme prémisses `T` |

### Lecture
- **AXIOMATIZER** *fournit la matière* (les axiomes/principes) mais ne **prouve** aucune dérivation — il abstrait, il ne déduit pas. Il **produit** ce que le BTV **consomme**.
- **COGNITIVE-VALIDATOR** valide et **bloque** ; or le BTV est explicitement **non bloquant** (score). Coller le BTV dans une gate bloquante trahirait ta décision (« score, pas verrou »).

**Conclusion** : le BTV n'est exactement *aucun* des deux. Mais il est en **dépendance forte avec l'AXIOMATIZER** (même registre : les axiomes/premiers principes) et en **complémentarité** avec le COGNITIVE-VALIDATOR.

---

## 2. Recommandation : un agent dédié **AG16 — TRUNK-VALIDATOR**, couplé à AG15

> Plutôt que de surcharger l'AXIOMATIZER (induction async, GDPR, purge) avec une logique de **preuve déductive** synchrone et non bloquante, on isole le BTV dans son **propre agent**, branché en aval de l'AXIOMATIZER.

```
  ┌──────────────┐  axiomes/principes   ┌────────────────────┐   score fond.   ┌──────────────────┐
  │ AG15         │ ───────────────────▶ │ AG16               │ ──────────────▶ │ Moteur génératif │
  │ AXIOMATIZER  │   (le tronc T)       │ TRUNK-VALIDATOR    │   ∈ [0,1]       │ (Blending/Seed)  │
  │ (induction)  │                      │ (Beth — déduction) │                 │                  │
  └──────────────┘                      └────────────────────┘                 └──────────────────┘
                                                  │ branches ouvertes
                                                  ▼
                                        diagnostic : principes manquants
```

### Pourquoi un agent dédié (et pas une extension)
| Argument | Détail |
|---|---|
| **Séparation des régimes logiques** | induction (AG15) ≠ déduction (AG16) ≠ vérification anti-hallucination (AG13). Un agent = un régime. |
| **Non-bloquant préservé** | AG16 émet un **score**, jamais un verdict de gate. Ne pas le noyer dans une gate bloquante (AG13). |
| **AG15 reste async/GDPR pur** | l'AXIOMATIZER a des contraintes lourdes (k-anonymat, purge). Y greffer un moteur de tableaux Beth synchrone polluerait sa frontière. |
| **Réutilisabilité plugin** | le BTV est une **infrastructure** (COSMOS-plugin friendly) : tout DomainPack (cyber, santé…) l'appelle. Un agent dédié = point d'entrée propre. |
| **Traçabilité** | le score Beth mérite son propre journal (`scy_agent_decisions`) avec l'arbre de preuve attaché. |

> **Alternative considérée et écartée** : extension d'AG15. Écartée car mélange induction/déduction et menace la frontière GDPR/async de l'AXIOMATIZER. **Alternative écartée** : extension d'AG13, car le BTV n'est pas une gate bloquante.

---

## 3. Contrat de l'AG16 — TRUNK-VALIDATOR

### 3.1 Purpose (proposé)
Prouver, par **Arbres de Beth**, que la connaissance `K` d'un sous-arbre est **dérivable** d'un tronc candidat `T` (premiers principes), et émettre un **score de fondationnalité hybride ∈ [0,1]** (non bloquant) accompagné du **diagnostic des branches ouvertes** (premiers principes manquants).

### 3.2 Entrées
```
  T : ensemble de premiers principes candidats   (depuis AG15 + DomainPack contract)
  K : connaissance du sous-arbre                  (Living Node / semantic tree)
  budget : { Dmax, Bmax }                         (bornes anti semi-décidabilité)
  weights : { w_f, w_t }                          (partition formel/tacite, cf. score hybride)
```

### 3.3 Sorties (Zod-validable, comme les autres agents)
```
  foundationality : float ∈ [0,1]
  breakdown : {
     formal  : { derivability, irreducibility, consistency },
     tacit   : { root_depth, feynman_pass, sop_grounding, coverage }
  }
  open_branches : [ { missing_principle, affected_knowledge } ]   ← diagnostic
  proof_status  : per-k ∈ { proven | open | undecided_in_budget }
  proof_tree_ref : pointeur vers l'arbre de Beth journalisé (audit)
```

### 3.4 Déclenchement dans le pipeline génératif
```
  Décomposition (remontée au tronc)
      → AG16 TRUNK-VALIDATOR  (prouve T ⊢ K, score)
          → si score haut : BLENDING depuis l'invariant → SEED (porte le score)
          → si branches ouvertes : feedback → AG15 (enrichir le tronc) OU marquer K_tacite
```
> Le score **module** `feasibility` de la Seed (cf. BTV §4.1). Une graine née d'un tronc à
> `foundationality` faible est marquée « fondation faible » — **pas interdite**, juste pondérée.

---

## 4. Interactions avec les agents existants (qui parle à qui)

| Agent | Relation avec AG16 | Sens |
|---|---|---|
| **AG15 AXIOMATIZER** | fournit les axiomes/principes du tronc ; reçoit le diagnostic des branches ouvertes | bidirectionnel |
| **AG13 COGNITIVE-VALIDATOR** | complémentaire : AG13 valide la *vérité source* du contenu ; AG16 prouve la *dérivabilité logique* du tronc. Pas de chevauchement. | parallèle |
| **AG03 DAG-ARCHITECT** | fournit la topologie (sous-arbre, LCA `root_depth`) utile au score tacite | amont |
| **AG09 SKILL-CERTIFIER** | peut citer la fondationnalité d'un tronc comme **preuve** dans une certification | aval |
| **AG10 CHRONICLE** | journalise l'arbre de preuve + score (audit, provenance) | aval |

> **Démarcation nette AG13 vs AG16** (anti-confusion) :
> - AG13 répond : *« cette assertion est-elle vraie/traçable à une source ? »* (anti-hallucination, **bloquant**).
> - AG16 répond : *« cette connaissance se déduit-elle des premiers principes retenus ? »* (fondationnalité, **score**).
> Les deux sont nécessaires : une assertion peut être *vraie* (AG13 ok) mais *non fondée sur le tronc* (AG16 score bas) → signal qu'il manque un premier principe.

---

## 5. Ce que ce couplage N'EST PAS
- ❌ Pas une gate bloquante de plus (le score ne barre pas la route).
- ❌ Pas un doublon de l'AXIOMATIZER (induction) ni du COGNITIVE-VALIDATOR (vérité source).
- ❌ Pas un moteur de détection cyber.
- ✅ Un **agent de preuve déductive** qui transforme « je crois que c'est le tronc » en « c'est **prouvé** dérivable jusqu'aux atomes ».

---

## 6. Questions ouvertes (avant ingénierie)
1. **Numérotation** : ✅ **AG16 est libre** (vérifié : le repo contient ag14, ag15, ag17, ag18 — il y a bien un trou à 16). `TRUNK-VALIDATOR` prend donc le slot **AG16** sans collision.
2. **Synchrone vs async** : le BTV bloque-t-il le blending (synchrone) ou tourne-t-il en pré-calcul (async, score mis en cache par tronc) ?
3. **Granularité du déclenchement** : par sous-arbre, par Living Node, ou à la demande du moteur génératif ?
4. **Politique sur `undecided_in_budget`** : comment l'afficher au fondateur/investisseur sans donner l'impression d'un échec ?

---

*Document d'architecture. Aucun code.*
*Specs sources réelles : `minddoc/s03_ascent_pipeline_agents/ag15_axiomatizer/`, `ag13_cognitive_validator/`.*
*Réf. internes : `SCYFORGE_BETH_TRUNK_VALIDATOR.md`, `SCYFORGE_BETH_LOGICAL_REPRESENTATION_CYBER.md`, `SCYFORGE_GENERATIVE_ENGINE_MATH_FORMALIZATION.md`.*
*Fondation Beth : [Evert Willem Beth](https://en.wikipedia.org/wiki/Evert_Willem_Beth), [Méthode des tableaux](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_tableaux).*

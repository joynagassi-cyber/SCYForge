# SCYForge — Le Validateur de Tronc par les Arbres de Beth

> **Statut** : architecture du Validateur de Tronc. **Aucun code.**
> **Origine du concept (fondateur)** : *« Nous allons utiliser le validateur de tronc : le principe
> des Arbres de Beth, avec sa logique pour démontrer une formule complexe. Nous allons l'utiliser pour
> prouver que [le tronc] est fondateur, et que sur cette base nous pouvons créer et innover. »*
> **Usage retenu** : **prouver que la connaissance complète est dérivable des premiers principes
> retenus** (le tronc engendre bien tout le reste). **Sortie = score de fondationnalité ∈ [0,1]**
> (pas un verrou bloquant).

---

## 0. Ce que sont vraiment les Arbres de Beth (fondation réelle, pas inventée)

Les **Arbres de Beth** (*semantic tableaux*) sont une méthode de **théorie de la démonstration** inventée par le logicien néerlandais **Evert Willem Beth** (1908–1964) [5](https://en.wikipedia.org/wiki/Evert_Willem_Beth).

Principe de la méthode (preuve par réfutation) :
1. Pour prouver qu'un ensemble de prémisses **Γ** implique une formule **φ**, on suppose la vérité simultanée de tout Γ **et de ¬φ** (la négation de la conclusion) [5](https://en.wikipedia.org/wiki/Evert_Willem_Beth).
2. On applique des règles de **décomposition** sur chaque connecteur logique, ce qui **ramifie** la liste en une structure arborescente de formules de plus en plus simples [1](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_tableaux).
3. On s'arrête *« lorsque seuls les atomes (ou leur négation) restent »* [3](https://helios2.mi.parisdescartes.fr/~gk/NumLog/CM/NL_CM10.pdf).
4. Si **toute branche aboutit à une contradiction**, chaque branche est **fermée** → Γ ∪ {¬φ} est inconsistant → donc **Γ implique φ**. La formule est **prouvée** [1](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_tableaux), [5](https://en.wikipedia.org/wiki/Evert_Willem_Beth).

> **Pourquoi c'est l'outil exact dont SCYForge a besoin** : la méthode de Beth **décompose jusqu'aux atomes irréductibles** — c'est *littéralement* la mécanique des **premiers principes** (descendre jusqu'à la brique insécable, cf. méthode Musk dans tes uploads : *« Réduction aux particules élémentaires »*, *« Élimination des scories »*, *« Synthèse du tronc »*). Beth donne la **rigueur de preuve** qui manquait au mécanisme de décomposition (§5.2 du doc de formalisation).

---

## 1. Le problème que le Validateur résout

Dans le moteur génératif, on **décompose** une connaissance jusqu'à son tronc (premiers principes), puis on **reconstruit** (blending depuis l'invariant) pour faire naître une **graine**. Mais un risque demeure (déjà signalé comme défi ouvert) :

> **Comment garantir qu'on a touché un vrai premier principe, et pas une couche intermédiaire ?**

Sans garantie, on reconstruit depuis un faux fondement → la graine est fragile. Le **Validateur de Tronc** apporte la **preuve formelle** que le tronc retenu est bien fondateur.

---

## 2. Définition : le Beth Trunk Validator (BTV)

Le **BTV** prend un ensemble candidat de premiers principes **T = {p₁, …, pₙ}** (le tronc proposé) et la connaissance complète **K** (toutes les feuilles/branches du sous-arbre), et **prouve par Arbres de Beth** que **T ⊢ K** (T engendre K).

```
   Entrée :  T = {p₁…pₙ}  (tronc candidat = premiers principes)
             K = {k₁…kₘ}  (la connaissance à expliquer = feuilles/branches)
   Sortie :  Foundationality(T, K) ∈ [0,1]   (score de fondationnalité)
```

### 2.1 La question logique posée à Beth
Pour chaque élément de connaissance `kⱼ`, on demande à l'Arbre de Beth :
```
   T ⊢ kⱼ  ?      (les premiers principes impliquent-ils kⱼ ?)
```
Méthode Beth : on suppose `T ∧ ¬kⱼ`, on décompose, et si **toutes les branches se ferment** (contradiction partout) → **`kⱼ` est dérivable du tronc**. Sinon, une branche **reste ouverte** → `kⱼ` **n'est PAS** dérivable de T (le tronc est incomplet pour expliquer cette connaissance).

### 2.2 Interprétation des branches ouvertes (le diagnostic)
| Résultat Beth | Signification | Action |
|---|---|---|
| toutes branches fermées | `kⱼ` est **engendré** par le tronc | ✅ le tronc explique cette connaissance |
| branche ouverte | `kⱼ` **échappe** au tronc | ⚠️ il manque un premier principe, OU `kⱼ` n'appartient pas à ce tronc |

> Une branche ouverte est **un cadeau** : elle pointe **exactement** le premier principe manquant. Le Validateur ne dit pas seulement « oui/non » — il dit **où** le tronc est incomplet.

---

## 3. Le score de fondationnalité (réponse à ton choix : score, pas verrou)

```
   Foundationality(T, K) = Derivability(T,K) · Irreducibility(T) · Consistency(T)
```

Produit de **trois preuves Beth** (un facteur nul ⇒ tronc non fondateur) :

| Facteur | Question | Preuve Beth | Mesure |
|---|---|---|---|
| **Derivability** | T engendre-t-il toute la connaissance K ? | `T ⊢ kⱼ` pour chaque j | proportion de `kⱼ` aux branches **fermées** |
| **Irreducibility** | chaque `pᵢ` est-il atomique (insécable) ? | tenter de dériver `pᵢ` des autres `p` ; **doit échouer** | proportion de `pᵢ` **non dérivables** des autres |
| **Consistency** | les principes du tronc sont-ils non-contradictoires ? | l'arbre de `T` ne doit PAS se fermer tout seul | 1 si T cohérent, 0 si T contient une contradiction |

### 3.1 Pourquoi ces trois (et pas un seul)
- **Derivability seul** : un tronc pourrait tout engendrer mais contenir des principes redondants (pas vraiment premiers).
- **Irreducibility** garantit que chaque `pᵢ` est bien une **brique élémentaire** (sinon c'est une couche intermédiaire — exactement le risque qu'on veut éliminer). *« Ne gardez que le vrai au niveau fondamental »* (tes uploads).
- **Consistency** garantit qu'on ne reconstruit pas depuis un tronc auto-contradictoire (sinon tout est dérivable trivialement — explosion logique).

### 3.2 Lecture du score
- `Foundationality → 1` : tronc **prouvé fondateur** → base solide pour créer/innover.
- `Foundationality bas` : le tronc est incomplet, redondant ou incohérent → on **redescend** (on cherche les principes manquants signalés par les branches ouvertes).

> **Score, pas verrou** : on n'**interdit** pas de continuer sous un seuil. Le score **module** la confiance dans les graines qui en découlent (une graine issue d'un tronc à `Foundationality=0.4` est marquée « fondation faible »).

---

## 4. Branchement au pipeline génératif

```
   CONNAISSANCE (Living Node / sous-arbre)
        │
   DÉCOMPOSITION par premiers principes (remontée au tronc)
        │
   ┌──────────────── BETH TRUNK VALIDATOR ────────────────┐
   │  prouve T ⊢ K  (dérivabilité)                          │
   │  prouve irréductibilité de chaque pᵢ                   │
   │  prouve cohérence de T                                 │
   │  → Foundationality(T,K) ∈ [0,1]                        │
   └───────────────────────────────────────────────────────┘
        │
   tronc PROUVÉ fondateur (score attaché)
        │
   BLENDING DEPUIS LE TRONC (création depuis l'invariant)
        │
   SEED  (porte le score de fondationnalité de son tronc d'origine)
```

### 4.1 Effet sur la viabilité de la graine
Le score de fondationnalité **alimente** la fonction de viabilité (doc de formalisation §3) :
```
   feasibility(s)  ←  pondéré par Foundationality du tronc d'origine
```
> Une graine bâtie sur un tronc **prouvé** (`Foundationality` haut) est **plus viable** : elle repose sur des fondations démontrées, pas supposées. C'est ce qui rend la décision *« qui ne peut être ignorée »* — elle est **prouvable jusqu'à ses axiomes**.

---

## 5. Pourquoi c'est un différenciateur (et pas une coquetterie logique)

| | Les autres outils | SCYForge + Beth Trunk Validator |
|---|---|---|
| Fondation d'une idée | implicite, supposée | **prouvée par tableaux sémantiques** |
| « Pourquoi y croire ? » | « l'IA l'a dit » | « c'est **dérivable** de vos premiers principes » |
| Robustesse | fragile (couche intermédiaire) | **atomicité prouvée** (irréductibilité) |
| Auditabilité | opaque | **chaque branche de l'arbre est traçable** |

> Beth donne à SCYForge une **chaîne de preuve formelle** de la fondation à la création. Couplé à la provenance (W3C PROV) et au bitemporel, une graine devient : *née de tel croisement (PROV), à telle date (bitemporel), depuis un tronc prouvé fondateur (Beth)*. **Triple preuve. Incontestable. Non-copiable.**

---

## 6. Limites honnêtes & subtilités

- **Décidabilité** : les Arbres de Beth sont une procédure de décision **effective pour le calcul propositionnel**, mais seulement **semi-effective pour la logique du premier ordre** (indécidable, théorème de Church) [5](https://en.wikipedia.org/wiki/Evert_Willem_Beth). → Pour le savoir d'entreprise (riche, du premier ordre), le BTV donne une **preuve quand elle se termine**, et un **score partiel/borné en temps** sinon. On assume cette limite (on borne la profondeur de l'arbre).
- **Formalisation du savoir** : appliquer Beth exige de représenter la connaissance en **formules logiques**. Tout le savoir d'entreprise n'est pas trivialement formalisable. → Le BTV s'applique au **noyau formalisable** du tronc ; le reste reçoit un score heuristique. **Sujet d'ingénierie à approfondir.**
- **Ce n'est pas magique** : Beth prouve la **dérivabilité logique**, pas la **vérité empirique** des axiomes. Le tronc doit toujours être ancré sur des principes réels (physique pour l'ingénierie, flux de trésorerie + psychologie pour le business — cf. tes uploads).

---

## 7. Questions ouvertes (avant ingénierie/code)

1. **Représentation logique** : sous quelle forme formalise-t-on les premiers principes d'un tronc cyber (logique propositionnelle ? premier ordre borné ? règles type Datalog) ?
2. **Borne de profondeur** : quelle profondeur max d'arbre de Beth avant de basculer sur un score partiel ?
3. **Couplage avec ASCENT** : quel agent porte le BTV (un nouvel agent « Trunk Validator » ou une extension de COGNITIVE-VALIDATOR / AXIOMATIZER déjà présents) ?
4. **Score heuristique** : pour la part non formalisable, quelle heuristique de fondationnalité (profondeur LCA `root_depth` ? test Feynman automatisé ?) ?

---

*Document d'architecture. Aucun code.*
*Fondation réelle : Arbres de Beth / tableaux sémantiques, Evert Willem Beth [5](https://en.wikipedia.org/wiki/Evert_Willem_Beth), [1](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_tableaux), [2](https://studylibfr.com/doc/2034000/arbres-de-beth-arbres-de-beth-pour-la-conjonction), [3](https://helios2.mi.parisdescartes.fr/~gk/NumLog/CM/NL_CM10.pdf).*
*Ancrage premiers principes : uploads fondateur (Protocole Arbre Sémantique, Maîtrise Radicale — méthode Musk : réduction → élimination des scories → synthèse du tronc).*
*Réf. internes : `SCYFORGE_GENERATIVE_ENGINE_MATH_FORMALIZATION.md` (§5 décomposition premiers principes), `SCYFORGE_GENERATIVE_ENGINE_LOGICAL_MODEL.md`.*

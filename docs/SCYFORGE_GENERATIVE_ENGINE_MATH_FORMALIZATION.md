# SCYForge — Formalisation Mathématique du Moteur Génératif

> **Statut** : formalisation mathématique / d'ingénierie. **Aucun code.** Suite de
> `SCYFORGE_GENERATIVE_ENGINE_LOGICAL_MODEL.md`.
> **Couvre les 5 questions ouvertes** : (1) métrique de distance, (2) seuils, (3) fonction de
> viabilité, (4) encodage du Vision Helm, (5) **mécanisme d'émergence endogène** — le cœur du 0→1.
>
> **⚠️ CORRECTION FONDATEUR (décision structurante)** :
> *« Je ne veux PAS de principe analogique, mais du principe Semantic Tree. L'analogie crée des
> améliorations progressives réplicables ; le First-Principles Thinking fait naître des graines. »*
> → Le mécanisme d'émergence (§5) **n'est PAS de l'analogie** (Gentner/SME : retiré, car réplicable).
> Il est fondé sur le **First-Principles Thinking via le Semantic Tree** : décomposer jusqu'au tronc
> (l'invariant irréductible) puis **reconstruire depuis les fondations**. Le **Blending** est conservé,
> mais ancré sur les **premiers principes** — pas sur des surfaces analogues. La prédiction de liens
> latents est **retirée** (elle ré-exploite l'existant, pas le tronc).

---

## 0. Notation de base

- STB = arbre sémantique ; un nœud `n` a : un embedding sémantique `e(n) ∈ ℝᵈ`, une position structurelle dans l'arbre, un Rootstock, une maturité `SMI(n) ∈ [0,1]`.
- `G = (V, E)` : le knowledge graph sous-jacent (lianes incluses).
- `H` : le Vision Helm (défini §4).
- Une Seed `s` naît d'une paire `(A, B)`.

---

## 1. MÉTRIQUE DE DISTANCE `distance(A,B)` — **HYBRIDE** (réponse Q1)

### 1.1 Décision : hybride sémantique × structurelle (ni l'un ni l'autre seul)
- **Sémantique seule** (embeddings) : capte le « sens proche », mais ignore la *position dans le savoir* → rate la profondeur de fondation.
- **Structurelle seule** (chemin dans l'arbre) : capte la topologie, mais deux nœuds proches dans l'arbre peuvent être sémantiquement sans rapport.
- **Hybride** = la seule option fidèle au principe Semantic Tree : on mesure à la fois l'éloignement de sens **et** la profondeur de tronc partagée.

### 1.2 Les trois composantes (toutes ancrées sur l'ARBRE, pas sur l'analogie)
```
   d_sem(A,B)    = 1 − cos( e(A), e(B) )             // distance sémantique (embeddings)
   d_struct(A,B) = chemin_normalisé(A,B) dans le STB  // éloignement topologique
   root_depth(A,B) = profondeur du tronc commun (LCA) // ★ premiers principes partagés
```

`root_depth` (Lowest Common Ancestor dans l'arbre) est la pièce maîtresse : il mesure **jusqu'à quelle fondation commune** il faut remonter pour que A et B se rejoignent. Deux nœuds qui ne se rejoignent qu'au **tronc** (LCA très bas) partagent un **premier principe** profond — c'est là que naît une graine, pas une variation.

### 1.3 Distance hybride et "potentiel de croisement"
```
   D(A,B) = α · d_sem(A,B) + β · d_struct(A,B)        (α + β = 1)
```
On définit le **potentiel de pollination** comme distance de surface élevée mais **tronc commun profond** :
```
   Π(A,B) = D(A,B) · root_depth(A,B)
```
> **Lecture clé (principe Semantic Tree, PAS analogie)** : un bon croisement = **distance de surface élevée** (A et B semblent sans rapport) **ET** `root_depth` élevé (ils partagent un **premier principe** au niveau du tronc). On ne cherche pas « A ressemble à B » (analogie → réplicable) ; on cherche « A et B descendent du même invariant fondamental » (premiers principes → génératif).

→ `Π` maximal dans la **zone féconde** : éloignés en surface, **unis à la racine**.

---

## 2. SEUILS `θ_min, θ_max, τ` — **HYBRIDE expert→appris** (réponse Q2)

### 2.1 Décision : seuils **amorcés par expert, puis appris par secteur**
Ni « tout expert » (rigide, ne s'améliore pas), ni « tout appris » (cold-start impossible sans données). Approche en 2 temps :

| Phase | Source des seuils | Pourquoi |
|---|---|---|
| **Bootstrap (M0)** | fixés par expert du secteur | pas encore de données ; on démarre sur du jugement métier |
| **Calibration (continu)** | appris par feedback (graines qui ont germé vs stériles) | les seuils convergent vers ce qui marche *dans ce secteur* |

### 2.2 Apprentissage des seuils
- Chaque graine reçoit un **label a posteriori** : a-t-elle germé (succès) ou non (stérile) ?
- On ajuste `θ_min, θ_max` pour **maximiser** la proportion de graines fécondes (zone féconde calibrée par les résultats réels).
- `τ` (température exploration/dirigé) reste **piloté par plugin + utilisateur** (cyber bas, R&D haut), mais sa valeur par défaut est elle aussi affinée par feedback.
- Méthode d'ancrage temporel : **time-slicing** — on entraîne sur le passé, on valide sur le futur (les liens devenus vrais ensuite). C'est la méthodologie standard de la Literature-Based Discovery [1](https://www.sciencedirect.com/science/article/pii/S1532046423001855), [5](https://link.springer.com/article/10.1007/s10462-024-10885-1).

> **Conséquence moat** : les seuils calibrés sur l'historique d'une entreprise sont **spécifiques à elle** → non transférables → encore du temps non-copiable.

---

## 3. FONCTION DE VIABILITÉ — forme exacte (réponse Q3)

### 3.1 Viability (germera-t-elle ?)
Produit de 4 facteurs normalisés dans `[0,1]` (un facteur nul ⇒ graine stérile) :
```
   Viability(s) = feasibility(s) · alignment(s) · non_redundancy(s) · resource_fit(s)
```

| Facteur | Définition | Mesure proposée |
|---|---|---|
| `feasibility` | la graine est-elle réalisable ? | faisabilité technique/logique (contraintes du domaine) |
| `alignment` | sert-elle la vision ? | `align(s, H)` vs Vision Helm (§4) |
| `non_redundancy` | est-elle vraiment nouvelle ? | `1 − max_sim(s, graines/liens existants)` |
| `resource_fit` | l'entreprise peut-elle la porter ? | adéquation aux moyens (temps, compétences, budget) |

> **Choix du produit (et non somme)** : un produit impose que **chaque** facteur soit non nul. Une graine infaisable (`feasibility=0`) ou non alignée (`alignment=0`) ou déjà connue (`non_redundancy=0`) est **stérile par construction** — c'est le comportement voulu.

### 3.2 Fecundity (combien d'arbres peut-elle engendrer ?)
```
   Fecundity(s) = potential_subtrees(s) · strategic_reach(s)
```
- `potential_subtrees` : nombre estimé de sous-arbres/dérivés que la graine peut générer.
- `strategic_reach` : portée (locale = une amélioration ; structurelle = une nouvelle ligne métier).

### 3.3 Score de priorité de plantation
```
   PlantScore(s) = Viability(s)^γ · Fecundity(s)^(1−γ)
```
- `γ ∈ [0,1]` : curseur prudence/ambition. `γ→1` privilégie le sûr (cyber) ; `γ→0` privilégie l'ambitieux (R&D).
- On plante d'abord les graines à `PlantScore` maximal. Les `DORMANT` (viability < seuil) sont conservées (réveil bitemporel possible).

---

## 4. ENCODAGE DU VISION HELM — **LES DEUX** (vecteur + graphe) (réponse Q4)

### 4.1 Décision : double encodage, deux usages
| Encodage | Forme | Usage |
|---|---|---|
| **Vecteur pondéré** `h ∈ ℝᵏ` | k axes stratégiques pondérés | calcul rapide d'`align()` (filtre temps-réel des graines) |
| **Graphe d'objectifs** `G_H` | objectifs → sous-objectifs → KPIs, avec dépendances | raisonnement, traçabilité « cette graine sert quel objectif ? », explicabilité manager |

> Le **vecteur** sert à *calculer* (vitesse). Le **graphe** sert à *expliquer et gouverner* (sens). Les deux sont **dérivés l'un de l'autre** (le vecteur = projection pondérée du graphe).

### 4.2 Fonction d'alignement
```
   align(x, H) = cos( proj(x), h )      ∈ [−1, 1]  →  renormalisé [0,1]
```
- `proj(x)` = projection d'une connaissance/graine sur les axes de vision.
- `align < 0` ⇒ la graine va *contre* la vision (rejetée ou signalée).

### 4.3 Le Helm gouverne tout (téléologie)
- **Arborization** : pénalise les racines mal alignées.
- **Pollination** : condition L4 = `align(s,H) ≥ τ_H`.
- **ASCENT/recrues** : priorise les branches à fort `align`.
- **COSMOS** : met en avant les vues à fort enjeu stratégique.
- **Bitemporel** : `H` est versionné (la vision évolue ; on garde l'historique des Helms).

---

## 5. ÉMERGENCE ENDOGÈNE — le cœur du 0→1 (réponse Q5)

> Exigence fondateur : faire **émerger des graines nouvelles SANS Internet**, à partir du **seul savoir privé** de l'entreprise, **par premiers principes (Semantic Tree)** et **non par analogie**. Internet (Research Agent) reste un **appoint de validation**, jamais la source.

### 5.0 Pourquoi PAS l'analogie (la frontière qui change tout)

| | **Analogie** (rejetée) | **First-Principles via Semantic Tree** (retenu) |
|---|---|---|
| Logique | « A ressemble à B → applique à A ce qui marche pour B » | « décompose A jusqu'au tronc, reconstruis depuis l'invariant » |
| Produit | amélioration **progressive, réplicable** | **graine** : structure neuve depuis les fondations |
| Dépendance | prisonnière de l'existant (copie-adapte) | libérée de l'existant (reconstruit) |
| Sortie | un greffon de plus | un **nouvel arbre en puissance** |

> **Le mot d'ordre** : on ne cherche pas la *ressemblance* (analogie), on cherche le *fondement commun* (premiers principes). La graine naît quand on **remonte au tronc partagé** de deux choses qui semblaient sans rapport, puis qu'on **reconstruit** depuis ce tronc.

### 5.1 Le mécanisme : 2 moteurs (First-Principles + Blending)

```
   ┌─────────────────────────────────────────────────────────────────┐
   │  ① DÉCOMPOSITION PAR PREMIERS PRINCIPES (Semantic Tree)          │
   │     descend A et B jusqu'à leur TRONC / invariant irréductible   │
   │     (Rootstock). On ne garde QUE les premiers principes.         │
   │     "Pourquoi cela est vrai ?" jusqu'à ce qu'on ne puisse plus   │
   │     décomposer → on touche le sol (axiomes du domaine).          │
   ├─────────────────────────────────────────────────────────────────┤
   │  ② BLENDING DEPUIS LE TRONC (Fauconnier-Turner, 4 espaces)       │
   │     fusionne les INVARIANTS de A et de B (pas leurs surfaces)    │
   │     → un ESPACE BLEND avec une STRUCTURE ÉMERGENTE reconstruite  │
   │     depuis les fondations = la Seed.                             │
   └─────────────────────────────────────────────────────────────────┘
```

### 5.2 ① Décomposition par premiers principes (le principe Semantic Tree)
- **Mécanisme** : pour tout nœud, on **remonte l'arbre** (de la feuille vers le tronc) en posant récursivement *« pourquoi est-ce vrai / nécessaire ? »* jusqu'à atteindre un **invariant irréductible** (le Rootstock, un axiome du domaine).
- **Ce qu'on obtient** : la connaissance **dépouillée de tout ce qui est contingent/réplicable**. Il ne reste que les briques fondamentales.
- **Pourquoi c'est génératif (pas réplicable)** : en repartant du sol, on n'est **plus contraint** par la forme actuelle de la solution. On peut reconstruire **autrement** → nouveauté réelle, pas variation.
- **Exemple cyber** : ne pas demander « cette nouvelle attaque ressemble à quelle attaque connue ? » (analogie → règle dérivée banale). Mais : « quel est l'**invariant** que toute attaque de ce type doit violer pour réussir ? » → on reconstruit une **posture de défense fondamentale** qui couvre des variantes encore non vues. **Ça, c'est une graine.**

> **`root_depth` (§1) opérationnalise ce mécanisme** : plus le tronc commun de A et B est profond, plus la décomposition par premiers principes est puissante.

### 5.3 ② Blending depuis le tronc (Fauconnier-Turner, ancré premiers principes)
- 4 espaces : 2 inputs, 1 generic, 1 **blend** où apparaît une **structure émergente** absente des inputs [4](https://en.wikipedia.org/wiki/Conceptual_blending).
- **Différence cruciale vs l'usage standard du blending** : les inputs ne sont **pas** les concepts de surface, mais leurs **invariants décomposés** (sortie de ①). Le `generic space` n'est pas « ce qu'ils ont en commun en surface », c'est leur **tronc partagé** (root_depth).
- 3 opérations : **Composition** (relier les invariants), **Completion** (compléter avec le savoir de fond de l'entreprise), **Elaboration** (faire « tourner » le blend comme une simulation pour voir l'arbre qu'il engendre).
- Résultat : une **Seed** dont la Core Proposition est une structure **reconstruite depuis les fondations**, pas copiée.
- Boden : la créativité combinatoire **n'est pas aléatoire** — recherche guidée dans l'espace des combinaisons [3](https://staff.fnwi.uva.nl/b.bredeweg/pdf/BSc/20122013/Steinbruck.pdf). Ici, guidée par le **tronc**.

### 5.4 L'orchestration (le pipeline endogène, sans analogie)
```
   SAVOIR PRIVÉ (STB + KG bitemporel)
        │
   sélection de paires (A,B) à Π élevé : loin en surface, tronc commun profond
        │
   ① DÉCOMPOSITION → invariants de A et de B (remontée au Rootstock)
        │
   ② BLENDING DEPUIS LE TRONC → structure émergente reconstruite = Seed candidate
        │
   FILTRE : conditions L1–L4 + Viability + align(H)
        │
   SEED viable (endogène, depuis premiers principes, datée, prouvée) ──► germination
        │
   (optionnel) RESEARCH AGENT Internet → CONTEXTUALISE / valide nouveauté externe
```

> **La position SCYForge** : la graine est **générée en interne** par ①② sur le savoir privé, **par premiers principes**. Internet n'intervient qu'**après**, pour *contextualiser* — jamais pour *générer*. Innovation **endogène, fondamentale, non-copiable**.

### 5.5 Pourquoi c'est le vrai 0→1
- Les outils du marché font de la **récupération** (RAG), de l'**insight de surface**, ou au mieux de l'**analogie** (amélioration réplicable). **Aucun ne reconstruit depuis les premiers principes** d'un arbre sémantique privé.
- L'analogie produit du x1.5 (mieux que l'existant). Les **premiers principes** produisent du x10 (autre chose que l'existant) — c'est la distinction Thiel 0→1 que vise le fondateur.
- Le résultat (Seed) est **prouvable** (provenance W3C PROV + bitemporel) et **aligné** (Vision Helm) → décision *« qui ne peut être ignorée »*.

---

## 6. Vue d'ensemble : les objets mathématiques du GFE

| Objet | Formalisme | Rôle |
|---|---|---|
| `D(A,B)` | distance hybride pondérée | éloignement de surface |
| `root_depth(A,B)` | profondeur du tronc commun (LCA) | premiers principes partagés |
| `Π(A,B) = D · root_depth` | potentiel de pollination | sélection des paires |
| `θ_min, θ_max` | seuils calibrés (expert→appris) | zone féconde |
| `τ, γ` | curseurs (exploration, prudence) | dirigé vs ouvert |
| `Viability(s)` | produit de 4 facteurs | germera ? |
| `Fecundity(s)` | potentiel × portée | combien d'arbres ? |
| `H = (h, G_H)` | vecteur + graphe | gouvernail de vision |
| `align(x,H)` | cosinus projeté | téléologie |
| ①② | Décomposition premiers principes + Blending depuis le tronc | émergence endogène (PAS analogie) |

---

## 7. Limites honnêtes & prochaines étapes

- **Choix assumé** : on **écarte l'analogie** (Structure-Mapping / SME) malgré sa maturité scientifique, car elle produit du **réplicable** — contraire à la thèse 0→1 du fondateur. On garde le **Blending** uniquement parce qu'il peut opérer sur des **invariants décomposés** (premiers principes), pas sur des surfaces.
- **Défi de recherche ouvert** : formaliser rigoureusement la **décomposition par premiers principes** sur un arbre sémantique (jusqu'où descendre ? comment garantir qu'on touche un invariant et pas une couche intermédiaire ?). C'est le vrai sujet de fond à approfondir.
- **À calibrer empiriquement** : `α, β, γ, τ`, seuils — par secteur, via time-slicing.
- **Prochaine étape possible** : spécification d'ingénierie (représentation des Rootstocks/invariants, mécanique de remontée au tronc, blending depuis le tronc) — **toujours en amont du code**, à valider avec toi.

---

*Formalisation mathématique. Aucun code.*
*Mécanisme d'émergence = **First-Principles Thinking via Semantic Tree + Blending depuis le tronc** (PAS analogie).*
*Sources externes réelles : Conceptual Blending (Fauconnier-Turner) [4](https://en.wikipedia.org/wiki/Conceptual_blending), [3](https://staff.fnwi.uva.nl/b.bredeweg/pdf/BSc/20122013/Steinbruck.pdf) — conservé, ancré premiers principes ; Literature-Based Discovery / time-slicing [1](https://www.sciencedirect.com/science/article/pii/S1532046423001855), [5](https://link.springer.com/article/10.1007/s10462-024-10885-1) — gardé uniquement comme méthode de validation temporelle de nouveauté. Structure-Mapping / SME (analogie) **écarté** comme mécanisme génératif.*
*Réf. internes : `SCYFORGE_GENERATIVE_ENGINE_LOGICAL_MODEL.md`, `SCYFORGE_GENERATIVE_TREE_POLLINATION_SEED.md`.*

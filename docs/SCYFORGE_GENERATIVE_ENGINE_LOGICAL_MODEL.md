# SCYForge — Modélisation Logique du Moteur Génératif : Pollination, Seed, Viability, Vision Helm

> **Statut** : modélisation logique profonde. **Aucun code.** Suite de `SCYFORGE_GENERATIVE_TREE_POLLINATION_SEED.md`.
> **Décisions fondateur intégrées** :
> - Validité de graine = **potentiel de viabilité + fécondité** (à définir rigoureusement).
> - Dirigée vs ouverte = **à trancher** → proposition argumentée ici.
> - Vision = un **« gouvernail »** qui encapsule/encode la vision pour que recrues, arborisations et fonctionnalités y concourent.
> - Traçabilité de la graine = **recherche demandée** → proposition ancrée sur standards réels (ci-dessous).
> - Cross-pollination = **vision long terme**. En cyber : pollinisation **intra-domaine d'abord**, puis une **couche inter-domaine**, **intelligente et autonome** (pas statique), liée au système d'arborisation.

---

## 1. NOMENCLATURE ANGLAISE (les concepts officiels du système)

> Tu as demandé des noms anglais pour nommer les concepts. Voici la nomenclature canonique proposée. Le **lexique interne** doit être stable et anglais (code, API, docs investisseurs).

| Concept FR (travail) | **Nom anglais canonique** | Alias court | Définition |
|---|---|---|---|
| Arbre sémantique | **Semantic Tree** / **Knowledge Tree** | `STB` (Semantic Tree Base) | structure dirigée tronc→branches→feuilles |
| Arborisation | **Arborization** (verbe : *to arborize*) | `ARBOR` | transformer un graphe plat (KG) en arbre dirigé |
| Nœud vivant | **Living Node** | — | nœud = fondation + dérivés datés (mini-arbre) |
| Fondation du nœud | **Rootstock** | — | la racine immuable d'une connaissance |
| Dérivés datés | **Growth Rings** | — | anneaux de croissance horodatés |
| Pollinisation | **Pollination** (opérateur : *Pollinator*) | `POLL` | croisement fécondant entre branches éloignées |
| Pollinisation intra-domaine | **Self-Pollination** | — | croisement à l'intérieur d'un même STB sectoriel |
| Pollinisation inter-domaine | **Cross-Pollination** | `XPOLL` | croisement entre STB sectoriels différents |
| Graine | **Seed** | — | résultat génératif, contient un arbre en puissance |
| Viabilité de la graine | **Seed Viability** | — | probabilité qu'une graine germe en valeur réelle |
| Fécondité | **Fecundity** | — | potentiel génératif (combien d'arbres une graine peut produire) |
| Germination | **Germination** | — | déploiement d'une graine en nouveau sous-arbre |
| Gouvernail de vision | **Vision Helm** | `HELM` | encapsule la vision ; aligne tout le système |
| Moteur génératif global | **Generative Forest Engine** | `GFE` | l'ensemble : arborize → pollinate → seed → germinate |

> **Métaphore d'ensemble** : SCYForge n'est pas un arbre, c'est une **forêt générative** (`Generative Forest`) — des arbres (STB) qui se pollinisent et sèment de nouveaux arbres, gouvernés par un cap (Vision Helm).

---

## 2. MODÉLISATION LOGIQUE DE LA POLLINATION

### 2.1 Définition logique
Une **Pollination** est un opérateur qui prend deux régions du savoir et produit (ou non) une **Seed** :

```
   Pollination( source_A , source_B , context ) → Seed | ∅
```
- `source_A`, `source_B` = deux sous-arbres / nœuds / feuilles (éloignés = plus de potentiel).
- `context` = l'état actuel : historique daté, Vision Helm, contraintes du secteur.
- sortie = une **Seed** si le croisement est fécond, sinon **∅** (croisement stérile).

### 2.2 Les 4 conditions logiques d'une pollination féconde
Un croisement n'est pas fécond par hasard. **Quatre conditions logiques** (toutes nécessaires) :

| # | Condition | Logique | Pourquoi |
|---|---|---|---|
| **L1** | **Distance suffisante** | `distance(A,B) ≥ θ_min` | trop proches = redondance (pas de nouveauté) |
| **L2** | **Compatibilité non nulle** | `∃ pont logique entre A et B` | trop éloignés sans pont = bruit aléatoire |
| **L3** | **Nouveauté** | le lien A↔B **n'existe pas déjà** dans le KG | sinon ce n'est pas une création, c'est un rappel |
| **L4** | **Alignement Vision** | `align(A⊕B, Vision Helm) ≥ τ` | une graine non alignée est stérile pour l'entreprise |

> **Sweet spot de la créativité** : ni trop proche (L1), ni trop loin sans pont (L2). C'est la zone `θ_min ≤ distance ≤ θ_max` **avec** un pont logique — la « zone féconde ».

### 2.3 La connaissance pertinente de chaque élément (exigence fondateur)
> *« Pour faire du cross, il faut connaître de manière pertinente et logique chaque élément. »*

Avant tout croisement, chaque `source` doit être **caractérisée** (pas juste un label). Caractérisation minimale d'un nœud avant pollination :
- son **Rootstock** (sa fondation/invariant),
- ses **propriétés logiques** (ce qu'il fait, ce qu'il requiert, ce qu'il exclut),
- ses **liens existants** (pour détecter la nouveauté L3),
- sa **maturité** (SMI : on ne pollinise pas depuis une branche non maîtrisée).

> **Règle** : *on ne pollinise jamais depuis l'ignorance.* Une source mal comprise produit des graines fausses. La pollination exige la maîtrise préalable (le STB doit être solide).

---

## 3. MODÉLISATION LOGIQUE DE LA SEED (la graine)

### 3.1 Anatomie logique d'une Seed
Une Seed n'est pas un texte : c'est un **objet structuré** à 5 composants logiques :

```
   SEED
   ├─ ① CORE PROPOSITION  : l'idée/décision/méthode neuve (le "quoi")
   ├─ ② PARENTHOOD        : (source_A, source_B) qui l'ont engendrée (le "d'où")
   ├─ ③ POTENTIAL TREE    : l'arbre en puissance qu'elle peut déployer (le "vers quoi")
   ├─ ④ VIABILITY PROFILE : viability + fecundity (le "peut-elle germer ?")
   └─ ⑤ PROVENANCE        : la lignée datée immuable (le "comment le prouver")
```

### 3.2 ④ VIABILITY PROFILE — le critère de fécondité (réponse à ta Q1)
Tu as dit : *la validité = potentiel de viabilité + fécondité.* On distingue **deux mesures** :

| Mesure | Question | Décomposition logique |
|---|---|---|
| **Seed Viability** | « Va-t-elle germer (survivre, devenir réelle) ? » | `feasibility × alignment × non_redundancy × resource_fit` |
| **Fecundity** | « Combien d'arbres/dérivés peut-elle engendrer ? » | `nb de sous-arbres potentiels × portée stratégique` |

- **Une graine viable mais peu féconde** = une bonne petite amélioration (germera, mais arbre nain).
- **Une graine féconde mais peu viable** = une idée géniale mais infaisable maintenant (à conserver pour plus tard).
- **Cible** : haute viabilité **et** haute fécondité = la graine qu'on plante en priorité.

> **Seed Sterility (graine stérile)** = `viability < seuil` OU `nouveauté = 0` OU `alignment Vision = 0`. Une graine stérile est **archivée, pas jetée** (elle pourra redevenir viable si le contexte change — bitemporel, cf. §5).

### 3.3 Cycle de vie d'une Seed (machine à états)
```
   POLLINATED ──(viability ≥ seuil)──► VIABLE ──(plantée)──► GERMINATING ──► NEW SUBTREE
        │                                  │
        └──(stérile)──► DORMANT ◄──────────┘ (rétrogradée si contexte change)
        DORMANT ──(contexte favorable plus tard)──► VIABLE   (réveil bitemporel)
```

> Aucune graine n'est détruite. **Dormant** ≠ mort : une graine stérile aujourd'hui peut germer demain si l'entreprise/le marché évolue. C'est le **capital génératif latent**.

---

## 4. DIRIGÉE vs OUVERTE — proposition argumentée (réponse à ta Q2 « à y réfléchir »)

### 4.1 Le choix : **UN opérateur unique avec un curseur** (pas deux opérateurs)
Recommandation : **un seul Pollinator** paramétré par un **curseur `exploration_temperature τ`** (0 = dirigé/sûr, 1 = ouvert/créatif).

| | `τ → 0` (Directed) | `τ → 1` (Open) |
|---|---|---|
| Secteur | Cyber, régulé | R&D, innovation produit |
| Contrainte L4 (alignement) | **stricte** (graines sûres) | **relâchée** (exploration) |
| Distance L1/L2 | resserrée (croisements proches, fiables) | élargie (croisements lointains, risqués) |
| Sortie | **décisions sûres et impactantes** | **idées créatives, hypothèses** |

**Pourquoi un curseur et pas deux opérateurs** :
1. **Économie d'architecture** : un seul opérateur à maintenir, prouver, optimiser.
2. **Continuité** : entre « sûr » et « créatif » il y a un continuum, pas une frontière. Un curseur le capture.
3. **Pilotage par plugin** : chaque plugin règle `τ` par défaut (Cyber bas, R&D haut), l'utilisateur peut ajuster.

> **Décision proposée — à valider** : `Pollinator(A, B, context, τ)`. Cyber pack : `τ ≈ 0.2`. Reste à confirmer ensemble.

---

## 5. TRAÇABILITÉ DE LA SEED — proposition ancrée sur standards réels (réponse à ta Q4)

> Tu m'as demandé de chercher et proposer. Voici une proposition **fondée sur deux standards éprouvés**, pas inventée.

### 5.1 Standard 1 — W3C PROV (provenance / lignée)
Le modèle **W3C PROV-DM** est le standard de provenance : il décrit comment une chose est née via `Entity / Activity / Agent` et la relation clé **`wasDerivedFrom`** [1](https://www.w3.org/TR/prov-dm/), [6](https://www.w3.org/TR/prov-o/).

Application à la Seed :
- la **Seed** est une `prov:Entity`,
- la **Pollination** est une `prov:Activity` (avec startTime),
- elle **`used`** `source_A` et `source_B`,
- la Seed **`wasGeneratedBy`** cette Pollination et **`wasDerivedFrom`** A et B,
- elle **`wasAttributedTo`** l'agent (Cross-Pollinator) et **`wasAssociatedWith`** la session/incident d'origine.

→ On obtient une **chaîne de provenance immuable** : toute Seed est traçable à ses parents, son activité, sa date, son agent. **Décision incontestable** car la lignée est prouvable.

### 5.2 Standard 2 — Bitemporal (Zep/Graphiti, déjà dans la stack SCYForge)
Le modèle **bitemporel** (déjà retenu via Graphiti/Zep) attache à chaque fait **deux temps** [3](https://www.getzep.com/ai-agents/temporal-knowledge-graph/) :
- **Event Time (T)** : quand le fait s'est réellement produit (l'incident de mars),
- **Ingestion Time (T′)** : quand le système l'a appris.

Et surtout : les faits supersédés sont **fermés (valid-to), pas supprimés** → l'historique reste **auditable** [3](https://www.getzep.com/ai-agents/temporal-knowledge-graph/).

Application à la Seed :
- chaque Seed et chaque Growth Ring porte `(event_time, ingestion_time, valid_from, valid_to)`,
- une Seed Dormant a `valid_to` ouvert → réveillable,
- on peut interroger : *« quelles graines étaient viables au 2026-03 ? »* (point-in-time),
- la provenance pointe vers l'**épisode source** (l'incident, le doc).

### 5.3 Structure de données proposée (conceptuelle, pas du code)
```
   Seed {
     id
     core_proposition
     parenthood: { source_A, source_B }      // wasDerivedFrom (PROV)
     generated_by: pollination_activity_id   // wasGeneratedBy (PROV)
     attributed_to: agent_id                  // wasAttributedTo (PROV)
     potential_tree_ref
     viability_profile: { viability, fecundity, state }
     temporal: { event_time, ingestion_time, valid_from, valid_to }  // bitemporal (Zep)
     vision_alignment_score                   // vs Vision Helm
   }
```

> **Le moat de traçabilité** : une Seed SCYForge n'est jamais « une idée d'IA ». C'est une **conséquence prouvée** du savoir daté de l'entreprise — provenance W3C + bitemporel. **Impossible à contester, impossible à copier** (c'est l'histoire de *cette* entreprise).

---

## 6. LE VISION HELM — gouvernail de vision (réponse à ta Q3)

> *« Il faut créer une sorte de gouvernail pour encapsuler/encoder la vision de l'entreprise, de telle sorte que les recrues, les arborisations et toute fonctionnalité concourent à l'avancement de cette vision. »*

### 6.1 Définition
Le **Vision Helm** est un objet de premier ordre qui **encode la vision/les objectifs stratégiques** de l'entreprise et **oriente tout le système** vers elle. Ce n'est pas un texte de mission : c'est un **champ d'alignement** que chaque opération consulte.

### 6.2 Ce que le Helm gouverne (tout y concourt)
| Composant SCYForge | Comment le Helm l'oriente |
|---|---|
| **Arborization** | la racine choisie privilégie ce qui sert la vision |
| **Pollination** | condition L4 : `align(seed, Helm) ≥ τ` filtre les graines |
| **Recrues (ASCENT)** | l'onboarding priorise les branches critiques pour la vision |
| **COSMOS** | les visualisations mettent en avant les angles stratégiques |
| **Seed ranking** | les graines alignées remontent en priorité |

### 6.3 Comment encoder la vision (proposition)
- **Vecteurs d'objectifs** : la vision décomposée en axes mesurables (ex. « réduire le temps de réponse incident », « monter en autonomie SOC »).
- **Poids stratégiques** : chaque axe a un poids → le Helm est un **vecteur pondéré**.
- **Fonction d'alignement** : `align(x, Helm)` mesure à quel point une connaissance/graine/décision pousse dans le sens de la vision.
- **Révisable** : le Helm évolue (la vision change) → bitemporel aussi (on garde l'historique des visions).

> **Le Helm transforme SCYForge en système téléologique** : tout le savoir, toute arborisation, toute graine **converge vers le cap** de l'entreprise. C'est ce qui rend les décisions *pertinentes et impossibles à ignorer*.

---

## 7. CROSS-POLLINATION INTELLIGENTE (réponse à ta Q5)

### 7.1 Séquencement (décision fondateur)
1. **Phase 1 (cyber, maintenant)** : **Self-Pollination** — croisements **intra-domaine** (entre éléments du STB cyber : incidents × SOP × techniques). Pertinent, fiable, immédiat.
2. **Phase 2 (couche ajoutée)** : **Cross-Pollination** inter-domaine — une **couche** au-dessus, activée plus tard.
3. **Vision long terme** : cross-pollination multi-secteurs (physique × quantique × cyber…).

### 7.2 Intelligente, pas statique (exigence fondateur)
> *« Notre cross-pollination doit être un système autonome lié au système d'arborisation — intelligent, pas juste statique. »*

Deux approches contrastées (et la position SCYForge) :

| Approche | Description | Verdict |
|---|---|---|
| **Classique (rejetée comme cœur)** | un **agent de recherche connecté à Internet** ajoute du contexte actualisé au Cross-Pollinator → détecte des liens « nouveaux » par rapport à l'existant | utile **en appoint**, mais **généraliste** : tout le monde peut le faire |
| **Intelligente (le cœur SCYForge)** | un système **autonome, indépendant d'Internet**, qui à partir des **infos propres de l'entreprise** fait **émerger** de nouveaux liens internes | **le vrai 0→1** : la créativité naît du savoir privé, pas du web |

### 7.3 Architecture proposée : deux moteurs, un superviseur
```
   ┌───────────────── CROSS-POLLINATOR (autonome, lié à Arborization) ─────────────┐
   │                                                                               │
   │  MOTEUR INTERNE (cœur)        │  MOTEUR EXTERNE (appoint, optionnel)          │
   │  émergence de liens à partir  │  Research Agent connecté Internet :           │
   │  du SAVOIR PRIVÉ de l'entrep. │  contextualise, vérifie la nouveauté,         │
   │  → indépendant d'Internet     │  apporte de l'actualité                       │
   │                               │                                               │
   └──────────────────────────────┴───────────────────────────────────────────────┘
                       │ supervisé par le système d'ARBORIZATION
                       ▼
              graines internes (prioritaires) + graines contextualisées
```

> **Principe** : le moteur **interne** (savoir privé) est le **cœur génératif**. Le moteur **externe** (Internet) ne fait que **contextualiser/valider la nouveauté** — il n'est jamais la source de la créativité. La créativité reste **endogène**, donc **non-copiable**.

### 7.4 Pourquoi c'est lié à l'Arborization
La cross-pollination n'est pas un module à part : elle **exploite la structure de l'arbre** (distances entre branches, ponts logiques, maturité des nœuds). C'est l'arborisation qui **rend possible** une pollination intelligente — sans arbre dirigé, pas de notion de « distance féconde ». **Arborize d'abord, pollinise ensuite.**

---

## 8. SYNTHÈSE : le Generative Forest Engine (GFE)

```
   ARBORIZE (KG plat → STB dirigé)
        │
   CHARACTERIZE (chaque nœud : rootstock, propriétés, liens, maturité)
        │
   POLLINATE (Pollinator avec curseur τ, conditions L1–L4)
        │
   SEED (objet à 5 composants, viability + fecundity)
        │
   GOVERN (Vision Helm filtre/aligne)
        │
   GERMINATE (graine viable → nouveau sous-arbre du STB)
        │
   └──► l'arbre grandit → de nouvelles pollinations deviennent possibles (boucle)
```

> **Le moat composé** : chaque germination agrandit la forêt → plus de pollinations possibles → plus de graines → plus de germinations. **Croissance générative auto-entretenue**, ancrée sur le savoir privé daté et la vision. Personne ne peut copier la forêt d'une entreprise : c'est son histoire, son cap, ses croisements.

---

## 9. Questions restantes pour le tour suivant (formalisation math / ingénierie)

1. **Métriques de distance** `distance(A,B)` : sémantique (embeddings) ? structurelle (chemin dans l'arbre) ? hybride ?
2. **Seuils** `θ_min, θ_max, τ` : appris par secteur, ou fixés par expert au départ ?
3. **Fonction de viabilité** : forme exacte de `feasibility × alignment × non_redundancy × resource_fit`.
4. **Encodage du Vision Helm** : vecteur pondéré ? graphe d'objectifs ? les deux ?
5. **Émergence endogène** : par quel mécanisme le moteur interne fait-il *émerger* des liens nouveaux sans Internet (raisonnement analogique structurel ? recombinaison sous contraintes ?) — **le cœur du 0→1, à approfondir.**

---

*Document de modélisation logique. Étape suivante : formalisation mathématique / logique / d'ingénierie (espaces d'état, opérateurs, métriques, seuils).*
*Sources externes : W3C PROV-DM [1](https://www.w3.org/TR/prov-dm/) & PROV-O [6](https://www.w3.org/TR/prov-o/) (provenance/lignée) ; Zep/Graphiti temporal knowledge graph bitemporel [3](https://www.getzep.com/ai-agents/temporal-knowledge-graph/).*
*Réf. internes : `SCYFORGE_GENERATIVE_TREE_POLLINATION_SEED.md`, `SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_C_ARBORIZATION.md`.*

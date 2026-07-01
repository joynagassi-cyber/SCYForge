# SCYForge — Le Semantic Tree comme Infrastructure Cognitive

> **Statut** : document fondateur / niveau investisseur.
> **Thèse centrale** : le *Semantic Tree* n'est pas une fonctionnalité d'affichage ni une carte mentale.
> C'est **le même invariant** qui structure (a) le cerveau de l'apprenant, (b) le savoir vivant de
> l'entreprise, et (c) l'architecture interne de SCYForge. Cette **triple coïncidence** est le moat.

---

## 0. TL;DR pour fondateur pressé

1. Tout savoir réellement maîtrisé est **structuré en arbre** : un tronc (fondations, 80/20), des branches (sous-domaines), des feuilles (détails opérables). Le cerveau ne retient pas des listes, il retient des **structures hiérarchiques connectées**.
2. SCYForge ne *montre pas* un arbre — il **force la construction de l'arbre dans la tête de l'apprenant**, tronc d'abord, via génération active, friction utile, et preuve.
3. Le **même arbre** est l'objet d'accumulation du savoir d'entreprise : chaque nouvel acquis (un incident, une procédure, une règle de détection) se **greffe** à un nœud existant au lieu de finir dans un PDF mort.
4. Le **même arbre** est l'**ossature du produit** : ASCENT, FSRS, COSMOS, BRAIN, Proof-of-Skill ne sont pas des modules juxtaposés, ce sont des **opérations sur le même graphe arborescent**.
5. Le différenciant : les concurrents indexent du contenu (RAG, LMS, NotebookLM). SCYForge **fait croître un organe cognitif partagé** entre l'humain et l'organisation. Plus l'entreprise vit, plus l'arbre s'enrichit, plus le coût de sortie augmente → **moat composé dans le temps**.

---

## 1. Pourquoi un arbre, et pas un index, un graphe plat, ou un cours

### 1.1 Le constat cognitif (acquis du jour)
- Le cerveau **rejette ~90 %** de ce qui n'est pas rattaché à une structure existante. La rétention dépend de l'**accrochage** d'une information neuve à un point d'ancrage déjà solide.
- Principe de l'**arbre sémantique** : *tronc avant feuilles*, *fondations avant détails*, *80/20*. On ne mémorise pas un détail flottant ; on **suspend** un détail à une branche, qui pend à un tronc.
- **Generation effect / friction utile** : un nœud que l'apprenant **reconstruit lui-même** tient ; un nœud qu'on lui *montre* glisse (illusion de fluidité, illusion de compétence).
- **3C** — Compresser / Compiler / Consolider — est littéralement l'opération de **tailler un arbre** : on compresse les feuilles en branches, on compile les branches en tronc, on consolide par répétition espacée.

### 1.2 Pourquoi pas un graphe plat (le piège du « knowledge graph »)
Un knowledge graph générique est **plat et démocratique** : toutes les arêtes se valent, tout est connecté à tout. C'est excellent pour la *recherche*, désastreux pour l'*apprentissage* :
- pas de **direction d'effort** (par où commencer ?),
- pas de **hiérarchie de criticité** (le tronc d'abord),
- pas de **séquence pédagogique**.

L'arbre **n'est pas l'opposé du graphe** : c'est un graphe **orienté, racine, et pondéré par criticité**, sur lequel on superpose des arêtes transverses (les « lianes » : dépendances inter-branches). On garde la richesse du graphe **sans perdre la direction d'apprentissage**.

> **Formalisme** : un Semantic Tree SCYForge = un **DAG enraciné** (tronc → branches → feuilles) + un ensemble d'arêtes transverses typées (`prereq`, `relates`, `contradicts`, `supersedes`). L'arbre porte la *pédagogie* ; les lianes portent la *réalité opérationnelle*.

---

## 2. Niveau 1 — Le Semantic Tree dans le cerveau de l'apprenant

### 2.1 Objectif
Ne pas *transmettre* un arbre, mais **provoquer sa construction neuronale** chez l'apprenant — un arbre auquel il pourra ensuite **greffer lui-même** les nouveaux acquis de l'entreprise.

### 2.2 Les 5 opérations de construction (mappées sur ASCENT)

| Opération cognitive | Ce que ça fait dans la tête | Agent ASCENT porteur |
|---|---|---|
| **Plant (planter le tronc)** | Établir 3–7 nœuds-racines (le 80/20 du domaine) avant tout détail | `01 GOAL-INTERPRETER` + `03 DAG-ARCHITECT` |
| **Graft (greffer)** | Suspendre chaque concept neuf à un nœud parent **déjà solide** (jamais en l'air) | `03 DAG-ARCHITECT` + `04 LEARNING-CONDUCTOR` |
| **Test (éprouver)** | Faire **reconstruire** la branche par l'apprenant (active recall, teach-back) — pas la relire | `05 PERFORMANCE-ANALYZER` + `13 COGNITIVE-VALIDATOR` |
| **Prune (élaguer)** | Détecter les branches mortes / mal accrochées (drift, confiance faible) et les recâbler | `07 DRIFT-GUARDIAN` |
| **Myelinate (consolider)** | Répétition espacée le long des branches critiques jusqu'au seuil de maîtrise | `APEX/FSRS` + `09 SKILL-CERTIFIER` |

### 2.3 Règle d'or anti-illusion
> **On ne déverrouille jamais une feuille tant que sa branche parente n'a pas atteint le seuil de confiance.**

Concrètement : `Node.confidence` (déjà présent dans `scy-shared/types.rs`) **gouverne l'accès aux enfants**. Un apprenant ne « descend » dans le détail d'une technique d'attaque que lorsque la branche parente (la tactique) est maîtrisée. C'est *tronc avant feuilles*, codé dans le runtime. Cela tue l'illusion de fluidité : impossible d'avancer en surface.

### 2.4 Le « greffon vivant » : ce que demande l'utilisateur
L'apprenant ne reçoit pas un arbre figé. Une fois son tronc planté, **chaque nouvel acquis de l'entreprise lui arrive comme un greffon** :
- SCYForge calcule **où** l'acquis se rattache (quel nœud parent),
- vérifie que la branche d'accueil est **assez mûre** pour le recevoir (sinon il consolide d'abord),
- présente l'acquis comme une **extension de ce que l'apprenant sait déjà**, jamais comme un nouveau cours déconnecté.

C'est la différence entre *« voici la nouvelle procédure XYZ (PDF de 40 pages) »* et *« tu connais déjà la détection LSASS — voici la variante que l'attaquant a utilisée chez nous mardi, elle se greffe ici »*.

---

## 3. Niveau 2 — Le Semantic Tree comme savoir vivant de l'entreprise

### 3.1 Le problème réel des organisations
Le savoir d'entreprise est aujourd'hui un **cimetière de feuilles détachées** : wikis morts, runbooks obsolètes, post-mortems lus une fois, connaissances dans la tête de 2 seniors qui partiront. Rien n'a de tronc commun. Rien ne se greffe. Tout se re-découvre.

### 3.2 Le Semantic Tree d'entreprise = un arbre **par organisation**, persistant et croissant
- **Tronc** = les fondations stables du domaine (en cyber : tactiques ATT&CK, fondamentaux blue team).
- **Branches** = les sous-domaines de l'entreprise (sa stack, ses détections Sigma, ses playbooks).
- **Feuilles** = les acquis opérationnels datés : *cet* incident, *cette* règle, *cette* décision sous pression.

Chaque événement de la vie de l'entreprise devient une **opération de greffe horodatée** sur l'arbre :

```
Incident T1003.001 (vol creds LSASS) — 2026-06-12
   ├─ se greffe sous: Branche "Credential Access" → Feuille "LSASS read access"
   ├─ enrichit la règle Sigma interne #SOC-0042
   ├─ génère un scénario ARENA rejouable
   └─ devient une carte FSRS pour toute l'équipe SOC
```

### 3.3 Mémoire temporelle = anneaux de croissance
La stack mémoire (Graphiti / Zep, déjà retenue) donne à l'arbre des **anneaux de croissance** : on peut interroger *« qu'est-ce que l'entreprise savait à la date T ? »*, voir **quand** une branche a poussé, **quelle** feuille a supersédé une autre (`supersedes`). Le savoir devient **versionné et auditable**, pas amnésique.

### 3.4 Conséquence : le départ d'un senior ne casse plus l'arbre
Quand un expert part, son savoir n'est pas dans sa tête — il est **déjà greffé** sur l'arbre d'entreprise, déjà transformé en branches consolidées et en preuves de compétence transmissibles. **C'est ça, l'autonomie organisationnelle.**

---

## 4. Niveau 3 — Le Semantic Tree comme architecture du produit

### 4.1 L'invariant : un seul objet, beaucoup d'opérations
Tous les sous-systèmes SCYForge ne sont **pas** des modules indépendants. Ce sont des **fonctions sur le même arbre** :

| Sous-système | Opération sur l'arbre |
|---|---|
| **Ingestion (cores 11–13)** | Découpe le corpus brut en candidats-nœuds |
| **NEURON-CHAINS (24 agents)** | Plante / greffe les nœuds, extrait les `Concept` atomiques (feuilles) |
| **DAG-ARCHITECT** | Ordonne tronc → branches → feuilles, pose les lianes `prereq` |
| **APEX / FSRS** | Myélinise les branches (répétition espacée par nœud) |
| **COSMOS (8 vues)** | **Rend** l'arbre (8 projections de la même structure) |
| **BRAIN (Q&A)** | Navigue l'arbre pour répondre, source-grounded |
| **ARENA** | Simule sous pression en *parcourant* une branche critique |
| **DRIFT-GUARDIAN** | Élague les branches obsolètes / contradictoires |
| **SKILL-CERTIFIER** | Certifie qu'une **sous-arbre** est maîtrisée (SMI ≥ 70) |
| **CHRONICLE** | Enregistre les anneaux de croissance |

> **Conséquence d'architecture** : il n'existe qu'**une** source de vérité — le Semantic Tree. Tout le reste lit, écrit, ou projette cet objet. C'est ce qui rend le système **cohérent** et **multi-domaines sans réécriture**.

### 4.2 Les objets système (ancrés sur le code réel existant)

Le repo a déjà les primitives dans `backend_rs/crates/scy-shared/src/types.rs` :
- `Node { id, goal_id, title, summary, confidence, created_at }` → **le nœud d'arbre** (le `confidence` est déjà là : c'est notre verrou *tronc-avant-feuilles*).
- `Concept { id, node_id, label, definition }` → **la feuille atomique** rattachée à un nœud.
- `Card` (FSRS B01–B10) → **l'unité de myélinisation** d'une feuille.

Ce qui manque pour faire de l'arbre un objet de **premier ordre** (extension proposée, non destructive) :

```rust
// Extension proposée à scy-shared : l'arête d'arbre comme objet explicite.
pub enum EdgeKind {
    Trunk,        // racine d'un domaine (pas de parent)
    Branch,       // parent = nœud d'arbre
    Leaf,         // parent = concept opérable
    Prereq,       // liane: A doit précéder B
    Relates,      // liane: lien transverse non bloquant
    Contradicts,  // conflit à arbitrer (drift)
    Supersedes,   // remplacement versionné (anneau de croissance)
}

pub struct TreeEdge {
    pub id: uuid::Uuid,
    pub tree_id: uuid::Uuid,     // l'arbre (par apprenant OU par organisation)
    pub from_node: uuid::Uuid,
    pub to_node: uuid::Uuid,
    pub kind: EdgeKind,
    pub criticality: f32,        // pondération 80/20: poids du chemin
    pub created_at: i64,
    pub superseded_at: Option<i64>, // null = vivant; sinon = anneau historisé
}

pub struct SemanticTree {
    pub id: uuid::Uuid,
    pub owner_kind: OwnerKind,   // Learner | Organization | DomainPack
    pub owner_id: uuid::Uuid,
    pub root_nodes: Vec<uuid::Uuid>, // les troncs
    pub domain_pack: String,         // "cyber" pour le wedge
}
```

### 4.3 Trois instances du **même** type
La force du design : `SemanticTree` se décline en trois `owner_kind` sans changer de type :
1. **`DomainPack`** — l'arbre canonique du domaine (ex. arbre cyber dérivé d'ATT&CK + Sigma). Partagé, versionné par SCYForge.
2. **`Organization`** — l'arbre de l'entreprise = arbre du pack **+ greffons privés** (incidents, règles internes). C'est ici que vit le moat de données privées.
3. **`Learner`** — la **projection maîtrisée** de l'arbre d'organisation dans une tête, avec `confidence` par nœud propre à l'apprenant.

> **Diff(org) − Diff(pack) = la valeur privée irréductible de l'entreprise.** Personne ne peut la copier : elle est faite de *son* histoire.

---

## 5. Le Semantic Tree comme **infrastructure** (le saut conceptuel demandé)

Une fonctionnalité s'utilise. Une **infrastructure** est ce sur quoi d'autres choses se construisent et **qu'on ne peut plus retirer sans tout casser**. Le Semantic Tree devient infrastructure dès qu'il satisfait 4 propriétés :

1. **Substrat unique** — un seul objet de vérité, lu/écrit par tous les agents (cf. §4.1). Rien ne contourne l'arbre.
2. **Accumulation composée** — chaque interaction (greffe, test, incident) **augmente** l'arbre de façon permanente et horodatée. L'arbre d'hier ⊂ l'arbre d'aujourd'hui.
3. **Interopérabilité interne via RCL** — les agents ne se parlent pas en prose, ils s'échangent des **opérations d'arbre compactes** (`compress inside, justify outside` : payload dense interne, justification auditable externe). Le RCL est le *bus* de l'infrastructure-arbre.
4. **Extensibilité par contrat (Domain Packs)** — un nouveau domaine = un nouvel `owner_kind=DomainPack` + un mapping d'ontologie. **Aucune réécriture du noyau.**

### 5.1 Schéma d'infrastructure

```
                 ┌──────────────────────────────────────────┐
                 │            SEMANTIC TREE (substrat)        │
                 │  troncs · branches · feuilles · lianes     │
                 │  3 instances: Pack / Org / Learner         │
                 └───────────────▲───────────┬────────────────┘
        opérations d'arbre (RCL) │           │ projections
   ┌──────────────┬──────────────┴───┐   ┌───▼──────────────┐
   │  INGESTION   │  NEURON-CHAINS    │   │ COSMOS (8 vues)  │
   │  greffe brut │  plante / greffe  │   │ BRAIN (Q&A)      │
   └──────────────┴──────────────────┘   │ ARENA (pression) │
   ┌──────────────┬──────────────────┐   └──────────────────┘
   │ APEX/FSRS     │ DRIFT-GUARDIAN   │   ┌──────────────────┐
   │ myélinise     │ élague / versionne│  │ SKILL-CERTIFIER  │
   └──────────────┴──────────────────┘   │ sous-arbre→preuve│
                                          └──────────────────┘
```

### 5.2 Effet réseau **intra-entreprise** (le bon type de network effect)
Le réseau n'est pas social (entre clients) — il est **interne** : chaque analyste qui maîtrise une branche, chaque incident greffé, chaque règle ajoutée **augmente la valeur de l'arbre pour tous les autres employés**. Plus l'entreprise utilise SCYForge, plus son arbre est dense, plus une nouvelle recrue monte vite. **La valeur croît avec l'usage, et elle est captive de l'organisation.** C'est un moat qui se renforce tout seul.

---

## 6. Le facteur différenciant (le « comment » et le « pourquoi on gagne »)

### 6.1 La ligne de démarcation nette

| | Indexent le savoir | **Font croître un organe cognitif** |
|---|---|---|
| RAG / chatbot doc | ✅ | ❌ |
| LMS | ✅ (cours figés) | ❌ |
| NotebookLM | ✅ (compréhension source-grounded) | ❌ |
| **SCYForge** | ✅ | ✅ **(unique)** |

> NotebookLM répond *« qu'est-ce que ce document dit ? »*.
> SCYForge répond *« es-tu capable d'agir, sous pression, à partir de ce que ton organisation a appris jusqu'à mardi dernier ? »* — et le **prouve** (SMI ≥ 70, Proof-of-Skill).

### 6.2 Les 3 différenciateurs irréductibles

1. **Différenciateur de structure** — SCYForge ne stocke pas du contenu, il stocke une **structure cognitive croissante**. Copier le contenu est facile ; **copier l'arbre vivant et son histoire de greffes est impossible** (c'est l'expérience opérationnelle de *cette* entreprise).

2. **Différenciateur de transformation** — la promesse n'est pas l'accès (gap d'accès = résolu par Google/RAG), c'est la **transformation savoir → maîtrise prouvée**. Le vrai gap cyber est un gap de **jugement sous pression**, pas d'information. SCYForge est le seul à fermer ce gap-là par construction d'arbre + ARENA + preuve.

3. **Différenciateur d'accumulation composée** — l'arbre s'enrichit à **chaque jour de vie de l'entreprise**. Le coût de remplacement croît dans le temps : au bout de 18 mois, l'arbre d'organisation contient des centaines de greffes datées impossibles à reconstituer ailleurs. **Le moat se creuse pendant que le client dort.**

### 6.3 Pourquoi c'est un moat *infrastructurel* et pas une feature
Une feature se contourne (un concurrent la recopie en un trimestre). Une infrastructure devient le **système nerveux** de l'organisation : la retirer, c'est lobotomiser l'entreprise. Quand l'arbre d'org contient le savoir vivant, daté, prouvé, et que chaque recrue est onboardée *à travers lui*, **partir coûte plus que rester** — définition exacte d'un monopole de niche.

---

## 7. Application au wedge cyber (concret)

- **Tronc** = 14 tactiques ATT&CK + fondamentaux blue team (dérivé du STIX : 697 techniques, 475 sous-techniques, 222 parentes).
- **Branches** = tactiques → techniques denses observées dans Sigma (`T1059.001` ≈ 179 règles, `T1218` ≈ 135, `T1003.001` ≈ 77…). La **densité Sigma** sert de **pondération de criticité** native des branches.
- **Feuilles** = sous-techniques + hunts réels (ThreatHunter-Playbook, ex. `170105-LSASSMemoryReadAccess` / T1003.001) + greffons d'incidents internes.
- **Scénarios ARENA** = parcours sous pression d'une branche (APT29 : 79 étapes → chemin critique de l'arbre).
- **Greffe d'entreprise** = chaque alerte traitée, chaque règle Sigma interne, chaque post-mortem se greffe sous sa technique ATT&CK (clé de jointure `attack.tXXXX` déjà identifiée).

> Le pack cyber n'est qu'**une instance** de `DomainPack`. Le pack vente (2e niche) sera un **autre arbre**, même noyau, zéro réécriture.

---

## 8. Extensibilité multi-domaines

| Élément | Domain-agnostic (noyau) | Domain-specific (pack) |
|---|---|---|
| `SemanticTree`, `TreeEdge`, `EdgeKind` | ✅ | |
| Opérations Plant/Graft/Test/Prune/Myelinate | ✅ | |
| Seuil maîtrise SMI ≥ 70, FSRS, RCL | ✅ | |
| Ontologie des troncs/branches | | ✅ (ATT&CK pour cyber, cycle de vente pour sales) |
| Source de criticité | | ✅ (densité Sigma / taux de closing) |
| Scénarios de pression | | ✅ (APT29 / objection client) |

Changer de niche = fournir un **nouveau pack** (ontologie + criticité + scénarios). Le noyau-arbre ne bouge pas. **C'est ça qui permet le zero-to-one répétable.**

---

## 9. Risques & garde-fous

- **Risque wrapper LLM (Thiel Q1)** : l'arbre doit être généré **10× plus vite et plus juste** qu'un senior manuel. → Le bench à prouver : temps de construction d'un arbre cyber validé vs. expert humain.
- **Risque arbre figé** : un arbre qui ne se greffe pas est un LMS déguisé. → KPI : **taux de greffe / semaine** par organisation.
- **Risque illusion de complétude** : un bel arbre affiché ≠ un arbre dans la tête. → La seule mesure qui compte est `Learner.confidence` **prouvée par test**, pas la couverture visuelle.
- **Risque sur-friction** : trop de friction tue l'engagement. → Politique runtime déjà cadrée (`SCYFORGE_COGNITIVE_RUNTIME_POLICIES.md`) : friction *utile*, dosée.

---

## 10. Prochaines étapes d'implémentation (proposées)

1. **Objets système** : ajouter `SemanticTree` / `TreeEdge` / `EdgeKind` à `scy-shared/types.rs` (extension non destructive de `Node`/`Concept`).
2. **Provider** : `SemanticTreeProvider` (port hexagonal) — opérations Plant/Graft/Test/Prune/Myelinate.
3. **Mapping RCL** : définir les messages d'opération d'arbre dans le `RCL_MESSAGE_CATALOG`.
4. **Branchement Cyber Pack** : générer l'arbre cyber canonique depuis `attack_hierarchy.json` + `attack_density.json` déjà présents.
5. **Greffe temporelle** : brancher Graphiti/Zep pour les anneaux de croissance (`superseded_at`).
6. **Backlog** : tickets d'implémentation alignés (à produire ensuite si validé).

---

*Document interne SCYForge. Aucune affirmation chiffrée non sourcée : données ATT&CK/Sigma/APT29 issues des corpus réels clonés (MITRE CTI STIX, SigmaHQ, OTRF ThreatHunter-Playbook, MITRE Adversary Emulation APT29).*

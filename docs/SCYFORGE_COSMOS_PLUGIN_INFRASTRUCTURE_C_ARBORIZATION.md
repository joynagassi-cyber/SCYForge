# SCYForge — COSMOS Plugin Infrastructure (C) : Arborisation du Graphe & Moteur d'Insights

> **Statut** : architecture du **0→1**. **Aucun code.** Document C de 3 (A=noyau, B=Plugin Cyber, C=ce document).
> **Thèse fondateur** : *« L'arborisation des graphes de connaissances — un tronc et des feuilles —
> n'existe pas encore sur le marché. C'est ce qui nous fait passer en 0→1. »*

---

## 0. La rupture : du graphe plat à l'arbre dirigé

| Tout le marché | SCYForge |
|---|---|
| Knowledge Base : « ce que dit la source » | + Knowledge Base |
| Knowledge Graph : « tout est relié à tout », **plat, sans direction** | + Knowledge Graph |
| — (s'arrête là) | **+ ARBORISATION → Semantic Tree** : tronc → branches → feuilles, dirigé, défendable |

> **L'arborisation est l'acte de jugement que personne ne fait** : choisir une racine, hiérarchiser, pondérer. Indexer est automatique ; **arboriser est intelligent**. C'est là qu'est le 0→1.

---

## 1. Les trois couches et leur frontière nette (rappel + approfondissement)

```
   ┌───────────────────────────────────────────────────────────────┐
   │ KNOWLEDGE BASE (KB)  — la PREUVE                                │
   │   documents bruts, chunks, citations. « Qu'est-ce que la       │
   │   source dit exactement ? »  Source-grounded, vérifiable.      │
   └───────────────────────────────▲──────────────────────────────┘
                                    │ extraction entités/relations
   ┌───────────────────────────────┴──────────────────────────────┐
   │ KNOWLEDGE GRAPH (KG) — la TOPOLOGIE                             │
   │   graphe plat, démocratique. « Qu'est-ce qui est relié à quoi ?»│
   │   Riche, exhaustif, MAIS sans direction d'apprentissage.       │
   └───────────────────────────────▲──────────────────────────────┘
                                    │ ★ ARBORISATION ★ (le 0→1)
   ┌───────────────────────────────┴──────────────────────────────┐
   │ SEMANTIC TREE (STB) — la DIRECTION                              │
   │   DAG enraciné, pondéré 80/20. « Par où apprendre ? Quoi       │
   │   maîtriser d'abord ? Comment défendre de bout en bout ? »     │
   │   Chaque nœud = un Nœud Vivant (fondation + dérivés datés).    │
   └────────────────────────────────────────────────────────────────┘
```

**Le STB ne remplace pas le KG** : il le **discipline**. Les arêtes du KG non hiérarchiques restent disponibles comme **lianes transverses** superposées à l'arbre (c'est elles qui nourrissent le moteur d'insights, §3).

---

## 2. L'ARBORISATION : comment transformer un KG plat en arbre

### 2.1 Définition
**Arboriser** = à partir d'un graphe plat (KG), produire un arbre dirigé (STB) en répondant à 3 questions :
1. **Quelle est la racine ?** (la fondation, le tronc — l'invariant 80/20)
2. **Quel est l'ordre des branches ?** (hiérarchie par criticité)
3. **Qu'est-ce qui est feuille ?** (le détail opérable, terminal)

### 2.2 Le pipeline d'arborisation (5 étapes)

```
KG plat
  │  ① RACINAGE        → identifier le(s) tronc(s) candidat(s)
  │  ② PONDÉRATION     → criticité par nœud (80/20, source = plugin)
  │  ③ HIÉRARCHISATION → orienter les arêtes (tronc→branche→feuille)
  │  ④ ÉLAGAGE         → retirer/historiser le bruit & redondances
  │  ⑤ LIANAGE         → conserver les arêtes transverses utiles (insights)
  ▼
STB dirigé
```

| Étape | Ce qu'elle fait | Qui la porte (ASCENT) | Comment elle décide |
|---|---|---|---|
| ① **Racinage** | choisit le tronc | DAG-ARCHITECT | centralité dans le KG + criticité plugin + (validation humaine si ambigu) |
| ② **Pondération** | poids 80/20 par nœud | DAG-ARCHITECT | source de criticité du plugin (densité Sigma en cyber) |
| ③ **Hiérarchisation** | oriente les arêtes | DAG-ARCHITECT | profondeur sémantique : général→spécifique |
| ④ **Élagage** | enlève le bruit | DRIFT-GUARDIAN | redondance, faible criticité, contradiction |
| ⑤ **Lianage** | garde les liens transverses | DAG-ARCHITECT | arêtes inter-branches à fort potentiel d'insight |

### 2.3 Le racinage : le point délicat (acte de jugement)
Quand plusieurs racines sont candidates, on **ne devine pas**. Trois stratégies, par ordre de préférence :
1. **Criticité-driven** : la racine est le nœud de plus forte criticité plugin (auto).
2. **Goal-driven** : si l'utilisateur déclare un objectif (GOAL-INTERPRETER), la racine = la fondation de cet objectif.
3. **Human-in-the-loop** : si ambiguïté, on propose 2-3 racines candidates et l'humain tranche (et ce choix devient un greffon du STB).

> **Invariant** : *aucune arborisation sans fondation explicite.* Un arbre sans tronc clair est rejeté.

---

## 3. Le Moteur d'Insights & Créativité (la valeur née de la KB)

> **Thèse fondateur** : *l'utilisateur peut relier des concepts hétérogènes — physique, IT, robotique,
> quantique, mathématiques — pour en tirer des liens logiques nouveaux. La base de connaissances de
> l'entreprise devient un actif capital pour innover, créer, et même se reconvertir demain.*

### 3.1 D'où viennent les insights ? Des LIANES, pas du tronc
- Le **tronc** sert à **apprendre/maîtriser** (direction).
- Les **lianes** (arêtes transverses du KG conservées à l'étape ⑤) servent à **créer** : ce sont les **ponts inattendus** entre branches distantes.

> Un insight = **une liane à fort potentiel entre deux sous-arbres éloignés.** (Ex. relier un concept de la branche « robotique » à un concept de la branche « quantique ».)

### 3.2 Deux modes selon le contexte (le moteur s'adapte au secteur)
| Contexte | Ce que le moteur produit | Exemple |
|---|---|---|
| **Projet d'apprentissage ouvert** (R&D, exploration) | **Créativité** : lier physique × IT × robotique × maths → idées de solutions nouvelles | un chercheur relie 5 domaines de son corpus → concept inédit |
| **Cybersécurité (décision sous contrainte)** | **Insights / décisions sûres** : pas de la créativité libre, mais des **prises de décision fiables**, idées de programmes/solutions nées de la KB interne | un analyste relie 3 incidents passés → règle de détection nouvelle |

> Même moteur, **deux sorties** selon le pack : *créativité* (exploration) vs *insight décisionnel* (contrainte). C'est le plugin qui règle le curseur.

### 3.3 Comment ça marche (conceptuel)
```
   STB (tronc + branches maîtrisées)
        │
   l'utilisateur sélectionne des concepts (mono ou multi-branches)
        │
   MOTEUR D'INSIGHTS parcourt les LIANES du KG entre ces concepts
        │
   propose des liens logiques : « ces deux notions partagent X »
        │
   ┌──────────────┬────────────────────────┐
   │ CRÉATIVITÉ   │ INSIGHT DÉCISIONNEL     │
   │ (exploration)│ (cyber, contrainte)     │
   └──────────────┴────────────────────────┘
        │
   l'insight retenu devient un DÉRIVÉ greffé au STB (anneau de croissance)
```

### 3.4 La boucle vertueuse (pourquoi la KB devient un actif stratégique)
1. L'entreprise ingère son savoir → KB.
2. SCYForge l'arborise → STB maîtrisable.
3. L'utilisateur explore les lianes → **insights/créations**.
4. Ces insights se **greffent** au STB (dérivés datés).
5. L'arbre s'enrichit → la base de connaissances **prend de la valeur dans le temps**.

> **Conséquence stratégique** : la KB de l'entreprise n'est plus un coût de stockage — c'est un **capital génératif**. Elle sert demain à **innover, créer des programmes, se reconvertir**. SCYForge est l'infrastructure qui transforme ce capital dormant en avantage actif.

---

## 4. Connexion des trois couches au Nœud Vivant

Rappel (Doc V2) : **un nœud = un semantic tree** (fondation + dérivés). Voici comment les 3 couches le nourrissent :
- **KB** → fournit la **fondation** (les sources sur lesquelles le nœud est ancré) + la **preuve** de chaque dérivé.
- **KG** → fournit les **lianes** (les relations transverses → d'où naissent les dérivés/insights).
- **STB** → fournit la **structure** (où le nœud se situe, quels sont ses parents/enfants).

> Ouvrir un Nœud Vivant = voir sa fondation (KB), ses dérivés (greffés via lianes KG), le tout placé dans l'arbre (STB). **Traçabilité totale** : tout pointe vers une source.

---

## 5. Pourquoi C est le vrai moat (le 0→1)

1. **L'arborisation est un acte de jugement, pas d'indexation** → automatisable par personne d'autre sans le même investissement.
2. **Les lianes deviennent un moteur génératif** → on ne vend plus de l'apprentissage, on vend de la **capacité d'innovation née des données du client**.
3. **Chaque insight greffé épaissit le STB** → moat composé, irréversible : plus le client utilise, plus son arbre vaut, plus partir coûte cher.
4. **Le marché s'arrête au KG** (graphes plats) ou au KB (NotebookLM). **Personne n'arborise.** C'est la définition d'un zero-to-one.

---

## 6. Questions ouvertes pour C (à trancher avant code)

1. **Racinage automatique vs humain** : à partir de quel seuil d'ambiguïté bascule-t-on en human-in-the-loop ?
2. **Qualité d'une liane d'insight** : comment scorer le « potentiel d'insight » d'une arête transverse (distance dans l'arbre ? rareté de la connexion ? validation utilisateur) ?
3. **Greffe d'insight** : un insight créé par l'utilisateur entre-t-il directement dans le STB, ou passe-t-il par une validation (COGNITIVE-VALIDATOR) ?
4. **Multi-domaines créatifs** : pour la créativité inter-domaines (physique × quantique…), faut-il un STB « transverse » au-dessus des STB sectoriels, ou des lianes inter-arbres suffisent-elles ?

---

*Document C — clôt la trilogie COSMOS Plugin Infrastructure. Voir Doc A (noyau & contrat) et Doc B (Plugin Cyber).*
*Référence interne : `docs/SCYFORGE_SEMANTIC_TREE_ARCHITECTURE_V2.md` (Nœud Vivant, connexion Tree↔KG↔KB).*

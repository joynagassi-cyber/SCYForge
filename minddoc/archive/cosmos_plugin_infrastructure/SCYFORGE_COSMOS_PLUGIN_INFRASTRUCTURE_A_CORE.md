<!--
ARCHIVE — RÉFÉRENCE HISTORIQUE
Cette architecture "Plugin" a été abandonnée au profit de COSMOS v5.
Le signal utile (KB→KG→STB, 8 intentions, 6 viz noyau) a été recyclé dans COSMOS v5.
Ne pas utiliser ce document comme référence d'architecture active.
Date d'archivage : 2026-07-02
-->

# SCYForge — COSMOS Plugin Infrastructure (A) : le Noyau Extensible [ARCHIVÉ]

> **Statut** : architecture fondatrice. **Aucun code.** Document A de 3 (A=noyau, B=Plugin Cyber, C=Arborisation KG & Insights).
> **Vision long terme** : SCYForge est une **infrastructure de transformation du savoir en compréhension, rétention, maîtrise et autonomie**. COSMOS n'est pas un produit cyber : c'est le **substrat de visualisation** sur lequel chaque secteur branche son **Plugin**.
> **Horizon** : 3 secteurs en 24 mois — **Cyber (#1)** → **Santé/Finance régulé (#2)** → **#3 à définir**.

---

## 0. La thèse en une phrase

> On ne construit pas « COSMOS pour la cyber ». On construit un **noyau COSMOS neutre** + un **contrat de plugin**, et chaque secteur ajoute une **couche** que personne ne peut copier sans refaire tout le temps d'apprentissage qu'on a investi. **Chaque couche est une brique du moat irréversible.**

---

## 1. Pourquoi « plugin » et pas « modes en dur »

### 1.1 Le piège à éviter (énoncé par le fondateur)
Si on code les 26 modes « en dur pour la cyber », alors :
- chaque nouveau secteur = **réécriture / refactor massif** de COSMOS,
- le savoir accumulé en cyber ne se **capitalise** pas dans une structure réutilisable,
- on devient un produit vertical fragile, pas une infrastructure.

### 1.2 L'approche visionnaire retenue
COSMOS = **noyau invariant** (rendu, physique, lentilles, sélection) + **plugins sectoriels** (les modes, leurs intentions, leurs règles d'orchestration). Ajouter un secteur = **ajouter un plugin**, jamais toucher au noyau.

> **Règle d'or #1** : *le noyau ne connaît aucun secteur.* Il ne sait pas ce qu'est « la cyber » ou « la finance ». Il sait rendre, sélectionner, orchestrer. Le sens vient du plugin.

### 1.3 Un « Plugin COSMOS » n'est PAS une petite extension
Définition précise (fondateur) : un Plugin COSMOS est une **couche métier vaste** qui contient :
- **plusieurs modes de visualisation** (pas un seul),
- chacun **dynamique** (réagit à l'état du savoir : SMI, drift, couverture),
- **orchestrés par des agents autonomes** qui **choisissent** la visualisation selon le cas d'usage,
- une **matrice d'intentions** `(problème métier, but) → visualisation` propre au secteur,
- un **mapping vers l'ontologie du secteur** (ATT&CK pour cyber, etc.).

---

## 2. Architecture en couches

```
┌──────────────────────────────────────────────────────────────────┐
│                        PLUGINS SECTORIELS                          │
│   [ Plugin CYBER ]   [ Plugin SANTÉ/FINANCE ]   [ Plugin #3 ]      │
│   modes + intentions + ontologie + règles d'orchestration agents   │
└───────────────────────────────▲──────────────────────────────────┘
                                 │  CONTRAT DE PLUGIN (stable)
┌───────────────────────────────┴──────────────────────────────────┐
│                        NOYAU COSMOS (neutre)                       │
│  • Mode Runtime      : cycle de vie d'un mode (mount/update/render)│
│  • Intent Resolver   : (problème, but, état STB) → UN mode         │
│  • Agent Orchestration Bus : agents choisissent/composent les modes│
│  • Render Engines    : 5 moteurs (Three.js, G6, G2, D3, Nivo…)     │
│  • Lens System       : fisheye, semantic lenses, reveal-by-relev.  │
│  • Trust System      : intention déclarée, anti-bruit visuel       │
└───────────────────────────────▲──────────────────────────────────┘
                                 │
┌───────────────────────────────┴──────────────────────────────────┐
│          SUBSTRAT DONNÉES : Semantic Tree ↔ KG ↔ KB (cf. Doc C)    │
└────────────────────────────────────────────────────────────────────┘
```

### 2.1 Ce que le noyau fournit (déjà partiellement spécifié dans `minddoc/s04`)
- **26 modes** existants → deviennent une **bibliothèque de primitives de rendu** réutilisables par les plugins (un plugin *référence* des modes, il ne les réécrit pas).
- **5 moteurs de rendu** (Three.js, G6, G2, D3, Nivo, + WebGPU) → neutres, pilotés par les modes.
- **Lens System / Fisheye / Reveal-by-relevance** → mécaniques d'interaction neutres.
- **Trust System** → garantit qu'aucun mode ne s'affiche sans intention (cf. §5).

### 2.2 Ce que le plugin fournit
- la **liste des intentions** du secteur,
- pour chaque intention : le(s) mode(s) à composer + leur **binding** sur l'ontologie,
- les **règles d'orchestration** (quel agent déclenche quoi, quand),
- les **bornes** (profondeur d'arbre, seuils SMI propres au secteur si besoin).

---

## 3. Le Contrat de Plugin (l'interface stable — le cœur du moat)

> C'est la pièce qui rend l'extension possible **sans réécriture**. Tant que ce contrat est stable, on peut ajouter l'infini de secteurs.

### 3.1 Les 6 éléments qu'un plugin DOIT déclarer

| # | Élément | Rôle | Exemple cyber |
|---|---|---|---|
| 1 | **Ontologie sectorielle** | le vocabulaire & la hiérarchie du domaine | ATT&CK (tactiques→techniques→sous-techniques) |
| 2 | **Source de criticité** | comment pondérer le 80/20 | densité de règles Sigma |
| 3 | **Matrice d'intentions** | `(problème, but) → mode(s)` | « voir mes angles faibles » → Treemap densité+SMI |
| 4 | **Bindings de modes** | comment un mode lit le STB du secteur | nœud=technique, couleur=SMI, taille=densité |
| 5 | **Règles d'orchestration** | quel agent choisit quelle visu, quand | ARENA pendant un exercice → Sankey kill-chain |
| 6 | **Scénarios de pression** | situations à éprouver | chaîne APT29 (79 étapes) |

### 3.2 Invariant : le plugin ne réimplémente jamais le rendu
Un plugin **déclare** (data + règles), il ne **code pas** de moteur. Cela garantit que la qualité de rendu (60 FPS, lentilles, accessibilité) est mutualisée et que les plugins restent **légers à produire mais riches en valeur**.

> **Règle d'or #2** : *un plugin est une déclaration, pas une implémentation de rendu.* Tout le rendu vit dans le noyau.

### 3.3 Pourquoi ce contrat crée un moat irréversible
- Chaque plugin encode du **jugement métier durement acquis** (quelle visu pour quel problème réel). Ce n'est pas du code copiable : c'est du **temps d'apprentissage terrain**.
- Plus on ajoute de plugins, plus le noyau se **durcit et se généralise** → chaque nouveau secteur est **plus rapide** à brancher (avantage composé).
- Un concurrent doit refaire **et** le noyau **et** chaque couche métier **et** le temps d'apprentissage. **Le moat n'est pas le code, c'est le temps accumulé.**

---

## 4. Orchestration par agents autonomes (le « dynamique »)

### 4.1 Les modes ne sont pas choisis par menu — ils sont choisis par agents
Conformément à la directive : *les entreprises veulent une solution, pas des choix.* Le noyau expose un **Agent Orchestration Bus** : les agents ASCENT (VISUAL-CRITIC en chef d'orchestre visuel, GOAL-INTERPRETER pour l'intention) **résolvent et composent** la visualisation.

```
   Question/objectif utilisateur
        │
   GOAL-INTERPRETER → intention normalisée
        │
   INTENT RESOLVER (noyau) + Matrice du Plugin (secteur)
        │
   → sélectionne UN mode (ou compose 2-3 en vue liée)
        │
   VISUAL-CRITIC valide : intention claire ? pas de bruit ? lisible ?
        │
   RENDER (moteur neutre)
```

### 4.2 Composition, pas juxtaposition
Un agent peut **composer** plusieurs modes en une vue cohérente (ex. Sunburst du STB + panneau Radar SMI lié). L'utilisateur reçoit **une** solution intégrée, jamais un sélecteur de 26 boutons.

> **Règle d'or #3** : *zéro mode affiché sans intention résolue par un agent.* Le menu n'existe pas pour l'utilisateur final.

---

## 5. Trust System : l'intention comme garde-fou

Repris/étendu de `minddoc/s04/cosmos_trust_system` :
- chaque rendu porte une **intention déclarée** (« cette vue répond à : … »),
- le VISUAL-CRITIC **refuse** un rendu qui n'a pas d'intention ou qui sur-charge (anti-illusion de compétence : un beau dessin n'est pas une compréhension),
- traçabilité : chaque élément visuel pointe vers sa **source KB** et son **nœud STB** (cf. Doc C).

---

## 6. Roadmap des plugins (24 mois, indicatif)

| Phase | Secteur | Plugin | Ce qui se durcit dans le noyau |
|---|---|---|---|
| M0–M8 | **Cyber** (#1) | Plugin Cyber (Doc B) | Intent Resolver, Orchestration Bus, contrat v1 |
| M8–M16 | **Santé/Finance régulé** (#2) | Plugin Régulé | généralisation criticité (conformité ≠ densité Sigma) |
| M16–M24 | **#3 (à définir)** | Plugin #3 | preuve que le contrat tient sans refactor |

> Critère de succès du noyau : **brancher le plugin #2 ne doit RIEN casser dans le plugin #1.** C'est le test du moat irréversible.

---

## 7. Questions ouvertes pour A (à trancher avant code)

1. **Granularité d'un mode** : un mode = un type de rendu (Sunburst) ou un mode = une intention complète (peut combiner 2 rendus) ?
2. **Versionnement du contrat** : comment fait-on évoluer le contrat de plugin sans casser les plugins existants (semver ? capacités déclaratives ?).
3. **Frontière noyau/plugin pour les lentilles** : la fisheye est-elle 100 % noyau, ou un plugin peut-il déclarer ses propres lentilles métier ?
4. **Performance multi-plugin** : lazy-load par secteur (déjà prévu) — confirme-t-on un plugin chargé à la fois ?

---

*Document A. Suite : Doc B (Plugin Cyber détaillé), Doc C (Arborisation KG & moteur d'insights).*
*Réf. : `minddoc/s04_scy_cosmos_visualization_engine/` (26 modes, 5 moteurs, trust system, lens system).*

# SCYForge — COSMOS v5 : Moteur de Rendu Intégré + VizSpec Catalog

> **Statut** : architecture active. **Aucun code.**
> **Remplace** : l'architecture "Plugin" (docs A/B/C archivés).
> **Philosophie** : COSMOS est un **moteur de rendu neutre** + une **bibliothèque de visualisations indexée** + un **sélecteur intention → viz**. Le choix de visualisation est une **fonction pure**, pas un plugin déclaratif.

---

## 0. La thèse en une phrase

> On ne construit pas « COSMOS pour la cyber » via des plugins. On construit un **noyau COSMOS neutre** qui sait **rendre**, **sélectionner** et **orchestrer** des visualisations. Chaque secteur déclare ses **Use Case Intentions** et ses **bindings** dans le domain pack — pas dans un plugin COSMOS. Ajouter un secteur = ajouter un domain pack, **zéro réécriture de COSMOS**.

---

## 1. Architecture en couches

```
┌──────────────────────────────────────────────────────────────────┐
│              COUCHE DOMAIN PACK (par secteur)                      │
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌───────────────┐  │
│  │ Cyber Pack       │  │ Santé/Finance    │  │ Plugin #3     │  │
│  │                  │  │ Régulé           │  │ (à définir)   │  │
│  │ • Ontologie      │  │ • Ontologie      │  │               │  │
│  │   ATT&CK         │  │   conformité     │  │               │  │
│  │ • Use Case       │  │ • Use Case       │  │               │  │
│  │   Intentions     │  │   Intentions     │  │               │  │
│  │   C1-C8          │  │   (HDS, PCI...)  │  │               │  │
│  │ • Viz Bindings   │  │ • Viz Bindings   │  │               │  │
│  │   (STB→viz)      │  │   (STB→viz)      │  │               │  │
│  │ • Orchestration  │  │ • Orchestration  │  │               │  │
│  │   Rules          │  │   Rules          │  │               │  │
│  └────────┬─────────┘  └────────┬─────────┘  └───────┬───────┘  │
│           │                     │                     │          │
│           └─────────────────────┼─────────────────────┘          │
│                                 │  CONTRAT DOMAIN PACK (D-020)  │
├─────────────────────────────────┼─────────────────────────────────┤
│                                 │                                  │
│  ┌──────────────────────────────┴─────────────────────────────┐  │
│  │              NOYAU COSMOS (neutre, invariant)                │  │
│  │                                                              │  │
│  │  • Intent Resolver   : (problème, but, état STB) → VizSpec  │  │
│  │  • VizSpec Catalog   : VizSpec[] indexé (90 entrées)        │  │
│  │  • Trust System      : intention déclarée, anti-bruit       │  │
│  │  • Agent Orchestration Bus : agents choisissent/composent   │  │
│  │  • Render Engines    : 5 moteurs neutres (G6, G2, Nivo,    │  │
│  │    React Flow, D3/Recharts, Three.js, Cosmograph)           │  │
│  │  • Lens System       : fisheye, semantic lenses             │  │
│  │  • Inline Capture    : screenshot inline + bouton ouvrir    │  │
│  │  • FSRS Coupling     : ré-exposition programmée V1/V4/V5    │  │
│  └──────────────────────────────▲──────────────────────────────┘  │
│                                 │                                  │
├─────────────────────────────────┼─────────────────────────────────┤
│                                 │                                  │
│  ┌──────────────────────────────┴──────────────────────────────┐  │
│  │          SUBSTRAT DONNÉES : KB ↔ KG ↔ STB (Doc C recyclé)    │  │
│  │  • KB : documents bruts, chunks, citations                   │  │
│  │  • KG : graphe plat, relations transverses (lianes)          │  │
│  │  • STB : Semantic Tree — DAG enraciné, pondéré 80/20         │  │
│  └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### 1.1 Ce que le noyau fournit (invariant, sector-agnostique)

- **VizSpec Catalog** : bibliothèque indexée de visualisations (`VizSpec[]`), chaque entrée étant un objet `{id, engine, dataShapes, intents, cognitiveEffects, maxNodes, requiresGPU, fallbackId, interactive, corePriority}`.
- **Intent Resolver** : fonction pure `(intent, dataShape, constraints) → VizSpec | null`. Résout la visualisation mathématiquement, pas créativement.
- **5 Render Engines** : Cosmograph (GPU massif), AntV G6 (node-link DAG), AntV G2 (statistique/hiérarchie), Nivo (React déclaratif), React Flow (DAG structuré), D3 (fallback bas niveau), Recharts (statistique simple), Three.js (3D immersif).
- **Trust System** : garantit qu'aucun rendu n'est affiché sans intention déclarée. Anti-illusion de compétence visuelle.
- **Agent Orchestration Bus** : les agents ASCENT (VISUAL-CRITIC, GOAL-INTERPRETER) résolvent et composent la visualisation.
- **Inline Capture Service** : capture canvas/serveur pour aperçu inline + bouton « ouvrir viz interactive ».
- **FSRS Coupling** : les viz noyau (V1/V4/V5) sont ré-exposées aux intervalles FSRS pour transformer la vue en trace mémoire.

### 1.2 Ce que le domain pack fournit (sectoriel, variable)

- **Ontologie sectorielle** : vocabulaire & hiérarchie du domaine (ATT&CK pour cyber).
- **Use Case Intentions** : matrice `(problème métier, but) → VizSpec intent(s)` — les 8 intentions C1-C8 pour le cyber.
- **Viz Bindings** : comment un VizSpec lit le STB du secteur (nœud=technique, couleur=SMI, taille=densité).
- **Orchestration Rules** : quel agent déclenche quelle intention, dans quel contexte runtime.
- **Source de criticité** : comment pondérer le 80/20 (densité Sigma en cyber, poids réglementaire en santé/finance).

### 1.3 Règle d'or (invariant)

> **Règle d'or #1** : *le noyau COSMOS ne connaît aucun secteur.* Il ne sait pas ce qu'est « la cyber » ou « la finance ». Il sait rendre, sélectionner, orchestrer. Le sens vient du domain pack.
>
> **Règle d'or #2** : *COSMOS ne génère JAMAIS d'image IA pour un concept qui a une visualisation mathématique dans le catalog.* L'image générative est réservée aux illustrations non-données (métaphores, décor pédagogique explicitement demandé).

---

## 2. Le contrat VizSpec (l'index de la bibliothèque)

### 2.1 Schéma d'une entrée

```typescript
type DataShape =
  | "network"          // nœuds + arêtes, non hiérarchique
  | "dag"              // graphe orienté acyclique (flux, roadmap)
  | "hierarchy"        // arbre / taxonomie (parent → enfants)
  | "matrix"           // relations n×n (corrélation, co-occurrence)
  | "flow"             // volumes transférés entre étapes
  | "timeseries"       // événements/valeurs ordonnés dans le temps
  | "multivariate"     // entités × N attributs comparables
  | "sequence"         // ordre linéaire d'éléments
  | "geospatial"       // coordonnées / régions

type ExplanatoryIntent =
  | "show_structure"       // « comment c'est organisé »
  | "show_relationships"   // « qu'est-ce qui est lié à quoi »
  | "show_flow"            // « comment ça circule / se transforme »
  | "show_sequence"        // « dans quel ordre ça s'est passé »
  | "compare"              // « qui est fort/faible où »
  | "show_distribution"    // « où se concentre la masse »
  | "show_hierarchy"       // « quoi contient quoi »
  | "show_causality"       // « qu'est-ce qui cause quoi (boucles) »
  | "show_state"           // « où j'en suis / verdict + confiance »

interface VizSpec {
  id: string                       // ex. "attack-graph", "mastery-tree"
  label: string                    // libellé lisible (langue tenant)
  engine: EngineId                 // quel moteur de rendu
  dataShapes: DataShape[]          // formes de données acceptées
  intents: ExplanatoryIntent[]     // intentions explicatives servies
  cognitiveEffects: CognitiveEffect[] // §2.2 — comprehension, analogy, anchoring, retention
  maxNodes: number                 // borne dure du moteur
  requiresGPU?: boolean            // cosmograph / three
  fallbackId?: string              // viz de repli si contrainte non remplie
  interactive: boolean             // supporte le bouton « ouvrir viz »
  corePriority?: 1 | 2 | 3         // 1 = viz noyau, 2 = prioritaire secteur, 3 = standard
  packBinding?: PackBindingRef     // comment le domain pack lie cette viz au STB
}
```

### 2.2 Cognitive Effects (les 4 critères de sélection noyau)

Une viz entre dans le noyau COSMOS **seulement si elle sert ≥ 3 des 4 effets** :

| Effet | Question de test |
|---|---|
| **Compréhension** | rend-il un concept abstrait *immédiatement* lisible ? |
| **Analogie** | active-t-il un modèle mental familier (carte, arbre, chronologie) ? |
| **Ancrage** | relie-t-il le nouveau savoir à une structure stable et répétée ? |
| **Rétention** | est-il *ré-exposé* dans le temps (couplable à APEX/FSRS) ? |

---

## 3. La sélection intention → viz (fonction pure)

### 3.1 Algorithme de résolution

La sélection n'est **jamais un choix créatif**. C'est une **fonction pure** `select(intent, dataShape, constraints) → VizSpec` :

```
[1] FILTRER  : VizSpec[] où intent ∈ intents ET dataShape ∈ dataShapes
[2] ÉCART    : retirer si maxNodes < taille du jeu OU (requiresGPU && !gpu)
[3] CLASSER  : corePriority (1=gagnante) → nb cognitiveEffects (≥3) → coût bundle
[4] FALLBACK : si la gagnante saute, suivre fallbackId
```

### 3.2 Table de correspondance de référence (intention × forme → viz)

| Intention explicative | Forme de données | Viz gagnante (moteur) | Fallback | Viz noyau§3.4 |
|---|---|---|---|---|
| `show_relationships` | network | Knowledge/Attack Graph (**G6**) | G6 Canvas / Cosmograph si massif | **V2** |
| `show_flow` | dag | Roadmap / Pipeline (**React Flow**) | d3 sankey | — |
| `show_flow` | flow | Sankey / Alluvial (**nivo/G2**) | d3 sankey | — |
| `show_sequence` | timeseries | Correlation Timeline (**recharts**) | nivo TimeRange | **V3** |
| `show_sequence` | sequence | Arc Diagram (**d3/G6**) | d3 arc | — |
| `show_hierarchy` | hierarchy | Sunburst / Treemap (**G2**) | nivo fallback | **V1** (tree) |
| `show_structure` | hierarchy | Mastery Tree (**G6 tree**) | nivo tree | **V1** |
| `compare` | multivariate | Radar (**recharts**) / Parallel Coord. (**d3**) | recharts radar | — |
| `show_distribution` | matrix | **Heatmap** ATT&CK (nivo/G2) | nivo heatmap | **V4** |
| `show_causality` | network+loops | Causal Loop Diagram (**G6**) | d3 force | — |
| `show_state` | multivariate | Decision & Confidence Gauge (**G2 gauge/recharts**) | recharts | **V6** |
| `show_state` | matrix | Autonomy Envelope grid (**custom/nivo heatmap**) | nivo heatmap | **V5** |

---

## 4. Les 6 visualisations noyau (le 20% qui produit 80% de la compréhension)

Ces 6 viz sont les entrées `corePriority: 1` du catalog. Elles gagnent la sélection dès qu'elles sont éligibles, indépendamment du secteur.

| # | Viz | Ce qu'elle montre | Analogie | Effets servis | Moteur |
|---|---|---|---|---|---|
| **V1** | **Arbre de maîtrise (Mastery Tree)** | tronc → branches → feuilles, coloré par SMI | arbre de compétences RPG | Compréhension · Ancrage · Rétention | G6 tree (compact-box) |
| **V2** | **Kill chain / graphe d'attaque** | entités + actions d'un incident, déroulé par phase | fil d'enquête sur liège | Compréhension · Analogie | G6 node-link |
| **V3** | **Timeline de corrélation** | alertes chronologiques, regroupement des événements liés | frise chronologique | Compréhension · Analogie | recharts / nivo TimeRange |
| **V4** | **Heatmap ATT&CK** | couverture tactiques×techniques, code couleur multi-phase | carte de chaleur météo | Ancrage · Compréhension | G2 / nivo heatmap |
| **V5** | **Carte d'autonomie (Envelope grid)** | matrice classe×risque → mode (shadow/guarded/autonomous/handoff) | tableau de bord permis | Ancrage · Rétention | custom / nivo heatmap |
| **V6** | **Jauge de décision & confiance** | verdict rendu + niveau de confiance + preuve associée | cadran / feu tricolore | Compréhension · Rétention | G2 gauge / recharts |

> **Pourquoi ces 6** : V1 et V5 sont les structures stables ré-exposées (ancrage/rétention, couplage APEX/FSRS) ; V2/V3 sont les récits d'incident (compréhension via séquence) ; V4 branche la priorité Pareto du domaine ; V6 répond au frein 2026 (confiance/visibilité de la décision). Tout le reste (camemberts de volume, compteurs BAU, gauges cosmétiques) est hors noyau : haute fréquence, faible transfert.

---

## 5. Les Use Case Intentions du Domain Pack (remplace le "Plugin")

Chaque domain pack déclare ses **Use Case Intentions** — pas des plugins COSMOS. Ces intentions sont la **v1 métier** du secteur.

### 5.1 Intentions Cyber (C1-C8, v1)

| # | Use case interne (problème réel) | But | Viz(s) noyau composé(s) | Données STB |
|---|---|---|---|---|
| C1 | « Une recrue doit comprendre NOTRE périmètre en 1 min » | Onboarding express défendable | **V1** Sunburst / Mastery Tree | STB org |
| C2 | « Où sont nos angles faibles de détection ? » | Prioriser l'effort 80/20 | **V4** Treemap densité × SMI | densité + couverture interne |
| C3 | « Comment se déroule l'attaque que nous avons subie ? » | Comprendre une kill-chain réelle | **V2** Sankey / kill-chain graph | chaîne d'incident mappée ATT&CK |
| C4 | « Quel rôle fait quoi, et qui dépend de qui ? » | Clarifier rôles & disciplines | Concept Map / Arc Diagram | taxonomie de rôles interne |
| C5 | « D'où vient cette règle interne, qu'a-t-elle engendré ? » | Ouvrir un Nœud Vivant | Nœud-arbre (fondation + dérivés datés) | STB org, anneaux de croissance |
| C6 | « Mon équipe est-elle prête sur la tactique X ? » | Mesurer la readiness | **V6** Radar SMI par tactique | SMI par sous-arbre |
| C7 | « Quelles règles strictes ne doivent JAMAIS être violées ? » | Ancrer les non-négociables | **V4** Heatmap criticité × conformité | règles internes critiques |
| C8 | « Comment cet incident se relie-t-il à nos procédures ? » | Relier incident ↔ SOP | Hierarchical Edge Bundling | incidents ↔ SOP internes |

### 5.2 Bindings de viz (comment une viz lit le STB du secteur)

Convention partagée par toutes les viz d'un même domain pack :

| Propriété visuelle | Donnée STB | Exemple Cyber |
|---|---|---|
| **nœud** | entité du secteur | technique ATT&CK ou concept interne greffé |
| **couleur** | SMI (0→1) | rouge 0 → or 100 |
| **taille / poids** | criticité | densité Sigma × pertinence interne |
| **profondeur** | strate de l'arbre | tronc=tactique, branche=technique, feuille=SOP |
| **horodatage** | anneau de croissance | quand la connaissance a été greffée |

### 5.3 Règles d'orchestration (quel agent déclenche quelle intention)

| Contexte runtime | Agent déclencheur | Intention → Viz |
|---|---|---|
| Début d'onboarding | GOAL-INTERPRETER | C1 → V1 (vue 1 min) |
| Exercice sous pression | ARENA | C3 → V2 (kill-chain) |
| Après session de révision | PERFORMANCE-ANALYZER | C6 → V6 (radar SMI) |
| Détection zone faible | DRIFT-GUARDIAN | C2 → V4 (angles faibles) |
| Consultation règle interne | LEARNING-CONDUCTOR | C5 → Nœud Vivant |

---

## 6. Le substrat de données KB → KG → STB (recyclé de Doc C)

Doc C (Arborisation) est **recyclé comme substrat de données**, pas comme plugin. Les 3 couches restent :

```
   ┌───────────────────────────────────────────────────────────────┐
   │ KNOWLEDGE BASE (KB)  — la PREUVE                              │
   │   documents bruts, chunks, citations. « Qu'est-ce que la      │
   │   source dit exactement ? »  Source-grounded, vérifiable.     │
   └───────────────────────────────▲──────────────────────────────┘
                                    │ extraction entités/relations
   ┌───────────────────────────────┴──────────────────────────────┐
   │ KNOWLEDGE GRAPH (KG) — la TOPOLOGIE                           │
   │   graphe plat, démocratique. « Qu'est-ce qui est relié à quoi?»│
   │   Riche, exhaustif, MAIS sans direction d'apprentissage.      │
   └───────────────────────────────▲──────────────────────────────┘
                                    │ ★ ARBORISATION ★ (le 0→1)
   ┌───────────────────────────────┴──────────────────────────────┐
   │ SEMANTIC TREE (STB) — la DIRECTION                            │
   │   DAG enraciné, pondéré 80/20. « Par où apprendre ? Quoi     │
   │   maîtriser d'abord ? »                                       │
   │   Chaque nœud = un Nœud Vivant (fondation + dérivés datés).   │
   └────────────────────────────────────────────────────────────────┘
```

**Le STB ne remplace pas le KG** : il le **discipline**. Les arêtes du KG non hiérarchiques restent disponibles comme **lianes transverses** — ce sont elles qui nourrissent le moteur d'insights (§7).

### 6.1 Pipeline d'arborisation (5 étapes — DAG-ARCHITECT)

| Étape | Ce qu'elle fait | Qui la porte | Comment elle décide |
|---|---|---|---|
| ① **Racinage** | choisit le tronc | DAG-ARCHITECT | centralité KG + criticité pack + validation humaine si ambigu |
| ② **Pondération** | poids 80/20 par nœud | DAG-ARCHITECT | source de criticité du pack (densité Sigma en cyber) |
| ③ **Hiérarchisation** | oriente les arêtes | DAG-ARCHITECT | profondeur sémantique : général→spécifique |
| ④ **Élagage** | enlève le bruit | DRIFT-GUARDIAN | redondance, faible criticité, contradiction |
| ⑤ **Lianage** | garde les liens transverses | DAG-ARCHITECT | arêtes inter-branches à fort potentiel d'insight |

---

## 7. Le Moteur d'Insights (créativité bornée par le secteur)

### 7.1 D'où viennent les insights ? Des LIANES, pas du tronc

- Le **tronc** sert à **apprendre/maîtriser** (direction).
- Les **lianes** (arêtes transverses du KG conservées à l'étape ⑤) servent à **créer** : ce sont les **ponts inattendus** entre branches distantes.

> Un insight = **une liane à fort potentiel entre deux sous-arbres éloignés.**

### 7.2 Deux modes selon le contexte

| Contexte | Ce que le moteur produit | Exemple |
|---|---|---|
| **Projet d'apprentissage ouvert** (R&D, exploration) | **Créativité** : lier domaines éloignés → idées nouvelles | chercheur relie physique × IT → concept inédit |
| **Cybersécurité (décision sous contrainte)** | **Insights / décisions sûres** : pas de créativité libre, mais prises de décision fiables | analyste relie 3 incidents → règle de détection nouvelle |

> Même moteur, deux sorties selon le pack : *créativité* (exploration) vs *insight décisionnel* (contrainte). C'est le domain pack qui règle le curseur via `PackConfigProvider`.

---

## 8. Trust System : l'intention comme garde-fou

- Chaque rendu porte une **intention déclarée** (« cette vue répond à : … »).
- Le VISUAL-CRITIC **refuse** un rendu qui n'a pas d'intention ou qui sur-charge (anti-illusion de compétence).
- Traçabilité : chaque élément visuel pointe vers sa **source KB** et son **nœud STB**.
- Aucun mode affiché sans intention résolue par un agent. Le menu n'existe pas pour l'utilisateur final.

---

## 9. Roadmap d'extension sectorielle (24 mois, indicatif)

| Phase | Secteur | Domain Pack | Ce qui se durcit dans COSMOS |
|---|---|---|---|
| M0–M8 | **Cyber** (#1) | Cyber Pack | Intent Resolver v1, VizSpec catalog v1, contrat pack v1 |
| M8–M16 | **Santé/Finance régulé** (#2) | Régulé Pack | généralisation criticité (conformité ≠ densité Sigma), nouvelles intentions sectorielles |
| M16–M24 | **#3 (à définir)** | Pack #3 | preuve que le catalog + resolver tiennent sans refactor |

> **Critère de succès du noyau** : brancher le Pack Régulé ne doit RIEN casser dans le Pack Cyber. Si c'est vrai, l'architecture est visionnaire, pas verticale.

---

## 10. Questions ouvertes pour COSMOS v5 (à trancher avant code)

1. **Granularité d'une intention** : une intention = un type de rendu (Sunburst) ou une intention = une intention complète (peut combiner 2 rendus en vue liée) ?
2. **Versionnement du catalog** : comment ajouter des VizSpec sans casser les résolutions existantes (semver sur les intent IDs ?) ?
3. **Frontière noyau/pack pour les lentilles** : la fisheye est-elle 100% noyau, ou un pack peut-il déclarer ses propres lentilles métier ?
4. **Performance multi-pack** : lazy-load par secteur — confirme-t-on un seul pack chargé à la fois ?

---

*COSMOS v5 — Architecture active. Remplace l'architecture Plugin (docs A/B/C archivés).*
*Signal recyclé : KB→KG→STB (Doc C), 8 Intentions C1-C8 (Doc B), 6 viz noyau (Feature Report §14).*
*Réf. : `SCYFORGE_FEATURE_REPORT.md §15` (VizSpec catalog, grammaire intention→viz), `minddoc/s04_scy_cosmos_visualization_engine/` (26 modes presets, 5 engines, trust system).*

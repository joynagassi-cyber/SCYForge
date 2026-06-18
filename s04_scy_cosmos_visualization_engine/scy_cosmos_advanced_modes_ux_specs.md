# Spécifications UX/UI Détaillées des Modes Visuels Avancés COSMOS v4
**Document ID** : SPEC-COSMOS-ADVANCED-UX-V4  
**Date** : 2026-06-09  
**Statut** : DÉPLOYABLE (ZÉRO IMPROVISATION POUR LES DESIGNERS & FRONTENDS)  
**Moteurs concernés** : `@xyflow/react` (React Flow), `@antv/g6`, `@antv/g2`, `nivo`, `d3`, `recharts`  

---

## 🧭 Table des Matières
1. [Introduction : Philosophie de Conception de l'Interactivité Spatialisée](#introduction)
2. [Spécifications UX/UI Détaillées (D-UX-MODES-001 à 017)](#specifications-uxui)
   - [M9 : Concept Map (G6)](#m9--concept-map-g6)
   - [S10 : Sunburst Hiérarchique (G2)](#s10--sunburst-g2)
   - [S11 : Treemap Conceptuel (G2)](#s11--treemap-g2)
   - [S12 : Chord Diagram (Nivo)](#s12--chord-diagram-nivo)
   - [M13 : Sankey / Alluvial (Nivo)](#m13--sankey--alluvial-nivo)
   - [M14 : Radar Comparaison (Recharts)](#m14--radar-comparaison-recharts)
   - [M15 : Parallel Coordinates (D3)](#m15--parallel-coordinates-d3)
   - [M16 : Heatmap Matricielle (Nivo)](#m16--heatmap-matricielle-nivo)
   - [M17 : Argument Map (React Flow)](#m17--argument-map-react-flow)
   - [M18 : Causal Loop Diagram (G6)](#m18--causal-loop-diagram-g6)
   - [M19 : Circle Packing (Nivo)](#m19--circle-packing-nivo)
   - [M20 : Arc Diagram (D3)](#m20--arc-diagram-d3)
   - [M21 : Hierarchical Edge Bundling (D3)](#m21--hierarchical-edge-bundling-d3)
   - [M22 : Semantic Zoom Graph (Cosmos)](#m22--semantic-zoom-graph-cosmos)
   - [M23 : 3D Knowledge Space (Three.js)](#m23--3d-knowledge-space-three-js)
   - [M24 : Voronoi Concept Map (D3)](#m24--voronoi-concept-map-d3)
   - [M25 : Knowledge Cards (React Flow)](#m25--knowledge-cards-react-flow)

---

## 🧭 Introduction : Philosophie de Conception de l'Interactivité Spatialisée {#introduction}

Dans COSMOS v4, une interface de visualisation n'est pas un dessin statique. C'est un **espace d'interactions physiques**. Pour éliminer la frustration des interfaces traditionnelles (les tooltips qui cachent le contenu, les zooms saccadés, ou les boutons trop petits sur mobile), chaque mode respecte 3 principes universels de conception (Règles d'Or) :
1. **Priorité au tactile (Touch-First)** : Toutes les actions de navigation complexes (clics, doubles-clics, drag) sont dimensionnées avec des zones de collision d'au moins **44×44px** pour être utilisables sur smartphone et tablette [D-MOB-001].
2. **Animation progressive (Physics-based transition)** : Aucune transition brusque. Les caméras se déplacent en interpolant les forces physiques de glissement (spring physics, tension: 170, friction: 26).
3. **Disclosure comportementale (Information à la demande)** : L'information détaillée n'est révélée qu'au clic ou lors de stationnements prolongés (Behavioral Disclosure), laissant l'espace visuel épuré par défaut.

---

## ⚙️ Spécifications UX/UI Détaillées (D-UX-MODES-001 à 017) {#specifications-uxui}

---

### D-UX-MODES-001 : M9 — Concept Map (G6)

```
       [ Concept A ] ──────────( verbe sémantique )──────────► [ Concept B ]
```

* **Le Problème résolu** : Représenter de véritables propositions logiques de connaissances Novakiennes.
* **Layout Visuel** :
  * **Nœuds** : Cercles légers. Couleur de fond ∝ domaine, texte central noir gras (`#111827`).
  * **Arêtes** : Courbes incurvées de relations sémantiques. Un rectangle de texte semi-transparent (`background: rgba(255,255,255,0.85)`) est centré sur le tracé de l'arête pour afficher la relation (ex: *"utilise"*, *"inhibe"*, *"est requis pour"*).
* **Interactions Utilisateur** :
  * **Clic sur une arête** : Met en valeur les deux concepts connectés et assombrit le reste du graphe (`opacity: 0.15`). Affiche un panneau d'explication de la validité de ce lien.
  * **Raccourci `E`** : Ouvre un éditeur de texte rapide pour modifier le verbe de la relation sémantique sélectionnée.
* **Failure Modes & Tiers** :
  * Si la densité du graphe est trop élevée (clutter), le plugin de lentille **Fisheye (`D-UX-001`)** s'active automatiquement au déplacement de la souris pour agrandir localement la zone sous le curseur et rendre lisible les étiquettes de relations.

---

### D-UX-MODES-002 : S10 — Sunburst Hiérarchique (G2)

```
        ┌──────────────────────────────────────────────┐
        │                 [ Racine ]                   │
        │         ┌───────────┴───────────┐            │
        │     [ Branche A ]           [ Branche B ]    │
        │     ┌───┴───┐               ┌───┴───┐        │
        │   [A1]     [A2]           [B1]     [B2]      │
        └──────────────────────────────────────────────┘
```

* **Le Problème résolu** : Naviguer de manière fluide à travers des ontologies taxonomiques de plus de 4 niveaux de profondeur.
* **Layout Visuel** :
  * **Anneaux concentriques** : Chaque niveau hiérarchique est un anneau. Le centre représente la racine de la matière, l'anneau le plus externe représente les concepts terminaux (nœuds feuilles).
  * **Secteurs angulaires** : La largeur angulaire de chaque secteur est proportionnelle au nombre de sous-concepts qu'il contient. Le code couleur indique le SMI moyen du sous-domaine.
* **Interactions Utilisateur** :
  * **Clic sur un secteur** : Déclenche l'animation de drill-down (`G2 native drillDown`). Le secteur cliqué glisse et s'étend pour devenir le nouvel anneau central (racine), recalculant instantanément l'échelle des anneaux enfants extérieurs.
  * **Breadcrumb (Fil d'Ariane)** : Un breadcrumb horizontal en haut à gauche montre la trajectoire de drill-down (ex: `Racine > Frontend > React > State`). Cliquer sur un jalon remonte la vue à cette échelle.
* **Failure Modes & Tiers** :
  * Sur les appareils `LOW/COMPAT` tier, la profondeur maximale d'affichage est limitée à 3 niveaux. Les niveaux inférieurs ne sont rendus que lors du drill-down pour préserver la mémoire.

---

### D-UX-MODES-003 : S11 — Treemap Conceptuel (G2)

```
┌─────────────────────────────────┬──────────────────────────────┐
│                                 │                              │
│                                 │      Concept B (SMI: 45)     │
│       Concept A (SMI: 84)       ├──────────────────────────────┤
│                                 │      Concept C (SMI: 62)     │
│                                 │                              │
└─────────────────────────────────┴──────────────────────────────┘
```

* **Le Problème résolu** : Comparer visuellement la masse documentaire et l'état de maîtrise de différents sous-domaines.
* **Layout Visuel** :
  * **Rectangles imbriqués** : Division géométrique de l'espace (algorithme Squarify). La surface d'un rectangle $\propto$ nombre de cartes APEX associées.
  * **Couleurs** : Dégradé du Rouge (SMI 0) au Vert/Or (SMI 100).
* **Interactions Utilisateur** :
  * **Double-clic** : Drill-down. Le rectangle sélectionné s'agrandit pour occuper tout le viewport, révélant ses sous-rectangles de détails.
  * **Labels Clamping** : Le label textuel n'est affiché que si la largeur et la hauteur du rectangle permettent d'écrire le titre avec une taille de police minimale de 10px. Si la place est insuffisante, le texte est remplacé par une icône d'alerte ou un point d'interrogation.
* **Failure Modes & Tiers** :
  * En cas de resize de la fenêtre, le recalcul de la partition Squarify est debounce à 150ms pour éviter de bloquer l'interface.

---

### D-UX-MODES-004 : S12 — Chord Diagram (Nivo)

```
        / \
      /     \     Rubans d'épaisseurs sémantiques reliant 
     |   █   |    les concepts disposés circulairement
      \     /
        \ /
```

* **Le Problème résolu** : Rendre lisibles les relations croisées bidirectionnelles denses et les densités de co-occurrence de concepts.
* **Layout Visuel** :
  * **Couronne extérieure** : Les domaines d'apprentissage sont disposés circulairement à la périphérie sous forme d'arcs de couleurs distinctes.
  * **Rubans de liaisons** : De fins rubans s'étendent à l'intérieur de la couronne pour connecter les arcs. L'épaisseur d'un ruban à sa source $\propto$ force d'association sémantique.
* **Interactions Utilisateur** :
  * **Survol d'un arc périphérique** : Assombrit instantanément l'intégralité du diagramme à l'exception des rubans émanant de l'arc survolé, mettant en valeur son faisceau d'influence.
  * **Clic sur un ruban** : Ouvre un tooltip détaillé expliquant pourquoi ces deux matières s'entrecroisent et liste les 3 concepts partagés majeurs.
* **Failure Modes & Tiers** :
  * Limite stricte de calcul de matrice fixée à 150 nœuds maximum pour éviter l'enchevêtrement des rubans au centre du diagramme.

---

### D-UX-MODES-005 : M13 — Sankey / Alluvial (Nivo)

```
┌──────────────┐          flux de connaissances          ┌──────────────┐
│  Concepts A  ├────────────────────────────────────────►│  Concepts B  │
└──────────────┘                                         └──────────────┘
```

* **Le Problème résolu** : Visualiser les flux de progression, de transfert d'informations et les points de blocage cognitif des apprenants.
* **Layout Visuel** :
  * **Nœuds verticaux** : Des blocs rectangulaires disposés en colonnes représentant des étapes temporelles d'apprentissage.
  * **Flux d'écoulement** : Des rubans fluides horizontaux de largeurs variables reliant les colonnes. Largeur du ruban $\propto$ volume d'apprenants ou de concepts traversant cette étape.
* **Interactions Utilisateur** :
  * **Survol d'un ruban** : Affiche le taux de réussite exact, le temps d'étude moyen, et la diminution du taux de mémorisation FSRS de la cohorte d'apprenants à ce niveau.
  * **Double-clic sur un bloc d'étape** : Ouvre le nœud de cursus ASCENT associé pour lancer une session de remédiation ciblée.
* **Failure Modes & Tiers** :
  * Les flux représentant moins de $2\%$ de la masse totale de données sont automatiquement fusionnés sous un ruban générique "Autres flux" pour désencombrer l'espace visuel.

---

### D-UX-MODES-006 : M14 — Radar Comparaison (Recharts)

```
                   [ Rétention ]
                         ▲
                         │
     [ Cohérence ] ◄─────┼─────► [ Profondeur ]
                   \   █ │   /
                     \   │ /
                       ▼
                 [ Enseignement ]
```

* **Le Problème résolu** : Permettre une auto-évaluation métacognitive instantanée en superposant ses performances réelles à des profils cibles.
* **Layout Visuel** :
  * **Axes radiaux** : 5 axes sémantiques représentant les dimensions du SMI (Rétention, Profondeur, Enseignement, Métacognition, Cohérence).
  * **Polygone de performance** : Un polygone translucide coloré en bleu (`rgba(99, 102, 241, 0.4)`) montrant l'état de maîtrise actuel de l'utilisateur.
  * **Polygone cible** : Un polygone en pointillés verts ou rouges représentant le seuil exigé pour valider le jalon d'apprentissage.
* **Interactions Utilisateur** :
  * **Clic sur un sommet d'axe** : Déclenche l'affichage d'un tiroir de détails listant les concepts exacts responsables de la déformation du polygone (ex: *"Vous avez un déficit en Enseignement dû aux 3 sessions Teach-Back STUDENT AI en suspens"*).

---

### D-UX-MODES-007 : M15 — Parallel Coordinates (D3)

```
     Difficulté         SMI          Date Ingestion     Stabilité FSRS
         ║               ║                 ║                  ║
         ╠═══════════════╬═════════════════╬══════════════════╣
         ║               ║                 ║                  ║
```

* **Le Problème résolu** : Filtrer de manière interactive et multicritère des milliers de concepts sur des axes de données parallèles.
* **Layout Visuel** :
  * **Axes verticaux parallèles** : Chaque axe représente une dimension physique (Difficulté, SMI, Date d'ingestion, Stabilité FSRS).
  * **Trajectoires de concepts** : Chaque concept est une ligne brisée horizontale traversant les axes verticaux à la valeur correspondante.
* **Interactions Utilisateur** :
  * **Brushing (Glissement de curseur)** : L'utilisateur clique et fait glisser son curseur sur n'importe quel axe vertical pour définir une zone d'intérêt (ex: sélectionner l'intervalle de difficulté 7 à 10). Toutes les trajectoires de concepts ne passant pas par cet intervalle sont instantanément grisées (`opacity: 0.05`).
* **Failure Modes & Tiers** :
  * Les calculs de coordonnées de trajectoires des 5 000 concepts maximaux du mode s'exécutent dans un Web Worker.

---

### D-UX-MODES-008 : M16 — Heatmap Matricielle (Nivo)

```
        ┌───┬───┬───┐
        │ █ │ ░ │ ▒ │   Grille de cellules colorées de manière
        ├───┼───┼───┤   dégradée selon la force d'association
        │ ░ │ █ │ ░ │   sémantique cosinus des concepts
        └───┴───┴───┘
```

* **Le Problème résolu** : Identifier d'un coup d'œil les redondances sémantiques ou les opportunités de fusions de concepts au sein d'un projet.
* **Layout Visuel** :
  * **Grille carrée de cellules** : L'intensité de la couleur d'une cellule (de blanc à violet foncé) $\propto$ similarité cosinus sémantique entre le concept de la ligne et celui de la colonne.
  * **Alerte de redondance** : Un symbole d'avertissement `⚠️` s'affiche si la similarité dépasse $0.95$.
* **Interactions Utilisateur** :
  * **Clic sur une cellule** : Ouvre un panneau d'explication de la similarité, proposant à l'utilisateur de fusionner les deux concepts redondants ou d'établir un lien de continuité.
* **Failure Modes & Tiers** :
  * Filtre de confidentialité k-anonymity automatique (`D-SEC-003`) masquant les données de cellules si le nombre de profils ayant contribué est $< 100$.

---

### D-UX-MODES-009 : M17 — Argument Map (React Flow)

```
                  ┌───────────────────────┐
                  │     Thèse majeure     │
                  └───────────▲───────────┘
             ┌────────────────┴────────────────┐
   ┌─────────┴─────────┐             ┌─────────┴─────────┐
   │ Support [VERT]    │             │ Réfutation [ROUGE]│
   └───────────────────┘             └───────────────────┘
```

* **Le Problème résolu** : Structurer visuellement des débats complexes, des argumentations juridiques ou des raisonnements logiques.
* **Layout Visuel** :
  * **Nœuds éditables** : Rectangles de propositions logiques :
    * **Thèse centrale** : Rectangle bleu d'en-tête, texte noir gras.
    * **Argument de support** : Rectangle vert avec flèche pointant vers la thèse (`supports`).
    * **Argument de réfutation** : Rectangle rouge avec flèche diamant pointant vers la thèse (`refutes`).
  * **Arêtes** : Flèches d'implications logiques colorées.
* **Interactions Utilisateur** :
  * Double-cliquer sur le texte d'un argument permet de l'éditer en direct.
  * Cliquer sur le bouton `+` flottant en bordure de carte permet de créer instantanément un sous-argument ou un contre-argument associé.
* **Failure Modes & Tiers** :
  * Le positionnement géométrique de ces arbres d'arguments est calculé localement de manière asynchrone par le solveur `elkjs` dans un Web Worker.

---

### D-UX-MODES-010 : M18 — Causal Loop Diagram (G6)

```
               ( + )                    ( - )
        [ Variable A ] ──────────────► [ Variable B ]
```

* **Le Problème résolu** : Modéliser et simuler l'influence et les rétroactions au sein d'un système dynamique.
* **Layout Visuel** :
  * **Nœuds** : Cercles légers représentant des variables d'influence du système.
  * **Arêtes** : Courbes incurvées de relations de cause à effet :
    * **Polarité $+$ (Vert)** : Influence de même sens (si la variable A augmente, la variable B augmente).
    * **Polarité $-$ (Rouge)** : Influence de sens opposé (si A augmente, B diminue).
  * **Badges centraux** : Symbole montrant le comportement de la boucle de rétroaction : `R` pour boucle de renforcement (cercle vert rotatif), `B` pour boucle d'équilibrage (balance rouge).
* **Interactions Utilisateur** :
  * Cliquer sur une variable permet de simuler l'augmentation de sa valeur à l'aide d'un curseur (slider) et d'observer visuellement la propagation des ondes d'énergie le long des boucles causales à 60 FPS.

---

### D-UX-MODES-011 : M19 — Circle Packing (Nivo)

```
        / \
      /  █  \     Bulles sémantiques imbriquées de manières
     | ░   ▒ |    concentriques (diagramme de Venn dynamique)
      \     /
        \ /
```

* **Le Problème résolu** : Représenter des regroupements sémantiques doux et des appartenances conceptuelles sans la lourdeur d'une arborescence.
* **Layout Visuel** :
  * **Bulles imbriquées** : Bulles circulaires de diamètres variables imbriquées de manières concentriques. Volume d'une bulle $\propto$ nombre de concepts qu'elle contient.
  * **Couleurs** : Dégradé de couleurs indiquant le niveau de maîtrise de la branche sémantique.
* **Interactions Utilisateur** :
  * **Clic sur un cercle** : Drill-down fluide zoomant sur la bulle cliquée et masquant les bulles extérieures de niveau supérieur.
* **Failure Modes & Tiers** :
  * Les sous-bulles d'un diamètre inférieur à 5 pixels sont automatiquement floutées ou masquées pour préserver les performances et la clarté visuelle.

---

### D-UX-MODES-012 : M20 — Arc Diagram (D3)

```
            ╭────────────────────╮
            │                    ▼
     [ Nœud A ] ──────────► [ Nœud B ] ──────────► [ Nœud C ]
                                 │                   ▲
                                 ╰───────────────────╯
```

* **Le Problème résolu** : Identifier des boucles d'apprentissage infini ou des dépendances circulaires au sein d'un processus.
* **Layout Visuel** :
  * **Nœuds alignés** : Cercles disposés de manière horizontale ou verticale sur un seul axe rectiligne.
  * **Arêtes en arcs** : Arcs de cercles de rayons variables reliant les nœuds. Les arcs supérieurs représentent les implications amont, les arcs inférieurs représentent les rétroactions aval.
* **Interactions Utilisateur** :
  * **Survol d'un nœud** : Assombrit toutes les relations du graphe pour ne conserver allumés que les arcs reliant le nœud sélectionné à ses cibles amont et aval.

---

### D-UX-MODES-013 : M21 — Hierarchical Edge Bundling (D3)

```
       / \
     /  ║  \      Faisceaux de relations sémantiques fins
    |   ║   |     fusionnés le long de la structure invisible
     \     /      de l'arbre sémantique central
       \ /
```

* **Le Problème résolu** : Désencombrer visuellement les graphes de dépendance denses en canalisant les arêtes le long de leur ontologie commune.
* **Layout Visuel** :
  * **Nœuds d'apprentissage** : Disposés de manière circulaire à la périphérie du diagramme.
  * **Arêtes en faisceaux** : Lignes de relations courbées fusionnées et tendues le long de la structure de l'arbre sémantique central invisible.
  * **Tension des faisceaux** : Réglable par un curseur (slider) de 0 (lignes droites brutes) à 1 (canaux fusionnés optimaux).
* **Interactions Utilisateur** :
  * **Survol d'un nœud** : Révèle l'intégralité du faisceau d'arêtes reliant le concept sélectionné à ses cibles avec un effet d'allumage progressif.

---

### D-UX-MODES-014 : M22 — Semantic Zoom Graph (Cosmos)

```
    [ Zoom 10% : Clusters ] ──► [ Zoom 40% : Groupes ] ──► [ Zoom 80% : Nœuds ]
```

* **Le Problème résolu** : Naviguer de manière fluide au travers de bases de connaissances gigantesques (1M+ nœuds) sans surcharge mentale.
* **Layout Visuel** :
  * **LOD Sémantique (3 Niveaux de Zoom)** :
    * **Niveau Macro (Zoom 0-15%)** : Seuls les clusters majeurs (D-PERF-001) sont visibles sous forme de grandes bulles lumineuses.
    * **Niveau Intermédiaire (Zoom 15-40%)** : Les groupes de concepts se matérialisent avec de fins tracés de forces.
    * **Niveau Micro (Zoom > 40%)** : Les concepts individuels complets et leurs labels apparaissent.
* **Interactions Utilisateur** :
  * **Drill-down double-clic** : Transitionne l'affichage du cluster Cosmos global vers le graphe local G6 du projet d'étude associé.
* **Failure Modes & Tiers** :
  * Si le GPU client est indisponible, fallback direct vers la vue de taxonomie Sunburst (Mode 10) pour l'exploration multi-échelle.

---

### D-UX-MODES-015 : M23 — 3D Knowledge Space (Three.js)

```
                         Z (Fondamental ↔ Avancé)
                         ▲   /
                         │  /
                         │ /
                         ├──────────► X (Concret ↔ Abstrait)
                        /
                       ▼
             Y (Théorique ↔ Pratique)
```

* **Le Problème résolu** : Exploiter la mémoire spatiale de l'utilisateur (méthode du palais de mémoire) pour consolider l'emplacement des concepts complexes.
* **Layout Visuel** :
  * **Espace 3D volumétrique** : Graphe conceptuel tridimensionnel navigable à la première personne dans l'espace.
  * **Nœuds** : Sphères lumineuses flottantes dans l'espace. Couleur ∝ Domaine d'apprentissage. Diamètre ∝ Importance.
  * **Arêtes** : Cylindres de force sémantiques translucides reliant les sphères.
* **Interactions Utilisateur** :
  * **Navigation** : Orbit controls (rotation, pan) et fly-to animation sur clic d'un nœud pour positionner la caméra face à la sphère sélectionnée.
* **Failure Modes & Tiers** :
  * Mode optionnel R&D (Phase 3). Si l'appareil de l'utilisateur ne supporte pas WebGL2 ou n'a pas de GPU dédié, ce mode est masqué de l'interface et remplacé par le Mode 2 (Knowledge Graph 2D).

---

### D-UX-MODES-016 : M24 — Voronoi Concept Map (D3)

```
       / \
     /  █  \     Territoires polygonaux irréguliers adjacents
    | ░   ▒ |    délimitant l'influence géométrique des concepts
     \     /
       \ /
```

* **Le Problème résolu** : Structurer territorialement l'espace de connaissances pour une assimilation visuelle-spatiale optimale.
* **Layout Visuel** :
  * **Polygones Voronoi irréguliers adjacents** : Semblables à des territoires ou pays sur une carte de géographie. Taille d'un polygone ∝ importance du concept.
  * **Couleurs** : Code couleur dynamique indiquant la maîtrise globale du concept (SMI).
* **Interactions Utilisateur** :
  * **Clic sur un territoire** : Déploie les sous-concepts territoriaux internes de manière fluide.
* **Failure Modes & Tiers** :
  * Les coordonnées des polygones de bordure sont fixées aux dimensions strictes du viewport pour éviter que les cellules ne s'étendent à l'infini en dehors de l'écran.

---

### D-UX-MODES-017 : M25 — Knowledge Cards (React Flow)

```
┌─────────────────────────────────────────┐
│ 🃏 CONCEPTS : useEffect                 │
├─────────────────────────────────────────┤
│ [ SQUELETTE SHIMMER LOCALISÉ EN COURS ] │  ◄── (Ligne de texte oscillant)
│ [    DE CHARGEMENT DES MÉTADONNÉES    ] │
│                                         │
│ 📊 MAÎTRISE (SMI) : --/100              │
│ [░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]        │
│                                         │
│ ⚡ ACTIONS RAPIDES :                     │
│ [ Shimmer ]             [ Shimmer ]     │
└─────────────────────────────────────────┘
```

* **Le Problème résolu** : Offrir l'expérience d'apprentissage actif la plus immersive du marché en transformant les nœuds en de véritables unités d'action éditables connectées par des flux animés.
* **Layout Visuel** :
  * **Nœuds d'apprentissage éditables** : Cartes éditables riches et interactives (custom nodes) connectées par des pipelines de flux d'énergie sémantiques (Bézier + WAAPI) [3](https://reactflow.dev/examples/edges/animating-edges).
  * **Squelettes Shimmer de cartes localisés** : Les cartes affichent un squelette Shimmer de balayage luminescent fluide translucide en cours de chargement de leurs données (titre, résumé, radar) pour éliminer tout clignotement.
* **Interactions Utilisateur** :
  * **MiniMap de navigation GPS** : Située en bas-droite de l'interface (D-UX-013).
  * **Actions directes** : L'apprenant peut modifier le contenu de ses notes de cours, lancer une session de Teach-Back, réviser sa flashcard ou ouvrir le document d'origine dans la Reader Suite directement depuis la carte.
* **Failure Modes & Tiers** :
  * Le positionnement géométrique de ces cartes est calculé localement de manière asynchrone par le solveur de grade académique `elkjs` dans un Web Worker pour 0$ de coût serveur [D-UX-014].

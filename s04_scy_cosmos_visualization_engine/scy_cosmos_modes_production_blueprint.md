# Blueprint de Production COSMOS v4 — Les 26 Modes de Visualisation
**Document ID** : BLUEPRINT-COSMOS-26MODES-PRODUCTION  
**Date** : 2026-06-09  
**Statut** : DÉPLOYABLE (ZÉRO IMPROVISATION POUR LES DÉVELOPPEURS)  

---

## 🧭 Partie 1 : Anatomie Sémantique du Nœud & Comportement au Clic

Pour SCY Forge, un nœud n'est pas un point inerte. C'est un **portail sémantique bidirectionnel** relié à la base de connaissances active de l'utilisateur. Lorsqu'un utilisateur clique sur un nœud, COSMOS ne se contente pas d'ouvrir une boîte de dialogue : il instancie un micro-espace de travail cognitif appelé la **Knowledge Card v2**.

```
┌────────────────────────────────────────────────────────┐
│             ANATOMIE DE LA KNOWLEDGE CARD v2           │
├────────────────────────────────────────────────────────┤
│                                                        │
│  [ COUCHE 1 : ANCRAGE ]                                │
│  - Label, Définition NEURON-CHAINS, Tags Domaine       │
│                                                        │
│  [ COUCHE 2 : ÉTAT DE MAÎTRISE SMI ]                   │
│  - Score global, micro-radar 5D, Progression jalon     │
│                                                        │
│  [ COUCHE 3 : ÉCHÉANCE MÉMOIRE FSRS ]                  │
│  - Stabilité (S), Difficulté (D), Prochain rappel     │
│                                                        │
│  [ COUCHE 4 : PROVENANCE & TRAÇABILITÉ ]               │
│  - Sources brutes 🎥📄, Deep Link direct READER SUITE │
│                                                        │
│  [ COUCHE 5 : ACTIONS COGNITIVES RAPIDES ]            │
│  - Lancer Teach-Back, Générer QCM, Validation IA      │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### Les 5 Couches de Données de la Card au Clic du Nœud :

#### 1. La Couche d'Ancrage Conceptuel (Concept Anchor Layer)
* **Contenu** : Label du concept (snapped CJK-aware) [D-QUAL-002], définition sémantique claire de 1 à 3 phrases rédigée par la chaîne EPSILON, et tags du domaine (ex: `Web > Frontend > React`).
* **Visualisation** : En-tête de carte avec code couleur du domaine et badge de niveau de complexité de Bloom (1 à 6).

#### 2. La Couche d'État de Maîtrise (SMI 5D Layer)
* **Contenu** : Le **SMI global (Score de Maîtrise Intégrée)** sur 100 [D-OPP-001].
* **Visualisation** : Un micro-radar chart Recharts à 5 axes (Rétention, Profondeur, Enseignement, Métacognition, Cohérence) montrant la déformation cognitive de l'utilisateur (ses forces et ses faiblesses réelles de compréhension).

#### 3. La Couche d'Échéance Mémoire (FSRS 5.0 Layer)
* **Contenu** : Les paramètres mémoriels de l'algorithme FSRS de la carte associée :
  * **Stabilité ($S$)** en jours.
  * **Difficulté ($D$)** sur une échelle de 1 à 10.
  * **Prochain rappel** estimé (ex: *"Dans 5 jours"* ou *"Aujourd'hui 🔔"*).
* **Visualisation** : Une barre de progression de la retrievability estimée ($R$) déclinant dans le temps, se colorant en rouge clignotant si l'évaluation est due aujourd'hui.

#### 4. La Couche de Provenance & Traçabilité (Provenance & Deep Links)
* **Contenu** : La table d'association `scy_concept_provenance` montrant les sources ingérées d'origine [D-OPP-003] :
  * 🎥 Lien vers la vidéo YouTube à la seconde exacte du concept.
  * 📄 Lien vers la page PDF ou le CFI de l'EPUB dans la READER SUITE.
  * 🌐 Lien vers l'article Web d'origine.
* **Comportement** : Cliquer sur l'une des sources ouvre instantanément le **File Viewer de la READER SUITE** à l'emplacement physique exact pour relire l'explication brute du cours (D-OPT-002).

#### 5. La Couche d'Actions Cognitives (Cognitive Work Callbacks)
* **Bouton 🎤 [STUDENT AI]** : Lance immédiatement une session de Teach-Back où l'utilisateur doit expliquer verbalement le concept pour que l'IA évalue sa compréhension.
* **Bouton 🃏 [RÉVISER CARTE]** : Ouvre instantanément la flashcard APEX associée au concept pour réévaluation FSRS.
* **Boutons ✓ / ✗ [VALIDATION IA]** (Si le nœud ou le lien est auto-généré) : L'utilisateur valide ou rejette la suggestion sémantique de l'IA (D-SEC-002), alimentant la boucle de feedback.

---

## 📚 Partie 2 : Fiches Techniques des 26 Modes COSMOS v4

Pour chaque mode, voici les spécifications complètes de production pour les développeurs.

---

### 🟢 MODE 0 : Base Knowledge Base (L'Espace Universel)

#### 1. Fiche Technique
* **Moteur de Rendu** : `@cosmograph/cosmos` v3 (GPU WebGL2) [D-RENDER-001].
* **Données Entrantes** : Float32Array de typed arrays généré par l'adaptateur `graphologyToCosmos` [D-DATA-004].
* **Justification de Performance** : Seul moteur capable de rendre 1M+ de nœuds à 60 FPS constants en déportant les calculs de forces physiques sur le processeur graphique de l'appareil.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Particules de taille ∝ PageRank global de la base de connaissances. Couleur ∝ Domaine majeur de la carte sémantique universelle.
* **Arêtes** : Fils fins semi-transparents (`opacity: 0.1` à `0.3`) de couleur neutre pour éviter le bruit visuel (hairball).
* **Badges & Halos** : Halos de pulsation masqués par défaut, activables uniquement par zoom sémantique (LOD 3) [D-PERF-001].

#### 3. Comportement au Clic du Nœud
* **Action** : Le clic sur un nœud déclenche un zoom progressif vers la coordonnée ($x, y$), suspend le rendu Cosmos global, charge le graphe local associé via le `useProjectGraphStore` et ouvre une Knowledge Card simplifiée affichant les liens d'interconnexions transversales.

#### 4. Résilience & Fallbacks
* **Timeout Init** : Si Cosmos met plus de 10 secondes à s'initialiser (drivers GPU bloqués ou mode navigation privée stricte) [D-RESILIENCE-001], fallback automatique vers le moteur `@antv/g6` en mode Canvas limité aux 2000 nœuds les plus pertinents (PageRank élevé).
* **WebGL Loss** : Géré par le `setupWebGLRecovery` ré-initialisant le graphe à l'état initial après reprise du context par le navigateur [D-RESILIENCE-002].

#### 5. Rétention & FSRS 5.0
* **Fonction** : Les concepts oubliés (dont la retrievability FSRS $R < 50\%$) voient leur opacité diminuer graduellement. Le graphe universel s'estompe visuellement dans les zones délaissées par l'apprenant, simulant l'effet d'usure synaptique de la mémoire humaine.

---

### 🟢 MODE 1 : Lexical Tags (La Taxonomie Plate)

#### 1. Fiche Technique
* **Moteur de Rendu** : HTML / CSS natif (TailwindCSS) + `react-window` (Virtual list).
* **Données Entrantes** : Array d'objets JSON plats représentant les tags et leur fréquence d'occurrence.
* **Justification de Performance** : Rendu de texte pur ultra-rapide sans surcharge GPU, idéal pour les appareils bas de gamme ou les connexions réseau dégradées.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Tags textuels entourés d'un contour coloré selon le domaine. Taille de la police (12px à 24px) ∝ importance du tag dans la base.
* **Arêtes** : Aucune (représentation en liste plate ou nuage de tags).
* **Badges & Halos** : Un micro-badge numérique rouge indique le nombre de cartes APEX associées à réviser aujourd'hui pour ce tag.

#### 3. Comportement au Clic du Nœud
* **Action** : Ouvre un volet latéral (drawer) listant l'intégralité des concepts possédant ce tag, triés par score de maîtrise SMI croissant pour cibler directement les lacunes.

#### 4. Résilience & Fallbacks
* **Timeout / Fallback** : Aucun timeout possible (DOM natif). Fallback d'affichage : liste textuelle standard indexée si le navigateur bloque les grilles flex CSS de Tailwind.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Permet de lancer une session de révision de cartes APEX groupée par étiquette lexicale, favorisant l'effet d'élaboration sémantique et la catégorisation conceptuelle.

---

### 🟢 MODE 2 : Knowledge Graph Projet (L'Espace d'Étude)

#### 1. Fiche Technique
* **Moteur de Rendu** : `@antv/g6` v5 (WebGL / Canvas) [D-RENDER-001].
* **Données Entrantes** : Graphe Graphology mappé de manière exclusive dans le store Zustand du projet d'étude actif [D-DATA-001].
* **Justification de Performance** : Permet des interactions locales riches (drag, hover dynamique, ajouts à la volée) sur une volumétrie restreinte (< 50 000 nœuds).

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Cercles pleins. Diamètre ∝ PageRank local du projet. Couleur ∝ SMI (de Rouge à Or) [D-OPP-001].
* **Arêtes** : Lignes directionnelles pleines ou tiretées stylisées selon la relation (`EDGE_SEMANTIC_STYLES`) [D-UX-006].
* **Badges & Halos** : Auras rouges clignotantes pour les concepts en retard de révision FSRS. Badge `📅 Xj` indiquant la distance temporelle du prochain rappel.

#### 3. Comportement au Clic du Nœud
* **Action** : Ouvre la **Knowledge Card v2 complète** (voir Partie 1 pour le schéma et les 5 couches). Un effet de zoom centré est appliqué au nœud sélectionné en masquant temporairement les nœuds non connectés d'ordre supérieur à 2 (2-hops).

#### 4. Résilience & Fallbacks
* **Tiers & Limits** : Si le nombre de nœuds du projet dépasse 30 000 sur un appareil classé en `LOW` ou `COMPAT` tier, blocage du rendu automatique et proposition d'un filtre de réduction (ex: afficher uniquement les nœuds de PageRank élevé).
* **Memory Leak** : Tous les écouteurs d'événements de G6 sont détruits au désassemblage du composant via useG6Graph [D-RESILIENCE-003].

#### 5. Rétention & FSRS 5.0
* **Fonction** : C'est la vue d'étude principale de SCY Forge. L'apprenant clique sur les nœuds en retard (auras rouges) pour purger ses révisions quotidiennes directement depuis le graphe sémantique.

---

### 🟢 MODE 3 : MindMap (La Vue Arborescente)

#### 1. Fiche Technique
* **Moteur de Rendu** : `@antv/g6` v5 (Radial Tree Layout) [D-RENDER-001].
* **Données Entrantes** : Structure d'arbre hiérarchique Graphology à racine unique et un seul parent par nœud.
* **Justification de Performance** : Le calcul de disposition radiale arborescente s'exécute dans un Web Worker asynchrone pour libérer le thread principal [D-PERF-003].

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Cercles légers. Couleur ∝ Branche de l'arborescence (domaine de filiation).
* **Arêtes** : Courbes de Bézier fluides émanant du centre (nœud racine) vers la périphérie.
* **Badges & Halos** : Badges simplifiés d'acquisition (symbole coché `✓` si SMI $\ge 70$, cadenas `🔒` si non débloqué).

#### 3. Comportement au Clic du Nœud
* **Action** : Replie ou déplie la sous-branche (collapse/expand) à l'aide d'une animation élastique fluide de 300ms. Si le nœud est terminal (nœud feuille), ouvre la Knowledge Card de révision.

#### 4. Résilience & Fallbacks
* **Layout Fail** : Si la structure de données comporte par erreur un cycle (plus de 1 parent pour un nœud), le validateur de graphe petgraph le détecte en amont [D-VALIDATION-002] et force un basculement automatique vers le layout classique de graphe (Mode 2) pour éviter le plantage du moteur d'arbre.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Idéal pour cartographier mentalement un cours (méthode de note-taking). Permet de réviser un chapitre complet en sélectionnant un nœud parent majeur pour charger toutes les flashcards de ses descendants.

---

### 🟢 MODE 4 : Roadmap ASCENT (Le Chemin de Cursus)

#### 1. Fiche Technique
* **Moteur de Rendu** : `@xyflow/react` v12 (React Flow) [D-RENDER-001].
* **Données Entrantes** : Schéma DAG strict provenant de la table `scy_ascent_nodes` validé par petgraph.
* **Justification de Performance** : React Flow permet d'afficher des nœuds HTML riches contenant des barres de progression interactives tout en maintenant des animations de flux de progression fluides à 60 FPS.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Rectangles de progression éditables :
  * **Verrouillé** : Fond gris opaque, bordure pointillée, icône cadenas.
  * **Disponible** : Fond blanc, bordure bleue, icône play.
  * **En cours** : Fond bleu translucide, jauge SMI active animée.
  * **Complété** : Fond vert, coche verte, score SMI final affiché en or.
* **Arêtes** : Canalisations de force sémantiques ( pipelines SVG) montrant le sens d'apprentissage.
* **Badges & Halos** : Un halo vert pulse doucement autour du nœud d'apprentissage actif pour attirer l'attention de l'apprenant (Zone Proximale de Développement).

#### 3. Comportement au Clic du Nœud
* **Action** : Déclenche l'affichage d'un panneau inférieur (Bottom Sheet) affichant le cours associé, les exercices d'application générés par NEURON-CHAINS et le bouton pour lancer le Teach-Back STUDENT AI.

#### 4. Résilience & Fallbacks
* **Max Nodes** : Limite dure de rendu fixée à 1 000 nœuds de cursus pour garantir la fluidité des translations de caméra.
* **Calcul Layout** : Les coordonnées de la roadmap sont calculées à l'aide du package asynchrone `dagre` en arrière-plan.

#### 5. Rétention & FSRS 5.0
* **Fonction** : C'est le tableau de bord de progression d'ASCENT. Un nœud ne se déverrouille que si le SMI théorique calculé par APEX est $\ge 70/100$, garantissant l'absence de lacunes avant de passer à la suite.

---

### 🟢 MODE 5 : Concepts Grid (La Vue Tableur)

#### 1. Fiche Technique
* **Moteur de Rendu** : TanStack Table v8.
* **Données Entrantes** : Array d'objets JSON plats représentant les attributs des concepts en base de données.
* **Justification de Performance** : Utilise le virtual scrolling (`react-window`) pour afficher et trier un nombre infini de lignes à 60 FPS, sans aucune charge GPU.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Lignes de tableau. Chaque colonne représente un attribut sémantique (Nom, Domaine, SMI, Stabilité FSRS, Difficulté FSRS, Date).
* **Arêtes** : Aucune.
* **Badges & Halos** : Une cellule colorée affiche le score SMI sous forme de badge de couleur (Rouge à Vert).

#### 3. Comportement au Clic du Nœud
* **Action** : Ouvre un panneau latéral coulissant (Drawer) affichant la Knowledge Card complète du concept sélectionné.

#### 4. Résilience & Fallbacks
* **Fallback** : Aucun (composant DOM de table pure). S'exécute sur 100% des navigateurs, y compris sur les liseuses e-ink ou les connexions très bas débit.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Permet aux profils d'étude rigoureux d'identifier précisément leurs faiblesses mémorielles en triant la table par stabilité FSRS croissante (les concepts les plus proches de l'oubli).

---

### 🟢 MODE 6 : Timeline (La Vue Chronologique)

#### 1. Fiche Technique
* **Moteur de Rendu** : React Custom Renderer + `react-spring` (Physics engine).
* **Données Entrantes** : Liste d'événements sémantiques ordonnés chronologiquement avec timestamps.
* **Justification de Performance** : Rendu SVG horizontal optimisé à l'aide de l'accélération CSS matérielle du navigateur.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Cartes chronologiques verticales émaillant un axe horizontal temporel central.
* **Arêtes** : L'axe horizontal lui-même (la ligne du temps), coloré selon l'époque ou le domaine.
* **Badges & Halos** : Badge d'alerte mémorielle sur les dates clés en cours d'oubli sémantique.

#### 3. Comportement au Clic du Nœud
* **Action** : Agrandi la carte d'événement sélectionnée, déclenche le zoom de l'axe temporel vers la date d'origine et ouvre un résumé sémantique détaillé.

#### 4. Résilience & Fallbacks
* **Out of Bounds** : Si un événement comporte une date invalide (NaN), il est automatiquement rejeté de l'affichage par la couche de sanitization [D-VALIDATION-001].

#### 5. Rétention & FSRS 5.0
* **Fonction** : Indispensable pour l'apprentissage historique, médical ou de processus industriels séquentiels. FSRS adapte ses rappels sur les dates pour éviter la confusion mémorielle temporelle (Lector paper).

---

### 🟢 MODE 7 : Statistics (La Vue de Performance)

#### 1. Fiche Technique
* **Moteur de Rendu** : `recharts` v2 (SVG Charts) [D-RENDER-001].
* **Données Entrantes** : Agrégations analytiques complexes issues des calculs de DuckDB-WASM [D-DATA-003].
* **Justification de Performance** : recharts est idéal pour le rendu déclaratif de graphes de courbes et de barres statistiques légers.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Graphiques à barres, courbes de rétention, et nuages de points de performances.
* **Arêtes** : Aucune.
* **Badges & Halos** : Indicateurs de réussite globale de formation en en-tête.

#### 3. Comportement au Clic du Nœud
* **Action** : Le clic sur un point d'un graphique (ex: un pic d'oubli un mardi) filtre les concepts de la base de connaissances concernés par cette statistique.

#### 4. Résilience & Fallbacks
* **Query Timeout** : Si l'agrégation DuckDB-WASM met plus de 5 secondes à calculer [D-RESILIENCE-005], la requête est interrompue par le circuit breaker et le graphique affiche un état fallback neutre basé sur les données statiques en cache.

#### 5. Rétention & FSRS 5.0
* **Fonction** : C'est la tour de contrôle métacognitive de SCY Forge. L'apprenant visualise objectivement l'état réel de sa mémorisation et la décroissance de son oubli théorique.

---

### 🟢 MODE 8 : DataFlow NEURON-CHAINS (La Vue Pipeline)

#### 1. Fiche Technique
* **Moteur de Rendu** : `@xyflow/react` v12 (React Flow).
* **Données Entrantes** : Événements d'exécution en streaming de l'EventBus d'ingestion.
* **Justification de Performance** : Permet de dessiner et d'animer à 60 FPS des flux de blocs en cours d'exécution.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Boîtes de traitement représentant les agents actifs (ex: `BETA-1 Taxonomiste`, `Fact-Checker`). Couleur ∝ Statut de traitement (Gris = en attente, Bleu clignotant = en cours, Vert = terminé).
* **Arêtes** : Pipelines SVG animés où des bulles de données circulent en temps réel du document brut vers la carte finale.
* **Badges & Halos** : Badge affichant le nombre de jetons compressés et les temps de traitement par agent.

#### 3. Comportement au Clic du Nœud
* **Action** : Affiche les journaux de logs en temps réel de l'agent sélectionné pour permettre à l'utilisateur de comprendre la pensée de l'IA (transparence de l'IA).

#### 4. Résilience & Fallbacks
* **Fallback** : Si le thread principal est surchargé, les animations de flux de particules des arêtes React Flow sont automatiquement désactivées pour préserver la fluidité de navigation.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Permet de comprendre d'où viennent les cartes et résumés créés. Augmente le sentiment de contrôle et de confiance (Self-Determination Theory).

---

### 🟢 MODE 9 : Concept Map (La Cartographie Sémantique)

#### 1. Fiche Technique
* **Moteur de Rendu** : `@antv/g6` v5 [D-RENDER-001].
* **Données Entrantes** : Structure de graphe non-arborescente (multi-parents) Graphology avec relations étiquetées.
* **Justification de Performance** : G6 Canvas gère à la perfection l'affichage d'arêtes fines étiquetées avec un calcul de forces physiques (ForceAtlas2) asynchrone [D-PERF-003].

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Cercles légers. Couleur ∝ Domaine. Taille ∝ PageRank sémantique.
* **Arêtes** : Lignes directionnelles de relations typées possédant une étiquette textuelle claire décrivant la relation (ex: *"dépend de"*, *"contredit"*, *"est un exemple de"*).
* **Badges & Halos** : Badge indiquant si la liaison a été validée par l'utilisateur ou générée automatiquement par l'IA.

#### 3. Comportement au Clic du Nœud
* **Action** : Ouvre la Knowledge Card v2. Cliquer sur une arête affiche l'explication logique de la liaison et permet de la valider ou de la rejeter instantanément.

#### 4. Résilience & Fallbacks
* **Fisheye Lens** : Intègre le plugin Fisheye (`D-UX-001`) pour désencombrer localement les zones denses du graphe sémantique lors des interactions.

#### 5. Rétention & FSRS 5.0
* **Fonction** : C'est le mode par excellence de l'assimilation conceptuelle profonde. En formulant explicitement des propositions textuelles, l'apprenant construit un modèle mental hautement structuré de son savoir.

---

### 🟢 MODE 10 : Sunburst Hiérarchique (La Taxonomie Radiale)

#### 1. Fiche Technique
* **Moteur de Rendu** : `@antv/g2` v5 (Statistical/Hiérarchique Engine) [D-RENDER-006].
* **Données Entrantes** : JSON d'arborescence multiniveau Graphology.
* **Justification de Performance** : G2 est optimisé spécifiquement pour le tracé géométrique complexe de secteurs angulaires concentriques.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Secteurs angulaires concentriques. Chaque secteur représente un sous-domaine de connaissances. Largeur angulaire ∝ volume de concepts associés.
* **Arêtes** : Aucune (la relation hiérarchique est induite par l'imbrication physique des anneaux).
* **Badges & Halos** : Code couleur dynamique indiquant la maîtrise SMI moyenne du secteur (de Rouge à Vert).

#### 3. Comportement au Clic du Nœud
* **Action** : Déclenche une animation de zoom de focalisation (drill-down). Le secteur cliqué devient le nouvel anneau central, et ses sous-catégories s'étendent à 60 FPS constants.

#### 4. Résilience & Fallbacks
* **Lazy-loading** : Le module G2 (~180KB) est chargé à la demande uniquement [D-RENDER-006]. Si l'appareil est un `COMPAT` tier, fallback vers une liste hiérarchique épurée pour éviter de surcharger le processeur.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Permet de repérer instantanément quel pan entier de ses connaissances est en train d'être oublié. L'apprenant clique sur le secteur rouge pour lancer une session de révision APEX focalisée sur cette famille d'étude.

---

### 🟢 MODE 11 : Treemap Conceptuel (L'Allocation de Connaissance)

#### 1. Fiche Technique
* **Moteur de Rendu** : `@antv/g2` v5 [D-RENDER-006].
* **Données Entrantes** : JSON d'arborescence multiniveau Graphology.
* **Justification de Performance** : Calcul de partition d'espace rectangulaire (Squarify) optimisé en Rust/C++ compilé en WASM.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Rectangles imbriqués. Surface du rectangle ∝ Volume de cartes associées au concept.
* **Arêtes** : Aucune.
* **Badges & Halos** : Couleur du rectangle ∝ Stabilité FSRS globale du sous-domaine (Rouge à Vert).

#### 3. Comportement au Clic du Nœud
* **Action** : Zoom d'expansion (drill-down) divisant le rectangle sélectionné pour révéler la sous-structure de ses sous-concepts.

#### 4. Résilience & Fallbacks
* **Labels Clamping** : Les étiquettes textuelles à l'intérieur des rectangles se désactivent automatiquement si la taille disponible est inférieure à la taille de la police, évitant tout chevauchement ou débordement visuel.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Offre une perspective unique sur le poids mémoriel de chaque matière d'étude. L'utilisateur peut facilement comparer si le temps passé sur une matière se traduit par une stabilité FSRS équivalente ou s'il s'agit d'un point de friction.

---

### 🟢 MODE 12 : Chord Diagram (La Vue de Co-occurrence)

#### 1. Fiche Technique
* **Moteur de Rendu** : `nivo` (Chord Module) [D-RENDER-007].
* **Données Entrantes** : Matrice carrée bidirectionnelle d'interactions.
* **Justification de Performance** : nivo gère l'affichage déclaratif de rubans complexes à l'aide d'interpolations de courbes SVG.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Segments disposés circulairement à la périphérie du diagramme.
* **Arêtes** : Rubans colorés d'épaisseurs variables reliant deux segments. Épaisseur du ruban ∝ intensité des interactions bidirectionnelles entre les deux concepts.
* **Badges & Halos** : Code couleur sémantique décrivant le type d'arêtes.

#### 3. Comportement au Clic du Nœud
* **Action** : Assombrit l'intégralité du diagramme à l'exception des rubans émanant du nœud sélectionné, mettant en valeur ses corrélations de co-occurrence majeures.

#### 4. Résilience & Fallbacks
* **Clutter Limit** : Limite stricte de calcul de matrice fixée à 200 nœuds maximum pour éviter l'enchevêtrement des rubans au centre du diagramme.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Indispensable pour comprendre les co-occurrences conceptuelles (ex: à quel point l'étude du concept de *Closures* croise-t-elle l'étude du concept d'*État React*). Aide à structurer les révisions transversales.

---

### 🟢 MODE 13 : Sankey / Alluvial (La Trajectoire d'Apprentissage)

#### 1. Fiche Technique
* **Moteur de Rendu** : `nivo` (Sankey Module) [D-RENDER-007].
* **Données Entrantes** : JSON de flux structuré par étapes d'apprentissage.
* **Justification de Performance** : Rendu SVG optimisé avec yield d'images progressif lors des phases de transition.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Rectangles verticaux disposés en colonnes d'étapes d'apprentissage.
* **Arêtes** : Rubans fluides horizontaux de largeurs variables reliant les colonnes. Largeur du ruban ∝ volume d'utilisateurs ou de concepts traversant cette étape.
* **Badges & Halos** : Pourcentage d'abandon ou de réussite affiché sur chaque ruban.

#### 3. Comportement au Clic du Nœud
* **Action** : Met en valeur l'intégralité du chemin de flux (la trajectoire complète) amont et aval traversant le nœud sélectionné.

#### 4. Résilience & Fallbacks
* **Filtre** : Les flux mineurs représentant moins de $2\%$ de la masse totale de données sont automatiquement masqués pour désencombrer l'espace visuel.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Permet à l'équipe pédagogique (et à l'utilisateur) de visualiser sa trajectoire d'étude et d'identifier précisément où se situent les bifurcations et les abandons d'apprentissage.

---

### 🟢 MODE 14 : Radar Comparaison (Le Profil Multidimensionnel)

#### 1. Fiche Technique
* **Moteur de Rendu** : `recharts` v2 [D-RENDER-001].
* **Données Entrantes** : Array d'objets JSON plats représentant les 5 dimensions du SMI calculées par l'`AGENT-05`.
* **Justification de Performance** : recharts est idéal pour le rendu instantané de polygones translucides superposés sur des axes radiaux.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : 5 axes radiaux (Rétention, Profondeur, Enseignement, Métacognition, Cohérence).
* **Arêtes** : Polygone translucide reliant les scores de l'utilisateur sur chaque axe.
* **Badges & Halos** : Superposition d'un polygone bleu (votre profil) et d'un polygone vert ou rouge (profil cible exigé pour débloquer la certification).

#### 3. Comportement au Clic du Nœud
* **Action** : Cliquer sur l'un des sommets du polygone (ex: l'axe Rétention) ouvre la liste des concepts de la base de données responsables du déclin ou de la force de cette dimension.

#### 4. Résilience & Fallbacks
* **Dynamic Snapping** : Les valeurs des axes s'ajustent dynamiquement entre 0 et 100 pour éviter tout dépassement ou déformation de l'échelle polygonale.

#### 5. Rétention & FSRS 5.0
* **Fonction** : C'est le tableau de bord d'analyse métacognitive. L'utilisateur repère visuellement ses déséquilibres d'étude (par exemple, s'il fait trop d'apprentissage par cœur au détriment de l'enseignement Teach-Back).

---

### 🟢 MODE 15 : Parallel Coordinates (Le Filtre Haute Dimension)

#### 1. Fiche Technique
* **Moteur de Rendu** : `d3` v7 [D-RENDER-008].
* **Données Entrantes** : Graphe Graphology mappé sur N axes de données parallèles.
* **Justification de Performance** : d3 offre un contrôle total de bas niveau pour gérer le glissement de curseurs interactifs (brushing) sur les axes verticaux en temps réel.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Axes verticaux parallèles représentant chacun une métrique d'étude (Difficulté, SMI, Date d'ingestion, Stabilité FSRS).
* **Arêtes** : Lignes brisées horizontales traversant les axes pour chaque concept.
* **Badges & Halos** : Code couleur de la ligne indiquant le domaine du concept.

#### 3. Comportement au Clic du Nœud
* **Action** : Cliquer et faire glisser son curseur (drag brush) sur un axe filtre instantanément toutes les lignes de concepts ne correspondant pas à cet intervalle de données.

#### 4. Résilience & Fallbacks
* **Worker Offload** : Les calculs de coordonnées de trajectoires des 5 000 concepts maximaux du mode s'exécutent dans un Web Worker.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Permet aux profils d'analyse avancés d'isoler les concepts les plus instables en mémoire (stabilité FSRS basse) qui ont pourtant demandé beaucoup de temps d'étude.

---

### 🟢 MODE 16 : Heatmap Matricielle (La Matrice de Corrélation)

#### 1. Fiche Technique
* **Moteur de Rendu** : `nivo` (Heatmap Module) [D-RENDER-007].
* **Données Entrantes** : Matrice carrée symétrique d'affinité sémantique (similarité cosinus).
* **Justification de Performance** : nivo gère l'affichage virtuel de milliers de cellules carrées interactives sans latence.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Cellules carrées colorées. L'intensité de la couleur (de blanc à violet foncé) ∝ force de la similarité cosinus entre le concept de la ligne et celui de la colonne.
* **Arêtes** : Aucune.
* **Badges & Halos** : Un symbole `⚠️` s'affiche si deux concepts distincts ont une similarité supérieure à $0.95$ (signifiant une forte redondance ou un besoin de fusion de concepts).

#### 3. Comportement au Clic du Nœud
* **Action** : Ouvre un volet latéral d'explication de la similarité, proposant à l'utilisateur de fusionner les deux concepts redondants ou d'établir un lien croisé de continuité sémantique.

#### 4. Résilience & Fallbacks
* **k-Anonymity** : Si la heatmap est partagée en communauté (Marketplace), le filtre de confidentialité k-anonymity masque automatiquement les données de cellules si le nombre de profils ayant contribué est $< 100$ [D-SEC-003].

#### 5. Rétention & FSRS 5.0
* **Fonction** : Permet d'identifier d'un coup d'œil les redondances ou les fusions conceptuelles à réaliser pour alléger la charge mémorielle FSRS de l'apprenant.

---

### 🟢 MODE 17 : Argument Map (La Vue Dialectique)

#### 1. Fiche Technique
* **Moteur de Rendu** : `@xyflow/react` v12 (React Flow) [D-RENDER-001].
* **Données Entrantes** : Graphe de propositions logiques structuré.
* **Justification de Performance** : React Flow permet d'afficher des boîtes de propositions contenant des blocs de texte éditables et des flèches directionnelles d'implications logiques.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Rectangles colorés :
  * **Thèse centrale** : Rectangle bleu d'en-tête.
  * **Argument de support** : Rectangle vert avec flèche pointant vers la thèse (`supports`).
  * **Argument de réfutation** : Rectangle rouge avec flèche diamant pointant vers la thèse (`refutes`).
* **Arêtes** : Flèches d'implications logiques colorées.
* **Badges & Halos** : Badge indiquant la source documentaire de l'argument d'origine.

#### 3. Comportement au Clic du Nœud
* **Action** : Permet d'éditer le texte de la proposition en temps réel ou d'ajouter une sous-réfutation ou un sous-support à l'aide d'un bouton `+` contextuel.

#### 4. Résilience & Fallbacks
* **Layout Auto** : Le positionnement des arguments est géré côté client de manière asynchrone par `elkjs` [D-UX-014].

#### 5. Rétention & FSRS 5.0
* **Fonction** : Indispensable pour l'apprentissage juridique, philosophique ou l'analyse de dossiers de crises. Entraîne l'utilisateur sur la mémorisation des structures d'argumentation et la réfutation dialectique.

---

### 🟢 MODE 18 : Causal Loop Diagram (La Vue Dynamique)

#### 1. Fiche Technique
* **Moteur de Rendu** : `@antv/g6` v5 [D-RENDER-001].
* **Données Entrantes** : Graphe Graphology orienté représentant des relations de cause à effet polarisées.
* **Justification de Performance** : G6 permet d'afficher des arêtes incurvées possédant des symboles mathématiques ($+$ ou $-$, ou $S$ pour Same, $O$ pour Opposite).

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Cercles légers représentant des variables d'influence du système.
* **Arêtes** : Courbes incurvées de relations de cause à effet :
  * **Polarité $+$** : Arête verte montrant une influence de même sens (si la variable A augmente, la variable B augmente).
  * **Polarité $-$** : Arête rouge montrant une influence de sens opposé (si A augmente, B diminue).
* **Badges & Halos** : Symbole central de la boucle de rétroaction : `R` pour boucle de renforcement (cercle vert rotatif), `B` pour boucle d'équilibrage (balance rouge).

#### 3. Comportement au Clic du Nœud
* **Action** : Permet de simuler l'augmentation d'une variable en direct en propageant l'impulsion sémantique à 60 FPS le long des boucles pour voir l'effet final sur l'écosystème modélisé.

#### 4. Résilience & Fallbacks
* **Validation** : Le système de validation de graphe s'assure qu'aucune contradiction logique n'est présente au sein du schéma avant de lancer la simulation de propagation.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Permet d'ancrer de manière durable la compréhension de systèmes complexes en remplaçant l'apprentissage par cœur linéaire par la modélisation de boucles causales.

---

### 🟢 MODE 19 : Circle Packing (La Classification Imbriquée)

#### 1. Fiche Technique
* **Moteur de Rendu** : `nivo` (Circle-packing Module) [D-RENDER-007].
* **Données Entrantes** : JSON hiérarchique Graphology.
* **Justification de Performance** : nivo gère le tracé déclaratif de bulles circulaires tangentes imbriquées à l'aide de l'accélération d'affichage du navigateur.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Bulles circulaires de diamètres variables imbriquées de manières concentriques. Volume d'une bulle ∝ nombre de concepts de la sous-famille.
* **Arêtes** : Aucune (la relation d'appartenance s'exprime par le confinement physique des bulles).
* **Badges & Halos** : Couleur de la bulle indiquant le niveau d SMI moyen de la famille.

#### 3. Comportement au Clic du Nœud
* **Action** : Drill-down fluide zoomant sur la bulle cliquée et masquant les bulles extérieures de niveau supérieur.

#### 4. Résilience & Fallbacks
* **Eviction** : Les sous-bulles d'un diamètre inférieur à 5 pixels sont automatiquement floutées ou masquées pour préserver les performances et la clarté visuelle.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Idéal pour l'apprentissage sémantique des concepts qui partagent des propriétés ou des origines communes, en s'affranchissant de la lourdeur d'une arborescence classique.

---

### 🟢 MODE 20 : Arc Diagram (La Vue de Flux Linéaire)

#### 1. Fiche Technique
* **Moteur de Rendu** : `d3` v7 [D-RENDER-008].
* **Données Entrantes** : Graphe ordonné linéairement Graphology.
* **Justification de Performance** : d3 permet un alignement parfait de nœuds sur un seul axe et le tracé d'arcs géométriques de rayons proportionnels à la distance des nœuds.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Cercles alignés horizontalement sur une ligne centrale.
* **Arêtes** : Arcs de cercles reliant les nœuds. Les arcs supérieurs représentent les liens d'implication directs, les arcs inférieurs indiquent les liens de retour en arrière (rétroactions).
* **Badges & Halos** : Couleur de l'arc indiquant le type de relation sémantique.

#### 3. Comportement au Clic du Nœud
* **Action** : Assombrit toutes les relations du graphe pour ne conserver allumés que les arcs reliant le nœud sélectionné à ses cibles amont et aval.

#### 4. Résilience & Fallbacks
* **Scale Clamp** : Le rayon des arcs est limité pour éviter que les liaisons à très longue distance ne sortent des limites physiques du canvas.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Permet d'identifier instantanément si un cursus de formation comporte des sauts de concepts trop importants (un arc de très grande envergure) ou des blocages cycliques d'apprentissage.

---

### 🟢 MODE 21 : Hierarchical Edge Bundling (Le Désencombrement)

#### 1. Fiche Technique
* **Moteur de Rendu** : `d3` v7 [D-RENDER-008].
* **Données Entrantes** : Structure de graphe de dépendances denses doublée d'une hiérarchie sous-jacente.
* **Justification de Performance** : d3 gère à la perfection l'algorithme de tension de faisceaux d'arêtes reliant des branches d'ontologies complexes.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Nœuds d'apprentissage disposés de manière circulaire à la périphérie du diagramme.
* **Arêtes** : Faisceaux d'arêtes (courbes de Bézier fusionnées et tendues le long de la structure de l'arbre sémantique central invisible) reliant les nœuds.
* **Badges & Halos** : Tension réglable des faisceaux par slider pour ajuster la clarté visuelle.

#### 3. Comportement au Clic du Nœud
* **Action** : Révèle l'intégralité du faisceau d'arêtes reliant le concept sélectionné à ses cibles avec un effet d'allumage progressif.

#### 4. Résilience & Fallbacks
* **LOD Transition** : Si le nombre de nœuds à la périphérie dépasse 2 000, le système bascule automatiquement sur un regroupement de branches (LOD 1) pour éviter la surcharge d'affichage.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Indispensable pour la visualisation d'ontologies complexes (médecine, ingénierie aéronautique). Permet de repérer comment des branches disjointes de la formation communiquent entre elles à long terme.

---

### 🟢 MODE 22 : Semantic Zoom Graph (La Révélation Progressive)

#### 1. Fiche Technique
* **Moteur de Rendu** : `@cosmograph/cosmos` v3 [D-RENDER-001].
* **Données Entrantes** : Graphe Graphology de très grande volumétrie découpé en 3 niveaux de zoom sémantique (LOD Sémantique).
* **Justification de Performance** : Cosmos.gl exploite les shaders GPU pour recalculer instantanément l'opacité et l'affichage des nœuds selon le niveau de zoom.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** :
  * **Niveau Macro (Zoom 0-15%)** : Seuls les clusters majeurs (D-PERF-001) sont visibles sous forme de grandes bulles lumineuses.
  * **Niveau Intermédiaire (Zoom 15-40%)** : Les groupes de concepts se matérialisent avec de fins tracés de forces.
  * **Niveau Micro (Zoom > 40%)** : Les concepts individuels complets et leurs labels apparaissent.
* **Arêtes** : Tracés de force reliant les clusters ou les concepts selon l'échelle.
* **Badges & Halos** : Halo d'indication de concepts hors-champ (halos de bordure du canvas montrant la direction des concepts overdue dues hors viewport).

#### 3. Comportement au Clic du Nœud
* **Action** : Drill-down géométrique et sémantique fluide vers le cluster sélectionné, commutant l'affichage vers la vue G6 locale (Mode 2) [D-PERF-001].

#### 4. Résilience & Fallbacks
* **Fallback** : Si le GPU client est indisponible, fallback direct vers la vue de taxonomie Sunburst (Mode 10) pour l'exploration multi-échelle.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Permet une exploration fluide et ludique de gigantesques bases de connaissances sans jamais subir de surcharge mentale (Information Overload).

---

### 🟢 MODE 23 : 3D Knowledge Space (L'Espace Immersif)

#### 1. Fiche Technique
* **Moteur de Rendu** : `three.js` (avec roadmap de migration WebGPU Phase 3) [D-RENDER-009].
* **Données Entrantes** : Coordonnées tridimensionnelles ($x, y, z$) calculées dans un espace sémantique à 3 axes orthogonaux.
* **Justification de Performance** : three.js permet le rendu volumétrique de sphères lumineuses et d'arêtes en trois dimensions à 60 FPS constants.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Sphères lumineuses flottantes dans l'espace. Couleur ∝ Domaine d'apprentissage. Diamètre ∝ Importance.
* **Arêtes** : Cylindres de force translucides reliant les sphères.
* **Badges & Halos** : Axes de coordonnées sémantiques 3D texturés visibles en arrière-plan.

#### 3. Comportement au Clic du Nœud
* **Action** : Déclenche une animation de vol de la caméra (fly-to animation) positionnant l'utilisateur face à la sphère sélectionnée, et déploie la Knowledge Card en 3D.

#### 4. Résilience & Fallbacks
* **GPU Check** : Mode R&D optionnel (Phase 3). Si l'appareil de l'utilisateur ne supporte pas WebGL2 ou n'a pas de GPU dédié, ce mode est masqué de l'interface et remplacé par le Mode 2 (Knowledge Graph 2D).

#### 5. Rétention & FSRS 5.0
* **Fonction** : Exploite la mémoire spatiale de l'utilisateur (méthode des lieux ou *palais de mémoire*). L'utilisateur associe mentalement l'emplacement physique d'un concept dans l'espace 3D à son sens conceptuel, doublant ainsi l'efficacité du rappel à long terme.

---

### 🟢 MODE 24 : Voronoi Concept Map (La Vue Territoriale)

#### 1. Fiche Technique
* **Moteur de Rendu** : `d3` v7 [D-RENDER-008].
* **Données Entrantes** : Coordonnées cartésiennes des concepts Graphology traduites en cellules Voronoi polygonales irrégulières.
* **Justification de Performance** : d3 gère de manière optimale l'algorithme géométrique de partitionnement de Delaunay/Voronoi côté client.

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Cellules polygonales irrégulières adjacentes (semblables à des territoires ou des pays sur une carte de géographie). Taille d'un polygone ∝ importance du concept.
* **Arêtes** : Les bordures des cellules, dessinant les frontières des concepts.
* **Badges & Halos** : Couleur du polygone ∝ Score SMI actuel (Rouge à Vert).

#### 3. Comportement au Clic du Nœud
* **Action** : Révèle les concepts enfants situés à l'intérieur du polygone du concept parent de manière fluide.

#### 4. Résilience & Fallbacks
* **Border Clamping** : Les coordonnées des polygones de bordure sont fixées aux dimensions strictes du viewport pour éviter que les cellules ne s'étendent à l'infini en dehors de l'écran.

#### 5. Rétention & FSRS 5.0
* **Fonction** : Très puissant pour les styles d'apprentissage visuels-spatiaux. L'apprenant visualise ses connaissances comme un **territoire de compétences** qu'il doit conquérir (les polygones rouges doivent être transformés en polygones verts).

---

### 🟢 MODE 25 : Knowledge Cards (Le Dashboard Spatial Interactif) 🔴 CRITIQUE

#### 1. Fiche Technique
* **Moteur de Rendu** : `@xyflow/react` v12 (React Flow) [D-RENDER-001].
* **Données Entrantes** : Concepts et relations du sous-graphe d'étude actif de l'utilisateur.
* **Justification de Performance** : React Flow est le seul moteur capable de rendre des cartes React complexes éditables connectées par des pipelines animés sans figer le thread principal [2](https://reactflow.dev/learn/advanced-use/performance).

#### 2. Sémiologie Graphique & Affichage
* **Nœuds** : Cartes verticales riches (Dashboard sémantique) avec jauge SMI, stabilité FSRS, mini-radar et boutons d'action rapide.
* **Arêtes** : Pipelines SVG directionnels (canalisations d'énergie) où circulent des particules lumineuses SVG de transfert de connaissances dont la vitesse de glissade (CSS `offset-path`) est proportionnelle à la similarité sémantique de la relation [3](https://reactflow.dev/examples/edges/animating-edges).
* **Badges & Halos** : Squelettes Shimmer de cartes localisés en cours de chargement (D-MODES-006) pour éliminer tout clignotement. MiniMap de navigation GPS située en bas-droite de l'interface (D-UX-013).

#### 3. Comportement au Clic du Nœud
* **Action** : Ouvre un focus de carte, permettant à l'utilisateur de modifier le contenu de ses notes de cours, de lancer un Teach-Back, de réviser sa flashcard ou d'ouvrir le document d'origine dans la Reader Suite.

#### 4. Résilience & Fallbacks
* **Layout Auto** : Le positionnement géométrique de ces cartes est calculé localement de manière asynchrone par le solveur de grade académique `elkjs` dans un Web Worker pour 0$ de coût serveur [D-UX-014].

#### 5. Rétention & FSRS 5.0
* **Fonction** : C'est le mode d'apprentissage et d'action sémantique ultime. L'apprenant manipule, édite et fait interagir ses concepts au sein d'un tableau de bord spatial, décuplant l'efficacité de l'étude active et de la mémorisation FSRS.

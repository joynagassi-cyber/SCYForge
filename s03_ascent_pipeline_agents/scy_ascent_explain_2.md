# 🎓 SCY FORGE — ASCENT COURSE DISPLAY ENGINE
## L'Interface d'Affichage des Cours de Formation — Spécification d'Expérience Interactive & Cognitive

---

**Document ID** : SPEC-ASCENT-COURSE-DISPLAY-V1
**Date** : 2026-06-08
**Statut** : 🔵 ARCHITECTURE DE RÉFÉRENCE — UI/UX DU NŒUD D'APPRENTISSAGE
**Périmètre** : Vue Cours/Nœud ASCENT (l'écran où l'apprenant *consomme* et *maîtrise* un nœud)
**Promesse UX** : *« Tout ce que l'utilisateur apprend doit être intuitif, interactif et aligné cognitivement — jamais une charge visuelle. »*
**Thème** : Dark / Light adaptatif (toggle + sync système, §13)

> Ce document **restructure et approfondit** les notes éparses (annexes A.3 → A.8 + structures `SkillNode` du PRD) en une **solution d'affichage unique, structurée et professionnelle** pour le cœur d'ASCENT : la page où un nœud de compétence devient une expérience d'apprentissage vivante. Aucune information des notes d'origine n'est perdue — chaque idée est conservée, précisée, et reliée à un comportement d'interface concret, des données, des événements et une justification cognitive.

---

## 📑 Table des Matières

1. [Vision — Pourquoi repenser l'affichage des cours](#1-vision)
2. [Les 7 Lois Cognitives qui Gouvernent l'Affichage](#2-les-7-lois-cognitives)
3. [Anatomie de la Page Cours/Nœud — Le Triptyque Adaptatif](#3-anatomie-de-la-page)
4. [Le Moteur de Lecture Interactive (Active Reading Layer)](#4-le-moteur-de-lecture-interactive)
   - 4.1 [Sélection intelligente → Radial Action Menu (Explain with BRAIN)](#41-selection-intelligente)
   - 4.2 [Les 9 actions contextuelles de sélection](#42-les-9-actions-contextuelles)
   - 4.3 [Glossaire vivant & hover-cards de concepts](#43-glossaire-vivant)
   - 4.4 [Active Recall inline — Cloze à la volée](#44-active-recall-inline)
   - 4.5 [Le Moteur de Rendu Technique Multi-Vues (D-UX-015)](#45-moteur-rendu-technique)
5. [Orchestration des Visuels COSMOS dans la Page](#5-orchestration-cosmos)
   - 5.1 [Le COSMOS Inline Director — auto-suggestion du bon visuel](#51-cosmos-inline-director)
   - 5.2 [Blocs visuels embarqués & drill-down](#52-blocs-visuels-embarques)
   - 5.3 [Mini-map de progression cognitive du nœud](#53-mini-map)
   - 5.4 [La MiniMap GPS interactive de viewport (D-UX-013)](#54-minimap-gps)
   - 5.5 [Pre-render Skeletons & L'Allumage Neural (The Neural Ignition Reveal) (D-UX-002)](#55-allumage-neural)
6. [ASCENT Slides — Présentation Pédagogique (AntV Infographic)](#6-ascent-slides)
   - 6.1 [Le pipeline de génération de slides](#61-pipeline-slides)
   - 6.2 [Template par nœud (8-10 slides) — enrichi](#62-template-par-noeud)
   - 6.3 [Modes de navigation & adaptation SMI](#63-modes-navigation)
   - 6.4 [Interactivité par slide](#64-interactivite-par-slide)
   - 6.5 [Generative-Canvas-AI (FlowSeek) — Le Dessin de Schéma en Streaming (D-UX-014)](#65-generative-canvas-flowseek)
7. [Timestamps Intelligents Vidéo & Sources Embarquées](#7-timestamps-intelligents)
8. [BRAIN dans la Page — Le Professeur Cognitif Contextuel](#8-brain-dans-la-page)
9. [Bloc Exercices & Validation par Domaine](#9-bloc-exercices)
10. [Les 12 Micro-Features Game-Changer](#10-micro-features-game-changer)
11. [ASCENT Software Sprint — Affichage des Cours Logiciels](#11-software-sprint)
12. [Goals Prédéfinis & Preuve Sociale — Affichage Pré-Cours](#12-goals-predefinis)
13. [Système de Design — Thème, États, Composants](#13-systeme-de-design)
14. [Spécifications Techniques — Data Model, Events, Perf, A11y](#14-specifications-techniques)
15. [Annexes Préservées — Sources, SQS & Pipeline 13 Agents](#15-annexes-preservees)

---

## 1. Vision

### 1.1 Le problème de l'affichage actuel

ASCENT sait *construire* un parcours (9 agents autonomes, §15) et *générer* du contenu (NEURON-CHAINS). Mais le moment de vérité — **l'écran où l'utilisateur lit, comprend, pratique et mémorise un nœud** — était décrit de façon éparse : des slides ici (A.4), des timestamps là (A.5), un BRAIN ailleurs (A.3), des exercices par domaine encore ailleurs. Résultat : un risque de **page-fourre-tout** où tout est présent mais rien n'est orchestré, ce qui produit exactement la **charge cognitive** que l'on veut éviter.

```
┌──────────────────────────────────────────────────────────────┐
│   AVANT (notes éparses)          APRÈS (Course Display Engine)│
│  ───────────────────────         ────────────────────────────│
│  • Slides (A.4)                  Une SEULE page-nœud           │
│  • Timestamps (A.5)        →     orchestrée, à 3 couches :     │
│  • BRAIN (A.3)                   READ · DO · PROVE             │
│  • Exercices par domaine         + Active Reading Layer        │
│  • SMI quelque part              + COSMOS inline                │
│  • Flashcards APEX               + micro-features cognitives   │
│                                                               │
│  « Tout est là, l'user          « Le bon élément, au bon      │
│    doit tout organiser »           moment, sans surcharge »   │
└──────────────────────────────────────────────────────────────┘
```

### 1.2 Principe directeur

> **L'affichage n'expose jamais tout en même temps. Il révèle progressivement (progressive disclosure) le bon contenu, déclenche l'interactivité au point de friction cognitive de l'utilisateur, et garde la mémoire de travail sous le seuil des 7±2 unités.**

Ce principe s'appuie sur la théorie de la charge cognitive (Sweller) et la divulgation progressive (Nielsen) : montrer l'information uniquement quand elle est nécessaire réduit la charge *extrinsèque* et libère la mémoire de travail pour la charge *intrinsèque* (le concept à apprendre lui-même) [1](https://versions.com/interaction/progressive-disclosure-the-art-of-revealing-just-enough/)[2](https://lollypop.design/blog/2025/may/progressive-disclosure/).

### 1.3 Les 3 couches d'une page-nœud

Chaque nœud s'affiche en **trois couches verticales conceptuelles**, toujours dans le même ordre — ce qui crée un *modèle mental stable* (consistance = charge réduite) :

| Couche | Nom | But cognitif | Composants clés |
|--------|-----|--------------|-----------------|
| **READ** | Comprendre | Encodage initial, sens | **Amorçage Cognitif IMPRINT** (pré-requis sémantique), Slides AntV, document NEURON-CHAINS, Active Reading Layer, COSMOS inline, vidéo timestampée |
| **DO** | Pratiquer | Récupération active (active recall) | Exercices par domaine, flashcards APEX inline, Teach-Back, Cloze à la volée |
| **PROVE** | Démontrer | Consolidation + métacognition | SMI live, IMPRINT, Miroir Cognitif, validation de nœud |

L'utilisateur descend naturellement READ → DO → PROVE, mais le **LEARNING-CONDUCTOR** (Agent-04) peut réordonner (ex. commencer par 5 flashcards dues avant la lecture). L'affichage suit la décision de l'agent, pas l'inverse.

---

## 2. Les 7 Lois Cognitives

Toute décision d'affichage du Course Display Engine doit pouvoir se justifier par au moins une de ces 7 lois. Elles sont la *constitution* de l'interface.

| # | Loi | Application concrète dans la page-nœud |
|---|-----|----------------------------------------|
| **L1** | **Charge cognitive (Sweller)** | On n'affiche jamais plus d'une tâche cognitive principale par écran visible ; tout le reste est replié/différé [3](https://www.ijraset.com/research-paper/reducing-cognitive-load-in-ui-design) |
| **L2** | **Divulgation progressive (Nielsen)** | Détails, sources, exemples extra = repliés derrière un geste explicite |
| **L3** | **7±2 (Miller)** | Max 5–7 éléments interactifs visibles simultanément ; les insights IMPRINT sont limités à 7±2 |
| **L4** | **Récupération active (Roediger/Dunlosky)** | La lecture déclenche du rappel actif (Cloze à la volée, Teach-Back) plutôt que du surlignage passif [4](https://studycardsai.com/blog/active-recall-techniques) |
| **L5** | **Effort désirable (Bjork)** | On préserve une *friction intentionnelle* (pas de copier-coller IMPRINT, masquage avant révélation) |
| **L6** | **Effet de génération (Slamecka & Graf)** | L'user produit (explique, reconstruit) plus qu'il ne reçoit — d'où le Teach-Back et la reconstruction d'arbre |
| **L7** | **Feedback immédiat & contrôle perçu** | Chaque action a un retour < 100 ms (toast, halo, SMI qui bouge) → sentiment de maîtrise |

**Règle d'arbitrage** : si une nouvelle feature d'affichage n'est portée par aucune de ces lois, **elle ne rentre pas dans la page**. C'est le garde-fou anti-surcharge.

---

## 3. Anatomie de la Page

### 3.1 Le Triptyque Adaptatif (desktop ≥ 1024px)

```
┌───────────────────────────────────────────────────────────────────────────┐
│  TOPBAR NŒUD  ·  N8/25 React Context   ·  SMI 62 ▮▮▮▮▮▯▯▯  ·  🎯 cible 70  │
│  [◀ nœud préc.]  [Roadmap ▢]  [🔆/🌙]  [Focus ⌖]  [⏱ 24 min restantes]     │
├──────────────┬────────────────────────────────────────────┬───────────────┤
│  RAIL GAUCHE │            SCÈNE CENTRALE (READ/DO/PROVE)    │  RAIL DROIT   │
│  (Navigation │                                              │  (BRAIN +     │
│   du nœud)   │   ┌──────────────────────────────────────┐  │   contexte)   │
│              │   │ ASCENT Slides (AntV Infographic)     │  │               │
│  ○ Accroche  │   │  ◁  slide 3/10  ▷     [🎯Rapide]      │  │  💬 Professor │
│  ● Concept   │   └──────────────────────────────────────┘  │     AI        │
│  ○ Décompo.  │                                              │               │
│  ○ Exemple   │   ┌── Document (Active Reading Layer) ────┐  │  ❓ 3 questions│
│  ○ Erreurs   │   │ Le useContext permet de partager…    │  │     suggérées │
│  ○ Quiz      │   │ [mot sélectionné → menu radial]      │  │               │
│  ○ Exercice  │   └──────────────────────────────────────┘  │  📎 Sources   │
│              │                                              │     du nœud   │
│  Mini-map    │   ┌── COSMOS inline (Concept Map) ────────┐  │               │
│  cognitive   │   │  [graphe interactif du nœud]         │  │  🧠 Mode      │
│  ▓▓▓▓░░       │   └──────────────────────────────────────┘  │  Socratique   │
└──────────────┴────────────────────────────────────────────┴───────────────┘
```

**Zones et responsabilités :**

| Zone | Contenu | Comportement |
|------|---------|--------------|
| **Topbar nœud** | Position DAG (N8/25), barre SMI live, cible, timer de session, toggles thème/Focus | Sticky, se compacte au scroll (réduit de 64→40px) |
| **Rail gauche** | Sommaire des 8–10 sections du nœud + mini-map cognitive (§5.3) | Scroll-spy : la section active s'illumine ; clic = scroll doux |
| **Scène centrale** | Le contenu actif (slides, doc, COSMOS, vidéo, exercices) — **une couche READ/DO/PROVE à la fois** | C'est ici qu'opère la divulgation progressive |
| **Rail droit** | BRAIN/Professor AI contextuel, 3 questions suggérées, sources, mode Socratique | Repliable ; en Focus mode, devient un onglet flottant |

### 3.2 Responsive — dégradation gracieuse

| Breakpoint | Adaptation |
|-----------|------------|
| **Desktop ≥ 1024px** | Triptyque complet (3 colonnes) |
| **Tablet 600–1024px** | 2 colonnes : scène + rail droit en *drawer* déclenché à la demande ; rail gauche en barre supérieure horizontale (chips de sections) |
| **Mobile < 600px** | 1 colonne ; navigation par **bottom bar** (READ · DO · PROVE · BRAIN) ; BRAIN en feuille modale ; gestes : swipe horizontal = slides, tap long = menu de sélection |

Le mobile suit les recommandations de réduction de charge : navigation par barre inférieure, gestes, cibles tactiles espacées, contenu personnalisé pour éviter la surcharge de choix [3](https://www.ijraset.com/research-paper/reducing-cognitive-load-in-ui-design).

### 3.3 Le rythme vertical « 1 idée = 1 bloc »

La scène centrale n'est jamais un mur de texte. Le document est segmenté en **blocs sémantiques** (issus des sections NEURON-CHAINS), chacun avec :
- un **titre court** (≤ 6 mots),
- un **corps** (1 idée),
- une **ancre d'interaction** (icône discrète : *expliquer / créer carte / visualiser*),
- un **état de maîtrise** (point coloré : non vu / lu / pratiqué / maîtrisé).

Cela crée une lecture *scannable* et donne un sentiment de progression mesurable bloc par bloc.

---

## 4. Le Moteur de Lecture Interactive

C'est **le cœur de la demande** : rendre la lecture vivante. Le *Active Reading Layer* transforme tout texte affiché (document, transcript, slide, réponse BRAIN) en surface interactive.

### 4.1 Sélection intelligente

**Comportement principal** — dès que l'utilisateur **sélectionne un mot, une phrase ou un paragraphe**, un **menu radial contextuel** (Radial Action Menu) apparaît à côté de la sélection, sans recouvrir le texte.

```
            Le useContext permet de partager des données
                      ╭──────────────╮
                      │  ✶ sélection │
                      ╰──────┬───────╯
            ┌────────────────┼────────────────┐
        ┌───────┐        ┌───────┐         ┌───────┐
        │💬 BRAIN│       │⚡ Carte│        │👁 Voir │
        │Expliquer│      │ APEX   │        │ COSMOS  │
        └───────┘        └───────┘         └───────┘
        ┌───────┐        ┌───────┐         ┌───────┐
        │📝 Note │       │🔊 Lire │        │🌐 Trad.│
        └───────┘        └───────┘         └───────┘
```

**Détails d'interaction :**
- Apparition < 80 ms (L7), animation de halo doux autour de la sélection.
- Position intelligente : au-dessus si place, sinon en dessous ; jamais hors écran.
- L'action par défaut (la plus utilisée contextuellement) est **mise en avant** (plus grande, accent couleur) pour réduire le temps de décision (Hick's Law) [4](https://studycardsai.com/blog/active-recall-techniques).
- Raccourci clavier : après sélection, `E` = Expliquer, `C` = Carte, `V` = Visualiser.
- Mobile : *tap long* → menu radial en arc tactile.

**« Expliquer avec BRAIN »** — l'action signature :
1. La sélection est envoyée à BRAIN **avec le contexte du nœud** (nœud courant, SMI par dimension, niveau Bloom, sources du nœud, score du dernier exercice — voir A.3 §15).
2. BRAIN répond **dans le rail droit** (pas de pop-up bloquant), calibré au niveau de l'utilisateur (ELI5 → ELI PhD selon SMI).
3. La réponse est elle-même un texte du *Active Reading Layer* → l'user peut re-sélectionner dedans (exploration en profondeur).
4. Un lien d'ancre relie la réponse au passage source (clic = re-scroll vers le texte).

### 4.2 Les 9 actions contextuelles

Le menu radial expose au maximum **6 actions** à la fois (L3), choisies dynamiquement parmi 9 selon le type de sélection et le domaine :

| Action | Icône | Déclencheur | Effet |
|--------|-------|-------------|-------|
| **Expliquer avec BRAIN** | 💬 | Toujours | Réponse contextuelle dans le rail droit |
| **Créer une flashcard APEX** | ⚡ | Toujours | Génère une carte (B02/B03/B08) pré-remplie, éditable, ajoutée au deck du nœud |
| **Voir dans COSMOS** | 👁 | Le terme est un concept du KG | Surligne le nœud-concept dans la COSMOS inline + ouvre une hover-card |
| **Prendre une note** | 📝 | Toujours | Note ancrée au passage (marge), exportable, visible au survol |
| **Lire à voix haute (TTS)** | 🔊 | Toujours | Lecture audio du passage (multimodal, carte B10) |
| **Traduire** | 🌐 | Domaine Langues / user multilingue | Traduction inline non destructive |
| **Simplifier (ELI5)** | 🧒 | Phrase/paragraphe | Réécriture ton T41 (ELI5) au-dessus de l'original |
| **Approfondir (ELI PhD)** | 🎓 | Phrase/paragraphe | Réécriture ton T42 + sources académiques |
| **Marquer comme « point flou »** | ❓ | Toujours | Signale à l'ADAPTIVE-ROUTER → influence la remédiation & priorise une révision |

> **Micro-feature cognitive** : l'action **« point flou » (❓)** alimente directement le SMI et le DRIFT-GUARDIAN. Un nœud avec beaucoup de points flous déclenche une **simplification automatique** ou une nouvelle source (CONTENT-SCOUT re-déclenché). L'utilisateur *enseigne au système où il bloque*, simplement en surlignant.

### 4.3 Glossaire Vivant

Les **concepts-clés du nœud** (issus de `key_concepts` du `SkillNode`) sont **soulignés en pointillé subtil** dans tout le texte. Au survol (ou tap mobile) → **hover-card** :

```
┌────────────────────────────────────┐
│  useContext                  SMI 58 │
│  ─────────────────────────────────  │
│  Hook React qui lit une valeur de   │
│  Context sans prop drilling.        │
│                                     │
│  Prérequis : useState ✅            │
│  Relié à : Context API, Provider    │
│  [👁 Voir dans COSMOS] [⚡ Réviser]  │
└────────────────────────────────────┘
```

- La hover-card montre le **SMI personnel** de ce concept (couleur) → l'user voit *en lisant* ce qu'il maîtrise déjà.
- Aucun rechargement : données pré-injectées (le KG du nœud est local à la page).
- Les concepts **non maîtrisés** (SMI < 40) ont un soulignement légèrement plus chaud → guidage visuel discret vers ce qui mérite attention.

### 4.4 Active Recall Inline

**Cloze à la volée (game-changer L4/L6)** : pendant la lecture, le système peut **masquer dynamiquement** un terme-clé déjà rencontré et inviter l'user à le retrouver, *sans quitter la lecture* :

```
  Le hook ⟦ _________ ⟧ permet de partager des données
           ▲ tape ta réponse ou clique pour révéler
```

- Déclenché avec parcimonie (1 cloze toutes ~3 sections, jamais 2 d'affilée — L1).
- Bonne réponse → +XP discret, halo vert, la carte APEX correspondante gagne en stabilité FSRS.
- Mauvaise réponse / révélation → la carte est priorisée pour révision (pas de pénalité affichée — on évite la honte, cf. STUDENT AI).
- **Réglage utilisateur** : intensité du rappel actif (Off / Léger / Standard / Intensif) — respect du contrôle perçu (L7).

**Surlignage actif vs passif** : le surlignage classique est *passif* et donne une illusion de maîtrise (fluency bias) [4](https://studycardsai.com/blog/active-recall-techniques). Ici, surligner **ouvre toujours une action** (menu radial) — on transforme un geste passif en geste génératif (L6).

### 4.5 Le Moteur de Rendu Technique Multi-Vues (Math, Code, Équations, Diagrammes) (D-UX-015) 🔴 COGNITIVE AFFORDANCE

Pour les cours techniques (Mathématiques, Finance, IA, Chimie, Algorithmique), les équations et les syntaxes brutes écrites en texte simple fatiguent la mémoire de travail et provoquent des erreurs de lecture. Le *Active Reading Layer* intègre un **Moteur de Rendu Technique Multi-Vues** inspiré de la polyvalence de Notion.

#### A. Équations Mathématiques & Notations Scientifiques (LaTeX / KaTeX) :
Toutes les équations mathématiques générées par NEURON-CHAINS en Markdown (en blocs `$$ ... $$` ou inline `$ ... $`) sont détectées et compilées à la volée côté client à l'aide de la bibliothèque ultra-rapide **`KaTeX`** (0$ de coût serveur, défilement à 60 FPS constants).
- **Notations couvertes** : Algèbre matricielle, calcul intégral/différentiel, séries de Fourier, équations physiques de l'IA (ex: formule de rétropropagation), et formules chimiques structurées (chemfig).

#### B. Blocs de Code Haute-Fidélité :
- Rendu de syntaxe colorée multi-langages (Shiki / Prism.js) avec thèmes sombres/clairs dynamiques [D-QUAL-001].
- Indicateurs de numéros de lignes, bouton "Copier le code", et badge du langage.
- **Playground interactif** : Les blocs de code (HTML, JS, Python, Rust) intègrent un bouton `[▶ Exécuter]` permettant de faire tourner le code localement (WASM) et d'afficher le résultat directement sous la forme de cours, favorisant l'apprentissage expérientiel.

#### C. Toggles de Multi-Vues Sémantiques (La Matrice des 50+ Vues de Blocs) :
Comme dans Notion, lorsqu'un bloc technique est rendu, un petit menu de toggle en haut à droite du bloc permet à l'utilisateur de **choisir la vue et la syntaxe qui s'adapte le mieux à sa forme de compréhension** :
* **Vue Mathématique** (LaTeX formaté) $\leftrightarrow$ **Vue Sémantique** (Explication textuelle de l'équation) $\leftrightarrow$ **Vue Code** (Formule traduite en script Python/Rust) $\leftrightarrow$ **Vue Graphique** (COSMOS micro-coordonnée) $\leftrightarrow$ **Vue Diagramme** (Mermaid.js ou AntV Infographic).
* *Bénéfice* : Respect de la loi **L7 (Contrôle perçu)** et du Double Codage. L'apprenant n'est jamais bloqué par une formulation : s'il ne comprend pas l'équation mathématique, il bascule en 1 clic sur l'explication sémantique ou le schéma visuel.

---

## 5. Orchestration COSMOS

Les notes prévoyaient COSMOS comme module séparé (25 modes). Le Course Display Engine **embarque COSMOS *dans* la page-nœud**, piloté automatiquement.

### 5.1 COSMOS Inline Director

L'**Agent-03 (DAG-ARCHITECT)** marque chaque section du nœud avec un *type de structure cognitive*. Le **COSMOS Inline Director** choisit alors le **mode de visualisation optimal** et l'insère au bon endroit (décision D-COSMOS-012 du PRD : auto-suggestion du mode).

| Structure de la section | Mode COSMOS inline auto-choisi | Exemple |
|-------------------------|-------------------------------|---------|
| Réseau de concepts liés | **Concept Map (M9)** | Relations entre hooks React |
| Hiérarchie / taxonomie | **Sunburst (S10)** / **Treemap (S11)** | Arborescence d'API |
| Séquence / prérequis | **Roadmap DAG (M4)** | Ordre d'apprentissage |
| Comparaison multi-critères | **Radar (M14)** | useState vs useReducer |
| Flux / transformation | **Sankey (M13)** | Cycle de rendu |
| Corrélations | **Heatmap (M16)** | Concepts qui s'entraident |
| Statistiques de progression | **Stats (M7)** | SMI dans le temps |

**Règle anti-surcharge (L1)** : **un seul visuel COSMOS majeur déplié par écran visible**. Les autres sont des **vignettes repliées** (placeholder cliquable « Voir le schéma ▸ ») — divulgation progressive (L2).

### 5.2 Blocs Visuels Embarqués

Chaque bloc COSMOS inline propose :
- **Aperçu statique léger** (SVG) au chargement (perf : pas de WebGL tant que non-déplié).
- **Drill-down** au clic : passage en mode interactif (zoom, filtres, sélection de nœud).
- **Pont vers la lecture** : sélectionner un nœud du graphe surligne le passage de texte correspondant (et inversement, via l'action 👁 du §4.2) → **lecture et visualisation se répondent**.
- **Bouton « Plein écran COSMOS »** : ouvre le module COSMOS complet (25 modes) avec le nœud pré-filtré, pour l'exploration profonde, puis retour à la page.

### 5.3 Mini-map Cognitive

Dans le rail gauche, une **mini-map** représente le nœud comme un **petit graphe de ses 8–10 sections/concepts**, colorés par état de maîtrise :

```
   Mini-map du nœud « React Context »
        (●)──(●)──(○)
         │         │
        (◐)──────(○)──(○)
   ● maîtrisé  ◐ en cours  ○ non vu
```

- Donne une **vue d'ensemble** (réduit l'anxiété de « où j'en suis »).
- Clic sur un point = saut vers la section.
- Se remplit en temps réel à mesure que l'user lit/pratique → **feedback de progression** (L7) et **effet de complétion** (motivation).

### 5.4 La MiniMap GPS interactive de viewport (D-UX-013) 🔴 HAUTE

Pour éviter que l'apprenant ne perde ses repères sémantiques lors de zooms profonds sur un concept de détail (LOD 2 ou LOD 3) dans les graphes volumineux (Modes 0, 2 ou 25), un composant interactif **MiniMap (GPS de Graphe)** est intégré en bas-droite du canvas.
- **Le Composant** : Un widget semi-transparent (180x120px) affichant la silhouette complète du graphe en miniature, avec un viseur rectangulaire de couleur délimitant la zone active d'écran (viewport).
- **Navigation Interactive** : Faire glisser le viseur de la MiniMap applique une translation physique (pan) instantanée de la caméra principale, permettant de naviguer à travers 100 000 concepts de manière fluide avec une consommation CPU de seulement **0.05ms** par frame.

### 5.5 Pre-render Skeletons & L'Allumage Neural (The Neural Ignition Reveal) (D-UX-002) 🔴 WAOUH EFFECT

Les squelettes de chargement classiques (shimmers gris et plats) sont inadaptés et ennuyeux pour un graphe de connaissances vivant. COSMOS met en scène le chargement à l'aide d'une **séquence cinématique interactive d'allumage neural (The Neural Ignition Reveal)** à coût serveur de 0$ (calculé par GPU client) :
1. **La Constellation (0ms – 500ms)** : Fond sombre d'espace cognitif avec micro-particules WebGL flottantes.
2. **L'Étincelle des Hubs (500ms – 1.5s)** : Les concepts majeurs (PageRank élevé) s'allument comme des nébuleuses lumineuses pulsantes, projetant des faisceaux laser de connexions.
3. **La Condensation (1.5s – 3s)** : Les sous-concepts (dont le **Mode 25 - Knowledge Cards** avec leurs squelettes shimmer locaux en verre dépoli) apparaissent organiquement le long des lignes de force.
4. **La Stabilisation (3s+)** : La simulation physique s'amortit et les étiquettes textuelles apparaissent de manière fluide par transition flou-net (*blur-to-focus transition*).

---

## 6. ASCENT Slides

Reprise et **approfondissement** de l'annexe A.4. Les slides sont la première couche READ et utilisent **AntV Infographic** — un moteur déclaratif de génération d'infographies, *AI-friendly*, qui rend des infographies de haute qualité en SVG à partir d'une syntaxe textuelle, avec rendu en streaming progressif et ~200 templates intégrés [5](https://github.com/antvis/Infographic)[6](https://github.com/antvis/Infographic/blob/main/README.md). L'écosystème inclut **InfographicAI** (génération de slides type PPT propulsée par Infographic) [5](https://github.com/antvis/Infographic).

### 6.1 Pipeline Slides

```
SkillNode (sections + key_concepts + bloom_level + sources)
        │
        ▼
[Slide Planner]  → choisit le template AntV Infographic par slide
        │           (ex: list-row-simple-horizontal-arrow pour une séquence,
        │            compare-binary-* pour une comparaison,
        │            hierarchy-tree-* pour une taxonomie,
        │            quadrant-* pour une matrice)         [5][7]
        ▼
[Syntax Generator] → produit la SYNTAXE Infographic (déclarative, tolérante)
        │
        ▼
[Streaming Renderer] → rend en SVG, progressivement (l'user voit la slide
        │                se construire — engagement + perception de vitesse)  [6]
        ▼
[Interactivity Binder] → attache les hotspots (BRAIN, note, flashcard, COSMOS)
```

**Pourquoi AntV Infographic plutôt que des images statiques :**
- **SVG net à toute échelle** (dark/light via variables CSS, pas de ré-export) [7](https://www.xugj520.cn/en/archives/antv-infographic-ai-visualization-framework.html).
- **Syntaxe déclarative générable par IA** → NEURON-CHAINS produit directement la slide, coût quasi nul [5](https://github.com/antvis/Infographic).
- **Streaming** → la slide apparaît au fil de la génération, évitant l'écran d'attente [6](https://github.com/antvis/Infographic/blob/main/README.md).
- **Éditable** (éditeur intégré) → l'user/expert peut raffiner une slide après génération [7](https://www.xugj520.cn/en/archives/antv-infographic-ai-visualization-framework.html).
- **MVP coût 0 $** (cohérent avec A.4 : Mermaid/D3/Prism → ici AntV Infographic en SVG).

> **Note d'implémentation** : la slide rendue par AntV Infographic vit dans un conteneur SVG inline ; le toggle dark/light pilote les variables de thème AntV. Pour la preview sandbox (sans réseau), les slides sont rendues côté client à partir de la syntaxe embarquée — aucun asset externe requis.

### 6.2 Template par Nœud (8–10 slides) — enrichi

| # | Slide | Rôle pédagogique | Template AntV suggéré | Interaction signature |
|---|-------|------------------|-----------------------|------------------------|
| 1 | **Accroche** | Capturer l'attention | Visuel impactant + question | Vote rapide « je sais / je ne sais pas » (calibration métacognitive d'entrée) |
| 2 | **Le Problème** | Ancrage par analogie monde réel | `list-row` / illustration | Bouton « une autre analogie » (BRAIN) |
| 3 | **Le Concept** | Définition + code/formule | `hierarchy-tree` / card | Concept ajouté au Glossaire Vivant |
| 4 | **Décomposition** | Step-by-step animé | `sequence-zigzag-steps` [7] | Révélation progressive étape par étape (L2) |
| 5 | **Exemple Concret** | Cas réel | card + code | « Exécuter / Voir le résultat » |
| 6 | **Erreurs Communes** | Pièges à éviter | `compare-binary` (bon/mauvais) | Quiz « repère l'erreur » |
| 7 | **Comparaison** | vs autres approches | `quadrant` / `compare` [7] | Radar COSMOS (M14) au clic |
| 8 | **Résumé Visuel** | Mind map / synthèse | `hierarchy-tree` | Reconstruire de mémoire (IMPRINT light) |
| 9 | **Vérification** | Micro-quiz 3 questions | quiz natif | Score → SMI live |
| 10 | **Connexion** | Lien vers nœud suivant | `list-row-arrow` | Aperçu du prochain nœud + prérequis acquis |

### 6.3 Modes de Navigation & Adaptation SMI

**3 profondeurs de parcours** (l'user choisit, ou l'agent suggère selon le temps dispo) :

| Mode | Slides | Quand |
|------|--------|-------|
| 🎯 **Rapide** | 5 slides essentiels | Micro-session, révision, SMI déjà élevé |
| 📚 **Standard** | 10 slides complets | Première découverte |
| 🔬 **Approfondi** | 15 slides + sources + exemples extra | SMI cible expert, domaine complexe |

**Adaptation SMI automatique (reprise A.4, précisée) :**
- `D1 (Rétention) < 50` → **insère une slide de révision des prérequis** (juste avant le concept).
- `D3 (Profondeur) < 50` → **ajoute 2 exemples concrets** (slide 5 dupliquée avec cas alternatifs).
- `D5 (Miroir/Enseignement) < 50` → **ajoute une slide « comment l'expliquer à quelqu'un »** + déclenche un Teach-Back court.
- **Nouveau** : `point flou (❓) > 2 sur la section` → **slide ELI5 injectée** automatiquement.

### 6.4 Interactivité par Slide

Chaque slide expose une **barre d'actions discrète** (apparaît au survol, masquée sinon — L1) :

```
[▶ Voir dans la vidéo source]   ← timestamp intelligent (§7)
[💬 Poser une question BRAIN]
[📝 Prendre une note]
[⚡ Créer une flashcard]
[👁 Visualiser (COSMOS)]
```

- Toute zone de texte d'une slide est dans le *Active Reading Layer* (§4) → sélectionnable.
- **Progress dots** des slides = aussi un indicateur de complétion (gamification douce).

### 6.5 Generative-Canvas-AI (FlowSeek) — Le Dessin de Schéma en Streaming (D-UX-014) 🔴 HAUTE

Pour expliquer des processus séquentiels, des flux logiques ou des architectures systèmes complexes au sein des slides ASCENT et des pages de cours, l'IA ne se contente pas d'afficher des images ou des infographies statiques (`InfographicAI`). Elle utilise **Generative-Canvas-AI (FlowSeek)** :

- **Le Principe** : L'agent IA (`NEURON-CHAINS`) émet en streaming un flux JSON d'événements structurés (via `streamObject` du Vercel AI SDK). Le frontend React Flow (`@xyflow/react`) intercepte ce flux en temps réel et délègue à la bibliothèque académique **`elkjs`** (s'exécutant dans un Web Worker en local pour un coût de 0$ de calcul serveur) le recalcul de la disposition géométrique ($x, y$) en moins de **10ms**.
- **Visualisation Cinématique** : L'apprenant voit littéralement le schéma prendre vie et se dessiner sous ses yeux de manière animée à 60 FPS (les cartes se condensent un à un et des particules lumineuses se déplacent de manière fluide le long des courbes de Bézier à l'aide de l'attribut CSS `offset-path`), au rythme de l'écriture ou de l'explication du tuteur.

#### 📝 Synergie & Complémentarité : InfographicAI ↔ Generative-Canvas-AI (FlowSeek)

Dans l'écosystème d'apprentissage de SCY Forge, ces deux moteurs d'illustration générative opèrent en parfaite synergie, chacun couvrant un hémisphère distinct de la compréhension :

| Dimension | InfographicAI (Le Noyau Factuel & Quantitatif) | Generative-Canvas-AI / FlowSeek (Le Noyau Structurel & Procédural) |
|-----------|------------------------------------------------|-------------------------------------------------------------------|
| **Rôle Cognitif** | Synthétiser et comparer des données factuelles, numériques, tabulaires ou comparatives (Dual Coding). | Visualiser des flux d'exécution, des étapes séquentielles, des dépendances de cause à effet et des architectures sémantiques. |
| **Moteur Visualisé** | Graphiques (barres, courbes, camemberts), matrices de décisions, tableaux comparatifs multicritères, diagrammes de répartition. | Graphes nodaux interactifs, arbres décisionnels, pipelines d'intégration, diagrammes de flux d'informations animés. |
| **Technologie Rendu** | Canvas 2D / SVG (`recharts` ou `nivo` spécialisé). | Canvas interactif React Flow (`@xyflow/react`) + Solveur d'auto-layout local `elkjs`. |
| **Type d'Explication** | *"Voici la répartition des coûts ou la comparaison des performances entre 3 algorithmes."* | *"Voici le chemin physique exact qu'un paquet réseau parcourt à travers ces 4 services pour s'authentifier."* |
| **Streaming Style** | Les barres ou les lignes de données montent ou se tracent au fur et à mesure que les nombres sont calculés. | Les nœuds de cartes (Knowledge Cards) se condensent un à un et des particules lumineuses se mettent à glisser le long des bras de force. |
| **Interactivité** | Hover sur les barres pour afficher des tooltips de données, filtres statiques. | Drag-and-drop, zoom sémantique sans limite, survol comportemental des cartes, MiniMap GPS de navigation. |

---

## 7. Timestamps Intelligents

Reprise et approfondissement de l'annexe A.5 — l'affichage relie chaque concept à **l'instant exact** de la vidéo source.

### 7.1 Fonctionnement

```
Ingestion YouTube → transcript découpé par timestamp
   → chaque concept extrait lié à son timestamp exact
   → dans le nœud : bouton [▶ Voir à 12:34]
   → clic → lecteur démarre exactement au bon moment
```

**Table** `scy_content_timestamps` : `content_hash · concept_id · timestamp_start · timestamp_end · relevance_score (0.0–1.0)`.

### 7.2 Affichage dans la page

- **Lecteur vidéo embarqué** (couche READ) avec une **piste de chapitres-concepts** : la timeline est segmentée et colorée par concept ; survoler un segment montre le concept ; cliquer saute au concept.
- **Synchronisation lecture ↔ transcript** : pendant la lecture, la ligne de transcript active se surligne (et reste sélectionnable → menu radial §4).
- **Boutons inline** : dans le document et les slides, `[▶ Voir à 12:34]` ouvre le lecteur au bon instant *sans quitter la page* (mini-lecteur picture-in-picture en bas du rail).

### 7.3 Redirection sources non-embeddables

```
→ Deep Link avec Context Card :
  « SCY Forge a extrait les points clés pour toi »
  [Ouvrir dans un nouvel onglet]
→ Détection de retour : « Tu as regardé la vidéo ? »
→ Adaptation de l'exercice selon la réponse
```

> **Micro-feature** : la **Context Card** affiche les 3–5 points clés extraits + leurs timestamps *avant* d'envoyer l'user sur la source externe → il sait quoi chercher (réduit la dispersion, charge L1).

---

## 8. BRAIN dans la Page

Reprise et approfondissement de l'annexe A.3 — BRAIN n'est pas un chatbot, c'est **un professeur qui sait exactement où en est l'utilisateur**. Dans la page-nœud, il vit dans le **rail droit** (ou drawer mobile).

### 8.1 Les 5 capacités, traduites en affichage

| Capacité (A.3) | Affichage concret |
|----------------|-------------------|
| **1. Réponse contextuelle** | Réponses dans le rail, badge de contexte visible : `N8/25 · Bloom: Apply · SMI 62` (transparence) |
| **2. Auto-suggestions** | Bloc **« 3 questions à te poser »** sous chaque section, classées par niveau Bloom, cliquables (génération via graph COSMOS 2-hop, T16, ~0 token) |
| **3. Mode Socratique** | Toggle 🧠 ; BRAIN ne donne plus la réponse mais guide ; déclenché auto si l'user pose 3× la même question / remédiation type 5 |
| **4. Miroir Cognitif** | Bouton **« Explique-moi ça »** : BRAIN joue le débutant, l'user enseigne → score D5 du SMI |
| **5. Contexte injecté** | Toujours : nœud, SMI/dimension, Bloom, sources, historique BRAIN du nœud, score dernier exercice |

### 8.2 Professor AI — accompagnateur global

- Présent à **chaque niveau** du parcours ; connaît le DAG complet (vue d'ensemble) et le contenu de tous les nœuds.
- **Vulgarise** selon la classification du Starter Evaluator (ELI5 → ELI PhD).
- Bouton flottant persistant en Focus mode.

### 8.3 Double alimentation (Projet / Internet / Hybride)

Un sélecteur dans l'en-tête du rail BRAIN : `Projet seul · Internet seul · Hybride (défaut)`. L'icône change pour signaler clairement à l'user la **provenance** de la réponse (conformité AI Act : transparence sur le contenu IA, cf. PRD Risque 10).

---

## 9. Bloc Exercices

Couche **DO**. La *forme* de l'exercice change selon le domaine (le SMI 5 dimensions, lui, reste identique — cohérence PRD).

### 9.1 Affichage adaptatif par domaine

| Domaine | Forme de l'exercice affichée | Validation |
|---------|------------------------------|------------|
| **Tech / Code** | Éditeur de code inline + sortie exécutable | Output vérifiable automatiquement |
| **Logiciel** | Upload de screenshot du résultat | GPT-4o Vision compare au résultat attendu (§11) |
| **Business** | Étude de cas + zone d'argumentation | Rubrique LLM |
| **Langues** | Production orale (micro) / écrite + correction inline | Whisper + correction |
| **Sciences** | Résolution de problème pas-à-pas + démonstration | Vérification étapes |
| **Arts** | Upload de production + rubrique | Rubrique visuelle |
| **Soft skills** | Simulation de dialogue (BRAIN joue un rôle) | Feedback comportemental |

### 9.2 Flashcards APEX inline

- Les cartes créées via le menu radial (§4.2) apparaissent dans un **deck flottant du nœud** (badge « 4 cartes prêtes »).
- **Révision express inline** : un mini-mode de révision (flip + feedback 4 niveaux Again/Hard/Good/Easy) sans quitter la page.
- Raccourcis : `Space` flip · `1-4` feedback · `U` undo (cohérent APEX §7.5 PRD).

### 9.3 Validation de nœud (passage PROVE)

Un **panneau de fin de nœud** synthétise :
```
┌─────────────────────────────────────────────┐
│  Nœud « React Context »   SMI 71 ✅ (cible 70)│
│  Rétention 74 · Profondeur 70 · Miroir 68    │
│  Métacog. 72 · Cohérence 75                  │
│  ─────────────────────────────────────────── │
│  ✅ 9 sections lues   ✅ 6 exercices (83%)    │
│  ⚡ 12 cartes créées   🧠 1 Teach-Back        │
│                                              │
│  [🎉 Valider & nœud suivant]  [Consolider]   │
└─────────────────────────────────────────────┘
```
- Si SMI ≥ cible → **célébration légère** (confetti court, +XP, badge éventuel) puis aperçu du nœud suivant.
- Si SMI < cible → l'ADAPTIVE-ROUTER propose **Consolidation** (exercices/cartes ciblés sur les dimensions faibles), affichée comme un plan court et clair.

### 9.4 La Suite Complète d'Examens & Formulaires Interactifs (SurveyJS Suite Integration) 🔴 SYSTEM ENGINE

Pour éviter d'avoir à coder manuellement des dizaines d'interfaces d'examens, d'outils d'administration pour les enseignants, de tableaux de bord statistiques ou de moteurs de génération de PDF, SCY Forge intègre la suite complète **SurveyJS Suite** (Form Library, Survey Creator, Dashboard, PDF Generator). 

Cette suite s'intègre de manière bidirectionnelle avec la pipeline des **13 agents autonomes d'ASCENT** et la chaîne de génération **NEURON-CHAINS**, couvrant le cycle de vie complet de l'évaluation :

```
[Agent IA (NEURON-CHAINS)] ──(Génère JSON)──► [Survey Creator (Validation/Édition Expert)]
                                                               │
                                                               ▼
[Générateur PDF] ◄── [Form Library (Rendu/Examen)] ◄───[Schéma JSON final validé]
   (Export local)        (Timer + Multi-pages)
                               │
                               ▼
                        [PostgreSQL DB] ──► [SurveyJS Dashboard (Analytics SMI)]
```

#### A. Les 4 Piliers de la Suite SurveyJS & Leurs Rôles dans SCY Forge :

1. **`Form Library` (Moteur de Rendu d'Examens — MIT)** :
   * *Rôle* : C'est le runner qui affiche les examens au niveau des nœuds (`AGENT-04`) et l'évaluation finale (`AGENT-09`). Il traduit instantanément les schémas JSON générés par l'IA en formulaires d'examens interactifs complexes, hautement responsives, avec un coût d'opération serveur de **0$**.
   * *Fonctionnalités* : Wizards de navigation multi-pages avec barre de progression, minuteur d'examen global et par question avec soumission automatique, notations et calculateur de score automatique, et logique conditionnelle (branching).

2. **`Survey Creator` (Éditeur Visuel pour Experts — Auto-hébergé)** :
   * *Rôle* : Intégré dans l'espace Administrateur / Éducateur de SCY Forge. Bien que `NEURON-CHAINS` génère les examens de manière autonome, les experts pédagogiques ou les concepteurs de cours peuvent ouvrir le `Survey Creator` (WYSYWIG drag-and-drop) pour réviser visuellement, affiner, corriger ou ajouter manuellement des questions à l'examen généré par l'IA avant sa mise en ligne.
   * *Bénéfice* : Gain de temps de développement de **-95%** sur la création d'outils d'édition d'examens.

3. **`Dashboard` (Visualisation & Analyses de Données d'Examens)** :
   * *Rôle* : Utilisé par le `PERFORMANCE-ANALYZER` (`AGENT-05`) et l'`ENGAGEMENT-AMPLIFIER` (`AGENT-08`). Il affiche instantanément, au sein du profil de l'utilisateur ou du tableau de bord de l'instructeur, des graphiques et des tables interactifs (courbes de réussite, répartition des scores, diagrammes de corrélation de fautes).
   * *Bénéfice* : Plus de code de dataviz à écrire manuellement pour les examens ; le dashboard s'alimente directement des données JSON de soumission.

4. **`PDF Generator` (Génération locale de rapports d'examens)** :
   * *Rôle* : Intégré au sein du `SKILL-CERTIFIER` (`AGENT-09`). Il permet à l'apprenant de télécharger instantanément au format PDF (en lecture seule ou modifiable) son examen final corrigé, avec ses réponses et les explications détaillées de l'IA, de manière autonome en local dans son navigateur.

#### B. Thème & Intégration Visuelle (Tailwind Sync) :
- La suite s'intègre via des variables CSS thématiques. Le thème de l'examen hérite directement de notre système de design et s'adapte dynamiquement au mode sombre/clair (`D-QUAL-001`).
- Toutes les données de soumission d'examen sont stockées de manière sécurisée en base cloud (PostgreSQL, table `scy_skill_final_assessments`).

---

## 10. Les 12 Micro-Features Game-Changer

Chacune est **petite**, **justifiée cognitivement**, et **désactivable** (contrôle perçu, L7). Elles boostent rétention et concentration *sans* alourdir l'écran.

| # | Micro-feature | Ce qu'elle fait | Loi(s) | Impact visé |
|---|---------------|-----------------|--------|-------------|
| **1** | **Focus Mode ⌖** | Masque rails + topbar, ne laisse que le contenu actif ; assombrit le hors-focus (spotlight) | L1, L7 | Concentration ; -surcharge |
| **2** | **Active Reading Layer** | Toute sélection → menu radial (§4) | L4, L6 | Lecture générative |
| **3** | **Cloze à la volée** | Masque un terme déjà vu, invite à le retrouver (§4.4) | L4, L5 | Récupération active |
| **4** | **Point flou ❓** | L'user surligne ce qu'il ne comprend pas → pilote la remédiation | L7 | Adaptation + agentivité |
| **5** | **Glossaire Vivant** | Concepts soulignés, hover-card avec SMI perso (§4.3) | L2, L7 | Guidage discret |
| **6** | **Mini-map cognitive** | Vue d'ensemble du nœud, se remplit en direct (§5.3) | L7 | Sentiment de progression |
| **7** | **Reading Pacer / Bionic** | Option de mise en gras du début des mots + barre de rythme de lecture | L1 | Vitesse + concentration |
| **8** | **Streak de focus** | Compteur de minutes de concentration ininterrompue (pause = reset doux), visible discrètement | L7 | Motivation, pas de pression |
| **9** | **Confidence check d'entrée** | Slide 1 : « je sais / je ne sais pas » → calibre la profondeur | L4 | Métacognition |
| **10** | **Teach-Back inline** | Bouton « Explique-moi » → BRAIN joue l'élève (§8) | L6 | Compréhension profonde |
| **11** | **IMPRINT trigger** | Après 3 succès / nœud complexe : modal de reconstruction d'arbre manuscrit (friction intentionnelle, pas de copier-coller) | L5, L6 | Ancrage long terme |
| **12** | **Smart Resume** | À la réouverture : « Reprendre où tu t'es arrêté » + 1 micro-rappel de la dernière idée | L4, L7 | Continuité, ré-encodage |

### Détails des 3 plus structurantes

**① Focus Mode (⌖)** — un *spotlight* progressif :
- Premier appui : masque rails latéraux.
- Second appui : assombrit tout sauf le bloc en cours de lecture (suit le scroll), réduit l'animation, coupe les notifications non critiques.
- Le DRIFT-GUARDIAN suspend ses interventions non urgentes pendant le Focus.

**⑦ Reading Pacer / Bionic Reading** :
- **Bionic** : met en gras la première moitié de chaque mot pour guider la saccade oculaire (option, car les preuves sont contrastées — d'où *opt-in*).
- **Pacer** : une fine barre de progression-rythme descend à une vitesse réglable (WPM), encourageant un flux régulier sans relecture compulsive (réduit la charge extrinsèque).

**⑪ L'Écosystème Cognitif IMPRINT v2** (transfert numérique $\rightarrow$ manuscrit, §7.8 PRD) :
- **Le Dessin de Feynman (L'IA d'Abord)** : L'IA génère et affiche en premier un schéma intuitif dessiné à la main (Feynman Sketch) expliquant le concept. L'apprenant l'étudie, puis le reproduit de mémoire de sa propre main sur son carnet papier. Il le prend en photo pour validation et indexation sémantique par l'IA.
- **L'Empreinte Vocabulaire** : Rendu et copie manuelle d'un arbre de dérivation étymologique ASCII reliant 10 mots d'élite complexes à leurs synonymes et à leur contexte.
- **L'Arbre de Résolution de Fonctions** : Présente un organigramme de décision logique (flowchart) montrant les étapes de résolution à recopier et à compléter avec les formules de dérivations correspondantes.
- **L'Empreinte Mnémotechnique** : Génération de phrases mnémotechniques fondées sur l'assonance acoustique (rimes/rythme) et l'imagerie insolite (effet Von Restorff) pour mémoriser les listes.
- **Le Code-Scribing** : Copie manuelle d'architectures et de flux de données système complexes (5 nœuds max) pour ancrer la systémique du code.
- **Friction intentionnelle** (L5) : Pas de copier-coller, pas de téléchargement, case à cocher obligatoire : *"J'ai écrit à la main dans mon carnet"* pour déverrouiller la suite.

---

## 11. Software Sprint

Affichage spécialisé pour les **cours de logiciels** (reprise A.6). Ici l'affichage central change de nature : screenshots annotés au lieu de prose.

### 11.1 Affichage à 3 piliers visuels

```
PILIER 1 — Slides + Screenshots annotés
  → Boîtes rouges sur les clics · Flèches sur les menus · Labels sur les panneaux
PILIER 2 — Doc officielle = Source Gold prioritaire (SQS Autorité 40 pts, fraîcheur ×3.0)
PILIER 3 — Bibliothèque visuelle versionnée (table scy_software_assets)
```

### 11.2 Comportement d'affichage spécifique

- **Annotations interactives** : survoler une boîte rouge = tooltip de l'action ; cliquer = étape suivante du workflow (step-by-step, L2).
- **Bandeau version** : chaque nœud affiche la version du logiciel ciblée (ex. « QGIS 3.34 ») ; un crawler surveille les changelogs → badge « contenu à jour ✅ / à vérifier ⚠️ ».
- **Validation objective** : l'user **upload un screenshot** de son résultat → GPT-4o Vision compare → validation non déclarative.
- **Branches métier** (Phase 2) : dialogue BRAIN « Je suis hydrologue » → DAG de 8–12 nœuds spécifiques affiché en surcouche de la roadmap.

> **Règle légale (A.6)** : tous les screenshots sont **générés** par SCY Forge (jamais scrapés) → propriété intellectuelle propre.

---

## 12. Goals Prédéfinis

Affichage **pré-cours** (la page « Goal » avant de cliquer Commencer). Reprise A.7 — friction zéro + preuve sociale.

### 12.1 Données affichées sur la page Goal

```
Titre + compétence visée · Durée (jours + min/jour) · Nœuds / milestones / projet final
Certification + standard officiel
─ Preuve sociale (temps réel) ─
Complétions · SMI moyen obtenu · Taux de certification · Satisfaction · Durée médiane réelle
Témoignages (prénom, statut pro, SMI obtenu) · Progression typique semaine/semaine
Prérequis (avec SMI requis) · Branches de spécialisation (logiciels)
```

### 12.2 Bloc « En ce moment » (live)

```
👥 X personnes apprennent ce Goal maintenant
✅ Y personnes l'ont complété cette semaine
📍 Z apprenants au même nœud aujourd'hui
```
→ Effet de **preuve sociale** + sentiment d'appartenance (motivation), affiché discrètement (L1).

---

## 13. Système de Design

### 13.1 Thème Dark / Light adaptatif

- **Toggle explicite** (🔆/🌙 topbar) + **sync système** (`prefers-color-scheme`) + mémorisation (localStorage).
- Transition douce 200 ms, **WCAG AA dans les deux modes** (contraste ≥ 4.5:1).
- Tout est en **variables CSS** (tokens) → slides AntV SVG, COSMOS, hover-cards héritent du thème sans ré-export.

**Tokens de couleur sémantiques (extrait) :**

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `--bg` | `#FAFAF7` | `#0E1116` | Fond de page |
| `--surface` | `#FFFFFF` | `#161B22` | Cartes, rails |
| `--text` | `#1A1A1A` | `#E6EDF3` | Texte principal |
| `--accent` | `#2F6BFF` | `#5B8CFF` | Actions, liens |
| `--smi-red` | `#E5484D` | `#F2555A` | SMI < 40 |
| `--smi-amber` | `#F5A623` | `#FFB22E` | SMI 40–69 |
| `--smi-green` | `#2FA84F` | `#3FBF63` | SMI 70–85 |
| `--smi-gold` | `#C9A227` | `#E3C04B` | SMI ≥ 86 (expert) |

La couleur SMI est le **fil rouge visuel** de toute l'interface (mini-map, glossaire, panneaux) → un seul langage de couleur = charge réduite.

### 13.2 États d'un bloc de contenu

`non-vu` (point gris) → `lu` (point bleu) → `pratiqué` (point ambre) → `maîtrisé` (point vert/or). Ces états pilotent la mini-map et le panneau de validation.

### 13.3 Inventaire des composants

| Composant | Rôle | États |
|-----------|------|-------|
| `NodeTopbar` | Position, SMI, timer, toggles | normal / compact (scroll) |
| `SectionRail` | Sommaire + mini-map | scroll-spy |
| `SlideDeck` | Slides AntV Infographic | rapide / standard / approfondi |
| `ReadingSurface` | Document + Active Reading Layer | sélection active / repos |
| `RadialMenu` | Menu d'actions de sélection | 6 actions max |
| `ConceptHoverCard` | Glossaire vivant | hover / pinned |
| `CosmosInlineBlock` | Visuel embarqué | aperçu SVG / interactif / plein écran |
| `BrainRail` | Professor AI contextuel | normal / socratique / miroir |
| `ExercisePanel` | Exercice par domaine | en cours / corrigé |
| `ApexDeckFloat` | Cartes du nœud | replié / révision express |
| `NodeValidationPanel` | Fin de nœud | sous-cible / validé |
| `FocusOverlay` | Spotlight Focus mode | off / rails masqués / spotlight |

---

## 14. Spécifications Techniques

### 14.1 Modèle de données d'affichage (extension `SkillNode`)

```rust
/// Vue d'affichage d'un nœud — ce que la page consomme
pub struct NodeDisplayModel {
    pub node: SkillNode,                  // (PRD) id, name, smi_required/achieved, bloom_level...
    pub sections: Vec<DisplaySection>,    // blocs sémantiques ordonnés
    pub slides: SlideDeckSpec,            // syntaxe AntV Infographic par slide
    pub inline_visuals: Vec<CosmosInline>, // visuels COSMOS + ancrage section
    pub glossary: Vec<GlossaryConcept>,   // concepts soulignés + SMI perso
    pub video_segments: Vec<TimestampSeg>,// timestamps intelligents
    pub apex_cards: Vec<CardRef>,         // deck du nœud
    pub brain_context: BrainContext,      // nœud, SMI/dim, bloom, sources, historique
    pub recall_policy: RecallIntensity,   // Off | Light | Standard | Intense
}

pub struct DisplaySection {
    pub id: Uuid,
    pub title: String,                    // ≤ 6 mots
    pub body_md: String,                  // texte (Active Reading Layer)
    pub cognitive_type: CognitiveStructure, // → choix du mode COSMOS inline
    pub key_concepts: Vec<Uuid>,
    pub mastery_state: MasteryState,      // NonVu | Lu | Pratique | Maitrise
}

pub enum CognitiveStructure {
    Network, Hierarchy, Sequence, Comparison, Flow, Correlation, Stats,
}
```

### 14.2 Événements d'interaction (vers EventBus / SMI)

```rust
pub enum CourseDisplayEvent {
    TextSelected     { section_id: Uuid, span: TextSpan, action: RadialAction },
    BrainExplained   { section_id: Uuid, query: String },
    CardCreated      { from_span: TextSpan, card_type: CardType },
    ClozeAnswered    { concept_id: Uuid, correct: bool },
    ConceptHovered   { concept_id: Uuid },
    CosmosDrilldown   { mode: CosmosMode, node_id: Uuid },
    FuzzyMarked      { section_id: Uuid, span: TextSpan },   // ❓ point flou
    SlideViewed      { index: u8, mode: SlideMode },
    VideoSeeked      { concept_id: Uuid, ts: u32 },
    FocusModeToggled { level: u8 },
    SectionMastered  { section_id: Uuid },
    NodeValidated    { smi_achieved: f32 },
}
```

- `FuzzyMarked` → `PERFORMANCE-ANALYZER` (Agent-05) + `ADAPTIVE-ROUTER` (Agent-06).
- `ClozeAnswered` / `CardCreated` → APEX/FSRS (ajuste stabilité).
- `NodeValidated` → `ENGAGEMENT-AMPLIFIER` (célébration) + déverrouillage nœud suivant.

### 14.3 Performance

| Cible | Valeur |
|-------|--------|
| Apparition menu radial | < 80 ms |
| Réponse visuelle à toute action | < 100 ms (L7) |
| Rendu slide AntV (SVG, streaming) | premier paint < 300 ms, progressif ensuite [6] |
| COSMOS inline aperçu | SVG statique (pas de WebGL avant drill-down) |
| Rendu document / scroll | 60 fps |
| Lazy-load | slides hors-écran, COSMOS interactif, lecteur vidéo = à la demande |

### 14.4 Accessibilité (WCAG 2.1 AA)

- **Clavier 100 %** : sélection + actions radiales (`E/C/V`), navigation slides (`←/→`), focus mode (`F`).
- **ARIA** : le menu radial est un `menu` accessible ; les visuels COSMOS ont une alternative textuelle (résumé du graphe) ; les slides SVG ont `aria-label` + une version texte repliée.
- **Lecteurs d'écran** : ordre de lecture READ→DO→PROVE respecté dans le DOM.
- **Mouvement réduit** : `prefers-reduced-motion` coupe streaming animé, confettis, pacer.
- **Contraste** : tokens validés AA en dark et light.

### 14.5 Contraintes de preview sandbox

La preview s'exécute en iframe sandbox sans réseau : slides AntV rendues **côté client** depuis la syntaxe embarquée, visuels COSMOS en **SVG inline**, icônes en SVG, aucune police/CDN externe → l'interface se dégrade proprement (les fonctionnalités live BRAIN/Internet nécessitent le backend, mais la mise en page et l'interactivité locale restent fonctionnelles).

---

## 15. Annexes Préservées

> Ces annexes conservent **intégralement** le contenu des notes d'origine (rien n'est retiré), désormais relié au Course Display Engine ci-dessus.

### 15.1 Le problème des sources (couverture des domaines)

Le constat d'origine reste valable et **conditionne l'affichage** : ASCENT ne peut afficher un cours que si la **couverture domaine ≥ 85 %** avec **≥ 3 sources Gold (SQS ≥ 80)**. Sinon, la page-nœud affiche un **état « sources insuffisantes »** explicite (et non un cours dégradé), avec proposition de scout complémentaire.

Domaines historiquement sous-couverts (à étendre) : Business & Management, Langues, Sciences, Arts & Créativité, Finance, Soft skills, Santé, Droit, Histoire & Philosophie, Mathématiques.

**Sources Gold non-tech à intégrer** (conservées) :
- *Business* : Harvard Business (hbr.org), Google PM (Coursera), HubSpot Academy, Salesforce Trailhead, Meta Blueprint.
- *Langues* : Duolingo for Schools, Alliance Française, British Council, Goethe Institut.
- *Sciences* : Khan Academy (→ Gold), MIT OpenCourseWare (→ Gold), PubMed/NIH, NASA Open Data, WHO/OMS.
- *Finance* : CFA Institute, Banque de France, AMF, OCDE/PISA.
- *Arts* : Adobe Education Exchange, Canva Design School, Berklee Online, MoMA Learning.

### 15.2 SQS — Source Quality Score (complet, conservé)

```
Autorité           0-40 pts (logiciels) / 0-30 pts (autres)
Fraîcheur          0-25 pts × coefficient domaine
Pédagogie          0-25 pts
Validation comm.   0-20 pts
Pertinence domaine 0-15 pts (nouveau critère)

Coefficients fraîcheur : Logiciel/IA ×3.0 · Cloud/Web/Sécu ×2.0 · Business ×1.2
                         Sciences ×0.8 · Langues ×0.5 · Humanités ×0.0

Seuils : ≥80 Gold · 60-79 Silver · 40-59 Bronze · <40 Rejetée
Couverture : ≥85 % + min 3 Gold, sinon ASCENT refuse de démarrer.
```

**Impact affichage** : un badge de **fiabilité de source** est visible sur chaque source du nœud (rail droit, §8) — Gold/Silver/Bronze — pour la transparence et la confiance.

### 15.3 Adaptation des exercices par domaine (conservé, cf. §9)

Tech → code + output · Business → étude de cas · Langues → production + correction · Sciences → problèmes + démonstration · Arts → production + rubrique · Soft skills → simulation + feedback. **Le SMI ×5 dimensions reste identique ; seule la FORME affichée change.**

### 15.4 Pipeline des 9 Agents Autonomes (référence — qui alimente l'affichage)

L'affichage n'existe pas seul : il est **produit et piloté** par la pipeline agentique. Rappel synthétique du rôle de chaque agent **vis-à-vis de la page-nœud** :

| Agent | Rôle pour l'affichage du cours |
|-------|--------------------------------|
| **01 GOAL-INTERPRETER** | Fixe le niveau (Bloom, classification) → calibre la profondeur des slides & le ton BRAIN |
| **02 CONTENT-SCOUT** | Fournit sources + timestamps vidéo affichés |
| **03 DAG-ARCHITECT** | Génère sections, slides (syntaxe AntV), key_concepts, visuels COSMOS inline |
| **04 LEARNING-CONDUCTOR** | **Ordonne** READ/DO/PROVE, déclenche flashcards/IMPRINT/Teach-Back |
| **05 PERFORMANCE-ANALYZER** | Calcule le SMI live affiché (topbar, panneau de validation) |
| **06 ADAPTIVE-ROUTER** | Injecte slides de remédiation/consolidation, contenu alternatif |
| **07 DRIFT-GUARDIAN** | Suspend ses alertes en Focus mode ; réagit aux « points flous » |
| **08 ENGAGEMENT-AMPLIFIER** | Confetti, XP, streak de focus, célébration de validation |
| **09 SKILL-CERTIFIER** | À la fin du DAG : déclenche la page Proof of Skill |
| **10 CHRONICLE** | Coéquipier quotidien gérant l'imprévu, la fatigue et les oublis |
| **11 ARENA** | Épreuve du feu par simulation de roleplay en conditions réelles |
| **12 VISUAL-CRITIC** | Audite l'intégrité logique, sémantique et géométrique de chaque schéma généré |
| **13 COGNITIVE-VALIDATOR** | Calibre et valide que le visuel généré est adapté à la charge cognitive et au SMI actuel de l'utilisateur |

> Le détail complet des 9 agents (structures Rust, interactions, cycle de vie, EventBus, métriques) demeure la **référence architecturale** et reste valable tel quel — le présent document en est la **couche d'affichage**.

---

## ✅ Résumé — Ce que ce document change

```
AVANT                                  APRÈS (Course Display Engine)
──────────────────────────────────    ──────────────────────────────────────
Notes éparses (A.3→A.8)               1 page-nœud orchestrée : READ · DO · PROVE
Lecture passive (surlignage)          Active Reading Layer (sélection → BRAIN, etc.)
Visuels COSMOS « ailleurs »            COSMOS inline auto-suggéré, 1 visuel/écran
Slides = images statiques             AntV Infographic (SVG, IA, streaming, éditable)
BRAIN = chatbot                       Professeur contextuel + 3 questions + Socratique
Risque de surcharge visuelle          7 lois cognitives + divulgation progressive
Aucune agentivité de l'apprenant      « Point flou ❓ » : l'user pilote sa remédiation
Motivation externe                    12 micro-features (Focus, Cloze, IMPRINT, streak…)

RÉSULTAT : un affichage intuitif, interactif, aligné cognitivement —
           qui augmente la rétention et la concentration sans charger l'écran.
```

---

**Document rédigé par** : Course Experience Architecture — Arena.ai
**Date** : 2026-06-08
**Version** : 1.0
**Statut** : ✅ PRÊT POUR PROTOTYPAGE UI
**Aligné avec** : PRD-SCY FORGE-V2 (COSMOS v3, APEX, BRAIN, NEURON-CHAINS) + ASCENT Autonomous Pipeline

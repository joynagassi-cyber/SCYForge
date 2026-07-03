<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🌳 SCY-DAG-VIEW-THEMATIC-TREE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_DAG_VIEW_THEMATIC_TREE_SPEC  
**Statut** : 🔵 PROPOSITION (EN ATTENTE DE VALIDATION UTILISATEUR)  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Purpose
L'**Arbre Hiérarchique par Thème et Sous-Thème** est la 2ᵉ vue d'affichage du DAG ASCENT. Il organise les nœuds de compétence en une **arborescence hiérarchique thématique** que l'utilisateur parcourt en drill-down (Thème → Sous-thème → Nœud de compétence). Inspirée des explorateurs de fichiers VS Code / Notion / File Explorer, cette vue révèle la **structure logique et conceptuelle** du parcours et permet une navigation naturelle par pliage/dépliage.

---

## 2. Anatomie de l'Arbre — Structure Complète

### 2.1 Layout Général (2 panneaux)

```
┌─────────────────────────────────┬───────────────────────────────────────────┐
│  PANNEAU GAUCHE (Arbre WBS)     │     PANNEAU DROIT (Détail / Preview)      │
│  (Navigation hiérarchique)      │     (Nœud sélectionné)                    │
│                                 │                                           │
│  🔍 [Recherche dans l'arbre...] │  ┌─────────────────────────────────────┐  │
│                                 │  │ 📄 useEffect & Side Effects         │  │
│  🎯 React Developer    [62/100] │  │ Bloom 4 · 3h · SMI 78/100          │  │
│  ├ ▼ 📁 Fondamentaux  [85/100] │  │─────────────────────────────────────│  │
│  │  ├ ▼ 📂 ES6+ Modern [90/100] │  │ 📊 SMI Breakdown                    │  │
│  │  │  ├ ✅ Arrow Functions  92  │  │ Rétention    ████████░░ 82         │  │
│  │  │  ├ ✅ Destructuring    88  │  │ Profondeur   ███████░░░ 71         │  │
│  │  │  └ ✅ Modules          90  │  │ Enseignement ██████░░░░ 65         │  │
│  │  └ ▶ 📂 DOM & Events   [78]  │  │ Métacog.     ████████░░ 80         │  │
│  │     ├ ✅ DOM Manip.      85  │  │ Cohérence    █████████░ 92         │  │
│  │     └ ▶️ Event Handl.    --  │  │─────────────────────────────────────│  │
│  ├ ▼ 📁 React Core     [45/100] │  │ 📚 Contenu : 3 docs · 12 cartes     │  │
│  │  ├ ▼ 📂 Composants    [60]   │  │ 🔗 Prérequis : useState ✅          │  │
│  │  │  ├ ✅ JSX & Rendering 85  │  │ 🔴 Chemin critique                  │  │
│  │  │  ├ ✅ Props & Children 80 │  │ 🏷️ [React] [Hooks] [Effects]       │  │
│  │  │  └ ⚡ useState 78 ← ZPD   │  │─────────────────────────────────────│  │
│  │  └ ◀ 📂 Hooks Avancés [0]    │  │ [▶ Démarrer] [🃏 Réviser] [🎤 T-B] │  │
│  │     ├ ▶️ useEffect    --     │  │ [📖 Reader Suite] [📊 COSMOS]      │  │
│  │     └ 🔒 useContext   --     │  └─────────────────────────────────────┘  │
│  ├ ▶ 📁 Écosystème     [0/100]  │                                           │
│  └ ▶ 📁 Projet Final   [0/100]  │                                           │
│                                 │                                           │
│  [🌳 Indented] [🌐 Radial]      │                                           │
│  [⬇ Expand All] [⬆ Collapse]   │                                           │
└─────────────────────────────────┴───────────────────────────────────────────┘
```

### 2.2 Hiérarchie à 4 Niveaux

| Niveau | Icône | Type | Contenu | Indicateurs affichés |
|--------|-------|------|---------|---------------------|
| **0 — Racine** | 🎯 | Objectif global | Titre du parcours | SMI global, % total, durée |
| **1 — Thème** | 📁 | Domaine majeur | 3-5 thèmes (BETA-1) | SMI moyen, % branche, compteur nœuds |
| **2 — Sous-thème** | 📂 | Spécialisation | 2-4 sous-thèmes | SMI moyen, % sous-branche, compteur |
| **3 — Nœud** | 📄 | Compétence atomique | Nœud DAG | SMI, statut, effort, Bloom, badges |

### 2.3 Indicateurs Visuels par Nœud Feuille

#### Ligne de nœud (mode Indented)
```
📄 useEffect & Side Effects    [SMI: 78] [⏱️ 3h] [Bloom 4]  ✅  🔴
                                                  ↑statut  ↑critique
```

| Indicateur | Emplacement | Détail |
|------------|-------------|--------|
| **Statut** | À droite | ✅ Complété / ▶️ Disponible / ⚡ En cours / 🔒 Verrouillé / 🔄 Remédiation / ⏸️ Suspendu |
| **SMI** | Badge coloré | Jauge (Rouge < 40, Orange 40-60, Jaune 60-70, Vert 70-86, Or ≥ 86) |
| **Effort** | Badge | `⏱️ 3h` (estimé) ou `⏱️ 2h15/3h` (réel/estimé si en cours) |
| **Bloom** | Badge coloré | Niveau 1-6 (Remember → Create), couleur ∝ difficulté |
| **Critique** | Badge rouge | 🔴 si sur le chemin critique (CPM Gantt) |
| **Leech** | Badge orange | ⚠️ si > 8 lapses |
| **Gap** | Badge bleu | 🔍 si prérequis manquant |
| **FSRS dues** | Badge rouge | ⏰ + compte si cartes dues aujourd'hui |
| **ZPD** | Halo | Halo vert pulsant si nœud actif (Zone Proximale de Développement) |

#### Ligne de branche (Thème/Sous-thème)
```
▼ 📁 React Core    [████████░░░░░░░░░░] 45% (3/6)    SMI moyen: 68/100
```
- **Barre de progression** horizontale (% nœuds complétés pondéré par effort)
- **SMI moyen** coloré de la branche
- **Compteur** : `3/6 nœuds`
- **Chevron** `▼` (expanded) / `▶` (collapsed)

### 2.4 Panneau Détail (Panneau Droit)

Quand un nœud est sélectionné (clic), le panneau droit affiche le **détail complet** du nœud :

| Section | Contenu |
|---------|---------|
| **En-tête** | Nom, Bloom, effort, SMI global |
| **SMI Breakdown** | Radar 5 dimensions (Rétention, Profondeur, Enseignement, Métacognition, Cohérence) |
| **Contenu** | Documents, cartes APEX, exercices (compteurs) |
| **Prérequis** | Liste avec statut (✅/🔒) + Gap Detection |
| **Dépendances** | Nœuds qui dépendent de celui-ci (successeurs) |
| **Badges** | Chemin critique, leeches, FSRS dues, drift |
| **Tags** | Domaine/sous-thème |
| **Actions** | Démarrer, Réviser cartes, Teach-Back, Reader Suite, voir dans COSMOS, voir dans Gantt |

**Hover Preview** : au survol d'un nœud (sans clic), un **tooltip riche** s'affiche (preview condensée : SMI, statut, effort, 1ère ligne de description). < 200ms (pré-chargé).

### 2.5 Connecteurs (Lignes entre nœuds)

En mode Indented, les connecteurs montrent la hiérarchie parent-enfant :

```
├── 📁 Thème
│   ├── 📂 Sous-thème
│   │   ├── 📄 Nœud A
│   │   └── 📄 Nœud B
│   └── 📂 Sous-thème
└── 📁 Thème
```

**Styles de connecteurs** :
| Style | Couleur | Usage |
|-------|---------|-------|
| Trait plein fin | Gris (#333) | Relation hiérarchique standard (thème → sous-thème → nœud) |
| Trait plein épais | Bleu électrique | Chemin actif (racine → nœud ZPD) |
| Pointillé | Orange | Dépendance de prérequis inter-thème (cross-domain) |
| Trait double | Violet | Relation forte (cosine > 0.85, auto-graph) |

---

## 3. Les 2 Modes de Rendu

### 3.1 Mode Indented (défaut) — Explorateur de fichiers

Arbre vertical indenté style VS Code / explorateur de fichiers :
- Chevron `▼`/`▶` pour plier/déplier.
- Indentation visuelle (CSS padding-left par niveau).
- Scroll vertical virtuel (`@tanstack/react-virtual` si > 100 nœuds).
- Lignes de connecteur (CSS `border-left` + `border-bottom`).

**Avantages** : familier, rapide, scannable, accessible (screen reader), mobile-friendly.

### 3.2 Mode Radial — Arbre cérébral (G6)

Arbre radial style MindMap (COSMOS Mode 3), root au centre, branches rayonnantes :
- **Moteur** : AntV G6 v5 (Radial Tree Layout, D-RENDER-001).
- **Layout** : calculé dans un Web Worker asynchrone (D-PERF-003).
- **Nœuds** : cercles colorés ∝ branche (domaine de filiation), taille ∝ PageRank sémantique.
- **Arêtes** : courbes de Bézier depuis la racine.
- **Badges** : `✓` si SMI ≥ 70, `🔒` si non débloqué (cohérent avec MindMap M3).
- **Interactions** : clic nœud feuille → panneau détail ; collapse/expand sous-branche (animation élastique 300ms).
- **Validation** : petgraph cycle detection (si cycle par erreur → fallback Indented).

**Avantages** : visuellement impressionnant, spatiale, mémorisation hippocampale.

### 3.3 Bascule entre les 2 modes
- Toggle `[🌳 Indented] [🌐 Radial]` en bas du panneau gauche.
- La bascule SHALL préserver l'état expand/collapse + nœud sélectionné.
- Transition fluide (< 500ms, pas de rechargement).

---

## 4. Interactions Avancées

### 4.1 Recherche dans l'Arbre

- Barre `🔍 [Recherche...]` en haut du panneau gauche.
- Recherche instantanée (≤ 300ms) par nom de nœud, tag, ou domaine.
- Les résultats sont **surlignés** et l'arbre **auto-expand** les branches contenant des matches.
- Les nœuds non-matchés sont **atténués** (opacity 0.3).
- Compteur de résultats : « 3 matches ».

### 4.2 Navigation Clavier

| Raccourci | Action |
|-----------|--------|
| `↑` `↓` | Naviguer entre les nœuds (tous niveaux) |
| `→` | Expand une branche repliée / entrer dans un nœud |
| `←` | Collapse une branche déployée / remonter au parent |
| `Enter` | Ouvrir le panneau détail / démarrer session |
| `Space` | Démarrer / Reprendre la session |
| `R` | Réviser les cartes APEX du nœud |
| `T` | Teach-Back STUDENT AI |
| `Ctrl+F` | Focus la barre de recherche |
| `+` / `-` | Expand All / Collapse All |
| `Esc` | Fermer panneau détail / clear recherche |

### 4.3 Menu Contextuel (clic droit)

Identique au Kanban : démarrer, reprendre, détails, réviser, Teach-Back, suspendre, remédiation, épingler, planifier (Gantt), voir dans COSMOS.

### 4.4 Multi-Sélection & Actions en Masse

- `Shift+clic` : sélection d'une plage de nœuds.
- `Ctrl+clic` : sélection disjointe.
- Actions en masse : « Réviser toutes les cartes des nœuds sélectionnés », « Exporter sélection ».
- Uniquement sur les nœuds feuilles (pas sur les thèmes/sous-thèmes).

### 4.5 Breadcrumb (Fil d'Ariane)

Barre horizontale en haut du panneau détail montrant le chemin :
```
🎯 React > 📁 React Core > 📂 Hooks Avancés > 📄 useEffect
```
Chaque segment est cliquable → scroll vers le nœud correspondant + expand automatique.

### 4.6 MiniMap (Mode Radial uniquement)

- Miniature de l'arbre complet (180×120px) en bas-droite (cohérent avec COSMOS MiniMap D-UX-013).
- Viseur délimitant la zone visible → glisser pour naviguer.

---

## 5. Tech Stack & Dependencies
* **Mode Indented** : React 18 custom (CSS, composant arbre natif, `@tanstack/react-virtual`).
* **Mode Radial** : React 18 + **AntV G6 v5** (Radial Tree Layout, D-RENDER-001, Web Worker D-PERF-003).
* **Animations** : `framer-motion` (collapse/expand élastique 300ms) ou G6 native (radial).
* **Recherche** : Tantivy ou simple regex (selon volume).
* **Données** : `scy_ascent_nodes` + `domain_tags` (classification BETA-1 taxonomiste) + `scy_ascent_edges` (prérequis).
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : l'arbre thématique reflète les données RÉELLES du DAG + la classification BETA-1. Les thèmes/sous-thèmes sont assignés par l'IA (taxonomiste) à partir des concepts réels, pas inventés.

---

## 6. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu Arbre Hiérarchique (2 panneaux)
- **GIVEN** Un DAG ASCENT généré avec classification thématique (BETA-1).
- **WHEN** L'utilisateur sélectionne la vue Arbre.
- **THEN** le système SHALL afficher le panneau gauche (arbre hiérarchique 4 niveaux) + le panneau droit (détail du nœud sélectionné).
- **AND** chaque nœud feuille SHALL afficher : nom, SMI (badge coloré), statut, effort, Bloom, badges (critique/leech/gap/FSRS/ZPD).
- **AND** chaque branche SHALL afficher : barre de progression, SMI moyen, compteur nœuds.

### Requirement : Drill-Down (Collapse/Expand)
- **THEN** chaque branche SHALL être pliable/dépliable (chevron, animation élastique 300ms).
- **AND** le système SHALL mémoriser l'état expand/collapse (persistance session).
- **AND** les commandes `Expand All` / `Collapse All` SHALL être disponibles.

### Requirement : Panneau Détail & Hover Preview
- **WHEN** Un nœud est sélectionné (clic).
- **THEN** le panneau droit SHALL afficher le détail complet (SMI radar 5D, contenu, prérequis, dépendances, badges, tags, actions).
- **WHEN** Un nœud est survolé (hover).
- **THEN** un tooltip riche SHALL s'afficher (< 200ms, preview condensée).

### Requirement : Recherche dans l'Arbre
- **THEN** le système SHALL offrir une recherche instantanée (≤ 300ms) par nom/tag/domaine.
- **AND** les résultats SHALL être surlignés + auto-expand + atténuation non-matchés.

### Requirement : 2 Modes (Indented ↔ Radial)
- **THEN** le système SHALL offrir le mode Indented (défaut, explorateur) ET le mode Radial (G6, arbre cérébral).
- **AND** la bascule SHALL préserver expand/collapse + nœud sélectionné (< 500ms).
- **AND** le mode Radial SHALL valider l'arbre (petgraph cycle → fallback Indented).

### Requirement : Chemin Actif & Connecteurs
- **THEN** le système SHALL surligner le chemin racine → nœud ZPD (trait bleu épais).
- **AND** les nœuds complétés SHALL être atténués (opacity 0.6).
- **AND** le nœud actif SHALL avoir un halo vert pulsant.
- **AND** les connecteurs SHALL distinguer : hiérarchie standard, chemin actif, cross-domain, auto-graph.

### Requirement : Navigation Clavier & Menu Contextuel
- **THEN** le système SHALL offrir les raccourcis (flèches, Enter, Space, R, T, Ctrl+F, +/-, Esc).
- **AND** le système SHALL offrir le menu contextuel (clic droit).

### Requirement : Breadcrumb & Multi-Sélection
- **THEN** le système SHALL afficher un breadcrumb cliquable (chemin racine → nœud sélectionné).
- **AND** le système SHALL supporter la multi-sélection (Shift/Ctrl+clic) + actions en masse.

### Requirement : Synchronisation Trans-Vues
- **THEN** le nœud sélectionné SHALL rester sélectionné à travers les bascules (Kanban/Arbre/Gantt/Réseau).
- **AND** les mises à jour temps réel (EventBus) SHALL synchroniser l'arbre.

---

## 7. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Thèmes/sous-thèmes inventés sans classification BETA-1 réelle.
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Permettre la réorganisation manuelle (l'ordre suit le DAG + classification BETA-1).
* 🚫 **SHALL NOT** : Afficher un nœud Disponible dont les prérequis ne sont pas validés.
* ⚠️ **MUST** : Persistance expand/collapse + nœud sélectionné en session.

---

## 8. Test cases & Validation
* **TC1 (Arbre)** : DAG → arborescence 4 niveaux avec indicateurs complets (SMI, statut, effort, Bloom, badges).
* **TC2 (Panneau détail)** : Clic nœud → panneau droit (radar 5D, contenu, prérequis, dépendances, actions).
* **TC3 (Hover preview)** : Survol → tooltip < 200ms (preview condensée).
* **TC4 (Drill-down)** : Collapse/Expand 300ms + persistance + Expand/Collapse All.
* **TC5 (Recherche)** : Instantanée ≤ 300ms + surlignage + auto-expand + atténuation.
* **TC6 (Modes)** : Bascule Indented ↔ Radial préservant l'état + cycle fallback.
* **TC7 (Chemin actif)** : Surlignage racine → ZPD + halo + atténuation complétés + connecteurs stylés.
* **TC8 (Clavier)** : Flèches + Enter + Space + R + T + Ctrl+F + +/- + Esc.
* **TC9 (Menu contextuel)** : Clic droit → toutes actions.
* **TC10 (Breadcrumb)** : Chemin cliquable + scroll + expand auto.
* **TC11 (Multi-sélection)** : Shift/Ctrl+clic + actions en masse.
* **TC12 (Branche)** : Barre progression + SMI moyen + compteur par branche.
* **TC13 (Sync trans-vues)** : Nœud sélectionné persiste à travers Kanban/Arbre/Gantt/Réseau.

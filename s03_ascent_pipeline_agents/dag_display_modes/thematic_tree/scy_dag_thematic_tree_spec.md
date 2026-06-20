# 🌳 SCY-DAG-VIEW-THEMATIC-TREE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_DAG_VIEW_THEMATIC_TREE_SPEC  
**Statut** : 🔵 PROPOSITION (EN ATTENTE DE VALIDATION UTILISATEUR)  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
L'**Arbre Hiérarchique par Thème et Sous-Thème** est la 2ᵉ vue d'affichage du DAG ASCENT. Il organise les nœuds de compétence en une **arborescence hiérarchique thématique** que l'utilisateur parcourt en drill-down (Thème → Sous-thème → Nœud de compétence). Cette vue révèle la **structure logique et conceptuelle** du parcours, contrairement au Kanban (statut) ou à la Timeline (temps).

---

## 2. Structure de l'Arbre

### Hiérarchie à 3 Niveaux

```
🎯 Objectif : "Maîtriser React"
│
├── 📁 Thème 1 : Fondamentaux JavaScript
│   ├── 📂 Sous-thème : ES6+ Modern
│   │   ├── 📄 Nœud : Arrow Functions, Destructuring, Modules
│   │   └── 📄 Nœud : Promises & Async/Await
│   └── 📂 Sous-thème : DOM & Events
│       └── 📄 Nœud : DOM Manipulation, Event Handling
│
├── 📁 Thème 2 : React Core
│   ├── 📂 Sous-thème : Composants
│   │   ├── 📄 Nœud : JSX & Rendering
│   │   ├── 📄 Nœud : Props & Children
│   │   └── 📄 Nœud : useState & State Management
│   └── 📂 Sous-thème : Hooks Avancés
│       ├── 📄 Nœud : useEffect & Side Effects
│       └── 📄 Nœud : useContext & useRef
│
└── 📁 Thème 3 : Écosystème React
    ├── 📂 Sous-thème : Routing
    │   └── 📄 Nœud : React Router
    └── 📂 Sous-thème : State Global
        └── 📄 Nœud : Redux Toolkit
```

### Les 3 Niveaux

| Niveau | Type | Contenu | Interaction |
|--------|------|---------|-------------|
| **Niveau 1 — Thème** | 📁 Dossier | Domaine majeur du parcours (3-5 thèmes) | Expand/Collapse |
| **Niveau 2 — Sous-thème** | 📂 Sous-dossier | Spécialisation du thème (2-4 sous-thèmes) | Expand/Collapse |
| **Niveau 3 — Nœud** | 📄 Feuille | Nœud de compétence atomique (DAG node) | Clic → détails/session |

### Indicateurs Visuels par Nœud Feuille

```
📄 useEffect & Side Effects    [SMI: 78] [⏱️ 3h] [Bloom 4]  ✅
📄 useContext & useRef          [SMI: --] [⏱️ 2h] [Bloom 3]  ▶️
📄 Redux Toolkit                [🔒]      [⏱️ 5h] [Bloom 5]  🔒
```

- SMI : jauge colorée (Rouge < 40, Orange 40-60, Jaune 60-70, Vert 70-86, Or ≥ 86)
- Statut : ✅ Complété / ▶️ Disponible / ⚡ En cours / 🔒 Verrouillé
- Effort estimé + Bloom level visibles

### Indicateurs par Branche (Thème/Sous-thème)
- **Barre de progression** globale de la branche (% nœuds complétés)
- **SMI moyen** de la branche (couleur agrégée)
- Compteur : « 3/5 nœuds complétés »

---

## 3. Tech Stack & Dependencies
* **Framework** : React 18 + **AntV G6 v5** (Radial Tree Layout ou indented tree) OU composant arbre custom.
* **Alternative** : Composant React arborescent natif (collapsible tree, CSS) pour simplicité MVP.
* **Données** : `scy_ascent_nodes` + `domain_tags` (classification thématique Agent-03/BETA-1).
* **Layout** : 
  - **Mode Indented** (défaut) : arbre vertical indenté style explorateur de fichiers.
  - **Mode Radial** : arbre radial G6 (Root au centre, branches rayonnantes).
- **Design** : tokens `design.md`.
* **Collapse/Expand** : animation élastique 300ms (cohérent avec MindMap M3).

> **Rappel anti-hallucination** : l'arbre thématique reflète les données RÉELLES du DAG + la classification BETA-1 (taxonomiste). Les thèmes/sous-thèmes sont assignés par l'IA à partir des concepts, pas inventés arbitrairement.

---

## 4. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu de l'Arbre Hiérarchique

#### Scénario : Affichage de l'arbre
- **GIVEN** Un DAG ASCENT généré avec classification thématique (BETA-1).
- **WHEN** L'utilisateur sélectionne la vue Arbre Hiérarchique.
- **THEN** le système SHALL organiser les nœuds en arborescence à 3 niveaux (Thème → Sous-thème → Nœud).
- **AND** chaque nœud feuille SHALL afficher : nom, SMI (jauge), statut, effort, Bloom.
- **AND** chaque branche SHALL afficher : barre de progression, SMI moyen, compteur nœuds.

---

### Requirement : Navigation Drill-Down (Collapse/Expand)

#### Scénario : Exploration de l'arbre
- **GIVEN** L'arbre affiché ( collapsed par défaut sauf premier niveau).
- **WHEN** L'utilisateur clique sur un Thème/Sous-thème.
- **THEN** le système SHALL déplier/replier ses enfants avec animation élastique 300ms.
- **AND** le système SHALL mémoriser l'état expand/collapse (persistance session).

---

### Requirement : Clic sur Nœud Feuille

#### Scénario : Accès au détail
- **WHEN** L'utilisateur clique sur un nœud feuille Disponible/En cours.
- **THEN** le système SHALL ouvrir le Bottom Sheet (cours, exercices, Teach-Back).
- **WHEN** L'utilisateur clique sur un nœud Verrouillé.
- **THEN** le système SHALL afficher les prérequis manquants + CTA « Combler ».

---

### Requirement : Mode Indented ↔ Radial

#### Scénario : Bascule de layout
- **THEN** le système SHALL offrir 2 modes de rendu :
  - **Indented** (défaut) : arbre vertical style explorateur de fichiers.
  - **Radial** : arbre radial G6 (root au centre, branches rayonnantes).
- **AND** la bascule SHALL préserver l'état expand/collapse.

---

### Requirement : Surlignage du Chemin Actif

#### Scénario : Mise en évidence du parcours courant
- **THEN** le système SHALL surligner le chemin depuis la racine jusqu'au nœud actif (Zone Proximale de Développement).
- **AND** les nœuds complétés SHALL être visuellement atténués (opacity 0.6).
- **AND** le nœud actif SHALL avoir un halo pulsant.

---

## 5. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Thèmes/sous-thèmes inventés sans classification BETA-1 réelle.
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Permettre la réorganisation manuelle (l'ordre suit le DAG + classification).
* ⚠️ **MUST** : Persistance de l'état expand/collapse en session.

---

## 6. Test cases & Validation
* **TC1 (Arbre)** : DAG → arborescence 3 niveaux (Thème → Sous-thème → Nœud) avec indicateurs.
* **TC2 (Drill-down)** : Collapse/Expand 300mm avec persistance.
* **TC3 (Clic feuille)** : Disponible → Bottom Sheet ; Verrouillé → prérequis + CTA.
* **TC4 (Layout)** : Bascule Indented ↔ Radial préservant l'état.
* **TC5 (Chemin actif)** : Surlignage racine → nœud actif + halo + atténuation complétés.
* **TC6 (Branche)** : Barre progression + SMI moyen + compteur par branche.

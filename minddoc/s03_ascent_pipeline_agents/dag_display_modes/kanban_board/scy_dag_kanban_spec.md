<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-DAG-VIEW-KANBAN — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_DAG_VIEW_KANBAN_SPEC  
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
Le **Board Kanban** est l'une des 3 vues d'affichage du DAG ASCENT. Inspiré des boards Trello/Notion/Linear, adapté au contexte d'apprentissage : il présente les nœuds de compétence sous forme de **cartes riches organisées en colonnes et swimlanes**, offrant une vue d'overview actionnable, filtrable et collaborative du parcours.

---

## 2. Anatomie du Board Kanban — Structure Complète

### 2.1 Layout Général (3 zones)

```
┌──────────────────────────────────────────────────────────────────────────┐
│  EN-TÊTE DE SYNTHÈSE                                                     │
│  🎯 React Developer │ 📊 25% (3/12) │ SMI 62/100 │ ⏱️ ~5 sem restantes  │
│  [📋 Kanban] [🌳 Arbre] [⏱️ Gantt] [🕸️ Réseau]  [⚙️] [📥 Export]        │
├──────────┬──────────┬──────────┬──────────┬──────────────────────────────┤
│ 🔒 VER.  │ ▶️ DISP. │ ⚡ ACTIF │ ✅ FAIT  │ SWIMLANES →                 │
│ (4)      │ (2)      │ (1)      │ (3)      │                              │
│          │          │          │          │ ┌── Fondamentaux ──────────┐│
│ ┌──────┐ │ ┌──────┐ │ ┌──────┐ │ ┌──────┐ │ │ ┌────┐ ┌────┐ ┌────┐    ││
│ │ Carte│ │ │ Carte│ │ │ Carte│ │ │ Carte│ │ │ │carte│ │carte│ │carte│    ││
│ │  1   │ │ │  2   │ │ │  3   │ │ │  4   │ │ │ └────┘ └────┘ └────┘    ││
│ └──────┘ │ └──────┘ │ └──────┘ │ └──────┘ │ ├── React Core ────────────┤│
│ ┌──────┐ │ ┌──────┐ │          │ ┌──────┐ │ │ ┌────┐                  ││
│ │ Carte│ │ │ Carte│ │          │ │ Carte│ │ │ │carte│                  ││
│ │  5   │ │ │  6   │ │          │ │  7   │ │ │ └────┘                  ││
│ └──────┘ │ └──────┘ │          │ └──────┘ │ └── Écosystème ───────────┘│
│          │          │          │          │ ┌────┐                     ││
│ + WIP:0  │ + WIP:2  │ + WIP:1  │ + WIP:∞  │ │carte│                     ││
│          │          │          │          │ └────┘                     ││
├──────────┴──────────┴──────────┴──────────┴────────────────────────────┤
│  BARRE DE FILTRES : [🔍] [🏷️ Domaine ▾] [📊 Bloom ▾] [⚡ Charge ▾]      │
└──────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Les Colonnes (par statut du nœud DAG)

| Colonne | Token couleur | Contenu | WIP Limit | Interaction carte |
|---------|---------------|---------|-----------|-------------------|
| **🔒 Verrouillé** | Gris opaque (#1a1a2e) | Prérequis non validés (SMI < 70) | ∞ | Lecture seule, clic → prérequis |
| **▶️ Disponible** | Bleu électrique (#2563EB) | Débloqués, prêts à étudier | Configurable (défaut: 3) | Clic → démarrer session |
| **⚡ En cours** | Bleu translucide + halo pulsant | Nœud actif d'apprentissage (ZPD) | **1** (hard limit) | Clic → reprendre session |
| **✅ Complété** | Vert émeraude (#10B981) + or SMI | Validés (SMI ≥ seuil) | ∞ | Clic → revoir / réviser |
| **🔄 Remédiation** | Orange (#D97706) | Nœud en remédiation intensive (Agent-06) | ∞ | Clic → session remédiation |
| **⏸️ Suspendu** | Gris strié | Suspendu manuellement (vacances, pause) | ∞ | Clic → reprendre |

**WIP Limits (Work In Progress)** :
- La colonne « ⚡ En cours » est limitée à **1 nœud** (focus — impossible d'étudier 2 nœuds simultanément).
- La colonne « ▶️ Disponible » a un WIP configurable (défaut 3) — au-delà, alerte « Trop de nœuds ouverts, terminez-en un d'abord ».
- WIP affiché en bas de chaque colonne : `WIP: 1/1` ou `WIP: 2/3`.

### 2.3 Swimlanes (Lignes Horizontales)

Les swimlanes permettent de **grouper visuellement les cartes par thème** horizontalement, tout en conservant les colonnes verticales par statut. Inspiré de Jira/Linear.

| Swimlane | Source | Contenu |
|----------|--------|---------|
| **Par Thème** (défaut) | Classification BETA-1 | Ligne horizontale par thème (Fondamentaux / Core / Écosystème) |
| **Par Bloom Level** | bloom_level | Ligne par niveau cognitif (Remember → Create) |
| **Par Jalon Macro** | Dynamic Graph Splitting | Ligne par jalon (Jalon 1 / Jalon 2 / ...) |
| **Par Domaine** | domain_tags | Ligne par domaine |
| **Aucune** (plate) | — | Pas de swimlane (board classique) |

**Header de swimlane** : nom du thème + barre de progression (% nœuds complétés dans ce thème) + SMI moyen + compteur.

### 2.4 La Carte Kanban — Anatomie Détaillée

```
┌───────────────────────────────────────────┐
│ 🎯 useEffect & Side Effects    [🔴 Critique]│  ← Priorité (chemin critique Gantt)
│                                   [Bloom 4] │  ← Niveau Bloom (badge coloré)
│─────────────────────────────────────────── │
│ 📊 SMI : ████████░░░░ 78/100              │  ← Jauge SMI colorée (vert/or)
│ ⏱️ Effort estimé : ~3h (réel : 2h15)       │  ← Effort estimé vs réel
│ 📚 3 docs · 12 cartes · 5 exos · 2 leeches │  ← Contenu du nœud
│─────────────────────────────────────────── │
│ 🏷️ [React] [Hooks] [Side Effects]         │  ← Tags/domaine
│ 🔗 Prérequis : useState (✅), State (✅)    │  ← Prérequis avec statut
│─────────────────────────────────────────── │
│ ⏰ 3 cartes FSRS dues aujourd'hui          │  ← Badge alerte révision
│ 📅 Démarré il y a 4 jours                  │  ← Card aging (durée dans colonne)
│─────────────────────────────────────────── │
│ [▶ Démarrer / ⚡ Reprendre]  [📖 Détails]   │  ← Actions rapides
└───────────────────────────────────────────┘
```

#### Badges & Indicateurs sur la carte

| Badge | Condition | Visuel |
|-------|-----------|--------|
| 🔴 **Critique** | Nœud sur le chemin critique (CPM Gantt) | Badge rouge pulsant |
| 🟠 **Leech** | > 8 lapses sur les cartes du nœud | Badge orange ⚠️ |
| 🔵 **Gap** | Prérequis manquant détecté (Gap Detection) | Badge bleu 🔍 |
| ⏰ **FSRS dues** | Cartes APEX dues aujourd'hui | Badge rouge + compte |
| 📅 **Vieillissement** | Durée dans la colonne « En cours » > effort estimé | Bordure vieillissante (jaune→rouge) |
| 🏅 **Expert** | SMI ≥ 86 (Fast-Track eligible) | Badge or |
| ⚠️ **Drift** | Drift détecté sur ce nœud (Agent-07) | Bordure rouge clignotante |
| 🎯 **ZPD** | Nœud actif (Zone Proximale de Développement) | Halo vert pulsant |

#### Menu Contextuel (clic droit / ⋮)

```
┌──────────────────────────┐
│ ▶ Démarrer la session    │
│ ⚡ Reprendre              │
│ 📖 Voir détails (Bottom) │
│ ─────────────────────    │
│ 🃏 Réviser cartes (APEX) │
│ 🎤 Teach-Back STUDENT AI │
│ ─────────────────────    │
│ ⏸️ Suspendre             │
│ 🔄 Remédiation           │
│ 📋 Dupliquer vers...     │
│ ─────────────────────    │
│ 📌 Épingler              │
│ 🏷️ Étiqueter             │
│ 📅 Planifier (Gantt)     │
└──────────────────────────┘
```

### 2.5 En-tête de Synthèse (Dashboard Bar)

```
┌──────────────────────────────────────────────────────────────────────────┐
│ 🎯 React Developer  │  📊 25% (3/12 nœuds)  │  SMI 62/100  │  ⏱️ ~5 sem │
│ 🔴 Critique : 5 nœuds  │  🟠 Leechees : 2  │  ⏰ 8 cartes dues auj.      │
│ [📋 Kanban] [🌳 Arbre] [⏱️ Gantt] [🕸️ Réseau]  [⚙️] [📥 Export CSV/PNG] │
└──────────────────────────────────────────────────────────────────────────┘
```

### 2.6 Barre de Filtres

| Filtre | Type | Effet |
|--------|------|-------|
| 🔍 **Recherche texte** | Input | Filtre les cartes par nom/tag |
| 🏷️ **Domaine** | Dropdown multi | Filtre par domaine/tag |
| 📊 **Bloom** | Dropdown | Filtre par niveau Bloom (1-6) |
| ⚡ **Charge** | Dropdown | Filtre par charge cognitive (légère/modérée/élevée) |
| 🔴 **Chemin critique** | Toggle | N'affiche que les cartes du chemin critique |
| 🟠 **Leeches** | Toggle | N'affiche que les nœuds avec leeches |
| ⏰ **FSRS dues** | Toggle | N'affiche que les nœuds avec cartes dues |

### 2.7 Mode Groupement Alternatif (Colonnes par Jalon)

Toggle « Grouper par » : Statut (défaut) ↔ **Jalon macro** ↔ **Bloom level** ↔ **Thème**.

En mode « Jalon macro » :
```
┌──────────┬──────────┬──────────┐
│ JALON 1  │ JALON 2  │ JALON 3  │
│ Fondam.  │ Core     │ Écosyst. │
│ (100%)   │ (40%)    │ (0%)     │
│ ┌──────┐ │ ┌──────┐ │ ┌──────┐ │
│ │ ✅JS  │ │ │ ⚡St. │ │ │ 🔒RT │ │
│ │ ✅ES6 │ │ │ ▶️Eff │ │ │ 🔒Re │ │
│ └──────┘ │ └──────┘ │ └──────┘ │
└──────────┴──────────┴──────────┘
```

Chaque carte affiche son statut interne (✅/▶️/⚡/🔒) via une bordure colorée.

---

## 3. Interactions Avancées

### 3.1 Glisser-Déposer (Drag & Drop) — Limité

| Action | Autorisée ? | Effet |
|--------|-------------|-------|
| Carte Verrouillé → Disponible | ❌ Non | Impossible (prérequis non validés) |
| Carte Disponible → En cours | ✅ Oui | Démarre le nœud (si WIP ≤ 1) |
| Carte En cours → Disponible | ✅ Oui | Met en pause le nœud |
| Carte → Suspendu | ✅ Oui | Suspend manuellement |
| Réordonner dans une colonne | ✅ Oui | **Priorité personnelle** (ne modifie pas l'ordre pédagogique du DAG) |
| Carte → autre swimlane | ❌ Non | Le thème est fixé par BETA-1 |

### 3.2 Raccourcis Clavier

| Raccourci | Action |
|-----------|--------|
| `←` `→` | Naviguer entre les colonnes |
| `↑` `↓` | Naviguer entre les cartes |
| `Enter` | Ouvrir le Bottom Sheet de la carte sélectionnée |
| `Space` | Démarrer / Reprendre la session |
| `R` | Réviser les cartes APEX du nœud |
| `T` | Lancer Teach-Back STUDENT AI |
| `S` | Suspendre / Réactiver |
| `F` | Épingler (pin) |
| `Ctrl+K` | Recherche globale |
| `Esc` | Fermer Bottom Sheet / menu |

### 3.3 Mobile / Tablette

- **Swipe gauche** sur une carte Disponible → démarre le nœud.
- **Swipe droite** → met en pause.
- **Tap long** → menu contextuel.
- Colonnes scrollables horizontalement (snap-scroll).
- Cartes adaptées mobile (informations condensées : nom + SMI + statut uniquement).

---

## 4. Tech Stack & Dependencies
* **Framework** : React 18 + composant Kanban custom (CSS Grid/Flexbox).
* **Drag & Drop** : `@hello-pangea/dnd` (fork maintenu de react-beautiful-dnd, accessible, mobile-friendly).
* **Virtualisation** : `@tanstack/react-virtual` (si > 50 cartes dans une colonne).
* **Animations** : `framer-motion` (transitions de cartes entre colonnes, spring physics).
* **Données** : `scy_ascent_nodes` (statut, SMI, effort, bloom_level, prereqs, domain_tags).
* **Design** : tokens `design.md` (Noir d'encre #020205, Violet profond #1E1B4B, Bleu électrique #2563EB, Émeraude #10B981, Or #D97706).

> **Rappel anti-hallucination** : le Kanban reflète les données RÉELLES du DAG. Le drag utilisateur ne modifie PAS l'ordre pédagogique (déterministe, Agent-03) — il ne fait que réordonner la priorité personnelle d'affichage au sein d'une colonne.

---

## 5. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu Kanban (Colonnes + Swimlanes + Cartes)
- **GIVEN** Un DAG ASCENT généré.
- **WHEN** L'utilisateur sélectionne la vue Kanban.
- **THEN** le système SHALL afficher les colonnes par statut (Verrouillé/Disponible/En cours/Complété/Remédiation/Suspendu).
- **AND** le système SHALL afficher les swimlanes par thème (défaut) ou selon le groupement choisi.
- **AND** chaque carte SHALL afficher l'anatomie complète (nom, Bloom, SMI jauge, effort, contenu, tags, prérequis, badges, actions).

### Requirement : WIP Limits
- **THEN** la colonne « En cours » SHALL être limitée à **1 nœud** (hard limit, focus).
- **AND** la colonne « Disponible » SHALL avoir un WIP configurable (défaut 3).
- **AND** au-delà du WIP, le système SHALL afficher une alerte.

### Requirement : Badges & Indicateurs Temps Réel
- **THEN** chaque carte SHALL afficher les badges : Critique (CPM), Leech, Gap, FSRS dues, Vieillissement, Expert, Drift, ZPD.
- **AND** les badges SHALL se mettre à jour en temps réel (EventBus `NodeCompleted`, `CardReviewed`, `DriftDetected`).

### Requirement : Glisser-Déposer Limité
- **THEN** le drag SHALL permettre : Disponible ↔ En cours (démarrer/pause), → Suspendu, réordonner dans colonne (priorité perso).
- **AND** le drag SHALL NOT permettre : Verrouillé → Disponible, changement de swimlane.

### Requirement : Filtres & Groupement
- **THEN** le système SHALL offrir les filtres : recherche, domaine, Bloom, charge, chemin critique, leeches, FSRS dues.
- **AND** le système SHALL offrir le groupement : par statut (défaut), jalon macro, Bloom, thème.

### Requirement : Transitions Animées
- **THEN** le déplacement d'une carte entre colonnes SHALL être animé (framer-motion, spring physics).
- **AND** le débloquage d'une carte (Verrouillé → Disponible) SHALL être animé (glissement + glow).

### Requirement : Menu Contextuel & Raccourcis
- **THEN** le système SHALL offrir un menu contextuel (clic droit / ⋮) avec : démarrer, reprendre, détails, réviser, Teach-Back, suspendre, remédiation, épingler, planifier.
- **AND** le système SHALL offrir les raccourcis clavier (flèches, Enter, Space, R, T, S, F).

### Requirement : Export
- **THEN** le système SHALL permettre l'export du board : PNG (capture), CSV (données nœuds).

---

## 6. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Drag modifiant l'ordre pédagogique du DAG (déterministe Agent-03).
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Afficher un nœud Disponible dont les prérequis ne sont pas validés.
* 🚫 **SHALL NOT** : Permettre plus d'1 nœud « En cours » simultanément (WIP hard limit).
* ⚠️ **MUST** : Synchronisation temps réel EventBus + persistance priorité perso + état collapse swimlanes.

---

## 7. Test cases & Validation
* **TC1 (Board)** : DAG → colonnes + swimlanes + cartes anatomie complète.
* **TC2 (WIP)** : En cours limité à 1 ; Disponible limité à 3 (configurable) + alerte.
* **TC3 (Badges)** : Critique/Leech/Gap/FSRS dues/Vieillissement/Expert/Drift/ZPD affichés et temps réel.
* **TC4 (Drag)** : Disponible→En cours (démarrer) ; réordonner colonne (priorité perso) ; Verrouillé→Disponible bloqué.
* **TC5 (Filtres)** : Recherche + domaine + Bloom + charge + critiques + leeches + FSRS.
* **TC6 (Groupement)** : Bascule statut ↔ jalon ↔ Bloom ↔ thème.
* **TC7 (Transitions)** : SMI ≥ 70 → carte En cours → Complété (animation spring) ; dépendantes débloquées (glissement + glow).
* **TC8 (Menu contextuel)** : Toutes les actions accessibles (démarrer/Teach-Back/suspendre/planifier).
* **TC9 (Raccourcis)** : Flèches + Enter + Space + R + T + S + F.
* **TC10 (Mobile)** : Swipe gauche (démarrer) + swipe droite (pause) + tap long (menu).
* **TC11 (Export)** : PNG + CSV.
* **TC12 (Synthèse)** : En-tête % complété + SMI global + temps restant + cartes dues + leeches + critiques.

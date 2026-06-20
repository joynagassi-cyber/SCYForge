# ⏱️ SCY-DAG-VIEW-TIMELINE (GANTT PROJECT) — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_DAG_VIEW_TIMELINE_SPEC  
**Statut** : 🔵 PROPOSITION (EN ATTENTE DE VALIDATION UTILISATEUR)  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
La **Timeline Gantt Project** est une vue d'affichage du DAG ASCENT inspirée des outils de gestion de projet professionnels (MS Project, GanttPRO, Asana Timeline). Elle projette le parcours d'apprentissage sur un axe chronologique avec **toutes les fonctionnalités d'un vrai Gantt** : tâches hiérarchisées, sous-tâches, barres de progression, chemin critique, types de dépendances, slack/marge, baseline vs réel, jalons, ressources (charge cognitive), ligne "aujourd'hui", et ETA dynamique piloté par CHRONICLE.

---

## 2. Anatomie du Gantt — Structure Complète

### 2.1 Layout Général (2 panneaux)

```
┌─────────────────────────┬──────────────────────────────────────────────────────────────┐
│  PANNEAU GAUCHE (WBS)   │              PANNEAU DROIT (AXE TEMPOREL)                   │
│  (Work Breakdown)       │                                                              │
│                         │   L S1   S2   S3   S4   S5   S6   S7   S8                    │
│ 🎯 React (Groupe)   60% │   ├■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■░░░░░░░░░░░░░░░░░│
│ ├ 📁 Fondamentaux  100% │   │ ├████████████████████████████████│                      │
│ │ ├ JS Basics      100% │   │ │ ├███████│                                               │
│ │ ├ ES6+           100% │   │ │ ├░░██████│                                              │
│ │ └ DOM            100% │   │ │ └░░░░███████│                                           │
│ ├ 📁 React Core     40% │   │ ├░░░░░░░░░■■■■■■■■■■■■■■■■■■■░░░░░░░░░░░│               │
│ │ ├ JSX/Props      100% │   │ │        ├░░░░░███████│                                  │
│ │ ├ useState        80% │   │ │              ├░░░░░■■■■■■■■│  ▓▓▓▓▓▓▓▓▓               │
│ │ ├ useEffect         0% │   │ │                    ├░░░░░░░░░░░░░░░░■■■■■■■■■■■■■■│
│ │ └ Context           0% │   │ │                                      ├░░░░░░░░░░░│
│ ├ 📁 Écosystème      0% │   │ ├░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░■■■■■■■■■■■│
│ └ 📁 Projet Final    0% │   │ └░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░■■■■◆│
│                         │      ▲ TODAY (Sem 3)                                           │
└─────────────────────────┴──────────────────────────────────────────────────────────────┘
```

**Légende des barres** :
- `███` = travail accompli (progression réelle)
- `░░░` = travail planifié non commencé / slack
- `■■■` = chemin critique (rouge épais)
- `▓▓▓` = nœud en cours d'étude (bleu translucide + halo)
- `◆` = jalon/milestone (losange)
- `▲ TODAY` = ligne verticale "aujourd'hui"

---

### 2.2 Work Breakdown Structure (Panneau Gauche)

Le panneau gauche affiche la **structure hiérarchique des tâches** (WBS) façon MS Project :

| Type | Indentation | Contenu | Colonnes affichées |
|------|-------------|---------|-------------------|
| **🎯 Groupe racine** | Niveau 0 | Objectif global (ex : « React ») | % global, durée totale, ETA |
| **📁 Thème (Summary Task)** | Niveau 1 | Domaine majeur (3-5 thèmes) | % thème, durée, SMI moyen thème |
| **📂 Sous-thème** | Niveau 2 | Spécialisation (2-4) | % sous-thème, durée |
| **📄 Nœud (Leaf Task)** | Niveau 3 | Compétence atomique | SMI, effort, Bloom, statut, début/fin |

**Colonnes configurables** (réorganisables, triables) :
- Nom · Statut · SMI · Bloom · Effort (h) · % Progression · Début prévu · Fin prévue · Début réel · Fin réelle · Slack (j) · Chemin critique · Charge FSRS · Prérequis

**Collapse/Expand** : chaque niveau peut être replié/déployé (par défaut : Thèmes déployés, sous-thèmes déployés, nœuds repliés).

---

### 2.3 Barres de Tâches (Panneau Droit)

Chaque nœud est représenté par une **barre Gantt** avec progression interne :

#### Structure d'une barre
```
                    ←———— Durée totale (effort ÷ dispo hebdo) ————→
    ┌──────────────────────────────────────────────────────────────┐
    │████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
    └──────────────────────────────────────────────────────────────┘
    ↑                      ↑                                        ↑
    Début prévu           Progression actuelle (78%)               Fin prévue
                          (line intérieure)
```

#### Styles par statut
| Statut | Style barre | Contour | Halo |
|--------|-------------|---------|------|
| 🔒 Verrouillé | Gris hachuré fin | Tirets gris | ❌ |
| ▶️ Disponible | Bleu électrique plein | Continu bleu | ❌ |
| ⚡ En cours | Bleu translucide + remplissage progressif | Épais bleu | ✅ Pulsant |
| ✅ Complété | Vert émeraude plein + SMI or | Continu vert | ❌ |
| ⏸️ Suspendu | Gris strié | Tirets orange | ❌ |
| 🔄 Remédiation | Orange plein | Épais orange | ✅ |

#### Barre de Summary Task (Thème/Sous-thème)
- Barre **noire épaisse** englobant les sous-tâches (du début du 1er nœud à la fin du dernier).
- Progression interne = agrégat des sous-tâches (% pondéré par effort).

---

### 2.4 Types de Dépendances (Links)

Les **4 types de liens** standard Gantt, adaptés au contexte pédagogique :

| Type | Notation | Symbole | Usage pédagogique | Définition |
|------|----------|---------|-------------------|------------|
| **Finish-to-Start (FS)** | Nœud B démarre après A | `A──▶B` | Prérequis strict | A doit être complété (SMI ≥ 70) avant que B démarre |
| **Start-to-Start (SS)** | B démarre avec A (décalage) | `A━━╮B` | Apprentissage parallèle | B peut commencer X jours après le début de A (ex : pratiquer pendant qu'on apprend la théorie) |
| **Finish-to-Finish (FF)** | B finit après A | `A──╯B` | Synchronisation | B doit finir en même temps ou après A (ex : projet final dépend de tous les nœuds) |
| **Start-to-Finish (SF)** | Rare | `A──◇B` | Cas spécial | B ne peut finir qu'après le début de A (rare en pédagogie) |

**Décalages (Lag/Lead)** :
- `FS +3j` : B démarre 3 jours après la fin de A (temps de consolidation FSRS).
- `FS -2j` : B démarre 2 jours avant la fin de A (Fast-Track si SMI ≥ 86).
- `SS +5j` : B démarre 5 jours après le début de A.

**Affichage** : flèches colorées entre barres (bleu = FS, vert = SS, orange = FF, violet = SF). Flèches du chemin critique en **rouge épais**.

---

### 2.5 Chemin Critique (Critical Path) 🔴

Le **chemin critique** est la plus longue séquence de nœuds dépendants qui détermine la durée minimale du parcours. Tout retard sur un nœud du chemin critique **retarde l'ETA global**.

**Calcul** : algorithme CPM (Critical Path Method) en Rust déterministe ($0 LLM).
- **Forward pass** : Early Start (ES) et Early Finish (EF) pour chaque nœud.
- **Backward pass** : Late Start (LS) et Late Finish (LF).
- **Slack** = LS − ES (= 0 sur le chemin critique).

**Affichage** :
- Nœuds du chemin critique : barres **rouge épais** + contour rouge.
- Nœuds hors chemin critique : barres normales + slack visible en gris clair.
- Indicateur en-tête : « 🔴 Chemin critique : 5 nœuds · durée min 42 jours ».

**Interaction** :
- Bouton toggle « 🔴 Chemin critique » → isole visuellement le chemin critique (atténue les autres).
- Tooltip sur nœud critique : « Ce nœud est sur le chemin critique. Un retard repousse votre date de certification. »

---

### 2.6 Slack / Marge (Float) 📊

Le **slack** est le temps disponible pour un nœud sans impacter l'ETA global.

| Type | Définition | Visuel |
|------|-----------|--------|
| **Total Slack** | LS − ES (marge avant d'impacter le chemin critique) | Barre grise étendue après la fin du nœud |
| **Free Slack** | Temps avant d'impacter le successeur direct | Petite barre grise entre 2 nœuds |

**Affichage** :
- Slack affiché en **gris clair hachuré** à droite de la barre du nœud.
- Tooltip : « Slack : 3 jours (vous pouvez prendre 3j de retard sans impacter l'ETA) ».
- Slack = 0 → indicateur rouge « ⚠️ Pas de marge ».

---

### 2.7 Baseline vs Réel (Planifié vs Effectif) 📐

Le Gantt distingue le **planifié** (baseline) du **réel** (effectif) :

#### Barre Baseline (planifié)
- Barre **grise fine** en arrière-plan (outline seule, transparente).
- Représente le planning initial calculé par Agent-03 au démarrage.
- Capturée une fois au démarrage (snapshot `scy_dag_baseline`).

#### Barre Réelle (effectif)
- Barre **colorée** (statut) au premier plan.
- Position = début réel (quand l'utilisateur a démarré le nœud).
- Largeur = temps réel passé (mis à jour à chaque session).
- Progression interne = SMI actuel.

#### Comparaison visuelle
```
    Baseline :  ┌──────────────────────────────┐ (gris fin)
    Réel :         ┌──────────────░░░░░░░░░░░░░┘ (coloré)
                   ↑ Décalage +3j (retard)
```
- **Retard** (réel démarre après baseline) : zone rouge entre les 2 barres.
- **Avance** (réel démarre avant baseline / Fast-Track) : zone verte.
- Indicateur variance : « ±2 jours vs planifié ».

#### Snapshot baseline
- Capturé au démarrage du parcours (DAGBuilt).
- Recapturé après reprogrammation CHRONICLE (nouvelle baseline = nouveau plan).
- Historique des baselines conservé (comparaison scénarios).

---

### 2.8 Jalons / Milestones ◆

Les jalons sont des **points temporels sans durée** (losanges) :

| Jalon | Symbole | Couleur | Déclencheur |
|-------|---------|---------|-------------|
| 🏁 **Départ** | ◆ | Vert | Démarrage du parcours |
| ⭐ **Fin de jalon macro** | ◆ | Or | Tous les nœuds d'un jalon macro complétés (Dynamic Graph Splitting) |
| 🏆 **Proof of Skill** | ◆ grand | Or impérial | Tous nœuds SMI ≥ seuil + ARENA |
| 📅 **Personnalisé** | ◆ | Bleu | Ajouté par l'utilisateur (« examen le 15 juillet ») |
| ⚠️ **Alerte drift** | ◆ | Rouge clignotant | Drift détecté (Agent-07, risque > 0.80) |
| 🔄 **Reprogrammation** | ◆ | Orange | Date modifiée par CHRONICLE |

**Deadline constraint** : un jalon personnalisé peut avoir une **deadline stricte** (« doit être fini avant le 15 juillet »). Si le calcul montre un dépassement → alerte rouge « ⚠️ Deadline à risque » + CHRONICLE propose options de rattrapage.

---

### 2.9 Ressources & Charge Cognitive 🧠

Dans un Gantt projet classique, les « ressources » sont les personnes assignées. Ici, la ressource unique est le **cerveau de l'apprenant** et son **temps disponible**.

#### Ressource : Temps hebdomadaire
- Configuré à l'onboarding : `weekly_availability_hours` (ex : 5h/semaine).
- Le Gantt allonge/raccourcit les barres selon cette disponibilité.
- Si l'utilisateur change sa dispo (CHRONICLE) → recalcul automatique.

#### Heatmap de Charge Cognitive (resource loading)
Une **piste superposée** sous le Gantt montre la charge cognitive jour par jour :
```
Semaine 3 :
 Lun : ████ (2h nouveau + 15 cartes FSRS dues = charge élevée)
 Mar : ██   (1h nouveau + 8 cartes = charge modérée)
 Mer : ████ (2h nouveau + 20 cartes PIC = surcharge ⚠️)
 Jeu : █    (révisions seulement = charge légère)
 Ven :      (repos)
```

- **Charge calculée** : (heures apprentissage nouveau) + (cartes FSRS dues × 2 min).
- **Seuil optimal** : Flow Zone (15-30% error rate, charge modérée).
- **Surcharge** (> seuil) : zone rouge + suggestion CHRONICLE « Étalez vos révisions ».
- **Sous-charge** : zone grise + suggestion « Profitez-en pour avancer un nœud ».

#### Resource Leveling (Nivellement)
Si deux nœuds indépendants (SS) créent une surcharge cognitive simultanée :
- Le système **décale** automatiquement le 2ᵉ nœud (resource leveling) pour répartir la charge.
- Visualisation : barre décalée avec indicateur « ↻ Nivelé pour éviter surcharge cognitive ».

---

### 2.10 Ligne "Aujourd'hui" & Progress Line 📍

- **Ligne verticale rouge** « TODAY » traversant tout le Gantt à la date du jour.
- **Progress Line** (ligne zigzag) : relie les points de progression de chaque tâche. À gauche de TODAY = en retard, à droite = en avance.

---

### 2.11 Zoom Temporel (3 niveaux)

| Zoom | Unité | Usage | Période visible |
|------|-------|-------|-----------------|
| **Jour** | 1 colonne = 1 jour | Détail sessions, cartes FSRS dues | 2-4 semaines |
| **Semaine** (défaut) | 1 colonne = 1 semaine | Vue standard du parcours | 2-3 mois |
| **Mois** | 1 colonne = 1 mois | Parcours longs (> 3 mois) | 6-12 mois |

Scroll horizontal infini (virtualisé `@tanstack/react-virtual`).

---

### 2.12 En-tête de Synthèse (Dashboard Bar)

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ 🎯 React Developer  │  ⏱️ 8 sem (56j)  │  📊 25% (3/12)  │  SMI 62/100     │
│ 📅 Fin estimée : 15 août  │  📅 Baseline : 10 août  │  ⚠️ Variance : +5j    │
│ 🔴 Chemin critique : 5 nœuds  │  ⚡ Charge sem : 4.5h/5h  │  🏆 ETA dynamique │
│ [📋 Kanban] [🌳 Arbre] [⏱️ Gantt] [🕸️ Réseau]  [⚙️ Paramètres] [📥 Export]   │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Tech Stack & Dependencies
* **Framework** : React 18 + **React Flow** (`@xyflow/react` v12) pour le Gantt custom OU **Gantt custom SVG** (pas de librairie externe lourde, cohérent avec Mode 6).
* **CPM (Critical Path Method)** : Rust déterministe (forward/backward pass, $0 LLM, < 5ms).
* **Resource Leveling** : Rust déterministe (heuristique de décalage minimisant la surcharge).
* **ETA dynamique** : FSRS forecast + Flow score + progression réelle (Agent-05) + CHRONICLE.
* **Baseline snapshot** : table `scy_dag_baseline` (snapshot planning initial + historique).
* **Virtualisation** : `@tanstack/react-virtual` (scroll horizontal/vertical infini).
* **Données** : `scy_ascent_nodes` (estimated_hours, status, bloom_level, SMI), `scy_ascent_edges` (dependency_type, lag), `scy_ascent_goals` (weekly_availability_hours, scope_hours).
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : toutes les dates, durées, charges et slack sont calculées à partir des données RÉELLES du DAG (effort estimé Agent-03 + disponibilité hebdo + progression réelle). L'ETA dynamique s'ajuste selon la réalité (FSRS + Flow). Le CPM est un algorithme déterministe. Aucune donnée inventée.

---

## 4. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu Gantt Complet (2 panneaux)
- **GIVEN** Un DAG ASCENT généré.
- **WHEN** L'utilisateur sélectionne la vue Timeline (Gantt).
- **THEN** le système SHALL afficher le panneau gauche (WBS hiérarchique) + le panneau droit (axe temporel avec barres).
- **AND** chaque nœud SHALL être une barre avec progression interne (SMI).
- **AND** les barres SHALL être positionnées chronologiquement (ordre topologique + effort + dispo hebdo).
- **AND** les Summary Tasks (thèmes/sous-thèmes) SHALL avoir une barre agrégée.
- **AND** le système SHALL afficher l'en-tête de synthèse.

### Requirement : Types de Dépendances (FS/SS/FF/SF + Lag)
- **THEN** le système SHALL afficher les 4 types de dépendances (flèches colorées).
- **AND** le système SHALL supporter les décalages (lag/lead) : `FS+3j`, `SS+5j`, `FS-2j`.
- **AND** les dépendances du chemin critique SHALL être en rouge épais.

### Requirement : Chemin Critique (CPM)
- **THEN** le système SHALL calculer le chemin critique (CPM forward/backward pass, Rust < 5ms).
- **AND** le système SHALL afficher les nœuds critiques en rouge épais.
- **AND** le système SHALL afficher le slack de chaque nœud (gris clair, tooltip).
- **AND** un toggle « 🔴 Chemin critique » SHALL isoler le chemin.

### Requirement : Baseline vs Réel
- **THEN** le système SHALL capturer une baseline au démarrage (snapshot).
- **AND** le système SHALL afficher la baseline (gris fin) ET le réel (coloré) superposés.
- **AND** le système SHALL calculer et afficher la variance (±X jours, rouge/vert).
- **AND** après reprogrammation CHRONICLE → nouvelle baseline capturée.

### Requirement : Jalons & Milestones
- **THEN** le système SHALL afficher les jalons (◆) : 🏁 Départ, ⭐ fin jalons macro, 🏆 Proof of Skill.
- **AND** le système SHALL permettre les jalons personnalisés (avec deadline stricte optionnelle).
- **AND** une deadline à risque SHALL déclencher une alerte rouge + CHRONICLE.

### Requirement : Charge Cognitive (Resource Loading + Leveling)
- **THEN** le système SHALL afficher une heatmap de charge cognitive jour par jour.
- **AND** le système SHALL calculer la charge (heures nouveau + cartes FSRS dues × 2min).
- **AND** une surcharge SHALL être signalée (rouge + suggestion CHRONICLE).
- **AND** le système SHALL appliquer le resource leveling (décalage anti-surcharge).

### Requirement : ETA Dynamique
- **THEN** le système SHALL calculer l'ETA dynamiquement (FSRS forecast + Flow + progression réelle).
- **AND** une avance (Fast-Track) SHALL raccourcir l'ETA.
- **AND** un retard (remédiation) SHALL rallonger l'ETA + notification CHRONICLE.

### Requirement : Reprogrammation CHRONICLE
- **GIVEN** L'utilisateur signale un imprévu à CHRONICLE.
- **THEN** le système SHALL mettre à jour les barres (nouvelles positions).
- **AND** le système SHALL capturer une nouvelle baseline.
- **AND** le système SHALL afficher visuellement le décalage (indicateur « reporté »).

### Requirement : Ligne "Aujourd'hui" & Progress Line
- **THEN** le système SHALL afficher une ligne verticale rouge « TODAY ».
- **AND** le système SHALL afficher une Progress Line (zigzag reliant les progressions).
- **AND** les tâches à gauche de TODAY sans progression = retard (rouge).

### Requirement : Zoom Temporel
- **THEN** le système SHALL offrir 3 zooms : Jour / Semaine (défaut) / Mois.
- **AND** le scroll horizontal SHALL être infini (virtualisé).

### Requirement : Export Gantt
- **THEN** le système SHALL permettre l'export du Gantt (PNG, PDF Typst, iCalendar .ics pour intégration Google Calendar / Outlook).

---

## 5. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Inventer des durées non calculées depuis le DAG réel.
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Afficher une date de fin sans ETA dynamique (la date statique est trompeuse).
* 🚫 **SHALL NOT** : Permettre le glisser-déposer des barres modifiant l'ordre topologique (le DAG est déterministe — seul CHRONICLE peut reprogrammer).
* ⚠️ **MUST** : Synchronisation avec CHRONICLE (reprogrammation temps réel) + EventBus (`NodeCompleted`/`NodeUnlocked`).
* ⚠️ **MUST** : CPM calculé en Rust déterministe ($0 LLM).

---

## 6. Test cases & Validation
* **TC1 (Gantt 2 panneaux)** : DAG → WBS gauche + barres droite + en-tête synthèse.
* **TC2 (Barres)** : Position chronologique + progression SMI interne + styles par statut + Summary agrégé.
* **TC3 (Dépendances)** : 4 types (FS/SS/FF/SF) + lag/lead + flèches colorées + critiques rouges.
* **TC4 (Chemin critique)** : CPM calculé (< 5ms) + nœuds rouges + slack gris + toggle isolation.
* **TC5 (Baseline vs réel)** : Baseline gris + réel coloré + variance ±X + nouvelle baseline post-CHRONICLE.
* **TC6 (Jalons)** : 🏁/⭐/🏆 affichés + jalons personnalisés + deadline alerte.
* **TC7 (Charge cognitive)** : Heatmap jour par jour + surcharge rouge + resource leveling.
* **TC8 (ETA)** : Dynamique (avance raccourcit, retard rallonge) + notification CHRONICLE.
* **TC9 (CHRONICLE)** : Imprévu → barres repositionnées + décalage visible + nouvelle baseline.
* **TC10 (TODAY + Progress Line)** : Ligne rouge + zigzag + retards rouges.
* **TC11 (Zoom)** : Jour / Semaine / Mois + scroll infini virtualisé.
* **TC12 (Export)** : PNG + PDF + iCalendar (.ics).

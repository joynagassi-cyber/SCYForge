# ⏱️ SCY-DAG-VIEW-TIMELINE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_DAG_VIEW_TIMELINE_SPEC  
**Statut** : 🔵 PROPOSITION (EN ATTENTE DE VALIDATION UTILISATEUR)  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
La **Timeline** est la 3ᵉ vue d'affichage du DAG ASCENT. Elle projette les nœuds de compétence sur un **axe chronologique**, révélant la **durée totale de la formation**, la séquence temporelle d'apprentissage, les chevauchements possibles, et les jalons clés. C'est la vue qui répond à la question : *« Combien de temps me faudra-t-il, et selon quel calendrier ? »*

---

## 2. Structure de la Timeline

### Axe Chronologique Horizontal
```
Semaine 1    Semaine 2    Semaine 3    Semaine 4    Semaine 5    Semaine 6    Semaine 7    Semaine 8
│            │            │            │            │            │            │            │
├─[JS Fond.]─┤            │            │            │            │            │            │
│            ├──[JSX/Props]──[useState]─┤            │            │            │            │
│            │            │            ├──[useEffect]──[Hooks Adv.]─┤            │            │
│            │            │            │            │            ├──[Router]──[Redux]──────┤
│            │            │            │            │            │            │            │
🏁 Départ    │            │            │            ⭐ Milestone  │            │            🏆 Proof of Skill
```

### Composants de la Timeline

#### A — Barres de Nœuds (Gantt-style)
Chaque nœud du DAG est représenté par une **barre horizontale positionnée chronologiquement** :
- **Position X** : date de début estimée (basée sur l'ordre topologique + effort + disponibilité hebdo)
- **Largeur** : durée estimée du nœud (effort ÷ heures/semaine disponibles)
- **Couleur** : statut (Gris verrouillé / Bleu disponible / Bleu translucide en cours / Vert complété)
- **Dépendances** : flèches entre barres (prérequis → nœud dépendant)
- **Label** : nom du nœud + SMI

#### B — Jalons & Milestones (losanges)
- 🏁 **Départ** : date de début du parcours
- ⭐ **Milestones intermédiaires** : fin de chaque jalon macro (Dynamic Graph Splitting)
- 🏆 **Proof of Skill** : date de fin estimée (certification)
- 📅 **Jalons personnalisés** : l'utilisateur peut ajouter ses propres repères (ex : « examen le 15 juillet »)

#### C — En-tête de Synthèse Temporelle
```
┌─────────────────────────────────────────────────────────┐
│ ⏱️ Durée totale estimée : 8 semaines (56 jours)         │
│ 📊 Progression : 3/12 nœuds (25%) — Semaine 3/8         │
│ 📈 SMI global : 62/100                                   │
│ ⚡ Heures/semaine : 5h (configurable)                    │
│ 🎯 Date de fin estimée : 15 août 2026                   │
│ 📌 ETA dynamique : basé sur FSRS forecast + Flow score   │
└─────────────────────────────────────────────────────────┘
```

#### D — Piste Parallèle : Révisions FSRS (overlay)
- Une piste secondaire superposée montre les **cartes FSRS dues par jour** (forecast 30j).
- Permet de visualiser la charge cognitive cumulée (apprentissage nouveau + révisions).

---

## 3. Tech Stack & Dependencies
* **Framework** : React 18 + **React Flow** (`@xyflow/react` v12) pour le Gantt custom OU **react-spring** pour animations.
* **Alternative** : Gantt custom SVG (pas de librairie externe, cohérent avec Mode 6 Timeline).
* **Calcul des dates** : Rust déterministe (ordre topologique + `estimated_hours` + `weekly_availability_hours`).
* **ETA dynamique** : FSRS forecast + Flow score + historique de progression réel (Agent-05).
* **CHRONICLE** : reprogrammation des dates en cas d'imprévu (Agent-10).
* **Données** : `scy_ascent_nodes` (estimated_hours, status), `scy_ascent_goals` (weekly_availability_hours, scope_hours).
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : les dates estimées sont calculées à partir des données RÉELLES du DAG (effort + disponibilité hebdo). L'ETA dynamique s'ajuste selon la progression réelle (FSRS + Flow). Aucune durée inventée.

---

## 4. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu Gantt Chronologique

#### Scénario : Affichage de la timeline
- **GIVEN** Un DAG ASCENT généré avec effort estimé + disponibilité hebdo.
- **WHEN** L'utilisateur sélectionne la vue Timeline.
- **THEN** le système SHALL positionner chaque nœud sur un axe chronologique (semaines).
- **AND** chaque nœud SHALL être une barre (position = début estimé, largeur = durée).
- **AND** les dépendances SHALL être représentées par des flèches.
- **AND** le système SHALL afficher l'en-tête de synthèse (durée totale, % progression, ETA, SMI global).

---

### Requirement : Jalons & Milestones

#### Scénario : Repères temporels
- **THEN** le système SHALL afficher les jalons : 🏁 Départ, ⭐ Milestones (fin jalons macro), 🏆 Proof of Skill.
- **AND** le système SHALL permettre à l'utilisateur d'ajouter des jalons personnalisés.

---

### Requirement : ETA Dynamique

#### Scénario : Ajustement de la date de fin
- **GIVEN** La progression réelle de l'utilisateur (SMI, Flow score, FSRS forecast).
- **WHEN** Le système recalcule l'ETA.
- **THEN** le système SHALL ajuster la date de fin estimée dynamiquement.
- **AND** si l'utilisateur est en avance (Fast-Track) → ETA raccourci.
- **AND** si l'utilisateur est en retard (remédiation) → ETA rallongé + notification CHRONICLE.

---

### Requirement : Reprogrammation CHRONICLE

#### Scénario : Imprévu signalé
- **GIVEN** L'utilisateur signale un imprévu à CHRONICLE (Agent-10).
- **WHEN** CHRONICLE reprogramme.
- **THEN** le système SHALL mettre à jour la timeline avec les nouvelles dates.
- **AND** le système SHALL afficher visuellement le décalage (barres repositionnées + indicateur « reporté »).

---

### Requirement : Overlay Révisions FSRS

#### Scénario : Charge cognitive cumulée
- **THEN** le système SHALL superposer une piste montrant les cartes FSRS dues par jour (forecast 30j).
- **AND** le système SHALL alerter visuellement si pic de charge (ex : 120 cartes un jour → zone rouge).

---

### Requirement : Zoom Temporel

#### Scénario : Navigation dans le temps
- **THEN** le système SHALL offrir 3 niveaux de zoom temporel :
  - **Vue Jour** : détail jour par jour (sessions, cartes dues)
  - **Vue Semaine** (défaut) : macro-semaines avec nœuds
  - **Vue Mois** : vue d'ensemble mois par mois (parcours longs > 3 mois)

---

## 5. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Inventer des durées non calculées depuis le DAG réel.
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Afficher une date de fin sans ETA dynamique (la date statique est trompeuse).
* ⚠️ **MUST** : Synchronisation avec CHRONICLE (reprogrammation temps réel).

---

## 6. Test cases & Validation
* **TC1 (Gantt)** : DAG → barres chronologiques (position + largeur + dépendances + couleurs statut).
* **TC2 (Jalons)** : 🏁 Départ, ⭐ Milestones, 🏆 Proof of Skill affichés + jalons personnalisés.
* **TC3 (ETA)** : Progression réelle → ETA ajusté (avance = raccourci, retard = rallongé).
* **TC4 (CHRONICLE)** : Imprévu → timeline reprogrammée + décalage visible.
* **TC5 (FSRS overlay)** : Cartes dues par jour superposées + alerte pic de charge.
* **TC6 (Zoom)** : 3 niveaux (Jour / Semaine / Mois).
* **TC7 (Synthèse)** : En-tête durée totale + % progression + ETA + SMI global + heures/semaine.

# 🎮 SCY-AG08-ENGAGEMENT-AMPLIFIER — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG08_ENGAGEMENT_AMPLIFIER_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement de l'**AGENT-08 : ENGAGEMENT-AMPLIFIER**. Sa mission est de **booster la motivation et la rétention** via un **moteur de gamification** : XP, niveaux, badges, streaks (séries), micro-objectifs et récompenses. Il amplifie l'engagement en transformant l'apprentissage en progression visible et gratifiante, en synergie avec les interventions de l'AGENT-07.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step).
* **Signaux d'entrée** : `NodeCompleted`, `ExerciseCompleted`, `CardReviewed`, `SessionEnded`, micro-objectifs atteints.
* **Moteur de gamification** : règles d'XP/niveaux, bibliothèque de badges, gestion des streaks.
* **Dépendances internes** : AGENT-07 (micro-objectifs de ré-engagement), COSMOS (affichage progression).
* **Validation** : modèles **Zod** pour les récompenses.
* **Persistence** : tables `mfg_user_xp`, `mfg_badges`, `mfg_streaks`.

> **Rappel anti-hallucination** : les récompenses sont déclenchées par des événements réels (complétion, exercice). Aucun XP/badge n'est attribué sans action mesurée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Attribution d'XP et Progression de Niveau

#### Scénario : Gain d'XP sur action
- **GIVEN** Un événement `NodeCompleted` ou `ExerciseCompleted`.
- **WHEN** Le système traite l'événement.
- **THEN** le système SHALL attribuer l'XP correspondante selon les règles définies.
- **AND** le système SHALL mettre à jour le niveau de l'utilisateur (paliers d'XP).
- **AND** le système SHALL persister dans `mfg_user_xp`.

---

### Requirement : Badges, Streaks et Récompenses

#### Scénario : Reconnaissance des accomplissements
- **GIVEN** Une série d'actions consécutives (streak) ou un accomplissement spécial.
- **WHEN** Le seuil d'un badge/streak est atteint.
- **THEN** le système SHALL débloquer le badge correspondant (`mfg_badges`).
- **AND** le système SHALL mettre à jour le streak (jours consécutifs d'activité).
- **AND** le système SHALL notifier l'utilisateur (via COSMOS / CHRONICLE).

---

### Requirement : Micro-Objectifs de Ré-Engagement

#### Scénario : Cibles court-terme pour le drift
- **GIVEN** Une alerte de drift de l'AGENT-07.
- **WHEN** L'ENGAGEMENT-AMPLIFIER intervient.
- **THEN** le système SHALL proposer un micro-objectif atteignable (ex : « révise 3 cartes aujourd'hui »).
- **AND** le système SHALL récompenser l'accomplissement du micro-objectif pour recréer de la dynamique.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Attribuer XP/badges sans action mesurée.
* 🚫 **SHALL NOT** : Rendre la gamification intrusive (notifications limitées).
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens de `design.md`.
* ⚠️ **MUST** : Récompenses validées par **Zod**.

---

## 5. Test cases & Validation
* **Test Case 1 (XP)** : Un `NodeCompleted` attribue l'XP correcte et met à jour le niveau.
* **Test Case 2 (Badge)** : Un accomplissement spécial débloque le badge attendu.
* **Test Case 3 (Streak)** : Une activité quotidienne continue maintient/augmente le streak.
* **Test Case 4 (Micro-objectif)** : Une alerte drift déclenche un micro-objectif récompensé.
* **Test Case 5 (Sans action)** : Aucune action → aucun XP/badge.

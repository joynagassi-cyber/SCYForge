<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
APEX/FSRS en MVP simplifié. SMI Calculator gardé, scheduler complet différé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# ⏰ SCY-SCHEDULER-FSRS — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S05_APEX_SCHEDULER_FSRS_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
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

## 0. Frontière avec flashcards_apex (Complémentarité)
* **scheduler_fsrs** (ce document) gère l'**algorithme FSRS 5.0** de planification (Stability/Difficulty/Retrievability, 4 états, feedback 4 niveaux, calibration).
* **flashcards_apex** gère les **10 types de cartes** (contenu, génération, leech).

---

## 1. Purpose
Cette spécification définit le comportement du **scheduler FSRS 5.0** (`fsrs` 0.6 Rust natif, **0 appel LLM**). Il modélise la mémoire humaine via 3 paramètres par carte (Stability, Difficulty, Retrievability), recalculés après chaque révision, avec 4 états et un feedback 4 niveaux. C'est le cœur de rétention spaced-repetition de SCY Forge.

---

## 2. Tech Stack & Dependencies
* **Algorithme** : `fsrs` 0.6 (Rust natif, **0 LLM**).
* **Paramètres par carte** : Stability (S, jours pour R=90%), Difficulty (D, 1-10), Retrievability (R = e^(-t/S)).
* **4 états** : New → Learning → Review → Relearning (machine à états).
* **Feedback 4 niveaux** : Again (1) / Hard (2) / Good (3) / Easy (4) — D-005.
* **Calibration** : 17 paramètres FSRS ajustés après 1000+ révisions + personnalisation par domaine (PAPER-005).
* **History Replay** : recalcul rétroactif (Event Sourcing FSRS, `scy_apex_reviews` immuable).
* **Self-Consistency Checker** : simulations Monte Carlo hebdo (D-OPT-028).
* **Tables** : `scy_apex_cards` (fsrs_state, next_review_at), `scy_apex_reviews` (immuable), `scy_apex_sessions`.

> **Rappel anti-hallucination** : FSRS est un algorithme déterministe Rust pur ($0 LLM). `R = e^(-t/S)` est la formule officielle. Aucune intervalle négative (test property-based D-ARC-012).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Calcul des 3 Paramètres & Retrievability

#### Scénario : Recalcul après révision
- **GIVEN** Une carte révisée avec un rating (Again/Hard/Good/Easy).
- **WHEN** FSRS recalcule.
- **THEN** le système SHALL mettre à jour S, D, et le `next_review_at`.
- **AND** le système SHALL calculer `R = e^(-t/S)`.
- **AND** le système SHALL NE JAMAIS produire d'intervalle négative (invariant property-based).

---

### Requirement : 4 États (Machine à états)

#### Scénario : Transitions d'état
- **GIVEN** Une carte dans un état.
- **THEN** le système SHALL respecter les transitions : New → Learning → Review → Relearning (sur Again) → Review.
- **AND** intervals selon l'état (Learning : 1min/10min/1j ; Review : FSRS complet).

---

### Requirement : Feedback 4 Niveaux (D-005)

#### Scénario : Effets des ratings
- **GIVEN** Un rating utilisateur.
- **THEN** Again → reset Learning +1 lapse, interval <1j ; Hard → interval ×0.5 ; Good → interval ×2.5 ; Easy → interval ×4.0 + graduated.
- **AND** Undo (touche U / Ctrl+Z) → retour à l'état FSRS précédent.
- **AND** Calibration auto si usage Easy excessif.

---

### Requirement : Calibration & Personnalisation

#### Scénario : Ajustement 17 paramètres
- **GIVEN** ≥ 1000 révisions accumulées.
- **THEN** le système SHALL ajuster les 17 paramètres FSRS selon l'historique personnel.
- **AND** le système SHALL différencier les paramètres par domaine (PAPER-005).

---

### Requirement : Due Cards Forecast & Retention Cible

#### Scénario : Planification de charge
- **THEN** le système SHALL calculer un forecast 30j (cartes dues par jour, Recharts bar chart).
- **AND** le système SHALL maintenir la retention rate cible 90% (configurable 85-95%).

---

### Requirement : Self-Consistency Checker (D-OPT-028)

#### Scénario : Audit de dérive
- **GIVEN** Hebdomadairement.
- **THEN** le système SHALL lancer 10 000 simulations Monte Carlo virtuelles par user.
- **AND** le système SHALL auto-calibrer les 17 constantes selon la vitesse réelle.

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Appel LLM dans le scheduler (Rust pur, $0).
* 🚫 **FORBIDDEN** : Intervalle négative (invariant property-based D-ARC-012).
* 🚫 **SHALL NOT** : Modifier `scy_apex_reviews` (Event Sourcing immuable, RGPD).
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens `design.md`.

---

## 5. Test cases & Validation
* **TC1 (Recalcul)** : Rating → S/D/next_review_at mis à jour ; R = e^(-t/S).
* **TC2 (Intervalle)** : Property-based → aucune intervalle négative (stabilité > 0).
* **TC3 (États)** : Transitions New→Learning→Review→Relearning respectées.
* **TC4 (Feedback)** : Again/Hard/Good/Easy effets corrects ; Undo fonctionnel.
* **TC5 (Calibration)** : ≥1000 révisions → 17 paramètres ajustés + par domaine.
* **TC6 (Forecast)** : 30j calculé ; retention cible 90%.
* **TC7 (Monte Carlo)** : 10 000 simulations hebdo → auto-calibration.
* **TC8 (Immuable)** : `scy_apex_reviews` non modifiable.

# 🪨 SCY-FRICTION-MODE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S11_NEURO_FRICTION_MODE_SPEC  
**Décision d'architecture** : D-OPT-015 (Mode FRICTION d'Anti-Fluidité)  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le **Mode FRICTION** (D-OPT-015). Il **casse l'illusion d'assimilation** par un entrelacement (interleaving 70% cible / 30% connexes) des cartes mémoire ET la **désactivation des barres de progression** en cours de session active. **Objectif : doubler la rétention à long terme** (briser l'habituation cognitive du cortex visuel).

---

## 2. Tech Stack & Dependencies
* **Interleaving** : ADAPTIVE-ROUTER (AGENT-06, déterministe Rust) — entrelacement 70% domaine cible / 30% connexes/maîtrisés (D-OPT-049).
* **Désactivation progression** : UI session (masquage barre de progression pendant session active).
* **Rétention** : mesurée APEX FSRS (comparaison fluide vs FRICTION).

> **Rappel anti-hallucination** : l'entrelacement suit des règles déterministes (70/30) basées sur le DAG réel. Aucune randomisation arbitraire. Mesure tracée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Entrelacement Interleaved (70/30)

#### Scénario : Session FRICTION
- **GIVEN** Une session APEX active en mode FRICTION.
- **THEN** le système SHALL entrelacer 70% de cartes du domaine cible + 30% de cartes connexes/maîtrisées (ADAPTIVE-ROUTER, D-OPT-049).
- **AND** le système SHALL briser l'habituation cognitive (Kornell & Bjork 2008, +25% rétention).

---

### Requirement : Désactivation des Barres de Progression

#### Scénario : Anti-fluidité visuelle
- **GIVEN** Une session active.
- **THEN** le système SHALL masquer les barres de progression en cours de session (D-OPT-015).
- **AND** le système SHALL empêcher l'illusion d'assimilation.

---

### Requirement : Mesure de Rétention

#### Scénario : Validation du gain
- **THEN** le système SHALL mesurer la rétention (APEX FSRS) — objectif ×2 vs mode fluide.

---

### Requirement : Reflection Delay (Délai de Réflexion 3s)

#### Scénario : Anti-réponse réflexe
- **GIVEN** Une session FRICTION active.
- **WHEN** Une carte est révélée.
- **THEN** le système SHALL imposer un délai de réflexion de **3 secondes** avant de permettre l'évaluation (boutons Again/Hard/Good/Easy désactivés pendant 3s).
- **AND** le système SHALL casser l'illusion de fluidité (réponse réflexe immédiate sans réflexion).
- **AND** le système SHALL afficher un compte à rebours visuel discret pendant le délai.

---

## 4. Boundaries & Constraints
* 🚫 **SHALL NOT** : Randomisation arbitraire de l'entrelacement (70/30 déterministe).
* 🚫 **MUST NOT** : Afficher les barres de progression pendant une session FRICTION active.

---

## 5. Test cases & Validation
* **TC1 (Interleaving)** : Session FRICTION → 70% cible / 30% connexes.
* **TC2 (Progression masquée)** : Barres de progression masquées pendant la session active.
* **TC3 (Rétention)** : Gain mesuré (×2 vs fluide, APEX FSRS).

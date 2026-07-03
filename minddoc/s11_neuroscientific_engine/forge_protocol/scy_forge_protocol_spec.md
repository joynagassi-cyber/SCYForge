<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📜 SCY-FORGE-PROTOCOL — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S11_NEURO_FORGE_PROTOCOL_SPEC  
**Décision d'architecture** : D-OPT-014 (Protocole FORGE d'Effet de Génération obligatoire)  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 0. Frontière avec IMPRINT / APEX (Complémentarité)
* **forge_protocol** (ce document) est le protocole d'**amorce cognitive sémantique préalable** (Feynman challenge à trous) avant tout affichage de contenu éducatif.
* **IMPRINT** (s07) gère la **mémorisation profonde manuscrite** (5 crans). **APEX** (s05) gère les **flashcards FSRS**. FORGE agit en **amont** de l'affichage.

---

## 1. Purpose
Cette spécification définit le **Protocole FORGE** (D-OPT-014). Il **interdit l'affichage passif** de tout contenu éducatif sans une tentative d'amorce cognitive sémantique préalable (Feynman challenge à trous) évaluée par l'APEX-AGENT. Fondation : Effet de Génération (Slamecka & Graf 1978). **Objectif : +20% à +40% de rétention** (passive → active).

---

## 2. Tech Stack & Dependencies
* **Évaluation** : APEX-AGENT (évaluation de l'amorce, Zod).
* **Génération du challenge** : NEURON-CHAINS (trou sémantique ciblé sur le concept clé).
* **Fallback ELI5** : D-OPT-024 (si 2 échecs consécutifs → affichage aide ELI5).
* **Rétention** : mesurée via APEX FSRS (comparaison passive vs FORGE).

> **Rappel anti-hallucination** : le challenge FORGE est généré à partir du contenu réel (concept clé du nœud). L'évaluation est tracée. Aucune amorce inventée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Amorce Obligatoire avant Affichage

#### Scénario : Challenge Feynman à trous
- **GIVEN** Un contenu éducatif sur le point d'être affiché (Knowledge Card / cours).
- **WHEN** L'utilisateur demande à voir le contenu.
- **THEN** le système SHALL exiger une amorce cognitive préalable (challenge Feynman à trous sur le concept clé).
- **AND** le système SHALL NE PAS afficher le contenu passivement sans amorce.

---

### Requirement : Évaluation & Fallback ELI5

#### Scénario : Échecs répétés
- **GIVEN** L'utilisateur échoue 2 fois consécutivement au test FORGE d'un nœud difficile.
- **THEN** le système SHALL déclencher l'affichage d'aide instantané ELI5 (D-OPT-024).
- **AND** le système SHALL neutraliser la frustration / risque d'abandon.

---

### Requirement : Mesure de Rétention

#### Scénario : Comparaison passive vs FORGE
- **THEN** le système SHALL mesurer la rétention (APEX FSRS) pour valider le gain (+20% à +40%).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Afficher du contenu éducatif passivement sans amorce FORGE (D-OPT-014).
* 🚫 **MUST NOT** : Laisser l'utilisateur bloqué sans fallback (ELI5 D-OPT-024 après 2 échecs).

---

## 5. Test cases & Validation
* **TC1 (Amorce obligatoire)** : Demande de contenu → challenge FORGE exigé avant affichage.
* **TC2 (Fallback ELI5)** : 2 échecs → aide ELI5 affichée.
* **TC3 (Rétention)** : Gain de rétention mesuré (+20% à +40% vs passif).
* **TC4 (Pas de blocage)** : L'utilisateur accède toujours au contenu (via réussite ou fallback).

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧠 SCY-AG13-COGNITIVE-VALIDATOR — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG13_COGNITIVE_VALIDATOR_SPEC  
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

## 1. Purpose
Cette spécification définit le comportement de l'**AGENT-13 : COGNITIVE-VALIDATOR**. Sa mission est de **garantir l'intégrité cognitive et pédagogique** de tout contenu généré (documents NEURON-CHAINS, scénarios ARENA, examens) en appliquant les **3 couches d'anti-hallucination** et un **score de confiance par section**. Il est le gardien de la qualité : aucun contenu non validé n'est présenté à l'utilisateur.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step, gate de validation).
* **3 couches anti-hallucination** :
  1. **Traçabilité source** : toute assertion doit être reliée à une source ingérée.
  2. **Cohérence interne** : détection des contradictions logiques.
  3. **Vérification externe** : recoupement sur des faits vérifiables (référentiel COSMOS / sources).
* **Score de confiance** : calcul par section (objectif ≥ 85/100, taux d'hallucination < 1 %).
* **LLM** : LlmRouter + BudgetGuard (vérification de cohérence).
* **Dépendances internes** : NEURON-CHAINS (contenus), ARENA (scénarios), VISUAL-CRITIC (sémantique visuelle).
* **Validation** : modèles **Zod** pour les verdicts de validation.

> **Rappel anti-hallucination** : le COGNITIVE-VALIDATOR est lui-même soumis à la règle de traçabilité. Aucun verdict n'est émis sans preuve (source/cohérence/vérification).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Validation par les 3 Couches Anti-Hallucination

#### Scénario : Contrôle d'un document généré
- **GIVEN** Un document généré par NEURON-CHAINS.
- **WHEN** Le COGNITIVE-VALIDATOR l'examine.
- **THEN** le système SHALL vérifier la traçabilité de chaque assertion vers une source ingérée (couche 1).
- **AND** le système SHALL détecter les contradictions logiques internes (couche 2).
- **AND** le système SHALL recouper les faits vérifiables (couche 3).
- **AND** le système SHALL produire un verdict (`valid` / `revise` / `reject`) par section.

---

### Requirement : Score de Confiance par Section

#### Scénario : Calcul et seuil
- **GIVEN** Les résultats des 3 couches.
- **WHEN** Le système calcule le score.
- **THEN** le système SHALL produire un score de confiance par section (objectif ≥ 85/100).
- **AND** le système SHALL estimer le taux d'hallucination (objectif < 1 %).
- **AND** le système SHALL bloquer toute section sous le seuil (renvoi à NEURON-CHAINS pour révision).

---

### Requirement : Gate de Qualité Globale

#### Scénario : Décision finale sur un contenu
- **GIVEN** Les scores de toutes les sections.
- **WHEN** Le système décide.
- **THEN** le système SHALL n'autoriser la présentation que si le score global ≥ seuil.
- **AND** le système SHALL journaliser le score et les justifications (Langfuse / rapport de confiance).
- **AND** le système SHALL émettre un rapport de confiance attaché au document.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Laisser passer un contenu non validé (gate bloquante).
* 🚫 **FORBIDDEN** : Valider une assertion sans source traçable (couche 1).
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens de `design.md`.
* ⚠️ **MUST** : Verdicts validés par **Zod**.

---

## 5. Test cases & Validation
* **Test Case 1 (Traçabilité)** : Une assertion sans source est détectée (couche 1).
* **Test Case 2 (Contradiction)** : Une contradiction interne est détectée (couche 2).
* **Test Case 3 (Score)** : Le score par section est calculé ; une section < seuil est bloquée.
* **Test Case 4 (Gate)** : Un document global < seuil n'est pas présenté.
* **Test Case 5 (Rapport)** : Un rapport de confiance est généré et journalisé.

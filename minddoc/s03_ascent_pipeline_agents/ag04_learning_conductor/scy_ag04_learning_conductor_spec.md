<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎓 SCY-AG04-LEARNING-CONDUCTOR — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG04_LEARNING_CONDUCTOR_SPEC  
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
Cette spécification définit le comportement de l'**AGENT-04 : LEARNING-CONDUCTOR**. Sa mission est d'**orchestrer les sessions d'apprentissage actif** : présenter le contenu ingéré, déclencher la génération documentaire via **NEURON-CHAINS**, planifier les révisions via **APEX/FSRS**, et déclencher la **mémorisation profonde IMPRINT**. Il est le chef d'orchestre de l'expérience d'apprentissage quotidienne de l'utilisateur.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step).
* **Dépendances internes orchestrées** :
  - **NEURON-CHAINS** : génération de documents (synthèses, explications) pour chaque nœud.
  - **APEX/FSRS 5.0** : planification des révisions espacées et flashcards.
  - **SCY-IMPRINT** : sessions de mémorisation profonde.
  - **COSMOS** : présentation visuelle du parcours (mode roadmap).
* **LLM** : LlmRouter + BudgetGuard (assistance contextuelle pendant la session).
* **Validation** : modèles **Zod** pour les sessions.
* **EventBus** : `SessionEnded`, `ExerciseCompleted`, `NodeCompleted`.

> **Rappel anti-hallucination** : LEARNING-CONDUCTOR orchestre les modules existants ; il ne génère pas lui-même le contenu pédagogique (rôle de NEURON-CHAINS). Tout contenu présenté est tracé vers une source.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Conduite d'une Session d'Apprentissage

#### Scénario : Présentation et apprentissage actif d'un nœud
- **GIVEN** Un nœud du DAG avec ses sources ingérées (depuis AGENT-02).
- **WHEN** L'utilisateur entame la session.
- **THEN** le système SHALL déclencher NEURON-CHAINS pour générer les documents pédagogiques du nœud (synthèse, explications).
- **AND** le système SHALL présenter le parcours dans COSMOS (mode roadmap).
- **AND** le système SHALL proposer des exercices actifs et des flashcards APEX/FSRS.
- **AND** le système SHALL émettre `ExerciseCompleted` à chaque validation.

---

### Requirement : Planification des Révisions & Mémorisation

#### Scénario : Boucle de rétention
- **GIVEN** Une session terminée sur un nœud.
- **WHEN** Le système planifie la suite.
- **THEN** le système SHALL enregistrer la session et émettre `SessionEnded { duration_minutes, cards_reviewed }`.
- **AND** le système SHALL planifier les révisions FSRS pour les flashcards du nœud.
- **AND** le système SHALL déclencher une session IMPRINT de mémorisation profonde pour les concepts clés.

---

### Requirement : Progression et Déblocage des Nœuds

#### Scénario : Validation d'un nœud
- **GIVEN** Un utilisateur atteignant la cible SMI d'un nœud (signal de l'AGENT-05).
- **WHEN** Le nœud est validé.
- **THEN** le système SHALL émettre `NodeCompleted { user_id, node_id, smi_achieved }`.
- **AND** le système SHALL débloquer les nœuds dépendants (`NodeUnlocked`) selon l'ordre topologique du DAG.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Générer du contenu pédagogique directement (déléguer à NEURON-CHAINS).
* 🚫 **SHALL NOT** : Débloquer un nœud dont les prérequis ne sont pas validés.
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens de `design.md`.
* ⚠️ **MUST** : Sessions et exercices validés par **Zod**.

---

## 5. Test cases & Validation
* **Test Case 1 (Session)** : Une session produit des documents NEURON-CHAINS + flashcards FSRS.
* **Test Case 2 (Rétention)** : `SessionEnded` est émis et les révisions FSRS sont planifiées.
* **Test Case 3 (Validation)** : Un nœud au SMI cible déclenche `NodeCompleted` et `NodeUnlocked`.
* **Test Case 4 (Prérequis)** : Un nœud sans prérequis validé n'est pas débloqué.

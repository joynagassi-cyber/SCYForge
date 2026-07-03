<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag11_arena DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# ⚔️ SCY-AG11-ARENA — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG11_ARENA_SPEC  
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

## 1. Purpose
Cette spécification définit le comportement de l'**AGENT-11 : ARENA**. Sa mission est de faire vivre des **simulations pratiques Full-AI (roleplay) dans tout domaine** : l'utilisateur est confronté à un scénario réaliste piloté par des agents IA jouant les rôles d'interlocuteurs (client, patient, recruteur, pair technique…). L'ARENA fournit l'**évaluation pratique** de la compétence (composante pratique du Proof of Skill, AGENT-09) en mesurant la performance de l'utilisateur en situation.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step).
* **Moteur de simulation** : génération de scénarios + agents-rôles (LLM, LlmRouter + BudgetGuard).
* **Dépendances internes** : AGENT-09 (déclenche la simulation), AGENT-13 (validation cognitive des scénarios), COSMOS (contexte du domaine).
* **Évaluation** : grille d'évaluation (critères mesurables par scénario).
* **Validation** : modèles **Zod** pour les scénarios et scores.
* **Persistence** : `mfg_arena_sessions`.

> **Rappel anti-hallucination** : les scénarios et évaluations sont générés puis validés (AGENT-13). Les scores reposent sur une grille d'évaluation explicite, jamais sur une appréciation arbitraire.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Génération de Scénario de Simulation

#### Scénario : Création d'un roleplay contextualisé
- **GIVEN** Un domaine et un objectif de compétence (depuis AGENT-09).
- **WHEN** L'ARENA génère la simulation.
- **THEN** le système SHALL créer un scénario réaliste (contexte, rôle de l'utilisateur, rôles des agents IA, objectifs).
- **AND** le système SHALL définir une grille d'évaluation mesurable (critères + pondération).
- **AND** le système SHALL valider le scénario via AGENT-13 (cohérence, réalisme).

---

### Requirement : Déroulement du Roleplay Full-AI

#### Scénario : Interaction multi-tours
- **GIVEN** Un scénario validé et démarré.
- **WHEN** L'utilisateur interagit avec les agents-rôles.
- **THEN** le système SHALL faire jouer les agents IA (réponses contextualisées au rôle).
- **AND** le système SHALL maintenir la cohérence du scénario sur plusieurs tours.
- **AND** le système SHALL enregistrer la transcription de la session.

---

### Requirement : Évaluation de la Performance Pratique

#### Scénario : Scoring de la simulation
- **GIVEN** Une session ARENA terminée.
- **WHEN** Le système évalue.
- **THEN** le système SHALL scorer la performance selon la grille d'évaluation (critères mesurables).
- **AND** le système SHALL produire un score de performance pratique (≥ seuil requis par AGENT-09).
- **AND** le système SHALL fournir un feedback ciblé (points forts, axes d'amélioration).

---

### Requirement : Architecture HSM de Persona (D-OPT-008)

#### Scénario : Machine à états finis hiérarchique
- **GIVEN** Un persona Full-AI construit par l'ARENA.
- **WHEN** Le roleplay se déroule.
- **THEN** le système SHALL structurer le persona en **machine à états finis hiérarchique (HSM)**.
- **AND** chaque état psychologique actif (ex : *Méfiant*, *Intéressé*, *Convaincu*, *Fermé*) dicte le comportement et le ton.
- **AND** le système SHALL mettre à jour un **Mood score** (-1.0 hostile → +1.0 convaincu) après chaque message utilisateur (classification sémantique ultra-rapide DeepSeek V4).
- **AND** le système SHALL envoyer uniquement la consigne de l'état actif au LLM (pas le prompt complet), conservant **100% du Prompt Caching DeepSeek** (-40% tokens/message).

### Requirement : FSRS Stability Gate avant ARENA (D-OPT-051)

#### Scénario : Verrouillage préalable
- **GIVEN** L'utilisateur veut lancer une simulation ARENA (Bloom ≥ 4).
- **WHEN** La stabilité FSRS des concepts requis est < 3.0 jours.
- **THEN** le système SHALL verrouiller l'accès à l'ARENA jusqu'à consolidation (Stability ≥ 3.0).

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Scorer sans grille d'évaluation explicite.
* 🚫 **SHALL NOT** : Produire des scénarios non validés par AGENT-13.
* 🚫 **SHALL NOT** : Dépasser le BudgetGuard sur les agents-rôles.
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens de `design.md`.
* ⚠️ **MUST** : Scénarios et scores validés par **Zod**.

---

## 5. Test cases & Validation
* **Test Case 1 (Scénario)** : Un domaine produit un scénario réaliste avec grille d'évaluation.
* **Test Case 2 (Roleplay)** : Les agents-rôles répondent de façon contextualisée et cohérente sur plusieurs tours.
* **Test Case 3 (Score)** : Une session terminée produit un score pratique selon la grille.
* **Test Case 4 (Seuil)** : Score ≥ seuil valide la composante pratique (AGENT-09).
* **Test Case 5 (Feedback)** : Un feedback ciblé est fourni (points forts + axes).

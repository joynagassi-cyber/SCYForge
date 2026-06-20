# 🔀 SCY-AG06-ADAPTIVE-ROUTER — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG06_ADAPTIVE_ROUTER_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement de l'**AGENT-06 : ADAPTIVE-ROUTER**. Sa mission est d'**adapter dynamiquement le parcours** : ajuster la difficulté du contenu, le rythme (pacing), et le routage des modèles LLM en fonction des performances (SMI, signaux de l'AGENT-05) et des goulots cognitifs (signalés par l'AGENT-03). Il personnalise l'expérience en temps réel pour maintenir l'utilisateur dans sa zone proximale de développement.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step).
* **Signaux d'entrée** : SMI (AGENT-05), goulots cognitifs (AGENT-03), signaux de drift (AGENT-07).
* **LlmRouter** : sélection du modèle selon la complexité du contenu et le budget.
* **NEURON-CHAINS** : régénération de contenu à difficulté ajustée.
* **Validation** : modèles **Zod** pour les décisions de routage.
* **EventBus** : décisions de routage consommées par AGENT-04.

> **Rappel anti-hallucination** : les décisions de l'ADAPTIVE-ROUTER s'appuient sur des signaux mesurés (SMI, drift). Aucune régénération n'est déclenchée sans justification chiffrée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Ajustement de Difficulté & Rythme

#### Scénario : Adaptation à la performance
- **GIVEN** Le SMI actuel d'un nœud et les signaux de performance (AGENT-05).
- **WHEN** L'utilisateur progresse (ou stagne).
- **THEN** le système SHALL ajuster la difficulté du contenu suivant (hausse si SMI élevé, simplification si SMI faible).
- **AND** le système SHALL ajuster le pacing (plus de nœuds si aisance, ralentissement si difficulté).
- **AND** le système SHALL valider la décision par un schéma **Zod** (`RoutingDecisionSchema`).

---

### Requirement : Traitement des Goulots Cognitifs

#### Scénario : Renforcement sur les nœuds critiques
- **GIVEN** Un nœud signalé comme goulot cognitif par l'AGENT-03 (forte dépendance entrante).
- **WHEN** Le système route le parcours.
- **THEN** le système SHALL prioriser le renforcement de ce nœud (exercices supplémentaires, IMPRINT approfondi).
- **AND** le système SHALL déclencher une régénération NEURON-CHAINS avec explications enrichies si le SMI stagne.

---

### Requirement : Routage Économique des Modèles

#### Scénario : Sélection du modèle LLM selon complexité
- **GIVEN** Une tâche de génération/explication à effectuer.
- **WHEN** Le système sélectionne le modèle.
- **THEN** le système SHALL choisir le modèle via le LlmRouter selon la complexité (modèle léger pour tâches simples, modèle avancé pour raisonnement complexe).
- **AND** le système SHALL respecter le BudgetGuard.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Déclencher des régénérations sans signal mesuré justifiant l'ajustement.
* 🚫 **SHALL NOT** : Dépasser le BudgetGuard lors du routage de modèles.
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens de `design.md`.
* ⚠️ **MUST** : Décisions validées par **Zod**.

---

## 5. Test cases & Validation
* **Test Case 1 (Ajustement)** : Un SMI élevé augmente la difficulté ; un SMI faible la simplifie.
* **Test Case 2 (Goulot)** : Un nœud goulot reçoit un renforcement prioritaire.
* **Test Case 3 (Routage modèle)** : Une tâche simple utilise un modèle léger ; une tâche complexe un modèle avancé.
* **Test Case 4 (Budget)** : Le routage respecte le BudgetGuard.

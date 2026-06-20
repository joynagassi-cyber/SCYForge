# 🎨 SCY-AG12-VISUAL-CRITIC — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG12_VISUAL_CRITIC_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement de l'**AGENT-12 : VISUAL-CRITIC**. Sa mission est d'**évaluer et d'améliorer la qualité des représentations visuelles** produites par COSMOS (graphes de connaissances, cartes conceptuelles, visualisations) et les figures issues de l'ingestion. Il vérifie la **clarté, la lisibilité, la justesse sémantique et l'accessibilité (WCAG)** des rendus visuels afin qu'ils communiquent efficacement le savoir.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step).
* **Cible** : rendus COSMOS (26 modes), figures d'ingestion, infographies NEURON-CHAINS.
* **Critères** : clarté, densité nœuds/arêtes, chevauchements, lisibilité labels, contraste/couleur (tokens `design.md`), conformité sémantique.
* **LLM** : LlmRouter + BudgetGuard (évaluation qualitative).
* **Dépendances internes** : COSMOS (moteur de rendu), AGENT-13 (cohérence sémantique).
* **Validation** : modèles **Zod** pour les critiques visuelles.
* **EventBus** : décisions de réajustement visuel consommées par COSMOS.

> **Rappel anti-hallucination** : les critiques s'appuient sur des métriques visuelles mesurables (densité, chevauchements, contraste) et sur les tokens de design officiels. Aucune évaluation arbitraire.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Évaluation de la Lisibilité du Graphe

#### Scénario : Détection de surcharge visuelle
- **GIVEN** Un rendu COSMOS (graphe de connaissances) généré.
- **WHEN** Le VISUAL-CRIC l'évalue.
- **THEN** le système SHALL mesurer la densité (nœuds/arêtes), les chevauchements et la lisibilité des labels.
- **AND** le système SHALL signaler une surcharge visuelle si les seuils sont dépassés.
- **AND** le système SHALL recommander des ajustements (regroupement, filtrage, fisheye lens).

---

### Requirement : Justesse Sémantique & Conformité Design

#### Scénario : Validation de la représentation
- **GIVEN** Un rendu visuel.
- **WHEN** Le système valide.
- **THEN** le système SHALL vérifier la conformité aux tokens de couleur `design.md` (pas de rouge/bleu fade non autorisés).
- **AND** le système SHALL vérifier le contraste (accessibilité WCAG).
- **AND** le système SHALL valider la justesse sémantique (les arêtes reflètent les vraies relations) avec AGENT-13.

---

### Requirement : Recommandations d'Amélioration

#### Scénario : Boucle d'amélioration visuelle
- **GIVEN** Une critique visuelle identifiant des défauts.
- **WHEN** Le système recommande.
- **THEN** le système SHALL proposer des améliorations concrètes (layout, échelle, mise en évidence).
- **AND** le système SHALL émettre les ajustements à COSMOS pour réajustement.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Autoriser des couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Valider un rendu sémantiquement faux (vérification AGENT-13).
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens de `design.md`.
* ⚠️ **MUST** : Critiques validées par **Zod**.

---

## 5. Test cases & Validation
* **Test Case 1 (Surcharge)** : Un graphe trop dense est signalé (seuil dépassé).
* **Test Case 2 (Couleurs)** : Une couleur hors tokens est rejetée.
* **Test Case 3 (Contraste)** : Un contraste insuffisant est signalé (WCAG).
* **Test Case 4 (Sémantique)** : Une arête fausse est détectée (AGENT-13).
* **Test Case 5 (Amélioration)** : Des recommandations concrètes sont émises à COSMOS.

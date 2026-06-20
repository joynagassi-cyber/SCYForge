# 🌳 SCY-AG03-DAG-ARCHITECT — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG03_DAG_ARCHITECT_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement de l'**AGENT-03 : DAG-ARCHITECT**. Sa mission est de **construire le graphe d'apprentissage (DAG — Directed Acyclic Graph)** à partir de l'objectif formalisé par l'AGENT-01 : décomposition en nœuds de compétence, chaînes de prérequis (relations de dépendance), ordre topologique, estimation d'effort par nœud et cibles SMI. Ce DAG est la structure de données centrale pilotée par COSMOS et consommée par tous les agents suivants.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step).
* **LLM** : LlmRouter + BudgetGuard (décomposition de compétences).
* **Référentiel de compétences** : COSMOS Knowledge Graph (prérequis canoniques entre concepts).
* **Validation** : modèles **Zod** pour le DAG (`DagSchema` : nœuds + arêtes + métadonnées).
* **Structures** : graphe acyclique dirigé, ordre topologique, détection de cycles.
* **Persistence** : tables `mfg_ascent_nodes`, `mfg_ascent_edges` (PostgreSQL).

> **Rappel anti-hallucination** : le DAG doit être **acyclique** (vérification algorithmique stricte) et ses prérequis doivent s'appuyer sur le référentiel COSMOS, sans inventer de dépendances arbitraires.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Décomposition en Nœuds de Compétence

#### Scénario : Génération du graphe depuis l'objectif
- **GIVEN** Un objectif formalisé par l'AGENT-01 (ex : « React »).
- **WHEN** Le DAG-ARCHITECT construit le parcours.
- **THEN** le système SHALL décomposer le domaine en nœuds atomiques de compétence.
- **AND** le système SHALL définir pour chaque nœud : un libellé, une cible SMI, et une estimation d'effort.
- **AND** le système SHALL valider la structure par `DagSchema` (Zod).

---

### Requirement : Chaînes de Prérequis et Ordre Topologique

#### Scénario : Dépendances et planification
- **GIVEN** Un ensemble de nœuds.
- **WHEN** Le système établit les relations.
- **THEN** le système SHALL définir les arêtes de prérequis (nœud A requis avant nœud B) en s'appuyant sur COSMOS.
- **AND** le système SHALL calculer un **ordre topologique** valide.
- **AND** le système SHALL garantir l'**acyclicité** (rejet si un cycle est détecté).
- **AND** le système SHALL détecter les **goulots cognitifs** (nœuds à forte dépendance entrante) pour alerter l'AGENT-06 ADAPTIVE-ROUTER.

---

### Requirement : Personnalisation par le Niveau de Départ

#### Scénario : Adaptation au SMI existant
- **GIVEN** Le niveau de départ de l'utilisateur (SMI préexistant, depuis l'AGENT-01).
- **WHEN** Le DAG est finalisé.
- **THEN** le système SHALL marquer comme déjà acquis les nœuds dont le SMI est ≥ seuil.
- **AND** le système SHALL raccourcir le parcours en évitant de re-planifier ces nœuds.
- **AND** le système SHALL émettre l'événement `DagBuilt { user_id, goal_id, node_count, edges_count }`.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Produire un graphe contenant un cycle (DAG = Acyclic).
* 🚫 **SHALL NOT** : Inventer des prérequis non fondés sur le référentiel COSMOS.
* 🚫 **SHALL NOT** : Ingérer du contenu (rôle de l'AGENT-02) — DAG-ARCHITECT ne produit que la structure.
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens de `design.md`.
* ⚠️ **MUST** : Structure validée par **Zod**.

---

## 5. Test cases & Validation
* **Test Case 1 (Décomposition)** : Un objectif produit un DAG avec nœuds et arêtes valides.
* **Test Case 2 (Acyclicité)** : Aucun cycle n'est présent (vérification algorithmique).
* **Test Case 3 (Ordre topo)** : L'ordre topologique respecte toutes les dépendances.
* **Test Case 4 (Personnalisation)** : Les nœuds au SMI ≥ seuil sont marqués acquis.
* **Test Case 5 (Goulot)** : Les nœuds à forte dépendance entrante sont signalés.

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🔀 SCY-ENGINE-REACT-FLOW — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_ENGINE_REACT_FLOW_SPEC  
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
Cette spécification définit le comportement du **moteur engine_react_flow**, basé sur **React Flow**. Il assure le **rendu interactif des DAG et diagrammes orientés** : visualisation de la roadmap d'apprentissage ASCENT (nœuds de compétence + dépendances), parcours utilisateur, et flux processus. Il est dédié aux représentations **structurées et éditables** (par opposition aux graphes force-dirigés de engine_g6/cosmograph).

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + **React Flow** (`@xyflow/react`).
* **Fonctionnalités** : nœuds/edges personnalisés, layouts dirigés (dagre), mini-map, contrôles, édition interactive.
* **Design** : tokens `design.md`.
* **Intégration** : DAG ASCENT (depuis AGENT-03), EventBus `DagBuilt`, `NodeCompleted`, `NodeUnlocked`.

> **Rappel anti-hallucination** : React Flow est la librairie réelle pour les diagrammes de nœuds interactifs. Palette stricte `design.md`. Le moteur consomme le DAG réel produit par l'AGENT-03.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu du DAG ASCENT

#### Scénario : Affichage de la roadmap d'apprentissage
- **GIVEN** Un DAG ASCENT produit par l'AGENT-03 (nœuds + arêtes de prérequis).
- **WHEN** engine_react_flow rend le DAG.
- **THEN** le système SHALL afficher la roadmap via React Flow (layout dirigé dagre, ordre topologique).
- **AND** le système SHALL représenter le statut de chaque nœud (acquis/débloqué/verrouillé/complété).
- **AND** le système SHALL écouter `NodeCompleted`/`NodeUnlocked` pour mettre à jour le statut en temps réel.

---

### Requirement : Interactivité & Navigation

#### Scénario : Exploration de la roadmap
- **GIVEN** Un DAG rendu.
- **WHEN** L'utilisateur interagit.
- **THEN** le système SHALL fournir zoom/pan/mini-map.
- **AND** le système SHALL permettre la sélection d'un nœud pour afficher son détail (cible SMI, effort, sources).

---

### Requirement : Personnalisation Visuelle

#### Scénario : Nœuds et arêtes stylisés
- **GIVEN** Le DAG avec différents statuts.
- **WHEN** Le système stylise.
- **THEN** le système SHALL appliquer des styles distincts par statut (tokens `design.md`).
- **AND** le système SHALL mettre en évidence les chemins critiques et goulots cognitifs.

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Afficher un nœud débloqué dont les prérequis ne sont pas validés (cohérence avec AGENT-03/04).
* ⚠️ **MUST** : Validation Zod du DAG avant rendu.

---

## 5. Test cases & Validation
* **Test Case 1 (DAG)** : Le DAG ASCENT s'affiche en layout dirigé avec statuts corrects.
* **Test Case 2 (Temps réel)** : `NodeCompleted` met à jour le statut du nœud.
* **Test Case 3 (Interactivité)** : Zoom/pan/sélection fonctionnels.
* **Test Case 4 (Goulot)** : Les chemins critiques/goulots sont mis en évidence.
* **Test Case 5 (Cohérence)** : Un nœud verrouillé (prérequis non validés) reste verrouillé.

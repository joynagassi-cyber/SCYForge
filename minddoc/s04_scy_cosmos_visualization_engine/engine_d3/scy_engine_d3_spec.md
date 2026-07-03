<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎛️ SCY-ENGINE-D3 — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_ENGINE_D3_SPEC  
**Décision d'architecture** : D-RENDER-008  
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
Cette spécification définit le comportement du **moteur engine_d3**, basé sur **d3 v7** (~80KB lazy-loadé). Il offre un **contrôle bas niveau** pour les visualisations custom nécessitant des algorithmes géométriques spécialisés : coordonnées parallèles interactives (brushing), arcs géométriques, faisceaux d'arêtes hiérarchiques (edge bundling) et tessellation Voronoi. Moteur des modes M15, M20, M21, M24.

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + **d3 v7** (`d3-scale`, `d3-shape`, `d3-brush`, `d3-delaunay`, `d3-hierarchy`).
* **Rendu** : SVG bas niveau (contrôle total).
* **Lazy-loading** : module d3 chargé à la demande uniquement si M15/M20/M21/M24 visités (D-RENDER-008).
* **Performance** : calculs géométriques déportés en Web Worker (M15 jusqu'à 5 000 concepts).
* **Données** : graphes Graphology (axes parallèles, ordonnés linéaires, dépendances hiérarchiques, coordonnées cartésiennes).
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : d3 v7 est la librairie réelle désignée par D-RENDER-008 pour ces 4 modes custom. Palette stricte `design.md`.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu des 4 Modes Géométriques

#### Scénario : Parallel Coordinates (M15)
- **GIVEN** Un graphe mappé sur N axes parallèles (Difficulté, SMI, Date, Stabilité FSRS).
- **WHEN** Le mode M15 est activé.
- **THEN** le système SHALL rendre les axes et trajectoires via d3.
- **AND** le brushing (glisser sur un axe) filtre instantanément les concepts hors intervalle (opacity 0.05).
- **AND** les calculs de trajectoires (≤ 5 000 concepts) s'exécutent en Web Worker.

#### Scénario : Arc Diagram (M20)
- **GIVEN** Un graphe ordonné linéairement Graphology.
- **WHEN** Le mode M20 est activé.
- **THEN** le système SHALL aligner les nœuds sur un axe et tracer les arcs via d3.
- **AND** le rayon des arcs est clampé (pas de dépassement de canvas).

#### Scénario : Hierarchical Edge Bundling (M21)
- **GIVEN** Un graphe de dépendances denses + hiérarchie sous-jacente.
- **WHEN** Le mode M21 est activé.
- **THEN** le système SHALL tracer les faisceaux d'arêtes (Bézier tendues) via d3.
- **AND** au-delà de 2 000 nœuds périphériques, bascule sur regroupement de branches (LOD 1).
- **AND** la tension des faisceaux est réglable par slider.

#### Scénario : Voronoi Concept Map (M24)
- **GIVEN** Des coordonnées cartésiennes de concepts.
- **WHEN** Le mode M24 est activé.
- **THEN** le système SHALL générer les cellules Voronoi via `d3-delaunay`.
- **AND** les coordonnées de bordure sont clampées au viewport.

---

### Requirement : Web Worker & Performance

#### Scénario : Déport des calculs
- **GIVEN** Un grand nombre de trajectoires (M15) ou de nœuds (M21).
- **WHEN** Le rendu est sollicité.
- **THEN** le système SHALL exécuter les calculs géométriques dans un Web Worker.
- **AND** le système SHALL NE PAS bloquer le thread principal.

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Inclure d3 dans le bundle initial (lazy-loading D-RENDER-005).
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Bloquer le thread principal (Web Worker obligatoire pour les calculs lourds).
* ⚠️ **MUST** : Validation Zod des données avant rendu.

---

## 5. Test cases & Validation
* **Test Case 1 (M15 brushing)** : Le brushing filtre les concepts hors intervalle.
* **Test Case 2 (M20 arcs)** : Les arcs sont clampés (pas de dépassement).
* **Test Case 3 (M21 LOD)** : > 2 000 nœuds → regroupement de branches activé.
* **Test Case 4 (M24 Voronoi)** : Cellules clampées au viewport.
* **Test Case 5 (Worker)** : Les calculs ne bloquent pas le thread principal.
* **Test Case 6 (Lazy-load)** : d3 absent du bundle initial.

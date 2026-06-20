# 🌌 SCY-ENGINE-COSMOGRAPH — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_ENGINE_COSMOGRAPH_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement du **moteur engine_cosmograph**, basé sur **Cosmograph** (rendu GPU/WebGL accéléré). Il assure le **rendu de graphes de très grande échelle** (100 000+ nœuds/arêtes) en exploitant la parallélisation GPU pour la simulation de forces et le rendu, là où engine_g6 (AntV G6) atteint ses limites. Il est dédié à la visualisation massive du graphe COSMOS global.

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + **Cosmograph** (librairie de visualisation GPU/WebGL).
* **Rendu** : WebGL via GPU, simulation de forces (force-directed) parallélisée sur GPU.
* **Performance** : gestion native des dizaines/centaines de milliers d'éléments.
* **Design** : tokens `design.md`.
* **Intégration** : données COSMOS globales, EventBus `KnowledgeGraphUpdated`.

> **Rappel anti-hallucination** : Cosmograph est une librairie réelle de visualisation GPU de grands graphes. Palette stricte `design.md`. Le moteur n'est activé que pour les graphes dépassant le seuil de performance d'engine_g6.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu GPU des Graphes Massifs

#### Scénario : Visualisation à très grande échelle
- **GIVEN** Un graphe COSMOS global de très grande taille (> seuil engine_g6, ex : 100 000+ nœuds).
- **WHEN** engine_cosmograph prend le relais.
- **THEN** le système SHALL rendre le graphe via Cosmograph (simulation GPU force-directed).
- **AND** le système SHALL exploiter la parallélisation GPU pour le calcul des forces et le rendu.
- **AND** le système SHALL maintenir une interactivité fluide (≥ 30 FPS) malgré l'échelle.

---

### Requirement : Bascule depuis engine_g6

#### Scénario : Sélection du moteur selon l'échelle
- **GIVEN** Un graphe dont la taille dépasse le seuil de performance d'engine_g6.
- **WHEN** Le système sélectionne le moteur de rendu.
- **THEN** le système SHALL basculer automatiquement vers engine_cosmograph.
- **AND** le système SHALL conserver la cohérence visuelle (palette, enveloppe) entre les deux moteurs.

---

### Requirement : Interactivité à Grande Échelle

#### Scénario : Navigation sur un graphe massif
- **GIVEN** Un graphe massif rendu.
- **WHEN** L'utilisateur zoome/explore.
- **THEN** le système SHALL fournir un zoom fluide révélant les clusters locaux.
- **AND** le système SHALL mettre en évidence les clusters/communautés à l'échelle globale.

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Utiliser engine_cosmograph pour de petits graphes (engine_g6 est préféré en dessous du seuil).
* ⚠️ **MUST** : Validation Zod des données avant rendu.

---

## 5. Test cases & Validation
* **Test Case 1 (Échelle)** : 100 000 nœuds rendus à ≥ 30 FPS via GPU.
* **Test Case 2 (Basulement)** : Un graphe > seuil déclenche engine_cosmograph (cohérence visuelle conservée).
* **Test Case 3 (Clusters)** : Le zoom révèle les clusters locaux.
* **Test Case 4 (Palette)** : Aucune couleur hors tokens.

# 📈 SCY-ENGINE-STATISTICAL — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_ENGINE_STATISTICAL_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 0. Frontière avec engine_g2 (Complémentarité)
* **engine_statistical** (ce document) est la **couche supérieure spécialisée** : visualisations statistiques/scientifiques spécifiques à l'apprentissage (heatmaps, matrices de corrélation, Sankey de trajectoires, distributions SMI).
* **engine_g2** est la couche primitive de graphiques généraux. engine_statistical peut s'appuyer sur G2 pour le rendu mais fournit des vues analytiques dédiées.

---

## 1. Purpose
Cette spécification définit le comportement du **moteur engine_statistical**. Il fournit les **visualisations statistiques et scientifiques** dédiées à l'analyse de l'apprentissage : heatmaps de rétention, matrices de corrélation entre concepts, diagrammes de Sankey des trajectoires d'apprentissage, distributions du SMI. Il exploite les vues matérialisées (`mv_concept_correlations`, `mv_learning_trajectories`).

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + AntV G2 v5 (heatmaps/Sankey) ou librairies stats compatibles.
* **Sources** : vues matérialisées (`mv_concept_correlations`, `mv_learning_trajectories`, `mv_user_smi_summary`).
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : les données visualisées proviennent des vues matérialisées PostgreSQL (données réelles agrégées). Palette stricte `design.md`.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Heatmaps de Rétention & Corrélations

#### Scénario : Affichage des corrélations entre concepts
- **GIVEN** La vue `mv_concept_correlations` disponible.
- **WHEN** engine_statistical rend la heatmap.
- **THEN** le système SHALL afficher une heatmap des corrélations entre concepts.
- **AND** le système SHALL refléter les données réelles de la vue matérialisée.

---

### Requirement : Trajectoires d'Apprentissage (Sankey/Alluvial)

#### Scénario : Visualisation des parcours
- **GIVEN** La vue `mv_learning_trajectories`.
- **WHEN** Le moteur rend les trajectoires.
- **THEN** le système SHALL afficher un diagramme Sankey/Alluvial des trajectoires d'apprentissage.
- **AND** le système SHALL montrer les flux entre nœuds/états.

---

### Requirement : Distribution du SMI

#### Scénario : Analyse de la performance
- **GIVEN** Les données SMI agrégées (`mv_user_smi_summary`).
- **WHEN** Le moteur rend la distribution.
- **THEN** le système SHALL afficher la distribution du SMI (histogramme/boîte à moustaches).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Inventer des données statistiques non présentes dans les vues matérialisées.
* ⚠️ **MUST** : Validation Zod des données analytiques.

---

## 5. Test cases & Validation
* **Test Case 1 (Heatmap)** : La heatmap reflète `mv_concept_correlations`.
* **Test Case 2 (Sankey)** : Le Sankey reflète `mv_learning_trajectories`.
* **Test Case 3 (SMI)** : La distribution reflète `mv_user_smi_summary`.
* **Test Case 4 (Palette)** : Aucune couleur hors tokens.

# 🔬 SCY-LENS-SYSTEM — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_LENS_SYSTEM_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 0. Frontière avec fisheye_lens (Complémentarité)
* **lens_system** (ce document) est le **framework extensible** orchestrant tous les types de lentilles COSMOS : fisheye (focus+context), filtrage, mise en évidence sémantique, lentilles de relation, lentilles de similarité.
* **fisheye_lens** est l'une des lentilles géométriques intégrées au système.

---

## 1. Purpose
Cette spécification définit le comportement du **lens_system** de COSMOS. Il fournit un **framework de lentilles sémantiques** permettant d'explorer le graphe de connaissances sous différents angles : lentille de fisheye (zoom focus+context), lentille de filtrage (masquer/montrer par type/SMI/domaine), lentille de mise en évidence (révéler les relations d'un concept), lentille de similarité (regrouper les concepts proches). Il est extensible pour ajouter de nouvelles lentilles.

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + AntV G6 v5 (extensibilité plugins).
* **Lentilles intégrées** : fisheye (focus+context), filtrage, mise en évidence, similarité.
* **Données** : graphe COSMOS (nœuds + arêtes + poids + SMI).
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : les lentilles opèrent sur les données réelles du graphe COSMOS. Palette stricte `design.md`.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Framework Extensible de Lentilles

#### Scénario : Activation et combinaison de lentilles
- **GIVEN** Un graphe COSMOS rendu.
- **WHEN** L'utilisateur active une lentille (ex : filtrage par domaine).
- **THEN** le système SHALL appliquer la lentille sélectionnée sur le graphe.
- **AND** le système SHALL permettre de combiner plusieurs lentilles (ex : fisheye + mise en évidence).
- **AND** le système SHALL être extensible (ajout de nouvelles lentilles sans refonte).

---

### Requirement : Lentilles Sémantiques

#### Scénario : Mise en évidence des relations d'un concept
- **GIVEN** Un concept sélectionné dans le graphe.
- **WHEN** La lentille de mise en évidence est activée.
- **THEN** le système SHALL révéler toutes les relations (arêtes) du concept.
- **AND** le système SHALL atténuer les éléments non liés.

#### Scénario : Lentille de similarité
- **GIVEN** Un concept sélectionné.
- **WHEN** La lentille de similarité est activée.
- **THEN** le système SHALL regrouper/mettre en évidence les concepts sémantiquement proches (embeddings).

---

### Requirement : Lentille de Filtrage

#### Scénario : Filtrage par attribut
- **GIVEN** Le graphe complet.
- **WHEN** L'utilisateur filtre par type/SMI/domaine.
- **THEN** le système SHALL masquer les nœuds ne correspondant pas au critère.
- **AND** le système SHALL préserver les relations entre les nœuds visibles.

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Modifier les données sous-jacentes (les lentilles sont des vues, pas des mutations).
* ⚠️ **MUST** : Les lentilles doivent être réversibles.

---

## 5. Test cases & Validation
* **Test Case 1 (Combinaison)** : Plusieurs lentilles activées simultanément fonctionnent ensemble.
* **Test Case 2 (Mise en évidence)** : La lentille révèle les relations d'un concept.
* **Test Case 3 (Similarité)** : La lentille regroupe les concepts proches.
* **Test Case 4 (Filtrage)** : Le filtrage masque correctement les nœuds non correspondants.
* **Test Case 5 (Extensibilité)** : Une nouvelle lentille peut être ajoutée sans refonte.
* **Test Case 6 (Réversibilité)** : Les lentilles sont réversibles (données intactes).

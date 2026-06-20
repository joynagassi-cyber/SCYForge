# 📊 SCY-ENGINE-NIVO — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_ENGINE_NIVO_SPEC  
**Décision d'architecture** : D-RENDER-007  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement du **moteur engine_nivo**, basé sur **nivo** (dataviz déclaratif, ~120KB lazy-loadé). Il fournit les visualisations **relationnelles et matricielles** declaratives : diagrammes de rubans (Chord), flux (Sankey/Alluvial), matrices de chaleur (Heatmap) et bulles imbriquées (Circle Packing). C'est le moteur des modes COSMOS M12, M13, M16 et M19.

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + **nivo** (`@nivo/chord`, `@nivo/sankey`, `@nivo/heatmap`, `@nivo/circle-packing`).
* **Rendu** : SVG déclaratif (interpolations de courbes).
* **Lazy-loading** : module nivo chargé à la demande uniquement si M12/M13/M16/M19 visités (D-RENDER-005, D-RENDER-007).
* **Données** : matrices carrées (Chord/Heatmap), flux structurés (Sankey), hiérarchies (Circle Packing) issus de Graphology.
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : nivo est la librairie réelle désignée par D-RENDER-007 pour ces 4 modes. Palette stricte `design.md` (pas de rouge/bleu fade non autorisés). Lazy-loading obligatoire pour ne pas gonfler le bundle initial.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu des 4 Modes Relationnels

#### Scénario : Affichage Chord (M12)
- **GIVEN** Une matrice carrée bidirectionnelle d'interactions (≤ 150-200 nœuds).
- **WHEN** Le mode M12 est activé.
- **THEN** le système SHALL rendre le Chord via `@nivo/chord` (rubans d'épaisseur ∝ intensité).
- **AND** le survol d'un arc assombrit le reste et met en valeur ses rubans.

#### Scénario : Affichage Sankey (M13)
- **GIVEN** Un JSON de flux structuré par étapes d'apprentissage.
- **WHEN** Le mode M13 est activé.
- **THEN** le système SHALL rendre le Sankey via `@nivo/sankey`.
- **AND** les flux < 2% de la masse totale sont masqués sous « Autres flux ».

#### Scénario : Affichage Heatmap (M16)
- **GIVEN** Une matrice symétrique d'affinité sémantique (cosinus).
- **WHEN** Le mode M16 est activé.
- **THEN** le système SHALL rendre la heatmap via `@nivo/heatmap` (intensité blanc→violet ∝ similarité).
- **AND** un `⚠️` s'affiche si similarité > 0.95 (redondance).

#### Scénario : Affichage Circle Packing (M19)
- **GIVEN** Un JSON hiérarchique Graphology.
- **WHEN** Le mode M19 est activé.
- **THEN** le système SHALL rendre les bulles imbriquées via `@nivo/circle-packing`.
- **AND** les sous-bulles < 5px sont masquées/floutées.

---

### Requirement : Lazy-Loading & Performance

#### Scénario : Chargement à la demande
- **GIVEN** Un bundle initial COSMOS (~220KB).
- **WHEN** L'utilisateur visite l'un des modes M12/M13/M16/M19.
- **THEN** le système SHALL charger dynamiquement le module nivo (~120KB).
- **AND** le système SHALL NE PAS inclure nivo dans le bundle initial.

---

### Requirement : Respect des Tiers Device

#### Scénario : Compatibilité
- **GIVEN** Un appareil classé LOW/COMPAT.
- **WHEN** Un mode nivo est demandé.
- **THEN** le système SHALL appliquer les limites de nœuds (Chord ≤ 150, Heatmap clampée).
- **AND** le système SHALL fournir un fallback liste simplifiée si le rendu SVG sature.

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Inclure nivo dans le bundle initial (lazy-loading obligatoire D-RENDER-005).
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Dépasser les limites de nœuds (Chord ≤ 200, Sankey flux < 2% masqués).
* ⚠️ **MUST** : Validation Zod des matrices/flux avant rendu.

---

## 5. Test cases & Validation
* **Test Case 1 (Chord)** : Une matrice 50×50 rend correctement, survol met en valeur les rubans.
* **Test Case 2 (Sankey)** : Les flux < 2% sont masqués sous « Autres flux ».
* **Test Case 3 (Heatmap)** : Une similarité > 0.95 déclenche le `⚠️`.
* **Test Case 4 (Circle Packing)** : Les bulles < 5px sont masquées.
* **Test Case 5 (Lazy-load)** : nivo absent du bundle initial, chargé à la visite d'un mode.

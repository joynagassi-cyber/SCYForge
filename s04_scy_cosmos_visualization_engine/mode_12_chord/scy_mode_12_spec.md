# 🟢 SCY-MODE-12 — CHORD DIAGRAM (SPEC)
**ID** : S04_COSMOS_MODE_12_SPEC · **Mode** : M12 — La Vue de Co-occurrence · **Moteur** : `nivo` Chord (D-RENDER-007) · **UX** : D-UX-MODES-004

## 1. Purpose
Le **MODE 12** rend lisibles les **relations croisées bidirectionnelles denses** et les co-occurrences de concepts via des rubans d'épaisseurs variables reliant des arcs périphériques.

## 2. Requirements (RFC 2119)
### Rendu chord
- **GIVEN** Une matrice carrée bidirectionnelle d'interactions (≤ 200 nœuds).
- **WHEN** M12 activé.
- **THEN** le système SHALL la rendre via `@nivo/chord` (domaines en arcs périphériques colorés, rubans épaisseur ∝ intensité d'association).
### Interactions
- **WHEN** survol d'un arc.
- **THEN** le système SHALL assombrir tout sauf les rubans émanant de l'arc.
- **AND** clic sur un ruban → tooltip expliquant le croisement + 3 concepts partagés majeurs.
### Résilience
- **GIVEN** Matrice > 200 nœuds.
- **THEN** limite stricte de calcul 200 (évite enchevêtrement central).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 > 200 nœuds. 🚫 nivo dans bundle initial.

## 4. Tests
- **TC1** : Chord rendu (arcs colorés, rubans ∝ intensité).
- **TC2** : Survol arc → mise en valeur de ses rubans.
- **TC3** : Clic ruban → tooltip + 3 concepts partagés.
- **TC4** : Matrice > 200 → limitée à 200.
- **TC5** : nivo lazy-loadé ; palette `design.md`.

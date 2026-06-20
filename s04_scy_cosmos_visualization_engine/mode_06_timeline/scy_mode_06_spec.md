# 🟢 SCY-MODE-06 — TIMELINE (SPEC)
**ID** : S04_COSMOS_MODE_06_SPEC · **Mode** : M6 — La Vue Chronologique · **Moteur** : React Custom Renderer + `react-spring`

## 1. Purpose
Le **MODE 6** affiche les événements/concepts sur un **axe temporel horizontal**. Indispensable pour l'apprentissage historique, médical ou des processus industriels séquentiels.

## 2. Requirements (RFC 2119)
### Rendu chronologique
- **GIVEN** Une liste d'événements sémantiques ordonnés avec timestamps.
- **WHEN** M6 activé.
- **THEN** le système SHALL rendre des cartes chronologiques verticales sur un axe horizontal (SVG optimisé, accélération CSS matérielle, `react-spring`).
- **AND** l'axe est coloré selon l'époque/domaine ; badge d'alerte mémorielle sur les dates clés en oubli.
### Clic
- **WHEN** une carte est cliquée.
- **THEN** le système SHALL l'agrandir, zoomer l'axe vers sa date et ouvrir un résumé sémantique détaillé.
### Résilience & FSRS
- **GIVEN** Un événement à date invalide (NaN).
- **THEN** la couche de sanitization le rejette (D-VALIDATION-001).
- FSRS adapte les rappels sur les dates (évite confusion temporelle).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. ⚠️ Sanitization des dates invalides.

## 4. Tests
- **TC1** : Cartes sur axe horizontal (couleur ∝ époque, badge alerte oubli).
- **TC2** : Clic → agrandissement + zoom axe + résumé détaillé.
- **TC3** : Date NaN → rejetée (D-VALIDATION-001).
- **TC4** : Palette `design.md`.

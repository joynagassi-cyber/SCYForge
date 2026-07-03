<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-19 — CIRCLE PACKING (SPEC)
**ID** : S04_COSMOS_MODE_19_SPEC · **Mode** : M19 — La Classification Imbriquée · **Moteur** : `nivo` Circle-packing (D-RENDER-007) · **UX** : D-UX-MODES-011

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
Le **MODE 19** représente des **regroupements sémantiques doux** (appartenances conceptuelles) via des bulles circulaires imbriquées concentriquement, sans la lourdeur d'une arborescence.

## 2. Requirements (RFC 2119)
### Rendu bulles
- **GIVEN** Un JSON hiérarchique Graphology.
- **WHEN** M19 activé.
- **THEN** le système SHALL le rendre via `@nivo/circle-packing` (bulles ∝ nombre de concepts, couleur ∝ SMI moyen de la branche).
### Clic drill-down
- **WHEN** clic sur un cercle.
- **THEN** le système SHALL zoomer sur la bulle cliquée et masquer les bulles extérieures de niveau supérieur.
### Résilience
- **GIVEN** Sous-bulles < 5px.
- **THEN** floutées/masquées (performance + clarté).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 nivo dans bundle initial.

## 4. Tests
- **TC1** : Bulles imbriquées (∝ nombre concepts, couleur ∝ SMI).
- **TC2** : Clic → drill-down masquant bulles extérieures.
- **TC3** : Sous-bulles < 5px → floutées/masquées.
- **TC4** : nivo lazy ; palette `design.md`.

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-10 — SUNBURST HIÉRARCHIQUE (SPEC)
**ID** : S04_COSMOS_MODE_10_SPEC · **Mode** : M10 — La Taxonomie Radiale · **Moteur** : `@antv/g2` v5 (D-RENDER-006) · **UX** : D-UX-MODES-002

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
Le **MODE 10** navigue dans des **ontologies taxonomiques de +4 niveaux** via des anneaux concentriques (centre=racine, périphérie=feuilles). Largeur angulaire ∝ volume de sous-concepts.

## 2. Requirements (RFC 2119)
### Rendu radial hiérarchique
- **GIVEN** Un JSON d'arborescence multiniveau Graphology.
- **WHEN** M10 activé.
- **THEN** le système SHALL le rendre via G2 v5 (secteurs angulaires concentriques, largeur ∝ volume concepts).
- **AND** code couleur dynamique ∝ SMI moyen du sous-domaine (Rouge→Vert).
### Clic drill-down
- **WHEN** clic sur un secteur.
- **THEN** le système SHALL déclencher l'animation drill-down native G2 (secteur → nouvel anneau central, recalcul à 60 FPS).
- **AND** un breadcrumb horizontal montre la trajectoire (ex : Racine > Frontend > React > State), clic jalon remonte.
### Résilience & FSRS
- **GIVEN** Appareil LOW/COMPAT.
- **THEN** profondeur max 3 niveaux ; niveaux inférieurs rendus au drill-down.
- **AND** G2 (~180KB) lazy-loadé (D-RENDER-006) ; fallback liste hiérarchique sur COMPAT.
- FSRS : clic secteur rouge → session APEX focalisée sur la famille.

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 G2 dans bundle initial (lazy).

## 4. Tests
- **TC1** : Anneaux rendus (largeur ∝ volume, couleur ∝ SMI).
- **TC2** : Clic → drill-down 60 FPS + breadcrumb.
- **TC3** : LOW/COMPAT → profondeur max 3 + fallback liste.
- **TC4** : G2 lazy-loadé ; clic secteur rouge → session APEX.
- **TC5** : Palette `design.md`.

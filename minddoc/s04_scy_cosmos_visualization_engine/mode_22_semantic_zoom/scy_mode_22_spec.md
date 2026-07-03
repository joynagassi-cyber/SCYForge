<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-22 — SEMANTIC ZOOM GRAPH (SPEC)
**ID** : S04_COSMOS_MODE_22_SPEC · **Mode** : M22 — La Révélation Progressive · **Moteur** : `@cosmograph/cosmos` v3 (D-RENDER-001) · **UX** : D-UX-MODES-014

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
Le **MODE 22** permet l'exploration fluide de **gigantesques bases de connaissances (1M+ nœuds)** via 3 niveaux de zoom sémantique (LOD), sans surcharge mentale.

## 2. Requirements (RFC 2119)
### Rendu LOD sémantique
- **GIVEN** Un graphe Graphology de très grande volumétrie (3 niveaux LOD).
- **WHEN** M22 activé.
- **THEN** le système SHALL exploiter les shaders GPU de Cosmos v3 pour recalculer opacité/affichage selon le zoom.
- **AND** Macro (0-15%) : clusters majeurs en bulles lumineuses ; Intermédiaire (15-40%) : groupes + tracés forces ; Micro (>40%) : concepts individuels + labels.
- **AND** halo d'indication des concepts hors-champ (bordure du canvas).
### Clic drill-down
- **WHEN** double-clic sur un cluster.
- **THEN** le système SHALL commuter vers la vue G6 locale du projet associé (Mode 2, D-PERF-001).
### Résilience
- **GIVEN** GPU client indisponible.
- **THEN** fallback direct vers Sunburst (Mode 10) pour l'exploration multi-échelle.

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. ⚠️ Cosmos async (`await graph.ready`, D-RENDER-003).

## 4. Tests
- **TC1** : 3 niveaux LOD (clusters → groupes → concepts) selon le zoom.
- **TC2** : Halo concepts hors-champ visible.
- **TC3** : Double-clic cluster → Mode 2 G6 local.
- **TC4** : GPU indispo → fallback Sunburst (Mode 10).
- **TC5** : Palette `design.md`.

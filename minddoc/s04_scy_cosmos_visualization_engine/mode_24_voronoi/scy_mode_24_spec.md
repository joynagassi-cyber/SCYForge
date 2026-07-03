<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-24 — VORONOI CONCEPT MAP (SPEC)
**ID** : S04_COSMOS_MODE_24_SPEC · **Mode** : M24 — La Vue Territoriale · **Moteur** : `d3` v7 + `d3-delaunay` (D-RENDER-008) · **UX** : D-UX-MODES-016

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
Le **MODE 24** structure **territorialement** l'espace de connaissances (cellules polygonales ∝ importance du concept) pour une assimilation visuelle-spatiale. L'apprenant conquiert ses « territoires de compétences » (polygones rouges → verts).

## 2. Requirements (RFC 2119)
### Rendu Voronoi
- **GIVEN** Des coordonnées cartésiennes des concepts.
- **WHEN** M24 activé.
- **THEN** le système SHALL générer les cellules Voronoi via `d3-delaunay` (taille ∝ importance, couleur ∝ SMI Rouge→Vert).
### Clic
- **WHEN** clic sur un territoire.
- **THEN** le système SHALL déployer les sous-concepts internes du polygone de manière fluide.
### Résilience
- **GIVEN** Cellules de bordure.
- **THEN** coordonnées clampées aux dimensions du viewport (pas d'extension à l'infini).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 d3 dans bundle initial.

## 4. Tests
- **TC1** : Cellules Voronoi (∝ importance, couleur ∝ SMI).
- **TC2** : Clic territoire → sous-concepts internes déployés.
- **TC3** : Cellules bordure → clampées au viewport.
- **TC4** : d3 lazy ; palette `design.md`.

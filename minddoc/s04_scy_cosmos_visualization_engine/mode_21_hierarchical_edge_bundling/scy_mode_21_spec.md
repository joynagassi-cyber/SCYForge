<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-21 — HIERARCHICAL EDGE BUNDLING (SPEC)
**ID** : S04_COSMOS_MODE_21_SPEC · **Mode** : M21 — Le Désencombrement · **Moteur** : `d3` v7 (D-RENDER-008) · **UX** : D-UX-MODES-013

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
Le **MODE 21** désencombre visuellement les **graphes de dépendance denses** en canalissant les arêtes le long de leur ontologie commune. Indispensable pour ontologies complexes (médecine, aéronautique).

## 2. Requirements (RFC 2119)
### Rendu faisceaux
- **GIVEN** Un graphe de dépendances denses + hiérarchie sous-jacente.
- **WHEN** M21 activé.
- **THEN** le système SHALL disposer les nœuds circulairement en périphérie et tracer les faisceaux (Bézier tendues) via d3.
- **AND** tension réglable par slider (0 = lignes droites, 1 = canaux fusionnés).
### Survol
- **WHEN** survol d'un nœud.
- **THEN** le système SHALL révéler tout le faisceau reliant le concept à ses cibles (allumage progressif).
### Résilience
- **GIVEN** > 2 000 nœuds périphériques.
- **THEN** bascule sur regroupement de branches (LOD 1).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 d3 dans bundle initial.

## 4. Tests
- **TC1** : Nœuds circulaires + faisceaux Bézier + slider tension.
- **TC2** : Survol → révélation du faisceau (allumage progressif).
- **TC3** : > 2 000 nœuds → regroupement de branches (LOD 1).
- **TC4** : d3 lazy ; palette `design.md`.

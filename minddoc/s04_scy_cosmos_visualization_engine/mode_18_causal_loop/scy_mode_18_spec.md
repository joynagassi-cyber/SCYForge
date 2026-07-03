<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-18 — CAUSAL LOOP DIAGRAM (SPEC)
**ID** : S04_COSMOS_MODE_18_SPEC · **Mode** : M18 — La Vue Dynamique · **Moteur** : `@antv/g6` v5 (D-RENDER-001) · **UX** : D-UX-MODES-010

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
Le **MODE 18** modélise et **simule l'influence et les rétroactions** d'un système dynamique via des boucles causales polarisées (+/-). Remplace l'apprentissage par cœur par la modélisation de boucles.

## 2. Requirements (RFC 2119)
### Rendu causal
- **GIVEN** Un graphe Graphology orienté de relations causales polarisées.
- **WHEN** M18 activé.
- **THEN** le système SHALL le rendre via G6 v5 (nœuds variables, arêtes courbes : polarité `+` verte / `-` rouge).
- **AND** badges centraux : `R` (boucle renforcement, cercle vert rotatif) / `B` (équilibre, balance rouge).
### Simulation
- **WHEN** clic sur une variable + slider d'augmentation.
- **THEN** le système SHALL propager l'impulsion à 60 FPS le long des boucles.
### Résilience
- **GIVEN** Schéma avant simulation.
- **THEN** validation petgraph : aucune contradiction logique avant propagation.

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. ⚠️ Validation petgraph avant simulation.

## 4. Tests
- **TC1** : Nœuds variables + arêtes + (vert) / - (rouge) + badges R/B.
- **TC2** : Slider variable → propagation 60 FPS.
- **TC3** : Contradiction logique → bloquée avant simulation.
- **TC4** : Palette `design.md`.

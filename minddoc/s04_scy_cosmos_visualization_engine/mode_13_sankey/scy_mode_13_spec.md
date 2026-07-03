<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-13 — SANKEY / ALLUVIAL (SPEC)
**ID** : S04_COSMOS_MODE_13_SPEC · **Mode** : M13 — La Trajectoire d'Apprentissage · **Moteur** : `nivo` Sankey (D-RENDER-007) · **UX** : D-UX-MODES-005

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
Le **MODE 13** visualise les **flux de progression, transferts d'informations et points de blocage cognitif** des apprenants via des rubans horizontaux de largeurs variables entre colonnes d'étapes.

## 2. Requirements (RFC 2119)
### Rendu Sankey
- **GIVEN** Un JSON de flux structuré par étapes d'apprentissage.
- **WHEN** M13 activé.
- **THEN** le système SHALL le rendre via `@nivo/sankey` (nœuds verticaux en colonnes, rubans ∝ volume traversant, % réussite/abandon affichés).
### Interactions
- **WHEN** survol d'un ruban.
- **THEN** le système SHALL afficher taux de réussite, temps d'étude moyen et diminution FSRS de la cohorte.
- **AND** double-clic sur un bloc d'étape → ouvre le nœud ASCENT associé (session de remédiation).
### Résilience
- **GIVEN** Flux mineurs < 2% de la masse.
- **THEN** masqués sous un ruban générique « Autres flux ».

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 nivo dans bundle initial.

## 4. Tests
- **TC1** : Sankey rendu (colonnes, rubans ∝ volume, % affichés).
- **TC2** : Survol ruban → réussite + temps + FSRS cohorte.
- **TC3** : Double-clic bloc → nœud ASCENT (remédiation).
- **TC4** : Flux < 2% → « Autres flux ».
- **TC5** : nivo lazy ; palette `design.md`.

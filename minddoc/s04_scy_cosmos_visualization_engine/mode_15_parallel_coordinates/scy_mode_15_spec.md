<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-15 — PARALLEL COORDINATES (SPEC)
**ID** : S04_COSMOS_MODE_15_SPEC · **Mode** : M15 — Le Filtre Haute Dimension · **Moteur** : `d3` v7 (D-RENDER-008) · **UX** : D-UX-MODES-007

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
Le **MODE 15** filtre de manière interactive et multicritère des milliers de concepts sur des **axes parallèles** (Difficulté, SMI, Date, Stabilité FSRS) via brushing.

## 2. Requirements (RFC 2119)
### Rendu axes parallèles
- **GIVEN** Un graphe mappé sur N axes parallèles (≤ 5 000 concepts).
- **WHEN** M15 activé.
- **THEN** le système SHALL rendre les axes verticaux + trajectoires brisées horizontales (couleur ∝ domaine) via d3.
- **AND** les calculs s'exécutent en Web Worker.
### Brushing
- **WHEN** l'utilisateur drag-brush sur un axe (ex : intervalle difficulté 7-10).
- **THEN** le système SHALL grisser instantanément (opacity 0.05) les trajectoires hors intervalle.

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 Thread bloqué (Worker obligatoire). 🚫 d3 dans bundle initial.

## 4. Tests
- **TC1** : Axes + trajectoires rendus (couleur ∝ domaine).
- **TC2** : Brushing filtre les trajectoires hors intervalle (opacity 0.05).
- **TC3** : Calculs en Web Worker (thread non bloqué).
- **TC4** : d3 lazy ; palette `design.md`.

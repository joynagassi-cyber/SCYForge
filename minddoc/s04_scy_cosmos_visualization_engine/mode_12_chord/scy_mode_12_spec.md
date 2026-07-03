<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-12 — CHORD DIAGRAM (SPEC)
**ID** : S04_COSMOS_MODE_12_SPEC · **Mode** : M12 — La Vue de Co-occurrence · **Moteur** : `nivo` Chord (D-RENDER-007) · **UX** : D-UX-MODES-004

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

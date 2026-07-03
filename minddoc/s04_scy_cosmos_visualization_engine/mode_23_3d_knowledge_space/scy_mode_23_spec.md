<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-23 — 3D KNOWLEDGE SPACE (SPEC)
**ID** : S04_COSMOS_MODE_23_SPEC · **Mode** : M23 — L'Espace Immersif · **Moteur** : `three.js` (D-RENDER-009, optionnel Phase 3) · **UX** : D-UX-MODES-015

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
Le **MODE 23** exploite la **mémoire spatiale** (palais de mémoire) via un graphe conceptuel 3D volumétrique navigable à la première personne. Associer l'emplacement physique d'un concept à son sens double l'efficacité du rappel.

## 2. Requirements (RFC 2119)
### Rendu 3D volumétrique
- **GIVEN** Des coordonnées 3D (x,y,z) sur 3 axes orthogonaux (Concret↔Abstrait, Théorique↔Pratique, Fondamental↔Avancé).
- **WHEN** M23 activé (GPU check OK).
- **THEN** le système SHALL rendre les sphères lumineuses (couleur ∝ domaine, diamètre ∝ importance) + cylindres translucides + axes sémantiques 3D à 60 FPS.
### Navigation
- **WHEN** interaction.
- **THEN** le système SHALL fournir Orbit Controls (rotation, pan) et fly-to animation sur clic de sphère.
- **AND** déploiement de la Knowledge Card en 3D après fly-to.
### GPU check & fallback
- **GIVEN** Pas de WebGL2 ni GPU dédié.
- **THEN** le système SHALL masquer M23 et le remplacer par le Mode 2 (Knowledge Graph 2D).

## 3. Boundaries
- 🚫 Activer M23 sans GPU check. 🚫 three.js (~450KB) dans bundle initial. 🚫 Couleurs hors tokens `design.md`.

## 4. Tests
- **TC1** : Sphères + cylindres + axes 3D à 60 FPS.
- **TC2** : Fly-to sur clic + Knowledge Card 3D.
- **TC3** : GPU check négatif → M23 masqué, fallback Mode 2.
- **TC4** : three.js lazy (~450KB).
- **TC5** : 3 axes orthogonaux visibles ; palette `design.md`.

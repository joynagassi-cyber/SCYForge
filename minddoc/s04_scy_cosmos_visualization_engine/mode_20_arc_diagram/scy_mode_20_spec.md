<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-20 — ARC DIAGRAM (SPEC)
**ID** : S04_COSMOS_MODE_20_SPEC · **Mode** : M20 — La Vue de Flux Linéaire · **Moteur** : `d3` v7 (D-RENDER-008) · **UX** : D-UX-MODES-012

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
Le **MODE 20** identifie les **boucles d'apprentissage infini ou dépendances circulaires** via des nœuds alignés sur un axe et des arcs géométriques reliant amont/aval.

## 2. Requirements (RFC 2119)
### Rendu arcs
- **GIVEN** Un graphe ordonné linéairement Graphology.
- **WHEN** M20 activé.
- **THEN** le système SHALL aligner les nœuds sur un axe et tracer les arcs via d3 (arcs supérieurs = implications amont, inférieurs = rétroactions aval, couleur ∝ type de relation).
### Survol
- **WHEN** survol d'un nœud.
- **THEN** le système SHALL assombrir toutes les relations sauf les arcs reliant le nœud à ses cibles amont/aval.
### Résilience
- **GIVEN** Arcs à très longue distance.
- **THEN** le rayon est clampé (pas de dépassement du canvas).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 d3 dans bundle initial.

## 4. Tests
- **TC1** : Nœuds alignés + arcs (supérieurs amont / inférieurs aval, couleur ∝ type).
- **TC2** : Survol → mise en valeur amont/aval, reste assombri.
- **TC3** : Arcs longs distance → clampés.
- **TC4** : d3 lazy ; palette `design.md`.

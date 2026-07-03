<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🔬 SCY-SEMANTIC-LENSES — SPÉCIFICATION (SPEC)
**ID** : S04_COSMOS_SEMANTIC_LENSES_SPEC · **Phase** : P1 · **Réf** : master_specs §A

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

## 0. Frontière avec lens_system
* **lens_system** (existant) = framework technique (fisheye, filtrage, mise en évidence, similarité).
* **semantic_lenses** (ce module) = les **4 lentilles sémantiques multidimensionnelles** superposables sur le graphe COSMOS.

## 1. Les 4 Lentilles Sémantiques

| Lentille | Effet visuel | Donnée source |
|----------|-------------|---------------|
| **Temporelle** | Couleur cyan froid (récent) → ambre (ancien) | Date d'acquisition du concept |
| **Épistémique** | Rouge (source unique) → vert (validation croisée multi-sources académiques) | Fiabilité/nombre de sources |
| **Émotionnelle** | Taille du nœud ∝ intensité émotionnelle ou controverse extraite | Analyse sentiment sources textuelles |
| **ASCENT** | Superposition des états de maîtrise socratique (SMI) | Score SMI par concept |

## 2. Requirements (RFC 2119)
- **THEN** le système SHALL permettre de superposer plusieurs lentilles simultanément sur la même vue.
- **AND** chaque lentille SHALL être activable/désactivable indépendamment.

## 3. Tests
- TC1 : Lentille temporelle (cyan→ambre selon date). | TC2 : Lentille épistémique (rouge→vert selon fiabilité). | TC3 : Lentille émotionnelle (taille ∝ controverse). | TC4 : Lentille ASCENT (SMI superposé). | TC5 : Superposition multiple.

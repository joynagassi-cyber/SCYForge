<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-14 — RADAR COMPARAISON (SPEC)
**ID** : S04_COSMOS_MODE_14_SPEC · **Mode** : M14 — Le Profil Multidimensionnel · **Moteur** : `recharts` v2 · **UX** : D-UX-MODES-006

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
Le **MODE 14** est le tableau de bord d'**analyse métacognitive** : polygone translucide bleu (profil SMI utilisateur) superposé à un polygone cible (pointillés vert/rouge) sur 5 axes (Rétention, Profondeur, Enseignement, Métacognition, Cohérence).

## 2. Requirements (RFC 2119)
### Rendu radar
- **GIVEN** Les 5 dimensions SMI d'AGENT-05.
- **WHEN** M14 activé.
- **THEN** le système SHALL rendre via recharts un polygone bleu translucide (rgba(99,102,241,0.4)) + polygone cible pointillés.
- **AND** les valeurs des axes sont bornées [0,100] (dynamic snapping).
### Clic
- **WHEN** clic sur un sommet d'axe.
- **THEN** le système SHALL ouvrir un tiroir listant les concepts responsables de la déformation de cette dimension (ex : déficit Enseignement → Teach-Back en suspens).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 Données SMI non issues d'AGENT-05.

## 4. Tests
- **TC1** : Polygone bleu + polygone cible pointillés superposés sur 5 axes.
- **TC2** : Valeurs bornées [0,100].
- **TC3** : Clic sommet → tiroir concepts responsables.
- **TC4** : Palette `design.md`.

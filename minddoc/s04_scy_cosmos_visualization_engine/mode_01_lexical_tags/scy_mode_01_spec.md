<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-01 — LEXICAL TAGS (SPEC)
**ID** : S04_COSMOS_MODE_01_SPEC · **Mode** : M1 — La Taxonomie Plate · **Moteur** : HTML/CSS (Tailwind) + `react-window` (virtual list)

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
Le **MODE 1** affiche les tags/domaines sous forme de taxonomie plate (liste ou nuage). Rendu texte pur ultra-rapide, idéal pour appareils bas de gamme et connexions dégradées.

## 2. Requirements (RFC 2119)
### Rendu des Tags
- **GIVEN** Un array JSON de tags + fréquence d'occurrence.
- **WHEN** M1 activé.
- **THEN** le système SHALL afficher les tags (contour coloré ∝ domaine, police 12-24px ∝ importance) via DOM natif + virtual list.
- **AND** un micro-badge rouge indique le nombre de cartes APEX à réviser aujourd'hui par tag.
### Clic
- **WHEN** un tag est cliqué.
- **THEN** le système SHALL ouvrir un drawer listant les concepts de ce tag, triés par SMI croissant (cibler les lacunes).
### FSRS
- Le système SHALL permettre de lancer une session APEX groupée par étiquette lexicale (effet d'élaboration sémantique).

## 3. Boundaries
- 🚫 Aucune couleur hors tokens `design.md`. ⚠️ Validation Zod des tags.

## 4. Tests
- **TC1** : Tags affichés, police ∝ importance, badge cartes dues.
- **TC2** : Clic → drawer trié par SMI croissant.
- **TC3** : Aucun timeout (DOM natif) ; fonctionne sur connexions dégradées.
- **TC4** : Palette `design.md` respectée.

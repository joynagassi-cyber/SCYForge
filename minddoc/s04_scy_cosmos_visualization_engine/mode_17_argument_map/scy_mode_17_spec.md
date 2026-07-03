<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-17 — ARGUMENT MAP (SPEC)
**ID** : S04_COSMOS_MODE_17_SPEC · **Mode** : M17 — La Vue Dialectique · **Moteur** : `@xyflow/react` v12 (D-RENDER-001/004) · **UX** : D-UX-MODES-009

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
Le **MODE 17** structure visuellement les **débats, argumentations juridiques et raisonnements logiques** : thèse centrale (bleu), supports (vert, flèche → thèse), réfutations (rouge, flèche diamant). Indispensable pour droit, philosophie, analyse de crises.

## 2. Requirements (RFC 2119)
### Rendu argumentaire
- **GIVEN** Un graphe de propositions logiques structuré.
- **WHEN** M17 activé.
- **THEN** le système SHALL le rendre via React Flow (thèse bleu, supports vert `supports`, réfutations rouge `refutes`, flèches d'implications).
- **AND** badge source documentaire de l'argument.
### Interactions
- **WHEN** double-clic sur le texte d'un argument.
- **THEN** le système SHALL permettre l'édition en direct.
- **AND** bouton `+` flottant → créer sous-argument/contre-argument.
### Résilience
- **GIVEN** Positionnement des arguments.
- **THEN** layout asynchrone `elkjs` en Web Worker (D-UX-014).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 Max 1000 nœuds (D-RENDER-004).

## 4. Tests
- **TC1** : Thèse bleu + supports vert + réfutations rouge + flèches.
- **TC2** : Double-clic → édition texte argument.
- **TC3** : Bouton `+` → sous-argument/contre-argument.
- **TC4** : Layout elkjs Web Worker (thread non bloqué).
- **TC5** : Palette `design.md`.

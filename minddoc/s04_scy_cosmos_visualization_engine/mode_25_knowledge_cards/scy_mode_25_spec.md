<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🔴 SCY-MODE-25 — KNOWLEDGE CARDS (SPEC)
**ID** : S04_COSMOS_MODE_25_SPEC · **Mode** : M25 — Le Dashboard Spatial Interactif 🔴 CRITIQUE · **Moteur** : `@xyflow/react` v12 (D-RENDER-001) · **UX** : D-UX-MODES-017

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
Le **MODE 25** est le **mode d'apprentissage et d'action sémantique ultime** : cartes React riches éditables (jauge SMI, stabilité FSRS, mini-radar, actions rapides) connectées par des pipelines animés (particules lumineuses CSS `offset-path` ∝ similarité). L'apprenant manipule, édite et fait interagir ses concepts dans un tableau de bord spatial.

## 2. Requirements (RFC 2119)
### Rendu cartes riches
- **GIVEN** Les concepts et relations du sous-graphe d'étude actif.
- **WHEN** M25 activé.
- **THEN** le système SHALL rendre les cartes verticales riches (custom nodes React Flow) : jauge SMI, stabilité FSRS, mini-radar, boutons d'action rapide.
- **AND** les arêtes sont des pipelines SVG directionnels avec particules lumineuses (vitesse ∝ similarité sémantique).
- **AND** squelettes Shimmer localisés pendant le chargement (D-MODES-006) pour éliminer le clignotement.
- **AND** MiniMap de navigation GPS en bas-droite (D-UX-013).
### Clic / actions
- **WHEN** focus sur une carte.
- **THEN** le système SHALL permettre l'édition des notes, le lancement d'un Teach-Back, la révision de la flashcard, l'ouverture du document d'origine dans la Reader Suite.
### Résilience
- **GIVEN** Positionnement géométrique des cartes.
- **THEN** layout asynchrone `elkjs` en Web Worker (D-UX-014, 0$ serveur).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 Thread bloqué (elkjs Worker obligatoire).

## 4. Tests
- **TC1** : Cartes riches (jauge SMI, FSRS, mini-radar, actions) + pipelines animés particules.
- **TC2** : Squelettes Shimmer pendant le chargement (pas de clignotement).
- **TC3** : MiniMap GPS bas-droite.
- **TC4** : Focus carte → édition/Teach-Back/flashcard/Reader Suite.
- **TC5** : Layout elkjs Web Worker ; palette `design.md`.

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-04 — ROADMAP ASCENT (SPEC)
**ID** : S04_COSMOS_MODE_04_SPEC · **Mode** : M4 — Le Chemin de Cursus · **Moteur** : `@xyflow/react` v12 (D-RENDER-001/004)

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
Le **MODE 4** est le tableau de bord de progression d'ASCENT : DAG strict (`scy_ascent_nodes`) rendu avec nœuds HTML riches contenant des barres de progression, pipelines SVG animés.

## 2. Requirements (RFC 2119)
### Rendu du DAG cursus
- **GIVEN** Un schéma DAG strict validé par petgraph (`scy_ascent_nodes`).
- **WHEN** M4 activé.
- **THEN** le système SHALL le rendre via React Flow (layout dagre asynchrone, max 1000 nœuds D-RENDER-004).
- **AND** styles par statut : Verrouillé (gris/cadenas), Disponible (blanc/bordure bleue/play), En cours (bleu translucide/jauge SMI animée), Complété (vert/coche/SMI en or).
- **AND** arêtes = pipelines SVG de force sémantiques (sens d'apprentissage).
- **AND** halo vert pulsant autour du nœud d'apprentissage actif (Zone Proximale de Développement).
### Clic
- **WHEN** un nœud est cliqué.
- **THEN** le système SHALL afficher un Bottom Sheet : cours associé, exercices NEURON-CHAINS, bouton Teach-Back STUDENT AI.
### FSRS / Déblocage
- Un nœud ne se déverrouille que si le SMI théorique APEX ≥ 70/100 (absence de lacunes).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 Max 1000 nœuds (D-RENDER-004). ⚠️ Validation petgraph du DAG.

## 4. Tests
- **TC1** : DAG rendu (styles par statut, jauge SMI animée, pipelines SVG).
- **TC2** : Halo vert sur nœud actif.
- **TC3** : Clic → Bottom Sheet (cours + exercices + Teach-Back).
- **TC4** : Nœud débloqué uniquement si SMI ≥ 70.
- **TC5** : Max 1000 nœuds respecté ; palette `design.md`.

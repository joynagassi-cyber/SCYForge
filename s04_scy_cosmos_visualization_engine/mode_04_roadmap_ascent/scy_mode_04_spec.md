# 🟢 SCY-MODE-04 — ROADMAP ASCENT (SPEC)
**ID** : S04_COSMOS_MODE_04_SPEC · **Mode** : M4 — Le Chemin de Cursus · **Moteur** : `@xyflow/react` v12 (D-RENDER-001/004)

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

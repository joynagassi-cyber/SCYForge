# 🟢 SCY-MODE-03 — MINDMAP (SPEC)
**ID** : S04_COSMOS_MODE_03_SPEC · **Mode** : M3 — La Vue Arborescente · **Moteur** : `@antv/g6` v5 (Radial Tree Layout, D-RENDER-001)

## 1. Purpose
Le **MODE 3** cartographie mentalement un cours sous forme d'**arbre hiérarchique à racine unique** (1 parent par nœud). Idéal pour le note-taking et la révision d'un chapitre complet.

## 2. Requirements (RFC 2119)
### Rendu arborescent radial
- **GIVEN** Une structure d'arbre Graphology à racine unique (1 parent/nœud).
- **WHEN** M3 activé.
- **THEN** le système SHALL calculer la disposition radiale dans un Web Worker asynchrone (D-PERF-003).
- **AND** les nœuds sont colorés ∝ branche (domaine de filiation), arêtes en courbes de Bézier depuis la racine.
- **AND** badges simplifiés (`✓` si SMI≥70, `🔒` si non débloqué).
### Clic
- **WHEN** un nœud est cliqué.
- **THEN** le système SHALL replier/déplier la sous-branche (collapse/expand, animation élastique 300ms). Si nœud feuille → ouvre la Knowledge Card de révision.
### Résilience
- **GIVEN** Une structure contenant un cycle par erreur (>1 parent).
- **THEN** le validateur petgraph le détecte (D-VALIDATION-002) et force le basculement vers le Mode 2 (graphe) pour éviter le plantage.
### FSRS
- Sélection d'un nœud parent majeur → charge toutes les flashcards de ses descendants pour révision de chapitre.

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. ⚠️ Validation petgraph de l'arborescence.

## 4. Tests
- **TC1** : Arbre radial rendu (couleur ∝ branche, Bézier depuis racine, badges ✓/🔒).
- **TC2** : Clic → collapse/expand 300ms ; feuille → Knowledge Card.
- **TC3** : Cycle détecté → basculement Mode 2 (pas de plantage).
- **TC4** : Sélection parent → charge flashcards descendants.
- **TC5** : Layout en Web Worker (thread non bloqué).

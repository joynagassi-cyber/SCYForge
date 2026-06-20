# 🟢 SCY-MODE-05 — CONCEPTS GRID (SPEC)
**ID** : S04_COSMOS_MODE_05_SPEC · **Mode** : M5 — La Vue Tableur · **Moteur** : TanStack Table v8 + react-virtual

## 1. Purpose
Le **MODE 5** affiche les concepts en **tableur virtualisé** (colonnes : Nom, Domaine, SMI, Stabilité FSRS, Difficulté, Date). Permet d'identifier précisément les faiblesses mémorielles (tri Stabilité FSRS croissante). Fonctionne sur 100% des navigateurs (liseuses e-ink inclus).

## 2. Requirements (RFC 2119)
### Rendu tableur
- **GIVEN** Un array JSON plat d'attributs concepts.
- **WHEN** M5 activé.
- **THEN** le système SHALL l'afficher via TanStack Table v8 + virtual scroll (nombre infini de lignes, 60 FPS, 0 GPU).
- **AND** cellule SMI = badge couleur Rouge→Vert.
### Clic & tri
- **WHEN** clic sur une ligne.
- **THEN** le système SHALL ouvrir un Drawer coulissant affichant la Knowledge Card complète.
- **AND** le tri par Stabilité FSRS croissante met les concepts proches de l'oubli en haut.
### FSRS
- Permet d'identifier les faiblesses mémorielles (tri stabilité croissante).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. ⚠️ Validation Zod des attributs.

## 4. Tests
- **TC1** : Table virtualisée (10 000 lignes, 60 FPS, 0 GPU).
- **TC2** : Badge SMI Rouge→Vert.
- **TC3** : Clic → Drawer Knowledge Card complète.
- **TC4** : Tri Stabilité FSRS croissante → concepts proches oubli en haut.
- **TC5** : Compatible liseuses e-ink / bas débit.

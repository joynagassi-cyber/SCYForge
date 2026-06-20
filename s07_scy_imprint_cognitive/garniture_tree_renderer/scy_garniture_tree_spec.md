# 🌳 SCY-GARNITURE-TREE-RENDERER — SPÉCIFICATION (SPEC)
**ID** : S07_IMPRINT_GARNITURE_TREE_SPEC · **Phase** : V1 · **Réf** : PRD §7.8

## 1. Purpose
Le **Garniture Engine** extrait les 5-7 insights essentiels (Miller's Law 7±2) du Cran 5 du CRE. Le **Tree Renderer** génère un **arbre ASCII conceptuel** reproductible manuscrit (max 3 niveaux, <5 mots/nœud) destiné à être recopié à la main dans le carnet physique de l'apprenant.

## 2. Requirements (RFC 2119)
- **GIVEN** Le Cran 5 du CRE (50-65 mots, 5-7 insights).
- **THEN** le Garniture Engine SHALL extraire les 5-7 insights essentiels.
- **AND** le Tree Renderer SHALL générer un arbre ASCII (max 3 niveaux, <5 mots/nœud).
- **AND** le système SHALL persister l'arbre (`scy_imprint_trees`, svg_data).

## 3. Tests
- TC1 : 5-7 insights extraits du Cran 5. | TC2 : Arbre ASCII ≤3 niveaux, <5 mots/nœud. | TC3 : Persistance `scy_imprint_trees`.

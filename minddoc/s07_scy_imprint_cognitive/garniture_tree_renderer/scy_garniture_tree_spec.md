<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
IMPRINT ÉLIMINÉE. Contenu biblique incompatible avec cyber ops. Réécriture nécessaire.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🌳 SCY-GARNITURE-TREE-RENDERER — SPÉCIFICATION (SPEC)
**ID** : S07_IMPRINT_GARNITURE_TREE_SPEC · **Phase** : V1 · **Réf** : PRD §7.8

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | ELIMINATED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module est ÉLIMINÉ du beachhead**
• Conservé pour expansion future
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Purpose
Le **Garniture Engine** extrait les 5-7 insights essentiels (Miller's Law 7±2) du Cran 5 du CRE. Le **Tree Renderer** génère un **arbre ASCII conceptuel** reproductible manuscrit (max 3 niveaux, <5 mots/nœud) destiné à être recopié à la main dans le carnet physique de l'apprenant.

## 2. Requirements (RFC 2119)
- **GIVEN** Le Cran 5 du CRE (50-65 mots, 5-7 insights).
- **THEN** le Garniture Engine SHALL extraire les 5-7 insights essentiels.
- **AND** le Tree Renderer SHALL générer un arbre ASCII (max 3 niveaux, <5 mots/nœud).
- **AND** le système SHALL persister l'arbre (`scy_imprint_trees`, svg_data).

## 3. Tests
- TC1 : 5-7 insights extraits du Cran 5. | TC2 : Arbre ASCII ≤3 niveaux, <5 mots/nœud. | TC3 : Persistance `scy_imprint_trees`.

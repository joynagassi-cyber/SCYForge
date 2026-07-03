<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
IMPRINT ÉLIMINÉE. Contenu biblique incompatible avec cyber ops. Réécriture nécessaire.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-GARNITURE-TREE-RENDERER — PLAN / TÂCHES / TESTS
**ID** : S07_IMPRINT_GARNITURE_TREE_PLAN / TASKS / TESTS
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

## Flux : [Cran 5 CRE] → Garniture Engine (5-7 insights Miller) → Tree Renderer (ASCII ≤3 niveaux <5 mots/nœud) → `scy_imprint_trees` (svg_data).
## Dépendances : NEURON-CHAINS. Table : `scy_imprint_trees`.
## Fichiers : `backend_rs/src/imprint/garniture/insight_extractor.rs`, `tree_renderer.rs`.
## Tâches : GT.1 Garniture Engine (20min) | GT.2 Tree Renderer ASCII (25min).
## Tests : TC1 5-7 insights | TC2 arbre ≤3 niveaux <5 mots/nœud | TC3 persistance.

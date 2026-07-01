# Arbre sémantique cyber canonique

`cyber_semantic_tree.json` est l'instance **`owner_kind = domain_pack`** du Semantic Tree
pour le wedge cyber (cf. `docs/SCYFORGE_SEMANTIC_TREE_INFRASTRUCTURE.md`).

## Génération
```bash
python3 packs/cyber/scripts/build_cyber_semantic_tree.py
```

## Source de vérité (corpus réels, aucune donnée inventée)
| Élément | Source |
|---|---|
| Troncs (tactiques) | `kill_chain_order` de `attack_hierarchy.json` (MITRE CTI STIX) |
| Branches (techniques) | `families` de `attack_hierarchy.json` |
| Feuilles (sous-techniques) | `sub_techniques` de `attack_hierarchy.json` |
| Criticité (80/20) | densité de règles `attack_density.json` (SigmaHQ, 3136 règles scannées) |

## Structure produite (dernier run)
- **14 troncs** (tactiques) · **20 branches** (techniques) · **130 feuilles** (sous-techniques) · **153 arêtes**
- Top-5 branches par criticité (densité Sigma) :
  1. `T1059` Command and Scripting Interpreter — 1.000
  2. `T1218` System Binary Proxy Execution — 0.754
  3. `T1027` Obfuscated Files or Information — 0.486
  4. `T1574` Hijack Execution Flow — 0.447
  5. `T1112` Modify Registry — 0.436

## Mapping vers les types Rust (`scy-shared::tree`)
| JSON | Rust |
|---|---|
| `owner_kind: "domain_pack"` | `OwnerKind::DomainPack` |
| `nodes[].kind: trunk/branch/leaf` | `EdgeKind::{Trunk,Branch,Leaf}` (porté par l'arête) |
| `edges[].criticality` | `TreeEdge.criticality` |
| `id` (uuid5 déterministe) | `SemanticTree.id` / `Node.id` |

## Instances dérivées (non incluses ici)
- **`organization`** = ce pack **+ greffons privés** (incidents, règles Sigma internes), horodatés → anneaux de croissance.
- **`learner`** = projection maîtrisée avec `LearnerNodeState.confidence` par nœud (verrou tronc-avant-feuilles, SMI ≥ 0.70).

> `Diff(organization) − Diff(domain_pack)` = la valeur privée irréductible de l'entreprise (le moat de données).

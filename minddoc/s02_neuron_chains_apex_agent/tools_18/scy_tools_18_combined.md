<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-TOOLS-18 — PLAN / TÂCHES / TESTS
**ID** : S02_NEURON_TOOLS_18_PLAN / TASKS / TESTS
---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## Architecture : chaque tool = struct Rust implémentant le trait `Tool` de Rig (D-OPT-057). 14/18 = Rust pur ($0), 4 = LLM mini/léger.
## Fichiers : `backend_rs/src/neurochain/tools/t01_doctype_detector.rs` ... `t18_semantic_cache.rs`.
## Tâches (par groupe) :
- Groupe 1 (T01-T05) : 5 tools planification/routage (30min)
- Groupe 2 (T06-T09) : 4 tools retrieval/compression (30min)
- Groupe 3 (T10-T14) : 5 tools qualité/scoring (30min)
- Groupe 4 (T15-T16) : 2 tools output (20min)
- Groupe 5 (T17-T18) : 2 tools monitoring (20min)
## Tests : TC1 chaque tool Rig | TC2 14/18 $0 <1ms | TC3 T09 ≥60% | TC4 T18 >35% hit | TC5 T17 économie 80%.

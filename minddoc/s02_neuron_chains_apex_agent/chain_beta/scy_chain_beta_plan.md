<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-CHAIN-BETA — PLAN (PLAN)
**ID** : S02_NEURON_CHAIN_BETA_PLAN
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

## Flux : [chunks/résumés ALPHA] → BETA-1 classification 10 domaines → BETA-2 relations typées (is_a/part_of/prerequisite_of/example_of/contradicts) → BETA-3 hiérarchie + PageRank (graphology-metrics $0) → COSMOS KG (`scy_concepts`, `scy_concept_relations`).
## Dépendances : graphology-metrics (PageRank $0), petgraph (validation). Tables : `scy_concepts`, `scy_concept_relations`.
## Fichiers : `backend_rs/src/neurochain/chains/beta/taxonomist.rs`, `relation_extractor.rs`, `hierarchy_architect.rs`.

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
BRAIN en MVP simplifié (BM25 FTS uniquement). Triple retrieval + live web différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-TRIPLE-RETRIEVAL-RRF — PLAN / TÂCHES / TESTS
**ID** : S06_BRAIN_TRIPLE_RETRIEVAL_PLAN / TASKS / TESTS

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

## Flux
```
[Requête utilisateur]
   ├──► Dense Vector (pgvector/Zilliz, 512D, top-20 cosine)
   ├──► Sparse BM25 (Tantivy/PG FTS, top-20)
   └──► Graph Traversal (Graphiti, 2-hop + PageRank, top-20)
            │
            ▼
   [RRF Fusion : RRF(d)=Σ 1/(60+rank)] → top-10
            │
   (Phase 1) HyDE + KG RAG | (Phase 2) Query Rewriting ×3 + Cross-Encoder + LLMLingua-2 -60%
            │
            ▼
   [Contexte compressé → Professor AI / génération]
```
## Dépendances : pgvector/Zilliz, Tantivy, Graphiti/Zep, text-embedding-3-small, LLMLingua-2 (candle). 
## Fichiers : `backend_rs/src/brain/retrieval/dense_retriever.rs`, `sparse_retriever.rs`, `graph_retriever.rs`, `rrf_fusion.rs`, `hyde.rs`, `query_rewriter.rs`.

## Tâches
- TR.1 : Coder les 3 retrieveurs parallèles (30 min) — Dense/Sparse/Graph top-20.
- TR.2 : Coder la fusion RRF k=60 → top-10 (20 min).
- TR.3 : Coder HyDE + KG RAG Phase 1 (25 min).
- TR.4 : Coder Query Rewriting ×3 + Cross-Encoder + LLMLingua-2 Phase 2 (30 min).

## Tests
- TC1 : 3 retrieveurs parallèles top-20. | TC2 : RRF k=60 top-10 pertinent. | TC3 : HyDE +recall, KG RAG +exact match. | TC4 : Phase 2 reformulations + compression -60%.

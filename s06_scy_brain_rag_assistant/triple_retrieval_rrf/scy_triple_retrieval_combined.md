# 🛠️ SCY-TRIPLE-RETRIEVAL-RRF — PLAN / TÂCHES / TESTS
**ID** : S06_BRAIN_TRIPLE_RETRIEVAL_PLAN / TASKS / TESTS

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

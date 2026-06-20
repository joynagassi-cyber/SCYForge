# 🔍 SCY-TRIPLE-RETRIEVAL-RRF — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S06_BRAIN_TRIPLE_RETRIEVAL_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

> **📌 RÉFÉRENCE CROISÉE** : L'algorithme détaillé (Triple Retrieval, formule RRF, 3 phases 0-2) est dans **`../scy_brain_rag_retrieval_specs.md`**. Ce fichier en est le résumé comportemental aligné sur le kit SDD.

---

## 1. Purpose
Le **Triple Retrieval + RRF** est le moteur de recherche hybride de SCY-BRAIN. Il combine 3 retrieveurs indépendants (Dense Vector, BM25 Sparse, Graph Traversal) et les fusionne via Reciprocal Rank Fusion (k=60) pour produire un top-10 final de pertinence absolue, éradiquant les coupures sémantiques.

---

## 2. Tech Stack & Dependencies
* **Retriever 1 Dense** : `text-embedding-3-small` (512D), pgvector/Zilliz, top-20 cosine.
* **Retriever 2 Sparse** : Tantivy (Rust) / PG FTS, BM25, stemming 120+ langues, top-20.
* **Retriever 3 Graph** : Graphiti/Zep, 2-hop neighborhood, PageRank, top-20.
* **Fusion** : RRF `RRF(d) = Σ 1/(k + rank_m(d))`, k=60, top-10 final.
* **Phases** : Phase 0 (naive), Phase 1 (HyDE +15-20% recall + KG RAG +12% exact match), Phase 2 (Query Rewriting 3 reformulations + Cross-Encoder reranking + LLMLingua-2 compression).

> **Rappel anti-hallucination** : les 3 retrieveurs interrogent des sources réelles (chunks ingérés, graphe COSMOS). Aucune fabrication de contexte.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Triple Retrieval Parallèle
#### Scénario : Recherche hybride
- **GIVEN** Une requête utilisateur.
- **WHEN** BRAIN effectue la recherche.
- **THEN** le système SHALL exécuter les 3 retrieveurs en parallèle (Dense top-20, Sparse top-20, Graph top-20).
- **AND** le système SHALL fusionner via RRF (k=60) → top-10 final.

### Requirement : Phase 1 — HyDE + KG RAG
#### Scénario : Amélioration du recall
- **THEN** le système SHALL générer un document hypothétique (HyDE) pour le vector retrieval (+15-20% recall).
- **AND** le système SHALL extraire les entités de la requête et traverser le sous-graphe COSMOS (KG RAG, +12% exact match).

### Requirement : Phase 2 — Query Rewriting + Compression
#### Scénario : Optimisation avancée
- **THEN** le système SHALL générer 3 reformulations parallèles (+8% couverture).
- **AND** le système SHALL reranker via Cross-Encoder (+5% précision).
- **AND** le système SHALL compresser le contexte via LLMLingua-2 (local, -60%).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Fabriquer du contexte non issu des sources ingérées.
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens `design.md`.
* ⚠️ **MUST** : Validation Zod des résultats ; k=60 immuable.

---

## 5. Test cases & Validation
* **TC1** : 3 retrieveurs exécutés en parallèle, top-20 chacun.
* **TC2** : RRF (k=60) produit un top-10 fusionné pertinent.
* **TC3 (Phase 1)** : HyDE améliore le recall (+15-20%) ; KG RAG améliore l'exact match (+12%).
* **TC4 (Phase 2)** : 3 reformulations + Cross-Encoder reranking + LLMLingua-2 -60%.

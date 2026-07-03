<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
BRAIN en MVP simplifié (BM25 FTS uniquement). Triple retrieval + live web différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧠 TRIPLE RETRIEVAL & RRF FUSION — SPÉCIFICATIONS TECHNIQUES
**ID Module** : S06_BRAIN_RAG_RETRIEVAL  
**Statut** : 🟢 SPÉCIFICATION DE PRODUCTION IMMUABLE ET VALIDÉE  

---

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

## 1. Algorithme de Triple Retrieval (Recherche Hybride)
Pour éradiquer les coupures sémantiques et garantir des réponses d'une pertinence absolue, BRAIN utilise trois moteurs de recherche indépendants :

```
[Requête Utilisateur]
       │
       ├──► 1. Dense Vector Retrieval (pgvector/Zilliz) ──► Top-20 (Cosine Similarity)
       │
       ├──► 2. Sparse Text Retrieval (Tantivy/PG FTS)  ──► Top-20 (BM25)
       │
       └──► 3. Graph Traversal Retrieval (Graphiti/Zep) ──► Top-20 (PageRank & 2-hop)
               │
               ▼
   [ Fusion Reciprocal Rank Fusion (RRF) ] ──► Reranking sémantique final ──► Top-10
```

1. **Retriever 1 : Vector Similarity (Dense)** :
   - *Modèle* : `text-embedding-3-small` projeté en **512 dimensions** (réduction de coût ×3, latence optimisée).
   - *Algorithme* : Recherche de similarité cosinus via pgvector ou Zilliz, retournant le `top-k = 20`.
2. **Retriever 2 : BM25 Full-Text (Sparse)** :
   - *Algorithme* : Index inverse via **Tantivy** (Rust natif) ou PG FTS. Stemming et stopwords pour 120+ langues, support des phrases exactes et filtres à facettes (tags, dates).
3. **Retriever 3 : Graph Traversal (COSMOS)** :
   - *Algorithme* : Extraction du voisinage de 2 sauts (2-hop neighborhood) dans Graphiti, enrichie de scores de centralité PageRank pour injecter le contexte d'importance théorique du concept.

---

## 2. Formule de Fusion RRF (Reciprocal Rank Fusion)
La réconciliation des 3 ensembles de résultats s'effectue de manière déterministe via la formule RRF :

$$RRF(d) = \sum_{m \in M} rac{1}{k + 	ext{rank}_m(d)}$$

Où :
* $M$ : Ensemble des moteurs de recherche actifs ($M = \{Dense, Sparse, Graph\}$).
* $	ext{rank}_m(d)$ : Position de classement du document $d$ renvoyée par le moteur $m$ (1-indexed).
* $k$ : Constante de lissage fixée réglementairement à **$60$**.

---

## 3. Les 3 Phases de RAG Avancé
1. **Phase 0 (Naive RAG)** : Retrieval vectoriel simple + génération de prompt basique.
2. **Phase 1 (HyDE + KG RAG)** :
   - *HyDE (Hypothetical Document Embeddings)* : Le LLM génère d'abord un document factice $	o$ vectorisation $	o$ recherche de documents réels proches (+15-20% de recall).
   - *KG RAG* : Extraction des entités de la requête $	o$ traversée du sous-graphe COSMOS $	o$ injection des relations sémantiques.
3. **Phase 2 (Query Rewriting & Compression)** :
   - Génération de 3 reformulations de requêtes en parallèle (+8% de couverture).
   - Reranking final via un modèle de type Cross-Encoder (+5% de précision).
   - Compression contextuelle via **LLMLingua-2** en local avant l'envoi au LLM.

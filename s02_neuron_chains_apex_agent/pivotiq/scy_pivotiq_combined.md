# 🛠️ SCY-PIVOTIQ — PLAN / TÂCHES / TESTS
**ID** : S02_NEURON_PIVOTIQ_PLAN / TASKS / TESTS · **Réf** : PRD §7.6.3

## Flux : [≥3 sources même sujet (Agent-02)] → RRF Scorer (crédibilité+freshness, $0) → Contradiction Detector (pairwise N×(N-1)/2, types Factual/Methodological/Temporal/Scope) → Semantic Deduplicator (cosine >0.92 MERGE / 0.75-0.92 RELATED / <0.75 DISTINCT) → Unified Synthesizer (4 sections : Consensus/Nuances/Contradictions/Recommandations) → NEURON-CHAINS (synthèse propre au lieu de sources brutes).
## Dépendances : embeddings (cosine), LlmRouter+BudgetGuard (contradiction detection + synthesis). Table : `scy_pivotiq_results`.
## Fichiers : `backend_rs/src/neurochain/pivotiq/rrf_scorer.rs`, `contradiction_detector.rs`, `deduplicator.rs`, `unified_synthesizer.rs`.
## Tâches : PQ.1 RRF Scorer (20min) | PQ.2 Contradiction Detector pairwise (25min) | PQ.3 Semantic Deduplicator (20min) | PQ.4 Unified Synthesizer 4 sections (25min).
## Tests : TC1 contradictions détectées | TC2 doublons MERGE -20% LLM | TC3 synthèse 4 sections | TC4 coût ~$0.025/topic.

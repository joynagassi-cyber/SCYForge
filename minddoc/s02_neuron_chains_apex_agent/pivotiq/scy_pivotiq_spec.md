<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🔄 SCY-PIVOTIQ — RÉCONCILIATION MULTI-SOURCES (SPEC)
**ID** : S02_NEURON_PIVOTIQ_SPEC · **Phase** : V2 · **Réf** : PRD §7.6.3 · **Position** : Entre MapReduce L0-L3 et NEURON-CHAINS

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

## 1. Purpose
**PIVOTIQ** réconcilie intelligemment les sources multiples potentiellement contradictoires **avant** leur transmission à NEURON-CHAINS. Quand l'utilisateur ingère ≥ 3 sources sur le même sujet, PIVOTIQ détecte les contradictions, déduplique les contenus sémantiquement identiques, et produit une synthèse unifiée propre — évitant que NEURON-CHAINS ne génère un document incohérent.

## 2. Les 4 Composants
1. **RRF Scorer** : rank des sources selon crédibilité (Academic 1.5×, Docs 1.3×, Tutorials 1.0×, Forums 0.8×, Blogs 0.6×) + freshness + citations. ($0 Rust pur)
2. **Contradiction Detector** : comparaison pairwise N×(N-1)/2. Types : Factual, Methodological, Temporal, Scope. Severity : Major (>0.7), Moderate (0.4-0.7), Minor (≤0.4).
3. **Semantic Deduplicator** : cosine > 0.92 → MERGE ; 0.75-0.92 → RELATED ; < 0.75 → DISTINCT. (-20% appels LLM)
4. **Unified Synthesizer** : document de synthèse en 4 sections (Consensus ⭐⭐⭐⭐⭐, Nuances ⭐⭐⭐, Contradictions ⚠️, Recommandations).

## 3. Requirements (RFC 2119)
- **GIVEN** ≥ 3 sources ingérées sur le même sujet (same_topic_cluster cosine > 0.6, ≥ 2 types différents).
- **WHEN** PIVOTIQ se déclenche (automatique via Agent-02 CONTENT-SCOUT).
- **THEN** le système SHALL ranker (RRF), détecter contradictions (pairwise), dédupliquer (cosine), et produire une synthèse unifiée.
- **AND** le système SHALL transmettre la synthèse propre à NEURON-CHAINS (au lieu des sources brutes contradictoires).

## 4. Tests
- TC1 : 3 sources contradictoires → contradictions détectées (Major/Moderate/Minor). | TC2 : Doublons cosine >0.92 → MERGE (-20% LLM). | TC3 : Synthèse 4 sections (Consensus/Nuances/Contradictions/Recommandations). | TC4 : Coût ~$0.025/topic.

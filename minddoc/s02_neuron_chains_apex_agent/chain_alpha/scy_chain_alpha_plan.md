<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-CHAIN-ALPHA — PLAN (PLAN)
**ID** : S02_NEURON_CHAIN_ALPHA_PLAN
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

## Flux : [contenu brut] → ALPHA-1 extraction (DOM/OCR/transcription) → ALPHA-2 chunking sémantique (500-2000 tok, overlap 10%, tokio parallèle 10-50) → ALPHA-3 résumés L1/L2/L3 → persistance `scy_chunks` (embedding VECTOR 512).
## Dépendances : tokio (parallèle), Docling (OCR), pgvector (embeddings). Tables : `scy_chunks`.
## Fichiers : `backend_rs/src/neurochain/chains/alpha/extractor.rs`, `chunker.rs`, `summarizer.rs`.

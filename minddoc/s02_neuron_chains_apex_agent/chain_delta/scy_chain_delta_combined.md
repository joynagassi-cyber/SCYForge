<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-CHAIN-DELTA — PLAN / TÂCHES / TESTS
**ID** : S02_NEURON_CHAIN_DELTA_PLAN / TASKS / TESTS
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

## Flux : [docs GAMMA] → DELTA-1 fact-check (T11, RAG retrieval : Verified/Unsupported/Contradicted) → DELTA-2 cohérence (contradictions) → DELTA-3 citations (APA/MLA/Vancouver) → corrections tracées.
## Dépendances : T11 FactChecker, RAG, Zod. Fichiers : `delta/fact_checker.rs`, `coherence_auditor.rs`, `citation_validator.rs`.
## Tâches : DE.1 Fact-Checker T11 (25min) | DE.2 Cohérence (20min) | DE.3 Citations (20min).
## Tests : TC1 unsupported→réécrit | TC2 contradiction détectée | TC3 citations format correct.

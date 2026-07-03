<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ANTI-HALLUCINATION — PLAN / TÂCHES / TESTS
**ID** : S02_NEURON_ANTI_HALLUCINATION_PLAN / TASKS / TESTS
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

## Flux : [contenu généré] → Couche 1 ancrage RAG (chunks similarity >0.70, sources reliability >0.60) → Couche 2 cross-check (T08 CitationTracker similarity <0.60=High, T11 FactChecker Verified/Unsupported/Contradicted) → Couche 3 scoring (T10 SectionScorer, T12 ConfidenceCalc, seuils ≥85/70-84/50-69/<50) → rapport `scy_confidence_reports`.
## Dépendances : T07/T08/T10/T11/T12, RAG, LanceDB. Table : `scy_confidence_reports`.
## Fichiers : `backend_rs/src/neurochain/anti_hallucination/ancrage.rs`, `cross_check.rs`, `scoring.rs`.
## Tâches : AH.1 Couche 1 ancrage (25min) | AH.2 Couche 2 cross-check T08+T11 (25min) | AH.3 Couche 3 scoring T10+T12+rapport (25min).
## Tests : TC1 assertion sans source→High | TC2 unsupported→réécrit | TC3 rapport section+global | TC4 <50 alerte/≥85 export | TC5 <1% hallucination.

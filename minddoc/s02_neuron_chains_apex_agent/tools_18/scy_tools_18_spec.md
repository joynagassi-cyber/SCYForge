<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# ⚙️ SCY-TOOLS-18 — LES 18 TOOLS NATIFS RUST (SPEC)
**ID** : S02_NEURON_TOOLS_18_SPEC · **Décision** : NC-001 (18 tools natifs Rust, latence <1ms)

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
Les **18 tools natifs** sont compilés en Rust et exposent des capacités à l'APEX-AGENT via le trait composable `Tool` de Rig. **14 sur 18 ne consomment aucun token LLM externe** ($0).

## 2. Les 18 Tools (numérotation PRD authoritative)

### Groupe 1 — Planification & Routage
| Tool | Code | Rôle | LLM |
|------|------|------|-----|
| DocTypeDetector | T01 | Auto-détecte type doc optimal | ⚠️ Mini |
| ToneSelector | T02 | Sélectionne ton parmi 50 (matrice statique) | ❌ $0 |
| OutlinePlanner | T03 | Plan sections + budget tokens/section | ❌ $0 |
| TokenBudgeter | T04 | Calcule/surveille budget tokens temps réel | ❌ $0 |
| ModelRouter | T05 | Route vers modèle optimal (coût/qualité) | ❌ $0 |

### Groupe 2 — Contexte & Retrieval
| Tool | Code | Rôle | LLM |
|------|------|------|-----|
| RAGRetriever | T06 | Hybrid BM25 + pgvector + Graph + RRF | ❌ $0 |
| SourceVerifier | T07 | Vérifie fiabilité sources (JSON Cognitif) | ❌ $0 |
| CitationTracker | T08 | Lie chaque assertion à une source | ❌ $0 |
| PromptCompressor | T09 | LLMLingua-2 via candle ONNX (-60%) | ❌ $0 |

### Groupe 3 — Génération & Qualité
| Tool | Code | Rôle | LLM |
|------|------|------|-----|
| SectionScorer | T10 | Score 5 dimensions par section | ❌ $0 |
| FactChecker | T11 | Vérifie assertions risquées via RAG | ❌ $0 |
| ConfidenceCalc | T12 | Score global pondéré + rapport | ❌ $0 |
| StructureValidator | T13 | Conformité au type de document | ❌ $0 |
| StyleEnforcer | T14 | Cohérence stylistique ton + gabarit XML | ⚠️ Léger |

### Groupe 4 — Output & Continuité
| Tool | Code | Rôle | LLM |
|------|------|------|-----|
| ExportFormatter | T15 | PDF Typst + DOCX + MD + JSON (9 formats) | ❌ $0 |
| DocSuggester | T16 | 3 docs logiquement suivants (graphe continuité) | ❌ $0 |

### Groupe 5 — Monitoring & Contrôle
| Tool | Code | Rôle | LLM |
|------|------|------|-----|
| BudgetGuard | T17 | Surveille tokens, active mode économie | ❌ $0 |
| SemanticCache | T18 | Cache LanceDB, lookup/store (threshold 0.87) | ❌ $0 |

## 3. Requirements (RFC 2119)
- **GIVEN** L'APEX-AGENT需要一个能力 (retrieval, scoring, compression, etc.).
- **THEN** le système SHALL invoquer le tool correspondant via le trait `Tool` de Rig.
- **AND** 14 tools sur 18 SHALL s'exécuter sans appel LLM externe ($0, latence <1ms).

## 4. Boundaries
🚫 Ne jamais appeler un LLM externe pour un tool marqué ❌ $0 (Rust pur). ⚠️ Tout tool implémente le trait Rig `Tool`.

## 5. Tests
- **TC1** : Chaque tool invoquable via Rig, retourne un résultat typé.
- **TC2** : 14/18 tools s'exécutent à $0 LLM (Rust pur, <1ms).
- **TC3** : T09 PromptCompressor compresse ≥ 60%.
- **TC4** : T18 SemanticCache hit rate > 35% (threshold 0.87).
- **TC5** : T17 BudgetGuard active le mode économie à 80%.

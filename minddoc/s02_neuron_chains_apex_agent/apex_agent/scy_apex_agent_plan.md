<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-APEX-AGENT — PLAN (PLAN)
**ID** : S02_NEURON_APEX_AGENT_PLAN · **Décisions** : D-OPT-057/058/059, NC-001 à NC-006

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

## Flux ReAct
```
[INPUT : "Générer le contenu du nœud X"]
   │
   ▼
[REASON : T01 DocType → T02 Tone → T03 Outline → T04 Budget → T05 Model → T06 RAG top-15]
   │
   ▼
[ACT : T09 PromptCompressor (-60%) → génération section/section → T10 SectionScorer → T11 FactChecker]
   │
   ▼
[OBSERVE : T12 ConfidenceCalc]
   ├── score ≥ 85 → T15 ExportFormatter (export direct)
   ├── 70-84 → réécriture ciblée sections < 70 (1 cycle)
   ├── 45-69 → réécriture complète (1 cycle max)
   └── < 45 → alerte utilisateur + rapport détaillé
```
## Orchestration parallèle (D-OPT-059) :
```
[JoinSet Tokio + CancellationToken]
   ├── chaîne fiches concepts ──┐
   ├── chaîne examen ───────────┼── join_next() → si Err → cancel_token.cancel() (SAGA)
   └── chaîne exercices ────────┘
```
## Dépendances : Rig (CompletionModel/Tool), RRAG, LlmRouter+BudgetGuard, 18 tools. Tables : `scy_documents`, `scy_confidence_reports`, `scy_agent_decisions`.
## Fichiers : `backend_rs/src/neurochain/apex_agent/react_loop.rs`, `orchestration/custom_orchestrator.rs`.

# 🛠️ SCY-AG13-COGNITIVE-VALIDATOR — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG13_COGNITIVE_VALIDATOR_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données de l'Agent

```
 [Contenu généré (NEURON-CHAINS / ARENA / examen)]
                 │
                 ▼
   [Step Mastra : cognitiveValidatorStep (gate bloquante)]
                 │
   ┌─────────────┼─────────────────┐
   ▼             ▼                 ▼
 [Couche 1 :    [Couche 2 :       [Couche 3 :
  traçabilité    cohérence         vérification
  source]        interne]          externe]
   │             │                 │
   └─────────────┼─────────────────┘
                 ▼
   [Verdict par section (valid/revise/reject)]
                 │
                 ▼
   [Score de confiance par section (≥ 85 objectif)
    + taux d'hallucination (< 1 % objectif)]
                 │
        ┌────────┴────────┐
        ▼                 ▼
  [Score ≥ seuil →       [< seuil → renvoi
   autorisé + rapport    NEURON-CHAINS
   de confiance]         pour révision]
```

---

## 2. Dépendances Techniques Strictes
* **3 couches** : traçabilité source, cohérence interne, vérification externe.
* **Référentiel** : COSMOS + sources ingérées.
* **LLM** : LlmRouter + BudgetGuard (cohérence/vérification).
* **Langfuse** : journalisation des scores et justifications.
* **Zod** : `ValidationVerdictSchema`, `ConfidenceReportSchema`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag13_cognitive_validator.ts`** : Step Mastra (gate de validation).
- **`backend_ts/src/ascent/validation/source_traceability.ts`** : Couche 1 (traçabilité).
- **`backend_ts/src/ascent/validation/coherence_check.ts`** : Couche 2 (contradictions).
- **`backend_ts/src/ascent/validation/external_check.ts`** : Couche 3 (recoupement).
- **`backend_ts/src/ascent/validation/confidence_scorer.ts`** : Score par section + rapport.
- **`mfg_confidence_reports`** : Persistance des rapports de confiance.

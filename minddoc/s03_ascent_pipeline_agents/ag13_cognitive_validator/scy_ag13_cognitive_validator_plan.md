<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-AG13-COGNITIVE-VALIDATOR — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG13_COGNITIVE_VALIDATOR_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

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

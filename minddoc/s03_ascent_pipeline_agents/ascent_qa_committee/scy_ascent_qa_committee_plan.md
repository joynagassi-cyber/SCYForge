<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ASCENT-QA-COMMITTEE — PLAN D'IMPLÉMENTATION (PLAN)
**ID** : S03_ASCENT_QA_COMMITTEE_PLAN · **Décision** : D-OPT-032  
**Spécification de référence** : `scy_ascent_qa_pedagogical_pipeline_specs.md` (SPEC-SCY-ASCENT-QA-PIPELINE-V1.0)

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

## Flux
```
[Matière brute ingérée + parsée (Docling)] → Étape 1 : Construire syllabus + cours (Rust)
   │
   ▼
[Étape 2 : SAGA de portail ASCENT-QA (6 audits asynchrones)]
   ├── QA-01 Curriculum Designer (progression DAG)
   ├── QA-02 SME (exactitude technique)
   ├── QA-03 Alignment Orchestrator (couverture syllabus → AGENT-02 si manquant)
   ├── QA-04 Cognitive Load Guarantor (densité, 1 idée=1 bloc, ELI5)
   ├── QA-05 Content Validator (clarté, markdown, LaTeX, calcul PQS)
   └── QA-06 Academic Certifier (Constructive Alignment cours↔examen SurveyJS)
   │
   ▼
[Calcul PQS = 0.2·design + 0.3·expert + 0.3·align + 0.2·cognitive]
   │
   ├── PQS < 88 ──► Rejet Harmonist → APEX-AGENT (réécriture ciblée)
   │
   ▼ (PQS ≥ 88)
[Signature électronique + déblocage étude active (Parcours B)]
   │
   ▼
[Traçabilité : scy_course_qa_audits + scy_qa_agent_reviews + scy_constructive_alignment_checks]
```
## Dépendances : Mastra TS (SAGA), Rust, LlmRouter+BudgetGuard, SurveyJS, Zod (ConstructiveAlignmentSchema), Harmonist gate.
## Fichiers : `backend_ts/src/ascent/qa/qa_committee_orchestrator.ts`, `qa_01_curriculum.ts` → `qa_06_certifier.ts`, `scy_ascent_qa_alignment.ts`.

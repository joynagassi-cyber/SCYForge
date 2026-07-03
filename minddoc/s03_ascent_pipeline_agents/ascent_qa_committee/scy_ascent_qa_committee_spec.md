<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎓 SCY-ASCENT-QA-COMMITTEE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_QA_COMMITTEE_SPEC  
**Décision d'architecture** : D-OPT-032 (ASCENT-QA Validation Board)  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

> **📌 RÉFÉRENCE CROISÉE** : La spécification détaillée complète du pipeline (6 rôles, Constructive Alignment Loop, formule PQS, schémas BDD) est le document dédié **`scy_ascent_qa_pedagogical_pipeline_specs.md`** (SPEC-SCY-ASCENT-QA-PIPELINE-V1.0) auquel la présente spec renvoie. Ce fichier en est le résumé comportemental aligné sur le kit SDD.

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

## 1. Purpose
Cette spécification définit le comportement du **Comité Pédagogique d'Audit ASCENT-QA** (sous-pipeline de 6 agents pédagogiques experts). Sa mission : auditer, calibrer et valider l'**intégrité de formations auto-générées** avant d'autoriser l'octroi d'une certification (Proof of Skill) d'une rigueur équivalente ou supérieure à des cursus certifiants (Coursera, ECTS/CEU). **Barrière de sûreté** : aucun nœud d'apprentissage auto-généré ne peut être débloqué pour l'étude active (Parcours B) sans validation + signature électronique du comité (seuil **PQS ≥ 88/100**).

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (SAGA asynchrone de production) + Rust.
* **6 sous-agents** (cf. spec dédiée) :
  1. **QA-01 Senior Curriculum Designer** — cohérence/progression DAG (Bloom, Gagné).
  2. **QA-02 Subject Matter Expert** — véracité technique (définitions, LaTeX, code).
  3. **QA-03 Alignment Orchestrator** — couverture 100% syllabus CEU/ECTS/CFA/AWS.
  4. **QA-04 Cognitive Load Guarantor** — densité (Sweller, Miller), « 1 idée = 1 bloc », ELI5.
  5. **QA-05 Rigorous Content Validator** — clarté syntaxique, broken-markdown, LaTeX malformé, calcul **PQS**.
  6. **QA-06 Academic Certifier** — Constructive Alignment (Biggs) cours ↔ examen SurveyJS.
* **PQS (Pedagogical Quality Score)** : `S_pqs = 0.2·design + 0.3·expert + 0.3·align + 0.2·cognitive`, seuil **≥ 88/100**.
* **LLM** : LlmRouter + BudgetGuard.
* **Tables** : `scy_course_qa_audits`, `scy_qa_agent_reviews`, `scy_constructive_alignment_checks`.
* **Interaction** : Harmonist (gate PQS), APEX-AGENT (réécriture si rejet), HITL-PROXY-SME (AGENT-16, collaboration expertise).

> **Rappel anti-hallucination** : Le comité fact-checke rigoureusement face aux standards mondiaux. Aucun score n'est arbitraire — chaque sous-score est justifié et tracé (`scy_qa_agent_reviews`).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Pipeline d'Audit Asynchrone (6 Rôles)

#### Scénario : Audit d'un nœud auto-généré
- **GIVEN** Un nœud de cours construit (matière brute ingérée parsée + cours généré).
- **WHEN** Le pipeline ASCENT-QA s'exécute (SAGA asynchrone après ingestion).
- **THEN** le système SHALL exécuter séquentiellement/parallèlement les 6 rôles d'audit.
- **AND** chaque agent SHALL produire un sous-score (0-100) + `critical_findings` + `remediation_prompt`.

---

### Requirement : Calcul du PQS & Seuil de Sûreté

#### Scénario : Décision de validation
- **GIVEN** Les 4 sous-scores (design, expert, align, cognitive).
- **WHEN** Le PQS est calculé.
- **THEN** le système SHALL calculer `S_pqs = 0.2·design + 0.3·expert + 0.3·align + 0.2·cognitive`.
- **AND** si `S_pqs ≥ 88` → validation + signature électronique + déblocage étude active (Parcours B).
- **AND** si `S_pqs < 88` → rejet mécanique par Harmonist + rapport renvoyé à APEX-AGENT pour réécriture ciblée.

---

### Requirement : Constructive Alignment (QA-06)

#### Scénario : Cohérence cours ↔ examen
- **GIVEN** Les Knowledge Cards + le projet d'examen SurveyJS.
- **WHEN** QA-06 audite.
- **THEN** le système SHALL vérifier que chaque question d'examen évalue un objectif explicitement couvert.
- **AND** le système SHALL vérifier que le niveau de difficulté correspond au niveau de Bloom fixé.
- **AND** au moindre écart → `aligned = false` + `remediation_required` précis.

---

### Requirement : Couverture Syllabus (QA-03)

#### Scénario : Lacune syllabus
- **GIVEN** Un référentiel d'accréditation visé (AWS, CFA, CEU).
- **WHEN** QA-03 vérifie la couverture.
- **THEN** le système SHALL identifier tout point obligatoire manquant.
- **AND** le système SHALL ordonner une recherche complémentaire via AGENT-02 (CONTENT-SCOUT).

---

### Requirement : Traçabilité & Console de Modération

#### Scénario : Audit transparent
- **GIVEN** Toute décision du comité.
- **THEN** le système SHALL consigner dans `scy_course_qa_audits` + `scy_qa_agent_reviews` + `scy_constructive_alignment_checks`.
- **AND** la console de modération administrative peut interroger ces tables.

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Débloquer un nœud (Parcours B) sans PQS ≥ 88 + signature.
* 🚫 **SHALL NOT** : Attribuer un score arbitraire (tout score justifié et tracé).
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens `design.md`.
* ⚠️ **MUST** : Tout verdict validé par Zod (`ConstructiveAlignmentSchema`).

---

## 5. Test cases & Validation
* **Test Case 1 (6 rôles)** : Le pipeline exécute les 6 audits, chacun produit sous-score + findings + remediation.
* **Test Case 2 (PQS ≥ 88)** : Validation + signature + déblocage Parcours B.
* **Test Case 3 (PQS < 88)** : Rejet Harmonist + rapport remédiation APEX-AGENT.
* **Test Case 4 (Alignment)** : Question d'examen hors cours → `aligned = false` + remediation.
* **Test Case 5 (Couverture)** : Point syllabus manquant → recherche AGENT-02 ordonnée.
* **Test Case 6 (Traçabilité)** : Décisions consignées dans les 3 tables QA.

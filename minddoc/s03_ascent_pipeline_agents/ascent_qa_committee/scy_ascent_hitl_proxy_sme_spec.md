<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🔬 SCY-AG16-HITL-PROXY-SME — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG16_HITL_PROXY_SME_SPEC  
**Décision d'architecture** : D-OPT-036 (SME HITL-Proxy Agent)  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

> **📌 RÉFÉRENCE CROISÉE** : La spécification scientifique complète de production (6 modules, 6 classes épistémologiques, verbes de Bloom, grille de scepticisme, 10 Commandements) est le document dédié **`scy_ascent_hitl_proxy_sme_specs.md`** (38KB) auquel la présente spec renvoie. Ce fichier en est le résumé comportemental aligné sur le kit SDD.

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
Cette spécification définit le comportement de l'**AGENT-16 : HITL-PROXY-SME v2.0 (L'Expert Virtuel Human-in-the-Loop)**. Pour éviter le coût et le temps de recrutement d'experts humains au lancement, cet agent **simule un auditeur humain sceptique et ultra-qualifié** dans le domaine exact de la formation ingérée (ex : *Cardiologue de la Mayo Clinic*, *Ingénieur système MIT*). Adoptant son persona de relecteur « Red Team », il critique les leçons NEURON-CHAINS, fact-checke la rigueur scientifique, et valide la cohérence constructive d'examens SurveyJS avant signature électronique (Parcours B, seuil PQS ≥ 88/100).

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Step asynchrone) + Rust (moteurs d'audit).
* **6 Modules** (cf. `scy_ascent_hitl_proxy_sme_specs.md`) :
  1. **Domain Fingerprinting** — 6 classes épistémologiques (Rust Enum) + classification auto.
  2. **Dynamic Persona Bootstrapping** — extraction signaux persona, profils experts par classe, calibration scepticisme.
  3. **Multi-Framework Pedagogical Audit** — SOLO Taxonomy, Cognitive Load (Sweller), Constructive Alignment (Biggs), Bloom's Verbs.
  4. **Red Team Scientific Audit** — protocole socratique adversarial (4 questions), détection sophismes, Steel-Manning.
  5. **Domain-Specific Validation Protocols** — Classe A (Math/Logique), C (Biomédical), D (Rust computationnel : analyse statique, Borrow Checker sim, lints Clippy, blocs unsafe).
  6. **Matrice de priorisation** de l'orchestration Module 4.
* **LLM** : LlmRouter + BudgetGuard (ton expert sceptique, modèle selon tier — Claude Opus 4.8 pour Pro/Ultra sur tâche d'audit).
* **Validation** : modèles **Zod** stricts.
* **Interaction** : collaboration avec le comité ASCENT-QA (PQS) et AGENT-09 SKILL-CERTIFIER.

> **Rappel anti-hallucination** : HITL-PROXY-SME fact-checke rigoureusement (équations LaTeX, définitions, code) face aux standards mondiaux. Il n'invente pas d'erreurs ; ses critiques sont tracées vers des sources/standards. Persona d'expert, mais outputs validés.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Classification Épistémologique & Persona

#### Scénario : Bootstrapping du persona expert
- **GIVEN** Une formation ingérée avec un domaine cible.
- **WHEN** HITL-PROXY-SME s'initialise.
- **THEN** le système SHALL classifier le domaine en l'une des 6 classes épistémologiques (Module 0).
- **AND** le système SHALL construire un persona expert complet (Module 1) avec niveau de scepticisme calibré.

---

### Requirement : Audit Pédagogique Multi-Framework

#### Scénario : Vérification cognitive et alignement
- **GIVEN** Les Knowledge Cards et exercices générés par NEURON-CHAINS.
- **WHEN** HITL-PROXY-SME audite.
- **THEN** le système SHALL appliquer l'audit SOLO + Cognitive Load + Constructive Alignment + Bloom's Verbs (Module 2).
- **AND** le système SHALL forcer « 1 idée = 1 bloc » et exiger des analogies ELI5 pour les notions abstraites.

---

### Requirement : Red Team Scientific Audit

#### Scénario : Critique adversariale
- **GIVEN** Le contenu généré.
- **WHEN** Le protocole socratique adversarial s'exécute (Module 3).
- **THEN** le système SHALL appliquer les 4 questions universelles de Red Team.
- **AND** le système SHALL détecter les sophismes pédagogiques.
- **AND** le système SHALL pratiquer l'Adversarial Steel-Manning (renforcement de l'argument avant critique).

---

### Requirement : Validation Domain-Specific (Module 4)

#### Scénario : Classe D — Computationnel Rust
- **GIVEN** Un cours contenant du code Rust généré.
- **WHEN** HITL-PROXY-SME valide (Classe D).
- **THEN** le système SHALL exécuter l'analyse statique + simulation Borrow Checker + lints Clippy + audit blocs unsafe + vérification complexités algorithmiques (Module 4 Classe D).
- **AND** le système SHALL rejeter les patterns de sécurité obsolètes.

---

### Requirement : Contribution au PQS & Signature

#### Scénario : Décision de validation Parcours B
- **GIVEN** Les résultats d'audit des modules.
- **WHEN** Le PQS est calculé (avec le comité ASCENT-QA).
- **THEN** le système SHALL contribuer au score d'expertise (`S_expert`).
- **AND** si PQS ≥ 88/100, le système SHALL autoriser la signature électronique (Parcours B).
- **AND** si PQS < 88/100, le système SHALL renvoyer un rapport de remédiation à l'APEX-AGENT pour réécriture.

---

### Requirement : Les 10 Commandements Invariants
- **GIVEN** Toute exécution de HITL-PROXY-SME.
- **THEN** le système SHALL respecter intégralement les 10 Commandements Invariants (cf. spec dédiée).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Valider un contenu sans audit Red Team complet.
* 🚫 **FORBIDDEN** : Signer (Parcours B) si PQS < 88/100.
* 🚫 **SHALL NOT** : Inventer des erreurs non fondées (toute critique tracée vers source/standard).
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens `design.md`.
* ⚠️ **MUST** : Tout verdict validé par Zod.

---

## 5. Test cases & Validation
* **Test Case 1 (Persona)** : Domaine classé + persona expert bootstrappé avec scepticisme calibré.
* **Test Case 2 (Audit multi-framework)** : Cognitive Load + Constructive Alignment vérifiés.
* **Test Case 3 (Red Team)** : 4 questions adversariales + détection sophisme + Steel-Manning.
* **Test Case 4 (Classe D Rust)** : Analyse statique + Borrow Checker sim rejettent le code non valide.
* **Test Case 5 (PQS ≥ 88)** : Signature autorisée (Parcours B).
* **Test Case 6 (PQS < 88)** : Rapport de remédiation renvoyé à APEX-AGENT.
* **Test Case 7 (10 Commandements)** : Tous respectés.

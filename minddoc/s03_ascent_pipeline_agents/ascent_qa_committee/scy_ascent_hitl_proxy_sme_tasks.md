<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-AG16-HITL-PROXY-SME — TÂCHES (TASKS)
**ID** : S03_ASCENT_AG16_HITL_PROXY_SME_TASKS · **Décision** : D-OPT-036

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

### Tâche 16.1 : Coder Module 0 — Classification épistémologique (25 min)
* **Fichier** : `backend_rs/src/ascent/hitl/domain_classifier.rs`
* **Description** : 6 classes épistémologiques (Rust Enum) + algorithme de classification auto.
* **Critère** : Domaine → classe correcte + traçabilité.

### Tâche 16.2 : Coder Module 1 — Persona Bootstrapping + scepticisme (25 min)
* **Fichier** : `backend_rs/src/ascent/hitl/persona_bootstrap.rs`
* **Description** : Extraction signaux persona + profils experts par classe + calibration scepticisme.
* **Critère** : Persona expert généré avec scepticisme calibré au domaine.

### Tâche 16.3 : Coder Module 2 — Audit pédagogique multi-framework (30 min)
* **Fichier** : `backend_rs/src/ascent/hitl/pedagogical_audit.rs`
* **Description** : SOLO Taxonomy + Cognitive Load (Sweller) + Constructive Alignment (Biggs) + Bloom's Verbs.
* **Critère** : « 1 idée = 1 bloc » vérifié ; analogies ELI5 exigées pour l'abstrait.

### Tâche 16.4 : Coder Module 3 — Red Team Scientific Audit (30 min)
* **Fichier** : `backend_rs/src/ascent/hitl/red_team_audit.rs`
* **Description** : 4 questions universelles adversariales + détection sophismes + Steel-Manning.
* **Critère** : Protocole socratique complet appliqué.

### Tâche 16.5 : Coder Module 4 Classe D — Validation Rust (30 min)
* **Fichier** : `backend_rs/src/ascent/hitl/rust_validation.rs`
* **Description** : Analyse statique + simulation Borrow Checker + lints Clippy + audit blocs unsafe + complexités + patterns obsolètes.
* **Critère** : Code Rust invalide rejeté ; patterns obsolètes détectés.

### Tâche 16.6 : Coder la matrice priorisation + contribution PQS + signature (25 min)
* **Fichier** : `backend_ts/src/ascent/agents/ag16_hitl_proxy_sme.ts`
* **Description** : Orchestration Module 4 (matrice) + contribution `S_expert` au PQS + signature si PQS ≥ 88 (Parcours B) / remédiation si < 88.
* **Critère** : PQS ≥ 88 → signature ; PQS < 88 → rapport remédiation APEX-AGENT.

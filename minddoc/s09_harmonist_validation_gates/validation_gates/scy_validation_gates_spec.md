<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Harmonist gates GARDÉES. Trust gates intégrité.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🚪 SCY-VALIDATION-GATES (HARMONIST) — SPÉCIFICATION (SPEC)
**ID** : S09_HARMONIST_VALIDATION_GATES_SPEC · **Phase** : V1 · **Réf** : PRD §9, D-OPT-032/037

> **📌 RÉFÉRENCE CROISÉE** : Les blueprints détaillés sont dans **`../scy_prd_neuro_consolidation_blueprint.md`** (34KB) et **`../scy_harmonist_integration_blueprint.md`** (7.7KB). Ce fichier en est le résumé SDD.

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
**Harmonist** est la couche de portes de validation (gates bloquantes) garantissant la sûreté pédagogique et l'intégrité du savoir avant tout déblocage de contenu ou certification. Elle orchestre la compensation SAGA en cas de rejet.

## 2. Requirements (RFC 2119)
### Gate PQS (Parcours B)
- **GIVEN** Un nœud généré soumis au comité ASCENT-QA + AGENT-16.
- **THEN** le système SHALL bloquer le déblocage si PQS < 88/100 (D-OPT-032).
- **AND** si PQS ≥ 88 → signature électronique + déblocage étude active.
- **AND** si PQS < 88 → rapport remédiation → APEX-AGENT (réécriture) via compensation SAGA.

### Dual Pathway (D-OPT-037)
- **THEN** le système SHALL appliquer le Parcours A (Assimilation, 0$ attente, zéro certificat) OU Parcours B (Accréditation, QA + ARENA + SurveyJS + Proof of Skill signé).

### Neuro-Consolidation
- **THEN** le système SHALL intégrer la consolidation neuroscientifique (sigmoïde vitalité D-OPT-009, fail-safe RIF D-OPT-010).

## 3. Tests
- TC1 : PQS < 88 → blocage + remédiation APEX-AGENT. | TC2 : PQS ≥ 88 → signature + déblocage. | TC3 : Parcours A vs B correctement séparés. | TC4 : Compensation SAGA sur rejet.

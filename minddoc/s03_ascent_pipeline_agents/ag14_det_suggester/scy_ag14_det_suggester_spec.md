<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# ⚡ SCY-AG14-DET-SUGGESTER — SPÉCIFICATION (SPEC)
**ID** : S03_AG14_DET_SUGGESTER_SPEC · **Phase** : P0 (Epic 4.1) · **Réf** : PRD epics Story 4.1, sprint SQL `why_suggested`

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
L'**AGENT-14 (Det-Suggester)** est l'**Agent Déterministe de Suggestions** de documents. À partir des métadonnées d'une source extraite (Docling), il renvoie en **moins de 5ms** exactement **3 codes de documents pertinents** (ex : G01, C01, W01) **sans aucun appel LLM externe**. Arbre de décision déterministe Rust pur ($0).

## 2. Tech Stack
* **Moteur** : Rust pur (arbre de décision déterministe, 0 LLM, < 5ms).
* **Entrées** : métadonnées Docling (codeblocks détectés, has_math, has_figures, domain, complexity, word_count).
* **Sortie** : 3 codes de documents (familles A-H) + `why_suggested` (explication).
* **Table** : `scy_project_deliverables.why_suggested` (sprint SQL ligne 121).

## 3. Requirements (RFC 2119)
- **GIVEN** Les métadonnées d'une source extraite par Docling.
- **WHEN** AGENT-14 est invoqué.
- **THEN** le système SHALL retourner en < 5ms exactement 3 codes de documents pertinents.
- **AND** le système SHALL NE PAS effectuer d'appel LLM externe ($0).
- **AND** le système SHALL fournir `why_suggested` (explication de la sélection).

## 4. Exemples de règles déterministes
- `has_code = true` + `domain = tech` → suggère G01 (Guide), C01 (Référence API), X03 (Défi pratique)
- `has_math = true` + `domain = academic` → suggère S01 (Synthèse), C03 (Glossaire), W02 (Critique)
- `word_count > 10000` → suggère S03 (Executive Brief), D01 (Mindmap), Y01 (Syllabus)

## 5. Tests
- TC1 : Métadonnées → 3 codes docs en < 5ms ($0 LLM). | TC2 : `why_suggested` fourni. | TC3 : Déterministe (même input → même output).

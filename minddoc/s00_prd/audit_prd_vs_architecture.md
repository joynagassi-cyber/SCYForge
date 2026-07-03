# audit_prd_vs_architecture.md — Rapport de cohérence PRD ↔ Architecture

> **Phase 3** — Livrable d'alignement PRD + Architecture
> **Source** : `MASTER_AGENT_PROMPT_V2.md` §4.3
> **Date** : 2026-07-03
> **Auteur** : Architecte Documentaire SCY Forge

---

## 1. Méthodologie

Comparaison systématique de tous les fichiers PRD (`minddoc/s00_prd/`) contre les documents d'architecture (`minddoc/s00_architecture_standards/`).

**Fichiers PRD analysés** :
- `scy_prd_part_1_strategy.md` (1329 lignes)
- `scy_prd_part_2_ascent_pipeline.md` (1273 lignes)
- `scy_prd_part_3_neuron_chains.md` (1166 lignes)
- `scy_prd_part_4_apex_retention.md` (1184 lignes)
- `scy_prd_part_5_cosmos_modes.md` (1197 lignes)
- `scy_prd_part_6_architecture_db.md` (1656 lignes)
- `scy_epics_and_stories.md` (780 lignes)
- `index.md`, `scy_startup_budget_checklist.md`, `scy_sprint_0_db_init.sql`

**Fichiers architecture analysés** :
- `decisions_master.md` (140 décisions)
- `patterns_master.md` (144 patterns)
- `audit_decisions.md` (120 décisions)
- `scy_architectural_blueprint_master.md`
- `scy_service_architecture_map.md`
- `project_context.md`

---

## 2. Incohérences identifiées (7 écarts)

### INC-P-01 — COSMOS modes : 26 modes PRD vs 4 modes IN_MVP

| Aspect | PRD | Architecture |
|--------|-----|-------------|
| Source PRD | `scy_prd_part_5_cosmos_modes.md` TOC §7 : "26 modes COSMOS" | `blueprint_master.md` D-010 + décisions FLY-xxx + `s04/scyforge_cosmos_v5_vizspec_catalog.md` |
| Valeur PRD | 26 modes listés (Mode 01-26) | 4 modes IN_MVP + 18 deferred + COSMOS v5 future |
| Impact | **Moyen** — Le PRD mélange les scopes (IN_MVP vs deferred vs future) |
| Recommandation | Clarifier dans PRD : 4 modes IN_MVP explicitement listés, 18 modes en veille, COSMOS v5 comme évolution future |

### INC-P-02 — ASCENT agents : 13 agents PRD vs 18 agents Architecture

| Aspect | PRD | Architecture |
|--------|-----|-------------|
| Source PRD | `scy_prd_part_1_strategy.md` §7.1, `scy_prd_part_2_ascent_pipeline.md`, `scy_epics_and_stories.md` Epic 3 : "13 agents" | `blueprint_master.md` D-010 : "18 agents (13 IN_MVP + 5 POST_MVP)" |
| Valeur PRD | 13 agents (AG-01 à AG-13) | 18 agents (AG-01 à AG-13 IN_MVP + AG-14 à AG-18 POST_MVP) |
| Impact | **Majeur** — Le PRD est obsolète sur un point architectural central (D-010) |
| Recommandation | Mettre à jour PRD : "ASCENT Plan C (18 agents — 13 IN_MVP + 5 POST_MVP)". Les 5 POST_MVP sont : AG14-LiveKit Voice, AG15-Gaming/Dual, AG16-Social Recruiting, AG17-Analytics Pipeline, AG18-Advanced Orchestration |

### INC-P-03 — STUDENT AI absent du PRD

| Aspect | PRD | Architecture |
|--------|-----|-------------|
| Source PRD | Aucune mention de STUDENT AI | `minddoc/s03_ascent_pipeline_agents/student_ai/student_ai_improvements.md` — 9 improvements (P1-P9) |
| Valeur PRD | STUDENT AI rebrandé Tactical AI uniquement dans `part_4` §4.3 | STUDENT AI = 9 improvements structurés (MSS, concept depth, pedagogical/LLM separation, metacognition, report visualization, extended FSRS, explanation profiles, presentation mode, collective intelligence) |
| Impact | **Majeur** — STUDENT AI est une feature architecturale majeure absente du PRD consolidé |
| Recommandation | Ajouter section STUDENT AI dans `scyforge_mvp_golden_master.md` avec les 7 improvements IN_MVP (P1-P7) et 2 POST_MVP (P8-P9) |

### INC-P-04 — COSMOS V5 absent du PRD

| Aspect | PRD | Architecture |
|--------|-----|-------------|
| Source PRD | `scy_prd_part_5_cosmos_modes.md` : COSMOS "4 modes cyber" (v4) | `s04/scyforge_cosmos_v5_vizspec_catalog.md` — VizSpec catalog (6 viz noyau, 8 intentions C1-C8), plugin architecture abandonnée |
| Valeur PRD | COSMOS = 4 modes cyber (Mission Tree, SMI Radar, Threat Terrain, Tactical Zoom) | COSMOS V5 = VizSpec catalog remplace le modèle plugin |
| Impact | **Moyen** — Le PRD référence l'architecture COSMOS v4 (4 modes), pas v5 (VizSpec) |
| Recommandation | Mettre à jour PRD : "COSMOS V5 (VizSpec catalog)" avec référence au fichier `s04/scyforge_cosmos_v5_vizspec_catalog.md` |

### INC-P-05 — PRD monolithique non consolidé

| Aspect | PRD | Architecture |
|--------|-----|-------------|
| Source PRD | `scy_prd_part_1_strategy.md` = 1329 lignes monolithe | Architecture : découpage par module `minddoc/sXX_module/` (< 1000 lignes par fichier) |
| Valeur PRD | 6 parties + epics = 7805 lignes dispersées | Structure standardisée : spec + plan + tasks + tests par feature |
| Impact | **Moyen** — Le PRD est difficile à naviguer et à maintenir |
| Recommandation | Consolider en `scyforge_mvp_golden_master.md` (~300-400 lignes) + `scyforge_post_mvp_roadmap.md` (~200-300 lignes) |

### INC-P-06 — LiveKit Voice absent du PRD

| Aspect | PRD | Architecture |
|--------|-----|-------------|
| Source PRD | Aucune mention de LiveKit Voice | `scy_livekit_voice_spec.md` — Voice Agent Pipeline (ARENA, BRAIN, CHRONICLE, COSMOS, DAG) — POST_MVP M36+ |
| Valeur PRD | Pas de pipeline vocal documenté | Pipeline vocal complet : LiveKit WebRTC + 2 architectures (A: OpenAI Realtime, B: STT+LLM+TTS) |
| Impact | **Mineur** — POST_MVP, mais doit être référencé dans la roadmap |
| Recommandation | Ajouter référence dans `scyforge_post_mvp_roadmap.md` |

### INC-P-07 — Pricing B2C absent du PRD

| Aspect | PRD | Architecture |
|--------|-----|-------------|
| Source PRD | `scy_prd_part_1_strategy.md` §2.5 : pricing Trial/Team/Enterprise/Industry/Government | `scyforge_pivot_architecture.md` §9.5 : B2C Consumer = POST_MVP |
| Valeur PRD | 5 tiers B2B uniquement | 5 tiers B2B + 1 tier B2C Consumer (POST_MVP) |
| Impact | **Mineur** — Le PRD ne distingue pas B2C vs B2B clairement |
| Recommandation | Clarifier dans PRD : B2C Consumer = POST_MVP (⏸️), B2B = IN_MVP (✅) |

---

## 3. Synthèse des actions correctives

| # | Incohérence | Action | Livrable cible |
|---|-------------|--------|----------------|
| INC-P-01 | COSMOS 26 modes vs 4 IN_MVP | Clarifier scope PRD | `scyforge_mvp_golden_master.md` |
| INC-P-02 | ASCENT 13 agents vs 18 | Mettre à jour PRD | `scyforge_mvp_golden_master.md` |
| INC-P-03 | STUDENT AI absent | Ajouter section STUDENT AI | `scyforge_mvp_golden_master.md` |
| INC-P-04 | COSMOS V5 absent | Ajouter référence COSMOS V5 | `scyforge_mvp_golden_master.md` |
| INC-P-05 | PRD monolithique | Créer consolidation + roadmap | `scyforge_mvp_golden_master.md` + `scyforge_post_mvp_roadmap.md` |
| INC-P-06 | LiveKit Voice absent | Ajouter référence POST_MVP | `scyforge_post_mvp_roadmap.md` |
| INC-P-07 | Pricing B2C absent | Clarifier B2C vs B2B | `scyforge_post_mvp_roadmap.md` |

---

## 4. Validation requise

Ce rapport d'écart est présenté à l'humain pour validation avant création des consolidations PRD.

**Confirmez-vous les actions correctives ?** ✅ Approve / ❌ Reject / 🔄 Modify

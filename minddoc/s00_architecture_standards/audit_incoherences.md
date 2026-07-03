# AUDIT INCOHÉRENCES — SCY Forge v2
**Date** : 2026-07-02
**Statut** : ✅ Valide pour implémentation (toutes les corrections validées par l'humain)
**Périmètre** : `minddoc/`, `docs/`, racine projet

---

## Légende

| Symbole | Signification |
|---|---|
| ✅ **Validé humain** | Correction approuvée par l'utilisateur |
| 🔴 **MAJEUR** | Impacte l'architecture, bloque le code |
| 🟡 **MOYEN** | Impacte un module, nécessite clarification |
| 🟢 **MINEUR** | Typos, nomanclature, formatage |

---

## INCOHÉRENCES MAJEURES (7)

### INC-M-01 — Nombre d'agents ASCENT : 13 vs 18
**Fichiers concernés** :
- `scy_architectural_blueprint_master.md` ligne 73 : "13 agents ASCENT généraux"
- `scy_service_architecture_map.md` ligne 49 : "ASCENT Pipeline (13 agents)"
- `scy_agentic_vision_complete.md` : **18 agents** détaillés (AG14-18 pour LiveKit, Gaming, Social, Analytics, Advanced)

**Problème** : Contradiction entre les documents d'architecture (13) et la vision agentique complète (18).

**Correction validée** :
- ✅ **Option B — 18 agents** retenue
- Réviser `AP-001` dans `scy_architectural_blueprint_master.md` pour refléter 18 agents
- Marquer `AG14-18` (LiveKit Voice, Gaming/Dual, Social Recruiting, Analytics Pipeline, Advanced Orchestration) comme **POST_MVP** dans `minddoc/s03/`
- Les agents IN_MVP restent `AG01-AG13` (Plan C)

**Action requise** :
1. Mettre à jour `AP-001` → "18 agents ASCENT (13 IN_MVP + 5 POST_MVP)"
2. Créer `minddoc/s03_ascent_pipeline_agents/ag14_ag18_postmvp/` avec un fichier README les listant comme POST_MVP
3. Mettre à jour `scy_service_architecture_map.md` ligne 49

---

### INC-M-02 — LiveKit : spécification existe mais non badgeée IN_MVP/POST_MVP
**Fichiers concernés** :
- `scy_livekit_voice_spec.md` (spécification complète, 50+ pages)
- `scy_architectural_blueprint_master.md` : LiveKit non mentionné explicitement
- `SCYFORGE_PIVOT_ARCHITECTURE.md` ligne 196 : "LiveKit (voix) — ❌ Hors MVP"

**Problème** : `scy_livekit_voice_spec.md` est une spécification complète sans badge IN_MVP/POST_MVP, ce qui crée une confusion sur son statut.

**Correction validée** :
- ✅ **Option A — ajouter bandeau POST_MVP** dans le document
- Ajouter en tête de `scy_livekit_voice_spec.md` :
  ```markdown
  <!--
  POST_MVP — Voice Agent Pipeline
  Source de vérité : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
  Statut : Hors beachhead. M36+.
  -->
  ```

**Action requise** : Ajouter le bandeau d'archivage POST_MVP en tête du fichier.

---

### INC-M-03 — Dossier `work_packages/` manquant dans `s00_architecture_standards/`
**Fichiers concernés** :
- `minddoc/s00_architecture_standards/` : pas de sous-dossier `work_packages/`
- `work_package_01_dcid_traits.md` à `work_package_14_cyber_pack.md` : à la racine de `minddoc/` ou `docs/` (position incohérente)

**Problème** : Les Work Packages WP01-WP14 sont éparpillés. La structure attendue (`minddoc/s00_architecture_standards/work_packages/`) n'existe pas.

**Correction validée** :
- ✅ **Option C — créer le dossier + déplacer**
- Créer `minddoc/s00_architecture_standards/work_packages/`
- Déplacer tous les WP01-WP14 dans ce dossier
- Mettre à jour les références croisées

**Action requise** :
1. `mkdir minddoc/s00_architecture_standards/work_packages/`
2. Déplacer tous les `WORK_PACKAGE_*.md` dans ce dossier
3. Mettre à jour les chemins dans `scy_architectural_blueprint_master.md` et `scy_service_architecture_map.md`

---

### INC-M-04 — WP03 EventBus : fragment incomplet (116 lignes)
**Fichiers concernés** :
- `work_package_03_eventbus_crate.md` : 116 lignes, seulement DLQ tests + checklist
- Manque : corps principal du WP (architecture, traits, événements, implémentation)

**Problème** : WP03 est un fragment. Impossible de coder sans le corps principal.

**Correction validée** :
- ✅ **Option B — fusionner en un seul WP03 complet**
- Le WP03 doit contenir :
  1. Vue d'ensemble EventBus (architecture, position dans la stack)
  2. Définition des traits Rust (`EventBus trait`, `Event enum`, `Subscriber trait`)
  3. Liste complète des événements (héritée de `SCYFORGE_SEQUENCE_DIAGRAMS.md`)
  4. Implémentation `scy-eventbus` crate (structure de fichiers)
  5. Tests (unit + intégration + DLQ)
  6. Checklist de validation

**Action requise** : Compléter WP03 avec le corps principal avant implémentation.

---

### INC-M-05 — Golden Master PRD + Roadmap Post-MVP manquants
**Fichiers concernés** :
- Aucun document consolidé "Golden Master" du PRD
- Aucun document "Post-MVP Roadmap" listant les features différées

**Problème** : Le PRD est dispersé dans 10+ fichiers. Impossible de savoir ce qui est IN_MVP vs POST_MVP sans naviguer entre tous les docs.

**Correction validée** :
- ✅ Créer un PRD consolidé (Golden Master) qui liste TOUTES les features avec leur statut
- ✅ Créer une Roadmap Post-MVP qui liste features différées + critères de réactivation

**Action requise** :
1. Créer `minddoc/s00_prd/GOLDEN_MASTER_PRD.md` — PRD consolidé
2. Créer `docs/POST_MVP_ROADMAP.md` — features différées avec critères de réactivation

---

### INC-M-06 — Pricing B2C non badgeé, B2B SOC seul IN_MVP
**Fichiers concernés** :
- `SCYFORGE_PIVOT_ARCHITECTURE.md` §9.5 : pricing avec tiers B2C et B2B
- Pas de distinction claire entre IN_MVP et POST_MVP dans les prix

**Problème** : Le pricing inclut des tiers B2C génériques qui ne sont pas dans le scope du beachhead cyber.

**Correction validée** :
- ✅ **Option A — Badger B2C comme POST_MVP**
- B2B SOC (MSSP/MDR + Corporate) reste IN_MVP
- B2C (consommateur individuel) → POST_MVP
- Supprimer les tiers B2C du scope MVP dans le pricing

**Action requise** :
1. Ajouter colonne "Statut" (IN_MVP/POST_MVP) au tableau pricing §9.5
2. Déplacer les tiers B2C dans `POST_MVP_ROADMAP.md`
3. Mettre à jour `SCYFORGE_PIVOT_ARCHITECTURE.md`

---

## INCOHÉRENCES ARCHITECTURALES (2)

### INC-A-04 — DCID : `ValidationGuardProvider` vs `ProofRubricProvider` — frontière floue
**Fichiers concernés** :
- `scy_architectural_blueprint_master.md` D-020 : liste 9 providers dont `ValidationGuardProvider` et `ProofRubricProvider`
- `SCYFORGE_CYBER_ONTOLOGY.md` §7 : mapping des 7 ports du contrat
- `SCYFORGE_FEATURE_REPORT.md` §12.8.1 et §12.8.2 : détaillent les deux providers

**Problème** : Les deux providers ont des zones de recouvrement (garde-fous, bornes de compétence). La frontière entre "ce qui est interdit" (ValidationGuard) et "ce qui est évalué" (ProofRubric) n'est pas clairement définie.

**Correction validée** :
- ✅ **Option A — Clarifier la frontière**
- `ValidationGuardProvider` = **garde-fous non négociables** (ce qui est INTERDIT, pas seulement mal évalué)
  - Faits ATT&CK non négociables
  - Pas de conseil offensif hors scope
  - Séparation détection/réponse (régulé)
  - Résidence/traitement des données (régulé)
- `ProofRubricProvider` = **critères d'évaluation** (ce qui est BON vs MAUVAIS, avec degrés)
  - Exactitude du verdict (VP/FP/bénin)
  - Vitesse de triage
  - Qualité de la justification
  - Respect du playbook

**Formule de distinction** :
```
ValidationGuard → Binaire (INTERDIT / AUTORISÉ)
ProofRubric → Graduel (score pondéré sur dimensions)
```

**Action requise** : Ajouter cette clarification dans D-020 et dans un nouveau WP si séparé.

### INC-A-05 — COSMOS "26 modes" vs "4 modes MVP" — cadrage incomplet
**Fichiers concernés** :
- `scy_cosmos_architecture_v4_5.md` : 26 modes, 122 décisions
- `SCYFORGE_PIVOT_ARCHITECTURE.md` §3 : "COSMOS réduit à 4 modes MVP"
- `SCYFORGE_FEATURE_REPORT.md` §15 : COSMOS v5 (VizSpec catalog, grammaire intention→viz)
- `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_A_CORE.md` : archivé (philosophie Plugin abandonnée)
- `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_B_CYBER.md` : archivé (8 intentions C1-C8 recyclées)
- `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_C_ARBORIZATION.md` : archivé (KB→KG→STB recyclé)

**Ancien problème** : Le document jazz entre "26 modes" (architecture v4.5), "4 modes MVP" (pivot architecture) et "plugin architecture" (docs A/B/C). Impossible de savoir quelle est la référence active.

**Nouvelle résolution (validée 2026-07-02)** :
- ✅ **COSMOS v5** : moteur de rendu intégré + VizSpec catalog
- L'architecture "Plugin" (Doc A/B/C) est **abandonnée** et archivée
- Le signal utile est recyclé :
  - KB→KG→STB (Doc C) → substrat de données COSMOS v5
  - 8 Use Case Intentions C1-C8 (Doc B) → Use Case Intentions du Cyber Pack
  - 6 viz noyau (Feature Report §14) → entrées `corePriority: 1` du VizSpec catalog
- Les 26 modes deviennent des **presets** du VizSpec catalog (pas des plugins)
- COSMOS v5 = `docs/scyforge_cosmos_v5_vizspec_catalog.md` (document actif)
- Les 3 docs Plugin (A/B/C) sont marqués **ARCHIVÉ — Référence historique**

**Action requise** :
1. ✅ Fait : archivage des 3 docs Plugin avec bandeau ARCHIVE
2. ✅ Fait : création de `docs/scyforge_cosmos_v5_vizspec_catalog.md`
3. Mettre à jour `minddoc/s04_scy_cosmos_visualization_engine/scy_cosmos_architecture_v4_5.md` pour référencer COSMOS v5
4. Migrer les 3 docs Plugin archivés de `docs/` vers `minddoc/archive/cosmos_plugin_infrastructure/`

---

## NOUVELLES INCOHÉRENCES AJOUTÉES (2)

### INC-M-07 — STUDENT AI : 9 améliorations non présentes dans l'architecture existante
**Fichiers concernés** :
- `docs/STUDENT_AI_IMPROVEMENT_REPORT.md` : rapport d'amélioration utilisateur (2026-07-02)
- Aucune référence dans `scy_architectural_blueprint_master.md`, `scy_service_architecture_map.md` ou les specs ASCENT

**Problème** : 9 améliorations majeures (MSS, profondeur conceptuelle, séparation pédagogique/LLM, métacognition, visualisation rapport, FSRS étendu, profils d'explication, mode présentation, intelligence collective) ne sont pas intégrées au scope architectural.

**Correction validée** :
- ✅ Créer `minddoc/s03_ascent_pipeline_agents/student_ai/student_ai_improvements.md`
- 7 améliorations IN_MVP (P1-P7), 2 POST_MVP (P8-P9)
- STUDENT AI est un **consumer du noyau ASCENT**, pas un agent séparé
- Intégré aux 5 composants ASCENT existants (Ag-05, Ag-07, Ag-09, Ag-11, COSMOS)

**Action requise** :
1. ✅ Fait : création du document STUDENT AI dans minddoc
2. Mettre à jour `scy_service_architecture_map.md` pour inclure STUDENT AI comme consumer
3. Mettre à jour `project_context.md` si nécessaire

---

## INCOHÉRENCES STRUCTURELLES (3)

### INC-S-01 — `work_packages/` absent de `s00_architecture_standards/`
**Fichiers concernés** :
- `minddoc/s00_architecture_standards/` : pas de sous-dossier `work_packages/`
- `AGENTS.md` référence : "lis `WP01_DCID_TRAITS.md` pour coder"

**Problème** : Le chemin attendu par AGENTS.md n'existe pas. Les WP sont éparpillés.

**Correction** : ✅ Même action que INC-M-03 (créer le dossier + déplacer)

### INC-S-02 — `packs/cyber/` absent du projet
**Fichiers concernés** :
- `SCYFORGE_PIVOT_ARCHITECTURE.md` référence : "tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`"
- Le dossier `packs/` n'existe pas à la racine du projet

**Problème** : Le contract DCID mentionne des packs par secteur, mais aucun pack n'existe dans le code.

**Correction** : Créer la structure `packs/cyber/` avec les sous-dossiers :
- `packs/cyber/ontology/` (MITRE ATT&CK STIX, 697/475 techniques)
- `packs/cyber/corpus/` (SigmaHQ 3136 règles, CISA IR, MITRE Emulation)
- `packs/cyber/scenarios/` (APT29 chain, 79 étapes)
- `packs/cyber/roles/` (SOC L1/L2/L3, DFIR, Detection Eng)
- `packs/cyber/rubrics/` (ProofRubric, ValidationGuard 2 profils)
- `packs/cyber/manifest.json` (pack manifest, 9 providers)

**Action requise** : Créer la structure et le manifest.

### INC-S-03 — `s99_migration_logs/` absent du projet
**Fichiers concernés** :
- Aucun dossier de migration SQL versionné
- `SCYFORGE_PIVOT_ARCHITECTURE.md` §6.2 : référence aux migrations Supabase

**Problème** : Les migrations SQL doivent être versionnées (`{timestamp}_description.up.sql` / `.down.sql`), mais aucun dossier de log n'existe.

**Correction** : Créer `minddoc/s99_migration_logs/` documentant chaque migration exécutée avec :
- Timestamp
- Description
- Fichier SQL appliqué
- Hash du fichier
- Statut (succès/échec/rollback)

---

## RÉCAPITULATIF DES CORRECTIONS

| # | Incohérence | Type | Correction validée | Priorité |
|---|---|---|---|---|
| INC-M-01 | 13 vs 18 agents | Majeure | ✅ 18 agents (AP-001 à réviser) | P0 |
| INC-M-02 | LiveKit sans badge POST_MVP | Majeure | ✅ Ajouter bandeau POST_MVP | P1 |
| INC-M-03 | work_packages/ manquant | Majeure | ✅ Créer dossier + déplacer WP01-WP14 | P0 |
| INC-M-04 | WP03 fragment incomplet | Majeure | ✅ Compléter WP03 corps principal | P0 |
| INC-M-05 | Golden Master PRD absent | Majeure | ✅ Créer PRD consolidé + Roadmap Post-MVP | P1 |
| INC-M-06 | Pricing B2C non badgeé | Majeure | ✅ B2C → POST_MVP, B2B SOC seul IN_MVP | P1 |
| INC-A-04 | DCID ValidationGuardProvider flou | Architecture | ✅ Clarifier frontière vs ProofRubric | P1 |
| INC-A-05 | COSMOS 26 modes vs 4 modes vs Plugin | Architecture | ✅ Abandon Plugin → COSMOS v5 | P0 |
| INC-M-07 | STUDENT AI 9 améliorations absentes | Majeure | ✅ Intégrer au scope (7 IN_MVP, 2 POST_MVP) | P1 |
| INC-S-01 | work_packages/ absent s00 | Structure | ✅ Même action que INC-M-03 | P0 |
| INC-S-02 | packs/cyber/ absent | Structure | ✅ Créer structure packs/ | P0 |
| INC-S-03 | s99_migration_logs/ absent | Structure | ✅ Créer dossier + conventions | P1 |

---

## ORDRE D'IMPLÉMENTATION DES CORRECTIONS

```
P0 (bloquant) :
  1. INC-M-03 / INC-S-01 : Créer work_packages/ + déplacer WP01-WP14
  2. INC-M-04 : Compléter WP03 (corps principal)
  3. INC-M-01 : Réviser AP-001 → 18 agents (13 IN_MVP + 5 POST_MVP)
  4. INC-A-05 : Archiver docs Plugin A/B/C + valider COSMOS v5
  5. INC-S-02 : Créer structure packs/cyber/

P1 (important) :
  6. INC-M-02 : Ajouter bandeau POST_MVP à LiveKit spec
  7. INC-M-05 : Créer Golden Master PRD + Post-MVP Roadmap
  8. INC-M-06 : Badger pricing B2C POST_MVP
  9. INC-A-04 : Clarifier ValidationGuardProvider vs ProofRubricProvider
  10. INC-M-07 : Mettre à jour service map avec STUDENT AI
  11. INC-S-03 : Créer s99_migration_logs/ + conventions
```

---

## FICHIERS CRÉÉS LORS DE CETTE AUDIT

| Fichier | Action | Statut |
|---|---|---|
| `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_A_CORE.md` | Archivé (bandeau ARCHIVE) | ✅ |
| `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_B_CYBER.md` | Archivé (bandeau ARCHIVE) | ✅ |
| `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_C_ARBORIZATION.md` | Archivé (bandeau ARCHIVE) | ✅ |
| `docs/scyforge_cosmos_v5_vizspec_catalog.md` | Créé (architecture active) | ✅ |
| `minddoc/s03_ascent_pipeline_agents/student_ai/student_ai_improvements.md` | Créé (9 améliorations) | ✅ |

---

*Fin du rapport. Toutes les corrections sont validées par l'humain.*
*Ce document est le référentiel d'incohérences résolues de SCY Forge.*

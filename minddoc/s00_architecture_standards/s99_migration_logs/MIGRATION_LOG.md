# migration_log.md — Journal des migrations documentaires

> **Début** : 2026-07-02
> **Phase** : Phase 2 — Unification de l'architecture
> **Règle** : Toute modification de la structure documentaire est tracée ici.

---

## Log des migrations

| Date | Action | Fichier_source | Fichier_destination | Justification |
|------|--------|---------------|---------------------|---------------|
| 2026-07-02 | Déplacé | `docs/SCYFORGE_COSMOS_V5_VIZSPEC_CATALOG.md` | `minddoc/s04_scy_cosmos_visualization_engine/scyforge_cosmos_v5_vizspec_catalog.md` | Architecture COSMOS active — doit vivre dans le module s04 |
| 2026-07-02 | Déplacé (archivé) | `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_A_CORE.md` | `minddoc/archive/cosmos_plugin_infrastructure/scyforge_cosmos_plugin_infrastructure_a_core.md` | Plugin architecture abandonnée — archivée |
| 2026-07-02 | Déplacé (archivé) | `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_B_CYBER.md` | `minddoc/archive/cosmos_plugin_infrastructure/scyforge_cosmos_plugin_infrastructure_b_cyber.md` | Plugin architecture abandonnée — archivée |
| 2026-07-02 | Déplacé (archivé) | `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_C_ARBORIZATION.md` | `minddoc/archive/cosmos_plugin_infrastructure/scyforge_cosmos_plugin_infrastructure_c_arborization.md` | Plugin architecture abandonnée — archivée |
| 2026-07-02 | Supprimé | `docs/SCYFORGE_DOMAIN_CONTRACTS_BLUEPRINT.md` | — | Doublon — signal recyclé dans D-019 (blueprint master) |
| 2026-07-02 | Supprimé | `docs/SCYFORGE_DOMAIN_PACK_CONTRACT.md` | — | Doublon — signal recyclé dans D-020 (blueprint master) |
| 2026-07-02 | Créé | — | `minddoc/archive/cosmos_plugin_infrastructure/` | Dossier d'archive pour la stack plugin COSMOS abandonnée |
| 2026-07-02 | Créé | — | `minddoc/s00_architecture_standards/s99_migration_logs/` | Dossier de logs de migration documentaire |
| 2026-07-03 | Créé | — | `minddoc/s00_architecture_standards/audit_decisions.md` | Phase 1 — Table de toutes les décisions D-xxx/AP-xxx/NC-xxx/FLY-xxx/ARC-xxx/D-OPT-xxx |
| 2026-07-03 | Créé | — | `minddoc/s00_architecture_standards/audit_features.md` | Phase 1 — Table de toutes les features MVP/Post-MVP (155+) |
| 2026-07-03 | Créé | — | `minddoc/s00_architecture_standards/audit_patterns.md` | Phase 1 — Table de tous les patterns architecturaux (144) |
| 2026-07-03 | Créé | — | `minddoc/s00_architecture_standards/decisions_master.md` | Phase 2 — Décisions unifiées consolidées sans doublons |
| 2026-07-03 | Créé | — | `minddoc/s00_architecture_standards/patterns_master.md` | Phase 2 — Patterns unifiés consolidés sans doublons |
| 2026-07-03 | Créé | — | `minddoc/s00_architecture_standards/index.md` | Phase 2.5 — Navigation centralisée (complété depuis version minimale) |
| 2026-07-03 | Renommé (42 fichiers) | `WORK_PACKAGE_*.md` + `AUDIT_*.md` + `INDEX.md` + etc. | `work_package_*.md` + `audit_*.md` + `index.md` + etc. | Convention snake_case pour tous les noms de fichiers .md |
| 2026-07-03 | Mis à jour | 187 fichiers .md | Références internes mises à jour | Toutes les références vers anciens noms majuscules remplacées par lowercase |

---

## Fichiers restants dans docs/ (catégorisés)

| Catégorie | Fichiers |
|-----------|----------|
| Opérationnels (build/déploiement) | `build_commands.md`, `code_style.md`, `dependency_manifest.md`, `implementation_order.md`, `project_structure.md` |
| Architecture visuelle | `scyforge_c4_model.md`, `scyforge_sequence_diagrams.md` |
| Spécifications cyber (IN_MVP) | `scyforge_cyber_ontology.md`, `scyforge_pivot_architecture.md`, `scyforge_cosmos_v5_vizspec_catalog.md` (depuis s04) |
| Stratégie commerciale | `scyforge_strategic_masterplan.md`, `scyforge_competitive_landscape_cyber.md`, `scyforge_monopoly_map_cyber.md`, etc. |
| Plans agents ASCENT | `scyforge_13_agents_refactor_plan_00_overview.md` .. `_06_mvp_to_multi_domain.md` |
| Infrastructure GFE | `scyforge_generative_engine_logical_model.md`, `scyforge_generative_engine_math_formalization.md`, `scyforge_generative_tree_pollination_seed.md` |

---

*migration_log.md — SCY Forge — V1.0 — 2026-07-02*

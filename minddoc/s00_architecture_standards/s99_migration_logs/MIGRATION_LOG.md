# migration_log.md — Journal des migrations documentaires

> **Début** : 2026-07-02
> **Phase** : Phase 2 — Unification de l'architecture
> **Règle** : Toute modification de la structure documentaire est tracée ici.

---

## Log des migrations

| Date | Action | Fichier_source | Fichier_destination | Justification |
|------|--------|---------------|---------------------|---------------|
| 2026-07-02 | Déplacé | `docs/scyforge_cosmos_v5_vizspec_catalog.md` | `minddoc/s04_scy_cosmos_visualization_engine/SCY_COSMOS_V5_VIZSPEC_CATALOG.md` | Architecture COSMOS active — doit vivre dans le module s04 |
| 2026-07-02 | Déplacé (archivé) | `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_A_CORE.md` | `minddoc/archive/cosmos_plugin_infrastructure/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_A_CORE.md` | Plugin architecture abandonnée — archivée |
| 2026-07-02 | Déplacé (archivé) | `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_B_CYBER.md` | `minddoc/archive/cosmos_plugin_infrastructure/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_B_CYBER.md` | Plugin architecture abandonnée — archivée |
| 2026-07-02 | Déplacé (archivé) | `docs/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_C_ARBORIZATION.md` | `minddoc/archive/cosmos_plugin_infrastructure/SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_C_ARBORIZATION.md` | Plugin architecture abandonnée — archivée |
| 2026-07-02 | Supprimé | `docs/SCYFORGE_DOMAIN_CONTRACTS_BLUEPRINT.md` | — | Doublon — signal recyclé dans D-019 (blueprint master) |
| 2026-07-02 | Supprimé | `docs/SCYFORGE_DOMAIN_PACK_CONTRACT.md` | — | Doublon — signal recyclé dans D-020 (blueprint master) |
| 2026-07-02 | Créé | — | `minddoc/archive/cosmos_plugin_infrastructure/` | Dossier d'archive pour la stack plugin COSMOS abandonnée |
| 2026-07-02 | Créé | — | `minddoc/s00_architecture_standards/s99_migration_logs/` | Dossier de logs de migration documentaire |

---

## Fichiers restants dans docs/ (catégorisés)

| Catégorie | Fichiers |
|-----------|----------|
| Opérationnels (build/déploiement) | `build_commands.md`, `code_style.md`, `DEPENDENCY_MANIFEST.md`, `implementation_order.md`, `project_structure.md` |
| Architecture visuelle | `SCYFORGE_C4_MODEL.md`, `SCYFORGE_SEQUENCE_DIAGRAMS.md` |
| Spécifications cyber (IN_MVP) | `SCYFORGE_CYBER_ONTOLOGY.md`, `SCYFORGE_PIVOT_ARCHITECTURE.md`, `scyforge_cosmos_v5_vizspec_catalog.md` (depuis s04) |
| Stratégie commerciale | `SCYFORGE_STRATEGIC_MASTERPLAN.md`, `SCYFORGE_COMPETITIVE_LANDSCAPE_CYBER.md`, `SCYFORGE_MONOPOLY_MAP_CYBER.md`, etc. |
| Plans agents ASCENT | `SCYFORGE_13_AGENTS_REFACTOR_PLAN_00_OVERVIEW.md` .. `_06_MVP_TO_MULTI_DOMAIN.md` |
| Infrastructure GFE | `SCYFORGE_GENERATIVE_ENGINE_LOGICAL_MODEL.md`, `SCYFORGE_GENERATIVE_ENGINE_MATH_FORMALIZATION.md`, `SCYFORGE_GENERATIVE_TREE_POLLINATION_SEED.md` |

---

*migration_log.md — SCY Forge — V1.0 — 2026-07-02*

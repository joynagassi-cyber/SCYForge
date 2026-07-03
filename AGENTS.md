# SCY FORGE — AGENTS.md
## Instructions permanentes pour l'agent de codage (lire en PREMIER)

> **Règle** : ce fichier est le point d'entrée. Tout commence ici.
> **Étape 1** : Lire `MASTER_AGENT_PROMPT_V2.md` (contexte charnière — 10 phases documentaires).
> **Étape 2** : Lire `minddoc/project_context.md` (contexte projet partageable).
> **Étape 3** : Lire `minddoc/s00_architecture_standards/index.md` (navigation architecture).
> **Étape 4** : Lire la phase correspondante dans `MASTER_AGENT_PROMPT_V2.md`.
> Ensuite, lis `minddoc/s00_architecture_standards/work_packages/WP01_DCID_TRAITS.md` pour coder.

> **Note** : `MASTER_AGENT_PROMPT.md` (V1) est conservé pour référence historique. La V2 est la référence active.

---

## 1. QUI TU ES (WHAT)

Tu codes **SCY Forge** (Synapse Cognitive Yield Forge), une plateforme d'apprentissage **agentique** où l'utilisateur déclare un objectif et 18 agents IA orchestrent l'ingestion, la génération, la rétention et la certification — automatiquement.

**Principe fondamental** : l'utilisateur décrit, l'agent fait tout. Zéro friction. Règle des 2 clics.

## 2. STACK (WHY)

| Couche | Technologie | Version |
|--------|-------------|---------|
| **Backend calcul** | Rust + Axum + Tokio | Edition 2021 |
| **Backend orchestration** | TypeScript + Mastra | Node 20+ |
| **Frontend** | React 18 + Vite + TailwindCSS | React 18.3 |
| **DB Cloud** | PostgreSQL 15+ (Northflank) + pgvector | — |
| **DB Desktop** | SQLite WAL (rusqlite 0.31) | — |
| **Vectoriel** | Zilliz Cloud (Serverless) / Milvus Lite | — |
| **Search sidecar** | SearxNG + Perplexica/Vane (Docker) | — |
| **LLM** | DeepSeek V4 (Free) / Claude (Premium) | — |
| **Déploiement** | Northflank (backend) + Vercel (frontend) | — |

## 3. COMMENT CODER (HOW)

### Avant de coder, lis TOUJOURS :
1. La spec de la feature : `minddoc/s0X_module/sous_feature/scy_*_spec.md`
2. Le plan : `scy_*_plan.md`
3. Les tâches : `scy_*_tasks.md`
4. Les tests : `scy_*_tests.md`
5. La cartographie des services : `minddoc/s00_architecture_standards/scy_service_architecture_map.md`

### Structure du code :
```
backend_rs/     → Rust (calculs lourds, FSRS, petgraph, RAG, NEURON-CHAINS)
backend_ts/     → TypeScript (agents ASCENT, Mastra orchestration)
frontend_react/ → React (COSMOS, APEX UI, Reader Suite, Dashboard)
```
→ Voir `docs/project_structure.md` pour l'arborescence complète.

## 4. BOUNDARIES — Ce que tu NE FAIS JAMAIS

- 🚫 **JAMAIS** : utiliser `docx-rs` (abandonné). Utilise `{ package = "docx", version = "0.4" }`.
- 🚫 **JAMAIS** : utiliser `zip-rs` (déprécié). Utilise `zip = "2.1"`.
- 🚫 **JAMAIS** : utiliser `printpdf` (obsolète). Utilise `typst` + `typst-pdf`.
- 🚫 **JAMAIS** : utiliser `sigma.js`, `cytoscape`, `react-chrono` (remplacés).
- 🚫 **JAMAIS** : inventer une API tierce non listée dans le PRD §6.1-6.2.
- 🚫 **JAMAIS** : modifier les couleurs hors des tokens `design.md`.
- 🚫 **JAMAIS** : appeler un LLM payant pour une opération marquée `$0` (Rust pur).
- 🚫 **JAMAIS** : committer des secrets (.env, tokens, clés API).
- 🚫 **JAMAIS** : modifier les fichiers du dossier `minddoc/s00_prd/` (source de vérité).
- ⚠️ **DEMANDER** : avant d'ajouter une nouvelle dépendance (crate / pnpm package).
- ⚠️ **DEMANDER** : avant de modifier le schéma BDD.

## 5. CE QUE TU FAIS TOUJOURS

- ✅ Valider tout retour JSON avec **Zod** (TypeScript) ou **serde** (Rust).
- ✅ Écrire en **français** dans les specs et commentaires.
- ✅ Tester : ≥ 80% coverage, property-based testing pour les maths (FSRS).
- ✅ Respecter l'**architecture hexagonale** (D-001) : ports/adapters, jamais de logique métier dans l'infra.
- ✅ Découpler avec l'**EventBus** : zéro appel direct inter-services.
- ✅ Suivre le **Spec-Driven Development** : spec → plan → tasks → code → tests.

## 6. COMMANDES CLÉS

→ Voir `docs/build_commands.md` pour la liste complète.

```bash
# Backend Rust
cargo build --release          # compiler
cargo test                     # tests
cargo clippy                   # lints

# Backend TS
cd backend_ts && pnpm dev       # dev server
pnpm test                       # tests

# Frontend
cd frontend_react && pnpm dev       # dev server (Vite)
pnpm build                         # build production
pnpm test                          # tests
```

## 7. ORDRE D'IMPLÉMENTATION

→ Voir `docs/implementation_order.md` pour le plan complet séquencé.

**Bottom-up** (les services avant les consommateurs) :
1. EventBus + PostgreSQL + Zilliz (fondation)
2. Ingestion Cores (source de matière)
3. NEURON-CHAINS (génération)
4. APEX/FSRS (rétention)
5. COSMOS (visualisation)
6. BRAIN (RAG + assistant)
7. Reader Suite + IMPRINT
8. ASCENT Pipeline (consommateur de tout)
9. Normal Mode + B2B

## 8. CONVENTIONS DE CODE

→ Voir `docs/code_style.md` pour les exemples complets.

- **Rust** : snake_case fonctions, PascalCase structs, error handling avec `Result<T, E>`.
- **TypeScript** : camelCase, interfaces explicites, Zod pour la validation.
- **React** : composants fonctionnels, hooks, TailwindCSS pour le style.
- **SQL** : préfixe `scy_`, UUID v7, timestamps INTEGER (Unix), RLS par user_id.

## 9. CRATES/PACKAGES OFFICIELS

→ Voir `minddoc/s00_architecture_standards/crates_standards/scy_crates_standards_spec.md` pour la liste complète.

## 10. CHARTES À RESPECTER

- **Humilité Totale** (CHRONICLE) : `minddoc/s03_ascent_pipeline_agents/ag10_chronicle/scy_chronicle_humility_charter.md`
- **Progressive Automation** : `minddoc/s00_architecture_standards/scy_progressive_automation_spec.md`
- **Design tokens** : `minddoc/s04_scy_cosmos_visualization_engine/scy_design_tokens.md`

---
project_name: SCYForge
user_name: Joy
date: 2026-06-27
status: complete
sections_completed:
  - technology_stack
  - critical_rules
  - anti_patterns
  - path_contracts
  - usage
optimized_for_llm: true
rule_count: 28
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- **Backend Rust** : edition 2021, rust-version 1.75, resolver 2, tokio, tracing, chrono, thiserror, anyhow, serde(+derive), serde_json, uuid(+v7,+serde)
- **Backend TS** : Node >=20, ESM, @mastra/core, zod 3.23+, @nangohq/node 0.40+, TypeScript 5.5, tsx 4.16+
- **Frontend** : React 18.3.1, Vite 5.3+, TailwindCSS 3.4.4, Zustand 4.5+, @nangohq/frontend 0.2+, @types/react 18.3+
- **Database / Vector** : PostgreSQL 15+, pgvector, Zilliz Cloud / Milvus Lite, SQLite WAL via rusqlite 0.31
- **Infra** : Docker sidecars (SearxNG + Perplexica/Vane), Northflank pour backend, Vercel pour frontend

---

## Critical Rules

### Paths & Artifacts

- `minddoc/s00_prd/` est **read-only** pour les agents.
- `design-artifacts/` et les tokens design sont **safe à lire** ; ne pas modifier sans validation humaine.
- NE PAS utiliser de chemins absolus Windows dans le code, les configs ou la documentation.
- Chaque règle doit être formulée comme une instruction actionnable : verbe à l’impératif ou `NE PAS …`.

### Security & Data Integrity

- Interdiction formelle de committer des secrets (`.env`, tokens, clés API).
- Erreurs Rust : utiliser `Result<T, E>` avec `thiserror` ; ne jamais renvoyer d’erreurs generiques sans contexte dans les couches métier.
- Validation JSON : **Zod** côté TS, **serde** côté Rust.
- UUID v7 : utiliser **`gen_random_uuid()`** avec **pgcrypto >= 1.6** ; ne pas utiliser `uuid_generate_v4()` par défaut.
- SQL : préfixe `scy_` systématique ; UUID v7 ; timestamps en INTEGER Unix ; activation RLS par `user_id`.

### Service Contracts & Communication

- Respecter l’**architecture hexagonale** : ports/adapters, aucune logique métier dans l’infra.
- **EventBus** est le seul canal autorisé pour la communication inter-services : zéro appel direct entre services.
- Toute intégration expose un **port métier** (interface Rust/TS) et un **adapter** ; aucun effet de bord direct entre services.

### Language & Documentation

- Français uniquement dans les **specs** et **comments** ; le **code** et les **symboles** restent en anglais.
- **Rust** : snake_case pour les fonctions, PascalCase pour les structs/enums.
- **TypeScript / React** : camelCase, interfaces explicites pour les props, ESM uniquement.
- Messages d’erreur et logs : **français** pour les messages destinés aux utilisateurs ; **anglais** pour les messages destinés aux développeurs/ops.

### Frontend & UX

- **React** : composants fonctionnels + hooks uniquement ; pas de classes.
- Style via TailwindCSS et **design tokens** uniquement — aucune couleur codée en dur hors tokens.
- State management via Zustand uniquement ; ne pas introduire Redux ou autre librairie non listée.

### Testing & Quality

- Coverage cible **≥ 80%**.
- Property-based testing **obligatoire** sur toute logique mathématique / algorithmique (ex : FSRS).
- Séparer clairement tests unitaires vs intégration ; les métriques de coverage doivent être remontées par crate/service.
- Lints : clippy strict, pedantic = warn (avec les assouplissements documentés dans Cargo.toml workspace).

### Build, CI & Workflow

- Ordre d’implémentation bottom-up : EventBus/DB/Vector → Ingestion → NEURON-CHAINS → APEX/FSRS → COSMOS → BRAIN → Reader/IMPRINT → ASCENT → Normal/B2B.
- Interdiction formelle de modifier `minddoc/s00_prd/` (source de vérité).
- TODO list / suivi de tâches recommandé pour respecter l’ordre séquentiel.
- `_bmad-output/project-context.md` vit hors versionnement git ; prévoir un hook de copie vers un fichier suivi (ex. `.ai/context.md`) pour que les agents et CI puissent le lire.

### Anti-Patterns

- NE PAS utiliser `docx-rs` (abandonné) → utiliser `docx` 0.4.
- NE PAS utiliser `zip-rs` (déprécié) → utiliser `zip` 2.1.
- NE PAS utiliser `printpdf` (obsolète) → utiliser `typst` + `typst-pdf`.
- NE PAS utiliser `sigma.js`, `cytoscape`, `react-chrono` (remplacés par d’autres implémentations).
- NE PAS inventer d’API tierce non listée dans le PRD §6.1-6.2.
- NE PAS modifier les couleurs hors des tokens `design.md`.
- NE PAS appeler un LLM payant pour une opération marquée `$0` (Rust pur).
- Ajouter une nouvelle dépendance (crate / pnpm package) uniquement après demande etvalidation.

---

## Usage Guidelines

**For AI Agents:**

- Lire ce fichier avant toute implémentation.
- Suivre TOUTES les règles exactement comme documentées.
- En cas de doute, choisir l’option la plus restrictive.
- Mettre à jour ce fichier si de nouveaux patterns ou contraintes émergent.

**For Humans:**

- Maintenir ce fichier concis et centré sur les besoins des agents.
- Mettre à jour lors d’un changement de stack ou de conventions.
- Revoir trimestriellement pour supprimer les règles devenues évidentes ou obsolètes.

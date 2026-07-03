# AUDIT STRUCTUREL — SCY Forge (révision de l'état réel du dépôt)

> **Date** : 2026-06-27
> **Évaluateur** : Agent de continuation (post-restructuration)
> **Réf commit** : `6d07170` (origin/main = local HEAD, synchro GitHub OK)
> **Objet** : Vérifier l'état réel du dépôt vs. les affirmations du résumé précédent, avant tout déplacement de fichier.

---

## 1. ÉTAT RÉEL CONFIRMÉ

### 1.1 Ce qui existe réellement (602 fichiers suivis)
| Emplacement | Contenu | Statut |
|---|---|---|
| `docs/code_style.md` | 758 lignes, « NIVEAU SENIOR », recherche 2026 | ✅ Enrichi, **canonique** |
| `docs/DEPENDENCY_MANIFEST.md` | 425 lignes + section 10 LiveKit | ✅ Complet, à jour |
| `minddoc/` | 600 fichiers specs (s00→s12 + design simulators) | ✅ Préservé |
| `minddoc/AGENTS.md` | 121 lignes | ⚠️ Au mauvais endroit (enterré) |
| `minddoc/docs/project_structure.md` | 420 lignes | ⚠️ Au mauvais endroit |
| `minddoc/docs/build_commands.md` | 182 lignes | ⚠️ Au mauvais endroit |
| `minddoc/docs/implementation_order.md` | 235 lignes | ⚠️ Au mauvais endroit + erreurs techniques |
| `minddoc/docs/code_style.md` | 376 lignes (ancienne version) | ⚠️ **Doublon obsolète** (supplanté par la 758 lignes) |

### 1.2 Ce qui n'existe PAS (contrairement au résumé)
| Élément | Affirmation du résumé | Réalité |
|---|---|---|
| `backend_rs/crates/*` (8+ crates vides) | « créés et prêts » | ❌ **JAMAIS créé** (le commit `45f7950` ne contient que des renommages) |
| `backend_ts/src/*` | « vide, prêt » | ❌ N'existe pas |
| `frontend_react/src/*` | « vide, prêt » | ❌ N'existe pas |
| `docker/` (sidecars) | « présent » | ❌ N'existe pas |
| `Cargo.toml` workspace | « à créer » | ❌ N'existe pas |
| `package.json` (TS/React) | « à créer » | ❌ N'existe pas |
| `docker-compose.yml` | « à créer » | ❌ N'existe pas |
| `.env.example` | « à créer » | ❌ N'existe pas |
| `AGENTS.md` **à la racine** | « racine » | ❌ En fait dans `minddoc/AGENTS.md` |
| `docs/project_structure.md` etc. | « docs/ » | ❌ En fait dans `minddoc/docs/` |

### 1.3 Remote Git
- `.git/config` était **absent** (remote cassé) → réparé et re-fetché.
- `origin/main` = `6d07170` = local HEAD. **Aucun commit parallèle plus récent** sur GitHub.

---

## 2. CONTRADICTION MAJEURE — Conflit de modèle structurel

Les 4 docs de codage décrivent le **Modèle A** (ancien), mais le dépôt réel suit le **Modèle B** (restructuré).

| Aspect | Modèle A (décrit par les docs) | Modèle B (réel + intention utilisateur) |
|---|---|---|
| Repo racine | `MindDoc/` | `SCYForge/` |
| Specs | à la racine (`s00_*/`, `s01_*/`…) | dans `minddoc/s00_*/` |
| Code | à la racine (`backend_rs/`, …) | (à créer) à la racine |
| `.env.example` | à la racine | à la racine |

**Preuves (références internes des docs) :**
- `minddoc/AGENTS.md` lignes 36, 56, 115, 119-121 → `s00_architecture_standards/`, `s00_prd/`, `s03_…`, `s04_…` (sans préfixe `minddoc/`)
- `minddoc/docs/project_structure.md` ligne 11 → `MindDoc/` ; lignes 18-31 → specs à la racine
- `minddoc/docs/build_commands.md` ligne 128 → `../s00_prd/scy_sprint_0_db_init.sql`

> **Intention utilisateur explicite** (instructions) : « restructuré en `SCYForge/` avec un sous-dossier `minddoc/` pour les specs ». → **Le Modèle B est voulu** ; ce sont les docs qui sont en retard, pas l'arborescence.

---

## 3. CONTRADICTIONS TECHNIQUES (docs entre eux)

### 3.1 ❌ Tantivy — interdit mais référencé
- `DEPENDENCY_MANIFEST.md` §8 + `scy_crates_standards_spec.md` : **Tantivy = À ÉVITER** (→ PostgreSQL FTS natif).
- `minddoc/docs/implementation_order.md` ligne 16 : « Test 4 : Tantivy RRF hybrid search » + ligne 113 : « BM25 Tantivy ».
- → **Le POC Sprint 0 référence une techno interdite.**

### 3.2 ❌ GLiNER ONNX — interdit mais référencé
- `DEPENDENCY_MANIFEST.md` §8 : **`ort` / GLiNER ONNX = À ÉVITER** (→ DeepSeek V4, GLiNER en fallback).
- `minddoc/docs/implementation_order.md` ligne 16 : « Test 2 : GLiNER-micro INT8 NER ».
- → **Le POC Sprint 0 référence une techno interdite.**

### 3.3 ⚠️ npm vs pnpm (mineur)
- `DEPENDENCY_MANIFEST.md` §7 : « pnpm préférable à npm pour monorepo ».
- `minddoc/AGENTS.md` lignes 80, 84 : `npm run dev` / `npm test`.
- → Cohérence à homogénéiser (pnpm).

### 3.4 ℹ️ Décompte crates (mineur)
- Résumé : « 8 crates ». `project_structure.md` liste en réalité **9** entrées sous `crates/` : 8 services transverses + `scy-shared`.

---

## 4. VERSIONS — code_style.md en double
- `docs/code_style.md` (758 lignes) = version « NIVEAU SENIOR » (commit `025183f`, « based on deep research »). Couvre workspace, thiserror+IntoResponse, proptest, tsconfig production, Zustand, lazy-load COSMOS, WCAG 2.1 AA, Conventional Commits. **→ Canonique.**
- `minddoc/docs/code_style.md` (376 lignes) = ancienne version, plus simple. **→ À supprimer (doublon obsolète).**

---

## 5. PLAN DE CORRECTION PROPOSÉ (en attente de validation)

Si **Modèle B** (garder `minddoc/`) est confirmé :

1. **Déplacer vers la racine** (avec `git mv` pour préserver l'historique) :
   - `minddoc/AGENTS.md` → `AGENTS.md`
   - `minddoc/docs/project_structure.md` → `docs/project_structure.md`
   - `minddoc/docs/build_commands.md` → `docs/build_commands.md`
   - `minddoc/docs/implementation_order.md` → `docs/implementation_order.md`
2. **Supprimer le doublon obsolète** : `minddoc/docs/code_style.md` (supplanté par `docs/code_style.md` 758 lignes).
3. **Supprimer** le dossier `minddoc/docs/` alors vide.
4. **Mettre à jour les références internes** (Modèle A → Modèle B) :
   - `AGENTS.md` : `s0X_*/` → `minddoc/s0X_*/` (lignes 36, 56, 115, 119-121)
   - `project_structure.md` : `MindDoc/` → `SCYForge/` ; specs `s0X_*/` → `minddoc/s0X_*/` (lignes 11, 18-31)
   - `build_commands.md` : `../s00_prd/` → `../minddoc/s00_prd/` (ligne 128)
5. **Corriger les contradictions techniques** dans `implementation_order.md` :
   - Test 2 GLiNER ONNX → DeepSeek V4 NER (GLiNER en fallback local)
   - Test 4 Tantivy → PostgreSQL FTS natif (GIN index) + RRF
   - Ligne 113 BM25 Tantivy → BM25 via PG FTS / pg_search
6. **Commit unique** : `fix: restore coding docs to root + align structure to minddoc/ restructure + fix forbidden-tech references`.

> **Note** : la création des dossiers de code (backend_rs, backend_ts, frontend_react, docker) et des fichiers de config (Cargo.toml, package.json, docker-compose.yml, .env.example) est **explicitement hors périmètre** de cette correction (choix utilisateur « fix_only ») — fera l'objet d'un chantier distinct après revue.

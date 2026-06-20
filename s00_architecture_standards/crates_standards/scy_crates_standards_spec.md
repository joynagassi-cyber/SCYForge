# ⚠️ SCY-CRATES-STANDARDS — SPÉCIFICATION (SPEC)
**ID** : S00_CRATES_STANDARDS_SPEC · **Phase** : MVP · **Réf** : PRD §6.1, §13.1 Risque 7

## 1. Purpose
Standards stricts sur les crates Rust utilisés. Certains crates sont **obsolètes/abandonnés** et DOIVENT être évités pour ne pas perdre du temps de debug sur du code non fonctionnel.

## 2. Crates à ÉVITER ABSOLUMENT ❌

| Crate obsolète | Remplacement officiel | Raison |
|----------------|----------------------|--------|
| ❌ `docx-rs` | ✅ `{ package = "docx", version = "0.4" }` | ABANDONNÉ 2024 |
| ❌ `zip-rs` | ✅ `zip = "2.1"` | DÉPRÉCIÉ |
| ❌ `printpdf` | ✅ `typst` + `typst-pdf` | OBSOLÈTE |
| ❌ `sigma.js` (frontend) | ✅ `@cosmograph/cosmos` + `@antv/g6` | Remplacé |
| ❌ `cytoscape` (frontend) | ✅ `@antv/g6` v5 | Remplacé |
| ❌ `react-chrono` (frontend) | ✅ Timeline custom React | -120KB bundle |

## 3. Crates Officiels Approuvés ✅ (extrait critique)
- `tokio` 1.37, `axum` 0.7, `serde` 1.0, `uuid` 1.8 (v7), `fsrs` 0.6, `petgraph` 0.6
- `reqwest` 0.12, `quick-xml` 0.36, `feed-rs` 1.x, `roux` 2.x, `epub` 2.x
- `typst` 0.11, `docx` 0.4, `zip` 2.1, `rust_xlsxwriter`, `tera` 1.x, `csv` 1.x
- `rusqlite` 0.31, `candle-core` 0.4, `lancedb` 0.4, `dashmap` 5.5

## 4. Requirements (RFC 2119)
- **THEN** le système SHALL NE JAMAIS utiliser les crates obsolètes listés ci-dessus.
- **AND** tout agent de codage SHALL vérifier la liste avant d'importer un crate.
- **AND** le Cargo.toml SHALL utiliser exactement les versions approuvées.

## 5. Tests
- TC1 : `grep -r "docx-rs\|zip-rs\|printpdf\|sigma\|cytoscape\|react-chrono" src/` → 0 résultat. | TC2 : Cargo.toml utilise uniquement les versions approuvées.

# 📦 SCY FORGE — MANIFESTE COMPLET DES DÉPENDANCES & OUTILS
**ID** : DEPENDENCY_MANIFEST_V2 · **Date** : 2026-06-26
**Règle absolue** : l'agent de codage n'invente JAMAIS une dépendance. Il utilise UNIQUEMENT celles listées ici. Toute autre dépendance doit être validée par l'équipe.

---

## 1. RUST CRATES — Backend (backend_rs/)

### 1.1 Core Runtime & Web
| Crate | Version | `Cargo.toml` | Rôle | Implémentation |
|-------|---------|-------------|------|----------------|
| `tokio` | 1.37+ | `tokio = { version = "1.37", features = ["full"] }` | Runtime async | `#[tokio::main]`, `tokio::spawn`, `tokio::select!` |
| `tokio-util` | 0.7+ | `tokio-util = "0.7"` | CancellationToken, task utilities | `CancellationToken::new()` |
| `axum` | 0.7+ | `axum = { version = "0.7", features = ["macros", "ws"] }` | HTTP + WebSocket + SSE | `Router::new().route("/", get(handler))` |
| `tower` | 0.4+ | `tower = { version = "0.4", features = ["timeout", "limit", "retry"] }` | Middleware (timeout, rate limit, retry) | `.layer(TimeoutLayer::new(...))` |
| `tower-http` | 0.5+ | `tower-http = { version = "0.5", features = ["cors", "trace", "compression-gzip", "request-id", "timeout", "auth"] }` | HTTP middleware complet | CORS, HSTS, CSP headers |
| `serde` | 1.0+ | `serde = { version = "1.0", features = ["derive"] }` | Sérialisation JSON/Binary | `#[derive(Serialize, Deserialize)]` |
| `serde_json` | 1.0+ | `serde_json = "1.0"` | JSON parsing | `serde_json::from_str::<T>(&body)?` |
| `uuid` | 1.8+ | `uuid = { version = "1.8", features = ["v7", "serde"] }` | UUID v7 time-ordered | `Uuid::now_v7()` |
| `chrono` | 0.4+ | `chrono = { version = "0.4", features = ["serde"] }` | Dates/temps | `chrono::Utc::now().timestamp()` |
| `reqwest` | 0.12+ | `reqwest = { version = "0.12", features = ["json", "stream", "rustls-tls"] }` | Client HTTP async (LLM, APIs externes) | `Client::new().get(url).send().await?` |
| `tracing` | 0.1+ | `tracing = "0.1"` | Logging structuré | `tracing::info!("User {} ingested source", id)` |
| `tracing-subscriber` | 0.3+ | `tracing-subscriber = { version = "0.3", features = ["env-filter", "json"] }` | Log output formaté | `fmt().json().with_env_filter().init()` |
| `thiserror` | 1.0+ | `thiserror = "1.0"` | Erreurs typées (library crates) | `#[derive(Error)] pub enum FsrsError { ... }` |
| `anyhow` | 1.0+ | `anyhow = "1.0"` | Erreurs applicatives (app layer) | `anyhow::Result<T>` |
| `dashmap` | 5.5+ | `dashmap = "5.5"` | HashMap concurrent thread-safe (EventBus, IdempotencyGuard) | `DashMap::new()` |
| `once_cell` | 1.19+ | `once_cell = "1.19"` | Lazy static initialization | `static CONFIG: Lazy<Config> = Lazy::new(|| ...)` |
| `governor` | 0.6+ | `governor = "0.6"` | Rate limiting (token bucket, SEC API, Twitter) | `RateLimiter::direct(Quota::per_second(nonzero!(10u32)))` |

### 1.2 IA / ML / RAG
| Crate | Version | `Cargo.toml` | Rôle | Module SCY |
|-------|---------|-------------|------|------------|
| `fsrs` | 0.6+ | `fsrs = "0.6"` | FSRS 5.0 spaced repetition (0 LLM, pur calcul) | APEX scheduler |
| `petgraph` | 0.6+ | `petgraph = "0.6"` | DAG validation (cycles, ordre topologique, CPM) | DAG-ARCHITECT, COSMOS |
| `candle-core` | 0.4+ | `candle-core = "0.4"` | ML local (LLMLingua-2 compression prompts) | NEURON-CHAINS T09 |
| `candle-transformers` | 0.4+ | `candle-transformers = "0.4"` | Modèles ML (Whisper-tiny ONNX INT8) | Ingestion audio |
| `tiktoken-rs` | 0.6+ | `tiktoken-rs = "0.6"` | Comptage tokens LLM | BudgetGuard, TokenBudgeter |
| `lancedb` | 0.4+ | `lancedb = "0.4"` | Vector DB in-process (cache sémantique, threshold 0.87) | NEURON-CHAINS T18 |

### 1.3 Rig & RRAG — Abstractions LLM/RAG Rust (D-OPT-057/058)
| Projet | Type | Installation | Rôle |
|--------|------|-------------|------|
| **Rig** | Crate Rust | `rig = "0.6"` | Unification des modèles LLM via traits composables (`CompletionModel`, `Tool`, `VectorStore`). Ultra-léger (<1.1 Go RAM). Type-safe compilation. |
| **RRAG** | Crate Rust | `rrag = "0.1"` | Moteur RAG async-first sur Tokio. Composants interchangeables (vector store, retriever, generator). Sécurise la couche RAG hybride. |

**Implémentation Rig** :
```rust
use rig::completion::{CompletionModel, Tool};
use rig::tool::ToolEmbedding;

// Chaque tool NEURON-CHAINS implémente le trait Tool de Rig
impl Tool for PromptCompressor {
    fn name(&self) -> &str { "PromptCompressor" }
    async fn call(&self, input: &str) -> Result<String, rig::Error> { ... }
}

// APEX-AGENT instancié via CompletionModel
let agent = Agent::new(model, tools, instructions);
let response = agent.prompt("Generate course for useEffect").await?;
```

### 1.4 Ingestion Cores (13 sources)
| Crate | Version | `Cargo.toml` | Rôle | Core |
|-------|---------|-------------|------|------|
| `scraper` | 0.19+ | `scraper = "0.19"` | HTML parsing (Rust natif) | c02 Web |
| `article_scraper` | 1.x | `article_scraper = "1.x"` | Extraction contenu web | c02 Web |
| `feed-rs` | 1.x | `feed-rs = "1.x"` | RSS/Atom parsing (podcasts) | c03 Podcast |
| `epub` | 2.x | `epub = "2.x"` | EPUB parsing (⚠️ PAS epub-rs) | c12 EPUB |
| `roux` | 2.x | `roux = "2.x"` | Reddit API v2 | c11 Reddit |
| `google-drive3` | 7.x | `google-drive3 = "7.x"` | Google Drive API | c05 Drive |
| `google-youtube3` | 7.x | `google-youtube3 = "7.x"` | YouTube Data API v3 | c01 YouTube |
| `yt-transcript-rs` | 0.1.8+ | `yt-transcript-rs = "0.1.8"` | Transcriptions YouTube | c01 YouTube |
| `flate2` | 1.x | `flate2 = "1.0"` | Décompression gzip (tarballs arXiv LaTeX) | c09 Science |
| `tar` | 0.4+ | `tar = "0.4"` | Extraction archives (e-print arXiv) | c09 Science |
| `quick-xml` | 0.36+ | `quick-xml = "0.36"` | XML parsing (Atom arXiv, OPF EPUB, Evernote .enex) | c08/c09/c12 |
| `calamine` | 0.24+ | `calamine = "0.24"` | Excel parsing (ingestion) | Drive/Financial |

### 1.5 PDF Stack (3 niveaux)
| Crate | Version | `Cargo.toml` | Niveau | Rôle |
|-------|---------|-------------|--------|------|
| `pdf_oxide` | 0.1+ | `pdf_oxide = "0.1"` | L1 | Markdown native extraction |
| `lopdf` | 0.32+ | `lopdf = "0.32"` | L3 | Content stream bas niveau |
| `oxidize-pdf` | 0.1+ | `oxidize-pdf = "0.1"` | L3 | Complément lopdf |

### 1.6 Export Documents (9 formats)
| Crate | Version | `Cargo.toml` | Format | ⚠️ Note |
|-------|---------|-------------|--------|---------|
| `typst` | 0.11+ | `typst = "0.11"` | PDF | ⚠️ PAS printpdf |
| `typst-pdf` | 0.11+ | `typst-pdf = "0.11"` | PDF rendering | — |
| `docx` | 0.4+ | `docx = { package = "docx", version = "0.4" }` | DOCX | ⚠️ PAS docx-rs (abandonné) |
| `zip` | 2.1+ | `zip = "2.1"` | ZIP/Anki .apkg | ⚠️ PAS zip-rs (déprécié) |
| `rust_xlsxwriter` | latest | `rust_xlsxwriter = "latest"` | Excel .xlsx | — |
| `tera` | 1.x | `tera = "1.x"` | HTML templates | — |
| `csv` | 1.x | `csv = "1.x"` | CSV (Notion, Anki) | — |

### 1.7 Intégrations Externes (11 services)
| Crate | Version | `Cargo.toml` | Service |
|-------|---------|-------------|---------|
| `notion-client` | 0.9+ | `notion-client = "0.9"` | Notion API (import/export) |
| `notify` | 6.x | `notify = "6"` | File watcher (Obsidian/Logseq vault sync) |
| `pulldown-cmark` | 0.13+ | `pulldown-cmark = "0.13"` | Markdown parser CommonMark (Obsidian/Logseq) |
| `gray_matter` | 0.2+ | `gray_matter = "0.2"` | Frontmatter YAML parsing |
| `keyring` | 2.x | `keyring = "2"` | OS keychain secrets (Desktop) |

### 1.8 Database & Observability
| Crate | Version | `Cargo.toml` | Rôle |
|-------|---------|-------------|------|
| `sqlx` | 0.7+ | `sqlx = { version = "0.7", features = ["postgres", "runtime-tokio-rustls", "uuid", "chrono", "json", "migrate"] }` | PostgreSQL async queries + migrations |
| `rusqlite` | 0.31+ | `rusqlite = { version = "0.31", features = ["bundled"] }` | SQLite Desktop (WAL mode) |
| `opentelemetry` | 0.22+ | `opentelemetry = "0.22"` | Distributed tracing |
| `opentelemetry-otlp` | 0.15+ | `opentelemetry-otlp = "0.15"` | OTLP exporter (Axiom) |

### 1.9 Architecture / CQRS
| Crate | Version | `Cargo.toml` | Rôle |
|-------|---------|-------------|------|
| `dashmap` | 5.5+ | (déjà listé) | EventBus HashMap concurrent |
| `once_cell` | 1.19+ | (déjà listé) | Lazy static registres |

---

## 2. PROJETS OPEN-SOURCE DOCKER SIDECARS

### 2.1 Composio — Plateforme d'Intégration OAuth
| Attribut | Valeur |
|----------|--------|
| **Projet** | [composio.dev](https://composio.dev) |
| **Type** | SDK TypeScript + Dashboard SaaS (gratuit tier) |
| **Installation** | `npm i composio-core` |
| **Rôle** | Handshake OAuth 2.0 pour Google Drive, Twitter, Notion, etc. Gestion/rotation automatique des jetons. Multi-comptes. |
| **Utilisation** | c05 Google Drive, intégrations Notion/Obsidian |
| **Sécurité** | Jetons chiffrés AES-256-GCM au repos |

```typescript
// backend_ts/src/infra/composio.ts
import { Composio } from 'composio-core';

const composio = new Composio({ apiKey: process.env.COMPOSIO_API_KEY });

// Initier OAuth Google Drive
const { redirectUrl } = await composio.connectedAccounts.initiate({
  userId: userId,
  integrations: { google_drive: { scopes: ['drive.readonly'] } },
});
```

### 2.2 Scrapling + CloakBrowser — Scraping Furtif
| Attribut | Valeur |
|----------|--------|
| **Projet** | [github.com/JosueSCZ/scrapling](https://github.com/JosueSCZ/scrapling) |
| **Type** | Python Docker sidecar (MIT) |
| **Image Docker** | `scy-forge/scrapling:latest` (custom build) |
| **Port** | 3003 |
| **Rôle** | Scraping web furtif : contournement Cloudflare, CAPTCHA, anti-bot. CloakBrowser = moteur d'empreinte navigateur. |
| **Utilisation** | c02 Web Article Core, c07 Twitter, c10 TikTok |

### 2.3 dom_smoothie — Readability Library
| Attribut | Valeur |
|----------|--------|
| **Projet** | [github.com/corani/dom_smoothie](https://github.com/corani/dom_smoothie) |
| **Type** | Rust crate OU npm package |
| **Installation** | `dom_smoothie = "0.1"` (Rust) OU `npm i dom_smoothie` (TS) |
| **Rôle** | Extraction du contenu principal (Readability). Purge scripts, ads, nav, cookies popups. HTML → Markdown propre. |
| **Utilisation** | c02 Web, c05 Drive (HTML exports), c07 Twitter, c08 Wikipedia |

### 2.4 Docling — Conversion Multi-Format
| Attribut | Valeur |
|----------|--------|
| **Projet** | [github.com/DS4SD/docling](https://github.com/DS4SD/docling) (IBM Research) |
| **Type** | Python Docker sidecar (MIT) |
| **Image Docker** | `docling/docling:latest` |
| **Port** | 3002 |
| **Rôle** | Conversion PDF, DOCX, PPTX, XLSX, images (OCR Tesseract/RapidOCR) → Markdown sémantique |
| **Utilisation** | c05 Google Drive, Reader Suite File Viewer |
| **Coût** | $0 infrastructure (local Docker) |

### 2.5 SearxNG — Méta-Recherche ($0 API)
| Attribut | Valeur |
|----------|--------|
| **Projet** | [searxng.org](https://searxng.org) / [github.com/searxng/searxng](https://github.com/searxng/searxng) |
| **Type** | Python Docker sidecar (AGPL-3.0) |
| **Image Docker** | `searxng/searxng:latest` |
| **Port** | 8080 (interne) |
| **Rôle** | Méta-recherche agrégeant 244 moteurs (Google, Bing, DuckDuckGo, Wolfram Alpha, YouTube, Reddit, Scholar...). Zéro API payante. |
| **Config** | `settings.yml` : `formats: [html, json]` + `engines: wolfram_alpha: enabled: true` |
| **Utilisation** | c02 Web Search Engine V2, BRAIN live web search |

### 2.6 Perplexica / Vane — Moteur de Réponse IA
| Attribut | Valeur |
|----------|--------|
| **Projet** | [github.com/ItzCrazyKns/Vane](https://github.com/ItzCrazyKns/Vane) (ex-Perplexica) |
| **Type** | Next.js Docker sidecar (MIT) |
| **Image Docker** | `itzcrazykns1337/vane:slim-latest` |
| **Port** | 3001 |
| **Rôle** | Classification de questions, query rewriting, embeddings reranking, citations sourcées. 6 Focus Modes. |
| **Utilisation** | c02 Web Search Engine V2, BRAIN live web search |
| **Config** | `SEARXNG_API_URL=http://searxng:8080`, LLM via `OPENAI_BASE_URL` (DeepSeek) ou Ollama local |

### 2.7 Harmonist — Framework de Validation Gates
| Attribut | Valeur |
|----------|--------|
| **Projet** | [github.com/GammaLab-Technologies/Harmonist](https://github.com/GammaLab-Technologies/Harmonist) (PyShine) |
| **Type** | Framework TypeScript (MIT) |
| **Installation** | `npm i harmonist` |
| **Rôle** | Portes de validation hook-driven (gates bloquantes). Intercepte les transactions, valide via hooks Zod, bloque ou autorise. PQS ≥ 88. |
| **Utilisation** | s09 Harmonist (validation pédagogique, gate PQS, Parcours A/B) |

```typescript
import { Gate, Hook } from 'harmonist';

const pqsGate = new Gate({
  name: 'pqs-validation',
  hooks: [validatePQSScore, checkConstructiveAlignment],
  threshold: 88,
  onBlock: (report) => apexAgent.rewrite(report),
});
```

### 2.8 Graphiti / Zep — Graphe de Connaissance Temporel
| Attribut | Valeur |
|----------|--------|
| **Projet** | [github.com/getzep/graphiti](https://github.com/getzep/graphiti) |
| **Type** | Python service (Apache 2.0) ou Zep Cloud |
| **Rôle** | Graphe de connaissance temporel pour BRAIN RAG. 2-hop neighborhood + PageRank. Consolidation chronologique des conversations. |
| **Utilisation** | BRAIN Triple Retrieval (Retriever 3 : Graph Traversal) |

### 2.9 GLiNER — NER Local (Named Entity Recognition)
| Attribut | Valeur |
|----------|--------|
| **Projet** | [github.com/urchade/GLiNER](https://github.com/urchade/GLiNER) |
| **Type** | Modèle ONNX INT8 (12MB) via `ort` 1.16 |
| **Rôle** | Extraction d'entités nommées (concepts clés) en local, $0/mois |
| **Utilisation** | File Viewer sidebar (concepts clés), NEURON-CHAINS BETA-1 taxonomiste |

> ⚠️ **Note PRD §6.1** : `# ort et GLiNER ONNX supprimés au profit d'appels API ultra-cheap DeepSeek V4 (0.0001$/1K)`. GLiNER reste documenté comme fallback local si DeepSeek indisponible.

---

## 3. SERVICES AUDIO IA

### 3.1 OpenAI Whisper — Transcription Audio
| Attribut | Valeur |
|----------|--------|
| **Projet** | OpenAI Whisper API |
| **Coût** | $0.006/min audio |
| **Rôle** | Transcription audio → texte temporel |
| **Utilisation** | c03 Podcast, c10 TikTok, B10 Audio cards, Proof of Skill Teach-Back vidéo |
| **Alternative locale** | Whisper-tiny ONNX INT8 (Candle, $0) — c01 YouTube fallback, c03 Podcast |

### 3.2 pyannote/segmentation-3.0 — Diarization
| Attribut | Valeur |
|----------|--------|
| **Projet** | [github.com/pyannote/audio](https://github.com/pyannote/audio) |
| **Type** | Python Docker sidecar (MIT, poids open-source) |
| **Rôle** | Identification et étiquetage des locuteurs (Speaker 1, Speaker 2...) |
| **Utilisation** | c03 Podcast (diarization), c06 Financial (earnings calls Q&A) |

### 3.3 OpenAI TTS — Text-to-Speech
| Attribut | Valeur |
|----------|--------|
| **Coût** | $0.015/1K characters (tts-1) ou $0.030/1K (tts-1-hd) |
| **Rôle** | Génération audio pour cartes B10, lecture TTS étendue B01-B05 |
| **Utilisation** | APEX session (touche R), CHRONICLE chat vocal, cartes audio |

---

## 4. PACKAGES NPM — Frontend (frontend_react/)

### 4.1 Core
| Package | Version | `npm i` | Rôle |
|---------|---------|---------|------|
| `react` | 18.3+ | `react@18.3` | Framework UI |
| `react-dom` | 18.3+ | `react-dom@18.3` | DOM renderer |
| `typescript` | 5.4+ | `-D typescript@5.4` | Language (strict mode) |
| `vite` | 5.2+ | `-D vite@5.2` | Build tool / dev server |
| `tailwindcss` | 3.4+ | `-D tailwindcss@3.4` | Styling utility-first |
| `zustand` | 4.5+ | `zustand@4.5` | State management global |
| `react-router-dom` | 6.22+ | `react-router-dom@6.22` | Routing |

### 4.2 COSMOS Visualization (26 modes + 12 engines)
| Package | Version | Modes | Rôle |
|---------|---------|-------|------|
| `@cosmograph/cosmos` | 3.x | M0, M22 | GPU WebGL2 (1M+ nœuds @ 60 FPS) |
| `@antv/g6` | 5.x | M2, M3, M9, M18 | Node-link interactif (ForceAtlas2) |
| `@antv/g2` | 5.x | M10, M11 | Statistiques hiérarchiques (Sunburst, Treemap) |
| `@xyflow/react` | 12.x | M4, M8, M17, M25 | DAGs / flow graphs interactifs |
| `recharts` | 2.x | M7, M14 | Charts SVG (Statistics, Radar SMI) |
| `nivo` | 0.87.x | M12, M13, M16, M19 | Dataviz déclarative (Chord, Sankey, Heatmap, Circle Packing) |
| `d3` | 7.x | M15, M20, M21, M24 | Visualisations custom bas niveau |
| `three` | latest | M23 | 3D Knowledge Space (optionnel Phase 3) |
| `graphology` | 0.25.x | (data) | Source de vérité du graphe (sérialisation JSON) |
| `graphology-communities-louvain` | 2.x | (data) | Clustering Louvain |
| `graphology-metrics` | 2.x | (data) | PageRank, centralité |
| `graphology-layout-forceatlas2` | 0.10.x | (data) | Layout force-directed |
| `@duckdb/duckdb-wasm` | latest | M7 | Analytics in-memory (D-013, DuckDB) |

### 4.3 Reader Suite & Rendu Technique
| Package | Version | Rôle |
|---------|---------|------|
| `@react-pdf-viewer/core` | 3.x | PDF viewer (PDF.js) |
| `pdfjs-dist` | 4.x | PDF rendering engine |
| `epubjs` | 0.3.x | EPUB reader |
| `mammoth` | 1.x | DOCX → HTML conversion |
| `react-markdown` | 9.x | Markdown renderer (GFM) |
| `rehype-highlight` | 7.x | Code highlighting dans Markdown |
| `remark-gfm` | 4.x | GitHub Flavored Markdown |
| `katex` | 0.16.x | LaTeX math rendering |
| `react-katex` | 3.x | React wrapper KaTeX |
| `mermaid` | latest | Diagrammes (Vue Diagramme des Multi-View Toggles) |
| `shiki` | latest | Coloration syntaxique haute-fidélité (thèmes dark/light) |
| `dompurify` | latest | HTML sanitizer (anti-XSS, iframe sandbox) |

### 4.4 UI & Interaction
| Package | Version | Rôle |
|---------|---------|------|
| `@tanstack/react-table` | 8.x | Table virtualisée (M5 Concepts Grid) |
| `@tanstack/react-virtual` | 3.x | Virtual scrolling (listes > 50 items) |
| `react-spring` | 9.x | Physics animations (M6 Timeline, COSMOS transitions) |
| `react-window` | 1.x | Virtual list (M1 Lexical Tags) |
| `@hello-pangea/dnd` | latest | Drag & drop accessible (Kanban Board DAG) |
| `framer-motion` | latest | Animations transitions (cartes Kanban, COSMOS) |
| `elkjs` | latest | Solveur auto-layout asynchrone (DAG, Knowledge Cards M25, Argument Map M17) |
| `reveal.js` | latest | Slides / PPTX viewer |
| `react-data-grid` | latest | CSV/Excel viewer interactif |

### 4.5 Examen & Certification
| Package | Version | Rôle |
|---------|---------|------|
| `survey-react-ui` | latest | SurveyJS exam runner (rendu React) |
| `survey-core` | latest | SurveyJS core engine |
| `survey-creator-react` | latest | SurveyJS form builder (admin) |
| `survey-creator-core` | latest | SurveyJS creator core |

### 4.6 Packages RETIRÉS ❌
| Package | Raison | Remplacement |
|---------|--------|-------------|
| ❌ `sigma.js` | Remplacé | ✅ `@cosmograph/cosmos` + `@antv/g6` |
| ❌ `cytoscape` / `react-cytoscapejs` | Remplacé | ✅ `@antv/g6` v5 |
| ❌ `react-chrono` | -120KB bundle | ✅ Timeline custom React + `react-spring` |

---

## 5. PACKAGES NPM — Backend TS (backend_ts/)

| Package | Version | Rôle |
|---------|---------|------|
| `@mastra/core` | latest | Agent orchestration (Workflow, Step, EventBus) |
| `zod` | latest | Schema validation (OBLIGATOIRE sur tout retour LLM/API) |
| `@northflank/sdk` | latest | Northflank deployment API |
| `composio-core` | latest | OAuth integrations (Google Drive, Twitter, Notion) |
| `harmonist` | latest | Validation gates framework (hook-driven) |
| `ace-builds` | latest | Code editor (Multi-View Toggles playground) |
| `opfs-worker` | latest | OPFS storage (D-DATA-005, BroadcastChannel sync) |
| `livekit-server-sdk` | latest | Token generation (server-side JWT, LiveKit room access) |

---

## 6. INFRASTRUCTURE CLOUD

| Service | Plan | Coût Phase 0-1 | Rôle |
|---------|------|-----------------|------|
| **Northflank** | Free tier | $0/mois | Backend Rust + PostgreSQL 15 + pgvector + Storage |
| **Vercel** | Free tier | $0/mois | Frontend React (CDN 180+ locations, ISR) |
| **Zilliz Cloud** | Serverless free | $0/mois | Vector DB (Milvus, embeddings 512D) |
| **Sentry** | Free tier | $0/mois | Error tracking (<5K events/mois) |
| **Axiom** | Free tier | $0/mois | Logs OpenTelemetry (<100GB/mois) |
| **Langfuse** | Self-hosted | $0/mois | LLM observabilité (tokens, latence, coût) |
| **Composio** | Free tier | $0/mois | OAuth management (Google Drive, etc.) |
| **LiveKit Cloud** | Free tier | $0/mois | WebRTC vocal (50 participants, 10K min/mois) | (Google Drive, etc.) |

### Phase 3 (scaling)
| Service | Coût estimé | Rôle |
|---------|-------------|------|
| Redis (Northflank) | ~$15/mois | Cache (Phase 3, remplace SQLite cache) |
| Storage additionnel | ~$10-15/mois | Audio MP3, exports PDF |
| **Total Phase 3** | **~$26-33/mois** | — |

---

## 7. OUTILS DE DÉVELOPPEMENT

| Outil | Version | Installation | Rôle |
|-------|---------|---------------|------|
| **Rust** | 1.75+ | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` | Compilateur Rust (edition 2021) |
| **Node.js** | 20+ | `nvm install 20` | Runtime TypeScript |
| **pnpm** | latest | `npm i -g pnpm` | Package manager (préférable à npm pour monorepo) |
| **Docker** | latest | [docker.com](https://docker.com) | Containers (sidecars) |
| **sqlx-cli** | 0.7+ | `cargo install sqlx-cli --no-default-features --features rustls,postgres` | Migrations DB |
| **cargo-audit** | latest | `cargo install cargo-audit` | Audit vulnérabilités crates |
| **cargo-watch** | latest | `cargo install cargo-watch` | Hot reload Rust dev (`cargo watch -x run`) |
| **wasm-pack** | latest | `cargo install wasm-pack` | Packaging Rust → WASM (D-OPT-001/060) |
| **wasm-bindgen** | latest | `cargo add wasm-bindgen` | Bindings Rust ↔ JS (WASM) |

---

## 8. CRATES À ÉVITER ABSOLUMENT ❌

| Crate | Statut | Raison | ✅ Remplacement |
|-------|--------|--------|----------------|
| ❌ `docx-rs` | ABANDONNÉ 2024 | Plus maintenu, bugs | ✅ `{ package = "docx", version = "0.4" }` |
| ❌ `zip-rs` | DÉPRÉCIÉ | Renommé | ✅ `zip = "2.1"` |
| ❌ `printpdf` | OBSOLÈTE | Limité, lent | ✅ `typst` + `typst-pdf` |
| ❌ `sigma.js` (npm) | Remplacé | Performance insuffisante | ✅ `@cosmograph/cosmos` + `@antv/g6` |
| ❌ `cytoscape` (npm) | Remplacé | API datée | ✅ `@antv/g6` v5 |
| ❌ `react-chrono` (npm) | Trop lourd | -120KB bundle | ✅ Timeline custom React + `react-spring` |
| ❌ `tantivy` | Supprimé PRD §6.1 | Remplacé par PG FTS | ✅ PostgreSQL Full-Text Search natif (GIN index) |
| ❌ `ort` + `GLiNER ONNX` | Supprimé PRD §6.1 | Remplacé par DeepSeek V4 | ✅ DeepSeek V4 ($0.0001/1K) — GLiNER en fallback local |

---

## 9. RÉCAPITULATIF PAR MODULE SCY

| Module SCY | Crates Rust | Packages NPM | Sidecars Docker |
|------------|-------------|--------------|-----------------|
| **s01 Ingestion** | scraper, article_scraper, feed-rs, epub, roux, google-drive3, google-youtube3, yt-transcript-rs, flate2, tar, quick-xml, calamine, reqwest | — | Scrapling, Docling, SearxNG, Perplexica |
| **s02 NEURON-CHAINS** | rig, rrag, candle-core, candle-transformers, tiktoken-rs, lancedb, fsrs (shared) | @mastra/core, zod | — |
| **s03 ASCENT** | petgraph, dashmap, governor | @mastra/core, zod, composio-core, harmonist, @livekit/components-react, livekit-client | LiveKit Server, Voice Agent Worker |
| **s04 COSMOS** | — | @antv/g6, @cosmograph/cosmos, @antv/g2, @xyflow/react, recharts, nivo, d3, three, graphology+plugins, @duckdb/duckdb-wasm, elkjs | — |
| **s05 APEX** | fsrs, tiktoken-rs | survey-react-ui, survey-core | — |
| **s06 BRAIN** | candle-core, lancedb, reqwest | @livekit/components-react, livekit-client | Graphiti/Zep, SearxNG, Perplexica, LiveKit (voice cascade) |
| **s07 IMPRINT** | — | — | — |
| **s08 Reader Suite** | — | @react-pdf-viewer/core, pdfjs-dist, epubjs, mammoth, react-markdown, katex, mermaid, shiki, dompurify | Docling |
| **s09 Harmonist** | — | harmonist, zod | — |
| **s10 Normal Mode** | — | @mastra/core | (shared) |
| **s11 Neuro Engine** | — | — | — |
| **s12 B2B** | — | survey-react-ui, @northflank/sdk | — |
| **Export 9 formats** | typst, typst-pdf, docx, zip, rust_xlsxwriter, tera, csv | — | — |
| **Intégrations** | notion-client, notify, pulldown-cmark, gray_matter, keyring | composio-core | — |

---

## 10. LIVEKIT — SYSTÈME VOCAL TEMPS RÉEL (WebRTC)

> **Spéc complète** : `minddoc/s00_architecture_standards/scy_livekit_voice_spec.md`

### 10.1 Packages NPM — Frontend (frontend_react/)
| Package | Version | `pnpm add` | Rôle |
|---------|---------|-----------|------|
| `@livekit/components-react` | latest | `@livekit/components-react` | Composants : LiveKitRoom, BarVisualizer, RoomAudioRenderer, useVoiceAssistant |
| `livekit-client` | latest | `livekit-client` | Client WebRTC (audio tracks, connexion room) |

### 10.2 Packages Python — Voice Agent Worker
| Package | Version | `pip install` | Rôle |
|---------|---------|-------------|------|
| `livekit-agents` | ~=1.5 | `"livekit-agents~=1.5"` | Framework agents vocaux (AgentSession, Agent, cli.run_app) |
| `livekit-plugins-openai` | ~=1.5 | `"livekit-plugins-openai~=1.5"` | OpenAI Realtime API (speech-in/speech-out, Architecture A) |
| `livekit-plugins-silero` | ~=1.5 | `"livekit-plugins-silero~=1.5"` | Silero VAD local ($0, CPU, Voice Activity Detection) |
| `livekit-plugins-assemblyai` | ~=1.5 | `"livekit-plugins-assemblyai~=1.5"` | AssemblyAI STT (Speech-to-Text, Architecture B BRAIN) |
| `livekit-plugins-cartesia` | ~=1.5 | `"livekit-plugins-cartesia~=1.5"` | Cartesia Sonic-3 TTS (Text-to-Speech basse latence ~100ms) |
| `livekit-plugins-noise-cancellation` | ~=0.2 | `"livekit-plugins-noise-cancellation~=0.2"` | BVC echo cancellation (Krisp, anti-feedback-loop) |
| `livekit-plugins-turn-detector` | ~=1.5 | `"livekit-plugins-turn-detector~=1.5"` | Multilingual Turn Detector (ONNX CPU, fin de tour multilingue) |

### 10.3 Service Docker
| Service | Image | Ports | Rôle |
|---------|-------|-------|------|
| **LiveKit Server** | `livekit/livekit-server:latest` | 7880 TCP / 7881 TCP TLS / 7882 UDP | WebRTC SFU + TURN/STUN + room management |
| **Voice Agent Worker** | Custom Python Dockerfile | — | Worker exécutant ARENA/BRAIN/CHRONICLE voice agents |
| **LiveKit Cloud** (alternative) | SaaS | — | Gratuit 50 participants simultanés + 10K min/mois |

### 10.4 Services Vocaux Tiers (par minute)
| Service | Coût | Architecture | Agents |
|---------|------|-------------|--------|
| **OpenAI Realtime API** | ~$0.06/min | A (speech-in/speech-out) | ARENA, CHRONICLE |
| **AssemblyAI STT** | ~$0.012/min | B (cascade STT) | BRAIN, COSMOS, DAG |
| **Cartesia Sonic-3 TTS** | ~$0.005/1K chars | B (cascade TTS) | BRAIN, COSMOS, DAG |
| **Silero VAD** | $0 (open-source ONNX) | A+B (local CPU) | Tous |
| **LiveKit Turn Detector** | $0 (open-source ONNX CPU) | B | BRAIN, COSMOS, DAG |

### 10.5 Matrice d'Utilisation par Agent
| Agent | Archi | Modèle LLM | STT | TTS | VAD | Turn Detection | Interruptions |
|-------|-------|-----------|-----|-----|-----|----------------|---------------|
| **ARENA** | A (Realtime) | GPT-4o Realtime | intégré | intégré | Silero | Server VAD | ✅ (l'utilisateur coupe) |
| **BRAIN** | B (Cascade) | DeepSeek V4 + RAG | AssemblyAI | Cartesia | Silero | Multilingual ONNX | ✅ (adaptive) |
| **CHRONICLE** | A (Realtime court) | GPT-4o Realtime | intégré | intégré | Silero | Server VAD patient | ❌ (pas couper CHRONICLE) |
| **COSMOS** | B (Cascade) | DeepSeek V4 | AssemblyAI | Cartesia | Silero | Multilingual ONNX | ✅ (adaptive) |
| **DAG** | B (Cascade) | DeepSeek V4 | AssemblyAI | Cartesia | Silero | Multilingual ONNX | ✅ (adaptive) |

# SCY FORGE — CODE STYLE (NIVEAU SENIOR)
## Conventions, Patterns & Anti-Patterns issus de la recherche 2026

---

## 1. RUST — Conventions de Niveau Senior

### 1.1 Nommage
| Élément | Convention | Exemple |
|---------|-----------|---------|
| Structs / Enums | `PascalCase` | `UserAutomationPrefs`, `AutomationLevel` |
| Fonctions / Méthodes | `snake_case` | `calculate_smi`, `detect_drift_signals` |
| Constantes | `SCREAMING_SNAKE_CASE` | `MAX_CONCURRENT_INGESTIONS`, `SOFTENING_EPSILON` |
| Modules / fichiers | `snake_case` | `fsrs_engine.rs`, `dead_letter_queue.rs` |
| Crates (workspace) | `scy-kebab-case` | `scy-apex-fsrs`, `scy-neuron-chains` |
| Types génériques | `PascalCase` simple | `T`, `K`, `V`, `Error` |

### 1.2 Workspace Architecture (recherche : flat > nested)

```toml
# Cargo.toml (workspace root — backend_rs/Cargo.toml)
[workspace]
resolver = "2"
members = [
    "crates/scy-shared",
    "crates/scy-eventbus",
    "crates/scy-ingestion",
    "crates/scy-neuron-chains",
    "crates/scy-apex-fsrs",
    "crates/scy-cosmos-kg",
    "crates/scy-brain-rag",
    "crates/scy-imprint",
    "crates/scy-reader",
    ".",  # L'app elle-même (src/main.rs)
]

# Versions partagées centralisées (Rust 1.64+)
[workspace.dependencies]
tokio = { version = "1.37", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
axum = "0.7"
sqlx = { version = "0.7", features = ["postgres", "runtime-tokio-rustls", "uuid", "chrono", "json"] }
uuid = { version = "1.8", features = ["v7", "serde"] }
reqwest = { version = "0.12", features = ["json"] }
tracing = "0.1"
thiserror = "1.0"
anyhow = "1.0"
dashmap = "5.5"

# Métadonnées globales
[workspace.package]
version = "0.1.0"
edition = "2021"
license = "MIT"
authors = ["SCY Forge Team"]

# Optimisation production
[profile.release]
lto = true              # Link-Time Optimization (meilleur binaire)
codegen-units = 1       # Optimisation maximale (plus lent à compiler)
opt-level = 3
panic = "abort"          # Réduit la taille du binaire (pas de unwind)
strip = true             # Strip les symboles de debug
```

Dans chaque crate membre :
```toml
# crates/scy-apex-fsrs/Cargo.toml
[package]
name = "scy-apex-fsrs"
version.workspace = true
edition.workspace = true

[dependencies]
# Hériter du workspace
tokio.workspace = true
serde.workspace = true
serde_json.workspace = true
uuid.workspace = true
thiserror.workspace = true

# Spécifique au crate
fsrs = "0.6"
proptest = "1.4"
```

### 1.3 lib.rs — API Publique Cuvée

```rust
// crates/scy-apex-fsrs/src/lib.rs

// ✅ Re-exporter seulement ce qui est nécessaire (API publique cuvée)
pub mod scheduler;
pub mod cards;
pub mod smi;

// Re-exporter les types couramment utilisés
pub use scheduler::{FsrsState, CardState, recalculate};
pub use smi::calculate_smi;
pub use cards::CardType;

// Types d'erreurs publics
pub use crate::error::{FsrsError, Result};

// ❌ NE PAS tout re-exporter aveuglément
// mod internal_stuff; // privé, pas accessible de l'extérieur
```

### 1.4 Error Handling — Pattern thiserror + IntoResponse

```rust
// crates/scy-shared/src/errors.rs
use axum::{
    http::StatusCode,
    response::{IntoResponse, Response},
    Json,
};
use serde_json::json;
use thiserror::Error;

/// Erreur applicative unifiée SCY Forge
#[derive(Error, Debug)]
pub enum AppError {
    #[error("Resource not found: {0}")]
    NotFound(String),

    #[error("Unauthorized: {0}")]
    Unauthorized(String),

    #[error("Validation error: {0}")]
    Validation(String),

    #[error("Database error: {0}")]
    Database(#[from] sqlx::Error),

    #[error("LLM error: {0}")]
    Llm(String),

    #[error("Budget exceeded: spent ${spent:.4} of ${budget:.4}")]
    BudgetExceeded { spent: f64, budget: f64 },

    #[error("Hallucination detected: assertion similarity {0:.2} < threshold 0.60")]
    HallucinationRisk(f64),

    #[error("FSRS invariant violated: {0}")]
    FsrsInvariant(String),

    #[error("Internal error: {0}")]
    Internal(#[from] anyhow::Error),
}

/// Conversion automatique vers réponse HTTP Axum
impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let (status, error_code, message) = match &self {
            AppError::NotFound(msg) => (
                StatusCode::NOT_FOUND,
                "NOT_FOUND",
                msg.clone(),
            ),
            AppError::Unauthorized(msg) => (
                StatusCode::UNAUTHORIZED,
                "UNAUTHORIZED",
                msg.clone(),
            ),
            AppError::Validation(msg) => (
                StatusCode::UNPROCESSABLE_ENTITY,
                "VALIDATION_ERROR",
                msg.clone(),
            ),
            AppError::Database(e) => {
                tracing::error!(error = ?e, "Database error");
                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    "DATABASE_ERROR",
                    "Internal server error".to_string(),
                )
            }
            AppError::BudgetExceeded { spent, budget } => (
                StatusCode::PAYMENT_REQUIRED,
                "BUDGET_EXCEEDED",
                format!("Budget exceeded: ${spent:.4}/${budget:.4}"),
            ),
            AppError::HallucinationRisk(score) => (
                StatusCode::UNPROCESSABLE_ENTITY,
                "HALLUCINATION_RISK",
                format!("Assertion similarity {score:.2} below threshold"),
            ),
            _ => {
                tracing::error!(error = %self, "Internal error");
                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    "INTERNAL_ERROR",
                    "Internal server error".to_string(),
                )
            }
        };

        // Structured JSON error response
        (
            status,
            Json(json!({
                "error": {
                    "code": error_code,
                    "message": message,
                }
            })),
        )
            .into_response()
    }
}

/// Type alias pour toute la codebase
pub type Result<T> = std::result::Result<T, AppError>;
```

### 1.5 Async / Tokio — Patterns Production

#### Règle d'or : NE JAMAIS bloquer le runtime async

```rust
// ❌ MAUVAIS : bloque le thread worker
async fn bad_example() {
    std::thread::sleep(Duration::from_secs(1)); // Bloque !
    let data = std::fs::read("file.txt").unwrap(); // Bloque !
}

// ✅ BON : async-native
async fn good_example() {
    tokio::time::sleep(Duration::from_secs(1)).await; // Cède au runtime
    let data = tokio::fs::read("file.txt").await.unwrap(); // Async I/O
}

// ✅ CPU-intensive : utiliser spawn_blocking
async fn heavy_computation() -> Result<Vec<f64>> {
    tokio::task::spawn_blocking(|| {
        // Tourne sur un thread pool séparé, ne bloque pas les workers async
        expensive_ml_inference()
    })
    .await
    .map_err(|e| AppError::Internal(e.into()))?
}
```

#### Structured Concurrency : JoinSet + CancellationToken (D-OPT-059)

```rust
use tokio::task::JoinSet;
use tokio_util::sync::CancellationToken;

/// Exécute des chaînes NEURON-CHAINS en parallèle avec annulation SAGA
pub async fn run_parallel_neuron_chains(
    tasks: Vec<AgentTask>,
    payload: Arc<serde_json::Value>,
) -> Result<Vec<serde_json::Value>> {
    let cancel_token = CancellationToken::new();
    let mut join_set = JoinSet::new();

    for task in tasks {
        let token = cancel_token.clone();
        let task_payload = Arc::clone(&payload);

        join_set.spawn(async move {
            tokio::select! {
                // Écoute active de l'annulation (SAGA fallback)
                _ = token.cancelled() => {
                    Err(format!("Task {} cancelled (SAGA)", task.id))
                }
                // Exécution normale
                result = execute_agent_chain(task, task_payload) => {
                    result
                }
            }
        });
    }

    let mut results = Vec::new();

    while let Some(res) = join_set.join_next().await {
        match res {
            Ok(Ok(payload)) => results.push(payload),
            _ => {
                // ÉCHEC d'une branche → annuler TOUTES les autres immédiatement
                cancel_token.cancel();
                tracing::error!("Neuron-Chain branch failed, aborting all parallel tasks");
                return Err(AppError::Internal(
                    anyhow::anyhow!("Parallel chain failed, SAGA abort triggered")
                ));
            }
        }
    }

    Ok(results)
}
```

#### Partage d'état : tokio::sync::Mutex (pas std::sync::Mutex)

```rust
use std::sync::Arc;
use tokio::sync::RwLock; // ✅ RwLock pour read-heavy
// use tokio::sync::Mutex; // ✅ Mutex pour write-heavy
// ❌ JAMAIS std::sync::Mutex dans du code async (deadlock sur .await)

// ✅ Pattern AppState (Axum)
#[derive(Clone)]
pub struct AppState {
    pub db: PgPool,
    pub event_bus: Arc<EventBus>,
    pub llm_router: Arc<LlmRouter>,
    pub config: Arc<Config>,
}

// ✅ Shared state RwLock (read-heavy : config, feature flags)
type SharedConfig = Arc<RwLock<Config>>;

async fn get_setting(config: SharedConfig, key: &str) -> Option<String> {
    let config = config.read().await; // Pas de blocage du thread
    config.get(key).cloned()
}
```

#### Timeouts obligatoires sur tout appel externe

```rust
use tokio::time::{timeout, Duration};

// ✅ TOUJOURS wrapper les appels externes avec un timeout
async fn llm_call_with_timeout(prompt: &str) -> Result<String> {
    timeout(
        Duration::from_secs(5), // L1 : 5s max par appel LLM
        llm_router.complete(prompt),
    )
    .await
    .map_err(|_| AppError::Llm("LLM timeout after 5s".into()))?
    .map_err(|e| AppError::Llm(e.to_string()))
}

// ✅ Circuit Breaker (ARC-001) par provider LLM
async fn llm_with_circuit_breaker(
    cb: &CircuitBreaker,
    provider: &str,
    prompt: &str,
) -> Result<String> {
    match cb.state() {
        CircuitState::Open => {
            tracing::warn!(provider, "Circuit OPEN, fast-fail");
            return Err(AppError::Llm(format!("Circuit open for {provider}")));
        }
        CircuitState::HalfOpen if cb.active_probes() >= 1 => {
            return Err(AppError::Llm("Half-open probe limit".into()));
        }
        _ => {}
    }

    match timeout(Duration::from_secs(5), llm_call(prompt)).await {
        Ok(Ok(result)) => {
            cb.on_success();
            Ok(result)
        }
        Ok(Err(e)) => {
            cb.on_failure();
            Err(e)
        }
        Err(_) => {
            cb.on_failure();
            Err(AppError::Llm("Timeout".into()))
        }
    }
}
```

### 1.6 Property-Based Testing (proptest) — Invariants Mathématiques

```rust
use proptest::prelude::*;

proptest! {
    /// FSRS ne produit JAMAIS une stability négative (invariant absolu)
    #[test]
    fn fsrs_never_negative_stability(
        stability in 0.1f64..10000.0,
        difficulty in 1.0f64..10.0,
        rating in 1u8..=4u8,
        elapsed in 0.0f64..365.0,
    ) {
        let state = FsrsState { stability, difficulty, state: CardState::Review };
        let result = recalculate(&state, rating, elapsed);
        prop_assert!(result.is_ok(), "recalculate should succeed");
        let new = result.unwrap();
        prop_assert!(new.stability > 0.0, "stability must be positive, got {}", new.stability);
    }

    /// Le graphe DAG ne contient JAMAIS de cycle (invariant structurel)
    #[test]
    fn dag_topological_sort_respects_edges(
        edges in prop::collection::vec(
            (1u32..50, 1u32..50).prop_map(|(a, b)| if a == b { (a, a + 1) } else { (a, b) }),
            0..100,
        ),
    ) {
        let mut graph = petgraph::Graph::<u32, ()>::new();
        let nodes: Vec<_> = (0..50).map(|i| graph.add_node(i)).collect();
        for (a, b) in &edges {
            if *a < 50 && *b < 50 && *a != *b {
                graph.add_edge(nodes[*a as usize], nodes[*b as usize], ());
            }
        }
        if let Ok(order) = petgraph::algo::toposort(&graph, None) {
            // Vérifier que l'ordre topologique respecte toutes les arêtes
            // (pour toute arête u→v, u apparaît avant v dans l'ordre)
            // ... verification logic
        }
    }
}
```

---

## 2. TYPESCRIPT — Conventions Strict Mode

### 2.1 tsconfig.json — Configuration Production

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",

    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,

    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,

    "paths": {
      "@/*": ["./src/*"],
      "@agents/*": ["./src/ascent/agents/*"],
      "@schemas/*": ["./src/ascent/schemas/*"]
    }
  }
}
```

### 2.2 Règles Strict TypeScript

```typescript
// ❌ JAMAIS utiliser `any`
function processData(data: any) { ... } // BANNI

// ✅ Utiliser `unknown` + type guards
function processData(data: unknown): string {
  if (typeof data === 'object' && data !== null && 'value' in data) {
    const typed = data as { value: unknown };
    if (typeof typed.value === 'string') {
      return typed.value.toUpperCase();
    }
  }
  throw new Error('Invalid data format');
}

// ✅ Discriminated unions pour les états
type AsyncState<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: string };

// ✅ satisfies operator (TS 4.9+) pour validation + inférence littérale
const agentConfig = {
  name: 'goal-interpreter',
  model: 'deepseek-v4',
  timeout: 5000,
} satisfies AgentConfig;
// agentConfig.model est typé comme 'deepseek-v4' (littéral), pas string
```

### 2.3 Zod Validation — Pattern Obligatoire

```typescript
import { z } from 'zod';

// ✅ Schéma Zod = source de vérité (le type est inféré)
const GoalSchema = z.object({
  domain: z.string().min(1, 'Domain requis'),
  subSkills: z.array(z.string()).min(1, 'Au moins 1 sous-compétence'),
  levelTarget: z.enum(['beginner', 'intermediate', 'advanced', 'expert']),
  constraints: z.object({
    durationWeeks: z.number().positive(),
    weeklyHours: z.number().positive(),
  }),
  criteria: z.array(z.object({
    type: z.enum(['smi_threshold', 'proof_of_skill', 'exercise_score']),
    target: z.number(),
    description: z.string(),
  })).min(1),
});

type Goal = z.infer<typeof GoalSchema>; // Type inféré automatiquement

// ✅ Validation des retours LLM (OBLIGATOIRE)
async function interpretGoal(rawInput: string): Promise<Goal> {
  const response = await llmRouter.complete({
    model: 'deepseek-v4',
    system: GOAL_SYSTEM_PROMPT,
    user: rawInput,
  });

  // safeParse pour gérer gracieusement (pas d'exception)
  const result = GoalSchema.safeParse(JSON.parse(response.content));

  if (!result.success) {
    // Retry avec correction
    const fixed = await llmRouter.complete({
      system: GOAL_FIX_PROMPT,
      user: `Invalid: ${JSON.stringify(result.error.issues)}`,
    });
    return GoalSchema.parse(JSON.parse(fixed.content)); // parse lance si invalide
  }

  return result.data; // ✅ Type-safe, validé
}
```

---

## 3. REACT — Conventions Niveau Senior

### 3.1 Organisation par Feature (pas par type)

```
src/
├── components/ui/         # Composants génériques réutilisables (Button, Card)
├── cosmos/                ← Feature: COSMOS (tout COSMOS ensemble)
│   ├── modes/             # 26 composants de mode
│   ├── engines/           # Lazy-loaders
│   ├── lenses/            # 4 lentilles sémantiques
│   ├── CosmosAgentAPI.ts  # API pour agents
│   └── index.ts           # API publique (re-exports)
├── apex/                  ← Feature: APEX (sessions, cartes, stats)
├── dag/                   ← Feature: DAG display (Kanban/Tree/Gantt)
├── stores/                # Zustand stores
└── hooks/                 # Hooks custom
```

### 3.2 Zustand Store Pattern

```typescript
// stores/useProjectGraphStore.ts
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';

interface ProjectGraphState {
  graph: GraphologyGraph | null;
  smiColors: Record<string, string>;
  selectedNode: string | null;

  // Actions
  setGraph: (graph: GraphologyGraph) => void;
  selectNode: (nodeId: string | null) => void;
  updateNodeSmi: (nodeId: string, smi: number) => void;
}

export const useProjectGraphStore = create<ProjectGraphState>()(
  devtools(
    persist(
      (set) => ({
        graph: null,
        smiColors: {},
        selectedNode: null,

        setGraph: (graph) => set({ graph }),
        selectNode: (nodeId) => set({ selectedNode: nodeId }),
        updateNodeSmi: (nodeId, smi) =>
          set((state) => ({
            smiColors: {
              ...state.smiColors,
              [nodeId]: smiToColor(smi),
            },
          })),
      }),
      { name: 'scy-cosmos-graph' } // localStorage persistence
    )
  )
);

// Usage dans un composant
function CosmosGraph() {
  // ✅ Sélecteur fin (re-render minimal)
  const graph = useProjectGraphStore((s) => s.graph);
  const selectNode = useProjectGraphStore((s) => s.selectNode);

  // ❌ NE PAS faire ça (re-render à chaque changement du store)
  // const store = useProjectGraphStore();
}
```

### 3.3 Lazy Loading COSMOS Engines

```typescript
// cosmos/engines/g6_loader.ts
let g6Module: typeof import('@antv/g6') | null = null;

export async function loadG6() {
  if (!g6Module) {
    // Dynamic import : le bundle G6 (~280KB) n'est chargé qu'à la première utilisation
    g6Module = await import('@antv/g6');
  }
  return g6Module;
}

// cosmos/engines/index.ts — Registry
export async function loadEngine(mode: CosmosMode) {
  switch (mode) {
    case 0: case 22: return loadCosmograph();  // ~700KB
    case 2: case 3: case 9: case 18: return loadG6();  // ~280KB
    case 10: case 11: return loadG2();  // ~180KB
    case 4: case 8: case 17: case 25: return loadReactFlow();  // ~180KB
    case 7: case 14: return loadRecharts();  // ~150KB
    case 12: case 13: case 16: case 19: return loadNivo();  // ~120KB
    case 15: case 20: case 21: case 24: return loadD3();  // ~80KB
    case 23: return loadThree();  // ~450KB (optionnel)
    case 5: return loadTanStack();  // ~60KB
    default: return loadG6();  // défaut
  }
}
```

### 3.4 TailwindCSS — Tokens Design Uniquement

```tsx
// tailwind.config.ts
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        // Tokens officiels design.md — JAMAIS de couleurs hors palette
        'ink-black': '#020205',       // Noir d'encre (fond)
        'violet-deep': '#1E1B4B',     // Violet profond
        'electric-blue': '#2563EB',   // Bleu électrique actif
        'emerald': '#10B981',          // Émeraude consolidée
        'imperial-gold': '#D97706',    // Or impérial (expert)
      },
      fontFamily: {
        sans: ['Inter Variable', 'system-ui', 'sans-serif'],
        cjk: ['Noto Sans SC', 'Noto Sans JP', 'Noto Sans KR'],
      },
    },
  },
};

// ✅ BON : tokens uniquement
<div className="bg-ink-black text-electric-blue border-emerald" />

// ❌ MAUVAIS : couleurs arbitraires
<div className="bg-red-500 text-blue-300" />
```

### 3.5 Accessibility (WCAG 2.1 AA)

```tsx
// ✅ Sémantique HTML, pas de div soup
<button
  onClick={handleStart}
  aria-label="Démarrer la session de révision"
  aria-busy={isLoading}
  className="..."
>
  {isLoading ? 'Chargement...' : 'Démarrer'}
</button>

// ✅ Contraste ≥ 4.5:1 (vérifier avec les tokens)
// ✅ Keyboard navigation 100%
// ✅ Focus visible (ring 2px)
<input
  className="focus:ring-2 focus:ring-electric-blue focus:outline-none"
  aria-describedby="email-error"
/>
```

---

## 4. SQL — Conventions

```sql
-- ✅ TOUJOURS :
-- 1. Préfixe scy_
-- 2. UUID v7 (DEFAULT gen_uuid_v7())
-- 3. Timestamps INTEGER (Unix epoch, PAS DATETIME)
-- 4. RLS (Row Level Security) sur toute table avec user_id
-- 5. Soft delete (deleted_at INTEGER NULL)
-- 6. Index sur les colonnes fréquemment filtrées

CREATE TABLE scy_example (
    id          UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id     UUID NOT NULL REFERENCES scy_users(id),

    -- Données
    name        TEXT NOT NULL CHECK (length(name) > 0),
    metadata    JSONB DEFAULT '{}',

    -- Timestamps Unix (PAS DATETIME !)
    created_at  INTEGER NOT NULL DEFAULT extract(epoch from now())::INTEGER,
    updated_at  INTEGER NOT NULL DEFAULT extract(epoch from now())::INTEGER,
    deleted_at  INTEGER NULL
);

-- Index partiel (WHERE deleted_at IS NULL = performances)
CREATE index idx_example_user
    ON scy_example(user_id, created_at DESC)
    WHERE deleted_at IS NULL;

-- RLS obligatoire
ALTER TABLE scy_example ENABLE ROW LEVEL SECURITY;
CREATE POLICY example_isolation ON scy_example
    USING (user_id = current_setting('app.current_user_id')::uuid);

-- ✅ Parameterized queries UNIQUEMENT (anti SQL injection)
-- sqlx::query("SELECT * FROM scy_example WHERE user_id = $1 AND id = $2")
--     .bind(user_id).bind(example_id)
```

---

## 5. CONVENTIONS GIT

### 5.1 Conventional Commits

```
feat: add FSRS scheduler recalculation (S05 scheduler_fsrs)
fix: prevent negative stability in FSRS when rating=Again
docs: update dependency manifest with Composio and Scrapling
refactor: migrate EventBus to use tokio::sync::broadcast
test: add property-based test for DAG cycle detection
chore: bump tokio to 1.37
```

### 5.2 Branches

```
main              ← Production-ready
feat/s05-fsrs     ← Feature branch
fix/ag03-cycle    ← Bugfix branch
docs/manifest     ← Documentation
```

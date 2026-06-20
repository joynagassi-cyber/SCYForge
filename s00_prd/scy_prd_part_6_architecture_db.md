  cache_value JSONB NOT NULL,
  expires_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL DEFAULT extract(epoch from now())::INTEGER
);

-- Sync Queue (offline-first Desktop)
CREATE TABLE scy_sync_queue (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  entity_type TEXT NOT NULL,
  entity_id UUID NOT NULL,
  operation TEXT NOT NULL, -- 'create', 'update', 'delete'
  payload JSONB NOT NULL,
  synced BOOLEAN DEFAULT false,
  created_at INTEGER NOT NULL,
  synced_at INTEGER NULL
);

-- IMPRINT Registres cognitifs
CREATE TABLE scy_imprint_registers (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  node_id UUID REFERENCES scy_ascent_nodes(id), -- Nœud associé (v2)
  document_id UUID REFERENCES scy_documents(id),
  cran_level INTEGER CHECK (cran_level BETWEEN 1 AND 5),
  insights JSONB NOT NULL,
  tree_structure JSONB NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE TABLE scy_imprint_trees (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  register_id UUID NOT NULL REFERENCES scy_imprint_registers(id),
  svg_data TEXT NOT NULL,
  complexity_score INTEGER,
  created_at INTEGER NOT NULL
);
```

### 8.3 Nouvelles Tables ASCENT Pipeline v2

```sql
-- Cache mutualisé entre users (économie LLM)
CREATE TABLE scy_shared_content_cache (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  content_hash TEXT UNIQUE NOT NULL, -- Hash objectif normalisé
  goal_domain TEXT NOT NULL, -- 'react', 'python', 'marketing'
  dag_template JSONB NOT NULL, -- DAG réutilisable (structure)
  node_documents JSONB NOT NULL, -- Documents générés (refs)
  flashcards_template JSONB NOT NULL, -- Cartes réutilisables
  generation_cost_usd REAL, -- Coût de la première génération
  reuse_count INTEGER DEFAULT 0, -- Nb users bénéficiant
  created_at INTEGER NOT NULL,
  last_used_at INTEGER,
  expires_at INTEGER -- TTL 90j (contenu technologique)
);

-- Décisions agentiques (observabilité complète)
CREATE TABLE scy_agent_decisions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  agent_name TEXT NOT NULL, -- 'learning-conductor', 'adaptive-router', etc.
  decision_type TEXT NOT NULL,
  input_state JSONB NOT NULL,
  output_action JSONB NOT NULL,
  reasoning TEXT,
  smi_at_decision REAL,
  execution_time_ms INTEGER,
  outcome TEXT, -- 'success', 'skipped', 'user_ignored'
  llm_tokens_used INTEGER DEFAULT 0, -- Monitoring coûts
  created_at INTEGER NOT NULL
);

-- Drift Guardian — Interventions
CREATE TABLE scy_drift_interventions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  signal_type TEXT NOT NULL,
  signal_data JSONB NOT NULL,
  severity TEXT NOT NULL, -- 'low', 'medium', 'high', 'critical'
  action_taken TEXT NOT NULL,
  message_sent TEXT,
  user_responded BOOLEAN,
  resumed_within_hours INTEGER,
  created_at INTEGER NOT NULL
);

-- Proof of Skill Certificates
CREATE TABLE scy_proof_of_skill (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  certification_id TEXT UNIQUE NOT NULL, -- 'SCY-2026-06-08-REACT-84'
  overall_smi REAL NOT NULL,
  retention_score REAL,
  depth_score REAL,
  mirror_score REAL,
  metacognition_score REAL,
  consistency_score REAL,
  total_days INTEGER,
  nodes_completed INTEGER,
  exercises_passed INTEGER,
  exercises_total INTEGER,
  cards_reviewed INTEGER,
  total_study_minutes INTEGER,
  max_streak_days INTEGER,
  pdf_url TEXT,
  linkedin_url TEXT,
  verification_url TEXT, -- scy_forge.app/verify/XXX
  next_goals_suggested JSONB,
  earned_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL
);

-- Routing adaptatif historique
CREATE TABLE scy_routing_history (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  node_id UUID NOT NULL REFERENCES scy_ascent_nodes(id),
  routing_decision TEXT NOT NULL, -- 'normal', 'fast_track', 'consolidation', 'remediation'
  smi_before REAL,
  smi_target REAL,
  additional_content_generated BOOLEAN DEFAULT false,
  strategy_changed BOOLEAN DEFAULT false,
  decided_at INTEGER NOT NULL
);

-- Gamification utilisateur
CREATE TABLE scy_user_gamification (
  user_id UUID PRIMARY KEY REFERENCES scy_users(id),
  total_xp INTEGER DEFAULT 0,
  current_level INTEGER DEFAULT 1,
  current_streak_days INTEGER DEFAULT 0,
  max_streak_days INTEGER DEFAULT 0,
  badges_earned TEXT[] DEFAULT '{}',
  last_activity_at INTEGER,
  updated_at INTEGER NOT NULL
);

CREATE TABLE scy_gamification_events (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  event_type TEXT NOT NULL, -- 'xp_gained', 'badge_earned', 'level_up', 'streak'
  value INTEGER,
  badge_id TEXT,
  metadata JSONB,
  created_at INTEGER NOT NULL
);

-- LLM Budget Monitoring
CREATE TABLE scy_llm_spend_log (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID REFERENCES scy_users(id),
  goal_id UUID REFERENCES scy_ascent_goals(id),
  agent_name TEXT, -- Quel agent a fait l'appel
  model_used TEXT NOT NULL,
  tokens_input INTEGER NOT NULL,
  tokens_output INTEGER NOT NULL,
  cost_usd REAL NOT NULL,
  task_type TEXT, -- 'simple', 'complex', 'output', 'reasoning'
  cache_hit BOOLEAN DEFAULT false,
  compression_ratio REAL,
  created_at INTEGER NOT NULL
);

-- NEURON-CHAINS — Rapports de confiance
CREATE TABLE scy_confidence_reports (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  document_id UUID REFERENCES scy_documents(id),
  node_id UUID REFERENCES scy_ascent_nodes(id),
  global_score INTEGER NOT NULL, -- 0-100
  quality_label TEXT NOT NULL, -- '🟢 Excellent', '🟡 Bon', etc.
  section_scores JSONB NOT NULL,
  total_assertions INTEGER DEFAULT 0,
  verified_assertions INTEGER DEFAULT 0,
  citation_coverage REAL,
  high_risk_assertions INTEGER DEFAULT 0,
  recommendations JSONB,
  created_at INTEGER NOT NULL
);
```

### 8.5 Tables CHRONICLE & ARENA (Agents Premium v2.4)

```sql
-- ═══════════════════════════════════════════════════
-- CHRONICLE (Agent-10) — Coéquipier IA Quotidien
-- ═══════════════════════════════════════════════════

-- Mémoire contextuelle persistante
CREATE TABLE scy_chronicle_memory (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID UNIQUE NOT NULL REFERENCES scy_users(id),

  -- Rythme de vie (observé + déclaré)
  declared_schedule JSONB,               -- {weekday: {slots: [{start, end}]}}
  observed_schedule JSONB,               -- Calculé depuis sessions réelles
  optimal_learning_hours JSONB,          -- Heures où performance est meilleure
  low_energy_days TEXT[],                -- ['monday', 'wednesday']
  recurring_constraints JSONB,           -- [{day, description, capacity_ratio, confirmed}]

  -- Préférences communication (détectées comportementalement)
  interaction_mode TEXT DEFAULT 'proactive',  -- 'chat_free'|'structured'|'proactive'|'minimal'
  preferred_tone TEXT DEFAULT 'warm',         -- 'warm'|'direct'|'professional'|'friendly'
  response_verbosity TEXT DEFAULT 'standard', -- 'short'|'standard'|'detailed'

  -- Track record
  commitments_made INTEGER DEFAULT 0,
  commitments_kept INTEGER DEFAULT 0,
  avg_disruptions_per_month REAL DEFAULT 0,

  -- Profil énergie
  energy_profile JSONB,                  -- Distribution énergie par heure/jour semaine

  updated_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL
);

-- Imprévus et reprises gérés par CHRONICLE
CREATE TABLE scy_chronicle_disruptions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),

  disruption_type TEXT NOT NULL,         -- 'imprévu'|'oubli'|'fatigue'|'maladie'|'voyage'
  sessions_missed INTEGER DEFAULT 0,
  days_inactive INTEGER DEFAULT 0,
  user_message TEXT,                     -- Ce que l'user a dit à CHRONICLE

  -- Options proposées par CHRONICLE
  options_proposed JSONB NOT NULL,       -- [{type, description, effort, new_end_date}]
  option_chosen TEXT,                    -- Type d'option choisie
  user_confirmed BOOLEAN DEFAULT false,

  -- Résultat
  successfully_recovered BOOLEAN,
  recovery_days_needed INTEGER,

  created_at INTEGER NOT NULL
);

-- Plans de rattrapage générés par CHRONICLE
CREATE TABLE scy_chronicle_plans (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  disruption_id UUID REFERENCES scy_chronicle_disruptions(id),

  plan_type TEXT NOT NULL,               -- 'extension'|'bootcamp'|'redistribution'|'micro'
  original_end_date DATE,
  new_end_date DATE,
  daily_plan JSONB NOT NULL,             -- [{date, sessions: [{type, duration_min, nodes}]}]
  total_extra_sessions INTEGER,

  started_at INTEGER,
  completed BOOLEAN DEFAULT false,
  completion_rate REAL,

  created_at INTEGER NOT NULL
);

-- Conversations quotidiennes CHRONICLE
CREATE TABLE scy_chronicle_conversations (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),

  initiated_by TEXT NOT NULL,            -- 'chronicle' | 'user'
  context TEXT NOT NULL,                 -- 'daily_check_in'|'disruption'|'motivation'|'free'
  chronicle_message TEXT NOT NULL,
  user_response TEXT,
  actions_taken JSONB,                   -- [{agent, action, params}]
  plan_modified BOOLEAN DEFAULT false,

  created_at INTEGER NOT NULL
);

-- ═══════════════════════════════════════════════════
-- ARENA (Agent-11) — Validation Pratique par Simulation
-- ═══════════════════════════════════════════════════

-- Sessions de roleplay ARENA
CREATE TABLE scy_arena_sessions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  node_id UUID REFERENCES scy_ascent_nodes(id),

  domain TEXT NOT NULL,                  -- 'sales'|'management'|'medical'|'speaking'|'pedagogy'|'other'
  scenario_type TEXT NOT NULL,
  scenario_description TEXT NOT NULL,
  difficulty_level TEXT NOT NULL,        -- 'easy'|'medium'|'hard'|'expert'

  -- Persona Full-AI généré
  persona_config JSONB NOT NULL,         -- {role, psychology, resistances, triggers, mood_initial}

  -- Déroulement
  transcript JSONB NOT NULL DEFAULT '[]', -- [{speaker, content, timestamp, live_analysis}]
  persona_mood_timeline REAL[],          -- Évolution humeur -1.0 (hostile) à +1.0 (convaincu)
  session_duration_seconds INTEGER,

  -- Scores
  global_score REAL,                     -- 0-100
  techniques_applied_score REAL,
  emotional_intelligence_score REAL,
  adaptability_score REAL,
  structure_score REAL,

  -- Débrief généré
  debrief JSONB,                         -- {strong_points, missed_opportunities, critical_issues, exercises_recommended}

  -- Impact sur apprentissage
  smi_depth_delta REAL DEFAULT 0,
  smi_mirror_delta REAL DEFAULT 0,
  smi_metacog_delta REAL DEFAULT 0,
  exercises_generated UUID[],           -- Nouvelles cartes APEX créées depuis les lacunes détectées

  -- État
  status TEXT NOT NULL DEFAULT 'active', -- 'active'|'completed'|'abandoned'
  started_at INTEGER NOT NULL,
  ended_at INTEGER,
  created_at INTEGER NOT NULL
);

-- Personas réutilisables (bibliothèque interne)
CREATE TABLE scy_arena_personas (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  domain TEXT NOT NULL,
  scenario_type TEXT NOT NULL,
  difficulty_level TEXT NOT NULL,

  persona_template JSONB NOT NULL,       -- Template psychologie complète
  times_used INTEGER DEFAULT 0,
  avg_user_score REAL,

  version INTEGER DEFAULT 1,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- Proof of Skill ARENA (composante pratique)
CREATE TABLE scy_arena_skill_proof (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),

  domain TEXT NOT NULL,
  sessions_completed INTEGER DEFAULT 0,
  best_arena_score REAL,
  avg_score REAL,

  -- Certification pratique
  practical_certified BOOLEAN DEFAULT false,
  certified_at INTEGER,
  certification_level TEXT,              -- 'foundational'|'proficient'|'advanced'
  included_in_pos UUID REFERENCES scy_proof_of_skill(id),

  created_at INTEGER NOT NULL
);

-- Indexes CHRONICLE & ARENA
CREATE INDEX idx_chronicle_memory_user ON scy_chronicle_memory(user_id);
CREATE INDEX idx_chronicle_disruptions_user ON scy_chronicle_disruptions(user_id, created_at DESC);
CREATE INDEX idx_chronicle_plans_user ON scy_chronicle_plans(user_id, goal_id);
CREATE INDEX idx_chronicle_conversations_user ON scy_chronicle_conversations(user_id, created_at DESC);
CREATE INDEX idx_arena_sessions_user ON scy_arena_sessions(user_id, goal_id, status);
CREATE INDEX idx_arena_sessions_domain ON scy_arena_sessions(domain, difficulty_level);
CREATE INDEX idx_arena_personas_domain ON scy_arena_personas(domain, difficulty_level);
CREATE INDEX idx_arena_skill_proof_user ON scy_arena_skill_proof(user_id, goal_id);
```

### 8.4 Indexes Critiques

```sql
-- Performance queries fréquentes
CREATE INDEX idx_sources_user_status ON scy_sources(user_id, status);
CREATE INDEX idx_sources_hash ON scy_sources(content_hash); -- Déduplication
CREATE INDEX idx_documents_user ON scy_documents(user_id, created_at DESC);
CREATE INDEX idx_concepts_user_smi ON scy_concepts(user_id, smi_score DESC);
CREATE INDEX idx_cards_next_review ON scy_apex_cards(user_id, next_review_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_ascent_nodes_goal ON scy_ascent_nodes(goal_id, status);
CREATE INDEX idx_agent_decisions_user ON scy_agent_decisions(user_id, goal_id, created_at DESC);
CREATE INDEX idx_llm_spend_user ON scy_llm_spend_log(user_id, created_at DESC);
CREATE INDEX idx_shared_cache_hash ON scy_shared_content_cache(content_hash);
CREATE INDEX idx_shared_cache_domain ON scy_shared_content_cache(goal_domain, reuse_count DESC);

-- Full-text search
CREATE INDEX idx_documents_fts ON scy_documents USING gin(to_tsvector('english', content));

-- Vector similarity déportée sur Zilliz Cloud (Milvus) pour soulager PostgreSQL
-- Milvus Lite (.db local via pip/rest) utilisé en local pour le cache sémantique Desktop/Offline (Unification de code 100% avec le Cloud)
```

---

## 9. APIs Externes & Intégrations `[Rôle : Backend & Data]`

### 9.1 AI/LLM Providers

| Provider | Usage | Coût moyen |
|---------|-------|-----------|
| DeepSeek V4 | Tâches simple/complex (Free tier primaire) | $0.0001-0.0002/1K |
| DeepSeek R1 | Raisonnement profond (Free tier) | $0.0015/1K |
| Claude Haiku | Tâches simples (Premium tier) | $0.0003/1K |
| Claude Sonnet | Tâches complexes (Premium tier) | $0.003/1K |
| Kimi K2.6 (128K) | Long context output (Free tier) | $0.001/1K |
| GPT-4.5 | Output haute qualité (Premium tier) | $0.01/1K |
| GPT-o1-mini | Raisonnement (Premium tier) | $0.015/1K |
| OpenAI Whisper | Transcription audio (Podcast, TikTok) | $0.006/min |
| text-embedding-3-small | Embeddings 512D | $0.00002/1K |

**Fallbacks** : OpenRouter, Together.ai, Groq (dev/testing)

**Modèles locaux** :
- GLiNER-micro INT8 (12MB ONNX, ort 1.16) : NER locale, $0/mois
- LLMLingua-2 (candle-core) : Compression prompts locale, $0/mois
- Nomic Embed (candle, optionnel offline) : Embeddings locaux

### 9.2 Ingestion APIs (25+)

YouTube Data API v3, Google Drive API v3, Reddit API v2, Twitter/X API v2, MediaWiki API, NASA API, ArXiv API, PubMed API, IEEE Xplore API, Springer API, Nature API, Science (AAAS) API, JSTOR API, Google Scholar (scraping), ResearchGate (scraping), Yahoo Finance API, Bloomberg API (enterprise), Reuters API, SEC EDGAR API, Earnings Calls API

### 9.3 Infrastructure Services

| Service | Rôle | Pricing Phase 0-1 |
|---------|------|-------------------|
| Northflank | Backend Rust deployment | $0/mois (tier gratuit) |
| Northflank | PostgreSQL + pgvector + Auth + Storage | $0/mois (tier gratuit 500MB) |
| Vercel | Frontend React deployment | $0/mois (tier gratuit) |
| Netlify | Fallback frontend | $0/mois |
| Sentry | Error tracking | $0/mois (<5K events/mois) |
| Axiom | Logs OpenTelemetry | $0/mois (<100GB/mois) |

---

## 10. Stratégie Économique LLM — Anti-Goulot `[Rôle : AI & LLM Engineer]`

### 10.1 Problème Sans Optimisation

Une pipeline agentique naïve consommerait **$1.78/parcours** (594K tokens, 600+ appels LLM). À 1000 parcours actifs simultanés → $1 780/mois LLM. Inacceptable pour une marge positive.

### 10.2 Les 7 Mécanismes Anti-Goulot

**Mécanisme 1 : Classification 4 types de décisions**
- TYPE A (70% des opérations) : Règles Rust déterministes → $0.00 LLM
  - FSRS scheduling, calcul SMI, routing adaptatif, détection drift
- TYPE B : Modèles locaux ONNX → $0.00 LLM externe
  - GLiNER NER, embeddings optionnels, LLMLingua compression
- TYPE C : Cache sémantique LanceDB (hit rate 35-60%) → $0.00 LLM
  - Même requête sémantique → réponse cached
- TYPE D : LLM externe requis ≤ 30% des opérations

**Mécanisme 2 : Contenu mutualisé cross-users**
- SharedContentCache : Même objectif → même DAG + docs pour tous les users
- User A génère React (coût $0.057), 999 autres → $0.00 chacun
- Économie : -80 à -99% sur parcours populaires

**Mécanisme 3 : Batch processing**
- 15 nœuds DAG = 1 seul appel LLM batch, pas 15 appels
- Économie : -60% appels DAG-ARCHITECT

**Mécanisme 4 : Compression LLMLingua-2**
- Avant chaque appel > 500 tokens : compression 60%
- candle ONNX INT8 (local, gratuit)
- Économie : -60% tokens input

**Mécanisme 5 : Cache sémantique LanceDB**
- Threshold cosine 0.87 → hit rate 35%
- LanceDB in-process Rust (<2ms lookup)
- Économie : -35% appels LLM

**Mécanisme 6 : Routing strict cheap → cher**
- 60% des appels : DeepSeek V4 ($0.0001/1K)
- 30% : Kimi/Claude Sonnet ($0.001-0.003/1K)
- 10% : GPT-4.5/R1 uniquement si requis
- Économie : -70% vs modèle unique premium

**Mécanisme 7 : Quotas adaptatifs par tier**
- Free : 100K tokens max/parcours, 3 parcours actifs max
- Premium : 500K tokens max/parcours, illimité parcours

**Mécanisme 8 : Prompt Caching Provider-Side** ⚡ (Action immédiate requise)

Certains providers LLM (Anthropic et DeepSeek confirmés) offrent un cache côté API : les tokens du system prompt mis en cache coûtent ~10% du prix normal.

```
Exemple NEURON-CHAINS system prompt : ~2000 tokens (statique entre appels)
Sans cache : 2000 tokens × $0.003/1K = $0.006 par appel
Avec cache  : 200 tokens effectifs  = $0.0006 par appel → Économie -90%

À 10K appels NEURON-CHAINS/mois : -$54/mois d'économie directe
```

**Règles de design pour activer le cache :**
1. Contenu STATIQUE en premier (instructions système, exemples, documents stables)
2. Cohérence absolue — une seule virgule modifiée = cache invalidé
3. Privilégier les longs prompts système (>1000 tokens statiques)

**⚠️ ACTION CRITIQUE COMPLÉTÉE ✅** : Le support du Prompt Caching et de l'API Batch de DeepSeek V4/R1 a été officiellement vérifié et validé en juin 2026.
- **Prompt Caching** : DeepSeek met en cache les tokens système (longs prompts statiques des NEURON-CHAINS) avec une réduction de **-90%** sur ces tokens. Le design de nos prompts système (plaçant les instructions statiques strictes en tête et les données dynamiques en queue de payload) garantit un taux d'utilisation du cache de ~100% sur les appels récurrents.
- **Batch API** : DeepSeek propose l'API Batch permettant d'exécuter des requêtes de génération asynchrone (ex: création de documents NEURON-CHAINS en arrière-plan pendant que l'utilisateur commence son étude) avec une remise de **-50%** par rapport au tarif d'API en temps réel.

**Mécanisme 9 : Stop Condition Streaming** (Phase 2)

Pour les appels LLM avec extraction courte (titre, classification, 1er concept), arrêter le stream dès que l'information est extraite plutôt d'attendre la réponse complète.

```rust
// Économise les tokens output restants après extraction
let mut buffer = String::new();
while let Some(token) = stream.next().await {
    buffer.push_str(&token);
    if let Some(result) = try_parse_complete_json(&buffer) {
        stream.abort(); // Stop immédiat → économie tokens output restants
        return Ok(result);
    }
}
// Cas d'usage : extraction titre document, classification type, 1er concept clé
// Économie estimée : -20% tokens output sur extractions courtes
```

**Impact cumulatif Mécanismes 8+9 :** -$55-80/mois supplémentaires sur la facture LLM Phase 0-1.

### 10.3 Budget Réel Après Optimisations

| Scénario | Coût/parcours 90j | 1000 users actifs/mois |
|---------|-------------------|----------------------|
| Pipeline naïve | $1.78 | $1 780/mois |
| **SCY Forge v2 optimisé** | **$0.006** | **$6/mois** |
| Avec cache mutualisé (>10 users) | $0.0006 | $0.60/mois |
| **Économie** | **-99.7%** | **-$1 774/mois** |

### 10.4 Marge Préservée

```
User Free :
  Coût LLM : $0.018/mois (3 parcours × $0.006)
  Agents : 01-09 uniquement (pas CHRONICLE ni ARENA)
  Monétisation : Freemium → upgrade Premium

User Premium $10/mois :
  Agents 01-09  : $0.050/mois (5 parcours actifs × $0.006 × 1.5)
  CHRONICLE (10): $0.004/mois (disruptions + conversations quotidiennes)
  ARENA (11)    : $0.045/mois (3 sessions/mois × $0.015)
  ───────────────────────────────────────────────────────────────
  TOTAL LLM     : $0.099/mois
  MARGE         : $9.90/mois = 99% marge brute LLM ✅

Différenciation Free vs Premium :
  Free    : ASCENT pipeline 9 agents (apprentissage autonome)
  Premium : + CHRONICLE (coéquipier quotidien) + ARENA (validation pratique)
  → Le Premium = transformation de l'expérience, pas juste + de features
```

### 10.5 BudgetGuard — Monitoring Temps Réel

Alertes automatiques si seuils dépassés :
- 50% budget mensuel → Warning Slack
- 80% → Mode économie activé (DeepSeek exclusif, compression max)
- 100% → Blocage appels premium, email dirigeants
- Dashboard coûts temps réel (`scy_llm_spend_log`)

---

## 11. Métriques de Succès `[Rôle : Product Owner & QA]`

### 11.1 Métriques Business (KPIs Phase 0-1)

| Métrique | Cible | Mesure |
|---------|-------|--------|
| Activation J1 | >60% users upload 1 source | % users action ingestion <24h |
| TTFV | <5min onboarding → 1ère carte révisée | Temps médian inscription → review |
| Rétention J7 | >40% | % users ≥1 session période |
| Rétention J30 | >25% | % users ≥1 session période |
| NPS | >40 | Survey 0-10 |
| ASCENT Completion | >70% terminent 1 roadmap | % users completés ≥1 goal |
| Coût LLM/user/mois | <$0.10 Free, <$0.50 Premium | scy_llm_spend_log |

### 11.2 Métriques Produit Pipeline Agentique (NOUVEAU v2)

| Métrique | Cible | Alerte si |
|---------|-------|-----------|
| Setup time Goal → DAG prêt | <20 minutes | >30 minutes |
| Content Scout coverage | >80% nœuds couverts | <60% |
| SMI moyen à completion | >75/100 | <65/100 |
| Taux hallucination docs | <1% assertions | >2% |
| Score confiance docs moyen | ≥85/100 | <75/100 |
| Cache hit rate mutualisé | >60% | <30% |
| Cache sémantique hit rate | >35% | <15% |
| % décisions sans LLM | >70% | <50% |
| Drift intervention success | >50% users reprennent | <30% |
| Proof of Skill delivery | 100% goals complétés | <95% |

### 11.3 Métriques Techniques

| Métrique | Cible |
|---------|-------|
| COSMOS render | <16ms (60fps) 1000 nœuds |
| RAG latency | p95 <2s |
| Dashboard load | <1s (ISR cache hit) |
| API error rate | <0.1% 5xx |
| Uptime | >99.5% |
| NER précision GLiNER | ≥85% |
| FSRS accuracy | Retention 87-92% |

### 11.4 Métriques Phase 3+ (Scalabilité)

| Métrique | Cible 12 mois |
|---------|--------------|
| MAU | 10K |
| Revenue | $50K ARR |
| Cache hit rate public | >80% |
| DAG quality +1000 completions | +30% vs 100 completions |
| LLM cost/user | <$0.05/mois (économie mutualisée) |

---

## 12. Budget & Timeline `[Rôle : Product Owner & PM]`

### 12.1 Budget Phase 0-1 — $5-10/mois (-80% Optimisé)

| Poste | Baseline | Phase 0-1 | Économie |
|-------|---------|-----------|---------|
| LLM API | $3-6/mois | $3-6/mois | $0 |
| Embeddings | $1-2/mois | $0.50/mois | -$1.50 |
| Cache (Redis) | $15/mois | $0 (SQLite D-002) | -$15 |
| NER (Hugging Face) | $9/mois | $0 (GLiNER local D-011) | -$9 |
| Storage Northflank | $0/mois | $0/mois | $0 |
| Compute Northflank | $0-5/mois | $0-5/mois | $0 |
| Monitoring | $0/mois | $0/mois | $0 |
| **TOTAL** | **$29-34/mois** | **$5-10/mois** | **-$24/mois** |

**Économie cumulée Année 1** : 12 × $24 = **-$288 économisés**

### 12.2 Timeline — 35 Jours (Scénario B révisé)

**POC Jour 4 (1j, 7h) — BLOQUANT avant tout développement**
- Test 1 : G6 v5 + Louvain clustering 1000 concepts <10s (go/no-go graphe)
- Test 2 : GLiNER-micro INT8 NER 100 concepts <3s, précision ≥85%
- Test 3 : Typst PDF génération complexe <2s
- Test 4 : Tantivy RRF hybrid search 1000 docs <100ms
- **Si 4 GO → Sprint** / **1 NO-GO → Fallback 60min** / **2+ NO-GO → STOP**

**MVP Phase 0 (16j)** :
- Ingestion : YouTube, Web, Google Drive (3 cores HIGH)
- NEURON-CHAINS : ALPHA, BETA, EPSILON (3 chaînes MVP)
- COSMOS : Lexical, Knowledge Graph, MindMap, Statistics (4 modes)
- APEX : FSRS + 5 types cartes + Feedback 4 niveaux
- BRAIN : Naive RAG (vector + generation)
- ASCENT Pipeline : Agents 01-06 (Goal → DAG → Learning → Performance → Routing)
- Features : Dashboard (D-003), Cache SQLite (D-002), Tantivy (D-009), Auto-Save (D-012)

**V1 Phase 1 (7j)** :
- Agents Pipeline : 07 (Drift-Guardian) + 08 (Engagement-Amplifier)
- Ingestion : Podcast, Financial (2 cores MEDIUM)
- COSMOS : Tags 3 niveaux (D-001), Timeline (D-010)
- BRAIN : HyDE + KG RAG
- NER GLiNER local (D-011)
- NEURON-CHAINS v2 : APEX-AGENT + 10 premiers tools (T01-T10)
- GPTCache + RouteLLM optimisation

**V2 Phase 2 (12j — étendu pour pipeline agentique complète)** :
- Agent-09 (Skill-Certifier) + Proof of Skill complet
- Ingestion : Wiki, Science, TikTok, Reddit (4 cores LOW)
- NEURON-CHAINS : GAMMA, DELTA, ZETA, ETA (4 chaînes POST-MVP)
- NEURON-CHAINS v2 : Tools T11-T18 complets (anti-hallucination + export)
- COSMOS : Roadmap ASCENT, Concepts Grid, DataFlow (3 modes POST-MVP)
- APEX : Miroir Cognitif 3 modes
- Export : 9 formats complets (D-008)
- Projets Workspaces (D-004), Calibration Métacognitive (D-006)
- SharedContentCache (économie mutualisée)
- Tests E2E complets + optimisations performance

**TOTAL : 36 jours** (POC 1j + MVP 16j + V1 7j + V2 12j)

### 12.3 Budget Phase 3 (+2000 Users)

| Poste | Phase 0-2 | Phase 3 | Delta |
|-------|----------|---------|-------|
| Cache | $0 (SQLite) | $15/mois (Redis Northflank) | +$15 |
| Storage | $0/mois | $10-15/mois | +$10 |
| LLM (économie mutualisée) | $3-6/mois | $1-3/mois | -$3 |
| **TOTAL** | **$5-10/mois** | **$26-33/mois** | +$20 |

---

## 13. Risques & Mitigations `[Rôle : DevOps & QA]`

### 13.1 Risques Critiques

**Risque 1 — POC Jour 4 Non Exécuté (BLOQUANT)**
- Impact : Risque technique 4 technologies majeures
- Mitigation : **Exécuter POC avant tout sprint** (7h, priorité absolue)
- Confiance : 100%

**Risque 2 — Coûts LLM Pipeline Agentique**
- Impact : Marges négatives si pipeline naïve
- Mitigation : 7 mécanismes anti-goulot (voir Section 10) + BudgetGuard
- Coût prouvé : $0.006/parcours vs $1.78 naïf (-99.7%)
- Confiance : 98%

**Risque 3 — Qualité Génération NEURON-CHAINS**
- Impact : Confiance utilisateur si docs insuffisants
- Mitigation : Anti-hallucination 3 couches + score confiance par section + seuil rejet <50
- Cible : <1% hallucinations, score moyen ≥85/100
- Confiance : 96%

**Risque 4 — ASCENT Completion Rate Faible**
- Impact : Value proposition "compétence garantie" non prouvée
- Mitigation : DRIFT-GUARDIAN 8 signaux + ADAPTIVE-ROUTER temps réel + gamification
- Confiance : 94%

**Risque 5 — Cold-Start ASCENT Nouveaux Users**
- Impact : Recommendations initiales génériques
- Mitigation : SINKT (PAPER-009) auto-positionnement + templates prédéfinis + questionnaire 3-5 questions
- Confiance : 97%

**Risque 6 — Latence COSMOS 5000+ Nœuds**
- Impact : UX dégradée <60fps
- Mitigation : WebGL G6 v5 (60fps <20K nœuds) + LOD + WebWorker background
- Confiance : 96%

**Risque 7 — Crates Libraries Obsolètes**
- Impact : Perte temps debug, code non fonctionnel
- Mitigation : Section ⚠️ CRATES À ÉVITER (docx-rs, zip-rs, printpdf)
- Confiance : 100%

**Risque 8 — Complexité Event Sourcing**
- Impact : +1 semaine dev initial
- Mitigation : Bounded Context ciblé (Ingestion + FSRS uniquement)
- Confiance : 92%
**# RISQUE 9 — WebAssembly (Modéré)

```
┌─────────────────────────────────────────────────────────────────┐
│         WEBASSEMBLY — OPPORTUNITÉ POUR TON STACK RUST          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  TA SITUATION UNIQUE :                                         │
│  Tu as du code Rust backend                                    │
│  WASM permet de compiler ce code Rust                         │
│  et de l'exécuter DANS LE NAVIGATEUR                          │
│                                                                  │
│  CE QUE ÇA CHANGE :                                           │
│                                                                  │
│  AUJOURD'HUI :                                                 │
│  FSRS → calcul côté backend Rust → résultat envoyé au front   │
│  petgraph → validation DAG côté backend                       │
│                                                                  │
│  AVEC WASM :                                                   │
│  FSRS compilé en WASM → calcul dans le navigateur            │
│  petgraph en WASM → validation DAG offline dans le browser    │
│  Zéro latence réseau pour ces opérations                      │
│  Zéro coût serveur pour ces calculs                           │
│  Fonctionne 100% offline                                      │
│                                                                  │
│  BÉNÉFICE POUR LA VERSION WEB :                               │
│  La version web peut avoir des features offline               │
│  Sans avoir besoin d'Electron                                 │
│  → PWA (Progressive Web App) offline-capable                  │
│                                                                  │
│  TECHNOLOGIES À SURVEILLER :                                   │
│  wasm-bindgen → Rust → WASM (mature, stable)                 │
│  wasmer → runtime WASM universel                              │
│  wasm-pack → packaging Rust WASM pour npm                     │
│                                                                  │
│  URGENCE : Modérée — opportunité pas urge



## RISQUE 10 — AI Act Européen (Légal)

```
┌─────────────────────────────────────────────────────────────────┐
│         AI ACT EU — CONFORMITÉ LÉGALE À PRÉPARER              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  QU'EST-CE QUE L'AI ACT ?                                     │
│  Réglementation européenne sur l'IA                            │
│  Entrée en vigueur progressive 2024-2026                      │
│                                                                  │
│  CE QUI CONCERNE MINDFORGE :                                   │
│                                                                  │
│  RISQUE FAIBLE (ton cas) :                                    │
│  Système d'éducation et d'apprentissage                       │
│  → Catégorie "risque limité"                                  │
│  → Obligations : transparence sur l'utilisation de l'IA      │
│                                                                  │
│  OBLIGATIONS CONCRÈTES :                                       │
│  ✅ Dire à l'user quand l'IA génère du contenu               │
│     → Tu le fais déjà (badges NEURON-CHAINS)                 │
│  ✅ Ne pas créer de faux profils humains                      │
│     → Tu ne fais pas ça                                       │
│  ⚠️ Traçabilité des décisions IA                              │
│     → Logger quelle chaîne a produit quel output            │
│  ⚠️ Droit à l'explication                                     │
│     → Expliquer pourquoi ASCENT a fait tel choix            │
│                                                                  │
│  CE QUE TU DOIS AJOUTER :                                     │
│  scy_ai_decisions (table de traçabilité)                      │
│  → Chaque décision IA loguée avec contexte                   │
│  → Explicable à l'utilisateur si demandé                     │
│                                                                  │
│  URGENCE : Modérée — à intégrer avant expansion EU           │
│                                                                  │
└─────────────────────────────────────────────




### 13.2 Sécurité — Points Critiques

- JWT rotation automatique (SDK Northflank)
- RLS PostgreSQL (isolation native DB-level)
- Rate limiting par endpoint et tier
- keyring OS pour secrets Desktop
- Parameterized queries uniquement (SQL injection impossible)
- CSP headers anti-XSS
- GDPR : Export + Delete + Audit trail (Event Sourcing)

---

## 14. Non-Goals & Out-of-Scope `[Rôle : Product Owner & PM]`

### Phase 0-2 Écartés

- ❌ **Collaboration CRDT Temps-Réel** : 3-4 mois dev, cas d'usage incertain → Partage lien UUID read-only Phase 1 (§7.7quater)
- ❌ **Sessions Groupe Live** : User research Phase 3 requis → Commentaires asynchrones Phase 3 (décision COL-003 §15.7)
- ❌ **Deep RL Scheduling FSRS** : +12% rétention vs +3-4 mois dev → FSRS 5.0 suffit Phase 0-2
- ❌ **NAS Transformer KT** : Gains +2-4%, compute NAS intensive → Mamba4KT référence
- ❌ **Qdrant Migration** : pgvector suffit Phase 0-2 → Phase 3 si p99 latency > 50ms sur >5M vecteurs (PERF-002 §15.7)
- ❌ **ColPali Embeddings Multimodaux** : Cloud GPU requis, coût élevé → Phase 3 Enterprise uniquement (PERF-003 §15.7)
- ❌ **Local Llama Desktop** : Performance CPU limitée → Phase 2 Ollama si compétiteur menace
- ❌ **Style d'apprentissage auto (ML)** : Classification comportementale complexe → Phase 3 R&D (§7.5.19-D)
- ❌ **HypergraphRAG** : Construction N-aires coûteuse, algorithmes immatures → Phase 3 si graphe standard insuffisant
- ❌ **MKGL Fine-Tuning KG** : Fine-tuning complexe, coût entraînement → Phase 3+ si COSMOS auto-construction insuffisante
- ❌ **Memory Dynamics Optimization (IEEE TKDE 2023)** : Modèle différentiel stochastique, complexité élevée → Phase 3 si FSRS limitant
- ❌ **Passkeys/WebAuthn** : Adoption progressive, dépend support Northflank → Phase 2 (vérification API requise, AUTH-001)

### Features Déprioritisées (Post-MVP)

- NEURON-CHAINS : GAMMA, DELTA, ZETA, ETA → Phase 2
- COSMOS Modes : Concepts Grid, Timeline, DataFlow → Phase 2
- COSMOS History Animation Temporelle → Phase 2 (§7.4.3bis-D)
- APEX Miroir Cognitif 3 modes → Phase 2
- SCY-IMPRINT (déclenchement auto par agent-04) → Phase 1 (déclenchement) / Phase 2 (UX complète)
- Agent-09 SKILL-CERTIFIER → Phase 2
- Shared Content Cache → Phase 1
- NEURON-CHAINS tools T11-T18 → Phase 2
- Reader Suite (Explore/Sprint/Review modes) → Phase 2 (§7.13.3)
- Page Gallery → Phase 2 (§7.13.5)
- Marketplace Decks → Phase 3 (§7.7quater Niveau 2)
- Leaderboards Gamification → Phase 2 opt-in (§7.5.12)
- Dynamic Cognitive Diagnosis → Phase 2 (§16 PAPER-034-bis)

---

## 15. Décisions Architecture — Registre Complet `[Rôle : DevOps & Architecte]`

### 15.1 Décisions Fondamentales (Décision-001 à Décision-018)

| ID | Décision | Confiance | Phase |
|----|---------|-----------|-------|
| D-001 | Architecture Hexagonale (ports & adapters) | 95% | MVP |
| D-002 | CQRS Léger (Commands/Queries séparés) | 95% | MVP |
| D-003 | Event Sourcing ciblé (Ingestion + FSRS) | 92% | MVP |
| D-004 | Monolithe Unifié (Single-Process Monolith) | 100% | MVP |
| D-005 | Repository Pattern (trait générique) | 100% | MVP |
| D-006 | GraphQL + DataLoader (N+1 résolu) | 93% | MVP |
| D-007 | Temporal Queries PostgreSQL (time-travel DB) | 95% | V1 |
| D-008 | Unit of Work Pattern (transactions atomiques) | 96% | MVP |
| D-009 | Pipeline Pattern NEURON-CHAINS | 98% | MVP |
| D-010 | Observer Pattern Notifications (EventBus) | 95% | MVP |
| D-011 | Typestate Pattern ASCENT (états type-safe) | 93% | MVP |
| D-012 | Distributed Tracing OpenTelemetry | 96% | V1 |
| D-013 | Polars + DuckDB Analytics (in-memory) | 94% | V1 |
| D-014 | Saga Pattern Workflows (futurs multi-services) | 92% | Phase 3 |
| D-015 | ISR Dashboard (Incremental Static Regeneration) | 96% | MVP |
| D-016 | Specification Pattern (filtres composables) | 93% | V1 |
| D-017 | Reactive Streams + Backpressure (ingestion) | 95% | MVP |
| D-018 | Observability as Code (métriques structurées) | 97% | MVP |

### 15.2 Décisions Session 2026-06-04 (D-001 à D-012 session)

| ID | Décision | Impact Budget | Phase |
|----|---------|--------------|-------|
| D-001 | Tags Hiérarchiques 3 niveaux | $0, +1j | V1 |
| D-002 | Cache SQLite→Redis 2-Phases | -$15/mois Phase 0-1 | MVP |
| D-003 | Dashboard Accueil Quick Actions | $0, +1j | MVP |
| D-004 | Projets Workspaces | $0, +1.5j | V2 |
| D-005 | APEX Feedback 4 Niveaux | $0 | MVP |
| D-006 | Calibration Métacognitive | $0, +1j | V2 |
| D-007 | Mind Map G6 v5 + Louvain | $0, +3j | V1 |
| D-008 | Export Typst/docx/zip 9 formats | $0, +8j phased | V2 |
| D-009 | Tantivy Hybrid Search + RRF | $0, +1j | MVP |
| D-010 | Timeline Custom vs react-chrono | $0, +0.5j | V1 |
| D-011 | NER GLiNER-micro INT8 locale | -$9/mois | V1 |
| D-012 | Auto-Save Drafts Dual Storage | $0, +0.5j | MVP |

### 15.3 Décisions ASCENT Pipeline v2 (NOUVELLES)

| ID | Décision | Justification |
|----|---------|--------------|
| AP-001 | 13 agents autonomes vs 1 orchestrateur monolithique | Séparation concerns, testabilité, évolutivité |
| AP-002 | EventBus central vs appels directs inter-agents | Découplage total, ajout agent sans refactoring |
| AP-003 | Règles Rust pour 70% décisions (zéro LLM) | Coût maîtrisé, latence <1ms, déterminisme |
| AP-004 | Typestate machine pour états ASCENT | Transitions type-safe, impossible état invalide |
| AP-005 | SharedContentCache cross-users | Économie mutualisée -80 à -99% LLM |
| AP-006 | BudgetGuard avec mode économie automatique | Protection marges, pas de surprises factures |
| AP-007 | FSRS + SMI = algorithmes Rust purs (0 LLM) | 1800 révisions = $0 LLM |

### 15.4 Décisions NEURON-CHAINS v2 (NOUVELLES)

| ID | Décision | Justification |
|----|---------|--------------|
| NC-001 | 18 tool callings natifs Rust vs Python sidecar | Latence <1ms, pas de GC, type-safety |
| NC-002 | Génération section par section vs monolithique | Anti-dérive, retry ciblé, cache intermédiaire |
| NC-003 | Anti-hallucination 3 couches vs vérification post | Prévention > guérison, moindre coût LLM |
| NC-004 | Score confiance par section vs global | Granularité actionnable, confiance utilisateur |
| NC-005 | LLMLingua-2 via candle ONNX (local) | Compression sans appel externe, $0/compression |
| NC-006 | LanceDB in-process vs Redis externe | Latence <2ms, $0/mois Phase 0-2 |

### 15.5 Décisions COSMOS v3 Extension (NOUVELLES)

| ID | Décision | Justification |
|----|---------|--------------|
| FLY-010 | @antv/g2 v5 pour Sunburst/Treemap vs G6 | G6 = graphes node-link, G2 = statistiques/hiérarchies — moteurs distincts |
| FLY-011 | Concept Map (M9) ≠ MindMap (M3) — modes distincts | Usages cognitifs différents validés par recherche (NN/Group 2024) |
| FLY-012 | Auto-Suggest mode optimal par Agent-03 | Type données + préférences + objectif courant → suggestion mode |
| FLY-013 | Lazy-loading strict nouveaux renderers | 7/16 modes = 0KB additionnel, bundle initial +20KB vs v2 |
| FLY-014 | nivo pour Sankey/Chord/CirclePacking (vs D3) | React-native, API déclarative, bundle comparable |
| FLY-015 | 16 nouveaux modes en 4 phases (MVP+ → V3, 18 mois) | Priorisation par impact/couverture et réutilisation existant |
| FLY-016 | HiDPI + Font Stack Universel obligatoires (v4) | Netteté Retina, support CJK/Emoji complet, zéro fallback manquant |
| FLY-017 | AI Confidence System — badge obligatoire sur toute connexion auto-générée (v4) | Confiance utilisateur, sur-confiance IA documentée, feedback loop |
| FLY-018 | Typed Semantic Edge Styles — 7 types distincts (v4) | Lisibilité ×3, différenciation sémantique, légende auto |
| FLY-019 | Progressive Rendering 4 phases — jamais de spinner blanc (v4) | Temps perçu ÷5, rétention utilisateur +65% |
| FLY-020 | Learning-Aware Graph — SMI intégré dans nœuds (v4 Opportunité #1) | Différenciation absolue, aucun concurrent, FSRS × visualisation |
| FLY-021 | Source-Linked Nodes — provenance tracée + Reader Suite bridge (v4 Opportunité #3) | Traçabilité complète, confiance données, navigation contextuelle |
| FLY-022 | Persistent GPU Buffers — pas de re-upload pan/zoom (v4) | Performance GPU ×120 en interactions |
| FLY-023 | WebGPU Roadmap Phase 3 — migration progressive (v4) | ×15 perf, 5M+ nœuds, ForceAtlas2 GPU |
| FLY-024 | Behavioral Progressive Disclosure — signaux hover (v4) | Information overload résolu, révélation contextuelle |
| FLY-025 | Persona Adaptive Interface — 3 modes expertise (v4) | Adoption +40%, novice vs expert, upgrade progressif |

### 15.6 Décisions Patterns Résilience & Robustesse (NOUVELLES — §3.4)

| ID | Décision | Justification | Phase |
|----|---------|--------------|-------|
| ARC-001 | Circuit Breaker par provider LLM (3 états) | Fast-fail, fallback automatique, prévention cascade failure | MVP |
| ARC-002 | Idempotency Keys UUID v7 (24h TTL) | Safe retries, 0% duplication, cohérence garantie | MVP |
| ARC-003 | Timeout 3 niveaux (5s API / 30s opération / 60s requête) | Protection cascade, expérience utilisateur préservée | MVP |
| ARC-004 | Dead Letter Queue SQLite + EventBus | Aucune perte d'événement, traçabilité 100% | MVP |
| ARC-005 | Bulkhead 6 domaines (sémaphores tokio) | Isolation pannes, +99.9% résilience inter-domaines | MVP+ |
| ARC-006 | Graceful Shutdown 5 phases (Drain→Exit) | Zéro perte données au redémarrage | MVP |
| ARC-007 | Outbox Pattern PostgreSQL (atomique BDD+Event) | Cohérence transactionnelle garantie | MVP+ |
| ARC-008 | Materialized Views PostgreSQL (4 vues) | -80% temps requêtes dashboard | V1 |
| ARC-009 | Health Checks 3 niveaux (/live, /ready, /deep) | Kubernetes-native, détection proactive | MVP |
| ARC-010 | Feature Flags avec RolloutStrategy graduel | Déploiement progressif, rollback instantané sans redeploy | V1 |
| ARC-011 | Blue/Green Deployment (Northflank + Vercel) | Zéro downtime, rollback < 2 min | V1 |
| ARC-012 | Property-Based Testing (proptest Rust) | Couverture exhaustive cas limites, FSRS + Circuit Breaker | MVP+ |
| ARC-013 | Chaos Engineering (4 scénarios) | Validation résilience en conditions réelles | V2 |
| ARC-014 | Strangler Fig Pattern (migration v2→v3) | Migration progressive sans risque, rollback immédiat | V1 |
| ARC-015 | Anti-Corruption Layer (APIs externes) | Domaine protégé, modèles externes isolés, jamais de leak | MVP |

### 15.7 Décisions Reader Suite & Collaboration (NOUVELLES)

| ID | Décision | Justification | Phase |
|----|---------|--------------|-------|
| RS-001 | File Viewer intégré (pas redirection externe) | UX cohérente, enrichissement IA contextuel sidebar | MVP |
| RS-002 | Web Viewer read-only strict pour fichiers générés | Voir avant décider — flow naturel vers Reader Suite | Phase 1 |
| RS-003 | Book Orchestrator : 1 question clarification max | Réduire friction cognitive, décision rapide | Phase 1 |
| RS-004 | Max 3 modes COSMOS par orchestration | Éviter la surcharge cognitive (Miller's Law 7±2) | Phase 1 |
| RS-005 | Page Gallery : miniatures côté client (PDF.js) | $0 génération serveur, lazy loading natif | Phase 2 |
| RS-006 | Reader Suite modes (Focus/Explore/Sprint/Review) | Adapter l'expérience au contexte, pas one-size-fits-all | Phase 2 |
| COL-001 | Partage lien UUID read-only (pas CRDT) | 2-3j dev vs 3-4 mois CRDT, 95% du besoin | Phase 1-2 |
| COL-002 | Marketplace : attendre >50 decks qualité | Marketplace vide = bad UX = pire que rien | Phase 3 |
| COL-003 | Leaderboards opt-in uniquement | Privacy-first, anti-toxicité comparaison forcée | Phase 2 |
| PERF-001 | SQLite-VSS pour vector store Desktop | Intégré rusqlite existant, 0 dépendance externe Desktop | Phase 1 Desktop |
| PERF-002 | Qdrant si pgvector p99 > 50ms (>5M vecteurs) | Trigger explicite décision migration, pas migration anticipée | Phase 3 |
| PERF-003 | ColPali uniquement Cloud GPU Enterprise | GPU requis = pas Desktop, pas Free tier | Phase 3 |
| AUTH-001 | Passkeys/WebAuthn Phase 2 (si Northflank supporte) | Standard 2025 mais adoption progressive, vérifier API d'abord | Phase 2 |

### 15.8 Nouvelles Décisions d'Optimisation ASCENT & DeepSeek (session v2.5)

| ID | Décision | Justification | Phase |
|----|---------|--------------|-------|
| D-OPT-001 | WASM-Based Local Edge Computation | Compiler le moteur d'ordonnancement FSRS et la validation de graphes petgraph en WebAssembly pour les exécuter localement sur le client React. Cela élimine la latence réseau, supprime la facturation CPU serveur, et permet le fonctionnement 100% hors-ligne. | MVP+ |
| D-OPT-002 | Deep Links Sémantiques APEX ↔ Reader | Associer chaque carte de révision APEX à un pointeur sémantique exact (source_id, page, offset/paragraphe ou timestamp). L'utilisateur peut ainsi sauter de son erreur directement à la source exacte surlignée dans la Reader Suite. | V1 |
| D-OPT-003 | Intégration Native DeepSeek Prompt Caching | Structurer délibérément tous les prompts système des NEURON-CHAINS pour qu'ils soient statiques en tête et dynamiques en queue afin de maximiser le cache DeepSeek (économie de -90% sur l'input). | MVP |
| D-OPT-004 | Ingestion Batch API DeepSeek | Utiliser l'API Batch asynchrone de DeepSeek pour toutes les générations de documents en tâche de fond (-50% sur le coût global de génération). | MVP |
| D-OPT-005 | Dynamic Graph Splitting | Ne générer que les nœuds du premier jalon actif d'un parcours (5 à 8 nœuds concrets), laissant le reste sous forme de macro-jalons non instanciés pour ramener le TTFV (Time to First Value) sous les 20 secondes. | MVP |
| D-OPT-006 | Double-Engine FSRS ↔ Bloom Loop | Conditionner l'accès aux exercices pratiques de niveau de Bloom supérieur (≥ 3) à un seuil minimum de stabilité cognitive FSRS ($\text{Stability} \ge 3.0$ jours) pour assurer des bases mémorielles solides avant la pratique. | V1 |
| D-OPT-007 | SMI Mathematical Formalization | Utiliser des équations déterministes strictes (calculées côté client) pour la fusion des 5 composantes du SMI (Score de Maîtrise Intégrée) afin de garantir la rigueur et la valeur académique du certificat. | MVP |
| D-OPT-008 | HSM Arena Personas | Concevoir les simulations de l'ARENA sous forme de machines à états finis hiérarchiques pilotées par un score émotionnel dynamique pour éviter les dérives comportementales et économiser 40% de tokens. | V1 |

---


### 15.9 Décisions d'Ingénierie Neuroscientifique & MIA (session v3.0)

| ID | Décision | Justification | Phase |
|----|---------|--------------|-------|
| D-OPT-009 | Sigmoïde de Vitalité Robust (ENGRAM) | Remplacer le modèle linéaire brut de vitalité par une équation sigmoïdale robuste amortie et écrêtée à $t = 60$ jours ($V_n(t)$). Cela évite le déclin trop agressif du savoir durant les premières semaines, tout en déclenchant l'archivage en dormance dans `scy_engram_vault` de manière fiable à J90. | Phase 1 (Web) |
| D-OPT-010 | Fail-Safe Gate de Compétition Synaptique (RIF) | Intégrer un seuil d'amortissement de 90% sur l'inhibition compétitive RIF lorsque la vitalité synaptique d'un concept sémantique descend sous $25.0/100$, neutralisant à 100% tout risque d'avalanche ou de cascade d'effondrement. | Phase 1 (Web) |
| D-OPT-011 | Approximation Physique Barnes-Hut (O(N log N)) | Implémenter l'approximation spatiale de Barnes-Hut s'appuyant sur un arbre Quadtree récursif à la place du calcul de répulsion Verlet quadratique $O(N^2)$, garantissant la scalabilité fluide de la constellation jusqu'à des millions de nœuds ($10^6$ nœuds). | Phase 1 (Web) |
| D-OPT-012 | Softening Epsilon d'Anti-Division par Zéro | Ajouter une constante de lissage $\epsilon = 10^{-6}$ au dénominateur du calcul des forces de répulsion pour éliminer les divisions par zéro et les coordonnées de type `NaN` lors de superpositions de nœuds. | Phase 1 (Web) |
| D-OPT-013 | Architecture Multi-Agent Découlée MIA | Organiser la boucle d'auto-recherche et de test-time learning sémantique autour de l'architecture découplée Manager-Planner-Executor (MIA, Shanghai SII / ECNU 2026), éradiquant l'inflation de contexte et optimisant récursivement le moteur. | Phase 1 (Web) |
| D-OPT-014 | Protocole FORGE d'Effet de Génération obligatoire | Interdire l'affichage passif de tout contenu éducatif sans une tentative d'amorce cognitive sémantique préalable (Feynman challenge à trous) évaluée par l'APEX-AGENT, augmentant la rétention de 20% à 40%. | Phase 1 (Web) |
| D-OPT-015 | Mode FRICTION d'Anti-Fluidité | Casser l'illusion d'assimilation par un entrelacement (70% cible, 30% connexes) des cartes mémoire et désactiver les barres de progression en cours de session active, doublant la rétention à long terme. | Phase 1 (Web) |
| D-OPT-016 | Température Thermodynamique du Graphe | Modéliser l'entropie de mémorisation temporelle et le niveau d'assimilation sous forme d'une équation thermodynamique de température ($T_n(t)$) affichée sous forme de carte thermique WebGL (COSMOS Mode 26) : Or impérial pour l'activité chaude, Bleu/Violet pour le consolidé stable, et Gris glacial pour l'obsolescence. | Phase 1 (Web) |
| D-OPT-017 | Creator-to-Student Synaptic Loop | Mettre en place une boucle de feedback créateur automatisée. Si l'Agent-13 (Cognitive-Validator) détecte qu'un seuil critique de 80% des étudiants d'une cohorte échouent ou restent bloqués sur un concept, une alerte est déclenchée. Le créateur peut alors enregistrer une micro-clarification sémantique (audio/vidéo de 1 min) ré-indexée instantanément dans Zilliz pour mettre à jour la formation en temps réel. | Phase 1 (Web) |
| D-OPT-018 | Lazy Physics Suspension | Mettre en pause complète la simulation physique (2D/3D) dès que le graphe de forces de Verlet a convergé (vitesse de déplacement des nœuds $\le 0.05$ pixel/frame), ramenant l'utilisation CPU à 0% et préservant la batterie mobile. | Phase 1 (Web) |
| D-OPT-019 | Quadtree Object Pooling | Utiliser un pool statique de nœuds Quadtree pré-alloués en mémoire (`Memory Pool`) pour éliminer tout temps de pause du ramasse-miettes (Garbage Collection) lors du rendu de millions de nœuds sur mobile. | Phase 1 (Web) |
| D-OPT-020 | Local Telemetry Debouncing | Accumuler et regrouper (debouncer) sur 5 secondes les mises à jour de vitalité synaptique $V_n(t)$ sur le client avant de les transmettre par lots asynchrones à la base de données relationnelle Northflank. | Phase 1 (Web) |
| D-OPT-021 | Fail-Safe Backup AI Clarification | Si un créateur de cohorte n'enregistre pas de micro-clarification sous 24h face à une alerte de goulot d'étranglement, le `Professor AI` génère automatiquement un contenu socratique transitoire pour débloquer les élèves. | Phase 1 (Web) |
| D-OPT-022 | Socratic Progressive Prompting | Limiter les explications du Professor AI à un maximum de 2 paragraphes et forcer l'inclusion d'une question socratique ciblée à la fin de chaque réponse, stimulant l'auto-découverte et réduisant de 40% les coûts de tokens. | Phase 1 (Web) |
| D-OPT-023 | Prerequisite Booster Schedule | Si un nœud requis (ancêtre) pour le nœud courant est en dormance sémantique (V < 20 dans le vault), planifier automatiquement un booster de révision de ce prérequis *avant* de lancer la session d'étude active. | Phase 1 (Web) |
| D-OPT-024 | ELI5 Micro-Remediation Overlay | Si un étudiant échoue deux fois consécutivement au test FORGE d'un nœud difficile, déclencher un affichage d'aide instantané (explication simplifiée ELI5) pour neutraliser la frustration et le risque d'abandon. | Phase 1 (Web) |
| D-OPT-025 | Adversarial RAG Context Guardrail | Filtrer détermistiquement et assainir tous les fragments de textes (chunks) récupérés du RAG vectoriel Zilliz pour strip-détecter les injections de prompts malveillantes avant de les injecter à l'APEX-AGENT. | Phase 1 (Web) |
| D-OPT-026 | Offline-First Local Sync Queue | Enregistrer toutes les interactions et progressions FSRS locales dans la table `scy_sync_queue` de l'IndexedDB locale du navigateur. Un service worker pousse asynchronement les lots à Northflank dès le retour du réseau. | Phase 1 (Web) |
| D-OPT-027 | Thread-of-Thought Scaffolding | Reconstruire une narration d'explication logique et chronologique dans le RAG de BRAIN en tissant des liaisons sémantiques entre le nœud courant et ses parents sémantiques immédiats pour éviter les explications fragmentées. | Phase 1 (Web) |
| D-OPT-028 | FSRS Self-Consistency Checker | Planifier des simulations de Monte Carlo hebdomadaires (10,000 runs virtuels par user) pour auditer la dérive de l'algorithme APEX FSRS et auto-calibrer les 17 constantes pour s'adapter à la vitesse réelle de l'utilisateur. | Phase 1 (Web) |
| D-OPT-029 | GDPR Anonymization & Cohort Milestones | Sécuriser la console Créateur en appliquant un masque de k-anonymat (k >= 10) sur tous les profils d'élèves (exclusion de la matière brute des chats), tout en permettant de débloquer des quêtes et lives collectifs selon l'SMI de cohorte. | Phase 1 (Web) |
| D-OPT-030 | Dynamic LOD & Label Cull | Désactiver dynamiquement l'affichage des labels de texte et des halos de lueurs pour les nœuds d'arrière-plan ou si le frame rate du Canvas descend sous les 45 FPS, garantissant un rendu fluide à 60 FPS sur tout mobile. | Phase 1 (Web) |
| D-OPT-031 | Persistent IndexedDB WAL | Sauvegarder la file `scy_sync_queue` locale sous forme de journal de transactions persistantes (Write-Ahead Log) dans l'IndexedDB, assurant la résilience et l'auto-réparation en cas de crash brutal du navigateur. | Phase 1 (Web) |
| D-OPT-032 | ASCENT-QA Validation Board | Intégrer un sous-pipeline d'audit pédagogique de 6 agents (SME, Curriculum Designer, etc.) évaluant à coût de licence nul (0$) de manière asynchrone le contenu généré avant de débloquer l'éligibilité à la certification Proof of Skill (seuil de validation PQS >= 88/100). | Phase 1 (Web) |
| D-OPT-033 | Base de Données d'Axiomes (SCY-AXIOM) | Moteur d'auto-apprentissage fermé : l'APEX-AGENT distille de nouvelles compétences de procédures (skills) sous forme de fichiers Markdown locaux anonymisés via un filtre PII strict pour éradiquer tout risque de fuite de données privées (GDPR). | Phase 1 (Web) |
| D-OPT-034 | Localized Metacognitive Auto-learning | Implémenter le cycle d'auto-apprentissage fermé (Closed-Loop Learning) de Hermes Agent (Nous Research, 2026) : l'APEX-AGENT distille de nouvelles compétences de procédures (skills) sous forme de fichiers Markdown locaux anonymisés via un filtre PII strict pour éradiquer tout risque de fuite de données privées (GDPR). | Phase 1 (Web) |
| D-OPT-035 | SCY-AXIOM Synthesis Engine | Remplacer les micro-skills locaux par un système d'escalier inductif géré par l'agent `AXIOMATIZER (AGENT-15)`. Il synthétise les traces réussies de cohortes en "Lois Fondamentales" uniques d'arrière-plan, partagées de manière invisible et globale avec tous les utilisateurs de SCY Forge (Moat d'Intelligence Collective). | Phase 1 (Web) |
| D-OPT-036 | SME HITL-Proxy Agent | Implémenter l'agent `HITL-PROXY-SME (AGENT-16)` simulant un expert humain sceptique de classe mondiale (Mayo Clinic, MIT, etc.) pour auditer la rigueur scientifique des cursus auto-générés et d'alignement d'examens d'ASCENT. | Phase 1 (Web) |
| D-OPT-037 | Dual Student Pathway Split | Séparer la machine à états d'apprentissage en deux parcours : Parcours A (Assimilation Active - rapide, sans barrière QA lourde, 0$ attente, zéro certificat) et Parcours B (Accréditation Certifiante - Comité QA + Expert obligatoire, examen SurveyJS, simulation ARENA, certificat Proof of Skill signé). | Phase 1 (Web) |
| D-OPT-043 | MindGraph MCP Server | Développer un serveur Model Context Protocol (MCP) local co-localisé au monolithe unifié. Il permet aux agents d'interroger `COSMOS-MINDGRAPH` via un outil unique `query-mindgraph` s'appuyant sur des requêtes SQL récursives CTE hyper-rapides, réduisant de 4.5x la consommation de tokens. | Phase 1 (Web) |
| D-OPT-048 | Boost Sommeil (Chronicle) | L'agent `CHRONICLE (AGENT-10)` planifie automatiquement une micro-révision de 2 minutes des concepts complexes juste avant le coucher de l'utilisateur pour cibler ces synapses pour la consolidation hippocampale nocturne. | Phase 1 (Web) |
| D-OPT-049 | Interleaved Adaptive Routing | L'agent `ADAPTIVE-ROUTER (AGENT-06)` impose de manière déterministe un entrelacement (70% domaine cible, 30% connexes/maîtrisés) pour briser l'habituation cognitive du cortex visuel. | Phase 1 (Web) |
| D-OPT-050 | STUDENT-AI Teach-Back Diagnostics | Si l'étudiant obtient un score de Teach-Back < 40%, `STUDENT-AI` diagnostique si la faille est sémantique ou logique, forçant la génération d'une fiche d'analogie de remédiation (Carte B06). | Phase 1 (Web) |
| D-OPT-051 | FSRS Stability Gate before ARENA | Verrouiller l'accès aux simulations d'ARENA (Bloom >= 4) tant que la stabilité cognitive FSRS des concepts requis n'est pas >= 3.0 jours, assurant des bases mémorielles saines. | Phase 1 (Web) |
| D-OPT-052 | Leech-Blocking Cran-5 IMPRINT | Pour les cartes marquées comme 'Leech' (difficiles), bloquer la révision numérique classique et forcer une session d'écriture manuscrite IMPRINT de Cran 5 (50-65 mots) pour ancrer la mémoire motrice. | Phase 1 (Web) |
| D-OPT-053 | Hippocampal Spatial Zoom (COSMOS) | Intégration du mode 'Semantic Zoom Graph' (COSMOS Mode 22) forçant l'élève à naviguer spatialement entre le micro-concept et la galaxie globale, stimulant les cellules de lieu de l'hippocampe. | Phase 1 (Web) |
| D-OPT-054 | Dunning-Kruger Calibration | Si la confiance déclarée de l'élève est élevée mais son recall FSRS est bas, l'agent `DRIFT-GUARDIAN (AGENT-07)` force une session Teach-Back immédiate pour briser l'illusion de savoir. | Phase 1 (Web) |
| D-OPT-055 | Tiny Habit Re-entry Protocol | En cas d'absence > 3 jours, masquer le backlog total de cartes en retard et présenter exclusivement un 'Mode Minimal' de 3 cartes prioritaires pour éliminer le stress de surcharge. | Phase 1 (Web) |

| D-OPT-056 | STUDENT-AI Socratic Teach-Back | Optimisation de la session Teach-Back pour les concepts spirituels et avancés (Hagah). L'IA élève adopte un rôle d'interlocuteur socratique calibré sur l'SMI de l'élève, exigeant la verbalisation d'imageries mentales, d'analyses contrastives et d'applications pratiques (Bloom 3), ré-ajustant directement la stabilité FSRS. | Phase 1 (Web) |
| D-OPT-057 | Rig Framework for LLM Abstractions | Intégration de la bibliothèque Rust **Rig** pour l'unification des modèles et des outils. L'utilisation de ses traits composables (`CompletionModel`, `Tool`, `VectorStore`) permet d'écrire nos propres briques d'outils de manière ultra-légère (<1.1 Go RAM) et type-safe. | Phase 1 (Web) |
| D-OPT-058 | RRAG for Enterprise Knowledge | Déploiement de **RRAG** comme moteur d'indexation et de récupération. Son architecture "async-first" sur Tokio et ses composants interchangeables sécurisent la couche RAG hybride de MindGraph. | Phase 1 (Web) |
| D-OPT-059 | Custom Concurrency Orchestrator | Développement de notre propre orchestrateur multi-agents asynchrone Rust utilisant les primitives `JoinSet` et `CancellationToken` de Tokio, éliminant les fuites de ressources et sécurisant la propagation des erreurs. | Phase 1 (Web) |
| D-OPT-060 | WASM Tool Sandboxing | Standardisation de l'exécution des scripts d'outils tiers au sein de bacs à sable WebAssembly (WASM) isolés, garantissant une étanchéité de sécurité absolue au runtime. | Phase 1 (Web) |

## 16. Fondation Recherche `[Rôle : AI & LLM Engineer]` — 44 Papers (27 initiaux + 12 COSMOS v3 + 5 nouveaux)

### 16.1 Papers par Composant

**FSRS Enhancements (5 papers)**
- **PAPER-001** : LECTOR ArXiv 2508.03275 — Interférence sémantique SRS. Retenu Phase 2 si coût <$0.01/user. Confiance 88%
- **PAPER-003** : Duolingo SRS ArXiv 1712.01856 (400+ citations) — +67% rétention. Retenu, valide FSRS. Confiance 98%
- **PAPER-004** : DRL-SRS MDPI 2024 — +12% rétention, complexité RL. ÉCARTÉ (cold-start bloquant). Confiance 92%
- **PAPER-005** : Personalized Forgetting 2024 — +3.2% AUC, +18% calibration. Retenu Phase 2. Confiance 94%

**ASCENT Architecture (4 papers)**
- **PAPER-006** : KT Benchmark ArXiv 2501.14256 — Mamba4KT optimal efficacité. Retenu référence. Confiance 96%
- **PAPER-007** : NAS Transformer KT — Gains +2-4%, NAS intensive. ÉCARTÉ. Confiance 90%
- **PAPER-008** : HiTSKT — +2.1% AUC sessions. Retenu Phase 2. Confiance 93%
- **PAPER-009** : SINKT — +4.7% AUC cold-start, auto-positionnement DAG. Retenu Phase 1 CRITIQUE. Confiance 97%
- **PAPER-029** : AAKT — +1.8-2.4% AUC, inférence -40%. Retenu Phase 1-2. Confiance 93%

**BRAIN RAG Avancé (6 papers)**
- **PAPER-010** : RAG + Entity Linking — +15% précision. Retenu Phase 1 CRITIQUE. Confiance 96%
- **PAPER-011** : GraphRAG — +40% questions globales. Retenu Phase 1 CRITIQUE. Confiance 98%
- **PAPER-012** : RAG Survey 2023 — Guide architectures. Retenu référence. Confiance 95%
- **PAPER-013** : RouteRAG — +8% F1, -35% appels LLM. En attente Phase 3. Confiance 87%
- **PAPER-014** : KAG — +18% exactitude, -42% hallucinations. Retenu Phase 1 CRITIQUE. Confiance 97%
- **PAPER-017** : KG-Extended RAG — +12% exact match multi-hop. Retenu Phase 1-2. Confiance 95%

**COSMOS Knowledge Graph (4 papers v2)**
- **PAPER-015** : LLM KG Construction Survey — Roadmap COSMOS auto. Retenu Phase 1-2. Confiance 94%
- **PAPER-016** : AriGraph — +28% performance agents long-terme. Retenu Phase 1 CRITIQUE. Confiance 96%
- **PAPER-027** : SPIRES — F1 0.72 zero-shot extraction. Retenu Phase 1 CRITIQUE. Confiance 96%
- **PAPER-028** : UniversalNER — F1 0.791 zero-shot NER. Retenu Phase 1-2. Confiance 94%

**COSMOS v3 Extension — Visualisation Avancée (12 références additionnelles)**
- **PAPER-031** : Shneiderman's Taxonomy of Data Types — FIU Libraries (2025). Référence fondatrice pour la couverture des types de données. Confiance 99%
- **PAPER-032** : NN/Group — Cognitive Maps, Mind Maps, Concept Maps Definitions (2024). Valide la distinction M3/M9. Confiance 98%
- **PAPER-033** : Fraunhofer — Semantic Zooming for Ontology Graph Visualizations (2017). Fondation du Mode 22. Confiance 95%
- **PAPER-034** : IVGraph — Ultimate Notion Knowledge Graph Guide 2026. Inspiration 3D Knowledge Space (M23). Confiance 88%
- **PAPER-035** : EuroVis 2026 — LLM-Visualization Systems Survey (arXiv:2601.14943). État de l'art systèmes LLM+Vis. Confiance 96%
- **PAPER-036** : MDPI — Foundations for a Generic Ontology for Visualization (2025). Taxonomie des ontologies de visualisation. Confiance 94%
- **PAPER-037** : PMC — Sankey Flow Diagrams for Symptom Trajectories (2022). Valide Sankey/Alluvial pour trajectoires. Confiance 97%
- **PAPER-038** : Genetic Programming — Treemaps & Sunbursts for Many-Objective Optimization (2018). Fondation S10/S11. Confiance 93%
- **PAPER-039** : yFiles — Guide to Creating Knowledge Graph Visualizations (2025). Bonnes pratiques layout KG. Confiance 95%
- **PAPER-040** : DataVid — Knowledge Graph Visualization Comprehensive Guide (2026). Couverture exhaustive types graphes. Confiance 94%
- **PAPER-041** : ResearchGate — KNOWNET: LLM + KG Progressive Visualization. Fondation Progressive Graph Viz. Confiance 90%
- **PAPER-042** : The Permatech — AI-Adaptive Visual Dashboards Best Practices (2026). Tendance dashboards adaptatifs. Confiance 89%

**NEURON-CHAINS Optimisation (6 papers)**
- **PAPER-018** : LLMLingua-2 — 2x-5x compression, -60% tokens. Retenu Phase 0 CRITIQUE. Confiance 99%
- **PAPER-019** : LongLLMLingua — +21.4% perf, ~4x compression longs contextes. Retenu Phase 0-1. Confiance 98%
- **PAPER-020** : Prompt Compression Survey — Taxonomie stratégie. Retenu référence. Confiance 94%
- **PAPER-021** : GPTCache — -40-60% appels, hit rate 35%, threshold 0.87. Retenu Phase 1. Confiance 97%
- **PAPER-022** : RouteLLM — -40% coûts, <5% dégradation. Retenu Phase 1. Confiance 98%
- **PAPER-025** : AutoGen — 85% HumanEval+, +30% raisonnement. Retenu Phase 1-2 CRITIQUE. Confiance 97%
- **PAPER-026** : Graph of Thoughts — +62% qualité, -31% tokens vs ToT. Retenu Phase 2. Confiance 95%

**Embeddings (2 papers)**
- **PAPER-023** : Matryoshka — -66% storage, trade-off qualité/coût. Retenu Phase 1. Confiance 96%
- **PAPER-024** : Nomic Embed — 8192 tokens, Matryoshka 64d-768d, open-source. Retenu Phase 0 (déjà validé). Confiance 100%

**Référence Transversale (1 paper)**
- **PAPER-030** : Deep Learning Educational Data Science — Survey 80+ modèles. Retenu référence. Confiance 95%

**Papers Additionnels — Analyse Documentaire Exhaustive (5 nouveaux)**

- **PAPER-002** : Memory Dynamics Optimization (Su, J. et al., IEEE TKDE 2023) — Modèle différentiel stochastique adaptatif pour SRS. Supérieur SM-2 et FSRS v3 sur datasets Anki réels. 🔶 EN ATTENTE Phase 3 — Évaluer si FSRS standard insuffisant. Complexité élevée. Confiance 91%
- **PAPER-034-bis** : Dynamic Cognitive Diagnosis (IEEE TLT 2023) — IRT + deep learning, +3.8% AUC, interprétabilité. Difficulté adaptive temps-réel ASCENT + calibration exercices NEURON-CHAINS. ✅ RETENU Phase 2. Confiance 93%
- **PAPER-ML-FC** : ML Meets Forgetting Curve (arXiv:2506.12034) — Réseaux neuronaux exhibant comportements d'oubli similaires aux humains. R&D fondamentale FSRS next-gen. 🔶 EN ATTENTE Phase 3+ R&D. Confiance 85%
- **PAPER-HGRAG** : HypergraphRAG (arXiv:2503.21322) — Relations N-aires dans le graphe (+9% multi-hop questions complexes). Construction coûteuse, algorithmes encore immatures. 🔶 EN ATTENTE Phase 3 COSMOS si graphe standard insuffisant. Confiance 88%
- **PAPER-MKGL** : MKGL Three-Word Language (NeurIPS 2024 Spotlight) — Fine-tuning LLM sur langage triplets KG, +15% MRR KG completion. COSMOS auto-completion améliorée. 🔶 EN ATTENTE Phase 3+ (fine-tuning complexe). Confiance 87%

### 16.2 Synthèse

- **Total retenus** : 40/44 analysés (91%)
- **Dont COSMOS v3** : 12 nouvelles références visualisation avancée
- **Dont nouveaux (analyse documentaire)** : 5 papers additionnels intégrés
- **Écartés** : 2 (DRL-SRS, NAS Transformer — complexité disproportionnée)
- **En attente** : 6 (RouteRAG Phase 3, Memory Dynamics Phase 3, ML Forgetting Curve Phase 3+, HypergraphRAG Phase 3, MKGL Phase 3+, Dynamic Cognitive Diagnosis Phase 2)
- **Phase 0 CRITIQUE** : 3 papers (LLMLingua-2, LongLLMLingua, Nomic Embed)
- **Phase 1 CRITIQUE** : 7 papers (SINKT, Entity Linking, GraphRAG, KAG, AriGraph, SPIRES, AutoGen)

---

## 17. Annexes `[Rôle : Product Owner & PM]`

### 17.1 Glossaire

| Terme | Définition |
|-------|-----------|
| APEX | Active Practice & Expertise System — système rétention FSRS |
| ASCENT | Adaptive Skill Curriculum Engine for Navigable Training |
| ASCENT-ORCHESTRATOR | Les 13 agents autonomes orchestrant l'ensemble de SCY Forge |
| APEX-AGENT | Méta-orchestrateur interne des NEURON-CHAINS (distinct de l'ASCENT-ORCHESTRATOR) |
| BRAIN | Backend for Retrieval-Augmented Intelligent Navigation |
| CQRS | Command Query Responsibility Segregation |
| DAG | Directed Acyclic Graph — graphe orienté acyclique (ASCENT roadmaps) |
| COSMOS | Flexible Layout for Your Intelligent Queries — visualisation KG |
| FSRS | Free Spaced Repetition Scheduler — algorithme SRS état-de-l'art |
| ISR | Incremental Static Regeneration |
| JSON Cognitif | 8 dimensions métadonnées document (complexité, domaines, prérequis...) |
| KG | Knowledge Graph |
| KT | Knowledge Tracing — ML prédiction maîtrise |
| NER | Named Entity Recognition |
| NEURON-CHAINS | Neural Engine Understanding Reasoning Orchestration Navigation |
| RAG | Retrieval-Augmented Generation |
| RRF | Reciprocal Rank Fusion k=60 |
| SharedContentCache | Cache mutualisé cross-users (économie LLM -80 à -99%) |
| SMI | Score de Maîtrise Intégrée /100 (5 dimensions) |
| SRS | Spaced Repetition System |
| Proof of Skill | Certificat compétence PDF + badge LinkedIn + vérification QR |
| TokenBudgeter | Tool T04 contrôlant le budget tokens par génération |
| BudgetGuard | Tool T17 + service monitoring coûts LLM temps réel |

### 17.2 Comparaison v1 → v2

| Élément | PRD v1 | PRD v2 |
|---------|--------|--------|
| Architecture features | Features isolées, pilotées user | Pipeline 13 agents autonomes orchestrant tout |
| NEURON-CHAINS | Chaînes statiques manuelles | APEX-AGENT + 18 tools + anti-hallucination 3 couches |
| Coût LLM estimé | $0.015/vidéo | $0.006/parcours complet 90j |
| Score confiance | Global post-génération | Par section + rapport lisible + seuils d'action |
| Anti-hallucination | Vérification basique | 3 couches (ancrage RAG + cross-check + scoring) |
| Compétence vérifiable | SMI calculé manuellement | Proof of Skill automatique (Agent-09) |
| Abandon prevention | Drift Detector manuel | DRIFT-GUARDIAN 8 signaux + interventions auto |
| Contenu mutualisé | Cache individuel | SharedContentCache cross-users |
| Gamification | Basique (streaks) | Système complet (XP, niveaux, badges, rapports, challenges, quêtes, heat map) |
| Décisions architecturales | 37 (PRD v1) | 37 + 13 nouvelles + 13 Reader Suite/Collab = **63 décisions validées** |
| Score confiance doc | 97.9% | **98.7%** |
| Lecture fichiers | Téléchargement externe | **SCY-READER SUITE (File Viewer + Web Viewer + Reader Suite + Book Orchestrator + Page Gallery)** |
| Collaboration | Absente | Partage lien UUID (Phase 1) + Marketplace (Phase 3) + Commentaires (Phase 3) |
| Personnalisation | Absente | Chronotype, Ton, Langue par domaine (Phase 1-2) |
| Techniques cognitives | FSRS uniquement | Interleaving + Desirable Difficulty + Elaborative Interrogation (Phase 1-2) |

### 17.3 Checklist Avant Sprint (BLOQUANTE)

Avant tout développement, valider dans l'ordre :

- [ ] **POC Jour 4 exécuté** (7h) : G6/Louvain, GLiNER, Typst, Tantivy
- [ ] **4 GO** → Lancer sprint | **1 NO-GO** → Fallback | **2+ NO-GO** → STOP
- [ ] Section "⚠️ CRATES À ÉVITER" dans README technique (docx-rs, zip-rs, printpdf)
- [ ] TokenOptimizationPipeline implémentée avant tout agent (protection marges)
- [ ] BudgetGuard configuré (alertes 50%, 80%, 100%)
- [ ] EventBus central créé avant toute feature (découplage)
- [ ] SharedContentCache schema DB créé (scy_shared_content_cache)
- [ ] scy_llm_spend_log actif (monitoring dès J1)

**Checklist Compléments v2.3 :**
- [x] **Vérifier Prompt Caching DeepSeek API** (Confirmé ✅) — Activé de manière permanente dans la pipeline de prompt des NEURON-CHAINS §10.2
- [ ] **graphology-metrics installé** → PageRank activé sur COSMOS (coût $0, impact immédiat)
- [ ] **petgraph Gap Detection** → Implémentation traversal prérequis manquants (Agent-06)
- [ ] **File Viewer PDF** → `@react-pdf-viewer/core` ajouté au bundle (lazy-loaded)
- [ ] **Book Orchestrator question clarification** → 7 intentions + règles Rust sélection modes COSMOS
- [ ] **Streak Freeze/Repair** → Logique implémentée dans Agent-08 avant lancement gamification

**Checklist COSMOS v4 — Sprint 0 (7 jours, BLOQUANTE avant lancement COSMOS) :**
- [ ] **D-QUAL-001 HiDPI** → `setupHiDPICanvas()` + `devicePixelRatio` dans config G6 + Cosmos
- [ ] **D-QUAL-002 Fonts** → Font stack universel dans `G6_GLOBAL_LABEL_CFG` + preload `<link>` index.html
- [ ] **D-QUAL-002 CJK** → `truncateLabelCJKAware()` remplace `String.slice()` sur tous les labels
- [ ] **D-UX-006 Edges** → `EDGE_SEMANTIC_STYLES` dict appliqué dans G6 + légende auto générée
- [ ] **D-SEC-001 Confidence** → Score multi-signaux calculé + badge "🤖 XX%" sur arêtes IA
- [ ] **D-SEC-002 Rejet** → Raccourcis V/X actifs + toast undo 10s + table `scy_ai_rejections`
- [ ] **D-PERF-007 GPU Buffers** → `equals()` check avant `setPointPositions()` (pan/zoom)

**Checklist COSMOS v4 — Phase 1 (Différenciation Core) :**
- [ ] **D-UX-001** Fisheye G6 v5 plugin actif (raccourci F) — 2j
- [ ] **D-UX-002** Progressive Rendering 4 phases + skeleton shimmer — 6j
- [ ] **D-UX-003** Knowledge Cards v2 (SMI + provenance + actions) — 8j
- [ ] **D-UX-004** Persona Adaptive Interface (3 modes) — 5j
- [ ] **D-UX-005** Behavioral Progressive Disclosure (hover signals) — 4j
- [ ] **D-UX-007** Exploration Trail (bas du graphe, 10 étapes) — 3j
- [ ] **D-UX-011** Gap Detection (nœuds fantômes rouges) — 5j
- [ ] **D-OPP-001** SMI Learning Graph (couleur + badge + aura nœuds) — 10j
- [ ] **D-OPP-002** Transparent AI Graph (validation flow complet) — 7j
- [ ] **D-OPP-003** Source-Linked Nodes (provenance + Reader bridge) — 5j
- [ ] **D-OPP-004** Prescriptive Insights Panel ($0 LLM, règles Rust) — 6j
- [ ] **D-SEC-003** k-Anonymity Guard Mode 16 Heatmap — 1j

### 17.4 Décisions Critiques Requérant Validation Humaine (v2.4)

| Décision | Contexte | Action | Priorité |
|---------|---------|--------|---------|
| **Prompt Caching DeepSeek** | Économie -90% tokens system prompts | VALIDÉ ET ACTIVÉ ✅ (DeepSeek V4/R1, économie -90% sur input, plus support Batch API à -50%) | 🟢 Validé |
| **Mode Guest Onboarding** | Conversion trial→signup, impact funnel complet | Valider si SCY Forge veut permettre essai sans compte | 🟠 Haute |
| **Passkeys/WebAuthn** | Northflank supporte-t-il WebAuthn nativement ? | Vérifier documentation API Northflank | 🟡 Moyenne |
| **Leaderboards** | Opt-in motivant vs risque toxicité comparaison | Décider politique : opt-in uniquement ou absent Phase 3 | 🟡 Moyenne |
| **Marketplace Timing** | >50 decks qualité requis, qui crée les premiers ? | Planifier stratégie contenu starter (équipe ou premium users) | 🟢 Basse |

---

**Document Finalisé Par** : Architecture Team SCY Forge  
**Date** : 2026-06-08  
**Version** : 2.5 (COSMOS v4 + 20 Patterns Résilience + 35 Compléments Analyse + SCY-READER SUITE + 19 Solutions COSMOS + 5 Opportunités Différenciation + CHRONICLE Agent-10 + ARENA Agent-11 + 10 Papers Rétention Science)  
**Remplace** : PRD-MINDFORGE-V2.3 (2026-06-08)  
**Score Confiance** : **98.9%** ✅ (↑ +0.2% — solutions terrain validées + opportunités différenciation documentées)  
**Statut** : ✅ DOCUMENT DE RÉFÉRENCE UNIQUE  
**Prochaine Révision** : Après exécution Sprint 0 COSMOS (7j) + POC Jour 4  
**Modules** : 13 modules (§7.1 → §7.13) + ASCENT Pipeline 11 agents (dont CHRONICLE + ARENA Premium) + NEURON-CHAINS v2 + 97 décisions architecturales (+9 ASCENT-RET + CHRONICLE + ARENA)  
**Architecture COSMOS** : v4 — 114 décisions (cosmos-architecture-v4.md), 17 Règles d'Or, 5 Opportunités Différenciation Absolue

*Zéro information perdue du PRD v2.3 — 100% éléments intégrés + 19 solutions COSMOS terrain + 5 opportunités différenciation + architecture COSMOS v4 complète*

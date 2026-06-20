-- =========================================================================
-- SCY FORGE — DATABASE SCHEMA & RLS CONSOLIDATION (SPRINT 0)
-- Platform: Northflank PostgreSQL (RLS enabled, default tenant partitioning)
-- Date: 2026-06-20
-- Status: 🟢 SPRINT 0 IMMUABLE INITIALIZATION SCRIPT
-- =========================================================================

-- Enable UUID v7 generation or default fallback uuid extension if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================================================================
-- 1. BASE SYSTEM & USERS
-- =========================================================================

CREATE TABLE IF NOT EXISTS scy_users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email           TEXT UNIQUE NOT NULL,
    tenant_id       TEXT NOT NULL,        -- Company/institution isolation key
    current_smi     REAL DEFAULT 50.0,    -- Systemic Mastery Index (0-100)
    created_at      INTEGER NOT NULL
);

-- Enable RLS for users
ALTER TABLE scy_users ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see their own user record
CREATE POLICY user_isolation_policy ON scy_users
    FOR ALL
    USING (id = current_setting('app.current_user_id', true)::UUID);

-- =========================================================================
-- 2. INGESTION & DOCUMENT CORES
-- =========================================================================

CREATE TABLE IF NOT EXISTS scy_documents (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
    title           TEXT NOT NULL,
    parsed_markdown TEXT NOT NULL,        -- Raw structured output from Docling (0$ cost)
    metadata        JSONB,                -- DOI, timestamps, has_code, has_math...
    created_at      INTEGER NOT NULL
);

ALTER TABLE scy_documents ENABLE ROW LEVEL SECURITY;

CREATE POLICY doc_isolation_policy ON scy_documents
    FOR ALL
    USING (user_id = current_setting('app.current_user_id', true)::UUID);


CREATE TABLE IF NOT EXISTS scy_chunks (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id     UUID NOT NULL REFERENCES scy_documents(id) ON DELETE CASCADE,
    content         TEXT NOT NULL,
    vector_id       TEXT NOT NULL,        -- Vector reference pointing to local/Zilliz store
    created_at      INTEGER NOT NULL
);

ALTER TABLE scy_chunks ENABLE ROW LEVEL SECURITY;

-- Subquery policy to enforce user isolation transitively on chunks
CREATE POLICY chunk_isolation_policy ON scy_chunks
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM scy_documents d 
            WHERE d.id = scy_chunks.document_id 
            AND d.user_id = current_setting('app.current_user_id', true)::UUID
        )
    );

-- =========================================================================
-- 3. NORMAL MODE PROJECTS & SUGGESTIONS
-- =========================================================================

CREATE TABLE IF NOT EXISTS scy_projects (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
    title           TEXT NOT NULL,
    description     TEXT,
    created_at      INTEGER NOT NULL,
    updated_at      INTEGER NOT NULL
);

ALTER TABLE scy_projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY project_isolation_policy ON scy_projects
    FOR ALL
    USING (user_id = current_setting('app.current_user_id', true)::UUID);


CREATE TABLE IF NOT EXISTS scy_project_sources (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id      UUID NOT NULL REFERENCES scy_projects(id) ON DELETE CASCADE,
    core_type       TEXT NOT NULL,        -- 'youtube', 'web', 'academic', 'financial'...
    source_title    TEXT NOT NULL,
    raw_input       TEXT NOT NULL,
    parsed_content  TEXT NOT NULL,        -- Clean markdown extract from Docling
    metadata        JSONB,
    created_at      INTEGER NOT NULL
);

ALTER TABLE scy_project_sources ENABLE ROW LEVEL SECURITY;

CREATE POLICY source_isolation_policy ON scy_project_sources
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM scy_projects p 
            WHERE p.id = scy_project_sources.project_id 
            AND p.user_id = current_setting('app.current_user_id', true)::UUID
        )
    );


CREATE TABLE IF NOT EXISTS scy_project_suggestions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id      UUID NOT NULL REFERENCES scy_projects(id) ON DELETE CASCADE,
    suggested_code  TEXT NOT NULL,        -- 'G01', 'S01', 'C01'...
    suggested_name  TEXT NOT NULL,
    why_suggested   TEXT NOT NULL,        -- Explanation computed by Agent-14
    created_at      INTEGER NOT NULL
);

ALTER TABLE scy_project_suggestions ENABLE ROW LEVEL SECURITY;

CREATE POLICY suggestion_isolation_policy ON scy_project_suggestions
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM scy_projects p 
            WHERE p.id = scy_project_suggestions.project_id 
            AND p.user_id = current_setting('app.current_user_id', true)::UUID
        )
    );


CREATE TABLE IF NOT EXISTS scy_project_deliverables (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id              UUID NOT NULL REFERENCES scy_projects(id) ON DELETE CASCADE,
    user_id                 UUID NOT NULL REFERENCES scy_users(id),
    deliverable_type        TEXT NOT NULL, -- 'suggested_doc', 'custom_doc', 'apex_cards', 'cosmos_map', 'imprint_primer'
    document_code           TEXT,          -- 'G01', 'S01', 'C01'...
    title                   TEXT NOT NULL,
    content                 TEXT,          -- Authored by APEX-AGENT (Rust)
    visualization_data      JSONB,         -- Structural graphics for COSMOS Engine
    user_custom_description TEXT,          -- User's prompt guidelines
    status                  TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'generating', 'completed', 'failed'
    confidence_score        INTEGER,       -- Quality assurance index (PQS)
    created_at              INTEGER NOT NULL,
    completed_at            INTEGER
);

ALTER TABLE scy_project_deliverables ENABLE ROW LEVEL SECURITY;

CREATE POLICY deliverable_isolation_policy ON scy_project_deliverables
    FOR ALL
    USING (user_id = current_setting('app.current_user_id', true)::UUID);

-- =========================================================================
-- 4. NEUROLOGICAL ENGINE & MEMORY VAULTS
-- =========================================================================

CREATE TABLE IF NOT EXISTS scy_synaptic_vitality (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
    node_id             UUID NOT NULL,        -- Polymorphic ID referencing ascent node or concept
    node_type           TEXT NOT NULL,        -- 'ascent_node' | 'concept'
    retention_score     REAL DEFAULT 100.0,   -- Retention metric (FSRS 5.0)
    connection_score    REAL DEFAULT 0.0,     -- Degree centralities from Graphiti
    mobilization_score  REAL DEFAULT 0.0,     -- Frequency of chats or notes mentions
    vitality_score      REAL DEFAULT 100.0,   -- Calculated via Sigmoidal equation (0-100)
    temperature         REAL DEFAULT 50.0,    -- Thermodynamic temperature metric (0-100)
    last_interaction_at INTEGER NOT NULL,
    updated_at          INTEGER NOT NULL
);

ALTER TABLE scy_synaptic_vitality ENABLE ROW LEVEL SECURITY;

CREATE POLICY vitality_isolation_policy ON scy_synaptic_vitality
    FOR ALL
    USING (user_id = current_setting('app.current_user_id', true)::UUID);


CREATE TABLE IF NOT EXISTS scy_engram_vault (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
    node_id         UUID NOT NULL,
    title           TEXT NOT NULL,
    content_payload JSONB NOT NULL,       -- Compressed data payload of the dormant knowledge card
    keywords        TEXT[] NOT NULL,      -- Retrieval hints used for active resurrection socratic efforts
    dormant_since   INTEGER NOT NULL,
    attempts_count  INTEGER DEFAULT 0
);

ALTER TABLE scy_engram_vault ENABLE ROW LEVEL SECURITY;

CREATE POLICY vault_isolation_policy ON scy_engram_vault
    FOR ALL
    USING (user_id = current_setting('app.current_user_id', true)::UUID);


CREATE TABLE IF NOT EXISTS scy_forge_attempts (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
    node_id         UUID NOT NULL,
    attempt_text    TEXT NOT NULL,
    semantic_score  REAL NOT NULL,        -- Evaluated by APEX-AGENT via cosine similarity
    is_unlocked     BOOLEAN DEFAULT false,
    created_at      INTEGER NOT NULL
);

ALTER TABLE scy_forge_attempts ENABLE ROW LEVEL SECURITY;

CREATE POLICY attempt_isolation_policy ON scy_forge_attempts
    FOR ALL
    USING (user_id = current_setting('app.current_user_id', true)::UUID);


CREATE TABLE IF NOT EXISTS scy_synaptic_pruning_log (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
    activated_node_id UUID NOT NULL,
    suppressed_node_id UUID NOT NULL,
    suppression_delta REAL NOT NULL,
    created_at      INTEGER NOT NULL
);

ALTER TABLE scy_synaptic_pruning_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY pruning_isolation_policy ON scy_synaptic_pruning_log
    FOR ALL
    USING (user_id = current_setting('app.current_user_id', true)::UUID);

-- =========================================================================
-- 5. CREATOR & COHORT MANAGEMENT
-- =========================================================================

CREATE TABLE IF NOT EXISTS scy_creator_cohorts (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id      UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
    title           TEXT NOT NULL,
    created_at      INTEGER NOT NULL
);

ALTER TABLE scy_creator_cohorts ENABLE ROW LEVEL SECURITY;

CREATE POLICY cohort_isolation_policy ON scy_creator_cohorts
    FOR ALL
    USING (creator_id = current_setting('app.current_user_id', true)::UUID);


CREATE TABLE IF NOT EXISTS scy_creator_insights (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cohort_id           UUID NOT NULL REFERENCES scy_creator_cohorts(id) ON DELETE CASCADE,
    node_id             UUID NOT NULL,        -- Course node where block occurred
    failure_rate        REAL NOT NULL,        -- E.g. 0.80 if 80% failure rate
    cognitive_block     TEXT NOT NULL,        -- Written analysis from Agent-13
    status              TEXT NOT NULL DEFAULT 'open', -- 'open' | 'resolved'
    created_at          INTEGER NOT NULL
);

ALTER TABLE scy_creator_insights ENABLE ROW LEVEL SECURITY;

CREATE POLICY insight_isolation_policy ON scy_creator_insights
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM scy_creator_cohorts c 
            WHERE c.id = scy_creator_insights.cohort_id 
            AND c.creator_id = current_setting('app.current_user_id', true)::UUID
        )
    );


CREATE TABLE IF NOT EXISTS scy_creator_clarifications (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    insight_id          UUID NOT NULL REFERENCES scy_creator_insights(id) ON DELETE CASCADE,
    clarification_text  TEXT,
    media_url           TEXT,                 -- Media link to video/audio memo
    created_at          INTEGER NOT NULL
);

ALTER TABLE scy_creator_clarifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY clarification_isolation_policy ON scy_creator_clarifications
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM scy_creator_insights i
            JOIN scy_creator_cohorts c ON c.id = i.cohort_id
            WHERE i.id = scy_creator_clarifications.insight_id
            AND c.creator_id = current_setting('app.current_user_id', true)::UUID
        )
    );

-- =========================================================================
-- 6. SYSTEM OBSERVABILITY, TELEMETRY & SPEND LOGGER
-- =========================================================================

CREATE TABLE IF NOT EXISTS scy_agent_decisions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
    session_id      UUID NOT NULL,
    agent_id        TEXT NOT NULL,        -- 'visual-critic', 'cognitive-validator', etc.
    decision        TEXT NOT NULL,        -- 'approved', 'rejected'
    schema_errors   JSONB,                -- Zod schema errors captured by Harmonist
    created_at      INTEGER NOT NULL
);

ALTER TABLE scy_agent_decisions ENABLE ROW LEVEL SECURITY;

CREATE POLICY decision_isolation_policy ON scy_agent_decisions
    FOR ALL
    USING (user_id = current_setting('app.current_user_id', true)::UUID);


CREATE TABLE IF NOT EXISTS scy_llm_spend_log (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
    session_id      UUID NOT NULL,
    tokens_input    INTEGER NOT NULL,
    tokens_output   INTEGER NOT NULL,
    cost_usd        REAL NOT NULL,        -- Computed in real-time via Langfuse/LiteLLM
    created_at      INTEGER NOT NULL
);

ALTER TABLE scy_llm_spend_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY spend_isolation_policy ON scy_llm_spend_log
    FOR ALL
    USING (user_id = current_setting('app.current_user_id', true)::UUID);

-- =========================================================================
-- 7. PERFORMANCE & COGNITIVE OPTIMIZATION INDEXES
-- =========================================================================

CREATE INDEX IF NOT EXISTS idx_users_tenant ON scy_users(tenant_id);
CREATE INDEX IF NOT EXISTS idx_documents_user_id ON scy_documents(user_id);
CREATE INDEX IF NOT EXISTS idx_chunks_document_id ON scy_chunks(document_id);
CREATE INDEX IF NOT EXISTS idx_projects_user_id ON scy_projects(user_id);
CREATE INDEX IF NOT EXISTS idx_project_sources_project_id ON scy_project_sources(project_id);
CREATE INDEX IF NOT EXISTS idx_project_suggestions_project_id ON scy_project_suggestions(project_id);
CREATE INDEX IF NOT EXISTS idx_project_deliverables_user_project ON scy_project_deliverables(user_id, project_id);
CREATE INDEX IF NOT EXISTS idx_vitality_user_score ON scy_synaptic_vitality(user_id, vitality_score);
CREATE INDEX IF NOT EXISTS idx_engram_user_dormant ON scy_engram_vault(user_id, dormant_since);
CREATE INDEX IF NOT EXISTS idx_forge_attempts_user_node ON scy_forge_attempts(user_id, node_id);
CREATE INDEX IF NOT EXISTS idx_pruning_user_activated ON scy_synaptic_pruning_log(user_id, activated_node_id);
CREATE INDEX IF NOT EXISTS idx_creator_insights_cohort_status ON scy_creator_insights(cohort_id, status);
CREATE INDEX IF NOT EXISTS idx_agent_decisions_user_id ON scy_agent_decisions(user_id);
CREATE INDEX IF NOT EXISTS idx_llm_spend_log_user_id ON scy_llm_spend_log(user_id);

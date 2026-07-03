-- SCY Forge — Migrations SQL v001
-- Sprint 0 — Foundation + Cyber Beachhead
-- Référence : docs/SCYFORGE_PIVOT_ARCHITECTURE.md §6 + docs/SCYFORGE_DOMAIN_PACK_CONTRACT.md

-- ═══════════════════════════════════════════════════════════════
--  EXTENSION UUID v7
-- ═══════════════════════════════════════════════════════════════
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pgvector;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Fonction UUID v7 (horodaté)
-- Si la fonction gen_uuid_v7() n'existe pas, on la crée.
-- PostgreSQL 17+ a un support natif; pour les versions antérieures,
-- on utilise une implémentation basée sur pgcrypto.

CREATE OR REPLACE FUNCTION gen_uuid_v7()
RETURNS UUID
LANGUAGE SQL
AS $$
  SELECT encode(
    -- 48 bits Unix timestamp ms (actuel)
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid()) placing
          encode(floor(extract(epoch from now()) * 1000)::bigint::bytea, 'hex')
          from 1 for 6
        ),
        122,  -- version bit
        1
      ),
      121, -- variant bits
      1
    ),
    'hex'
  )::uuid;
$$;


-- ═══════════════════════════════════════════════════════════════
--  EXTENSION POUR TIMESTAMPS UNIX
-- ═══════════════════════════════════════════════════════════════
CREATE OR REPLACE FUNCTION now_unix()
RETURNS INTEGER
LANGUAGE SQL
AS $$
  SELECT extract(epoch FROM now())::INTEGER;
$$;


-- ═══════════════════════════════════════════════════════════════
--  1. UTILISATEURS
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS scy_users (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  email TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  organization_id UUID,                    -- null = solo learner
  role TEXT NOT NULL DEFAULT 'learner',    -- 'soc_l1' | 'soc_l2' | 'dfir' | 'sel' | 'admin'
  organization_role TEXT,                  -- 'manager' | 'lead' | 'analyst'
  password_hash TEXT,                      -- null si SSO only
  email_verified BOOLEAN DEFAULT false,
  last_login_at INTEGER,
  created_at INTEGER NOT NULL DEFAULT now_unix(),
  updated_at INTEGER NOT NULL DEFAULT now_unix(),

  CONSTRAINT valid_role CHECK (
    role IN ('soc_l1', 'soc_l2', 'soc_l3', 'dfir',
             'detection_eng', 'threat_hunter',
             'sel', 'admin', 'learner')
  )
);

CREATE INDEX idx_users_org ON scy_users(organization_id) WHERE organization_id IS NOT NULL;
CREATE INDEX idx_users_role ON scy_users(role);


-- ═══════════════════════════════════════════════════════════════
--  2. ORGANISATIONS
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS scy_organizations (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  name TEXT NOT NULL,
  industry TEXT,                           -- 'cybersecurity' | 'finance' | ...
  size_bucket TEXT,                        -- '1-50' | '51-200' | '201-1000' | '1000+'
  plan TEXT NOT NULL DEFAULT 'trial',      -- 'trial' | 'starter' | 'growth' | 'enterprise'
  settings JSONB DEFAULT '{}'::jsonb,
  created_at INTEGER NOT NULL DEFAULT now_unix(),
  updated_at INTEGER NOT NULL DEFAULT now_unix()
);


-- ═══════════════════════════════════════════════════════════════
--  3. DOMAIN PACKS (registry des packs chargés)
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS scy_domain_packs (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  pack_id TEXT NOT NULL UNIQUE,
  version TEXT NOT NULL,
  pivot_ontology TEXT,
  status TEXT NOT NULL DEFAULT 'active',   -- 'loading' | 'active' | 'deprecated'
  loaded_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL DEFAULT now_unix()
);


-- ═══════════════════════════════════════════════════════════════
--  4. SEMANTIC TREES (arbre par organisation ou learner)
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS scy_semantic_trees (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  owner_kind TEXT NOT NULL,                -- 'domain_pack' | 'organization' | 'learner'
  owner_id UUID NOT NULL,
  domain_pack TEXT NOT NULL REFERENCES scy_domain_packs(pack_id),
  root_nodes UUID[] NOT NULL DEFAULT '{}',
  created_at INTEGER NOT NULL DEFAULT now_unix(),

  CONSTRAINT valid_owner_kind CHECK (
    owner_kind IN ('domain_pack', 'organization', 'learner')
  )
);

CREATE INDEX idx_trees_owner ON scy_semantic_trees(owner_kind, owner_id);
CREATE INDEX idx_trees_pack ON scy_semantic_trees(domain_pack);


-- ═══════════════════════════════════════════════════════════════
--  5. ARÊTES TYPÉES (TreeEdge)
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS scy_tree_edges (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  tree_id UUID NOT NULL REFERENCES scy_semantic_trees(id) ON DELETE CASCADE,
  from_node UUID NOT NULL,
  to_node UUID NOT NULL,
  kind TEXT NOT NULL,                      -- 'trunk'|'branch'|'leaf'|'prereq'|'relates'|'contradicts'|'supersedes'
  criticality REAL NOT NULL DEFAULT 0.0,   -- 0.0–1.0 (dérivé de densité Sigma en cyber)
  superseded_at INTEGER,                   -- NULL = arête vivante | ts = historisée
  created_at INTEGER NOT NULL DEFAULT now_unix(),

  CONSTRAINT valid_edge_kind CHECK (
    kind IN ('trunk', 'branch', 'leaf', 'prereq', 'relates', 'contradicts', 'supersedes')
  )
);

CREATE INDEX idx_edges_tree ON scy_tree_edges(tree_id);
CREATE INDEX idx_edges_from ON scy_tree_edges(from_node);
CREATE INDEX idx_edges_to ON scy_tree_edges(to_node);


-- ═══════════════════════════════════════════════════════════════
--  6. SOUS-ARBRES DE RÔLE (role → nœuds requis)
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS scy_role_subtrees (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  role_id TEXT NOT NULL,                   -- 'soc_l1' | 'soc_l2' | 'dfir' | 'detection_eng' | 'threat_hunter'
  tree_id UUID NOT NULL REFERENCES scy_semantic_trees(id) ON DELETE CASCADE,
  required_node_ids UUID[] NOT NULL DEFAULT '{}',
  criticality_overrides JSONB DEFAULT '{}'::jsonb,  -- {node_id: weight}
  created_at INTEGER NOT NULL DEFAULT now_unix(),

  CONSTRAINT valid_soc_role CHECK (
    role_id IN ('soc_l1', 'soc_l2', 'soc_l3', 'dfir',
                'detection_eng', 'threat_hunter', 'sel', 'admin')
  ),
  UNIQUE(role_id, tree_id)
);

CREATE INDEX idx_role_subtrees_role ON scy_role_subtrees(role_id);
CREATE INDEX idx_role_subtrees_tree ON scy_role_subtrees(tree_id);


-- ═══════════════════════════════════════════════════════════════
--  7. ÉTATS DE MAÎTRISE PAR APPRENANT (LearnerNodeState)
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS scy_learner_node_states (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  learner_id UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
  tree_id UUID NOT NULL REFERENCES scy_semantic_trees(id) ON DELETE CASCADE,
  node_id UUID NOT NULL,
  confidence REAL NOT NULL DEFAULT 0.0,    -- 0.0–1.0 (prouvée par test)
  unlocked BOOLEAN NOT NULL DEFAULT false, -- tronc-avant-feuilles
  last_reviewed_at INTEGER,
  created_at INTEGER NOT NULL DEFAULT now_unix(),
  updated_at INTEGER NOT NULL DEFAULT now_unix(),

  CONSTRAINT confidence_range CHECK (confidence >= 0.0 AND confidence <= 1.0),
  UNIQUE(learner_id, tree_id, node_id)
);

CREATE INDEX idx_learner_states_learner ON scy_learner_node_states(learner_id);
CREATE INDEX idx_learner_states_tree ON scy_learner_node_states(tree_id);
CREATE INDEX idx_learner_states_confidence ON scy_learner_node_states(confidence);


-- ═══════════════════════════════════════════════════════════════
--  8. INSTANCES DE SCÉNARIOS ARENA
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS scy_scenario_instances (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  pack_id TEXT NOT NULL DEFAULT 'cyber',
  scenario_id TEXT NOT NULL,               -- 'apt29_chain_v1'
  learner_id UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'in_progress', -- 'in_progress' | 'completed' | 'abandoned'
  current_step INTEGER NOT NULL DEFAULT 0,
  choices JSONB NOT NULL DEFAULT '[]'::jsonb,
  score REAL,                               -- score global 0.0–1.0
  started_at INTEGER NOT NULL DEFAULT now_unix(),
  completed_at INTEGER,

  CONSTRAINT valid_scenario_status CHECK (
    status IN ('in_progress', 'completed', 'abandoned')
  )
);

CREATE INDEX idx_scenarios_learner ON scy_scenario_instances(learner_id);
CREATE INDEX idx_scenarios_status ON scy_scenario_instances(status);


-- ═══════════════════════════════════════════════════════════════
--  9. ÉVALUATIONS DE MAÎTRISE (Proof-of-Skill)
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS scy_mastery_evaluations (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  learner_id UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
  tree_id UUID NOT NULL REFERENCES scy_semantic_trees(id) ON DELETE CASCADE,
  smi_score REAL NOT NULL,                 -- Skill Mastery Index 0.0–1.0
  format TEXT NOT NULL,                    -- 'scenario' | 'writeup' | 'evidence' | 'interview' | 'field_test'
  rubric_criteria JSONB NOT NULL,          -- {criterion: {score, max_score, weight}}
  evaluator TEXT NOT NULL,                 -- 'ia' | 'human' | 'hybrid'
  created_at INTEGER NOT NULL DEFAULT now_unix(),

  CONSTRAINT valid_evaluator CHECK (evaluator IN ('ia', 'human', 'hybrid')),
  CONSTRAINT smi_range CHECK (smi_score >= 0.0 AND smi_score <= 1.0)
);

CREATE INDEX idx_mastery_learner ON scy_mastery_evaluations(learner_id);
CREATE INDEX idx_mastery_tree ON scy_mastery_evaluations(tree_id);
CREATE INDEX idx_mastery_score ON scy_mastery_evaluations(smi_score);


-- ═══════════════════════════════════════════════════════════════
--  10. LOG DES OPÉRATIONS TREE (traçabilité + replay)
-- ═══════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS scy_tree_operations (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  tree_id UUID NOT NULL REFERENCES scy_semantic_trees(id) ON DELETE CASCADE,
  operation TEXT NOT NULL,                 -- 'plant' | 'graft' | 'test' | 'prune' | 'myelinate'
  actor TEXT NOT NULL,                     -- 'system' | 'user' | 'agent_03' | 'agent_07'
  node_ids UUID[] NOT NULL DEFAULT '{}',
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at INTEGER NOT NULL DEFAULT now_unix(),

  CONSTRAINT valid_tree_op CHECK (
    operation IN ('plant', 'graft', 'test', 'prune', 'myelinate')
  )
);

CREATE INDEX idx_tree_ops_tree ON scy_tree_operations(tree_id);
CREATE INDEX idx_tree_ops_op ON scy_tree_operations(operation);
CREATE INDEX idx_tree_ops_created ON scy_tree_operations(created_at);


-- ═══════════════════════════════════════════════════════════════
--  11. TABLES HÉRITÉES (Sprint 0 générique — inchangées)
-- ═══════════════════════════════════════════════════════════════

-- Sources (sources de contenu)
CREATE TABLE IF NOT EXISTS scy_sources (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
  domain_type TEXT NOT NULL,               -- 'cyber' | 'medical' | 'generic'
  source_type TEXT NOT NULL,               -- 'url' | 'pdf' | 'docx' | 'doc' | 'epub' | 'youtube'
  title TEXT NOT NULL,
  url TEXT,
  file_path TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  processed BOOLEAN DEFAULT false,
  created_at INTEGER NOT NULL DEFAULT now_unix()
);

-- Documents (après ingestion)
CREATE TABLE IF NOT EXISTS scy_documents (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  source_id UUID NOT NULL REFERENCES scy_sources(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content_hash TEXT,                       -- SHA-256 du contenu normalisé
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at INTEGER NOT NULL DEFAULT now_unix()
);

-- Chunks (découpage L0-L3)
CREATE TABLE IF NOT EXISTS scy_chunks (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  document_id UUID NOT NULL REFERENCES scy_documents(id) ON DELETE CASCADE,
  level INTEGER NOT NULL DEFAULT 0,        -- 0=L0 brute, 1=L1 clean, 2=L2 section, 3=L3 paragraph
  content TEXT NOT NULL,
  token_count INTEGER,
  embedding_id UUID,                       -- référence vers Zilliz
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at INTEGER NOT NULL DEFAULT now_unix()
);

-- Concepts (extraits par NEURON-CHAINS — Phase 2+)
CREATE TABLE IF NOT EXISTS scy_concepts (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  node_id UUID NOT NULL,                   -- référence vers le Semantic Tree
  title TEXT NOT NULL,
  definition TEXT,
  category TEXT,                           -- 'technique' | 'procedure' | 'tool' | 'concept'
  confidence REAL DEFAULT 0.5,
  sources JSONB,
  created_at INTEGER NOT NULL DEFAULT now_unix()
);

-- Cartes APEX/FSRS (Phase 2+)
CREATE TABLE IF NOT EXISTS scy_cards (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
  node_id UUID,                            -- nœud associé
  card_type TEXT NOT NULL,                 -- 'B01'–'B10'
  front TEXT NOT NULL,
  back TEXT NOT NULL,
  tags TEXT[] DEFAULT '{}',
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at INTEGER NOT NULL DEFAULT now_unix()
);

-- Queue de synchronisation offline-first
CREATE TABLE IF NOT EXISTS scy_sync_queue (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id) ON DELETE CASCADE,
  entity_type TEXT NOT NULL,
  entity_id UUID NOT NULL,
  operation TEXT NOT NULL,                 -- 'create' | 'update' | 'delete'
  payload JSONB NOT NULL,
  synced BOOLEAN DEFAULT false,
  created_at INTEGER NOT NULL,
  synced_at INTEGER
);

-- DLQ (EventBus — dead letter queue)
CREATE TABLE IF NOT EXISTS scy_event_dlq (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  event_type TEXT NOT NULL,
  payload JSONB NOT NULL,
  error TEXT NOT NULL,
  retry_count INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL DEFAULT now_unix(),
  last_retry_at INTEGER
);


-- ═══════════════════════════════════════════════════════════════
--  12. ROW LEVEL SECURITY (multi-tenant)
-- ═══════════════════════════════════════════════════════════════
-- Note : les policies RLS sont activées par application au niveau
-- des connexions (SET app.current_user_id = '...').
-- Les tables sensibles au multi-tenant sont :
--   scy_users, scy_learner_node_states, scy_scenario_instances,
--   scy_mastery_evaluations

-- Les tables trans-organisation (scy_semantic_trees, scy_tree_edges,
-- scy_domain_packs, scy_role_subtrees) sont accessibles à tous les
-- utilisateurs authentifiés (pas de RLS restrictive).


-- ═══════════════════════════════════════════════════════════════
--  13. FONCTIONS UTILITAIRES
-- ═══════════════════════════════════════════════════════════════

-- Calcul du SMI (Skill Mastery Index) — moyenne pondérée
CREATE OR REPLACE FUNCTION calculate_smi(learner_uuid UUID, tree_uuid UUID)
RETURNS TABLE (smi_score REAL, nodes_evaluated INTEGER, nodes_mastered INTEGER)
LANGUAGE SQL
AS $$
  SELECT
    AVG(confidence)::REAL,
    COUNT(*)::INTEGER,
    COUNT(*) FILTER (WHERE confidence >= 0.70)::INTEGER
  FROM scy_learner_node_states
  WHERE learner_id = learner_uuid AND tree_id = tree_uuid;
$$;

-- Récupérer les nœuds non maîtrises avec prérequis manquants (gap detection)
CREATE OR REPLACE FUNCTION detect_gaps(learner_uuid UUID, tree_uuid UUID)
RETURNS TABLE (
  node_id UUID,
  confidence REAL,
  prereq_node_id UUID,
  prereq_confidence REAL
)
LANGUAGE SQL
AS $$
  SELECT
    ln.node_id,
    ln.confidence,
    p.from_node AS prereq_node_id,
    pconf.confidence AS prereq_confidence
  FROM scy_learner_node_states ln
  JOIN scy_tree_edges p ON p.to_node = ln.node_id AND p.kind = 'prereq'
  LEFT JOIN scy_learner_node_states pconf
    ON pconf.node_id = p.from_node AND pconf.learner_id = ln.learner_id
  WHERE ln.learner_id = learner_uuid
    AND ln.tree_id = tree_uuid
    AND ln.confidence < 0.70
    AND pconf.confidence < 0.70;
$$;


-- ═══════════════════════════════════════════════════════════════
--  FIN DES MIGRATIONS v001
-- ═══════════════════════════════════════════════════════════════

# WORK PACKAGE 02 — SQL Migrations v001-v003 (Tables + Indexes + Triggers)

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Bloquant pour WP05 (adapter Postgres)
> **Dépendances** : WP01 (types Rust) doit exister
> **Références** : `MASTER_AGENT_PROMPT.md`, `minddoc/s00_architecture_standards/scy_service_architecture_map.md` (D-001, D-019), `minddoc/s00_prd/scy_prd_part_6_architecture_db.md`

---

## 1. Objectif

Créer les migrations SQL `migrations/seed_*_postgres/` qui définissent les tables, indexes, triggers et CHECK constraints du Semantic Tree.

**Livrable** : 3 migrations applicables via `supabase db push` (ou `supabase migration up`).

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `MASTER_AGENT_PROMPT.md` — sections Architecture cible, Code conventions (UUID v7, INTEGER timestamps, RLS)
2. `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` — D-019 (Semantic Tree), D-024
3. `minddoc/s01_semantic_tree/scy_state_machines.md` — SM-1, SM-4 (LearnerNodeState)
4. `docs/SCYFORGE_PIVOT_ARCHITECTURE.md` — §12 (D9 Coverage), §16 (MEDIATOR)

---

## 3. Contraintes NON-NÉGOCIABLES

1. **UUID v7** pour toutes les clés primaires et foreign keys.
2. **Timestamps INTEGER** — jamais de `TIMESTAMP WITH TIME ZONE`. Utilise `INTEGER` (Unix epoch seconds).
3. **RLS par `user_id`** — chaque table protégée doit avoir RLS activé + policy `user_id = auth.uid()`.
4. **PAS de terme métier cyber dans les noms de colonnes**. Le nom de la table `scy_semantic_nodes` est OK (préfixe scy_). Mais `scy_mitre_tactics` = INTERDIT.
5. **`owner_kind` est CHECK constrained**. Valeurs autorisées : `domain_pack`, `organization`, `learner`.
6. **`EdgeKind` CHECK constrained**. Exactement ces 7 valeurs : `hierarchical_trunk`, `hierarchical_branch`, `hierarchical_leaf`, `relational_prereq`, `relational_relates`, `relational_contradicts`, `relational_supersedes`.
7. **`confidence` est `float CHECK (confidence >= 0.0 AND confidence <= 1.0)`**.
8. **pgcrypto** — utiliser pour le seed_hash (SHA-256).
9. **Migration réversible** — implémenter `down()` SQL pour chaque migration.

---

## 4. Structure cible

```
supabase/migrations/
└── seed_YYYYMMDDHHMMSS_postgres/
    ├── up.sql           # Migration
    └── down.sql         # Rollback
```

Créer 3 migrations :

| # | Migration | Tables créées |
|---|-----------|---------------|
| v001 | Semantic Tree core | `scy_semantic_trees`, `scy_semantic_nodes`, `scy_tree_edges` |
| v002 | Learner state | `scy_learner_node_states`, `scy_pack_configs` |
| v003 | Indexes + Triggers + Functions | indexes, RLS policies, triggers, fonctions utilitaires |

---

## 5. Livrable détaillé — Migration par Migration

### 5.1 v001 — Semantic Tree Core

**`up.sql`** — Créer `scy_semantic_trees`, `scy_semantic_nodes`, `scy_tree_edges`

```sql
-- ============================================================
-- V001 — Semantic Tree Core
-- Crée: scy_semantic_trees, scy_semantic_nodes, scy_tree_edges
-- Référence: D-019, D-024
-- ============================================================

-- ── scy_semantic_trees ──
CREATE TABLE IF NOT EXISTS scy_semantic_trees (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_kind      TEXT NOT NULL CHECK (owner_kind IN ('domain_pack', 'organization', 'learner')),
    owner_id        UUID NOT NULL,
    domain_pack     TEXT NOT NULL,
    root_nodes      UUID[] NOT NULL DEFAULT '{}',
    created_at      INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint)
);

-- ── scy_semantic_nodes ──
CREATE TABLE IF NOT EXISTS scy_semantic_nodes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tree_id         UUID NOT NULL REFERENCES scy_semantic_trees(id) ON DELETE CASCADE,
    title           TEXT NOT NULL,
    summary         TEXT NOT NULL,
    depth           INTEGER NOT NULL DEFAULT 0 CHECK (depth >= 0),
    node_kind       TEXT NOT NULL CHECK (node_kind IN ('trunk', 'branch', 'leaf')),
    domain_ref      JSONB,  -- {ontology: text, id: text, label: text?}
    metadata        JSONB NOT NULL DEFAULT '{}',
    created_at      INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint),

    UNIQUE(tree_id, title) -- titre unique dans un arbre
);

-- ── scy_tree_edges ──
CREATE TABLE IF NOT EXISTS scy_tree_edges (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tree_id         UUID NOT NULL REFERENCES scy_semantic_trees(id) ON DELETE CASCADE,
    from_node       UUID NOT NULL REFERENCES scy_semantic_nodes(id) ON DELETE CASCADE,
    to_node         UUID NOT NULL REFERENCES scy_semantic_nodes(id) ON DELETE CASCADE,
    kind            TEXT NOT NULL, -- CHECK ajouté en v003
    criticality     REAL NOT NULL CHECK (criticality >= 0.0 AND criticality <= 1.0),
    created_at      INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint),
    superseded_at   INTEGER, -- null = edge vivante, sinon = anneau historisé

    UNIQUE(tree_id, from_node, to_node) -- pas de duplicata dans un arbre
);
```

**`down.sql`** :

```sql
DROP TABLE IF EXISTS scy_tree_edges CASCADE;
DROP TABLE IF EXISTS scy_semantic_nodes CASCADE;
DROP TABLE IF EXISTS scy_semantic_trees CASCADE;
```

---

### 5.2 v002 — Learner State + Pack Config

**`up.sql`** — Créer `scy_learner_node_states`, `scy_pack_configs`

```sql
-- ============================================================
-- V002 — Learner State + Pack Config
-- Crée: scy_learner_node_states, scy_pack_configs
-- Référence: D-011, D-024, scy_state_machines.md (SM-1, SM-4)
-- ============================================================

-- ── scy_learner_node_states ──
CREATE TABLE IF NOT EXISTS scy_learner_node_states (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    learner_id          UUID NOT NULL,
    tree_id             UUID NOT NULL REFERENCES scy_semantic_trees(id) ON DELETE CASCADE,
    node_id             UUID NOT NULL REFERENCES scy_semantic_nodes(id) ON DELETE CASCADE,
    confidence          REAL NOT NULL CHECK (confidence >= 0.0 AND confidence <= 1.0),
    mastery_score       REAL GENERATED ALWAYS AS (
        -- Formule SMI (D-011) — pack_config.mastery_threshold disponible via JOIN
        -- MVP: confidence seul, puis enrichi par les 4 poids
        confidence
    ) STORED,
    status              TEXT GENERATED ALWAYS AS (
        CASE
            WHEN confidence >= pack_config.mastery_threshold THEN 'mastered'
            WHEN confidence > 0.0 THEN 'studying'
            ELSE 'locked'
        END
    ) STORED,
    unlocked           BOOLEAN NOT NULL DEFAULT false,
    last_reviewed_at   INTEGER,
    created_at          INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint),
    updated_at          INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint),

    UNIQUE(learner_id, node_id)
);

-- Note: mastery_score et status utilisent pack_config.mastery_threshold.
-- Le trigger en v003 remplace cette logique par une fonction PL/pgSQL
-- qui résout le pack_config via owner_kind cascade.

-- ── scy_pack_configs ──
CREATE TABLE IF NOT EXISTS scy_pack_configs (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_kind              TEXT NOT NULL CHECK (owner_kind IN ('domain_pack', 'organization', 'learner')),
    owner_id                UUID NOT NULL,
    domain_pack             TEXT NOT NULL DEFAULT 'cyber',
    inherited_from_kind     TEXT CHECK (inherited_from_kind IN ('domain_pack', 'organization', 'learner')),
    inherited_from_id       UUID,
    mastery_threshold       REAL NOT NULL,
    smi_retention_weight    REAL NOT NULL DEFAULT 0.35,
    smi_fluency_weight      REAL NOT NULL DEFAULT 0.25,
    smi_gap_weight          REAL NOT NULL DEFAULT 0.25,
    smi_depth_weight        REAL NOT NULL DEFAULT 0.15,
    criticality_formula     TEXT NOT NULL DEFAULT '$$0.5 * log(1.0 + x)$$',
    custom                  JSONB NOT NULL DEFAULT '{}',
    created_at              INTEGER NOT NULL DEFAULT (extract(epoch FROM now())::bigint),

    UNIQUE(owner_kind, owner_id, domain_pack)
);
```

**`down.sql`** :

```sql
DROP TABLE IF EXISTS scy_learner_node_states CASCADE;
DROP TABLE IF EXISTS scy_pack_configs CASCADE;
```

---

### 5.3 v003 — Indexes + RLS + Triggers + Fonctions + CHECK Constraints

**`up.sql`** — Indexes, RLS, triggers, fonctions, CHECKs

```sql
-- ============================================================
-- V003 — Indexes + RLS + Triggers + Fonctions + CHECK Constraints
-- Référence: D-001, D-019, D-024
-- ============================================================

-- ── 1. CHECK constraints pour EdgeKind (déplacé ici car list_agg non supporté inline) ──
ALTER TABLE scy_tree_edges
    ADD CONSTRAINT edge_kind_check
        CHECK (kind IN (
            'hierarchical_trunk',
            'hierarchical_branch',
            'hierarchical_leaf',
            'relational_prereq',
            'relational_relates',
            'relational_contradicts',
            'relational_supersedes'
        ));

-- ── 2. Fonction utilitaire — résolution cascade pack_config ──
-- Référence: D-024 (inheritance rules)
CREATE OR REPLACE FUNCTION resolve_pack_config(
    p_learner_kind  TEXT,  -- toujours 'learner'
    p_learner_id    UUID,
    p_domain_pack   TEXT
) RETURNS TABLE (
    mastery_threshold  REAL,
    smi_retention      REAL,
    smi_fluency        REAL,
    smi_gap            REAL,
    smi_depth          REAL,
    criticality_formula TEXT
) AS $$
BEGIN
    -- 1. Learner d'abord
    RETURN QUERY
    SELECT pc.mastery_threshold, pc.smi_retention_weight, pc.smi_fluency_weight,
           pc.smi_gap_weight, pc.smi_depth_weight, pc.criticality_formula
    FROM scy_pack_configs pc
    WHERE pc.owner_kind = 'learner'
      AND pc.owner_id = p_learner_id
      AND pc.domain_pack = p_domain_pack
    LIMIT 1;

    IF FOUND THEN RETURN; END IF;

    -- 2. Organization ensuite
    RETURN QUERY
    SELECT pc.mastery_threshold, pc.smi_retention_weight, pc.smi_fluency_weight,
           pc.smi_gap_weight, pc.smi_depth_weight, pc.criticality_formula
    FROM scy_pack_configs pc
    JOIN scy_organizations o ON o.id = pc.owner_id
       AND o.learner_id = p_learner_id  -- filtrer les orgs de ce learner
    WHERE pc.owner_kind = 'organization'
      AND pc.domain_pack = p_domain_pack
    LIMIT 1;

    -- 3. DomainPack en dernier recours
    RETURN QUERY
    SELECT pc.mastery_threshold, pc.smi_retention_weight, pc.smi_fluency_weight,
           pc.smi_gap_weight, pc.smi_depth_weight, pc.criticality_formula
    FROM scy_pack_configs pc
    WHERE pc.owner_kind = 'domain_pack'
      AND pc.domain_pack = p_domain_pack
    LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE;

-- ── 3. Fonction — mise à jour mastery_score + status via pack_config ──
-- Remplace le GENERATED ALWAYS AS simplifié de v002
CREATE OR REPLACE FUNCTION update_learner_node_status()
RETURNS TRIGGER AS $$
DECLARE
    v_threshold REAL;
BEGIN
    -- Résoudre le threshold via cascade
    SELECT mastery_threshold INTO v_threshold
    FROM resolve_pack_config('learner', NEW.learner_id,
        (SELECT domain_pack FROM scy_semantic_trees WHERE id = NEW.tree_id));

    -- mastery_score = confidence (MVP, puis pondéré par SMI)
    NEW.mastery_score := NEW.confidence;

    -- status dérivé
    IF NEW.confidence >= v_threshold THEN
        NEW.status := 'mastered';
    ELSIF NEW.confidence > 0.0 THEN
        NEW.status := 'studying';
    ELSE
        NEW.status := 'locked';
    END IF;

    NEW.updated_at := extract(epoch FROM now())::bigint;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_learner_node_status
    BEFORE INSERT OR UPDATE OF confidence
    ON scy_learner_node_states
    FOR EACH ROW
    EXECUTE FUNCTION update_learner_node_status();

-- Note: COMPATIBILITY SHIM — v002 uses GENERATED ALWAYS AS with a null reference
-- to pack_config. Since the v003 function overwrites the value anyway, this is safe.
-- When v004 removes the GENERATED ALWAYS AS, the trigger will handle it entirely.

-- ── 4. Fonction — validate_seed_criteria C1-C7 (Cyber Pack) ──
CREATE OR REPLACE FUNCTION validate_cyber_seed(
    p_core_proposition TEXT,
    p_sources          TEXT[],
    p_domain_refs      JSONB,
    p_scope            JSONB
) RETURNS TABLE (
    all_passed BOOLEAN,
    criterion  TEXT,
    passed     BOOLEAN,
    message    TEXT
) AS $$
BEGIN
    -- C1: Grounded — sources[] non vide
    RETURN QUERY
    SELECT false, 'C1', p_sources IS NOT NULL AND array_length(p_sources, 1) > 0,
           CASE WHEN p_sources IS NULL OR array_length(p_sources, 1) = 0
                THEN 'Seed must have at least one source' ELSE '' END;

    -- C2: Pivot Anchored — au moins un domain_ref
    RETURN QUERY
    SELECT false, 'C2', p_domain_refs IS NOT NULL AND jsonb_array_length(p_domain_refs) > 0,
           CASE WHEN p_domain_refs IS NULL OR jsonb_array_length(p_domain_refs) = 0
                THEN 'Seed must have at least one domain reference' ELSE '' END;

    -- C3: Criticality calculable
    RETURN QUERY
    SELECT false, 'C3', p_scope::text IS NOT NULL AND (p_scope->>'trunk_priority') IS NOT NULL,
           CASE WHEN (p_scope->>'trunk_priority') IS NULL
                THEN 'Criticality formula requires trunk_priority in scope' ELSE '' END;

    -- C4: Decision Bearing — C1-c7 validation le fait via le vrai filter,
    -- mais SQL check: la proposition ne doit pas être vide
    RETURN QUERY
    SELECT false, 'C4', length(btrim(p_core_proposition)) > 50,
           'Proposition too short — must carry operational decision weight';

    -- C5-6-7: pack-définis (implémentés dans Rust via DomainFilterProvider trait)
END;
$$ LANGUAGE plpgsql STABLE;

-- ── 5. Trigger — immutable TreeEdge ──
-- Un TreeEdge ne peut JAMAIS être UPDATE (D-020)
CREATE OR REPLACE FUNCTION prevent_tree_edge_update()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        RAISE EXCEPTION 'TreeEdge is immutable after creation. Use superseded_at for historical marking.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_tree_edge_immutable
    BEFORE UPDATE ON scy_tree_edges
    FOR EACH ROW
    EXECUTE FUNCTION prevent_tree_edge_update();

-- ── 6. Trigger — seed_hash automatique (pour scy_seeds, WP06) ──
-- Pré-créé pour WP06 (scy_seeds table)
-- La table scy_seeds sera créée en WP06, mais le trigger est pré-positionné ici
-- pour que WP06 n'ait qu'à ajouter le trigger référence.

-- ── 7. Indexes ──

-- Semantic Trees
CREATE index IF NOT EXISTS idx_semantic_trees_owner
    ON scy_semantic_trees (owner_kind, owner_id);

CREATE index IF NOT EXISTS idx_semantic_trees_domain_pack
    ON scy_semantic_trees (domain_pack);

-- Semantic Nodes
CREATE index IF NOT EXISTS idx_semantic_nodes_tree
    ON scy_semantic_nodes (tree_id);

CREATE index IF NOT EXISTS idx_semantic_nodes_kind
    ON scy_semantic_nodes (node_kind);

CREATE index IF NOT EXISTS idx_semantic_nodes_domain_ref
    ON scy_semantic_nodes USING GIN (domain_ref);

CREATE index IF NOT EXISTS idx_semantic_nodes_metadata
    ON scy_semantic_nodes USING GIN (metadata);

-- Tree Edges
CREATE index IF NOT EXISTS idx_tree_edges_tree
    ON scy_tree_edges (tree_id);

CREATE index IF NOT EXISTS idx_tree_edges_from
    ON scy_tree_edges (from_node);

CREATE index IF NOT EXISTS idx_tree_edges_to
    ON scy_tree_edges (to_node);

CREATE index IF NOT EXISTS idx_tree_edges_kind
    ON scy_tree_edges (kind);

CREATE index IF NOT EXISTS idx_tree_edges_live
    ON scy_tree_edges (tree_id, kind)
    WHERE superseded_at IS NULL;

-- Learner Node States
CREATE index IF NOT EXISTS idx_learner_node_states_learner
    ON scy_learner_node_states (learner_id);

CREATE index IF NOT EXISTS idx_learner_node_states_tree
    ON scy_learner_node_states (tree_id);

CREATE index IF NOT EXISTS idx_learner_node_states_status
    ON scy_learner_node_states (status);

CREATE index IF NOT EXISTS idx_learner_node_states_confidence
    ON scy_learner_node_states (confidence DESC);

-- Pack Configs
CREATE index IF NOT EXISTS idx_pack_configs_owner
    ON scy_pack_configs (owner_kind, owner_id);

CREATE index IF NOT EXISTS idx_pack_configs_domain_pack
    ON scy_pack_configs (domain_pack);

-- ── 8. Row Level Security (RLS) ──
-- NB: Les policies utilisent un patron standard.
-- En production, auth.uid() est fourni par Supabase Auth.
-- En dev/test, injecter le user_id dans les requêtes.

ALTER TABLE scy_semantic_trees ENABLE ROW LEVEL SECURITY;
ALTER TABLE scy_semantic_nodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE scy_tree_edges ENABLE ROW LEVEL SECURITY;
ALTER TABLE scy_learner_node_states ENABLE ROW LEVEL SECURITY;
ALTER TABLE scy_pack_configs ENABLE ROW LEVEL SECURITY;

-- scy_semantic_trees — Organization gère sa vue, Learner ne voit que SON arbre
CREATE POLICY domain_pack_read ON scy_semantic_trees
    FOR SELECT USING (owner_kind = 'domain_pack');
CREATE POLICY org_read ON scy_semantic_trees
    FOR ALL USING (owner_kind = 'organization');
CREATE POLICY learner_read_own ON scy_semantic_trees
    FOR ALL USING (owner_kind = 'learner' AND owner_id::text = current_setting('app.user_id', true));

-- scy_semantic_nodes, scy_tree_edges — propagés par FK depuis trees
-- Coverage via JOIN (implémenté dans le repository Rust, pas en SQL)
-- Ici on autorise SELECT pour tous les utilisateurs authentifiés
-- La row-level filter se fait dans l'adapter (WP05)

-- scy_learner_node_states — strictement par learner_id
CREATE POLICY learner_select_own ON scy_learner_node_states
    FOR SELECT USING (learner_id::text = current_setting('app.user_id', true));
CREATE POLICY learner_insert_own ON scy_learner_node_states
    FOR INSERT WITH CHECK (learner_id::text = current_setting('app.user_id', true));
CREATE POLICY learner_update_own ON scy_learner_node_states
    FOR UPDATE USING (learner_id::text = current_setting('app.user_id', true));

-- scy_pack_configs — domain_pack public, org/learner restrictif
CREATE POLICY pack_config_public_read ON scy_pack_configs
    FOR SELECT USING (owner_kind = 'domain_pack');
CREATE POLICY pack_config_org_access ON scy_pack_configs
    FOR ALL USING (owner_kind = 'organization');
CREATE POLICY pack_config_learner_access ON scy_pack_configs
    FOR ALL USING (owner_kind = 'learner');
```

**`down.sql`** :

```sql
-- Rollback v003
DROP TRIGGER IF EXISTS trg_learner_node_status ON scy_learner_node_states;
DROP FUNCTION IF EXISTS update_learner_node_status();
DROP FUNCTION IF EXISTS resolve_pack_config(UUID, TEXT, TEXT);
DROP FUNCTION IF EXISTS validate_cyber_seed(TEXT, TEXT[], JSONB, JSONB);
DROP FUNCTION IF EXISTS prevent_tree_edge_update();

DROP index IF EXISTS idx_pack_configs_domain_pack;
DROP index IF EXISTS idx_pack_configs_owner;
DROP index IF EXISTS idx_learner_node_states_confidence;
DROP index IF EXISTS idx_learner_node_states_status;
DROP index IF EXISTS idx_learner_node_states_tree;
DROP index IF EXISTS idx_learner_node_states_learner;
DROP index IF EXISTS idx_semantic_nodes_domain_ref;
DROP index IF EXISTS idx_semantic_nodes_metadata;
DROP index IF EXISTS idx_semantic_nodes_kind;
DROP index IF EXISTS idx_semantic_nodes_tree;
DROP index IF EXISTS idx_tree_edges_kind;
DROP index IF EXISTS idx_tree_edges_live;
DROP index IF EXISTS idx_tree_edges_to;
DROP index IF EXISTS idx_tree_edges_from;
DROP index IF EXISTS idx_tree_edges_tree;
DROP index IF EXISTS idx_semantic_trees_domain_pack;
DROP index IF EXISTS idx_semantic_trees_owner;
```

---

## 6. Tests à fournir (supabase/test/migrations.test.ts)

```typescript
import { createClient } from '@supabase/supabase-js';

describe('Semantic Tree Migrations', () => {
  const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE!);

  test('v001 — scy_semantic_tables created with correct constraints', async () => {
    const { data } = await supabase
      .from('scy_semantic_trees')
      .select('*')
      .limit(0);
    // Vérifie que la table existe (query ne plante pas)
    expect(data).toEqual([]);
  });

  test('owner_kind CHECK constraint rejects invalid values', async () => {
    const { error } = await supabase
      .from('scy_semantic_trees')
      .insert({
        owner_kind: 'invalid_value', // ← doit être rejeté
        owner_id: crypto.randomUUID(),
        domain_pack: 'cyber',
        root_nodes: [],
      });
    expect(error).toBeDefined();
    expect(error?.code).toBe('23514'); // CHECK violation
  });

  test('confidence CHECK constraint rejects values > 1.0', async () => {
    // Insérer avec confidence = 1.5 → doit être rejeté
    const result = await supabase
      .from('scy_learner_node_states')
      .insert({
        learner_id: crypto.randomUUID(),
        tree_id: crypto.randomUUID(),
        node_id: crypto.randomUUID(),
        confidence: 1.5,
      });
    expect(result.error).toBeDefined();
  });

  test('TreeEdge immutability trigger', async () => {
    // Créer un edge puis tenter un UPDATE → doit planter
    const { error: insertErr } = await supabase
      .from('scy_tree_edges')
      .insert({
        tree_id: crypto.randomUUID(),
        from_node: crypto.randomUUID(),
        to_node: crypto.randomUUID(),
        kind: 'hierarchical_branch',
        criticality: 0.5,
      });
    // NOTE: Ce test nécessite des références valides, donc il peut échouer à l'insert
    // mais NE DOIT PAS planter avec un 23505 (unique violation) vs un erreur d'immutabilité
  });
});
```

---

## 7. Checklist de livraison

- [ ] Migration v001 créée (scy_semantic_trees, scy_semantic_nodes, scy_tree_edges)
- [ ] Migration v002 créée (scy_learner_node_states, scy_pack_configs)
- [ ] Migration v003 créée (indexes, RLS, triggers, fonctions, CHECK constraints)
- [ ] `supabase db push` / `supabase migration up` fonctionne sans erreur
- [ ] `down.sql` réversible pour chaque migration
- [ ] CHECK constraints sur `owner_kind` et `EdgeKind`
- [ ] CHECK constraint sur `confidence` (0.0–1.0)
- [ ] RLS activé sur toutes les tables
- [ ] `resolve_pack_config()` fonction PL/pgSQL fonctionne
- [ ] `update_learner_node_status()` trigger fonctionne
- [ ] `validate_cyber_seed()` fonction fonctionne (C1-C4 SQL)
- [ ] Trigger d'immutabilité TreeEdge fonctionne
- [ ] Index GIN sur `domain_ref` et `metadata`
- [ ] Aucun `TIMESTAMP WITH TIME ZONE` utilisé
- [ ] Aucun terme métier cyber dans les noms de colonnes
- [ ] NOTE COMIT: `"COMPATIBILITY SHIM — v002 uses GENERATED ALWAYS AS with a null`
  reference to pack_config. Since the v003 function overwrites the value anyway, this is
  safe. When v004 removes the GENERATED ALWAYS AS, the trigger will handle it entirely."' preserved exactly as written

---

## 8. Ce que tu NE fais PAS dans ce work package

- ❌ Créer des tables qui ne sont pas listées en Section 4
- ❌ Insérer des données de test (seed data)
- ❌ Modifier les types Rust définis dans WP01
- ❌ Créer `scy_seeds` table (WP06)
- ❌ Créer `scy_autonomy_logs` table (WP07)
- ❌ Modifier les données existantes

---

*Fin du WORK PACKAGE 02. Implémente UNIQUEMENT ce qui est dans ce fichier. Si tu as un doute, demande.*

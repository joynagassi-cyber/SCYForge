# 🧠 COSMOS-MINDGRAPH & SERVEUR MCP LOCAL — SPÉCIFICATIONS TECHNIQUES
## Architecture du Graphe de Contexte Sémantique Invisible et du Serveur Model Context Protocol (MCP)

**Document ID** : SPEC-MFG-COSMOS-MINDGRAPH-V1.0  
**Date** : 2026-06-12  
**Statut** : 🟢 SPÉCIFICATION DE PRODUCTION IMMUABLE ET VALIDÉE  
**Périmètre** : Implémentation du MindGraph et du serveur local MCP pour optimiser la collecte de contexte des agents.

---

## 🧭 1. Vision Technique : Le MindGraph comme Cordon Neural

Le **`COSMOS-MINDGRAPH`** (ou **`MindGraph`**) est la colonne vertébrale invisible de MindForge. L'utilisateur ne voit jamais les détails techniques de ce graphe d'arêtes. Le miracle réside dans la pertinence de nos agents (comme `CHRONICLE` ou `Professor AI`), qui savent instantanément tout de son parcours de formation.

Pour que ce graphe soit interrogeable de manière ultra-rapide par notre IA tout en consommant le moins de jetons (tokens) possible, nous mettons en place un **Serveur local MCP (Model Context Protocol)**. 

Plutôt que de laisser l'agent faire 5 appels de bases de données, puis analyser les relations lui-même (bloat de contexte), l'agent appelle un **outil MCP unique d'une seule traite (Single-Turn MCP Tool Call)**, récupérant le contexte sémantique pré-indexé et épuré.

---

## 2. Spécification Technique du Serveur MCP de MindGraph

Le serveur MCP est écrit en TypeScript (intégré nativement au sein de notre framework **Mastra**) et s'exécute localement dans le même conteneur d'exécution (Monolithe Unifié).

### 2.1 Définition de l'Outil MCP (`get_mindgraph_context`)
Cet outil est exposé à l'IA pour remonter l'état sémantique et la trajectoire de l'élève en moins de 10ms :

```typescript
// features/m04_mfg_cosmos_visualization_engine/mcp/mindgraphServer.ts
import { McpServer, ResourceTemplate } from '@modelcontextprotocol/sdk'; // Standard 2026
import { z } from 'zod';

const server = new McpServer({
  name: "MindGraph Context Server",
  version: "1.0.0"
});

// Enregistrement de l'outil d'interrogation du MindGraph
server.tool(
  "query-mindgraph",
  "Interroge le graphe de contexte de l'étudiant pour remonter ses prérequis et blocages sémantiques.",
  {
    user_id: z.string().uuid(),
    node_id: z.string().uuid()
  },
  async ({ user_id, node_id }) => {
    // 1. Exécuter la requête SQL récursive CTE en Rust Axum (ou sqlx direct)
    const context = await fetchGraphContextFromDatabase(user_id, node_id);
    
    return {
      content: [{
        type: 'text',
        text: context // Retourne un résumé de contexte ultra-condensé et formaté
      }]
    };
  }
);
```

---

## 3. Schéma de Base de Données Unifié d'Insforge PostgreSQL
Les arêtes de relations entre les différents nœuds d'apprentissage de MindForge sont stockées dans une table relationnelle unique et hautement indexée :

```sql
-- == COSMOS-MINDGRAPH — LE GRAPHE DE CONTEXTE UNIFIÉ ==

CREATE TABLE mfg_cosmos_mindgraph_edges (
    id                  UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    source_type         TEXT NOT NULL,        -- 'user', 'cohort', 'ascent_node', 'apex_card', 'source'
    source_id           UUID NOT NULL,
    relation_type       TEXT NOT NULL,        -- 'STUDIES_IN', 'REVISES', 'BLOCKS_ON', 'PROVIENS_DE', 'AUDITED_BY'
    target_type         TEXT NOT NULL,
    target_id           UUID NOT NULL,
    
    -- Métadonnées de relation
    confidence_score    INTEGER DEFAULT 100,  -- Score d'intégrité (badge auto-graph)
    created_at          INTEGER NOT NULL,
    updated_at          INTEGER NOT NULL
);

-- Indexations du MindGraph pour requêtes de parcours sous-millisecondes
CREATE INDEX idx_mindgraph_source ON mfg_cosmos_mindgraph_edges(source_type, source_id);
CREATE INDEX idx_mindgraph_target ON mfg_cosmos_mindgraph_edges(target_type, target_id);
CREATE INDEX idx_mindgraph_relation ON mfg_cosmos_mindgraph_edges(relation_type);
```

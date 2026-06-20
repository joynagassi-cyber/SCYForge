# 🛠️ SCY-AG02-CONTENT-SCOUT — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG02_CONTENT_SCOUT_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données de l'Agent

```
 [Nœud de compétence (depuis AGENT-03)]
 ex: "Hooks React"
                 │
                 ▼
   [Step Mastra : contentScoutStep]
                 │
        ┌────────┴───────────┐
        ▼                    ▼
  [Cache check               [Découverte cores
   mfg_shared_content_cache   pertinents (YouTube, Web, ...)]
   (priorité $0)]                    │
        │                    ▼
        │            [Enqueue tâches ingestion async
        │             pour les sources nouvelles (miss)]
        │                    │
        └────────┬───────────┘
                 ▼
   [Scoring : pertinence (embeddings) + qualité + coût]
                 │
                 ▼
   [Validation Zod SourceListSchema + classement ordonné]
                 │
        ┌────────┴───────────┐
        ▼                    ▼
  [Écoute EventBus          [Hand-off → AGENT-04
   SourceIngested /         LEARNING-CONDUCTOR
   IngestionFailed →        (génération de contenu)]
   rétrogradation]
```

---

## 2. Dépendances Techniques Strictes
* **Cores d'ingestion** : adaptateurs `s01` (13 cores).
* **Embeddings** : Zilliz (similarité sémantique nœud ↔ source).
* **LlmRouter + BudgetGuard** : scoring léger (classement).
* **Zod** : `SourceListSchema`.
* **EventBus** : `SourceIngested`, `IngestionFailed`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag02_content_scout.ts`** : Step Mastra (découverte + classement).
- **`backend_ts/src/ascent/schemas/source_list_schema.ts`** : Schéma Zod des sources classées.
- **`backend_ts/src/ascent/scoring/source_scorer.ts`** : Scoring pertinence/qualité/coût.
- **`mfg_shared_content_cache`** : Vérification et réutilisation des sources.
- **`mfg_sync_queue`** : Enqueue des ingestions asynchrones.

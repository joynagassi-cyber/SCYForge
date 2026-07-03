<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-AG02-CONTENT-SCOUT — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG02_CONTENT_SCOUT_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

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

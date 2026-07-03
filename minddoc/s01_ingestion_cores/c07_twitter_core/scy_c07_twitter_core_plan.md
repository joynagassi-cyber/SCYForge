<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-TWITTER-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_TWITTER_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Architecture du Flux de Données

```
 [URL tweet / @username / tweet_id]
                 │
                 ▼
     [Résolution identifiant]
        ├── URL → extraction tweet_id
        ├── @username → GET /2/users/by/username → user_id
        └── tweet_id direct
                 │
                 ▼
     [Mastra TS Ingestion Worker]
                 │
                 ├──► [Vérification mfg_shared_content_cache (tweet_id)] ──► Hit + non modifié ──► (Fin)
                 │
                 └──► [Miss : Appel Twitter API v2 (reqwest + Bearer secret)]
                             │
              ┌──────────────┴──────────────────────┐
              ▼                                     ▼
     [Tweet unique]                         [Thread / conversation]
     GET /2/tweets/{id}                     search/recent
              │                             conversation_id:{cid}
              │                             + pagination next_token
              │                                     │
              └──────────────┬──────────────────────┘
                             ▼
                [Extraction médias : expansions media_keys]
                [Extraction entités : urls, hashtags, mentions]
                             │
                             ▼
                [Reconstruction hiérarchique
                 via referenced_tweets (replied_to)]
                [Tri chronologique created_at]
                             │
                             ▼
                [Markdown imbriqué (auteur + date + citation)]
                [Score d'intégrité DRACO]
                             │
                             ▼
        [Écriture PostgreSQL mfg_project_sources]
        [Indexation vectorielle Zilliz]
        [Arête sémantique COSMOS-MINDGRAPH → status: completed]
```

---

## 2. Dépendances Techniques Strictes
* **API Twitter/X v2** :
  - Bearer Token stocké dans le gestionnaire de secrets Northflank (jamais en clair).
  - Endpoints : `/2/tweets/{id}`, `/2/users/by/username/{username}`, `/2/tweets/search/recent`.
  - Champs : `tweet.fields=created_at,conversation_id,referenced_tweets,entities,edit_history_tweet_ids`.
  - Expansions : `expansions=author_id,attachments.media_keys`.
* **Runtimes Rust** :
  - `reqwest` (client HTTP + Bearer Token + respect en-têtes `x-rate-limit-*`).
  - `serde_json` (parsing réponses paginées).
  - `governor` (rate limiting préventif).
  - Circuit Breaker (pattern ARC-001) sur `429` répétés.
* **Stockage** :
  - PostgreSQL (Northflank) : `mfg_project_sources`, `mfg_shared_content_cache`, `mfg_sync_queue`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/twitterCore.ts`** : Orchestration Mastra TS (résolution identifiant, vérification cache, enqueue SAGA).
- **`backend_rs/src/cores/twitter/api_client.rs`** : Client HTTP Twitter API v2 (Bearer, rate limiting, Circuit Breaker).
- **`backend_rs/src/cores/twitter/identity.rs`** : Résolution URL/username/tweet_id → identifiants API.
- **`backend_rs/src/cores/twitter/thread_reconstructor.rs`** : Reconstruction récursive de thread via `conversation_id` + pagination.
- **`backend_rs/src/cores/twitter/media.rs`** : Extraction + téléchargement médias et entités.
- **`mfg_project_sources`** : Stockage du Markdown hiérarchique du thread et des métadonnées.
- **`mfg_shared_content_cache`** : Dé-duplication par `tweet_id` (+ vérification `edit_history_tweet_ids` pour tweets modifiés).
- **`mfg_sync_queue`** : File d'attente asynchrone SAGA pour la reconstruction de threads longs.

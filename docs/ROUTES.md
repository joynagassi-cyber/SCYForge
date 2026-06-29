# SCYForge — Routes and APIs

> Audience: agent de codage ou humain qualifié.  
> Objectif: trouver les chemins HTTP, les contrats et les responsabilités par frontière de service.

Cette page couvre les routes principales; elle s’appuie sur l’architecture et sur les conventions de code du projet sans les recopier.

---

## 1. Convention d’URLs

Regles appliquées:
-Prefixes par domaine metier:
   `/auth`, `/ingestion`, `/ascent`, `/cosmos`, `/apex`, `/brain`, `/reader`, `/imprint`
- Routes de sante separees:
   `/health/live`, `/health/ready`, `/health/deep`
- Routes longues ou topics async preferent SSE ou EventBus plutot que polling HTTP

Contraintes MB:
- les routes metier retournent `{data, error}`
- les routes sensibles sont protegees par JWT et RLS
- les routes sont documentees par un contrat Zod en TS ou par un type Rust en rust

---

## 2. Backend Rust: routes principales

Les routes se trouvent dans:
- `backend_rs/src/api/routes.rs`
- `backend_rs/src/api/auth.rs`
- `backend_rs/src/api/ingestion.rs`
- `backend_rs/src/api/ascent.rs`
- `backend_rs/src/api/cosmos.rs`
- `backend_rs/src/api/apex.rs`
- `backend_rs/src/api/brain.rs`
- `backend_rs/src/api/reader.rs`

Groupes de routes:

### 2.1 Authentification et sante
- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/refresh`
- `GET  /health/live`
- `GET  /health/ready`
- `GET  /health/deep`

### 2.2 Ingestion
- `POST /ingestion/youtube`
- `POST /ingestion/web`
- `POST /ingestion/academic`
- `POST /ingestion/drive`
- `POST /ingestion/podcast`
- `POST /ingestion/financial`
- `POST /ingestion/twitter`
- `POST /ingestion/wikipedia`
- `POST /ingestion/science`
- `POST /ingestion/tiktok`
- `POST /ingestion/reddit`
- `POST /ingestion/epub`
- `POST /ingestion/anki`

### 2.3 NEURON-CHAINS
- `POST /neuron-chains/run`
- `POST /neuron-chains/chain/alpha`
- `POST /neuron-chains/chain/beta`
- `POST /neuron-chains/chain/gamma`
- `POST /neuron-chains/chain/delta`
- `POST /neuron-chains/chain/epsilon`
- `POST /neuron-chains/chain/zeta`
- `POST /neuron-chains/chain/eta`
- `POST /neuron-chains/tools/tXX`

### 2.4 APEX / FSRS
- `POST /apex/cards/generate`
- `POST /apex/session/start`
- `POST /apex/session/review`
- `GET  /apex/cards/due`
- `GET  /apex/stats/smi`
- `GET  /apex/forecast/30d`

### 2.5 COSMOS
- `POST /cosmos/graph/build`
- `GET  /cosmos/graph/node/:id`
- `GET  /cosmos/graph/edges`
- `GET  /cosmos/modes/:mode`
- `POST /cosmos/agent/visualize`
- `POST /cosmos/agent/compare`
- `POST /cosmos/agent/highlight`

### 2.6 BRAIN
- `POST /brain/chat`
- `POST /brain/query`
- `POST /brain/teach-back`
- `GET  /brain/sources`

### 2.7 Reader Suite
- `GET  /reader/file/:id`
- `GET  /reader/web/:id`
- `POST /reader/deep-link`
- `GET  /reader/gallery/:id`

### 2.8 IMPRINT
- `POST /imprint/cre`
- `POST /imprint/garniture`
- `POST /imprint/vocabulaire`

---

## 3. Backend TypeScript: routes principales

Les routes se trouvent dans:
- `backend_ts/src/index.ts`
- `backend_ts/src/ascent/`
- `backend_ts/src/normal_mode/`
- `backend_ts/src/b2b/`
- `backend_ts/src/automation/`

Groupes de routes:

### 3.1 ASCENT Pipeline
- `POST /api/ascent/goal/interpret`
- `POST /api/ascent/dag/build`
- `POST /api/ascent/session/start`
- `POST /api/ascent/session/progress`
- `POST /api/ascent/session/end`
- `POST /api/ascent/certify/proof-of-skill`

### 3.2 Normal Mode
- `POST /api/normal/ingest`
- `POST /api/normal/generate`
- `GET  /api/normal/project/:id`

### 3.3 B2B
- `POST /api/b2b/creator/upload`
- `GET  /api/b2b/creator/cohort/:id`
- `GET  /api/b2b/creator/insights`

### 3.4 Automatisation progressive
- `GET  /api/automation/level`
- `POST /api/automation/level`

### 3.5 Sagesse et coaching
- `POST /api/wisdom/principle`
- `GET  /api/wisdom/coach`

---

## 4. Contrats d’appels critiques

### 4.1 ASCENT appelle NEURON-CHAINS
- frontiere: `backend_ts` -> `backend_rs` sur `/neuron-chains/*`
- responsabilite backend_ts: fournir le contexte DAG et les hints
- responsabilite backend_rs: executer la chaine et renvoyer des livrables

### 4.2 Ingestion appelle NEURON-CHAINS
- frontiere: `backend_ts` -> `backend_rs` sur `/ingestion/*` puis `/neuron-chains/*`
- regle: un fichier source peut generer plusieurs documents/N-nodes; idempotence via UUID v7

### 4.3 APEX publie sur EventBus
- `CardReviewed` contient: `user_id`, `node_id`, `feedback`, `stability_delta`, `smi_delta`
- consommateurs autorises: ASCENT Agent-05, COSMOS, CHRONICLE

### 4.4 COSMOS expose MindGraph MCP
- outil expose: `query-mindgraph`
- transport: MCP local, pas HTTP
- avantage: reduit la consommation tokens de 4.5x vs narration brute

### 4.5 BRAIN recherche web
- frontiere: `backend_rs` -> `SearxNG` + `Perplexica`
- host: `docker/searxng` et `docker/perplexica`
- route interne: `/brain/web-search`

---

## 5. Limites et garde-fous applicables aux routes

Interdictions:
- aucune route qui accepte un secret dans le body sans chiffrement de transport
- aucune route metier sans validation schema en entree
- aucune route qui depose un fichier sans taille max, sans scan MIME, sans ACL tenant
- aucune route qui telephonne a un LLM payant sans timeout 5s, sans circuit breaker, sans budget guard

Obligations:
- retourner `{data, error}`
- logger les decisions agents et les depenses LLM
- respecter le typestate et les transitions valides avant toute ecriture en base

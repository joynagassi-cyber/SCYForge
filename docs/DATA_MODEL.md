# SCYForge — Data Model

> Audience: agent de codage ou humain qualifie.  
> Objectif: comprendre les tables, les indexes, les contraintes et le mapping services <> donnees sans relire le script SQL en entier.

Cette documentation estheboree a partir de:
- `minddoc/s00_prd/scy_sprint_0_db_init.sql`
- docs/ARCHITECTURE.md
- docs/ROUTES.md

---

## 1. Regles globales appliquees a toutes les tables

- UUID v7 comme identifiant principal via `gen_random_uuid()`
- timestamps Unix en `INTEGER`
- soft delete par `deleted_at INTEGER NULL`
- isolement multi-tenant par `user_id` avec RLS obligatoire
- politique de policy PostgreSQL pour chaque table
- préfixe `scy_` sur toutes les tables
- contraintes explicites, pas de colonne nullable sans justification

---

## 2. Tables par domaine metier

### 2.1 Base systeme et utilisateurs

- `scy_users`
- colonnes principales: `id`, `email`, `tenant_id`, `current_smi`, timestamps
- role: stocker l’utilisateur, l’isolation tenant et l’etat global SMI
- politiques RLS: lecture et ecriture limites a l’utilisateur courant

### 2.2 Ingestion et documents

- `scy_documents`
- `scy_chunks`
- `scy_projects`
- `scy_project_sources`
- `scy_project_suggestions`
- `scy_project_deliverables`

Roles:
- documents et chunks pour le mode ASCENT et Normal Mode
- projets et sources pour le mode Normal Mode
- suggestions et deliverables pour la generation agentique

Contraintes notables:
- `scy_chunks.vector_id` lie a Zilliz ou Milvus Lite
- `scy_project_deliverables.status` pour tracer la generation
- RLS transitive sur chunks, suggestions et deliverables par projet

### 2.3 Moteur neurologique et memoire

- `scy_synaptic_vitality`
- `scy_engram_vault`
- `scy_forge_attempts`
- `scy_synaptic_pruning_log`

Roles:
- vitalite synaptique par noeud ou concept
- vault pour les engrams dormants
- historiques des tentatives de Forge
- journal de pruning synaptique

### 2.4 Createurs et cohortes B2B

- `scy_creator_cohorts`
- `scy_creator_insights`
- `scy_creator_clarifications`

Roles:
- regrouper les etudiants sous un createur
- capturer les blocages cognitifs
- permettre des clarifications humaines

### 2.5 Observabilite et depenses

- `scy_agent_decisions`
- `scy_llm_spend_log`

Roles:
- tracer les decisions des agents
- tracer la consommation LLM par utilisateur et par session

---

## 3. Indexes obligatoires

Toutes les colonnes suivies de `WHERE`, `JOIN`, `ORDER BY` ou utilisees en RLS sont indexees:
- `user_id` sur `scy_users`
- `document_id` sur `scy_chunks`
- `project_id` sur `scy_project_sources`, `scy_project_suggestions`, `scy_project_deliverables`
- `user_id, vitality_score` sur `scy_synaptic_vitality`
- `user_id, dormant_since` sur `scy_engram_vault`
- `user_id, node_id` sur `scy_forge_attempts`
- `cohort_id, status` sur `scy_creator_insights`
- `user_id` sur `scy_agent_decisions` et `scy_llm_spend_log`

---

## 4. Mapping services transverses vers tables

- `scy-ingestion` -> `scy_documents`, `scy_chunks`, `scy_projects`, `scy_project_sources`
- `scy-neuron-chains` -> `scy_project_deliverables`, `scy_engram_vault`
- `scy-apex-fsrs` -> `scy_synaptic_vitality`, `scy_forge_attempts`, `scy_synaptic_pruning_log`
- `scy-cosmos-kg` -> lecture de `scy_chunks`, `scy_synaptic_vitality`
- `scy-brain-rag` -> lecture de `scy_chunks`, `scy_documents`
- `scy-imprint` -> lecture de `scy_engram_vault`
- `scy-reader` -> lecture de `scy_documents`, `scy_chunks`
- EventBus -> lecture de `scy_agent_decisions`, `scy_llm_spend_log`

---

## 5. Evenements et logs derives

Les events clefs incluent:
- `GoalInterpreted`
- `SourceIngested`
- `DocumentGenerated`
- `CardReviewed`
- `NodeCompleted`
- `DriftDetected`
- `SessionEnded`
- `ProofOfSkillSubmitted`
- `CohortInsightResolved`

Chaque event traversant EventBus doit pouvoir etre correle a:
- un `user_id`
- une `session_id`
- un service emetteur
- un timestamp Unix

---

## 6. Contraintes d’evolution interdites sans spec

- modification d’une colonne referencee dans un service traverse sans migration adaptee
- suppression d’un index utilise par un service production
- changement du mode UUID sans impact sur les consumers
- introduction d’un booleen nullable sans enum explicite et sans evaluation d’impact

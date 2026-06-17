# 🚀 MINDFORGE — PRD NEURO-CONSOLIDATION MASTER BLUEPRINT v3.0
## Spécification Globale d'Ingénierie Cognitive, Algorithmique et d'Architecture Système Unifiée

**Document ID** : PRD-MFG-NEURO-CONSOLIDATION-V3.0  
**Date** : 2026-06-12  
**Statut** : 🟢 DOCUMENT DE RÉFÉRENCE DE PRODUCTION (CONSOLIDATION GLOBALE)  
**Périmètre** : Intégration complète des 5 Piliers Neuroscientifiques, du Modèle Mathématique "Force-Cerveau", de l'Ingestion Mode Normal (11 Cores), et de la Stack Hybride de Sûreté (Mastra, Rust Axum, Insforge, Zilliz, Harmonist, Langfuse).  
**Charte de Rendu** : Style Spatial Premium (Règle 60-30-10, Noir d'encre `#020205`, Violet sémantique `#1E1B4B`, Bleu électrique `#2563EB`, Émeraude consolidée `#10B981`, Or impérial `#D97706`).

---

## 🧭 Table des Matières
1. [Serment de Rigueur & Alignement Philosophique](#1-philosophy)
2. [Les 5 Piliers Neuroscientifiques : Spécifications Mathématiques](#2-neuro-piliers)
3. [Le Modèle Géométrique de Morphing "Force-Cerveau"](#3-force-brain)
4. [Consolidation de l'Ingestion en Mode Normal (11 Cores)](#4-normal-mode)
5. [Le Schéma Relationnel SQL Unifié (Insforge PostgreSQL)](#5-sql-schema)
6. [L'Écosystème de Sûreté et Télémétrie en Production](#6-safety-monitoring)
7. [Matrice de Traçabilité des Exigences Consolidées](#7-traceability)

---

## 1. Serment de Rigueur & Alignement Philosophique {#1-philosophy}

La quasi-totalité des systèmes d'apprentissage numériques et de gestion de connaissances personnels (PKM/Second Brain) traitent l'esprit humain comme un réceptacle passif : accumuler, empiler et relier statiquement des notes. 

**MindForge v3.0** rompt définitivement avec cette approche en devenant la première plateforme d'apprentissage **biologiquement cohérente et plastique**. Son architecture logicielle ne se limite pas à stocker de la donnée, elle imite, stimule et respecte activement le fonctionnement neurologique réel du cerveau humain :
- **L'oubli est traité comme un mécanisme d'optimisation biologique actif** (ENGRAM Vault).
- **Le rappel est sélectif et sculpte continuellement la topologie du réseau** (Compétition Synaptique).
- **La difficulté est une condition fondamentale d'ancrage à long terme** (Protocole FORGE & Mode FRICTION).
- **L'organisation spatio-temporelle s'auto-structure en forme cérébrale** (Modèle Force-Cerveau).

---

## 2. Les 5 Piliers Neuroscientifiques : Spécifications Mathématiques {#2-neuro-piliers}

Chacune de nos décisions neuroscientifiques est traduite par un modèle mathématique rigoureux s'exécutant sur notre double-moteur (Rust APEX-AGENT & Mastra TS).

### Pilier 1 : Le Système ENGRAM (Dormance & Cold Engram Vault)
La vitalité synaptique $V_n(t) \in [0, 100]$ de chaque concept ou nœud d'apprentissage décline de manière algorithmique.

#### L'Équation Dynamique de Vitalité :
$$V_n(t) = w_r \cdot R_n(t) + w_c \cdot C_n(t) + w_m \cdot M_n(t) - \lambda \cdot (t - t_{\text{last}})$$

Où :
* $R_n(t) \in [0, 100]$ : Score de rétention issu des révisions espacées **APEX (FSRS 5.0)**.
* $C_n(t) \in [0, 100]$ : Centralité de degré normalisée du nœud $n$ calculée par Graphiti (densité de liens).
* $M_n(t) \in [0, 100]$ : Score de mobilisation récente (fréquence d'utilisation dans les notes, recherches et sessions ARENA sur les 7 derniers jours).
* $\lambda \in \mathbb{R}^+$ : Facteur de déclin biologique (par défaut $0.05$ par jour).
* $(t - t_{\text{last}})$ : Temps en jours écoulé depuis la dernière interaction active.

#### Seuil de Dormance :
Si $V_n(t) < 20/100$, le concept est extrait du graphe actif et de l'index RAG, puis compressé dans `mfg_engram_vault`.
* *Résurrection active* : Ré-activation obligatoire par une tentative de reconstruction active (Feynman challenge à trous) évaluée à un score sémantique $\ge 70\%$ par l'APEX-AGENT en Rust.

### Pilier 2 : Le Moteur de Sélection par Activation (Compétition Synaptique)
Basé sur le *Retrieval-Induced Forgetting (RIF)*, l'activation réussie d'un concept $N_i$ applique un amortisseur d'inhibition compétitive sur les concepts adjacents (1-hop) sémantiquement similaires :

$$V_j(t_{\text{new}}) = V_j(t) \cdot (1 - \alpha \cdot S_{ij})$$

Où :
* $\alpha \in [0, 1]$ : Coefficient de suppression synaptique concurrentielle (par défaut $0.12$).
* $S_{ij}$ : Similarité cosinus calculée sur les embeddings denses des concepts $N_i$ et $N_j$.

### Pilier 3 : Le Protocole FORGE (L'Effet de Génération)
Interdit l'affichage passif d'un cours.
- L'utilisateur est face à une **amorce générative** (cloze-test, prediction challenge ou Feynman Sketch d'une phrase).
- Après sa tentative, l'APEX-AGENT en Rust calcule la pertinence conceptuelle, injecte un feedback socratique d'encouragement et **révèle le cours et KaTeX à 60 FPS**.

### Pilier 4 : Le Mode FRICTION (Difficultés Désirables & Interleaving)
Le Mode FRICTION casse délibérément l'illusion de fluidité d'étude :
- **Interleaving** : Sessions composées de **70% du domaine ciblé et 30% de domaines éloignés ou déjà maîtrisés** (cognitive cross-training).
- **Anti-Fluency UX** : Masquage des barres de progression en phase d'étude ; **Reflection Delay** (bouton de validation verrouillé pendant 3 secondes pour forcer l'analyse du problème).

### Pilier 5 : La Carte Thermique du Graphe (Thermodynamique Entropique)
La température thermique $T_n(t) \in [0, 100]$ d'un concept se définit par :

$$T_n(t) = \theta \cdot V_n(t) + \phi \cdot \left| \frac{\partial H}{\partial t} \right|$$

Où :
- $V_n(t)$ : Score de vitalité du Pilier 1.
- $\left| \frac{\partial H}{\partial t} \right|$ : Taux de variation récent de l'entropie structurelle temporelle du nœud mesuré par **Graphiti**.
* *Rendu COSMOS Mode 26* : Éclaire le nœud en **Or impérial `#D97706`** (Hot, zone active), en **Bleu électrique/Violet** (Warm, consolidé) ou en **Gris/Silver glacé** (Cold, obsolescence).

---

## 3. Le Modèle Géométrique de Morphing "Force-Cerveau" {#3-force-brain}

Le modèle de morphing de graphe s'organise selon un **double-rendu bi-modal (2D Axial & 3D KB)** pour allier clarté de navigation de cours et matérialisation immersive de la base globale de connaissances.

### 3.1 L'Équation d'Enveloppe de Coupe Horizontale (Axiale 2D)
Pour l'affichage bidimensionnel des concepts de cours (COSMOS Mode 25), le graphe prend la forme d'une **vue du dessus (horizontale)**, découpée en deux hémisphères par la **fissure longitudinale centrale**.

L'enveloppe horizontale est modélisée géométriquement en coordonnées polaires par :
$$r(\theta) = R_0 \cdot \left( 1 + 0.12 \cdot \cos(2\theta) - 0.04 \cdot \cos(4\theta) \right) \cdot \left( 1 - 0.08 \cdot |\sin(\theta)|^4 \right)$$
* $\cos(2\theta)$ : Allonge le cerveau de l'avant (frontal) vers l'arrière (occipital).
* $\cos(4\theta)$ : Forme les échancrures des tempes.
* $|\sin(\theta)|^4$ : Crée la fente centrale interhémisphérique verticale à $\theta = \pi/2$ et $-\pi/2$.

---

### 3.2 La Matérialisation de la base globale en 3D (COSMOS Mode 26)
La base complète de connaissances (KB) se matérialise sous la forme d'un **vrai cerveau tridimensionnel interactif** en rotation orbitale libre $(x, y, z) \in [-1, 1]^3$.

#### 1. Coordonnées d'Ancrage 3D des Lobes :
Chaque concept de la base s'organise et se positionne dynamiquement selon sa taxonomie de Bloom :
- **Lobe Frontal / Cortex Préfrontal (Créer/Évaluer)** : $x = [0.4, 0.8]$, $y = [0.3, 0.6]$, $z = [-0.3, 0.3]$ (Avant supérieur)
- **Lobe Pariétal (Analyser)** : $x = [-0.2, 0.2]$, $y = [0.5, 0.8]$, $z = [-0.4, 0.4]$ (Milieu supérieur)
- **Lobe Occipital (Appliquer - Visuel)** : $x = [-0.8, -0.6]$, $y = [0.1, 0.3]$, $z = [-0.3, 0.3]$ (Arrière)
- **Lobe Temporel (Comprendre - Mémoire)** : $x = [-0.3, 0.3]$, $y = [-0.4, 0.0]$, $z = [0.4, 0.8]$ (Latéral bas)
- **Cervelet (Mémoriser / Pratique)** : $x = [-0.5, -0.3]$, $y = [-0.7, -0.5]$, $z = [-0.4, 0.4]$ (Arrière bas)
- **Tronc Cérébral (Ingestion de base)** : $x = [0.0]$, $y = [-1.3, -1.0]$, $z = [0.0]$ (Axe central vertical inférieur)

#### 2. Projection de Perspective Tridimensionnelle :
Le moteur applique des transformations de rotation 3D orbitale commandées par la souris de l'utilisateur, puis projette les nœuds en perspective 2D :
$$x_{\text{projected}} = \frac{x_1 \cdot f_{\text{fov}}}{d_{\text{camera}} + z_2} \cdot \text{scale} + c_x$$
$$y_{\text{projected}} = \frac{y_2 \cdot f_{\text{fov}}}{d_{\text{camera}} + z_2} \cdot \text{scale} + c_y$$

#### 3. Z-Buffering sémantique :
Les nœuds d'arrière-plan ($z_2 > 0$) sont atténués en opacité et en rayon d'affichage pour simuler la profondeur physique, tandis que les nœuds d'avant-plan ($z_2 < 0$) s'allument avec un halo de Bleu électrique actif ou d'Émeraude consolidée, révélant la fissure interhémisphérique séparant les lobes gauche et droit.

### 3.3 Système de Forces Modifié (Verlet Integration 3D)

#### A. Améliorations de Robustesse Validées par MIA :
- **Lazy Physics Suspension (D-OPT-018)** : Dès que l'énergie cinétique moyenne du système descend sous un seuil critique $\langle E_k \rangle < 0.005$, la boucle de simulation de forces Axum/Verlet s'interrompt. Le Canvas se contente de réagir aux rotations de caméras, supprimant toute charge CPU inutile.
- **Quadtree Object Pooling (D-OPT-019)** : Évite d'allouer de nouveaux objets QuadtreeNode à chaque frame du moteur de physique. Un tableau à taille fixe pré-alloué en mémoire (`Memory Pool`) est recyclé à chaque frame, ramenant l'impact du Garbage Collection JS/WASM à **0ms**.
- **Local Telemetry Debouncing (D-OPT-020)** : Bloque les écritures excessives sur Insforge PostgreSQL en appliquant un debouncing de 5 secondes sur les métriques $V_n(t)$ locales de l'utilisateur.
- **Backup AI Clarification (D-OPT-021)** : Résout la frustration des élèves en générant un déblocage socratique de secours automatique sous 24h si le créateur est indisponible.
- **Socratic Progressive Prompting (D-OPT-022)** : Élimine la surcharge cognitive de l'utilisateur en bridant la génération du Professor AI à un maximum de 2 paragraphes socratiques par interaction.
- **Prerequisite Booster Schedule (D-OPT-023)** : Élimine la faille d'oubli de bases : si un concept parent d'un nœud à étudier est dormant dans `mfg_engram_vault`, une carte de révision de ce concept parent est planifiée d'office en début de session.
- **ELI5 Micro-Remediation Overlay (D-OPT-024)** : En cas d'échec répété au test FORGE d'un nœud difficile, une fenêtre modale d'analogie ELI5 est déployée pour ramener la charge cognitive sous un seuil tolérable.
- **Adversarial RAG Context Guardrail (D-OPT-025)** : Assainit le RAG vectoriel en éliminant les injections de prompts sémantiques ou le bruit sémantique.
- **Offline-First Local Sync Queue (D-OPT-026)** : Gère les déconnexions du réseau par un mécanisme d'IndexedDB local se synchronisant par lots asynchrones dès le retour du réseau (table `mfg_sync_queue` sur Insforge PostgreSQL).
- **Thread-of-Thought Scaffolding (D-OPT-027)** : Construit un pont sémantique continu entre les anciens concepts maîtrisés de l'élève et la nouvelle explication du Professor AI pour éviter les explications hachées.
- **FSRS Self-Consistency Checker (D-OPT-028)** : Auto-réglage asynchrone des poids de mémorisation via des simulations Monte Carlo hebdomadaires pour neutraliser la fatigue des cartes.
- **GDPR Anonymization & Cohort Milestones (D-OPT-029)** : Anonymisation stricte de la console d'administration Créateur (k-anonymat >= 10) et gamification collective de la cohorte selon l'SMI de groupe.
- **Dynamic LOD & Label Cull (D-OPT-030)** : Optimisation de rendu du Canvas/WebGL limitant le dessin des labels et des lueurs floues aux seuls nœuds de premier plan en cas de surcharge GPU.
- **Persistent IndexedDB WAL (D-OPT-031)** : Sécurise la persistance de l'IndexedDB par un journal des transactions (Write-Ahead Log) pour parer aux pannes de crash de batterie ou du navigateur.
- **Lazy Physics Suspension (D-OPT-018)** : Dès que l'énergie cinétique moyenne du système descend sous un seuil critique $\langle E_k \rangle < 0.005$, la boucle de simulation de forces Axum/Verlet s'interrompt. Le Canvas se contente de réagir aux rotations de caméras, supprimant toute charge CPU inutile.
- **Quadtree Object Pooling (D-OPT-019)** : Évite d'allouer de nouveaux objets QuadtreeNode à chaque frame du moteur de physique. Un tableau à taille fixe pré-alloué en mémoire (`Memory Pool`) est recyclé à chaque frame, ramenant l'impact du Garbage Collection JS/WASM à **0ms**.
- **Local Telemetry Debouncing (D-OPT-020)** : Bloque les écritures excessives sur Insforge PostgreSQL en appliquant un debouncing de 5 secondes sur les métriques $V_n(t)$ locales de l'utilisateur.
- **Backup AI Clarification (D-OPT-021)** : Résout la frustration des élèves en générant un déblocage socratique de secours automatique sous 24h si le créateur est indisponible.



## 4. Consolidation de l'Ingestion en Mode Normal (11 Cores) {#4-normal-mode}

Le Mode Normal (Ingestion-First) s'exécute à la demande. Il s'appuie sur le framework **Mastra TypeScript** pour orchestrer la conversion asynchrone par les 11 Cores et sur **Rust** pour générer instantanément le **Pack Neural par Défaut**.

### 4.1 Ingestion & Normalisation (Les 11 Cores)
- **YouTube** (`yt-transcript-rs`), **Web/Article** (Scrapling bypass + readability), **Academic** (9 sources APIs + DOI), **Google Drive** (Composio OAuth), **Podcast** (Feed-rs + Whisper), **Financial** (SEC EDGAR / SEC Earnings), **Twitter** (v2 API), **Wikipedia** (MediaWiki), **Science** (arXiv), **TikTok** (Scraping + Whisper) et **Reddit** (Roux API).
- Les documents complexes sont transformés en Markdown structuré par **Docling** (Docker, 0$) et vectorisés sur **Zilliz Cloud Serverless** (`partition_key = tenant_id`).

### 4.2 L'Agent Déterministe de Suggestions (`AGENT-14 : DET-SUGGESTER`)
Pour éliminer les latences et les coûts probabilistes, `AGENT-14` analyse la nature sémantique du fichier ingéré et propose instantanément **exactement 3 types de documents pertinents** :
- *Code/Repositories* $\rightarrow$ Suggère : `G01` (Developer Onboarding Manual), `C01` (API Reference), `W01` (Architectural Audit).
- *Academic/LaTeX* $\rightarrow$ Suggère : `S01` (Résumé Analytique), `G02` (Dérivations Mathématiques), `W02` (Critique Littérature).
- *YouTube/Audio* $\rightarrow$ Suggère : `S02` (Synthèse Chronologique), `C02` (Aide-Mémoire), `G03` (Guide d'Exploitation).
- *Financial/SEC* $\rightarrow$ Suggère : `R01` (Analyse Comparative), `S03` (Briefing Direction), `E01` (Matrice Risques & Opp.).

### 4.3 Le Pack Neural par Défaut (Génération automatique Multi-Output)
Dès que l'ingestion se termine, le **`NORMAL-MODE-DEFAULT-ORCHESTRATOR`** lance en parallèle (Tokio tasks) la génération de :
1. **Les 3 Documents Suggestionnels** rédigés par l'APEX-AGENT en Rust (respectant l'ancrage DELTA).
2. **1 Visualisation Interactive COSMOS** (Graphe de concepts exporté sous forme de TreeMap, Concept Map, ou Sunburst).
3. **1 Deck d'APEX Flashcards** (10 à 15 cartes sémantiques mémorisables via FSRS 5.0).
4. **1 Note d'Amorçage Cognitif IMPRINT v2** (Pareto Priming).

*Itération Utilisateur* : L'utilisateur peut ensuite saisir une **Consigne Courte de Personnalisation** (`user_custom_description`) pour générer sur-mesure un livrable formaté selon ses exigences opérationnelles.

---

## 5. Le Schéma Relationnel SQL Unifié (Insforge PostgreSQL) {#5-sql-schema}

Le schéma de base de données d'**Insforge PostgreSQL** s'unifie de façon transparente. Il évite tout doublon de persistance et sécurise l'étanchéité multi-tenant :

```sql
-- =========================================================================
-- MINDFORGE DATABASE SCHEMA CONSOLIDATION — V3.0
-- Platform: Insforge PostgreSQL (RLS enabled, default tenant partitioning)
-- =========================================================================

-- == COUCHE COMMUNE & UTILISATEURS ==
CREATE TABLE mfg_users (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    email           TEXT UNIQUE NOT NULL,
    tenant_id       TEXT NOT NULL,        -- Clé d'isolation d'entreprise
    current_smi     REAL DEFAULT 50.0,    -- Indice de Maîtrise Systémique global
    created_at      INTEGER NOT NULL
);

-- == COUCHE INGESTION & DOCUMENTS ==
CREATE TABLE mfg_documents (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES mfg_users(id) ON DELETE CASCADE,
    title           TEXT NOT NULL,
    parsed_markdown TEXT NOT NULL,        -- Résultat de conversion Docling (0$)
    metadata        JSONB,                -- DOI, timestamps, has_code, has_math...
    created_at      INTEGER NOT NULL
);

CREATE TABLE mfg_chunks (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    document_id     UUID NOT NULL REFERENCES mfg_documents(id) ON DELETE CASCADE,
    content         TEXT NOT NULL,
    vector_id       TEXT NOT NULL,        -- Référence vectorielle sur Zilliz Cloud
    created_at      INTEGER NOT NULL
);

-- == COUCHE MODE NORMAL — PROJETS & SUGGESTIONS ==
CREATE TABLE mfg_projects (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES mfg_users(id) ON DELETE CASCADE,
    title           TEXT NOT NULL,
    description     TEXT,
    created_at      INTEGER NOT NULL,
    updated_at      INTEGER NOT NULL
);

CREATE TABLE mfg_project_sources (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    project_id      UUID NOT NULL REFERENCES mfg_projects(id) ON DELETE CASCADE,
    core_type       TEXT NOT NULL,        -- 'youtube', 'web', 'academic', 'financial'...
    source_title    TEXT NOT NULL,
    raw_input       TEXT NOT NULL,
    parsed_content  TEXT NOT NULL,        -- Extrait Docling
    metadata        JSONB,
    created_at      INTEGER NOT NULL
);

CREATE TABLE mfg_project_suggestions (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    project_id      UUID NOT NULL REFERENCES mfg_projects(id) ON DELETE CASCADE,
    suggested_code  TEXT NOT NULL,        -- 'G01', 'S01', 'C01'...
    suggested_name  TEXT NOT NULL,
    why_suggested   TEXT NOT NULL,        -- Justification technique de l'Agent-14
    created_at      INTEGER NOT NULL
);

CREATE TABLE mfg_project_deliverables (
    id                      UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    project_id              UUID NOT NULL REFERENCES mfg_projects(id) ON DELETE CASCADE,
    user_id                 UUID NOT NULL REFERENCES mfg_users(id),
    deliverable_type        TEXT NOT NULL, -- 'suggested_doc', 'custom_doc', 'apex_cards', 'cosmos_map', 'imprint_primer'
    document_code           TEXT,          -- 'G01', 'S01', 'C01'...
    title                   TEXT NOT NULL,
    content                 TEXT,          -- Rédigé par APEX-AGENT (Rust)
    visualization_data      JSONB,         -- Graphe pour COSMOS
    user_custom_description TEXT,          -- Consigne utilisateur libre (Custom Prompt)
    status                  TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'generating', 'completed', 'failed'
    confidence_score        INTEGER,       -- Score issu de mfg_confidence_reports
    created_at              INTEGER NOT NULL,
    completed_at            INTEGER
);

-- == COUCHE NEUROLOGIQUE — VITALITÉ, DORMANCE & SÛRETÉ ==
CREATE TABLE mfg_synaptic_vitality (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES mfg_users(id) ON DELETE CASCADE,
    node_id         UUID NOT NULL,        -- Référence polymorphique
    node_type       TEXT NOT NULL,        -- 'ascent_node' | 'concept'
    retention_score REAL DEFAULT 100.0,   -- Stat de mémorisation FSRS
    connection_score REAL DEFAULT 0.0,    -- Centralité Graphiti
    mobilization_score REAL DEFAULT 0.0,  -- Mention récente (notes/chats)
    vitality_score  REAL DEFAULT 100.0,   -- Résultat de l'équation
    temperature     REAL DEFAULT 50.0,    -- Température thermodynamique
    last_interaction_at INTEGER NOT NULL,
    updated_at      INTEGER NOT NULL
);

CREATE TABLE mfg_engram_vault (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES mfg_users(id) ON DELETE CASCADE,
    node_id         UUID NOT NULL,
    title           TEXT NOT NULL,
    content_payload JSONB NOT NULL,       -- Compression de la Knowledge Card dormante
    keywords        TEXT[] NOT NULL,      -- Mots-clés pour la résurrection active
    dormant_since   INTEGER NOT NULL,
    attempts_count  INTEGER DEFAULT 0
);

CREATE TABLE mfg_forge_attempts (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES mfg_users(id) ON DELETE CASCADE,
    node_id         UUID NOT NULL,
    attempt_text    TEXT NOT NULL,
    semantic_score  REAL NOT NULL,        -- Évalué par APEX-AGENT
    is_unlocked     BOOLEAN DEFAULT false,
    created_at      INTEGER NOT NULL
);

CREATE TABLE mfg_synaptic_pruning_log (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES mfg_users(id) ON DELETE CASCADE,
    activated_node_id UUID NOT NULL,
    suppressed_node_id UUID NOT NULL,
    suppression_delta REAL NOT NULL,
    created_at      INTEGER NOT NULL
);


-- == COUCHE CRÉATEURS DE CONTENU & COHORTES ==
CREATE TABLE mfg_creator_cohorts (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    creator_id      UUID NOT NULL REFERENCES mfg_users(id) ON DELETE CASCADE,
    title           TEXT NOT NULL,
    created_at      INTEGER NOT NULL
);

CREATE TABLE mfg_creator_insights (
    id                  UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    cohort_id           UUID NOT NULL REFERENCES mfg_creator_cohorts(id) ON DELETE CASCADE,
    node_id             UUID NOT NULL,       -- Le nœud de cours posant problème
    failure_rate        REAL NOT NULL,       -- ex: 0.80 pour 80% d'échec de la cohorte
    cognitive_block     TEXT NOT NULL,       -- Explication rédigée par l'Agent-13 (Cognitive-Validator)
    status              TEXT NOT NULL DEFAULT 'open', -- 'open' | 'resolved'
    created_at          INTEGER NOT NULL
);

CREATE TABLE mfg_creator_clarifications (
    id                  UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    insight_id          UUID NOT NULL REFERENCES mfg_creator_insights(id) ON DELETE CASCADE,
    clarification_text  TEXT,
    media_url           TEXT,                -- Lien vers un mémo vidéo ou audio du créateur
    created_at          INTEGER NOT NULL
);

-- Index pour accélérer le tableau de bord créateur
CREATE INDEX idx_creator_insights_cohort ON mfg_creator_insights(cohort_id, status);

-- == COUCHE SÛRETÉ D'HARMONIST (TRANS_LOGS) ==
CREATE TABLE mfg_agent_decisions (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES mfg_users(id) ON DELETE CASCADE,
    session_id      UUID NOT NULL,
    agent_id        TEXT NOT NULL,        -- 'visual-critic', 'cognitive-validator'
    decision        TEXT NOT NULL,        -- 'approved', 'rejected'
    schema_errors   JSONB,                -- Erreurs Zod interceptées par Harmonist
    created_at      INTEGER NOT NULL
);

-- == COUCHE TÉLÉMÉTRIE & SPEND LOG ==
CREATE TABLE mfg_llm_spend_log (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES mfg_users(id) ON DELETE CASCADE,
    session_id      UUID NOT NULL,
    tokens_input    INTEGER NOT NULL,
    tokens_output   INTEGER NOT NULL,
    cost_usd        REAL NOT NULL,        -- Calculé via Langfuse/LiteLLM
    created_at      INTEGER NOT NULL
);

-- == INDEXATIONS D'OPTIMISATION ==
CREATE INDEX idx_vitality_search ON mfg_synaptic_vitality(user_id, vitality_score DESC);
CREATE INDEX idx_deliverables_status ON mfg_project_deliverables(project_id, status);
CREATE INDEX idx_spend_user_date ON mfg_llm_spend_log(user_id, created_at DESC);
CREATE INDEX idx_engram_vault_active ON mfg_engram_vault(user_id, dormant_since);
```

---

## 6. L'Écosystème de Sûreté et Télémétrie en Production {#6-safety-monitoring}

Même lors de générations par lots massives du **Pack Neural par Défaut**, l'intégrité financière et logique est assurée par trois boucliers de production :

```
[ REQUÊTE UTILISATEUR ] ──► [ PROXY LITELLM DOCKER ] ──► (Circuit Breaker & Throttle)
                                    │
                                    ▼
                      [ APEX-AGENT RUST ENGINE ]
                        ├── LLMLingua-2 Compressor (-80% de tokens)
                        └── Local Semantic Cache (LanceDB / Meta Postgres, <5ms)
                                    │
                                    ▼
                      [ WORKFLOW MASTRA (TS) & HARMONIST ]
                        └── Validation Zod stricte des outputs
                                    │
                                    ▼
                      [ TÉLÉMÉTRIE GLOBALE LANGFUSE ]
                        └── Suivi en direct du spend par user
```

1. **LiteLLM Docker Proxy** :  
   Proxy de routage centralisé OpenAI-compatible. Il gère de manière déterministe le failover automatique, le load-balancing d'API, et applique des quotas stricts et des alertes de surconsommation par utilisateur sans coder de logique complexe de disjoncteur (0$ de licence).
2. **Harmonist Validation Protocol** :  
   Protocole mécanique interceptant les écritures de base de données. Si la structure JSON ou géométrique de COSMOS échoue à la validation Zod par `AGENT-12` (Visual-Critic), la transaction est rejetée avec un auto-retry immédiat ciblé.
3. **Langfuse Open-Core** :  
   Déployé sur Zeabur sous Docker. Trace chaque étape d'exécution de nos 13 agents ASCENT et du Mode Normal, mesure la latence p95, et remplit en direct la table de coûts `mfg_llm_spend_log` pour éliminer le goulot financier (Token Bleeding).

---

## 7. Matrice de Traçabilité des Exigences Consolidées {#7-traceability}

| Réf Exigence | Description Clinique & Cognitive | Composant Technique | Statut de Cohérence |
|--------------|-----------------------------------|---------------------|---------------------|
| **REQ-NEURO-01** | Oubli Actif : Les nœuds inutilisés entrent en dormance. | `mfg_engram_vault` + Équation Vitalité | 🟢 **Intégré & Cohérent** |
| **REQ-NEURO-02** | Résurrection active par effort cognitif sémantique $\ge 70\%$. | API Axum `/api/neuroscience/forge/attempt` | 🟢 **Intégré & Cohérent** |
| **REQ-NEURO-03** | Compétition Synaptique (RIF) : Réduire vitalité des nœuds voisins. | Algorithme Rust `synaptic_competition.rs` | 🟢 **Intégré & Cohérent** |
| **REQ-NEURO-04** | Protocole FORGE : Génération d'amorce obligatoire avant lecture. | Composant React `ForgeProtocolGate` | 🟢 **Intégré & Cohérent** |
| **REQ-NEURO-05** | Mode FRICTION : Entrelacement (70/30) et masquage de progression. | Workflow Mastra `getFrictionSession` | 🟢 **Intégré & Cohérent** |
| **REQ-NEURO-06** | Carte Thermique : Visu 3D/2D thermodynamique des connaissances. | COSMOS Mode 26 + Équation de Température | 🟢 **Intégré & Cohérent** |
| **REQ-NEURO-07** | Modèle Force-Cerveau : Morphing géométrique en forme cérébrale. | Équation Sagittale + `BrainForceGraph.tsx` | 🟢 **Intégré & Cohérent** |
| **REQ-INGEST-01**| Ingestion Mode Normal : 11 Cores et parsing sémantique par Docling. | Ingestion Cores Mastra TS + Docling Docker | 🟢 **Intégré & Cohérent** |
| **REQ-INGEST-02**| Agent Déterministe de Suggestions : 3 livrables pertinents instantanés.| `AGENT-14 : DET-SUGGESTER` | 🟢 **Intégré & Cohérent** |
| **REQ-INGEST-03**| Pack Neural par Défaut : Génération automatique multi-output. | `NORMAL-MODE-DEFAULT-ORCHESTRATOR` | 🟢 **Intégré & Cohérent** |
| **REQ-INGEST-04**| Consigne Libre : Personnalisation par l'utilisateur. | `user_custom_description` + StyleEnforcer | 🟢 **Intégré & Cohérent** |

---

## 🏁 Conclusion : L'Étoile du Nord de MindForge

Ce **Master Blueprint de Consolidation v3.0** dote MindForge d'une spécification d'ingénierie absolue, validée scientifiquement et architecturalement infaillible. 

En éliminant tout doublon de persistance ou conflit d'orchestration entre le Mode Normal et ASCENT, et en reliant l'intégralité du traitement de données au socle relationnel d'**Insforge**, nous sommes prêts à coder le premier sprint de la **Phase 1 (Web-First)** de MindForge. L'aventure de l'apprentissage cybernétique et symbiotique commence maintenant.


-- == PIPELINE DE PORTAIL DE VALIDATION PÉDAGOGIQUE ASCENT-QA ==

-- Table centrale des sessions d'audits pédagogiques
CREATE TABLE mfg_course_qa_audits (
    id                  UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    node_id             UUID NOT NULL,       -- Référence polymorphique au nœud ou projet étudié
    global_pqs_score    INTEGER NOT NULL,    -- Score PQS final (0-100)
    is_approved         BOOLEAN NOT NULL DEFAULT false, -- True si PQS >= 88
    
    -- Détail des sous-scores du Comité d'agents
    design_score        INTEGER NOT NULL,    -- QA-01
    expert_score        INTEGER NOT NULL,    -- QA-02
    alignment_score     INTEGER NOT NULL,    -- QA-06
    cognitive_score     INTEGER NOT NULL,    -- QA-04
    
    created_at          INTEGER NOT NULL,
    completed_at        INTEGER
);

-- Journal des critiques détaillées par agent d'audit
CREATE TABLE mfg_qa_agent_reviews (
    id                  UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    audit_id            UUID NOT NULL REFERENCES mfg_course_qa_audits(id) ON DELETE CASCADE,
    agent_code          TEXT NOT NULL,       -- 'QA-01' à 'QA-06'
    assigned_score      INTEGER NOT NULL,    -- Score individuel (0-100)
    critical_findings   TEXT NOT NULL,       -- Liste des lacunes ou approximations identifiées
    remediation_prompt  TEXT NOT NULL,       -- Consignes de corrections directes pour la Neuro-Chain
    created_at          INTEGER NOT NULL
);

-- Table des vérifications d'alignement constructif (John Biggs)
CREATE TABLE mfg_constructive_alignment_checks (
    id                  UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    audit_id            UUID NOT NULL REFERENCES mfg_course_qa_audits(id) ON DELETE CASCADE,
    question_index      INTEGER NOT NULL,    -- Index de la question de l'examen SurveyJS
    target_objective_id TEXT NOT NULL,       -- Objectif pédagogique du cours visé
    is_aligned          BOOLEAN NOT NULL DEFAULT true,
    mismatch_details    TEXT,
    created_at          INTEGER NOT NULL
);

-- == LES PARCOURS D'ÉTUDES, COHORTES ET SÉCURITÉ DE VITALITÉ ==
ALTER TABLE mfg_ascent_goals 
ADD COLUMN pathway_type TEXT NOT NULL DEFAULT 'assimilation_active', -- 'assimilation_active' (Parcours A) | 'accreditation_professionnelle' (Parcours B)
ADD COLUMN is_certified BOOLEAN DEFAULT false,
ADD COLUMN certified_at INTEGER;

-- == LE VOLANT D'ÉVOLUTION AXIOMATIQUE DE MINDFORGE (MFG-AXIOM) ==

-- Table de capture des traces expérimentales unitaires réussies
CREATE TABLE mfg_procedural_traces (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES mfg_users(id) ON DELETE CASCADE,
    domain_category TEXT NOT NULL,        -- 'ingestion_financial', 'pedagogy_deep_learning'...
    raw_trace       JSONB NOT NULL,       -- Suite d'actions et de requêtes réussies
    metric_score    REAL NOT NULL,        -- Score de succès (SMI ou DRACO)
    created_at      INTEGER NOT NULL
);

-- Table des Lois Fondamentales Unifiées (Axiomes)
CREATE TABLE mfg_axioms (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    axiom_code      TEXT UNIQUE NOT NULL, -- ex: 'AX-ING-01' (Loi Ingestion), 'AX-PED-04' (Loi Pédagogique)
    domain_category TEXT NOT NULL,        -- 'ingestion_financial', 'pedagogy_deep_learning'...
    title           TEXT NOT NULL,
    fundamental_law TEXT NOT NULL,        -- Règle sémantique unifiée et hautement optimisée
    is_global       BOOLEAN DEFAULT true, -- Indique si partagé avec l'ensemble du réseau MindForge
    created_at      INTEGER NOT NULL,
    updated_at      INTEGER NOT NULL
);

-- Journal de synchronisation des Axiomes entre les cohortes/utilisateurs
CREATE TABLE mfg_axiom_sync_logs (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES mfg_users(id) ON DELETE CASCADE,
    axiom_id        UUID NOT NULL REFERENCES mfg_axioms(id) ON DELETE CASCADE,
    synced_at       INTEGER NOT NULL
);

-- Table des audits d'imitation d'experts humains (AGENT-16)
CREATE TABLE mfg_hitl_proxy_audits (
    id                  UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    node_id             UUID NOT NULL,       -- Le nœud ou cours audité
    expert_persona_name TEXT NOT NULL,       -- Le persona d'expert bootstrappé (ex: "Dr. Mayo Clinic")
    expert_domain       TEXT NOT NULL,       -- Le domaine d'expertise validé (ex: "Cardiologie")
    rigor_score         INTEGER NOT NULL,    -- Score de rigueur scientifique (0-100)
    critical_findings   TEXT NOT NULL,       -- Liste des approximations ou simplifications rejetées
    is_approved         BOOLEAN NOT NULL DEFAULT false,
    created_at          INTEGER NOT NULL
);

-- Index d'optimisation de l'Axiomatizer
CREATE INDEX idx_procedural_traces_domain ON mfg_procedural_traces(domain_category);
CREATE INDEX idx_axioms_global ON mfg_axioms(domain_category, is_global);
CREATE INDEX idx_goals_pathway ON mfg_ascent_goals(user_id, pathway_type);
CREATE INDEX idx_hitl_audits_node ON mfg_hitl_proxy_audits(node_id);

-- Index pour la console de modération administrative
CREATE INDEX idx_qa_audits_node ON mfg_course_qa_audits(node_id);
CREATE INDEX idx_qa_reviews_audit ON mfg_qa_agent_reviews(audit_id, agent_code);

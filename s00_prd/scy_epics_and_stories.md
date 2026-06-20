---
stepsCompleted: ["Step 1: Validate Prerequisites and Extract Requirements", "Step 2: Design Epics and Stories"]
inputDocuments: ["uploads/scy_forge_prd.md", "uploads/scy_forge_prd_neuro_consolidation_blueprint.md", "uploads/design.md", "uploads/experience.md", "uploads/scy_forge_optimized_neuro_mathematics.md", "uploads/scy_forge_brain_graph_rendering_specs.md"]
---

# SCY Forge v3.5 - Epic Breakdown

## Overview
Ce document fournit la décomposition complète des exigences et des décisions architecturales de SCY Forge v3.5 en Épiques (Epics) et récits utilisateurs (User Stories) prêts pour l'implémentation directe et sans hallucination par nos agents de développement.

---

## Requirements Inventory

### Functional Requirements
* **FR-INGEST-01** : Ingestion multilingue unifiée à 11 Cores (YouTube, Web/Article, Academic, Google Drive, Podcast, Financial, Twitter, Wikipedia, Science, TikTok, Reddit).
* **FR-NEURO-01** : Moteur de vitalité d'ENGRAM sigmoïdal calculé sur FSRS, centralité Graphiti et mobilisation sémantique.
* **FR-NEURO-02** : Compétition synaptique sémantique (RIF) avec barrière anti-avalanche (Fail-Safe Gate à 25/100 de vitalité).
* **FR-NEURO-03** : Protocole FORGE exigeant un effort de génération avant révélation complète du cours.
* **FR-NEURO-04** : Mode FRICTION d'anti-fluidité (entrelacement 70/30, masquage de progression et Reflection Delay de 3s).
* **FR-VISU-01** : Double affichage COSMOS bi-modal (Coupe axiale 2D horizontale et Volume 3D interactif rotatif).
* **FR-CREATOR-01** : Console Créateur/Formateur avec diagnostic de goulots cognitifs par l'Agent-13, clarifications en un clic (RAG) et k-anonymat ($k \ge 10$).

### NonFunctional Requirements
* **NFR-SCALE-01** : Support de millions de nœuds ($10^6$ nœuds) en production via l'algorithme de partitionnement spatial **Barnes-Hut (O(N log N))** s'exécutant sur un Quadtree.
* **NFR-PERF-01** : Élimination des pauses de Garbage Collection par le recyclage de structures (`Object Pooling`) et suspension physique de Verlet si stabilisation.
* **NFR-RESIL-01** : Résilience réseau hors-ligne via une file `scy_sync_queue` stockée en local dans l'IndexedDB sécurisée par un journal de transactions (WAL).
* **NFR-MATH-01** : Protection anti-NaN via une constante de softening $\epsilon = 10^{-6}$ et anti-overflow d'exposants de vitalité.

### Additional Requirements (Architecture & Tech)
* **ARCH-001** : Double-moteur d'orchestration (Mastra TS sur Northflank pour l'expérience, Rust Axum pour les calculs physiques lourds et le RAG).
* **ARCH-002** : Ingestion sémantique via **Docling Docker** (0$ infrastructure) et vectorisation isolée sur **Zilliz Cloud Serverless** (`partition_key = tenant_id`).

### UX Design Requirements (DESIGN & EXPERIENCE)
* **UX-DR-01** : Utilisation exclusive de la **Palette Chromatique Spatiale** (Noir d'encre `#020205`, Violet profond `#1E1B4B`, Bleu électrique `#2563EB`, Émeraude consolidée `#10B981`, Or impérial `#D97706`).
* **UX-DR-02** : Cinématique d'allumage en 4 phases (The Neural Ignition Reveal) avec skeleton shimmer localisé masquant la latence.

---

## Epic List
1. **Epic 1 : Noyau Infrastructure, Base de Données et Sûreté (Northflank & Zilliz)**
2. **Epic 2 : Le Moteur Neuroscientifique et Algorithmique (Rust Backend)**
3. **Epic 3 : La Constellation Graphique Bi-Modale 2D/3D (AntV G6, Cosmos & Three.js)**
4. **Epic 4 : L'Orchestration Ingestion Mode Normal & Pack par Défaut (Mastra TS)**
5. **Epic 5 : La Console Créateur Élite & Sécurité (k-anonymat & WAL Sync)**

---

## Epic 1 : Noyau Infrastructure, Base de Données et Sûreté

Cette Épique pose les fondations de la persistance relationnelle, de l'isolation vectorielle et de la surveillance de nos marges de tokens.

### Story 1.1 : Initialisation de la Base Relationnelle (Northflank PostgreSQL)
**En tant que** Développeur Backend,  
**Je veux** instancier les tables SQL consolidées sur Northflank avec règles de Row Level Security (RLS),  
**Afin que** les données sémantiques et d'apprentissages soient stockées de manière hermétique par `tenant_id`.

* **Critères d'Acceptation :**
  - **Given** Une instance active d'Northflank PostgreSQL.
  - **When** J'exécute le script DDL consolidé contenant `scy_users`, `scy_synaptic_vitality` et `scy_project_deliverables`.
  - **Then** Les tables sont créées sans erreurs et les index d'optimisations sont actifs.
  - **And** Toutes les requêtes `SELECT` ou `UPDATE` filtrent de manière déterministe via la politique RLS `tenant_id`.

---

## Epic 2 : Le Moteur Neuroscientifique et Algorithmique (Rust Backend)

Cette Épique régit les calculs physiques, le déclin d'oubli, et l'approximation spatiale Barnes-Hut.

### Story 2.1 : Algorithme de partitionnement spatial Barnes-Hut (O(N log N))
**En tant que** Concepteur d'Algorithmes,  
**Je veux** coder l'insertion et le calcul de forces sur un arbre Quadtree récursif,  
**Afin d'** assurer la fluidité de calcul de la constellation sur millions de nœuds en production.

* **Critères d'Acceptation :**
  - **Given** Un nuage de 5000 nœuds simulés.
  - **When** Je calcule la répulsion de Verlet classique en O(N^2) puis via notre approximation Barnes-Hut en O(N log N) avec un seuil $	heta = 0.50$.
  - **Then** La complexité et le temps de calcul CPU sont réduits de plus de 99.0%.
  - **And** Les forces calculées par approximation convergent de façon symétrique sans aucune vibration ou instabilité numérique.

### Story 2.2 : Équation de Vitalité Sigmoïdale d'ENGRAM & Anti-NaN
**En tant que** Développeur de Sûreté Cognitive,  
**Je veux** implémenter la décomposition sigmoïdale de vitalité avec clipping de sécurité d'exposant et softening $\epsilon = 10^{-6}$,  
**Afin d'** éradiquer tout risque de débordement floating-point ou d'apparition de valeurs de coordonnées `NaN`.

* **Critères d'Acceptation :**
  - **Given** Un intervalle de temps t tendant vers l'infini ($t = 10^9$) et des nœuds superposés à distance d_ij = 0.
  - **When** J'applique l'équation de vitalité d'ENGRAM avec `clip_limit = 50.0` et l'epsilon de softening.
  - **Then** La formule ne produit aucune erreur de division par zéro ni d'overflow exponentiel.
  - **And** Le score de vitalité décline de manière lissée pour franchir le seuil de dormance < 20 à J90 précis.

---

## Epic 3 : La Constellation Graphique Bi-Modale 2D/3D (AntV G6, Cosmos & Three.js)

Cette Épique régit le double-rendu géométrique cérébral sur le frontend React 18.

### Story 3.1 : Coupe Axiale Horizontale 2D (AntV G6 v5 & Cosmos)
**En tant que** Développeur Frontend,  
**Je veux** coder la vue de dessus horizontale en s'appuyant sur AntV G6 ou Cosmos,  
**Afin de** présenter le savoir séparé en deux hémisphères par la fissure longitudinale centrale.

* **Critères d'Acceptation :**
  - **Given** Une liste de concepts issus de `scy_synaptic_vitality`.
  - **When** L'utilisateur active la vue 2D horizontale.
  - **Then** Les nœuds sont contraints par l'équation d'enveloppe polaire sagittale et se positionnent de façon symétrique de part et d'autre de la fente centrale.
  - **And** Le rendu s'exécute à 60 FPS constants via WebGL.

### Story 3.2 : Volume 3D Matérialisé de la KB (Three.js)
**En tant que** Développeur Frontend,  
**Je veux** coder la vue sphérique tridimensionnelle du cerveau sémantique via Three.js,  
**Afin que** l'utilisateur puisse faire pivoter et naviguer dans sa base complète de connaissances de manière immersive.

* **Critères d'Acceptation :**
  - **Given** L'intégration de Three.js et OrbitControls dans React 18.
  - **When** L'utilisateur clique et glisse sa souris pour orbiter autour de sa base de connaissances globale.
  - **Then** Le cerveau s'oriente de manière tridimensionnelle en direct.
  - **And** Les nœuds d'arrière-plan subissent le Z-Buffering sémantique (taille et opacité atténuées de moitié) tandis que les nœuds d'avant-plan rayonnent avec éclat.

---

## Epic 4 : L'Orchestration Ingestion Mode Normal & Pack par Défaut (Mastra TS)

Cette Épique gère la plomberie des 11 Cores et la génération automatique multi-outputs.

### Story 4.1 : L'Agent Déterministe de Suggestions (AGENT-14)
**En tant que** Spécialiste d'Orchestration IA,  
**Je veux** implémenter l'arbre de décision déterministe d'AGENT-14,  
**Afin d'** obtenir des propositions de documents instantanées sans appel LLM payant.

* **Critères d'Acceptation :**
  - **Given** Les métadonnées d'une source extraite par Docling (ex: codeblocks détectés).
  - **When** J'invoque `AGENT-14`.
  - **Then** Il renvoie en moins de 5ms exactement 3 codes de documents pertinents (ex: `G01`, `C01`, `W01`) sans aucun appel LLM externe.

---

## Epic 5 : La Console Créateur Élite & Sécurité (k-anonymat & WAL Sync)

Cette Épique sécurise la vie privée des étudiants et blinde la synchronisation locale.

### Story 5.1 : Masquage RGPD k-anonymat
**En tant que** Garant de la Vie Privée,  
**Je veux** filtrer la console d'administration par un masque de k-anonymisation ($k \ge 10$),  
**Afin d'** empêcher le créateur d'espionner ou de lire les profils de mémorisation ou les conversations privées individuelles des élèves.

* **Critères d'Acceptation :**
  - **Given** Une cohorte active de moins de 10 étudiants.
  - **When** Le créateur ouvre sa console d'insights.
  - **Then** Aucune donnée sémantique ou graphique n'est affichée (le message d'attente de taille minimale s'affiche).
  - **And** Dès que la cohorte dépasse 10 étudiants, les données sont présentées sous forme d'agrégats de moyennes anonymisés.

### Story 5.2 : File IndexedDB WAL d'Anti-Panne
**En tant que** Développeur Frontend,  
**Je veux** implémenter un journal de transactions (Write-Ahead Log) dans l'IndexedDB locale,  
**Afin de** parer à toute coupure réseau ou crash batterie pendant une session de révision active.

* **Critères d'Acceptation :**
  - **Given** Une file `scy_sync_queue` contenant 50 révisions FSRS locales en attente de synchronisation.
  - **When** Le navigateur subit un crash brutal ou une déconnexion.
  - **Then** Le WAL récupère et sécurise l'intégralité des transactions saines de mémorisation.
  - **And** Dès le retour de la connexion, le service worker rejoue le WAL et transmet les lots asynchrones à Northflank PostgreSQL sans perte de données.

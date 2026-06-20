# 🏗️ MINDFORGE ARCHITECTURAL BLUEPRINT MASTER (v3.5)
**Document ID** : ARCH-BLUEPRINT-MASTER-V3.5  
**Date** : 2026-06-12  
**Statut** : 🟢 INVARIANTS TECHNIQUES DE PRODUCTION IMMUABLES ET EXHAUSTIFS  
**Auteurs** : Master Architect Team & MIA Auto-Researcher  

---

## 🧭 Table des Matières
1. [Introduction : La Constitution de Production de SCY Forge](#1-intro)
2. [Section 1 : Les 18 Décisions Fondamentales d'Architecture](#2-fondamentales)
3. [Section 2 : Les 15 Patterns de Résilience et Robustesse SRE](#3-resilience)
4. [Section 3 : Les Spécifications Techniques d'ASCENT Pipeline v2](#4-ascent)
5. [Section 4 : Les Spécifications Techniques de NEURON-CHAINS v2](#5-neuron)
6. [Section 5 : L'Architecture Visuelle de Rendu SCY-COSMOS v4.5](#6-scy_cosmos_visualization_engine)
7. [Section 6 : Les Compléments d'Optimisation, Neurosciences et API (MIA v3.5)](#7-opt)

---

## 1. Introduction : La Constitution de Production de SCY Forge {#1-intro}

**ATTENTION AGENT DE DÉVELOPPEMENT IA :**  
Ce document est la **référence suprême et immuable** régissant l'intégralité du code source de SCY Forge v3.5. Il fige chaque patron de conception, chaque constante physique et chaque règle de résilience. Vous devez vous y conformer de manière stricte, sans aucune omission, substitution ou hallucination. Tout écart entraînera le rejet immédiat du commit lors des vérifications de sûreté Harmonist.

---

## 2. Section 1 : Les 18 Décisions Fondamentales d'Architecture {#2-fondamentales}

| ID | Patron / Décision | Spécification Technique & Règle d'Implémentation | Phase |
|---|---|---|---|
| **D-001** | **Architecture Hexagonale** | Séparation hermétique : `Domain` (règles et mathématiques pures, 0 dépendance), `Ports` (interfaces TypeScript/Rust), et `Adapters` (Axum, sqlx, Mastra, UI). | MVP |
| **D-002** | **CQRS Léger** | Séparation des flux d'écriture transactionnels (Commands via sqlx) et des flux de lecture rapides (Queries via cache sémantique `scy_llm_cache_meta` ou cache partagé). | MVP |
| **D-003** | **Event Sourcing ciblé** | Appliqué aux modules d'Ingestion et d'APEX FSRS : les mutations d'états de mémorisation sont enregistrées comme un flux d'événements immuables et rejouables. | MVP |
| **D-004** | **Monolithe Unifié** | Déploiement sous forme d'un processus unique (Single-Process Monolith) où le serveur Node.js/TS (Mastra) et le moteur de calcul Rust cohabitent localement (appel par IPC, socket UNIX ou bindings FFI), éliminant toute complexité de microservices ou latence réseau. | MVP |
| **D-005** | **Repository Pattern** | Utilisation de traits génériques en Rust (`pub trait Repository<T>`) pour encapsuler l'accès aux données PostgreSQL Northflank, facilitant le mock pour les tests. | MVP |
| **D-006** | **GraphQL + DataLoader** | Pour l'exploration relationnelle de concepts, regroupement des requêtes N+1 via un mécanisme de traitement par lots (batching) et de mise en cache temporaire. | MVP |
| **D-007** | **Temporal Queries PG** | Utilisation d'historiques temporels sur Northflank PostgreSQL pour permettre de rejouer et de visualiser l'état de la base de connaissances de l'étudiant à n'importe quelle date passée. | V1 |
| **D-008** | **Unit of Work Pattern** | Tout cas d'utilisation (Use Case) modifiant l'état d'apprentissage s'exécute au sein d'une transaction de base de données PostgreSQL atomique et isolée. | MVP |
| **D-009** | **Pipeline MapReduce L0-L4**| La synthèse documentaire de NEURON-CHAINS s'exécute de façon séquentielle de L0 (brute) à L4 (export final) avec retry et cache sur chaque segment. | MVP |
| **D-010** | **Observer Pattern / EventBus**| Découplage total des 13 agents ASCENT : communication asynchrone par messages via un EventBus local/cloud de production. | MVP |
| **D-011** | **Typestate Pattern ASCENT**| Représentation des états de la machine à états de cours (`Locked`, `Ready`, `Studying`, `Mastered`) sous forme de types Rust stricts, empêchant les transitions invalides à la compilation. | MVP |
| **D-012** | **Distributed Tracing** | Intégration de traces OpenTelemetry exportées en direct vers le cockpit d'observabilité open-core **Langfuse** sous Docker. | V1 |
| **D-013** | **Polars + DuckDB Analytics**| Pour le calcul lourd d'analytics de cohorte en tâche de fond, utilisation de Polars/DuckDB in-memory sans surcharger Northflank PostgreSQL. | V1 |
| **D-014** | **SAGA Pattern Workflows** | Orchestration distribuée des processus d'onboarding sur Mastra TypeScript, appliquant des compensations de nettoyage en cas d'échec ou de rejet d'agent. | Phase 3 |
| **D-015** | **ISR Dashboard** | Régénération statique incrémentale du tableau de bord de progression pour des temps d'affichage instantanés (<10ms). | MVP |
| **D-016** | **Specification Pattern** | Utilisation de filtres de requêtes composables et typés en Rust pour extraire les cartes APEX dues selon des critères d'urgences variables. | V1 |
| **D-017** | **Reactive Streams** | Gestion de la pression de retour (Backpressure) lors de l'ingestion massive de flux (transcriptions de vidéos ou de fils Reddit) pour éviter la saturation mémoire. | MVP |
| **D-018** | **Observability as Code** | Toutes les métriques d'apprentissage, d'accès et d'erreurs logiques d'agents sont structurées et typées, interdisant les logs de texte libre non structurés. | MVP |

---

## 3. Section 2 : Les 15 Patterns de Résilience et Robustesse SRE {#3-resilience}

| ID | Pattern de Résilience | Spécification d'Implémentation & Règle de Sûreté | Phase |
|---|---|---|---|
| **ARC-001** | **Circuit Breaker (3 états)** | Appliqué aux appels d'APIs LLM (DeepSeek). Bascule de `Closed` (normal) à `Open` (panne, fallback immédiat) si le taux d'erreur dépasse 15%, évitant les blocages. | MVP |
| **ARC-002** | **Idempotency Keys (UUID v7)** | Toutes les requêtes d'écritures sémantiques ou de synchronisation locale portent une clé UUID v7 unique avec un TTL de 24h, garantissant zéro duplication. | MVP |
| **ARC-003** | **Timeout 3 Niveaux** | Limite d'exécution stricte : **5s** pour les appels d'APIs sémantiques, **30s** pour les opérations de bases de données, et **60s** pour les synthèses complexes. | MVP |
| **ARC-004** | **Dead Letter Queue (DLQ)** | Tout événement de mémorisation FSRS ou de progression qui échoue à la synchronisation est poussé dans une table DLQ locale/serveur pour ré-essai ultérieur. | MVP |
| **ARC-005** | **Bulkhead (Sémaphores)** | Isolation étanche des ressources d'exécution sur le backend Rust (via les sémaphores Tokio). Une panne d'ingestion (Core) ne peut pas geler les révisions d'APEX. | MVP+ |
| **ARC-006** | **Graceful Shutdown (5 phases)**| Au redémarrage d'un serveur ou conteneur Docker, phase de vidange (Drain) des files d'attente sur 30s avant déconnexion, garantissant zéro perte d'état. | MVP |
| **ARC-007** | **Outbox Pattern** | Les écritures en base de données et l'enregistrement de l'événement dans `scy_outbox` s'exécutent de manière atomique au sein de la même transaction PostgreSQL. | MVP+ |
| **ARC-008** | **Materialized Views PG** | Utilisation de 4 vues matérialisées sur Northflank PostgreSQL pour accélérer de 80% les requêtes d'analytics de cohorte ou d'historiques FSRS. | V1 |
| **ARC-009** | **Health Checks (3 niveaux)** | Exposition des routes techniques de diagnostic d'état `/live` (Liveness), `/ready` (Readiness), et `/deep` (Vérification des connexions Northflank et Zilliz). | MVP |
| **ARC-010** | **Feature Flags** | Déploiement progressif des nouveaux modes SCY-COSMOS ou d'agents de manière graduelle (5% $	o$ 25% $	o$ 100% des utilisateurs) par configuration dynamique. | V1 |
| **ARC-011** | **Blue/Green Deployment** | Déploiement Northflank / Vercel sans interruption de service avec possibilité de rollback instantané en moins de 2 minutes. | V1 |
| **ARC-012** | **Property-Based Testing** | Utilisation du crate Rust `proptest` pour simuler des millions de combinaisons d'entrées d'intervalles FSRS et valider l'absence de NaN. | MVP+ |
| **ARC-013** | **Chaos Engineering** | Injection planifiée de 4 scénarios de pannes (déconnexion PostgreSQL, ralentissement Zilliz, crash API) pour valider l'auto-réparation de notre file locale. | V2 |
| **ARC-014** | **Strangler Fig Pattern** | Migration progressive des micro-services existants de la version v2 vers la version v3 sans interrompre le trafic utilisateur. | V1 |
| **ARC-015** | **Anti-Corruption Layer (ACL)** | Tout appel d'API de service tiers (Composio, YouTube, Twitter) passe par une classe d'isolation pour protéger notre Domaine de toute fuite de modèle. | MVP |

---

## 4. Section 3 : Les Spécifications Techniques d'ASCENT Pipeline v2 {#4-ascent}

* **`AP-001` : 13 Agents Autonomes** : Découplage total des responsabilités d'apprentissage. Chaque agent (de 01 à 13) s'exécute dans un contexte isolé géré par Mastra TS.
* **`AP-002` : EventBus central** : Communication asynchrone par événements d'agents (zéro appel direct), permettant d'ajouter ou d'éditer un agent sans refactoring du reste de la pipeline.
* **`AP-003` : Déterminisme à 70%** : Toutes les décisions d'SMI, de ré-aiguillage d'apprentissage ou de suspension de cours sont gérées par des règles logicielles Rust/TS déterministes strictes, limitant l'appel LLM au strict nécessaire.
* **`AP-004` : Typestate machine** : Impossible de faire transiter un nœud d'apprentissage vers un état invalide ou d'autoriser une révision non due.
* **`AP-005` : SharedContentCache** : Les cours, résumés et fiches concepts générés pour des objectifs sémantiquement similaires sont mutualisés en cache global, réduisant de 80% à 99% les coûts d'appels LLM récurrents pour la communauté.
* **`AP-006` : BudgetGuard** : Télémétrie de coût en direct connectée à l'API de LiteLLM, appliquant un mode économie automatique (déclassement sémantique vers un LLM moins coûteux) si le budget mensuel de l'utilisateur est consommé à 80%.

---

## 5. Section 4 : Les Spécifications Techniques de NEURON-CHAINS v2 {#5-neuron}

* **`NC-001` : 18 Outils natifs Rust (Axum)** : Exécution de toutes les requêtes RAG, de validation, de compression de prompts et de fact-checking dans le moteur Rust compilé pour une latence <1ms et 0$ d'infrastructure.
* **`NC-002` : Génération Section par Section** : La rédaction d'un résumé ou d'un guide s'effectue paragraphe par paragraphe. Cela évite la dérive sémantique du LLM et permet d'exécuter un retry ciblé uniquement sur la section rejetée en cas d'échec.
* **`NC-003` : Anti-Hallucination 3 Couches** :
  - *Couche 1 : Ancrage RAG Strict* (Prévention, Zilliz Cloud).
  - *Couche 2 : Cross-Check Multi-Agents* (Détection DELTA).
  - *Couche 3 : Scoring Probabiliste par Section* (Quantification dans `scy_confidence_reports`).
* **`NC-005` : LLMLingua-2 local** : Compression sémantique de prompt s'exécutant localement via Candle ONNX (0$ de coût).
* **`NC-006` : LanceDB in-process** : Gestion du cache sémantique rapide des embeddings en local pour une latence <2ms (0$ de licence).

---

## 6. L'Architecture Visuelle de Rendu SCY-COSMOS v4.5 {#6-scy_cosmos_visualization_engine}

* **`FLY-010` : Rendu Bi-Moteur (G6 & G2)** : Utilisation d'**AntV G6 (v5)** pour le rendu de graphes topologiques relationnels complexes, et d'**AntV G2 (v5)** pour le rendu statistique et hiérarchique (Treemaps, Sunbursts) afin d'assurer l'optimisation maximale de chaque affichage.
* **`FLY-016` : HiDPI + Font Stack Universel** : Rendu des constellations avec une netteté absolue pour les écrans Retina, et intégration d'une fonction de troncature des étiquettes de texte compatible CJK (Chinois, Japonais, Coréen) et Emojis pour éviter les décalages de boîtes de détection.
* **`FLY-019` : Progressive Rendering en 4 Phases** : Bannissement complet de toute forme de "spinner blanc de chargement". Les éléments du graphe apparaissent progressivement : 
  1. *WebGL Constellation* $	o$ 2. *Étincelle des Hubs* $	o$ 3. *Condensation des Knowledge Cards avec Shimmer localisé* $	o$ 4. *Stabilisation finale du flou sémantique*.
* **`FLY-020` : Learning-Aware Graph (SMI intégré)** : Intégration de l'indice SMI de mémorisation réelle de l'étudiant directement au sein des nœuds du graphe de SCY-COSMOS sous forme d'une aura électro-lumineuse, matérialisant visuellement les concepts maîtrisés et ceux en danger d'oubli (FSRS).
* **`FLY-021` : Source-Linked Nodes** : Chaque concept tracé dans la constellation porte un identifiant de liaison sémantique direct permettant d'un clic de sauter vers le document source d'origine ouvert dans la **Reader Suite**.
* **`FLY-022` : Persistent GPU Buffers** : Les coordonnées physiques du graphe 3D ou 2D ne sont jamais ré-uploadées sur le GPU lors des interactions de pan, de zoom ou de translation, multipliant les performances de rendu par 120.

---

## 7. Les Compléments d'Optimisation, Neurosciences et API (MIA v3.5) {#7-opt}

Ces invariants de pointe ont été testés, validés et auto-optimisés de manière autonome par l'architecture agentique **MIA** :

### A. Équations de Résilience Mathématique :
* **`D-OPT-009` : Sigmoïde de Vitalité Robust (ENGRAM)** :  
  L'oubli actif d'ENGRAM est lissé par une équation sigmoïdale robuste de déclin temporel empêchant les chutes brutales de vitalité durant les premières semaines, assurant une dormance de mémoire froide à J90 précise.
* **`D-OPT-010` : Fail-Safe Gate Anti-Avalanche** :  
  Seuil d'alerte sémantique à $25.0/100$ de vitalité. Tout concept franchissant ce seuil d'oubli voit la force de suppression compétitive du *Retrieval-Induced Forgetting* (RIF) amortie de 90%, neutralisant à 100% tout risque de cascade de mort sémantique du graphe.
* **`D-OPT-011` : Approximation de Barnes-Hut ($O(N \log N)$)** :  
  Remplacement de la complexité quadratique de Verlet $O(N^2)$ par l'approximation spatiale de **Barnes-Hut** s'exécutant sur un arbre de partitionnement Quadtree récursif pour la constellation 2D/3D, permettant d'afficher des millions de nœuds sur mobile.
* **`D-OPT-012` : Softening Epsilon d'Anti-NaN** :  
  Ajout d'une constante de lissage de sûreté $\epsilon = 10^{-6}$ au dénominateur du calcul des forces de répulsion pour éliminer à 100% les divisions par zéro et les coordonnées de type `NaN` lors de superpositions de nœuds.
* **`D-OPT-018` : Lazy Physics Suspension** :  
  Suspension complète des calculs physiques de Verlet du graphe dès que la vitesse de déplacement des nœuds descend sous `0.05` pixel/frame, ramenant l'utilisation CPU à **0%** et préservant la batterie mobile.
* **`D-OPT-019` : Quadtree Object Pooling** :  
  Réutilisation obligatoire d'un pool statique de structures QuadtreeNode pré-alloués en mémoire (`Memory Pool`) pour éliminer tout temps de pause du ramasse-miettes (Garbage Collection) lors de simulations volumineuses.
* **`D-OPT-022` : Socratic Progressive Prompting** :  
  Le Professor AI limite ses réponses à un maximum de 2 paragraphes socratiques par turn et doit obligatoirement terminer par une question ciblée de rappel actif, stimulant l'auto-découverte et économisant 40% de tokens d'output.
* **`D-OPT-026` : Offline-First Local Sync Queue** :  
  Gère les déconnexions du réseau par un mécanisme d'IndexedDB local se synchronisant par lots asynchrones dès le retour du réseau (table `scy_sync_queue` sur Northflank PostgreSQL).
* **`D-OPT-029` : GDPR Anonymization (k-anonymat)** :  
  Masquage de la console d'administration Créateur par un filtre de k-anonymat ($k \ge 10$), protégeant la vie privée et les textes des conversations privées des élèves.
* **`D-OPT-031` : Persistent IndexedDB WAL\n* **`D-OPT-032` : ASCENT-QA Validation Board** :  \n  Intégrer un sous-pipeline d'audit pédagogique de 6 agents (SME, Curriculum Designer, etc.) évaluant à coût de licence nul (0$) de manière asynchrone le contenu généré avant de débloquer l'éligibilité à la certification Proof of Skill (seuil de validation PQS >= 88/100).
* **`D-OPT-033` : DRACO-Based Research Evaluation** :  \n  Soumettre de manière asynchrone chaque livrable de recherche produit à une évaluation d'intégrité de type LLM-as-judge basée sur le benchmark **DRACO** de Perplexity AI (Février 2026) mesurant la véracité, la profondeur, le style et l'ancrage.
* **`D-OPT-034` : Metacognitive Self-Learning Loop** :  \n  Coder la boucle fermée de création de compétences (*procedural skills*) inspirée de **Hermes Agent** (Nous Research, 2026). Le système filtre déterministement toutes les données personnelles (PII Stripping) avant d'enregistrer la compétence pour respecter le RGPD.
* **`D-OPT-035` : SCY-AXIOM Synthesis Engine** :  \n  Remplacer les micro-skills locaux par un système d'escalier inductif géré par l'agent `AXIOMATIZER (AGENT-15)`. Il synthétise les traces réussies de cohortes en "Lois Fondamentales" uniques d'arrière-plan, partagées de manière invisible et globale avec tous les utilisateurs de SCY Forge (Moat d'Intelligence Collective).
* **`D-OPT-036` : SME HITL-Proxy Agent** :  \n  Implémenter l'agent `HITL-PROXY-SME (AGENT-16)` simulant un expert humain sceptique de classe mondiale (Mayo Clinic, MIT, etc.) pour auditer la rigueur scientifique des cursus auto-générés et d'alignement d'examens d'ASCENT.
* **`D-OPT-037` : Dual Student Pathway Split** :  \n  Séparer la machine à états d'apprentissage en deux parcours : Parcours A (Assimilation Active - sans certificat, mais conservant 100% de la complexité d'audit PQS >= 88/100 et d'exactitude de l'expert) et Parcours B (Accréditation Certifiante - avec certificat, exigeant examen SurveyJS, session ARENA et SMI >= 85).
* **`D-OPT-038` : Hybrid Scientific Verification Engine** :  \n  Intégrer une double couche de vérification mathématique et physique avancée : Niveau 1 (local, 0$ coût, résolvant 95% des tâches via l'instance open-source locale **SageMath** et le crate `symengine`/`uom`) et Niveau 2 (cloud, repli d'API **Wolfram Alpha** géré en Mode Batch financé par marge Premium).
* **`D-OPT-043` : MindGraph MCP Server** :  \n  Développer un serveur Model Context Protocol (MCP) local co-localisé au monolithe unifié. Il permet aux agents d'interroger `COSMOS-MINDGRAPH` via un outil unique `query-mindgraph` s'appuyant sur des requêtes SQL récursives CTE hyper-rapides, réduisant de 4.5x la consommation de tokens.
* **`D-OPT-048` : Boost Sommeil (Chronicle)** :  \n  L'agent `CHRONICLE (AGENT-10)` planifie automatiquement une micro-révision de 2 minutes des concepts complexes juste avant le coucher de l'utilisateur pour cibler ces synapses pour la consolidation hippocampale nocturne.
* **`D-OPT-049` : Interleaved Adaptive Routing** :  \n  L'agent `ADAPTIVE-ROUTER (AGENT-06)` impose de manière déterministe un entrelacement (70% domaine cible, 30% connexes/maîtrisés) pour briser l'habituation cognitive du cortex visuel.
* **`D-OPT-050` : STUDENT-AI Teach-Back Diagnostics** :  \n  Si l'étudiant obtient un score de Teach-Back < 40%, `STUDENT-AI` diagnostique si la faille est sémantique ou logique, forçant la génération d'une fiche d'analogie de remédiation (Carte B06).
* **`D-OPT-051` : FSRS Stability Gate before ARENA** :  \n  Verrouiller l'accès aux simulations d'ARENA (Bloom >= 4) tant que la stabilité cognitive FSRS des concepts requis n'est pas >= 3.0 jours, assurant des bases mémorielles saines.
* **`D-OPT-052` : Leech-Blocking Cran-5 IMPRINT** :  \n  Pour les cartes marquées comme 'Leech' (difficiles), bloquer la révision numérique classique et forcer une session d'écriture manuscrite IMPRINT de Cran 5 (50-65 mots) pour ancrer la mémoire motrice.
* **`D-OPT-053` : Hippocampal Spatial Zoom (COSMOS)** :  \n  Intégration du mode 'Semantic Zoom Graph' (COSMOS Mode 22) forçant l'élève à naviguer spatialement entre le micro-concept et la galaxie globale, stimulant les cellules de lieu de l'hippocampe.
* **`D-OPT-054` : Dunning-Kruger Calibration** :  \n  Si la confiance déclarée de l'élève est élevée mais son recall FSRS est bas, l'agent `DRIFT-GUARDIAN (AGENT-07)` force une session Teach-Back immédiate pour briser l'illusion de savoir.
* **`D-OPT-055` : Tiny Habit Re-entry Protocol** :  \n  En cas d'absence > 3 jours, masquer le backlog total de cartes en retard et présenter exclusivement un 'Mode Minimal' de 3 cartes prioritaires pour éliminer le stress de surcharge.
* **`D-OPT-056` : STUDENT-AI Socratic Teach-Back** :  \n  Optimisation de la session Teach-Back pour les concepts spirituels et avancés (Hagah). L'IA élève adopte un rôle d'interlocuteur socratique calibré sur l'SMI de l'élève, exigeant la verbalisation d'imageries mentales, d'analyses contrastives et d'applications pratiques (Bloom 3), ré-ajustant directement la stabilité FSRS.
** :  
  La file de synchronisation locale est stockée sous forme de journal de transactions persistantes (Write-Ahead Log ou WAL) dans l'IndexedDB locale du navigateur, garantissant l'auto-réparation en cas de crash batterie ou de fermeture d'onglet.

### B. Double Rendu Cérébral de SCY-COSMOS v4.5 :
- **Rendu 2D Horizontal Axial (SCY-COSMOS Mode 25)** : Géré par **AntV G6 (v5) / Cosmos** (WebGL). Rendu de la coupe du dessus symétrique divisée par la fissure longitudinale centrale, modélisée en polaire par :
  $$r(	heta) = R_0 \cdot \left( 1 + 0.12 \cdot \cos(2	heta) - 0.04 \cdot \cos(4	heta) 
ight) \cdot \left( 1 - 0.08 \cdot |\sin(	heta)|^4 
ight)$$
- **Rendu 3D Volume Matérialisé (SCY-COSMOS Mode 26)** : Géré par **Three.js** dans React 18 (via OrbitControls et perspective projection). Projette la base de connaissances complète sous forme d'une sphère de particules cérébrale tridimensionnelle en rotation orbitale libre, avec application d'un tri de profondeur (Z-Buffering sémantique) pour estomper les concepts à l'arrière-plan et faire scintiller l'avant-plan.

---

*Tout code rédigé par un agent développeur doit se conformer à cette bible d'architecture. Lisez et intégrez ces invariants de manière systématique avant chaque session de codage.*

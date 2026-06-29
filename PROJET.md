# SCYForge — Documentation de Projet

## 1. Identité du projet

- **Nom** : SCYForge
- **Signature** : Synapse Cognitive Yield Forge
- **Type** : Plateforme d’apprentissage agentique
- **Cible** : apprenants et créateurs de savoir
- **Ambition produit** : décrire un objectif d’apprentissage et laisser le système orchestrer automatiquement ingestion, génération, rétention, visualisation et certification
- **Logique produit centrale** : zéro friction, < 2 clics pour démarrer

---

## 2. Vision et finalité

SCYForge vise à :

- rendre l’apprentissage personnalisé massif sans effort manuel de structuration
- transformer n’importe quelle source en parcours d’apprentissage vérifiable
- piloter la rétention long terme du savoir avec des méthodes fondées scientifiquement
- exposer les connaissances sous plusieurs métaphores visuelles et cognitives
- certifier des compétences avec traçabilité et preuves multiples
- accompagner l’apprenant comme un tuteur continu, pas comme un outil ponctuel

---

## 3. Problème adressé

- fragmentation des savoirs entre de multiples sources et formats
- charge ingénierie pédagogique trop élevée pour une adaptation personnalisée
- difficulté à retenir durablement des savoirs complexes
- absence de vue d’ensemble intelligente d’un corpus
- manque de validation pédagogique systématique
- certes, il existe des LMS, des outils de spaced repetition, des outils RAG
- SCYForge ambitionne de réunir ces dimensions dans une expérience unifiée et agentique

---

## 4. Solution proposée

- un objectif utilisateur simple comme point d’entrée
- 18 agents spécialisés qui orchestrent des microservices
- un moteur central capable de générer documents, cartes, parcours et questions
- un système de mémorisation algorithmique et inspectable
- une couche de visualisation augmentée du savoir
- un assistant conversationnel capable d’expliquer, vérifier et réviser
- un système de certification piloté par preuve et alignement pédagogique

---

## 5. Principes de conception

### 5.1 Philosophie produit

- l’utilisateur déclare une intention
- le système invente le chemin pédagogique sans demander de configuration expert
- tout est traçable et justifiable
- la complexité est absorbée par les agents, pas par l’utilisateur

### 5.2 Règles d’usage internes

- Spec → Plan → Tâches → Code → Tests
- architecture hexagonale
- découplage total entre services par EventBus
- priorisation des implémentations à coût nul
- interdépendances documentées et tests property-based
- code reproductible, vérifiable, audit-friendly

---

## 6. Stack technique

### 6.1 Couche calcul
- Rust + Axum + Tokio

### 6.2 Couche orchestration
- TypeScript + Mastra

### 6.3 Interface
- React 18 + Vite + TailwindCSS

### 6.4 Bases de données
- PostgreSQL 15+ avec pgvector
- SQLite WAL en mode local/desktop

### 6.5 Recherche et mémoire
- Zilliz Cloud Serverless ou Milvus Lite
- SearxNG + Perplexica ou Vane en container

### 6.6 Intelligence artificielle
- DeepSeek V4 en mode gratuit principal
- Claude en premium
- routage adaptatif entre fournisseurs

### 6.7 Déploiement
- Northflank pour les backends
- Vercel pour le frontend
- Docker Compose pour les services compagnons

---

## 7. Architecture applicative

### 7.1 Vue d’ensemble

```
Utilisateur
   │
   ▼
Frontend React
   │
   ├── consommateur ──► Backend TypeScript / Mastra
   │                        │
   │                        ▼
   │                  Backend Rust
   │                        │
   ├── EventBus ◄────► PostgreSQL / Zilliz / Sidecars
   │
   └── Visualisation, Retention, RAG, Export
```

### 7.2 Backend Rust
responsabilités :

- calculs lourds
- moteur de rétention FSRS
- moteur de graphe et rétention cognitive
- moteur neuroscientifique
- ingestion et chunking
- extraction et génération NEURON-CHAINS
- moteur RAG
- couche données et risques hallucination

organisation :

- `scy-eventbus`
- `scy-ingestion`
- `scy-neuron-chains`
- `scy-apex-fsrs`
- `scy-cosmos-kg`
- `scy-brain-rag`
- `scy-imprint`
- `scy-reader`
- `scy-shared`
- `src/` avec routes REST, adapters DB, clients infra, moteurs neuro

### 7.3 Backend TypeScript
responsabilités :

- orchestration agents métier
- pipeline ASCENT
- normal mode ingestion
- console B2B
- moteur automation progressive
- bibliothèque sagesse et coaching

### 7.4 Frontend React
responsabilités :

- expérience utilisateur de déclaration d’objectif
- visualisation COSMOS avec 26 modes
- sessions de révision
- interface chat BRAIN
- Reader Suite multi-format et multi-surface
- CHRONICLE et ARENA
- dashboard global, paramètres, automation, exports

### 7.5 Services compagnons
- SearxNG pour recherche fédérée
- Perplexica ou Vane pour recherche augmentée
- Nango pour le coffre d’identifiants
- LiveKit pour l’expérience vocale

---

## 8. Domaines métier

### 8.1 Ingestion
sources couvertes :

- YouTube
- web
- podcast
- académique
- drive
- finances
- réseaux sociaux
- wiki et science
- livres et ePub
- Anki

fonctions transverses :

- nettoyage HTML vers Markdown
- scraping résilient
- chunking hiérarchique
- déduplication
- file d’exécution asynchrone

### 8.2 NEURON-CHAINS
- orchestre la génération depuis les sources ingérées vers des savoirs utilisables
- boucle ReAct
- orchestration parallèle avec reprise et annulation
- sept chaînes spécialisées
- dix-huit outils dédiés
- anti-hallucination à trois niveaux
- cache sémantique et citation automatique

### 8.3 APEX / Rétention
- ordonnance les révisions selon un scheduler déterministe
- calcule un indice de maîtrise multi-dimensionnelle
- génère dix familles de cartes
- détecte et protège contre les cartes leeches
- propose un miroir cognitif et un enseignement actif

### 8.4 COSMOS
- construit un graphe de concepts
- expose vingt-six modes visuels
- détecte les lacunes
- assure la confiance et la double validation
- expose des API agentiques pour enrichir les parcours visuels

### 8.5 BRAIN
- interroge le savoir par triple retrieval
- reformule, rerank et résume avec garde-fous
- propose un tuteur socratique
- intègre la recherche web en direct
- embarque l’apprenant sous forme de chat contextuel

### 8.6 IMPRINT
- distille les idées en formats courts
- structure les insights sous forme arborescente
- reconstruit l’empreinte lexicale d’un concept

### 8.7 Reader Suite
- rend le savoir lisible et navigable
- permet d’annoter, exporter, comparer et relier
- unifie les deep links entre plusieurs surfaces du produit

### 8.8 ASCENT Pipeline
- reçoit l’objectif utilisateur
- planifie le DAG pédagogique
- pilote les sessions
- analyse la performance
- adapte le parcours selon le comportement
- certifie et trace
- assure la qualité collective via un comité multi-agents

### 8.9 CHRONICLE
- tient un journal conversationnel continu
- maintient la santé pédagogique
- propose le quotidien et l’attention
- assure l’humilité totale dans la communication

### 8.10 ARENA
- simule des situations pratiques
- coache la mise en situation
- valide la performance sous contrainte
- protège par un seuil de stabilité avant entrée

### 8.11 Normal Mode
- ingestion directe sans pipeline agentique complet
- utile pour une exploitation immédiate des contenus
- pas de DAG, pas de QA, pas rétention supervisée longue

### 8.12 B2B Creator Console
- expose les créateurs à leurs publics
- produit des analytics synthétiques
- boucle synaptique créateur → étudiant

---

## 9. Architecture orientée services

### 9.1 Services transverses

- EventBus
- NEURON-CHAINS
- APEX / FSRS
- COSMOS
- BRAIN
- IMPRINT
- Reader Suite
- Ingestion Cores

### 9.2 Services consommateurs

- ASCENT Pipeline
- Normal Mode
- B2B Creator Console

### 9.3 Principe d’interaction

- pas d’appel direct entre services
- communication asynchrone et typée
- traces, retry, dead letter queue

---

## 10. Flux de données principal

1. l’utilisateur décrit un objectif
2. l’agent interprète l’objectif
3. les ingesters collectent et structurent
4. les NEURON-CHAINS génèrent des savoirs organisés
5. le graphe est construit et enrichi
6. les cartes et parcours sont préparés
7. BRAIN devient disponible pour interroger
8. ASCENT planifie l’apprentissage
9. APEX planifie la rétention
10. l’utilisateur pratique, révise et progresse
11. les performances sont analysées
12. les certifications peuvent être délivrées
13. toutes ces interactions sont tracées et auditées

---

## 11. Modèle de données orienté produit

- utilisateur
- objectif
- source et ingestion
- document et chunk
- concept, noeud, lien
- carte, session, révision
- feedback et performance
- certification
- agent, run, log
- politique d’isolation multi-tenant par utilisateur

---

## 12. Choix techniques notables

- FSRS 5.0 comme scheduler prenant
- property-based testing ciblé pour les invariants mathématiques
- circuit breaker et budget par appel LLM
- recherche hybride dense + sparse + graphe + RRF
- lazy loading des moteurs de visualisation
- design system contraint tokens pour cohérence visuelle
- progression automation progressive selon maturité utilisateur

---

## 13. Sécurité, confidentialité et gouvernance

- isolation par utilisateur sur toutes les tables
- tokens obligatoires, jamais de secret dans les fichiers
- TLS, JWT, OAuth
- GDPR, anonymisation possible
- auditabilité complète des décisions agents
- journalisation conversationnelle respectant la charte d’humilité

---

## 14. Niveaux de qualité attendus

- couverture de tests supérieure à 80%
- validation Zod pour les données entrantes en TS
- serde / types Rust stricts pour les données métiers
- invariants documentés et vérifiés
- clippy / eslint / prettier en continu
- sécurité OWASP / propriétés métier protégées

---

## 15. Roadmap synthétique

Sprint 0

- fondations, POC, base de données et EventBus

Sprint 1

- ingestion multi-sources

Sprint 2

- NEURON-CHAINS transverses

Sprint 3

- APEX/FSRS et COSMOS

Sprint 4

- BRAIN, Reader Suite, IMPRINT

Sprint 5

- ASCENT, DAG, QA committee

Sprint 6

- CHRONICLE, ARENA, Normal Mode, B2B

Sprint 7

- moteur neuroscientifique, W3C-style polish, production

---

## 16. Glossaire

- ASCENT : pipeline principal des 18 agents
- APEX : moteur de rétention et cartes
- COSMOS : moteur de visualisation du savoir
- BRAIN : assistant conversationnel contextuel
- IMPRINT : moteur de résumé cognitif très condensé
- NEURON-CHAINS : moteur de génération et transformation des savoirs
- FSRS : algorithme de spaced repetition
- SMI : indice synthétique de maîtrise
- EventBus : bus d’événements asynchrone
- DAG : graphe dirigé acyclique de plan pédagogique
- RAG : retrieval augmented generation
- RRF : Reciprocal Rank Fusion
- PROPTEST : tests property-based Rust
- PIVOTIQ : couche de réconciliation multi-sources
- FORGE : protocole d’amorce cognitive
- RIF : compétition synaptique
- HITL : Human In The Loop

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Implémentation order — adapté pour cybe.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# SCY FORGE — IMPLEMENTATION ORDER
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

## Ordre Séquencé d'Implémentation (Bottom-Up)

> **Règle d'or** : les services transverses DOIVENT être codés AVANT les consommateurs.
> Un consommateur (ASCENT, Normal Mode) ne peut pas fonctionner sans ses services.

---

## SPRINT 0 — Fondation (Semaine 1) 🔴 BLOQUANT

### 0.1 POC Jour 4 (BLOQUANT — go/no-go)
```
□ Test 1 : G6 v5 + Louvain clustering 1000 concepts < 10s
□ Test 2 : DeepSeek V4 NER 100 concepts < 3s, précision ≥ 85% (GLiNER-micro en fallback local CPU)
□ Test 3 : Typst PDF génération complexe < 2s
□ Test 4 : PostgreSQL FTS natif (GIN index) + RRF hybrid search 1000 docs < 100ms
→ 4 GO = Lancer sprint | 1 NO-GO = Fallback | 2+ NO-GO = STOP
```

### 0.2 Infrastructure
```
□ PostgreSQL Northflank + pgvector + RLS multi-tenant
□ Zilliz Cloud Serverless (collection embeddings)
□ Docker Compose (searxng + perplexica sidecars)
□ EventBus crate (scy-eventbus) — SCY ForgeEvent enum + publisher + DLQ
□ scy-shared crate (types partagés : User, Goal, Node, Card, Concept, AppError)
□ .env.example + secrets management (Northflank keyring)
□ Health checks 3 niveaux (/live, /ready, /deep)
□ Migrations SQL 001_init (tables core : users, sources, documents, chunks, concepts)
```

---

## SPRINT 1 — Ingestion Cores (Semaine 2)

### 1.1 Ingestion (Service Transverse)
```
□ scy-ingestion crate
□ MapReduce L0-L4 (chunking 500-2000 tokens, overlap 10%)
□ c01 YouTube (yt-dlp + yt-transcript-rs + Whisper fallback)
□ c02 Web Search Engine V2 (SearxNG + Perplexica + Scrapling + dom_smoothie)
□ c03 Podcast (feed-rs + Whisper + pyannote diarization)
□ c04 Academic (DOI/arXiv/Scholar + cross-ref)
□ c05 Google Drive (Composio OAuth + Docling)
□ Dé-duplication (mfg_shared_content_cache)
□ SAGA async queue (mfg_sync_queue)
```

---

## SPRINT 2 — NEURON-CHAINS (Semaines 3-4) 🔴 CRITIQUE

### 2.1 NEURON-CHAINS (Service Transverse — le plus consommé)
```
□ scy-neuron-chains crate
□ APEX-AGENT (boucle ReAct : Reason→Act→Observe)
□ Orchestrateur parallèle (JoinSet + CancellationToken, D-OPT-059)
□ Chaîne ALPHA (extraction + chunking + résumés L1/L2/L3)
□ Chaîne BETA (taxonomiste + relations + PageRank)
□ Chaîne EPSILON (cartes B01-B05 + exercices Template Gold)
□ 18 Tools (T01-T18) avec Rig traits composables
□ Anti-hallucination 3 couches (ancrage RAG + cross-check + scoring)
□ Score de confiance par section (T12 ConfidenceCalc)
□ LlmRouter + BudgetGuard (DeepSeek V4 + Prompt Caching D-OPT-003)
□ LLMLingua-2 compression (candle ONNX, -60% tokens)
□ SemanticCache (LanceDB, threshold 0.87)
□ Citation Sourcing (T08 CitationTracker + [1][2] exposants cliquables)
```

---

## SPRINT 3 — APEX/FSRS + COSMOS (Semaines 5-6)

### 3.1 APEX/FSRS (Service Transverse)
```
□ scy-apex-fsrs crate
□ FSRS 5.0 scheduler (fsrs 0.6, S/D/R=e^(-t/S), 4 états, feedback 4 niveaux)
□ 10 types de cartes (B01-B10) + leech detection
□ SMI Calculator (5 dimensions : Rétention 35% + Profondeur 25% + Miroir 20% + Métacog 10% + Cohérence 5%)
□ Due Cards Forecast 30j
□ Calibration 17 paramètres (après 1000+ révisions)
□ Monte Carlo Self-Consistency Checker (D-OPT-028)
□ Import/Export Anki (.apkg SM-2↔FSRS)
□ Miroir Cognitif 3 modes
□ TTS étendu (touche R) + Deep Links (D-OPT-002)
```

### 3.2 COSMOS (Service Transverse)
```
□ scy-cosmos-kg crate (data layer graphe)
□ Knowledge Graph (graphology + PageRank + Louvain clustering)
□ Gap Detection (prérequis manquants → nœuds rouges)
□ Auto-Graph (cosine > 0.75 + badge confiance)
□ AI Confidence System (multi-signaux, V/X validation, feedback loop)
□ Double Validation Sceau (consensus doré IA+Humain)
□ Semantic Lenses (4 lentilles : Temporelle/Épistémique/Émotionnelle/ASCENT)
□ MindGraph MCP Server (D-OPT-043, SQL CTE, -4.5× tokens)
□ Frontend : 26 modes (lazy-loaded) + 12 engines + WebGPU
□ CosmosAgentAPI (agents peuvent visualize/compare/highlight)
□ Neural Ignition Reveal (4 phases cinématiques)
□ Reveal by Relevance (top 150 concepts)
□ Prescriptive Insights (max 3 recommandations, Rust $0)
□ Design tokens application (palette stricte)
```

---

## SPRINT 4 — BRAIN + Reader Suite + IMPRINT (Semaines 7-8)

### 4.1 BRAIN (Service Transverse)
```
□ scy-brain-rag crate
□ Triple Retrieval (Dense pgvector + BM25 PostgreSQL FTS + Graph traversal + RRF k=60)
□ Phase 1 : HyDE + KG RAG
□ Phase 2 : Query Rewriting ×3 + Cross-Encoder reranking + LLMLingua-2
□ Professor AI (Socratic Progressive Prompting D-OPT-022, Thread-of-Thought D-OPT-027)
□ Fail-Safe Backup (D-OPT-021)
□ Live Web Search (Perplexica sidecar integration)
□ 3 modes source : Base cumulative | Internet | Hybride
□ Onboarding gamifié (Guest mode + 5 étapes + TTFV < 90s)
```

### 4.2 Reader Suite (Service Transverse)
```
□ scy-reader crate
□ File Viewer (PDF/EPUB/MD/DOCX/HTML/LaTeX/Jupyter/CSV/PPTX, 3 panneaux)
□ Web Viewer (read-only + score confiance + export 9 formats)
□ Book Orchestrator (7 intentions + select_cosmos_modes déterministe)
□ Page Gallery (miniatures PDF.js côté client + virtual scroll)
□ Deep Links unifiés (5 surfaces → Reader Suite position exacte)
□ Export 9 formats (PDF Typst, DOCX, HTML, MD, LaTeX, .apkg, Excel, ZIP, CSV)
```

### 4.3 IMPRINT (Service Transverse)
```
□ scy-imprint crate
□ CRE Engine (5 crans : 200-300 → 50-65 mots)
□ Garniture Engine + Tree Renderer (5-7 insights, ASCII ≤ 3 niveaux)
□ Empreinte Vocabulaire (10 mots + étymologie + validation active)
□ Modal IMPRINT (friction intentionnelle, écriture manuscrite)
□ Déclenchement Agent-04 (3 succès + SMI > 75% + complexité ≥ 4)
```

---

## SPRINT 5 — ASCENT Pipeline (Semaines 9-12) 🔴 CŒUR DU PRODUIT

### 5.1 Agents ASCENT (Consommateurs de tous les services)
```
□ backend_ts/src/ascent/
□ Agent-01 GOAL-INTERPRETER (formalisation + Starter Evaluator + Serment de Rigueur)
□ Agent-02 CONTENT-SCOUT (multi-core discovery + cache + scoring)
□ Agent-03 DAG-ARCHITECT (petgraph + cycle detection + PageRank + Dynamic Graph Splitting)
□ Agent-04 LEARNING-CONDUCTOR (sessions + FSRS↔Bloom Loop + Habit Engine)
□ Agent-05 PERFORMANCE-ANALYZER (SMI continu + Flow State + SDT Monitor)
□ Agent-06 ADAPTIVE-ROUTER (fast-track/normal/remédiation + Goal Setting)
□ Agent-07 DRIFT-GUARDIAN (8 signaux SHAP + Frictionless Re-entry)
□ Agent-08 ENGAGEMENT-AMPLIFIER (gamification SDT + Variable Rewards + Commitment Device)
□ Agent-09 SKILL-CERTIFIER (Proof of Skill : 5 formats + PDF Typst + badge LinkedIn)
□ DAG Display Views (Kanban + Arbre + Gantt CPM + Réseau)
□ ASCENT-QA Comité (6 agents + PQS ≥ 88 + Constructive Alignment)
□ Agent-12 VISUAL-CRITIC + Agent-13 COGNITIVE-VALIDATOR
□ Agent-14 DET-SUGGESTER (déterministe < 5ms)
□ Agent-15 AXIOMATIZER + Agent-16 HITL-PROXY-SME
□ Agent-17 WORK-MODE-DETECTOR + Agent-18 CONSCIOUS-AGENT
□ Proof of Skill complet (5 formats soumission + SurveyJS + ARENA)
```

---

## SPRINT 6 — CHRONICLE + ARENA + Normal Mode + B2B (Semaines 13-16)

### 6.1 CHRONICLE (Knowledge Guardian Vivant)
```
□ Agent-10 CHRONICLE (7 piliers Knowledge Guardian)
□ Charte d'Humilité Totale (humility_filter sur tous messages)
□ Knowledge Health Monitor + Daily Pulse + Resurrection Protocol
□ Conversation-Native Retrieval (WhatsApp/Telegram/Discord)
□ Attention + Coaching + Universal Wisdom system
□ Progressive Automation engine (3 niveaux + granulaire + auto-détection)
□ Boost Sommeil (D-OPT-048)
```

### 6.2 ARENA (Simulations Pratiques)
```
□ Agent-11 ARENA (Full-AI roleplay)
□ HSM Persona (machine à états hiérarchique + mood score, D-OPT-008)
□ 6 domaines (Vente/Management/Parole/Médical/Pédagogie/Arts)
□ Debrief structuré + exercices générés automatiquement
□ Proof of Skill ARENA (théorie + pratique)
□ FSRS Stability Gate avant ARENA (D-OPT-051)
```

### 6.3 Normal Mode + B2B
```
□ Normal Mode (ingestion directe → NEURON-CHAINS + APEX + COSMOS immédiats)
□ B2B Console (Creator Dashboard + SurveyJS analytics $0)
□ Creator-to-Student Synaptic Loop (D-OPT-017)
□ k-anonymat GDPR (D-OPT-029)
□ API Monetization (usage-based billing + BudgetGuard par clé)
```

---

## SPRINT 7 — Neuro Engine + Polish + Production (Semaines 17-20)

### 7.1 Moteur Neuroscientifique
```
□ FORGE Protocol (amorce cognitive obligatoire, D-OPT-014)
□ FRICTION Mode (entrelacement 70/30 + Reflection Delay 3s, D-OPT-015)
□ RIF Synaptic Competition (Fail-Safe Gate 90% si V<25, D-OPT-010)
□ Engram Decay Vitality (sigmoïde robuste, D-OPT-009)
□ Prerequisite Booster (D-OPT-023)
□ WASM Edge Computing (FSRS+petgraph navigateur, D-OPT-001/060)
```

### 7.2 Features Transverses
```
□ PIVOTIQ (réconciliation multi-sources)
□ FINANCE SUITE (Pipeline Data Analyst Financier)
□ Generative-Canvas-AI FlowSeek (diagrammes animés 60 FPS)
□ Multi-View Toggles (Math/Sémantique/Code/Graphique/Diagramme)
□ Intégrations 11 services (Notion/Obsidian/Anki/Readwise/Zotero...)
□ UX/UI Features (Dashboard D-003, Tags D-001, Auto-Save D-012, Search, Notifications)
□ Infrastructure & Sécurité (JWT, OAuth, RLS, TLS 1.3, GDPR, AI Act EU)
```

### 7.3 Tests E2E + Optimisation + Production
```
□ Tests E2E Playwright (parcours critiques)
□ Tests de charge (1000 users concurrents)
□ Optimisation bundle (lazy-loading, code splitting)
□ Monitoring (Sentry + Axiom + OpenTelemetry + Langfuse)
□ Documentation utilisateur
□ Déploiement production (Northflank + Vercel)
```

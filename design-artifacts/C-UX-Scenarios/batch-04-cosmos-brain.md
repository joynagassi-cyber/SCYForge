# WDS-3 SCENARIOS — BATCH 04
_Modules : COSMOS (26 modes) + BRAIN (RAG + Professor AI)_
_Source : minddoc/s04_scy_cosmos_visualization_engine/ + minddoc/s06_scy_brain_rag_assistant/_
_Version : 1.0_

---

# SC-023 — COSMOS Knowledge Graph — Mode M00 (P-AL, P-KG)

**Trigger** : CTA "Voir COSMOS" depuis Library, Dashboard, ou DAG node
**Persona** : P-AL (apprendre relations), P-KG (visualiser base)
**Business Goal** : BG-04 Visualiser + BG-06 Certifier
**Écran** : `/cosmos/modes/00`
**Flux** :
1. Chargement Graphe : backend_rs GET `/cosmos/graph/node/:id` + `/cosmos/graph/edges`
2. Render G6 (ou Cosmograph si > 500 nodes) — lazy-load engine via `g6_loader.ts`
3. Interactions :
   - Drag node → pan canvas + zoom (scroll wheel)
   - Click node → sidebar panel avec métadonnances (title, type, source, date, confidence)
   - Hover node → tooltip résumé + edges incidentes
   - Double-click node → navigue vers `/library/item/:id` ou `/cosmos/graph/node/:id`
4. Filtres couche : ☑ Ingest ☑ NEURON-CHAINS ☑ APEXcartes ☑ COSMOS auto-edges
5. Lenses overlay : toggle par lentille sémantique (voir `lens_system/`)
6. Layout toggle : Force | Circular | Hierarchical | Radial (7 modes — engine_g2)
7. Mini-map + search bar (fuzzy search node by label)
8. Export : PNG / SVG / JSON (pour partage B2B)
**Spec source** : `minddoc/s04_scy_cosmos_visualization_engine/engine_g6/` + `engine_cosmograph/`
**Design System** : `scy-radius-md` nodes, `scy-color-primary-500` sélectionné, `scy-color-*` par node type, shadow `scy-shadow-lg` panel
**Success** : 100 nodes fluide 60fps, 1000 nodes < 500ms render (Cosmograph)
**Edge** : graph vide → empty state + CTA "Ingérer des sources"

---

# SC-024 — COSMOS Gap Detection — Détection prérequis manquants (P-KG) 🆕

**Trigger** : Sidebar COSMOS → onglet "Santé" ou action "Détecter les gaps"
**Persona** : P-KG (Knowledge Guardian)
**Business Goal** : BG-06 Certifier + amélioration qualité knowledge base
**Écran** : `/cosmos/gap-detection`
**Flux** :
1. Backend_rs `gap_detection.rs` analyse le graphe :
   - Nodes orphelins (0 edges)
   - Clusters isolés (composantes connexes)
   - Concepts fréquents mais non connectés (cosine < 0.5)
   - Nœuds avec confidence < 0.6 (besoin validation humaine)
2. Résultats triés par criticité : 🔴 Critique | 🟡 Warning | 🟡 Info
3. Pour chaque gap :
   - Description : "12 nodes orphelins — aucune source ingérée"
   - Suggestion : "Connecter via ReadertSuite ou ajouter prérequis manuel"
   - Action rapide : [Connecter à…] / [Supprimer] / [Ignorer]
4. Batch actions : tout sélectionner → action groupée
5. Historique scans : Date + nombre gaps + évolution
6. Auto-trigger optionnel : scan hebdomadaire après chaque batch ingest
**Spec source** : `minddoc/s04_scy_cosmos_visualization_engine/gap_detection/`
**Design System** : Gauge santé globale (0–100), liste groupée par criticité, `scy-color-danger-500` critique, `scy-color-warning-500` warning
**Success** : scan 5000 nodes en < 30s, gaps listés avec actions en 1 clic
**Edge** : beaucoup de gaps (>50) → priorisation automatique par fréquence + impact

---

# SC-025 — COSMOS 3D Graph — Mode M23 three.js (P-AL)

**Trigger** : CTA "Vue 3D" depuis Knowledge Graph header
**Persona** : P-AL (Autonomous Learner — exploration immersive)
**Business Goal** : BG-04 Visualiser engagement forts
**Écran** : `/cosmos/modes/23`
**Flux** :
1. Loader `threejs_loader.ts` : chargement three.js + custom shaders (lazy)
2. Render graphe 3D avec `Brain3DGraph.tsx` :
   - Nodes = sphères radius proportionnelle au PageRank
   - Edges = tubes avec épaisseur = poids cosine
   - Force layout 3D (d3-force-3d) auto-stabilisation en 5s
3. Interactions :
   - OrbitControls : rotate / pan / zoom (souris + touch)
   - Raycaster : hover node → highlight + tooltip
   - Click node → camera fly-to + focus panel latéral
   - Search : focus node par nom
4. Lenses overlay : toggle par lentille → change couleur nodes
5. Performance : instanced rendering pour 10000+ nodes, LOD (level of detail)
6. Export screenshot PNG 3D
**Spec source** : `minddoc/s04_scy_cosmos_visualization_engine/engine_threejs/`
**Design System** : Palette couleurs nodes par groupe, bloom effect optionnel, HUD info
**Success** : 5000 nodes à 30fps sur GPU moyen, raycasting < 16ms
**Edge** : GPU non supporté → fallback graphe 2D (M00) automatique

---

# SC-026 — COSMOS Adaptive UX — Personnalisation layout (P-AL, P-FA)

**Trigger** : Icône "⚙️ Adaptatif" dans toolbar COSMOS
**Persona** : P-AL, P-FA
**Business Goal** : BG-04 + UX engagement
**Écran** : Overlay `/cosmos/settings/adaptive`
**Flux** :
1. `cosmos_adaptive_ux` engine enregistre préférences utilisateur :
   - Layout par défaut : Force | Circular | Hierarchical
   - Lenses actives par défaut : checklist lenses
   - Density : Comfortable | Compact | Dense (selon taille écran)
   - Color mode : Auto (system) | Light | Dark
   - Interaction : Hover preview ON/OFF, Tooltip delay (0ms | 300ms | 1000ms)
2. Preview live : les changements s'appliquent en temps réel au graphe derrière
3. Save → stocké dans `scy_user_preferences` table (PostgreSQL)
4. Sync cross-device si login OAuth
5. Reset → "Restaurer defaults SCY Forge"
**Spec source** : `minddoc/s04_scy_cosmos_visualization_engine/cosmos_adaptive_ux/`
**Design System** : Settings panel `scy-radius-lg`, toggle switches `scy-color-primary-500`, live preview
**Success** : préférences sauvegardées en < 1s, appliquées au prochain chargement
**Edge** : conflit préférences device vs serveur → serveur gagne, notif user

---

# SC-027 — BRAIN Chat — Interface conversationnelle PIVOTIQ (P-FA) 🆕

**Trigger** : CTA "Discuter avec BRAIN" depuis Dashboard P-FA après ingest financial
**Persona** : P-FA (Finance Analyst)
**Business Goal** : BG-02 Générer insights + PIVOTIQ feature
**Écran** : `/brain/chat?context=pivotiq&docId=xxx`
**Flux** :
1. ChatInterface React : layout split (gauche : chat, droite : contexte document)
2. Contexte pré-chargé : doc PIVOTIQ reconcilié + sources EDGAR/Bloomberg citations
3. Premier message système BRAIN :
   > "Je suis votre assistant financier. Basé sur le document [Ticker FY2024 10-K], je peux : analyser les écarts P&L, comparer aux peers, détecter anomalies."
4. Requêtes types suggérées (suggestion chips cliquables) :
   - "Explique les 3 principales divergences P&L"
   - "Comparer revenue growth 2023 vs 2024"
   - "Quels risques sont mentionnés ?"
   - "Génère un résumé en 3 bullets"
5. Retrieval Triple (BRAIN retrieval) : Dense + Sparse + Graph (RRF fusion)
6. Citation inline : chaque affirmation cite source EDGAR/Bloomberg [1][2]
7. CitationMark.tsx : hover preview + click → ouvre sidebar source
8. Follow-up auto : BRAIN propose 2–3 questions de suivi pertinentes
9. Export conversation → MD / PDF pour archiving
**Spec source** : Nouvelle feature FINANCE SUITE + `minddoc/s06_scy_brain_rag_assistant/` + `docs/ROUTES.md` §2.6
**Design System** : Chat bubbles (user = `scy-color-primary-500`, BRAIN = `scy-color-neutral-100`), CitationMark inline, suggestion chips `scy-radius-full`
**Success** : première réponse en < 3s (avec RAG), citations présentes 100% affirmations chiffrées
**Edge** : données non-réconciliées → alerte "Certaines sources divergent — PIVOTIQ recommandé"

---

# SC-028 — BRAIN Professor AI — Session Socratique (P-AL, P-B2B)

**Trigger** : CTA "Coach Socr" depuis Library item ou Dashboard
**Persona** : P-AL (apprendre), P-B2B (évaluer compréhension)
**Business Goal** : BG-05 Dialoguer + BG-06 Certifier compréhension
**Écran** : `/brain/professor?nodeId=xxx`
**Flux** :
1. ProfessorAI.tsx initialise session :
   - Concept cible : node COSMOS sélectionné
   - Contexte : documents sources + cartes APEX associées
   - Objectif pédagogique : évaluer compréhension profonde (Socratic)
2. Thread-of-Thought strategy (backend_rs `thread_of_thought.rs`) :
   - Q1 : "Quelle est la différence entre X et Y ?"
   - (Analyse réponse user → détection misconceptions)
   - Q2 : "Tu as mentionné Z — peux-tu développer ?"
   - Q3 : "Applique ce concept à ce cas concret…"
3. Fail-safe module : si user bloqué > 2min → hint progressif
4. Score compréhension : after each answer → 0–100 calculé par `cognitive_validator.rs`
5. Résultat :
   - Score ≥ 80% → certification ASCENT auto + badge
   - Score 50–79% → recommandation cartes APEX ciblées
   - Score < 50% → génération contenu remedial (NEURON-CHAINS α revisit)
6. Session saved dans `scy_teaching_sessions` table
**Spec source** : `minddoc/s06_scy_brain_rag_assistant/professor_ai/` + `backend_rs/crates/scy-brain-rag/src/professor/`
**Design System** : Chat bubbles + score gauge animée après chaque réponse, badge certif vert si ≥ 80
**Success** : session 10 questions en < 15min, score fiable (± 5pts)
**Edge** : user abandonne → save état + resume plus tard

---

# SC-029 — BRAIN Profiling utilisateur — Persona auto-détection (P-B2B, P-FA)

**Trigger** : Auto après 3 sessions actives (login #4)
**Persona** : P-B2B, P-FA (auto-détecté par analyse comportement)
**Business Goal** : BG-05 + adaptation automatique UX
**Écran** : `/settings/profile?tab=persona`
**Flux** :
1. BE backend_ts ASCENT ag17 `work_mode_detector.ts` analyse :
   - Types de contenu ingérés (finance vs académique vs vidéo)
   - Fréquence sessions APEX (révision intensive vs light)
   - Navigation patterns (COSMOS depth vs Dashboard quick)
   - Export formats préférés (PDF rapport vs flashcards)
2. Score par persona :
   - P-AL : 65% → profil actuel "Autonomous Learner"
   - P-FA : 75% → proposition switch vers "Finance Analyst"
   - P-B2B : 80% → confirmation + activation B2B features
3. UI propose : "Nous avons détecté que vous utilisez principalement des documents financiers. Voulez-vous activer le mode Finance Analyst ?"
4. Si accept : layout Dashboard P-FA + PIVOTIQ sidebar + FINANCE template defaults
5. Si refuse : reste P-AL, propose re-détection dans 7 jours
6. Override manuel toujours possible dans `/settings/profile`
**Spec source** : `minddoc/s03_ascent_pipeline_agents/ag17_work_mode_detector/` + ASCENT ag17 spec
**Design System** : Modal propos avec pie chart détection + [Activer] [Rester en mode actuel] [Plus tard]
**Success** : détection correcte ≥ 80% après 3 sessions, UX transparente
**Edge** : faux positif → override facile + feedback "Diagnostic incorrect"

---

# SC-030 — BRAIN Live Web Search — Recherche temps réel (P-FA, P-KG)

**Trigger** : Chat BRAIN → mention "@web" ou toggle "Recherche web"
**Persona** : P-FA, P-KG
**Business Goal** : BG-02 + BG-05 + enrichissement dynamique
**Écran** : `/brain/chat` avec sidebar "Recherche web"
**Flux** :
1. User tape : "@web taux inflation UE 2024"
2. Frontend détecte `@web` → split message : query + context
3. Backend_rs `brain/web_search` appelle :
   - SearxNG sidecar (`/search?q=…&format=json`) pour résultats bruts
   - Perplexica sidecar si query complexe nécessite synthèse
4. Scraping furtif : `scrapling_client.rs` + `dom_smoothie.rs` → nettoyage
5. Retrieval : triple (Dense BM25 Graph) sur résultats web frais
6. Affichage résultats : card par source avec snippet + URL + date
7. Citation inline `[web:1]` dans réponse BRAIN
8. Option : "Ingérer ces résultats" → bulk ingest dans Library
**Spec source** : `minddoc/s06_scy_brain_rag_assistant/live_web_search/` + `docs/ROUTES.md` §2.6
**Design System** : Sidebar slide-in, result cards avec favicon + timestamp, `scy-color-neutral-500` URLs
**Success** : réponse enrichie en < 8s (web roundtrip), scraping < 3s/page
**Edge** : SearxNG down → timeout 5s → réponse BRAIN sans web + notif "Recherche indisponible"

---

# SC-031 — COSMOS Trust System — Validation doubles sources (P-KG)

**Trigger** : Toggle "Trust" dans COSMOS view — mode Knowledge Guardian obligatoire
**Persona** : P-KG (Knowledge Guardian)
**Business Goal** : BG-06 Certifier confiance knowledge graph
**Écran** : `/cosmos/graph?view=trust`
**Flux** :
1. Backend_rs `trust_system.rs` calcule score confiance par node :
   - Source qualité : peer-reviewed > éditoriale > user-generated
   - Validation humaine : nombre validateurs Harmonist
   - Cohérence : concordance multi-sources (PIVOTIQ alignement)
   - Fraîcheur : age document + update frequency
2. Visualisation overlay : nodes avec badge score (0–100)
   - 🟢 80–100 : confiance forte
   - 🟡 40–79 : confiance moyenne, à valider
   - 🔴 0–39 : confiance faible, bloquer usage
3. Double Validation workflow :
   - User P-KG valide node → score +10pts + badge "Validated by [user]"
   - Si 2 validateurs indépendants → score +20pts + badge "Peer validated"
4. Action : "Flag for review" → enqueue dans HARMONIST QA gates
5. Dashboard Trust : métriques globales (avg trust score, distribution)
**Spec source** : `minddoc/s04_scy_cosmos_visualization_engine/cosmos_trust_system/`
**Design System** : Color badges trust, double-check icon validateurs, progress bar score
**Success** : calcul trust score en < 2s par node, workflow 2-validateurs en < 1min
**Edge** : node jamais validé → auto-flag dans HARMONIST après 30 jours sans source fraîche

---

# SC-032 — BRAIN Teor Back — Étudiant récite à l'IA (P-AL)

**Trigger** : CTA "Teach-Back" depuis SessionView APEX ou Dashboard
**Persona** : P-AL (Autonomous Learner)
**Business Goal** : BG-03 Rétention active + métacognition
**Écran** : `/apex/teach-back?sessionId=xxx`
**Flux** :
1. API sélectionne 5 cartes APEX révisées récemment (SMI faible)
2. Mode vocal (Web Speech API) ou texte
3. Pour chaque carte :
   - Affichage question : "Qu'est-ce que le Sampling Error ?"
   - User répond (vocal/texte)
   - BRAIN évalue : précision (cosine embedding) + complétude + formulation
   - Feedback immédiat :
     ✅ Correct | ⚠️ Presque (détail manquant) | ❌ Incorrect (correction fournie)
4. Score global session : % correct + temps moyen réponse
5. Post-session :
   - Cartes fails → replanification FSRS accélérée (intervalle -50%)
   - Cartes passes → intervalle +20%
   - Rapport : "Vous avez maîtrisé 4/5 concepts — 1 à revoir"
6. Historique teach-back sessions dans `/apex/stats`
**Spec source** : `minddoc/s06_scy_brain_rag_assistant/` + `minddoc/s05_apex_retention_system/` + `backend_rs/crates/scy-brain-rag/src/professor/teach_back.rs` (implied)
**Design System** : Card question flip animation, waveform vocal (MediaRecorder API), score gauge finale
**Success** : session 5 cartes en < 8min, feedback < 1s par réponse
**Edge** : reconnaissance vocale instable → fallback mode texte automatique

---

*Fin du batch 04 — 8 scénarios (COSMOS + BRAIN + Teach-Back + Trust)*
*Modes COSMOS couverts : M00, M23 3D, gap detection, trust system, adaptive UX*
*BRAIN couvert : chat PIVOTIQ, Professor AI Socratic, persona detection, web search, teach-back*
*Prochain batch : READER SUITE + IMPRINT + CHRONICLE (8 scénarios)*

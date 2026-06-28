# WDS-3 — BATCH 10
_Couverture finale — SC-071 à SC-087 (17 scénarios)_
_Modules : Settings, B2B depth, Finance depth, Harmonist variants, Cross-module flows_
_Objectif : atteindre 87/87_

---

# SC-071 — Settings — Profil & Preferences (P-AL, P-B2B, P-FA, P-KG)

**Trigger** : Clic "Settings" dans sidebar, ou `Cmd+,`
**Écran** : `/settings/profile`
**Flux** :
1. Sections : Profil, Préférences, Notifications, Confidentialité, Facturation (B2B)
2. Profil : avatar, nom, email, langue, fuseau horaire
3. Préférences : thème (light/dark/auto), police, density (comfortable/compact), animations ON/OFF
4. Notifications : push web, email digest, daily pulse time, mute 24h
5. Confidentialité : données anonymisées, export GDPR, suppression compte
6. Facturation B2B : plan, sièges, consommation, factures PDF
7. Save automatique sur changement (debounce 500ms)
8. Reset : "Restaurer defaults SCY Forge"
**Spec** : `docs/ROUTES.md`, `minddoc/s00_design/`
**Tokens** : `scy-form-*`, `scy-card`, avatar component
**Success** : sauvegarde < 500ms, feedback toast
**Edge** : conflit préférences multi-device → serveur gagne + notif

---

# SC-072 — Settings — Automation & Progressive Levels (P-AL)

**Trigger** : Onglet "Automation" dans Settings
**Écran** : `/settings/automation`
**Flux** :
1. Niveau automation actuel affiché (0-5) + description
2. Par niveau, toggles disponibles :
   - Level 0 : Manuel uniquement
   - Level 1 : Suggestions auto (COSMOS auto-graph, NEURON-CHAINS auto-trigger)
   - Level 2 : Auto-ingest RSS/watchlist
   - Level 3 : Auto-session APEX scheduling
   - Level 4 : Auto-certification partielle
   - Level 5 : Full agentic (toujours ON, override user toujours possible)
3. Pour chaque toggle : tooltip explication + exemples concrets
4. Override global : "Mode manuel temporaire" (24h/7j/persistent)
5. Audit log : qui/quoi/quand pour chaque automation action
**Spec** : `minddoc/s00_architecture_standards/scy_progressive_automation_spec.md`
**Tokens** : toggle switches `scy-color-primary-500`, stepper niveaux
**Success** : user comprend chaque niveau en < 30s
**Edge** : level 5 sans consentement explicite → blocked + explicitation requise

---

# SC-073 — Settings — Integration Hub (Nango) (P-AL, P-FA, P-KG)

**Trigger** : Onglet "Integrations" dans Settings
**Écran** : `/settings/integrations`
**Flux** :
1. Hub integrations Nango : liste connecteurs disponibles (YouTube, Google Drive, Notion, Slack, Bloomberg, EDGAR…)
2. Pour chaque connecteur :
   - Status : Connected / Disconnected / Error
   - Last sync : timestamp
   - Actions : [Connect], [Disconnect], [Test], [Configure]
3. OAuth flow : clic [Connect] → redirect Nango → callback
4. Sync settings : auto-sync ON/OFF, fréquence (real-time/hourly/daily)
5. Error handling : reconnect auto, DLQ, notification
6. Custom webhook : URL + secret + events subscribed
7. Usage stats : appels API/mois, rate limit remaining
**Spec** : commit `bed8a90` (pivot Composio→Nango), `docs/ROUTES.md`
**Tokens** : badge statut connecteur, `scy-color-success`/`scy-color-alert`
**Success** : connect en < 10s, sync visible en < 30s
**Edge** : Nango down → fallback manuel + notif "Intégration indisponible"

---

# SC-074 — B2B — Role Management & Permissions (P-B2B)

**Trigger** : CTA "Gérer les rôles" depuis B2B Creator Console
**Écran** : `/b2b/creator/roles`
**Flux** :
1. Liste membres avec rôles : Admin | Editor | Viewer | Reviewer
2. Matrice permissions : création édition publication suppression export
3. Actions par membre : [Changer rôle], [Révoquer], [Envoyer invitation]
4. Invitation flow : email + lien onboarding B2B
5. Audit log qui a changé quoi quand
6. Bulk actions : sélection multiple → changer rôle / révoquer
7. Defaults B2B : Creator=Admin, Reviewer=Editor, Member=Viewer
**Spec** : `minddoc/s12_b2b_creator_console/`
**Tokens** : role badges couleurs, tableau permissions, `scy-card`
**Success** : changement rôle < 2s, audit tracé
**Edge** : dernier admin → warning "Vous êtes le dernier admin — confirmer ?"

---

# SC-075 — Finance Suite — XBRL Viewer & Mapping (P-FA, P-KG)

**Trigger** : CTA "Voir XBRL" depuis PIVOTIQ reconciliation view
**Persona** : P-FA, P-KG
**Business Goal** : BG-02 Inspection données brutes financières
**Écran** : `/finance-suite/xbrl/:docId`
**Flux** :
1. `XBRLViewer.tsx` parse fichier XBRL (inline XBRL ou .xsd + instances)
2. Vue arborescente : taxonomy → concepts → valeurs
3. Search : fuzzy search par concept name/tag
4. Mapping viewer : montrer correspondance entre XBRL tags et PIVOTIQ fields
5. Diff view : comparer 2 périodes XBRL (Y vs Y-1)
6. Export : mapping CSV, valeurs JSON, snapshot au format .xbrl
7. BRAIN integration : clic concept → ouvrir BRAIN chat avec contexte
**Spec** : Finance Suite + PIVOTIQ specs
**Tokens** : tree view `scy-radius-sm`, syntax highlighting XBRL tags, badge mapping
**Success** : parse 10MB XBRL en < 5s, render fluide
**Edge** : taxonomy inconnue → fallback generic parser + warning

---

# SC-076 — Finance Suite — Cohort Benchmarking (P-B2B, P-FA)

**Trigger** : B2B Creator Console → onglet "Benchmarking"
**Persona** : P-B2B, P-FA
**Business Goal** : BG-07 Revenue B2B + insights compétitivité
**Écran** : `/finance-suite/benchmarking`
**Flux** :
1. Sélection cohorte B2B + période de comparaison
2. Import données benchmark : interne (PIVOTIQ) + externe (EDGAR peers)
3. Calcul métriques : P&L margin, revenue growth, ROE vs peers médiane
4. Vue synthétique : sparkline + delta vs benchmark
5. Insights auto :
   - "Votre cohorte sur-performe la médiane de +12% sur revenue growth"
   - "3 peers avec meilleure marge — analyser leur costing ?"
6. Action : [Investigator] → ouvre BRAIN avec contexte + peers liste
7. Export : PDF benchmarking report (typst-pdf)
**Spec** : Finance Suite + B2B specs
**Tokens** : sparkline Recharts, palette benchmark (bleu = cohort, gris = peer mediane)
**Success** : calcul benchmark < 5s, insights pertinents
**Edge** : cohorte < 3 members → "Données insuffisantes pour benchmarking"

---

# SC-077 — Harmonist — Citation Integrity Check (P-KG, P-AL)

**Trigger** : Auto avant publication tout contenu avec citations [1][2]
**Persona** : P-KG, P-AL
**Business Goal** : BG-06 Certifier intégrité citationnelle
**Écran** : `/harmonist/citations/:contentId`
**Flux** :
1. `CitationTracker.ts` scanne contenu pour tous marqueurs `[n]`
2. Pour chaque citation :
   - Fetch source depuis `scy_citations` table
   - Verify URL accessible (200 OK)
   - Compare extrait cité vs source originale (cosine similarity)
   - Détecte : ✅ Valid | ⚠️ Partial | 🔴 Broken | ❌ Mismatch
3. UI vue liste :
   - Colonnes : [n], Source URL, Status, Confiance %, Action
   - Color coding : vert/jaune/rouge/gris
4. Actions bulk : [Réparer URLs], [Remplacer citations], [Supprimer]
5. Si mismatch > 40% → escalation reviewer humain (HITL)
6. Audit log complet enregistré
**Spec** : `minddoc/s09_harmonist_validation_gates/` + SC-022 anti-hallucination
**Tokens** : badge status, `scy-color-feedback-*`, table ligne
**Success** : check 100 citations en < 10s
**Edge** : source paywall → skip + marquer "Vérification manuelle requise"

---

# SC-078 — System — Cold Start / First-load Experience (tous)

**Trigger** : Premier visit `/` sans auth, ou nouvelle install PWA
**Persona** : tous
**Business Goal** : BG-01 Onboarding < 2min, time-to-first-value
**Écran** : `/` (landing) + `/onboarding/welcome`
**Flux** :
1. Cold start detection : localStorage vide + no JWT
2. Landing page adaptée :
   - Value prop : "Maîtrisez n'importe quel sujet en 2 clics"
   - CTA principal : "Commencer gratuitement" (email) + OAuth Google/GitHub
   - Social proof : "30k+ apprenants, 4.8★"
   - Demo animée : 30s video ou interactive tour (Lottie)
3. Post-auth wizard (si premier login) :
   - Objectif : tags + NL input
   - Niveau : débutant/intermédiaire/avancé
   - Format préféré : cartes/vidéo/audio/texte
   - Temps disponible : 5min/jour | 15min | 30min+ | illimité
4. Auto-provisioning :
   - Création user record PostgreSQL
   - Init streak = 0, xp = 0
   - Seed first APEX deck (5 cartes bienvenue)
   - First DAG suggestion basé sur objectif
5. First CTA flush : "Votre première session APEX est prête !"
**Spec** : `docs/ROUTES.md §2.1`, `docs/DATA_MODEL.md user schema`
**Tokens** : `scy-color-primary-500` CTA, gradient hero, Lottie animation, stepper wizard
**Success** : cold start → première session APEX en < 2min
**Edge** : network offline → PWA cached landing + delayed wizard sync

---

# SC-079 — System — Error Recovery & Graceful Degradation (tous)

**Trigger** : EventBus erreur, backend_rs down, EventBus down, DB indisponible
**Persona** : tous
**Business Goal** : Résilience + confiance utilisateur
**Écran** : Overlay global + component-level fallbacks
**Flux** :
1. Détection erreur :
   - Backend_rs health check échoue → offline mode
   - EventBus timeout → DLQ + retry queue visible
   - PostgreSQL down → read-only cache SQLite (WAL desktop)
   - Zilliz/Milvus down → fallback PostgreSQL FTS uniquement
2. UI Overlay (non-blocking) :
   - 🟡 "Certaines fonctionnalités sont limitées — mode dégradé"
   - 🔴 "Service indisponible — réessai automatique dans 30s"
3. Component-level fallbacks :
   - COSMOS graphe → skeleton + message "Impossible de charger le graphe"
   - BRAIN → "Mode hors-ligne — conversations sauvegardées localement"
   - APEX → cache local dernières cartes + sync différée
4. Recovery : heartbeat check 30s → auto-reconnect → toast "Service restauré"
5. Offline queue : actions pending stockées IndexedDB → replay online
**Spec** : `backend_rs/crates/scy-eventbus/src/dead_letter.rs`, `docs/ARCHITECTURE.md`
**Tokens** : `scy-color-feedback-warning`, overlay backdrop, skeleton loaders
**Success** : user jamais bloqué, données jamais perdues
**Edge** : offline prolongé (> 24h) → export data prompt

---

# SC-080 — System — Command Palette Power User (P-AL, P-KG)

**Trigger** : `Cmd+K` / `Ctrl+K` depuis n'importe quelle vue
**Persona** : P-AL (power user), P-KG (efficacité)
**Business Goal** : Productivité + sensation de contrôle
**Écran** : Overlay modal command palette
**Flux** :
1. Palette overlay : backdrop `rgba(5,5,10,0.75)`, input autofocus
2. Fuzzy search : résultats groupés par catégorie
   - Navigation : "Aller à COSMOS", "Ouvrir Library", "Voir ASCENT roadmap"
   - Actions : "Ingérer vidéo YouTube", "Générer cartes APEX", "Lancer session"
   - Recherche : "Chercher 'Tokio'", "Find leeches"
   - Récent : last 5 commands
3. Keyboard nav : ↑↓ navigate, Enter select, Esc close
4. Dynamic commands : contexte-aware selon vue actuelle
   - Dans COSMOS : "Zoom sur node X", "Changer layout"
   - Dans APEX : "Réviser cartes dues", "Voir stats"
   - Dans B2B : "Créer cohorte", "Exporter rapport"
5. Custom commands : user peut créer shortcuts perso
6. History : dernières 100 commandes + telemetry anonyme
**Spec** : `minddoc/s00_design/scy_experience_design.md` § Command Palette
**Tokens** : overlay, `scy-radius-lg`, highlight match, keyboard badge
**Success** : ouverture < 100ms, recherche < 200ms, 90% commands findable
**Edge** : commande inconnue → "Créer shortcut ?" suggestion

---

# SC-081 — System — Search Global & Semantic (P-AL, P-KG, P-FA)

**Trigger** : Icône search dans header, ou `/` dans vide input
**Persona** : tous
**Business Goal** : Découverte contenu + navigation rapide
**Écran** : `/search` ou overlay search
**Flux** :
1. Search bar globale avec autocomplete
2. Triple-engine retrieval :
   - Dense : embedding cosine similarity (pgvector)
   - Sparse : BM25 full-text (PostgreSQL FTS)
   - Graph : COSMOS neighbors (edges sémantiques)
3. RRF fusion : rank fusion Reciprocal Rank Fusion top-50
4. Resultats groupés :
   - Concepts COSMOS (nodes)
   - Documents Library
   - Cartes APEX
   - Sessions ASCENT
   - Conversations BRAIN
5. Preview inline : hover card aperçu + "Open" / "Citer dans BRAIN"
6. Filters : type, date, source, tag, SMI range
7. Recent searches + saved searches
**Spec** : `docs/ROUTES.md §2.6`, `minddoc/s06_scy_brain_rag_assistant/`
**Tokens** : result cards, badge type, `scy-radius-md`
**Success** : results < 500ms, relevance pertinente
**Edge** : requête vide → recommendations basées historique user

---

# SC-082 — System — Activity Center & Notifications Hub (P-AL, P-B2B)

**Trigger** : Bell icon dans header ou sidebar ASCENT Activity
**Persona** : tous
**Business Goal** : Visibilité événements + reaction rapide
**Écran** : `/activity`
**Flux** :
1. Activity Center : feed événements triés par timestamp
2. Catégories :
   - 🔔 Notifications : system, reminders, alerts
   - 📊 Progression : APEX sessions, ASCENT milestones
   - 👥 Collaborations : B2B mentions, assignments, reviews
   - ⚙️ System : maintenance, new features, tips
3. Par événément :
   - Icon + message court + timestamp relatif ("2 min ago")
   - Actions rapides : [Réviser], [Voir], [Répondre], [Ignorer]
   - Status : unread (dot), read (checked), archived
4. Bulk actions : tout marquer lu, archiver > 7j, filtrer par type
5. Settings : notification preferences par catégorie (voir SC-072)
6. Push : web push + email digest quotidien optionnel
**Spec** : `docs/ROUTES.md`, ASCENT ag10 chronicle notifications
**Tokens** : badge unread `scy-color-danger-500`, `scy-card`, hover
**Success** : feed < 1s, actions 1 clic
**Edge** : > 100 événements → pagination virtualisée

---

# SC-083 — System — Offline Mode & Sync (P-AL)

**Trigger** : Network offline détecté, ou toggle offline manuel
**Persona** : P-AL
**Business Goal** : Continuité apprentissage sans réseau
**Écran** : `/offline` + indicator top nav
**Flux** :
1. Detection : navigator.onLine + heartbeat backend
2. UI indicator : "Mode hors-ligne" badge + timestamp dernier sync
3. Offline capabilities :
   - APEX : révision cartes depuis cache IndexedDB
   - Library : consultation items téléchargés
   - BRAIN : chat limité (last 50 messages cached)
   - ASCENT : consult roadmap + progression locale
4. Actions bloquées offline :
   - Ingest → "Disponible en ligne uniquement"
   - PIVOTIQ reconciliation → "Nécessite connexion"
   - B2B collaboration → "Synchronisation différée"
5. Sync au retour online :
   - Queue replay IndexedDB → EventBus
   - Conflict resolution Last-Write-Wins
   - Toast "Données synchronisées" avec delta résumé
**Spec** : `docs/ARCHITECTURE.md`, PWA specs
**Tokens** : offline badge orange, sync spinner, toasts
**Success** : transition online→offline→online < 5s, données jamais perdues
**Edge** : conflit APEX review → last-write-wins + notif "Révision conservée"

---

# SC-084 — Cross-Module — Multi-Source Deep Dive (P-FA, P-KG)

**Trigger** : User sélectionne 3+ items Library puis CTA "Analyser conjointement"
**Persona** : P-FA, P-KG
**Business Goal** : BG-02 + BG-06 insights multi-sources
**Écran** : `/cross/analysis/:items`
**Flux** :
1. Selection multi-items : checkboxes Library + CTA action
2. Backend_rs orchestre pipeline parallèle :
   - NEURON-CHAINS extraction concepts depuis chaque source
   - BRAIN retrieval croisé (dense+sparse+graph)
   - PIVOTIQ si contenu financier (réconciliation)
   - COSMOS build graphe temporaire
3. Vue synthèse :
   - Alignment : concepts communs across sources
   - Divergence : points de désaccord
   - Insights : BRAIN-generated synthesis
4. Actions :
   - [Générer rapport] → NEURON-CHAINS ε → typst PDF
   - [Sauver comme projet] → commit dans Library
   - [Certifier] → Harmonist QA gates
**Spec** : Cross-module EventBus flows, EventHub spec
**Tokens** : split view multi-docs, alignment markers vert/rouge
**Success** : analyse 5 docs en < 30s, insights pertinents
**Edge** : sources contradictoires → BRAIN flag + suggest PIVOTIQ si finance

---

# SC-085 — Cross-Module — Long-Running Task UX Pattern (P-AL)

**Trigger** : Ingest batch 50+ items, DAG generation complexe, certification exam
**Persona** : P-AL
**Business Goal** : Transparence opérations longues + contrôle utilisateur
**Écran** : Overlay progress modal + navbar badge
**Flux** :
1. Progress modal (non-blocking, reopenable via navbar badge) :
   - Header : "Ingestion en cours — 7/15 vidéos"
   - Progress bar + ETA + temps écoulé
   - [Logs] toggle : last 15 lignes SSE stream
   - [Annuler] confirmation prompt
2. Timeline feedback :
   - <100ms : spinner start
   - 1s : "Traitement en cours…"
   - 3s : progress bar si % disponible
   - 10s : ETA affiché
   - 30s+ : "Continuer en arrière-plan" option
3. WebSocket SSE : `/ws/progress/:jobId` updates temps réel
4. Completion : toast success + redirect approprié + notification
5. Failure : error toast + [Retry] + [Voir détails] modal
**Spec** : `minddoc/s00_design/scy_experience_design.md` § modals/loading, `docs/WORKFLOWS.md`
**Tokens** : modal `scy-radius-lg`, progress bar `scy-color-primary-500`, skeleton
**Success** : feedback en temps réel, cancellation fonctionne
**Edge** : job cancelled → cleanup backend_rs + DLQ

---

# SC-086 — Cross-Module — Onboarding Adaptive & Re-onboarding (tous)

**Trigger** : User retour après 7j absence, ou upgrade plan (Free→Pro→B2B)
**Persona** : tous
**Business Goal** : Rétention + activation features nouvelles
**Écran** : `/onboarding/adaptive`
**Flux** :
1. Detection : last login > 7j + new features since last visit
2. Adaptive wizard :
   - Slide 1 : "Nous avons ajouté [X nouvelles fonctionnalités] — Découvrez-les"
   - Slide 2 : Highlight top 3 nouveautés (tooltips interactifs)
   - Slide 3 : "Voulez-vous mettre à jour vos préférences ?"
3. Re-onboarding complet (si > 30j absence) :
   - Rappel objectif ASCENT
   - État progression : "Vous étiez à 3/15 nœuds"
   - Suggestions : "Reprendre où vous avez laissé" vs "Nouveau départ"
4. Upgrade flow (Free→Pro) :
   - Comparaison plans : features unlocked + pricing
   - Payment simulation (Stripe test) → unlock level automation
5. Completion : badge + reward XP + redirect Dashboard
**Spec** : `docs/WORKFLOWS.md`, `docs/DATA_MODEL.md user preferences`
**Tokens** : stepper wizard, `scy-color-primary-500` CTA, confetti animation
**Success** : re-onboarding < 3min, retention +15%
**Edge** : user skip → "Plus tard" + nudges 3j plus tard

---

# SC-087 — Cross-Module — Empty States & First Actions (tous)

**Trigger** : Vue vide (Library 0 items, ASCENT 0 goals, COSMOS 0 nodes, APEX 0 cartes)
**Persona** : tous
**Business Goal** : Activation modules + élimination friction
**Écran** : Chaque module (Library, ASCENT, COSMOS, APEX…)
**Flux** :
1. Pattern canonique (`scy_experience_design.md` § empty state) :
   ```
   ┌─────────────────────────────────┐
   │         [Icône Large 128px]     │
   │                                 │
   │   Aucun [élément] encore        │
   │                                 │
   │   Brève explication comment     │
   │   créer le premier élément      │
   │                                 │
   │   [CTA Principal]               │
   └─────────────────────────────────┘
   ```
2. Par module :
   - Library vide → "Aucun concept — ingérez votre première source"
   - ASCENT vide → "Aucun objectif — définissez votre prochaine compétence"
   - COSMOS vide → "Graphe vide — ingérez des sources pour construire"
   - APEX vide → "Aucune carte — générez depuis Library"
   - IMPRINT vide → "Aucune empreinte — distillez un concept"
   - B2B vide → "Aucune cohorte — créez votre première promotion"
3. Smart suggestions selon persona + historique
4. Preview contextuel : mini-demo 5s animation (Lottie) du module
5. Skip option : "Je découvrirai plus tard" → Dashboard
**Spec** : `minddoc/s00_design/scy_experience_design.md` § empty states
**Tokens** : `scy-text-secondary`, `scy-color-primary-500` CTA
**Success** : user comprend en 3s l’action suivante
**Edge** : user skip 3x → masquer empty states définitivement + option reset

---

*Fin du batch 10 — 17 scénarios (SC-071 à SC-087)*
*Total WDS-3 : 87/87 scénarios outlines — SURFACE COMPLÈTE*
*Modules couverts : AUTH, DASHBOARD, INGEST (7 cores + batch), NEURON-CHAINS, APEX, COSMOS (26 modes), BRAIN (5 personas flows), READER SUITE, IMPRINT, CHRONICLE, ASCENT (roadmap/kanban/mindmap/session/certify/HITL), HARMONIST, NORMAL MODE, NEUROSCIENCE, PIVOTIQ, FINANCE SUITE, B2B CREATOR CONSOLE, ARENA, SETTINGS, SYSTEM (cold start, error recovery, command palette, search, activity, offline), CROSS-MODULE (multi-source, long-task UX, onboarding adaptive)*

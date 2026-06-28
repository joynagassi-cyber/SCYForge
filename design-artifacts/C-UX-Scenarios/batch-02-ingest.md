# WDS-3 SCENARIOS — BATCH 02
_Modules : INGEST (13 cores) — Sélection prioritaire_
_Source : minddoc/s01_ingestion_cores/ + trigger-map.md_
_Version : 1.0_

---

# SC-009 — Ingest vidéo YouTube (P-AL)

**Trigger** : CTA "Ingérer" → sélection "Vidéo YouTube"
**Persona** : P-AL (Autonomous Learner)
**Business Goal** : BG-01 Discover + BG-02 Générer
**Écran** : `/ingest/form`
**Flux** :
1. Input URL YouTube (Zod : regexYouTube)
2. Sélection langue + transcription mode (auto/manual)
3. Submit → POST `/ingestion/youtube` → backend_rs yt-dlp → scrapling_client
4. Progress bar en temps réel via SSE (`/ingestion/youtube/stream/:jobId`)
5. Status : "Transcription…" → "Extraction concepts…" → "Préparation COSMOS…"
6. Success → redirect `/library/item/:id` + notification APEX "3 cartes générées"
**Spec source** : `minddoc/s01_ingestion_cores/c01_youtube_core/scy_youtube_core_spec.md`
**Design System** : `scy-color-primary-500` CTA, stepper 5 étapes, SSE progress bar animée
**Success** : ingest complet en < 5min pour vidéo 30min, handle youtube regex
**Edge** : vidéo privée / région bloquée → message overlay + suggestion proxy
**Edge** : transcript désactivé → fallback description + community subs

---

# SC-010 — Ingest article Web (P-AL, P-KG)

**Trigger** : Bouton extension navigateur "SCYForge" ou coller URL
**Persona** : P-AL (étudiant), P-KG (Knowledge Guardian)
**Business Goal** : BG-01 + BG-02 + BG-06 (Knowledge Guardian ingère sa base)
**Écran** : `/ingest/form` (onglet "Article Web")
**Flux** :
1. Input URL ou extension popup détecte page active
2. bouton "Scraper & Nettoyer" → dom_smoothie (HTML→MD) → `scy_pdf_ingestion_engine` si PDF
3. Aperçu Markdown nettoyé (éditeur Monaco intégré)
4. Metadata auto : titre, auteur, date, domain (Whois)
5. Tags suggérés par BRAIN NER → utilisateur valide/édite
6. Submit → POST `/ingestion/web` → WAL SQLite desktop → EventBus → NEURON-CHAINS
7. Success → redirect `/library/item/:id` + badge "Ingéré"
**Spec source** : `minddoc/s01_ingestion_cores/c02_web_article_core/scy_web_article_core_spec.md` + `minddoc/s01_ingestion_cores/c02_web_article_core/scy_web_search_engine_spec_v2.md`
**Design System** : Monaco editor theme scy-dark, preview pane split, tags chips `scy-radius-full`
**Success** : ingest web en < 30s, preview render en < 2s
**Edge** : paywall / bot protection → message + suggestion mode "résumé via SearxNG"

---

# SC-011 — Ingest document financier + déclenchement PIVOTIQ (P-FA) 🆕

**Trigger** : CTA "Ingérer document financier" depuis Dashboard P-FA
**Persona** : P-FA (Finance Analyst)
**Business Goal** : BG-01 Discover + **PIVOTIQ feature core**
**Écran** : `/pivotiq/ingest`
**Flux** :
1. Upload PDF / 10-K / Earnings call transcript / XBRL
2. Sélection type document : 10-K | 10-Q | Earnings | Presentation | Note
3. Sélection sources additionnelles : [ ] EDGAR [ ] Bloomberg [ ] Reuters [ ] Manually paste
4. Submit → backend_rs `scy-pivotiq-reconciler` normalise + extrait métriques P&L, BS, CF
5. PIVOTIQ reconciliation engine lance comparaison multi-sources (2–5s)
6. Affichage delta : alignements ✅ + divergences ⚠️ + anomalies 🔴
7. Action : "Valider réconciliation" ou "Investiguer divergence"
8. Save → document + reconciliation résultat dans `scy_pivotiq_docs` table
9. Downstream : BRAIN ingest + COSMOS node créé + APEX cartes financières générées
**Spec source** : Nouvelle feature PIVOTIQ + `docs/ROUTES.md` §2.2 `/ingestion/financial`
**Design System** : Tableau reconciliation avec cellules colorées (vert对齐 / rouge divergence / gris N/A), badges source EDGAR/Bloomberg
**Success** : reconciliation 3 sources en < 10s, divergences mises en évidence en 1 coup d'œil
**Edge** : sources incohérentes → modal "Investiguer" ouvre BRAIN avec contexte
**Edge** : upload XBRL invalide → erreur inline avant traitement

---

# SC-012 — Ingest batch multi-sources — Knowledge Base import (P-KG)

**Trigger** : CTA "Importer une base de connaissances" depuis Dashboard P-KG
**Persona** : P-KG (Knowledge Guardian)
**Business Goal** : BG-01 + BG-04 Visualiser COSMOS
**Écran** : `/ingest/batch`
**Flux** :
1. Upload ZIP / CSV manifest listant URLs + types (YouTube, PDF, Web, Academic…)
2. Preview : 50 items listés avec statut (pending / processing / done / error)
3. Sélection parallélisme : 1 | 3 | 5 (max workers)
4. Submit → backend_rs `mapreduce` pipeline L0-L4 distribué
5. Progress globale : X/Y items + ETA calculé
6. Chaque item peut être inspecté individuellement (expand row)
7. Option : "Auto-générer COSMOS" coché par défaut
8. Completion → notification + redirect `/cosmos/graph` pour visualiser
**Spec source** : `minddoc/s01_ingestion_cores/` specs individuelles + `backend_rs/src/api/ingestion.rs`
**Design System** : Tableau large avec virtualisation (react-window), tooltip détail item, badge statut animé
**Success** : batch 100 items en < 30min, COSMOS construit auto à la fin
**Edge** : item en erreur → [Retry] individuel sans relancer tout le batch
**Edge** : timeout EventBus → DLQ affichée + replay option

---

# SC-013 — Ingest podcast audio (P-AL)

**Trigger** : CTA "Ingérer" → onglet "Podcast"
**Persona** : P-AL (Autonomous Learner)
**Business Goal** : BG-01 + BG-02 Générer depuis audio
**Écran** : `/ingest/form` (onglet "Podcast")
**Flux** :
1. URL RSS / podcast episode ou upload MP3
2. Détection automatique : épisode + série + durée
3. Worker Whisper (backend_rs) → transcription → diarisation (si > 1 speaker)
4. Aperçu transcript avec highlights speaker
5. Tags suggérés : sujets + personnes citées
6. Submit → EventBus → NEURON-CHAINS ε (epsilon → génération flashcards)
7. Success → redirect `/library/item/:id` + notif "Audio transformé en contenu"
**Spec source** : `minddoc/s01_ingestion_cores/c03_podcast_core/scy_c03_podcast_core_spec.md`
**Design System** : Audio waveform preview (waveform-loader.ts custom), speaker color chips, progress bar Whisper
**Success** : transcript épisode 1h en < 10min (Whisper large)
**Edge** : file > 200MB → chunk + upload résumable (Tus protocol)

---

# SC-014 — Ingest publication académique (P-AL, P-KG)

**Trigger** : CTA "Ingérer" → onglet "Académique" + DOI lookup
**Persona** : P-AL (recherche), P-KG (base académique)
**Business Goal** : BG-01 + BG-06 Certifier + Harmonist citation check
**Écran** : `/ingest/form` (onglet "Académique")
**Flux** :
1. Input DOI / arXiv ID / PMID → lookup CrossRef / Semantic Scholar API
2. Récupération métadonnées auto : auteurs, journal, date, abstract
3. Check Open Access : PDF disponible ? → download si oui
4. Aperçu abstract + bouton "Voir PDF" (iframe inline)
5. Tags suggérés : MESH terms + keywords COSMOS
6. Submit → citation tracker activé → Harmonist QA gate lancé post-ingest
7. Success → node COSMOS créé + edges vers related papers
**Spec source** : `minddoc/s01_ingestion_cores/c04_academic_core/scy_c04_academic_core_spec.md`
**Design System** : Citation badge `[1]` cliquable, DOI link,引用 format APA/MLA toggle
**Success** : lookup DOI en < 3s, PDF fetch en < 10s
**Edge** : paywalled → suggestion Unpaywall + alternative pre-print
**Edge** : DOI invalide → message + recherche par titre

---

# SC-015 — Ingest multi-cœurs — Bibliothèque personnelle (P-AL)

**Trigger** : CTA "Ma bibliothèque" dans sidebar ou Dashboard
**Persona** : P-AL (Autonomous Learner — vue d'ensemble)
**Business Goal** : BG-03 Rétention + navigation rapide
**Écran** : `/library`
**Flux** :
1. Vue grille / liste toggle : tous items ingérés (YouTube, Web, Podcast, Academic, Finance…)
2. Filtres : type (icône par core), date, tag, statut traitement (done/processing/error)
3. Recherche full-text : interroge PostgreSQL FTS + pgvector
4. Item click → `/library/item/:id` : preview Markdown + métadonnées
5. Actions rapides :
   - [Générer cartes APEX] → lance NEURON-CHAINS ε
   - [Visualiser dans COSMOS] → redirect mode graphe
   - [Ajouter au DAG] → drag vers `/dag` board
   - [Supprimer] → confirm modal
6. Bulk actions : sélection multiple → générer cartes batch / supprimer
**Spec source** : `docs/ROUTES.md` + `docs/DATA_MODEL.md` (library item schema)
**Design System** : Icon grid par core type (🔴 YouTube, 🌐 Web, 🎙️ Podcast, 📚 Academic…), checkbox bulk, toolbar actions
**Success** : library 500 items fluide (virtualized grid), recherche < 500ms
**Edge** : 0 items → empty state avec CTA "Ingérez votre première source"

---

# SC-016 — Ingest erreur — Retry & DLQ gestion (P-AL, P-KG)

**Trigger** : Notification "Ingest échoué" ou badge rouge dans Library
**Persona** : P-AL, P-KG
**Business Goal** : Support onboarding + confiance système
**Écran** : `/ingest/errors` + toast inline
**Flux** :
1. Toast : "⚠️ Ingest échoué — [Voir détails]"
2. Détail modal : cause (timeout / 403 / parse error) + logs backend
3. Actions :
   - [Réessayer] (retry même source)
   - [Modifier paramètres] (changer langue, format)
   - [Ignorer] (marquer comme skipped)
   - [Signaler problème] (ouvrir ticket / feedback)
4. Retry → re-enqueue dans EventBus + mise à jour statut
5. Si échec x3 → DLQ (Dead Letter Queue) → notif "Besoin d'intervention humaine"
6. Historique : onglet "Échecs passés" avec status + timestamp
**Spec source** : `backend_rs/crates/scy-eventbus/src/dead_letter.rs` + `docs/ROUTES.md`
**Design System** : Badge `scy-color-danger-500` error, accordion logs, skeleton loading states
**Success** : user comprend la cause en < 10s, retry fonctionne en 1 clic
**Edge** : erreur récurrente → escalation HITL (human-in-the-loop) via ASCENT ag16

---

*Fin du batch 02 — 8 scénarios (INGEST — cores priorisés parmi 13)*
*Cores couverts : YouTube • Web Article • Financial 🆕 • Batch • Podcast • Academic • Library overview • Error handling*
*Prochain batch : NEURON-CHAINS + APEX (6 scénarios)*

# WDS-3 SCENARIOS — BATCH 03
_Modules : NEURON-CHAINS + APEX_
_Source : minddoc/s02_neuron_chains_apex_agent/ + minddoc/s05_apex_retention_system/_
_Version : 1.0_

---

# SC-017 — Génération flashcards depuis contenu ingéré (P-AL)

**Trigger** : Cliquer "Générer cartes APEX" depuis Library item `/library/item/:id`
**Persona** : P-AL (Autonomous Learner)
**Business Goal** : BG-02 Générer + BG-03 Réviser
**Écran** : `/neuron-chains/generate?sourceId=xxx`
**Flux** :
1. Sélection du type de sortie : Cartes APEX (B01-B10) — checkbox multi
2. Sélection du contexte : Chapitres / Sections / Full document
3. Submit → POST `/neuron-chains/run` avec `{sourceId, outputTypes: ["apex_cards"], context: "chapter_3"}`
4. Backend_rs `scy-neuron-chains` exécute chaînes α→ε en 4 passes :
   - α : extraction concepts (NER + embeddings)
   - β : structuration en objets APEX (cloze, QCM, true/false…)
   - γ : enrichissement via BRAIN Professor AI (exemples concrets)
   - ε : génération cartes prêtes pour FSRS scheduler
5. Progress : stream SSE `/neuron-chains/run/stream/:jobId` avec étapes
6. Success : redirect `/apex/cards?session=new` + notif "15 cartes générées"
**Spec source** : `minddoc/s02_neuron_chains_apex_agent/` specs + `backend_rs/crates/scy-neuron-chains/src/chains/`
**Design System** : Stepper α-β-γ-δ-ε-ζ-η avec icônes, badge "IA généré", spinner SSE
**Success** : 15 cartes générées depuis 30min vidéo en < 2min
**Edge** : contenu trop pauvre → warning "Peu de concepts extraits — voulez-vous enrichir ?"
**Edge** : génération timeout LLM > 30s → fallback DeepSeek V4 + retry auto

---

# SC-018 — Génération résumé exécutif financier — FINANCE SUITE (P-FA) 🆕

**Trigger** : CTA "Générer exécutif" depuis PIVOTIQ reconciliation item
**Persona** : P-FA (Finance Analyst)
**Business Goal** : BG-02 + Finance Suite feature
**Écran** : `/finance-suite/generate?docId=xxx`
**Flux** :
1. Sélection format : PDF (typst) | DOCX | PPTX | MD
2. Sélection sections : [ ] Executive Summary [ ] P&L Highlights [ ] Cash Flow [ ] Risks
3. Sélection longueur : 1-page | 3-pages | 5-pages | Full
4. Submit → backend_rs lance NEURON-CHAINS ε (epsilon → génération documents)
5. Utilise données PIVOTIQ reconciliées + [1][2] citations EDGAR/Bloomberg
6. Aperçu Markdown temps réel (Monaco) pendant génération
7. Export final : typst PDF via `typst-pdf` crate (interdit printpdf)
8. Historique générations : onglet "Exécutifs passés" avec dates
**Spec source** : Nouvelle feature FINANCE SUITE + `minddoc/s02_neuron_chains_apex_agent/` ε chain
**Design System** : Template sélection cards (visual preview), format badges, download button `scy-color-primary-500`
**Success** : résumé 3-pages PDF en < 5min post-reconciliation
**Edge** : contradictions sources → alerte inline "Valeurs divergentes détectées — vérifier section P&L"
**Edge** : export typst échoue → fallback DOCX via crate `docx 0.4`

---

# SC-019 — Génération QCM + diagnostic adaptatif (P-AL, P-B2B)

**Trigger** : CTA "Évaluer" depuis DAG node ou Library item
**Persona** : P-AL (test), P-B2B (évaluation cohorte)
**Business Goal** : BG-06 Certifier + ASCENT
**Écran** : `/neuron-chains/quiz?sourceId=xxx`
**Flux** :
1. Configuration : nb questions (5 | 10 | 20 | 50), difficulté, temps limite
2. Types de questions : ☑ QCM ☑ Vrai/Faux ☑ Cloze ☑ Ouverte courte
3. Submit → backend_rs NEURON-CHAINS δ (delta → validation) + λ (learning objective align)
4. Génération : chaque question liée à un concept node COSMOS (traçabilité)
5. Preview édition avant publication : réorganiser, éditer, supprimer questions
6. Publier → questions insérées dans `scy_quiz` table
7. Lien partageable créé pour cohort B2B ou user P-AL
8. Analytics : taux réussite par question, discrimination index
**Spec source** : `minddoc/s02_neuron_chains_apex_agent/` δ chain + `minddoc/s09_harmonist_validation_gates/`
**Design System** : Card question editor, difficulty slider, preview mode
**Success** : 20 questions générées en < 3min, publication en 1 clic
**Edge** : ambiguïté question → Harmonist QA gate suggère reformulation

---

# SC-020 — Génération cartes conceptuelles COSMOS (P-AL, P-KG)

**Trigger** : Bouton "Générer carte conceptuelle" depuis Library item
**Persona** : P-AL, P-KG
**Business Goal** : BG-04 Visualiser COSMOS + BG-01
**Écran** : `/cosmos/generate?sourceId=xxx`
**Flux** :
1. Sélection mode COSMOS cible : M00 (Knowledge Graph) / M02 (Lexical) / M04 (Roadmap)
2. Depth : Shallow (1-hop) | Medium (2-hop) | Deep (3-hop)
3. Submit → backend_rs lance :
   - α : extraction concepts
   - β : structuration nodes + edges
   - COSMOS `auto_graph.rs` : cosine > 0.75 edges auto
4. Preview graphe : render miniaturisé (G6 WebGL) dans modal
5. Actions : ajouter nodes manuellement, supprimer edges, éditer labels
6. Save → commit dans `scy_graph_nodes` + `scy_graph_edges` tables
7. Redirect `/cosmos/modes/00` (Knowledge Graph complet)
**Spec source** : `minddoc/s04_scy_cosmos_visualization_engine/` specs + `backend_rs/crates/scy-cosmos-kg/src/auto_graph.rs`
**Design System** : Mini graphe G6 dans modal, `scy-color-primary-500` nodes, depth toggle
**Success** : graphe 50 nodes généré en < 1min, edge auto-détectées en < 5s
**Edge** : trop d'edges (>1000) → warning + suggestion threshold cosine > 0.85

---

# SC-021 — Génération document final Export (P-B2B, P-FA)

**Trigger** : CTA "Exporter" depuis NEURON-CHAINS outputs
**Persona** : P-B2B, P-FA
**Business Goal** : BG-02 + B2B deliverable
**Écran** : `/neuron-chains/export`
**Flux** :
1. Sélection output : 📄 PDF (typst) | 📝 DOCX | 📊 PPTX | 🔗 MD (GitHub-ready)
2. Template : [SCY Forge Default] [Corporate B2B] [Finance Report] [Academic]
3. Options : ☑ Citations [1][2] ☑ Table des matières ☑ Glossary auto-glossaire
4. Branding B2B : upload logo + couleur primaire (override design tokens)
5. Submit → backend_rs ε chain → typst PDF engine
6. Progress : "Compilation…" (typst compile ~10–30s typique)
7. Download : fichier servis depuis backend_rs storage bucket
8. Historique exports : onglet avec dates + formats + tailles
**Spec source** : FINANCE SUITE feature + `minddoc/s02_neuron_chains_apex_agent/chains/epsilon/` generics documents
**Design System** : Template preview cards, format icon badges, progress bar compilation
**Success** : PDF 20-pages en < 1min, DOCX en < 10s
**Edge** : typst erreur → message détailléligne + fallback DOCX auto

---

# SC-022 — Anti-hallucination review + Harmonist QA (tous)

**Trigger** : Avant publication d'un contenu généré (auto ou manuel)
**Persona** : tous (P-AL, P-B2B, P-FA, P-KG)
**Business Goal** : BG-06 Certifier qualité
**Écran** : `/harmonist/review/:contentId`
**Flux** :
1. Auto-trigger : après NEURON-CHAINS ζ (zeta → revision qualité)
2. 3 couches anti-hallucination :
   - Couche 1 : CitationTracker vérifie chaque `[n]` existe dans sources
   - Couche 2 : Semantic cache compare embedding généré vs source — seuil 0.82
   - Couche 3 : LLM judge (DeepSeek V4 free) — prompt "Détecte toute affirmation non sourcée"
3. Résultats alignés Harmonist QA gates : ✅ Pass | ⚠️ Warning | 🔴 Fail
4. Si Warnings : suggestions corrections inline + accept/reject/replace par utilisateur
5. Si Fail : blocage publication + escalation vers reviewer humain (ASCENT ag16 HITL)
6. Audit log : chaque décision enregistrée dans `scy_harmonist_audit` table
**Spec source** : `minddoc/s09_harmonist_validation_gates/` + `backend_rs/crates/scy-neuron-chains/src/anti_hallucination/`
**Design System** : Checklist 3-couches avec status badge, diff view corrections, confidence score
**Success** : review auto en < 5s par document, 0% hallucination sur sortie publiée
**Edge** : faux positif citation checker → override manuel possible + feedback loop

---

*Fin du batch 03 — 6 scénarios (NEURON-CHAINS + APEX)*
*Prochain batch : COSMOS + BRAIN (8 scénarios)*

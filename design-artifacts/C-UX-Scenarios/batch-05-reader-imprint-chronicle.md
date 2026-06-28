# WDS-3 SCENARIOS — BATCH 05
_Modules : READER SUITE + IMPRINT + CHRONICLE_
_Source : minddoc/s07_scy_imprint_cognitive/ + minddoc/s08_scy_reader_suite/ + minddoc/s03_ascent_pipeline_agents/ag10_chronicle/_
_Version : 1.0_

---

# SC-033 — Reader Suite — File Viewer PDF/EPUB (P-AL)

**Trigger** : Clic sur un item Library de type PDF/EPUB depuis `/library/item/:id`
**Persona** : P-AL (Autonomous Learner)
**Business Goal** : BG-02 Générer + consommation contenu
**Écran** : `/reader/file/:id`
**Flux** :
1. `FileViewer.tsx` monte le renderer selon le format :
   - PDF : PDF.js + moteur highlights annotations
   - EPUB : epub.js + pagination fluide + police ajustable
   - DOCX : conversion MD via backend_rs si nécessaire
2. Toolbar Reader :
   - Zoom +/-, Plein écran, Thème (light/dark/sepia), Police taille
   - [Annoter] : highlight selection → dropdown (note, question, concept)
   - [Deep Link] : bouton crée lien `reader://nodeId?page=12&selection=abc`
   - [Voir COSMOS] : panel slide-out montre concepts liés extraits auto
3. Sidebar annotations : liste triée par page + filtre type + recherche
4. Export annotations → MD / DOCX (via `export_formats/` spec)
5. DeepLinkNavigator : si lien `reader://` cliqué → restore état exact (page, scroll, selection highlightée)
**Spec source** : `minddoc/s08_scy_reader_suite/file_viewer/scy_file_viewer_spec.md`
**Design System** : `scy-radius-md` toolbar, `scy-shadow-sm` annotations panel, typographie lisible (line-height 1.6)
**Success** : ouverture PDF 100 pages en < 1s, annotations fluide
**Edge** : fichier corrompu → fallback viewer basique + message

---

# SC-034 — Reader Suite — Web Viewer pour contenu en ligne (P-AL, P-FA)

**Trigger** : CTA "Ouvrir dans Reader" depuis Library item de type Web/URL
**Persona** : P-AL, P-FA
**Business Goal** : BG-01 + consommation sans distraction
**Écran** : `/reader/web/:id`
**Flux** :
1. `WebViewer.tsx` charge URL dans iframe sandboxé (CSP restrictif)
2. Overlay Reader actif pendant chargement : minuterie + barre progression
3. Bouton [Extraire sélection] : user surligne texte → popup "Ajouter comme note" ou "Créer carte APEX"
4. Injections DOM :
   - Bouton SCY Forge flottant en haut à droite (extention-like)
   - Raccourci clavier `Ctrl+Shift+S` capture selection
5. Highlight Management : toutes selections enregistrées dans `scy_reader_annotations` table
6. Sync : si user quitte without save → auto-save draft dans localStorage + prompt "Voulez-vous conserver vos notes ?"
7. Partage : lien Deep Link partageable vers sélection précise
**Spec source** : `minddoc/s08_scy_reader_suite/web_viewer/scy_web_viewer_spec.md`
**Design System** : Overlay `scy-color-neutral-900` 80% opacity, bouton flottant `scy-radius-full`
**Success** : chargement page en < 3s, extraction sélection en < 500ms
**Edge** : CSP bloque iframe → message "Site incompatible avec Reader — ouvrir dans nouvel onglet"

---

# SC-035 — Reader Suite — Book Orchestrator — Reading plan adaptatif (P-AL)

**Trigger** : CTA "Créer un plan de lecture" depuis Library item de type livre/document long
**Persona** : P-AL (Autonomous Learner — auto-didacte structuré)
**Business Goal** : BG-03 Rétention structurée + APEX intégré
**Écran** : `/reader/orchestrator/:docId`
**Flux** :
1. `BookOrchestrator.tsx` analyse le document :
   - TOC extraite (PDF bookmarks / EPUB nav)
   - Chapitres estimés par densité tokens
   - Concepts clés par chapitre (COSMOS NER)
2. Configuration plan :
   - Objectif : "Lire en 1 semaine" | "Lire en 1 mois" | "Personnalisé"
   - Rythme : 15min | 30min | 1h par jour
   -.Objectif : "Compréhension seule" vs "Mémorisation active" (APEX)
3. Génération DAG roadmap (React Flow - engine_react_flow) :
   - Nodes = chapitres, Edges = prérequis, Durée = taille × vitesse
   - Color codes : 🟢 Prêt | 🟡 En cours | 🔴 Bloqué (prérequis manquants)
4. Intégration APEX :
   - Après chaque chapitre → auto-suggest flashcards (NEURON-CHAINS ε)
   - Review reminders : FSRS scheduler notifie "Chapitre 3 prêt pour révision"
5. Progress tracking : barre globale + vue par chapitre
6. Actions : [Marquer terminé] → unlock next chapter si prérequis remplis
**Spec source** : `minddoc/s08_scy_reader_suite/book_orchestrator/scy_book_orchestrator_spec.md`
**Design System** : React Flow nodes `scy-radius-md`, badges chapitre couleurs, stepper vertical
**Success** : plan généré en < 5s, roadmap interactive fluide
**Edge** : document sans TOC → estimation auto par pages + user peut override

---

# SC-036 — IMPRINT — CRE Engine — Distillation cognitive (P-AL, P-KG)

**Trigger** : CTA "Distiller" depuis DAG node ou concept COSMOS
**Persona** : P-AL (apprendre), P-KG (structurer base)
**Business Goal** : BG-04 Visualiser + BG-06 Certifier essence conceptuelle
**Écran** : `/imprint/cre/:nodeId`
**Flux** :
1. `CRE Engine` backend_rs exécute distillation 5 crans (5 levels) :
   - L0 : Document brut (>10k tokens)
   - L1 : Résumé exécutif (~2000 tokens)
   - L2 : Synthèse structurée (~500 tokens)
   - L3 : Concept nucléaire (~100 tokens) ← couche de travail utilisateur
   - L4 : Empreinte mémorielle (~20 tokens)
2. UI Tree Renderer ASCII (Garniture — `garniture_tree_renderer`) :
   - Arbre vertical avec nodes L0→L4
   - Each node : preview hover + [Ouvrir] [Éditer] [Générer enfant]
3. Workflow :
   - User édite L3 concept → valide
   - Auto-génère L4 empreinte (cosine compression)
   - Sauvegarde dans `scy_imprint_cre` table PostgreSQL
4. Visualisation Garniture : rendu ASCII art style (Mermaid-like custom)
5. Comparaison : sélectionner 2 nodes → overlay comparison view differences
**Spec source** : `minddoc/s07_scy_imprint_cognitive/cre_engine/scy_cre_engine_spec.md`
**Design System** : Tree nodes `scy-radius-sm`, badges niveau L0-L4, accents par profondeur
**Success** : distillation L0→L3 en < 10s, re-génération L4 en < 2s
**Edge** : document trop pauvre → avertissement "Distillation limitée — ajouter sources"

---

# SC-037 — IMPRINT — Garniture Tree Renderer — Visualisation empreinte (P-KG)

**Trigger** : CTA "Voir l'empreinte" depuis IMPRINT CRE node
**Persona** : P-KG (Knowledge Guardian — vue macro)
**Business Goal** : BG-04 Visualiser arborescence cognitive
**Écran** : `/imprint/garniture/:conceptId`
**Flux** :
1. `GarnitureTreeRenderer.tsx` fetch :
   - Node racine sélectionné + descendants (profondeur max 5)
   - Relations : parent/child, semantic_similarity, co-occurrence
2. Render modes :
   - ASCII tree : rendu texte stylé fidèle à spec Garniture
   - Visual tree : d3-hierarchy radial layout optionnel
   - Export : PNG / SVG / DOT (Graphviz)
3. Interactions :
   - Expand/collapse branches
   - Hover node : tooltip avec métriques (poids, date, auteur)
   - Click node : navigue vers `/library/item/:id` source
   - Drag reorder : déplacer node entre parents (avec confirmation)
4. Stats overlay : nb descendants, profondeur moyenne, densité sémantique
5. Partage : snapshot Garniture exporté comme image + metadata
**Spec source** : `minddoc/s07_scy_imprint_cognitive/garniture_tree_renderer/scy_garniture_tree_renderer_spec.md`
**Design System** : Tree lines `scy-color-neutral-400`, node badges `scy-radius-sm`
**Success** : render arbre 500 nodes en < 1s, export PNG en < 3s
**Edge** : arbre déséquilibré (1 branche dominant) → layout auto-rebalance avant render

---

# SC-038 — IMPRINT — Empreinte Vocabulaire — Signature conceptuelle (P-KG, P-B2B) 🆕

**Trigger** : CTA "Voir empreinte vocabulaire" depuis Concept page ou Dashboard P-KG
**Persona** : P-KG, P-B2B
**Business Goal** : BG-06 Certifier unicité conceptuelle + brand B2B
**Écran** : `/imprint/vocabulaire/:conceptId`
**Flux** :
1. `EmpreinteVocabulaire` backend_rs calcule :
   - Distribution termes par fréquence (TF-IDF)
   - N-grammes signatures (bigrammes/trigrammes distinctifs)
   - Embedding centroid + variance (qualité représentation)
   - Comparaison aux concepts voisins (cosine > 0.7 risque collision)
2. UI Visualisation :
   - Word cloud pondérée (taille = fréquence, couleur = centralité)
   - Distribution chart (Recharts bar chart top 30 termes)
   - Radar diagram : 5 dimensions (spécificité, densité, stabilité,unicité, fraîcheur)
3. Signaux d'alerte :
   - 🔴 Vocabulaire trop générique → "Considérez ajouter sources spécialisées"
   - 🟡 Collision sémantique → "3 concepts voisins partagent 40% du vocabulaire"
   - 🟢 Signature unique → "Empreinte distinctive confirmée"
4. Usage B2B : brand vocabulary check pour créateurs (cohérence tone of voice)
5. Historique : évolution empreinte dans le temps (si document mis à jour)
**Spec source** : `minddoc/s07_scy_imprint_cognitive/empreinte_vocabulaire/scy_empreinte_vocabulaire_spec.md`
**Design System** : Word cloud custom component, radar chart `scy-color-primary-500`, badges alerte
**Success** : calcul empreinte en < 3s, visualisation fluide
**Edge** : concept trop récent (< 3 docs) → message "Données insuffisantes"

---

# SC-039 — CHRONICLE — Chat quotidien — Daily Pulse (P-AL, P-KG)

**Trigger** : Badge notification "Daily Pulse" + ouverture depuis Dashboard ou sidebar CHRONICLE
**Persona** : P-AL (routine), P-KG (veille)
**Business Goal** : BG-03 Rétention boucle quotidienne + engagement
**Écran** : `/chronicle/chat`
**Flux** :
1. `ChronicleChat.tsx` layout WhatsApp-like :
   - Header : "Daily Pulse — [date]" + streak count + XP gagnés
   - Messages bubbles : user (droite, `scy-color-primary-500`) vs CHRONICLE (gauche, `scy-color-neutral-100`)
2. Message quotidien auto-généré par ASCENT ag10_chronicle :
   - "🌟 Bonjour ! Aujourd'hui : 3 cartes dues, 1 nouveau node COSMOS sur [topic]. Prêt ?"
   - Suggestions cliquables : [Voir mes cartes] [Explorer COSMOS] [Discuter avec BRAIN]
3. Interactions :
   - User reply textuel ou vocal → CHRONICLE répond contextuellement
   - Quick actions inline : [Confirmer] [Reporter] [Changer sujet]
   - Partage : forward message à BRAIN pour approfondissement
4. Push notifications : web push + mobile (si PWA installé)
   - 9h : Daily Pulse
   - 18h : Résumé journée ("Vous avez révisé 12 cartes — keep going !")
5. Historique : 7 jours sliding window + search
**Spec source** : `minddoc/s03_ascent_pipeline_agents/ag10_chronicle/scy_ag10_chronicle_spec.md` + `docs/ROUTES.md` §2.8
**Design System** : WhatsApp-like bubbles, `scy-radius-lg`, emoji sparingly, notification badge `scy-color-danger-500`
**Success** : Daily Pulse généré en < 2s, push reçu en < 1min
**Edge** : user mute 24h → respect + message "À demain !"

---

# SC-040 — CHRONICLE — Health Monitor — Métriques cognitives (P-AL, P-KG)

**Trigger** : Sidebar CHRONICLE → onglet "Santé" ou CTA depuis Dashboard
**Persona** : P-AL, P-KG
**Business Goal** : BG-03 Rétention + visibilité progression
**Écran** : `/chronicle/health`
**Flux** :
1. `HealthMonitor.tsx` fetch métriques via EventBus (APEX publisher events) :
   - Streak jours consécutifs
   - Cartes révisées / dues (SMI strength distribution)
   - Concepts maîtrisés (score APEX ≥ 90% sur 3 sessions)
   - Vitesse learning : concepts/semaine
   - Focus areas : top domaines par temps passé
2. Gauges animées (d3) :
   - Retention Score (0–100) : composite SMI + streak + maîtrise
   - Learning Velocity : courbe Recharts 30 derniers jours
   - Cognitive Load : warning si > 3h session unique
3. Insights :
   - "Vous maîtrisez mieux le soir (18h–21h)"
   - "3 concepts faibles SMI : [cards] → revoir"
4. Alertes :
   - 🔴 Burnout risk : > 2h sans pause → suggestion break
   - 🟡 Plateau : stagnation 7 jours → propos nouvelle stratégie
5. Partage B2B : export PDF rapport progression pour manager/créateur
**Spec source** : `minddoc/s03_ascent_pipeline_agents/ag10_chronicle/` + retention science specs
**Design System** : Gauges `scy-color-primary-500`, `scy-color-success-500`, `scy-color-warning-500`, chart line smooth
**Success** : dashboard load en < 2s, insights pertinents
**Edge** : nouveau user sans data → empty state + "Complétez 3 sessions pour voir vos métriques"

---

# SC-041 — IMPRINT — Leech Verse — Détection concepts difficiles (P-AL)

**Trigger** : Auto-détection après 3 échecs APEX sur même node COSMOS
**Persona** : P-AL
**Business Goal** : BG-03 Rétention + remédiation automatique
**Écran** : `/imprint/leech/:nodeId`
**Flux** :
1. Backend_rs `scy_imprint_leech_verse_spec.rs` détecte Leech :
   - Définition : node avec retention rate < 50% sur 5 tentatives
   - Calcul : rolling window 30 jours, threshold configurable
2. UI LeechVerse page :
   - Header alert : "⚠️ Concept en difficulté : [nom node]"
   - Stats : taux échec, nb révisions, intervalle moyen, SMI history
   - Causes probables (backend infers) :
     - Concept trop large (trop de facets)
     - Prérequis manquants (gap detection COSMOS)
     - Card mal formulée (ambiguous question)
3. Actions remédiation :
   - [Décomposer] : NEURON-CHAINS α subdivide concept en sous-nodes
   - [Créer prérequis] : ajoute node manquant au DAG
   - [Reformuler carte] : éditeur inline question/answer APEX
   - [Reprogrammer] : FSRS intervalle -30%, review quotidienne
   - [Ignorer temporairement] : marquer "pass" 7 jours
4. Tracking : toutes interventions enregistrées dans `scy_leech_interventions` table
5. Dashboard Leech : vue globale tous leeches actifs (admin/Knowledge Guardian)
**Spec source** : `minddoc/s07_scy_imprint_cognitive/scy_imprint_leech_verse_spec.md` + `minddoc/s05_apex_retention_system/` leech_detector
**Design System** : `scy-color-danger-500`/`scy-color-warning-500` alertes, stepper remédiation, badge Leech
**Success** : détection en temps réel, remédiation en < 2min
**Edge** : faux positif leec h → feedback "Pas un leech" → ajuste seuil auto per user

---

# SC-042 — CHRONICLE — Humility Charter — Révision journée (P-AL, P-B2B)

**Trigger** : Notification "Bilan du jour" à 20h ou ouverture manuelle
**Persona** : P-AL (réflexion), P-B2B (coach équipe)
**Business Goal** : BG-03 Rétention métacognitive + Humilité Totale (CHRONICLE charter)
**Écran** : `/chronicle/daily-review`
**Flux** :
1. `DailyPulse.tsx` génère bilan selon charter Humilité Totale (`scy_chronicle_humility_charter.md`) :
   - "Aujourd'hui, vous avez [X] révisé, [Y] appris."
   - "Vous avez maîtrisé [Z] concepts."
   - "1 concept en difficulté : [A] — remédiation suggérée."
2. Grille Honnêteté Intellectuelle :
   - ☑ "J'ai bien compris ce que j'ai révisé aujourd'hui ?"
   - ☑ "Je peux expliquer ceci à quelqu'un d'autre ?"
   - ☑ "Qu'est-ce que j'ai appris de nouveau ?"
3. Prompt réflexion (optionnel) :
   - Textarea "Note du jour" (max 500 chars)
   - Tags : [Difficile] [Facile] [Surprenant] [À revoir]
4. Pour P-B2B : vue cohorte agrégée
   - Taux complétion quotidien par membre
   - Top 3 concepts maîtrisés équipe
   - Alertes : membres en difficulté (> 3 leeches)
5. Export : snapshot PNG/MD pour partage ou archiving
**Spec source** : `minddoc/s03_ascent_pipeline_agents/ag10_chronicle/scy_chronicle_humility_charter.md`
**Design System** : Checkbox `scy-color-primary-500`, textarea warm, chart cohorte Recharts
**Success** : review 2min, insights pertinents
**Edge** : user skip → sauvegarde "Skippé" avec possibilité catch-up

---

*Fin du batch 05 — 8 scénarios (Reader Suite + IMPRINT + CHRONICLE)*
*Modules couverts : FileViewer, WebViewer, BookOrchestrator, CRE, Garniture, Empreinte Vocabulaire 🆕, LeechVerse, Chronicle Chat, HealthMonitor, Daily Review Humility Charter*
*Prochain batch : ASCENT Pipeline (18 agents) + HARMONIST QA (8 scénarios)*

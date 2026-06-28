# SC-043 — DAG ASCENT — Vue Roadmap interactive

**Persona** : P-AL (Autonomous Learner)
**Trigger** :Ouverture module ASCENT depuis sidebar
**Écran** : `/ascent/roadmap`
**Flux** :
1. Dashboard ASCENT affiche la roadmap React Flow : objectif racine → nœuds phases → nœuds concepts
2. Chaque nœud : badge SMI, statut verrouillé/débloqué/en cours/completé, durée estimée
3. Arêtes : prérequis sémantiques (couleur par force du lien)
4. Panneau latéral : clic sur nœud → détails, flashcards associées (APEX), métriques de progression
5. Toolbar : zoom, fit-to-screen, filtre par statut, vue par compétence
6. Command palette `Cmd+K` → naviguer vers node, créer node, éditer
7. États visuels :
   - 🔒 Verrouillé (gris) → prérequis non remplis
   - 🔓 Débloqué (info) → prêt à apprendre
   - 🔄 En cours (warning) → en progression
   - ✅ Completé (success) → maîtrisé
**Tokens** : `scy-color-info`, `scy-color-success`, `scy-color-warning`, `scy-card`
**Spéc source** : `docs/ROUTES.md §3.1`, `minddoc/s03_ascent_pipeline_agents/`
**Success** : roadmap rend en < 500ms, 200+ nodes fluides, transitions nodes temps réel
**Edge** : objectif sans prérequis → wizard création DAG auto

---

# SC-044 — DAG ASCENT — Vue Kanban

**Persona** : P-AL, P-KG (Knowledge Guardian — vue organisée)
**Trigger** : Toggle [Kanban] dans bar d'outils ASCENT
**Écran** : `/ascent/kanban`
**Flux** :
1. Colonnes Kanban : À faire | En cours | En révision | Maîtrisé | Certifié
2. Drag & drop entre colonnes pour mettre à jour statut (avec undo)
3. Cartes Kanban : titre node, tags compétence, SMI mini-gauge, assignés (B2B mode)
4. Filtres : par phase, par compétence, par difficulté, par date limite
5. Vue assignation B2B : clic droit → assigner créateur/cadre, set deadline, add note
6. Vue Knowledge Guardian : toutes les cards de tous les users filterable, bulk actions
7. Actions rapides par card : [Démarrer session APEX] [Voir COSMOS] [Assigner]
8. Empty state : "Aucun nœud — générez votre roadmap d'abord"
**Tokens** : `scy-card`, `scy-radius-md`, badge couleurs par colonne
**Spéc source** : `docs/ROUTES.md`, `minddoc/s03_ascent_pipeline_agents/dag_display_modes/`
**Success** : drag fluide 60fps, state sync temps réel
**Edge** : drag bloqué (permissions B2B) → feedback inline "Droits insuffisants"

---

# SC-045 — DAG ASCENT — Vue MindMap cognitive

**Persona** : P-AL, P-KG (vue arborescente conceptuelle)
**Trigger** : Toggle [MindMap] dans bar d'outils ASCENT
**Écran** : `/ascent/mindmap`
**Flux** :
1. Render arbre sémantique : racine = objectif, branches = phases, feuilles = concepts
2. Layout : force-directed ou radial (toggle), layout sauvegardé par user
3. Chaque feuille : label concept, icône type (vidéo/texte/pratique), SMI coloré
4. Focus contextuel : hover highlight sub-tree, click zoom sur branche
5. Mini-map navigable en bas à droite
6. Ajout de nœud : clic sur [⊕] entre deux nodes → wizard : "Ajouter compétence intermédaire ?"
7. Export : PNG MindMap, SVG, ou export COSMOS node pour Knowledge Graph
8. Recherche : `Cmd+K` focus + fuzzy search tous les nodes du DAG
**Tokens** : `scy-radius-sm`, `scy-line`, couleurs statut (voir roadmap)
**Spéc source** : `minddoc/s03_ascent_pipeline_agents/dag_display_modes/`
**Success** : 300 nodes renderés en < 2s, interaction fluide
**Edge** : arbre circulaire (3000+ nodes) → avertissement "Vue simplifiée recommandée"

---

# SC-046 — Création objectif ASCENT — Wizzard NL

**Persona** : P-AL, P-B2B (créateur cohorte)
**Trigger** : CTA "Nouvel objectif" sur Dashboard ou page ASCENT vide
**Écran** : `/ascent/create-goal`
**Flux** :
1. Step 1 : NL input → "Maîtriser Rust async et Tokio pour applications haute performance"
2. Prévisualisation IA : objectif parsé → competences identifiées, gaps estimés
3. Step 2 : Catégorie (Langage/Framework/Concepts), Niveau actuel, Niveau cible, Deadline
4. Step 3 : Aperçu roadmap generated (mini-graph) → "15 nœuds, ~12h estimées"
5. Submit → POST `/api/ascent/dag/build` → modal progrès DAG generation
6. Cancel token si user ferme modal
7. Result : redirect `/ascent/roadmap?new=xxx` avec roadmap animée entrée nodes
**Spéc source** : `docs/ROUTES.md §3.1`, ASCENT `ag01_goal_interpreter`, `ag03_dag_architect`
**Tokens** : stepper, `scy-card`, `scy-spinner`
**Success** : DAG généré en < 10s, roadmap rendu fluide
**Edge** : objectif trop large → warning "Découper en sous-objectifs ?"

---

# SC-047 — Session APEX — Révision active

**Persona** : P-AL
**Trigger** : Clic [Réviser] depuis roadmap ASCENT ou Dashboard
**Écran** : `/ascent/session/:goalId`
**Flux** :
1. Session setup : objectif sélectionné, deck flashcards associées, mode (standard/intensif)
2. Card flip : recto = question, verso = réponse avec citation [1] + explication contextualisée
3. Feedback 4 boutons : Oublié | Difficile | Bon | Facile → mise à jour FSRS temps réel
4. Streak counter : cartes révisées dans session, barre progression
5. Timer optionnel : mode sprint (30s/card) ou exploration (pas de limite)
6. Statut session : sauvegarde auto, possibilité pause/reprise
7. End session : résumé (cartes révisées, SMI moyen, temps, XP gagnés)
8. Post-session : suggestion auto prochaine session (FSRS forecast)
**Spéc source** : `docs/ROUTES.md §2.4`, `minddoc/s05_apex_retention_system/`
**Tokens** : `scy-card-3d`, flip animation 1400ms, emerald laser reveal, couleurs feedback
**Success** :Session 20 cartes en 15min, cache hit < 200ms
**Edge** : interruption navigateur → resume auto au dernier index

---

# SC-048 — Dashboard progression ASCENT — Vue globale

**Persona** : P-AL, P-B2B (vue cohorte)
**Trigger** : Dashboard ASCENT ou `/ascent/progress`
**Écran** : `/ascent/progress/:goalId` ou dashboard
**Flux** :
1. Grille KPIs : SMI moyen, cartes révisées aujourd'hui, streak jours, temps total investi, taux complétion goal
2. Graphique progression 7j/30j/90j (Recharts area) : SMI par jour
3. Répartition par compétence : bar chart par node DAG
4. Insights ASCENT agent :
   - "Vous progressez de +5pts SMI/semaine — rythme soutenu"
   - "3 concepts stagnants : proposez exercices pratiques ?"
   - "Meilleur créneau : 18h–20h, taux rétention 2x supérieur"
5. B2B cohort view : leaderboard anonyme, comparaison moyenne équipe, badges top performers
6. Alertes intelligentes :
   - 🔴 Burnout risk (>2h session)
   - 🟡 Plateau detection (7j stagnation)
   - 🟢 Milestone atteint (célébration animée)
7. Export : PDF rapport progression via typst-pdf
**Spéc source** : `backend_rs/crates/scy-apex-fsrs/`, ASCENT `ag05_performance_analyzer`
**Tokens** : `scy-color-success`, `scy-color-warning`, `scy-color-alert`, `scy-card`
**Success** : dashboard load < 2s, insights pertinents
**Edge** : pas de données → empty state + CTA "Démarrer votre première session"

---

# SC-049 — Certification ASCENT — Preuve de compétence

**Persona** : P-AL, P-B2B (employeur certification)
**Trigger** : 100% nodes DAG complétés + SMI ≥ 80/100 sur 75% nodes
**Écran** : `/ascent/certify`
**Flux** :
1. Invitation : "Félicitations ! Objectif atteint — Prêt pour la certification ?"
2. Exam configuration :
   - Mode : QCM + Code + Réponse longue + Oral (BRAIN Professor AI)
   - Time limit : 30min/1h/sans limite
   - Conditions : invigilation optionnelle (webcam + tab switch detection)
3. Exam interface :
   - QCM : radio buttons, auto-submit on select
   - Réponse longue : textarea, évaluation post-par AI + Harmonist QA
   - Oral : enregistrement vocal MediaRecorder → transcription Whisper → évaluation
4. Grading :
   - Score ≥ 90% → 🏆 Certifié + badge + certificate PDF (typst)
   - Score 70–89% → ⚠️ Certifié avec recommandations
   - Score < 70% → ❌ Échec → roadmap remediation générée automatiquement
5. Certificate : généré typst-pdf, signé ASCENT agent, NFT-like hash dans `scy_certificates`
6. Share : LinkedIn share (template), badge embed URL, portfolio inclusion
**Spéc source** : `docs/ROUTES.md §3.1`, ASCENT `ag09_skill_certifier`, `ag13_cognitive_validator`
**Tokens** : `scy-color-success` certifié, badge or, typographie celebratory, modal confirmation
**Success** : cert generation < 5min, cert unique verifiable
**Edge** : triche detection → auto-fail + flag pour review humaine

---

# SC-050 — HITL ASCENT — Intervention humaine (P-AL, P-KG, P-B2B)

**Persona** : P-AL, P-KG (Knowledge Guardian), P-B2B (coach)
**Trigger** : ASCENT ag16 `hitl_proxy_sme` détecte blocage agentique (ambiguïté, conflit sources, demande utilisateur)
**Écran** : `/ascent/hitl/:requestId`
**Flux** :
1. Notification push : "🛑 Intervention requise — Clarity : [résumé problème]"
2. Page intervention :
   - En-tête : objet blocage + timestamp + contexte DAG
   - Panel gauche : données agents (queries, résultats contradictoires, citations)
   - Panel droite : outils décision utilisateur
3. Types d'intervention :
   - 🔄 Clarifier objectif : "L'agent ne comprend pas 'maîtriser Rust' — quel périmètre exact ?"
   - ⚖️ Résoudre conflit : deux sources disent X/Y différentes → choisir
   - 📝 Valider contenu : agent demande confirmation avant certification
   - 🚦 Changer direction : user reassigne priorité, redirect agent
4. Decision tracking : chaque action enregistrée → audit trail `scy_hitl_decisions`
5. Post-décision : agent reprend automatiquement + feedback user "Décision appliquée"
6. Analytics HITL : taux d'intervention par goal, résolution moyenne, satisfaction
**Spéc source** : ASCENT `ag16_hitl_proxy_sme` spec, `docs/ROUTES.md §3.1`
**Tokens** : `scy-color-alert` bordure, badge HITL, stepper résolution, feedback rapide
**Success** : intervention < 3min, retour auto agent < 10s
**Edge** : timeout 24h → escalation + default decision + notif user

---

*Fin du batch 06 — 8 scénarios (ASCENT Pipeline: roadmap/kanban/mindmap, session APEX, progress dashboard, certification, HITL)*

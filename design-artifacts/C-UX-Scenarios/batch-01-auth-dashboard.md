# WDS-3 SCENARIOS — BATCH 01
_Modules : AUTH / ONBOARDING + DASHBOARD_
_Source : minddoc/ + trigger-map.md (tous personas)_
_Version : 1.0_

---

# SC-001 — Inscription autonome (P-AL)

**Trigger** : L'utilisateur atterrit sur `/` sans compte.
**Persona** : Autonomous Learner (P-AL)
**Business Goal** : BG-01 Onboarding < 2 min
**Écran** : `/auth/register`
**Flux** :
1. Landing → CTA "Commencer gratuitement"
2. Formulaire : email + mot de passe (Zod validate)
3. Envoi code OTP email (backend_ts)
4. Vérification → redirection `/dashboard`
5. Éligibilité Progressive Automation : level=0
**Spec source** : `docs/ROUTES.md` §2.1 `POST /auth/register`
**Design System** : Token `scy-color-primary-500` CTA, `scy-radius-md` inputs
**Success** : compte créé en < 90s, redirect dashboard
**Edge** : email déjà pris → inline error, propose login

---

# SC-002 — Connexion OAuth (Google/GitHub) (P-AL, P-B2B, P-FA, P-KG)

**Trigger** : CTA "Se connecter avec Google/GitHub"
**Persona** : tous (P-AL / P-B2B / P-FA / P-KG)
**Business Goal** : BG-01 Onboarding < 2 min
**Écran** : `/auth/login`
**Flux** :
1. Clic OAuth → redirect provider
2. Callback → backend_ts échange code → JWT access + refresh
3. Si premier login → wizard onboarding 3 étapes (objectif, niveau, format préféré)
4. Sinon → redirect `/dashboard`
**Spec source** : docs mentionnées dans `docs/ROUTES.md`
**Design System** : Boutons OAuth brand colors + `scy-color-neutral-100` hover
**Success** : login en < 5s, onboarding wizard en < 60s
**Edge** : compte OAuth existe sans password → proposelier lien password

---

# SC-003 — Wizard onboarding (P-AL, P-FA)

**Trigger** : Premier login après inscription
**Persona** : P-AL (étudiant), P-FA (analyste)
**Business Goal** : BG-01 + BG-02 Activation < 5 min
**Écran** : `/onboarding`
**Flux** :
1. Slide 1/3 : "Quel est votre objectif ?" → sélection tags (médecine, finance, droit, dev…)
2. Slide 2/3 : "Quel est votre niveau ?" → Débutant / Intermédiaire / Avancé
3. Slide 3/3 : "Quel format préférez-vous ?" → Cartes / Vidéo / Audio / Texte
4. Submit → POST `/api/normal/ingest` auto-démarre avec objectif parsé
5. Progress bar "Préparation de votre première session…"
**Spec source** : `docs/WORKFLOWS.md` + `docs/DATA_MODEL.md` user preferences
**Design System** : Stepper component, `scy-color-primary-500` active step, `scy-color-neutral-300` inactive
**Success** : onboarding complété en < 60s, premier INGEST lancé auto
**Edge** : utilisateur skip → objectif par défaut "Apprendre efficacement"

---

# SC-004 — Récupération compte / Reset password (tous)

**Trigger** : CTA "Mot de passe oublié"
**Persona** : tous (P-AL / P-B2B / P-FA / P-KG)
**Business Goal** : BG-01 support onboarding
**Écran** : `/auth/forgot-password`
**Flux** :
1. Saisie email → POST `/auth/forgot-password`
2. Backend envoie token JWT (1h TTL) par email
3. Clic lien email → `/auth/reset-password?token=xxx`
4. Nouveau mot de passe (Zod : min 8 chars, 1 number, 1 special)
5. Redirect `/auth/login?reset=success`
**Spec source** : `docs/ROUTES.md`
**Design System** : Form states (loading, success, error), `scy-color-danger-500` error
**Success** : reset en < 3 min total
**Edge** : token expiré → message + renvoi possible

---

# SC-005 — Dashboard Home — Vue P-AL (Autonomous Learner)

**Trigger** : Login réussi, redirect `/dashboard`
**Persona** : P-AL
**Business Goal** : BG-03 Rétention boucle quotidienne
**Écran** : `/dashboard`
**Flux** :
1. Header : greeting personnalisé + streak count (jours consécutifs)
2. Hero card : "Votre prochaine révision" → carte APEX due → CTA "Réviser maintenant"
3. Section "En progression" : 3 derniers nodes COSMOS actifs
4. Section "Suggestions" : 3 concepts connexes auto-générés par COSMOS auto_graph
5. Footer : quick actions (Ingester, Discuter avec BRAIN, Voir COSMOS)
6. Bouton "Règle des 2 clics" : chaque action en ≤ 2 clics depuis dashboard
**Spec source** : `docs/WORKFLOWS.md` + `minddoc/s00_design/scy_experience_design.md` § navigation patterns
**Design System** : Cards `scy-radius-lg`, shadow `scy-shadow-card`, grid responsive
**Success** : user comprend en 3s quoi faire ensuite
**Edge** : nouveau user sans données → empty state avec CTA onboarding

---

# SC-006 — Dashboard Home — Vue P-B2B (Créateur entreprise)

**Trigger** : Login réussi B2B user
**Persona** : P-B2B
**Business Goal** : BG-07 Revenue B2B / insights cohortes
**Écran** : `/dashboard`
**Flux** :
1. Header : "Espace Créateur" + MRR indicator + cohort count
2. Hero card : "Cohorts actifs" → clic → B2B Creator Console
3. Section "Performance du contenu" : top 3 modules par taux de complétion (Recharts)
4. Section "Insights fintech" : pour chaque cohorte → taux certification ASCENT
5. Quick actions : "Créer cohorte", "Voir finances", "Exporter rapport"
**Spec source** : `docs/ROUTES.md` §3.3 B2B routes
**Design System** : Theme B2B (couleurs légèrement différentes pour distinguer du mode normal), badges revenue
**Success** : créateur voit son MRR en 2s, navigue en 1 clic vers cohortes
**Edge** : pas de cohorte → empty state + CTA "Créer votre première cohorte"

---

# SC-007 — Dashboard Home — Vue P-FA (Finance Analyst)

**Trigger** : Login réussi, profil "Finance Analyst"
**Persona** : P-FA
**Business Goal** : BG-01 Discover + BG-04 Visualiser PIVOTIQ
**Écran** : `/dashboard`
**Flux** :
1. Header : "Financial Workspace" + alertes marché (si SearxNG connecté)
2. Hero card : "Documents en attente d'analyse" → Ingesta financial core auto
3. Section "PIVOTIQ" : réconciliations multi-sources en cours / complétées
4. Section "Insights" : 3 points clés extraits par BRAIN depuis derniers docs
5. Quick actions : "Ingérer document financier", "Lancer réconciliation", "Exporter rapport"
**Spec source** : `docs/ROUTES.md` §2.2 `POST /ingestion/financial` + PIVOTIQ routes
**Design System** : Couleurs `scy-color-accent-amber` (finance), badges vert/rouge pour P&L
**Success** : analyste voit ses docs traités en 2s, lance PIVOTIQ en 1 clic
**Edge** : pas de docs → empty state + suggestions (10-K, earnings call, Bloomberg)

---

# SC-008 — Dashboard Home — Vue P-KG (Knowledge Guardian)

**Trigger** : Login réussi, profil "Knowledge Guardian"
**Persona** : P-KG
**Business Goal** : BG-04 Visualiser + BG-06 Certifier
**Écran** : `/dashboard`
**Flux** :
1. Header : "Knowledge Base" + health score global (0-100) calculé par HARMONIST
2. Hero card : "Santé du knowledge graph" → COSMOS gap detection → nodes manquants
3. Section "Graphe en croissance" : nb nodes + nb edges + densité (COSMOS trust_system)
4. Section "En attente de certification" : nodes soumis à HARMONIST QA gates
5. Quick actions : "Ingérer source", "Voir COSMOS", "Certifier", "Exporter base"
**Spec source** : `docs/ROUTES.md` + `minddoc/s04_scy_cosmos_visualization_engine/` specs
**Design System** : Health score gauge (d3-loader), couleurs statut (vert/jaune/rouge)
**Success** : gardien voit la santé de sa base en 2s, sait quelle action prioriser
**Edge** : base vide → wizard "Ingérez votre première source"

---

*Fin du batch 01 — 8 scénarios (AUTH + DASHBOARD)*
*Prochain batch : INGEST (8 scénarios) — modules `s01_ingestion_cores/`*

# WDS-3 SCENARIOS — BATCH CYBER BEACHHEAD
_Modules : AUTH / ONBOARDING SOC + PACK LOAD + ARENA + DASHBOARD — Beachhead MVP_

> **Cette version remplace les scenarios génériques de batch-01/02.**
> Les scenarios originaux (Ingest YouTube, Finance, etc.) sont **reportés à Phase 2+**.
> **Source :** SCYFORGE_PIVOT_ARCHITECTURE.md + packs/cyber/ + SCYFORGE_STRATEGIC_MASTERPLAN.md

---

## Personas Cyber-Uniques

| ID | Rôle | Description | Objectif Principal |
|----|------|-------------|-------------------|
| **P-SOC1** | SOC L1 Analyste | Nouvelle recrue blue-team (0-12 mois) | Atteindre autonomie opérationnelle |
| **P-SOC2** | SOC L2 Analyste | Analyste 1-2 ans, maîtrise tactiques de base | Investigations approfondies + threat hunting |
| **P-DFIR** | DFIR / IR Analyste | Spécialiste réponse aux incidents | Investigation forensique + chaine kill |
| **P-SEL** | Security Enablement Lead | Manager qui forme les recrues | Réduire charge senior + prouver readiness |

---

# SC-001 — Inscription SOC L1 avec Organization

**Trigger** : SOC Manager atterrit sur `/` sans compte.
**Persona** : P-SEL (Security Enablement Lead)
**Business Goal** : BG-C01 — Onboarding Manager < 5 min
**Écran** : `/auth/register`
**Flux** :
1. Landing → CTA "Créer mon espace SOC"
2. Formulaire :
   - Nom du SOC / Organisation
   - Email professionnel
   - Mot de passe (Zod : min 8 chars)
   - Nombre de recrues à former (slider : 1-50)
3. Création auto de l'organization (`scy_organizations`)
4. Redirection `/organization/setup` (configurer les rôles avant onboarding)
**Success** : organisation créée en < 2 min, redirect vers setup recrues
**Edge** : email déjà pris → proposer SSO (Phase 2) ou invite direct

**Durée cible** : 90s

---

# SC-002 — Invitation et Création de Recrues

**Trigger** : SEL sur `/organization/setup`
**Persona** : P-SEL
**Business Goal** : BG-C02 — Team setup < 3 min
**Écran** : `/organization/learners`
**Flux** :
1. Formulaire batch : nom + email + rôle SOC pour chaque recrue
   - Rôles disponibles : SOC L1, SOC L2, DFIR, Detection Engineer, Threat Hunter
2. Submit → création comptes + envoi invitations email
3. Liste des recrues avec statuts : "invité" | "en ligne" | "actif"
4. Pour chaque recrue : bouton "Assigner un parcours" (sous-arbre de rôle)
**Success** : 5 recrues créées en < 3 min
**Edge** : email invalide → inline error + skip possible pour création manuelle

**Durée cible** : 3 min

---

# SC-003 — Chargement du Cyber Pack v0.2

**Trigger** : SEL clique "Charger le Cyber Pack" depuis `/organization/settings`
**Persona** : P-SEL
**Business Goal** : BG-C03 — Pack ready < 30s
**Écran** : `/organization/packs`
**Flux** :
1. Affichage du pack disponible : "Cybersécurité — Blue Team / SOC v0.2"
2. Métadonnées affichées :
   - Pivot : MITRE ATT&CK
   - Sources : SigmaHQ (3 136 rules), OTRF, CISA IR, MITRE Emulation
   - Couverture : 14 tactiques, 20 branches, 130 feuilles
3. Clic "Charger ce pack" → POST `/api/packs/load {pack_id: 'cyber'}`
4. Loading : "Chargement de l'ontologie…" → "Construction de l'arbre…" → "Prêt"
5. Confirm : "14 tactiques ATT&CK chargées. 4 profils de rôle configurés."
   - SOC L1 : 6 tactiques core
   - SOC L2 : 10 tactiques
   - DFIR : 14 tactiques
   - Detection Engineer : 12 tactiques
6. Arbre visible immédiatement (COSMOS-lite Mode-Roadmap)
**Success** : pack chargé et visible en < 30s
**Edge** : pack déjà chargé → proposer "Recharger" (perd les progrès)

**Durée cible** : 30s

---

# SC-004 — Aristation Recrue SOC L1 (Onboarding < 5 min)

**Trigger** : Alice (SEL créée) reçoit l'invitation email et clique le lien
**Persona** : P-SOC1
**Business Goal** : BG-C04 — Time-to-First-View < 5 min
**Écran** : `/auth/setup` → `/dashboard`
**Flux** :
1. Email invitation → link → `/auth/setup?token=xxx`
2. Formulaire setup :
   - Mot de passe (obligatoire, sinon SSO)
   - Rôle sélectionné par le manager (pré-rempli : "SOC L1 Analyste")
3. Connect → Dashboard
4. Premier écran : "Votre arbre de maîtrise SOC" — vue COSMOS-lite
   - 6 nœuds troncs ATT&CK (Reconnaissance, Resource Development, Initial Access, Execution, Persistence, Privilege Escalation)
   - Tous unlocked = false, confidence = 0
   - Tooltip : "Choisissez une tactique pour commencer"
5. Clic sur "Reconnaissance" → sous-arbre se déploie (branche Detection, branch Reconnaissance)
6. Notification : "Votre premier scénario est prêt : APT29 — Détection initiale"
7. Clic → ARENA Scenario View
**Success** : de l'invitation à la vue arbre en < 5 min
**Edge** : token expiré → message + "Renvoyer l'invitation"

**Durée cible** : 5 min

---

# SC-005 — ARENA — Premier Scenario APT29 (Step 1/79)

**Trigger** : Alice clique sur le scenario suggéré depuis son dashboard
**Persona** : P-SOC1
**Business Goal** : BG-C05 — First scenario < 2 min
**Écran** : `/arena/scenario/apt29-v1/step/1`
**Flux** :
1. Context panel (gauche) :
   - Title: "APT29 — Détection Initiale"
   - Context: "Vous êtes analyste SOC. EDR alert: LSASS memory dump suspect..."
   - Objectif: Identifier le vecteur d'entrée initial
2. Decision panel (centre) :
   - Stimulus: "L'alerte indique un dump mémoire LSASS non autorisé. Votre première action ?"
   - 3 Options:
     - **A)** Escalader immédiatement à l'incident response
     - **B)** Collecter plus de contexte (timeline EDR, processus enfants, connexions réseau)
     - **C)** Isoler l'hôte immédiatement
   - Timer discret (pas de pression, mais enregistré pour analytics)
3. Alice choisit **B**
4. POST `/api/scenarios/{scenario_id}/react {step_id: 1, choice_id: 'B'}`
5. Feedback panel (droite) :
   ```
   ✅ Bonne analyse
   Points: [Context collection before escalation = critical in SOC L1]
   
   Pourquoi c'est la bonne décision :
   • Un dump LSASS peut être légitime (debug, admin tool)
   • Contexte EDR révèle souvent le vrai vecteur (process hollowing, credential dumping)
   • Escalade prématurée = alert fatigue
   
   Score cette étape: 85/100
   Score global: 85/100
   Progression: 1/79
   ```
6. Auto-avance vers Step 2/79
**Success** : première décision en < 2 min, feedback immédiat
**Edge** : timeout 10min sans réponse → "Besoin d'aide ?" → hint option

**Durée cible** : 2 min par step

---

# SC-006 — Vue Arbre — Progression dans COSMOS-lite

**Trigger** : Alice termine 5 scenarios + voit son arbre se colorer
**Persona** : P-SOC1
**Business Goal** : BG-C06 — SMI visible en temps réel
**Écran** : `/tree`
**Flux** :
1. Affichage Mode-Roadmap (COSMOS-lite) :
   - 14 troncs ATT&CK avec codes couleur :
     - 🟢 Vert (#10B981) = mastered (SMI ≥ 0.70)
     - 🔵 Cyan (#06B6D4) = studying (0 < SMI < 0.70)
     - ⚪ Gris (#6B7280) = locked (prereq non satisfait)
     - 🟠 Or (#D97706) = gap (nœud accessible mais confidence faible)
2. Tooltips hover sur chaque nœud :
   - Nom tactique (ex: "Detection")
   - Confidence: X%
   - Étapes complétées: Y/18
   - Prochain prereq: "Master Execution before unlocking Lateral Movement"
3. Cliquer sur nœud 🔵 (Detection) → panneau détails :
   - Sous-arbre déplié (4 branches : Process Monitoring, Log Analysis, Network, SIEM)
   - Cartes de révision associées (B01-B04)
   - Bouton "Réviser" → lance session APEX (simplifiée)
4. Légende :
   - 🟢 Mastered   🟢 = branch fully mastered
   - 🔵 Studying   🔵 = in progress
   - ⚪ Locked     ⚪ = prerequisite not met
   - 🟠 Gap        🟠 = accessible but weak confidence
**Success** : vue arbre se met à jour en < 200ms après chaque scenario step
**Edge** : > 50 nœuds → lazy load + pagination virtual scroll

**Durée cible** : < 1s render

---

# SC-007 — Dashboard Manager — Readiness Visibility

**Trigger** : Lucy (SEL) ouvre `/dashboard` après 1 semaine d'utilisation
**Persona** : P-SEL
**Business Goal** : BG-C07 — Manager trust + visibility
**Écran** : `/dashboard`
**Flux** :
1. Vue d'ensemble (3 sections) :
   - **Coverage Map** : barre horizontale par recrue
     ```
     Alice (SOC L1)   ████████░░░░░░░░░░░░  42%
     Bob (SOC L2)     ████████████░░░░░░░░  58%
     Charlie (DFIR)   ███████░░░░░░░░░░░░░░  35%
     ```
   - **Gap Map** : liste des nœuds rouges (prereq manqués) avec estimation de temps :
     ```
     Bob — Lateral Movement (prereq: Execution)
       → Bob maîtrise Execution à 45% (besoin ~2h)
       → Recommandation: session APEX sur "Living off the Land"
     ```
   - **Readiness Score** : SMI global par rapport au profil de rôle cible :
     ```
     Équipe SOC L1
     Cible: 100% de 6 tactiques à SMI ≥ 0.70
     Actuel: 2/6 tactiques (33%)
     Projection: autonomie dans ~12 jours au rythme actuel
     ```
2. Bouton "Exporter rapport PDF" → Proof-of-Skill certificate batch
3. Notifications : "Alice a atteint SMI ≥ 0.70 sur Reconnaissance" (temps réel via WebSocket)
**Success** : dashboard complet en < 500ms, export PDF < 3s
**Edge** : org avec 50+ learners → data aggregation + cashing

**Durée cible** : < 500ms

---

# SC-008 — Role-Based Subtree — DFIR Profil

**Trigger** : Lucy assigne Bob = DFIR → voit un arbre différent de SOC L1
**Persona** : P-DFIR (Bob)
**Business Goal** : BG-C08 — Role-appropriate content
**Écran** : `/tree` (après changement de rôle)
**Flux** :
1. GET `/api/roles/{id}/subtree` pour 'dfir'
2. Retour : 14 nœuds au lieu de 6
   - Ajoute : Collection, Command & Control, Exfiltration, Impact
   - Exclut (SOC L1 only) : : Reconnaissance-naissance-naissance
3. Vue COSMOS-lite mise à jour :
   - 14 troncs visibles (vs 6 auparavant)
   - Branch "Investigation" déployée de facto (DFIR-specific)
   - Nouveaux scénarios ARENA : "IR Playbook CISA — Ransomware"
4. Notifications push : "Votre sous-arbre a été mis à jour — 8 nouveaux nœuds"
**Success** : changement de rôle + update arbre en < 2s
**Edge** : learner en cours de scenario → avertir "changement appliqué au prochain scenario"

**Durée cible** : 2s

---

# SC-009 — Mastery Evaluation + Certificat Proof-of-Skill

**Trigger** : Alice finit APT29 scenario avec score = 0e87
**Persona** : P-SOC1 (Alice)
**Business Goal** : BG-C09 — Verifiable certification
**Écran** : `/mastery/certificate`
**Flux** :
1. Résumé affiché :
   ```
   ===== PROOF-OF-SKILL CERTIFICATE =====
   Attesté par: SCYForge (IA + Human Review)
   Candidat: Alice Dupont
   Rôle: SOC L1 Analyste
   Domaine: Cybersécurité — Blue Team

   SMI Global: 0.87 → CERTIFIÉ (≥ 0.70)
   Score APT29: 87/100

   Critères:
   ├── Qualité de décision: 8/10 (poids 40%)
   ├── Vitesse de décision: 7/10 (poids 30%)
   ├── Connaissance procédurale: 9/10 (poids 30%)

   Tactiques maîtrisées: 6/6
   ├── 🟢 Reconnaissance (SMI: 0.92)
   ├── 🟢 Resource Development (SMI: 0.88)
   ├── 🟢 Initial Access (SMI: 0.85)
   ├── 🟢 Execution (SMI: 0.91)
   ├── 🟢 Persistence (SMI: 0.79)
   └── 🟢 Privilege Escalation (SMI:0.88)

   Date: 2026-07-01
   Validé par: SCYForge Engine (hybrid IA+human)
   ```
2. Options de partage :
   - Copier lien (Deep Link)
   - Télécharger PDF (Typst-generated)
   - Partager sur LinkedIn (badge)
3. Lucy (SEL) reçoit notification : "Alice certifiée SOC L1"
**Success** : certificat généré en < 3s (Typst PDF)
**Edge** : score < 0.70 → afficher "Continuez l'entraînement" au lieu de certifier

**Durée cible** : 3s

---

# SC-010 — Gap Detection + Remediation Plan

**Trigger** : Bob (SOC L2) a SMI = 0.55 sur "Lateral Movement" après 3 scenarios
**Persona** : P-SEL (Lucy voit le problème dans le Dashboard)
**Business Goal** : BG-C10 — Targeted remediation
**Écran** : `/dashboard/gaps`
**Flux** :
1. Lucy voit dans Gap Map :
   ```
   🔴 Bob SOC L2 — "Lateral Movement"
      Prereq: "Execution" maîtrisé à 45% (SMI: 0.45 < 0.70)
      → Bob ne peut pas maîtriser Lateral Movement
      → Bottleneck identifié
   ```
2. Clic "Générer plan de remediation" :
   - SCYForge crée un sous-objectif pour Bob
   - Session APEX ciblée sur les 4 concepts du prereq "Execution"
   - 2 scénarios courts (10 steps chacun) pour pratiquer
3. Bob reçoit notification : "Nouvelle session recommandée : Execution Fundamentals"
4. Après session : Edge UE-001 (SC-010-POST) → Lucy voit l'arbre se mettre à jour
**Success** : gap identifié + plan généré en < 5s
**Edge** : si gap sur > 3 nœuds → alerte "Considérer session de rattrapage groupée"

**Durée cible** : 5s

---

# SC-011 — Authentication SSO (Phase 2+)

> **Reporté à Phase 2** — MVP utilise email/password uniquement.
> À implémenter quand un client entreprise demande SAML/OIDC.
> Trigger : Customer requirement.
> Persona : P-SEL
> Spec source : docs/SCYFORGE_COGNITIVE_RUNTIME_POLICIES.md §auth

---

## Enchaînement des Scenarios (User Flow)

```
                    ┌─────────────────┐
                    │   Landing Page  │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
         SOC Manager     Pas de compte    Invité
              │              │              │
              ▼              ▼              ▼
        SC-001 Register  SC-002 Login   SC-015 Guest
              │              │           Demo Mode
              ▼              │              │
        SC-002 Setup        │              │
        Organization         │              │
              │              │              │
              ▼              │              │
        SC-003 Load Pack     │              │
              │              │              │
          ┌───┴────┐         │              │
          │        │         │              │
     SOC L1    SOC L2        │              │
     (Alice)   (Bob)         │              │
          │        │         │              │
          ▼        ▼         │              │
     SC-004 Onboard          │              │
          │        │         │              │
          ▼        ▼         │              │
     ┌──────────┴──────────┐ │              │
     │   COSMOS-lite +     │ │              │
     │   ARENA Scenarios   │ │              │
     └──────────┬──────────┘ │              │
                │            │              │
     ┌──────────┴──────────┐ │              │
     │   Mastery + SMI +   │ │              │
     │   Gap Detection     │ │              │
     └──────────┬──────────┘ │              │
                │            │              │
     ┌──────────┴────────────┴──────────────┴──┐
     │         SC-007 Dashboard Manager          │
     │   Coverage + Gaps + Readiness + Export    │
     └───────────────────────────────────────────┘
```

---

## Matrice Scenarios × Personas × Modules

| ID | Scenario | Personas | Modules Frontend | Endpoints Backend |
|----|----------|---------|-------------------|-------------------|
| SC-001 | Inscription SOC Manager | P-SEL | AUTH, Organization | `/auth/register` |
| SC-002 | Création + Invitation recrues | P-SEL | Organization, Learners | `/api/learners/batch` |
| SC-003 | Chargement Cyber Pack | P-SEL | Packs, COSMOS-lite | `/api/packs/load` |
| SC-004 | Onboarding Recrue SOC L1 | P-SOC1 | Onboarding, Dashboard | `/auth/setup`, `/api/roles/{id}/subtree` |
| SC-005 | ARENA APT29 Step 1 | P-SOC1, P-SOC2, P-DFIR | ARENA Engine | `/api/scenarios/{id}/react` |
| SC-006 | Vue Arbre Progression | P-SOC1, P-SOC2, P-DFIR | COSMOS-lite | `/api/tree/nodes` |
| SC-007 | Dashboard Manager | P-SEL | Dashboard, GapMap, SMI-Radar | `/api/dashboard/team` |
| SC-008 | Role-Based Subtree | P-SOC2, P-DFIR | COSMOS-lite, Onboarding | `/api/roles/{id}/subtree` |
| SC-009 | Mastery Evaluation + Cert | P-SOC1, P-SOC2, P-DFIR | Dashboard, Cert | `/api/mastery/evaluate`, `/api/mastery/certificate` |
| SC-010 | Gap Detection + Remediation | P-SEL, P-SOC2 | Dashboard, GapMap | `/api/dashboard/gaps`, `/api/plans/remediate` |

---

## Edge Cases Spécifiques Beachhead

| ID | Edge | Catégorie | Solution |
|----|------|-----------|----------|
| EDGE-001 | Manager tente charger un 2ème pack avant d'avoir fini le 1er | Gestion conflit | Avertissement + confirmation |
| EDGE-002 | Learner finit scénario APT29 sans avoir fait la préparation (prereq non maîtrisés) | Anti-illusion | Avertissement + suggestion "Commencer par le tutoriel ATT&CK" |
| EDGE-003 | Organization avec 50+ learners → lenteur COSMOS | Performance | Virtual scroll + lazy rendering + Web Worker calcul SMI |
| EDGE-004 | Learner change de rôle en cours de progression | Data integrity | Snapshot avant change, recalcul du sous-arbre, préservation des nodes évalués |
| EDGE-005 | SearxNG sidecar down → scenarios avec contexte web | Degraded mode | Mode offline : pas de contexte web dynamique, scenarios fonctionnent avec données pack only |
| EDGE-006 | Score SMI = 0.70 exact → unlocked ? | Boundary | OUI, ≥ 0.70 déverrouille (pas >). Log arrondi à 2 décimales |
| EDGE-007 | Certificat PDF avec 0 utilisateur | Typst edge | Rendering async + progress indicator |
| EDGE-008 | 3 recrues, même email | Collision | Détection + demande manager de clarifier |
| EDGE-009 | Learner abandonne scenario à step 60/79 | Abandon | Sauvegarde auto toutes les 5 steps. Resume possible. Aucune pénalité SMI |
| EDGE-010 | Role L1 tente accéder à nœud "Privilege Escalation" (locked) | Anti-illusion | Clic bloqué + tooltip "Maîtrisez d'abord 'Execution' (SMI requis: 0.70, votreractuel: 0.45)" |

---

## Tokens Design Référencés (Beachhead)

| Token Catégorie | Valeur | Usage dans scenarios |
|-----------------|--------|---------------------|
| CTA primary | `--scy-color-ai` (#7C3AED) violet | Boutons "Charger pack", "Commencer scenario" |
| Success | `--scy-color-success` (#10B981) vert | Nœuds mastered, certificat validé |
| Info / Studying | `--scy-color-info` (#06B6D4) cyan | Nœuds in-progress, info panels |
| Alert / Gap | `--scy-color-alert` (#D97706) or | Nœuds gap, alertes manager |
| Error | `--scy-color-error` (#EF4444) rouge | Erreurs système uniquement |
| Background | `--scy-bg-main` (#05050A) | Fond dark |
| Card | `--scy-bg-card` (#0D0D15) | Cards dashboard, scenario panels |
| Border | `--scy-border-default` (#374151) | Bordures standard |
| Focus | `--scy-border-focus` (#7C3AED) | Focus inputs |
| Font sans | Inter + system-ui | Tout le texte |
| Font mono | JetBrains Mono | Technique IDs (ATT&CK T1059.001), hex |

---

*Fin du document. Ces 11 scenarios constituent le beachhead MVP.
Tout scenario générique (Ingest YouTube, Finance, etc.) est reporté à Phase 2+.*

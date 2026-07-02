<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Diagrammes séquence onboarding + pack loader.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# Séquence — Onboarding SOC Manager + Chargement du Pack Cyber

**Flux complet** du moment où un SOC Manager démarre SCYForge jusqu'au premier apprentissage autonome d'une recrue.

> **Convention** : Lucy = SOC Manager, Alice = Recrue SOC L1, Bob = Recrue DFIR

---

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

## Diagramme ASCII

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                        SÉQUENCE 1 : Onboarding + Pack Load                    │
└──────────────────────────────────────────────────────────────────────────────┘

  Lucy (SOC Manager)
       │
       │ 1. POST /api/auth/register {email, password, org_name, role: 'sel'}
       ▼
  ┌──────────────┐
  │  Axum Auth   │
  │  Handler     │
  └──────┬───────┘
       │
       │ 2. JWT access + refresh tokens
       │    Organization created (scy_organizations)
       ▼
  ┌──────────────────┐
  │  React Frontend  │
  │  Organization    │
  │  Dashboard       │
  └────────┬─────────┘
           │
           │ 3. Lucy clique "Ajouter une recrue"
           │    POST /api/learners {display_name, email, role: 'soc_l1'}
           ▼
  ┌──────────────┐
  │  scy-shared  │
  │  types.rs:   │
  │  User        │
  └──────┬───────┘
       │
       │ 4. Recrue créée (scy_users, organization_id lié)
       ▼
  ┌──────────────────┐
  │  React Frontend  │
  │  Learner List    │
  │  (3 recrues      │
  │   créées)         │
       │
           │ 5. Lucy clique "Charger le Pack Cyber"
           │    POST /api/packs/load {pack_id: 'cyber', version: '0.2.0'}
           ▼
  ┌──────────────────┐
  │  DomainPack      │
  │  Loader          │
  │                  │
  │  Étapes:        │
  │  a. Valide       │
  │     pack.manifest│
  │  b. Vérifie les  │
  │     9 providers  │
  │  c. Charge       │
  │     cyber_semantic│
  │     _tree.json   │
  │  d. Charge       │
  │     attack_hierarchy│
  │  e. Charge       │
  │     attack_density│
  │  f. Charge       │
  │     apt29_chain  │
  │  g. Calcule      │
  │     role_subtrees│
  │                  │
  │  Résultat:       │
  │  • 14 troncs     │
  │  • 20 branches   │
  │  • 130 feuilles  │
  │  • 153 arêtes    │
  │  • 4 rôles       │
  │  • 3 scenarios   │
  └──────┬──────────┘
         │
         │ 6. Plant 14 troncs ATT&CK dans scy_semantic_trees
         │    Arêtes insérées dans scy_tree_edges
         │    Inserts dans scy_role_subtrees (4 rôles)
         ▼
  ┌──────────────────┐
  │  EventBus        │
  │  TreeOpPlanted   │
  │  {tree_id, roots:│
  │   [14 UUIDs]}    │
  └──────┬──────────┘
         │
         │ 7. Event publié (aucun consommateur direct au MVP,
         │    mais traçabilité log)
         ▼
  ┌──────────────────┐
  │  Reaction:       │
  │  - 14 troncs     │
  │    insérés       │
  │  - Chaque tronc  │
  │    a confidence=0│
  │  - Tous unlocked │
  │    = false        │
  └──────────────────┘


┌──────────────────────────────────────────────────────────────────────────────┐
│                SÉQUENCE 2 : Learner Alice démarre son onboarding             │
└──────────────────────────────────────────────────────────────────────────────┘

                           Lucy (Manager)
                              │
                    ┌─────────┴────────────────┐
                    │                          │
              Alice (SOC L1)                  Bob (DFIR)
                    │                          │
                    │ 8. POST /auth/login {email, password}
                    ▼
              ┌──────────────┐
              │  Axum Auth   │
              └──────┬───────┘
                     │
                     │ 9. JWT access token
                     ▼
              ┌──────────────────┐
              │  React Frontend  │
              │  Onboarding Flow │
              └────────┬─────────┘
                       │
                       │ 10. GET /api/roles/{role_id}/subtree
                       │     (pour 'soc_l1' → 6 tactiques core)
                       ▼
              ┌──────────────┐
              │  Role Projector│
              │              │
              │  FROM scy_role_subtrees WHERE role_id = 'soc_l1'│
              │  → 6 required_node_ids (Reconnaissance,        │
              │    Resource Development, Recon, Discovery,     │
              │    Credential Access, Initial Access)          │
              └──────┬───────┘
                     │
                     │ 11. Sous-arbre retourné
                     ▼
              ┌──────────────────┐
              │  React COSMOS    │
              │  Lite (G6.js)    │
              │                  │
              │  Vue: 6 nœuds    │
              │  - Tous unlocked │
              │  - Confidence=0  │
              │  - Color:        │
              │    info (cyan)  │
              │                  │
              │  Legend:         │
              │  🟢 mastered     │
              │  🔵 studying     │
              │  ⚪ locked       │
              │  🟠 gap          │
              └────────┬─────────┘
                       │
                       │ 12. Alice voit son arbre + notification:
                       │     "APT29 Scenario 1 — Introduction disponible"
                       ▼
              ┌──────────────────┐
              │  React ARENA     │
              │  Engine          │
              │                  │
              │  Charge          │
              │  apt29_chain.json│
              │  Step 1:         │
              │  "Vous recevez   │
              │   une alerte EDR│
              │   ...LSASS       │
              │   dump suspect"  │
              │                  │
              │  3 Options:      │
              │  A) Escalate     │
              │     immediately  │
              │  B) Collect      │
              │   more context  │
              │  C) Isolate host │
              │  →           │
              └────────┬─────────┘
                       │
                       │ 13. Alice choisit B
                       │     POST /api/scenarios/{id}/react {step_id, choice_id: 'B'}
                       ▼
              ┌──────────────┐
              │  ARENA Engine│
              │              │
              │  Scoring:    │
              │  Bon choix   │
              │  Score: 0.85 │
              │  Feedback:   │
              │  "Bonne       │
              │   analyse... │
              │   mais aussi  │
              │   vérifier    │
              │   la timeline │
              │   EDR."      │
              │              │
              │  Next:       │
              │  Step 2/79   │
              └──────┬───────┘
                     │
                     │ 14. EventBus: ScenarioEvaluated
                     │     → MasteryEvaluator calcule SMI
                     ▼
              ┌──────────────┐
              │  Mastery     │
              │  Evaluator   │
              │              │
              │  SMI = confidence avg des nœuds
              │  évalués dans ce scenario
              │  → SMI = 0.42 (après step 1)
              │  → nodes_mastered = 0 / 3
              │  → Gap: "Credential Access" confidence trop basse
              └──────┬───────┘
                     │
                     │ 15. PUT /api/learners/{id}/state {node_id, confidence: 0.42}
                     │     INSERT scy_learner_node_states
                     ▼
              ┌──────────────────┐
              │  COSMOS Lite     │
              │  (re-render)     │
              │                  │
              │  Nœud            │
              │  "Detected        │
              │   Techniques"     │
              │  passe de        │
              │  info → studying │
              │  (cyan →艷)  │
              └──────────────────┘


┌──────────────────────────────────────────────────────────────────────────────┐
│                   SÉQUENCE 3 : Fin de Scenario + Certification              │
└──────────────────────────────────────────────────────────────────────────────┘

                           Alice
                            │
                            │ ... (steps 2-79)
                            │
                            │ POST /api/scenarios/{id}/react (79 fois)
                            ▼
              ┌──────────────┐
              │  ARENA Engine│
              │              │
              │  Scenario     │
              │  completed    │
              │  Score final  │
              │  = 0.87       │
              │  → Threshold  │
              │    0.70 → PASS│
              └──────┬───────┘
                     │
                     │ POST /api/mastery/evaluate
                     │ {tree_id, smi_score: 0.87, format: 'scenario', evaluator: 'ia'}
                     ▼
              ┌──────────────┐
              │  scy_mastery_ │
              │  evaluations  │
              │              │
              │  INSERT       │
              │  rubric_criteria:│
              │  {             │
              │    decision_   │
              │     quality:   │
              │     {score:8,  │
              │      max:10,   │
              │      weight:0.4│
              │    },          │
              │    speed:      │
              │     {score:7,  │
              │      max:10,   │
              │      weight:0.3│
              │    },          │
              │    knowledge:  │
              │     {score:9,  │
              │      max:10,   │
              │      weight:0.3│
              │    }           │
              │  }             │
              └──────┬───────┘
                     │
                     │ EventBus: MasteryEvaluated
                     ▼
              ┌──────────────────┐
              │  Lucy (Manager)  │
              │  Dashboard       │
              │                  │
              │  Coverage:       │
              │  6 tactiques     │
              │  • Reconnaissance│
              │    → mastered (🟢)│
              │  • Resource Dev  │
              │    → studying (🔵)│
              │  • Detection...  │
              │    → studying    │
              │  ...             │
              │                  │
              │  Readiness Score │
              │  = 42% du rôle  │
              │  SOC L1 cible    │
              │                  │
              │  Estimated time  │
              │  to full readiness│
              │  = 18 jours      │
              └──────────────────┘


┌──────────────────────────────────────────────────────────────────────────────┐
│                    SÉQUENCE 4 : Graft (nouvelle menace → arbre)             │
└──────────────────────────────────────────────────────────────────────────────┘

  Lucy (SOC Manager)
       │
       │ "Nouvelle menace CVE-2025-XXXX découverte dans notre infra"
       │ POST /api/tree/graft {tree_id, parent_node_id: '...', node: {title, ...}}
       ▼
  ┌──────────────┐
  │  Graft Op    │
  │              │
  │  Checks:     │
  │  • Parent     │
  │    already    │
  │    mastered?  │
  │    (SMI ≥ 0.70)│
  │  → OUI        │
  │  → Graft OK   │
  │  • New node   │
  │    confidence │
  │    = 0.0      │
  │  • New edge   │
  │    kind='leaf'│
  └──────┬───────┘
       │
       │ EventBus: TreeOpGrafted
       ▼
  ┌──────────────────┐
  │  All learners    │
  │  get notification│
  │  "New node       │
  │   available:     │
  │   CVE-2025-XXXX" │
  └──────────────────┘
```

---

## Flots d'Événements EventBus (Beachhead)

```
Pack Loaded (déclenché une fois au chargement)
  ├── DomainPackRegistered
  └── PackIntegrityChecked

TreeOp Performed (chaque opération sur l'arbre)
  ├── TreeOpPlanted   (14 troncs au chargement)
  ├── TreeOpGrafted   (nouveau nœud ajouté)
  ├── TreeOpPruned    (nœuds morts supprimés)
  ├── TreeOpTested    (évaluation de maîtrise)
  └── TreeOpMyelinated(répétition espacée confirmée)

Scenario Lifecycle
  ├── ScenarioStarted  (Étape 1/79)
  ├── ScenarioReacted  (choix du joueur)
  ├── ScenarioEvaluated(score calculé)
  └── ScenarioCompleted(final score + certificat)

Mastery Flow
  ├── MasteryUpdated   (confidence change)
  ├── MasteryThreshold (nœud passe ≥ 0.70 → unlocked children)
  ├── GapDetected      (prereq manquant → nœud rouge)
  └── CertEarned       (proof-of-skill obtenu)
```

---

## Non-Goals (beachhead — ce qui N'EST PAS dans ces séquences)

| Ce qui manque | Pourquoi | Phase |
|---------------|----------|-------|
| **Chat BRAIN** | Pas de LLM au MVP — BM25 PostgreSQL suffit | Phase 2 |
| **Génération LLM de contenu** | Tout est pré-construit dans le pack | Phase 2 |
| **NEURON-CHAINS** | Scénarios et corpus pré-chargés | Phase 2+ |
| **CHRONICLE (knowledge guardian)** | Pas de multi-tenant KB cumulée | Phase 2+ |
| **IMPRINT (CRE engine)** | Après 100+ nœuds maîtrisés | Phase 3 |
| **FSRS scheduler complet** | SMI suffit au MVP, FSRS 5.0 complet après | Phase 1+ |
| **Webhook entrants** | SOC Manager agit via UI seulement | Phase 2 |

*Fin du document. Ces séquences sont la base des user stories à implémenter.*

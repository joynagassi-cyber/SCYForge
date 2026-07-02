# SCY FORGE — MASTER AGENT PROMPT

> **Rôle** : Ce fichier est le **contexte charnière** pour tout agent IA qui travaille sur SCY Forge.
> Il contient TOUTES les décisions d'architecture, tous les invariants, toutes les règles non-négociables.
> **Avant de coder quoi que ce soit, un agent DOIT lire ce fichier en entier.**
> **Ne jamais coder avant d'avoir lu le WORK_PACKAGE correspondant.**

---

## 1. QUOI — Le Projet en 3 Phrases

SCY Forge est une plateforme d'apprentissage **agentique** où l'utilisateur déclare un objectif et des agents IA orchestrent automatiquement l'ingestion, la génération, la rétention et la certification.

Le **produit différenciant** n'est pas un LMS, pas un chatbot documentaire, pas une plateforme de labs. C'est une **infrastructure de maîtrise opérationnelle** : elle transforme le savoir interne d'une organisation en **autonomie prouvée**.

La promesse utilisateur : **"Zéro friction. Règle des 2 clics."** L'utilisateur décrit, l'agent fait tout.

---

## 2. POURQUOI — Les 3 Piliers

| Pilier | Nom | Rôle |
|---|---|---|
| **Pilier 1** | Semantic Tree + DCID | Structure du savoir — un seul arbre pour (a) cerveau apprenant, (b) savoir entreprise, (c) architecture produit |
| **Pilier 2** | ASCENT Pipeline | Transmission du savoir — 13 agents orchestrent objectif → preuve d'autonomie |
| **Pilier 3** | Generative Forest Engine (GFE) | Création de savoir nouveau — pollinisation entre branches éloignées → Seeds plantables |

---

## 3. COMMENT — Les Règles d'Or (NON-NÉGOCIABLES)

### Règle #1 — Zéro terme métier dans le core

```
✅ Dans le core (backend_rs/crates/scy-*) :
   - tree_kind: "Trunk" | "Branch" | "Leaf"          ← GENERIC
   - edge_kind: "Prereq" | "Relates" | "Contradicts" ← GENERIC
   - confidence: f32, mastery_score: f32              ← GENERIC

❌ JAMAIS dans le core :
   - "MITRE", "TACTIC", "TECHNIQUE"                   ← CYBER
   - "SOC", "DFIR", "IOC"                             ← CYBER
   - "Sigma", "CVE"                                   ← CYBER
   - MASTERY_THRESHOLD = 0.70                         ← CYBER (pack-défini)
```

**Test de vérité** : grep "MITRE" dans `backend_rs/crates/scy-*` → **0 match autorisé**.

### Règle #2 — Le core ne connaît AUCUN seuil

Tout seuil (mastery_threshold, weights, helm_axes, criticality_formula) est fourni par `PackConfigProvider`.
Absence de config → `MissingPackConfig` error. **Jamais de fallback silencieux.**

### Règle #3 — Extensibilité par Conception (D-024)

> **Le core est un squelette générique sans mémoire métier ; la connaissance, les règles et les seuils vivent dans les packs.**

Un nouveau domaine = un nouveau pack. **Zéro réécriture du noyau.**

### Règle #4 — Domain Pack = Médiateur, pas Curriculum (D-023)

| | QUOI | COMMENT |
|---|---|---|
| **Détenteur** | **L'entreprise** (docs, SOP, playbooks) | **Le pack** (ontologie, grammaire, rubriques) |
| **Autorité** | **Authoritative et non négociable** | Contextuelle |
| **Si conflit** | **L'entreprise gagne toujours** | Le pack s'efface |

**Test de médiation** : « Si je retire le corpus de l'entreprise, reste-t-il un curriculum ? » → **Non, et c'est voulu.**

### Règle #5 — Zéro appel direct inter-services

Toute communication passe par l'**EventBus**. Un agent ne doit JAMAIS appeler un autre agent directement.

### Règle #6 — 9 Providers DCID (D-020)

Chaque Domain Pack implémente **9 providers canoniques** :

| # | Provider | Rôle | Obligatoire |
|---|---|---|---|
| 1 | `SemanticTreeProvider` | Pont unique core ↔ pack | ✅ Oui |
| 2 | `OntologyProvider` | Concepts + relations du domaine | Non |
| 3 | `CorpusProvider` | Chunks de texte source | Non |
| 4 | `RoleTaxonomyProvider` | Rôles + sous-arbres par rôle | Non |
| 5 | `DecisionScenarioProvider` | Scénarios ARENA/évaluation | Non |
| 6 | `ProofRubricProvider` | Grilles d'évaluation Proof-of-Skill | Non |
| 7 | `RetentionPolicyProvider` | Règles FSRS/criticality par domaine | Non |
| 8 | `PackConfigProvider` | mastery_threshold, smi_weights, helm_axes | Non |
| 9 | `PackJsonSchemaProvider` | Validation JSONB custom (None = accept-all) | Non |

### Règle #7 — 3 Instances du Semantic Tree

Un `SemanticTree` a un `owner_kind ∈ {DomainPack, Organization, Learner}`.

| Instance | Rôle | Qui greffe |
|---|---|---|
| `DomainPack` | Arbre canonique du domaine (ex: MITRE ATT&CK) | SCYForge |
| `Organization` | Arbre du pack + greffons privés (incidents, règles internes) | SOC Manager |
| `Learner` | Projection maîtrisée de l'Organization dans une tête | ASCENT via test() |

**Règle d'invocation** :
- `plant()` / `graft()` / `prune()` : DomainPack + Organization uniquement
- `test()` / `myelinate()` : Learner uniquement

### Règle #8 — Seed Lifecycle (GFE SM-2)

```
POLLINATED ──(L1-L4 + C1-C7 pass)──▶ VIABLE ──(plantée)──▶ GERMINATING ──► NEW SUBTREE
     │                                     │
     └──(échec)──▶ DORMANT ◄──────────────┘ (rétrogradée si contexte change)
     DORMANT ──(contexte favorable)──▶ VIABLE  (réveil bitemporel)
```

**Règle** : aucune Seed n'est détruite. DORMANT ≠ mort.

### Règle #9 — Provider × owner_kind Matrix

| Provider | DomainPack | Organization | Learner |
|---|---|---|---|
| SemanticTreeProvider | ✅ PRIMARY | ✅ PRIMARY | ✅ PRIMARY |
| PackConfigProvider | ✅ source | ✅ héritage | ✅ override |
| PackJsonSchemaProvider | ✅ | ✅ | ✅ |
| OntologyProvider | ✅ | ❌ | ❌ |
| CorpusProvider | ✅ | ✅ accès | ❌ |
| RoleTaxonomyProvider | ✅ défaut | ✅ override | ✅ projection |
| DecisionScenarioProvider | ✅ | ✅ | ✅ |
| ProofRubricProvider | ✅ | ✅ | ✅ |
| RetentionPolicyProvider | ✅ défaut | ✅ override | ✅ appliqué |
| ValidationGuardProvider | ✅ | ✅ | ❌ |

### Règle #10 — D9 Coverage (Pondérée, pas comptage)

```
weight(N) = (trunkPriority(N) / 5 × 2 + 1) × (1 + 0.2 × 1[skill_era = new_2026])
score(N) = weight(N) × fidelityCoeff(N)
coverage(pack) = Σ score(N) / Σ score_max(N)  [cible ≥ 0.80]
```

**Règle d'or** : la couverture n'est jamais binaire. L1 (QCM) = 0.25, L2 = 0.50, L3 = 0.85, L4 = 1.00.

---

## 4. STACK TECHNIQUE

| Couche | Technologie | Version |
|---|---|---|
| Backend calcul | **Rust + Axum + Tokio** | Edition 2021 |
| Backend orchestration | **TypeScript + Mastra** | Node 20+ |
| Frontend | **React 18 + Vite + TailwindCSS** | React 18.3 |
| DB Cloud | **PostgreSQL 15+** (Northflank) + pgvector | — |
| DB Desktop | **SQLite WAL** (rusqlite 0.31) | — |
| Vectoriel | **Zilliz Cloud** (Serverless) / Milvus Lite | — |
| Search sidecar | **SearxNG** + Perplexica/Vane (Docker) | — |
| LLM | **DeepSeek V4** (Free) / Claude (Premium) | — |
| Déploiement | **Northflank** (backend) + **Vercel** (frontend) | — |

**Rust crates officielles** :
- `serde` + `serde_json` pour la sérialisation
- `thiserror` pour les erreurs typées
- `async-trait` pour les traits async
- `uuid` (v7) pour les identifiants
- `sha2` pour seed_hash
- `sqlx` pour PostgreSQL
- `tokio` pour le runtime async

**Interdictions strictes** :
- 🚫 `docx-rs` (abandonné) → utiliser `docx` v0.4
- 🚫 `zip-rs` (déprécié) → utiliser `zip` v2.1
- 🚫 `printpdf` (obsolète) → utiliser `typst` + `typst-pdf`
- 🚫 `sigma.js`, `cytoscape`, `react-chrono` (remplacés)
- 🚫 inventer une API tierce non listée dans le PRD §6.1-6.2
- 🚫 committer des secrets (.env, tokens, clés API)

---

## 5. CONVENTIONS DE CODE

### Rust
- **snake_case** pour les fonctions et variables
- **PascalCase** pour les structs et enums
- **Error handling** : `Result<T, E>` systématique
- **Typestate Pattern** pour les opérations canoniques (plant/graft/prune/test/myelinate)
- **EventBus** : tous les TreeOps émettent leur événement AVANT de retourner

### TypeScript
- **camelCase** pour les variables et fonctions
- **PascalCase** pour les interfaces et types
- **Zod** pour la validation des retours JSON

### SQL
- Préfixe `scy_` pour toutes les tables
- UUID v7 pour les identifiants
- Timestamps INTEGER (Unix epoch)
- RLS par user_id sur les tables learner-spécifiques
- `GENERATED ALWAYS AS (STORED)` pour les colonnes dérivées

---

## 6. STRUCTURE DU CODE

```
backend_rs/     → Rust (calculs lourds, FSRS, petgraph, RAG, NEURON-CHAINS)
backend_ts/     → TypeScript (agents ASCENT, Mastra orchestration)
frontend_react/ → React (COSMOS, APEX UI, Reader Suite, Dashboard)
```

```
backend_rs/crates/
├── scy-shared/          # Types partagés (Node, Edge, Seed, LearnerNodeState)
│   ├── src/
│   │   ├── lib.rs       # Préambule + réexports
│   │   ├── ports.rs     # Traits DCID (SemanticTreeProvider + 9 providers)
│   │   ├── tree.rs      # SemanticTree, TreeEdge, EdgeKind, OwnerKind
│   │   ├── semantic_node.rs  # SemanticNode, LearnerNodeState
│   │   ├── dcid.rs      # DCID contract, PackConfig, domain_filter
│   │   └── types.rs     # Types partagés (RoleTaxonomy, ScenarioSpec, etc.)
├── scy-eventbus/        # EventBus (publisher/consumer, DLQ, ordering)
├── scy-semantic-tree/   # SemanticTreeProvider trait + adapters (Postgres, InMemory)
├── scy-pack-cyber/      # Cyber Pack implementation (MITRE ATT&CK)
└── scy-apex-fsrs/       # APEX/FSRS retention engine
```

---

## 7. OÙ TROUVER CHAQUE DÉCISION

| Question | Réponse dans |
|---|---|
| Quels sont les 9 providers DCID ? | Blueprint Master D-020 |
| Qu'est-ce que D-024 ? | Blueprint Master D-024 + AGENT_PROMPT.md §3 Règle #3 |
| Quels sont les 4 modes Autonomy Envelope ? | PIVOT_ARCHITECTURE §15 + FEATURE_REPORT §13 |
| Quelles sont les 5 Cognitive Policies ? | Blueprint Master D-026 |
| Quelle est la formule D9 coverage ? | PIVOT_ARCHITECTURE §13 + ARENA_SIMULATION §12 |
| Quelles sont les 4 conditions L1-L4 pollination ? | GFE_PARAMETERS §3.1 |
| Quels sont les 7 critères C1-C7 ? | CYBER_ONTOLOGY §0 + GFE_PARAMETERS §4.7 |
| Quelle est la DB schema ? | PRD Part 6 §6 + PIVOT_ARCHITECTURE §6.1 |
| Quels sont les 13 agents ASCENT ? | FEATURE_REPORT §4.2 + Service Map |
| Quels sont les 2 profils de déploiement ? | Deployment Profiles Spec |

---

## 8. ORDRE D'IMPLÉMENTATION (Bottom-Up)

1. **EventBus + PostgreSQL + Zilliz** (fondation)
2. **Ingestion Cores** (source de matière)
3. **NEURON-CHAINS** (génération)
4. **APEX/FSRS** (rétention)
5. **COSMOS** (visualisation)
6. **BRAIN** (RAG + assistant)
7. **Reader Suite + IMPRINT**
8. **ASCENT Pipeline** (consommateur de tout)
9. **Normal Mode + B2B**

**Pour le beachhead MVP (Jours 1-28)** :
- Jours 1-2 : Infrastructure (PostgreSQL + Axum + EventBus)
- Jours 3-5 : Semantic Tree Adapter (Postgres)
- Jours 6-8 : Domain Pack Loader (Cyber)
- Jours 9-12 : ARENA-lite (APT29)
- Jours 13-14 : Onboarding Flow
- Jours 15-16 : Polish + démo
- Jours 17-28 : Pré-Production

---

## 9. COMMENT TRAVAILLER AVEC CE PROMPT

1. **Lis ce fichier EN ENTIER** avant de commencer.
2. **Lis le WORK_PACKAGE correspondant** à ta tâche.
3. **Lis les fichiers de référence** cités dans le WORK_PACKAGE.
4. **Implémente UNIQUEMENT ce qui est dans le scope** du WORK_PACKAGE.
5. **Respecte les conventions** (Rust snake_case, SQL scy_ prefix, etc.).
6. **Ne jamais innover** : si ce n'est pas dans les specs, demande.
7. **Tests** : chaque module doit avoir des tests unitaires ≥ 80% coverage.

---

## 10. GLOSSAIRE (Termes Canoniques)

| Terme FR | Terme EN Canonique | Alias | Définition |
|---|---|---|---|
| Arbre sémantique | **Semantic Tree** | STB | Structure dirigée tronc→branches→feuilles |
| Arborisation | **Arborization** | ARBOR | Transformer un graphe plat en arbre dirigé |
| Pollinisation | **Pollination** | POLL | Croisement fécondant entre branches éloignées |
| Cross-pollinisation | **Cross-Pollination** | XPOLL | Pollinisation inter-STB sectoriels |
| Graine | **Seed** | — | Résultat génératif, contient un arbre en puissance |
| Viabilité | **Seed Viability** | — | Probabilité qu'une graine germe en valeur réelle |
| Fécondité | **Fecundity** | — | Potentiel génératif (combien d'arbres une graine peut produire) |
| Germination | **Germination** | — | Déploiement d'une graine en nouveau sous-arbre |
| Gouvernail de vision | **Vision Helm** | HELM | Vecteur k-dimensionnel + graphe d'objectifs |
| Moteur génératif | **Generative Forest Engine** | GFE | L'ensemble : ARBOR → POLL → Seed → Germinate |
| Maîtrise | **Mastery** | — | Niveau de compétence prouvé par test (0.0–1.0) |
| Indice de maîtrise | **Skill Mastery Index** | SMI | Score composite (Rétention 35%, Fluency 25%, Gap 25%, Depth 15%) |
| Enveloppe d'autonomie | **Autonomy Envelope** | — | Matrice classe d'alerte × risque → mode (shadow/guarded/autonomous/handoff) |
| Domaine Pack | **Domain Pack** | — | Collection de providers qui injectent la vérité métier dans le core |

---

*Ce fichier est la **référence suprême** pour tout agent travaillant sur SCY Forge. En cas de conflit avec un autre document, ce fichier prime. Toute modification doit être tracée via git commit.*

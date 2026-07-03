# SCY Forge — WDS-3 STRATEGIC CONTEXT
_Étape 03 — Build Strategic Context_
_Source de vérité : `minddoc/` + `design-artifacts/A-Product-Brief/` + `design-artifacts/B-Trigger-Map/`_
_Version : 1.0 — Gelé après approbation_

---

## 1. Résumé exécutif

**SCY Forge** (Synapse Cognitive Yield Forge) est une plateforme d'apprentissage **agentique** où l'utilisateur déclare un objectif et 18 agents IA orchestrent automatiquement l'ingestion, la génération, la rétention et la certification des connaissances.

**Principe fondamental** : l'utilisateur décrit, l'agent fait tout. Zéro friction. Règle des 2 clics.

---

## 2. Personas

> Dérivées de `design-artifacts/B-Trigger-Map/trigger-map.md` § 4.1

| Persona | ID | Description | Objectif principal | Frustration #1 |
|---------|-----|-------------|-------------------|----------------|
| **Autonomous Learner** | P-AL | Étudiant / autodidacte qui veut maîtriser un sujet complexe rapidement | Apprendre efficacement sans effort d'organisation | La charge mentale de organiser soi-même son programme |
| **B2B Creator** | P-B2B | Créateur de contenu éducatif / formateur d'entreprise | Produire du contenu certifié à grande échelle | La difficulté de maintenir la qualité pédagogique |
| **Finance Analyst** | P-FA | Analyste financier / décisionnaire business | Analyser rapidement des documents financiers complexes | Le temps perdu à naviguer entre sources hétérogènes |
| **Knowledge Guardian** | P-KG | Knowledge Manager / Bibliothécaire numérique | Structurer et pérenniser un knowledge base corporatif | La dégradation silencieuse de la qualité des connaissances |

---

## 3. Objectifs stratégiques

### 3.1 North Star Metric

> **Knowledge Yield** = (Concepts maîtrisés certifiés × Niveau de rétention 30j) / Temps utilisateur investi

### 3.2 Objectifs business par tier

| Tier | Objectif | KPI cible | Module(s) principal(aux) |
|------|----------|-----------|---------------------------|
| **Tier 1 (Acquisition)** | Onboarding < 2 min | Taux d'inscription complété ≥ 85% | AUTH, DASHBOARD |
| **Tier 2 (Activation)** | 1ère session APEX en < 5 min | Time-to-first-card ≤ 5 min | INGEST, NEURON-CHAINS, APEX |
| **Tier 3 (Rétention)** | Boucle d'apprentissage quotidienne | DAU/MAU ≥ 40% | APEX, COSMOS, ASCENT |
| **Tier 4 (Expansion)** | Découverte naturelle des 26 modes COSMOS | ≥ 3 modes utilisés/semaine | COSMOS |
| **Tier 5 (Revenue B2B)** | Convertisison créateur payant | MRR ≥ $50K à M6 | B2B CREATOR CONSOLE, FINANCE SUITE |

### 3.3 Objectifs UX

| Objectif | Cible | Mesure |
|----------|-------|--------|
| Règle des 2 clics | 100% des actions core | Audit manuel |
| Cohérence design system | 100% composants conformes | WDS-7 audit |
| Performance front | LCP < 2s, FID < 100ms | Web Vitals |
| Accessibilité | WCAG 2.1 AA | axe DevTools |

---

## 4. Cartographie fonctionnelle (15 modules)

> Vue synthèse. Pour les specs détaillées → `minddoc/project_structure.md`

```
SCY FORGE — ARCHITECTURE MODULAIRE
═══════════════════════════════════════

                    ┌──────────────────┐
                    │   UTILISATEUR    │
                    └────────┬─────────┘
                             │ objectif
                    ┌────────▼─────────┐
                    │  DASHBOARD / UX  │  ← Frontend React
                    └────────┬─────────┘
                             │
          ┌──────────────────┼──────────────────┐
          │                  │                   │
    ┌─────▼─────┐   ┌──────▼──────┐   ┌───────▼──────┐
    │  ASCENT   │   │ NORMAL MODE │   │  B2B CONSOLE │  ← backend_ts (Mastra)
    │  24 agents│   │  Orches.    │   │  Dashboard   │
    └─────┬─────┘   └─────────────┘   └──────────────┘
          │
    ┌─────┴──────────────────────────────────────┐
    │               EventBus (scy-eventbus)      │
    └─────┬──────────────────────────────────────┘
          │
    ┌─────┴──────────────────────────────────────────────────────┐
    │                    backend_rs (Rust)                        │
    │                                                             │
    │  ┌─────────────┐  ┌──────────────┐  ┌─────────────────┐  │
    │  │   INGEST    │  │ NEURON-CHAINS│  │     APEX/FSRS   │  │
    │  │  13 cores   │→ │  7 chaînes   │→ │  rétention      │  │
    │  └─────────────┘  └──────────────┘  └─────────────────┘  │
    │         │                │                    │           │
    │         ▼                ▼                    ▼           │
    │  ┌─────────────┐  ┌──────────────┐  ┌─────────────────┐  │
    │  │   COSMOS    │  │    BRAIN     │  │    IMPRINT      │  │
    │  │  26 modes   │  │  RAG + AI    │  │  cognitive      │  │
    │  └─────────────┘  └──────────────┘  └─────────────────┘  │
    │                                                     │    │
    │  ┌─────────────┐  ┌──────────────┐                    │    │
    │  │ READER SUITE│  │ CHRONICLE    │                    │    │
    │  │  formats    │  │  chat+push   │                    │    │
    │  └─────────────┘  └──────────────┘                    │    │
    │                                                       │    │
    │  ┌─────────────────────────────────────────────────────┘  │
    │  │              HARMONIST (QA Gates)                       │
    │  └───────────────────────────────────────────────────────┘
    │                                                             │
    │  ┌────────────────┐  ┌────────────────┐  ┌─────────────┐  │
    │  │ PIVOTIQ        │  │ FINANCE SUITE  │  │ NEURO SCI   │  │
    │  │ Reconciliation │  │ Financial docs │  │ Engram+RIF   │  │
    │  └────────────────┘  └────────────────┘  └─────────────┘  │
    └─────────────────────────────────────────────────────────────┘
          │           │              │
    ┌─────▼───┐ ┌─────▼─────┐ ┌─────▼──────┐
    │PostgreSQL│ │ pgvector  │ │ Zilliz/Milv │ ← Bases de données
    └──────────┘ └───────────┘ └─────────────┘
          │           │           │
    ┌─────▼───┐ ┌─────▼─────┐ ┌─────▼──────┐
    │SearxNG  │ │Perplexica │ │ AI LLMs    │ ← Sidecars / API
    └──────────┘ └───────────┘ └─────────────┘
```

---

## 5. Story mapping par persona × objectif business

> Clé de lecture : chaque intersection [Persona × Business Goal × Module] génère 1 à N scénarios WDS-3.

### 5.1 Autonomous Learner (P-AL) — Objectif : maîtriser un sujet

| Business Goal | Module | Scénarios WDS-3 estimés |
|---------------|--------|-------------------------|
| BG-01 : Discover | DASHBOARD, INGEST | 4 |
| BG-02 : Générer | NEURON-CHAINS, READER | 6 |
| BG-03 : Réviser | APEX, FSRS | 5 |
| BG-04 : Visualiser | COSMOS | 4 |
| BG-05 : Dialoguer | BRAIN | 3 |
| BG-06 : Certifier | ASCENT, HARMONIST | 4 |
| BG-07 : Revoir | CHRONICLE, IMPRINT | 2 |
| **Total P-AL** | | **28** |

### 5.2 B2B Creator (P-B2B) — Objectif : produire du contenu certifié

| Business Goal | Module | Scénarios WDS-3 estimés |
|---------------|--------|-------------------------|
| BG-07 : Admin | B2B CREATOR CONSOLE, FINANCE SUITE | 6 |
| BG-01 : Discover | INGEST, DASHBOARD | 3 |
| BG-02 : Générer | NEURON-CHAINS | 4 |
| BG-06 : Certifier | ASCENT, HARMONIST | 4 |
| BG-04 : Visualiser | COSMOS, ARENA | 3 |
| BG-07 : Revoir | CHRONICLE | 2 |
| **Total P-B2B** | | **22** |

### 5.3 Finance Analyst (P-FA) — Objectif : analyser des docs financiers

| Business Goal | Module | Scénarios WDS-3 estimés |
|---------------|--------|-------------------------|
| BG-01 : Discover | INGEST (financial core), DASHBOARD | 3 |
| BG-02 : Générer | NEURON-CHAINS, BRAIN | 5 |
| BG-03 : Réviser | APEX | 3 |
| BG-04 : Visualiser | COSMOS, PIVOTIQ | 4 |
| BG-06 : Certifier | ASCENT | 3 |
| **Total P-FA** | | **18** |

### 5.4 Knowledge Guardian (P-KG) — Objectif : structurer un knowledge base

| Business Goal | Module | Scénarios WDS-3 estimés |
|---------------|--------|-------------------------|
| BG-01 : Discover | INGEST (tous cores), DASHBOARD | 5 |
| BG-04 : Visualiser | COSMOS (tous lentilles), DAG | 4 |
| BG-06 : Certifier | HARMONIST, NEUROSCIENCE ENGINE | 4 |
| BG-07 : Revoir | IMPRINT, CHRONICLE | 3 |
| BG-02 : Générer | NEURON-CHAINS, READER | 3 |
| **Total P-KG** | | **19** |

### 5.5 Récapitulatif global

| # | Persona | Scénarios estimés |
|---|---------|-------------------|
| 1 | Autonomous Learner | 28 |
| 2 | B2B Creator | 22 |
| 3 | Finance Analyst | 18 |
| 4 | Knowledge Guardian | 19 |
| | **Total** | **87** |

> **Note** : Le total de 87 scénarios est cohérent avec l'inventaire initial de ~96 vues. Les écarts s'expliquent par les vues système (auth, settings, onboarding) non liées à un persona spécifique.

---

## 6. Feature-to-scenario coverage matrix

> Légende : 🟢 Core — 🟡 Secondary — 🔴 Edge

| Module | P-AL | P-B2B | P-FA | P-KG | Total scénarios |
|--------|:----:|:-----:|:----:|:----:|:---------------:|
| **AUTH / ONBOARDING** | 🟢 | 🟢 | 🟢 | 🟢 | 4 |
| **DASHBOARD** | 🟢 | 🟡 | 🟡 | 🟢 | 4 |
| **INGEST** (13 cores incl. financial) | 🟢 | 🟢 | 🟢 | 🟢 | 8 |
| **NEURON-CHAINS** | 🟢 | 🟡 | 🟡 | 🟡 | 6 |
| **APEX / FSRS** (retention science) | 🟢 | 🔴 | 🟡 | 🔴 | 5 |
| **COSMOS** (26 modes) | 🟢 | 🟡 | 🟢 | 🟢 | 8 |
| **BRAIN** (RAG + Professor AI) | 🟢 | 🟡 | 🟢 | 🟡 | 4 |
| **READER SUITE** | 🟢 | 🟡 | 🟡 | 🟡 | 4 |
| **IMPRINT** | 🟡 | 🔴 | 🔴 | 🟡 | 3 |
| **CHRONICLE** | 🟡 | 🟡 | 🔴 | 🟢 | 3 |
| **ASCENT** (18 agents pipeline) | 🟢 | 🟢 | 🟢 | 🟢 | 5 |
| **HARMONIST** (QA gates) | 🟡 | 🟡 | 🟡 | 🟢 | 4 |
| **DAG** | 🟡 | 🟡 | 🟡 | 🟢 | 3 |
| **ARENA** | 🟡 | 🟡 | 🔴 | 🔴 | 2 |
| **NORMAL MODE** | 🟢 | 🔴 | 🔴 | 🟡 | 2 |
| **B2B CREATOR CONSOLE** | 🔴 | 🟢 | 🔴 | 🔴 | 4 |
| **FINANCE SUITE** | 🔴 | 🟡 | 🟢 | 🔴 | 4 |
| **PIVOTIQ** | 🔴 | 🔴 | 🟢 | 🟡 | 3 |
| **NEUROSCIENCE ENGINE** | 🔴 | 🔴 | 🔴 | 🟡 | 2 |
| **SETTINGS** (auto + profile) | 🟢 | 🟢 | 🟢 | 🟢 | 3 |
| | | | | | |
| **TOTAL** | | | | | **87** |

---

## 7. Choix stratégiques (roadmap context)

### 7.1 Décisions structurantes déjà prises

| # | Décision | Contexte | Impact design |
|---|----------|----------|---------------|
| D-01 | **Brownfield docs-driven** | 590+ specs existantes dans `minddoc/` | Tous les scénarios doivent référencer la spec source |
| D-02 | **Nango comme Integration Hub** | Remplacement de Composio (voir commit `bed8a90`) | Les flows d'ingestion passent par Nango |
| D-03 | **NotebookLM exclu** | Décision de pivot stratégique | Aucune intégration NotebookLM dans les scénarios |
| D-04 | **DeepSeek V4 free / Claude premium** | Freemium LLM strategy | UI de sélection LLM dans les paramètres + dans les sessions |
| D-05 | **Architecture hexagonale D-001** | Standards d'architecture | Composants frontend = presentation adapters uniquement |
| D-06 | **EventBus obligatoire** | Zéro appel inter-services direct | Pattern pub/sub dans tous les scénarios async |
| D-07 | **WDS-7 après WDS-3** | Ordonnancement officiel | Design system tokens disponibles avant implémentation |

### 7.2 Choix à confirmer / à venir

| # | Choix | Options | Recommandation |
|---|-------|---------|----------------|
| C-01 | Moteur de graphe COSMOS côté front | G6 (léger) vs Cosmograph (massif) | Hybride : G6 pour modes légers, Cosmograph pour M00/M22 |
| C-02 | État global frontend | Zustand vs Jotai vs Redux | Zustand (déjà dans la stack) |
| C-03 | Navigation principale | Sidebar fixe vs Bottom tabs mobile | Sidebar desktop + Bottom tabs mobile (responsive) |
| C-04 | Modale vs Page split | Pour Reader + Brain | Reader : page split ; Brain : modale overlay |
| C-05 | Édition schema BDD | UUID v7 vs UUID v4 | **UUID v7** (obligatoire par spec) |

---

## 8. Roadmap stratégique WDS

```
WDS — ROADMAP GLOBALE
═══════════════════════════════════════════════════════════

 Phase            WDS Skill          Deliverable                     Statut
 ─────────────────────────────────────────────────────────────
 [TERMINÉ]    WDS-1 Project Brief  product-brief.md                ✅
 [TERMINÉ]    WDS-2 Trigger Map    trigger-map.md                  ✅
 [EN COURS]   WDS-3 Scenarios      Ce document + 87 scénarios       🔄
 [À VENIR]    WDS-4 UX Design      87 scenarios_ux.md par feuille   ⏳
 [À VENIR]    WDS-5 Copywriting    87 scenarios_copy.md            ⏳
 [À VENIR]    WDS-6 Assets         87 scenarios_assets.md           ⏳
 [À VENIR]    WDS-7 Design System  tokens.tsx + primitives.tsx     ⏳
 [À VENIR]    WDS-8 Evolution      roadmap.md + hypotheses.md       ⏳
```

---

## 9. Gouvernance et règles d'or

> Appliquer à tous les livrables WDS.

1. **Français uniquement** dans les specs, commentaires, et copywriting.
2. **Zéro appel LLM payant** pour une opération marquée `$0` (Rust pur).
3. **Zéro composant React** sans token design conforme.
4. **Zéro scénario** sans référencement vers `minddoc/` source.
5. **Zéro route métier** sans validation Zod/Serde.
6. **Zéro modification** du dossier `minddoc/s00_prd/` (source de vérité).
7. **UUID v7** et timestamps INTEGER (Unix) obligatoires en base.

---

## 10. Références

| Document | Chemin |
|----------|--------|
| Product Brief | `design-artifacts/A-Product-Brief/product-brief.md` |
| Trigger Map | `design-artifacts/B-Trigger-Map/trigger-map.md` |
| Architecture | `docs/ARCHITECTURE.md` |
| Data Model | `docs/DATA_MODEL.md` |
| Routes & APIs | `docs/ROUTES.md` |
| Workflows | `docs/WORKFLOWS.md` |
| Project Structure | `minddoc/project_structure.md` |
| Design System | `minddoc/s00_design/scy_design_system.md` |
| Experience Design | `minddoc/s00_design/scy_experience_design.md` |
| Build Commands | `minddoc/build_commands.md` |
| Implementation Order | `minddoc/implementation_order.md` |
| Code Style | `minddoc/code_style.md` |
| CRATES standards | `minddoc/s00_architecture_standards/crates_standards/scy_crates_standards_spec.md` |

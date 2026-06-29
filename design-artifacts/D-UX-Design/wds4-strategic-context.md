# SCY Forge — WDS-4 STRATEGIC CONTEXT
_Étape 04 — Build Strategic Context (UX Design)_
_Source de vérité : `design-artifacts/C-UX-Scenarios/` + `minddoc/`_
_Version : 1.0 — À venir_

---

## 1. Résumé exécutif

**WDS-4** (UX Design) complète et enrichit les 87 scénarios WDS-3 en y ajoutant :
- Spécifications UX détaillées (layout, information architecture)
- Wireframes textuels (ASCII)
- Flows d'interaction et séquences
- Spécifications de composants UI par scénario
- Considérations d'accessibilité (WCAG 2.1 AA)

Chaque scénario WDS-3 devient un **fichier `scenarios_ux.md`** avec une section UX dédiée.

---

## 2. Objectifs WDS-4

### 2.1 Objectifs principaux

| # | Objectif | Cible | Métrique |
|---|----------|-------|----------|
| UX-01 | Couverture UX complète des 87 scénarios | 87/87 | % de scénarios avec spécifications UX |
| UX-02 | Consistance avec le design system (WDS-7) | 100% | Audit manuel + tooling |
| UX-03 | Accessibilité WCAG 2.1 AA | 100% | axe DevTools + axe-core |
| UX-04 | Règle des 2 clics respectée | 100% | Audit manuel + tests automatisés |
| UX-05 | Performance UX (LCP, FID) | LCP < 2s, FID < 100ms | Web Vitals |

### 2.2 Objectifs par persona

| Persona | Objectif UX | Cible |
|---------|-------------|-------|
| **P-AL** (Autonomous Learner) | Onboarding frictionless | 0 clics morts, < 1 min pour 1ère session |
| **P-B2B** (B2B Creator) | Dashboard intuitif pour admins | 100% des actions admin dans 2 clics |
| **P-FA** (Finance Analyst) | Tableaux financiers clairs | 100% des données financières visibles sans scroll excessif |
| **P-KG** (Knowledge Guardian) | Navigation intuitive dans COSMOS | 100% des modes accessibles en 1 clic |

---

## 3. Périmètre UX Design

### 3.1 Modules couverts

| Module | Scénarios WDS-3 | Portée UX Design |
|--------|-----------------|------------------|
| **AUTH / ONBOARDING** | 4 | Layout auth, flows d'inscription, onboarding wizard |
| **DASHBOARD** | 4 | Layout principal, widgets, navigation globale |
| **INGEST** (13 cores) | 8 | UI ingestion par core, upload, configuration |
| **NEURON-CHAINS** | 6 | UI génération de chaînes, configuration, preview |
| **APEX / FSRS** | 5 | UI flashcards, scheduling, progress |
| **COSMOS** (26 modes) | 8 | UI navigation modes, visualisation graphique |
| **BRAIN** (RAG + Professor AI) | 4 | UI chat, configuration RAG, preview |
| **READER SUITE** | 4 | UI reader, formats, annotations |
| **IMPRINT** | 3 | UI imprint, cognitive profiling |
| **CHRONICLE** | 3 | UI chat, push notifications, history |
| **ASCENT** (18 agents) | 5 | UI pipeline, status agents, logs |
| **HARMONIST** (QA Gates) | 4 | UI gates, validation, feedback |
| **DAG** | 3 | UI graphe, navigation, édition |
| **ARENA** | 2 | UI compétition, leaderboard |
| **NORMAL MODE** | 2 | UI orchestration, timeline |
| **B2B CREATOR CONSOLE** | 4 | UI admin, billing, team management |
| **FINANCE SUITE** | 4 | UI tableaux financiers, KPIs, reconciliation |
| **PIVOTIQ** | 3 | UI reconciliation, alerts |
| **NEUROSCIENCE ENGINE** | 2 | UI engram + RIF |
| **SETTINGS** (auto + profile) | 3 | UI settings, profile, preferences |
| **TOTAL** | **87** | **87 scénarios UX documentés** |

### 3.2 Frontend stack UX

| Couche | Tech | Version | Rôle UX |
|--------|------|---------|---------|
| **Framework** | React 18.3.1 | — | Composants UI |
| **State** | Zustand 4.5 | — | Gestion d'état global |
| **Routing** | React Router 6.x | — | Navigation |
| **Styling** | TailwindCSS 3.4.4 | — | Design system tokens |
| **Design System** | WDS-7 (tokens) | — | Composants primaires |
| **Graph** | G6 (léger) / Cosmograph | — | Visualisations COSMOS |
| **Charts** | Recharts / Chart.js | — | Tableaux financiers |
| **Icons** | Lucide React | — | Icônes système |
| **Icons** | Heroicons | — | Icônes métier |

---

## 4. Architecture UX

### 4.1 Layout principal (Dashboard)

```
┌─────────────────────────────────────────────────────────────────┐
│ HEADER (Logo + User Menu + Search + Notifications)              │
├──────────┬──────────────────────────────────────────────────────┤
│          │                                                      │
│ SIDEBAR  │  MAIN CONTENT AREA                                    │
│ (Navigation)│  ┌──────────────────────────────────────────────┐  │
│          │  │  TOP BAR (Breadcrumbs + Actions + Filters)    │  │
│ ┌────────┤  ├──────────────────────────────────────────────┤  │
│ │ INGEST │  │  CONTENT AREA                                  │  │
│ ├────────┤  │  ┌─────────────┐  ┌─────────────────────┐    │  │
│ │ COSMOS │  │  │  Widget 1  │  │  Widget 2           │    │  │
│ ├────────┤  │  └─────────────┘  └─────────────────────┘    │  │
│ │ APEX  │  │  ┌──────────────────────────────────────┐    │  │
│ ├────────┤  │  │  Main View (scénario spécifique)      │    │  │
│ │ BRAIN │  │  └──────────────────────────────────────┘    │  │
│ ├────────┤  │                                              │  │
│ │ ASCENT │  │  FOOTER (Status + Links)                    │  │
│ ├────────┤  └──────────────────────────────────────────────┘  │
│ │ CHRONICLE│                                              │  │
│ ├────────┤  MOBILE: Bottom Tabs Navigation                  │  │
│ │ SETTINGS│                                              │  │
│ └────────┘                                              │  │
│          │                                              │  │
└──────────┴──────────────────────────────────────────────────────┘
```

### 4.2 Modèles de composants UI

| Composant | Usage | Token de base | Accessibilité |
|-----------|-------|---------------|---------------|
| **Button** | Actions primaires | `scy-btn-primary` | `aria-label`, `focus-visible` |
| **Card** | Conteneur de contenu | `scy-card` | `role="article"`, `aria-labelledby` |
| **Input** | Données utilisateur | `scy-input` | `label`, `aria-describedby` |
| **Modal** | Contenu secondaire | `scy-modal` | `aria-modal="true"`, `role="dialog"` |
| **Sidebar** | Navigation | `scy-sidebar` | `role="navigation"`, `aria-label` |
| **Tabs** | Navigation sectionnée | `scy-tabs` | `role="tablist"`, `aria-selected` |
| **Toast** | Feedback | `scy-toast` | `role="alert"`, `aria-live` |
| **Dropdown** | Menu | `scy-dropdown` | `aria-expanded`, `aria-controls` |
| **Badge** | Labels | `scy-badge` | `aria-label` |
| **Progress** | Progression | `scy-progress` | `aria-valuenow`, `aria-valuemin` |

---

## 5. Règles UX fondamentales

### 5.1 Règle des 2 clics

> **Toute action utilisateur (core ou non) doit être accessible en 2 clics max depuis le Dashboard.**

Exemples :
- **Auth** : Login → Dashboard (1 clic)
- **Ingest** : Dashboard → Select Core → Upload (2 clics)
- **APEX** : Dashboard → APEX → Start Session (2 clics)
- **BRAIN** : Dashboard → BRAIN → New Chat (2 clics)

### 5.2 Dark-first par défaut

> Toutes les interfaces sont **dark-first** par défaut. Le mode clair est une option secondaire.

### 5.3 Contraste et lisibilité

- **Contraste minimum** : WCAG 2.1 AA (4.5:1 pour texte, 3:1 pour UI)
- **Taille de police** : minimum 16px (14px pour labels)
- **Line-height** : 1.5 pour texte long, 1.25 pour UI
- **Line-limit** : 72 caractères par ligne (max 80)

### 5.4 Feedback utilisateur

| Type | Composant | Timing | Message |
|------|-----------|--------|---------|
| **Success** | Toast | < 3s | "Action réussie" |
| **Error** | Toast + Modal | < 5s | "Erreur : [message]" |
| **Loading** | Spinner + Skeleton | < 2s | "Chargement..." |
| **Info** | Toast | < 5s | "Informations" |

### 5.5 Accessibilité

| Critère | Niveau | Règle |
|---------|--------|-------|
| **Contraste** | AA | WCAG 2.1 AA (4.5:1) |
| **Clavier** | AA | Navigation complète au clavier |
| **Focus visible** | AA | Focus outline visible (token `scy-focus-visible`) |
| **Screen reader** | AA | `aria-label`, `aria-describedby`, `role` appropriés |
| **Semantic HTML** | AA | Utilisation correcte de balises sémantiques |
| **Motion** | AA | Animations réduites optionnelles |

---

## 6. Roadmap WDS-4

```
WDS-4 — ROADMAP UX DESIGN
═══════════════════════════════════════════════════════════

 Phase            WDS Skill          Deliverable                     Statut
 ─────────────────────────────────────────────────────────────
 [TERMINÉ]    WDS-3 Scenarios      87 scénarios outlines            ✅
 [EN COURS]   WDS-4 UX Design      wds4-strategic-context + 87 UX    🔄
 [À VENIR]    WDS-5 Copywriting    87 scenarios_copy.md             ⏳
 [À VENIR]    WDS-6 Assets         87 scenarios_assets.md           ⏳
 [À VENIR]    WDS-7 Design System  tokens + primitives (déjà fait)   ✅
```

---

## 7. Gouvernance et règles d'or WDS-4

> Appliquer à tous les livrables WDS-4.

1. **UX = Design + Interaction + Accessibilité** (pas juste UI visuelle)
2. **Chaque scénario WDS-3 → fichier `scenarios_ux.md` avec section UX dédiée**
3. **Zéro scénario sans wireframe textuel (ASCII)**
4. **Zéro composant UI sans token design conforme (WDS-7)**
5. **Zéro scénario sans considérations d'accessibilité**
6. **Zéro scénario sans référence à la spec source (`minddoc/`)**
7. **Consistance stricte avec le design system (dark-first, tokens)**
8. **Règle des 2 clics respectée dans tous les flows**

---

## 8. Références UX

| Document | Chemin |
|----------|--------|
| WDS-3 Strategic Context | `design-artifacts/C-UX-Scenarios/wds3-strategic-context.md` |
| Design System | `minddoc/s00_design/scy_design_system.md` |
| Experience Design | `minddoc/s00_design/scy_experience_design.md` |
| Architecture | `docs/ARCHITECTURE.md` |
| Routes & APIs | `docs/ROUTES.md` |
| Build Commands | `minddoc/BUILD_COMMANDS.md` |

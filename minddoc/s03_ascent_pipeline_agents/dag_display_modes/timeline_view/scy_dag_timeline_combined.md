<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-DAG-VIEW-TIMELINE (GANTT) — PLAN / TÂCHES / TESTS
**ID** : S03_DAG_VIEW_TIMELINE_PLAN / TASKS / TESTS

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

## Architecture (2 panneaux)
```
[WBS gauche (hiérarchie thèmes/nœuds)]  ←→  [Axe temporel droit (barres Gantt)]
```

## Composants à coder
1. **WBS Panel** (panneau gauche) : arbre hiérarchique collapsible + colonnes configurables
2. **Gantt Bars** (panneau droit) : barres avec progression interne + styles par statut + Summary agrégé
3. **Dependency Links** : 4 types (FS/SS/FF/SF) + lag/lead + flèches colorées + critiques rouges
4. **Critical Path (CPM)** : Rust déterministe forward/backward pass + slack + toggle isolation
5. **Baseline vs Réel** : snapshot planning initial + comparaison variance (rouge/vert)
6. **Milestones (◆)** : 🏁/⭐/🏆 + personnalisés + deadline constraint
7. **Resource Loading heatmap** : charge cognitive jour par jour + resource leveling
8. **ETA dynamique** : FSRS + Flow + progression réelle + CHRONICLE
9. **TODAY line + Progress Line** : ligne rouge + zigzag + retards
10. **Zoom temporel** : Jour/Semaine/Mois + virtual scroll
11. **Export** : PNG + PDF Typst + iCalendar .ics

## Flux de données
```
[scy_ascent_nodes + scy_ascent_edges + weekly_availability_hours]
   │
   ▼
[CPM Rust déterministe : Forward/Backward pass → ES/EF/LS/LF/Slack/Critical Path] (< 5ms, $0)
   │
   ▼
[Calcul dates : début/fin prévu par nœud (effort ÷ dispo hebdo + ordre topo + dépendances)]
   │
   ├── Baseline snapshot (démarrage) → scy_dag_baseline
   │
   ▼
[Rendu Gantt React (barres + liens + jalons + charge + TODAY)]
   │
   ├── EventBus NodeCompleted/NodeUnlocked → màj temps réel barres + ETA
   ├── CHRONICLE imprévu → reprogrammation + nouvelle baseline + décalage visible
   └── ETA dynamique (FSRS forecast + Flow score + progression réelle)
```

## Tables impactées
- `scy_ascent_nodes` : +estimated_start, +estimated_finish, +actual_start, +actual_finish, +slack_days, +is_critical_path, +dependency_type, +lag_days
- `scy_ascent_edges` : +dependency_type (FS/SS/FF/SF), +lag_days
- `scy_dag_baseline` (NOUVELLE) : snapshot planning (nodes JSON, captured_at, is_current, chronicle_reprogram_id)
- `scy_milestones` (NOUVELLE) : label, type (start/macro/proof/personal/drift/reprogram), target_date, is_deadline_strict, created_at

## Dépendances : React Flow (@xyflow/react), Rust CPM, @tanstack/react-virtual, FSRS forecast, CHRONICLE, typst (export PDF), ics (export iCalendar).
## Fichiers : `frontend_react/src/dag/timeline/GanttChart.tsx`, `WbsPanel.tsx`, `GanttBar.tsx`, `DependencyLink.tsx`, `CriticalPathOverlay.tsx`, `BaselineLayer.tsx`, `MilestoneMarker.tsx`, `ResourceHeatmap.tsx`, `TodayLine.tsx`, `backend_rs/src/ascent/gantt/cpm.rs`, `resource_leveling.rs`, `eta_calculator.rs`.

## Tâches
- GT.1 : Coder le CPM Rust (forward/backward pass, slack, critical path, <5ms) (30min)
- GT.2 : Coder le WBS Panel (hiérarchie + colonnes + collapse/expand) (30min)
- GT.3 : Coder les barres Gantt (position + progression SMI + styles statut + Summary) (30min)
- GT.4 : Coder les Dependency Links (4 types + lag/lead + couleurs + critiques rouges) (25min)
- GT.5 : Coder le Critical Path overlay + toggle isolation + slack gris (25min)
- GT.6 : Coder Baseline vs Réel (snapshot + variance + nouvelle baseline CHRONICLE) (30min)
- GT.7 : Coder Milestones (◆ + personnalisés + deadline constraint + alerte) (25min)
- GT.8 : Coder Resource Heatmap (charge cognitive jour + surcharge rouge + leveling) (30min)
- GT.9 : Coder ETA dynamique (FSRS + Flow + progression + CHRONICLE) (25min)
- GT.10 : Coder TODAY line + Progress Line (ligne rouge + zigzag + retards) (20min)
- GT.11 : Coder Zoom temporel (Jour/Semaine/Mois + virtual scroll) (20min)
- GT.12 : Coder Export (PNG + PDF Typst + iCalendar .ics) (25min)

## Tests
- TC1 : Gantt 2 panneaux (WBS + barres + en-tête). | TC2 : Barres (position + SMI + statut + Summary). | TC3 : Dépendances 4 types + lag + critiques rouges. | TC4 : CPM < 5ms + nœuds rouges + slack + toggle. | TC5 : Baseline vs réel + variance + CHRONICLE nouvelle baseline. | TC6 : Jalons ◆ + deadline alerte. | TC7 : Heatmap charge + surcharge + leveling. | TC8 : ETA dynamique (avance/retard). | TC9 : CHRONICLE reprogrammation + décalage. | TC10 : TODAY + Progress Line + retards. | TC11 : Zoom 3 niveaux + scroll infini. | TC12 : Export PNG/PDF/ics.

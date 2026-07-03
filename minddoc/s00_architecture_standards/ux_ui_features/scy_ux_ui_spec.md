<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Standards architecturaux — ajouter section beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎨 SCY-UX-UI-FEATURES — SPÉCIFICATION (SPEC)
**ID** : S00_UX_UI_SPEC · **Phase** : MVP · **Réf** : PRD §7.11, D-001/D-003/D-012

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

## 1. Purpose
Module **UX/UI — Features Interface** : dashboard accueil, tags hiérarchiques, auto-save, search globale, notifications, thème, raccourcis, responsive, accessibilité.

## 2. Features

### Dashboard Accueil (D-003)
- Quick Actions Cards (Ajouter source, Réviser, Continuer roadmap, BRAIN search)
- Stats Widget (cartes révisées/objectif, SMI moyen, streak, prochaine révision)
- Activity Feed (sources ingérées, concepts appris, milestones)
- AI Recommendations (suggestions ASCENT contextuelles)

### Tags Hiérarchiques 3 Niveaux (D-001)
- Structure drill-down : Tech > Web > React
- Auto-suggestion ML (clustering sémantique)
- Multi-sélection AND/OR, drag & drop

### Auto-Save Drafts (D-012)
- Dual storage : localStorage + PostgreSQL
- Debounce 2s, offline support, sync background, conflict resolution LWW

### Search Globale
- Hybrid Tantivy + pgvector, autocomplete 300ms, facets (source, tags, date, SMI)

### Notifications
- Types : Cards dues, Milestone, Ingestion, Erreur, Drift
- Channels : in-app toast, push browser, email optionnel
- Préférences granulaires

### Theme / Shortcuts / Responsive / Accessibility
- Dark/Light (localStorage, system sync, transition 200ms, WCAG AA)
- Shortcuts : Ctrl+K search, Ctrl+N source, Ctrl+R révision, 1-4 APEX feedback
- Responsive : Mobile <600px, Tablet 600-900px, Desktop >900px
- WCAG 2.1 AA : keyboard 100%, ARIA, contraste ≥4.5:1, focus 2px

## 3. Tests
- TC1 : Dashboard Quick Actions + Stats + Activity Feed. | TC2 : Tags 3 niveaux drill-down + auto-suggest. | TC3 : Auto-Save dual storage + offline. | TC4 : Search autocomplete 300ms + facets. | TC5 : WCAG 2.1 AA (contraste, keyboard, ARIA).

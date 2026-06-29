# SCY Forge — WDS-4 Accessibility & Design System Review (Step 05)
_Phase WDS-4_
_Source : `design-artifacts/D-UX-Design/*` + `design-artifacts/D-Design-System/*`_

---

## Objectif

Vérifier que les 87 scénarios WDS-4 respectent :
1. WCAG 2.1 AA
2. Les tokens WDS-7 exclusivement
3. La règle des 2 clics
4. Les patterns d’interaction définis

---

## Checklist accessibilité (par scénario)

### Chaque scénario doit valider :

- [ ] Tous les champs ont un label explicite (pas de placeholder seul)
- [ ] États d’erreur liés par `aria-describedby` ou `aria-invalid`
- [ ] États `loading` marqués par `aria-busy="true"`
- [ ] États `error` associés à un message d’erreur accessible
- [ ] Boutons d’action ont un `type` explicite (`submit`, `button`)
- [ ] Icônes seules ont un `aria-label` ou sont cachées (`aria-hidden="true"`)
- [ ] Navigation clavier complète (tab / enter / escape)
- [ ] Ordre de tab cohérent (haut → bas, gauche → droite)
- [ ] Focus visible conservé en permanence (`scy-focus-visible`)
- [ ] Modales ont `role="dialog"`, `aria-modal="true"`, `aria-labelledby`
- [ ] Toasts ont `role="alert"` ou `aria-live="polite"`
- [ ] Navigation landmarks (`<nav>`, `<main>`, `<header>`, `<footer>`)
- [ ] Contraste vérifié (4.5:1 texte, 3:1 UI)

---

## Checklist design system (par composant)

### Chaque composant documenté doit :

- [ ] Référencer uniquement des tokens WDS-7
- [ ] Être documenté avec ses variants et états
- [ ] Avoir un exemple d’utilisation dans un scénario WDS-4
- [ ] Suivre les conventions de nommage du design system
- [ ] Exporter un wrapper typé (React + TS)

---

## Revue par module

### Auth / Dashboard (SC-001 → SC-008)
- AuthShell : OK
- Sidebar : OK
- Topbar : OK
- Widgets Dashboard : OK
- Accessibilité : labels auth OK, focus management OK

### INGEST (SC-009 → SC-016)
- DropZone : ✅ `aria-label` OK, keyboard activation OK
- ProgressBar : ✅ `aria-valuenow` OK
- IngestCard : ✅ états accessibles
- États empty / error : ✅ présents

### NEURON / APEX (SC-017 → SC-022)
- GeneratorPanel : ✅ variants documentés
- CardPreview : ✅ interop NEURON → APEX claire
- ReviewSession : ✅ FSRS states mappés

### COSMOS / BRAIN (SC-023 → SC-032)
- GraphView : ✅ wrapper commun documenté
- ChatModal : ✅ `role="dialog"` présent
- LensSelector : ✅ variants et états clairs

### Reader / Imprint / Chronicle (SC-033 → SC-042)
- ReaderShell : ✅ modes documentés
- MetricCard : ✅ variantes delta OK
- TimelineFeed : ✅ états lue / non lue OK

### ASCENT (SC-043 → SC-050)
- PipelineStep : ✅ états pending/running/success/failed
- LogConsole : ✅ filtres et export documentés
- PolicySelector : ✅ variantes select/json OK

### Harmonist / Normal / Neuro / PivotIQ (SC-051 → SC-062)
- Audit/report : ✅ diagnostic court
- Neuroscience : ✅ simulation et profil
- PivotIQ : ✅ rollback explicite

### B2B / Arena / Finance (SC-063 → SC-070)
- MemberRow : ✅ rôles et permissions
- LeaderboardRow : ✅ surlignage current user
- FinancialCard : ✅ variants positif/négatif

### System / Settings / Transversaux (SC-071 → SC-087)
- États dégradés : ✅ offline / système
- SSO / reprise session : ✅ flows alternatifs documentés
- Export données : ✅ formats et périodes

---

## Synthèse

- **87/87 scénarios** couverts par des spécifications UX
- **WCAG 2.1 AA** : exigence appliquée à chaque scénario
- **Tokens WDS-7** : exclusivement autorisés
- **Règle des 2 clics** : vérifiée par flow (voir `wds4-flows.md`)
- **Composants UI** : catalogués par module avec variants et états (voir `wds4-component-catalog.md`)

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `design-artifacts/D-UX-Design/batch-*-*.md` | WDS-4 | Spécifications UX 087/087 |
| `design-artifacts/D-UX-Design/wds4-flows.md` | WDS-4 | Flows d’interaction |
| `design-artifacts/D-UX-Design/wds4-component-catalog.md` | WDS-4 | Catalogue composants UI |
| `design-artifacts/D-UX-Design/wds4-accessibility-review.md` | WDS-4 | Accessibilité + cohérence |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

> WDS-4 Step-05 cloturé une fois l’audit manuel effectué avec l’équipe design/dev.

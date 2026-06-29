# SCY Forge — WDS-4 Component Catalog (Step 04)
_Phase WDS-4_
_Source : `design-artifacts/D-UX-Design/batch-*-*.md`_

---

## Principe

Tous les composants UI consomment exclusivement les tokens WDS-7.  
Aucun style inline, aucune couleur magique.

---

## Composants Auth / Navigation

### AuthShell
- Usage : connexion, inscription, reset password
- Variants : `login` / `signup` / `forgot`
- États : `idle / loading / error`
- Accessibilité : `aria-labelledby`, `aria-describedby`, ordre de tab natif

### Sidebar
- Usage : navigation principale
- Variants : `expanded / collapsed`
- États : section active, survol, disabled
- Tokens : `scy-bg-sidebar`, `scy-border-subtle`

### Topbar
- Usage : breadcrumb, recherche, notifications, profil
- Variants : `default / compact`
- États : recherche focus, panel ouvert

---

## Composants INGEST

### IngestCard
- Usage : item dans la liste des ingests
- Variants : `idle / running / completed / failed`
- États : progression, annulation, retry
- Tokens : `scy-bg-card`, `scy-border-default`, `scy-text-primary`

### DropZone
- Usage : upload fichier
- Variants : `idle / dragOver / uploading`
- États : formats refusés, quota dépassé
- Tokens : `scy-border-dashed`, `scy-accent-primary`

### ProgressBar
- Usage : progression ingest, génération NEURON, pipeline ASCENT
- Variants : `determinate / indeterminate`
- États : `0-100%`, étiquetage étape
- Tokens : `scy-accent-primary`, `scy-bg-subtle`

---

## Composants NEURON / APEX

### GeneratorPanel
- Usage : configuration génération NEURON
- Variants : `concept / flashcards / quiz / summary`
- États : `idle / generating / completed / failed`
- Tokens : `scy-bg-card`

### CardPreview
- Usage : aperçu carte APEX / NEURON avant validation
- Variants : `text / image / cloze`
- États : `selected / disabled`
- Tokens : `scy-bg-card`, `scy-border-subtle`

### ReviewSession
- Usage : session révision APEX
- Variants : `front / back / stats`
- États : `new / learning / review / relearning`
- Tokens : `scy-bg-card`, `scy-text-primary`, `scy-accent-primary`

---

## Composants COSMOS / BRAIN

### GraphView
- Usage : rendu graphe COSMOS
- Variants : `chronological / conceptual / social / pedagogical`
- États : `loading / interactive / overlay`
- Contrainte : wrapper commun pour G6 / Cosmograph
- Tokens : `scy-bg-primary`, `scy-border-subtle`

### ChatModal
- Usage : interface BRAIN
- Variants : `floating / pinned`
- États : `idle / typing / error`
- Tokens : `scy-bg-elevated`, `scy-border-subtle`

### LensSelector
- Usage : choix lentille COSMOS
- Variants : `horizontal scroll`
- États : `active / hover`
- Tokens : `scy-bg-subtle`, `scy-accent-primary`

---

## Composants Reader / Imprint / Chronicle

### ReaderShell
- Usage : lecture document
- Variants : `text / pdf / epub`
- États : texte annoté, mode focus
- Tokens : `scy-bg-primary`, `scy-text-primary`

### MetricCard
- Usage : KPI Imprint ou Dashboard
- Variants : `value / delta / sparkline`
- États : positif, négatif, neutre
- Tokens : `scy-bg-card`, `scy-text-primary`, `scy-accent-primary`, `scy-accent-danger`

### TimelineFeed
- Usage : Chronicle
- Variants : `vertical / compact`
- États : lue / non lue / archivée
- Tokens : `scy-bg-card`, `scy-border-subtle`, `scy-text-secondary`

---

## Composants ASCENT / Harmonist / Normal / PivotIQ

### PipelineStep
- Usage : représentation d’agent ASCENT
- Variants : `pending / running / success / failed`
- États : hover détails, retry
- Tokens : `scy-bg-subtle`, `scy-accent-success`, `scy-accent-danger`

### LogConsole
- Usage : logs ASCENT / système
- Variants : `collapsed / expanded`
- États : filtre actif, ligne sélectionnée
- Tokens : `scy-bg-subtle`, police monospace via token typographique

### PolicySelector
- Usage : configuration expert (retry, timeout, fallback)
- Variants : `select / json editor`
- États : validation, aperçu
- Tokens : `scy-bg-card`, `scy-border-default`

---

## Composants B2B / Arena / Finance

### MemberRow
- Usage : table membres B2B
- Variants : `admin / editor / viewer`
- États : actif, en attente, révoqué
- Tokens : `scy-bg-card`, `scy-border-subtle`

### LeaderboardRow
- Usage : classement ARENA
- Variants : `top / current / normal`
- États : surlignage du current user
- Tokens : `scy-bg-card`, `scy-accent-primary`

### FinancialCard
- Usage : KPI Finance Suite
- Variants : `revenue / margin / burn`
- États : positif, négatif, neutre
- Tokens : `scy-bg-card`, `scy-text-primary`, `scy-accent-success`, `scy-accent-danger`

---

## Composants globaux

### Button
- Variants : `primary / secondary / ghost / danger`
- États : `idle / loading / disabled`
- Tokens : `scy-btn-*`, `scy-focus-visible`

### Input
- Variants : `text / password / search / email`
- États : `idle / focus / error / disabled`
- Tokens : `scy-input`, `scy-border-default`, `scy-accent-danger`

### Select, Toggle, Checkbox, Radio
- Variants : standard / compact
- États : `checked / unchecked / indeterminate / disabled`
- Tokens : `scy-bg-subtle`, `scy-border-default`, `scy-accent-primary`

### Modal
- Variants : `alert / confirm / form / drawer`
- États : `open / closed / closing`
- Tokens : `scy-bg-elevated`, `scy-border-subtle`

### Toast
- Variants : `success / error / warning / info`
- États : `entering / visible / leaving`
- Tokens : `scy-bg-elevated`, `scy-border-subtle`, `scy-accent-*`

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `design-artifacts/D-UX-Design/batch-*-*.md` | WDS-4 | Spécifications UX |
| `design-artifacts/D-UX-Design/wds4-component-catalog.md` | WDS-4 | Catalogue composants |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

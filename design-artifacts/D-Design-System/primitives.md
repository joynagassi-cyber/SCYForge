# SCY Forge — UI Primitives

> Source unique de vérité : `mindoc/s00_design/scy_design_system.md`
>
> Cette page répertorie toutes les primitives UI à implémenter dans
> `frontend_react/src/components/ui/`. Aucune primitive n'est inventée ici ;
> chaque entrée provient du design system SCY Forge.

---

## Organisation

```
frontend_react/src/components/ui/
├── primitives/          ← briques atomiques (Button, Input, Badge, ...)
├── composites/          ← assemblages métier (ScenarioCard, MasteryRadar, ...)
└── layouts/             ← gabarits structurels (DashboardShell, OnboardingLayout)
```

---

## Primitives Atomiques (primitives/)

### Buttons

| Variant | Usage |
|---------|-------|
| `Button.primary` | Action principale (CTA violet) |
| `Button.success` | Validation, confirmation (vert émeraude) |
| `Button.outline` | Action secondaire, ghost |
| `Button.danger` | Suppression, warning (rouge — usage restreint) |
| `Button.icon` | Icône seule (toolbar, header) |

États gérés : `default` | `hover` | `active` | `disabled` | `loading`.

Taille : `sm` | `md` | `lg`. Rayon : `--scy-rounded-md`. Ombre hover : `--scy-shadow-glow-violet`.

### Inputs

| Variant | Usage |
|---------|-------|
| `Input.text` | Champ texte standard |
| `Input.password` | Mot de passe avec toggle reveal |
| `Input.search` | Recherche globale avec icône loupe |
| `Input.select` | Select dropdown |
| `Input.textarea` | Texte multi-lignes |
| `Input.role-selector` | Spécifique : sélection du rôle SOC lors de l'onboarding |

États gérés : `default` | `focus` | `error` | `disabled`.

Border focus : `--scy-color-ai`. Border error : `--scy-color-error`.

### Cards

```
Card
├── Card.Header     (titre + badge)
├── Card.Body       (contenu principal)
└── Card.Footer     (actions)
```

Variants : `default` | `hover:lift` | `selected` | `mastered` (bordure verte).

### Badges

| Variant | Couleur | Usage |
|---------|---------|-------|
| `Badge.ai` | Violet | Tag IA, conseil généré |
| `Badge.success` | Vert | Nœud maîtrisé, succès |
| `Badge.alert` | Or | À retravailler, alerte |
| `Badge.info` | Cyan | Neutre, progression |
| `Badge.error` | Rouge | Erreur système |

### Progress

| Variant | Usage |
|---------|-------|
| `Progress.bar` | Barre de progression (SMI %, chargement pack) |
| `Progress.circular` | Indicateur circulaire (radar SMI) |
| `Progress.stepped` | Steps numérotés (onboarding flow) |

### Tree / Graph

| Composant | Usage |
|-----------|-------|
| `TreeNode` | Nœud individuel (état : `locked` / `ready` / `studying` / `mastered`) |
| `TreeEdge` | Arête entre deux nœuds (style selon `EdgeKind`) |
| `TreeLegend` | Légende des couleurs de l'arbre |
| `SkillGapBadge` | Badge rouge sur nœud avec prérequis manquants |

### Decision (ARENA)

| Composant | Usage |
|-----------|-------|
| `DecisionCard` | Carte de décision ARENA (stimulus + 3 options) |
| `DecisionFeedback` | Feedback post-décision (bon/pas bon + explication) |
| `ScenarioProgress` | Progression dans la chaîne APT29 (étape X/79) |

### Dashboard

| Composant | Usage |
|-----------|-------|
| `SMIRadar` | Radar SMI (5 dimensions) |
| `GapMap` | Nœuds rouges + chemins de rattrapage |
| `CoverageBar` | % de l'arbre ATT&CK couvert par le rôle |
| `ReadinessScore` | Score global de readiness pour le rôle cible |

### Feedback / Toast

| Composant | Usage |
|-----------|-------|
| `Toast.success` | Confirmation (vert) |
| `Toast.ai` | Conseil IA (violet) |
| `Toast.alert` | Warning (or) |
| `Toast.error` | Erreur (rouge) |

---

## Primitives Typographiques

### Hiérarchie de Titres

```
H1 — text-4xl / font-bold / text-primary   (Titre page)
H2 — text-3xl / font-semibold / text-primary (Section)
H3 — text-2xl / font-semibold / text-primary (Sous-section)
H4 — text-xl / font-medium / text-primary   (Card title)
H5 — text-lg / font-medium / text-primary   (Micro-section)
```

### Corps de Texte

```
Body — text-base / font-normal / text-primary    (Paragraphe)
Body-sm — text-sm / font-normal / text-secondary (Annotation, description)
Caption — text-xs / font-normal / text-muted      (Meta, timestamp)
Mono — text-sm / font-mono / text-secondary      (Code, hex, technique ID)
```

---

## Primitives d'Espacement

### Échelle

```
xs  → space-1  (4px)   Padding interne serré
sm  → space-2  (8px)   Gaps élémentaires
md  → space-3  (12px)  Séparations standards
lg  → space-4  (16px)  Sections, card padding
xl  → space-6  (24px)  Groupes de cards
2xl → space-8  (32px)  Sections de page
3xl → space-12 (48px)  Marges inter-blocs
```

### Règles d'Espacement

- **Vertical rhythm** : multiples de 4px uniquement.
- **Card padding** : toujours `space-4` (16px) sauf spécification contraire.
- **Gap entre éléments d'une ligne** : `space-2` (8px) minimum.
- **Section separation** : `space-8` (32px) minimum.

---

## Primitives de Couleurs (États Sémantiques)

### Semantic Color Map

| État | Couleur | Usage |
|------|---------|-------|
| **Mastered** | `color-success` (#10B981) | Nœud maîtrisé (SMI ≥ 0.70), badge validé |
| **Studying** | `color-info` (#06B6D4) | Nœud en cours d'apprentissage |
| **Locked** | `text-muted` (#6B7280) | Nœud verrouillé (prereq non satisfait) |
| **Gap** | `color-alert` (#D97706) | Nœud dégradé (prereq manquant, criticality faible) |
| **AI-generated** | `color-ai` (#7C3AED) | Contenu généré par agent, carte IA |
| **Error** | `color-error` (#EF4444) | Erreur système (usage restrictif) |
| **Interactive** | `color-ai` (border-focus) | Focus input, hover bouton |

---

## Primitives d'Animation

> Toutes les animations sont synchronisées sur la durée de `cubic-bezier(0.4, 0, 0.2, 1)`.

| Primitive | Duration | Easing | Usage |
|-----------|----------|--------|-------|
| `transition-fast` | 150ms | ease-out | Hover micro-interactions (buttons, cards) |
| `transition-normal` | 250ms | ease-out | State transitions (panel open, dropdown) |
| `transition-slow` | 400ms | ease-out | Page transitions, hero animations |
| `transition-global` | 600ms | ease-in-out | Semantic Tree node entrance ( Plant/Graft ) |
| `keyframe-pulse` | 2000ms loop | ease-in-out | Nœud SMI en cours de calcul |
| `keyframe-glow` | 2500ms loop | ease-in-out | Badge IA, notification |

### Motion Constraints

- Aucune animation sur les éléments de layout structurel (pas de `transition` sur `<header>`, `<nav>`, `<aside>`).
- Animations déclenchées uniquement par : `enter` (apparition), `update` (changement d'état), `exit` (disparition via Framer Motion `AnimatePresence`).
- `prefers-reduced-motion` : toutes animations réduites à 0ms si l'utilisateur a configuré l'accessibilité OS.

---

## Primitives de Ombres

```
shadow-rest      → shadow-sm    (éléments plats, cards subtiles)
shadow-raised    → shadow-md    (cards hover, popover)
shadow-modal     → shadow-lg    (modale, panel)
shadow-glow-violet → glow-violet (CTA, focus states)
shadow-glow-emerald → glow-emerald (validation, achievement)
```

---

## Z-Index Layers

```
base        → 0         (contenu statique)
dropdown    → 1000      (selects, autocomplete)
sticky      → 1020      (header sticky, sticky notes)
overlay     → 1030      (backdrop modale)
modal       → 1040      (modale)
popover     → 1050      (tooltips, info popovers)
toast       → 1060      (notifications)
overlay-deep → 1070     (loader global, emergency overlay)
```

---

## Layout Primitives

### Layout Container

```
Container:
  padding-x: space-4 (16px)
  max-width: 1280px
  margin: 0 auto
```

### Grid System

```
Grid (standard) :   grid-template-columns: repeat(12, 1fr)
Grid (dashboard):   grid-template-columns: repeat(6, 1fr)
Gap standard:       gap-md (12px)
Gap dashboard:      gap-lg (16px)
```

### Sidebar (Layout Shell)

```
Sidebar:
  width: 260px
  bg: --scy-bg-card
  border-right: 1px solid --scy-border-default
  padding: space-4
  z-index: sticky
```

### Main Content Area

```
Main:
  padding: space-6 (24px)
  max-width: calc(100vw - 260px)
```

---

## Primitives d'Accessibilité

| Primitive | Implémentation |
|-----------|----------------|
| Focus visible | `ring-2 ring-offset-2 ring-[--scy-color-ai]` sur tous les éléments interactifs |
| Skip links | `<a href="#main" class="sr-only focus:not-sr-only">` |
| ARIA labels | Obligatoires sur icônes, graphs, tree nodes |
| Contraste | Texte primary sur bg-card = 12.6:1 (WCAG AAA) |
| Keyboard nav | Tree nodes navigables via flèches ↑↓, Enter = ouvrir, Esc = fermer |
| Screen reader | Tree nodes : `role="treeitem"` + `aria-expanded`, `aria-level`, `aria-setsize` |
| Reduced motion | `@media (prefers-reduced-motion: reduce)` → animations 0ms |

---

## Checklist d'Audit (pour toute PR frontend)

Avant de merger un composant frontend, vérifier :

- [ ] Toutes les couleurs viennent des tokens (`colors.*`), pas de hardcoded hex
- [ ] Toutes les ombres viennent de `shadows.*`
- [ ] Tous les espacements viennent de l'échelle `space-*`
- [ ] Toutes les animations respectent les durations et easing définis
- [ ] Focus visible présent et testable au clavier
- [ ] `prefers-reduced-motion` respecté
- [ ] Composant exporté depuis `primitives/index.ts`
- [ ] Tests d'a11y (axe DevTools) passent sur le composant
- [ ] Responsive : mobile < 768px, tablet 768-1024px, desktop > 1024px

*Fin du document. Cette liste est exhaustive pour le beachhead MVP.
Toute nouvelle primitive doit être ajoutée ici AVANT implémentation.*

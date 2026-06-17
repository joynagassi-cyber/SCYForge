---
status: final
version: 1.0.0
updated: 2026-06-03
project: MindForge
platforms: [web, desktop-windows, desktop-macos, desktop-linux, mobile-ios, mobile-android]
ui-system: tailwindcss-3.4
framework: react-18.3

# Design Tokens
colors:
  # Fonds
  bg-main: "#05050A"           # Noir d'Encre Profond
  bg-card: "#0D0D15"           # Bleu Nuit Spatial
  bg-hover: "#1A1A25"          # Hover state
  bg-active: "#25253A"         # Active state
  
  # Accents
  color-ai: "#7C3AED"          # Violet Électrique — IA, focus, brand
  color-success: "#10B981"     # Emerald — validé, maîtrisé
  color-info: "#06B6D4"        # Cyan Cyber — neutre, progression
  color-alert: "#D97706"       # Or Brillant — critique, à retravailler
  color-error: "#EF4444"       # Rouge (usage limité: erreurs systèmes uniquement)
  
  # Texte
  text-primary: "#F3F4F6"      # Gris clair (Titres uniquement)
  text-reading: "#E5E7EB"      # Off-White Anti-Halation (Corps de texte longs, évite le saignement visuel sur fond noir)
  text-secondary: "#9CA3AF"    # Gris moyen
  text-muted: "#6B7280"        # Gris foncé
  text-inverse: "#05050A"      # Texte sur fond clair
  
  # Muted Opacities (Composants Verre / Translucides)
  opacity-ai-bg: "rgba(124, 58, 237, 0.08)"
  opacity-success-bg: "rgba(16, 185, 129, 0.08)"
  opacity-alert-bg: "rgba(217, 119, 6, 0.08)"
  opacity-info-bg: "rgba(6, 182, 212, 0.08)" 
  
  # Bordures
  border-default: "#374151"    # Bordure standard
  border-hover: "#4B5563"      # Bordure hover
  border-focus: "#7C3AED"      # Bordure focus (violet)

typography:
  # Familles de polices
  font-sans: "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif"
  font-mono: "'JetBrains Mono', 'Fira Code', 'Consolas', monospace"
  
  # Échelle de tailles
  text-xs: "0.75rem"      # 12px
  text-sm: "0.875rem"     # 14px
  text-base: "1rem"       # 16px
  text-lg: "1.125rem"     # 18px
  text-xl: "1.25rem"      # 20px
  text-2xl: "1.5rem"      # 24px
  text-3xl: "1.875rem"    # 30px
  text-4xl: "2.25rem"     # 36px
  
  # Poids
  font-normal: 400
  font-medium: 500
  font-semibold: 600
  font-bold: 700

spacing:
  # Échelle spatiale (basée sur 4px)
  space-0: "0"
  space-1: "0.25rem"    # 4px
  space-2: "0.5rem"     # 8px
  space-3: "0.75rem"    # 12px
  space-4: "1rem"       # 16px
  space-5: "1.25rem"    # 20px
  space-6: "1.5rem"     # 24px
  space-8: "2rem"       # 32px
  space-10: "2.5rem"    # 40px
  space-12: "3rem"      # 48px
  space-16: "4rem"      # 64px

# États Attentionnels (ADHD & Focus Constraints - Loi L1 Sweller)
focus-states:
  spotlight-opacity-inactive: 0.25      # Opacité des blocs hors-focus pour forcer le tunnel visuel
  spotlight-blur-inactive: "blur(2px)"  # Floutage léger du contenu non-actif en Focus Mode
  pacer-speed-default: "250wpm"         # Vitesse par défaut de la barre de rythme oculaire

rounded:
  # Arrondis
  rounded-sm: "0.125rem"   # 2px
  rounded: "0.25rem"       # 4px
  rounded-md: "0.375rem"   # 6px
  rounded-lg: "0.5rem"     # 8px
  rounded-xl: "0.75rem"    # 12px
  rounded-2xl: "1rem"      # 16px
  rounded-full: "9999px"   # Cercle complet

shadows:
  # Élévations
  shadow-sm: "0 1px 2px 0 rgb(0 0 0 / 0.05)"
  shadow: "0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)"
  shadow-md: "0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)"
  shadow-lg: "0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)"
  shadow-xl: "0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)"
  shadow-glow-violet: "0 0 20px rgba(124, 58, 237, 0.3)"
  shadow-glow-emerald: "0 0 20px rgba(16, 185, 129, 0.3)"

components:
  # Composants définis dans les sections ci-dessous
  button: true
  card: true
  input: true
  badge: true
  sidebar: true
  modal: true
  tooltip: true
---

# MindForge Design System

**Version :** 1.0.0  
**Date :** 2026-06-02  
**Direction :** L'Équilibre Synaptique (Tech Innovante + Neuro-Ergonomie)  
**Mode par défaut :** Dark Mode First

---

## Brand & Style

### Vision Design

MindForge est une **plateforme d'apprentissage augmentée par l'IA** qui agit comme un **prolongement transparent de la pensée**. L'interface favorise un **état de flux (flow state)** pour des sessions longues (25+ minutes) en minimisant la fatigue visuelle.

### Principes de Neuro-Ergonomie

1. **Réduction de la fatigue visuelle (Asténopie)**  
   Contrastes doux mais nets. Dark mode par défaut avec émission de lumière bleue minimale.

2. **Indexation attentionnelle**  
   Couleurs chaudes (Or, Violet) réservées aux notifications et points de blocage critiques uniquement.

3. **Ancrage mémoriel**  
   Chaque module a une signature chromatique unique pour créer des repères spatiaux dans le cerveau.

### Règle 60-30-10

- **60% fond sombre** (`#05050A`) → Repos de l'œil
- **30% surfaces/textes** (`#0D0D15`, `#F3F4F6`) → Structure l'information
- **10% accents** (Violet, Emerald, Cyan, Or) → CTA, IA, validations, alertes

### Inspirations

- **Notion** : Disposition complexe simple et intuitive
- **Obsidian** : Dark mode élégant, focus contenu
- **Canva** : Organisation fonctionnalités multiples accessible
- **VS Code** : Environnement de développement moderne
- **Linear** : Navigation fluide et états clairs

---

## Colors

### Palette Principale

#### Fonds (Backgrounds)

**Noir d'Encre Profond** `#05050A`  
Usage : Fond principal de l'application  
Justification : Émission de lumière bleue minimale, repos de la rétine

**Bleu Nuit Spatial** `#0D0D15`  
Usage : Surfaces, cartes, modals  
Justification : Délimite les zones de travail sans rupture de contraste agressive

**Hover State** `#1A1A25`  
Usage : État hover des cartes et boutons

**Active State** `#25253A`  
Usage : État actif/sélectionné

#### Accents (Semantic Colors)

**Violet Électrique** `#7C3AED`  
Usage : IA, focus, brand, créativité  
Modules : LIBRARY (concepts), BRAIN (chat)  
Justification : Stimule l'activité cérébrale et l'association d'idées

**Emerald** `#10B981`  
Usage : Validations, succès, maîtrisé, streak  
Modules : APEX (cartes mastered), ASCENT (nœuds completed)  
Justification : Ancré dans l'inconscient humain comme signal de progression

**Cyan Cyber** `#06B6D4`  
Usage : Information, neutre, progression  
Modules : INGEST (progress bars), ASCENT (nœuds unlocked)  
Justification : Effet calmant, fluidité et validation des étapes

**Or Brillant** `#D97706`  
Usage : Critique, à retravailler, opportunité  
Modules : ASCENT (nœuds nécessitant révision), Activity Center (warnings)  
Justification : Attire l'attention sans déclencher stress du rouge

#### Texte (Text Colors)

**Texte Principal** `#F3F4F6`  
Usage : Titres, corps de texte principal  
Contraste : 15.8:1 sur `#05050A` (WCAG AAA)

**Texte Secondaire** `#9CA3AF`  
Usage : Labels, metadata, timestamps  
Contraste : 8.6:1 sur `#05050A` (WCAG AAA)

**Texte Muet** `#6B7280`  
Usage : Placeholders, hints, disabled text  
Contraste : 5.1:1 sur `#05050A` (WCAG AA)

### Anti-Pattern : Éviter le Rouge Pur

Dans un contexte éducatif, le rouge stimule le stress lié à l'erreur ou à l'échec scolaire. MindForge utilise l'**Or/Ambre** (#D97706) pour signaler les points à réviser, transformant l'erreur en **opportunité de maîtrise**.

**Usage limité du Rouge** `#EF4444` : uniquement pour erreurs système critiques (500, crash, data loss).

### Ancrage Mémoriel par Module

| Module  | Couleur Signature | Hex               | Usage Spécifique               |
| ------- | ----------------- | ----------------- | ------------------------------ |
| INGEST  | Cyan              | #06B6D4           | Progress bars, status icons    |
| LIBRARY | Violet AI         | #7C3AED           | Concept cards, IA suggestions  |
| COSMOS   | Multi             | Varies            | Nœuds colorés par SMI level    |
| APEX    | Emerald           | #10B981           | Cartes mastered, streak badges |
| ASCENT  | Or → Emerald      | #D97706 → #10B981 | locked → completed             |
| BRAIN   | Violet AI         | #7C3AED           | Chat interface, RAG responses  |

### Palettes SMI (Score Maîtrise Intégrée)

Utilisées dans COSMOS Knowledge Graph et ASCENT Roadmap :

| Niveau SMI        | Range  | Couleur      | Hex     | Signification / État Visuel           |
| ----------------- | ------ | ------------ | ------- | ------------------------------------- |
| **Expert / Or**   | 86-100 | Or Pulsant   | #C9A227 | Maîtrise absolue (Simul. ARENA/Teach-Back) |
| **Validé / Vert** | 76-85  | Vert Émeraude| #10B981 | Maîtrise validée par révision active   |
| **Consolidé**     | 60-75  | Jaune-Or     | #FDE68A | Compréhension solide, consolidation   |
| **Fragile**       | 40-59  | Orange       | #FB923C | Bases à retravailler, FSRS récurrente |
| **Débutant**      | <40    | Rouge        | #EF4444 | Concept non acquis ou dérive critique  |
| **Pas de SMI**    | N/A    | Gris         | #9CA3AF | Pas encore évalué par le système      |

---

## Typography

### Familles de Polices

**Sans-Serif (Primaire)** : Inter  
Usage : Interface, textes de contenu, navigation  
Fallback : -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif  
Justification : Géométrique moderne, excellente lisibilité écran

**Monospace (Code)** : JetBrains Mono  
Usage : Code snippets, JSON, logs, timestamps  
Fallback : 'Fira Code', 'Consolas', monospace  
Justification : Ligatures coding, excellent espacement

### Échelle Typographique

| Token     | Taille   | Px  | Usage                         |
| --------- | -------- | --- | ----------------------------- |
| text-xs   | 0.75rem  | 12  | Badges, tags, metadata        |
| text-sm   | 0.875rem | 14  | Labels, hints, secondary text |
| text-base | 1rem     | 16  | Corps de texte principal      |
| text-lg   | 1.125rem | 18  | Sous-titres, card titles      |
| text-xl   | 1.25rem  | 20  | Section headers               |
| text-2xl  | 1.5rem   | 24  | Page titles                   |
| text-3xl  | 1.875rem | 30  | Hero titles                   |
| text-4xl  | 2.25rem  | 36  | Marketing, onboarding         |

### Poids (Weights)

| Token         | Valeur | Usage                       |
| ------------- | ------ | --------------------------- |
| font-normal   | 400    | Corps de texte              |
| font-medium   | 500    | Labels, navigation          |
| font-semibold | 600    | Sous-titres, emphase        |
| font-bold     | 700    | Titres, CTA, focus éléments |

### Hiérarchie Visuelle

**H1** : text-3xl, font-bold, text-primary  
**H2** : text-2xl, font-semibold, text-primary  
**H3** : text-xl, font-semibold, text-primary  
**H4** : text-lg, font-medium, text-primary  
**Body** : text-base, font-normal, text-primary  
**Caption** : text-sm, font-normal, text-secondary  
**Label** : text-sm, font-medium, text-secondary


---

## Layout & Spacing

### Grid System

**Desktop/Web :**  
- Container max-width : 1440px
- Gutter : 24px (space-6)
- Colonnes : 12 columns flexible grid

**Mobile :**  
- Container : 100% width
- Padding : 16px (space-4)
- Colonnes : 4 columns

### Spacing Scale

Basée sur un système de **4px** (0.25rem) :

| Token    | Value   | Px  | Usage                                  |
| -------- | ------- | --- | -------------------------------------- |
| space-0  | 0       | 0   | Reset                                  |
| space-1  | 0.25rem | 4   | Icon padding, tight spacing            |
| space-2  | 0.5rem  | 8   | Button padding vertical, badge padding |
| space-3  | 0.75rem | 12  | Input padding vertical                 |
| space-4  | 1rem    | 16  | Card padding, section spacing          |
| space-5  | 1.25rem | 20  | Between form fields                    |
| space-6  | 1.5rem  | 24  | Card inner padding, modal padding      |
| space-8  | 2rem    | 32  | Section separation                     |
| space-10 | 2.5rem  | 40  | Large section separation               |
| space-12 | 3rem    | 48  | Module separation                      |
| space-16 | 4rem    | 64  | Hero sections, major breaks            |

### Layout Patterns

**Sidebar Layout (Desktop/Web) :**
```
┌─────┬────────────────────────────┐
│     │                            │
│  S  │        Main Content        │
│  I  │                            │
│  D  │                            │
│  E  │                            │
│  B  │                            │
│  A  │                            │
│  R  │                            │
│     │                            │
└─────┴────────────────────────────┘
```
- Sidebar : 72px (collapsed) / 256px (expanded)
- Main content : `calc(100vw - sidebar-width)`
- Gap : 0 (sidebar fixed position)

**Bottom Tab Layout (Mobile) :**
```
┌──────────────────────────────────┐
│                                  │
│       Main Content               │
│       (Safe area inset)          │
│                                  │
│                                  │
├──────────────────────────────────┤
│  [TAB1] [TAB2] [TAB3] [TAB4] [+] │
└──────────────────────────────────┘
```
- Tab bar height : 64px (iOS safe area)
- Tab height : 56px (Android)
- Main content : `calc(100vh - tab-height)`

---

## Elevation & Depth

### Shadow System

MindForge utilise des ombres subtiles pour créer de la profondeur sans surcharger l'interface dark mode.

| Token               | Value                             | Usage                         |
| ------------------- | --------------------------------- | ----------------------------- |
| shadow-sm           | 0 1px 2px 0 rgb(0 0 0 / 0.05)     | Input fields, subtle cards    |
| shadow              | 0 1px 3px 0 rgb(0 0 0 / 0.1)      | Cards, dropdowns              |
| shadow-md           | 0 4px 6px -1px rgb(0 0 0 / 0.1)   | Modals, popovers              |
| shadow-lg           | 0 10px 15px -3px rgb(0 0 0 / 0.1) | Command Palette, large modals |
| shadow-xl           | 0 20px 25px -5px rgb(0 0 0 / 0.1) | Full-screen overlays          |
| shadow-glow-violet  | 0 0 20px rgba(124, 58, 237, 0.3)  | Focus states, active IA       |
| shadow-glow-emerald | 0 0 20px rgba(16, 185, 129, 0.3)  | Success states, completed     |

### Z-Index Scale

| Layer          | Z-Index | Usage                     |
| -------------- | ------- | ------------------------- |
| base           | 0       | Default layer             |
| dropdown       | 1000    | Dropdowns, tooltips       |
| sticky         | 1020    | Sticky headers, sidebars  |
| modal-backdrop | 1030    | Modal overlays            |
| modal          | 1040    | Modal content             |
| popover        | 1050    | Popovers, command palette |
| toast          | 1060    | Toast notifications       |
| tooltip        | 1070    | Tooltips (highest)        |

### Transitions

**Durées standards :**
- Fast : 150ms (hover states, small changes)
- Normal : 300ms (modals, dropdowns, page transitions)
- Slow : 500ms (major layout changes)

**Easing :**
- `ease-in-out` : Transitions symétriques (modals, overlays)
- `ease-out` : Entrées (dropdowns apparaissent)
- `ease-in` : Sorties (éléments disparaissent)

```css
transition: all 300ms ease-in-out;
```

---

## Skeletons & Transitions Animées (Cinématique de Rendu)

### Squelettes Shimmer & Allumage (The Neural Ignition Reveal — D-UX-002)

```css
@keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

@keyframes synap-pulse {
  0% { transform: scale(0.95); opacity: 0.7; filter: drop-shadow(0 0 5px rgba(124, 58, 237, 0.5)); }
  50% { transform: scale(1.05); opacity: 1.0; filter: drop-shadow(0 0 15px rgba(124, 58, 237, 0.9)); }
  100% { transform: scale(0.95); opacity: 0.7; filter: drop-shadow(0 0 5px rgba(124, 58, 237, 0.5)); }
}

/* Squelette de balayage luminescent pour les Knowledge Cards (M25) */
.mfg-card-skeleton-line {
  height: 12px;
  background: linear-gradient(
    90deg,
    rgba(255, 255, 255, 0.02) 25%,
    rgba(255, 255, 255, 0.08) 50%,
    rgba(255, 255, 255, 0.02) 75%
  );
  background-size: 200% 100%;
  animation: shimmer 1.6s infinite linear;
  border-radius: 4px;
}

/* Conteneur de carte en verre dépoli (Pending State) */
.mfg-knowledge-card-pending {
  background: rgba(11, 15, 30, 0.55);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.06);
  padding: 16px;
  border-radius: 12px;
  width: 240px;
  height: 320px;
}
```

### Rendu d'Équations Mathématiques KaTeX (D-QUAL-004)

```css
.mfg-katex-block {
  font-family: "KaTeX_Main", "KaTeX_Math", sans-serif;
  font-size: 1.1em;
  padding: 12px;
  background: rgba(255, 255, 255, 0.02);
  border-radius: 8px;
  overflow-x: auto; /* Anti-clipping sémantique */
  border-left: 3px solid #7c3aed; /* Accroche violette AI */
}
```

## Shapes

### Border Radius

| Token        | Value    | Px  | Usage                            |
| ------------ | -------- | --- | -------------------------------- |
| rounded-sm   | 0.125rem | 2   | Inputs, badges                   |
| rounded      | 0.25rem  | 4   | Buttons, small cards             |
| rounded-md   | 0.375rem | 6   | Cards, panels                    |
| rounded-lg   | 0.5rem   | 8   | Modals, large cards              |
| rounded-xl   | 0.75rem  | 12  | Hero cards, featured content     |
| rounded-2xl  | 1rem     | 16  | Onboarding cards, demos          |
| rounded-full | 9999px   | ∞   | Avatar, circular buttons, badges |

### Border Widths

- Default : 1px
- Thick : 2px (focus states, active borders)
- None : 0px

### Border Colors

- `border-default` : #374151 (Gris moyen)
- `border-hover` : #4B5563 (Gris clair)
- `border-focus` : #7C3AED (Violet — focus visible)

---

## Components

### Button

#### Variants

**Primary (Violet) :**
```css
bg: #7C3AED
text: #FFFFFF
hover: #6D28D9
shadow: shadow-md
rounded: rounded-md
padding: space-3 space-6
font: font-medium
```

**Secondary (Cyan) :**
```css
bg: #06B6D4
text: #FFFFFF
hover: #0891B2
shadow: shadow-sm
rounded: rounded-md
padding: space-3 space-6
font: font-medium
```

**Success (Emerald) :**
```css
bg: #10B981
text: #FFFFFF
hover: #059669
shadow: shadow-sm
rounded: rounded-md
padding: space-3 space-6
font: font-medium
```

**Ghost (Transparent) :**
```css
bg: transparent
text: #F3F4F6
border: 1px solid #374151
hover-bg: #1A1A25
rounded: rounded-md
padding: space-3 space-6
font: font-medium
```

**Danger (Or — usage limité) :**
```css
bg: #D97706
text: #FFFFFF
hover: #B45309
shadow: shadow-sm
rounded: rounded-md
padding: space-3 space-6
font: font-medium
```

#### Sizes

| Size | Padding         | Text Size | Height |
| ---- | --------------- | --------- | ------ |
| sm   | space-2 space-4 | text-sm   | 32px   |
| md   | space-3 space-6 | text-base | 40px   |
| lg   | space-4 space-8 | text-lg   | 48px   |

#### States

- **Default** : Couleur normale
- **Hover** : Couleur +10% plus foncée
- **Active** : Couleur +20% plus foncée, `scale(0.98)`
- **Focus** : `ring-2 ring-violet ring-offset-2`
- **Disabled** : `opacity-50 cursor-not-allowed`
- **Loading** : Spinner animé, `cursor-wait`

### Card

```css
bg: #0D0D15 (bg-card)
border: 1px solid #374151
rounded: rounded-lg
padding: space-6
shadow: shadow-md
hover: border-hover (#4B5563)
transition: 300ms ease-in-out
```

**Card Header :**
```css
padding-bottom: space-4
border-bottom: 1px solid #374151
```

**Card Body :**
```css
padding-top: space-4
```

**Card Footer :**
```css
padding-top: space-4
border-top: 1px solid #374151
```

### Input

```css
bg: #0D0D15
border: 1px solid #374151
text: #F3F4F6
rounded: rounded-md
padding: space-3 space-4
font: text-base
placeholder: #6B7280
```

**States :**
- **Focus** : `border-violet ring-2 ring-violet/20`
- **Error** : `border-alert ring-2 ring-alert/20`
- **Success** : `border-success ring-2 ring-success/20`
- **Disabled** : `bg-gray-800 opacity-50 cursor-not-allowed`

### Badge

**Variants :**

| Variant | Background | Text    | Usage             |
| ------- | ---------- | ------- | ----------------- |
| Default | #1A1A25    | #9CA3AF | General tags      |
| Violet  | #7C3AED/20 | #7C3AED | IA, brand         |
| Emerald | #10B981/20 | #10B981 | Success, mastered |
| Cyan    | #06B6D4/20 | #06B6D4 | Info, progress    |
| Or      | #D97706/20 | #D97706 | Warning, critical |

```css
padding: space-1 space-3
rounded: rounded-full
font: text-xs font-medium
```

### Sidebar

**Desktop (Collapsed 72px) :**
```css
width: 72px
bg: #0D0D15
border-right: 1px solid #374151
padding: space-4
```

**Desktop (Expanded 256px) :**
```css
width: 256px
bg: #0D0D15
border-right: 1px solid #374151
padding: space-6
```

**Item actif :**
```css
bg: #1A1A25
border-left: 3px solid #7C3AED
text: #7C3AED
```

### Modal

```css
backdrop: rgba(5, 5, 10, 0.75)
bg: #0D0D15
border: 1px solid #374151
rounded: rounded-xl
shadow: shadow-xl
padding: space-8
max-width: 640px (md) | 800px (lg) | 1024px (xl)
```

**Modal Header :**
```css
padding-bottom: space-6
border-bottom: 1px solid #374151
```

**Modal Footer :**
```css
padding-top: space-6
border-top: 1px solid #374151
display: flex
justify-content: flex-end
gap: space-4
```

### Tooltip

```css
bg: #1A1A25
text: #F3F4F6
rounded: rounded-md
padding: space-2 space-3
font: text-sm
shadow: shadow-md
z-index: 1070
max-width: 256px
```

**Arrow :** 8px triangle matching background

### Évaluation & Examens (SurveyJS Form Library)

```css
/* Intégration chromatique du runner SurveyJS (MIT) */
.mfg-survey-dark-root {
  background-color: #0d0d15;
  border-radius: 12px;
  padding: 24px;
  border: 1px solid #374151;
}

.mfg-survey-dark-q-title {
  font-family: 'Inter', sans-serif;
  color: #f3f4f6;
  font-size: 1rem;
  font-weight: 500;
  line-height: 1.5;
  max-width: 65ch; /* Règle d'or de lecture */
}
```

### BRAIN Panel Components

Les composants du panneau BRAIN héritent du design system mais ont des caractéristiques visuelles spécifiques :

#### Context Header

```css
bg: {bg-card}
border-bottom: 1px solid {border-default}
padding: space-4
```

**Context indicators par scope :**
- Document : Icône 📄, color {color-info}
- Concept : Icône 💡, color {color-alert}
- Roadmap : Icône 🗺️, color {color-success}
- Global : Icône 🌐, color {text-secondary}

#### Suggested Prompt Chip

```css
bg: {bg-card}
border: 1px solid {border-default}
rounded: rounded-lg
padding: space-3 space-4
font: text-sm
hover-bg: {bg-hover}
hover-border: {color-ai}
hover-transform: translateX(2px)
transition: 150ms ease
```

**Arrow icon :**
- Opacity 0 default
- Opacity 1 on hover
- Color {text-muted}

#### Message Bubbles

**User message :**
```css
avatar-bg: {color-info}/20
avatar-color: {color-info}
text: {text-primary}
font: text-base
```

**Assistant message :**
```css
avatar-bg: {color-ai}/20
avatar-color: {color-ai}
text: {text-primary}
font: text-base
```

**Code blocks (markdown) :**
```css
bg: #1A1A25
padding: space-4
rounded: rounded-lg
font: font-mono text-sm
```

**Citation badges :**
```css
bg: {bg-card}
border: 1px solid {border-default}
rounded: rounded-full
padding: space-1 space-2
font: text-xs font-semibold
color: {color-ai}
hover-bg: {color-ai}
hover-color: white
hover-transform: scale(1.05)
```

#### BRAIN Input

```css
bg: {bg-card}
border: 1px solid {border-default}
rounded: rounded-lg
padding: space-3
font: text-base
min-height: 44px
max-height: 120px (5 lignes)
resize: none (auto-expand vertical)
```

**Focus state :**
```css
border: 1px solid {color-ai}
ring: 2px {color-ai}/20
```

**Send button :**
```css
bg: {color-ai}
text: white
rounded: rounded-md
padding: space-2 space-3
hover-bg: #6D28D9 (violet darker)
disabled-opacity: 0.5
```

---

## Do's and Don'ts

### ✅ Do's

**Couleurs :**
- ✅ Utiliser Emerald (#10B981) pour succès et maîtrise
- ✅ Utiliser Or (#D97706) pour points à réviser (pas rouge)
- ✅ Respecter la règle 60-30-10 (fonds/surfaces/accents)
- ✅ Associer chaque module à sa couleur signature

**Typographie :**
- ✅ Utiliser Inter pour interface (lisibilité écran)
- ✅ Utiliser JetBrains Mono pour code et logs
- ✅ Respecter l'échelle typographique (multiples de 4px)
- ✅ Maintenir contraste minimum WCAG AA (4.5:1)

**Espacement :**
- ✅ Utiliser l'échelle de spacing (multiples de 4px)
- ✅ Espacements consistents entre éléments similaires
- ✅ Respirer les interfaces (généreux padding cartes)

**Interactions :**
- ✅ Feedback immédiat sur hover/click (<100ms)
- ✅ Transitions fluides (300ms ease-in-out)
- ✅ Focus states visibles (ring violet)
- ✅ Loading states pour opérations >500ms

### ❌ Don'ts

**Couleurs :**
- ❌ Ne jamais utiliser rouge pur pour erreurs d'apprentissage
- ❌ Éviter plus de 3 couleurs d'accent simultanées
- ❌ Ne pas mélanger couleurs chaudes (sauf Or critique)
- ❌ Ne pas utiliser texte gris <#6B7280 sur #05050A (contraste insuffisant)

**Typographie :**
- ❌ Ne pas descendre sous text-xs (12px) sauf exceptions
- ❌ Éviter plus de 3 poids de police dans une vue
- ❌ Ne pas utiliser ALL CAPS sauf acronymes courts
- ❌ Éviter italique pour texte long (fatigue visuelle)

**Espacement :**
- ❌ Ne pas utiliser valeurs arbitraires (respecter l'échelle)
- ❌ Éviter espacement négatif sauf cas très spécifiques
- ❌ Ne pas coller bordures d'écran (min 16px padding mobile)

**Interactions :**
- ❌ Ne pas bloquer l'UI pour opérations <3 secondes
- ❌ Éviter animations >500ms (sauf transitions majeures)
- ❌ Ne pas désactiver focus outlines (accessibilité)
- ❌ Éviter hover states sur mobile (touch only)

---

## Platform-Specific Considerations

### Desktop (Windows, macOS, Linux)

- **Window controls** : Respecter conventions OS (traffic lights macOS, close button Windows)
- **Keyboard shortcuts** : ⌘K (macOS) / Ctrl+K (Windows/Linux) pour Command Palette
- **Scrollbars** : Style custom dark pour cohérence visuelle
- **Context menus** : Right-click menus natifs

### Web (SaaS)

- **Responsive breakpoints** :
  - Mobile : <768px
  - Tablet : 768px-1024px
  - Desktop : >1024px
- **PWA** : Installable, offline-capable (ServiceWorker)
- **Safe areas** : Respecter notches et bordures arrondies

### Mobile (iOS, Android)

- **Safe area insets** : iOS notch/Dynamic Island, Android status bar
- **Bottom tab bar** : 64px (iOS) / 56px (Android)
- **Touch targets** : Minimum 44×44px (iOS) / 48×48px (Android)
- **Haptic feedback** : Vibrations subtiles sur actions importantes
- **Gestures** : Swipe horizontal entre modules, pull-to-refresh

---

## References

### Design System Inspirations

- **Tailwind CSS** : Token-based design system
- **Radix UI** : Accessible primitives
- **shadcn/ui** : Component architecture
- **Linear** : Dark mode excellence
- **Obsidian** : Content-first design



## 11. Compléments Spatiaux Élite & Design Neuroscientifique (v3.0)

### 11.1 Palette Chromatique Spatiale Unifiée
- **Noir d'Encre Abyssal (`#020205` / `#05050A`)** : Arrière-plan principal de la constellation.
- **Violet Profond Sémantique (`#1E1B4B` / `rgba(30,27,75,0.3)`)** : Structure de support, matière grise d'arrière-plan, axones de liens calmes.
- **Bleu Électrique Actif (`#2563EB` / `#60A5FA`)** : Influx nerveux en transit, nœud actif, lueurs de surchauffes cognitives ($T_n \ge 60^\circ	ext{C}$).
- **Émeraude Synaptique Consolidée (`#10B981` / `#059669`)** : Indique une mémorisation stable à long terme (rétention FSRS $\ge 90\%$).
- **Blanc Lumineux Intense (`#FFFFFF`)** : Nœud sélectionné ou survolé par le pointeur.
- **Gris Axonal (`#475569` / `#64748B`)** : Nœuds froids, dormants ou en attente d'assimilation.

### 11.2 Spécifications de Rendu du Graphe "Force-Cerveau" (COSMOS Mode 26)
- **Contrainte d'Enveloppe Cérébrale** : Tracé en pointillés violet translucide (`rgba(30, 27, 75, 0.2)`) selon l'Équation de Sagittal de MindForge.
- **Lueur Synaptique** : Gradient radial de lueur active bleue ou émeraude proportionnelle à la température thermodynamique du nœud.
- **Animation de Respiration** : Micro-oscillation sinusoïdale ondulatoire imitant les battements de la pensée biologique en tâche de fond.

### 11.3 Séquence d'Allumage Neural (The Neural Ignition Reveal)
1. **Constellation WebGL** : Allumage de la grille tridimensionnelle en bleu nuit spatial (`#0D0D15`).
2. **Étincelle des Hubs** : Jaillissement en Or impérial (`#D97706`) des suggestions de livrables d'ingestion.
3. **Condensation des Cartes** : Shimmer localisé masquant les temps de traitement de la Neuro-Chain Rust.
4. **Stabilisation finale** : Transition du flou à net à 60 FPS constants et affichage de LaTeX/KaTeX local.

### Color Science

- **WCAG 2.1** : Contrast ratios, accessibility
- **Color psychology** : Emotion and learning associations
- **Neuro-ergonomics** : Visual fatigue reduction

### Tools

- **Figma** : Design prototypes
- **Tailwind CSS** : Implementation framework
- **React** : Component library
- **Storybook** : Component documentation

**Document Status :** Final  
**Version :** 1.0.0  
**Last Updated :** 2026-06-03  
**Next Review :** Before implementation phase starts

**Maintainers :** Joy (Product Owner)  
**Approval Required :** Before implementation phase

**Related Documents :**
- {EXPERIENCE.md} : User experience patterns and key flows
- {.decision-log.md} : UX decisions log (6 major decisions)
- {BRAIN-PANEL-COMPONENTS-SPEC.md} : Technical component specifications
- {extraction-sources.md} : Technical specifications extracted
- {ux-design-questions-reponse.md} : Detailed flows and navigation

---

*Ce document est la référence contractuelle pour l'implémentation visuelle de MindForge. En cas de conflit entre ce document et tout wireframe, mock ou import, ce document prévaut.*

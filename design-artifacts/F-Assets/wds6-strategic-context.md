# SCY Forge — WDS-6 STRATEGIC CONTEXT
_Étape 06 — Assets & Visual Narratives_
_Source : `design-artifacts/E-Copywriting/*` + `minddoc/s00_design/scy_design_system.md`_
_Version : 1.0_

---

## 1. Résumé exécutif

**WDS-6** produit les assets visuels et guidelines pour chaque scénario WDS-4/WDS-5.

### Livrables
- Image generation prompts (DALL·E / Flux / Stable Diffusion)
- Motion graphics prompts (Luma / Runway)
- Audio cues (ElevenLabs)
- Structured media prompts (typography, color, composition)
- Brand consistency rules (SCY Forge visual identity)

---

## 2. Visual Identity SCY Forge

### Palette
- **Primary** : `#0A0A0A` (dark bg)
- **Secondary** : `#141414` (elevated)
- **Accent** : `#00E5A0` (primary accent)
- **Accent secondary** : `#0099FF` (info)
- **Error** : `#FF4466`
- **Warning** : `#FFB020`
- **Text primary** : `#F5F5F5`
- **Text secondary** : `#A0A0A0`

### Typography
- **Headings** : Inter (700/600)
- **Body** : Inter (400)
- **Monospace** : JetBrains Mono (logs, code)

### Style
- Dark-first
- Minimal gradients
- Rounded corners 8px
- Subtle shadows
- 2px borders max
- No decorative noise

---

## 3. Tones visuels par module

| Module | Tone |
|--------|------|
| Auth | Clean, minimal, trustworthy |
| Dashboard | Organized, bright, actionable |
| INGEST | Technical, precise, fast |
| NEURON/APEX | Academic, calm, focused |
| COSMOS | Vast, exploratory, scientific |
| BRAIN | Conversational, warm, intelligent |
| ASCENT | Industrial, orchestrated, robust |
| B2B | Professional, enterprise, clean |
| Finance | Precise, authoritative, financial |

---

## 4. Image prompts (extraits)

### Auth background
```
Minimalist dark UI background for AI learning platform.
Deep black (#0A0A0A) with subtle gradient.
Abstract neural network lines in #00E5A0 (10% opacity).
Clean, no text, no people, no hands.
Style: Apple Bento grid, minimal, 2026.
```

### Dashboard hero
```
Hero illustration for AI learning dashboard.
3D floating cards representing learning modules.
Soft lighting, dark mode aesthetic.
Color palette: #0A0A0A, #141414, #00E5A0.
No text, no hands, no faces.
Style: Linear.app, premium dark UI.
```

### INGEST in action
```
File upload animation for data ingestion.
Documents flowing into a data pipeline.
Tech-inspired, clean lines, dark background.
Accent color: #0099FF.
Silent video loop concept.
```

### COSMOS exploration
```
Conceptual knowledge graph visualization.
Nodes and edges floating in dark space.
Scientific, academic aesthetic.
Colors: #00E5A0, #0099FF on #0A0A0A.
No decorative elements.
```

---

## 5. Motion graphics prompts

### APEX flashcards
```
Smooth card flip animation for flashcard app.
Dark background, minimal shadow.
Card reveals back side with gradient accent.
Duration: 0.8s ease-in-out.
No text, no hands.
```

### ASCENT pipeline
```
Pipeline orchestration animation.
Agents as glowing nodes connected by flowing lines.
Industrial, data-driven aesthetic.
Colors: #00E5A0 for success, #FF4466 for error.
```

---

## 6. Audio cues

| Scenario | Cue | Mood |
|----------|-----|------|
| Ingest complete | Soft chime | Success, calm |
| Apex session | Click | Focus, neutral |
| Error | Soft buzz | Alert, non-intrusive |
| Notification | Gentle ping | Info, polite |

---

## 7. Structured media rules

### Image generation rules
- **Never** show hands, faces, or people
- **Always** dark-first
- **Maximum** 2 colors per image (primary + accent)
- **No text** in generated images
- **Style references** : Linear.app, Apple, Vercel

### Asset naming convention
```
{module}-{scenario}-{type}-{variant}.{ext}
Ex: apex-sc022-card-flip-dark.mp4
```

---

## 8. WDS-6 workflow

```
WDS-6 — ASSETS
═══════════════════════════════════════════════════════════

 Phase            WDS Skill          Deliverable                     Statut
 ─────────────────────────────────────────────────────────────
 [TERMINÉ]    WDS-3 Scenarios      87 scénarios outlines            ✅
 [TERMINÉ]    WDS-4 UX Design      87 scénarios UX                 ✅
 [TERMINÉ]    WDS-5 Copywriting    87 scénarios copy               ✅
 [EN COURS]   WDS-6 Assets         87 scenarios_assets             🔄
 [TERMINÉ]    WDS-7 Design System  tokens + primitives              ✅
 [À VENIR]    WDS-8 Evolution      roadmap.md + hypotheses.md       ⏳
```

---

## Traçabilité WDS-6

| Fichier | Phase | Rôle |
|---------|-------|------|
| `design-artifacts/E-Copywriting/batch-*-*.md` | WDS-5 | Copy sources |
| `design-artifacts/F-Assets/wds6-strategic-context.md` | WDS-6 | Contexte et règles visuelles |
| `design-artifacts/F-Assets/batch-*-*.md` | WDS-6 | Prompts par scénario |

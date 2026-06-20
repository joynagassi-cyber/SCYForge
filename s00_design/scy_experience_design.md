---
status: final
version: 1.0.1
updated: 2026-06-03
project: SCY Forge
platforms: [web, desktop-windows, desktop-macos, desktop-linux, mobile-ios, mobile-android]
design-reference: DESIGN.md
sources: [extraction-sources.md, ux-design-questions-reponse.md, .decision-log.md]
p0-fixes-integrated: [COSMOS-web-worker, code-splitting, text-scaling-responsive, memory-cleanup]
review-score: 80/100
review-synthesis: review-synthesis.md
---

# SCY Forge Experience Design

**Version :** 1.0.0  
**Date :** 2026-06-02  
**Objectif :** Définir l'architecture d'information, les comportements, les états, les interactions et les parcours utilisateurs de SCY Forge

---

## Foundation

### Form-Factor & Platforms

**6 plateformes supportées :**

1. **Web SaaS** : React 18 SPA, cloud-native, PostgreSQL Northflank
2. **Desktop Windows** : Electron 33, SQLite local, offline-first
3. **Desktop macOS** : Electron 33, SQLite local, offline-first
4. **Desktop Linux** : Electron 33, SQLite local, offline-first
5. **Mobile iOS** : Capacitor 6, SQLite local, offline-first
6. **Mobile Android** : Capacitor 6, SQLite local, offline-first

### UI System

**Frameworks :**


**Référence visuelle :** {DESIGN.md}

### Architecture Unifiée

```
"Une architecture unifiée, trois plateformes, un seul backend"
```

- **Backend Rust IDENTIQUE** pour Desktop/Web/Mobile
- **Seul `STORAGE_MODE` change** : `local` (Desktop/Mobile) vs `cloud` (Web)
- **Frontend React PARTAGÉ** avec feature-detect plateforme

---

## Information Architecture

### La Double Colonne Vertébrale

SCY Forge s'articule autour de **deux routes majeures et distinctes** :

#### 📥 Route 1 : INGEST (Normale) — Flux Entrant

**Nature :** Cycle quotidien d'enrichissement de la base de connaissances

**Flux :**
```
INGEST (11 cores) → LIBRARY (concepts) → COSMOS (visualisation) → APEX (révision) → BRAIN (RAG)
```

**Caractéristiques :**
- Flux entrant : externe → interne
- Objectif : enrichir la base de connaissances
- Rythme : quotidien, variable
- Progression : non linéaire, exploratoire
- Métrique : nombre de documents/concepts

#### 🎯 Route 2 : ASCENT (Ascendante) — Flux Orienté Objectif

**Nature :** Parcours linéaire de progression vers maîtrise certifiée

**Flux :**
```
Objectif → DAG (25 nœuds) → SMI tracking → APEX par nœud → Certification
```

**Caractéristiques :**
- Flux ascendant : ignorance → maîtrise
- Objectif : certifier une compétence
- Rythme : structuré, progressif
- Progression : linéaire, nœud par nœud
- Métrique : SMI ×5 dimensions

### Les 6 Modules Principaux

| Module  | Route  | Entrée        | Sortie                   | Dépendances     |
| ------- | ------ | ------------- | ------------------------ | --------------- |
| INGEST  | INGEST | URLs externes | scy_sources + documents  | —               |
| LIBRARY | INGEST | Documents     | scy_concepts + relations | INGEST          |
| COSMOS   | INGEST | Concepts      | Visualisation (8 modes)  | LIBRARY         |
| APEX    | DUAL   | Concepts      | Flashcards + reviews     | LIBRARY         |
| ASCENT  | ASCENT | Objectif user | DAG + certification      | LIBRARY + APEX  |
| BRAIN   | DUAL   | Question user | Réponse RAG              | LIBRARY + COSMOS |

**DUAL** = Module utilisable depuis les 2 routes

### Matrice de Navigation Inter-Modules

| De \ Vers   | INGEST          | LIBRARY          | COSMOS         | APEX           | ASCENT           | BRAIN       |
| ----------- | --------------- | ---------------- | ------------- | -------------- | ---------------- | ----------- |
| **INGEST**  | —               | Auto post-ingest | Ouvrir graphe | Générer cartes | Créer objectif   | —           |
| **LIBRARY** | Ré-ingérer      | —                | Visualiser    | Générer cartes | Créer objectif   | Questionner |
| **COSMOS**   | —               | Voir source      | —             | —              | Voir dans DAG    | —           |
| **APEX**    | —               | Voir concept     | —             | —              | Sync progression | —           |
| **ASCENT**  | Ingest manquant | Voir prérequis   | Voir DAG      | Réviser nœud   | —                | Questionner |
| **BRAIN**   | —               | Citer source     | —             | —              | —                | —           |

**Hubs principaux :** LIBRARY et ASCENT sont les points de jonction majeurs

---

## Voice and Tone

### Brand Voice

SCY Forge parle comme un **compagnon d'apprentissage expert mais accessible** :

- **Expert sans condescendance** : "Voici ce que j'ai extrait" (pas "Tu devrais apprendre")
- **Encourageant sans infantilisation** : "3 nœuds complétés — continue !" (pas "Bravo champion !")
- **Transparent sur l'IA** : "L'IA a identifié 28 concepts" (pas "Nous avons trouvé...")
- **Orienté action** : "Ingérer ta première source" (pas "Tu peux commencer par ingérer si tu veux")

### Microcopy Guidelines

**Call-to-Actions :**
- ✅ "Ingérer une vidéo YouTube"
- ❌ "Ajouter du contenu"

**États vides :**
- ✅ "Aucun concept encore — ingère ta première source pour commencer"
- ❌ "Aucun élément"

**Succès :**
- ✅ "15 vidéos ingérées — 127 concepts extraits"
- ❌ "Opération réussie"

**Erreurs :**
- ✅ "Cette URL YouTube n'est pas accessible — vérifie qu'elle est publique"
- ❌ "Erreur 404"

**Progress :**
- ✅ "3/15 vidéos analysées — 8 min restantes"
- ❌ "Chargement..."

### Tone par Contexte

| Contexte             | Tone                     | Exemple                                     |
| -------------------- | ------------------------ | ------------------------------------------- |
| Onboarding           | Welcoming, explorateur   | "Explore ce projet démo, puis crée le tien" |
| Succès apprentissage | Encourageant, factuel    | "SMI 72/100 — nœud débloqué !"              |
| Erreur système       | Transparent, actionnable | "Sync échoué — réessai dans 30s"            |
| Feedback IA          | Neutre, informatif       | "L'IA suggère 3 concepts reliés"            |
| Certification        | Formel, affirmatif       | "Compétence certifiée — 25 nœuds maîtrisés" |

---

## Component Patterns

### BRAIN Panel Components

SCY Forge intègre un assistant IA contextuel (BRAIN) inspiré de NotebookLM, accessible en permanence via un panneau latéral. Les composants suivants définissent les comportements et interactions du BRAIN panel.

#### BrainContextHeader

**Purpose :** Affiche le contexte actuel à l'utilisateur, montrant ce que BRAIN "sait" sur l'état du module actif.

**Visual Pattern :**
```
┌────────────────────────────────────────────┐
│ 🎯 Context: Document                       │
│ "The Rust Programming Language"            │
│ Chapter 10 - Generic Types                 │
└────────────────────────────────────────────┘
```

**Comportements :**
- **4 scopes contextuels** :
  - `document` : Document actif dans LIBRARY (icône 📄, {color-info})
  - `concept` : Concept sélectionné dans COSMOS (icône 💡, {color-alert})
  - `roadmap` : Objectif ASCENT actif (icône 🗺️, {color-success})
  - `global` : Contexte général (icône 🌐, {text-secondary})

- **Clear context button** : Visible pour tous scopes sauf `global`, retour à contexte général

- **Payload-specific details** :
  - Document : Titre, chapitre, type, word count
  - Concept : Nom, profondeur, nombre prérequis
  - Roadmap : Objectif, completion %, SMI moyen

#### SuggestedPrompts

**Purpose :** Affiche des suggestions contextuelles de questions comme chips cliquables pour réduire friction.

**Visual Pattern :**
```
┌─────────────────────────────────────────────┐
│ 💡 Try asking:                              │
│                                             │
│ [Résume ce document en 3 points]            │
│ [Quels sont les concepts clés ?]            │
│ [Génère un flashcard pour ce passage]       │
└─────────────────────────────────────────────┘
```

**Comportements :**
- **Génération dynamique** basée sur contexte :
  - `document` : "Résume...", "Concepts clés", "Génère flashcards", "Explique comme si j'avais 12 ans"
  - `concept` : "Explique autrement", "Donne exemple concret", "Prérequis ?", "Crée mnémotechnique"
  - `roadmap` : "Prochaine étape optimale", "Pourquoi cet ordre ?", "Temps restant", "Points faibles"
  - `global` : "Documents récents", "Stats apprentissage", "Suggère objectif", "Révisions du jour"

- **Interactions** :
  - Click sur chip → remplit automatiquement input BRAIN et envoie
  - Max 4 prompts visibles par défaut
  - Bouton "Show N more" si >4 prompts
  - Hover : Flèche → apparaît, chip translate +2px

- **Analytics tracking** : Track `suggested_prompt_clicked` avec context_scope et prompt_text

#### BrainMessageList

**Purpose :** Affiche la conversation avec markdown rendering, streaming support, et citations cliquables.

**Visual Pattern :**
```
┌──────────────────────────────────────────┐
│ 👤 You                                   │
│ Explique les lifetimes en Rust          │
└──────────────────────────────────────────┘

┌──────────────────────────────────────────┐
│ 🤖 BRAIN                                 │
│ Les lifetimes sont des annotations...   │
│                                          │
│ ```rust                                  │
│ fn longest<'a>(x: &'a str, y: &'a str)  │
│ ```                                      │
│                                          │
│ Sources: [1] [2] [3]                     │
└──────────────────────────────────────────┘
```

**Comportements :**
- **Auto-scroll** : Scroll automatique vers bottom quand nouveau message arrive
- **Markdown support** complet :
  - Code blocks avec syntax highlighting (Prism oneDark theme)
  - Tables responsives avec scroll horizontal
  - Blockquotes avec bordure gauche {color-ai}
  - Links externes : `target="_blank" rel="noopener"`

- **Streaming support** :
  - SSE (Server-Sent Events) via `/api/brain/messages/:id/stream`
  - Content arrive chunk par chunk
  - Streaming indicator : 3 dots animés avec pulse
  - `isComplete` flag quand done

- **Citations** :
  - Affichées en bas du message assistant uniquement
  - Format badge `[1] [2] [3]`
  - Click → Navigate vers document source + highlight chunk
  - Hover → Tooltip avec titre document complet
  - Transition scale 1.05 sur hover

- **Message states** :
  - User messages : Avatar bleu {color-info}, align left
  - Assistant messages : Avatar violet {color-ai}, align left
  - Timestamp : Format relatif ("2 min ago", "1h ago")

#### BrainInput

**Purpose :** Input zone pour poser questions à BRAIN avec support multi-lignes et shortcuts clavier.

**Comportements :**
- **Textarea auto-expand** : Min 1 ligne, max 5 lignes, puis scroll
- **Keyboard shortcuts** :
  - `Enter` : Envoyer (si non-empty)
  - `Shift+Enter` : Nouvelle ligne
  - `Cmd/Ctrl+K` : Clear input
  - `Esc` : Clear focus

- **States** :
  - Empty : Placeholder "Ask BRAIN anything..."
  - Typing : Border {border-focus}
  - Sending : Disabled + spinner dans button
  - Error : Border {color-alert} + error message

- **Voice input (optionnel)** : Icône microphone pour speech-to-text (Web Speech API)

#### Responsive BRAIN Panel

**Desktop (>1024px) :**
- Panneau fixe 360px (420px sur >1440px)
- Toujours visible sauf modules immersifs (COSMOS, ASCENT)
- Toggle avec `Cmd/Ctrl+B`

**Tablet (768-1024px) :**
- Panneau collapsible par défaut (0px width)
- Toggle button fixe right edge
- Width 320px quand ouvert (overlay sur contenu)

**Mobile (<768px) :**
- Bottom sheet avec snap points [20%, 50%, 90%]
- Floating action button (FAB) bottom-right pour ouvrir
- Swipe down pour fermer ou réduire
- Keyboard avoidance : Input monte avec clavier

### Navigation Patterns

#### Sidebar (Desktop/Web)

**Structure :**
```
┌─────────────────┐
│ 🎯 SCY Forge   │  Logo + projet
├─────────────────┤
│ 📥 INGEST      │  Cyan accent si actif
│ 📚 LIBRARY     │
│ 🧠 COSMOS       │
│ ⚡ APEX        │
│ 🎯 ASCENT      │
│ 🔮 BRAIN       │
├─────────────────┤
│ 🔔 Activity    │  Badge si opérations actives
│ ⚙️  Settings   │
│ 👤 Profil      │
└─────────────────┘
```

**Comportements :**
- **Collapsed (72px)** : Icônes uniquement, tooltip sur hover
- **Expanded (256px)** : Icônes + labels
- **Toggle** : Click sur logo ou Cmd+B
- **Module actif** : Bordure gauche violette {color-ai}, background {bg-hover}

**Responsive :**
- Desktop : toujours visible
- Tablet : auto-collapse, overlay sur contenu
- Mobile : hidden, remplacé par bottom tab bar

#### Bottom Tab Bar (Mobile)

**Structure :**
```
┌──────────────────────────────────┐
│  [INGEST] [COSMOS] [APEX] [ASCENT] [···] │
└──────────────────────────────────┘
```

**5 tabs :**
1. INGEST (📥)
2. COSMOS (🧠)
3. APEX (⚡)
4. ASCENT (🎯)
5. More (···) → ouvre drawer avec LIBRARY, BRAIN, Settings, Profil

**Comportements :**
- **Tab actif** : Icône {color-ai}, label {text-primary}
- **Tab inactif** : Icône {text-secondary}, label {text-muted}
- **Badge** : Nombre opérations actives sur More
- **Swipe** : Geste horizontal entre tabs adjacents
- **Haptic** : Feedback subtil sur tab change

#### Command Palette (⌘K)

**Déclencheurs :**
- Cmd+K (macOS) / Ctrl+K (Windows/Linux)
- Click sur search icon navbar
- Type '/' dans n'importe quelle vue

**Comportements :**
- **Overlay** : backdrop {rgba(5, 5, 10, 0.75)}, z-index 1050
- **Input** : Autofocus, fuzzy search
- **Résultats** : Groupés par catégorie (Navigation, Actions, Recherche)
- **Keyboard nav** : ↑↓ pour naviguer, Enter pour sélectionner, Esc pour fermer
- **Recent** : Dernières 5 commandes en haut

**Commandes supportées :**
- `Ouvrir COSMOS Graph 2D`
- `Ingérer vidéo YouTube`
- `Réviser maintenant`
- `Objectif ASCENT actif`
- `Rechercher concept 'Tokio'`
- `Exporter Roadmap PNG`
- `Activity Center`
- `Mode sombre`

### Card Patterns

#### Concept Card (LIBRARY, COSMOS)

**Structure :**
```
┌─────────────────────────────────┐
│ 🏷️ Tokio Runtime            │  Nom + icône domaine
│ Programming · Rust             │  Domaine + tag
│                                 │
│ SMI: 67/100 ████████░░          │  Gauge SMI avec couleur
│                                 │
│ Définition: Runtime async...    │  100 chars max
│                                 │
│ [Voir détails] [APEX] [ASCENT] │  Actions
└─────────────────────────────────┘
```

**États :**
- **Default** : {bg-card}, {border-default}
- **Hover** : {border-hover}, cursor-pointer
- **Active** : {border-focus}

#### Source Card (INGEST)

**Structure :**
```
┌─────────────────────────────────┐
│ ▶️ YouTube: Rust Async Basics  │  Type + titre
│ youtube.com/watch?v=...         │  URL tronquée
│                                 │
│ ✅ Done · 2h ago                │  Status + timestamp
│ 127 concepts extraits           │  Métriques
│                                 │
│ [Voir dans LIBRARY]             │  Action
└─────────────────────────────────┘
```

**Status visuel :**
- `pending` : Icône horloge {text-secondary}
- `processing` : Spinner {color-info}
- `done` : Checkmark {color-success}
- `error` : Alert icon {color-alert} + tooltip error_msg

#### ASCENT Node Card (Roadmap)

**Structure :**
```
┌─────────────────────────────────┐
│ 🎯 Phase 3: Tokio               │  Phase + label
│                                 │
│ SMI: 72/100 ████████░░          │  Gauge SMI
│                                 │
│ Prérequis: 2/2 ✅               │  Prérequis satisfied
│                                 │
│ [Réviser] [Exercice]            │  Actions
└─────────────────────────────────┘
```

**4 états visuels :**
- `locked` : {bg-gray-300}, icône cadenas, opacity 0.6
- `unlocked` : {color-info}, icône déverrouillé
- `in_progress` : {color-alert}, icône en cours
- `completed` : {color-success}, icône checkmark

#### APEX 3D Holographic Socratic Card (APEX Module)

**Concept de design** :  
Une carte physique, lourde, tactile et immersive. Elle est conçue comme un projecteur holographique que l'utilisateur pourrait virtuellement "tenir dans sa main".

**Comportement 3D & Parallaxe** :
- **Perspective Wrapper** : Conteneur doté d'une perspective de `1500px`.
- **Interactions 3D au pointeur** : Le survol de la souris incline légèrement la carte de manière bidirectionnelle selon les coordonnées relatives du curseur (angles de tangage et de roulis calculés dynamiquement), renforçant l'effet de présence tridimensionnelle.
- **Retournement Trigonométrique 3D** : Cliquer sur la carte ou appuyer sur la touche [Espace] déclenche une rotation horizontale complète lente de `180deg` (autour de l'axe vertical Y) en `1.4s` avec une transition organique d'amortissement (`cubic-bezier(0.2, 1, 0.3, 1)`).
- **Feuilles Multi-Couches en 3D (translateZ)** :
  - Les éléments textuels et fonctionnels sont projetés vers l'avant à l'aide de la translation d'axe Z pour flotter virtuellement au-dessus du verre de la carte :
    - Catégorie / Métadonnées : `translateZ(40px)`
    - Question / Réponse socratique : `translateZ(75px)` (projection maximale)
    - Bouton "Révéler" / Boutons d'intervalles FSRS : `translateZ(50px)`

**Arrière-plan Neural Actif** :
- Un arrière-plan de l'écran composé d'une constellation 3D de particules neuronales tourne lentement (Canvas 3D).
- **Rétroaction Synaptique** : Lors du retournement de la carte ou de la validation d'une révision APEX, les synapses du cerveau d'arrière-plan subissent une décharge de luminosité (flash) et une accélération de rotation de manière organique.
- **Balayage Laser (Scanline)** : Au moment de la révélation, une ligne laser néon émeraude (`box-shadow` émeraude) balaie de haut en bas le texte de la réponse pour dissiper un léger effet de flou sémantique d'arrière-plan.

### Modal Patterns

#### Progress Modal (Opérations Longues)

**Structure :**
```
┌─────────────────────────────────┐
│ Ingestion en cours...        [×]│  Titre + close
├─────────────────────────────────┤
│ 7/15 vidéos analysées            │  Progress text
│ ████████████░░░░░░░░░░░          │  Progress bar
│ ~8 min restantes                 │  ETA
│                                 │
│ [Logs]                          │  Toggle logs
│ > Vidéo 7: Extracting concepts  │  Dernières 15 lignes
│ > 23 concepts found              │
│ > Generating embeddings...       │
│                                 │
│        [Annuler]                │  Action
└─────────────────────────────────┘
```

**Comportements :**
- **Non-bloquant** : Utilisateur peut fermer et continuer ailleurs
- **Réouvrable** : Badge navbar indique opérations actives
- **WebSocket** : Updates temps réel via `/ws/progress`
- **Annulation** : Confirme avant d'arrêter l'opération


---

## State Patterns

### Data Loading States

#### Initial Load (First Paint)

**Desktop/Web :**
1. Splash screen (200ms) : Logo + spinner
2. Auth check (300ms) : Vérifie JWT
3. Data hydration (500ms) : Charge données depuis cache/DB
4. Render (100ms) : Affiche UI

**Total target :** <1100ms

**Mobile :**
- Native splash screen (iOS/Android)
- Même flux après splash

#### Subsequent Loads (Navigation)

**Optimistic UI :**
- Affiche layout immédiatement
- Skeleton screens pour contenu
- Data fetch en background
- Replace skeletons quand data arrive

**Skeleton patterns :**
- Text lines : {bg-gray-800} animated pulse
- Cards : {bg-card} with shimmer effect
- Images : {bg-gray-700} placeholder avec icône

#### Empty States

**Pattern général :**
```
┌─────────────────────────────────┐
│                                 │
│         [Icône Large]           │  128×128px, {text-muted}
│                                 │
│   Aucun [élément] encore        │  Titre {text-primary}
│                                 │
│   Brève explication de comment  │  Description {text-secondary}
│   créer le premier élément      │
│                                 │
│   [CTA Principal]               │  Action claire
│                                 │
└─────────────────────────────────┘
```

**Exemples :**
- **LIBRARY vide** : "Aucun concept encore — ingère ta première source"
- **APEX vide** : "Aucune carte générée — crée-les depuis LIBRARY"
- **ASCENT vide** : "Aucun objectif défini — détermine ta prochaine compétence"

### Sync States (Desktop/Mobile Only)

#### Offline Indicator

**Position :** Top navbar, à droite du logo

**États :**
- **Online** : Icône cloud {color-success}, tooltip "Synchronisé"
- **Syncing** : Spinner {color-info}, tooltip "Sync en cours (3/10)"
- **Offline** : Icône cloud barré {text-secondary}, tooltip "Mode hors ligne"
- **Error** : Icône alert {color-alert}, tooltip "Sync échoué — réessai dans 30s"

#### Sync Queue Visibility

**Activity Center** affiche :
```
Sync Queue (7 opérations en attente)
• Review APEX Card #142 → Retry 1/5
• ASCENT Node Completed → Retry 0/5
• Ingestion Source #89 → Retry 2/5
```

#### Conflict Resolution

**Last-Write-Wins :**
- Automatique pour la plupart des cas
- Toast notification si conflit résolu :
  ```
  ⚠️ Conflit résolu: ta dernière révision APEX a été conservée
  ```

### Operation States

#### Status Progression

```
pending → processing → done
                    ↘ error
```

**Indicateurs visuels :**
- `pending` : Horloge {text-secondary}, "En attente..."
- `processing` : Spinner animé {color-info}, progress % si disponible
- `done` : Checkmark {color-success}, "Terminé · [timestamp]"
- `error` : Alert {color-alert}, error_msg + "Réessayer"

#### Long-Running Operations (>3s)

**Feedback requis :**
1. **Immédiat (<100ms)** : Spinner démarre
2. **1s** : Message "Traitement en cours..."
3. **3s** : Progress bar apparaît si % disponible
4. **10s** : ETA affiché si calculable
5. **30s+** : Option "Continuer en arrière-plan"

**WebSocket Events :**
- `IngestStarted` → Modal apparaît
- `IngestProgress` → Progress bar update
- `IngestDone` → Success toast
- `IngestFailed` → Error modal avec détails

---

## Interaction Primitives

### Mouse/Pointer Interactions

#### Click Targets

**Minimum sizes :**
- Desktop : 32×32px (comfortable)
- Touch : 44×44px (iOS) / 48×48px (Android)

**Padding generous :**
- Boutons : {space-3} vertical, {space-6} horizontal
- Icons buttons : {space-2} padding uniform
- Cards : {space-6} padding

#### Hover States

**Timing :**
- Hover detection : 0ms (immédiat)
- Visual feedback : <100ms
- Tooltip apparition : 500ms delay

**Visual changes :**
- Cards : {border-hover}, transition 150ms
- Buttons : Couleur +10% plus foncée, transition 150ms
- Links : {text-primary} → {color-ai}, transition 150ms

#### Focus States

**Keyboard navigation :**
- Tab order logique (top→bottom, left→right)
- Focus ring visible : 2px solid {color-ai}, offset 2px
- Skip links : "Aller au contenu principal"

**States visuels :**
```css
focus-visible {
  outline: none;
  box-shadow: 0 0 0 2px {color-ai}, 0 0 0 4px rgba(124, 58, 237, 0.2);
}
```

### Keyboard Shortcuts

#### Global

| Shortcut    | Action               | Context      |
| ----------- | -------------------- | ------------ |
| ⌘K / Ctrl+K | Command Palette      | Toujours     |
| ⌘B / Ctrl+B | Toggle Sidebar       | Desktop only |
| ⌘N / Ctrl+N | Nouvelle ingestion   | INGEST       |
| Esc         | Fermer modal/overlay | Modal ouvert |
| ? (Shift+/) | Afficher raccourcis  | Toujours     |

#### Navigation

| Shortcut | Action                       |
| -------- | ---------------------------- |
| ⌘1-6     | Sauter au module N           |
| ⌘[       | Module précédent             |
| ⌘]       | Module suivant               |
| ⌘L       | Focus search/command palette |

#### APEX (Session de révision)

| Shortcut | Action                  |
| -------- | ----------------------- |
| Space    | Révéler réponse         |
| 1-4      | Noter difficulté (FSRS) |
| Enter    | Carte suivante          |
| Esc      | Quitter session         |

### Touch Gestures (Mobile)

#### Swipe

**Horizontal (entre modules) :**
- Swipe left : Module suivant
- Swipe right : Module précédent
- Velocity threshold : 200px/s
- Distance threshold : 50px
- Haptic feedback : Impact light

**Vertical (refresh/scroll) :**
- Pull-to-refresh : Swipe down depuis top (>100px)
- Infinite scroll : Approche bottom (<50px remaining)

#### Long Press

**Cards/Items :**
- Duration : 500ms
- Haptic feedback : Impact medium
- Action : Ouvre context menu avec actions secondaires
  - Voir détails
  - Partager
  - Supprimer
  - Exporter

#### Pinch-to-Zoom (COSMOS only)

**Knowledge Graph, Roadmap :**
- Min scale : 0.5x
- Max scale : 2x
- Double-tap : Reset zoom à 1x

### COSMOS Performance Patterns (P0 Fix)

**CRITICAL: These patterns MUST be implemented to support 1000+ nodes**

#### Web Worker + Barnes-Hut Layout

```typescript
//cosmos/workers/layout.worker.ts
import { FA2Layout } from 'graphology-layout-forceatlas2/worker';

self.onmessage = ({ data: { graph, settings } }) => {
  const layout = new FA2Layout(graph, { 
    settings: { ...settings, barnesHutOptimize: true } 
  });
  
  for (let i = 0; i < 500; i++) {
    layout.step();
    if (i % 50 === 0) {
      self.postMessage({ type: 'progress', positions: layout.getPositions() });
    }
  }
  
  self.postMessage({ type: 'complete', positions: layout.getPositions() });
};

// Usage with React 18 Transition
const [isPending, startTransition] = useTransition();
startTransition(() => {
  worker.postMessage({ graph, settings });
});
```

#### Progressive Loading (Chunk Size 200)

```typescript
const CHUNK_SIZE = 200;
for (let i = 0; i < nodes.length; i += CHUNK_SIZE) {
  const chunk = nodes.slice(i, i + CHUNK_SIZE);
  await new Promise(resolve => setTimeout(resolve, 16)); // 1 frame
  chunk.forEach(node => graph.addNode(node.id, node.attributes));
}
```

#### LOD (Level of Detail) + Viewport Culling

```typescript
sigma.on('zoom', ({ ratio }) => {
  if (ratio < 0.5) {
    sigma.setSetting('renderEdgeLabels', false);
    sigma.setSetting('labelRenderedSizeThreshold', 8);
  } else {
    sigma.setSetting('renderEdgeLabels', true);
    sigma.setSetting('labelRenderedSizeThreshold', 0);
  }
});
```

#### Cluster View Fallback (>2000 nodes)

```typescript
if (nodes.length > 2000) {
  // Switch to aggregated cluster view
  renderClusterView(groupByDomain(nodes));
}
```

---

### Code Splitting Patterns (P0 Fix)

```typescript
//vite.config.ts
export default {
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          'vendor-react': ['react', 'react-dom', 'react-router-dom'],
          'vendor-state': ['zustand'],
          'cosmos-graph': ['sigma', 'graphology', 'graphology-layout-forceatlas2'],
          'cosmos-flow': ['@xyflow/react'],
          'cosmos-charts': ['recharts'],
          'cosmos-timeline': ['react-chrono'],
        }
      }
    }
  }
};

// Lazy loading
const CosmosGraph = lazy(() => import('./cosmos/GraphMode'));
const CosmosMindMap = lazy(() => import('./cosmos/MindMapMode'));

// Plotly lazy only if Financial mode
const Plotly = lazy(() => import('plotly.js-basic-dist-min'));
```

---

### Text Scaling 200% Responsive (P0 Fix)

```css
/* Responsive text scaling - no fixed sizes */
.sidebar-item {
  font-size: clamp(0.75rem, 1vw, 1rem);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.concept-card {
  height: auto;  /* Not fixed 120px */
  min-height: 120px;
  max-height: none;
}

.concept-card__definition {
  max-height: 200px;
  overflow-y: auto;
}

@media (min-width: 1024px) {
  .brain-panel {
    width: clamp(320px, 25vw, 420px);
  }
}
```

---

### Memory Cleanup Patterns (P0 Fix)

```typescript
// COSMOS cleanup on unmount
useEffect(() => {
  const sigmaInstance = new Sigma(graph, container, settings);
  
  return () => {
    sigmaInstance.kill();
    graph.clear();
    sigmaInstance.removeAllListeners();
  };
}, []);

// WebSocket cleanup
useEffect(() => {
  const ws = new WebSocket(WS_URL);
  
  return () => {
    if (ws.readyState === WebSocket.OPEN) {
      ws.close(1000, 'Component unmounting');
    }
  };
}, []);

// Zustand unsubscribe
useEffect(() => {
  const unsubscribe = useStore.subscribe(
    (state) => state.concepts,
    (concepts) => updateGraph(concepts)
  );
  
  return unsubscribe;
}, []);
```

---

## Accessibility Floor

### WCAG 2.1 Level AA Compliance

#### Contrast Ratios

**Minimum requis :**
- Text normal (16px) : 4.5:1
- Text large (18px+ ou 14px bold) : 3:1
- UI components : 3:1

**SCY Forge ratios (audité) :**
- {text-primary} sur {bg-main} : **15.8:1** ✅ (AAA)
- {text-secondary} sur {bg-main} : **8.6:1** ✅ (AAA)
- {text-muted} sur {bg-main} : **5.1:1** ✅ (AA)
- {color-ai} sur {bg-main} : **7.2:1** ✅ (AAA)
- {color-success} sur {bg-main} : **6.8:1** ✅ (AAA)

#### Keyboard Navigation

**Toutes les fonctionnalités accessibles au clavier :**
- Tab : Navigation séquentielle
- Shift+Tab : Navigation inverse
- Enter/Space : Activation
- Esc : Fermeture/annulation
- Arrows : Navigation dans listes/grilles

**Focus indicators :**
- Toujours visibles (jamais `outline: none` sans remplacement)
- Contraste minimum 3:1 avec background

#### Screen Reader Support

**ARIA labels obligatoires :**
```html
<button aria-label="Ingérer une vidéo YouTube">
  <YoutubeIcon aria-hidden="true" />
</button>

<div role="progressbar" aria-valuenow="47" aria-valuemin="0" aria-valuemax="100" aria-label="Ingestion en cours">
  47% complété
</div>

<nav aria-label="Navigation principale">
  <a href="/ingest" aria-current="page">Ingestion</a>
</nav>
```

**Live regions :**
```html
<div role="status" aria-live="polite" aria-atomic="true">
  15 vidéos ingérées — 127 concepts extraits
</div>

<div role="alert" aria-live="assertive">
  Erreur: Cette URL n'est pas accessible
</div>
```

#### Color Independence

**Information never conveyed by color alone :**
- ✅ SMI levels : couleur + label textuel ("Expert 87/100")
- ✅ Status : couleur + icône + label ("✅ Done")
- ✅ ASCENT nodes : couleur + border + icône + label

#### Motion Reduction

**Respecter `prefers-reduced-motion` :**
```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
  
  /* Désactiver animations Sigma.js */
  .sigma-container {
    --animation-enabled: false;
  }
}
```

**Animations désactivées :**
- Force Atlas 2 layout (COSMOS)
- Animated edges
- Transitions modals
- Skeleton shimmer effects

#### Text Scaling

**Support 200% text zoom :**
- Utiliser `rem` units (jamais `px` pour text)
- Layout responsive adapte
- No horizontal scroll nécessaire
- Pas de texte tronqué critique

### Platform-Specific Accessibility

#### Desktop

- **Windows** : Narrator support, High Contrast Mode
- **macOS** : VoiceOver support, Reduce Motion
- **Linux** : Orca screen reader support

#### Mobile

- **iOS** : VoiceOver, Dynamic Type, Reduce Motion, Bold Text
- **Android** : TalkBack, Font Size, Remove Animations

---

## Key Flows

### Flow 1 : Onboarding — Première Connexion

**Protagoniste :** Marie, 24 ans, étudiante en informatique, découvre SCY Forge

**Objectif :** Comprendre SCY Forge en <60 secondes et ingérer sa première source

**Étapes :**

1. **Arrivée (0s)**
   - Marie ouvre SCY Forge pour la première fois
   - Splash screen 200ms
   - Auth rapide (si déjà connectée) ou signup

2. **Démo Pre-populated (2s)**
   - Atterrit sur projet démo pré-chargé
   - Bandeau amber visible : "Mode démo · Tes données apparaîtront ici quand tu importeras ton premier contenu"
   - Voit immédiatement :
     - 3 sources ingérées (YouTube ML, papier Arxiv, article web Rust)
     - 28 concepts visibles dans LIBRARY
     - 1 objectif ASCENT "Machine Learning Basics" avec 12 nœuds (3 completed)
     - 15 cartes APEX avec SMI 62/100
     - 1 session BRAIN pré-affichée avec question/réponse

3. **Exploration libre (5-30s)**
   - Marie clique sur COSMOS → voit Knowledge Graph avec nœuds connectés
   - Clique sur ASCENT → voit Roadmap avec progression visuelle
   - Clique sur APEX → voit cartes de révision
   - Tooltips (?) apparaissent sur hover pour guider subtilement

4. **CTA proéminent (30s)**
   - Marie voit CTA en bas du bandeau demo :
     ```
     C'est ton tour — importe ton premier contenu
     [Coller URL YouTube] [Upload PDF] [Coller du texte]
     ```

5. **Premier import (35s)**
   - Marie colle une URL YouTube sur Rust Async
   - Modal progress apparaît (non-bloquant)
   - WebSocket updates en temps réel
   - Peut continuer à explorer la démo pendant ingestion

6. **Démo disparaît (2min)**
   - Dès que l'ingestion est `done`
   - Bandeau demo disparaît automatiquement
   - Marie voit SA source ingérée dans LIBRARY
   - Toast success : "Ta première source ingérée — 23 concepts extraits !"

**Climax :** Marie réalise que SCY Forge a **automatiquement extrait des concepts** de sa vidéo et les a **connectés dans un graphe**. Elle comprend la valeur en voyant ses propres données.

**Métriques de succès :**
- Time to First Value : <60s
- Taux complétion onboarding : >80%
- Rétention J+1 : >60%


### Flow 2 : Ingestion YouTube Intelligente (15 Vidéos Parallèles)

**Protagoniste :** Thomas, 28 ans, entrepreneur tech, cherche patterns SaaS qui réussissent

**Objectif :** Identifier 5-10 points communs entre SaaS à succès en analysant 15 vidéos YouTube simultanément

**Étapes :**

1. **Accès INGEST (0s)**
   - Thomas clique sur INGEST dans sidebar
   - Sélectionne "YouTube Intelligent Tracking"

2. **Expression intention (5s)**
   - Input NL : "Points communs des SaaS qui ont réussi"
   - Clique "Analyser"

3. **Résolution IA (8s)**
   - IA identifie chaînes pertinentes :
     - YCombinator
     - SaaStr
     - Indie Hackers
     - Levelsio
   - Affiche modal confirmation : "Je vais analyser 15 vidéos de ces 4 chaînes"
   - Thomas confirme

4. **Ingestion parallèle (10s → 12min)**
   - Modal progress apparaît :
     ```
     Analyse en cours — 15 vidéos YouTube
     3/15 vidéos analysées
     ██████░░░░░░░░░░░░░░░░ 20%
     ~9 min restantes
     
     [Logs]
     > Vidéo 1 (YCombinator): 87 concepts extraits
     > Vidéo 2 (SaaStr): 54 concepts extraits
     > Vidéo 3 (Indie Hackers): En cours...
     
     [Continuer en arrière-plan]
     ```
   
   - Thomas clique "Continuer en arrière-plan"
   - Modal se ferme, badge navbar (🔔 15) indique opérations actives
   - Thomas explore LIBRARY pendant que ça tourne

5. **Progression temps réel (Background)**
   - WebSocket events :
     - `IngestProgress` → Badge navbar s'update (🔔 7/15)
     - Toasts discrets en bas : "Vidéo 7/15 analysée"
   
   - Thomas peut réouvrir modal depuis Activity Center

6. **Analyse croisée IA (12min)**
   - Toast : "15 vidéos analysées — génération du rapport"
   - IA croise les transcriptions
   - Identifie patterns récurrents

7. **Rapport structuré (13min)**
   - Notification : "Rapport prêt — 8 points communs identifiés"
   - Thomas clique → ouvre rapport :
     ```
     ## Points Communs SaaS Réussis
     
     ### Sources (15 vidéos)
     - [YCombinator] How to...
     - [SaaStr] The secret...
     - ...
     
     ### Points Communs Identifiés (8)
     1. **Problem-First Approach** (14/15 vidéos)
        - Toujours commencer par un vrai problème
        - Cité dans: [sources]
     
     2. **Early Monetization** (12/15 vidéos)
        - Ne pas attendre 100k users
        - Cité dans: [sources]
     
     ...
     
     ### Nuances
     - Timing varie selon B2B vs B2C
     - Bootstrapped vs VC-backed approches différentes
     
     ### Recommandations
     - Focus top 3 points communs pour ton SaaS
     ```

8. **Exploration COSMOS (14min)**
   - Thomas clique "Voir dans COSMOS"
   - Knowledge Graph montre tous les concepts SaaS interconnectés
   - Peut filter par source

**Climax :** Thomas réalise qu'il a **synthétisé 15 heures de vidéo en 13 minutes** et a obtenu **un rapport actionnable avec sources citées**.

**Métriques de succès :**
- Temps total : <15min pour 15 vidéos
- Qualité rapport : >80% pertinence (feedback user)
- Utilisation fonctionnalité : >20% des users INGEST

---

### Flow 3 : Création Objectif ASCENT + Certification

**Protagoniste :** Léa, 26 ans, développeuse web, veut maîtriser Rust async pour changer de job

**Objectif :** Obtenir une certification vérifiable "Rust Async Mastery" en 4 semaines

**Étapes :**

1. **Création objectif (0s)**
   - Léa clique sur ASCENT dans sidebar
   - Empty state : "Définis ton premier objectif d'apprentissage"
   - Clique "Créer un objectif"

2. **Formulaire objectif (10s)**
   - Input : "Maîtriser Rust async et tokio pour applications production"
   - Skill : Rust
   - Catégorie : Programming
   - Niveau actuel : Intermédiaire (connaît Rust basics)
   - Niveau cible : Expert
   - Deadline : 4 semaines
   - Clique "Générer parcours"

3. **Génération DAG IA (20s)**
   - Modal : "Analyse de l'objectif en cours..."
   - IA :
     - Identifie 25 concepts nécessaires
     - Détecte concepts déjà dans LIBRARY (Léa avait ingéré docs Rust avant)
     - Génère concepts manquants
     - Établit prérequis entre concepts
     - Organise en 5 phases
   
   - WebSocket : `AscentGoalCreated {goal_id, nodes_count: 25}`

4. **Visualisation Roadmap (25s)**
   - DAG s'affiche en mode Roadmap (défaut)
   - 5 phases horizontales :
     ```
     Phase 1: Fundamentals → Phase 2: Tokio Basics → Phase 3: Advanced Patterns → Phase 4: Production Ready → Phase 5: Mastery
     ```
   
   - Léa voit :
     - 3 nœuds `unlocked` (pas de prérequis)
     - 22 nœuds `locked` (prérequis non remplis)
     - Chemin critique highlighted en violet
   
   - Switcher vue : [Roadmap] [MindMap] [Kanban]
   - Léa teste MindMap → voit hiérarchie conceptuelle
   - Revient à Roadmap (sauvegarde préférence)

5. **Premier nœud (30s)**
   - Léa clique sur "Futures & Polling" (premier nœud unlocked)
   - Vue détail nœud s'ouvre :
     ```
     ## Futures & Polling
     
     **SMI actuel :** 0/100 (pas encore étudié)
     **Prérequis :** Aucun (nœud racine)
     **Débloque :** 3 nœuds suivants
     
     ### Matériel d'apprentissage
     - 5 concepts LIBRARY liés
     - 8 flashcards APEX générées
     - 2 sources externes (Rust book, tokio docs)
     
     [Étudier] [Réviser APEX] [Passer exercice]
     ```

6. **Étude + Révision (Jour 1-3)**
   - Léa clique "Étudier" → voit concepts LIBRARY
   - Clique "Réviser APEX" → session 8 flashcards
   - Répète sur 3 jours (FSRS schedule)
   - SMI monte progressivement : 0 → 45 → 67 → 73

7. **Exercice validation (Jour 3)**
   - SMI ≥70 → bouton "Passer exercice" s'active
   - Léa clique → exercice généré IA :
     - 2 MCQ (choix multiples)
     - 1 réponse courte
     - 1 application pratique (code snippet)
   
   - Léa répond (10 min)
   - Score : 85/100 ✅
   - Toast : "Nœud complété ! SMI final: 78/100"

8. **Déblocage nœuds suivants (Jour 3)**
   - Nœud "Futures & Polling" devient `completed` (vert)
   - 3 nœuds suivants passent `locked` → `unlocked` (cyan)
   - Animation subtle : nœuds s'illuminent
   - Notification : "3 nouveaux concepts débloqués"

9. **Progression continue (Jour 4-28)**
   - Léa répète le cycle pour chaque nœud
   - Dashboard ASCENT montre :
     ```
     Rust Async Mastery
     Progress: 18/25 nœuds completed (72%)
     SMI moyen: 74/100
     Temps investi: 23h
     Deadline: 6 jours restants
     ```

10. **Certification finale (Jour 28)**
    - 25/25 nœuds completed ✅
    - Modal : "Prêt pour la certification finale ?"
    - Léa confirme
    
    - Examen de synthèse (45 min) :
      - 10 MCQ couvrant tout le DAG
      - 3 exercices pratiques
      - 1 projet mini (implémentation async complète)
    
    - Léa soumet → Score : 87/100 ✅
    
    - Certificat généré :
      ```
      ┌─────────────────────────────────────┐
      │  🏆 Certificat SCY Forge            │
      │                                     │
      │  Léa Martin                         │
      │  a démontré la maîtrise de          │
      │  Rust Async & Tokio                 │
      │                                     │
      │  25 concepts maîtrisés              │
      │  SMI moyen: 79/100                  │
      │  Durée: 28 jours                    │
      │                                     │
      │  Certifié le 2026-06-30             │
      │  ID: ASC-2026-06-30-RU-12a4b       │
      └─────────────────────────────────────┘
      
      [Télécharger PDF] [Partager LinkedIn] [Voir sur blockchain]
      ```

**Climax :** Léa a une **preuve vérifiable** de sa compétence Rust async. Elle peut **montrer son certificat** en entretien avec l'ID traçable sur blockchain.

**Métriques de succès :**
- Taux complétion objectifs : >40%
- Temps moyen certification : 21-35 jours
- SMI moyen final : >75/100
- Satisfaction certification : >4.5/5

---

### Flow 4 : Session Révision APEX (Spaced Repetition)

**Protagoniste :** Marc, 30 ans, data scientist, révise concepts ML quotidiennement

**Objectif :** Maintenir ses connaissances ML via révision espacée optimale (FSRS)

**Étapes :**

1. **Notification due cards (Matin 9h)**
   - Badge sidebar APEX : ⚡ 23
   - Toast : "23 cartes à réviser aujourd'hui — maintiens ton streak 14 jours"

2. **Accès APEX (9h05)**
   - Marc clique sur APEX
   - Dashboard :
     ```
     🔥 Streak: 14 jours
     ⚡ Cartes dues: 23
     📊 SMI moyen: 67/100
     
     [Démarrer révision] [Voir stats]
     ```

3. **Démarrage session (9h06)**
   - Marc clique "Démarrer révision"
   - Modal session s'ouvre :
     ```
     Session APEX — 23 cartes
     Progression: 0/23
     
     [Carte apparaît]
     ```

4. **Révision cartes (9h06 → 9h25)**
   - **Carte 1 (Type: Définition)**
     ```
     Question: Qu'est-ce que le gradient descent?
     
     [Révéler réponse]
     ```
     
     - Marc réfléchit (5s)
     - Clique "Révéler réponse" (ou Space)
     
     ```
     Réponse: Algorithme d'optimisation itératif qui...
     
     Difficulté perçue:
     [1-Difficile] [2-Moyen] [3-Facile] [4-Très facile]
     ```
     
     - Marc clique "3-Facile"
     - FSRS recalcule :
       - `stability` : 5.2 → 8.7 days
       - `difficulty` : 0.4 (facile)
       - `next_due` : dans 9 jours
   
   - **Carte 2 (Type: MCQ)**
     ```
     Quelle fonction d'activation est utilisée dans les sorties de classification binaire?
     
     A) ReLU
     B) Sigmoid
     C) Tanh
     D) Softmax
     
     [A] [B] [C] [D]
     ```
     
     - Marc clique "B" → ✅ Correct
     - Auto-difficulté : "3-Facile" (réponse correcte immédiate)
   
   - **Carte 3 (Type: Application)**
     ```
     Cas pratique: Tu as un dataset déséquilibré (90% classe A, 10% classe B). Quelle métrique privilégier?
     
     [Réponse courte...]
     ```
     
     - Marc tape : "F1-score ou AUC-ROC, pas accuracy"
     - IA valide → ✅ Correct
     - Difficulté : "2-Moyen"
   
   - Répète pour les 20 cartes restantes (15 min)

5. **Fin de session (9h25)**
   - Modal fin :
     ```
     🎉 Session terminée !
     
     23/23 cartes révisées
     Score: 87% (20 correctes)
     Temps: 19 min
     
     SMI mis à jour:
     • Gradient Descent: 72 → 76
     • Sigmoid Function: 65 → 68
     • ... (21 autres)
     
     SMI moyen global: 67 → 69 (+2)
     
     🔥 Streak maintenu: 15 jours
     
     Prochaine session: Demain, 18 cartes
     
     [Terminer] [Continuer (cartes avancées)]
     ```
   
   - Marc clique "Terminer"

6. **Feedback ASCENT (9h26)**
   - Toast : "2 nœuds ASCENT débloqués grâce à tes révisions"
   - Marc voit dans ASCENT que 2 nœuds sont passés `unlocked` car SMI ≥70

**Climax :** Marc maintient ses connaissances ML **sans effort de mémoire** — FSRS optimise automatiquement les intervalles. Son **streak de 15 jours** le motive à continuer.

**Métriques de succès :**
- Taux rétention 30 jours : >85%
- Temps moyen session : 15-20 min
- Streak moyen : >10 jours
- SMI progression : +2 à +5 points par session

---

## Responsive & Platform

### Breakpoints

| Breakpoint | Width      | Layout                        |
| ---------- | ---------- | ----------------------------- |
| Mobile     | <768px     | Bottom tab bar, single column |
| Tablet     | 768-1024px | Sidebar overlay, 2 columns    |
| Desktop    | >1024px    | Sidebar fixed, 3 columns      |

### Platform-Specific Patterns

#### Desktop (Windows, macOS, Linux)

**Window chrome :**
- macOS : Traffic lights top-left, title centered
- Windows/Linux : Close/minimize/maximize top-right

**Scrollbars :**
- Custom dark style pour cohérence
- Auto-hide après 2s inactivité

**Drag & Drop :**
- Files → INGEST pour import direct
- Concepts → ASCENT nodes pour lier manuellement

#### Web (SaaS)

**PWA (Progressive Web App) :**
- Installable depuis browser
- Service Worker pour offline cache
- Manifest pour icône home screen

**URL routing :**
- `/ingest` → Module INGEST
- `/library/concepts/:id` → Détail concept
- `/ascent/goals/:id` → Détail objectif
- `/cosmos?mode=graph` → COSMOS mode Graph

#### Mobile (iOS, Android)

**Safe areas :**
- iOS : Notch/Dynamic Island top, home indicator bottom
- Android : Status bar top, navigation bar bottom

**Native features :**
- Share sheet : Partager certificats, concepts
- Biometric auth : Face ID, Touch ID, fingerprint
- Haptic feedback : Vibrations sur actions importantes
- Background sync : Sync queue continue en arrière-plan

**Gestures :**
- Swipe horizontal : Entre modules
- Pull-to-refresh : Actualiser données
- Long press : Context menu

---

## Inspiration & Anti-patterns

### Inspirations

**Navigation :**
- **Notion** : Command Palette ⌘K fluide
- **Linear** : Navigation keyboard-first
- **Obsidian** : Sidebar collapsible élégante

**Visualisation :**
- **Obsidian Graph** : Knowledge graph interactif
- **Roadmap.sh** : Visualisation parcours apprentissage
- **Anki** : Spaced repetition efficace

**Feedback :**
- **VS Code** : Progress notifications non-bloquantes
- **Linear** : Toasts subtils en bas
- **GitHub** : Activity feed temps réel

### Anti-patterns à Éviter

**❌ Modal blocking pour <3s operations**
```
Mauvais: Modal "Chargement..." qui bloque 2s
Bon: Skeleton screen + load en background
```

**❌ Success modals qui nécessitent confirmation**
```
Mauvais: Modal "Succès !" avec bouton OK obligatoire
Bon: Toast auto-dismiss après 3s
```

**❌ Navigation hamburger sur desktop**
```
Mauvais: Menu hamburger caché sur grand écran
Bon: Sidebar toujours visible, collapsible
```

**❌ Trop de niveaux de navigation**
```
Mauvais: Home > Module > Submenu > Tab > Section
Bon: Module > View (max 2 niveaux)
```

**❌ Pagination forcée**
```
Mauvais: "Page 1 of 47" avec navigation manuelle
Bon: Infinite scroll + virtualization
```

---

## Document Status

**Status :** Final  
**Version :** 1.0.0  
**Last Updated :** 2026-06-03  
**Next Review :** Before wireframes completion

**Maintainers :** Joy (Product Owner)  
**Approval Required :** Before implementation phase

**Related Documents :**
- {DESIGN.md} : Visual design system reference (colors, typography, components)
- {.decision-log.md} : UX decisions log (6 major decisions documented)
- {BRAIN-PANEL-COMPONENTS-SPEC.md} : BRAIN panel technical component specifications
- {extraction-sources.md} : Technical specifications extracted from architecture docs
- {ux-design-questions-reponse.md} : Detailed flows and navigation architecture

---

*Ce document est la référence contractuelle pour l'expérience utilisateur de SCY Forge. En cas de conflit entre ce document et tout wireframe, mock ou import, ce document prévaut. DESIGN.md prévaut sur les décisions visuelles, EXPERIENCE.md prévaut sur les comportements et parcours.*

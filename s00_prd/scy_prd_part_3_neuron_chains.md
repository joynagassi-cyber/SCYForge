**Professionnels (T21-T30)** : Business Exécutif, Consulting Stratégique, Juridique Précis, Marketing Persuasif, Journalistique Factuel, Technique Support, Formation Corporate, Startup Disruptif, Gouvernemental Officiel, ONG Engagé

**Créatifs (T31-T40)** : Dystopique, Utopique, Cyberpunk, Fantasy, Steampunk, Thriller, Comédie Absurde, Documentaire, Slam Poétique, Rap Éducatif

**Spécialisés (T41-T50)** : ELI5, ELI PhD, Mnémotechnique, Debate, Interview Q&A, Code Comments, Chanson Éducative, Infographie, Meme Culture, ASMR Textuel

### 7.4 Module COSMOS — 26 Modes Visualisation `[Rôle : Frontend & UI-UX]` (v3 Extension)

**Source** : cosmos_extension_research.md | **Confiance** : 95%
**Objectif** : Couvrir 87% des concepts complexes (vs ~50% en v2, 8 modes)

#### 7.4.1 Modes Existants (v2 — 9 modes)

| # | Mode | Bibliothèque | Bundle | Phase | Couverture |
|---|------|-------------|--------|-------|------------|
| 0 | Base Knowledge Base | @cosmograph/cosmos v3 + DuckDB-WASM | ~700KB | MVP | Relations transversales multi-projets |
| 1 | Lexical Tags | TailwindCSS + Headless UI + react-window | ~50KB | MVP | Taxonomies simples, catégorisations |
| 2 | Knowledge Graph Projet | @antv/g6 v5 + graphology | ~280KB | MVP | Réseaux sémantiques, communautés |
| 3 | MindMap | @antv/g6 v5 (Tree layout) | ~280KB | MVP | Hiérarchies arborescentes simples |
| 4 | Roadmap ASCENT (DAG) | @xyflow/react v12 + Dagre | ~180KB | MVP | Séquences d'apprentissage, prérequis |
| 5 | Concepts Grid | TanStack Table v8 + Virtual | ~60KB | Post-MVP | Données tabulaires, inventaires |
| 6 | Timeline | Custom React + react-spring | ~50KB | Post-MVP | Chronologies, séries temporelles |
| 7 | Statistics | Recharts v2 | ~150KB | MVP | Distributions statistiques, tendances |
| 8 | DataFlow NEURON-CHAINS | @xyflow/react v12 + SSE | ~180KB | Post-MVP | Flux de traitement, pipelines |

**Couverture v2 : ~50% des concepts complexes**

#### 7.4.2 Nouveaux Modes (v3 — 16 modes additionnels)

##### Phase 1 — MVP+ (T0+3 mois, +5 modes → couverture ~65%)

| # | Mode | Type | Bibliothèque | Bundle |
|---|------|------|-------------|--------|
| **M9** | **Concept Map** 🔴 | Réseau à liaisons croisées étiquetées | @antv/g6 v5 + graphology | ~0KB (réutilisation) |
| **S10** | **Sunburst Hiérarchique** 🔴 | Hiérarchie radiale concentrique (≥3 niveaux) | @antv/g2 v5 | ~180KB |
| **S11** | **Treemap Conceptuel** 🟠 | Partition rectangulaire hiérarchique | @antv/g2 v5 | ~0KB (via G2) |
| **M14** | **Radar Comparaison** 🟠 | Profil multidimensionnel (3-12 axes) | recharts v2 | ~0KB (réutilisation) |
| **M16** | **Heatmap Matricielle** 🟡 | Matrice de corrélations inter-concepts | nivo/heatmap | ~25KB |

##### Phase 2 — Post-MVP V1 (T0+6 mois, +5 modes → couverture ~75%)

| # | Mode | Type | Bibliothèque | Bundle |
|---|------|------|-------------|--------|
| **M13** | **Sankey / Alluvial** 🟠 | Flux pondérés entre étapes | nivo/sankey | ~25KB |
| **S12** | **Chord Diagram** 🟡 | Relations bidirectionnelles circulaires | nivo/chord | ~30KB |
| **M15** | **Parallel Coordinates** 🟡 | N dimensions, brush filtering | d3 | ~35KB |
| **M19** | **Circle Packing** 🟢 | Cercles imbriqués hiérarchiques | nivo/circle-packing | ~22KB |
| **M20** | **Arc Diagram** 🟢 | Nœuds alignés, arcs = relations | d3 | ~18KB |

##### Phase 3 — Post-MVP V2 (T0+12 mois, +6 modes → couverture ~85%)

| # | Mode | Type | Bibliothèque | Bundle |
|---|------|------|-------------|--------|
| **M22** | **Semantic Zoom Graph** 🔴 | 3 niveaux de détail progressifs | @cosmograph/cosmos v3 | ~0KB (réutilisation) |
| **M17** | **Argument Map** 🟡 | Propositions logiques liées par inférence | @xyflow/react v12 | ~0KB (réutilisation) |
| **M18** | **Causal Loop Diagram** 🟡 | Boucles de rétroaction causale | @antv/g6 v5 | ~0KB (réutilisation) |
| **M21** | **Hierarchical Edge Bundling** 🟢 | Faisceaux d'arêtes hiérarchiques | d3 | ~15KB |
| **M24** | **Voronoi Concept Map** 🟢 | Partition polygonale irrégulière | d3 | ~18KB |

##### Phase 4 — V3 R&D (T0+18 mois)

| # | Mode | Type | Bibliothèque | Bundle |
|---|------|------|-------------|--------|
| **M23** | **3D Knowledge Space** 🔵 | Graphe volumétrique 3D immersif | three.js | ~450KB (optionnel) |

**Total bundle COSMOS v3 : ~1.4MB lazy-loaded, initial ~220KB (+610KB incrémental vs v2)**

#### 7.4.3 Fiches Détaillées — Modes Prioritaires

---

**MODE 9 — Concept Map (Cartographie Conceptuelle Croisée)** 🔴 CRITIQUE

**Différenciation vs Mode 3 (MindMap)** :
- MindMap : radial, 1 parent par nœud, pas de liens entre branches — usage créatif/brainstorming
- Concept Map : liaisons croisées étiquetées, plusieurs parents, propositions lisibles — usage analytique
- Fondement recherche : Novak (1970s), NN/Group (2024), Creately (2026)

**Features** :
- ✅ Nœuds = concepts, arêtes = relations étiquetées (verbes/prépositions)
- ✅ Layout force-directed adaptatif (ForceAtlas2) + ancrage manuel
- ✅ Propositions lisibles : triplets "Concept A → relation → Concept B"
- ✅ Plusieurs parents par nœud (pas de restriction arborescente)
- ✅ Filtres par type de relation, profondeur, domaine
- ✅ Détection automatique de clusters conceptuels (Louvain)
- ✅ Export PNG/SVG + JSON structuré
- ✅ Synchro bidirectionnelle avec Mode 3 (MindMap → Concept Map)

**Intégration ASCENT** : Agent-03 (DAG-ARCHITECT) peuple automatiquement les relations croisées

---

**MODE 10 — Sunburst Hiérarchique (Taxonomie Profonde)** 🔴 CRITIQUE

**Description** : Visualisation de taxonomies profondes (≥3 niveaux) — parfait pour ontologies, arborescences de domaines, classifications académiques.

**Features** :
- ✅ Anneaux concentriques (1 anneau = 1 niveau hiérarchique)
- ✅ Segments proportionnels à la taille (nombre de concepts, cartes, documents)
- ✅ Drill-down interactif : clic → zoom sur un segment
- ✅ Breadcrumb navigation
- ✅ Code couleur : domaine, SMI moyen, ou densité
- ✅ Tooltip : nom, nb enfants, nb documents, SMI moyen
- ✅ Jusqu'à 6 niveaux (limite perceptuelle)
- ✅ Animation de transition fluide (300ms)

---

**MODE 14 — Radar Comparaison (Profil Multidimensionnel)** 🟠 HAUTE

**Description** : Comparaison visuelle de profils de compétence sur N dimensions. Exploite directement le SMI multidimensionnel calculé par l'Agent-05.

**Features** :
- ✅ 3-12 axes radiaux (dimensions SMI, compétences, attributs)
- ✅ Superposition de plusieurs profils (comparaison avant/après, vs objectif)
- ✅ Remplissage semi-transparent par profil
- ✅ Tooltip par axe avec valeur précise
- ✅ Animation de transition entre états
- ✅ Intégration directe SMI 5 dimensions (Recall, Application, Analyse, Synthèse, Évaluation)

**Intégration ASCENT** : Agent-05 (PERFORMANCE-ANALYZER) → données SMI → Radar Chart temps réel

---

**MODE 13 — Sankey / Alluvial (Trajectoires de Connaissances)** 🟠 HAUTE

**Description** : Cartographie des trajectoires d'apprentissage : comment les concepts s'enchaînent, où les apprenants bifurquent, quelles sont les voies les plus empruntées.

**Features** :
- ✅ Flux entre étapes d'apprentissage (colonnes)
- ✅ Largeur des flux ∝ nombre d'apprenants/concepts
- ✅ Couleurs = catégories de concepts
- ✅ Hover : tooltip avec volume et métriques
- ✅ Filtrage des flux mineurs (< seuil)
- ✅ Mode Alluvial : étapes temporelles (progression séquentielle)
- ✅ Mode Sankey : flux de transformation (d'un état à l'autre)

---

**MODE 22 — Semantic Zoom Graph (Zoom Sémantique)** 🔴 R&D

**Description** : Exploration ontologique avec 3 couches de détail : agrégée → intermédiaire → détaillée. Le niveau de zoom détermine ce qui est affiché. Inspiré de Fraunhofer (2017) et KNOWNET.

**Features** :
- ✅ 3 niveaux de zoom : clusters → groupes → concepts individuels
- ✅ Transition fluide entre niveaux
- ✅ Niveau 1 : clusters colorés avec labels
- ✅ Niveau 2 : sous-groupes avec arêtes inter-groupes
- ✅ Niveau 3 : concepts individuels avec relations complètes
- ✅ Halo visualization (indicateurs de concepts hors-champ)
- ✅ Préservation du "mental map" lors des transitions

---

#### 7.4.3 bis — Intelligence du Graphe COSMOS (Features IA)

**A — PageRank des Concepts (Importance Scoring)**

Appliquer l'algorithme PageRank sur le graphe conceptuel COSMOS pour déterminer l'importance relative de chaque concept.

```
Principe : Un concept très référencé par d'autres concepts = concept fondamental
Librairie : graphology-metrics (déjà dans §6.2 — coût $0)

Impact sur SCY Forge :
✅ APEX : Prioriser révision des concepts haute importance (pondération FSRS)
✅ COSMOS : Taille des nœuds ∝ PageRank score (cosmos.gl supporte nativement)
✅ ASCENT Agent-03 : Placer les concepts haute importance en début de DAG
✅ Dashboard : Carte "Top 5 concepts fondamentaux de votre domaine"
```

**Seuils PageRank :**
| Score | Label | Couleur nœud | Action ASCENT |
|-------|-------|-------------|---------------|
| Top 5% | Fondamental 🏛️ | Or | Priorité maximale dans DAG |
| Top 20% | Important 🔵 | Bleu | Priorité haute |
| Reste | Standard | Neutre | Ordre normal |

**Phase recommandée** : Phase 0 (coût nul, `graphology-metrics` déjà présent)

---

**B — Gap Detection (Lacunes Conceptuelles)**

Analyser le DAG conceptuel pour identifier les concepts prérequis manquants dans la base de connaissance de l'utilisateur.

```
Principe : Traversal du graphe COSMOS sur les arêtes type "prerequisite_of"
           Identifier les nœuds prérequis absents de scy_concepts (user)
Librairie : petgraph (déjà dans §6.1 — coût $0)

Exemple :
L'user a : Concept "React Hooks" + Concept "Redux"
Manque   : Concept "Closures JavaScript" (prérequis de React Hooks)
→ Alert : "Il vous manque ce prérequis fondamental : [Closures JS]"
→ Action : Suggestion d'ingestion source + génération contenu NEURON-CHAINS
```

**Feature UX Gap Detection :**
- ✅ Notification in-app si gap critique détecté
- ✅ Visualisation COSMOS : Nœuds manquants en pointillés rouges
- ✅ Bouton "Combler cette lacune" → déclenche Agent-02 (CONTENT-SCOUT)
- ✅ Agent-06 (ADAPTIVE-ROUTER) intègre les gaps dans la décision de remédiation

**Phase recommandée** : Phase 0-1 (feature killer différenciante, coût nul)

---

**C — Cross-Domain Auto-Linking (Liens Inter-Domaines)**

Détecter automatiquement les concepts similaires entre différents domaines de compétence de l'utilisateur et créer des liens transversaux.

```rust
// Embedding cross-domain avec nomic-embed (déjà présent)
pub async fn detect_cross_domain_links(
    user_id: Uuid,
    new_concept: &Concept,
    threshold: f32, // 0.70 pour cross-domain (vs 0.75 intra-domaine)
) -> Vec<ConceptLink> {
    // Comparer le nouveau concept avec tous les concepts d'autres domaines
    let candidates = concept_repo
        .find_cross_domain_similar(user_id, &new_concept.embedding, threshold)
        .await?;
    
    candidates.into_iter()
        .filter(|c| c.domain != new_concept.domain)
        .map(|c| ConceptLink {
            source: new_concept.id,
            target: c.id,
            relation_type: "cross_domain_analog",
            weight: c.similarity,
            auto_generated: true,
        })
        .collect()
}
```

**UX COSMOS :** Arêtes cross-domain colorées en orange (vs arêtes intra-domaine en bleu)
**Impact APEX :** Réutiliser une carte pour plusieurs domaines (économie génération)
**Phase recommandée** : Phase 1

---

**D — History Animation Temporelle (Évolution du Graphe)**

Visualiser l'évolution chronologique du graphe conceptuel COSMOS dans le temps.

```
Feature :
- Slider temporel (Jour 1 → Aujourd'hui)
- Nœuds apparaissent progressivement selon date d'ingestion
- Couleur SMI évolue visuellement (rouge → orange → vert)
- Playback animé de la progression d'apprentissage

Technologie :
- Temporal Queries PostgreSQL (D-007) → snapshots historiques
- Animation CSS transitions + d3 timeline
- Implémenté comme sous-mode du Mode 6 (Timeline) ou Mode 25

Impact pédagogique : L'utilisateur visualise son parcours d'apprentissage
                     comme une "croissance" de son graphe cognitif
```

**Phase recommandée** : Phase 2

---

#### 7.4.4 Matrice de Couverture Conceptuelle

| Catégorie de Concept Complexe | Modes v2 | Modes v3 | Δ |
|-------------------------------|----------|----------|---|
| Réseau sémantique simple | 0, 2 | 0, 2 | = |
| Réseau sémantique à liaisons croisées | — | **9** | 🆕 |
| Hiérarchie simple (≤3 niveaux) | 1, 3 | 1, 3 | = |
| Hiérarchie profonde (≥4 niveaux) | — | **10, 11** | 🆕 |
| Taxonomie/Ontologie | — | **10, 11, 22** | 🆕 |
| Comparaison multi-attributs | — | **14, 15** | 🆕 |
| Matrice de corrélations | — | **16** | 🆕 |
| Flux et transformations | 8 | 8, **13** | 🆕 |
| Relations bidirectionnelles | — | **12** | 🆕 |
| Séquence temporelle | 6, 7 | 6, 7 | = |
| Raisonnement logique | — | **17** | 🆕 |
| Système dynamique/feedback | — | **18** | 🆕 |
| Distribution spatiale | — | **19, 24** | 🆕 |
| Relations ordonnées | — | **20** | 🆕 |
| Exploration multi-échelle | — | **22** | 🆕 |
| **COUVERTURE GLOBALE** | **~50%** | **~87%** | **+37%** |

#### 7.4.5 Architecture de Rendu COSMOS v3

```
┌──────────────────────────────────────────────────────────────────────┐
│                     COSMOS Renderer Abstraction Layer                   │
│                                                                        │
│  ┌─────────────┐ ┌──────────────┐ ┌───────────────┐ ┌─────────────┐ │
│  │ cosmos.gl    │ │ @antv/g6 v5  │ │ @antv/g2 v5   │ │ @xyflow     │ │
│  │ (GPU WebGL2) │ │ (WebGL Node- │ │ (Statistical  │ │ (DAG/Flow   │ │
│  │ Modes 0, 22  │ │  Link)       │ │  Charts)      │ │  Graphs)    │ │
│  │              │ │ Modes 2,3,9  │ │ Modes 10,11   │ │ Modes 4,8   │ │
│  │              │ │ Modes 18,20  │ │ Modes 16,19   │ │ Mode 17     │ │
│  └─────────────┘ └──────────────┘ └───────────────┘ └─────────────┘ │
│                                                                        │
│  ┌─────────────┐ ┌──────────────┐ ┌───────────────┐ ┌─────────────┐ │
│  │ nivo        │ │ Recharts      │ │ d3 (low-level)│ │ three.js    │ │
│  │ (React      │ │ (Charts)      │ │ (Custom)      │ │ (3D)        │ │
│  │  Dataviz)   │ │ Modes 7, 14   │ │ Modes 13, 15  │ │ Mode 23     │ │
│  │ Modes 12,13 │ │               │ │ Modes 21, 24  │ │             │ │
│  └─────────────┘ └──────────────┘ └───────────────┘ └─────────────┘ │
│                                                                        │
│  ┌──────────────────────────────────────────────────────────────────┐ │
│  │           SOURCE DE VÉRITÉ : graphology (0.25.x)                   │ │
│  │  - Graphe conceptuel unifié — Sérialisation JSON standard          │ │
│  │  - Algorithmes ML (Louvain, PageRank, ForceAtlas2)                │ │
│  │  - Adaptateurs vers chaque renderer (conversion <100ms)           │ │
│  └──────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

#### 7.4.6 Décisions Architecturales COSMOS

**D-COSMOS-001 : Séparation stricte Base Knowledge Base ↔ Graphes Projet** *(conservé v2)*
- Base KB (cosmos.gl) : Typed arrays GPU, 1M+ nœuds, transversal multi-projets
- Graphes Projet (G6 + graphology) : Structure objet riche, algorithmes ML, <50K nœuds
- Adaptateur `graphologyToCosmos()` pour drill-down (conversion <100ms)
- ⚠️ cosmos.gl NE supporte PAS graphology en input — tentative unification = échec

**D-COSMOS-002 : Cosmos.gl v3 Asynchrone** *(conservé v2)*
```typescript
const graph = new CosmosGraph(canvas, config);
await graph.ready; // ⚠️ CRITIQUE — méthodes en queue jusqu'à ready
graph.setPointPositions(positions);
graph.setLinks(links);
graph.render();
```

**D-COSMOS-006 : React Flow uniquement pour DAGs** *(conservé v2)*
- Roadmap ASCENT + DataFlow NEURON-CHAINS + Argument Map = React Flow ✅
- Knowledge Graph = jamais React Flow (utiliser G6)
- Max 1000 nœuds React Flow (virtual rendering)

**D-COSMOS-010 : Bibliothèque Sunburst/Treemap — @antv/g2 v5** *(nouveau v3)*
- Choix : @antv/g2 v5 (pas G6)
- Justification : G6 = graphes node-link, G2 = statistiques/hiérarchies — moteurs de rendu différents, même écosystème AntV
- Alternative : nivo pour équipes favorisant React-native

**D-COSMOS-011 : Concept Map vs MindMap — Deux modes distincts** *(nouveau v3)*
- MindMap (Mode 3) : créativité, brainstorming, arborescence simple, 1 parent/nœud
- Concept Map (Mode 9) : analyse, relations croisées, propositions lisibles, multi-parents
- Ne PAS fusionner — usages cognitifs différents validés par la recherche (NN/Group 2024, Novak 1970s)

**D-COSMOS-012 : Mode Auto-Suggest par l'Agent-03** *(nouveau v3)*
- L'orchestrateur ASCENT (Agent-03 DAG-ARCHITECT) suggère le mode COSMOS optimal selon :
  - Type de données (hiérarchique → Sunburst, réseau → KG, multidimensionnel → Radar)
  - Préférences utilisateur (historique de modes utilisés)
  - Objectif courant (apprentissage → Concept Map, révision → Radar SMI)

**D-COSMOS-013 : Lazy-loading strict pour tous les nouveaux renderers** *(nouveau v3)*
- 7 des 16 nouveaux modes utilisent des bibliothèques déjà dans le bundle (G6, React Flow, cosmos.gl)
- @antv/g2, nivo, d3, three.js chargés à la demande uniquement
- graphology comme source de données unique — tous les modes partagent le même modèle

**D-COSMOS-014 : HiDPI + Font Stack Universel obligatoires** *(nouveau v4)*
- `devicePixelRatio` appliqué systématiquement à l'init G6, Cosmos, Canvas2D
- Font stack global : Inter Variable + Noto Sans SC/JP/KR + Noto Color Emoji + system-ui
- `truncateLabelCJKAware()` via `Intl.Segmenter` — jamais de `String.slice()` sur labels
- Référence : D-QUAL-001, D-QUAL-002 (cosmos-architecture-v4.md)

**D-COSMOS-015 : AI Confidence System — Toute connexion IA affiche son score** *(nouveau v4)*
- Score multi-signaux : cosine × 0.45 + source_agreement × 0.30 + maturity × 0.15 + domain × 0.10
- Styles visuels : HIGH (plein violet) / MEDIUM (tireté) / LOW (pointillé + ⚠️)
- Validation/Rejet : raccourcis V/X + toast undo 10s + persistance `scy_ai_rejections`
- Feedback loop : rejets agrégés (k ≥ 100) → ajustement seuil cosine par domaine
- Référence : D-SEC-001, D-SEC-002 (cosmos-architecture-v4.md)

**D-COSMOS-016 : Typed Semantic Edge Styles — 7 types visuellement distincts** *(nouveau v4)*
- Chaque `relation_type` a un style G6 dédié (couleur, dash pattern, flèche, opacité)
- Légende auto-générée (uniquement types présents dans le graphe courant)
- Référence : D-UX-006 (cosmos-architecture-v4.md)

**D-COSMOS-017 : Progressive Rendering 4 Phases — Jamais de spinner blanc** *(nouveau v4)*
- Skeleton shimmer → Clusters → Hubs → Nodes complets (batches 500 avec `requestAnimationFrame`)
- Indicateur progression avec ETA (composant `GraphProgressBar`)
- Référence : D-UX-002 (cosmos-architecture-v4.md)

**D-COSMOS-018 : Learning-Aware Graph — SMI intégré dans les nœuds** *(nouveau v4 — Opportunité #1)*
- Couleur nœud = niveau SMI (rouge→orange→jaune→vert→or)
- Badge `📅Xj` ou `🔔` (révision overdue) visible zoom > 30%
- Aura pulsante rouge si révision due aujourd'hui
- Sync EventBus : session APEX terminée → COSMOS nœuds mis à jour immédiatement
- Référence : D-OPP-001 (cosmos-architecture-v4.md)

**D-COSMOS-019 : Source-Linked Nodes — Chaque nœud tracé à sa source** *(nouveau v4 — Opportunité #3)*
- Table `scy_concept_provenance` : source_id, position (page/timestamp/paragraph), confidence
- Badge source sur nœud (zoom > 30%) : 🎥📄🌐✍️🤖
- Navigation one-click vers SCY-READER SUITE à la position exacte
- Référence : D-OPP-003 (cosmos-architecture-v4.md)

**D-COSMOS-020 : Persistent GPU Buffers — Pas de re-upload pendant pan/zoom** *(nouveau v4)*
- `equals()` check sur référence Float32Array avant `setPointPositions()`
- Uniforms viewMatrix uniquement lors de pan/zoom (scaling côté GPU)
- Référence : D-PERF-007 (cosmos-architecture-v4.md)

**D-COSMOS-021 : WebGPU Roadmap — Migration Progressive Phase 3** *(nouveau v4)*
- T0+12 mois : Mode 23 (3D) → `three/webgpu` + `WebGPURenderer()` (2 lignes)
- T0+15 mois : ForceAtlas2 WGSL compute shader (×40-123 speedup vs CPU)
- T0+18 mois : Remplacement partiel Cosmos par WebGPU renderer custom
- Fallback WebGL2 maintenu automatiquement (70% support 2026 → 30% fallback)
- Référence : D-PERF-006 (cosmos-architecture-v4.md)

#### 7.4.7 Nouvelles Features Intelligence COSMOS (v4)

**A — Gap Detection Visuel (Prérequis Manquants)**
- Traversal petgraph (Rust, $0) sur arêtes `prerequisite_of`
- Nœuds prérequis absents de la base utilisateur → affichés en pointillés rouges dans COSMOS
- CTA "Combler cette lacune" → déclenche Agent-02 CONTENT-SCOUT
- Toggle : bouton "🔍 Voir les lacunes" dans controls COSMOS
- Phase recommandée : Phase 0-1 (coût nul, feature killer différenciante)

**B — Prescriptive Insights Panel (Opportunité #4)**
- Panel flottant bas-gauche, max 3 insights simultanés (Miller's Law)
- Règles Rust pures : gaps, révisions overdue, clusters faibles → $0 LLM
- Chaque insight : titre court + explication + CTA avec temps estimé
- Urgence visuelle : 'critical' → toast rouge pulsant 5s
- Phase recommandée : Phase 1

---

### D — Sceau de Double Validation Théorique (AI vs Human Dual Confidence) 🔴 CRITIQUE

**Description** : Pour transformer le graphe en un véritable outil scientifique rigoureux d'acquisition de connaissances, toutes les arêtes sémantiques de la Base de Connaissances (Mode 0) et du Graphe Projet (Mode 2) affichent un badge de double validation (zoom > 35%) :
- **Le Score IA (🤖)** : Confiance sémantique de l'extraction par l'IA (en-tête de 0 à 100%).
- **Le Score Humain (👤 / 👥)** : Statut de validation personnel de l'utilisateur (`✓ Validé par moi`) ou taux de consensus des pairs de la communauté (`👥 XX%`).
- **Sceau de Consensus Doré** : Si le score IA $\ge 85\%$ et le score Humain $\ge 90\%$, l'arête s'affiche en doré lumineux continu, certifiant un consensus théorique validé.
- **Conflit Sémantique / Rejet (⚠️)** : Si le lien est personnellement rejeté ou contesté par la communauté ($< 40\%$), l'arête est striée en rouge de manière discontinue avec une icône d'avertissement, matérialisant les failles et conflits de théories à corriger.

---

### E — Mode 25 : Knowledge Cards (Dashboard Spatial Interactif & Squelette Shimmer Localisé) 🔴 CRITIQUE

**Description** : Vue d'apprentissage de type "Dashboard Spatial" où les concepts ne sont pas de simples cercles dans un réseau abstrait, mais des cartes de contrôle verticales riches (custom nodes React Flow).
- **Contenu de Carte** : Nom, résumé de définition sémantique, niveau SMI actuel, jauge de stabilité mémorielle FSRS (couleur pulsante selon l'échéance), mini-radar de compétences, et boutons d'action rapide.
- **Squelette Shimmer Localisé (Pending State)** : Pendant la phase de récupération des métadonnées asynchrones de la carte, celle-ci est déjà affichée à l'écran pour structurer le viewport, mais ses champs internes (titre, texte, radar) affichent un **Squelette Shimmer de balayage luminescent fluide** translucide. Dès que la donnée arrive, le shimmer s'efface pour laisser place au vrai contenu de manière fluide (transition CSS opacity).
- **Liaisons de Flux Animées (CSS Motion Paths & WAAPI)** : Les arêtes reliant ces cartes ne sont pas de simples lignes inertes. Ce sont de véritables **canalisations de transfert de connaissances**. De petits nodules de données (des particules lumineuses SVG) glissent physiquement et de manière fluide le long des courbes de Bézier à une vitesse de défilement proportionnelle à la proximité sémantique de la relation, démontrant visuellement la puissance des interconnexions sémantiques et d'apprentissage du graphe.

---

### F — MiniMap Navigation GPS (Localisateur de Graphe) 🔴 HAUTE

**Description** : Module de géolocalisation sémantique situé en bas-droite de l'interface visuelle (180×120px) affichant la silhouette complète du graphe en miniature. Un viseur délimite la zone actuellement visible à l'écran. Faire glisser le viseur permet d'ajuster instantanément le viewport principal (pan/zoom) de manière fluide.

---

### G — Progressive Rendering & L'Allumage Neural (The Neural Ignition Reveal) 🔴 WAOUH EFFECT

**Description** : Les shimmers classiques (rectangles gris et blancs plats) sont inadaptés et ennuyeux pour une base de connaissances vivante. COSMOS utilise une **séquence cinématique interactive d'allumage neural (The Neural Ignition Reveal)** :
1. **La Constellation** (0-500ms) : Fond sombre cognitif avec micro-particules flottantes (bruit de fond cérébral).
2. **L'Étincelle des Hubs** (500ms-1.5s) : Les concepts majeurs (PageRank élevé) s'allument comme des nébuleuses lumineuses pulsantes, projetant des faisceaux laser de connexions.
3. **La Condensation** (1.5s-3s) : Les sous-concepts apparaissent organiquement le long des lignes de force avec un dé-zoom fluide de la caméra.
4. **La Stabilisation** (3s+) : La simulation physique s'amortit et les labels textuels apparaissent avec un effet de flou à net ultra-premium.

---

### H — Generative-Canvas-AI (FlowSeek) pour Slides & Pages de Cours 🔴 HAUTE

**Description** : Composant d'illustration dynamique et interactif s'intégrant au sein des slides ASCENT et des pages de cours textuels. Plutôt que d'afficher une infographie statique (`InfographicAI`), l'agent IA (`NEURON-CHAINS`) émet un flux JSON d'événements traduisant un concept (architecture technique, processus, arbre de décision). Le frontend React Flow couplé au solveur d'auto-layout local **`elkjs`** dessine et anime le graphe en temps réel à 60 FPS constants sous les yeux de l'apprenant à mesure que l'explication textuelle s'écrit, créant un effet d'explication cinématique inégalé (coût serveur de calcul de coordonnées = 0$).

#### 📝 Synergie & Complémentarité : InfographicAI ↔ Generative-Canvas-AI (FlowSeek)

Dans l'écosystème d'apprentissage de SCY Forge, les deux moteurs d'illustration générative opèrent en parfaite synergie, chacun couvrant un hémisphère distinct de la compréhension :

| Dimension | InfographicAI (Le Noyau Factuel & Quantitatif) | Generative-Canvas-AI / FlowSeek (Le Noyau Structurel & Procédural) |
|-----------|------------------------------------------------|-------------------------------------------------------------------|
| **Rôle Cognitif** | Synthétiser et comparer des données factuelles, numériques, tabulaires ou comparatives (Dual Coding). | Visualiser des flux d'exécution, des étapes séquentielles, des dépendances de cause à effet et des architectures sémantiques. |
| **Moteur Visualisé** | Graphiques (barres, courbes, camemberts), matrices de décisions, tableaux comparatifs multicritères, diagrammes de répartition. | Graphes nodaux interactifs, arbres décisionnels, pipelines d'intégration, diagrammes de flux d'informations animés. |
| **Technologie Rendu** | Canvas 2D / SVG (`recharts` ou `nivo` spécialisé). | Canvas interactif React Flow (`@xyflow/react`) + Solveur d'auto-layout local `elkjs`. |
| **Type d'Explication** | *"Voici la répartition des coûts ou la comparaison des performances entre 3 algorithmes."* | *"Voici le chemin physique exact qu'un paquet réseau parcourt à travers ces 4 services pour s'authentifier."* |
| **Streaming Style** | Les barres ou les lignes de données montent ou se tracent au fur et à mesure que les nombres sont calculés. | Les nœuds de cartes (Knowledge Cards) se condensent un à un et des particules lumineuses se mettent à glisser le long des bras de force. |
| **Interactivité** | Hover sur les barres pour afficher des tooltips de données, filtres statiques. | Drag-and-drop, zoom sémantique sans limite, survol comportemental des cartes, MiniMap GPS de navigation. |

---

### I — Rendu de Blocs Techniques Multi-Vues (Math, Code, Équations, Diagrammes) 🔴 CRITIQUE

**Description** : Pour les formations scientifiques et techniques (Sciences, Finance, IA, Chimie, Algorithmique), les équations et les syntaxes brutes écrites en texte simple fatiguent la mémoire de travail et provoquent des erreurs de lecture. Le *Active Reading Layer* intègre un **Moteur de Rendu Technique Multi-Vues** inspiré de Notion.
- **Équations LaTeX (KaTeX)** : Toutes les formules mathématiques, matrices et intégrales sont compilées à la volée côté client par la bibliothèque ultra-rapide **`KaTeX`** (défilement à 60 FPS, coût d'opération serveur de 0$).
- **Playground de Code Interactif** : Coloration syntaxique haute-fidélité (Shiki / Prism.js) avec thèmes sombres/clairs dynamiques et un bouton `[▶ Exécuter]` pour faire tourner localement (WASM) le code et afficher le résultat en direct.
- **Notion-Style Multi-View Toggles** : Pour tout bloc technique généré par l'IA, l'utilisateur peut cliquer sur un menu de basculement à 50+ styles sémantiques pour changer le format d'affichage à sa convenance : **Vue Mathématique** (formule LaTeX compilée) $\leftrightarrow$ **Vue Sémantique** (explication textuelle) $\leftrightarrow$ **Vue Code** (script Python/Rust d'application) $\leftrightarrow$ **Vue Graphique** (COSMOS micro-coordonnée) $\leftrightarrow$ **Vue Diagramme** (Mermaid.js ou AntV Infographic).
- **Rôle cognitif** : Respect de la loi **L7 (Contrôle perçu)** et du Double Codage. L'apprenant n'est jamais bloqué : s'il ne comprend pas l'équation mathématique, il bascule en 1 clic sur l'explication sémantique ou le schéma visuel.



### 7.5 Module APEX — Système Rétention FSRS `[Rôle : Frontend / AI / Backend]` (Active Practice & Expertise System)

**Source** : audit-scy-part1.md, lignes 227-234 | **Confiance** : 98%  
**Technologies** :

| Technologie | Version | Rôle |
|------------|---------|------|
| **fsrs** | 0.6 | Algorithme FSRS 5.0 Rust natif (0 LLM) |
| **rusqlite** | 0.31 | Historique révisions Desktop (WAL mode) |
| **PostgreSQL** | 15+ | Historique révisions Cloud (Northflank) |
| **tiktoken-rs** | 0.6 | Comptage tokens cartes |
| **async-openai** | 0.29 | Génération cartes via NEURON-CHAINS |

---

#### 7.5.1 FSRS 5.0 Scheduler — Algorithme Central `[Rôle : AI / Backend]`

**Principe** : FSRS (Free Spaced Repetition Scheduler) est l'algorithme SRS état-de-l'art 2024. Il modélise la mémoire humaine via 3 paramètres par carte, recalculés après chaque révision. **Zéro appel LLM — pur calcul Rust.**

**Paramètres FSRS par carte :**
- **Stability (S)** : Durée (en jours) avant que la retrievability tombe à 90%. Ex : S=10 → dans 10j, probabilité de souvenir = 90%
- **Difficulty (D)** : Score 1-10 représentant la difficulté intrinsèque du concept pour cet utilisateur
- **Retrievability (R)** : Probabilité estimée de rappel correct au moment t, calculée par `R = e^(-t/S)`

**Métriques FSRS globales :**
- ✅ **Retention rate cible** : 90% (configurable 85-95% dans Settings)
- ✅ **Interval growth** : ×2.5 médian (réponses Good)
- ✅ **Reviews/day** : ~20-50 cartes (selon backlog accumulé)
- ✅ **Forecast 30j futurs** : Graphique bar chart (cartes dues par jour, planification charge cognitive)
- ✅ **Optimisation par domaine** : Paramètres FSRS différenciés (géographie vs maths vs code) selon PAPER-005

**4 États de Carte (State Machine FSRS) :**
```
New → [première révision] → Learning
Learning → [Good/Easy répétés] → Review
Review → [Again] → Relearning
Relearning → [Good/Easy] → Review
```
- ✅ **New** : Jamais révisée, sort du deck en attente
- ✅ **Learning** : En cours d'apprentissage initial (intervalles courts : 1min, 10min, 1j)
- ✅ **Review** : Maîtrisée, intervalles longs (algorithme FSRS complet)
- ✅ **Relearning** : Oubliée depuis état Review, intervalles de récupération

**Calibration automatique paramètres :**
- ✅ Ajustement des 17 paramètres FSRS selon historique personnel (après 1000+ révisions)
- ✅ Personnalisation par domaine de connaissance (PAPER-005)
- ✅ History Replay : Recalcul rétroactif si algorithme amélioré (Event Sourcing FSRS)

---

#### 7.5.2 Les 10 Types de Cartes (B01-B10)

**Phase MVP — 5 types actifs :**

**B01 — Carte Exposition**
- Rôle pédagogique : Introduction passive d'un concept (pas de question)
- Usage : Primo-découverte, concepts difficiles nécessitant exposition avant évaluation
- Format : Texte + exemples visuels optionnels
- FSRS : Interval court (revu souvent en début d'apprentissage)
- Génération : EPSILON-1, modèle DeepSeek V4

**B02 — Carte Définition**
- Rôle pédagogique : Retrieval Practice (rappel actif terme → définition)
- Usage : Vocabulaire, concepts fondamentaux, terminologie
- Format : `[Terme]` → `[Définition complète + exemple]`
- FSRS : Algorithme standard, interval croissant selon performance
- Génération : EPSILON-1

**B03 — Carte MCQ (Multiple Choice)**
- Rôle pédagogique : Recognition testing (discrimination entre options)
- Usage : Concepts avec confusions fréquentes, distinctions subtiles
- Format : Question + 4 options (1 correcte, 3 distracteurs plausibles)
- Distracteurs : Générés intelligemment (erreurs communes réelles, pas aléatoires)
- FSRS : Pénalité renforcée si Again (oubli sur MCQ = signal fort)
- Génération : EPSILON-3

**B04 — Carte Short Answer**
- Rôle pédagogique : Recall actif texte libre (niveau supérieur au MCQ)
- Usage : Explications, processus, relations causales
- Format : Question ouverte → Réponse attendue (keywords + modèle de réponse)
- Évaluation : Auto-évaluation par l'utilisateur (comparer sa réponse au modèle)
- FSRS : Algorithme standard
- Génération : EPSILON-1

**B05 — Carte Application**
- Rôle pédagogique : Transfer Learning (appliquer dans un contexte nouveau)
- Usage : Concepts pratiques, algorithmes, méthodes
- Format : `[Problème contextuel]` → `[Solution step-by-step + explication]`
- FSRS : Seuil de succès plus élevé (Good requis 2× avant augmentation interval)
- Génération : EPSILON-2

**Phase Post-MVP V1-V2 — 5 types additionnels :**

**B06 — Carte Analogie**
- Rôle pédagogique : Compréhension profonde via comparaison métaphorique
- Format : `[Concept cible]` = `[Analogie intuitive]` + explication
- Génération : GAMMA-2 (Générateur Analogies)

**B07 — Carte Teaching (Feynman Technique)**
- Rôle pédagogique : Miroir Cognitif — apprendre en enseignant
- Format : `[Expliquez [concept] comme si vous l'enseigniez à un débutant]`
- Évaluation : LLM évalue qualité explication (via BRAIN)
- Lien SMI : Dimension "Mirror" calculée depuis scores B07

**B08 — Carte Cloze (Texte à Trous)**
- Rôle pédagogique : Complétion contextuelle (mémorisation en contexte)
- Format : `"Le réseau neuronal utilise une fonction d'activation {{sigmoid}} pour normaliser les sorties"`
- Génération automatique depuis documents ingérés (EPSILON-1)

**B09 — Carte Image Occlusion**
- Rôle pédagogique : Mémorisation visuelle (diagrammes, schémas)
- Format : Image avec zones cachées à retrouver
- Usage : Anatomie, architecture systèmes, organigrammes

**B10 — Carte Audio**
- Rôle pédagogique : Apprentissage multimodal (écoute active)
- Format : Question vocale TTS → Réponse texte ou vocale
- Technologie : OpenAI TTS API (génération), Whisper (évaluation réponse vocale)

---

#### 7.5.3 Feedback 4 Niveaux (D-005) — Phase MVP

**Principe** : L'utilisateur évalue subjectivement sa facilité de rappel après avoir vu la réponse. FSRS recalcule immédiatement les paramètres S et D.

| Niveau | Clé | Signification | Impact FSRS |
|--------|-----|--------------|-------------|
| **Again** | `1` | Oublié totalement | Reset → Learning, +1 lapse, interval < 1j |
| **Hard** | `2` | Rappelé avec difficulté | Interval × 0.5 (réduit de 50%) |
| **Good** | `3` | Rappelé normalement | Interval × 2.5 (croissance standard) |
| **Easy** | `4` | Rappelé sans effort | Interval × 4.0 + graduated (forte augmentation) |

**Comportements spéciaux :**
- ✅ **Calibration automatique** : Si un utilisateur utilise trop "Easy", FSRS ajuste le modèle pour allonger les intervalles
- ✅ **Lapse penalty** : Chaque "Again" sur une carte Review déclenche une pénalité sur le paramètre Stability
- ✅ **Undo** : Annuler la dernière évaluation (bouton U ou Ctrl+Z) — revient à l'état FSRS précédent
- ✅ **Raccourcis clavier APEX** :
  - `Space` → Reveal answer (afficher réponse)
  - `1` → Again | `2` → Hard | `3` → Good | `4` → Easy
  - `U` → Undo dernière review
  - `R` → Replay audio (carte B10)
  - `E` → Edit card (modifier contenu)
  - `Ctrl+Z` → Undo

**UX Session APEX :**
- ✅ Barre de progression (X cartes révisées / Y total session)
- ✅ Timer par carte (temps passé, affiché après flip)
- ✅ Statistiques session live (% correctes, streak actuel)
- ✅ Abandon session gracieux (progrès FSRS sauvegardé au fur et à mesure)
- ✅ Mobile : Swipe left (Again), Swipe right (Easy), Tap (reveal/Good) — React Native PanResponder Phase 2

---

#### 7.5.4 Miroir Cognitif — 3 Modes selon SMI (Phase Post-MVP V2)

**Principe** : Après chaque session APEX, le Miroir Cognitif pose une question métacognitive adaptée au niveau de maîtrise actuel (SMI). C'est la dimension "Mirror" du SMI.

**Mode 1 — SMI < 40% (Restitution libre)**
- Question : *"En une phrase, qu'avez-vous principalement retenu aujourd'hui ?"*
- Objectif : Forcer la restitution active même sur des bases fragiles
- Scoring : Longueur + présence de mots-clés (1-5)
- Interface : Zone texte libre, pas d'évaluation stricte

**Mode 2 — SMI 40-70% (Reformulation)**
- Question : *"Expliquez [concept du nœud actuel] comme si vous l'enseigniez à un enfant de 10 ans"*
- Objectif : Tester compréhension profonde vs mémorisation superficielle
- Scoring : BRAIN évalue qualité (cohérence, complétude, clarté) → score 1-5
- Interface : Zone texte + feedback qualitatif de BRAIN

**Mode 3 — SMI > 70% (Application et Métacognition)**
- Question : *"Où pourriez-vous concrètement utiliser [concept] dans votre travail ou vie demain ?"*
- Objectif : Transfer learning + ancrage mémoriel contextuel
- Scoring : Spécificité + faisabilité de l'application proposée
- Interface : Zone texte + détection sur-confiance

**Features communes Miroir Cognitif :**
- ✅ Scoring confiance auto-déclaré (1-5) : "À quel point êtes-vous confiant ?"
- ✅ Détection sur-confiance (Dunning-Kruger) : confiance déclarée >> performance réelle → alerte
- ✅ Stockage réponses (historique consultable)
- ✅ Dimension "Metacognition" du SMI calculée depuis calibration confiance vs réalité (D-006)
- ✅ Fréquence : 1 question Miroir par session (pas après chaque carte)

---

#### 7.5.5 SMI Calculator — Score de Maîtrise Intégrée /100 `[Rôle : AI / Backend]`

**Formule officielle :**
```
SMI = (Retention × 0.35) + (Depth × 0.25) + (Mirror × 0.20)
      + (Metacognition × 0.10) + (Consistency × 0.05)
```

> ⚠️ Note : Le document FEATURES-V1 indiquait Consistency × 0.05 (pas 0.10). La formule ci-dessus est la version consolidée officielle. Les coefficients totalisent exactement 1.00.

**Calcul de chaque dimension (Rust pur, 0 LLM) :**

**Retention (35%)** — Source : historique FSRS
```
retention = (good_reviews + easy_reviews) / total_reviews
          × (1 - lapse_rate_30j)
          × stability_factor  // Cartes en état "Review" vs "Learning"
// Normalisé 0-100
```

**Depth (25%)** — Source : scores exercices ASCENT
```
depth = weighted_avg(exercise_scores, complexity_weights)
// Exercices complexity 4-5 pèsent 2× plus que complexity 1-2
// Normalisé 0-100
```

**Mirror (20%)** — Source : cartes B07 + Miroir Cognitif
```
mirror = avg(teaching_card_scores)  // B07 scores évalués par BRAIN
       + miroir_cognitif_scores     // Scores mode 2 et 3
// Normalisé 0-100
```

**Metacognition (10%)** — Source : calibration D-006
```
metacognition = 100 - abs(confidence_declared - actual_performance) × 2
// Parfaite calibration = 100, écart de 50pts = 0
```

**Consistency (5%)** — Source : Timeline COSMOS
```
consistency = sessions_done_last_30j / sessions_planned_last_30j
            × streak_bonus  // +10% si streak ≥ 7j
// Normalisé 0-100
```

**Seuils SMI et leurs effets :**
| Seuil | Label | Couleur COSMOS | Action Agent-06 |
|-------|-------|--------------|-----------------|
| SMI < 40 | Faible | Rouge 🔴 | Remédiation intensive |
| 40 ≤ SMI < 60 | En construction | Orange 🟠 | Consolidation |
| 60 ≤ SMI < 70 | Presque là | Jaune 🟡 | Consolidation légère |
| 70 ≤ SMI < 86 | Maîtrisé ✅ | Vert 🟢 | Progression normale |
| SMI ≥ 86 | Expert 🏅 | Or ⭐ | Fast-track eligible |

**Features SMI :**
- ✅ Calcul après chaque révision APEX (latence <1ms, Rust pur)
- ✅ Breakdown 5 dimensions (radar chart dans COSMOS Statistics Mode 7)
- ✅ Evolution temporelle (line chart 12 semaines dans COSMOS)
- ✅ Export LinkedIn/CV : Badge "SMI [score]/100 — [domaine] (SCY Forge)" + URL vérification
- ✅ SMI par nœud ASCENT (visible dans COSMOS Roadmap mode 4, couleurs états)
- ✅ SMI global portfolio (dashboard accueil)
- ✅ SMI prédictif : Estimation SMI dans 7j/30j selon rythme actuel (FSRS forecast)

---

#### 7.5.6 Leech Detection — Cartes Problématiques

**Définition** : Une "leech" est une carte dont l'utilisateur n'arrive pas à se souvenir malgré de nombreuses révisions. Elle consomme du temps de révision sans retour.

**Critère de détection :**
- ✅ Cartes avec **> 8 lapses** (oubliées > 8 fois depuis état Review)
- ✅ Cartes avec **taux d'échec > 80%** sur les 10 dernières révisions

**Actions automatiques sur leech détectée :**
- ✅ Tag automatique `#leech` (visible dans Concepts Grid COSMOS mode 5)
- ✅ Notification in-app : *"Cette carte vous pose problème. Voici des alternatives :"*
- ✅ Suggestions générées par NEURON-CHAINS :
  - Carte Analogie B06 (même concept, angle métaphorique)
  - Carte Exposition B01 (retour aux bases)
  - Exercice facile C01 (application concrète moins abstraite)
  - Document IMPRINT (mémorisation profonde manuscrite)
- ✅ Suspension automatique optionnelle (carte retirée du scheduling temporairement)
- ✅ Alerte DRIFT-GUARDIAN si >5 leeches simultanées (signal blocage possible)

---

#### 7.5.7 Due Cards Forecast — Planification Charge

**Description** : Graphique Recharts (bar chart) montrant combien de cartes seront dues chaque jour sur les 30 prochains jours. Permet à l'utilisateur de planifier sa charge cognitive.

**Features :**
- ✅ Forecast 30j calculé depuis états FSRS actuels de toutes les cartes
- ✅ Affichage bars par jour (bleu = révisions normales, rouge = overdue)
- ✅ Ligne objectif quotidien (configurable : ex. 30 cartes/jour)
- ✅ Alerte si pic détecté (ex : 120 cartes en un jour → suggestion d'étaler)
- ✅ Filtrable par deck, tag, nœud ASCENT
- ✅ Vue hebdomadaire optionnelle (groupement par semaine)
- ✅ Estimation durée session (cards_due × 2min estimation)

---

#### 7.5.8 Stats Dashboard APEX

**Description** : Tableau de bord complet de l'état du deck de révision, disponible dans COSMOS Mode 7 (Statistics) et sur le Dashboard Accueil.

**Métriques affichées :**

| Métrique | Description | Mise à jour |
|---------|-------------|-------------|
| **Total cartes** | Toutes cartes dans le système | Temps réel |
| **New** | Cartes jamais révisées (état New) | Temps réel |
| **Learning** | Cartes en apprentissage initial | Après session |
| **Review** | Cartes maîtrisées (intervalles longs) | Après session |
| **Relearning** | Cartes oubliées en récupération | Après session |
| **Suspended** | Cartes mises en pause manuellement | Temps réel |
| **Dues today** | Cartes à réviser aujourd'hui | Temps réel |
| **Overdue** | Cartes en retard (non révisées à temps) | Temps réel |
| **Retention rate** | % bonnes réponses (30 derniers jours) | Après session |
| **Average interval** | Durée moyenne entre révisions (jours) | Après session |
| **Reviews today** | Révisions effectuées aujourd'hui | Après session |
| **Streak actuel** | Jours consécutifs avec révision | Quotidien |
| **Streak max** | Record personnel de streak | Historique |

**Features Stats :**
- ✅ Filtres par nœud ASCENT (stats d'un nœud spécifique)
- ✅ Filtres par tag, domaine, source
- ✅ Comparaison semaine actuelle vs semaine précédente (% delta)
- ✅ Export CSV/Excel des stats (rust_xlsxwriter backend)
- ✅ Heatmap contributions style GitHub (52 semaines × 7 jours) dans COSMOS Timeline

---

#### 7.5.9 Import Anki — Conversion SM-2 → FSRS

**Technologies** : zip 2.1 + rusqlite 0.31 + fsrs 1.x

**Processus d'import :**
1. Upload fichier `.apkg` (ZIP contenant SQLite + media)
2. Extraction et parsing `collection.anki2` (SQLite)
3. Lecture paramètres SM-2 par carte (interval, ease_factor, reps, lapses)
4. Conversion SM-2 → FSRS parameters (algorithme de mapping)
5. Création cartes SCY Forge avec états FSRS calculés
6. Import médias (images, audio) si présents

**Features import :**
- ✅ Préservation tags et decks hiérarchiques (mapping → tags SCY Forge)
- ✅ Conversion historique SM-2 → état FSRS initial
- ✅ Support LaTeX formules (MathJax rendering front-end)
- ✅ Import médias (images PNG/JPG/SVG, audio MP3)
- ✅ Rapport import : X cartes importées, Y médias, Z erreurs
- ✅ Détection doublons (hash contenu carte)
- ✅ Prévisualisation avant import (10 premières cartes)

---

#### 7.5.10 Export Anki — SCY Forge → .apkg

**Technologies** : zip 2.1 + rusqlite 0.31

**Features export :**
- ✅ Export cartes APEX → fichier `.apkg` compatible Anki/AnkiDroid/AnkiMobile
- ✅ FSRS parameters embedded (AnkiDroid 2.18+ supporte FSRS natif)
- ✅ 5 types cartes → templates Anki correspondants
- ✅ Médias bundling dans archive ZIP
- ✅ Decks hiérarchiques (tags SCY Forge → sous-decks Anki)
- ✅ Tags préservés
- ✅ Export sélectif (par nœud ASCENT, par tag, par domaine)

---

#### 7.5.11 Suspension & Gestion Manuelle Cartes

- ✅ **Suspendre carte** : Retirer temporairement du scheduling (carte non proposée)
- ✅ **Bury card** : Reporter la carte au lendemain (sans l'oublier)
- ✅ **Bury siblings** : Reporter les cartes issues du même concept (éviter sur-test)
- ✅ **Unsuspend** : Réactiver une carte suspendue
- ✅ **Delete** : Suppression soft (deleted_at, récupérable 30j)
- ✅ **Edit** : Modifier contenu front/back en cours de session
- ✅ **Flag** : Marquer une carte pour révision manuelle ultérieure (5 couleurs)
- ✅ **Add note** : Ajouter une note personnelle à une carte (visible au dos)

---

#### 7.5.12 Gamification APEX (via Agent-08)

- ✅ **Streaks** : Jours consécutifs avec au moins 1 révision
  - Bronze badge : 7 jours consécutifs 🥉
  - Silver badge : 30 jours consécutifs 🥈
  - Gold badge : 100 jours consécutifs 🥇

- ✅ **Protection de Streak** (Phase 1) :
  - **Streak Freeze** : 1 freeze/mois (Free), 3 freezes/mois (Premium) — protège le streak si l'utilisateur rate 1 journée
  - **Streak Repair** : Dans les 24h suivant une coupure, réviser 2× l'objectif quotidien pour "réparer" le streak
  - Notification proactive (Agent-07) : "Votre streak de 15 jours est en danger — il vous reste 4h pour réviser !"

- ✅ **XP par action** :
  - Révision Again : +2 XP
  - Révision Hard : +5 XP
  - Révision Good : +8 XP
  - Révision Easy : +10 XP
  - Session complète (toutes cartes dues) : +25 XP bonus
  - Teach-Back réussi (>70% coverage) : +50 XP
  - Nœud ASCENT complété : +100 XP
  - Quête daily complétée : +30 XP bonus

- ✅ **Achievements** :
  - "Premier pas" : Première révision
  - "Centenaire" : 100 cartes révisées
  - "Millionnaire" : 1000 cartes révisées
  - "Sans faute" : Session 100% Good/Easy
  - "Leech Slayer" : Résoudre une leech (0 Again sur 5 tentatives)

- ✅ **Challenges Hebdomadaires** (Phase 1) :
  - Générés automatiquement par Agent-08 chaque lundi matin
  - Exemples : "Révisez 100 cartes cette semaine", "Atteignez SMI 80 sur un nœud", "Complétez 3 sessions Teach-Back"
  - Récompenses : XP ×2 + badge spécial "Challenge [Semaine N] Complété"
  - Difficulté adaptée au niveau de l'utilisateur (historique 4 semaines)

- ✅ **Quêtes Daily** (Phase 1) :
  - 3 quêtes quotidiennes renouvelées à minuit (heure locale)
  - Exemples : "Réviser 10 cartes", "Compléter 1 session APEX", "Explorer 1 nouveau nœud ASCENT", "Poser 1 question à BRAIN"
  - Récompenses : XP × 2 si les 3 quêtes complétées dans la journée
  - Générées par Agent-08 selon le contexte utilisateur (nœud actuel, streak, SMI)

- ✅ **Leaderboards Optionnels** (Phase 2, opt-in uniquement) :
  - Classement hebdomadaire par XP dans le même domaine (React, Machine Learning, etc.)
  - Pseudonyme uniquement (jamais de nom réel, privacy-first)
  - Opt-out total possible à tout moment dans Settings
  - Pas de classement global forcé (anti-toxicité)
  - Badge "Top 10% cette semaine" si applicable

- ✅ **Heat Map Annuelle** (Phase 2) :
  - Visualisation contribution style GitHub (365 jours × intensité révision)
  - Couleur = nombre de cartes révisées ce jour (blanc → bleu clair → bleu foncé)
  - Position : Dashboard accueil + COSMOS Mode 7 Statistics
  - Exportable en PNG (partage LinkedIn "Mon année d'apprentissage SCY Forge")

---

#### 7.5.12 bis — UX Session APEX — Fonctionnalités Manquantes

- ✅ **Audio TTS pour toutes cartes** (Phase 1) :
  - Text-To-Speech disponible pour cartes B01, B02, B03, B04, B05 (pas seulement B10)
  - Usage : Mode mains-libres (conduite, sport), accessibilité malvoyants
  - Touche `R` → lecture audio de la carte courante (déjà dans PRD pour B10, étendu)
  - Technologie : OpenAI TTS API (déjà dans §9.1)

- ✅ **Timer Optionnel par Carte** (Phase 1) :
  - Timer configurable : 5s / 10s / 15s / 30s / Désactivé
  - Force le rappel actif plus rapide, simule conditions d'examen
  - Visible dans Settings APEX → "Mode Pression Temporelle"
  - Alerte sonore douce à l'expiration (pas de pénalité automatique)

- ✅ **Mode Focus Plein Écran** (Phase 0) :
  - Raccourci `F` → masque navigation latérale, notifications silencées, fond épuré
  - Barre de progression minimale en bas (% session, streak actuel)
  - `Escape` → quitter mode focus

- ✅ **Mode Nuit Automatique** (Phase 0) :
  - Basculement dark mode selon heure système (configurable : 20h-7h par défaut)
  - Ou : suivi préférence OS (`prefers-color-scheme`) — toujours synchronisé
  - Transition douce 300ms, sans rechargement de page

---

#### 7.5.13 Schéma BDD APEX — Tables Complètes

```sql
-- Cartes révision
CREATE TABLE scy_apex_cards (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  concept_id UUID REFERENCES scy_concepts(id),
  document_id UUID REFERENCES scy_documents(id),
  node_id UUID REFERENCES scy_ascent_nodes(id),    -- Lien nœud ASCENT
  card_type TEXT NOT NULL CHECK (card_type IN (
    'exposition','definition','mcq','short_answer','application',
    'analogy','teaching','cloze','image_occlusion','audio'
  )),
  front_content TEXT NOT NULL,
  back_content TEXT NOT NULL,
  mcq_options JSONB NULL,           -- {options: ["A","B","C","D"], correct_index: 2}
  cloze_template TEXT NULL,         -- Template avec {{champs}} pour B08
  media_urls JSONB NULL,            -- [{type: "image", url: "...", alt: "..."}]
  -- États FSRS
  fsrs_state JSONB NOT NULL,        -- {stability, difficulty, elapsed_days, scheduled_days, state}
  fsrs_card_state TEXT NOT NULL DEFAULT 'New', -- 'New','Learning','Review','Relearning'
  next_review_at INTEGER NOT NULL,  -- Unix timestamp
  -- Métriques
  total_reviews INTEGER DEFAULT 0,
  total_lapses INTEGER DEFAULT 0,
  consecutive_correct INTEGER DEFAULT 0,
  is_leech BOOLEAN DEFAULT false,   -- true si lapses > 8
  is_suspended BOOLEAN DEFAULT false,
  is_buried BOOLEAN DEFAULT false,
  flags INTEGER DEFAULT 0,          -- Bitmask couleurs flags (1=rouge, 2=orange, etc.)
  user_note TEXT NULL,              -- Note personnelle utilisateur
  -- Tracking
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
);

-- Sessions révision
CREATE TABLE scy_apex_sessions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  goal_id UUID REFERENCES scy_ascent_goals(id),    -- Contexte ASCENT si applicable
  node_id UUID REFERENCES scy_ascent_nodes(id),    -- Nœud ciblé si micro-session
  session_type TEXT NOT NULL DEFAULT 'manual',      -- 'micro','standard','deep','marathon','manual'
  started_at INTEGER NOT NULL,
  ended_at INTEGER NULL,
  cards_reviewed INTEGER DEFAULT 0,
  cards_correct INTEGER DEFAULT 0,
  cards_again INTEGER DEFAULT 0,
  cards_hard INTEGER DEFAULT 0,
  cards_good INTEGER DEFAULT 0,
  cards_easy INTEGER DEFAULT 0,
  duration_seconds INTEGER,
  xp_earned INTEGER DEFAULT 0,
  streak_day INTEGER,               -- Jour de streak correspondant
  created_at INTEGER NOT NULL
);

-- Reviews individuelles (Event Sourcing FSRS — immuable)
CREATE TABLE scy_apex_reviews (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  session_id UUID NOT NULL REFERENCES scy_apex_sessions(id),
  card_id UUID NOT NULL REFERENCES scy_apex_cards(id),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  rating TEXT NOT NULL CHECK (rating IN ('again','hard','good','easy')),
  elapsed_seconds INTEGER,          -- Temps passé sur cette carte
  fsrs_state_before JSONB NOT NULL, -- État avant review (Event Sourcing)
  fsrs_state_after JSONB NOT NULL,  -- État après review (calculé)
  reviewed_at INTEGER NOT NULL,
  -- RGPD : cet enregistrement NE PEUT PAS être modifié
  CONSTRAINT reviews_immutable CHECK (true) -- Rappel intention immuable
);

-- Miroir Cognitif — réponses métacognitives
CREATE TABLE scy_apex_mirror_responses (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  session_id UUID NOT NULL REFERENCES scy_apex_sessions(id),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  node_id UUID REFERENCES scy_ascent_nodes(id),
  miroir_mode INTEGER NOT NULL CHECK (miroir_mode IN (1,2,3)),
  question TEXT NOT NULL,
  user_response TEXT NOT NULL,
  confidence_declared INTEGER CHECK (confidence_declared BETWEEN 1 AND 5),
  score_evaluated INTEGER CHECK (score_evaluated BETWEEN 1 AND 5),
  evaluator TEXT,                   -- 'auto' (règles) ou 'brain' (LLM BRAIN)
  dunning_kruger_alert BOOLEAN DEFAULT false,
  responded_at INTEGER NOT NULL
);

-- Leech tracking
CREATE TABLE scy_apex_leeches (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  card_id UUID NOT NULL REFERENCES scy_apex_cards(id),
  detected_at INTEGER NOT NULL,
  lapse_count INTEGER NOT NULL,
  action_taken TEXT,                -- 'suspended','alternative_suggested','imprint_triggered'
  resolved BOOLEAN DEFAULT false,
  resolved_at INTEGER NULL
);

-- Indexes APEX critiques
CREATE INDEX idx_cards_next_review ON scy_apex_cards(user_id, next_review_at)
  WHERE deleted_at IS NULL AND is_suspended = false AND is_buried = false;
CREATE INDEX idx_cards_leech ON scy_apex_cards(user_id, is_leech)
  WHERE is_leech = true;
CREATE INDEX idx_cards_node ON scy_apex_cards(node_id)
  WHERE node_id IS NOT NULL;
CREATE INDEX idx_reviews_card_time ON scy_apex_reviews(card_id, reviewed_at DESC);
CREATE INDEX idx_sessions_user ON scy_apex_sessions(user_id, started_at DESC);
CREATE INDEX idx_mirror_user ON scy_apex_mirror_responses(user_id, responded_at DESC);
```

---

#### 7.5.14 Intégration APEX ↔ ASCENT Pipeline

- ✅ **Agent-03 (DAG-ARCHITECT)** → Crée 12 cartes par nœud lors de la construction du DAG
  - 3 cartes B02 (définitions concepts clés)
  - 3 cartes B03 (MCQ distinctions importantes)
  - 3 cartes B04 (questions courtes processus)
  - 3 cartes B05 (application pratique)
- ✅ **Agent-04 (LEARNING-CONDUCTOR)** → Sélectionne cartes dues pour chaque session
  - Priorise cartes overdue (retard FSRS)
  - Priorise cartes nœud actuel si session contextualisée
  - Ajuste nombre selon temps disponible (micro = 2 cartes, deep = 20+ cartes)
- ✅ **Agent-05 (PERFORMANCE-ANALYZER)** → Lit historique APEX pour calculer SMI (dimension Retention)
- ✅ **Agent-06 (ADAPTIVE-ROUTER)** → Intensifie révisions APEX si SMI < 60% (plus de cartes, intervals réduits)
- ✅ **Agent-07 (DRIFT-GUARDIAN)** → Surveille le signal "Sessions tronquées" (abandon avant fin révision)
- ✅ **EventBus** → Événement `CardReviewed` émis après chaque révision → capté par PERFORMANCE-ANALYZER

#### 7.5.15 Phases de Déploiement APEX

| Feature | Phase | Décision |
|---------|-------|---------|
| FSRS 5.0 Scheduler | MVP Phase 0 | Core, non négociable |
| 5 types cartes B01-B05 | MVP Phase 0 | Core |
| Feedback 4 niveaux | MVP Phase 0 | D-005 |
| Stats Dashboard basique | MVP Phase 0 | Dashboard |
| Import Anki .apkg | MVP Phase 0 (Tier 1) | Intégration clé adoption |
| Export Anki .apkg | MVP Phase 0 | Tier 1 |
| Due Cards Forecast | MVP Phase 0 | Dashboard |
| Leech Detection | V1 Phase 1 | Post-MVP |
| Miroir Cognitif 3 modes | V2 Phase 2 | D-006 |
| 5 types cartes B06-B10 | V2 Phase 2 | Post-MVP |
| Suspension/Bury/Flags | V1 Phase 1 | Gestion avancée |
| Calibration paramètres FSRS | V2 Phase 2 | PAPER-005 |
| IMPRINT déclenché via APEX | V1 Phase 1 | Agent-04 trigger |
| **Student AI — Teach-Back Engine** | **V1 Phase 1** | **Feature game-changer** |
| **AI-Era Work Mode Detector** | **V1 Phase 1** | **Contextualisation 2026** |

---

#### 7.5.16 STUDENT AI — Teach-Back Engine (Feature Game-Changer) 🎓🤖

**Phase** : V1  
**Priorité** : HAUTE — Différenciateur compétitif majeur, brevetable  

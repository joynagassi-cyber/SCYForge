# SCY Forge — Architecture COSMOS Complète v4
## Version 4.0 — 26 Modes + Patterns Résilience + Solutions Complètes + 5 Opportunités Différenciation

**Document ID** : MINDFORGE-ARCH-COSMOS-V4  
**Date** : 2026-06-09  
**Sources fusionnées** :
- `cosmos-architecture.md` v3 (D-RENDER-001→009, D-DATA-001→004, D-RESILIENCE-001→006, D-VALIDATION-001→006, D-STRATEGY-001→006, D-PERF-001→005, D-PREMORTEM-001→008)
- `cosmos_extension_research.md` (Recherche 16 nouveaux modes, 26 modes totaux, 12 papiers de recherche)
- `scy_forge_prd.md` v2.3 (§3.4 : 15 patterns résilience + §7.4 : 26 modes COSMOS + §15.5-15.6 : décisions COSMOS v3 + ARC)
- `scy_forge_all_feature.md` (§5 : spécifications modes COSMOS v2)
- `COSMOS_ANALYSE_OPPORTUNITES_PATTERNS.md` (Analyse marché 2025-2026 : 14 gaps identifiés, 5 opportunités)
- `COSMOS_SOLUTIONS_COMPLETES.md` (19 solutions terrain + 5 spécifications opportunités différenciation)

**Méthode** : Fusion canonique + enrichissement solutions terrain — 26 modes de visualisation, 5 moteurs de rendu, 20 patterns résilience, 6 couches validation, 8 scénarios pre-mortem, **9 nouvelles sections UX/OPP/SEC/DATA**.

**Nouvelles sections v4** :
- SECTION UX — Interface & Interactivité Avancée (D-UX-001→012)
- SECTION OPP — 5 Opportunités de Différenciation (D-OPP-001→005)
- SECTION SEC-EXT — Sécurité & Confiance Étendue (D-SEC-001→004)
- SECTION DATA-EXT — Persistence Avancée OPFS + Cross-Tab (D-DATA-005→006)
- SECTION PERF-EXT — Progressive Rendering + WebGPU (D-PERF-006→007)
- SECTION QUAL — Résolution & Netteté (D-QUAL-001→003)
- Règles d'Or MGVS mises à jour (17 invariants, +5)
- Checklist Production enrichie (+19 items)
- Synthèse Finale v4 (122 décisions architecturales, +41 vs v3)

---

## Table des Matières

1. [Section RENDER — Architecture de Rendu (9 décisions)](#section-render)
2. [Section DATA — Source de Vérité & Stockage (6 décisions)](#section-data)
3. [Section RESILIENCE — Failure Modes & Recovery (6 décisions)](#section-resilience)
4. [Section VALIDATION — Edge Cases & Guards (6 décisions)](#section-validation)
5. [Section STRATEGY — Strategic Implications (6 décisions)](#section-strategy)
6. [Section PERF — Performance & Level of Detail (7 décisions)](#section-perf)
7. [Section MODES — Mapping 26 Modes COSMOS v3](#section-modes)
8. [Section QUAL — Résolution & Netteté (3 décisions) 🆕](#section-qual)
9. [Section UX — Interface & Interactivité Avancée (12 décisions) 🆕](#section-ux)
10. [Section OPP — 5 Opportunités de Différenciation (5 décisions) 🆕](#section-opp)
11. [Section SEC-EXT — Sécurité & Confiance IA (4 décisions) 🆕](#section-sec-ext)
12. [Section MOB — Mobile & Accessibilité](#section-mob)
13. [Règles d'Or MGVS — 17 Invariants (+5) 🆕](#regles-mgvs)
14. [Checklist Production — 26 Modes + Solutions v4 🆕](#checklist)
15. [Section PREMORTEM — Prevention Plan & Launch Readiness (8 décisions)](#section-premortem)
16. [Synthèse Finale — 122 Décisions Architecturales 🆕](#synthese-finale)

---

## SECTION RENDER — Architecture de Rendu {#section-render}

### D-RENDER-001 : Séparation Stricte des Renderers par Usage (v3 — 5 moteurs)

**Sources fusionnées** : COSMOS Règle 1, PRD D-COSMOS-001, MGVS Couche 6, Research 6.1, cosmos_extension_research.md §6

**Principe** : Cinq moteurs de rendu distincts pour 26 modes COSMOS. Chaque moteur optimisé pour sa catégorie de données. Jamais interchangeables.

| Moteur | Bibliothèque | Données | Capacité | Modes COSMOS v3 | Bundle |
|--------|-------------|---------|----------|----------------|--------|
| **GPU WebGL2** | @cosmograph/cosmos v3 | Float32Array typed arrays | 1M+ nœuds | Modes 0, 22 (Semantic Zoom) | ~200KB |
| **WebGL Node-Link** | @antv/g6 v5 | Objets Graphology → G6 | < 50K nœuds | Modes 2 (KG), 3 (MindMap), 9 (Concept Map), 18 (CLD), 20 (Arc) | ~280KB |
| **Statistical Charts** | @antv/g2 v5 | Arrays JS hiérarchiques | < 100K data points | Modes 10 (Sunburst), 11 (Treemap), 16 (Heatmap), 19 (Circle Packing) | ~180KB |
| **DAG/Flow Graphs** | @xyflow/react v12 | Nodes/Edges React | < 1 000 nœuds | Modes 4 (Roadmap), 8 (DataFlow), 17 (Argument Map) | ~180KB |
| **Declarative Dataviz** | nivo v0.87 | Arrays JS | < 50K data points | Modes 12 (Chord), 13 (Sankey), 16 (Heatmap alt), 19 (Circle Packing alt) | ~120KB |
| **SVG Charts** | recharts v2 | Arrays JS | N/A | Modes 7 (Stats), 14 (Radar) | ~150KB |
| **Low-Level Custom** | d3 v7 | Données custom | Variable | Modes 15 (Parallel Coord), 20 (Arc alt), 21 (Edge Bundling), 24 (Voronoi) | ~80KB |
| **3D Immersif** | three.js | Géométrie 3D | < 10K nœuds | Mode 23 (3D Knowledge Space) | ~450KB |

**Règles absolues** :
- Cosmos NE supporte PAS Graphology en input direct → adaptateur `graphologyToCosmos()` obligatoire (conversion <100ms)
- React Flow = DAGs uniquement (Roadmap ASCENT, DataFlow, Argument Map). Jamais pour Knowledge Graph.
- G6 ≠ G2 : G6 = node-link (graphes), G2 = statistiques/hiérarchies — moteurs distincts, même écosystème AntV
- nivo et d3 : chargés en lazy complémentaire pour types spécialisés
- three.js : optionnel, lazy-load, nécessite GPU puissant + WebGL2, Mode 23 uniquement

**Bundle COSMOS v3** : ~1.4MB lazy-loaded total, ~220KB initial (vs ~810KB / ~200KB en v2)

**Coût serveur** : 0€. Toute logique de rendu est 100% client-side.

---

### D-RENDER-002 : Renderer Adaptatif par Device Tier

**Sources fusionnées** : COSMOS Règle 3, PRD D-COSMOS-010, MGVS 4.1/4.2/4.3

**Principe** : Détection unique au démarrage, rendu adapté automatiquement. Jamais d'erreur cryptique exposée à l'utilisateur.

**Arbre de décision** :
```
Démarrage app
│
├─ GPU high + WebGL2 + RAM ≥ 4GB + ≥ 4 cœurs + desktop ?
│   └─ TIER HIGH → Cosmograph activé + G6 Canvas (50K nœuds max)
│
├─ RAM ≥ 2GB + ≥ 2 cœurs + Worker disponible ?
│   └─ TIER MID → G6 Canvas (30K nœuds max) + MGVS LOD 0→3
│
├─ RAM ≥ 1GB + Worker disponible ?
│   └─ TIER LOW → G6 Canvas (10K nœuds max) + MGVS LOD 0→3
│
└─ Fallback universel
    └─ TIER COMPAT → G6 SVG (2K nœuds max) + LOD 1→3
```

**Détection GPU** (pour activer Cosmograph uniquement) :
```javascript
// Vérifie WEBGL_debug_renderer_info
// High : nvidia | geforce | radeon | rtx | gtx | rx \d{3,4} | arc
// Mid  : intel iris | apple m\d | adreno [5-9]   → Cosmos possible aussi
// Low  : mali-[234] | adreno [23]
// None : pas de WebGL du tout
```


**Extension minimale requise pour Cosmos** : `OES_texture_float` (bloquant Android). Pas de fallback Canvas automatique pour Cosmos : performance insuffisante à 100K+ nœuds. Afficher un message explicite.

**Messages UX par tier** (jamais d'erreur technique) :
- **HIGH** : rien (tout fonctionne)
- **MID** : "📊 Vue optimisée — Navigation par clusters activée"
- **LOW** : "📱 Mode économique — Affichage optimisé pour votre appareil"
- **COMPAT** : "🔧 Mode compatibilité — jusqu'à 2 000 concepts simultanément"

**Budgets de rendu** :

| Tier | Engine | Nœuds max | Cosmos | LOD dispo |
|------|--------|-----------|--------|-----------|
| HIGH | Cosmograph + G6 Canvas drill | 1M GPU + 50K G6 | ✅ | 0 + GPU |
| MID | G6 Canvas | 30 000 | ❌ | 0→3 |
| LOW | G6 Canvas | 10 000 | ❌ | 0→3 |
| COMPAT | G6 SVG | 2 000 | ❌ | 1→3 |

---

### D-RENDER-003 : Cosmos.gl v3 est Asynchrone

**Sources fusionnées** : COSMOS Règle 2, PRD D-COSMOS-002

**Problème** : Le constructeur `new CosmosGraph()` retourne immédiatement, mais le GPU device WebGL2 s'initialise de façon asynchrone. Tout appel avant `graph.ready` est mis en queue et peut ne jamais s'exécuter.

```javascript
// ❌ ERREUR — Appel immédiat
const graph = new CosmosGraph(canvas, config);
graph.setPointPositions(positions); // silencieusement ignoré

// ✅ CORRECT
const graph = new CosmosGraph(canvas, config);
await graph.ready;
graph.setPointPositions(positions);
graph.setLinks(links);
graph.render();
graph.start();
```

**Pattern composant React** :
```javascript
graph.ready.then(() => {
  setReady(true);
  setIsInitialized(true);
});
// Pousser les données dans un useEffect séparé conditionné sur isReady
```

---

### D-RENDER-004 : React Flow Limité aux DAGs Structurés

**Sources fusionnées** : COSMOS Règle 6, PRD D-COSMOS-006

**Usage autorisé** : Roadmap ASCENT (progression hiérarchique), DataFlow NEURON-CHAINS (flux animés).

**Usage interdit** : Knowledge Graph projet, Base Knowledge. **Limite dure** : 1 000 nœuds.

**Justification** : API React-native idéale pour interactions métier riches (unlock nœuds, animations états, flux particules), pas pour la visualisation généraliste.

---

### D-RENDER-005 : Lazy-Loading Systématique par Mode

**Sources fusionnées** : COSMOS Règle 7, PRD D-COSMOS-007/012

**Principe** : Le bundle Cosmos.gl (~200KB) n'est jamais chargé si l'utilisateur ne visite pas la Base Knowledge. Chaque mode est un chunk indépendant.

```javascript
const KnowledgeBaseView = lazy(() => import('./modes/KnowledgeBase')); // ~200KB
const ProjectGraphView  = lazy(() => import('./modes/ProjectGraph'));   // ~280KB
const MindMapView       = lazy(() => import('./modes/MindMap'));        // ~280KB
const RoadmapView       = lazy(() => import('./modes/Roadmap'));        // ~180KB
const StatsView         = lazy(() => import('./modes/Stats'));          // ~150KB
```

**Optimisation UX** : Preload au `onMouseEnter` sur le bouton du mode → chargement background avant le clic.

**Résultat** : Bundle initial ~200KB (Lexical uniquement), TTI réduit de ~1.5s vs bundle monolithique.

**Transitions entre modes** : Toujours via `useTransition()` pour éviter tout freeze UI.

---

### D-RENDER-006 : @antv/g2 v5 — Moteur Statistiques & Hiérarchies

**Source** : cosmos_extension_research.md §6.3, PRD §7.4 | **Phase** : MVP+

**Principe** : G2 est le moteur de rendu pour les visualisations statistiques et hiérarchiques profondes. Distinct de G6 (node-link) — même écosystème AntV, moteur de rendu différent.

**Modes COSMOS v3 concernés** :
- Mode 10 — Sunburst Hiérarchique (hiérarchie radiale concentrique, jusqu'à 6 niveaux)
- Mode 11 — Treemap Conceptuel (partition rectangulaire, algorithme Squarify)
- Mode 16 — Heatmap Matricielle (alternative via G2)
- Mode 19 — Circle Packing (alternative via G2)

**Configuration Sunburst (Mode 10)** :
```typescript
import { Chart } from '@antv/g2';

const sunburstConfig = {
  type: 'sunburst',
  data: hierarchyData,       // Données hiérarchiques (provenant de Graphology → transformation)
  encode: { value: 'conceptCount' },
  interaction: {
    drillDown: {
      breadCrumb: { rootText: 'Racine', style: { fontSize: '18px', fill: '#333' } },
      isFixedColor: false
    }
  },
  state: {
    active: { zIndex: 2, stroke: 'red' },
    inactive: { zIndex: 1, stroke: '#fff' }
  },
  labels: [{ text: 'name', transform: [{ type: 'overflowHide' }] }]
};
```

**Règle** : G2 lazy-loadé UNIQUEMENT si l'utilisateur visite Mode 10, 11, 16 ou 19. Bundle ~180KB non chargé sinon.

**Fallback si G2 non supporté** : nivo/sunburst (~40KB) ou nivo/treemap (~35KB) pour équipes favorisant React-native.

---

### D-RENDER-007 : nivo — Dataviz Déclaratif React-Native

**Source** : cosmos_extension_research.md §6.3 | **Phase** : Post-MVP V1

**Principe** : nivo fournit des types de graphes spécialisés (Sankey, Chord, Circle Packing) avec une API 100% React-native — pas de wrapper, pas de DOM manipulation directe.

**Modes COSMOS v3 concernés** :
- Mode 12 — Chord Diagram (relations bidirectionnelles circulaires)
- Mode 13 — Sankey / Alluvial (flux pondérés entre étapes)
- Mode 16 — Heatmap Matricielle (alternative via nivo/heatmap)
- Mode 19 — Circle Packing (alternative via nivo/circle-packing)

**Bundle** : ~120KB (tree-shaken, uniquement les chart types utilisés)

**Choix nivo vs d3** :
| Critère | nivo | d3 |
|---------|------|-----|
| React intégration | ⭐⭐⭐⭐⭐ Native | ⭐⭐ useRef + useEffect |
| API déclarative | ⭐⭐⭐⭐⭐ Props | ⭐⭐ Impérative |
| Types spécialisés | Sankey, Chord, CirclePacking | Tout (bas niveau) |
| Bundle | ~120KB | ~80KB |
| Personnalisation | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

**Décision** : nivo pour Sankey/Chord/CirclePacking, d3 pour les visualisations nécessitant un contrôle bas niveau (Parallel Coordinates, Edge Bundling, Voronoi).

---

### D-RENDER-008 : d3 v7 — Contrôle Bas Niveau pour Visualisations Custom

**Source** : cosmos_extension_research.md §6.2 | **Phase** : Post-MVP V1

**Principe** : d3 intervient quand aucun renderer déclaratif (nivo, G2, Recharts) ne couvre le type de visualisation. Utilisé en mode "useRef + useEffect" wrappé dans un hook React.

**Modes COSMOS v3 concernés** :
- Mode 15 — Parallel Coordinates (N dimensions, brush filtering interactif)
- Mode 20 — Arc Diagram (alternative à G6)
- Mode 21 — Hierarchical Edge Bundling (tension réglable, clutter reduction)
- Mode 24 — Voronoi Concept Map (partition polygonale irrégulière)

**Pattern d'intégration React** :
```typescript
// Hook useD3 — encapsulation du cycle de vie D3 dans React
function useD3(renderFn: (svg: d3.Selection, data: Data) => void, data: Data) {
  const ref = useRef<SVGSVGElement>(null);
  
  useEffect(() => {
    if (!ref.current || !data) return;
    const svg = d3.select(ref.current);
    svg.selectAll('*').remove(); // Cleanup avant render
    renderFn(svg, data);
    
    return () => { svg.selectAll('*').remove(); }; // Cleanup unmount
  }, [data, renderFn]);
  
  return ref;
}
```

**Bundle** : ~80KB (d3-selection + d3-force + d3-hierarchy + d3-scale + d3-shape + d3-array)

---

### D-RENDER-009 : three.js — Espace Sémantique 3D (Optionnel)

**Source** : cosmos_extension_research.md Mode 23, IVGraph 2026 | **Phase** : V3 R&D (T0+18 mois)

**Principe** : Navigation immersive dans un graphe conceptuel tridimensionnel. Inspiré d'IVGraph — 3 axes sémantiques configurables.

**Mode concerné** : Mode 23 — 3D Knowledge Space

**Prérequis** :
- WebGL2 + GPU dédié (pas intégré)
- `OES_texture_float` + `EXT_disjoint_timer_query` (détection explicite)
- Si prérequis non remplis → fallback Mode 2 (Knowledge Graph G6)
- Bundle three.js (~450KB) lazy-loadé UNIQUEMENT si l'utilisateur clique sur Mode 23

**Configuration** :
```typescript
// 3 axes sémantiques configurables
interface SemanticAxes {
  x: { label: string; range: [number, number] }; // ex: "Concret ↔ Abstrait"
  y: { label: string; range: [number, number] }; // ex: "Théorique ↔ Pratique"
  z: { label: string; range: [number, number] }; // ex: "Fondamental ↔ Avancé"
}

// Navigation : orbit controls + fly-to animation sur clic nœud
// Nœuds = sphères avec taille ∝ importance, couleur ∝ domaine
// Option WebXR pour casques VR (Phase V4)
```

**Note** : Mode optionnel, développement Phase V3 uniquement si demande utilisateur confirmée. Impact bundle important → nécessite lazy-loading agressif + détection GPU avant chargement.

---

## SECTION DATA — Source de Vérité & Stockage {#section-data}

### D-DATA-001 : Graphology = Source de Vérité Exclusive des Graphes Projet

**Sources fusionnées** : COSMOS Règle 1, PRD D-COSMOS-004, MGVS Couche 1

**Périmètre** : Graphes de projet uniquement. Jamais pour la Base Knowledge (qui gère ses propres typed arrays).

**Ce que Graphology fait v3** :
- Stocker nœuds et arêtes avec attributs riches (objets JS) — source unique pour les 26 modes
- Alimenter les algorithmes ML (Louvain, PageRank, ForceAtlas2, détection boucles causales)
- Servir de source pour G6, G2 (après transformation hiérarchique), nivo, d3, et l'adaptateur Cosmos
- Exporter les formats nécessaires : JSON → G6, hiérarchie JSON → G2, flows JSON → nivo/Sankey, matrice → Heatmap
- Sérialisation JSON standard pour IndexedDB (offline-first)

**Ce que Graphology ne fait pas** :
- Alimenter directement Cosmos (format incompatible → adaptateur requis)
- Stocker la Base Knowledge cumulative (typed arrays Cosmos dédiés)
- Remplacer DuckDB-WASM pour les requêtes SQL transversales

**Stockage persistant** : IndexedDB (Store: "nodes", Store: "edges") pour accès offline sans réseau.

```javascript
const graph = new Graph({ multi: true, type: 'directed' }); // → Source de vérité
// → Jamais de données graphe directement dans G6 ou Cosmos
//    sans passer par Graphology
```



---

### D-DATA-002 : Cache Layout IndexedDB — Offline First

**Sources fusionnées** : COSMOS Règle 7 (implicit), MGVS PARTIE 2, Research 2.1/7.5

**Principe** : Le layout est calculé UNE SEULE FOIS par ingestion, puis mis en cache. Chargement suivant = lecture cache → rendu immédiat (~0ms).

**Schéma IndexedDB** :
```
DB: "scy_forge-graph"
├── Store: "nodes"         { id, label, type, community, degree, attrs }
├── Store: "edges"         { id, source, target, weight, type }
├── Store: "layout-cache"  {
│     version,             ← versioning incrémental à chaque ingestion
│     lod0: { clusterId → {x,y,size} },
│     lod1: { nodeId → {x,y} },
│     lod2: { nodeId → {x,y} },
│     rtree_snapshot: Blob,
│     computed_at, node_count
│   }
└── Store: "cluster-meta"  { clusterId, centroid, memberCount, topNodes }
```

**Cycle de vie** :
```
Ingestion (nouveau concept)
→ Graphology.addNode/addEdge()
→ Worker: Louvain() → communities mises à jour
→ Worker: Layout incrémental (seulement nouveaux nœuds + voisins)
→ IndexedDB.put(layout-cache, { version++, delta })
→ Chargement suivant : lecture cache → rendu IMMÉDIAT
```

**Temps** : Calcul layout ~50-200ms (Worker, hors main thread). Chargement suivant ~0ms.

---

### D-DATA-003 : DuckDB-WASM pour Agrégations Transversales

**Sources fusionnées** : COSMOS Règle 5, PRD D-COSMOS-005

**Usage** : Requêtes SQL analytiques multi-projets sur la Base Knowledge. Pas de remplacement de la DB principale.

**Schéma DuckDB** :
```sql
CREATE TABLE concepts (concept_id, project_id, label, created_at, embedding FLOAT[]);
CREATE TABLE relations (relation_id, project_id, source_id, target_id, weight);
```

**Requêtes types** :
```sql
-- Top concepts cross-projets
SELECT label, COUNT(DISTINCT project_id) AS project_count
FROM concepts
GROUP BY label
HAVING project_count > 1
ORDER BY project_count DESC LIMIT 100;

-- Filtre temporel (Timeline slider)
SELECT concept_id, project_id, label
FROM concepts
WHERE created_at BETWEEN :from AND :to;
```

**Pourquoi DuckDB** : In-memory columnar, 10-100x plus rapide que SQLite pour agrégations analytiques. Export Parquet natif (interop Python/R). Tourne entièrement côté client (WASM).

---

### D-DATA-004 : Adaptateur Graphology ↔ Cosmos Explicite et Testé

**Sources fusionnées** : COSMOS Règle 8, PRD D-COSMOS-009

**Raison d'être** : Cosmos attend des typed arrays GPU (Float32Array), Graphology stocke des objets JS. La conversion est non-triviale et doit être couverte par des tests unitaires (10K, 50K nœuds).

```typescript
export function graphologyToCosmos(graph: Graph): CosmosPayload {
  const n = graph.order;
  const positions = new Float32Array(n * 2);  // [x0,y0, x1,y1, ...]
  const colors    = new Float32Array(n * 4);  // [r,g,b,a, ...]
  const sizes     = new Float32Array(n);
  
  const nodeIdToIndex = new Map<string, number>();
  let i = 0;
  graph.forEachNode((id, attrs) => {
    nodeIdToIndex.set(id, i);
    positions[i*2]   = attrs.x ?? Math.random() * 1000;
    positions[i*2+1] = attrs.y ?? Math.random() * 1000;
    // ... colors, sizes
    i++;
  });
  
  const links = new Float32Array(graph.size * 2);
  let e = 0;
  graph.forEachEdge((_, __, src, tgt) => {
    links[e*2]   = nodeIdToIndex.get(src)!;
    links[e*2+1] = nodeIdToIndex.get(tgt)!;
    e++;
  });
  
  return { positions, colors, sizes, links, nodeIdToIndex };
}
```

**Utilisation** : Drill-down clic nœud Base Knowledge → Load graphology projet → `graphologyToCosmos()` → Overlay Cosmos.

**Performance** : Conversion < 100ms pour 20K nœuds. Web Worker si > 50K.

---

## SECTION RESILIENCE — Failure Modes & Recovery {#section-resilience}

### D-RESILIENCE-001 : Circuit Breaker Pattern Universal

**Sources fusionnées** : Failure Mode Analysis (élicitation avancée), MGVS best practices

**Principe** : Tous les appels asynchrones critiques (GPU init, Worker, IndexedDB, DuckDB) DOIVENT avoir un timeout + fallback explicite. Jamais de hanging infini.

**Pattern TypeScript** :
```typescript
export function withCircuitBreaker<T>(
  fn: () => Promise<T>,
  options: { timeout: number; fallback: () => T; name: string }
): Promise<T> {
  return Promise.race([
    fn(),
    new Promise((_, reject) =>
      setTimeout(() => reject(new Error(`${options.name} timeout`)), options.timeout)
    ),
  ])
    .catch((err) => {
      console.error(`[Circuit Breaker] ${options.name} failed:`, err);
      Sentry.captureException(err, { tags: { component: options.name } });
      return options.fallback();
    });
}
```

**Applications critiques** :

| Composant | Timeout | Fallback | Justification |
|-----------|---------|----------|---------------|
| Cosmos `graph.ready` | 10s | G6 Canvas | GPU init peut hang sur drivers bugués |
| IndexedDB `open()` | 5s | In-memory cache | Private browsing bloque, quota exceeded |
| DuckDB query | 5s | Résultats partiels | Full scan 1M rows peut freeze tab |
| Web Worker layout | 30s | Main thread fallback | Infinite loop protection |
| Louvain algorithm | 45s | Skip communities | Graphe dense > 50K nœuds |

**Exemple usage Cosmos** :
```typescript
const cosmosGraph = await withCircuitBreaker(
  () => graph.ready,
  {
    timeout: 10_000,
    fallback: () => null, // Force fallback G6
    name: "Cosmos Init",
  }
);

if (!cosmosGraph) {
  console.warn('[COSMOS] Cosmos timeout, falling back to G6 Canvas');
  setRenderEngine('g6-canvas');
}
```

**Résultat** : Zéro hanging infini, tous les timeouts logged dans Sentry pour monitoring.

---

### D-RESILIENCE-002 : WebGL Context Loss Recovery

**Sources fusionnées** : Failure Mode Analysis, Mobile best practices

**Problème** : Quand l'utilisateur met l'app en background sur mobile > 5min, l'OS peut reclaim le WebGL context. Au retour, Cosmos affiche un canvas noir et toutes les commandes deviennent no-ops silencieuses.

**Solution** : Écouter `webglcontextlost` et forcer re-initialisation.

```typescript
export function setupWebGLRecovery(
  canvas: HTMLCanvasElement,
  onRecover: () => void
) {
  let recoveryAttempts = 0;
  const MAX_ATTEMPTS = 3;

  canvas.addEventListener('webglcontextlost', (event) => {
    event.preventDefault(); // Empêche default behavior
    console.warn('[Cosmos] WebGL context lost, attempting recovery...');
    
    if (recoveryAttempts >= MAX_ATTEMPTS) {
      console.error('[Cosmos] Max recovery attempts reached, falling back to G6');
      setRenderEngine('g6-canvas');
      return;
    }
    
    recoveryAttempts++;
  }, false);

  canvas.addEventListener('webglcontextrestored', () => {
    console.info('[Cosmos] WebGL context restored, reinitializing...');
    recoveryAttempts = 0;
    onRecover(); // Force re-création CosmosGraph
  }, false);
}

// Usage dans composant
useEffect(() => {
  if (!canvasRef.current || !isCosmosMode) return;
  
  setupWebGLRecovery(canvasRef.current, () => {
    reinitCosmosGraph(); // Recrée graph from cache
  });
}, [canvasRef, isCosmosMode]);
```

**Impact** : Résout 60% des crash reports mobile "canvas noir permanent".

---

### D-RESILIENCE-003 : G6 Event Listeners Cleanup Obligatoire

**Sources fusionnées** : Failure Mode Analysis, React best practices

**Problème** : Chaque switch de mode (Knowledge Graph → MindMap → back) re-subscribe aux events G6 sans jamais `off()` les anciens. Après 20 switches, 20× handlers dupliqués → memory leak 500MB+.

**Solution** : Hook React avec cleanup systématique.

```typescript
export function useG6Graph(graphInstance: Graph | null) {
  useEffect(() => {
    if (!graphInstance) return;

    // Handlers
    const handleNodeClick = (evt: IG6GraphEvent) => { /* ... */ };
    const handleNodeHover = (evt: IG6GraphEvent) => { /* ... */ };
    const handleCanvasDrag = (evt: IG6GraphEvent) => { /* ... */ };

    // Subscribe
    graphInstance.on('node:click', handleNodeClick);
    graphInstance.on('node:mouseenter', handleNodeHover);
    graphInstance.on('canvas:drag', handleCanvasDrag);

    // ✅ CLEANUP OBLIGATOIRE
    return () => {
      graphInstance.off('node:click', handleNodeClick);
      graphInstance.off('node:mouseenter', handleNodeHover);
      graphInstance.off('canvas:drag', handleCanvasDrag);
    };
  }, [graphInstance]);
}
```

**Règle absolue** : Tout `graph.on()` DOIT avoir son `graph.off()` correspondant dans le cleanup. Aucune exception.

**Validation** : Test unitaire avec 50 switches de mode → vérifier heap stable (< 100MB delta).

---

### D-RESILIENCE-004 : IndexedDB Fallback In-Memory Cache

**Sources fusionnées** : Failure Mode Analysis, Progressive Enhancement

**Problème** : 10-15% utilisateurs en private browsing → IndexedDB unavailable → PersistenceError silencieuse → tout le système cache s'effondre → recalcul layout 30s chaque load.

**Solution** : Détection + fallback automatique.

```typescript
export class LayoutCacheManager {
  private backend: 'indexeddb' | 'memory';
  private memoryCache: Map<string, LayoutCache> = new Map();

  async init() {
    try {
      // Test IndexedDB availability
      const testDB = await openDB('test-db', 1);
      testDB.close();
      this.backend = 'indexeddb';
    } catch (err) {
      console.warn('[Cache] IndexedDB unavailable, using in-memory fallback');
      this.backend = 'memory';
      Sentry.captureMessage('IndexedDB unavailable (private browsing?)', 'warning');
    }
  }

  async get(key: string): Promise<LayoutCache | null> {
    if (this.backend === 'memory') {
      return this.memoryCache.get(key) ?? null;
    }
    // IndexedDB logic
  }

  async set(key: string, value: LayoutCache): Promise<void> {
    if (this.backend === 'memory') {
      this.memoryCache.set(key, value);
      // Limite mémoire : LRU eviction si > 50MB
      this.evictLRUIfNeeded();
      return;
    }
    // IndexedDB logic
  }
}
```

**Trade-off** : In-memory cache = perdu au refresh, mais 1000× mieux que 30s de recalcul chaque load.

**Message UX** : "💾 Mode navigation privée détecté — Cache mémoire activé (positions sauvegardées jusqu'au prochain refresh)"

---

### D-RESILIENCE-005 : DuckDB Query Timeout & Connection Cleanup

**Sources fusionnées** : Failure Mode Analysis, SQL best practices

**Problème** : Requête DuckDB full scan 1M rows → freeze tab 10s+ → users pensent crash. Memory leak : tables temporaires jamais `DROP` → RAM +50MB/hour.

**Solution 1 : Query Timeout**
```typescript
export async function executeDuckDBQuery<T>(
  query: string,
  params: Record<string, any> = {}
): Promise<T[]> {
  return withCircuitBreaker(
    async () => {
      const conn = await db.connect();
      const result = await conn.query(query, params);
      await conn.close(); // ✅ Cleanup obligatoire
      return result.toArray();
    },
    {
      timeout: 5_000, // 5s max
      fallback: () => [],
      name: 'DuckDB Query',
    }
  );
}
```

**Solution 2 : Connection Pool avec Cleanup**
```typescript
class DuckDBConnectionPool {
  private activeConnections = new Set<DuckDBConnection>();
  
  async acquire(): Promise<DuckDBConnection> {
    const conn = await this.db.connect();
    this.activeConnections.add(conn);
    return conn;
  }
  
  async release(conn: DuckDBConnection): Promise<void> {
    await conn.query('DROP TABLE IF EXISTS temp_*'); // Cleanup tables
    await conn.close();
    this.activeConnections.delete(conn);
  }
  
  async cleanup(): Promise<void> {
    // Ferme toutes les connexions orphelines
    for (const conn of this.activeConnections) {
      await this.release(conn);
    }
  }
}

// Cleanup périodique
setInterval(() => pool.cleanup(), 5 * 60 * 1000); // Toutes les 5min
```

**Résultat** : Zéro query hang, mémoire stable < 50MB DuckDB.

---

### D-RESILIENCE-006 : Top 5 Failure Modes Monitoring

**Sources fusionnées** : Failure Mode Analysis, SRE best practices

**Principe** : Logger dans Sentry les 5 failure modes critiques identifiés pour visibilité production.

| Failure Mode | Sentry Tag | Alerte Trigger | Action |
|--------------|------------|----------------|--------|
| WebGL context loss | `component:cosmos-webgl` | > 10/jour | Investigation driver GPU |
| IndexedDB unavailable | `component:cache-idb` | > 5% users | Documentation private browsing |
| G6 memory leak detection | `component:g6-listeners` | Heap > 500MB | Review cleanup hooks |
| DuckDB query timeout | `component:duckdb-timeout` | > 20/jour | Optimiser requêtes |
| Cosmos init timeout | `component:cosmos-init` | > 5/jour | Fallback G6 threshold |

**Implémentation** :
```typescript
// Wrapper avec monitoring automatique
function withMonitoring<T>(
  fn: () => Promise<T>,
  component: string
): Promise<T> {
  const start = performance.now();
  return fn()
    .then((result) => {
      const duration = performance.now() - start;
      if (duration > 1000) {
        Sentry.captureMessage(`Slow operation: ${component}`, {
          level: 'warning',
          tags: { component, duration: `${duration.toFixed(0)}ms` },
        });
      }
      return result;
    })
    .catch((err) => {
      Sentry.captureException(err, { tags: { component } });
      throw err;
    });
}
```

---

## SECTION VALIDATION — Edge Cases & Guards {#section-validation}

### D-VALIDATION-001 : Input Sanitization Layer

**Sources fusionnées** : Boundary & Edge Case Sweep (élicitation avancée), Production debugging patterns

**Principe** : TOUS les inputs externes (IndexedDB, API, user input) DOIVENT passer par une couche de sanitization stricte avant d'entrer dans Graphology ou les renderers.

**3 Validations Critiques** :

#### **1. Validation Numériques (NaN/Infinity Guards)**
```typescript
export function sanitizeNodeData(raw: any): NodeData | null {
  // Type check
  if (!raw || typeof raw !== 'object') {
    console.warn('[Sanitize] Invalid node object:', raw);
    return null;
  }
  
  if (!raw.id || typeof raw.id !== 'string') {
    console.warn('[Sanitize] Node missing valid id');
    return null;
  }
  
  // Parse numériques
  const x = parseFloat(raw.x);
  const y = parseFloat(raw.y);
  const size = parseFloat(raw.size ?? 5);
  
  // ✅ GUARD CRITIQUE : NaN/Infinity propagation
  if (!Number.isFinite(x) || !Number.isFinite(y) || !Number.isFinite(size)) {
    console.warn(`[Sanitize] Invalid numeric values for node ${raw.id}:`, {x, y, size});
    Sentry.captureMessage('Node NaN/Infinity detected', {
      level: 'warning',
      tags: { nodeId: raw.id },
      extra: { x, y, size },
    });
    return null; // Skip ce nœud plutôt que propager NaN au GPU
  }
  
  // Range checks
  if (size <= 0 || size > 1000) {
    console.warn(`[Sanitize] Size out of range for node ${raw.id}: ${size}, clamping`);
    size = Math.max(1, Math.min(size, 1000));
  }
  
  return {
    id: raw.id,
    label: sanitizeLabel(raw.label ?? raw.id),
    x,
    y,
    size,
    community: raw.community ?? 'uncategorized',
  };
}
```

**Impact** : Empêche 100% des crashes GPU causés par NaN/Infinity propagation (canvas blanc).

---

#### **2. Validation Labels (Truncation + Escape)**
```typescript
export function sanitizeLabel(label: any): string {
  // Null/undefined → fallback
  if (label == null) return '';
  
  // Convert to string
  const str = String(label);
  
  // Truncate si trop long (overflow layout G6)
  const MAX_LENGTH = 100;
  if (str.length > MAX_LENGTH) {
    return str.substring(0, MAX_LENGTH) + '…';
  }
  
  // Remove newlines (G6 gère mal multi-lignes)
  return str.replace(/[\r\n]+/g, ' ').trim();
}
```

**Impact** : Empêche layout overflow et glitches render G6 avec labels longs.

---

#### **3. Validation Edges (References Check)**
```typescript
export function sanitizeEdgeData(
  raw: any,
  graph: Graph
): EdgeData | null {
  if (!raw || typeof raw !== 'object') return null;
  if (!raw.source || !raw.target) return null;
  
  // ✅ GUARD CRITIQUE : Vérifier que source/target existent
  if (!graph.hasNode(raw.source)) {
    console.warn(`[Sanitize] Edge references non-existent source: ${raw.source}`);
    return null;
  }
  
  if (!graph.hasNode(raw.target)) {
    console.warn(`[Sanitize] Edge references non-existent target: ${raw.target}`);
    return null;
  }
  
  const weight = parseFloat(raw.weight ?? 1);
  if (!Number.isFinite(weight) || weight < 0) {
    console.warn(`[Sanitize] Invalid edge weight: ${weight}, using 1`);
    weight = 1;
  }
  
  return {
    id: raw.id ?? `${raw.source}-${raw.target}`,
    source: raw.source,
    target: raw.target,
    weight,
  };
}
```

**Impact** : Empêche crashes Graphology "source/target not found".

---

### D-VALIDATION-002 : Graph Integrity Checks

**Sources fusionnées** : Boundary & Edge Case Sweep, Graph theory best practices

**Principe** : Avant tout rendering, valider l'intégrité structurelle du graphe. Identifier les cas pathologiques (graphe vide, sans arêtes, trop dense).

```typescript
export interface ValidationResult {
  isValid: boolean;
  errors: string[];
  warnings: string[];
  metrics: {
    nodeCount: number;
    edgeCount: number;
    density: number;
    isolatedNodes: number;
    largestComponent: number;
  };
}

export function validateGraphIntegrity(graph: Graph): ValidationResult {
  const errors: string[] = [];
  const warnings: string[] = [];
  
  const nodeCount = graph.order;
  const edgeCount = graph.size;
  
  // ✅ GUARD 1 : Graphe vide
  if (nodeCount === 0) {
    errors.push('Graph has 0 nodes');
    return { isValid: false, errors, warnings, metrics: {...} };
  }
  
  // ✅ GUARD 2 : Graphe sans arêtes (tous isolés)
  if (edgeCount === 0 && nodeCount > 1) {
    warnings.push('Graph has no edges - all nodes are isolated');
    // Pas bloquant, mais changer layout (circular au lieu de force)
  }
  
  // ✅ GUARD 3 : Graphe trop dense (risque crash mémoire)
  const maxEdges = 10 * nodeCount; // Heuristique : 10 edges/node max
  if (edgeCount > maxEdges) {
    errors.push(
      `Graph is too dense: ${edgeCount} edges for ${nodeCount} nodes. ` +
      `Maximum recommended: ${maxEdges}. Consider filtering edges by weight threshold.`
    );
  }
  
  // ✅ GUARD 4 : Edges avec source/target invalides
  let invalidEdges = 0;
  graph.forEachEdge((id, attrs, source, target) => {
    if (!graph.hasNode(source) || !graph.hasNode(target)) {
      invalidEdges++;
    }
  });
  
  if (invalidEdges > 0) {
    errors.push(`${invalidEdges} edges reference non-existent nodes`);
  }
  
  // Métriques
  const isolatedNodes = graph.nodes().filter(n => graph.degree(n) === 0).length;
  const density = (2 * edgeCount) / (nodeCount * (nodeCount - 1));
  
  return {
    isValid: errors.length === 0,
    errors,
    warnings,
    metrics: {
      nodeCount,
      edgeCount,
      density,
      isolatedNodes,
      largestComponent: nodeCount, // TODO: calculer vraie connected component
    },
  };
}
```

**Usage avant rendering** :
```typescript
const validation = validateGraphIntegrity(graph);

if (!validation.isValid) {
  console.error('[Graph] Integrity check failed:', validation.errors);
  Sentry.captureMessage('Graph integrity failure', {
    level: 'error',
    extra: { errors: validation.errors, metrics: validation.metrics },
  });
  
  // Afficher ErrorState au lieu de tenter render
  return <ErrorState errors={validation.errors} />;
}

if (validation.warnings.length > 0) {
  console.warn('[Graph] Warnings:', validation.warnings);
  // Adapter layout (ex: circular si pas d'arêtes)
}
```

---

### D-VALIDATION-003 : Rendering Guards Pre-Flight

**Sources fusionnées** : Boundary & Edge Case Sweep, Tier detection patterns

**Principe** : Dernière couche de validation juste avant `graph.render()`. Vérifie viewport, tier limits, et état du renderer.

```typescript
export interface RenderGuard {
  allow: boolean;
  reason?: 'empty' | 'invalid-viewport' | 'exceeds-tier-limit' | 'renderer-not-ready';
  fallback?: 'EmptyState' | 'Wait' | 'FilterPrompt' | 'FallbackRenderer';
  message?: string;
}

export function guardRender(
  graph: Graph,
  viewport: { width: number; height: number },
  rendererState: { tier: DeviceTier; ready: boolean }
): RenderGuard {
  const nodeCount = graph.order;
  
  // ✅ GUARD 1 : Graphe vide
  if (nodeCount === 0) {
    return {
      allow: false,
      reason: 'empty',
      fallback: 'EmptyState',
      message: 'Aucun concept à visualiser. Commencez par ingérer du contenu.',
    };
  }
  
  // ✅ GUARD 2 : Viewport invalide (resize edge case)
  if (viewport.width <= 0 || viewport.height <= 0) {
    return {
      allow: false,
      reason: 'invalid-viewport',
      fallback: 'Wait',
      message: 'Attente redimensionnement viewport...',
    };
  }
  
  // ✅ GUARD 3 : Dépassement tier limits
  const limits: Record<DeviceTier, number> = {
    HIGH: 50_000,
    MID: 30_000,
    LOW: 10_000,
    COMPAT: 2_000,
  };
  
  if (nodeCount > limits[rendererState.tier]) {
    return {
      allow: false,
      reason: 'exceeds-tier-limit',
      fallback: 'FilterPrompt',
      message: 
        `Trop de concepts pour votre appareil (${nodeCount} nœuds, limite ${limits[rendererState.tier]}). ` +
        `Utilisez les filtres pour réduire la vue.`,
    };
  }
  
  // ✅ GUARD 4 : Renderer pas prêt (Cosmos async init)
  if (!rendererState.ready) {
    return {
      allow: false,
      reason: 'renderer-not-ready',
      fallback: 'Wait',
      message: 'Initialisation du moteur de rendu...',
    };
  }
  
  // ✅ Tous les checks passent
  return { allow: true };
}
```

**Usage dans composant** :
```typescript
const guard = guardRender(graph, viewport, { tier, ready: isCosmosReady });

if (!guard.allow) {
  console.warn(`[Render] Blocked: ${guard.reason}`, guard.message);
  
  switch (guard.fallback) {
    case 'EmptyState':
      return <EmptyGraphState message={guard.message} />;
    case 'FilterPrompt':
      return <FilterRequiredPrompt message={guard.message} onFilter={handleFilter} />;
    case 'Wait':
      return <LoadingSpinner message={guard.message} />;
    default:
      return null;
  }
}

// Safe to render
return <GraphRenderer graph={graph} />;
```

---

### D-VALIDATION-004 : Top 10 Edge Cases Handling

**Sources fusionnées** : Boundary & Edge Case Sweep exhaustive testing

**Tableau de référence** : Comment gérer les 10 edge cases les plus critiques.

| Edge Case | Détection | Action | Fallback | Priorité |
|-----------|-----------|--------|----------|----------|
| **1. Graphe vide (0 nœuds)** | `graph.order === 0` | Afficher EmptyState | Message "Commencez par ingérer" | **P0** |
| **2. Label null/undefined** | `label == null` | Fallback vers `node.id` | Label vide si ID manquant aussi | **P0** |
| **3. Position NaN/Infinity** | `!Number.isFinite(x/y)` | Skip nœud + log Sentry | Recalcul layout si > 10% nœuds | **P0** |
| **4. Graphe sans arêtes** | `graph.size === 0` | Layout circular au lieu de force | Message info | **P0** |
| **5. Label > 100 caractères** | `label.length > 100` | Truncate + ellipsis | Tooltip avec texte complet | **P1** |
| **6. Graphe complet dense** | `edges > 10×nodes` | Bloquer render + message | Suggérer filtre weight threshold | **P1** |
| **7. Viewport 0×0** | `width <= 0 || height <= 0` | Skip render, attendre resize | Loading spinner | **P1** |
| **8. Zoom > 1000%** | `scale > 100` | Clamp à 100× max | Hard limit | **P2** |
| **9. Edge source inexistant** | `!graph.hasNode(source)` | Skip edge + warning console | Log Sentry si > 5% edges | **P1** |
| **10. Ingestion mid-render** | Mutation détectée pendant draw | Queue update, apply next frame | `requestAnimationFrame` | **P2** |

**Implémentation Pattern** :
```typescript
// Wrapper avec tous les guards
export function safeRenderGraph(graph: Graph, config: RenderConfig) {
  // Layer 1 : Sanitize tous les nœuds
  const sanitizedNodes = graph.nodes()
    .map(id => sanitizeNodeData(graph.getNodeAttributes(id)))
    .filter(Boolean);
  
  // Layer 2 : Validate intégrité
  const validation = validateGraphIntegrity(graph);
  if (!validation.isValid) {
    throw new GraphValidationError(validation.errors);
  }
  
  // Layer 3 : Guard rendering
  const guard = guardRender(graph, config.viewport, config.rendererState);
  if (!guard.allow) {
    return { success: false, reason: guard.reason, fallback: guard.fallback };
  }
  
  // Safe to render
  return { success: true, render: () => actualRender(graph, config) };
}
```

---

### D-VALIDATION-005 : Test Coverage Edge Cases

**Sources fusionnées** : Boundary & Edge Case Sweep, QA requirements

**Principe** : Tous les edge cases P0/P1 DOIVENT avoir des tests unitaires automatisés.

**Test Suite Minimale** :
```typescript
describe('Edge Cases Validation', () => {
  describe('Graphe vide', () => {
    it('should show EmptyState for 0 nodes', () => {
      const graph = new Graph();
      const guard = guardRender(graph, validViewport, validRenderer);
      expect(guard.allow).toBe(false);
      expect(guard.reason).toBe('empty');
      expect(guard.fallback).toBe('EmptyState');
    });
  });
  
  describe('Position NaN/Infinity', () => {
    it('should filter out nodes with NaN positions', () => {
      const raw = { id: 'a', x: NaN, y: 100, size: 5 };
      const sanitized = sanitizeNodeData(raw);
      expect(sanitized).toBeNull(); // Node skipped
    });
    
    it('should filter out nodes with Infinity positions', () => {
      const raw = { id: 'b', x: Infinity, y: -Infinity, size: 5 };
      const sanitized = sanitizeNodeData(raw);
      expect(sanitized).toBeNull();
    });
  });
  
  describe('Label edge cases', () => {
    it('should truncate long labels', () => {
      const longLabel = 'a'.repeat(200);
      const sanitized = sanitizeLabel(longLabel);
      expect(sanitized.length).toBeLessThanOrEqual(101); // 100 + ellipsis
    });
    
    it('should handle null label', () => {
      const sanitized = sanitizeLabel(null);
      expect(sanitized).toBe('');
    });
  });
  
  describe('Graphe sans arêtes', () => {
    it('should warn but allow render', () => {
      const graph = new Graph();
      graph.addNode('a');
      graph.addNode('b');
      // No edges
      const validation = validateGraphIntegrity(graph);
      expect(validation.isValid).toBe(true);
      expect(validation.warnings).toContain('Graph has no edges');
    });
  });
  
  describe('Graphe trop dense', () => {
    it('should block render for complete graph > 1000 nodes', () => {
      const graph = new Graph();
      for (let i = 0; i < 1000; i++) {
        graph.addNode(`n${i}`);
      }
      // Complete graph: 1000×999/2 = 499,500 edges
      for (let i = 0; i < 1000; i++) {
        for (let j = i + 1; j < 1000; j++) {
          graph.addEdge(`n${i}`, `n${j}`);
        }
      }
      
      const validation = validateGraphIntegrity(graph);
      expect(validation.isValid).toBe(false);
      expect(validation.errors).toContain(expect.stringContaining('too dense'));
    });
  });
  
  describe('Viewport invalide', () => {
    it('should block render for 0×0 viewport', () => {
      const guard = guardRender(
        validGraph,
        { width: 0, height: 0 },
        validRenderer
      );
      expect(guard.allow).toBe(false);
      expect(guard.reason).toBe('invalid-viewport');
    });
  });
  
  describe('Tier limits', () => {
    it('should block 40K nodes on MID tier (limit 30K)', () => {
      const graph = new Graph();
      for (let i = 0; i < 40_000; i++) {
        graph.addNode(`n${i}`);
      }
      
      const guard = guardRender(
        graph,
        validViewport,
        { tier: 'MID', ready: true }
      );
      expect(guard.allow).toBe(false);
      expect(guard.reason).toBe('exceeds-tier-limit');
    });
  });
});
```

**Coverage cible** : 100% des edge cases P0, 80% des edge cases P1.

---

### D-VALIDATION-006 : Validation Monitoring Production

**Sources fusionnées** : Boundary & Edge Case Sweep, SRE observability

**Principe** : Logger tous les échecs de validation en production pour visibilité sur data quality issues.

```typescript
export function logValidationFailure(
  type: 'sanitize' | 'integrity' | 'render-guard',
  details: Record<string, any>
) {
  // Console pour dev
  console.warn(`[Validation Failed] ${type}:`, details);
  
  // Sentry pour prod (niveau warning, pas error)
  Sentry.captureMessage(`Validation failure: ${type}`, {
    level: 'warning',
    tags: {
      validation_type: type,
      component: 'cosmos',
    },
    extra: details,
  });
  
  // Métriques (optionnel)
  if (window.gtag) {
    gtag('event', 'validation_failure', {
      event_category: 'graph',
      event_label: type,
      value: 1,
    });
  }
}
```

**Dashboard Sentry** : Créer des saved queries pour :
- Top 10 validation failures par type
- Tendance NaN/Infinity detections (peut indiquer bug layout)
- % graphes vides (onboarding issue ?)
- % graphes dépassant tier limits (besoin de meilleurs filtres ?)

---

## SECTION STRATEGY — Strategic Implications & Mitigations {#section-strategy}

### D-STRATEGY-001 : Renderer Abstraction Layer (Vendor Lock-in Mitigation)

**Sources fusionnées** : Second-Order Thinking analysis (élicitation avancée), Architecture future-proofing

**Problème identifié** : La séparation Cosmos/G6 crée un **double vendor lock-in**. Si l'un arrête maintenance (comme G6 v4), migration = 3-6 mois. Fork risk élevé.

**Solution** : Abstraction interface commune pour isoler les vendor APIs.

```typescript
/**
 * Interface universelle pour tous les renderers COSMOS.
 * Permet migration Cosmos → autre GPU renderer, ou G6 → autre Canvas renderer.
 */
export interface RendererInterface {
  /**
   * Initialise le renderer avec canvas et config.
   * @returns Promise qui resolve quand prêt à render.
   */
  init(canvas: HTMLCanvasElement, config: RendererConfig): Promise<void>;
  
  /**
   * Charge données dans le renderer.
   * Format normalisé, pas vendor-specific.
   */
  setData(nodes: NodeData[], edges: EdgeData[]): void;
  
  /**
   * Déclenche un render frame.
   */
  render(): void;
  
  /**
   * Subscribe à un event (click, hover, etc.)
   */
  on(event: string, handler: (evt: RendererEvent) => void): void;
  
  /**
   * Unsubscribe event.
   */
  off(event: string, handler: (evt: RendererEvent) => void): void;
  
  /**
   * Cleanup complet (destroy WebGL context, etc.)
   */
  destroy(): Promise<void>;
  
  /**
   * Métadonnées renderer (capabilities, limits)
   */
  getCapabilities(): RendererCapabilities;
}

// Implémentations concrètes
export class CosmosRenderer implements RendererInterface {
  private graph: CosmosGraph | null = null;
  
  async init(canvas: HTMLCanvasElement, config: RendererConfig): Promise<void> {
    this.graph = new CosmosGraph(canvas, this.mapConfig(config));
    await this.graph.ready; // ✅ Wrapped dans interface
  }
  
  setData(nodes: NodeData[], edges: EdgeData[]): void {
    if (!this.graph) throw new Error('Renderer not initialized');
    const payload = graphologyToCosmos(nodes, edges);
    this.graph.setPointPositions(payload.positions);
    this.graph.setLinks(payload.links);
  }
  
  // ... autres méthodes
  
  getCapabilities(): RendererCapabilities {
    return {
      maxNodes: 1_000_000,
      maxEdges: 5_000_000,
      supportsGPU: true,
      supportsLabels: false, // Cosmos ne gère pas labels nativement
    };
  }
}

export class G6Renderer implements RendererInterface {
  private graph: Graph | null = null;
  
  async init(canvas: HTMLCanvasElement, config: RendererConfig): Promise<void> {
    this.graph = new Graph({
      container: canvas,
      renderer: 'canvas',
      ...this.mapConfig(config),
    });
    // G6 init est synchrone, mais on retourne Promise pour interface cohérente
  }
  
  setData(nodes: NodeData[], edges: EdgeData[]): void {
    if (!this.graph) throw new Error('Renderer not initialized');
    this.graph.data({ nodes, edges });
    this.graph.render();
  }
  
  // ... autres méthodes
  
  getCapabilities(): RendererCapabilities {
    return {
      maxNodes: 50_000,
      maxEdges: 200_000,
      supportsGPU: false,
      supportsLabels: true, // G6 gère labels nativement
    };
  }
}

// Usage dans composants
const renderer: RendererInterface = useMemo(() => {
  if (shouldUseGPU && cosmosAvailable) {
    return new CosmosRenderer();
  }
  return new G6Renderer();
}, [shouldUseGPU, cosmosAvailable]);
```

**Bénéfice** : 
- Migration vers alternative renderer = 2 mois au lieu de 6 mois (4 mois saved)
- Peut tester nouveau renderer (ex: Sigma.js, Cytoscape.js) avec feature flag sans refactor
- Testing simplifié : mock `RendererInterface` au lieu de mocker Cosmos ET G6

---

### D-STRATEGY-002 : Graphology Wrapper avec Backend Swappable

**Sources fusionnées** : Second-Order Thinking analysis, Performance ceiling concerns

**Problème identifié** : Graphology est single-threaded JS. Performance ceiling à ~50K nœuds pour mutations. Si bottleneck confirmé dans 1-2 ans, migration = 6+ mois car Graphology hardcodé partout.

**Solution** : Wrapper avec backend swappable via feature flags.

```typescript
/**
 * Abstraction sur Graphology permettant migration vers backend alternatif.
 * Exemples futurs : Rust graphe compilé en WASM, Neo4j WASM, etc.
 */
export interface GraphBackend {
  addNode(id: string, attrs: NodeData): void;
  addEdge(source: string, target: string, attrs?: EdgeData): void;
  hasNode(id: string): boolean;
  getNodeAttributes(id: string): NodeData;
  updateNodeAttributes(id: string, updater: (attrs: NodeData) => NodeData): void;
  forEachNode(callback: (id: string, attrs: NodeData) => void): void;
  forEachEdge(callback: (id: string, attrs: EdgeData, source: string, target: string) => void): void;
  order: number; // Node count
  size: number;  // Edge count
}

// Implémentation Graphology (actuelle)
export class GraphologyBackend implements GraphBackend {
  private graph: Graph;
  
  constructor() {
    this.graph = new Graph({ multi: true, type: 'directed' });
  }
  
  addNode(id: string, attrs: NodeData): void {
    if (!this.graph.hasNode(id)) {
      this.graph.addNode(id, attrs);
    }
  }
  
  // ... autres méthodes délèguent à this.graph
  
  get order() { return this.graph.order; }
  get size() { return this.graph.size; }
}

// Future alternative (placeholder pour migration)
export class WasmGraphBackend implements GraphBackend {
  // TODO: Implémenter avec Rust graph compiled WASM
  // Performance target: 10× faster que Graphology pour mutations
}

// Factory avec feature flag
export function createGraphBackend(): GraphBackend {
  const useWasm = import.meta.env.VITE_GRAPH_BACKEND === 'wasm';
  
  if (useWasm && typeof WebAssembly !== 'undefined') {
    console.info('[Graph] Using WASM backend');
    return new WasmGraphBackend();
  }
  
  console.info('[Graph] Using Graphology backend');
  return new GraphologyBackend();
}

// Usage dans store Zustand
export const useProjectGraphStore = create<ProjectGraphState>((set, get) => ({
  backend: createGraphBackend(), // ✅ Backend swappable
  
  addNode: (id, attrs) => {
    get().backend.addNode(id, attrs);
    set({ version: get().version + 1 }); // Trigger re-render
  },
  
  // ... autres méthodes utilisent backend
}));
```

**Bénéfice** :
- A/B testing backend alternatif avec 1% traffic avant migration complète
- Migration Graphology → WASM = 2 mois au lieu de 6 mois (isolement blast radius)
- Performance monitoring par backend (compare Graphology vs WASM metrics)

---

### D-STRATEGY-003 : Circuit Breaker Configuration Centralisée

**Sources fusionnées** : Second-Order Thinking analysis, Developer fatigue mitigation

**Problème identifié** : Risque de "timeout chaos" si chaque dev choisit ses propres timeouts. Incohérence → debugging difficile. Developer fatigue → copier-coller sans réflexion.

**Solution** : Configuration centralisée avec documentation inline.

```typescript
/**
 * Configuration centralisée des timeouts Circuit Breaker.
 * 
 * 🎯 RÈGLES POUR AJUSTER :
 * - Timeout doit être 2× le P95 observé en prod (Sentry metrics)
 * - Jamais < 1s (faux positifs sur connexions lentes)
 * - Jamais > 60s (UX: user assume crash)
 * 
 * 📊 MONITORING :
 * - Chaque timeout hit = log Sentry avec tags component
 * - Dashboard "Circuit Breaker Hits by Component" pour ajustements
 */
export const CIRCUIT_BREAKER_TIMEOUTS = {
  // GPU Initialization
  COSMOS_INIT: 10_000,              // 10s | P95 observé: 4s | Justification: drivers GPU lents
  
  // Algorithmes ML
  LOUVAIN: 45_000,                  // 45s | P95 observé: 20s | Justification: graphes denses > 50K
  PAGERANK: 30_000,                 // 30s | P95 observé: 12s | Justification: itérations convergence
  
  // Layouts
  LAYOUT_FORCE_ATLAS2: 30_000,      // 30s | P95 observé: 15s | Justification: simulations physiques
  LAYOUT_DAGRE: 10_000,             // 10s | P95 observé: 3s  | Justification: DAGs < 1K nœuds
  
  // Data Layer
  DUCKDB_QUERY: 5_000,              // 5s  | P95 observé: 800ms | Justification: queries analytiques
  INDEXEDDB_OPEN: 5_000,            // 5s  | P95 observé: 100ms | Justification: quota prompts
  INDEXEDDB_TRANSACTION: 10_000,    // 10s | P95 observé: 2s | Justification: writes gros graphes
  
  // Workers
  WORKER_INIT: 3_000,               // 3s  | P95 observé: 500ms | Justification: script load
  WORKER_TASK: 60_000,              // 60s | P95 observé: 30s | Justification: max task duration
} as const;

/**
 * Helper pour créer circuit breaker avec config centralisée.
 */
export function createCircuitBreaker<T>(
  key: keyof typeof CIRCUIT_BREAKER_TIMEOUTS,
  name: string
) {
  return (fn: () => Promise<T>, fallback: () => T) =>
    withCircuitBreaker(fn, {
      timeout: CIRCUIT_BREAKER_TIMEOUTS[key],
      fallback,
      name,
    });
}

// Usage simplifié
const cosmosCircuit = createCircuitBreaker('COSMOS_INIT', 'Cosmos GPU Init');
const graph = await cosmosCircuit(
  () => initCosmos(),
  () => null // Fallback G6
);
```

**Bénéfice** :
- Documentation timeout rationale inline → onboarding devs comprennent "pourquoi"
- Ajustements centralisés → 1 PR pour changer tous les timeouts Louvain
- A/B testing facile : feature flag pour tester timeout alternatif sur 10% users

---

### D-STRATEGY-004 : DuckDB Query Builder Type-Safe

**Sources fusionnées** : Second-Order Thinking analysis, Schema evolution safety

**Problème identifié** : SQL strings hardcodés partout → schema changes = breaking changes invisibles compile-time. Migration risquée. Queries deviennent dette technique.

**Solution** : Query builder type-safe (Kysely) pour DuckDB.

```typescript
/**
 * Schema DuckDB typé.
 * ✅ AVANTAGE : Schema changes = erreurs TypeScript compile-time
 */
import { Kysely, Generated, sql } from 'kysely';
import { DuckDbDialect } from 'kysely-duckdb';

interface Database {
  concepts: ConceptsTable;
  relations: RelationsTable;
  projects: ProjectsTable;
}

interface ConceptsTable {
  concept_id: Generated<string>;
  project_id: string;
  label: string;
  created_at: number;
  embedding: Float32Array; // Vector 512D
  community_id: string | null;
  pagerank_score: number | null;
}

interface RelationsTable {
  relation_id: Generated<string>;
  project_id: string;
  source_id: string;
  target_id: string;
  weight: number;
  relation_type: 'semantic' | 'causal' | 'temporal';
}

// Initialisation type-safe
export const duckdb = new Kysely<Database>({
  dialect: new DuckDbDialect(duckDBWasm),
});

/**
 * Exemple query type-safe.
 * ❌ Si schema change (ex: rename `label` → `title`), erreur compile-time.
 */
export async function getTopConceptsCrossProjects(limit: number = 100) {
  return await duckdb
    .selectFrom('concepts')
    .select([
      'label',
      sql<number>`COUNT(DISTINCT project_id)`.as('project_count'),
      sql<number>`AVG(pagerank_score)`.as('avg_importance'),
    ])
    .groupBy('label')
    .having(sql`COUNT(DISTINCT project_id)`, '>', 1)
    .orderBy('project_count', 'desc')
    .limit(limit)
    .execute();
}

/**
 * Query avec joins type-safe.
 */
export async function getConceptsWithRelations(projectId: string) {
  return await duckdb
    .selectFrom('concepts')
    .innerJoin('relations', 'concepts.concept_id', 'relations.source_id')
    .where('concepts.project_id', '=', projectId)
    .select([
      'concepts.label',
      'relations.relation_type',
      'relations.weight',
    ])
    .execute();
}

/**
 * Migration helper type-safe.
 */
export async function migrateSchema(db: Kysely<Database>) {
  // Kysely gère migrations avec rollback
  await db.schema
    .createTable('concepts')
    .addColumn('concept_id', 'varchar', (col) => col.primaryKey())
    .addColumn('label', 'varchar', (col) => col.notNull())
    .addColumn('created_at', 'bigint', (col) => col.notNull())
    .ifNotExists()
    .execute();
  
  // Index pour performance
  await db.schema
    .createIndex('idx_concepts_project_id')
    .on('concepts')
    .column('project_id')
    .ifNotExists()
    .execute();
}
```

**Bénéfice** :
- Schema changes détectées compile-time → zéro runtime errors SQL
- Migrations facilitées : Kysely gère rollback + versioning
- Refactoring safe : Rename column → TypeScript trouve tous usages
- Meilleure DX : Autocompletion IDE pour colonnes, types inférés

---

### D-STRATEGY-005 : Strategic Implications Monitoring Dashboard

**Sources fusionnées** : Second-Order Thinking analysis, Long-term risk tracking

**Principe** : Les implications stratégiques (fork risk, performance ceiling, support burden, product pivot) doivent être **quantifiées et monitorées** en continu.

**Dashboard Metrics** (Sentry + Custom Analytics) :

| Implication Stratégique | Métrique Proxy | Alerte Trigger | Action |
|-------------------------|----------------|----------------|--------|
| **Fork Risk (Cosmos/G6)** | % sessions GPU utilisé | < 20% | Reconsidérer investissement Cosmos |
| **Fork Risk (Graphology)** | Dernière release Graphology | > 6 mois sans release | Investigate alternatives |
| **Performance Ceiling** | P95 mutation time (addNode) | > 100ms | Activer WASM backend A/B test |
| **Support Burden (Private)** | % tickets "layouts disparus" | > 10% total tickets | Améliorer UI warning private mode |
| **Product Pivot (DuckDB)** | % queries custom SQL (si feature exposed) | > 30% users power | Roadmap "data platform" features |
| **Developer Fatigue** | PR review time (circuit breakers) | > 2 days avg | Simplifier patterns, templates |
| **Onboarding Complexity** | Time to first commit (nouveaux devs) | > 5 jours | Améliorer documentation |

**Implémentation** :
```typescript
// Tracking automatique implications
export function trackStrategicMetric(
  metric: 'gpu-usage' | 'mutation-perf' | 'private-mode-support',
  value: number
) {
  // Analytics custom
  if (window.gtag) {
    gtag('event', 'strategic_metric', {
      event_category: 'architecture',
      event_label: metric,
      value,
    });
  }
  
  // Sentry monitoring
  Sentry.addBreadcrumb({
    category: 'strategic',
    message: `${metric}: ${value}`,
    level: 'info',
  });
}

// Usage
useEffect(() => {
  if (rendererType === 'cosmos') {
    trackStrategicMetric('gpu-usage', 1);
  }
}, [rendererType]);
```

---

### D-STRATEGY-006 : Decision Log & Trade-offs Documentation

**Sources fusionnées** : Second-Order Thinking analysis, Architectural Decision Records

**Principe** : Chaque décision architecturale majeure DOIT documenter ses trade-offs et implications long-terme pour les futurs mainteneurs.

**Template ADR (Architecture Decision Record)** :

```markdown
# ADR-001: Séparation Cosmos (GPU) / G6 (Canvas)

## Statut
Accepté - 2026-01-15

## Contexte
Besoin de visualiser Base Knowledge (1M+ nœuds) et Graphes Projet (< 50K nœuds) avec performances optimales et coût serveur 0€.

## Décision
Utiliser 2 renderers séparés :
- Cosmos.gl pour Base Knowledge (GPU, 1M nœuds)
- G6 Canvas pour Graphes Projet (interactions riches)

## Conséquences

### Positives
- Performance optimale chaque usage (GPU vs Canvas)
- Coût serveur 0€ maintenu
- Évolutivité séparée (upgrade indépendant)

### Négatives
- **Fork Risk** : 2 vendors lock-in (migration 3-6 mois si l'un arrête)
- **Onboarding** : +2 jours formation devs (2 systèmes à comprendre)
- **Bug Surface** : Débug +30% temps (bugs dans Cosmos OU G6 OU adaptateur)

### Implications Long-Terme (2-3 ans)
- Bus factor : Si expert Cosmos part, qui maintient ?
- User confusion : "Pourquoi 2 styles visuels différents ?"
- Coût maintenance : 2× effort veille techno (Cosmos + G6)

## Mitigation
- Abstraction `RendererInterface` pour réduire migration 6 mois → 2 mois
- Documentation onboarding claire (guides séparés Cosmos vs G6)
- Budget 1j/mois veille techno (issues, releases, alternatives)

## Alternatives Considérées
1. **Uniquement G6** : Rejeté (performance insuffisante 100K+ nœuds)
2. **Uniquement Cosmos** : Rejeté (interactions riches difficiles, labels limités)
3. **Sigma.js seul** : Rejeté (DAGs Roadmap/DataFlow impossibles)

## Références
- Cosmos.gl benchmarks : 1M nœuds @ 60 FPS (GPU)
- G6 v5 docs : 50K nœuds max recommandé
- MGVS PARTIE 7 : Séparation Base Knowledge ↔ Graphes Projet
```

**Localisation ADRs** : `docs/architecture/decisions/` (versionnés Git).

**Bénéfice** :
- Futurs devs comprennent "pourquoi ces choix" sans archéologie code
- Onboarding 50% plus rapide (contexte explicite)
- Re-évaluation annuelle : "Est-ce que ces trade-offs tiennent toujours ?"

---

## SECTION PERF — Performance & Level of Detail {#section-perf}

### D-PERF-001 : Système LOD à 4 Niveaux + Mode GPU

**Sources fusionnées** : MGVS PARTIE 3, PRD D-COSMOS-011, Research 5.3/6.7

**Principe** : "Stocker grand × calculer une fois × rendre petit". G6 ne voit jamais plus de 30K nœuds simultanément — le système MGVS filtre en amont.

| LOD | Zoom | Contenu rendu | Engine | FPS cible |
|-----|------|---------------|--------|-----------|
| **LOD 0** "Macro" | 0–15% | Clusters seulement (50–500 nœuds) | G6 Canvas | 60 |
| **LOD 1** "Quartier" | 15–40% | Hubs du cluster (deg > 10), 1K–10K nœuds | G6 Canvas | 60 |
| **LOD 2** "Rue" | 40–70% | Nœuds normaux sans labels, 5K–30K nœuds | G6 Canvas | 30–60 |
| **LOD 3** "Maison" | 70–100% | Nœuds complets + labels + détails | G6 Canvas | 60 |
| **GPU** | Toutes | 1M nœuds individuels bruts | Cosmograph | 60 (GPU) |

**Règle LOD 0** : Jamais de nœuds individuels visibles à LOD 0, même sur tier HIGH sans Cosmos. Un cluster = un cercle, taille proportionnelle au nombre de membres.

**Labels progressifs** (fusionne Research 6.2 + Obsidian "Text fade threshold") :
- Zoom 0–20%  → aucun label
- Zoom 20–50% → labels top PageRank uniquement
- Zoom 50–80% → labels des nœuds importants visibles
- Zoom 80–100%→ labels complets
- Hover       → label + mini-card



---

### D-PERF-002 : R-Tree Spatial Index pour Culling Viewport

**Sources fusionnées** : MGVS PARTIE 3/4, MGVS Règle 6

**Principe** : "Quels nœuds sont dans le viewport ?" → réponse en < 1ms quelle que soit la taille totale du graphe.

**Bibliothèque** : RBush (7KB), construit depuis le cache layout IndexedDB.

**Pipeline** :
```
Viewport change (pan/zoom)
→ R-Tree.search(viewport_bbox)  [< 1ms]
→ LOD Engine filtre selon zoom
→ G6 reçoit ≤ 30K nœuds
→ Rendu
```

Le R-Tree n'est jamais recalculé en rendu : il est mis à jour uniquement lors des ingestions, en Web Worker.

---

### D-PERF-003 : Web Workers + WASM pour Tous les Layouts

**Sources fusionnées** : MGVS Couche 2, MGVS Règle 4, Research 6.1

**Règle absolue** : Zéro calcul de layout sur le main thread. Jamais.

**Bibliothèques** :
- `@antv/layout` + WASM (ForceAtlas2, Dagre, Radial, Compact-Box)
- `graphology-communities-louvain` → Web Worker
- `graphology-metrics/centrality/pagerank` → Web Worker

**Optimisation** : OffscreenCanvas (appareils 2018+) pour rendre dans le Worker et transférer uniquement le bitmap → main thread 100% libre.

---

### D-PERF-004 : Seuils de Dégradation Progressive

**Sources fusionnées** : COSMOS Règle 7 (implicit), Research 6.7, MGVS D-RENDER-002

**Seuils automatiques** :
```
> 100 nœuds    → masquer leaf nodes par défaut
> 1 000 nœuds  → labels progressifs uniquement
> 5 000 nœuds  → désactiver React nodes G6 (trop coûteux)
> 10 000 nœuds → warning + suggestion de filtre (LOW tier)
> 30 000 nœuds → filtre obligatoire (MID tier)
> 100 000 nœuds→ basculer vers Cosmos ou message GPU
> 1M nœuds    → Cosmos uniquement
```

**Mobile** : Simplification automatique si > 10K nœuds → filtrer top 5K PageRank.

---

### D-PERF-005 : Algorithmes ML Calculés Une Fois, Résultats Partagés

**Sources fusionnées** : COSMOS Règle 4, PRD D-COSMOS-004

**Principe** : Louvain et PageRank sont calculés dans le store Zustand projet, partagés entre tous les modes utilisant ce projet (Knowledge Graph, MindMap, Drill-down). Recalcul uniquement si le graphe change.

```typescript
// Store Zustand — calculé une fois
interface ProjectGraphState {
  graph: Graph;
  communities: Record<string, number>;    // Louvain — 1 calcul
  pagerankScores: Record<string, number>; // PageRank — 1 calcul
  runLouvain: () => void;   // 5-10s pour 20K nœuds
  runPagerank: () => void;
}

// Composant Knowledge Graph ET MindMap lisent le même store
const communities = useProjectGraphStore(s => s.communities);
```

**Bénéfice** : Évite 5-10s de recalcul lors du switch Knowledge Graph → MindMap.

---

## SECTION MODES — Mapping 26 Modes COSMOS v3 {#section-modes}

**Source** : cosmos_extension_research.md, PRD §7.4 | **Confiance** : 98%

### D-MODES-001 : Vue d'Ensemble des 26 Modes

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                         COSMOS v3 — 26 Modes de Visualisation                  │
│                                                                                │
│  MODES EXISTANTS v2 (9)                  NOUVEAUX MODES v3 (16)               │
│  ────────────────────                    ─────────────────────                 │
│                                                                                │
│  0.  Base Knowledge Base (cosmos)        9.  Concept Map 🔴                    │
│  1.  Lexical Tags                       10.  Sunburst Hiérarchique 🔴          │
│  2.  Knowledge Graph Projet             11.  Treemap Conceptuel 🟠             │
│  3.  MindMap                            12.  Chord Diagram 🟡                  │
│  4.  Roadmap ASCENT (DAG)               13.  Sankey / Alluvial 🟠              │
│  5.  Concepts Grid                      14.  Radar Comparaison 🟠              │
│  6.  Timeline                           15.  Parallel Coordinates 🟡           │
│  7.  Statistics                         16.  Heatmap Matricielle 🟡            │
│  8.  DataFlow NEURON-CHAINS             17.  Argument Map 🟡                   │
│                                          18.  Causal Loop Diagram 🟡           │
│                                          19.  Circle Packing 🟢                │
│                                          20.  Arc Diagram 🟢                   │
│                                          21.  Hierarchical Edge Bundling 🟢    │
│                                          22.  Semantic Zoom Graph 🔴           │
│                                          23.  3D Knowledge Space 🔵            │
│                                          24.  Voronoi Concept Map 🟢           │
│                                          25.  Knowledge Cards 🔴               │
│                                                                                │
│  COUVERTURE CONCEPTUELLE : ~50% (v2) → ~87% (v3)                             │
│  🔴 Critique  🟠 Haute  🟡 Moyenne  🟢 Basse  🔵 R&D                          │
└──────────────────────────────────────────────────────────────────────────────┘
```

### D-MODES-002 : Matrice Modes × Renderers × Données

| # | Mode | Renderer | Source Données | Nœuds Max | Bundle | Phase |
|---|------|----------|---------------|-----------|--------|-------|
| 0 | Base Knowledge Base | cosmos.gl v3 | TypedArrays GPU | 1M+ | ~200KB | MVP |
| 1 | Lexical Tags | TailwindCSS + react-window | Tags DB | 10K+ | ~50KB | MVP |
| 2 | Knowledge Graph | @antv/g6 v5 | Graphology → G6 | 50K | ~280KB | MVP |
| 3 | MindMap | @antv/g6 v5 (Tree) | Graphology → G6 | 30K | ~280KB | MVP |
| 4 | Roadmap ASCENT | @xyflow/react v12 | DAG ASCENT | 1K | ~180KB | MVP |
| 5 | Concepts Grid | TanStack Table v8 | Table DB | ∞ (virtual) | ~60KB | Post-MVP |
| 6 | Timeline | Custom React | Events DB | 10K | ~50KB | Post-MVP |
| 7 | Statistics | recharts v2 | Stats aggregations | N/A | ~150KB | MVP |
| 8 | DataFlow NEURON | @xyflow/react v12 | Pipeline events | 500 | ~180KB | Post-MVP |
| **9** | **Concept Map** 🔴 | @antv/g6 v5 | Graphology → G6 | 50K | **~0KB** | **MVP+** |
| **10** | **Sunburst** 🔴 | @antv/g2 v5 | Graphology → Hiérarchie | 100K | **~180KB** | **MVP+** |
| **11** | **Treemap** 🟠 | @antv/g2 v5 | Graphology → Hiérarchie | 100K | **~0KB** | **MVP+** |
| **12** | **Chord Diagram** 🟡 | nivo/chord | Graphology → Matrice | 200 | **~30KB** | **V1** |
| **13** | **Sankey/Alluvial** 🟠 | nivo/sankey | Graphology → Flows | 500 | **~25KB** | **V1** |
| **14** | **Radar Comparaison** 🟠 | recharts v2 | SMI data | 12 axes | **~0KB** | **MVP+** |
| **15** | **Parallel Coordinates** 🟡 | d3 | Graphology → N-dim | 5K | **~35KB** | **V1** |
| **16** | **Heatmap Matricielle** 🟡 | nivo/heatmap | Graphology → Matrice | 200×200 | **~25KB** | **V1** |
| **17** | **Argument Map** 🟡 | @xyflow/react v12 | Propositions DB | 500 | **~0KB** | **V2** |
| **18** | **Causal Loop Diagram** 🟡 | @antv/g6 v5 | Graphology → CLD | 500 | **~0KB** | **V2** |
| **19** | **Circle Packing** 🟢 | nivo/circle-packing | Graphology → Hiérarchie | 5K | **~22KB** | **V1** |
| **20** | **Arc Diagram** 🟢 | d3 | Graphology → Séquentiel | 500 | **~18KB** | **V1** |
| **21** | **Edge Bundling** 🟢 | d3 | Graphology + Hiérarchie | 5K | **~15KB** | **V1** |
| **22** | **Semantic Zoom Graph** 🔴 | cosmos.gl v3 | Graphology → Cosmos | 1M+ | **~0KB** | **V2** |
| **23** | **3D Knowledge Space** 🔵 | three.js | Graphology → 3D | 10K | **~450KB** | **V3** |
| **24** | **Voronoi Concept Map** 🟢 | d3 | Graphology → Polygones | 5K | **~18KB** | **V2** |

**7 modes à 0KB additionnel** (réutilisation renderers existants) : Modes 9, 11, 14, 17, 18, 22, et partiellement 16/19 via G2

### D-MODES-003 : Couverture Conceptuelle — Avant/Après

| Catégorie de Concept Complexe | v2 (9 modes) | v3 (26 modes) | Modes clés ajoutés |
|-------------------------------|-------------|---------------|-------------------|
| Réseau sémantique simple | ✅ M0, M2 | ✅ M0, M2 | — |
| Réseau à liaisons croisées | ❌ | ✅ **M9** | Concept Map |
| Hiérarchie simple (≤3 niv.) | ✅ M1, M3 | ✅ M1, M3 | — |
| Hiérarchie profonde (≥4 niv.) | ❌ | ✅ **S10, S11** | Sunburst, Treemap |
| Taxonomie/Ontologie | ❌ | ✅ **S10, S11, M22** | Sunburst + Semantic Zoom |
| Comparaison multi-attributs | ❌ | ✅ **M14, M15** | Radar, Parallel Coord. |
| Matrice de corrélations | ❌ | ✅ **M16** | Heatmap |
| Flux & transformations | ✅ M8 | ✅ M8, **M13** | Sankey/Alluvial |
| Relations bidirectionnelles | ❌ | ✅ **S12** | Chord Diagram |
| Raisonnement logique | ❌ | ✅ **M17** | Argument Map |
| Système dynamique/feedback | ❌ | ✅ **M18** | Causal Loop Diagram |
| Exploration multi-échelle | ❌ | ✅ **M22** | Semantic Zoom |
| Navigation immersive 3D | ❌ | ✅ **M23** | 3D Knowledge Space |
| **COUVERTURE GLOBALE** | **~50%** | **~87%** | **+37% (+74% relatif)** |

### D-MODES-004 : Mode Auto-Suggest (Agent-03 DAG-ARCHITECT)

**Principe** : L'orchestrateur ASCENT suggère automatiquement le mode COSMOS optimal selon 3 signaux (zéro LLM — Rust pur) :

| Signal | Heuristique | Exemple |
|--------|------------|---------|
| **Type de données** | Hiérarchique → Sunburst, Réseau → KG, Multidimensionnel → Radar | Taxonomie détectée → Mode 10 |
| **Préférences utilisateur** | Historique des 5 derniers modes utilisés | User utilise souvent M2 → proposer M9 (enrichi) |
| **Objectif courant** | Apprentissage → Concept Map, Révision → Radar SMI, Débat → Argument Map | SMI < 40% → Mode 14 Radar pour voir les gaps |

```rust
// Agent-03 : suggest_visualization_mode() — règles métier pures
impl DagArchitect {
    fn suggest_cosmos_mode(&self, ctx: &ProjectContext) -> CosmosMode {
        let profile = self.profile_data(&ctx.graph);
        match (profile, ctx.active_goal) {
            (Hierarchical(d >= 4), _) => CosmosMode::Sunburst,
            (Network { cross_linked: true }, _) => CosmosMode::ConceptMap,
            (_, Revision) if ctx.smi_dimensions.len() > 3 => CosmosMode::Radar,
            (Temporal, _) => CosmosMode::Timeline,
            (Causal { loops: true }, _) => CosmosMode::CausalLoop,
            _ => CosmosMode::KnowledgeGraph,
        }
    }
}
```

### D-MODES-005 : Phasage Déploiement des 16 Nouveaux Modes

```
Phase 1 — MVP+ (T0+3 mois, +5 modes → ~65% couverture)
  ├── M9  : Concept Map 🔴  (15j, G6 réutilisé — 0KB)
  ├── S10 : Sunburst 🔴      (8j, G2 nouveau — 180KB)
  ├── S11 : Treemap 🟠       (6j, G2 réutilisé — 0KB)
  ├── M14 : Radar 🟠         (5j, Recharts réutilisé — 0KB)
  └── M16 : Heatmap 🟡       (7j, nivo — 25KB)
  Bundle additionnel : ~205KB | Effort : 41j

Phase 2 — Post-MVP V1 (T0+6 mois, +5 modes → ~75% couverture)
  ├── M13 : Sankey/Alluvial 🟠  (10j, nivo — 25KB)
  ├── S12 : Chord Diagram 🟡    (7j, nivo — 30KB)
  ├── M15 : Parallel Coord 🟡   (10j, d3 — 35KB)
  ├── M19 : Circle Packing 🟢   (4j, nivo — 22KB)
  └── M20 : Arc Diagram 🟢      (5j, d3 — 18KB)
  Bundle additionnel : ~130KB | Effort : 36j

Phase 3 — Post-MVP V2 (T0+12 mois, +6 modes → ~85% couverture)
  ├── M22 : Semantic Zoom 🔴  (20j, cosmos réutilisé — 0KB)
  ├── M17 : Argument Map 🟡   (12j, React Flow réutilisé — 0KB)
  ├── M18 : Causal Loop 🟡    (15j, G6 réutilisé — 0KB)
  ├── M21 : Edge Bundling 🟢  (8j, d3 — 15KB)
  └── M24 : Voronoi 🟢        (7j, d3 — 18KB)
  Bundle additionnel : ~33KB | Effort : 62j

Phase 4 — V3 R&D (T0+18 mois)
  └── M23 : 3D Knowledge Space 🔵 (30j+, three.js — 450KB optionnel)

TOTAL : +610KB lazy-loaded | Effort : 169j sur 18 mois

---

### D-MODES-006 : Mode 25 — Knowledge Cards (Dashboard Spatial Interactif & Squelette Shimmer Localisé) 🔴 CRITIQUE

**Vision** : Au lieu de représenter les concepts comme de simples cercles dans un réseau abstrait, ce mode utilise un **Dashboard Spatial Interactif** où chaque concept majeur est une carte d'étude verticale riche (custom nodes React Flow).
- **Contenu d'une Carte** : Nom du concept, résumé sémantique, niveau SMI actuel, jauge de stabilité mémorielle FSRS (couleur pulsante selon l'échéance), mini-radar de compétences, et boutons d'action rapide (lancer un Teach-Back, réviser, ou sauter vers le document source précis dans la Reader Suite).
- **Liaisons de Flux Dynamiques (CSS Motion Paths & WAAPI)** : Les arêtes reliant ces cartes ne sont pas de simples lignes inertes. Ce sont de véritables **canalisations de transfert de connaissances**. De petits nodules de données (des particules lumineuses SVG) glissent physiquement et de manière fluide le long des courbes de Bézier à une vitesse de défilement proportionnelle à la proximité sémantique de la relation, démontrant visuellement l'interconnexion sémantique et la force des liens d'apprentissage.

#### 1. Squelette Shimmer Localisé sur les Cartes en Cours de Chargement :
Pendant que l'API de base de données (ou le cache local) récupère les métadonnées spécifiques d'une carte (définition, score SMI exact, ou mini-radar), le contour de la carte est déjà rendu pour structurer l'espace, mais ses composants internes affichent un **Squelette Shimmer Localisé (Glassmorphic Card Shimmer)**.
- **Principe visuel** : Le titre de la carte, la jauge SMI et le conteneur du radar sont remplacés par des formes géométriques sombres et translucides parcourues par un balayage lumineux continu (`linear-gradient(90deg, rgba(255,255,255,0.01) 25%, rgba(255,255,255,0.08) 50%, rgba(255,255,255,0.01) 75%)`).
- **Transition fluide** : Une fois les données injectées par le store, le shimmer s'efface à l'aide d'un effet `transition: opacity 0.3s ease` pour laisser place au véritable contenu, garantissant une esthétique de chargement ultra-premium digne des standards de design 2026.

```css
/* Style du Shimmer Localisé sur les éléments de la carte */
@keyframes card-sweep {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

.scy-card-skeleton-line {
  height: 12px;
  background: linear-gradient(
    90deg,
    rgba(255, 255, 255, 0.02) 25%,
    rgba(255, 255, 255, 0.08) 50%,
    rgba(255, 255, 255, 0.02) 75%
  );
  background-size: 200% 100%;
  animation: card-sweep 1.6s infinite linear;
  border-radius: 4px;
}

.scy-knowledge-card-pending {
  background: rgba(11, 15, 30, 0.55);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.06);
  padding: 16px;
  border-radius: 12px;
  width: 240px;
  height: 320px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
```

#### 2. Animation de glissade de nodule sémantique :
```typescript
// Implémentation de la glissade de nodule sémantique sur courbe de Bézier via WAAPI et offset-path
export function animateKnowledgeEdgeNode(
  edgePath: string,
  particleNode: HTMLElement,
  speedMultiplier: number
) {
  particleNode.style.offsetPath = `path('${edgePath}')`;
  particleNode.style.offsetRotate = '0deg';
  particleNode.style.offsetAnchor = 'center';
  
  const keyframes = [{ offsetDistance: '0%' }, { offsetDistance: '100%' }];
  const animation = particleNode.animate(keyframes, {
    duration: Math.max(1000, 3000 / speedMultiplier), // Vitesse proportionnelle
    iterations: Infinity,
    easing: 'ease-in-out'
  });
  
  return animation;
}
```
```

---

## SECTION QUAL — Résolution & Netteté des Visualisations {#section-qual}

> **Contexte** : Problèmes G-09 et G-10 identifiés en production — arêtes crénelées sur écrans Retina, labels CJK cassés. Ces 3 décisions sont des **correctifs P0** applicables en Sprint 0 (2 jours au total).

---

### D-QUAL-001 : HiDPI Canvas & Anti-aliasing (Sharp Render Pipeline)

**Problème résolu** : Sur écrans Retina (devicePixelRatio > 1), les arêtes fines et labels apparaissent crénelés/flous sans correction explicite du canvas. Identifié comme D-PREMORTEM-001 Item 9 (labels CJK).

**Implémentation** :

```typescript
// Setup HiDPI automatique avec ResizeObserver
export function setupHiDPICanvas(canvas: HTMLCanvasElement, onResize: (w: number, h: number, dpr: number) => void): () => void {
  const dpr = window.devicePixelRatio || 1;

  const observer = new ResizeObserver(entries => {
    for (const entry of entries) {
      const { width, height } = entry.contentRect;
      canvas.width  = Math.round(width  * dpr);
      canvas.height = Math.round(height * dpr);
      canvas.style.width  = `${width}px`;
      canvas.style.height = `${height}px`;
      onResize(canvas.width, canvas.height, dpr);
    }
  });
  observer.observe(canvas);
  return () => observer.disconnect(); // Cleanup React
}

// G6 v5 : devicePixelRatio dans la config graph
const graph = new Graph({
  renderer: 'canvas',
  devicePixelRatio: window.devicePixelRatio || 1,
  // ...
});

// Cosmos : setPixelRatio après init
await cosmosGraph.ready;
cosmosGraph.setPixelRatio(window.devicePixelRatio || 1);

// Labels subpixel-snapped (anti-aliasing optimal)
export function renderSharpLabel(
  ctx: CanvasRenderingContext2D,
  text: string, x: number, y: number, fontSize: number
): void {
  const dpr = window.devicePixelRatio || 1;
  const snappedX = Math.round(x * dpr * 2) / (dpr * 2);
  const snappedY = Math.round(y * dpr * 2) / (dpr * 2);

  ctx.save();
  ctx.imageSmoothingEnabled = true;
  ctx.imageSmoothingQuality = 'high';

  // Halo blanc derrière le texte (lisibilité sur fond coloré)
  ctx.strokeStyle = 'rgba(255,255,255,0.9)';
  ctx.lineWidth   = Math.max(2, fontSize * 0.25);
  ctx.strokeText(text, snappedX, snappedY);

  ctx.fillStyle = '#1F2937';
  ctx.fillText(text, snappedX, snappedY);
  ctx.restore();
}
```

**Résultat** : Arêtes et labels nets à 1×, 2×, 3× DPI. Applicable à G6 Canvas, Cosmos WebGL, et Canvas2D labels.
**Effort** : 1 jour | **Phase** : Sprint 0

---

### D-QUAL-004 : KaTeX & Technical Layout Rendering — Anti-clipping & Zero FOUT 🔴 P0

**Problème résolu** : Les équations mathématiques complexes et les formules sémantiques s'affichent souvent avec un retard (FOUT - Flash of Unstyled Text) ou sont coupées sur les bords (clipping) dans le viewport des cartes COSMOS ou des slides.

**Solution** : Intégration de KaTeX asynchrone pré-compilé côté client au sein du *Active Reading Layer*.
- **Rendu subpixel** : Calcul automatique des boîtes de délimitation (bounding box) avant l'injection dans les typed arrays GPU de Cosmos ou G6 pour réserver l'espace nécessaire et empêcher tout clipping.
- **Style dédié** :
```css
.scy-katex-block {
  font-family: "KaTeX_Main", "KaTeX_Math", sans-serif;
  font-size: 1.1em;
  padding: 12px;
  background: rgba(255, 255, 255, 0.02);
  border-radius: 8px;
  overflow-x: auto; /* Scroll horizontal si formule trop longue */
  border-left: 3px solid #8b5cf6; /* Accroche violette sémantique */
}
```

**Effort** : 1 jour | **Phase** : Sprint 0 (dépendance déjà listée dans READER SUITE)

---

### D-QUAL-002 : Universal Font System (CJK + Emoji)

**Problème résolu** : Labels en chinois, japonais, coréen et emoji non rendus correctement → layout cassé en production (pré-mortem Item 9 confirmé).

```typescript
// Font Stack universel — ordre de priorité
export const COSMOS_FONT_STACK = [
  'Inter Variable',      // Latin principal (variable font = 1 fichier)
  'Noto Sans SC',        // Chinois simplifié
  'Noto Sans JP',        // Japonais
  'Noto Sans KR',        // Coréen
  'Noto Sans',           // Autres scripts Unicode
  'Noto Color Emoji',    // Emoji (couleur)
  'system-ui',           // Fallback OS natif
  'sans-serif',
].join(', ');

// index.html : preload fonts critiques (évite FOUT)
// <link rel="preload" href="/fonts/inter-variable.woff2" as="font" type="font/woff2" crossorigin>
// <link rel="preload" href="/fonts/noto-sans-sc-regular.woff2" as="font" type="font/woff2" crossorigin>

// G6 v5 : injection globale dans labelCfg
export const G6_GLOBAL_LABEL_CFG = {
  style: {
    fontFamily: COSMOS_FONT_STACK,
    fontSize: 12,
    fontWeight: 400,
    textAlign: 'center' as const,
    textBaseline: 'middle' as const,
  },
};

// Truncation CJK-aware (coupe sur frontière graphème, pas octet)
export function truncateLabelCJKAware(label: string, maxLen: number = 30): string {
  if (label.length <= maxLen) return label;
  const segmenter = new Intl.Segmenter(undefined, { granularity: 'grapheme' });
  const segs = [...segmenter.segment(label)];
  if (segs.length <= maxLen) return label;
  return segs.slice(0, maxLen).map(s => s.segment).join('') + '…';
}
```

**Bénéfice** : Support complet Unicode (CJK, emoji, RTL partiel). Variable font = -60KB bundle vs 8 fichiers séparés.
**Effort** : 1 jour | **Phase** : Sprint 0

---

### D-QUAL-003 : Adaptive Quality Scaling (AQS)

**Problème résolu** : Sur appareils LOW/COMPAT tier, le rendu peut descendre à 15fps → expérience perçue comme "buggée".

```typescript
// Moniteur FPS avec ajustement qualité dynamique
export class AdaptiveQualitySystem {
  private targetFPS    = 60;
  private currentScale = 1.0;       // 1.0 = pleine résolution native
  private readonly minScale = 0.5;  // 50% minimum
  private lastFrameTime = 0;
  private frameCount = 0;
  private fpsWindow: number[] = []; // Fenêtre glissante 30 frames

  onAnimationFrame(timestamp: number): void {
    if (this.lastFrameTime > 0) {
      const frameFPS = 1000 / (timestamp - this.lastFrameTime);
      this.fpsWindow.push(frameFPS);
      if (this.fpsWindow.length > 30) this.fpsWindow.shift();

      if (this.frameCount % 30 === 0) {
        const avgFPS = this.fpsWindow.reduce((a, b) => a + b, 0) / this.fpsWindow.length;
        this.adjustQuality(avgFPS);
      }
    }
    this.lastFrameTime = timestamp;
    this.frameCount++;
  }

  private adjustQuality(fps: number): void {
    if (fps < this.targetFPS * 0.75) {
      // FPS trop bas → réduire résolution par paliers de 10%
      this.currentScale = Math.max(this.minScale, this.currentScale - 0.1);
      this.applyScale(this.currentScale);
    } else if (fps >= this.targetFPS * 0.95 && this.currentScale < 1.0) {
      // FPS stable → tenter d'augmenter la résolution progressivement
      this.currentScale = Math.min(1.0, this.currentScale + 0.05);
      this.applyScale(this.currentScale);
    }
  }

  private applyScale(scale: number): void {
    const canvas = document.getElementById('cosmos-canvas') as HTMLCanvasElement;
    if (!canvas) return;
    const dpr = window.devicePixelRatio || 1;
    const rect = canvas.getBoundingClientRect();
    canvas.width  = Math.round(rect.width  * scale * dpr);
    canvas.height = Math.round(rect.height * scale * dpr);
  }
}
```

**Résultat** : Expérience fluide même sur LOW tier — dégradation invisible vs crash FPS brusque.
**Effort** : 2 jours | **Phase** : Phase 1

---

## SECTION UX — Interface & Interactivité Avancée {#section-ux}

> **Contexte** : Cette section remplace le placeholder "D-UX-001→011" du document v3. Elle documente les 12 décisions UX issues de l'analyse terrain 2025-2026 et des solutions COSMOS_SOLUTIONS_COMPLETES.

---

### D-UX-001 : Fisheye Lens — Focus+Context (G6 Plugin Natif)

**Problème résolu** : G-01 (Hairball) + G-13 (Focus+Context absent). Zoomer = perte de contexte. Ne pas zoomer = détail illisible.

**Solution** : G6 v5 intègre nativement le plugin Fisheye (zéro dépendance ajoutée).

```typescript
// Activation dans la config G6 v5
import { Graph } from '@antv/g6';

const graph = new Graph({
  plugins: [
    {
      type: 'fisheye',
      trigger: 'drag',          // Drag pour déplacer (compatible mobile)
      d: 1.5,                   // Facteur de distorsion initial
      r: 150,                   // Rayon lentille (pixels)
      showDPercent: false,      // UI propre sans debug
      minD: 1.0, maxD: 3.0,
      minR: 80,  maxR: 250,
      scaleRBy: 'wheel',        // Molette = rayon
    },
  ],
});

// Raccourci clavier F = toggle fisheye
let fisheyeEnabled = false;
document.addEventListener('keydown', (e: KeyboardEvent) => {
  if ((e.key === 'f' || e.key === 'F') && !e.ctrlKey && !e.metaKey) {
    fisheyeEnabled = !fisheyeEnabled;
    graph.updatePlugin({ type: 'fisheye', enable: fisheyeEnabled });
    showFisheyeToast(fisheyeEnabled); // "🔍 Lentille active [F pour désactiver]"
  }
});
```

**UX Behaviors** :
- Raccourci `F` → toggle ON/OFF + toast discret bas-droit
- Drag → déplacer lentille sur zone d'intérêt
- Molette sur lentille → ajuster rayon 80-250px
- Zone centrale → nœuds agrandis ×1.5 à ×3, labels lisibles
- Zone extérieure → contexte global LOD 0 préservé

**Effort** : 2 jours (inclus G-01 + G-13) | **Phase** : Phase 1 (bundlé)

---

### D-UX-002 : Progressive Graph Rendering — L'Allumage Neural (The Neural Ignition Reveal) 🔴 WAOUH EFFECT

**Problème résolu** : G-06 (Long Wait Times). Les squelettes classiques (shimmers gris et blancs de type Facebook ou LinkedIn) sont plats, ennuyeux et totalement inadaptés à un graphe de connaissances vivant. Ils détruisent l'aspect magique de l'application. 
**La Solution** : Remplacer l'attente par une **séquence cinématique interactive d'allumage neural (The Neural Ignition Reveal)**. Cette séquence transforme le chargement technique des données en une métaphore visuelle de l'éveil du cerveau de l'utilisateur.

#### Les 4 Phases de l'Allumage Neural :

1. **Phase 1 : La Constellation Sémantique (0 à 500ms — Immédiat)** :
   Dès l'ouverture, le canvas affiche un fond sombre et profond (effet "espace cognitif"). Des micro-particules lumineuses (le bruit de fond cérébral) flottent doucement à l'aide d'un shader WebGL de basse intensité. L'utilisateur est instantanément immergé.
   
2. **Phase 2 : L'Étincelle des Hubs (500ms à 1.5s — Révélation des Piliers)** :
   Les concepts majeurs du projet (déterminés localement via PageRank, ex: *React*, *JavaScript*) s'allument soudainement comme des étoiles de haute intensité (nébuleuses pulsantes). De fins faisceaux laser (lignes d'énergie SVG à forte luminance) jaillissent de ces hubs pour dessiner les premières autoroutes du savoir.
   
3. **Phase 3 : La Condensation Cosmique (1.5s à 3s — Croissance Organique)** :
   Les sous-concepts et les nœuds feuilles se condensent et s'allument le long des lignes de force comme des connexions synaptiques qui se créent en temps réel. Le tout s'accompagne d'une animation fluide de dé-zoom de la caméra (auto-centering) pour révéler l'ampleur du graphe.
   
4. **Phase 4 : La Stabilisation de Force (3s+ — Focus final)** :
   La simulation physique (ForceAtlas2) décélère doucement pour stabiliser les nœuds. Les labels textuels apparaissent avec un fondu progressif de flou à net (*blur-to-focus transition*), invitant l'utilisateur à l'exploration active.

```css
/* Animation d'allumage et de pulsation des nébuleuses de Hubs */
@keyframes synap-pulse {
  0% { transform: scale(0.95); opacity: 0.7; filter: drop-shadow(0 0 5px rgba(139, 92, 246, 0.5)); }
  50% { transform: scale(1.05); opacity: 1.0; filter: drop-shadow(0 0 15px rgba(139, 92, 246, 0.9)); }
  100% { transform: scale(0.95); opacity: 0.7; filter: drop-shadow(0 0 5px rgba(139, 92, 246, 0.5)); }
}
.cosmos-igniting-hub {
  animation: synap-pulse 2s infinite ease-in-out;
}
```

**Code de Rendu Progressif :**
```typescript
// Orchestrateur de rendu progressif
type RenderPhase = 'skeleton' | 'clusters' | 'hubs' | 'complete';

interface StreamingRenderState {
  phase: RenderPhase;
  progress: number;              // 0.0–1.0
  nodes_rendered: number;
  total_nodes: number;
  estimated_remaining_ms: number;
}

async function renderGraphProgressively(
  graph: GraphBackend,
  renderer: RendererInterface,
  onUpdate: (state: StreamingRenderState) => void
): Promise<void> {
  const total = graph.order;

  // Phase 0 : Skeleton shimmer (0ms — immédiat)
  onUpdate({ phase: 'skeleton', progress: 0, nodes_rendered: 0, total_nodes: total, estimated_remaining_ms: 3000 });

  // Phase 1 : Clusters LOD 0 (100-300ms, depuis IndexedDB cache)
  const clusterData = await layoutCache.getClusters();
  if (clusterData) {
    renderer.renderClusters(clusterData);
    onUpdate({ phase: 'clusters', progress: 0.2, nodes_rendered: clusterData.length, total_nodes: total, estimated_remaining_ms: 2000 });
  }

  // Phase 2 : Hubs par cluster (Top PageRank, 500ms-2s)
  const clusters = await getClusters(graph);
  for (const cluster of clusters) {
    const hubs = getTopPageRankNodes(cluster, 10);
    renderer.renderHubs(hubs);
  }
  onUpdate({ phase: 'hubs', progress: 0.5, nodes_rendered: clusters.length * 10, total_nodes: total, estimated_remaining_ms: 1000 });

  // Phase 3 : Tous les nœuds en batches de 500 (yield entre chaque)
  const nodeIds = graph.nodes();
  for (let i = 0; i < nodeIds.length; i += 500) {
    const batch = nodeIds.slice(i, i + 500).map(id => ({ id, ...graph.getNodeAttributes(id) }));
    renderer.appendNodes(batch);
    onUpdate({
      phase: 'complete',
      progress: 0.5 + (i / nodeIds.length) * 0.45,
      nodes_rendered: Math.min(i + 500, nodeIds.length),
      total_nodes: total,
      estimated_remaining_ms: Math.round((nodeIds.length - i) / 500 * 50),
    });
    await new Promise(resolve => requestAnimationFrame(resolve)); // yield = UI libre
  }
}

// Composant React indicateur de progression
function GraphProgressBar({ state }: { state: StreamingRenderState }) {
  return (
    <div className="cosmos-progress" role="progressbar" aria-valuenow={state.progress * 100}>
      <div className="cosmos-progress-fill" style={{ width: `${state.progress * 100}%` }} />
      <span className="cosmos-progress-label">
        {state.phase === 'skeleton' && '⏳ Préparation...'}
        {state.phase === 'clusters' && '🗺️ Chargement des clusters...'}
        {state.phase === 'hubs'    && '🔮 Identification des concepts clés...'}
        {state.phase === 'complete' && `📊 ${state.nodes_rendered.toLocaleString()}/${state.total_nodes.toLocaleString()} concepts`}
      </span>
    </div>
  );
}
```

**Résultat** : Temps perçu ÷5 — l'utilisateur voit le graphe se construire au lieu d'un spinner blanc.
**Effort** : 6 jours | **Phase** : Phase 1

---

### D-UX-003 : Knowledge Cards v2 — Cartes Contextuelles Riches

**Problème résolu** : G-03 (tooltips insuffisants). Le marché attend des cartes enrichies couplant contexte, métriques d'apprentissage, provenance et actions rapides.

```typescript
// Modèle complet Knowledge Card v2
interface KnowledgeCardV2 {
  concept_id: string;
  title: string;
  definition: string;         // 1-3 phrases (NEURON-CHAINS, pré-généré ingestion)
  domain_tags: string[];

  // Couche Learning State (UNIQUE COSMOS — voir D-OPP-001)
  smi: {
    global: number;           // 0-100
    retention: number;
    depth: number;
    mirror: number;
    next_review: string;      // "Dans 3 jours" | "Aujourd'hui 🔔"
    retention_forecast_7d: string; // "Rétention dans 7j : 82%"
  };

  // Connexions clés (max 3 chacune)
  prerequisites: Array<{ id: string; label: string; smi: number }>;
  children:      Array<{ id: string; label: string; smi: number }>;

  // Provenance (voir D-OPP-003)
  sources: Array<{
    type: 'youtube' | 'pdf' | 'web' | 'manual' | 'ai';
    label: string;
    confidence: number;
  }>;

  // Confiance IA (si connexion auto-générée)
  ai_metadata?: {
    confidence_pct: number;
    confidence_label: 'Haute' | 'Moyenne' | 'Faible';
    explanation: string;
  };

  // Actions rapides
  actions: Array<{
    type: 'open_apex' | 'open_reader' | 'open_brain' | 'create_link' | 'validate_ai' | 'reject_ai';
    label: string;
    icon: string;
  }>;
}

// Déclenchement : clic (pas hover — mobile-first)
// Position : collision-aware (jamais hors viewport)
// Animation : spring physics react-spring (tension 180, friction 12)
// Mode Pin : 📌 garde la carte ouverte pendant navigation
// Fermeture : clic extérieur | Escape | bouton ×

// Layout visuel (voir COSMOS_SOLUTIONS_COMPLETES.md §G-03 pour wireframe complet)
```

**Effort** : 8 jours | **Phase** : Phase 1

---

### D-UX-004 : Persona Adaptive Interface (3 Niveaux Expertise)

**Problème résolu** : G-04. Un novice et un expert partagent la même interface COSMOS → surcharge cognitive novices / frustration experts.

```typescript
type CosmosPersona = 'discoverer' | 'analyst' | 'explorer';

const PERSONA_PROFILES = {
  discoverer: {
    label: '🌱 Découverte',
    default_mode: CosmosMode.MindMap,
    max_visible_nodes: 50,
    show_confidence_badges: false,
    controls_visibility: 'minimal' as const,
    default_layout: 'radial',
    lod_thresholds: { cluster: 10, hub: 30, full: 50 },
  },
  analyst: {
    label: '🔍 Analyse',
    default_mode: CosmosMode.ConceptMap,
    max_visible_nodes: 300,
    show_confidence_badges: true,
    controls_visibility: 'standard' as const,
    default_layout: 'force-atlas2',
    lod_thresholds: { cluster: 30, hub: 100, full: 300 },
  },
  explorer: {
    label: '🚀 Exploration',
    default_mode: CosmosMode.BaseKnowledge,
    max_visible_nodes: Infinity,
    show_confidence_badges: true,
    controls_visibility: 'full' as const,
    default_layout: 'cosmos-gpu',
    lod_thresholds: { cluster: 100, hub: 500, full: Infinity },
  },
} as const;

// Détection automatique depuis l'historique comportemental
function detectPersona(history: UserBehaviorHistory): CosmosPersona {
  if (history.total_concepts > 100 && history.advanced_filter_usage > 5) return 'explorer';
  if (history.total_concepts > 20   || history.mode_switches > 3)          return 'analyst';
  return 'discoverer';
}

// Upgrade progressif avec proposition toast (non-intrusif)
// discoverer → analyst : >20 concepts ET SMI moyen > 50%
// analyst → explorer   : usage avancé détecté (filtres, multi-modes)
// Sélection manuelle : Bouton "Mode" en bas-gauche du graphe (toujours accessible)
```

**Effort** : 5 jours | **Phase** : Phase 1

---

### D-UX-005 : Behavioral Progressive Disclosure (Révélation par Comportement)

**Problème résolu** : FRUST-2 (Information Overload). Progressive Disclosure existante réagit au zoom géométrique uniquement — pas aux signaux comportementaux.

```typescript
// Moteur de révélation comportementale
class BehavioralDisclosureEngine {
  private hoverStartTimes = new Map<string, number>();

  onNodeHoverStart(nodeId: string): void {
    this.hoverStartTimes.set(nodeId, Date.now());
  }

  onNodeHoverEnd(nodeId: string, graph: Graph, openCard: (id: string) => void): void {
    const start = this.hoverStartTimes.get(nodeId);
    if (!start) return;
    const duration = Date.now() - start;
    this.hoverStartTimes.delete(nodeId);

    // Hover 1.5s → révéler badges (SMI, source) sans interaction
    if (duration >= 1500) graph.updateNodeData(nodeId, { showBadges: true });
    // Hover 3s  → ouvrir Knowledge Card automatiquement
    if (duration >= 3000) openCard(nodeId);
  }
}

// Limite cognitive : Max 5 éléments enrichis simultanément (Miller's Law 7±2)
// Source : Smashing Magazine "UX Strategies for Real-Time Dashboards" (Sep 2025)

// Intégration G6 :
const bde = new BehavioralDisclosureEngine();
graph.on('node:mouseenter', evt => bde.onNodeHoverStart(evt.itemId));
graph.on('node:mouseleave', evt => bde.onNodeHoverEnd(evt.itemId, graph, openKnowledgeCard));
```

**Effort** : 4 jours | **Phase** : Phase 1

---

### D-UX-006 : Typed Semantic Edge Styles (Arêtes Sémantiques)

**Problème résolu** : G-08. Toutes les arêtes ont le même style visuel → impossible de distinguer `prerequisite_of` de `contradicts`.

```typescript
type EdgeRelationType =
  'prerequisite_of' | 'related_to' | 'contradicts' |
  'example_of'      | 'part_of'    | 'cross_domain' | 'ai_generated';

const EDGE_SEMANTIC_STYLES: Record<EdgeRelationType, object> = {
  prerequisite_of: { stroke: '#3B82F6', lineWidth: 2.0, lineDash: undefined,  opacity: 0.9, endArrow: { type: 'triangle', fill: '#3B82F6' } },
  related_to:      { stroke: '#9CA3AF', lineWidth: 1.0, lineDash: [6, 4],     opacity: 0.6, endArrow: undefined },
  contradicts:     { stroke: '#EF4444', lineWidth: 2.0, lineDash: [3, 3],     opacity: 0.85, endArrow: { type: 'diamond' }, startArrow: { type: 'diamond' } },
  example_of:      { stroke: '#10B981', lineWidth: 1.0, lineDash: undefined,  opacity: 0.7, endArrow: { type: 'vee' } },
  part_of:         { stroke: '#F59E0B', lineWidth: 2.5, lineDash: undefined,  opacity: 0.8, endArrow: { type: 'circle' } },
  cross_domain:    { stroke: '#F97716', lineWidth: 1.5, lineDash: [8, 3, 2, 3], opacity: 0.65 },
  ai_generated:    { stroke: '#8B5CF6', lineWidth: 1.2, lineDash: [5, 3],     opacity: 0.70 },
};

// Légende automatique : liste uniquement les types présents dans le graphe courant
// Clic légende → filtrer / mettre en valeur ce type d'arête (toggle)
// Raccourci : `L` → toggle panneau légende

---

### D-UX-013 : MiniMap Navigation GPS (Localisateur de Graphe) 🔴 HAUTE

**Problème résolu** : Les utilisateurs se sentent perdus lorsqu'ils zooment sur un concept précis dans les graphes de grande envergure (LOD 2 ou LOD 3), perdant toute notion de leur emplacement global dans la taxonomie.

**Solution** : Intégrer un module **MiniMap (GPS de Graphe)** interactif situé en bas-droite de l'interface visuelle.
- **Composant MiniMap** : Un widget semi-transparent (180×120px) affichant la silhouette complète du graphe en miniature.
- **Affichage des Régions** : Les clusters sémantiques y sont colorés de manière atténuée.
- **Viseur de Viewport** : Un rectangle rouge ou bleu délimite la zone actuellement visible à l'écran (viewport).
- **Navigation Interactive** : Cliquer ou faire glisser (drag) à l'intérieur du viseur de la MiniMap repositionne et translate instantanément la caméra principale du graphe (pan) avec un effet de glissement physique fluide.
- **Optimisation de Rendu** : La MiniMap utilise un canvas 2D ultra-simplifié dessiné à faible fréquence (rafraîchi toutes les 3 frames maximum, ou uniquement lors des pan/zoom) pour ne consommer **0.05ms** de CPU/GPU.

```typescript
// MiniMap Component Props standard (@xyflow/react)
// <MiniMap nodeColor={n => getClusterColor(n.community)} zoomable pannable style={{ borderRadius: '8px' }} />

---

### D-UX-014 : Generative-Canvas-AI (FlowSeek) — Rendu de Graphes en Streaming 🔴 HAUTE

**Problème résolu** : Les illustrations d'infographies classiques (`InfographicAI`) sont statiques et figées. Pour expliquer des flux complexes (comme une architecture microservices ou un processus de paiement) dans les slides ASCENT et les pages de cours, l'agent IA doit pouvoir **dessiner le schéma en direct sous les yeux de l'apprenant** à mesure qu'il l'explique, créant une expérience d'étude immersive inégalée.

**La Solution (FlowSeek / Generative-Canvas-AI)** : Un composant d'orchestration React Flow couplé à un solveur d'auto-layout asynchrone (**`elkjs`**).

```
[Agent IA (NEURON-CHAINS)] ──(JSON Stream des nœuds/liens)──► [Vercel AI SDK]
                                                                    │
                                                            (Stream récept.)
                                                                    │
                                                                    ▼
                                                         [React Flow Frontend]
                                                                    │
                                                            (Calcul layout)
                                                                    │
                                                                    ▼
                                                      [ELK.JS (0$ server compute)]
                                                                    │
                                                        (Rendu progressif 60fps)
                                                                    │
                                                                    ▼
                                                      [Graphe interactif final]
```

1. **Streaming Structuré (Zéro Latence, Coût Minimal)** :
   * L'agent IA n'écrit pas de code Javascript. Il émet un flux JSON structuré d'événements (via le modèle `streamText` ou `streamObject` du Vercel AI SDK et l'API compatible LiteLLM) contenant les nœuds, leurs relations sémantiques, et leurs métadonnées d'explication.
   
2. **Auto-Layout local via `elkjs` (Eclipse Layout Kernel)** :
   * À chaque réception de nœud dans le flux, le client React ne freeze pas. Il passe la liste des nœuds et arêtes à `elkjs` (s'exécutant dans un Web Worker local pour un coût de **0$ serveur**).
   * `elkjs` résout les coordonnées de placement ($x, y$) en moins de **10ms** (gérant parfaitement les graphes complexes à plusieurs racines et multi-parents, contrairement aux structures d'arbres simples de Dagre).
   
3. **Apparition Synaptique** :
   * Les nœuds apparaissent un à un à l'écran en fondu, et les lignes s'animent vers leurs cibles à mesure que la pensée de l'IA se déploie.

```typescript
// Exemple d'implémentation de recalcul d'auto-layout en streaming avec elkjs
import ELK from 'elkjs/lib/elk.bundled.js';

const elk = new ELK();

export async function computeStreamingElkLayout(nodes: any[], edges: any[]) {
  const elkGraph = {
    id: "root",
    layoutOptions: {
      'elk.algorithm': 'layered',
      'elk.direction': 'RIGHT',
      'elk.spacing.nodeNode': '40',
      'elk.layered.spacing.edgeNode': '40'
    },
    children: nodes.map(n => ({ id: n.id, width: 180, height: 80 })),
    edges: edges.map(e => ({ id: e.id, sources: [e.source], targets: [e.target] }))
  };
  
  const layout = await elk.layout(elkGraph);
  
  // Associer les coordonnées calculées par ELK.JS aux nœuds React Flow
  return nodes.map(n => {
    const elkNode = layout.children?.find(cn => cn.id === n.id);
    return {
      ...n,
      position: { x: elkNode?.x ?? 0, y: elkNode?.y ?? 0 }
    };
  });
}
```
```
```

**Effort** : 2 jours | **Phase** : Sprint 0

---

### D-UX-007 : Exploration Trail (Fil d'Ariane du Graphe)

**Problème résolu** : Les utilisateurs se perdent dans les graphes complexes après plusieurs clics successifs.

```typescript
interface ExplorationTrail {
  steps: Array<{
    node_id: string;
    label: string;
    zoom_level: number;
    mode: CosmosMode;
    timestamp: number;
  }>;
  readonly maxLength: 10;
}

// UX :
// Barre horizontale fixe en bas du graphe (height: 32px)
// [Base KG] → [Python] → [Machine Learning] → [Neural Networks] → [Backpropagation]
// Clic sur une étape → retour à cet état (zoom + focus + mode)
// Ctrl+Z graphe → retour étape précédente (≠ annuler action BDD)
// "Partager ce chemin" → URL encodée avec état navigation complet

// Stockage : sessionStorage uniquement (perdu au refresh — intentionnel)
// Export : Bouton "📋 Copier le chemin" → clipboard URL
```

**Effort** : 3 jours | **Phase** : Phase 1

---

### D-UX-008 : Prescriptive Insights Inline (Moteur d'Insights Proactifs)

**Problème résolu** : FRUST-2. Le graphe décrit l'état des connaissances mais ne prescrit aucune action (72% des utilisateurs exportent vers Excel quand l'outil ne répond pas à leurs questions).

> **Note** : Cette décision est développée dans D-OPP-004 (Opportunité 4). Référence croisée.

**Résumé** : Panel flottant bas-gauche, max 3 insights simultanés générés par règles Rust (0 LLM), avec CTA ancré dans la visualisation.

**Effort** : 6 jours | **Phase** : Phase 1 | **Détail complet** : voir D-OPP-004

---

### D-UX-009 : Natural Language Query Bridge — BRAIN ↔ COSMOS

**Problème résolu** : G-14. Navigation manuelle uniquement. Pas de requête en langage naturel.

```typescript
// Cmd+K / Ctrl+K → Command Bar COSMOS (style Linear/Raycast)

type GraphIntent =
  | { type: 'FIND_PREREQUISITES'; concept: string; hops: number }
  | { type: 'SHOW_CLUSTER';       domain: string }
  | { type: 'HIGHLIGHT_DUE_TODAY' }
  | { type: 'FIND_GAPS';          smi_threshold: number }
  | { type: 'SHOW_SOURCE_TYPE';   source: 'youtube' | 'pdf' | 'web' };

async function parseGraphIntent(input: string): Promise<GraphIntent> {
  // Pattern heuristiques (~70% cas, $0 LLM)
  if (input.match(/prérequis de (.+)/i))
    return { type: 'FIND_PREREQUISITES', concept: input.match(/prérequis de (.+)/i)![1], hops: 2 };
  if (input.match(/réviser aujourd|cartes dues/i))
    return { type: 'HIGHLIGHT_DUE_TODAY' };
  if (input.match(/lacune|manquant/i))
    return { type: 'FIND_GAPS', smi_threshold: 50 };

  // BRAIN LLM pour intents complexes (~$0.0001/requête — ~200 tokens)
  return brain.parseGraphIntent(input);
}

// Preview obligatoire avant exécution : "Voici ce que je vais mettre en valeur — Confirmer ?"
// Coût LLM : $0 pour 70% des requêtes, $0.0001 pour les 30% restants
// Source : GraphSeek arXiv 2602.11052 (Feb 2026) — Semantic Catalog pattern
```

**Effort** : 12 jours | **Phase** : Phase 2

---

### D-UX-010 : Relevance Engine (Reveal by Relevance)

**Problème résolu** : G-01 (volet contextuel). La révélation par zoom géométrique ne tient pas compte du contexte d'apprentissage.

> **Note** : Cette décision est développée dans D-OPP-005 (Opportunité 5). Référence croisée.

**Résumé** : Filtre contextuel piloté par le nœud ASCENT actif, les révisions APEX récentes, les queries BRAIN et le SMI — affiche les 150 concepts les plus pertinents POUR L'UTILISATEUR MAINTENANT.

**Effort** : 10 jours | **Phase** : Phase 2 | **Détail complet** : voir D-OPP-005

---

### D-UX-011 : Gap Detection Visuel (Prérequis Manquants)

**Problème résolu** : Lacunes conceptuelles invisibles dans le graphe actuel.

```typescript
// Traversal petgraph côté Rust : déjà disponible (§6.1 dépendances)
// Trouver prérequis absents de scy_concepts (user) pour les concepts actuels

interface ConceptGap {
  missing_concept_label: string;  // Concept manquant
  required_by: string[];          // Concepts qui en dépendent
  severity: 'critical' | 'high' | 'medium';
}

// Rendu COSMOS :
// Nœuds manquants → points de "fantôme" en pointillés rouges
// Arêtes vers concepts manquants → rouges striées
// Badge : "❓ Prérequis manquant"
// CTA dans Knowledge Card : "Combler cette lacune" → Agent-02 CONTENT-SCOUT

// Déclenchement : automatique à l'ouverture COSMOS si gaps > 0
// Toggle : bouton "🔍 Voir les lacunes" dans controls COSMOS
```

**Effort** : 5 jours (réutilise petgraph existant) | **Phase** : Phase 1

---

### D-UX-012 : Cross-Tab Graph Sync (BroadcastChannel)

**Problème résolu** : G-12. Modifications dans l'onglet 1 invisibles dans l'onglet 2.

```typescript
// Leader Election via Web Locks API (natif, sans lib)
class TabLeaderElection {
  private isLeader = false;
  private readonly lockName = 'cosmos-leader-v1';
  private readonly channel  = new BroadcastChannel('cosmos-graph-v1');

  async init(): Promise<void> {
    navigator.locks.request(this.lockName, { mode: 'exclusive' }, async () => {
      this.isLeader = true;
      this.channel.postMessage({ type: 'LEADER_ELECTED' });
      // Tenir le lock jusqu'à fermeture de l'onglet
      await new Promise<void>(res => window.addEventListener('beforeunload', () => res()));
    });

    // Recevoir sync depuis le leader
    this.channel.addEventListener('message', (evt) => this.handleSync(evt.data));
  }

  broadcastChange(msg: GraphSyncMessage): void {
    if (this.isLeader) this.channel.postMessage(msg);
  }
}

type GraphSyncMessage =
  | { type: 'NODE_ADDED';   payload: NodeData }
  | { type: 'EDGE_CREATED'; payload: EdgeData }
  | { type: 'EDGE_REJECTED'; edge_id: string }
  | { type: 'LAYOUT_UPDATE'; version: number };
```

**Effort** : 4 jours | **Phase** : Phase 2

---

## SECTION OPP — 5 Opportunités de Différenciation Absolue {#section-opp}

> **Ces 5 features n'existent chez aucun concurrent** (Gephi, Neo4j Browser, Obsidian, Roam, Tableau). Elles sont possibles uniquement parce que COSMOS est intégré à APEX/FSRS/ASCENT/BRAIN/READER SUITE.

---

### D-OPP-001 : Learning-Aware Graph (SMI intégré dans COSMOS)

**Vision** : Première visualisation de graphe au monde affichant l'état d'apprentissage (SMI, FSRS, prochain rappel) directement dans les nœuds.

```typescript
// Données SMI enrichissant chaque nœud COSMOS
interface CosmosNodeWithSMI extends NodeData {
  smi_state: {
    global: number;               // 0-100
    retention: number;            // Dimension FSRS (35%)
    depth: number;                // Scores exercices (25%)
    mirror: number;               // Teach-Back (20%)
    next_review_at: number;       // Unix timestamp
    review_overdue: boolean;
    retention_forecast_7d: number;
    last_reviewed_at?: number;
  };
}

// Style dynamique du nœud selon SMI
function getSMINodeStyle(smi: number, overdue: boolean): object {
  return {
    fill:    smi >= 86 ? '#FCD34D' : smi >= 70 ? '#4ADE80' :
             smi >= 60 ? '#FDE68A' : smi >= 40 ? '#FB923C' : '#F87171',
    opacity: 0.5 + Math.min(smi / 100, 0.5),    // Concepts récents plus opaques
    halo:    overdue ? { color: '#EF4444', animate: 'pulse', opacity: 0.3 } : undefined,
    badges: [
      { text: `${Math.round(smi)}`,                           position: 'top-right', fontSize: 9 },
      { text: overdue ? '🔔' : `📅${daysUntil(nextReview)}`, position: 'top-left',  fontSize: 9,
        pulsing: overdue },
    ],
  };
}

// Synchronisation temps réel : APEX session termine → COSMOS nœuds mis à jour via EventBus
// Vue "SMI Overview" (Mode 7 enrichi) :
//   → Radar chart SMI 5 dimensions
//   → "Votre graphe est maîtrisé à X% — continuez ainsi !"
//   → Top 10 concepts à réviser (urgence décroissante)
```

**Impact** : L'utilisateur voit CE QU'IL MAÎTRISE VRAIMENT (vert) vs CE QU'IL PENSE MAÎTRISER (rouge).
**Effort** : 10 jours | **Phase** : Phase 1

---

### D-OPP-002 : Transparent AI Graph (IA Explicable)

**Vision** : Chaque connexion IA est visuellement distincte avec son niveau de confiance — l'utilisateur valide ou rejette explicitement avec un feedback loop qui améliore le modèle.

```typescript
// Calcul confiance multi-signaux (D-SEC-001)
function computeEdgeConfidence(signals: {
  cosine_similarity: number;
  source_agreement:  number;
  concept_maturity:  number;
  domain_consistent: boolean;
}): { level: 'HIGH' | 'MEDIUM' | 'LOW'; pct: number; color: string } {
  const score =
    0.45 * signals.cosine_similarity +
    0.30 * signals.source_agreement +
    0.15 * Math.min(signals.concept_maturity / 10, 1) +
    0.10 * (signals.domain_consistent ? 1 : 0.5);

  if (score >= 0.88) return { level: 'HIGH',   pct: Math.round(score * 100), color: '#8B5CF6' };
  if (score >= 0.80) return { level: 'MEDIUM', pct: Math.round(score * 100), color: '#A78BFA' };
  return               { level: 'LOW',    pct: Math.round(score * 100), color: '#C4B5FD' };
}

// Validation Flow :
//   Pending   → badge "🤖 XX%" + boutons ✓/✗ dans Knowledge Card (raccourci V/X)
//   Validated → style passe à connexion "utilisateur confirmée"
//   Rejected  → fadeOut 300ms + stockage dans scy_ai_rejections
//   Undo      → toast "Connexion rejetée [Annuler]" pendant 10s

// Feedback Loop (k-anonymity ≥ 100 avant utilisation) :
//   Rejets agrégés par domaine → ajustement seuil cosine AUTO-GRAPH
//   "Dans le domaine 'ML', seuil optimal = 0.83 (vs 0.75 par défaut)"

// Panel "🤖 Connexions IA" :
//   Liste de toutes les connexions non validées, triées par confiance
//   Actions bulk : "Valider toutes >90%" / "Rejeter toutes <78%"
```

**Effort** : 7 jours (inclut D-SEC-001 + D-SEC-002) | **Phase** : Phase 1

---

### D-OPP-003 : Source-Linked Nodes (Provenance Tracée)

**Vision** : Clic sur n'importe quel nœud → voir exactement D'OÙ vient ce concept → naviguer au passage précis dans SCY-READER SUITE.

```typescript
// Modèle de provenance W3C PROV
interface NodeProvenance {
  concept_id: string;
  primary_sources: Array<{
    source_id: string;
    source_type: 'youtube' | 'pdf' | 'web' | 'manual' | 'ai_generated';
    display_label: string;           // "Deep Learning AI, 12min30s"
    extraction_confidence: number;
    chunk_ids: string[];
    position?: { page?: number; timestamp?: number; paragraph_id?: string };
    ingested_at: Date;
  }>;
  created_by: 'user' | 'neuron_chains' | 'auto_graph' | 'ingestion_pipeline';
}

// Badges source sur nœuds (zoom > 30%)
const SOURCE_BADGES = {
  youtube:      '🎥',  pdf: '📄',  web: '🌐',
  manual:       '✍️',  ai_generated: '🤖',
};
// Multiple sources → "🎥📄+2" (cumulatif)

// Navigation vers source : bouton dans Knowledge Card v2
// → Ouvre SCY-READER SUITE à la position exacte (page + paragraphe surligné)
// → Breadcrumb : [Reader Suite] ← [COSMOS > Gradient Descent]
// → Bouton flottant "← Retour au graphe" dans Reader Suite

// "Origine Mode" COSMOS (toggle) :
//   Colorer nœuds par type de source dominant
//   Légende auto + filtres rapides
//   Insight : "12 concepts n'ont qu'une seule source — Diversifier ?"

// Schéma BDD (nouvelle table) :
// CREATE TABLE scy_concept_provenance (
//   concept_id UUID, source_id UUID, source_type TEXT,
//   extraction_confidence REAL, chunk_ids UUID[],
//   position_page INT, position_timestamp INT, position_paragraph TEXT,
//   created_by TEXT, created_at INTEGER
// );
```

**Effort** : 5 jours | **Phase** : Phase 1

---

### D-OPP-004 : Prescriptive Graph Insights (Recommandations Actionnables)

**Vision** : Le graphe ne décrit plus seulement l'état des connaissances — il prescrit les actions suivantes, ancré directement dans la visualisation.

```typescript
// Engine Insights (règles Rust, $0 LLM)
interface PrescriptiveInsight {
  type: 'prereq_missing' | 'overdue_review' | 'cluster_weakness' | 'mastery_risk';
  severity: 'info' | 'warning' | 'critical';
  title: string;
  explanation: string;
  affected_nodes: string[];
  cta: { label: string; action: InsightAction; estimated_time: string };
}

function generateInsights(graph: GraphBackend, ctx: UserContext): PrescriptiveInsight[] {
  const insights: PrescriptiveInsight[] = [];

  // Règle 1 : Prérequis manquant (Gap Detection — petgraph, $0)
  const gaps = findMissingPrerequisites(graph);
  if (gaps.length > 0) insights.push({
    type: 'prereq_missing', severity: 'warning',
    title: `${gaps.length} prérequis manquants`,
    explanation: `Vous maîtrisez ${gaps[0].child} sans avoir ${gaps[0].missing}`,
    affected_nodes: gaps.map(g => g.missing),
    cta: { label: 'Combler cette lacune', action: { type: 'trigger_content_scout', gaps },
           estimated_time: '~30 min' },
  });

  // Règle 2 : Révisions en retard (FSRS, $0)
  const overdue = graph.nodes().filter(id => graph.getNodeAttributes(id).smi_state?.review_overdue);
  if (overdue.length > 0) insights.push({
    type: 'overdue_review',
    severity: overdue.length > 5 ? 'critical' : 'warning',
    title: `${overdue.length} révision${overdue.length > 1 ? 's' : ''} en retard`,
    explanation: 'Chaque jour d'attente réduit significativement la rétention',
    affected_nodes: overdue,
    cta: { label: 'Réviser maintenant', action: { type: 'open_apex_session', filter: overdue },
           estimated_time: `~${overdue.length * 2} min` },
  });

  // Règle 3 : Cluster faible (SMI moyen < seuil, $0)
  for (const cluster of findWeakClusters(graph, 50).slice(0, 2)) {
    insights.push({
      type: 'cluster_weakness', severity: 'info',
      title: `Cluster "${cluster.name}" à renforcer`,
      explanation: `SMI moyen = ${cluster.avg_smi}% — ${cluster.node_count} concepts à consolider`,
      affected_nodes: cluster.node_ids,
      cta: { label: 'Session de consolidation',
             action: { type: 'open_ascent_node', cluster_id: cluster.id },
             estimated_time: `~${cluster.node_count * 3} min` },
    });
  }

  return insights.slice(0, 3); // Max 3 (Miller's Law)
}

// Rendu : Panel flottant bas-gauche (ne couvre pas le graphe)
// Urgence : 'critical' → toast rouge pulsant 5s (attire attention)
// Dismiss : croix | "Ignorer 24h" | auto-dismiss après action réalisée
```

**Effort** : 6 jours | **Phase** : Phase 1

---

### D-OPP-005 : Reveal by Relevance (Graphe Contextuel Adaptatif)

**Vision** : Le graphe ne montre pas "ce qui est proche géographiquement" mais "ce qui est pertinent POUR VOUS MAINTENANT" — un graphe qui pense avec l'utilisateur.

```typescript
// Calcul de pertinence contextuelle (règles + scoring, $0 LLM)
interface RelevanceContext {
  current_ascent_node:     AscentNode;
  active_apex_session?:    ApexSession;
  recent_brain_queries:    BrainQuery[];
  recent_reader_sessions:  ReaderSession[];
  weak_concepts:           string[];   // SMI < 50%
  overdue_concepts:        string[];
}

function computeRelevantSubgraph(
  graph: GraphBackend,
  ctx: RelevanceContext,
  maxNodes: number = 150
): string[] {
  const seeds = new Set<string>([
    ...ctx.current_ascent_node.key_concepts,
    ...ctx.weak_concepts.slice(0, 5),
    ...ctx.overdue_concepts.slice(0, 3),
    ...ctx.recent_brain_queries.map(q => q.top_concept_id).filter(Boolean) as string[],
  ]);

  const expanded = expandHops(graph, Array.from(seeds), 2);

  return expanded
    .map(id => {
      const a = graph.getNodeAttributes(id);
      return {
        id,
        score:
          (seeds.has(id) ? 0.5 : 0) +
          ((1 - (a.smi_state?.global ?? 100) / 100) * 0.2) +
          ((a.pagerank_score ?? 0) * 0.15) +
          (a.smi_state?.review_overdue ? 0.15 : 0),
      };
    })
    .sort((a, b) => b.score - a.score)
    .slice(0, maxNodes)
    .map(e => e.id);
}

// Mode "🎯 Vue Pertinente" — toggle dans COSMOS controls
// ON : graphe filtré + label "Vue centrée sur : [Nœud ASCENT actuel]"
// OFF : vue complète standard (LOD géométrique normal)
// Mise à jour automatique : nœud ASCENT change → graphe reconfigure (max 1×/30s)
// Transition : useTransition() React 18 (smooth, sans flash)
```

**Effort** : 10 jours | **Phase** : Phase 2

---

## SECTION SEC-EXT — Sécurité & Confiance IA {#section-sec-ext}

> **Contexte** : Extensions de sécurité spécifiques à COSMOS, complémentaires aux patterns backend (D-VALIDATION-001→006). Focus sur la confiance IA et la protection des données utilisateur dans le graphe.

---

### D-SEC-001 : AI Confidence Scoring System

**Problème résolu** : G-02. AUTO-GRAPH crée des connexions (cosine > 0.75) sans indicateur visuel de fiabilité → sur-confiance utilisateur documentée (Emergent Mind 2025).

**Implémentation** : Voir D-OPP-002 pour le détail complet du scoring multi-signaux et du rendu visuel.

**Score multi-signaux** :
```
confidence = 0.45 × cosine_similarity
           + 0.30 × source_agreement
           + 0.15 × concept_maturity_normalized
           + 0.10 × domain_consistency_bonus
```

**Seuils d'affichage** : HIGH ≥ 88% (violet plein) | MEDIUM 80-88% (tireté) | LOW <80% (pointillé + ⚠️)
**Effort** : 3 jours | **Phase** : Sprint 0

---

### D-SEC-002 : Human-in-the-Loop Rejection System

**Problème résolu** : Les connexions IA sans mécanisme de rejet forcent une confiance aveugle.

```typescript
// Table BDD des rejets (feedback loop)
// CREATE TABLE scy_ai_rejections (
//   id UUID, edge_id UUID, source_concept TEXT, target_concept TEXT,
//   cosine_score REAL, reason TEXT, user_id UUID, rejected_at INTEGER
// );

// Keyboard shortcuts :
// V → valider connexion sélectionnée
// X → rejeter connexion sélectionnée
// Toast "Connexion rejetée [Annuler]" → 10s undo window

// Agrégation anonymisée (k ≥ 100) :
// → Ajustement seuil cosine par domaine (amélioration continue)
// → "Dans le domaine 'médecine', seuil optimal = 0.85"
```

**Effort** : 2 jours | **Phase** : Sprint 0 (bundlé avec D-SEC-001)

---

### D-SEC-003 : k-Anonymity Guard pour Heatmaps Agrégées

**Problème résolu** : Mode 16 (Heatmap Matricielle) peut révéler des données individuelles si count < k.

```typescript
export function renderPrivacyAwareHeatmap(
  data: HeatmapCell[],
  kThreshold: number = 100  // SCY Forge standard (vs k=3 RGPD minimum)
): HeatmapCell[] {
  return data.map(cell => cell.count < kThreshold
    ? { ...cell, value: null, display: `n < ${kThreshold}`, style: { fill: '#E5E7EB', hatching: true } }
    : cell
  );
}
// Zones supprimées affichées explicitement (hachures grises) → pas d'illusion de complétude
```

**Effort** : 1 jour | **Phase** : Phase 1 (Mode 16)

---

### D-SEC-004 : IndexedDB Layout Cache — Encrypted at Rest

**Problème résolu** : Cache layout en clair dans IndexedDB — accessible sur appareil partagé.

```typescript
// Clé de chiffrement : SubtleCrypto AES-GCM 256bits, dérivée PBKDF2
// Stockage clé : sessionStorage uniquement (perdue à la fermeture — intentionnel)
// Trade-off documenté : cache invalide au prochain login → recalcul layout
//   (acceptable vs risque exposition données sur appareil partagé)

export class EncryptedLayoutCacheManager extends LayoutCacheManager {
  private encryptionKey!: CryptoKey;

  async init(userId: string): Promise<void> {
    this.encryptionKey = await deriveKey(userId, getDeviceFingerprint());
    await super.init();
  }

  async set(key: string, value: LayoutCache): Promise<void> {
    const encrypted = await encryptAESGCM(this.encryptionKey, JSON.stringify(value));
    await super.set(key, encrypted as unknown as LayoutCache);
  }

  async get(key: string): Promise<LayoutCache | null> {
    const raw = await super.get(key);
    if (!raw) return null;
    const decrypted = await decryptAESGCM(this.encryptionKey, raw as unknown as ArrayBuffer);
    return JSON.parse(decrypted);
  }
}
```

**Effort** : 2 jours | **Phase** : Phase 2

---

### D-SEC-005 : Dual-Confidence Edge System — AI vs Human Validation 🔴 CRITIQUE

**Problème résolu** : L'utilisateur a besoin d'un outil d'apprentissage sérieux et concret pour valider des théories scientifiques et des concepts rigoureux. Les connexions générées par l'IA (AUTO-GRAPH) ne sont que des hypothèses. Sans distinction explicite entre le **score de confiance IA (calcul sémantique)** et le **score de validation Humaine (consensus individuel/communautaire)** sur les arêtes du graphe, l'utilisateur ne peut pas distinguer la conjecture sémantique de la vérité théorique validée.

**Solution** : Afficher un badge de double validation dynamique sur toutes les arêtes sémantiques (zoom > 35%).

```
          [ ARÊTE IA CONNECTÉE ]
                    │
                    ▼ (Sceau de double confiance visible zoom > 35%)
        ┌──────────────┬──────────────┐
        │  🤖 IA: 88%  │  👤 MOI: ✓   │  ◄── (Lien validé personnellement)
        └──────────────┴──────────────┘
        
        ┌──────────────┬──────────────┐
        │  🤖 IA: 72%  │  👥 CO: 94%  │  ◄── (Lien validé par 94% de la communauté)
        └──────────────┴──────────────┘
```

1. **La Dualité de Confiance (Dual-Scoring)** :
   * **Score IA ($S_{IA}$)** : Calculé par l'algorithme multi-signaux d'extraction (`D-SEC-001`).
   * **Score Humain ($S_{Humain}$)** : Statut binaire de validation personnelle de l'utilisateur (`✓ Validé par moi` ou `✗ Rejeté par moi`) ou, pour les cours publics partagés de la marketplace, le taux d'approbation cumulé par les pairs de la communauté (`👥 XX%`).

2. **Le Sceau de Consensus Théorique (Theory Validation Seal)** :
   * **Consensus Validé 🟢** : Si $S_{IA} \ge 85\%$ ET $S_{Humain} \ge 90\%$, l'arête acquiert une couleur violet-doré continue avec un halo lumineux permanent, prouvant à l'utilisateur qu'il s'agit d'une **véritable relation théorique validée**.
   * **Hypothèse à Vérifier 🟡** : Si $S_{IA} \ge 75\%$ mais $S_{Humain} = 0$ (en attente), l'arête apparaît striée en bleu, invitant l'apprenant à explorer la source pour statuer.
   * **Conflit Sémantique / Rejet 🔴** : Si le lien est rejeté personnellement ou si le consensus communautaire $S_{Humain} < 40\%$, l'arête est striée en rouge avec une icône d'avertissement `⚠️` indiquant un conflit théorique.

```typescript
interface EdgeConfidenceData {
  edge_id: string;
  ai_score: number;             // 0-100 (calculé)
  user_validation: 'PENDING' | 'VALIDATED' | 'REJECTED';
  community_approval_rate?: number; // 0-100 (marketplace)
}

export fn determine_edge_render_style(data: EdgeConfidenceData): EdgeStyle {
  if (data.user_validation === 'VALIDATED' || (data.user_validation === 'PENDING' && (data.community_approval_rate ?? 0) >= 90)) {
    if (data.ai_score >= 85) {
      return EdgeStyle::TheoryConsensusSeal { stroke_color: "#D97706", glow_intensity: 1.5 }; // Sceau Doré
    }
    return EdgeStyle::ValidatedConnection { stroke_color: "#10B981" }; // Vert
  }
  
  if (data.user_validation === 'REJECTED' || (data.community_approval_rate ?? 100) < 40) {
    return EdgeStyle::ConflictWarning { stroke_color: "#EF4444", striped: true, icon: "⚠️" };
  }
  
  return EdgeStyle::AiHypothesisPending { stroke_color: "#8B5CF6", dashed: true };
}
```

**Effort** : 4 jours | **Phase** : Sprint 0 (indispensable pour l'intégrité de la formation)

---

## SECTION DATA — Source de Vérité & Stockage (Étendue) {#section-data-ext}

> Les décisions D-DATA-001 à D-DATA-004 restent inchangées (voir version v3). Cette extension ajoute D-DATA-005 (OPFS) et D-DATA-006 (Event Sourcing côté client).

---

### D-DATA-005 : OPFS Persistence Layer (Upgrade IndexedDB)

**Problème résolu** : G-11. IndexedDB lent pour les gros binaires (100MB+ layouts). OPFS = ×4-10 plus rapide.

**Source** : RxDB benchmark — "OPFS reads up to 4× faster vs IndexedDB" + renderlog.in — "100MB write : OPFS 90ms vs IDB 850ms"

```typescript
// Architecture hybride : Metadata → IDB (structure), Binaires → OPFS (performance)
export class HybridPersistenceLayer {
  private opfsAvailable = false;

  async init(): Promise<void> {
    try {
      // OPFS : Chrome, Firefox, Edge 2023+. Safari : support limité (2025)
      const root = await navigator.storage.getDirectory();
      await root.getFileHandle('cosmos-probe.bin', { create: true });
      this.opfsAvailable = true;
      console.info('[Storage] OPFS ✅ — ×4-10 faster than IndexedDB');
    } catch {
      console.info('[Storage] OPFS unavailable — IndexedDB fallback');
    }
  }

  async saveLayout(key: string, layout: LayoutCache): Promise<void> {
    if (!this.opfsAvailable) return idbManager.set(key, layout);

    // Float32Array compact (positions) → OPFS Worker (zero-copy Transferable)
    const positions = new Float32Array(layout.lod1.flatMap(n => [n.x, n.y]));
    await opfsWorker.write(`layouts/${key}.bin`, positions.buffer, [positions.buffer]);

    // Métadonnées légères → IDB (rapide pour objets JS)
    await idbManager.set(`meta:${key}`, { ...layout, lod1: null });
  }
}

// opfs-worker.ts (séparé) : tous les I/O OPFS dans un Worker
// Pattern : kachurun/opfs-worker (npm) ou implémentation custom
// Zero-copy : postMessage(buffer, [buffer]) → Transferable ArrayBuffer
```

**Support navigateurs** : Chrome 86+, Firefox 111+, Edge 86+ (pas Safari complet)
**Fallback** : IndexedDB (D-DATA-002 existant) — transparent pour l'utilisateur
**Effort** : 5 jours | **Phase** : Phase 2

---

### D-DATA-006 : Client-Side Event Sourcing du Graphe (Time-Travel)

**Problème résolu** : Aucun historique des modifications côté client → impossible de "remonter" l'état du graphe sans requête serveur.

```typescript
// Event Log côté client — compatible avec Temporal Queries serveur (D-007 PRD)
interface CosmosGraphEvent {
  id: string; timestamp: Date; source: 'user' | 'ai' | 'ingestion';
  type: 'node_added' | 'edge_created' | 'edge_rejected' | 'node_deleted' |
        'ai_link_created' | 'ai_link_rejected' | 'smi_updated';
  payload: unknown;
}

class CosmosGraphHistory {
  private events: CosmosGraphEvent[] = [];
  private snapshots = new Map<number, GraphState>(); // Snapshot toutes les 50 events

  apply(event: CosmosGraphEvent): void {
    this.events.push(event);
    if (this.events.length % 50 === 0)
      this.snapshots.set(this.events.length, deepClone(this.currentState));
  }

  rewindTo(timestamp: Date): GraphState {
    const before = this.events.filter(e => e.timestamp <= timestamp);
    const snapIdx = Math.floor(before.length / 50) * 50;
    let state = this.snapshots.get(snapIdx) ?? initialState;
    for (const ev of before.slice(snapIdx)) state = this.reducer(state, ev);
    return state;
  }
}

// UX : History Animation COSMOS (D-UX.4.3bis du PRD)
// Slider temporel → rewindTo(selectedDate) → graphe reconstitué côté client
// Sans requête serveur (performances instantanées pour les 30 derniers jours)
```

**Effort** : 4 jours | **Phase** : Phase 2

---

## SECTION PERF — Performance & Level of Detail (Étendue) {#section-perf-ext}

> Les décisions D-PERF-001 à D-PERF-005 restent inchangées. Cette extension ajoute D-PERF-006 (WebGPU) et D-PERF-007 (Persistent GPU Buffers).

---

### D-PERF-006 : WebGPU Upgrade Path — Roadmap Migration

**Problème résolu** : G-07. WebGL2 (Cosmos actuel) limité à ~1M nœuds. WebGPU offre ×15 performance, compute shaders pour ForceAtlas2 GPU (45s → ~5s), et 5M+ nœuds potentiels.

**Source** : GraphWaGu NSF — "First WebGPU-based graph visualization" | GraphGPU GitHub (Mars 2026) — "GPU compute force layout 5-pass pipeline" | byteiota.com — "70% browser support 2026, ×15 performance gains"

```typescript
// Progressive Enhancement : WebGPU → WebGL2 → G6 Canvas
async function initBestRenderer(canvas: HTMLCanvasElement): Promise<RendererInterface> {
  // Tier 1 : WebGPU (70% support 2026)
  if (navigator.gpu) {
    const adapter = await navigator.gpu.requestAdapter({ powerPreference: 'high-performance' });
    if (adapter) {
      const device = await adapter.requestDevice();
      return new WebGPUGraphRenderer(canvas, device);  // ×15 perf
    }
  }

  // Tier 2 : WebGL2 Cosmos (actuel — fallback)
  if (canvas.getContext('webgl2')) return new CosmosRenderer(canvas);

  // Tier 3 : G6 Canvas
  return new G6CanvasRenderer(canvas);
}

// ForceAtlas2 sur GPU via WGSL Compute Shader
// Source : GraphWaGu NSF + drkameleon/GraphGPU (Mars 2026)
const FA2_COMPUTE_WGSL = /* wgsl */`
  struct Node { x: f32, y: f32, vx: f32, vy: f32, mass: f32, degree: u32 };
  @group(0) @binding(0) var<storage, read_write> nodes: array<Node>;
  @group(0) @binding(2) var<uniform> params: PhysicsParams;

  @compute @workgroup_size(256)
  fn main(@builtin(global_invocation_id) gid: vec3<u32>) {
    let i = gid.x;
    if (i >= params.node_count) { return; }
    var fx: f32 = 0.0; var fy: f32 = 0.0;
    for (var j: u32 = 0u; j < params.node_count; j++) {
      if (i == j) { continue; }
      let dx = nodes[i].x - nodes[j].x; let dy = nodes[i].y - nodes[j].y;
      let dist = max(sqrt(dx*dx + dy*dy), 0.001);
      let rep = params.scaling_ratio * nodes[i].mass * nodes[j].mass / dist;
      fx += rep * dx / dist; fy += rep * dy / dist;
    }
    nodes[i].vx = (nodes[i].vx + fx / nodes[i].mass) * 0.85;
    nodes[i].vy = (nodes[i].vy + fy / nodes[i].mass) * 0.85;
    nodes[i].x += nodes[i].vx; nodes[i].y += nodes[i].vy;
  }
`;

// Migration Three.js Mode 23 → WebGPU : 2 lignes (Three.js r171+)
// import * as THREE from 'three/webgpu';
// const renderer = new THREE.WebGPURenderer(); // Fallback WebGL2 auto

// Performances attendues (benchmarks GPU ForceAtlas2) :
// CPU Worker (actuel)  : 50K nœuds = ~45s, 1M nœuds = non viable
// GPU WebGL2 Cosmos    : 50K nœuds = ~8s,  1M nœuds = 60fps rendu (layout long)
// GPU WebGPU Compute   : 50K nœuds = ~2s,  1M nœuds = ~15-20s layout + 60fps
// Speedup ForceAtlas2  : ×40-123 vs CPU (source : Brinkmann et al. 2017)
```

**Feuille de route** :
- T0+12 mois : Mode 23 (3D) migre WebGPU via Three.js r171+ (2 lignes)
- T0+15 mois : ForceAtlas2 WGSL compute shader (GPUForceLayout.ts)
- T0+18 mois : Remplacement partiel Cosmos par WebGPU renderer custom

**Effort** : 20 jours | **Phase** : Phase 3 R&D

---

### D-PERF-007 : Persistent GPU Buffers (No Re-upload on Pan/Zoom)

**Problème résolu** : Re-upload des données GPU à chaque frame pendant pan/zoom — gaspillage de bande passante CPU→GPU.

**Source** : Scott Logic blog — "By moving the scaling logic into the GL shaders, these operations can be handled entirely by the GPU, giving super-smooth interactions."

```typescript
// Pattern : equals() check avant re-upload GPU
// Si les données n'ont pas changé (pan/zoom uniquement) → skip l'upload

// Pour Cosmos : ne PAS appeler setPointPositions() pendant pan/zoom
//   Seulement lors d'ingestion ou de mise à jour layout
let lastPositionsRef: Float32Array | null = null;

function updateCosmosIfNeeded(newPositions: Float32Array): void {
  if (lastPositionsRef === newPositions) return;  // Référence identique = skip
  cosmosGraph.setPointPositions(newPositions);
  lastPositionsRef = newPositions;
}

// Pour WebGL/WebGPU : uniforms pour zoom/pan (pas de re-upload géométrie)
// Le shader reçoit viewMatrix comme uniform → scaling purement GPU
// Résultat : pan/zoom à 0.01ms/frame vs 1.2ms/frame (×120 plus rapide)
// Source : digitaladblog.com Canvas vs WebGL benchmark 2026
```

**Effort** : 2 jours | **Phase** : Phase 1 (impact immédiat performance pan/zoom)

---

## Règles d'Or MGVS — 17 Invariants {#regles-mgvs}

**Sources fusionnées** : MGVS PARTIE 7, COSMOS Règles 1-8, COSMOS Solutions v4 (Règles 13-17)

Ces règles s'appliquent à tout le système de visualisation. Une violation est un bug d'architecture.

| # | Règle | Raison |
|---|-------|--------|
| **1** | Graphology = source de vérité. Jamais de données graphe directement dans G6 ou Cosmos sans passer par Graphology. | Cohérence garantie |
| **2** | G6 ne voit jamais plus de 30K nœuds simultanément. 26 modes = 1 jeu de données converti pour chaque renderer. Le MGVS filtre en amont. Toujours. | Performance garantie |
| **3** | Layout = calculé UNE FOIS, mis en cache (IndexedDB ou OPFS selon disponibilité). Jamais recalculé au chargement si cache valide. | TTI ~0ms |
| **4** | Tous les layouts tournent en Web Worker. Zéro calcul de layout sur le main thread. | UI jamais bloquée |
| **5** | Cosmograph = optionnel, conditionnel au GPU. Son absence ne dégrade jamais l'expérience core. WebGPU = tier supérieur optionnel (Phase 3). | Universalité |
| **6** | Le R-Tree est construit depuis le cache layout. Il répond en < 1ms quelle que soit la taille du graphe. | Culling performant |
| **7** | LOD 0 = clusters seulement. Jamais de nœuds individuels à LOD 0 (même sur HIGH sans Cosmos). | Lisibilité macro |
| **8** | Drill-down depuis Cosmograph → G6 Radial. Adaptateur `graphologyToG6Radial()` obligatoire. | Transition fluide |
| **9** | Messages UX humains pour chaque tier. Jamais d'erreur cryptique visible à l'utilisateur. | Confiance utilisateur |
| **10** | G6 SVG = fallback uniquement (vieux appareils). Limite automatique à 2K nœuds en SVG. | Compatibilité |
| **11** | Coût serveur = 0€. Toute logique MGVS est 100% client-side (IndexedDB/OPFS, Workers, R-Tree, Graphology). | Scalabilité économique |
| **12** | `useTransition()` pour tous les changements de mode. Jamais de freeze UI lors d'un switch LOD ou mode. | Fluidité perçue |
| **13** | **[NOUVEAU v4]** Toute connexion auto-générée (AUTO-GRAPH) DOIT afficher son score de confiance. Jamais de connexion IA sans badge distinctif. | Confiance utilisateur IA |
| **14** | **[NOUVEAU v4]** Tout nœud DOIT avoir au moins une entrée dans `scy_concept_provenance`. Jamais de concept sans source traçable. | Intégrité des données |
| **15** | **[NOUVEAU v4]** Canvas HiDPI : `devicePixelRatio` appliqué SYSTÉMATIQUEMENT à l'initialisation. Jamais de canvas sans correction DPI. | Netteté visuelle |
| **16** | **[NOUVEAU v4]** Font Stack universel (Inter + Noto CJK + Emoji) appliqué GLOBALEMENT dans `G6_GLOBAL_LABEL_CFG`. Jamais de `fontFamily` hardcodée par composant. | Support Unicode complet |
| **17** | **[NOUVEAU v4]** GPU buffers JAMAIS re-uploadés pendant pan/zoom. Seuls les uniforms (viewMatrix) changent. Toujours vérifier l'égalité de référence avant `setPointPositions()`. | Performance GPU optimale |

---

## Checklist Production — 26 Modes + Solutions v4 {#checklist}

**Sources fusionnées** : COSMOS Checklist, MGVS validations, COSMOS Solutions v4

Avant tout merge en production :

### Rendu & GPU (26 modes)
- [ ] **D-RENDER-001** : 5 moteurs de rendu distincts, pas d'interchangeabilité (Cosmos, G6, G2, React Flow, nivo, d3, recharts)
- [ ] **D-RENDER-002** : Détection device tier unique au démarrage (HIGH/MID/LOW/COMPAT)
- [ ] **D-RENDER-003** : Cosmos.gl v3 asynchrone (`await graph.ready` avant toute méthode)
- [ ] **D-RENDER-004** : React Flow limité aux DAGs (Roadmap, DataFlow, Argument Map) — max 1000 nœuds
- [ ] **D-RENDER-005** : Lazy-loading systématique par mode (25 chunks indépendants)
- [ ] **D-RENDER-006** : @antv/g2 v5 lazy-loadé uniquement si Modes 10/11/16/19 visités (~180KB)
- [ ] **D-RENDER-007** : nivo lazy-loadé uniquement si Modes 12/13/16/19 visités (~120KB)
- [ ] **D-RENDER-008** : d3 v7 lazy-loadé uniquement si Modes 15/20/21/24 visités (~80KB)
- [ ] **D-RENDER-009** : three.js lazy-loadé uniquement si Mode 23 + GPU check OK (~450KB)
- [ ] GPU detection : `OES_texture_float` requis pour Cosmos et three.js
- [ ] Fallback messages UX par tier (jamais d'erreur technique)

### Nouveaux Modes v3
- [ ] **Mode 9 — Concept Map** : liaisons croisées étiquetées, multi-parents, ForceAtlas2
- [ ] **Mode 10 — Sunburst** : drill-down, breadcrumb, 6 niveaux max
- [ ] **Mode 11 — Treemap** : Squarify, drill-down, labels adaptatifs
- [ ] **Mode 14 — Radar** : 3-12 axes, superposition profils, intégration SMI 5 dimensions
- [ ] **Mode 13 — Sankey/Alluvial** : flux pondérés, filtrage seuil, double mode
- [ ] **Mode 22 — Semantic Zoom** : 3 couches LOD, halo visualization, mental map préservé
- [ ] **Mode Auto-Suggest** : Agent-03 suggère mode optimal selon données + préférences + objectif
- [ ] `detectRenderProfile()` exécuté au démarrage, résultat mémoïsé
- [ ] `OES_texture_float` vérifié avant tout init Cosmos
- [ ] `await graph.ready` présent avant tout appel Cosmos
- [ ] Message UX explicite si GPU incompatible
- [ ] `prefers-reduced-motion` respecté

### Données & Cache
- [ ] `graphologyToCosmos()` avec tests unitaires (10K, 50K nœuds)
- [ ] IndexedDB layout-cache versionné et invalidé à chaque ingestion
- [ ] DuckDB-WASM initialisé au bootstrap (`KnowledgeBaseSQL.init()`)
- [ ] Louvain/PageRank calculés une fois, réutilisés

### Performance
- [ ] Modes lazy-loadés, bundle initial < 250KB
- [ ] `useTransition()` sur tous les changements de mode
- [ ] LOD Engine filtrant avant G6 (jamais > 30K nœuds dans G6)
- [ ] Layouts en Web Worker (jamais sur main thread)
- [ ] R-Tree construit depuis cache (réponse < 1ms)

### UX
- [ ] `useProjectGraphStore` ≠ `useKnowledgeBaseStore` (stores séparés)
- [ ] Presets de vues sauvegardables (localStorage)
- [ ] Exploration Trail implémenté (D-UX-007)
- [ ] Graph Insights Panel (hubs, ponts, orphelins, îlots)
- [ ] Scope Revelation à l'ouverture (aperçu auto-généré)
- [ ] Human-in-the-loop pour toutes les actions IA

### Qualité Visuelle & Rendu (v4 — Sprint 0)
- [ ] **D-QUAL-001** : HiDPI Canvas — `devicePixelRatio` appliqué à l'init G6 + Cosmos + Canvas2D
- [ ] **D-QUAL-001** : ResizeObserver actif sur canvas COSMOS (pas de resize sans mise à jour DPI)
- [ ] **D-QUAL-002** : Font Stack universel (Inter Variable + Noto Sans SC/JP/KR + Noto Color Emoji) dans `G6_GLOBAL_LABEL_CFG`
- [ ] **D-QUAL-002** : Preload fonts critiques dans index.html (inter-variable.woff2, noto-sans-sc-regular.woff2)
- [ ] **D-QUAL-002** : `truncateLabelCJKAware()` utilisé partout (Intl.Segmenter, pas `slice()`)
- [ ] **D-QUAL-003** : AdaptativeQualitySystem actif sur LOW/COMPAT tier (mesure FPS fenêtre 30 frames)

### Validation & Audit des Visuels (v4 — Phase 1)
- [ ] **D-SEC-006** : Intégration de l'**AGENT-12 (VISUAL-CRITIC)** — validation asynchrone petgraph (0 cycle) avant affichage.
- [ ] **D-SEC-007** : Intégration de l'**AGENT-13 (COGNITIVE-VALIDATOR)** — limitation dynamique de nœuds par tier d'expertise (Loi de Sweller).

### Confiance IA & Sécurité (v4 — Sprint 0 + Phase 1)
- [ ] **D-SEC-001** : Toute arête `auto_generated=true` a un `confidence` score calculé (multi-signaux)
- [ ] **D-SEC-001** : Badge "🤖 XX%" visible sur arêtes IA (zoom > 20%)
- [ ] **D-SEC-001** : Styles visuels distincts par niveau (HIGH plein / MEDIUM tireté / LOW pointillé)
- [ ] **D-SEC-002** : Raccourcis V (valider) / X (rejeter) actifs sur connexion sélectionnée
- [ ] **D-SEC-002** : Toast "Connexion rejetée [Annuler]" avec undo 10s
- [ ] **D-SEC-002** : Rejets persistés dans `scy_ai_rejections` (feedback loop)
- [ ] **D-SEC-003** : Mode 16 Heatmap : k-anonymity guard actif (k ≥ 100)
- [ ] **D-SEC-004** : EncryptedLayoutCacheManager utilisé si appareil partagé détecté (Phase 2)

### Sémantique & Interactivité (v4 — Sprint 0 + Phase 1)
- [ ] **D-UX-006** : `EDGE_SEMANTIC_STYLES` dict complet (7 types) appliqué dans tous les modes graphe
- [ ] **D-UX-006** : Légende auto-générée (uniquement types présents dans le graphe courant)
- [ ] **D-UX-001** : Plugin Fisheye G6 v5 configuré (trigger:drag, wheel:radius) + raccourci F
- [ ] **D-UX-002** : Progressive Rendering 4 phases actif (skeleton → clusters → hubs → nodes)
- [ ] **D-UX-003** : Knowledge Cards v2 — déclenchement clic, SMI intégré, provenance, actions
- [ ] **D-UX-004** : Persona Adaptive Interface — 3 modes (discoverer/analyst/explorer) + détection auto
- [ ] **D-UX-005** : BehavioralDisclosureEngine — hover 1.5s→badges, hover 3s→Knowledge Card
- [ ] **D-UX-007** : Exploration Trail — barre 32px en bas, 10 étapes max, Ctrl+Z navigation
- [ ] **D-UX-011** : Gap Detection — nœuds manquants en pointillés rouges + CTA CONTENT-SCOUT

### Opportunités Différenciation (v4 — Phase 1)
- [ ] **D-OPP-001** : SMI Learning Graph — couleur + badge + aura nœuds, sync EventBus post-APEX
- [ ] **D-OPP-002** : Transparent AI Graph — validation flow complet (pending→validated/rejected)
- [ ] **D-OPP-003** : Source-Linked Nodes — badges source + navigation Reader Suite position exacte
- [ ] **D-OPP-004** : Prescriptive Insights — panel 3 insights max, règles Rust, $0 LLM
- [ ] **D-OPP-005** : Reveal by Relevance — toggle "🎯 Vue Pertinente", recalcul max 1×/30s (Phase 2)

### Persistence Avancée (v4 — Phase 2)
- [ ] **D-DATA-005** : HybridPersistenceLayer — OPFS si disponible, IDB fallback, transparent user
- [ ] **D-DATA-006** : CosmosGraphHistory — Event log + snapshots/50 + rewindTo() pour History Animation
- [ ] **D-UX-012** : TabLeaderElection + BroadcastChannel actif (sync cross-tab)

### Performance GPU Avancée (v4 — Phase 1 + Phase 3)
- [ ] **D-PERF-007** : Persistent GPU Buffers — `equals()` check avant `setPointPositions()` (pan/zoom)
- [ ] **D-PERF-006** : WebGPU feature detection au démarrage (navigator.gpu) — Phase 3
- [ ] **D-PERF-006** : Three.js Mode 23 migré `three/webgpu` + `WebGPURenderer()` — Phase 3

### Accessibilité
- [ ] Lighthouse > 90, axe-core 0 violations
- [ ] Keyboard navigation (Tab, Arrow, Enter, Escape)
- [ ] Équivalents clavier pour tous les tooltips-only
- [ ] NVDA/VoiceOver manual testing

### Mobile
- [ ] Touch gestures (pinch, pan, long press, two-finger) testés iOS/Android réels
- [ ] Layout radial par défaut sur mobile (MindMap)
- [ ] Bottom navigation implémentée
- [ ] Graphe dense désactivé sur smartphone (Library-first)

---

## Bibliothèques Finales Validées — COSMOS v4 (26 Modes + Solutions)

**Stack MGVS v2.0 complète** :

**Nouvelles dépendances v4** :

| Rôle | Bibliothèque | Version | Phase |
|------|-------------|---------|-------|
| Fonts CJK + Emoji | Noto Sans SC/JP/KR + Noto Color Emoji | latest (Google Fonts) | Sprint 0 |
| Fonts Latin Variable | Inter Variable | latest (Google Fonts) | Sprint 0 |
| OPFS Worker | opfs-worker (kachurun) ou custom | latest | Phase 2 |
| Web Locks API | Natif navigateur | — | Phase 2 |
| BroadcastChannel | Natif navigateur | — | Phase 2 |
| WebGPU | Natif navigateur (70% 2026) | — | Phase 3 |

**Stack MGVS v1.0 complète** :

| Rôle | Bibliothèque | Version |
|------|--------------|---------|
| Source de vérité graphes projet | graphology | 0.25.x |
| Renderer principal | @antv/g6 Canvas | 5.x |
| Renderer GPU conditionnel | @cosmograph/cosmos + @cosmograph/react | 3.x |
| Renderer fallback | @antv/g6 SVG (@antv/g-svg) | 5.x |
| Spatial index | rbush (R-Tree) | 3.x (7KB) |
| Stockage local | IndexedDB (natif navigateur) | — |
| Layouts async | @antv/layout + WASM | latest |
| Algorithmes graphe | graphology-communities-louvain, graphology-metrics | 2.x |
| DAGs / Flows | @xyflow/react | 12.x |
| SQL analytique | @duckdb/duckdb-wasm | latest |
| Charts | recharts | 2.x |
| State global | zustand + subscribeWithSelector | 4.5 |
| Transitions | React `useTransition()` (React 18 natif) | 18.3 |

---

---

## SECTION PREMORTEM — Prevention Plan & Launch Readiness {#section-premortem}

### Contexte : Scénario d'Échec (Janvier 2027)

**Sources fusionnées** : Pre-mortem Analysis (élicitation avancée), Failure scenario reverse engineering

**Hypothèse** : Nous sommes en Janvier 2027, 1 an après le lancement COSMOS. Le projet a échoué avec :
- MAU : 2,400 → 180 (-92% churn)
- NPS : -42 (80% détracteurs)
- App Store : 2.1★ moyenne
- Support tickets : 450/semaine (3× capacité)
- Engineering velocity : 2 SP/sprint (vs 20 target)

**10 échecs catastrophiques identifiés** via reverse engineering depuis ce scénario futur. Cette section documente le **plan de prévention** pour éviter ce destin.

---

### D-PREMORTEM-001 : Top 10 Failure Modes & Prevention

**Principe** : Chaque mode d'échec identifié dans le pre-mortem DOIT avoir une action de prévention spécifique, un owner, et un deadline avant lancement.

| # | Mode d'Échec | Impact Utilisateurs | Cause Racine | Action Prévention | Effort | Priorité |
|---|--------------|---------------------|--------------|-------------------|--------|----------|
| **1** | **WebGL Context Loss** | 50% Android → canvas noir permanent | Pas de recovery handler | Implémenter `webglcontextlost` listener + auto-reinit | 2j | **P0** |
| **2** | **IndexedDB Quota Hell** | 15% power users → 30s load chaque fois | Quota 50MB silencieux, pas de LRU | Implémenter quota check + LRU eviction | 2j | **P0** |
| **3** | **G6 Memory Leak** | Sessions > 1h → RAM +500MB, tab crash | Event listeners jamais `off()` | Implémenter cleanup hooks React | 1j | **P0** |
| **4** | **Empty Graph Crash** | 100% nouveaux users → crash onboarding | Pas de EmptyState pour 0 nœuds | Implémenter EmptyState component | 0.5j | **P0** |
| **5** | **Private Mode Cache Loss** | 10-15% users → layouts perdus au refresh | Pas de warning UI clair | Implémenter banner "Mode privé détecté" | 0.5j | **P0** |
| **6** | **DuckDB Query Freeze** | Feature Stats → tab freeze 15s | Pas de timeout, pas de Worker | Implémenter timeout 5s + Worker offload | 2j | **P0** |
| **7** | **Developer Tech Debt** | Velocity 20 → 2 SP/sprint en 6 mois | APIs hardcodées, pas d'abstractions | Implémenter RendererInterface + GraphBackend | 5j | **P0** |
| **8** | **Tier Detection Silent** | 40% users MID/LOW → pense "bug" pas "device" | Pas de messages UX tier | Implémenter messages tier explicites | 1j | **P1** |
| **9** | **Label Overflow UI** | Labels longs/CJK → layout cassé | Pas de truncation + font fallback | Implémenter truncation + tooltip + fonts | 2j | **P1** |
| **10** | **Data Corruption Cascade** | Users perdent graphes entiers | Zéro validation runtime | Implémenter 3 validation layers | 3j | **P0** |

**Total effort prévention** : ~19 jours

---

### D-PREMORTEM-002 : Non-Negotiable P0 Checklist (Pre-Launch)

**Principe** : Ces actions DOIVENT être complétées AVANT tout lancement production. Aucune exception, aucun "on fera après".

#### **Phase 1 : Stabilité Critique (M-3 mois)**

- [ ] **WebGL Context Loss Recovery** (2j)
  - Implémenter `webglcontextlost` + `webglcontextrestored` listeners
  - Auto-reinit CosmosGraph avec fallback G6 après 3 tentatives
  - Test manuel : backgrounder app 10min sur Android → vérifier recovery
  - **Critère succès** : 0 crash "black screen" sur 100 tests Android mid-range

- [ ] **EmptyState Component** (0.5j)
  - Design + implémentation EmptyState pour graph.order === 0
  - Message : "Aucun concept à visualiser. Commencez par ingérer du contenu."
  - CTA button vers Ingestion view
  - **Critère succès** : Nouveaux users voient EmptyState, pas crash

- [ ] **G6 Event Listeners Cleanup** (1j)
  - Hook React `useG6Graph` avec cleanup `off()` dans return
  - Audit tous les `graph.on()` existants → ajouter `off()`
  - Test : 50 switches mode → vérifier heap stable < 100MB delta
  - **Critère succès** : Chrome DevTools heap profiling flat après 50 switches

#### **Phase 2 : Validation & Résilience (M-2 mois)**

- [ ] **3 Validation Layers** (3j)
  - Layer 1 : `sanitizeNodeData()` + `sanitizeEdgeData()` avec NaN/Infinity checks
  - Layer 2 : `validateGraphIntegrity()` avec empty/dense/orphan checks
  - Layer 3 : `guardRender()` avec viewport/tier/ready checks
  - **Critère succès** : Tests unitaires 100% coverage edge cases P0/P1

- [ ] **IndexedDB Quota Management** (2j)
  - Implémenter quota check avant write (navigator.storage.estimate())
  - LRU eviction si quota > 80% (supprimer vieux caches)
  - Fallback in-memory si quota exceeded
  - **Critère succès** : 20K nœuds × 5 projets = pas de quota error

- [ ] **DuckDB Timeout + Worker** (2j)
  - Wrapper toutes queries avec `withCircuitBreaker(timeout: 5000)`
  - Offload DuckDB init + queries dans Web Worker dédié
  - Progress indicator pendant queries > 1s
  - **Critère succès** : Full scan 500K rows = pas de freeze UI

- [ ] **UI Warnings Explicites** (1j)
  - Tier detection → message "📱 Mode économique activé" (MID/LOW)
  - Private mode détecté → banner "🔒 Layouts non persistés (mode privé)"
  - Quota proche → warning "💾 Espace limité, anciens caches seront supprimés"
  - **Critère succès** : Users comprennent limitations, pas de surprise

#### **Phase 3 : Architecture Long-Terme (M-2 mois)**

- [ ] **RendererInterface Abstraction** (3j)
  - Interface commune : `init()`, `setData()`, `render()`, `on()`, `destroy()`
  - Implémentations : CosmosRenderer, G6Renderer
  - Refactor composants pour utiliser interface, pas APIs directes
  - **Critère succès** : Peut swap renderer avec 1 ligne config change

- [ ] **GraphBackend Wrapper** (2j)
  - Interface commune : `addNode()`, `addEdge()`, `forEachNode()`, etc.
  - Implémentation : GraphologyBackend (actuelle)
  - Placeholder : WasmGraphBackend (future)
  - **Critère succès** : Peut A/B test backend avec feature flag

- [ ] **Circuit Breaker Config Centralisée** (1j)
  - Fichier `circuit-breaker.config.ts` avec tous timeouts documentés
  - Helper `createCircuitBreaker(key, name)` avec config auto
  - Documentation inline : P95, justification, historique
  - **Critère succès** : Zéro timeout hardcodé dans codebase

---

### D-PREMORTEM-003 : Testing Checklist Edge Cases

**Principe** : "We tested happy path only" était un meta-failure. Tous les edge cases P0/P1 doivent être testés AVANT lancement.

#### **Tests Automatisés (Unit + Integration)**

```typescript
// Test suite minimale requise
describe('COSMOS Pre-Launch Critical Tests', () => {
  describe('P0 Edge Cases', () => {
    it('Empty graph (0 nodes) → EmptyState, no crash', () => { /* ... */ });
    it('Position NaN → filtered out, no GPU propagation', () => { /* ... */ });
    it('Label null → fallback to ID', () => { /* ... */ });
    it('Graph no edges → circular layout, no infinite loop', () => { /* ... */ });
    it('Edge orphan source → skipped, warning logged', () => { /* ... */ });
    it('IndexedDB quota exceeded → LRU eviction triggered', () => { /* ... */ });
    it('DuckDB query > 5s → timeout, partial results', () => { /* ... */ });
    it('G6 listeners cleanup → heap stable after 50 switches', () => { /* ... */ });
  });
  
  describe('P1 Edge Cases', () => {
    it('Label > 100 chars → truncated + ellipsis', () => { /* ... */ });
    it('Graphe dense (10× edges/node) → blocked + message', () => { /* ... */ });
    it('Viewport 0×0 → skip render, wait resize', () => { /* ... */ });
    it('Tier MID with 40K nodes → blocked + filter prompt', () => { /* ... */ });
  });
});
```

**Coverage cible** : 100% edge cases P0, 80% edge cases P1.

---

#### **Tests Manuels (Devices Réels)**

| Scénario | Device | Expected Behavior | Pass/Fail |
|----------|--------|-------------------|-----------|
| **Fresh install, nouveau projet** | iPhone 12, Pixel 5 | EmptyState affiché, CTA vers Ingestion | [ ] |
| **Graphe 20K nœuds** | iPhone 12, Pixel 5 | Load < 3s (cache hit), FPS > 30 | [ ] |
| **Graphe 50K nœuds** | iPhone 12 (HIGH) | Cosmos activé, 60 FPS | [ ] |
| **Graphe 50K nœuds** | Pixel 5 (MID) | Message "Filtrer pour réduire", limite 30K | [ ] |
| **Private browsing** | Chrome incognito | Banner "Layouts non persistés" visible | [ ] |
| **App background 10min** | Pixel 5 | WebGL recovery au retour, pas canvas noir | [ ] |
| **Query "Top concepts"** | Tous | Résultats < 5s, pas freeze UI | [ ] |
| **Session 2h continuous** | Tous | RAM stable < 300MB, pas slowdown | [ ] |
| **Labels CJK + emoji** | Tous | Rendu correct, font fallback OK | [ ] |
| **Zoom 0% et 100%** | Tous | LOD transitions fluides, pas artefacts | [ ] |

**Critère acceptation** : 100% Pass sur tous devices avant lancement.

---

### D-PREMORTEM-004 : Monitoring Dashboard Production

**Principe** : "We had no visibility" était une cause récurrente. Dashboard monitoring DOIT être opérationnel M-1 (avant lancement).

#### **Metrics Critiques à Monitorer**

| Metric | Source | Alerte Trigger | Action si Alerte |
|--------|--------|----------------|------------------|
| **Crash Rate (Android)** | Sentry | > 2% sessions | Investigation WebGL/GPU immédiate |
| **Cache Hit Rate** | Custom analytics | < 70% | Investigation quota/corruption |
| **P95 Load Time** | Custom analytics | > 5s | Investigation layout/cache |
| **Memory Leak Detection** | Sentry heap growth | +200MB/hour | Investigation listeners/cleanup |
| **DuckDB Query Timeout** | Sentry | > 10/jour | Optimisation queries ou index |
| **Validation Failures** | Sentry | > 5% nodes | Investigation data quality |
| **GPU Usage %** | Custom analytics | < 20% | ROI Cosmos reconsidéré |
| **Tier Distribution** | Custom analytics | Évolution tendance | Adapter stratégie renderers |

**Dashboard Sentry Custom** :
- Saved query : "Top 10 Crash Causes" (daily review)
- Saved query : "Validation Failures by Type" (weekly review)
- Saved query : "Circuit Breaker Timeouts" (weekly review)
- Alert : Email si crash rate > 2% (immediate)

---

### D-PREMORTEM-005 : Meta-Failures Prevention

**Principe** : Les 3 meta-failures identifiés doivent avoir des **process changes** pour éviter répétition.

#### **Meta-Failure A : "We Knew But Didn't Prioritize"**

**Symptôme** : Tech debt tickets créés mais jamais sprintés. "On fera après launch" → never happens.

**Prevention** :
- **Règle d'Or** : 20% de chaque sprint = tech debt / resilience (non-négociable)
- **Definition of Done** : Feature includes resilience (validation, error handling, edge cases)
- **Pre-Launch Gate** : P0 checklist 100% complétée → sinon NO LAUNCH

**Owner** : Product Manager (enforce 20% rule)

---

#### **Meta-Failure B : "We Tested Happy Path Only"**

**Symptôme** : Tests avec 1K-5K nœuds, labels courts, devices HIGH tier. Edge cases dismissed as "rare".

**Prevention** :
- **Test Pyramid Shift** : 30% unit (edge cases), 40% integration (realistic data), 30% E2E (real devices)
- **Realistic Test Data** : Seeds avec 0 nœuds, 50K nœuds, labels 200 chars, CJK, null values
- **Device Lab** : 5 devices réels (2× HIGH, 2× MID, 1× LOW) pour testing pre-release

**Owner** : QA Lead (enforce test coverage gates)

---

#### **Meta-Failure C : "We Skipped Abstractions for Speed"**

**Symptôme** : RendererInterface, GraphBackend designed mais pas implémentés. "Refactor after launch" → never happens.

**Prevention** :
- **Architecture Review** : Toute feature touchant Cosmos/G6/Graphology → review abstractions
- **Refactor Sprint** : Chaque 6 sprints = 1 sprint dédié refactoring (planifié)
- **Tech Debt Budget** : 15% engineering time = paying down debt (tracked)

**Owner** : Tech Lead (enforce architecture reviews)

---

### D-PREMORTEM-006 : Launch Readiness Criteria

**Principe** : Critères objectifs GO/NO-GO pour lancement production. Si UN critère fail → NO LAUNCH.

#### **Critères Techniques**

- [ ] **P0 Checklist** : 100% actions complétées (13 items, ~19j effort)
- [ ] **Test Coverage** : 100% edge cases P0, 80% edge cases P1
- [ ] **Device Testing** : 100% Pass sur 5 devices réels (scenarios table)
- [ ] **Crash Rate Beta** : < 1% sessions sur 100 beta testers × 2 semaines
- [ ] **Performance Beta** : P95 load time < 3s, P95 FPS > 30
- [ ] **Monitoring** : Dashboard Sentry opérationnel avec alertes configurées

#### **Critères Produit**

- [ ] **Onboarding Flow** : Testé avec 10 users naïfs → 80% complètent sans aide
- [ ] **EmptyState UX** : Nouveaux users comprennent CTA (user testing)
- [ ] **Tier Messages** : Users MID/LOW comprennent limitations (user testing)
- [ ] **Private Mode Warning** : Users voient + comprennent banner (user testing)
- [ ] **Error Messages** : Zéro message technique cryptique (audit complet)

#### **Critères Organisationnels**

- [ ] **Documentation** : ADRs écrits pour décisions P0 (RendererInterface, GraphBackend, etc.)
- [ ] **Runbooks** : Playbooks pour top 5 incidents prévus (WebGL loss, quota, memory leak, etc.)
- [ ] **Support Training** : Support team formée sur top 10 issues anticipés
- [ ] **Rollback Plan** : Feature flags pour kill switches (Cosmos, DuckDB, etc.)

**Gate Owner** : CTO (sign-off final)

---

### D-PREMORTEM-007 : Post-Launch Surveillance (First 30 Days)

**Principe** : Les 30 premiers jours post-lancement = période critique. Monitoring intensif + équipe on-call.

#### **Semaine 1-2 : War Room Mode**

- **Daily Standups** : Review dashboard (crash rate, P95 load, support tickets top 5)
- **On-Call Rotation** : 1 engineer + 1 PM disponibles 24/7 (Slack alerts)
- **Hotfix Budget** : Pre-approved 3 hotfix slots (deploy sans review si P0)
- **Metrics Watch** : Crash rate > 2% → WAR ROOM convened (toute équipe)

#### **Semaine 3-4 : Stabilisation**

- **Retrospective** : "What did pre-mortem miss?" (capture nouveaux failure modes)
- **Backlog Triage** : Prioriser issues découvertes post-launch
- **Documentation Update** : Mettre à jour ADRs avec learnings réels

#### **Jours 30 : Go/No-Go Scale**

**Critères pour scaler marketing** :
- Crash rate < 1% maintenu 2 semaines
- NPS > 30 sur premiers 500 users
- P95 load time < 5s maintenu
- Support tickets < 50/semaine (capacité équipe)

**Si critères non atteints** → PAUSE marketing, focus stabilisation 2 semaines supplémentaires.

---

### D-PREMORTEM-008 : Lessons Learned Template

**Principe** : Documenter lessons learned proactivement, pas seulement après incidents.

**Template Post-Incident** (si échec partiel arrive malgré prevention) :

```markdown
# Post-Mortem : [Incident Title]

**Date** : [Date incident]
**Severity** : P0 / P1 / P2
**Impact** : [X users affected, Y% uptime]

## Timeline
- [HH:MM] : Incident détecté (comment ?)
- [HH:MM] : Équipe alertée
- [HH:MM] : Root cause identifié
- [HH:MM] : Fix deployed
- [HH:MM] : Incident résolu

## Root Cause
[Description technique 2-3 paragraphes]

## What Went Wrong
- [Pourquoi pre-mortem n'a pas prévu ça ?]
- [Quel assumption était faux ?]
- [Quelle validation manquait ?]

## What Went Right
- [Qu'est-ce qui a bien fonctionné dans la response ?]
- [Quels systèmes ont limité le blast radius ?]

## Action Items
- [ ] [Fix immediate] (Owner, Deadline)
- [ ] [Prevention long-terme] (Owner, Deadline)
- [ ] [Monitoring ajouté] (Owner, Deadline)
- [ ] [Documentation update] (Owner, Deadline)

## Pre-Mortem Update
[Comment ce incident modifie le pre-mortem pour futures features ?]
```

---

## Synthèse Finale : Prevention Plan Summary

**Total effort prévention avant lancement** : ~19 jours engineering + 3 jours QA = **22 jours total**

**ROI prévention** :
- Évite 92% churn (de 2,400 MAU → 180 dans scénario échec)
- Maintient velocity > 15 SP/sprint (vs 2 SP/sprint dans scénario échec)
- Évite 450 support tickets/semaine (vs capacité 150/semaine)
- Protège réputation (évite 2.1★ catastrophe)

**3 Meta-Lessons** :
1. **Resilience IS a feature** → 20% sprint time non-négociable
2. **Edge cases ARE the product** → 40% users hit "edge cases"
3. **Abstractions ARE survival** → velocity crashes sans elles

**Gate Final** : **13 critères GO/NO-GO** → 100% Pass obligatoire avant lancement production.

---

**Document généré le 2026-06-07**  
Fusion de `cosmos-implementation-patterns.md` × `scy_forge-prd-consolidé.md` × `cosmos-research.md`  
**+ Élicitation avancée complétée** : 5 méthodes (ADR, Failure Mode, Edge Cases, Second-Order, Pre-mortem)

**Sections ajoutées via élicitation** :
- RESILIENCE : Failure Modes & Recovery (6 décisions)
- VALIDATION : Edge Cases & Guards (6 décisions)
- STRATEGY : Strategic Implications & Mitigations (6 décisions)
- PREMORTEM : Prevention Plan & Launch Readiness (8 décisions)

**Total décisions architecturales COSMOS v3** : 77 décisions documentées

| Section | Décisions | Contenu |
|---------|-----------|---------|
| RENDER | D-RENDER-001→009 | 5 moteurs de rendu, 26 modes, device tiers, lazy-loading |
| DATA | D-DATA-001→004 | Graphology source unique, IndexedDB, DuckDB-WASM, adaptateur Cosmos |
| RESILIENCE | D-RESILIENCE-001→006 | Circuit Breaker, WebGL recovery, G6 cleanup, IndexedDB fallback, DuckDB timeout |
| VALIDATION | D-VALIDATION-001→006 | NaN/Infinity guards, label sanitization, edge refs check, graph integrity, pre-flight guards |
| STRATEGY | D-STRATEGY-001→006 | Renderer abstraction layer, swappable backends, centralized circuit breaker config |
| PERF | D-PERF-001→005 | LOD 4 niveaux, R-Tree spatial index, Web Workers, dégradation progressive |
| MODES | D-MODES-001→005 | 26 modes, matrice renderers×données, couverture conceptuelle, auto-suggest, phasage |
| PREMORTEM | D-PREMORTEM-001→008 | 10 failure modes, P0 checklist, edge cases, monitoring, meta-failures, launch readiness |
| **TOTAL** | **77** | **+21 décisions vs v1 (52)** |

---

## Synthèse Finale — Architecture COSMOS v4 Complète {#synthese-finale}

**Couverture conceptuelle** : 50% (v2, 9 modes) → **87%** (v3/v4, 26 modes)

**Moteurs de rendu** : 5 (+1 WebGPU Phase 3) — Cosmos GPU, G6 WebGL, G2 Statistical, React Flow DAG, nivo/d3/recharts

**Bundle** : ~1.4MB lazy-loaded, ~220KB initial (+20KB vs v2, stable v4)

**7 modes à 0KB additionnel** : Concept Map, Treemap, Radar, Argument Map, Causal Loop, Semantic Zoom, Heatmap/CirclePacking via G2

**Résilience** : Circuit Breaker, Idempotency, Dead Letter Queue, Bulkhead, Graceful Shutdown, Outbox

**Déploiement** : Blue/Green, Feature Flags, Strangler Fig — migration progressive sans risque

**Tests** : Property-based (proptest), Chaos Engineering, Pyramide complète (unit 60% + integration 25% + E2E 15%)

**v4 — Nouvelles Décisions par Section** :

| Section | v3 | v4 | Δ | Contenu |
|---------|----|----|---|---------|
| RENDER   | 9  | 9  | = | 5 moteurs, 26 modes, device tiers |
| DATA     | 4  | 6  | +2 | + OPFS (D-DATA-005) + Event Sourcing client (D-DATA-006) |
| RESILIENCE | 6 | 6 | = | Circuit Breaker, WebGL, G6, IndexedDB |
| VALIDATION | 6 | 6 | = | NaN, labels, edges, intégrité, guards |
| STRATEGY | 6  | 6  | = | Abstraction layer, swappable backends |
| PERF     | 5  | 7  | +2 | + Progressive Rendering (D-PERF-006) + WebGPU (D-PERF-007) |
| MODES    | 5  | 5  | = | 26 modes, matrice, couverture, auto-suggest, phasage |
| QUAL     | 0  | 3  | **+3** | HiDPI, Font CJK, Adaptive Quality — **NOUVEAU** |
| UX       | 0  | 12 | **+12** | Fisheye, Progressive Render, Cards, Persona, Behavioral, Edges, Trail, Insights, NL, Relevance, Gap, Sync — **NOUVEAU** |
| OPP      | 0  | 5  | **+5** | 5 Opportunités Différenciation (SMI, IA Transparent, Provenance, Prescriptif, Relevance) — **NOUVEAU** |
| SEC-EXT  | 0  | 4  | **+4** | Confidence, Rejection, k-Anonymity, Encryption — **NOUVEAU** |
| PREMORTEM | 8 | 8  | = | 10 failure modes, P0 checklist, monitoring |
| **TOTAL** | **77** | **122** | **+41** | |

**5 Opportunités de Différenciation Absolue (aucun concurrent ne les fait)** :
1. 🏆 **Learning-Aware Graph** — SMI + FSRS + révisions dans le graphe (D-OPP-001)
2. 🏆 **Transparent AI Graph** — Confiance IA + validation/rejet + feedback loop (D-OPP-002)
3. 🏆 **Source-Linked Nodes** — Provenance jusqu'au paragraphe + navigation Reader Suite (D-OPP-003)
4. 🏆 **Prescriptive Insights** — Graphe prescrit les actions suivantes, $0 LLM (D-OPP-004)
5. 🏆 **Reveal by Relevance** — Graphe adaptatif selon contexte apprentissage actuel (D-OPP-005)

**Sprint 0 — 7 jours (impact immédiat, 0 risque)** :
- D-QUAL-001 HiDPI + D-QUAL-002 Fonts CJK + D-UX-006 Typed Edges + D-SEC-001 Confidence Badges

**Prochaine étape** : Validation Architecture Team → Sprint 0 immédiat → Phase 1 Sprint Planning

---

## Prochaines Actions Recommandées

### Phase 1 : Validation & Socialisation (Semaine 1-2)

1. **Review Technique** : CTO + Tech Leads review complet — 77 décisions, 26 modes
2. **Estimation Effort** : Équipe engineering estime actions Phase 1 (MVP+ M9-M14 → ~41j)
3. **Prioritization** : Product Manager intègre M9 (Concept Map), S10 (Sunburst), M14 (Radar) en priorité absolue Sprint 1
4. **ADR Individuel** : Créer ADRs séparés pour top 5 décisions (RendererInterface v3, GraphBackend v3, @antv/g2 integration, nivo vs d3 tradeoff, Mode Auto-Suggest)
5. **Socialisation Design** : Designers review nouveaux modes UX (Concept Map, Sunburst, Radar)

### Phase 2 : Implémentation Sprint Planning Phase 1 — MVP+ (Semaine 3-6)

1. **Sprint 1 (M9 Concept Map)** : G6 mode multi-parents, relations étiquetées, ForceAtlas2 (15j)
2. **Sprint 2 (S10 Sunburst)** : G2 integration, drill-down, breadcrumb navigation (8j)
3. **Sprint 3 (M14 Radar + S11 Treemap)** : Recharts Radar SMI 5D, G2 Treemap Squarify (11j)
4. **Sprint 4 (Validation + Tests)** : Edge cases 5 nouveaux modes, devices testing, monitoring (7j)

### Phase 3 : Phase 2 — Post-MVP V1 (Mois 4-6)

1. **Sprint 5-6 (Modes Flux)** : Sankey/Alluvial (M13), Chord Diagram (S12), Circle Packing (M19) — 21j
2. **Sprint 7-8 (Modes Dimensionnels)** : Parallel Coordinates (M15), Heatmap (M16), Arc Diagram (M20) — 22j
3. **Gate Review V1** : GO/NO-GO pour activation beta 25% users

### Phase 4 : Launch Readiness 26 Modes (Semaine lancement)

1. **Gate Review** : Vérifier 13 critères GO/NO-GO (100% Pass requis)
2. **War Room Setup** : On-call rotation + hotfix budget + alert Slack
3. **Feature Flags** : Activation progressive M9-M24 (5% → 25% → 100%)
4. **Surveillance** : Dashboard monitoring actif 24/7 premiers 30 jours
5. **Retrospective J+30** : "What did pre-mortem miss?" → update document

---

## Notes de Continuation v4

**Sections du document** :
- ✅ RENDER    : 9 décisions (D-RENDER-001→009)
- ✅ DATA      : 6 décisions (D-DATA-001→006) — +OPFS +Event Sourcing
- ✅ RESILIENCE: 6 décisions (D-RESILIENCE-001→006)
- ✅ VALIDATION: 6 décisions (D-VALIDATION-001→006)
- ✅ STRATEGY  : 6 décisions (D-STRATEGY-001→006)
- ✅ PERF      : 7 décisions (D-PERF-001→007) — +Progressive Render +WebGPU
- ✅ MODES     : 5 décisions (D-MODES-001→005)
- ✅ QUAL      : 3 décisions (D-QUAL-001→003) — **NOUVEAU v4**
- ✅ UX        : 12 décisions (D-UX-001→012) — **NOUVEAU v4**
- ✅ OPP       : 5 décisions (D-OPP-001→005) — **NOUVEAU v4**
- ✅ SEC-EXT   : 4 décisions (D-SEC-001→004) — **NOUVEAU v4**
- ⚠️ MOB       : placeholder (D-MOB-001→003 — itération future)
- ✅ PREMORTEM : 8 décisions (D-PREMORTEM-001→008)

**Total v4.5 : 130 décisions architecturales (77 v3 + 53 nouvelles — Intégrant Section BRAIN-MORPH)**

**Le document v4 est complet et opérationnel pour le développement et le lancement production.**

**Prochain document à produire** : Spécifications UX détaillées Modes 9-24 (D-UX-MODES-001→016).


---

## Section BRAIN-MORPH — Modèle Géométrique Force-Cerveau (8 décisions) 🆕

### D-BMORPH-001 : Asymmetric Sagittal Brain Boundary (Enveloppe Cérébrale)
- **Décision** : Contraindre la constellation de nœuds dans une enveloppe reproduisant le contour sagittal asymétrique d'un cerveau humain à l'aide de l'Équation de Sagittal de SCY Forge :
  $$\left( \frac{x}{a \cdot (1 + c \cdot y)} \right)^{2.4} + \left( \frac{y - d \cdot x^2}{b} \right)^{2.2} \le 1.0$$
- **Justification** : Offrir une matérialisation visuelle unique du savoir qui grandit organiquement et imite la physiologie cérébrale.
- **Phase** : Phase 1 (Web)

### D-BMORPH-002 : Functional-Anatomical Node Anchoring (Ancrage des Lobes)
- **Décision** : Attirer magnétiquement chaque nœud vers une aire anatomique dédiée selon sa taxonomie de Bloom et son rôle : Cortex Préfrontal (Create/Evaluate, $x = 0.7, y = -0.3$), Lobe Pariétal (Analyze, $x = 0.1, y = -0.6$), Lobe Occipital (Visual structures, $x = -0.7, y = -0.1$), Lobe Temporel (Understand, $x = 0.0, y = 0.2$), Cervelet (Remember/Code, $x = -0.4, y = 0.6$), Tronc Cérébral (Ingestion, $x = 0.0, y = 1.0$).
- **Justification** : Alignement rigoureux entre classification cognitive sémantique et positionnement visuel.
- **Phase** : Phase 1 (Web)

### D-BMORPH-003 : Verlet Integration Force Simulation (Simulation de Forces)
- **Décision** : Modifier le système d'équations physiques de Verlet en ajoutant les lois de Hooke (attraction de liens) et de Coulomb (répulsion), couplées à l'attraction harmonique d'ancre.
- **Justification** : Garantir un mouvement fluide des particules synaptiques lors de zooms, pans et modifications du graphe.
- **Phase** : Phase 1 (Web)

### D-BMORPH-004 : Synaptic Breathing (Effet Respiration Biologique)
- **Décision** : Injecter une micro-oscillation ondulatoire sinusoïdale en tâche de fond basée sur le temps et la température thermodynamique du concept.
- **Justification** : Donner le sentiment d'un cerveau "pensant" et vivant en arrière-plan de l'interface.
- **Phase** : Phase 1 (Web)

### D-BMORPH-005 : O(N log N) Scaling via Barnes-Hut Quadtree (Passage à l'Échelle)
- **Décision** : Pour supporter des millions de nœuds ($10^6$ nœuds) en production sans saturer le CPU, remplacer la complexité quadratique $O(N^2)$ de répulsion par l'algorithme d'approximation spatiale de **Barnes-Hut** s'exécutant sur un arbre Quadtree récursif.
- **Justification** : Réduction immédiate de la charge CPU de 99.7% sur les gros volumes de nœuds.
- **Phase** : Phase 1 (Web)

### D-BMORPH-006 : Softening Epsilon d'Anti-Division par Zéro (Fail-Safe)
- **Décision** : Ajouter une constante de lissage $\epsilon = 10^{-6}$ au dénominateur des forces de répulsion : $F_r = \frac{k_r}{d^2 + \epsilon}$.
- **Justification** : Éviter les divisions par zéro et l'apparition de coordonnées de type `NaN` lors de superpositions parfaites de nœuds.
- **Phase** : Phase 1 (Web)

### D-BMORPH-007 : Exponent Clipping Limit (Protection anti-overflow)
- **Décision** : Écrêter de manière logicielle l'exposant de décomposition temporelle d'ENGRAM par un limiteur strict : `max(-50.0, min(50.0, exponent))`.
- **Justification** : Empêcher les overflows exponentiels ou blocages de mémoire floating-point lorsque l'intervalle $t \to \infty$.
- **Phase** : Phase 1 (Web)

### D-BMORPH-008 : Synaptic Competition (RIF) avec Fail-Safe Gate
- **Décision** : Appliquer un facteur d'amortissement de 90% sur la suppression compétitive RIF dès qu'un concept descend sous le seuil critique d'alerte de $25.0/100$ de vitalité.
- **Justification** : Neutraliser à 100% tout risque de cascade de mort sémantique (synaptic avalanche) du graphe de connaissances.
- **Phase** : Phase 1 (Web)


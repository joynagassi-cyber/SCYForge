<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🌌 SCY-COSMOS — L'ESPACE DE PENSÉE AUGMENTÉE DE SCY FORGE
**ID Module** : S04_SCY_COSMOS_CORE  
**Statut** : 🟢 SPÉCIFICATION TECHNIQUE DE PRODUCTION (REBRANDING MAÎTRE)  

---

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

## 1. Changement de Paradigme : COSMOS ──► SCY-COSMOS
Le passage de COSMOS à **COSMOS** n'est pas un simple ajustement esthétique ou marketing. C'est une révolution dans le rapport de l'utilisateur avec sa connaissance.
- **COSMOS** suggérait un outil d'intelligence rapide — un simple assistant réactif.
- **COSMOS** désigne un **univers de pensée personnel**, structuré, dynamique et habitable, dont l'utilisateur est le centre, et qui s'élargit de manière auto-organisatrice à mesure que son savoir se développe.

---

## 2. L'Architecture des 5 Moteurs de Rendu de COSMOS

Pour garantir des performances optimales sans concession, COSMOS s'appuie sur une stack de **5 moteurs de rendu complémentaires**, intégrés de façon asynchrone (Lazy-Loading) :

```
                        [ COSMOS CORE ORCHESTRATOR (React 18) ]
                                           │
         ┌───────────────────┬─────────────┼──────────────┬──────────────────┐
         ▼ (WebGL2)          ▼ (Canvas)    ▼ (SVG/HTML)   ▼ (SVG Flow)       ▼ (Statistiques)
   ┌───────────┐       ┌───────────┐ ┌───────────┐  ┌───────────┐      ┌───────────┐
   │Cosmograph │       │  AntV G6  │ │  AntV G2  │  │React Flow │      │ nivo, d3  │
   │ 1M nodes  │       │ (V5 WebGL)│ │(Sunburst) │  │  (DAGs)   │      │ Recharts  │
   └───────────┘       └───────────┘ └───────────┘  └───────────┘      └───────────┘
```

1. **Moteur 1 : Cosmograph (WebGL2 GPU)** :  
   Rendu brut capable d'afficher jusqu'à **1 000 000 de nœuds** en direct à 60 FPS constants. Idéal pour la base de connaissances globale à long terme sans ralentissement.
2. **Moteur 2 : AntV G6 (v5 WebGL Canvas)** :  
   Dédié aux représentations nœud-lien interactives d'une grande complexité (Knowledge Graph sémantique, Concept Maps, MindMaps).
3. **Moteur 3 : AntV G2 (v5 SVG/Canvas)** :  
   Dédié aux représentations hiérarchiques géométriques denses (Treemaps conceptuels, Sunburst concentriques).
4. **Moteur 4 : React Flow** :  
   Dédié aux graphes orientés acycliques (DAGs) d'apprentissage d'ASCENT, aux diagrammes d'argumentations et aux flux de données inter-agents.
5. **Moteur 5 : nivo, d3, Recharts** :  
   Dédié aux affichages statistiques d'SMI, diagrammes de Sankey, Chord Diagrams et matrices de Heatmaps.

* **Optimisation de Bundle (Lazy-Loading)** : Chaque moteur n'est chargé que lorsque l'utilisateur l'invoque. Le bundle initial est bridé à **200 KB**, évitant de charger les modules Three.js (450 KB) ou d'autres moteurs d'office.

---

## 3. Les 4 Séquences de l'Allumage Neural (Neural Ignition Reveal)

Lors de l'ouverture de COSMOS, la cinématique d'animation s'organise en 4 phases d'orientations cognitives pour éliminer tout temps d'attente perçu (TTFV < 1s) :
1. **Phase 1 : WebGL Shader Background (0 - 500ms)** :  
   Rendu d'un fond d'espace sombre et profond traversé de micro-particules lumineuses simulant l'activité au repos du cerveau (resting-state).
2. **Phase 2 : Éveil des Hubs (500ms - 1500ms)** :  
   Les nœuds les plus centraux et structurants apparaissent d'abord selon leur score PageRank, reliés par des arcs de lumière électriques.
3. **Phase 3 : Condensation des Clusters (1500ms - 2500ms)** :  
   Les concepts secondaires s'allument en vagues successives par familles sémantiques (Louvain), guidant la lecture de l'œil sans saturation.
4. **Phase 4 : Stabilisation (2500ms - 3000ms)** :  
   L'ensemble du graphe se stabilise géométriquement, la micro-respiration synaptique lente s'installe, et le flou sémantique se résout.

---

## 4. Les Nouvelles Caractéristiques Différenciatrices de COSMOS

### A. Le Système de Lentilles Multidimensionnelles
L'utilisateur peut superposer plusieurs grilles de lecture sémantiques simultanées sur la même vue :
* *Lentille Temporelle* : Colorie les concepts par date d'acquisition (du cyan froid pour le récent à l'ambre pour l'ancien).
* *Lentille Épistémique* : Colorie par fiabilité de source (du rouge pour l'unitaire au vert pour les validations croisées multi-sources académiques).
* *Lentille Émotionnelle* : Module la taille physique du nœud selon l'intensité émotionnelle ou de controverse extraite des sources textuelles.
* *Lentille ASCENT* : Superpose les états de maîtrise socratique.

### B. Fisheye Lens (La Touche F)
Pour résoudre le problème "Focus + Contexte" sans perdre la vue d'ensemble, l'utilisateur active une loupe sphérique dynamique en appuyant sur **`F`**. Elle agrandit localement la zone sous le curseur d'un facteur 1.5x à 3x (rayon réglable par molette) tout en conservant la structure globale du cerveau en périphérie.

### C. L'IA Transparente & Feedback Loop
Toutes les relations créées par AUTO-GRAPH affichent un badge de confiance. L'utilisateur peut rejeter ou valider les liens suggérés via un panel d'actions en masse. Les rejets ré-alimentent et calibrent automatiquement les seuils de similarité cosinus de la communauté.

### D. Provenance W3C PROV & Source-Linked Nodes
Chaque concept de COSMOS dresse son historique de provenance conforme au standard W3C PROV. Un clic permet d'ouvrir instantanément la **Reader Suite** ou la vidéo YouTube au timestamp ou paragraphe exact d'extraction.

### E. Les Insights Prescriptifs Déterministes (Miller's Law)
Un moteur d'analyse local à coût nul (0$ d'appels LLM, règles Rust) affiche un maximum de **3 recommandations actionnables** simultanées (ex: révisions en retard signalées par des nœuds palpitants, prérequis manquants pour les autodidactes).

### F. Reveal by Relevance (La Vue Pertinente)
Filtre dynamiquement l'affichage pour masquer le superflu et recentrer l'attention exclusive sur les **150 concepts** les plus pertinents par rapport au contexte de l'étudiant (requêtes récentes, cours actif), assurant un focus absolu sans saturation de l'attention.


### G. Le Zoom Sémantique Hippocampal (COSMOS Mode 22)
S'inspirant des techniques de méditation cognitive, COSMOS intègre le **Semantic Zoom Graph** :
- Force l'utilisateur à naviguer spatialement et mentalement à l'aide des zooms entre l'atome (la fiche concept micro) et la galaxie complète (la KB globale).
- Cette navigation spatiale active les cellules de lieu de l'hippocampe d'une manière similaire à un parcours d'orientation géographique physique, ancrant géographiquement les connaissances dans les structures mnésiques profondes de l'utilisateur.


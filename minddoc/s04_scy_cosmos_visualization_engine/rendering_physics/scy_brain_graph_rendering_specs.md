<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧠 LE MODÈLE MATHÉMATIQUE "FORCE-CERVEAU" — SPÉCIFICATIONS DE RENDU DE GRAPHE
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

## Architecture Algorithmique du Graphe de Connaissances Morphogénétique et Charte Graphique Spatiale Élite

**Document ID** : SPEC-SCY-BRAIN-GRAPH-MORPHING-V1.0  
**Date** : 2026-06-12  
**Statut** : 🟢 SPÉCIFICATION DE DESIGN & CODAGE PRÊTE POUR SPRINTS  
**Périmètre** : Modèle mathématique de morphing du graphe de connaissances en forme de cerveau humain et spécification d'intégration d'UI.  
**Palettes Chromatiques** : Noir d'encre, Violet profond, Bleu électrique, Émeraude consolidée, Blanc luminous, Gris axonal.

---

## 🧭 Table des Matières
1. [Vision Artistique et Audace Technologique](#1-vision)
2. [L'Équation Morphogénétique de l'Enveloppe Cérébrale (L'Enveloppe de Sagittal)](#2-equations)
3. [Classification Fonctionnelle et Anchoring Anatomique](#3-classification)
4. [L'Algorithme Mathématique du Graphe "Force-Cerveau" (Force-Directed WebGL)](#4-algorithm)
5. [La Charte Graphique Spatiale Élite (L'Esthétique Synaptique)](#5-color-palette)
6. [Code Source de Rendu : Composant React Canvas Biologiquement Animé](#6-code-implementation)
7. [Intégration d'État (Northflank & COSMOS Mode 26)](#7-integration)

---

## 1. Vision Artistique et Audace Technologique {#1-vision}

La majorité des outils de gestion des connaissances affichent des graphes sémantiques sous forme de **nuages stellaires désordonnés**, de spaghettis relationnels illisibles, ou de cercles parfaits artificiels. C'est un aveu de faiblesse mathématique et esthétique.

SCY Forge fait le choix de l'**audace technologique** : **plus le savoir de l'utilisateur grandit, plus son graphe de connaissances se structure, s'auto-organise, et prend littéralement la forme anatomique d'un cerveau humain (sagittal et hémisphérique)**.

Ce morphing n'est pas une simple animation statique en surimpression, mais le résultat d'un **système dynamique de forces physiques et de potentiels d'attraction géométriques**. Chaque nœud de connaissance est attiré vers sa région anatomique logique (cortex frontal, lobe occipital, cervelet, tronc cérébral) selon ses métadonnées sémantiques, cognitives (Bloom) et de mémorisation.

---

## 2. L'Équation Morphogénétique de l'Enveloppe Cérébrale (L'Enveloppe de Sagittal) {#2-equations}

Pour contraindre les nœuds à se structurer au sein d'une enveloppe imitant un profil sagittal du cerveau humain, nous définissons une équation de **frontière de potentiel asymétrique**.

La forme globale du cortex cérébral est modélisée dans un repère normalisé $(x, y) \in [-1.5, 1.5] \times [-1.5, 1.5]$ par une **superellipse asymétrique déformée** (Équation de Sagittal de SCY Forge) :

$$\left( \frac{x}{a \cdot (1 + c \cdot y)} \right)^p + \left( \frac{y - d \cdot x^2}{b} \right)^q \le 1$$

Où les paramètres de calibrage géométrique sont fixés comme suit :
* $a = 1.0$ : Rayon horizontal de base.
* $b = 0.85$ : Rayon vertical de base.
* $c = 0.25$ : Facteur d'asymétrie frontale (élargit le lobe préfrontal à l'avant $x > 0$ et rétrécit le pôle occipital à l'arrière $x < 0$).
* $d = 0.15$ : Constante de courbure basale (crée le bombement supérieur du cortex et le creux de la base du crâne).
* $p = 2.4$, $q = 2.2$ : Coefficients de superellipses lissant les courbures des lobes frontaux et pariétaux.

### Les Frontières de Potentiel d'Évitement :
Si un nœud dépasse cette enveloppe lors de la simulation de forces, un vecteur de force de rappel de gradient inverse $\vec{F}_{\text{border}}$ est appliqué pour le repousser doucement vers l'intérieur :

$$\vec{F}_{\text{border}}(n) = - k_{\text{border}} \cdot (\text{Distance}(P_n) - 1)^2 \cdot \vec{u}_{\text{center}}$$

---



## 2. bis — Évolutions v3.0 : Double-Rendu Bi-Modal (2D Horizontal & 3D KB Matérialisé) 🆕

Pour répondre au besoin d'un affichage de carte d'apprentissage ergonomique et d'une matérialisation physique de la base de connaissances (KB), SCY Forge intègre deux modes d'affichages géométriques :

### A. La Coupe Horizontale (Axiale) en 2D (COSMOS Mode 25)
La coupe transversale/sagittale est complétée par une **vue axiale/horizontale (du dessus)**. Elle sépare le savoir en deux hémisphères (gauche et droit) divisés par une **fissure longitudinale centrale**.

La frontière d'enveloppe horizontale est modélisée en coordonnées polaires par :
$$r(\theta) = R_0 \cdot \left( 1 + 0.12 \cdot \cos(2\theta) - 0.04 \cdot \cos(4\theta) \right) \cdot \left( 1 - 0.08 \cdot |\sin(\theta)|^4 \right)$$
* $\cos(2\theta)$ : Allonge le cerveau de l'avant (frontal) vers l'arrière (occipital).
* $\cos(4\theta)$ : Crée les échancrures naturelles des tempes.
* $|\sin(\theta)|^4$ : Forme l'étroite fissure interhémisphérique verticale à $\theta = \pi/2$ et $-\pi/2$.

---

### B. La Base de Connaissances Matérialisée en 3D (COSMOS Mode 26)
La base globale de connaissances est projetée dans un espace tridimensionnel réversible $(x, y, z) \in [-1, 1]^3$.

#### 1. Coordonnées d'Ancrage Cérébral en 3D :
Chaque nœud de connaissance est attiré en 3D vers son ancre d'origine :
- **Lobe Frontal / Cortex Préfrontal (Créer/Évaluer)** : $x = [0.4, 0.8]$, $y = [0.3, 0.6]$, $z = [-0.3, 0.3]$ (Anterior superior).
- **Lobe Pariétal (Analyser)** : $x = [-0.2, 0.2]$, $y = [0.5, 0.8]$, $z = [-0.4, 0.4]$ (Posterior superior).
- **Lobe Occipital (Appliquer - Visuel)** : $x = [-0.8, -0.6]$, $y = [0.1, 0.3]$, $z = [-0.3, 0.3]$ (Far posterior).
- **Lobe Temporel (Comprendre - Mémoire)** : $x = [-0.3, 0.3]$, $y = [-0.4, 0.0]$, $z = [0.4, 0.8]$ (Lateral sides).
- **Cervelet (Mémoriser / Pratique)** : $x = [-0.5, -0.3]$, $y = [-0.7, -0.5]$, $z = [-0.4, 0.4]$ (Posterior inferior).
- **Tronc Cérébral (Ingestion de base)** : $x = [0.0]$, $y = [-1.3, -1.0]$, $z = [0.0]$ (Central inferior shaft).

#### 2. Matrice de Rotation 3D :
La rotation orbitale contrôlée par la souris applique des transformations trigonométriques sur les coordonnées :
- **Rotation autour de l'axe Y (angle $\beta$)** :
  $$x_1 = x \cdot \cos(\beta) - z \cdot \sin(\beta)$$
  $$z_1 = x \cdot \sin(\beta) + z \cdot \cos(\beta)$$
- **Rotation autour de l'axe X (angle $\alpha$)** :
  $$y_2 = y \cdot \cos(\alpha) - z_1 \cdot \sin(\alpha)$$
  $$z_2 = y \cdot \sin(\alpha) + z_1 \cdot \cos(\alpha)$$

#### 3. Projection Perspective 3D sur Canvas 2D :
$$x_{\text{projected}} = \frac{x_1 \cdot f_{\text{fov}}}{d_{\text{camera}} + z_2} \cdot \text{scale} + c_x$$
$$y_{\text{projected}} = \frac{y_2 \cdot f_{\text{fov}}}{d_{\text{camera}} + z_2} \cdot \text{scale} + c_y$$

#### 4. Tri de Profondeur (Peintre / Z-Buffering) :
Pour dessiner proprement les liaisons axonales et les nœuds sans distorsions d'occlusions, les nœuds sont triés selon $z_2$ (profondeur projetée) avant le rendu.
* **Effet de Profondeur** : Les nœuds situés à l'arrière ($z_2 > 0$) voient leur rayon d'affichage, leur lueur et l'opacité de leur texte réduits de moitié (matière grise d'arrière-plan), tandis que les nœuds à l'avant ($z_2 < 0$) rayonnent avec une intensité maximale de Bleu électrique ou d'Émeraude consolidée, créant un effet tridimensionnel spectaculaire.

## 3. Classification Fonctionnelle et Anchoring Anatomique {#3-classification}

Chaque type de connaissance de SCY Forge est associé à une **aire anatomique spécifique** selon son profil sémantique et cognitif, créant un alignement biologique parfait.

```
                         ┌────────────────────────────────────────┐
                         │       LOBE PARIÉTAL / INTÉGRATION      │
                         │ (Concepts cardinaux, Textes denses, S) │
                         └──────────────────┬─────────────────────┘
                                            │
   ┌───────────────────────────┐            │            ┌───────────────────────────┐
   │ LOBE FRONTAL / STRATÉGIE  │◄───────────┼───────────►│ LOBE OCCIPITAL / VISUEL   │
   │ (Bloom Elevé, Objectifs,  │            │            │ (COSMOS modes, Schémas,    │
   │  Projets complexes, G)    │            │            │  Diagrammes)              │
   └───────────────────────────┘            │            └───────────────────────────┘
                                            ▼
                         ┌────────────────────────────────────────┐
                         │   LOBE TEMPOREL / MÉMOIRE APEX (FSRS)  │
                         │  (Flashcards, Glossaires, Vocabulaire) │
                         └──────────────────┬─────────────────────┘
                                            │
                                            ▼
                         ┌────────────────────────────────────────┐
                         │     CERVELET / PRATIQUE ET CODE        │
                         │  (Codebases, Repomix, Exercices, Arena)│
                         └──────────────────┬─────────────────────┘
                                            │
                                            ▼
                         ┌────────────────────────────────────────┐
                         │       TRONC CÉRÉBRAL / INGESTION       │
                         │ (11 Cores d'Ingestion, Configs, Logs)  │
                         └────────────────────────────────────────┘
```

### Table des Coordonnées d'Ancrage Anatomique $(x_{\text{target}}, y_{\text{target}})$ :

| Lobe Anatomique | Rôle Cognitif & Sémantique | Critère Technique Majeur | Coordonnées Cibles de l'Ancre | Force d'Attraction ($\gamma$) |
|-----------------|-----------------------------|---------------------------|-------------------------------|-------------------------------|
| **Cortex Préfrontal** | Stratégie, Objectifs, Bloom élevé (`Evaluate`, `Create`). | Nœuds ASCENT actifs, Documents `G01`, `W01`. | $(0.8, 0.4)$ | High ($0.45$) |
| **Lobe Pariétal** | Concepts centraux, synthèse, définitions stables. | Documents `S01`, `S03`, `scy_concepts`. | $(0.1, 0.7)$ | Medium ($0.30$) |
| **Lobe Occipital** | Visualisations spatiales, modes de rendu COSMOS. | Données de graphe COSMOS, diagrammes. | $(-0.8, 0.2)$ | High ($0.40$) |
| **Lobe Temporel** | Mémoire consolidée, révisions espacées APEX. | Cartes `scy_apex_cards` et stats FSRS. | $(0.0, -0.2)$ | High ($0.50$) |
| **Cervelet** | Compétence procédurale, pratique réelle, code. | Ingestion `Repomix`, sessions `ARENA`. | $(-0.5, -0.7)$| Medium ($0.35$) |
| **Tronc Cérébral** | Ingestion brute, données d'entrées, 11 Cores. | Sources `scy_project_sources`. | $(0.0, -1.2)$ | High ($0.60$) |

---

## 4. L'Algorithme Mathématique du Graphe "Force-Cerveau" (Force-Directed WebGL) {#4-algorithm}

Pour structurer le graphe en forme de cerveau de manière fluide, nous modifions l'équation classique de Verlet des systèmes de forces en ajoutant notre **Attraction Potentielle d'Ancre** et une force de **Micro-respiration Synaptique** :

$$\vec{F}_{\text{total}}(n) = \vec{F}_{\text{repulsion}}(n) + \vec{F}_{\text{attraction}}(n) + \vec{F}_{\text{anchor}}(n) + \vec{F}_{\text{breathing}}(n)$$

### 1. La Force de Repulsion (Loi de Coulomb modifiée) :
Évite la superposition des nœuds :
$$\vec{F}_{\text{repulsion}}(i, j) = \frac{k_r}{(d_{ij})^2} \cdot \vec{u}_{ij}$$

### 2. La Force d'Attraction de Lien (Loi de Hooke) :
Maintient les concepts interconnectés liés entre eux :
$$\vec{F}_{\text{attraction}}(i, j) = - k_a \cdot (d_{ij} - l_0) \cdot \vec{u}_{ij}$$

### 3. La Force d'Ancrage Cérébral (Loi de morphing) :
Pousse doucement le nœud vers son aire de spécialisation biologique :
$$\vec{F}_{\text{anchor}}(n) = - \gamma_n \cdot (\vec{P}_n - \vec{A}_n)$$
Où $\vec{A}_n$ est l'ancre anatomique définie au paragraphe 3 et $\gamma_n$ son coefficient d'attraction.

### 4. La Force de Respiration Synaptique (Breathing Effect) :
Pour donner vie au graphe et simuler un cerveau en train de "penser" (sans interaction utilisateur), nous ajoutons une micro-oscillation basée sur le temps et la température thermodynamique du nœud :
$$\vec{F}_{\text{breathing}}(n) = \sin(t \cdot \omega_n + \phi_n) \cdot T_n \cdot \vec{\eta}_n$$
Où $T_n$ est la température du concept (Pilier 5) et $\vec{\eta}_n$ un vecteur aléatoire unitaire.

---

## 5. La Charte Graphique Spatiale Élite (L'Esthétique Synaptique) {#5-color-palette}

Bannissant définitivement les arcs-en-ciel de couleurs des graphes amateurs, SCY Forge opte pour une **charte chromatique contrastée haut de gamme**, évoquant un cockpit spatial premium et des visualisations neurologiques médicales de pointe :

### La Palette de Couleurs Spatiale :

* **Violet Profond Sémantique (`#1E1B4B` ou `rgba(30, 27, 75, 0.3)`)** : 
  Représente l'enveloppe de support du cerveau et les liens de concepts d'arrière-plan (la matière grise).
* **Bleu Électrique Actif (`#2563EB` / `#60A5FA`)** : 
  Représente l'influx nerveux en cours de transit. Utilisé pour les nœuds actifs, les surbrillances et les connexions en cours d'étude ou de transfert.
* **Gris Axonal / Muted Silver (`#64748B` / `#334155`)** : 
  Représente la structure stable des liens dormants, des concepts non prioritaires ou en phase froide.
* **Émeraude Synaptique Consolidée (`#10B981` ou `#059669`)** : 
  La couleur de la réussite d'ancrage ! Appliquée aux concepts dont la rétention FSRS $\ge 90\%$ ou dont le nœud d'apprentissage est validé à 100%. Remplace toute forme de vert fade.
* **Blanc Lumineux Intense (`#FFFFFF`)** : 
  Dédié au concept actuellement survolé ou sélectionné par l'utilisateur, irradiant avec un halo de flou lumineux électrique.
* **Noir d'Encre de l'Espace (`#020205` / `#05050A`)** : 
  Le fond d'écran abyssal de la constellation, permettant de faire ressortir les contrastes avec une profondeur absolue (Règle 60% Noir d'Encre, 30% Violet Profond, 10% Bleu Électrique/Émeraude).

---

## 6. Code Source de Rendu : Composant React Canvas Biologiquement Animé {#6-code-implementation}

Voici le code source TypeScript complet du composant de simulation de force-cerveau auto-organisatrice en 2D Canvas, léger, ultra-performant et prêt à être intégré dans COSMOS :

```typescript
// components/BrainForceGraph.tsx
import React, { useEffect, useRef } from 'react';

export interface BrainNode {
  id: string;
  label: string;
  bloomLevel: string; // 'Remember' | 'Understand' | 'Apply' | 'Analyze' | 'Evaluate' | 'Create'
  isConsolidated: boolean;
  vitality: number; // 0-100
  temperature: number; // 0-100
  x: number;
  y: number;
  vx: number;
  vy: number;
  targetX: number;
  targetY: number;
  anchorForce: number;
}

export interface BrainLink {
  source: string;
  target: string;
  strength: number;
}

interface BrainGraphProps {
  nodes: BrainNode[];
  links: BrainLink[];
}

export const BrainForceGraph: React.FC<BrainGraphProps> = ({ nodes: initialNodes, links }) => {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const nodesRef = useRef<BrainNode[]>([]);

  // Initialiser les positions d'ancres anatomiques
  useEffect(() => {
    nodesRef.current = initialNodes.map((node) => {
      let tx = 0, ty = 0, force = 0.35;
      
      // Affectation des coordonnées d'ancres sémantiques (anatomie cérébrale)
      switch (node.bloomLevel) {
        case 'Evaluate':
        case 'Create':
          tx = 0.7; ty = -0.3; force = 0.45; // Cortex Préfrontal (Avant supérieur)
          break;
        case 'Analyze':
          tx = 0.1; ty = -0.6; force = 0.30; // Lobe Pariétal (Milieu supérieur)
          break;
        case 'Apply':
          tx = -0.7; ty = -0.1; force = 0.40; // Lobe Occipital (Arrière)
          break;
        case 'Understand':
          tx = 0.0; ty = 0.2; force = 0.45; // Lobe Temporel (Milieu bas)
          break;
        case 'Remember':
          tx = -0.4; ty = 0.6; force = 0.35; // Cervelet (Arrière bas)
          break;
        default:
          tx = 0.0; ty = 0.9; force = 0.50; // Tronc Cérébral (Bas vertical)
      }

      // Convertir du repère normalisé [-1, 1] vers l'espace Canvas initial
      return {
        ...node,
        targetX: tx,
        targetY: ty,
        anchorForce: force,
        x: node.x || (tx * 150) + (Math.random() - 0.5) * 50,
        y: node.y || (ty * 150) + (Math.random() - 0.5) * 50,
        vx: 0,
        vy: 0,
      };
    });
  }, [initialNodes]);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let animationId: number;
    let time = 0;

    const runPhysicsAndRender = () => {
      time += 0.03;
      const width = canvas.width;
      const height = canvas.height;
      const cx = width / 2;
      const cy = height / 2;
      const scale = Math.min(width, height) * 0.35; // Rayon de mise à l'échelle

      ctx.fillStyle = '#020205'; // Fond noir d'encre abyssal
      ctx.fillRect(0, 0, width, height);

      const nodes = nodesRef.current;

      // 1. CALCUL DE PHYSIQUE (SIMULATION DE FORCE-CERVEAU)
      // Repulsion entre tous les nœuds
      for (let i = 0; i < nodes.length; i++) {
        for (let j = i + 1; j < nodes.length; j++) {
          const dx = nodes[j].x - nodes[i].x;
          const dy = nodes[j].y - nodes[i].y;
          const dist = Math.sqrt(dx * dx + dy * dy) || 1;
          if (dist < 120) {
            const force = (120 - dist) * 0.05;
            nodes[i].vx -= (dx / dist) * force;
            nodes[i].vy -= (dy / dist) * force;
            nodes[j].vx += (dx / dist) * force;
            nodes[j].vy += (dy / dist) * force;
          }
        }
      }

      // Attraction de liens (Hooke)
      links.forEach((link) => {
        const sourceNode = nodes.find(n => n.id === link.source);
        const targetNode = nodes.find(n => n.id === link.target);
        if (sourceNode && targetNode) {
          const dx = targetNode.x - sourceNode.x;
          const dy = targetNode.y - sourceNode.y;
          const dist = Math.sqrt(dx * dx + dy * dy) || 1;
          const targetLength = 60;
          const force = (dist - targetLength) * 0.015 * link.strength;
          sourceNode.vx += (dx / dist) * force;
          sourceNode.vy += (dy / dist) * force;
          targetNode.vx -= (dx / dist) * force;
          targetNode.vy -= (dy / dist) * force;
        }
      });

      // Attraction d'ancres anatomiques & Respiration biologique
      nodes.forEach((node) => {
        // Position d'ancre cible projetée en pixels
        const ax = node.targetX * scale;
        const ay = node.targetY * scale;

        // Force d'ancrage
        node.vx += (ax - node.x) * node.anchorForce * 0.03;
        node.vy += (ay - node.y) * node.anchorForce * 0.03;

        // Force de respiration synaptique biologique (temps & température du nœud)
        const breatheStrength = 0.15 * (node.temperature / 100);
        const angle = time + parseInt(node.id.slice(0, 4), 16) * 0.01;
        node.vx += Math.cos(angle) * breatheStrength;
        node.vy += Math.sin(angle) * breatheStrength;

        // Mise à jour de la position avec amortissement (friction)
        node.x += node.vx;
        node.y += node.vy;
        node.vx *= 0.85;
        node.vy *= 0.85;
      });

      // 2. RENDU DES LIENS (AXONES)
      links.forEach((link) => {
        const sourceNode = nodes.find(n => n.id === link.source);
        const targetNode = nodes.find(n => n.id === link.target);
        if (sourceNode && targetNode) {
          ctx.beginPath();
          ctx.moveTo(cx + sourceNode.x, cy + sourceNode.y);
          ctx.lineTo(cx + targetNode.x, cy + targetNode.y);
          
          // Liens électriques si très actifs sémantiquement
          if (sourceNode.temperature > 70 && targetNode.temperature > 70) {
            ctx.strokeStyle = `rgba(96, 165, 250, 0.18)`; // Bleu électrique semi-transparent
            ctx.lineWidth = 1.5;
          } else {
            ctx.strokeStyle = `rgba(51, 65, 85, 0.12)`; // Gris axonal discret
            ctx.lineWidth = 0.8;
          }
          ctx.stroke();
        }
      });

      // 3. RENDU DES NŒUDS (CELLULES SYNAPTIQUES)
      nodes.forEach((node) => {
        const nx = cx + node.x;
        const ny = cy + node.y;
        const size = 4 + (node.vitality / 100) * 4; // Taille proportionnelle à la vitalité

        // Halo de lueur sémantique pour les nœuds chauds ou actifs
        if (node.temperature > 60) {
          const gradient = ctx.createRadialGradient(nx, ny, 0, nx, ny, size * 3);
          gradient.addColorStop(0, `rgba(37, 99, 235, 0.3)`); // Bleu électrique
          gradient.addColorStop(1, 'rgba(0, 0, 0, 0)');
          ctx.fillStyle = gradient;
          ctx.beginPath();
          ctx.arc(nx, ny, size * 3, 0, Math.PI * 2);
          ctx.fill();
        }

        ctx.beginPath();
        ctx.arc(nx, ny, size, 0, Math.PI * 2);

        // Charte de couleurs sémantiques épurée
        if (node.isConsolidated) {
          ctx.fillStyle = '#10B981'; // Émeraude consolidée (Apprentissage ancré)
          ctx.shadowColor = '#10B981';
        } else if (node.temperature > 80) {
          ctx.fillStyle = '#60A5FA'; // Bleu électrique actif (Mise à jour chaude)
          ctx.shadowColor = '#60A5FA';
        } else {
          ctx.fillStyle = '#475569'; // Gris sémantique (Froid / En attente)
          ctx.shadowColor = '#475569';
        }
        
        ctx.shadowBlur = node.temperature > 50 ? 8 : 0;
        ctx.fill();
        ctx.shadowBlur = 0; // Reset ombre

        // Rendu des labels uniquement si survol ou si vitalité élevée
        if (node.vitality > 75) {
          ctx.fillStyle = '#94A3B8'; // Blanc/Gris doux
          ctx.font = '9px monospace';
          ctx.textAlign = 'center';
          ctx.fillText(node.label, nx, ny - size - 4);
        }
      });

      animationId = requestAnimationFrame(runPhysicsAndRender);
    };

    runPhysicsAndRender();

    return () => {
      cancelAnimationFrame(animationId);
    };
  }, [links]);

  return (
    <div className="relative w-full h-full bg-[#020205] border border-gray-900 rounded-2xl overflow-hidden shadow-inner">
      <div className="absolute top-4 left-4 z-10">
        <span className="text-[10px] font-bold text-[#60A5FA] tracking-widest uppercase bg-[#0D0D15] px-3 py-1.5 border border-gray-800 rounded-full">
          Graphe Morphogénétique Cérébral v1.0
        </span>
      </div>
      <canvas 
        ref={canvasRef} 
        width={800} 
        height={600} 
        className="w-full h-full block"
      />
    </div>
  );
};
```

---

## 7. Intégration d'État (Northflank & COSMOS Mode 26) {#7-integration}

Ce modèle visuel est câblé directement sur les données physiques stockées dans la base unifiée **Northflank PostgreSQL** :
- Le composant tire sa liste de nœuds de la table `scy_synaptic_vitality`. Le flag `isConsolidated` est activé de manière déterministe si le score de rétention d'APEX (`retention_score`) est supérieur à **90/100**.
- La température et la vitalité sont extraites en temps réel pour piloter les ombres WebGL, les halos de lueurs et le rayon physique des particules synaptiques.
- À mesure que l'utilisateur accumule des connaissances et débloque de nouveaux concepts, les nouveaux nœuds sont injectés dans le Canvas et trouvent instantanément leur place anatomique grâce à la simulation de forces, **faisant "grandir" le cerveau numérique de l'utilisateur sous ses yeux**.

---

## 🏁 Conclusion

L'intégration du modèle mathématique **Force-Cerveau** et de sa charte chromatique premium (Violet profond, Bleu électrique, Émeraude) métamorphose l'affichage du graphe de SCY Forge. Nous offrons à l'utilisateur une **matérialisation plastique vivante de son esprit numérique**, créant une affordance cognitive d'une puissance artistique et fonctionnelle inégalée sur le marché mondial.

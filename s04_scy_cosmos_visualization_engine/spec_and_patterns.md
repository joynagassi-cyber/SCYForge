# Module 4 : COSMOS — 26 Modes of Visualization — ENVIRONNEMENT TECHNIQUE DE CODAGE DE RÉFÉRENCE
**ID Module** : S04_COSMOS_VISUALIZATION_ENGINE  
**Statut de Sûreté** : 🟢 INTÉGRITÉ COGNITIVE ET TECHNIQUE VALIDÉE (ZÉRO INVENTIONS AUTORISÉES)  
**Date d'Émission** : 2026-06-12  

---

## 🧭 Fiche de Synthèse
* **Description Fonctionnelle** : Le moteur de rendu spatial de connaissances.
* **Stack Technique Officielle** : React 18, AntV G6 (v5), Cosmos, Three.js, WebGL
* **Patterns d'Ingénierie à Respecter** : Force-Cerveau 2D/3D (LOD, Verlet, Barnes-Hut, Object Pooling)

---

# 🎨 MODULE 4 : COSMOS — 26 Modes of Visualization — Spécifications de Codage

## 1. Description du Module
Ce module régit la visualisation du savoir en 2D et 3D. 
* **CORRECTION MAJEURE** : La simulation Canvas HTML5 était un outil de validation de laboratoire. Le code de production **DOIT obligatoirement utiliser AntV G6 (v5) / Cosmos** pour la 2D et **Three.js** pour la 3D.

## 2. Articulation Technique du Rendu
- **Coupe Axiale Horizontale (2D)** : Gérée par **AntV G6 (v5)** ou **Cosmos**. Rendu WebGL haute performance de la coupe axiale symétrique divisée par la fissure longitudinale centrale.
- **Volume 3D Matérialisé (3D)** : Géré par **Three.js** intégré dans React 18 (via OrbitControls). Projette la base de connaissances sous forme d'une sphère de particules tridimensionnelle simulant le cortex cérébral et ses lobes.

## 3. Pattern de Rendu de Particules (Three.js 3D Brain Core)
```typescript
// frontend_react/src/components/Brain3DGraph.tsx
import React, { useEffect, useRef } from 'react';
import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';

export const Brain3DGraph: React.FC = () => {
  const mountRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    if (!mountRef.current) return;
    const scene = new THREE.Scene();
    scene.background = new THREE.Color('#020205'); // Noir d'encre

    const camera = new THREE.PerspectiveCamera(75, 1, 0.1, 1000);
    camera.position.z = 2.5;

    const renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(400, 400);
    mountRef.current.appendChild(renderer.domElement);

    // Créer la géométrie de particules Force-Cerveau
    const geometry = new THREE.BufferGeometry();
    const count = 500;
    const positions = new Float32Array(count * 3);

    for (let i = 0; i < count; i++) {
      // Coordonnées cibles selon l'enveloppe 3D déformée du cerveau
      const x = (Math.random() - 0.5) * 1.5;
      const y = (Math.random() - 0.5) * 1.5;
      const z = (Math.random() - 0.5) * 1.5;
      positions[i * 3] = x;
      positions[i * 3 + 1] = y;
      positions[i * 3 + 2] = z;
    }

    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    const material = new THREE.PointsMaterial({ color: '#2563EB', size: 0.05 });
    const points = new THREE.Points(geometry, material);
    scene.add(points);

    const controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;

    const animate = () => {
      requestAnimationFrame(animate);
      controls.update();
      renderer.render(scene, camera);
    };
    animate();

    return () => {
      renderer.dispose();
    };
  }, []);

  return <div ref={mountRef} style={{ width: '400px', height: '400px' }} />;
};
```


---

## 🛑 DIRECTIVES STRICTES CONTRE L'HALLUCINATION (AI DE CODELING)
Pour garantir la réussite absolue du codage de ce module par nos agents de développement :
1. **Ne jamais inventer d'APIs tierces** : Utilise scrupuleusement les bibliothèques et connecteurs listés dans la stack.
2. **Ne pas modifier les structures de données** : Référence-toi à l'index SQL consolidé de la base de données Insforge.
3. **Respecter la palette de couleurs spatiale** : Ne jamais introduire de rouge ou de bleu fade en dehors des tokens d'interface fixés dans `design.md`.
4. **Validation des schémas** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

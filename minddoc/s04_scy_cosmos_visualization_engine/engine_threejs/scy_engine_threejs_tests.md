<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-ENGINE-THREEJS — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_THREEJS_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

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

### 🧪 Test TJ.1 : Rendu Volumétrique (M23)
* **Input** : Coordonnées 3D valides + GPU check OK.
* **Attendu** : Sphères + cylindres + axes rendus à 60 FPS, palette `design.md`.

### 🧪 Test TJ.2 : Fly-To + Knowledge Card
* **Input** : Clic sur une sphère.
* **Attendu** : Animation fly-to + déploiement de la Knowledge Card 3D.

### 🧪 Test TJ.3 : GPU Check Négatif
* **Input** : Appareil sans WebGL2/GPU dédié.
* **Attendu** : M23 masqué ; fallback Mode 2 (Knowledge Graph 2D).

### 🧪 Test TJ.4 : Lazy-Loading
* **Attendu** : three.js (~450KB) absent du bundle initial.

### 🧪 Test TJ.5 : Axes Sémantiques
* **Attendu** : Les 3 axes orthogonaux (Concret↔Abstrait, Théorique↔Pratique, Fondamental↔Avancé) sont visibles.

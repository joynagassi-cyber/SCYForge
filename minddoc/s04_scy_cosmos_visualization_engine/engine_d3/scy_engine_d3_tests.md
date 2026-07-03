<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-ENGINE-D3 — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_D3_TESTS  
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

### 🧪 Test D3.1 : Parallel Coordinates (M15)
* **Input** : Graphe sur 4 axes, brushing sur l'axe Difficulté [7-10].
* **Attendu** : Seules les trajectoires dans l'intervalle restent visibles.

### 🧪 Test D3.2 : Arc Diagram (M20)
* **Attendu** : Les arcs ne dépassent pas les limites du canvas (clamp).

### 🧪 Test D3.3 : Edge Bundling (M21)
* **Input** : > 2 000 nœuds périphériques.
* **Attendu** : Regroupement de branches (LOD 1) activé ; tension réglable.

### 🧪 Test D3.4 : Voronoi (M24)
* **Attendu** : Les cellules de bordure sont clampées au viewport.

### 🧪 Test D3.5 : Thread non bloqué
* **Attendu** : Les calculs géométriques lourds s'exécutent en Web Worker.

### 🧪 Test D3.6 : Lazy-Loading & Palette
* **Attendu** : d3 absent du bundle initial ; aucune couleur hors tokens `design.md`.

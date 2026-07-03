<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-ENGINE-D3 — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_D3_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

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

### 🚀 Tâche D3.1 : Coder le Lazy-Loader + Web Worker géométrique (Durée : 25 min)
* **Description** : Coder `d3_loader.ts` (lazy-import) et `geo_worker.ts` (calculs trajectoires/Voronoi/edge bundling déportés).
* **Fichiers** : `d3_loader.ts`, `workers/geo_worker.ts`
* **Critère de Succès** : d3 hors bundle initial ; calculs en worker sans bloquer le thread.

### 🚀 Tâche D3.2 : Coder Parallel Coordinates M15 (Durée : 30 min)
* **Description** : Coder M15 (axes parallèles + brushing interactif filtrant les concepts).
* **Fichier** : `frontend_react/src/cosmos/modes/`
* **Critère de Succès** : Le brushing filtre les concepts hors intervalle (opacity 0.05).

### 🚀 Tâche D3.3 : Coder Arc M20 + Edge Bundling M21 (Durée : 30 min)
* **Description** : Coder M20 (arcs clampés) et M21 (faisceaux tension réglable + LOD > 2000).
* **Fichier** : `frontend_react/src/cosmos/modes/`
* **Critère de Succès** : Arcs clampés ; M21 bascule en regroupement au-delà de 2000 nœuds.

### 🚀 Tâche D3.4 : Coder Voronoi M24 (Durée : 25 min)
* **Description** : Coder M24 via `d3-delaunay` avec coordonnées de bordure clampées au viewport.
* **Fichier** : `frontend_react/src/cosmos/modes/`
* **Critère de Succès** : Cellules Voronoi clampées au viewport.

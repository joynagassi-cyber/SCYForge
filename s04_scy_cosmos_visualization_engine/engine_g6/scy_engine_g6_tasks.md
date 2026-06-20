# 📋 SCY-ENGINE-G6 — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_G6_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche G6.1 : Coder le Composant CosmosGraph2D (Durée : 25 min)
* **Description** : Coder le composant React `CosmosGraph2D.tsx` initialisant un Graph AntV G6 v5 (renderer WebGL) consommant les données COSMOS et l'événement `KnowledgeGraphUpdated`.
* **Fichier** : `frontend_react/src/components/CosmosGraph2D.tsx`
* **Critère de Succès** : Un graphe COSMOS s'affiche en 2D avec la palette `design.md`.

### 🚀 Tâche G6.2 : Coder le Layout Force-Directed Axial (Durée : 25 min)
* **Description** : Configurer le layout force-directed respectant l'enveloppe axiale polaire (coupe axiale horizontale symétrique).
* **Fichier** : `frontend_react/src/cosmos/g6_layout.ts`
* **Critère de Succès** : La disposition respecte la symétrie axiale de COSMOS.

### 🚀 Tâche G6.3 : Coder les Optimisations Perf (Durée : 25 min)
* **Description** : Implémenter LOD, Barnes-Hut et Object Pooling pour maintenir ≥ 30 FPS sur les grands graphes.
* **Fichier** : `frontend_react/src/cosmos/g6_perf.ts`
* **Critère de Succès** : 5 000 nœuds rendus à ≥ 30 FPS.

### 🚀 Tâche G6.4 : Coder l'Interactivité + Validation Zod (Durée : 20 min)
* **Description** : Coder les contrôles zoom/pan/sélection (détail nœud) et la validation Zod des données graphe avant rendu.
* **Fichier** : `frontend_react/src/components/CosmosGraph2D.tsx`
* **Critère de Succès** : Navigation fluide ; données invalides rejetées.

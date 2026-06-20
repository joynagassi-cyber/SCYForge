# 📋 SCY-ENGINE-REACT-FLOW — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_REACT_FLOW_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche RF.1 : Coder le Composant AscentRoadmap (Durée : 25 min)
* **Description** : Coder `AscentRoadmap.tsx` (React Flow) consommant le DAG ASCENT et les événements `DagBuilt`/`NodeCompleted`/`NodeUnlocked`.
* **Fichier** : `frontend_react/src/components/AscentRoadmap.tsx`
* **Critère de Succès** : Le DAG s'affiche ; les événements mettent à jour les statuts en temps réel.

### 🚀 Tâche RF.2 : Coder le Layout Dagre (Durée : 20 min)
* **Description** : Coder le layout dirigé dagre (ordre topologique respectant les prérequis).
* **Fichier** : `frontend_react/src/cosmos/dagre_layout.ts`
* **Critère de Succès** : L'ordre topologique est respecté visuellement.

### 🚀 Tâche RF.3 : Coder les Nœuds Personnalisés + Styles (Durée : 25 min)
* **Description** : Coder les nœuds personnalisés par statut (tokens `design.md`) et la mise en évidence des chemins critiques/goulots.
* **Fichier** : `frontend_react/src/cosmos/reactflow_nodes.tsx`
* **Critère de Succès** : Styles distincts par statut ; goulots visibles ; aucune couleur hors tokens.

### 🚀 Tâche RF.4 : Coder l'Interactivité (Durée : 15 min)
* **Description** : Coder zoom/pan/mini-map et la sélection de nœud affichant son détail (cible SMI, effort, sources).
* **Fichier** : `frontend_react/src/components/AscentRoadmap.tsx`
* **Critère de Succès** : Navigation fluide ; détail du nœud affiché.

# 📋 SCY-ENGINE-COSMOGRAPH — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_COSMOGRAPH_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche CG.1 : Coder le Sélecteur de Moteur (Durée : 20 min)
* **Description** : Coder `engineSelector` basculant vers engine_cosmograph quand la taille du graphe dépasse le seuil d'engine_g6.
* **Fichier** : `frontend_react/src/cosmos/engine_selector.ts`
* **Critère de Succès** : Un graphe > seuil sélectionne cosmograph ; cohérence visuelle conservée.

### 🚀 Tâche CG.2 : Coder le Composant CosmosGraphMassive (Durée : 30 min)
* **Description** : Coder le composant React `CosmosGraphMassive.tsx` utilisant Cosmograph (simulation GPU force-directed + rendu WebGL).
* **Fichier** : `frontend_react/src/components/CosmosGraphMassive.tsx`
* **Critère de Succès** : 100 000 nœuds rendus à ≥ 30 FPS.

### 🚀 Tâche CG.3 : Coder la Configuration GPU + Clusters (Durée : 25 min)
* **Description** : Configurer la simulation GPU, la mise en évidence des clusters/communautés et le zoom révélant les structures locales.
* **Fichier** : `frontend_react/src/cosmos/cosmograph_config.ts`
* **Critère de Succès** : Le zoom révèle les clusters locaux ; les communautés sont visibles à l'échelle globale.

# 📋 SCY-ENGINE-NIVO — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_NIVO_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche NV.1 : Coder le Lazy-Loader nivo (Durée : 20 min)
* **Description** : Coder `nivo_loader.ts` avec imports dynamiques des 4 modules nivo (chunks indépendants, hors bundle initial).
* **Fichier** : `frontend_react/src/cosmos/engines/nivo_loader.ts`
* **Critère de Succès** : Les modules sont chargés à la demande ; le bundle initial n'inclut pas nivo.

### 🚀 Tâche NV.2 : Coder Chord M12 + Sankey M13 (Durée : 30 min)
* **Description** : Coder les composants M12 (Chord, matrice ≤ 200) et M13 (Sankey, flux < 2% masqués) avec interactions survol.
* **Fichier** : `frontend_react/src/cosmos/modes/`
* **Critère de Succès** : M12 rend les rubans et met en valeur au survol ; M13 masque les flux mineurs.

### 🚀 Tâche NV.3 : Coder Heatmap M16 + Circle Packing M19 (Durée : 30 min)
* **Description** : Coder M16 (Heatmap, `⚠️` si similarité > 0.95) et M19 (Circle Packing, bulles < 5px masquées).
* **Fichier** : `frontend_react/src/cosmos/modes/`
* **Critère de Succès** : M16 affiche l'alerte de redondance ; M19 masque les sous-bulles trop petites.

### 🚀 Tâche NV.4 : Coder les Limites Tiers + Fallback (Durée : 20 min)
* **Description** : Coder l'application des limites de nœuds (Chord ≤ 150/200) et le fallback liste simplifiée sur LOW/COMPAT.
* **Fichier** : `frontend_react/src/cosmos/engines/nivo_loader.ts`
* **Critère de Succès** : Les limites sont appliquées ; le fallback s'active sur appareil faible.

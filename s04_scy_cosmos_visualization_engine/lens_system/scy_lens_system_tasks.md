# 📋 SCY-LENS-SYSTEM — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_LENS_SYSTEM_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche LS.1 : Coder l'Orchestrateur de Lentilles (Durée : 25 min)
* **Description** : Coder `lensSystem.ts` (activation/combinaison/réversibilité des lentilles, architecture extensible).
* **Fichier** : `frontend_react/src/cosmos/lens_system.ts`
* **Critère de Succès** : Plusieurs lentilles combinables ; réversibilité ; architecture extensible.

### 🚀 Tâche LS.2 : Coder les Lentilles Filtrage + Mise en Évidence (Durée : 25 min)
* **Description** : Coder `filter_lens.ts` (filtrage type/SMI/domaine) et `highlight_lens.ts` (révélation des relations d'un concept, atténuation du reste).
* **Fichier** : `frontend_react/src/cosmos/lenses/`
* **Critère de Succès** : Le filtrage masque correctement ; la mise en évidence révèle les relations.

### 🚀 Tâche LS.3 : Coder la Lentille de Similarité (Durée : 20 min)
* **Description** : Coder `similarity_lens.ts` (regroupement des concepts proches via embeddings Zilliz).
* **Fichier** : `frontend_react/src/cosmos/lenses/similarity_lens.ts`
* **Critère de Succès** : Les concepts sémantiquement proches sont mis en évidence.

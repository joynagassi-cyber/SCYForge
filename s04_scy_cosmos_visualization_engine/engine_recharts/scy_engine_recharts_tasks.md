# 📋 SCY-ENGINE-RECHARTS — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_RECHARTS_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche RC.1 : Coder Statistics M7 + Circuit Breaker (Durée : 30 min)
* **Description** : Coder M7 (barres/courbes/nuages recharts consommant DuckDB-WASM), clic sur point filtrant les concepts, et circuit breaker (> 5s → fallback statique).
* **Fichier** : `frontend_react/src/cosmos/modes/`
* **Critère de Succès** : Clic filtre les concepts ; agrégation > 5s → fallback neutre.

### 🚀 Tâche RC.2 : Coder Radar M14 (Durée : 25 min)
* **Description** : Coder M14 (polygone bleu profil + polygone cible pointillés, 5 axes SMI), clic sur sommet ouvrant les concepts responsables, valeurs bornées [0,100].
* **Fichier** : `frontend_react/src/cosmos/modes/`
* **Critère de Succès** : Polygones superposés ; clic sommet fonctionnel ; bornes respectées.

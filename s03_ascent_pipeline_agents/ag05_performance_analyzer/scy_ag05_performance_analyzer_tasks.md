# 📋 SCY-AG05-PERFORMANCE-ANALYZER — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG05_PERFORMANCE_ANALYZER_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche 5.1 : Coder le Calcul SMI Multi-Dimensionnel (Durée : 25 min)
* **Description** : Coder `smiCalculator` (rétention FSRS + application + profondeur) selon les formules du moteur `s11`.
* **Fichier** : `backend_ts/src/ascent/smi/smi_calculator.ts`
* **Critère de Succès** : Un signal de révision produit un SMI cohérent borné [0, 100].

### 🚀 Tâche 5.2 : Coder l'Ingestion des Signaux + Persistance (Durée : 20 min)
* **Description** : Coder l'écoute des événements (`CardReviewed`, `ExerciseCompleted`, ARENA) et la persistance du SMI dans `mfg_ascent_nodes`.
* **Fichier** : `backend_ts/src/ascent/agents/ag05_performance_analyzer.ts`
* **Critère de Succès** : Chaque signal déclenche un recalcul persisté.

### 🚀 Tâche 5.3 : Coder la Détection de Seuil + EventBus (Durée : 15 min)
* **Description** : Coder la détection du seuil cible et l'émission de `NodeCompleted`.
* **Fichier** : `backend_ts/src/ascent/agents/ag05_performance_analyzer.ts`
* **Critère de Succès** : Un SMI ≥ seuil émet `NodeCompleted`.

### 🚀 Tâche 5.4 : Coder l'Agrégation + Export Parquet (Durée : 25 min)
* **Description** : Coder la mise à jour de `mv_user_smi_summary` (Polars/DuckDB) et l'export Parquet pour analytics.
* **Fichier** : `backend_ts/src/ascent/agents/ag05_performance_analyzer.ts`
* **Critère de Succès** : Le SMI agrégé est correct ; l'export Parquet est généré.

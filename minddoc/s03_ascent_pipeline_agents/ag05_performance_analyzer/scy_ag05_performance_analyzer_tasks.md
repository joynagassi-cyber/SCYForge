<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-AG05-PERFORMANCE-ANALYZER — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG05_PERFORMANCE_ANALYZER_TASKS  
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

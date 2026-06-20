# 📋 SCY-AG13-COGNITIVE-VALIDATOR — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG13_COGNITIVE_VALIDATOR_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche 13.1 : Coder la Couche 1 (Traçabilité Source) (Durée : 25 min)
* **Description** : Coder `sourceTraceability` vérifiant que chaque assertion est reliée à une source ingérée.
* **Fichier** : `backend_ts/src/ascent/validation/source_traceability.ts`
* **Critère de Succès** : Une assertion sans source est détectée et marquée.

### 🚀 Tâche 13.2 : Coder la Couche 2 (Cohérence Interne) (Durée : 20 min)
* **Description** : Coder `coherenceCheck` détectant les contradictions logiques internes via LLM (BudgetGuard).
* **Fichier** : `backend_ts/src/ascent/validation/coherence_check.ts`
* **Critère de Succès** : Une contradiction interne est détectée.

### 🚀 Tâche 13.3 : Coder la Couche 3 (Vérification Externe) (Durée : 20 min)
* **Description** : Coder `externalCheck` recoupant les faits vérifiables sur le référentiel COSMOS / sources.
* **Fichier** : `backend_ts/src/ascent/validation/external_check.ts`
* **Critère de Succès** : Un fait non recoupé est signalé.

### 🚀 Tâche 13.4 : Coder le Score + Gate + Rapport (Durée : 25 min)
* **Description** : Coder `confidenceScorer` (score par section, taux d'hallucination), la gate bloquante (seuil global), le verdict Zod, et la génération/journalisation du rapport de confiance.
* **Fichier** : `backend_ts/src/ascent/validation/confidence_scorer.ts`
* **Critère de Succès** : Une section < seuil est bloquée ; un document < seuil global n'est pas présenté ; un rapport est généré.

# 📋 SCY-AG07-DRIFT-GUARDIAN — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG07_DRIFT_GUARDIAN_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche 7.1 : Coder l'Évaluation des 8 Signaux (Durée : 30 min)
* **Description** : Coder `signalEvaluator` (inactivité, déclin SMI, sauts prérequis, baisse fréquence, échecs répétés, fatigue, désengagement COSMOS, feedback négatif) avec seuils mesurés.
* **Fichier** : `backend_ts/src/ascent/drift/signal_evaluator.ts`
* **Critère de Succès** : Un signal franchissant son seuil est détecté ; un seuil non franchi n'alerte pas.

### 🚀 Tâche 7.2 : Coder le Score Consolidé + Émission EventBus (Durée : 20 min)
* **Description** : Coder l'agrégation des 8 signaux en score de risque et l'émission de `DriftDetected` validé par Zod.
* **Fichier** : `backend_ts/src/ascent/agents/ag07_drift_guardian.ts`
* **Critère de Succès** : Le score consolidé reflète les signaux actifs.

### 🚀 Tâche 7.3 : Coder les Actions de Ré-Engagement + Anti-spam (Durée : 25 min)
* **Description** : Coder le déclenchement d'actions proportionnées (CHRONICLE, AGENT-08, AGENT-06) personnalisées par type de signal, avec limitation de fréquence.
* **Fichier** : `backend_ts/src/ascent/agents/ag07_drift_guardian.ts`
* **Critère de Succès** : L'action correspond au signal ; la fréquence est limitée.

### 🚀 Tâche 7.4 : Coder l'Écoute DLQ (Durée : 15 min)
* **Description** : Coder l'abonnement à la Dead Letter Queue pour la notification des erreurs système.
* **Fichier** : `backend_ts/src/ascent/agents/ag07_drift_guardian.ts`
* **Critère de Succès** : Un événement en DLQ notifie l'Agent-07.

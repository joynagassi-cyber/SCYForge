# 📋 SCY-AG09-SKILL-CERTIFIER — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG09_SKILL_CERTIFIER_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche 9.1 : Coder l'Évaluation Théorique (Durée : 25 min)
* **Description** : Coder la vérification du SMI global ≥ seuil (AGENT-05) et l'administration de l'examen SurveyJS avec score ≥ seuil.
* **Fichier** : `backend_ts/src/ascent/agents/ag09_skill_certifier.ts`
* **Critère de Succès** : SMI + examen réussis → composante théorique validée ; échec → blocage.

### 🚀 Tâche 9.2 : Coder l'Évaluation Pratique ARENA (Durée : 20 min)
* **Description** : Coder le déclenchement de la simulation ARENA (AGENT-11) et l'exigence de performance ≥ seuil.
* **Fichier** : `backend_ts/src/ascent/agents/ag09_skill_certifier.ts`
* **Critère de Succès** : Simulation réussie → composante pratique validée ; échec → blocage.

### 🚀 Tâche 9.3 : Coder la Génération + Signature du Certificat (Durée : 25 min)
* **Description** : Coder `certificateGenerator` (Proof of Skill SMI global + dimensions) et la signature par hash vérifiable, validé par `CertificateSchema`.
* **Fichier** : `backend_ts/src/ascent/cert/certificate_generator.ts`
* **Critère de Succès** : Les deux composantes validées → certificat signé persisté dans `mfg_certificates`.

### 🚀 Tâche 9.4 : Coder l'Export + EventBus (Durée : 15 min)
* **Description** : Coder l'export PDF/partage et l'émission de `GoalCompleted`.
* **Fichier** : `backend_ts/src/ascent/agents/ag09_skill_certifier.ts`
* **Critère de Succès** : Le certificat est exportable ; `GoalCompleted` émis.

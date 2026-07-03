<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-AG09-SKILL-CERTIFIER — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG09_SKILL_CERTIFIER_TASKS  
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

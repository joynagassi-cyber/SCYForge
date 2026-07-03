<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-AG13-COGNITIVE-VALIDATOR — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG13_COGNITIVE_VALIDATOR_TASKS  
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

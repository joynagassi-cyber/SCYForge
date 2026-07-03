<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-AG06-ADAPTIVE-ROUTER — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG06_ADAPTIVE_ROUTER_TASKS  
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

### 🚀 Tâche 6.1 : Coder l'Ajustement Difficulté/Pacing (Durée : 25 min)
* **Description** : Coder `difficultyAdjuster` (hausse/simplification selon SMI, ajustement du pacing).
* **Fichier** : `backend_ts/src/ascent/router/difficulty_adjuster.ts`
* **Critère de Succès** : Un SMI élevé augmente la difficulté ; un SMI faible la simplifie.

### 🚀 Tâche 6.2 : Coder le Traitement des Goulots (Durée : 20 min)
* **Description** : Coder la priorisation du renforcement (exos/IMPRINT) sur les nœuds goulots et la régénération NEURON-CHAINS si SMI stagne.
* **Fichier** : `backend_ts/src/ascent/agents/ag06_adaptive_router.ts`
* **Critère de Succès** : Un nœud goulot reçoit un renforcement prioritaire.

### 🚀 Tâche 6.3 : Coder le Routage Modèle + Validation Zod (Durée : 20 min)
* **Description** : Coder la sélection du modèle via LlmRouter (léger/avancé selon complexité, BudgetGuard) et la validation des décisions par `RoutingDecisionSchema`.
* **Fichier** : `backend_ts/src/ascent/agents/ag06_adaptive_router.ts`
* **Critère de Succès** : Tâche simple → modèle léger ; tâche complexe → modèle avancé ; BudgetGuard respecté.

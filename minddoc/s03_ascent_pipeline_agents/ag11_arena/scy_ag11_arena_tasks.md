<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag11_arena DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-AG11-ARENA — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG11_ARENA_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

### 🚀 Tâche 11.1 : Coder la Génération de Scénario + Grille (Durée : 30 min)
* **Description** : Coder `scenarioGenerator` (contexte, rôles, objectifs, grille d'évaluation mesurable) via LLM (BudgetGuard), validé par `ScenarioSchema`.
* **Fichier** : `backend_ts/src/ascent/arena/scenario_generator.ts`
* **Critère de Succès** : Un domaine produit un scénario réaliste avec grille d'évaluation complète.

### 🚀 Tâche 11.2 : Coder les Agents-Rôles (Durée : 25 min)
* **Description** : Coder `roleAgent` (réponses contextualisées au rôle, cohérence multi-tours) via LLM avec BudgetGuard.
* **Fichier** : `backend_ts/src/ascent/arena/role_agent.ts`
* **Critère de Succès** : Les agents-rôles répondent de façon cohérente et contextualisée sur plusieurs tours.

### 🚀 Tâche 11.3 : Coder l'Évaluateur + Feedback (Durée : 25 min)
* **Description** : Coder `evaluator` (scoring selon grille + feedback points forts/axes d'amélioration), validé par `ArenaScoreSchema`.
* **Fichier** : `backend_ts/src/ascent/arena/evaluator.ts`
* **Critère de Succès** : Une session terminée produit un score pratique + feedback ciblé.

### 🚀 Tâche 11.4 : Coder l'Intégration AGENT-13 + AGENT-09 (Durée : 20 min)
* **Description** : Coder la validation du scénario par AGENT-13 (régénération si échec) et la remontée du score vers AGENT-09 (validation composante pratique).
* **Fichier** : `backend_ts/src/ascent/agents/ag11_arena.ts`
* **Critère de Succès** : Scénario non validé → régénération ; score ≥ seuil → composante pratique validée.

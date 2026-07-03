<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-AG03-DAG-ARCHITECT — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG03_DAG_ARCHITECT_TASKS  
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

### 🚀 Tâche 3.1 : Coder le Schéma Zod du DAG (Durée : 20 min)
* **Description** : Définir `DagSchema` (nœuds[], arêtes[], métadonnées) avec validation stricte.
* **Fichier** : `backend_ts/src/ascent/schemas/dag_schema.ts`
* **Critère de Succès** : Un DAG valide passe ; un DAG malformé est rejeté.

### 🚀 Tâche 3.2 : Coder la Décomposition LLM + COSMOS (Durée : 25 min)
* **Description** : Coder la décomposition de l'objectif en nœuds via LLM (BudgetGuard) et la consultation des prérequis canoniques dans COSMOS.
* **Fichier** : `backend_ts/src/ascent/agents/ag03_dag_architect.ts`
* **Critère de Succès** : Un objectif produit une liste de nœuds avec arêtes fondées sur COSMOS.

### 🚀 Tâche 3.3 : Coder Ordre Topologique + Détection de Cycles (Durée : 25 min)
* **Description** : Implémenter l'ordre topologique (Kahn), la détection de cycles (DFS) et le rejet en cas de cycle.
* **Fichier** : `backend_ts/src/ascent/graph/topo_sort.ts`
* **Critère de Succès** : L'ordre respecte les dépendances ; un cycle simulé est rejeté.

### 🚀 Tâche 3.4 : Coder la Détection de Goulots + Personnalisation (Durée : 20 min)
* **Description** : Implémenter la détection des goulots (degré entrant élevé) et la personnalisation (nœuds SMI ≥ seuil marqués acquis).
* **Fichier** : `backend_ts/src/ascent/agents/ag03_dag_architect.ts`
* **Critère de Succès** : Les goulots sont signalés ; les nœuds acquis sont marqués.

### 🚀 Tâche 3.5 : Coder la Persistance + EventBus (Durée : 15 min)
* **Description** : Coder l'écriture dans `mfg_ascent_nodes`/`mfg_ascent_edges` et l'émission de `DagBuilt`.
* **Fichier** : `backend_ts/src/ascent/agents/ag03_dag_architect.ts`
* **Critère de Succès** : Le DAG est persisté et l'événement `DagBuilt` est publié.

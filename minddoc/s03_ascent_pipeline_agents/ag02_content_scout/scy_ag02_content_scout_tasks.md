<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-AG02-CONTENT-SCOUT — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG02_CONTENT_SCOUT_TASKS  
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

### 🚀 Tâche 2.1 : Coder la Vérification du Cache Mutualisé (Durée : 20 min)
* **Description** : Implémenter la recherche prioritaire dans `mfg_shared_content_cache` par similarité sémantique (embeddings Zilliz) pour réutiliser les sources existantes.
* **Fichier** : `backend_ts/src/ascent/agents/ag02_content_scout.ts`
* **Critère de Succès** : Un nœud avec source en cache renvoie un hit ($0) sans ré-ingestion.

### 🚀 Tâche 2.2 : Coder la Découverte Multi-Core (Durée : 25 min)
* **Description** : Implémenter le requêtage des cores d'ingestion pertinents pour un nœud et l'enqueue asynchrone des sources nouvelles.
* **Fichier** : `backend_ts/src/ascent/agents/ag02_content_scout.ts`
* **Critère de Succès** : Au moins un core pertinent renvoie des candidats réels.

### 🚀 Tâche 2.3 : Coder le Scoring + Classement Zod (Durée : 25 min)
* **Description** : Implémenter le scoring (pertinence embeddings + qualité + coût) et la production d'une liste ordonnée validée par `SourceListSchema`.
* **Fichier** : `backend_ts/src/ascent/scoring/source_scorer.ts`
* **Critère de Succès** : Les sources sont ordonnées et validées par Zod.

### 🚀 Tâche 2.4 : Coder la Gestion des Échecs (Durée : 20 min)
* **Description** : Implémenter l'écoute de `IngestionFailed`, la rétrogradation et le repli sur la source suivante, garantissant au moins une source valide.
* **Fichier** : `backend_ts/src/ascent/agents/ag02_content_scout.ts`
* **Critère de Succès** : Une source défaillante est remplacée sans blocage du nœud.

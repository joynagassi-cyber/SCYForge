<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG03-DAG-ARCHITECT — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG03_DAG_ARCHITECT_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

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

### 🧪 Test 3.1 : Décomposition en Nœuds (Happy Path)
* **Input** : Objectif « React ».
* **Exécution** : `dagArchitectStep(goal)`.
* **Attendu** : DAG valide (nœuds + arêtes), validé par `DagSchema`.

### 🧪 Test 3.2 : Acyclicité Garantie
* **Pré-conditions** : Graphe construit.
* **Attendu** : Aucun cycle détecté (DFS) ; ordre topologique valide.

### 🧪 Test 3.3 : Ordre Topologique Correct
* **Attendu** : Pour toute arête A→B, A précède B dans l'ordre topologique.

### 🧪 Test 3.4 : Personnalisation par SMI
* **Pré-conditions** : Utilisateur avec nœuds au SMI ≥ seuil.
* **Attendu** : Ces nœuds sont marqués `acquired` et exclus du parcours actif.

### 🧪 Test 3.5 : Détection de Goulot Cognitif
* **Attendu** : Un nœud à forte dépendance entrante est signalé pour l'ADAPTIVE-ROUTER.

### 🧪 Test 3.6 : Rejet d'un Cycle
* **Pré-conditions** : Dépendances formant un cycle (cas extrême).
* **Attendu** : Le système rejette avec une erreur typée (pas de propagation d'un graphe invalide).

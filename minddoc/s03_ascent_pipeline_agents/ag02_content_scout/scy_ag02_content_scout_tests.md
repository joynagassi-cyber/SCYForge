<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG02-CONTENT-SCOUT — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG02_CONTENT_SCOUT_TESTS  
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

### 🧪 Test 2.1 : Découverte Multi-Core (Happy Path)
* **Input** : Nœud « Hooks React ».
* **Exécution** : `contentScoutStep(node)`.
* **Attendu** : Au moins une source pertinente est sélectionnée parmi les cores réels.

### 🧪 Test 2.2 : Réutilisation du Cache ($0)
* **Pré-conditions** : Source déjà dans `mfg_shared_content_cache`.
* **Input** : Nœud correspondant.
* **Attendu** : Cache hit, aucune ré-ingestion, coût $0.

### 🧪 Test 2.3 : Classement par Score
* **Input** : Plusieurs candidats.
* **Attendu** : Liste ordonnée par pertinence/qualité/coût, validée par `SourceListSchema`.

### 🧪 Test 2.4 : Résilience (Échec d'Ingestion)
* **Pré-conditions** : Une source défaillante.
* **Attendu** : Rétrogradation + repli sur la suivante ; au moins une source valide retenue.

### 🧪 Test 2.5 : Respect du Budget
* **Attendu** : La découverte ne dépasse pas le BudgetGuard ; coût journalisé Langfuse.

### 🧪 Test 2.6 : Aucune Source Inventée
* **Attendu** : Aucune URL/source non retournée par un core réel n'apparaît dans la sélection.

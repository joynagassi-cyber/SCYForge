<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG06-ADAPTIVE-ROUTER — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG06_ADAPTIVE_ROUTER_TESTS  
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

### 🧪 Test 6.1 : Ajustement de Difficulté
* **Input** : SMI élevé vs SMI faible.
* **Attendu** : Difficulté augmentée / simplifiée en conséquence ; pacing ajusté.

### 🧪 Test 6.2 : Renforcement de Goulot
* **Pré-conditions** : Nœud signalé comme goulot (AGENT-03).
* **Attendu** : Renforcement prioritaire (exos/IMPRINT) ; régénération si SMI stagne.

### 🧪 Test 6.3 : Routage de Modèle
* **Input** : Tâche simple vs tâche complexe.
* **Attendu** : Modèle léger / avancé sélectionné via LlmRouter.

### 🧪 Test 6.4 : Respect du Budget
* **Attendu** : Aucune décision de routage ne dépasse le BudgetGuard.

### 🧪 Test 6.5 : Justification Chiffrée
* **Attendu** : Chaque régénération/ajustement est justifié par un signal mesuré (SMI, drift, goulot).

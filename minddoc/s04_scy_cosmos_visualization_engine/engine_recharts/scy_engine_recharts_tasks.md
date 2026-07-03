<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-ENGINE-RECHARTS — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_RECHARTS_TASKS  
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

### 🚀 Tâche RC.1 : Coder Statistics M7 + Circuit Breaker (Durée : 30 min)
* **Description** : Coder M7 (barres/courbes/nuages recharts consommant DuckDB-WASM), clic sur point filtrant les concepts, et circuit breaker (> 5s → fallback statique).
* **Fichier** : `frontend_react/src/cosmos/modes/`
* **Critère de Succès** : Clic filtre les concepts ; agrégation > 5s → fallback neutre.

### 🚀 Tâche RC.2 : Coder Radar M14 (Durée : 25 min)
* **Description** : Coder M14 (polygone bleu profil + polygone cible pointillés, 5 axes SMI), clic sur sommet ouvrant les concepts responsables, valeurs bornées [0,100].
* **Fichier** : `frontend_react/src/cosmos/modes/`
* **Critère de Succès** : Polygones superposés ; clic sommet fonctionnel ; bornes respectées.

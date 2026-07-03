<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-LENS-SYSTEM — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_LENS_SYSTEM_TASKS  
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

### 🚀 Tâche LS.1 : Coder l'Orchestrateur de Lentilles (Durée : 25 min)
* **Description** : Coder `lensSystem.ts` (activation/combinaison/réversibilité des lentilles, architecture extensible).
* **Fichier** : `frontend_react/src/cosmos/lens_system.ts`
* **Critère de Succès** : Plusieurs lentilles combinables ; réversibilité ; architecture extensible.

### 🚀 Tâche LS.2 : Coder les Lentilles Filtrage + Mise en Évidence (Durée : 25 min)
* **Description** : Coder `filter_lens.ts` (filtrage type/SMI/domaine) et `highlight_lens.ts` (révélation des relations d'un concept, atténuation du reste).
* **Fichier** : `frontend_react/src/cosmos/lenses/`
* **Critère de Succès** : Le filtrage masque correctement ; la mise en évidence révèle les relations.

### 🚀 Tâche LS.3 : Coder la Lentille de Similarité (Durée : 20 min)
* **Description** : Coder `similarity_lens.ts` (regroupement des concepts proches via embeddings Zilliz).
* **Fichier** : `frontend_react/src/cosmos/lenses/similarity_lens.ts`
* **Critère de Succès** : Les concepts sémantiquement proches sont mis en évidence.

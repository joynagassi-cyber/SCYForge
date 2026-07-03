<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-ENGINE-STATISTICAL — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_STATISTICAL_TASKS  
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

### 🚀 Tâche ST.1 : Coder la Heatmap de Corrélations (Durée : 25 min)
* **Description** : Coder `StatHeatmap.tsx` (G2) consommant `mv_concept_correlations`.
* **Fichier** : `frontend_react/src/components/StatHeatmap.tsx`
* **Critère de Succès** : La heatmap reflète les corrélations réelles.

### 🚀 Tâche ST.2 : Coder le Sankey des Trajectoires (Durée : 25 min)
* **Description** : Coder `StatSankey.tsx` (G2) consommant `mv_learning_trajectories`.
* **Fichier** : `frontend_react/src/components/StatSankey.tsx`
* **Critère de Succès** : Le Sankey montre les flux entre nœuds/états.

### 🚀 Tâche ST.3 : Coder la Distribution SMI (Durée : 20 min)
* **Description** : Coder `StatDistribution.tsx` (histogramme/boxplot) consommant `mv_user_smi_summary`.
* **Fichier** : `frontend_react/src/components/StatDistribution.tsx`
* **Critère de Succès** : La distribution reflète les données SMI agrégées.

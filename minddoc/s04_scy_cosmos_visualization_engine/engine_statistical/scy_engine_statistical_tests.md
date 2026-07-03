<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-ENGINE-STATISTICAL — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_STATISTICAL_TESTS  
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

### 🧪 Test ST.1 : Heatmap de Corrélations
* **Attendu** : La heatmap reflète `mv_concept_correlations`.

### 🧪 Test ST.2 : Sankey des Trajectoires
* **Attendu** : Le Sankey reflète `mv_learning_trajectories`.

### 🧪 Test ST.3 : Distribution SMI
* **Attendu** : La distribution reflète `mv_user_smi_summary`.

### 🧪 Test ST.4 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

### 🧪 Test ST.5 : Aucune Donnée Inventée
* **Attendu** : Les visualisations ne contiennent que des données issues des vues matérialisées.

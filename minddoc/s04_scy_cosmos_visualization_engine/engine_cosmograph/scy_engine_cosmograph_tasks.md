<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-ENGINE-COSMOGRAPH — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_COSMOGRAPH_TASKS  
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

### 🚀 Tâche CG.1 : Coder le Sélecteur de Moteur (Durée : 20 min)
* **Description** : Coder `engineSelector` basculant vers engine_cosmograph quand la taille du graphe dépasse le seuil d'engine_g6.
* **Fichier** : `frontend_react/src/cosmos/engine_selector.ts`
* **Critère de Succès** : Un graphe > seuil sélectionne cosmograph ; cohérence visuelle conservée.

### 🚀 Tâche CG.2 : Coder le Composant CosmosGraphMassive (Durée : 30 min)
* **Description** : Coder le composant React `CosmosGraphMassive.tsx` utilisant Cosmograph (simulation GPU force-directed + rendu WebGL).
* **Fichier** : `frontend_react/src/components/CosmosGraphMassive.tsx`
* **Critère de Succès** : 100 000 nœuds rendus à ≥ 30 FPS.

### 🚀 Tâche CG.3 : Coder la Configuration GPU + Clusters (Durée : 25 min)
* **Description** : Configurer la simulation GPU, la mise en évidence des clusters/communautés et le zoom révélant les structures locales.
* **Fichier** : `frontend_react/src/cosmos/cosmograph_config.ts`
* **Critère de Succès** : Le zoom révèle les clusters locaux ; les communautés sont visibles à l'échelle globale.

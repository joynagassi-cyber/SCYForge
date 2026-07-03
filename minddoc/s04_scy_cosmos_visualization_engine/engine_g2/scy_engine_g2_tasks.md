<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-ENGINE-G2 — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_G2_TASKS  
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

### 🚀 Tâche G2.1 : Coder le Composant MetricChart (Durée : 25 min)
* **Description** : Coder `MetricChart.tsx` (AntV G2 v5) affichant barres/lignes/jauges des indicateurs (XP, streak, SMI).
* **Fichier** : `frontend_react/src/components/MetricChart.tsx`
* **Critère de Succès** : Les indicateurs s'affichent avec la palette `design.md`.

### 🚀 Tâche G2.2 : Coder le Rafraîchissement Temps Réel (Durée : 20 min)
* **Description** : Coder la mise à jour des graphiques sur changement de données (EventBus) sans rechargement complet.
* **Fichier** : `frontend_react/src/cosmos/g2_charts.ts`
* **Critère de Succès** : Les graphiques se rafraîchissent avec animation fluide.

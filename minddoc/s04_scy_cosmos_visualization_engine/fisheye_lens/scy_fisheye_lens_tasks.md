<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-FISHEYE-LENS — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_FISHEYE_LENS_TASKS  
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

### 🚀 Tâche FL.1 : Coder la Distorsion Focus+Context (Durée : 25 min)
* **Description** : Coder la transformation fisheye (distorsion radiale) via plugin G6 ou custom, agrandissant le focus et compressant le contexte.
* **Fichier** : `frontend_react/src/cosmos/fisheye_lens.ts`
* **Critère de Succès** : La région focalisée est agrandie ; le contexte reste visible.

### 🚀 Tâche FL.2 : Coder le Suivi Curseur Temps Réel (Durée : 20 min)
* **Description** : Coder le suivi du curseur comme centre du focus avec recalcul temps réel (≥ 30 FPS).
* **Fichier** : `frontend_react/src/components/FisheyeLensOverlay.tsx`
* **Critère de Succès** : Le focus suit le curseur fluidement.

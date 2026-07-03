<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-ENGINE-TANSTACK-TABLE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_TANSTACK_TABLE_TASKS  
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

### 🚀 Tâche TT.1 : Coder la Grille Virtualisée (Durée : 25 min)
* **Description** : Coder `ConceptsGrid.tsx` (TanStack Table v8 + react-virtual) avec colonnes d'attributs et cellule SMI badge couleur.
* **Fichier** : `frontend_react/src/components/ConceptsGrid.tsx`
* **Critère de Succès** : 10 000 concepts affichés à 60 FPS ; badges SMI Rouge→Vert.

### 🚀 Tâche TT.2 : Coder Tri + Filtre + Drawer (Durée : 25 min)
* **Description** : Coder le tri (Stabilité FSRS croissante), le filtre domaine/SMI, et l'ouverture du Drawer Knowledge Card au clic de ligne.
* **Fichier** : `frontend_react/src/components/ConceptsGrid.tsx`
* **Critère de Succès** : Le tri met les concepts proches de l'oubli en haut ; le clic ouvre le Drawer.

# 📋 SCY-FISHEYE-LENS — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_FISHEYE_LENS_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche FL.1 : Coder la Distorsion Focus+Context (Durée : 25 min)
* **Description** : Coder la transformation fisheye (distorsion radiale) via plugin G6 ou custom, agrandissant le focus et compressant le contexte.
* **Fichier** : `frontend_react/src/cosmos/fisheye_lens.ts`
* **Critère de Succès** : La région focalisée est agrandie ; le contexte reste visible.

### 🚀 Tâche FL.2 : Coder le Suivi Curseur Temps Réel (Durée : 20 min)
* **Description** : Coder le suivi du curseur comme centre du focus avec recalcul temps réel (≥ 30 FPS).
* **Fichier** : `frontend_react/src/components/FisheyeLensOverlay.tsx`
* **Critère de Succès** : Le focus suit le curseur fluidement.

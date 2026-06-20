# 📋 SCY-ENGINE-THREEJS — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_THREEJS_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche TJ.1 : Coder le Lazy-Loader + GPU Check (Durée : 25 min)
* **Description** : Coder `threejs_loader.ts` (lazy-import three.js ~450KB + feature detection WebGL2 + fallback M2 si incompatibilité).
* **Fichier** : `frontend_react/src/cosmos/engines/threejs_loader.ts`
* **Critère de Succès** : three.js hors bundle initial ; GPU check masque M23 et bascule M2 si incompatibilité.

### 🚀 Tâche TJ.2 : Coder le Rendu Volumétrique (Durée : 30 min)
* **Description** : Coder `Brain3DGraph.tsx` (sphères lumineuses, cylindres translucides, axes sémantiques 3D) à 60 FPS.
* **Fichier** : `frontend_react/src/components/Brain3DGraph.tsx`
* **Critère de Succès** : Rendu 3D fluide à 60 FPS avec palette `design.md`.

### 🚀 Tâche TJ.3 : Coder la Navigation Fly-To + Knowledge Card 3D (Durée : 25 min)
* **Description** : Coder Orbit Controls et l'animation fly-to sur clic de sphère déployant la Knowledge Card 3D.
* **Fichier** : `frontend_react/src/components/Brain3DGraph.tsx`
* **Critère de Succès** : Fly-to fluide + Knowledge Card 3D affichée après clic.

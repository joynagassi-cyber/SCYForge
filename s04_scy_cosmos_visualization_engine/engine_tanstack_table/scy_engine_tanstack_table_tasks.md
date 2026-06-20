# 📋 SCY-ENGINE-TANSTACK-TABLE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_TANSTACK_TABLE_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche TT.1 : Coder la Grille Virtualisée (Durée : 25 min)
* **Description** : Coder `ConceptsGrid.tsx` (TanStack Table v8 + react-virtual) avec colonnes d'attributs et cellule SMI badge couleur.
* **Fichier** : `frontend_react/src/components/ConceptsGrid.tsx`
* **Critère de Succès** : 10 000 concepts affichés à 60 FPS ; badges SMI Rouge→Vert.

### 🚀 Tâche TT.2 : Coder Tri + Filtre + Drawer (Durée : 25 min)
* **Description** : Coder le tri (Stabilité FSRS croissante), le filtre domaine/SMI, et l'ouverture du Drawer Knowledge Card au clic de ligne.
* **Fichier** : `frontend_react/src/components/ConceptsGrid.tsx`
* **Critère de Succès** : Le tri met les concepts proches de l'oubli en haut ; le clic ouvre le Drawer.

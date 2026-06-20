# 🧪 SCY-ENGINE-G2 — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_G2_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test G2.1 : Affichage des Indicateurs (Happy Path)
* **Input** : Données XP/streak/SMI.
* **Attendu** : Graphiques G2 v5 affichés, palette `design.md` respectée.

### 🧪 Test G2.2 : Rafraîchissement Temps Réel
* **Input** : Changement de données (EventBus).
* **Attendu** : Graphiques rafraîchis avec animation, sans rechargement complet.

### 🧪 Test G2.3 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

# 🧪 SCY-ENGINE-G6 — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_G6_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test G6.1 : Rendu 2D Axial (Happy Path)
* **Input** : Graphe COSMOS valide.
* **Attendu** : Affichage 2D via G6 v5, disposition force-directed axiale, palette `design.md` respectée.

### 🧪 Test G6.2 : Performance (Grand Graphe)
* **Input** : 5 000 nœuds.
* **Attendu** : ≥ 30 FPS avec LOD + Barnes-Hut + Object Pooling actifs.

### 🧪 Test G6.3 : Interactivité
* **Attendu** : Zoom/pan fluides ; sélection d'un nœud affiche son détail.

### 🧪 Test G6.4 : Respect de la Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

### 🧪 Test G6.5 : Rejet de Données Invalides
* **Input** : Graphe non conforme (Zod).
* **Attendu** : Rendu refusé avec erreur typée (pas de crash).

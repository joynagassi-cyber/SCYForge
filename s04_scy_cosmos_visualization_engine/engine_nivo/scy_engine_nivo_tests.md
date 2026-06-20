# 🧪 SCY-ENGINE-NIVO — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_NIVO_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test NV.1 : Chord (M12)
* **Input** : Matrice 50×50.
* **Attendu** : Rendu correct ; survol met en valeur les rubans émanant de l'arc.

### 🧪 Test NV.2 : Sankey (M13)
* **Input** : Flux avec des flux mineurs < 2%.
* **Attendu** : Les flux mineurs sont fusionnés sous « Autres flux ».

### 🧪 Test NV.3 : Heatmap (M16)
* **Input** : Matrice avec similarité > 0.95.
* **Attendu** : Le `⚠️` de redondance s'affiche.

### 🧪 Test NV.4 : Circle Packing (M19)
* **Input** : Hiérarchie avec sous-bulles < 5px.
* **Attendu** : Les bulles trop petites sont masquées/floutées.

### 🧪 Test NV.5 : Lazy-Loading
* **Attendu** : nivo absent du bundle initial ; chargé uniquement à la visite d'un mode M12/M13/M16/M19.

### 🧪 Test NV.6 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

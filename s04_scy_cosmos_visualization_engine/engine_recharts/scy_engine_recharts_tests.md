# 🧪 SCY-ENGINE-RECHARTS — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_RECHARTS_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test RC.1 : Statistics (M7) clic
* **Input** : Clic sur un pic d'oubli.
* **Attendu** : Les concepts concernés sont filtrés/affichés.

### 🧪 Test RC.2 : Statistics (M7) fallback
* **Input** : Agrégation DuckDB-WASM dépassant 5s.
* **Attendu** : Affichage d'un fallback statique neutre (circuit breaker).

### 🧪 Test RC.3 : Radar (M14) superposition
* **Attendu** : Polygone bleu (profil) + polygone cible (pointillés) superposés sur 5 axes.

### 🧪 Test RC.4 : Radar (M14) bornes
* **Attendu** : Toutes les valeurs des axes sont dans [0,100].

### 🧪 Test RC.5 : Radar (M14) clic sommet
* **Attendu** : Le clic sur un sommet ouvre les concepts responsables de la dimension.

### 🧪 Test RC.6 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

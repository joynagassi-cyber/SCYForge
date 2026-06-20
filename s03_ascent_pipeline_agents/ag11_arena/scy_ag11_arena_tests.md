# 🧪 SCY-AG11-ARENA — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG11_ARENA_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test 11.1 : Génération de Scénario (Happy Path)
* **Input** : Domaine + objectif.
* **Attendu** : Scénario réaliste généré avec grille d'évaluation mesurable.

### 🧪 Test 11.2 : Cohérence du Roleplay
* **Attendu** : Les agents-rôles restent cohérents et contextualisés sur plusieurs tours.

### 🧪 Test 11.3 : Scoring Pratique
* **Pré-conditions** : Session terminée.
* **Attendu** : Score produit selon la grille, validé par `ArenaScoreSchema`.

### 🧪 Test 11.4 : Seuil de Validation
* **Attendu** : Score ≥ seuil → composante pratique validée (AGENT-09) ; < seuil → échec.

### 🧪 Test 11.5 : Feedback Ciblé
* **Attendu** : Le feedback inclut points forts et axes d'amélioration.

### 🧪 Test 11.6 : Validation AGENT-13
* **Pré-conditions** : Scénario incohérent.
* **Attendu** : Régénération déclenchée (pas de scénario invalide utilisé).

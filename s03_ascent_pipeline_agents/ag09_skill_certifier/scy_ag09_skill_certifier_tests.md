# 🧪 SCY-AG09-SKILL-CERTIFIER — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG09_SKILL_CERTIFIER_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test 9.1 : Évaluation Théorique (Happy Path)
* **Pré-conditions** : SMI global ≥ seuil.
* **Input** : Examen SurveyJS réussi.
* **Attendu** : Composante théorique validée.

### 🧪 Test 9.2 : Évaluation Pratique ARENA
* **Pré-conditions** : Composante théorique validée.
* **Input** : Simulation ARENA réussie.
* **Attendu** : Composante pratique validée.

### 🧪 Test 9.3 : Délivrance du Proof of Skill
* **Pré-conditions** : Les deux composantes validées.
* **Attendu** : Certificat signé généré, persisté dans `mfg_certificates`, exportable.

### 🧪 Test 9.4 : Refus de Certification
* **Pré-conditions** : Une composante échouée (théorie ou pratique).
* **Attendu** : Aucun certificat délivré.

### 🧪 Test 9.5 : Vérifiabilité du Hash
* **Attendu** : Le hash signé du certificat peut être vérifié (intégrité confirmée).

### 🧪 Test 9.6 : GoalCompleted
* **Attendu** : La certification déclenche `GoalCompleted { user_id, goal_id }`.

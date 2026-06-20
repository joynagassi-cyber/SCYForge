# 🧪 SCY-AG07-DRIFT-GUARDIAN — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG07_DRIFT_GUARDIAN_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test 7.1 : Détection d'Inactivité
* **Pré-conditions** : Inactivité simulée > seuil (N jours).
* **Attendu** : `DriftDetected { signal_type: "inactivity", severity }` émis.

### 🧪 Test 7.2 : Déclin de Performance
* **Pré-conditions** : Baisse de SMI > seuil.
* **Attendu** : Signal "decline" détecté et agrégé au score.

### 🧪 Test 7.3 : Ré-Engagement Personnalisé
* **Input** : Alerte "échecs répétés".
* **Attendu** : Action de simplification (AGENT-06) déclenchée (pas un rappel générique).

### 🧪 Test 7.4 : Anti-spam
* **Pré-conditions** : Alertes répétées rapprochées.
* **Attendu** : La fréquence des notifications est limitée.

### 🧪 Test 7.5 : DLQ
* **Pré-conditions** : Un événement échoue 3 fois.
* **Attendu** : L'Agent-07 est notifié via la DLQ.

### 🧪 Test 7.6 : Anti-Faux-Positifs
* **Pré-conditions** : Aucun seuil franchi.
* **Attendu** : Aucune alerte émise ; surveillance continue.

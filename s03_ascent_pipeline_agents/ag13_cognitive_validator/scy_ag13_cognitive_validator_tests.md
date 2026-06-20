# 🧪 SCY-AG13-COGNITIVE-VALIDATOR — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG13_COGNITIVE_VALIDATOR_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test 13.1 : Détection d'Aassertion Sans Source (Couche 1)
* **Input** : Document avec une assertion non tracée.
* **Attendu** : Assertion détectée et marquée `unverified`.

### 🧪 Test 13.2 : Détection de Contradiction (Couche 2)
* **Input** : Document contenant deux assertions contradictoires.
* **Attendu** : Contradiction détectée.

### 🧪 Test 13.3 : Recoupement Externe (Couche 3)
* **Input** : Fait non recoupable dans le référentiel.
* **Attendu** : Fait signalé comme non vérifié.

### 🧪 Test 13.4 : Score par Section + Blocage
* **Pré-conditions** : Une section sous le seuil (85).
* **Attendu** : Section bloquée ; renvoi à NEURON-CHAINS pour révision.

### 🧪 Test 13.5 : Gate Globale
* **Pré-conditions** : Score global < seuil.
* **Attendu** : Le document n'est pas présenté à l'utilisateur.

### 🧪 Test 13.6 : Rapport de Confiance
* **Attendu** : Un rapport (score + justifications) est généré et journalisé dans Langfuse.

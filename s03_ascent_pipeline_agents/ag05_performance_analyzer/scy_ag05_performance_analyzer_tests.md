# 🧪 SCY-AG05-PERFORMANCE-ANALYZER — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG05_PERFORMANCE_ANALYZER_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

### 🧪 Test 5.1 : Recalcul SMI (Happy Path)
* **Input** : `CardReviewed { rating: "good" }`.
* **Exécution** : `performanceAnalyzerStep(event)`.
* **Attendu** : SMI recalculé, borné [0,100], persisté dans `mfg_ascent_nodes`.

### 🧪 Test 5.2 : Détection de Seuil
* **Pré-conditions** : Nœud proche du seuil.
* **Input** : Signal faisant franchir le seuil.
* **Attendu** : `NodeCompleted { smi_achieved }` émis.

### 🧪 Test 5.3 : Agrégation SMI Global
* **Pré-conditions** : Plusieurs nœuds à différents SMI.
* **Attendu** : `mv_user_smi_summary` reflète correctement la moyenne/médiane et le compte de nœuds maîtrisés.

### 🧪 Test 5.4 : Export Parquet
* **Attendu** : L'export Parquet contient les colonnes attendues (domaine, type, lapses, stability).

### 🧪 Test 5.5 : Aucun Score Inventé
* **Attendu** : Le SMI n'augmente qu'avec des signaux réels mesurés ; sans signal, SMI inchangé.

# 🧪 SCY-SCIENCE-CORE — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S01_INGESTION_SCIENCE_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

## 1. Scénarios de Validation Unitaires

### 🧪 Test 9.1 : Extraction Métadonnées arXiv
* **Pré-conditions** : Client arXiv opérationnel avec rate limiting.
* **Input** : Identifiant arXiv valide `2401.12345`.
* **Règle d'Exécution** : Appeler `fetchArxivMetadata(id)`.
* **Post-conditions (Attendu)** :
  - Les métadonnées (titre, auteurs, abstract, catégorie arXiv) sont extraites.
  - Le DOI lié (si présent) est récupéré.

### 🧪 Test 9.2 : Extraction LaTeX Native (Happy Path)
* **Pré-conditions** : Source LaTeX (`e-print`) disponible pour l'article.
* **Input** : Identifiant arXiv avec source disponible.
* **Règle d'Exécution** : Appeler le pipeline complet `ingestScienceArticle(id)`.
* **Post-conditions (Attendu)** :
  - Le Markdown produit contient le texte intégral.
  - Les formules mathématiques sont préservées en `$$...$$` et `$...$` exactement.
  - Le score DRACO est ≥ 88/100.
  - Les embeddings sont indexés dans Zilliz.

### 🧪 Test 9.3 : Fallback PDF (Source Absente)
* **Pré-conditions** : Article sans source LaTeX disponible (source scellée).
* **Input** : Identifiant arXiv sans `e-print`.
* **Règle d'Exécution** : Appeler `ingestScienceArticle(id)`.
* **Post-conditions (Attendu)** :
  - Le système bascule sur le téléchargement PDF + Docling.
  - Les formules sont extraites (MathML → LaTeX).
  - Le score DRACO est réduit et annoté (confiance OCR/PDF vs LaTeX natif).

### 🧪 Test 9.4 : Extraction Figures & Tableaux
* **Pré-conditions** : Article contenant figures et tableaux.
* **Input** : Identifiant arXiv d'un article riche en figures.
* **Règle d'Exécution** : Appeler `extractFigures(id)`.
* **Post-conditions (Attendu)** :
  - Les figures sont extraites avec leurs légendes associées.
  - Les tableaux sont convertis en Markdown.

### 🧪 Test 9.5 : Dé-duplication par Version
* **Pré-conditions** : Article `2401.12345` version `v1` déjà indexé dans `mfg_shared_content_cache`.
* **Input** : Nouvelle demande d'ingestion de `2401.12345` (v1 inchangée).
* **Règle d'Exécution** : Appeler `ingestScienceArticle(id)`.
* **Post-conditions (Attendu)** :
  - L'article est sauté sans téléchargement.
  - Si une `v2` existe et est demandée, une ré-ingestion est déclenchée.

### 🧪 Test 9.6 : Rejet d'un Identifiant Invalide
* **Pré-conditions** : Client arXiv opérationnel.
* **Input** : Identifiant arXiv invalide `9999.99999`.
* **Règle d'Exécution** : Appeler `fetchArxivMetadata(id)`.
* **Post-conditions (Attendu)** :
  - Le système renvoie le code `ARXIV_NOT_FOUND`.
  - Aucune exception non gérée n'est levée.

### 🧪 Test 9.7 : Respect du Rate Limiting arXiv
* **Pré-conditions** : Client arXiv configuré.
* **Input** : 5 requêtes consécutives vers l'API de requête.
* **Règle d'Exécution** : Appeler `batchMetadataFetch()`.
* **Post-conditions (Attendu)** :
  - Aucune fenêtre de 3 secondes ne contient plus d'une requête API de requête.
  - Le `User-Agent` est présent sur chaque appel.

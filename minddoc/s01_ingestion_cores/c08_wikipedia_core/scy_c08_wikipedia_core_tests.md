<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-WIKIPEDIA-CORE — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S01_INGESTION_WIKIPEDIA_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Scénarios de Validation Unitaires

### 🧪 Test 8.1 : Résolution & Conversion d'un Article (Happy Path)
* **Pré-conditions** : Client MediaWiki opérationnel avec `User-Agent`.
* **Input** : Titre `Apprentissage automatique`, langue `fr`.
* **Règle d'Exécution** : Appeler `ingestArticle(title, lang)`.
* **Post-conditions (Attendu)** :
  - Le Markdown produit contient un résumé, une hiérarchie de sections et une infobox.
  - Le score DRACO est ≥ 85/100.
  - Les embeddings sont indexés dans Zilliz.

### 🧪 Test 8.2 : Gestion des Redirections
* **Pré-conditions** : Client opérationnel.
* **Input** : Un titre qui est une redirection vers un article canonique.
* **Règle d'Exécution** : Appeler `ingestArticle(redirTitle, lang)`.
* **Post-conditions (Attendu)** :
  - Le système suit la redirection vers l'article final.
  - Le contenu ingéré est celui de l'article canonique.

### 🧪 Test 8.3 : Extraction du Graphe de Wikiliens
* **Pré-conditions** : Article avec de nombreux liens internes.
* **Input** : Titre d'un article technique riche en wikiliens.
* **Règle d'Exécution** : Appeler `extractWikilinkGraph(title)`.
* **Post-conditions (Attendu)** :
  - Des arêtes COSMOS sont créées vers les concepts liés.
  - Les namespaces non pertinents (`Catégorie:`, `Aide:`) sont filtrés.
  - Le poids d'arête reflète la fréquence/contexte du lien.

### 🧪 Test 8.4 : Support Multilingue
* **Pré-conditions** : Client configuré.
* **Input** : Titre + langue `es`.
* **Règle d'Exécution** : Appeler `ingestArticle(title, "es")`.
* **Post-conditions (Attendu)** :
  - La requête cible `es.wikipedia.org`.
  - La langue détectée (`es`) est préservée dans les métadonnées.

### 🧪 Test 8.5 : Dé-duplication par Révision
* **Pré-conditions** : Un article (`page_id: 42`, `last_rev_id: 1000`) déjà indexé dans `mfg_shared_content_cache`.
* **Input** : Nouvelle demande d'ingestion du même article (révision inchangée).
* **Règle d'Exécution** : Appeler `ingestArticle(...)`.
* **Post-conditions (Attendu)** :
  - L'article est sauté sans appel réseau au-delà de la vérification de révision.
  - Si `last_rev_id` change (article modifié), une ré-ingestion est déclenchée.

### 🧪 Test 8.6 : Rejet d'un Article Introuvable
* **Pré-conditions** : Client opérationnel.
* **Input** : Un titre inexistant (ex : `QWERTYXYZNonExistent123`).
* **Règle d'Exécution** : Appeler `ingestArticle(...)`.
* **Post-conditions (Attendu)** :
  - Le système renvoie le code `ARTICLE_NOT_FOUND`.
  - Aucune exception non gérée n'est levée.

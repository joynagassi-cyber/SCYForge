# 🔬 SCY-SCIENCE-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_SCIENCE_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 0. Frontière avec c04_academic_core (Complémentarité)
* **`c04_academic_core`** gère la **découverte et les métadonnées** (Google Scholar, DOI/ISBN, listing arXiv, cross-référencement).
* **`c09_science_core`** (ce document) gère le **contenu scientifique profond** d'arXiv : extraction du **texte intégral**, des **formules LaTeX** et des **figures**, à partir d'un identifiant arXiv déjà résolu. Les deux cores sont complémentaires et ne se chevauchent pas.

---

## 1. Purpose
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion Science (`c09_science_core`)** de SCY Forge. Le système doit être capable, à partir d'un identifiant arXiv (ex : `2401.12345`), d'extraire le **texte intégral**, les **formules mathématiques en LaTeX**, les **figures/tableaux** et les métadonnées de l'article. L'API arXiv étant publique et gratuite, l'ingestion s'effectue à **coût d'infrastructure nul (0 $)**.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **API arXiv** (publique, gratuite) :
  - `http://export.arxiv.org/api/query?id_list={id}` — métadonnées (Atom XML : titre, auteurs, abstract, catégories, DOI lié).
  - `https://arxiv.org/pdf/{id}.pdf` — téléchargement du PDF plein texte.
  - `https://arxiv.org/e-print/{id}` — téléchargement de la source LaTeX (tarball `.tar.gz` contenant les fichiers `.tex`).
* **Parsing Atom XML** : `quick-xml` (Rust) pour les métadonnées de l'API.
* **Parsing PDF scientifique** : **Docling** (conteneur Docker local) — extraction du texte, des formules (MathML/OCR) et des figures. Alternative : `lopdf` (Rust) pour un accès bas niveau.
* **Extraction LaTeX natif** : décompression du tarball source (`flate2` + `tar` crates Rust) puis parsing des fichiers `.tex` pour récupérer les formules et le balisage scientifique originel.
* **Conversion formules** : MathML/LaTeX préservé tel quel dans le Markdown (blocs `$$...$$` et inline `$...$`).
* **Nettoyage** : `dom_smoothie` non requis ; le balisage scientifique est préservé.

> **Rappel anti-hallucination** : tout composant listé ci-dessus est une dépendance réelle et vérifiable. arXiv ne requiert aucune clé API (politique : max 1 requête toutes les 3 secondes pour l'API de requête). Aucune API scientifique payante n'est autorisée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Récupération des Métadonnées arXiv

#### Scénario : Extraction des métadonnées d'un article
- **GIVEN** Un identifiant arXiv valide (ex : `2401.12345`).
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` lance l'ingestion.
- **THEN** le système SHALL appeler l'API arXiv `id_list={id}` pour récupérer : titre, auteurs, abstract, catégories arXiv (ex : `cs.AI`), DOI lié (si présent), date de soumission.
- **AND** le système SHALL rejeter les identifiants inexistants avec le code `ARXIV_NOT_FOUND`.

---

### Requirement : Extraction du Texte Intégral & des Formules LaTeX

#### Scénario : Extraction prioritaire depuis la source LaTeX
- **GIVEN** Un article arXiv dont la source LaTeX est disponible (`e-print`).
- **WHEN** Le système télécharge le contenu.
- **THEN** le système SHALL télécharger le tarball source via `https://arxiv.org/e-print/{id}`.
- **AND** le système SHALL décompresser (`flate2` + `tar`) et localiser le fichier `.tex` principal.
- **AND** le système SHALL parser le `.tex` pour extraire le texte structuré et les formules en LaTeX natif (qualité optimale, sans erreur d'OCR).
- **AND** le système SHALL convertir le contenu en Markdown en préservant les formules en blocs `$$...$$` et inline `$...$`.

#### Scénario : Fallback PDF lorsque la source LaTeX est indisponible
- **GIVEN** Un article arXiv dont la source LaTeX n'est pas disponible (scellée ou absente).
- **WHEN** Le téléchargement `e-print` échoue.
- **THEN** le système SHALL télécharger le PDF via `https://arxiv.org/pdf/{id}.pdf`.
- **AND** le système SHALL transmettre le PDF à **Docling** pour extraction du texte, des formules (MathML) et des figures.
- **AND** le système SHALL signaler une confiance réduite sur les formules extraites par OCR/PDF (vs LaTeX natif) via le score DRACO.

---

### Requirement : Extraction des Figures & Tableaux

#### Scénario : Capture des figures scientifiques
- **GIVEN** Un article arXiv contenant des figures.
- **WHEN** Le système ingère l'article.
- **THEN** le système SHALL extraire les figures (images) depuis la source LaTeX ou via Docling sur le PDF.
- **AND** le système SHALL associer chaque figure à sa légende (`\caption{}`).
- **AND** le système SHALL extraire les tableaux de données et les convertir en tableaux Markdown.
- **AND** le système SHALL stocker les figures (références + chemin) dans `mfg_project_sources`.

---

### Requirement : Dé-duplication & Cache

#### Scénario : Évitement des ré-ingestions
- **GIVEN** Un article déjà indexé dans `mfg_shared_content_cache`.
- **WHEN** Une nouvelle ingestion du même arXiv ID est demandée.
- **THEN** le système SHALL comparer `arxiv_id` + `version` (v1/v2/...) avec le cache.
- **AND** le système SHALL ignorer l'article si déjà à jour, sauf si une nouvelle version est détectée.

---

### Requirement : Respect des Limites de l'API arXiv

#### Scénario : Bon citoyen de l'API arXiv
- **GIVEN** Plusieurs requêtes vers l'API arXiv.
- **WHEN** Le système émet des appels consécutifs.
- **THEN** le système SHALL respecter la politique arXiv (max 1 requête toutes les 3 secondes pour l'API de requête).
- **AND** le système SHALL inclure un `User-Agent` descriptif.
- **AND** le système SHALL appliquer un Circuit Breaker en cas de réception répétée de `429`.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Dépasser la limite arXiv (1 requête / 3 s sur l'API de requête).
* 🚫 **FORBIDDEN** : Décompresser des tarballs sources sans limite de taille (protection anti-bombe zip) — seuil configurable.
* 🚫 **SHALL NOT** : Détourner les formules LaTeX (elles DOIVENT être préservées telles quelles, sans approximation).
* 🚫 **SHALL NOT** : Appeler des APIs scientifiques payantes (Semantic Scholar premium, Elsevier).
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens définis dans `design.md`.
* ⚠️ **MUST** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (LaTeX natif)** : Un article avec source LaTeX disponible produit un Markdown avec formules `$$...$$` préservées exactement, score DRACO ≥ 88/100.
* **Test Case 2 (Fallback PDF)** : Un article sans source LaTeX est ingéré via Docling/PDF avec formules MathML converties et confiance réduite signalée.
* **Test Case 3 (Figures)** : Les figures sont extraites avec leurs légendes et les tableaux convertis en Markdown.
* **Test Case 4 (Dé-duplication)** : Un article déjà à jour (même version) est sauté sans téléchargement.
* **Test Case 5 (Introuvable)** : Un identifiant arXiv invalide renvoie `ARXIV_NOT_FOUND` sans exception non gérée.

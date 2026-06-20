# 📚 SCY-EPUB-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_EPUB_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 0. Frontière avec s08_scy_reader_suite (Complémentarité)
* **`c12_epub_core`** (ce document) gère l'**ingestion** : parsing d'un fichier EPUB en Markdown sémantique chapitré et indexation vectorielle pour l'apprentissage.
* **`s08_scy_reader_suite`** gère la **lecture/visualisation** : affichage interactif du livre (pagination, galerie de pages, export). Les deux sont complémentaires et ne se chevauchent pas.

---

## 1. Purpose
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion EPUB (`c12_epub_core`)** de SCY Forge. Le système doit être capable, à partir d'un fichier `.epub` local, d'en extraire les métadonnées (titre, auteur, langue, éditeur via OPF), la **table des matières** (NCX/NAV) et le **contenu chapitré** (XHTML) converti en Markdown sémantique. L'ingestion s'effectue à **coût d'infrastructure nul (0 $)** (parsing local, aucune API).

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **Parsing EPUB** : crate **`epub`** (Rust) — lecture de l'archive ZIP, accès au manifeste OPF, à la table des matières (NCX EPUB 2 / NAV EPUB 3) et aux documents XHTML.
* **Archive ZIP** : `zip` crate (décompression de l'EPUB).
* **XHTML → Markdown** : `dom_smoothie` (core `c02_web_article_core`) pour convertir chaque document XHTML en Markdown propre.
* **Parsing OPF** : `quick-xml` (métadonnées Dublin Core : `dc:title`, `dc:creator`, `dc:language`, `dc:publisher`).
* **OCR optionnel** : Docling pour les EPUB scannés (images de pages), rare mais prévu.

> **Rappel anti-hallucination** : tout composant listé ci-dessus est une dépendance réelle et vérifiable. Le format EPUB est une archive ZIP standardisée (XHTML + OPF + NCX/NAV). Aucune API tierce payante n'est utilisée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Extraction des Métadonnées OPF

#### Scénario : Lecture des métadonnées du livre
- **GIVEN** Un fichier `.epub` valide fourni par l'utilisateur.
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` lance l'ingestion.
- **THEN** le système SHALL ouvrir l'EPUB via la crate `epub`.
- **AND** le système SHALL extraire les métadonnées Dublin Core du manifeste OPF : titre, auteur(s), langue, éditeur, date, ISBN (si présent).
- **AND** le système SHALL rejeter les fichiers corrompus/non-EPUB avec le code `INVALID_EPUB`.

---

### Requirement : Extraction de la Table des Matières

#### Scénario : Reconstruction de la structure chapitrée
- **GIVEN** Un EPUB valide.
- **WHEN** Le système lit la table des matières.
- **THEN** le système SHALL parser le fichier de navigation (NCX pour EPUB 2, NAV pour EPUB 3).
- **AND** le système SHALL reconstruire la hiérarchie des chapitres (titres + ordre + ancres).
- **AND** le système SHALL mapper chaque entrée de la TOC vers le document XHTML correspondant.

---

### Requirement : Conversion XHTML → Markdown Chapitré

#### Scénario : Conversion du contenu
- **GIVEN** Un EPUB valide avec sa TOC résolue.
- **WHEN** Le système convertit le contenu.
- **THEN** le système SHALL parcourir les documents XHTML dans l'ordre du manifeste (spine).
- **AND** le système SHALL convertir chaque document XHTML en Markdown via `dom_smoothie`.
- **AND** le système SHALL segmenter le contenu par chapitre (selon la TOC) en documents Markdown distincts ou sections.
- **AND** le système SHALL écrire chaque chapitre dans `mfg_project_sources` et indexer les embeddings dans Zilliz.

---

### Requirement : Traitement des Médias Embarqués

#### Scénario : Gestion des images et ressources
- **GIVEN** Un EPUB contenant des images, couvertures ou médias.
- **WHEN** Le système ingère le livre.
- **THEN** le système SHALL extraire les images de l'archive (couverture, illustrations).
- **AND** le système SHALL associer chaque image à sa position dans le chapitre correspondant.
- **AND** le système SHALL conserver les références d'images dans le Markdown (chemin local).

---

### Requirement : Dé-duplication & Robustesse

#### Scénario : Évitement des ré-ingestions
- **GIVEN** Un EPUB déjà indexé dans `mfg_shared_content_cache`.
- **WHEN** Une nouvelle ingestion du même fichier est demandée.
- **THEN** le système SHALL comparer le hash SHA-256 du fichier avec le cache.
- **AND** le système SHALL ignorer le fichier si déjà présent et identique.

#### Scénario : EPUB protégé par DRM
- **GIVEN** Un EPUB protégé par DRM (ex : Adobe ADEPT).
- **WHEN** Le système tente de parser le contenu.
- **THEN** le système SHALL détecter le chiffrement DRM.
- **AND** le système SHALL rejeter l'ingestion avec le code `EPUB_DRM_PROTECTED` sans tentative de contournement.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Contourner les protections DRM (illégal et hors périmètre).
* 🚫 **FORBIDDEN** : Décompresser des EPUB de taille non bornée (protection anti-bombe zip).
* 🚫 **SHALL NOT** : Mélanger les chapitres hors ordre du spine.
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens définis dans `design.md`.
* ⚠️ **MUST** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (Happy Path)** : Un EPUB valide produit des chapitres Markdown structurés avec métadonnées, score DRACO ≥ 85/100.
* **Test Case 2 (TOC)** : La hiérarchie des chapitres est correctement reconstruite et mappée aux XHTML.
* **Test Case 3 (Images)** : Les images (couverture, illustrations) sont extraites et référencées.
* **Test Case 4 (Dé-duplication)** : Un EPUB identique (même hash) est sauté sans re-parsing.
* **Test Case 5 (DRM)** : Un EPUB protégé renvoie `EPUB_DRM_PROTECTED` sans contournement.

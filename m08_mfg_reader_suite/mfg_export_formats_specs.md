# 📤 EXPORT MULTI-FORMATS — SPÉCIFICATIONS DES 9 FORMATS DE PRODUCTION
**ID Module** : M08_READER_SUITE_EXPORT  
**Statut** : 🟢 FORMATS ET CRATES HISTOLOGIQUEMENT SÉCURISÉS ET TYPES  

---

## 1. Spécification des 9 Formats d'Exportation
MindForge permet d'exporter l'intégralité du matériel sémantique d'un nœud ou d'un projet dans 9 formats standards de niveau de production :

### 1.1 PDF (Typst 0.11 + typst-pdf 0.11)
* **Technologie** : Compilation locale du moteur **Typst** en Rust (0$ d'infrastructure).
* **Règles de rendu** : Génération de documents de grade académique avec table des matières automatique, headers/footers dynamiques, formules LaTeX compilées et code blocks avec coloration syntaxique (150+ langues). Inclusion du rapport de confiance anti-hallucination dans une section dédiée.

### 1.2 DOCX (docx 0.4 — ⚠️ PAS docx-rs déprécié)
* **Technologie** : Utilisation exclusive du crate `docx = "0.4"`.
* **Règles de rendu** : Document entièrement éditable sous Microsoft Word respectant la hiérarchie des styles de paragraphes (H1 à H6, normal, code). Les listes à puces et tableaux sont intégrés nativement.

### 1.3 HTML (tera 1.x)
* **Technologie** : Moteur de templates `tera = "1.x"` compilant un fichier HTML statique.
* **Règles de rendu** : HTML5 sémantique avec feuilles de style CSS et scripts Prism.js de coloration syntaxique embarqués (embedded) pour un fonctionnement 100% autonome et hors-ligne. Support du mode sombre et d'un layout adapté à l'impression (`@media print`).

### 1.4 Markdown (Rust natif)
* **Technologie** : Rust natif se conformant à la norme **CommonMark 0.31**.
* **Règles de rendu** : Frontmatter YAML contenant les métadonnées cognitives (SMI, dates de révision) et balisage de tableaux et de listes de tâches (GFM).

### 1.5 LaTeX (tera 1.x templates)
* **Technologie** : Templates d'exportations académiques compilés via Tera.
* **Règles de rendu** : Génération d'articles de style IEEE ou Nature avec cross-references, index de figures et indexation BibTeX automatique.

### 1.6 Anki .apkg (zip 2.1 + rusqlite 0.31)
* **Technologie** : Écriture de la base SQLite Anki locale via `rusqlite` et empaquetage ZIP de type `.apkg`.
* **Règles de rendu** : Export de nos flashcards de types Cloze ou Définitions avec préservation de nos paramètres FSRS 5.0 pour une compatibilité native dans AnkiDroid 2.18+.

### 1.7 Excel .xlsx (rust_xlsxwriter)
* **Technologie** : Utilisation exclusive du crate `rust_xlsxwriter`.
* **Règles de rendu** : Génération de tableaux multi-onglets (un onglet de synthèse globale et un onglet par nœud de compétences) avec colorations adaptatives basées sur l'SMI de l'utilisateur.

### 1.8 ZIP (zip 2.1 — ⚠️ PAS zip-rs déprécié)
* **Technologie** : Empaquetage via `zip = "2.1"`.
* **Règles de rendu** : Archive compressée (niveau 6) regroupant les documents Markdown, les fichiers médias et un index structuré au format JSON (`manifest.json`).

### 1.9 Notion CSV
* **Technologie** : Format CSV d'importation de base de données de Notion.
* **Règles de rendu** : Fichier tabulaire avec colonnes : Titre, Contenu Markdown, Source, Date de Révision, et identifiants de relations pour conserver la structure de graphe dans Notion.

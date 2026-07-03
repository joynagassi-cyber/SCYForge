<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📄 SCY-FILE-VIEWER — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S08_READER_FILE_VIEWER_SPEC  
**Phase** : File Viewer MVP Phase 0 (PDF+MD+TXT) → Phase 1 complet  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

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

## 0. Frontière avec c12_epub_core (Complémentarité)
* **file_viewer** (ce document) est le **lecteur intégré** (affichage des fichiers sources ingérés + enrichissement IA sidebar).
* **c12_epub_core** gère l'**ingestion/parsing** EPUB → Markdown. Les deux sont complémentaires.

---

## 1. Purpose
Cette spécification définit le **File Viewer** — lecteur natif complet pour tous les formats d'ingestion (PDF, EPUB, MD, DOCX, HTML, TXT, LaTeX, Jupyter, CSV/Excel, PPTX), avec une **interface 3 panneaux** (Navigation / Lecteur principal / Enrichissement IA sidebar). Ce n'est pas un aperçu — c'est un lecteur fidèle, navigable, enrichi.

---

## 2. Tech Stack & Dependencies
* **Rendu multi-format** : `@react-pdf-viewer/core` (PDF.js), `epubjs` (EPUB), `react-markdown`+`rehype-highlight` (MD), `mammoth.js` (DOCX→HTML), iframe sandboxé+DOMPurify (HTML), KaTeX/MathJax (LaTeX), nbviewer (Jupyter), `react-data-grid` (CSV/Excel), `reveal.js` (PPTX).
* **Sidebar Enrichissement IA** : résumé chapitre (`scy_chunks.summary`, $0 déjà calculé), concepts clés GLiNER (NER local $0, indicateur SMI), mini COSMOS inline (cosmos.gl), cartes APEX liées (+ créer carte depuis sélection).
* **Features core** : TOC cliquable, signets, recherche full-text surlignage, zoom 50-200%, mode nuit, progression lecture, sélection → actions contextuelles (Créer carte / Note / Définir terme).
* **Tables** : `scy_reader_sessions`, `scy_reader_annotations`.
* **Lazy-loading** : modules à la demande.

> **Rappel anti-hallucination** : le File Viewer lit des fichiers réels (sources ingérées). Les enrichissements IA (résumés, concepts) sont pré-générés et tracés. Aucune fabrication de contenu. iframe HTML sandboxé (DOMPurify anti-XSS).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu Multi-Format Fidèle

#### Scénario : Lecture d'un fichier source
- **GIVEN** Un fichier source ingéré (PDF/EPUB/MD/...).
- **WHEN** L'utilisateur l'ouvre dans le File Viewer.
- **THEN** le système SHALL le rendre fidèlement via le moteur adapté au format.
- **AND** le système SHALL fournir TOC, navigation page, zoom, recherche full-text surlignage.

---

### Requirement : Sidebar Enrichissement IA (3 panneaux)

#### Scénario : Enrichissement contextuel
- **GIVEN** Un chapitre affiché.
- **THEN** la sidebar SHALL afficher : résumé chapitre (pré-généré), concepts clés GLiNER (SMI coloré), mini COSMOS inline, cartes APEX liées.
- **AND** la sélection de texte → [Créer carte] [Note] [Définir terme].

---

### Requirement : Progression & Annotations

#### Scénario : Suivi de lecture
- **THEN** le système SHALL tracker la progression (% lu, reprise position) dans `scy_reader_sessions`.
- **AND** le système SHALL supporter highlights, notes, bookmarks dans `scy_reader_annotations`.

---

### Requirement : Sécurité HTML & Performance

#### Scénario : HTML non fiable
- **GIVEN** Un fichier HTML source.
- **THEN** le système SHALL le rendre en iframe sandboxé + DOMPurify (anti-XSS).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Rendre du HTML non sandboxé/non assaini.
* 🚫 **SHALL NOT** : Fabriquer du contenu d'enrichissement non tracé.
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens `design.md`.

---

## 5. Test cases & Validation
* **TC1 (PDF)** : Rendu fidèle + TOC + zoom + recherche surlignage.
* **TC2 (Sidebar)** : Résumé + concepts GLiNER (SMI) + mini COSMOS + cartes APEX liées.
* **TC3 (Sélection)** : Créer carte / Note / Définir terme.
* **TC4 (Progression)** : % lu + reprise position persistées.
* **TC5 (HTML safe)** : iframe sandboxé + DOMPurify.

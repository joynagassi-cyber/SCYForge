# 🧪 SCY-FILE-VIEWER — TESTS
**ID** : S08_READER_FILE_VIEWER_TESTS

- **TC1 (PDF)** : Rendu fidèle + TOC cliquable + zoom 50-200% + recherche full-text surlignage.
- **TC2 (Formats)** : EPUB/DOCX/HTML/LaTeX/Jupyter/CSV/PPTX rendus fidèlement.
- **TC3 (Sidebar)** : Résumé chapitre ($0) + concepts GLiNER (SMI coloré) + mini COSMOS inline + cartes APEX liées.
- **TC4 (Sélection)** : Sélection texte → [Créer carte] [Note] [Définir terme].
- **TC5 (Progression)** : % lu + reprise position persistées dans `scy_reader_sessions`.
- **TC6 (Annotations)** : Highlights/notes/bookmarks créés dans `scy_reader_annotations`.
- **TC7 (HTML safe)** : iframe sandboxé + DOMPurify (anti-XSS).
- **TC8 (Aucune fabrication)** : Enrichissements tracés vers sources/pre-générés.

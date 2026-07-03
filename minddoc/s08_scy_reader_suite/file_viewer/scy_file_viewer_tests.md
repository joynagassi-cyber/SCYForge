<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-FILE-VIEWER — TESTS
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

**ID** : S08_READER_FILE_VIEWER_TESTS

- **TC1 (PDF)** : Rendu fidèle + TOC cliquable + zoom 50-200% + recherche full-text surlignage.
- **TC2 (Formats)** : EPUB/DOCX/HTML/LaTeX/Jupyter/CSV/PPTX rendus fidèlement.
- **TC3 (Sidebar)** : Résumé chapitre ($0) + concepts GLiNER (SMI coloré) + mini COSMOS inline + cartes APEX liées.
- **TC4 (Sélection)** : Sélection texte → [Créer carte] [Note] [Définir terme].
- **TC5 (Progression)** : % lu + reprise position persistées dans `scy_reader_sessions`.
- **TC6 (Annotations)** : Highlights/notes/bookmarks créés dans `scy_reader_annotations`.
- **TC7 (HTML safe)** : iframe sandboxé + DOMPurify (anti-XSS).
- **TC8 (Aucune fabrication)** : Enrichissements tracés vers sources/pre-générés.

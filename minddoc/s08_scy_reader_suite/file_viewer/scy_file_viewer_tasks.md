<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-FILE-VIEWER — TÂCHES (TASKS)
**ID** : S08_READER_FILE_VIEWER_TASKS

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

### Tâche FV.1 : Coder le layout 3 panneaux + rendu PDF/MD/TXT MVP (25 min)
* **Fichier** : `frontend_react/src/reader/FileViewer.tsx`
* **Description** : Layout 3 panneaux, détection format, rendu PDF (`@react-pdf-viewer/core`) + MD (`react-markdown`) + TXT, TOC/zoom/recherche.
* **Critère** : PDF/MD/TXT rendus fidèlement + TOC + recherche surlignage.

### Tâche FV.2 : Coder les rendus format additionnels (30 min)
* **Fichier** : `frontend_react/src/reader/renderers/*.tsx`
* **Description** : EPUB (epubjs), DOCX (mammoth.js), HTML (iframe sandboxé+DOMPurify), LaTeX (KaTeX), Jupyter, CSV/Excel (react-data-grid), PPTX (reveal.js).
* **Critère** : Chaque format rendu fidèlement ; HTML sécurisé.

### Tâche FV.3 : Coder la sidebar Enrichissement IA (30 min)
* **Fichier** : `frontend_react/src/reader/enrichment_sidebar.tsx`
* **Description** : Résumé chapitre (`scy_chunks.summary` $0), concepts GLiNER (SMI coloré), mini COSMOS inline, cartes APEX liées, sélection → [Créer carte][Note][Définir].
* **Critère** : Enrichissements contextuels affichés ; sélection → actions.

### Tâche FV.4 : Coder progression + annotations (20 min)
* **Fichier** : `frontend_react/src/reader/FileViewer.tsx`
* **Description** : Progression (% lu, reprise position) dans `scy_reader_sessions` ; highlights/notes/bookmarks dans `scy_reader_annotations`.
* **Critère** : Progression persistée ; annotations créables.

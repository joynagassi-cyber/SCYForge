<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-FILE-VIEWER — PLAN (PLAN)
**ID** : S08_READER_FILE_VIEWER_PLAN

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

## Flux / Layout 3 panneaux
```
┌──────────────┬────────────────────────────────┬──────────────────────────┐
│ NAVIGATION   │ LECTEUR PRINCIPAL              │ ENRICHISSEMENT IA        │
│ TOC/Signets/ │ (rendu fidèle format natif)    │ Résumé chapitre ($0)     │
│ Notes/Rech.  │ [contenu] [◀ Préc] X/N [Suiv▶] │ Concepts GLiNER (SMI)    │
│              │                                │ Mini COSMOS inline       │
│              │                                │ Cartes APEX liées        │
└──────────────┴────────────────────────────────┴──────────────────────────┘
[Source ingérée] → détection format → moteur rendu adapté (lazy) → TOC/zoom/recherche
  → sidebar enrichissement (résumé scy_chunks, GLiNER $0, mini COSMOS, APEX liées)
  → sélection texte → [Créer carte][Note][Définir] → scy_reader_annotations
  → progression → scy_reader_sessions
```
## Dépendances : `@react-pdf-viewer/core`, `epubjs`, `react-markdown`+`rehype-highlight`, `mammoth.js`, DOMPurify, KaTeX, cosmos.gl, GLiNER, react-data-grid, reveal.js. Tables : `scy_reader_sessions`, `scy_reader_annotations`.
## Fichiers : `frontend_react/src/reader/FileViewer.tsx`, `renderers/*.tsx`, `enrichment_sidebar.tsx`.

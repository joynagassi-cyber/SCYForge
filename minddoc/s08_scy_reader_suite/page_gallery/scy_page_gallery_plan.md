<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-PAGE-GALLERY — PLAN (PLAN)
**ID** : S08_READER_PAGE_GALLERY_PLAN · **Décision** : RS-005

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

## Flux
```
[Document généré (N pages)]
   │
   ▼
[PDF.js renderPage() → canvas → WebP 80% CÔTÉ CLIENT ($0 serveur)]
   │
   ▼
[Virtual scroll @tanstack/react-virtual : lazy pages visibles + 2 suivantes]
[Cache localStorage 24h]
   │
   ▼
[4 modes affichage : Large(3) / Normal(4-5) / Compact(6-8) / Strip(tactile)]
   │
   ▼
[Hover → tooltip section | clic → Web Viewer page | boutons Reader Suite/PDF/Book Orchestrator]
```
## Dépendances : `pdfjs-dist` (PDF.js), `@tanstack/react-virtual`, localStorage. Table : `scy_page_gallery_cache`.
## Fichiers : `frontend_react/src/reader/PageGallery.tsx`, `thumbnail_generator.ts`.

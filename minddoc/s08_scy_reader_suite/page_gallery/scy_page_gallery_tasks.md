<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-PAGE-GALLERY — TÂCHES (TASKS)
**ID** : S08_READER_PAGE_GALLERY_TASKS · **Décision** : RS-005

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

### Tâche PG.1 : Coder la génération miniatures côté client (25 min)
* **Fichier** : `frontend_react/src/reader/thumbnail_generator.ts`
* **Description** : PDF.js `renderPage()` → canvas → WebP 80% côté client ($0 serveur).
* **Critère** : Miniatures générées sans coût serveur.

### Tâche PG.2 : Coder le virtual scroll + cache 24h (20 min)
* **Fichier** : `frontend_react/src/reader/PageGallery.tsx`
* **Description** : `@tanstack/react-virtual` (lazy pages visibles + 2 suivantes) + cache localStorage 24h.
* **Critère** : Lazy loading fluide ; cache actif.

### Tâche PG.3 : Coder les 4 modes + interactions (20 min)
* **Fichier** : `frontend_react/src/reader/PageGallery.tsx`
* **Description** : Large/Normal/Compact/Strip + hover tooltip + clic→Web Viewer page + boutons Reader Suite/PDF/Book Orchestrator.
* **Critère** : 4 modes disponibles ; interactions fonctionnelles.

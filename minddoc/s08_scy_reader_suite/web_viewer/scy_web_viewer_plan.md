<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-WEB-VIEWER — PLAN (PLAN)
**ID** : S08_READER_WEB_VIEWER_PLAN

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

## Layout
```
┌─────────────────────────────────────────────────────────────────┐
│ 📄 [Nom fichier généré]   Score confiance: 91/100 🟢            │
│ ─────────────────────────────────────────────────────────────── │
│ [RENDU COMPLET DU DOCUMENT — READ ONLY — PAS D'INTERACTION]    │
│ ─────────────────────────────────────────────────────────────── │
│ [⬇ PDF][⬇ DOCX][⬇ MD]...   [📖 Reader Suite ▶] [🎭 Book Orch.]│
└─────────────────────────────────────────────────────────────────┘
```
## Flux : [Fichier généré NEURON-CHAINS] → WebViewer.tsx (rendu read-only, score T12 en-tête) → export 9 formats / transition Reader Suite / Book Orchestrator.
## Dépendances : T12 ConfidenceCalc, export 9 formats (§7.9). Fichiers : `frontend_react/src/reader/WebViewer.tsx`.

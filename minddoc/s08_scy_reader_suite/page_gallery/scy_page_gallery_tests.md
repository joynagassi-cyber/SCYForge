<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-PAGE-GALLERY — TESTS
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

**ID** : S08_READER_PAGE_GALLERY_TESTS

- **TC1** : Miniatures générées côté client (PDF.js → WebP, $0 serveur, RS-005).
- **TC2** : Virtual scroll (pages visibles + 2 suivantes générées en lazy).
- **TC3** : Cache localStorage 24h actif.
- **TC4** : 4 modes d'affichage (Large/Normal/Compact/Strip).
- **TC5** : Hover → tooltip titre section ; clic → Web Viewer à la page.
- **TC6** : Boutons Reader Suite / PDF / Book Orchestrator fonctionnels.

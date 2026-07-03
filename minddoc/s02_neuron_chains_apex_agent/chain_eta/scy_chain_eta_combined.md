<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-CHAIN-ETA — PLAN / TÂCHES / TESTS
**ID** : S02_NEURON_CHAIN_ETA_PLAN / TASKS / TESTS
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

## Flux : [docs ZETA] → ETA-1 export 9 formats (T15 : PDF Typst/DOCX/HTML/MD/LaTeX/.apkg/Excel/ZIP/CSV) → ETA-2 métadonnées (Dublin Core/Schema.org) → ETA-3 JSON Cognitif 360° (12 dimensions).
## Dépendances : T15 ExportFormatter, typst, docx, zip, rust_xlsxwriter, csv. Fichiers : `eta/export_formatter.rs`, `metadata_enricher.rs`, `cognitive_json.rs`.
## Tâches : ET.1 Export 9 formats (30min) | ET.2 Métadonnées (20min) | ET.3 JSON 360° (20min).
## Tests : TC1 9 formats | TC2 Dublin Core | TC3 JSON 12 dimensions valide.

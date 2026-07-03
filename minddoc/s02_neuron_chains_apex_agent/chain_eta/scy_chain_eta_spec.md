<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟡 SCY-CHAIN-ETA — EXPORT FINAL (SPEC)
**ID** : S02_NEURON_CHAIN_ETA_SPEC · **Phase** : V2

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

## 1. Purpose
La chaîne **ETA** produit les livrables finaux : export multi-formats (ETA-1, 9 formats), enrichissement métadonnées (ETA-2, Dublin Core / Schema.org), et génération du JSON Cognitif 360° (ETA-3, 12 dimensions).

## 2. Agents
* **ETA-1 Formateur Multi-Formats** : 9 formats (PDF Typst, DOCX, HTML, Markdown, LaTeX, Anki .apkg, Excel, ZIP, Notion CSV).
* **ETA-2 Enrichisseur Métadonnées** : Dublin Core, Schema.org.
* **ETA-3 JSON Cognitif 360°** : 12 dimensions sémantiques (machine-readable).

## 3. Requirements (RFC 2119)
- **GIVEN** Les documents finalisés par ZETA.
- **THEN** ETA-1 SHALL exporter en 9 formats (T15 ExportFormatter) ; ETA-2 SHALL enrichir les métadonnées (Dublin Core/Schema.org) ; ETA-3 SHALL générer le JSON Cognitif 360° (12 dimensions).

## 4. Tests
- **TC1** : 9 formats d'export générés correctement.
- **TC2** : Métadonnées Dublin Core/Schema.org présentes.
- **TC3** : JSON Cognitif 360° (12 dimensions) valide.

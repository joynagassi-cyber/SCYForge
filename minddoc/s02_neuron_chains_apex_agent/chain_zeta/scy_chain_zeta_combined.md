<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-CHAIN-ZETA — PLAN / TÂCHES / TESTS
**ID** : S02_NEURON_CHAIN_ZETA_PLAN / TASKS / TESTS
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

## Flux : [docs DELTA] → ZETA-1 harmonisation terminologie → ZETA-2 clarté (simplification jargon) → ZETA-3 tons (T14 StyleEnforcer, 50 tons→5 régimes, gabarit XML).
## Dépendances : T14 StyleEnforcer, 8 squelettes + 5 régimes (scy_cosmos_document_synthesis_specs.md). Fichiers : `zeta/style_harmonizer.rs`, `clarity_optimizer.rs`, `tone_adapter.rs`.
## Tâches : ZE.1 Harmoniseur (20min) | ZE.2 Clarté (20min) | ZE.3 Tons T14 (25min).
## Tests : TC1 terminologie cohérente | TC2 jargon simplifié | TC3 ton + gabarit XML.

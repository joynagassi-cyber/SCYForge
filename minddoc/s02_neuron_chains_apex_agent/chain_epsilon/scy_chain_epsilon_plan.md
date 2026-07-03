<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-CHAIN-EPSILON — PLAN (PLAN)
**ID** : S02_NEURON_CHAIN_EPSILON_PLAN
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

## Flux : [concepts/relations BETA] → EPSILON-1 cartes (12/nœud : 3×B02/B03/B04/B05) → EPSILON-2 exercices Template Gold (6 sections, 4 niveaux) → EPSILON-3 QCM (distracteurs erreurs communes) → validation Zod → `scy_apex_cards` + `scy_ascent_exercises`.
## Dépendances : LlmRouter+BudgetGuard, Zod. Tables : `scy_apex_cards`, `scy_ascent_exercises`.
## Fichiers : `backend_rs/src/neurochain/chains/epsilon/card_generator.rs`, `exercise_generator.rs`, `mcq_assembler.rs`.

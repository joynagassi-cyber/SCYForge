<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-CHAIN-GAMMA — PLAN / TÂCHES / TESTS
**ID** : S02_NEURON_CHAIN_GAMMA_PLAN / TASKS / TESTS
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

## Flux : [docs EPSILON] → GAMMA-1 contexte (histoire, applications) → GAMMA-2 analogies (B06) → GAMMA-3 exemples/contre-exemples/edge cases → enrichissement tracé.
## Dépendances : LlmRouter+BudgetGuard, RAG (sources). Fichiers : `gamma/contextualizer.rs`, `analogy_generator.rs`, `example_creator.rs`.
## Tâches : GA.1 Contextualiseur (20min) | GA.2 Analogies B06 (20min) | GA.3 Exemples+edge cases (25min).
## Tests : TC1 contexte tracé | TC2 analogies B06 | TC3 contre-exemples pertinents.

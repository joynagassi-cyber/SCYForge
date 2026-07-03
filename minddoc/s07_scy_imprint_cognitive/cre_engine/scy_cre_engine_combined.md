<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
IMPRINT ÉLIMINÉE. Contenu biblique incompatible avec cyber ops. Réécriture nécessaire.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-CRE-ENGINE — PLAN / TÂCHES / TESTS
**ID** : S07_IMPRINT_CRE_ENGINE_PLAN / TASKS / TESTS
---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | ELIMINATED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module est ÉLIMINÉ du beachhead**
• Conservé pour expansion future
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## Flux : [concept complexe] → Cran 1 (200-300) → Cran 2 (150-200) → Cran 3 (100-120) → Cran 4 (70-85) → Cran 5 (50-65, 5-7 insights Miller) → persistance `scy_imprint_registers`.
## Dépendances : NEURON-CHAINS (distillation), LlmRouter+BudgetGuard. Table : `scy_imprint_registers`.
## Fichiers : `backend_rs/src/imprint/cre/distiller.rs`.
## Tâches : CR.1 Coder les 5 crans de distillation (25min) | CR.2 Coder le déclenchement Agent-04 (20min).
## Tests : TC1 5 crans | TC2 Cran 5 5-7 insights | TC3 déclenchement (3 succès/SMI>75/complexité≥4).

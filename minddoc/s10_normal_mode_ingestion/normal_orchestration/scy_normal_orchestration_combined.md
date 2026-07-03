<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
Normal Mode ÉLIMINÉE. Beachhead = role-based onboarding.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-NORMAL-ORCHESTRATION — PLAN / TÂCHES / TESTS
**ID** : S10_NORMAL_MODE_ORCHESTRATION_PLAN / TASKS / TESTS
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

## Flux : [source ingérée Mode Normal] → activation immédiate COSMOS + APEX (FSRS) + BRAIN (0$ attente) → filtre intégrité minimal arrière-plan (anti-NaN/anti-÷0 softening_epsilon) → Parcours A (zéro certificat).
## Référence : `scy_normal_mode_orchestration_specs.md`.
## Fichiers : `backend_rs/src/normal/orchestrator.rs`, `integrity_filter.rs`.
## Tâches : NO.1 Activation immédiate COSMOS/APEX/BRAIN post-ingestion (25min) | NO.2 Filtre intégrité minimal (anti-NaN/÷0) (20min).
## Tests : TC1 activation 0$ attente | TC2 filtre sans blocage | TC3 zéro certificat (Parcours A).

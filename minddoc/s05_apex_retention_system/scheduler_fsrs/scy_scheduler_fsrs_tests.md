<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
APEX/FSRS en MVP simplifié. SMI Calculator gardé, scheduler complet différé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-SCHEDULER-FSRS — TESTS
---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

**ID** : S05_APEX_SCHEDULER_FSRS_TESTS

- **TC1** : Rating → S/D/next_review_at mis à jour ; R = e^(-t/S).
- **TC2** : Property-based (proptest) → aucune intervalle négative, stabilité > 0 (10 000 cas).
- **TC3** : Transitions d'état New→Learning→Review→Relearning→Review respectées.
- **TC4** : Effets Again (reset+lapse) / Hard (×0.5) / Good (×2.5) / Easy (×4.0+graduated) ; Undo (U/Ctrl+Z).
- **TC5** : ≥1000 révisions → 17 paramètres ajustés + différenciés par domaine.
- **TC6** : Forecast 30j calculé (cartes dues/jour) ; retention cible 90% (configurable 85-95%).
- **TC7** : 10 000 Monte Carlo hebdo → auto-calibration des constantes (D-OPT-028).
- **TC8** : `scy_apex_reviews` immuable (Event Sourcing RGPD, non modifiable).
- **TC9** : Aucun appel LLM dans le scheduler (Rust pur, $0).

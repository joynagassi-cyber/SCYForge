<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-SYNAPTIC-COMPETITION-RIF — TESTS
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

**ID** : S11_NEURO_SYNAPTIC_COMPETITION_RIF_TESTS · **Décisions** : D-OPT-010, D-OPT-009, D-OPT-023

- **TC1 (RIF)** : Rappel concept A → inhibition compétitive sur concurrents, modulée par V_n(t).
- **TC2 (Fail-Safe)** : Concurrent V < 25 → amortissement 90% de l'inhibition (D-OPT-010).
- **TC3 (Dormance)** : V au seuil dormance → archivage `scy_engram_vault` (J90).
- **TC4 (Prerequisite Booster)** : Ancêtre requis dormant (V<20) → booster planifié AVANT session active (D-OPT-023).
- **TC5 (No cascade)** : Simulation stress multi-concepts → aucune avalanche / cascade d'effondrement (Fail-Safe validé).

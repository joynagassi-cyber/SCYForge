<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-SYNAPTIC-COMPETITION-RIF — TÂCHES (TASKS)
**ID** : S11_NEURO_SYNAPTIC_COMPETITION_RIF_TASKS · **Décisions** : D-OPT-010, D-OPT-023

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

### Tâche RIF.1 : Coder le moteur de compétition RIF (25 min)
* **Fichier** : `backend_rs/src/neuro/rif/competition_engine.rs`
* **Description** : Inhibition compétitive RIF modulée par la vitalité V_n(t) des concurrents.
* **Critère** : Rappel de A → inhibition correcte sur concurrents (modulée par V).

### Tâche RIF.2 : Coder la Fail-Safe Gate anti-avalanche (25 min)
* **Fichier** : `backend_rs/src/neuro/rif/fail_safe_gate.rs`
* **Description** : Amortissement 90% si V < 25 (D-OPT-010) ; neutralisation avalanche/cascade.
* **Critère** : Concurrent V<25 → inhibition amortie 90% ; aucune cascade.

### Tâche RIF.3 : Coder l'archivage vault + Prerequisite Booster (25 min)
* **Fichier** : `backend_rs/src/neuro/rif/prerequisite_booster.rs`
* **Description** : Archivage `scy_engram_vault` au seuil dormance (J90, D-OPT-009) + booster prérequis dormant (V<20) avant session active (D-OPT-023).
* **Critère** : Dormance → vault ; ancêtre V<20 → booster planifié avant session.

### Tâche RIF.4 : Coder les tests de simulation stress (20 min)
* **Fichier** : `backend_rs/src/neuro/rif/fail_safe_gate.rs`
* **Description** : Simulation stress multi-concepts pour valider l'absence de cascade.
* **Critère** : Aucune cascade d'effondrement sur simulation stress.

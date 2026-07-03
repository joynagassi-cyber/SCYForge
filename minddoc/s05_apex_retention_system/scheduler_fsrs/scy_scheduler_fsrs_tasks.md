<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
APEX/FSRS en MVP simplifié. SMI Calculator gardé, scheduler complet différé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-SCHEDULER-FSRS — TÂCHES (TASKS)
**ID** : S05_APEX_SCHEDULER_FSRS_TASKS

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

### Tâche SF.1 : Coder le moteur FSRS + recalcul S/D/R (25 min)
* **Fichier** : `backend_rs/src/apex/scheduler/fsrs_engine.rs`
* **Description** : Intégration `fsrs` 0.6, recalcul S/D/`R=e^(-t/S)`/next_review_at après rating.
* **Critère** : Recalcul correct ; R formule officielle.

### Tâche SF.2 : Coder la machine à états + feedback 4 niveaux (25 min)
* **Fichier** : `backend_rs/src/apex/scheduler/fsrs_engine.rs`
* **Description** : Transitions New→Learning→Review→Relearning, effets Again/Hard/Good/Easy, Undo (U/Ctrl+Z).
* **Critère** : Transitions et effets corrects ; Undo fonctionnel.

### Tâche SF.3 : Coder les tests property-based (20 min)
* **Fichier** : `backend_rs/src/apex/scheduler/fsrs_engine.rs`
* **Description** : proptest (D-ARC-012) — aucune intervalle négative, stabilité > 0.
* **Critère** : Invariant respecté sur 10 000 cas aléatoires.

### Tâche SF.4 : Coder la calibration + par domaine (25 min)
* **Fichier** : `backend_rs/src/apex/scheduler/calibrator.rs`
* **Description** : Ajustement 17 paramètres après ≥1000 révisions + différenciation par domaine (PAPER-005).
* **Critère** : Paramètres ajustés personnellement et par domaine.

### Tâche SF.5 : Coder Forecast + Monte Carlo Self-Consistency (25 min)
* **Fichiers** : `forecast.rs`, `monte_carlo_checker.rs`
* **Description** : Forecast 30j (bar chart) + retention cible 90% + 10 000 Monte Carlo hebdo (D-OPT-028).
* **Critère** : Forecast 30j correct ; Monte Carlo auto-calibre les constantes.

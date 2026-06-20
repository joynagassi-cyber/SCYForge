# 🛠️ SCY-SYNAPTIC-COMPETITION-RIF — PLAN (PLAN)
**ID** : S11_NEURO_SYNAPTIC_COMPETITION_RIF_PLAN · **Décisions** : D-OPT-010, D-OPT-009, D-OPT-023

## Flux
```
[Rappel actif concept A (session APEX)]
   │
   ▼
[Identification concepts concurrents sémantiquement proches]
   │
   ▼
[Calcul inhibition RIF modulée par vitalité V_n(t) des concurrents]
   │
   ├── Concurrent V ≥ 25 ──► Inhibition RIF normale
   │
   └── Concurrent V < 25 ──► FAIL-SAFE GATE (amortissement 90%, D-OPT-010)
                              │
                              └── Neutralise avalanche / cascade d'effondrement
   │
   ▼
[Si V → seuil dormance ──► archivage scy_engram_vault (J90, D-OPT-009)]
   │
   ▼
[Prerequisite Booster : si ancêtre requis dormant (V<20) ──► booster planifié AVANT session active (D-OPT-023)]
```
## Dépendances : vitalité `V_n(t)` (sigmoïde D-OPT-009, moteur engram_decay_vitality), `scy_engram_vault`, APEX FSRS.
## Fichiers : `backend_rs/src/neuro/rif/competition_engine.rs`, `fail_safe_gate.rs`, `prerequisite_booster.rs`.

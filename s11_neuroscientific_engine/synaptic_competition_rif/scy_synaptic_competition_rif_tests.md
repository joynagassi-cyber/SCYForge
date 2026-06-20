# 🧪 SCY-SYNAPTIC-COMPETITION-RIF — TESTS
**ID** : S11_NEURO_SYNAPTIC_COMPETITION_RIF_TESTS · **Décisions** : D-OPT-010, D-OPT-009, D-OPT-023

- **TC1 (RIF)** : Rappel concept A → inhibition compétitive sur concurrents, modulée par V_n(t).
- **TC2 (Fail-Safe)** : Concurrent V < 25 → amortissement 90% de l'inhibition (D-OPT-010).
- **TC3 (Dormance)** : V au seuil dormance → archivage `scy_engram_vault` (J90).
- **TC4 (Prerequisite Booster)** : Ancêtre requis dormant (V<20) → booster planifié AVANT session active (D-OPT-023).
- **TC5 (No cascade)** : Simulation stress multi-concepts → aucune avalanche / cascade d'effondrement (Fail-Safe validé).

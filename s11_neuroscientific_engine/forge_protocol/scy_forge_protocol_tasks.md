# 📋 SCY-FORGE-PROTOCOL — TÂCHES (TASKS)
**ID** : S11_NEURO_FORGE_PROTOCOL_TASKS · **Décision** : D-OPT-014

### Tâche FP.1 : Coder la génération du challenge Feynman à trous (25 min)
* **Fichier** : `backend_rs/src/neuro/forge/forge_challenge.rs`
* **Description** : Génération (NEURON-CHAINS) d'un trou sémantique ciblé sur le concept clé du nœud.
* **Critère** : Challenge cohérent avec le concept réel.

### Tâche FP.2 : Coder la gate d'amorce obligatoire + évaluation (25 min)
* **Fichier** : `backend_rs/src/neuro/forge/forge_evaluator.rs`
* **Description** : Gate bloquante avant affichage (interdit passif, D-OPT-014) + évaluation APEX-AGENT (Zod).
* **Critère** : Aucun contenu affiché sans amorce ; évaluation tracée.

### Tâche FP.3 : Coder le fallback ELI5 + mesure rétention (20 min)
* **Fichier** : `backend_rs/src/neuro/forge/forge_evaluator.rs`
* **Description** : 2 échecs consécutifs → aide ELI5 (D-OPT-024) ; mesure rétention APEX FSRS.
* **Critère** : Fallback ELI5 après 2 échecs ; gain rétention mesurable.

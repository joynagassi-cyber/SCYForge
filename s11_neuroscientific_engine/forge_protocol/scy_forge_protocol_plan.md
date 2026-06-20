# 🛠️ SCY-FORGE-PROTOCOL — PLAN (PLAN)
**ID** : S11_NEURO_FORGE_PROTOCOL_PLAN · **Décision** : D-OPT-014

## Flux
```
[Utilisateur demande à voir un contenu éducatif (Knowledge Card / cours)]
   │
   ▼
[Génération challenge Feynman à trous (NEURON-CHAINS, concept clé du nœud)]
   │
   ▼
[Amorce exigée AVANT affichage (interdit affichage passif, D-OPT-014)]
   │
   ├── Réussite ──► Affichage contenu + mesure rétention (APEX FSRS)
   │
   └── Échec (×2 consécutif sur nœud difficile)
        │
        ▼
   [Affichage aide instantanée ELI5 (D-OPT-024) → neutralise frustration]
        │
        ▼
   [Accès au contenu garanti (pas de blocage)]
```
## Dépendances : APEX-AGENT (évaluation), NEURON-CHAINS (challenge), ELI5 fallback (D-OPT-024), APEX FSRS (mesure rétention).
## Fichiers : `backend_rs/src/neuro/forge/forge_challenge.rs`, `forge_evaluator.rs`.

# 🛠️ SCY-FRICTION-MODE — PLAN (PLAN)
**ID** : S11_NEURO_FRICTION_MODE_PLAN · **Décisions** : D-OPT-015, D-OPT-049

## Flux
```
[Session APEX active — Mode FRICTION activé]
   │
   ▼
[ADAPTIVE-ROUTER (AGENT-06, Rust déterministe) : entrelacement 70% domaine cible / 30% connexes maîtres (D-OPT-049)]
   │
   ▼
[Désactivation barres de progression UI pendant session active (D-OPT-015)]
   │
   ▼
[Casse de l'habituation cognitive du cortex visuel → ×2 rétention long terme]
   │
   ▼
[Mesure rétention APEX FSRS (comparaison fluide vs FRICTION)]
```
## Dépendances : ADAPTIVE-ROUTER (AGENT-06), UI session, APEX FSRS. Fichiers : `backend_rs/src/neuro/friction/interleaver.rs`, `frontend_react/src/apex/FrictionSessionUI.tsx`.

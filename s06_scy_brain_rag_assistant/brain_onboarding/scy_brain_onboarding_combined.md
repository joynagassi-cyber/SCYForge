# 🛠️ SCY-BRAIN-ONBOARDING — PLAN / TÂCHES / TESTS
**ID** : S06_BRAIN_ONBOARDING_PLAN / TASKS / TESTS

## Flow
```
[Mode Guest Phase 0 : objectif/source sans compte (localStorage UUID anonyme)]
   │
   ▼
[Phase 1 Flow Gamifié]
   Étape 1 (15s) : Choix objectif → feedback immédiat
   Étape 2 (10s) : Niveau (Débutant→Avancé)
   Étape 3 (10s) : Temps disponible
   Étape 4 (<90s) : 1 nœud ASCENT + 3 cartes APEX + 1 session → confetti + SMI 45 🎉
   Étape 5 : Email capture POST-succès
   │
   ▼
[Création compte → migration auto contenu guest]
```
## Dépendances : localStorage, ASCENT (nœud + cartes), APEX (session), animation confetti. 
## Fichiers : `frontend_react/src/brain/onboarding/GuestMode.tsx`, `OnboardingFlow.tsx`, `ProgressBar.tsx`.

## Tâches
- OB.1 : Coder le Mode Guest (localStorage, migration auto) (25 min).
- OB.2 : Coder le flow 5 étapes + premier succès <90s (30 min).
- OB.3 : Coder la progress bar + métriques (20 min).

## Tests
- TC1 : Guest (objectif sans compte, migration auto). | TC2 : 5 étapes, premier succès <90s confetti. | TC3 : progress bar dès étape 1. | TC4 : TTFV <2min, complétion >70%, conversion >40%.

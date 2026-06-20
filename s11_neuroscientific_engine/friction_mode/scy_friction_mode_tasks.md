# 📋 SCY-FRICTION-MODE — TÂCHES (TASKS)
**ID** : S11_NEURO_FRICTION_MODE_TASKS · **Décisions** : D-OPT-015, D-OPT-049

### Tâche FM.1 : Coder l'entrelacement 70/30 (20 min)
* **Fichier** : `backend_rs/src/neuro/friction/interleaver.rs`
* **Description** : ADAPTIVE-ROUTER déterministe — 70% domaine cible / 30% connexes maîtres.
* **Critère** : Ratio 70/30 respecté (déterministe, pas aléatoire).

### Tâche FM.2 : Coder la désactivation des barres de progression (15 min)
* **Fichier** : `frontend_react/src/apex/FrictionSessionUI.tsx`
* **Description** : Masquage barres de progression pendant session active.
* **Critère** : Barres masquées en session FRICTION active.

### Tâche FM.3 : Intégrer la mesure de rétention (15 min)
* **Fichier** : `backend_rs/src/neuro/friction/interleaver.rs`
* **Description** : Mesure APEX FSRS (comparaison fluide vs FRICTION).
* **Critère** : Gain de rétention mesurable (×2 objectif).

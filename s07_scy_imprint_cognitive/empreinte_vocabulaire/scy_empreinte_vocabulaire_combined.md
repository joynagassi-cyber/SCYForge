# 🛠️ SCY-EMPREINTE-VOCABULAIRE — PLAN / TÂCHES / TESTS
**ID** : S07_IMPRINT_EMPREINTE_VOCABULAIRE_PLAN / TASKS / TESTS
## Flux : [domaine linguistique] → sélection 10 mots (IA) → fiche étymologique (phonétique/étymo DELTA/définition GAMMA-3) → Tree Renderer (dérivation + 3 synonymes + phrase) → écriture manuscrite → validation active (synonyme exact OU Cloze L4) → déverrouillage mot suivant.
## Dépendances : DELTA (étymologie), GAMMA-3 (définition/exemple), Tree Renderer, Cloze. 
## Fichiers : `backend_rs/src/imprint/vocab/word_selector.rs`, `etymology_card.rs`, `validation.rs`.
## Tâches : EV.1 Sélection 10 mots + fiche étymologique (25min) | EV.2 Validation active (synonyme/Cloze L4) (20min).
## Tests : TC1 10 mots | TC2 fiche étymologique | TC3 validation active verrouille progression.

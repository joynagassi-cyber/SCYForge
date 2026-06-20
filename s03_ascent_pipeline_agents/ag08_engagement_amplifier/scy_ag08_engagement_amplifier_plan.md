# 🛠️ SCY-AG08-ENGAGEMENT-AMPLIFIER — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG08_ENGAGEMENT_AMPLIFIER_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données de l'Agent

```
 [Événements : NodeCompleted / ExerciseCompleted / CardReviewed / SessionEnded]
                 │
                 ▼
   [Step Mastra : engagementAmplifierStep]
                 │
   [Attribution XP selon règles + maj niveau (mfg_user_xp)]
                 │
        ┌────────┴───────────────┐
        ▼                        ▼
  [Badges : seuil atteint ?     [Streaks : activité
   → débloquer (mfg_badges)]    quotidienne continue]
        │                        │
        └────────┬───────────────┘
                 ▼
   [Notification COSMOS / CHRONICLE]

 [Écoute AGENT-07 : drift → micro-objectif récompensé]
```

---

## 2. Dépendances Techniques Strictes
* **Événements** : `NodeCompleted`, `ExerciseCompleted`, `CardReviewed`, `SessionEnded`.
* **Moteur gamification** : règles XP/niveaux, badges, streaks.
* **Zod** : `RewardSchema`.
* **Tables** : `mfg_user_xp`, `mfg_badges`, `mfg_streaks`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag08_engagement_amplifier.ts`** : Step Mastra (gamification).
- **`backend_ts/src/ascent/gamification/xp_rules.ts`** : Règles d'XP et de niveaux.
- **`backend_ts/src/ascent/gamification/badges.ts`** : Bibliothèque de badges.
- **`mfg_user_xp`**, **`mfg_badges`**, **`mfg_streaks`** : Persistance.

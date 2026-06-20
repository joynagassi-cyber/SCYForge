# 🛠️ SCY-AG04-LEARNING-CONDUCTOR — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG04_LEARNING_CONDUCTOR_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données de l'Agent

```
 [Nœud + sources ingérées (AGENT-02/03)]
                 │
                 ▼
   [Step Mastra : learningConductorStep]
                 │
        ┌────────┼─────────────┬──────────────┐
        ▼         ▼             ▼              ▼
  [NEURON-    [APEX/FSRS    [COSMOS         [SCY-IMPRINT
   CHAINS]     flashcards]   roadmap]       mémorisation]
   (docs       + exercices   (présentation)  profonde]
    pédago.)   actifs)
        │         │             │              │
        └────────┬─────────────┴──────────────┘
                 ▼
   [Session active → ExerciseCompleted / CardReviewed]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [SMI cible atteinte ?     [Session terminée]
   (signal AGENT-05)]
        │                     │
        ▼                     ▼
  [NodeCompleted +         [SessionEnded +
   NodeUnlocked             planif. FSRS +
   (nœuds dépendants)]      IMPRINT]
```

---

## 2. Dépendances Techniques Strictes
* **Modules orchestrés** : NEURON-CHAINS, APEX/FSRS 5.0, SCY-IMPRINT, COSMOS.
* **EventBus** : `SessionEnded`, `ExerciseCompleted`, `CardReviewed`, `NodeCompleted`, `NodeUnlocked`.
* **Zod** : `SessionSchema`, `ExerciseSchema`.
* **Tables** : `mfg_sessions`, `mfg_ascent_nodes` (statut).

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag04_learning_conductor.ts`** : Step Mastra (orchestration session).
- **`backend_ts/src/ascent/schemas/session_schema.ts`** : Schémas Zod session/exercice.
- **`mfg_sessions`** : Sessions d'apprentissage (user_id, node_id, duration, cards_reviewed).
- **`mfg_ascent_nodes`** : Mise à jour du statut (unlocked/completed).

# 🛠️ SCY-AG11-ARENA — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG11_ARENA_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données de l'Agent

```
 [Domaine + objectif (AGENT-09)]
                 │
                 ▼
   [Step Mastra : arenaStep]
                 │
   [Génération scénario (LLM) + grille d'évaluation mesurable]
                 │
        ┌────────┴────────┐
        ▼                 ▼
  [Validation AGENT-13    [Échec validation
   (cohérence/réalisme)]   → régénération]
        │
        ▼
   [Déroulement roleplay multi-tours
    (agents-rôles LLM, BudgetGuard)]
                 │
                 ▼
   [Session terminée → transcription enregistrée]
                 │
                 ▼
   [Scoring selon grille + feedback ciblé]
                 │
        ┌────────┴────────┐
        ▼                 ▼
  [Score ≥ seuil →       [< seuil → composante
   composante pratique    pratique échouée]
   validée (AGENT-09)]
```

---

## 2. Dépendances Techniques Strictes
* **LLM** : LlmRouter + BudgetGuard (génération scénario + agents-rôles).
* **Validation** : AGENT-13 (cohérence cognitive).
* **Zod** : `ScenarioSchema`, `ArenaScoreSchema`.
* **Tables** : `mfg_arena_sessions`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag11_arena.ts`** : Step Mastra (simulation).
- **`backend_ts/src/ascent/arena/scenario_generator.ts`** : Génération scénario + grille.
- **`backend_ts/src/ascent/arena/role_agent.ts`** : Agents-rôles (réponses contextualisées).
- **`backend_ts/src/ascent/arena/evaluator.ts`** : Scoring selon grille + feedback.
- **`mfg_arena_sessions`** : Persistance (scénario, transcription, score, feedback).

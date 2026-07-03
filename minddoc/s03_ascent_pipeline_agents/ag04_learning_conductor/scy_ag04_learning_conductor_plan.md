<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-AG04-LEARNING-CONDUCTOR — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG04_LEARNING_CONDUCTOR_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

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

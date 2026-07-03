<!--
BEACHHEAD PIVOT v2.0 — UNKNOWN
Module non classifié.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# SCY FORGE — CODE STYLE
---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | UNKNOWN |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• À vérifier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## Conventions et Patterns de Référence

---

## 1. RUST — Conventions

### 1.1 Nommage
- **Structs/Enums** : `PascalCase` → `UserAutomationPrefs`, `AutomationLevel`
- **Fonctions/Méthodes** : `snake_case` → `calculate_smi`, `detect_drift`
- **Constants** : `SCREAMING_SNAKE_CASE` → `MAX_CONCURRENT_INGESTIONS`
- **Modules** : `snake_case` → `fsrs_engine`, `dead_letter_queue`
- **Crates** : `scy-kebab-case` → `scy-apex-fsrs`, `scy-neuron-chains`

### 1.2 Pattern de référence — Service Transverse (exemple FSRS)

```rust
// backend_rs/crates/scy-apex-fsrs/src/scheduler/fsrs_engine.rs

use serde::{Deserialize, Serialize};
use thiserror::Error;

/// Erreurs FSRS typées
#[derive(Debug, Error)]
pub enum FsrsError {
    #[error("Invalid rating: must be 1-4, got {0}")]
    InvalidRating(u8),
    #[error("Card not found: {0}")]
    CardNotFound(uuid::Uuid),
    #[error("Stability cannot be negative")]
    NegativeStability,
}

/// Paramètres FSRS d'une carte
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FsrsState {
    pub stability: f64,     // S — jours pour R=90%
    pub difficulty: f64,    // D — 1.0 à 10.0
    pub state: CardState,   // New/Learning/Review/Relearning
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum CardState {
    New,
    Learning,
    Review,
    Relearning,
}

/// Recalcule FSRS après une révision (Rust pur, 0 LLM)
///
/// # Arguments
/// * `current` - L'état FSRS actuel de la carte
/// * `rating` - Le feedback utilisateur (1=Again, 2=Hard, 3=Good, 4=Easy)
/// * `elapsed_days` - Jours écoulés depuis la dernière révision
///
/// # Returns
/// Le nouvel état FSRS + la prochaine date de révision
///
/// # Errors
/// Retourne `FsrsError::InvalidRating` si rating ∉ [1,4]
/// Retourne `FsrsError::NegativeStability` si S devient négatif (invariant)
pub fn recalculate(
    current: &FsrsState,
    rating: u8,
    elapsed_days: f64,
) -> Result<FsrsState, FsrsError> {
    if !(1..=4).contains(&rating) {
        return Err(FsrsError::InvalidRating(rating));
    }

    let multiplier = match rating {
        1 => 0.30,  // Again → reset quasi-complet
        2 => 0.50,  // Hard
        3 => 2.50,  // Good
        4 => 4.00,  // Easy
        _ => unreachable!(),
    };

    let new_stability = current.stability * multiplier;

    // INVARIANT : stability ne peut JAMAIS être négative (property-based test)
    if new_stability < 0.0 {
        return Err(FsrsError::NegativeStability);
    }

    // Softening epsilon anti-division-par-zéro
    let epsilon = 1e-6;
    let retrievability = (-elapsed_days / (new_stability + epsilon)).exp();

    let new_state = match rating {
        1 => CardState::Relearning,  // Again → Relearning
        _ if current.state == CardState::New || current.state == CardState::Learning => {
            CardState::Learning
        }
        _ => CardState::Review,
    };

    Ok(FsrsState {
        stability: new_stability,
        difficulty: current.difficulty,  // ajusté séparément
        state: new_state,
    })
}

// Dans le fichier de tests :
#[cfg(test)]
mod tests {
    use super::*;
    use proptest::prelude::*;

    proptest! {
        /// PROPERTY-BASED : FSRS ne produit JAMAIS une stability négative
        #[test]
        fn fsrs_never_negative_stability(
            stability in 0.1f64..1000.0,
            difficulty in 1.0f64..10.0,
            rating in 1u8..=4u8,
            elapsed in 0.0f64..365.0,
        ) {
            let current = FsrsState { stability, difficulty, state: CardState::Review };
            let result = recalculate(&current, rating, elapsed);
            prop_assert!(result.is_ok());
            let new_state = result.unwrap();
            prop_assert!(new_state.stability >= 0.0);
        }
    }
}
```

### 1.3 Error Handling
```rust
// TOUJOURS utiliser Result<T, E> — jamais panic! en production
// Utiliser thiserror pour les erreurs de library
// Utiliser anyhow pour les erreurs d'application

// ✅ BON
pub fn ingest(url: &str) -> Result<Source, IngestionError> { ... }

// ❌ MAUVAIS
pub fn ingest(url: &str) -> Source { ... }  // peut panic
```

### 1.4 Async
```rust
// TOUJOURS async avec tokio (jamais std::thread)
// CancellationToken pour annulation propre (D-OPT-059)

pub async fn generate_document(
    node: &AscentNode,
    cancel_token: CancellationToken,
) -> Result<Document, NeuronChainError> {
    tokio::select! {
        _ = cancel_token.cancelled() => Err(NeuronChainError::Cancelled),
        result = apex_agent.generate(node) => result,
    }
}
```

---

## 2. TYPESCRIPT — Conventions

### 2.1 Nommage
- **Interfaces/Types** : `PascalCase` → `GoalSchema`, `AgentProposal`
- **Fonctions** : `camelCase` → `calculateSmri`, `detectDrift`
- **Constantes** : `SCREAMING_SNAKE_CASE` → `MAX_WIP_LIMIT`
- **Fichiers** : `camelCase.ts` ou `kebab-case.ts`

### 2.2 Pattern de référence — Agent Mastra (exemple Agent-01)

```typescript
// backend_ts/src/ascent/agents/ag01_goal_interpreter.ts

import { Step } from '@mastra/core';
import { z } from 'zod';
import { llmRouter, budgetGuard } from '../infra/llm';
import { cosmos } from '../infra/cosmos';
import { eventBus } from '../infra/eventbus';

// Schéma Zod strict (obligatoire pour tout retour LLM)
export const GoalSchema = z.object({
  domain: z.string().min(1),
  sub_skills: z.array(z.string()).min(1),
  level_target: z.enum(['beginner', 'intermediate', 'advanced', 'expert']),
  constraints: z.object({
    duration_weeks: z.number().positive(),
    weekly_hours: z.number().positive(),
  }),
  criteria: z.array(z.object({
    type: z.enum(['smi_threshold', 'proof_of_skill', 'exercise_score']),
    target: z.number(),
    description: z.string(),
  })).min(1),
});

export type Goal = z.infer<typeof GoalSchema>;

export const goalInterpreterStep = new Step({
  id: 'goal-interpreter',
  execute: async ({ context }) => {
    const rawGoal = context.userInput as string;

    // 1. Consulter le BudgetGuard avant l'appel LLM
    await budgetGuard.checkBudget(context.userId, 'goal-interpretation');

    // 2. Appeler le LLM (DeepSeek V4, prompt caching)
    const prompt = buildGoalPrompt(rawGoal);
    const response = await llmRouter.complete({
      model: 'deepseek-v4',
      system: GOAL_SYSTEM_PROMPT,  // statique (cacheable)
      user: prompt,
    });

    // 3. Valider STRICTEMENT avec Zod (retry si invalide)
    let goal: Goal;
    try {
      goal = GoalSchema.parse(JSON.parse(response.content));
    } catch (e) {
      // Retry avec correction
      const fixed = await llmRouter.complete({
        model: 'deepseek-v4',
        system: GOAL_FIX_PROMPT,
        user: `${response.content}\n\nFix: ${e.message}`,
      });
      goal = GoalSchema.parse(JSON.parse(fixed.content));
    }

    // 4. Persister (Outbox pattern pour cohérence transactionnelle)
    await persistGoal(context.userId, goal);

    // 5. Émettre l'événement
    await eventBus.publish({
      type: 'GoalInterpreted',
      userId: context.userId,
      goalId: goal.id,
      domain: goal.domain,
    });

    return { goal, status: 'interpreted' };
  },
});
```

### 2.3 Zod Validation (obligatoire)
```typescript
// TOUJOURS valider les retours LLM et les inputs API avec Zod

// ✅ BON
const result = GoalSchema.parse(llmResponse);

// ❌ MAUVAIS
const result = llmResponse as Goal;  // pas de validation
```

---

## 3. REACT — Conventions

### 3.1 Nommage
- **Composants** : `PascalCase` → `CosmosGraph2D`, `SessionView`
- **Hooks** : `useCamelCase` → `useProjectGraph`, `useAscentStore`
- **Fichiers** : `PascalCase.tsx` → `KanbanBoard.tsx`
- **CSS** : TailwindCSS uniquement (pas de CSS custom sauf tokens)

### 3.2 Pattern de référence — Composant avec Zustand

```tsx
// frontend_react/src/cosmos/CosmosGraph2D.tsx

import React, { useEffect, useRef } from 'react';
import { useProjectGraphStore } from '../stores/useProjectGraphStore';
import { useHiDPI } from '../hooks/useHiDPI';

interface CosmosGraph2DProps {
  mode?: number;  // optionnel : si non fourni, l'agent sélectionne
}

export const CosmosGraph2D: React.FC<CosmosGraph2DProps> = ({ mode }) => {
  const mountRef = useRef<HTMLDivElement>(null);
  const graph = useProjectGraphStore((s) => s.graph);
  const smiColors = useProjectGraphStore((s) => s.smiColors);
  useHiDPI(mountRef);

  useEffect(() => {
    if (!mountRef.current || !graph) return;

    // Lazy-load G6 (D-RENDER-005)
    import('@antv/g6').then(({ Graph, forceAtlas2Layout }) => {
      const g6Graph = new Graph({
        container: mountRef.current!,
        // ... config G6
        layout: new forceAtlas2Layout({ /* ... */ }),
        nodeStyle: (node) => ({
          // Couleur du nœud = SMI (D-COSMOS-018)
          fill: smiColors[node.data.smi] ?? '#666',
        }),
      });
      g6Graph.setData(graph);
      g6Graph.render();
    });

    return () => {
      // Nettoyage obligatoire (D-RESILIENCE-003)
      if (mountRef.current) {
        mountRef.current.innerHTML = '';
      }
    };
  }, [graph, smiColors]);

  return <div ref={mountRef} style={{ width: '100%', height: '100%' }} />;
};
```

### 3.3 TailwindCSS — Tokens Design
```tsx
// TOUJOURS utiliser les tokens design.md
// JAMAIS de couleurs hors palette

// ✅ BON (tokens)
<div className="bg-ink-black text-electric-blue border-emerald-green" />

// ❌ MAUVAIS (couleurs hors tokens)
<div className="bg-red-500 text-blue-300" />
```

### 3.3 Règles Frontend
- **Lazy-loading** : tous les engines COSMOS sont chargés à la demande (`import()`).
- **Zustand** : state management global (pas de Redux).
- **Virtualisation** : `@tanstack/react-virtual` pour les listes > 50 items.
- **SSE Streaming** : `EventSource` pour le streaming BRAIN/NEURON-CHAINS.
- **Accessibility** : WCAG 2.1 AA (ARIA, keyboard 100%, contraste ≥ 4.5:1).

---

## 4. SQL — Conventions

### 4.1 Règles
- **Préfixe** : toutes les tables commencent par `scy_`
- **IDs** : `UUID DEFAULT gen_uuid_v7()` (time-ordered)
- **Timestamps** : `INTEGER NOT NULL` (Unix epoch, PAS DATETIME)
- **Soft Delete** : `deleted_at INTEGER NULL`
- **RLS** : toutes les tables avec `user_id` ont une policy RLS
- **JSONB** : pour les données flexibles (fsrs_state, metadata, dag_template)

### 4.2 Pattern de référence — Création de table

```sql
-- Toujours avec RLS, UUID v7, timestamps Unix
CREATE TABLE scy_example (
    id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id UUID NOT NULL REFERENCES scy_users(id),
    
    -- Données
    name TEXT NOT NULL,
    data JSONB DEFAULT '{}',
    
    -- Timestamps Unix (PAS DATETIME)
    created_at INTEGER NOT NULL DEFAULT extract(epoch from now())::INTEGER,
    updated_at INTEGER NOT NULL DEFAULT extract(epoch from now())::INTEGER,
    deleted_at INTEGER NULL,
    
    -- Index
    CONSTRAINT example_name_check CHECK (length(name) > 0)
);

-- Index performance
CREATE INDEX idx_example_user ON scy_example(user_id, created_at DESC)
    WHERE deleted_at IS NULL;

-- RLS (Row Level Security — OBLIGATOIRE)
ALTER TABLE scy_example ENABLE ROW LEVEL SECURITY;
CREATE POLICY example_isolation ON scy_example
    USING (user_id = current_setting('app.current_user_id')::uuid);
```

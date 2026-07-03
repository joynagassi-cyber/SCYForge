<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ENGINE-G6 — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_G6_PLAN  
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

## 1. Flux de Données

```
 [Graphe COSMOS (nœuds + arêtes + poids)]
 [EventBus : KnowledgeGraphUpdated]
                 │
                 ▼
   [Validation Zod des données graphe]
                 │
                 ▼
   [Composant React : CosmosGraph2D.tsx]
                 │
   [AntV G6 v5 : Graph + layout force-directed (enveloppe axiale polaire)]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [Optimisations :          [Rendu WebGL
   LOD + Barnes-Hut +         (coupe axiale 2D)
   Object Pooling]            palette design.md]
        │                     │
        └────────┬────────────┘
                 ▼
   [Interactivité : zoom / pan / sélection nœud → détail]
```

---

## 2. Dépendances Techniques Strictes
* **AntV G6 v5** : `@antv/g6` (Graph API v5, layouts, renderer WebGL).
* **React 18** : composant `CosmosGraph2D.tsx`.
* **Optimisations** : LOD, Barnes-Hut, Object Pooling (G6 plugins/configs).
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/components/CosmosGraph2D.tsx`** : Composant React principal G6 v5.
- **`frontend_react/src/cosmos/g6_layout.ts`** : Configuration layout force-directed + enveloppe axiale.
- **`frontend_react/src/cosmos/g6_perf.ts`** : LOD + Barnes-Hut + Object Pooling.
- **`frontend_react/src/cosmos/schemas/graph_schema.ts`** : Validation Zod du graphe.

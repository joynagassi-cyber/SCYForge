<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ENGINE-REACT-FLOW — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_REACT_FLOW_PLAN  
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
 [DAG ASCENT (AGENT-03)] + [EventBus : DagBuilt / NodeCompleted / NodeUnlocked]
                 │
                 ▼
   [Validation Zod du DAG]
                 │
                 ▼
   [Composant React : AscentRoadmap.tsx (React Flow)]
                 │
   [Layout dirigé dagre (ordre topologique)]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [Statuts nœuds :          [Styles par statut
   acquis/débloqué/          + chemins critiques
   verrouillé/complété]      + goulots mis en évidence]
        │                     │
        └────────┬────────────┘
                 ▼
   [Interactivité : zoom / pan / mini-map / sélection → détail]
```

---

## 2. Dépendances Techniques Strictes
* **React Flow** : `@xyflow/react` (CustomNode, edges, MiniMap, Controls).
* **dagre** : layout dirigé (ordre topologique).
* **React 18** : composant `AscentRoadmap.tsx`.
* **EventBus** : `DagBuilt`, `NodeCompleted`, `NodeUnlocked`.
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/components/AscentRoadmap.tsx`** : Composant React Flow principal.
- **`frontend_react/src/cosmos/reactflow_nodes.tsx`** : Nœuds personnalisés (par statut).
- **`frontend_react/src/cosmos/dagre_layout.ts`** : Layout dirigé dagre.
- **`frontend_react/src/cosmos/schemas/dag_schema.ts`** : Validation Zod du DAG (partagé avec AGENT-03).

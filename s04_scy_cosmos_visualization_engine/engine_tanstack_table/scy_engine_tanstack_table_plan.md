# 🛠️ SCY-ENGINE-TANSTACK-TABLE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_TANSTACK_TABLE_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données

```
 [Array concepts (Nom, Domaine, SMI, Stabilité FSRS, Difficulté, Date)]
                 │
                 ▼
   [Validation Zod des attributs]
                 │
                 ▼
   [Composant React : ConceptsGrid.tsx (TanStack Table v8 + react-virtual)]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [Colonnes d'attributs      [Virtual scrolling
   + cellule SMI badge       (nombre infini de lignes
   couleur Rouge→Vert]       à 60 FPS, 0 GPU)]
        │                     │
        └────────┬────────────┘
                 ▼
   [Tri (Stabilité FSRS croissante) + filtre domaine/SMI]
                 │
                 ▼
   [Clic ligne → Drawer Knowledge Card complète]
```

---

## 2. Dépendances Techniques Strictes
* **TanStack Table** : `@tanstack/react-table` v8.x.
* **Virtual scroll** : `@tanstack/react-virtual` v3.x (déjà dans la stack).
* **React 18** : composant `ConceptsGrid.tsx`.
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/components/ConceptsGrid.tsx`** : Composant React TanStack Table.
- **`frontend_react/src/cosmos/modes/`** : composant M5.
- **`frontend_react/src/cosmos/schemas/concept_schema.ts`** : Validation Zod des attributs.

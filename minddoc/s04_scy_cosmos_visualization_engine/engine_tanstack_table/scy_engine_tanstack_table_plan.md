<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ENGINE-TANSTACK-TABLE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_TANSTACK_TABLE_PLAN  
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

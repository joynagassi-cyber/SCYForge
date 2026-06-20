# 🛠️ SCY-LENS-SYSTEM — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_LENS_SYSTEM_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données

```
 [Graphe COSMOS rendu (engine_g6)]
                 │
                 ▼
   [LensSystem : orchestrateur de lentilles]
                 │
        ┌────────┼─────────────┬───────────────┬──────────────┐
        ▼        ▼             ▼               ▼              ▼
  [Fisheye   [Filtrage     [Mise en         [Similarité    [Extensibilité
   lens      (type/SMI/     évidence        (embeddings    (nouvelles
   focus+]   domaine)]      relations)]     concepts       lentilles
   context)]                                proches)]      plug-in)]
        │        │             │               │              │
        └────────┴─────────────┴───────────────┴──────────────┘
                       │
                       ▼
        [Combinaison de lentilles + réversibilité + palette design.md]
```

---

## 2. Dépendances Techniques Strictes
* **AntV G6 v5** : extensibilité (plugins, filtres, styles dynamiques).
* **React 18** : orchestrateur de lentilles.
* **Embeddings** : Zilliz (similarité sémantique).
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/cosmos/lens_system.ts`** : Orchestrateur de lentilles (activation/combinaison).
- **`frontend_react/src/cosmos/lenses/filter_lens.ts`** : Lentille de filtrage.
- **`frontend_react/src/cosmos/lenses/highlight_lens.ts`** : Lentille de mise en évidence.
- **`frontend_react/src/cosmos/lenses/similarity_lens.ts`** : Lentille de similarité.
- **`frontend_react/src/cosmos/lenses/fisheye_lens.ts`** : Intégration fisheye (cf. fisheye_lens).

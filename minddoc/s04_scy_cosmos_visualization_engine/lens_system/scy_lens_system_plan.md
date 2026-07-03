<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-LENS-SYSTEM — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_LENS_SYSTEM_PLAN  
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

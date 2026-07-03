<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ENGINE-NIVO — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_NIVO_PLAN  
**Décision** : D-RENDER-007  
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
 [Données Graphology : matrice (Chord/Heatmap) / flux (Sankey) / hiérarchie (Circle Packing)]
                 │
                 ▼
   [Lazy-import dynamique : const { Chord } = await import('@nivo/chord')]
                 │
                 ▼
   [Validation Zod des données (matrice carrée / flux structuré / hiérarchie)]
                 │
        ┌────────┼──────────────┬───────────────┐
        ▼        ▼              ▼               ▼
  [@nivo/chord  [@nivo/sankey  [@nivo/heatmap [@nivo/circle-packing
   (M12)]        (M13)]         (M16)]          (M19)]
        │        │              │               │
        └────────┴──────────────┴───────────────┘
                       │
                       ▼
        [Rendu SVG déclaratif + interactions (survol/drill-down)]
        [Limites tiers appliquées + fallback liste]
        [Cohérence palette design.md]
```

---

## 2. Dépendances Techniques Strictes
* **nivo** : `@nivo/chord`, `@nivo/sankey`, `@nivo/heatmap`, `@nivo/circle-packing` (v0.87.x).
* **React 18** : dynamic import (`React.lazy` + `Suspense`).
* **Lazy-loading** : chunks indépendants (D-RENDER-005).
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/cosmos/engines/nivo_loader.ts`** : Lazy-import dynamique des 4 modules nivo.
- **`frontend_react/src/cosmos/modes/`** : composants M12/M13/M16/M19 (consomment nivo_loader).
- **`frontend_react/src/cosmos/schemas/`** : validation Zod (matrice/flux/hiérarchie).

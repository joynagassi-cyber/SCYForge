<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ENGINE-COSMOGRAPH — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_ENGINE_COSMOGRAPH_PLAN  
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
 [Graphe COSMOS global (100K+ nœuds)]
                 │
                 ▼
   [Sélecteur de moteur : taille > seuil ? → engine_cosmograph]
                 │
                 ▼
   [Validation Zod des données]
                 │
                 ▼
   [Composant React : CosmosGraphMassive.tsx]
                 │
   [Cosmograph : simulation GPU force-directed + rendu WebGL]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [Parallélisation GPU     [Cohérence visuelle
   (forces + rendu)]        palette + enveloppe]
        │                     │
        └────────┬────────────┘
                 ▼
   [Interactivité : zoom révélant clusters + mise en évidence communautés]
```

---

## 2. Dépendances Techniques Strictes
* **Cosmograph** : `@cosmograph/cosmograph` (rendu GPU/WebGL grands graphes).
* **React 18** : composant `CosmosGraphMassive.tsx`.
* **Sélecteur de moteur** : logique de bascule selon seuil de taille.
* **Tokens design** : `design.md`.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/components/CosmosGraphMassive.tsx`** : Composant React Cosmograph.
- **`frontend_react/src/cosmos/engine_selector.ts`** : Sélection du moteur (g6 vs cosmograph) selon la taille.
- **`frontend_react/src/cosmos/cosmograph_config.ts`** : Configuration GPU + clusters.

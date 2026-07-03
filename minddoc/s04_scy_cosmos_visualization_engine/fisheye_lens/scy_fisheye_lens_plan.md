<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-FISHEYE-LENS — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_FISHEYE_LENS_PLAN  
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
   [Activation fisheye lens (plugin G6 ou transformation custom)]
                 │
   [Suivi curseur → centre du focus]
                 │
                 ▼
   [Distorsion radiale : focus agrandi + contexte compressé]
   r' = r * (d + 1) / (d/r + 1)
                 │
                 ▼
   [Recalcul temps réel (≥ 30 FPS) + cohérence palette]
```

---

## 2. Dépendances Techniques Strictes
* **AntV G6 v5** : plugin fisheye (ou transformation géométrique custom).
* **React 18** : intégration composant.
* **Mathématique** : distorsion radiale focus+context.

---

## 3. Fichiers et Tables Impactés
- **`frontend_react/src/cosmos/fisheye_lens.ts`** : Logique de distorsion focus+context.
- **`frontend_react/src/components/FisheyeLensOverlay.tsx`** : Surcouche d'activation.

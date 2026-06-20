# 🛠️ SCY-FISHEYE-LENS — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S04_COSMOS_FISHEYE_LENS_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

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

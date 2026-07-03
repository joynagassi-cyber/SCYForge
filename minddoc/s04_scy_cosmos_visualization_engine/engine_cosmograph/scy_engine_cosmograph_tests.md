<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-ENGINE-COSMOGRAPH — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_COSMOGRAPH_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

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

### 🧪 Test CG.1 : Rendu Massif (Happy Path)
* **Input** : 100 000 nœuds.
* **Attendu** : Rendu via Cosmograph (GPU) à ≥ 30 FPS.

### 🧪 Test CG.2 : Basulement Automatique
* **Input** : Graphe > seuil engine_g6.
* **Attendu** : engine_cosmograph sélectionné ; cohérence visuelle conservée.

### 🧪 Test CG.3 : Révélation des Clusters
* **Attendu** : Le zoom révèle les clusters locaux ; communautés visibles à l'échelle globale.

### 🧪 Test CG.4 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

### 🧪 Test CG.5 : Performance GPU
* **Attendu** : La parallélisation GPU maintient l'interactivité malgré l'échelle.

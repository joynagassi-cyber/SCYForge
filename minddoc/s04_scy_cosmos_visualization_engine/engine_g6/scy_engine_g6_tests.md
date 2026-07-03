<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-ENGINE-G6 — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_G6_TESTS  
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

### 🧪 Test G6.1 : Rendu 2D Axial (Happy Path)
* **Input** : Graphe COSMOS valide.
* **Attendu** : Affichage 2D via G6 v5, disposition force-directed axiale, palette `design.md` respectée.

### 🧪 Test G6.2 : Performance (Grand Graphe)
* **Input** : 5 000 nœuds.
* **Attendu** : ≥ 30 FPS avec LOD + Barnes-Hut + Object Pooling actifs.

### 🧪 Test G6.3 : Interactivité
* **Attendu** : Zoom/pan fluides ; sélection d'un nœud affiche son détail.

### 🧪 Test G6.4 : Respect de la Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

### 🧪 Test G6.5 : Rejet de Données Invalides
* **Input** : Graphe non conforme (Zod).
* **Attendu** : Rendu refusé avec erreur typée (pas de crash).

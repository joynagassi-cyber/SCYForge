<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-MODE-02 — TÂCHES (TASKS)
**ID** : S04_COSMOS_MODE_02_TASKS
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

### Tâche M2.1 : Coder le graphe G6 + sémiologie (25 min)
* **Fichier** : `frontend_react/src/cosmos/modes/Mode02KnowledgeGraph.tsx` · **Critère** : nœuds ∝ PageRank/SMI, arêtes EDGE_SEMANTIC_STYLES, auras rouges retard FSRS.
### Tâche M2.2 : Coder la Knowledge Card v2 complète au clic (25 min)
* **Critère** : Clic → 5 couches affichées + masquage nœuds >2-hops.
### Tâche M2.3 : Coder les limites tiers + nettoyage écouteurs (20 min)
* **Critère** : >30 000 nœuds LOW/COMPAT → blocage + filtre ; écouteurs détruits (D-RESILIENCE-003).

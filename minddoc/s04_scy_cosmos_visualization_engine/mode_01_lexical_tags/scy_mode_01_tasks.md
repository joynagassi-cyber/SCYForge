<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-MODE-01 — TÂCHES (TASKS)
**ID** : S04_COSMOS_MODE_01_TASKS
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

### Tâche M1.1 : Coder la liste/nuage de tags virtualisée (20 min)
* **Fichier** : `frontend_react/src/cosmos/modes/Mode01LexicalTags.tsx` · **Critère** : Tags contour ∝ domaine, police ∝ importance, badge cartes dues.
### Tâche M1.2 : Coder le drawer concepts + session APEX groupée (20 min)
* **Critère** : Clic tag → drawer tri SMI croissant ; lancement session APEX par étiquette.

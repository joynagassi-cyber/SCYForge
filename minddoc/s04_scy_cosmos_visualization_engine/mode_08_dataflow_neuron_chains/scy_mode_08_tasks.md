<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-MODE-08 — TÂCHES (TASKS)
**ID** : S04_COSMOS_MODE_08_TASKS
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

### Tâche M8.1 : Coder le pipeline animé + EventBus streaming (25 min)
* **Fichier** : `frontend_react/src/cosmos/modes/Mode08DataFlow.tsx` · **Critère** : Boîtes agents couleur ∝ statut, pipelines SVG animés, badge jetons/temps.
### Tâche M8.2 : Coder les logs clic + fallback surcharge (20 min)
* **Critère** : Clic agent → logs temps réel ; surcharge → animations off.

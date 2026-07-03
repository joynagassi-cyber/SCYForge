<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-CHAIN-BETA — TÂCHES (TASKS)
**ID** : S02_NEURON_CHAIN_BETA_TASKS
---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

### Tâche BE.1 : Coder BETA-1 Taxonomiste (20 min)
* **Fichier** : `beta/taxonomist.rs` · **Critère** : Classification en 10 domaines.
### Tâche BE.2 : Coder BETA-2 Extracteur Relations (25 min)
* **Fichier** : `beta/relation_extractor.rs` · **Critère** : Relations typées extraites (is_a, prerequisite_of, etc.).
### Tâche BE.3 : Coder BETA-3 Hiérarchie + PageRank (25 min)
* **Fichier** : `beta/hierarchy_architect.rs` · **Critère** : Arbre conceptuel + PageRank (graphology-metrics) + COSMOS KG peuplé.

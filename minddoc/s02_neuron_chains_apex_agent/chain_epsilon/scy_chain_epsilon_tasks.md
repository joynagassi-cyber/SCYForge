<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-CHAIN-EPSILON — TÂCHES (TASKS)
**ID** : S02_NEURON_CHAIN_EPSILON_TASKS
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

### Tâche EP.1 : Coder EPSILON-1 Cartes (25 min)
* **Fichier** : `epsilon/card_generator.rs` · **Critère** : 12 cartes/nœud (B02-B05), validation Zod.
### Tâche EP.2 : Coder EPSILON-2 Exercices Template Gold (25 min)
* **Fichier** : `epsilon/exercise_generator.rs` · **Critère** : 6 sections (contexte/question/hint/solution/explication/next_steps), 4 niveaux.
### Tâche EP.3 : Coder EPSILON-3 QCM distracteurs (25 min)
* **Fichier** : `epsilon/mcq_assembler.rs` · **Critère** : QCM 4 choix, distracteurs = erreurs communes réelles (pas aléatoires).

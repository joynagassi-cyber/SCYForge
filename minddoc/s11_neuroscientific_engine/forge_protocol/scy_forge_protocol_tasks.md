<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-FORGE-PROTOCOL — TÂCHES (TASKS)
**ID** : S11_NEURO_FORGE_PROTOCOL_TASKS · **Décision** : D-OPT-014

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

### Tâche FP.1 : Coder la génération du challenge Feynman à trous (25 min)
* **Fichier** : `backend_rs/src/neuro/forge/forge_challenge.rs`
* **Description** : Génération (NEURON-CHAINS) d'un trou sémantique ciblé sur le concept clé du nœud.
* **Critère** : Challenge cohérent avec le concept réel.

### Tâche FP.2 : Coder la gate d'amorce obligatoire + évaluation (25 min)
* **Fichier** : `backend_rs/src/neuro/forge/forge_evaluator.rs`
* **Description** : Gate bloquante avant affichage (interdit passif, D-OPT-014) + évaluation APEX-AGENT (Zod).
* **Critère** : Aucun contenu affiché sans amorce ; évaluation tracée.

### Tâche FP.3 : Coder le fallback ELI5 + mesure rétention (20 min)
* **Fichier** : `backend_rs/src/neuro/forge/forge_evaluator.rs`
* **Description** : 2 échecs consécutifs → aide ELI5 (D-OPT-024) ; mesure rétention APEX FSRS.
* **Critère** : Fallback ELI5 après 2 échecs ; gain rétention mesurable.

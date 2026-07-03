<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag15_axiomatizer DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-AG15-AXIOMATIZER — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG15_AXIOMATIZER_PLAN  
**Décisions** : D-OPT-035, D-OPT-033, D-OPT-034, D-OPT-057/058/059  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

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

## 1. Flux de Données de l'Agent (Asynchrone, arrière-plan)

```
 [scy_procedural_traces — traces de réussite accumulées]
                 │
                 ▼
   [Tâche planifiée asynchrone (Mastra Step / Tokio JoinSet)]
                 │
   [Détection de patrons convergents (≥ seuil k, ex 100 traces)]
        │
        ├── k < seuil ──► (attendre accumulation, aucune action)
        │
        ▼ (k ≥ seuil)
   [Distillation inductive — marche escalier (LLM, BudgetGuard, Rig/RRAG)]
   → formulation Loi/Méthode Fondamentale unique
                 │
                 ▼
   [Validation Zod AxiomSchema]
        │
        ├── invalide ──► retry ciblé / abandon (journalisé)
        │
        ▼ (valide)
   [Filtre PII strict + masque k-anonymat (k ≥ 10)]
        │
        ├── PII détectée non strippable ──► rejet (GDPR)
        │
        ▼ (anonymisé)
   [Persistance scy_axioms (partage global invisible)]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [Purge micro-règles        [Journalisation
   / traces d'origine]        scy_agent_decisions]
                 │
                 ▼
   [Moat d'Intelligence Collective mis à jour]
```

---

## 2. Dépendances Techniques Strictes
* **Moteur de distillation** : Rust asynchrone (Tokio `JoinSet` + `CancellationToken`, D-OPT-059).
* **Abstraction LLM** : Rig (`CompletionModel`, `Tool`, `VectorStore` composables, D-OPT-057) + RRAG (D-OPT-058).
* **LlmRouter + BudgetGuard** : tâche raisonnement, modèle selon tier.
* **Validation** : Zod `AxiomSchema`.
* **Sécurité** : filtre PII (D-OPT-033), k-anonymat k ≥ 10 (D-OPT-029).
* **Tables** : `scy_axioms`, `scy_procedural_traces`, `scy_agent_decisions`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag15_axiomatizer.ts`** : Step Mastra asynchrone (distillation + purge).
- **`backend_rs/src/ascent/axiom/distiller.rs`** : Moteur de distillation inductive (Rig/RRAG).
- **`backend_rs/src/ascent/axiom/pii_filter.rs`** : Filtre PII + k-anonymat.
- **`backend_ts/src/ascent/schemas/axiom_schema.ts`** : Schéma Zod de l'axiome.
- **`scy_axioms`** : Lois fondamentales anonymisées partagées globalement.
- **`scy_procedural_traces`** : Traces sources (purgeables après consolidation).

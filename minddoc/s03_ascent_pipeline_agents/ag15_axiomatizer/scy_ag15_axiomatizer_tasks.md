<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag15_axiomatizer DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-AG15-AXIOMATIZER — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG15_AXIOMATIZER_TASKS  
**Décisions** : D-OPT-035, D-OPT-033, D-OPT-034  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

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

### 🚀 Tâche 15.1 : Coder la Détection de Patrons Convergents (Durée : 25 min)
* **Description** : Coder la sélection des traces convergentes dans `scy_procedural_traces` (regroupement sémantique, seuil k ≥ 100).
* **Fichier** : `backend_rs/src/ascent/axiom/distiller.rs`
* **Critère de Succès** : k < seuil → aucune action ; k ≥ seuil → lot candidat transmis à la distillation.

### 🚀 Tâche 15.2 : Coder la Distillation Inductive + Validation Zod (Durée : 30 min)
* **Description** : Coder la distillation (marche escalier) via Rig/RRAG + LlmRouter (BudgetGuard), produisant une Loi/Méthode Fondamentale unique, validée par `AxiomSchema`.
* **Fichier** : `backend_rs/src/ascent/axiom/distiller.rs`
* **Critère de Succès** : Lot de traces → 1 axiome formulé et validé Zod.

### 🚀 Tâche 15.3 : Coder le Filtre PII + k-Anonymat (Durée : 25 min)
* **Description** : Coder `pii_filter.rs` : strip des identifiants personnels + masque k-anonymat (k ≥ 10) sur les profils contributeurs.
* **Fichier** : `backend_rs/src/ascent/axiom/pii_filter.rs`
* **Critère de Succès** : Axiome avec PII → rejeté/anonymisé ; profils masqués.

### 🚀 Tâche 15.4 : Coder la Persistance + Purge + Journalisation (Durée : 20 min)
* **Description** : Coder l'écriture dans `scy_axioms` (partage global), la purge des micro-règles/traces d'origine, et la journalisation dans `scy_agent_decisions`.
* **Fichier** : `backend_ts/src/ascent/agents/ag15_axiomatizer.ts`
* **Critère de Succès** : Axiome persisté globalement ; micro-règles purgées ; décision journalisée.

### 🚀 Tâche 15.5 : Coder l'Orchestration Asynchrone (Durée : 20 min)
* **Description** : Coder le Step Mastra asynchrone (tâche planifiée en arrière-plan, Tokio `JoinSet` + `CancellationToken`), sans bloquer l'UX.
* **Fichier** : `backend_ts/src/ascent/agents/ag15_axiomatizer.ts`
* **Critère de Succès** : La distillation tourne en arrière-plan ; UX non bloquée.

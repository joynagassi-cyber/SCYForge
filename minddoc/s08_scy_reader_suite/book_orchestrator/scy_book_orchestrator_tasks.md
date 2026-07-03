<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-BOOK-ORCHESTRATOR — TÂCHES (TASKS)
**ID** : S08_READER_BOOK_ORCHESTRATOR_TASKS · **Décisions** : RS-003, RS-004

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

### Tâche BO.1 : Coder la question clarification UI (7 intentions) (20 min)
* **Fichier** : `frontend_react/src/reader/BookOrchestrator.tsx`
* **Description** : UI statique 7 intentions (1 question max, $0 LLM).
* **Critère** : 1 question posée, 7 intentions disponibles.

### Tâche BO.2 : Coder l'analyse structure + matrice intention→features (25 min)
* **Fichier** : `backend_rs/src/reader/book_orchestrator/structure_analyzer.rs`
* **Description** : Analyse structure (Rust $0) + matrice intention→max 3 features.
* **Critère** : Intention → max 3 features orchestrées.

### Tâche BO.3 : Coder select_cosmos_modes (IA décide) (25 min)
* **Fichier** : `backend_rs/src/reader/book_orchestrator/mode_selector.rs`
* **Description** : Règles déterministes sélection max 3 modes COSMOS (hiérarchique→S10, >20→M9, chrono→M6, SMI<50→M7, dense→M0).
* **Critère** : « IA décide » → max 3 modes optimaux ; persistance `scy_book_orchestrations`.

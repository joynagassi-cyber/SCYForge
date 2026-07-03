<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-BOOK-ORCHESTRATOR — TESTS
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

**ID** : S08_READER_BOOK_ORCHESTRATOR_TESTS

- **TC1** : Exactement 1 question de clarification (7 intentions) posée (RS-003).
- **TC2** : Chaque intention → max 3 features orchestrées (RS-004).
- **TC3** : « IA décide » → max 3 modes COSMOS selon règles (hiérarchique→S10, >20 concepts→M9, chrono→M6, SMI<50→M7, dense→M0).
- **TC4** : Coût ≤ $0.002 (analyse + sélection déterministes $0).
- **TC5** : Persistance `scy_book_orchestrations` (user_intent, features, cosmos_modes).

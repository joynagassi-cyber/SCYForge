<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-APEX-AGENT — TESTS
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

**ID** : S02_NEURON_APEX_AGENT_TESTS

- **TC1 (ReAct)** : Demande → type/ton/sources/budget/model déterminés → génération → scoring → décision.
- **TC2 (Section/section)** : Document multi-sections généré et scoré section par section (NC-002).
- **TC3 (Parallèle)** : Chaînes exécutées en parallèle via JoinSet + CancellationToken (D-OPT-059).
- **TC4 (SAGA)** : Échec d'une branche → annulation immédiate de toutes les autres.
- **TC5 (Seuils)** : score ≥85 → export ; 70-84 → réécriture ciblée ; 45-69 → complète ; <45 → alerte.
- **TC6 (Ancrage RAG)** : Aucune génération sans chunks RAG (couche 1 anti-hallucination).
- **TC7 (Budget)** : Budget tokens respecté (T04/T17 BudgetGuard).
- **TC8 (Traçabilité)** : Décisions journalisées dans `scy_agent_decisions`.

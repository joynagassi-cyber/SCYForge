<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG16-HITL-PROXY-SME — TESTS
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

**ID** : S03_ASCENT_AG16_HITL_PROXY_SME_TESTS · **Décision** : D-OPT-036

- **TC1** : Domaine classé en bonne classe épistémologique + persona expert bootstrappé (scepticisme calibré).
- **TC2** : Audit multi-framework (SOLO + Cognitive Load + Constructive Alignment + Bloom) vérifié.
- **TC3** : Red Team : 4 questions adversariales + détection sophisme + Steel-Manning appliqués.
- **TC4** : Classe D Rust : analyse statique + Borrow Checker sim + Clippy + unsafe rejettent le code invalide.
- **TC5** : PQS ≥ 88 → signature électronique Parcours B autorisée.
- **TC6** : PQS < 88 → rapport remédiation renvoyé à APEX-AGENT (réécriture).
- **TC7** : Les 10 Commandements Invariants tous respectés.
- **TC8** : Aucune erreur inventée (toute critique tracée vers source/standard).

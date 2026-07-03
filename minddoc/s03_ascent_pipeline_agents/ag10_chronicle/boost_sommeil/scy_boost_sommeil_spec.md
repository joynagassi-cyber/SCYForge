<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag10_chronicle DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 😴 SCY-BOOST-SOMMEIL (CHRONICLE) — SPÉCIFICATION (SPEC)
**ID** : S03_CHRONICLE_BOOST_SOMMEIL_SPEC · **Décision** : D-OPT-048 · **Réf** : PRD §15.9

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

## 1. Purpose
Le **Boost Sommeil** (D-OPT-048) : CHRONICLE (Agent-10) planifie automatiquement une **micro-révision de 2 minutes** des concepts complexes juste avant le coucher de l'utilisateur pour cibler ces synapses pour la **consolidation hippocampale nocturne**.

## 2. Requirements (RFC 2119)
- **GIVEN** L'heure de coucher détectée/déclarée de l'utilisateur (chronotype CHRONICLE).
- **WHEN** L'heure approche (ex : 30 min avant coucher).
- **THEN** le système SHALL proposer une micro-révision de 2 min des concepts complexes les moins stables.
- **AND** le système SHALL cibler la consolidation hippocampale nocturne (sommeil).

## 3. Tests
- TC1 : Micro-révision 2 min proposée avant coucher. | TC2 : Cible les concepts complexes les moins stables (FSRS).

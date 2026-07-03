<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
Normal Mode ÉLIMINÉE. Beachhead = role-based onboarding.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🔄 SCY-NORMAL-ORCHESTRATION — SPÉCIFICATION (SPEC)
**ID** : S10_NORMAL_MODE_ORCHESTRATION_SPEC · **Phase** : Phase 0-1 · **Réf** : PRD §7.13.10

> **📌 RÉFÉRENCE CROISÉE** : Les specs d'orchestration sont dans **`../scy_normal_mode_orchestration_specs.md`** (22KB). Ce fichier en est le résumé SDD.

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | ELIMINATED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module est ÉLIMINÉ du beachhead**
• Conservé pour expansion future
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Purpose
Le **Mode Normal d'ingestion** est le pipeline d'ingestion hors ASCENT : l'utilisateur ingère une source directement, et COSMOS, les cartes FSRS (APEX), et BRAIN s'activent **immédiatement à 0$ de temps d'attente** dès la fin de l'ingestion brute. Sûreté : filtre d'intégrité minimal (anti-NaN, anti-division par zéro `softening_epsilon`) en arrière-plan sans bloquer l'étudiant. **Zéro certificat délivré** (Parcours A).

## 2. Requirements (RFC 2119)
- **GIVEN** Une source ingérée en Mode Normal (hors ASCENT).
- **THEN** le système SHALL activer COSMOS + APEX (cartes FSRS) + BRAIN **immédiatement** après ingestion (0$ attente).
- **AND** le système SHALL appliquer un filtre d'intégrité minimal (anti-NaN, anti-÷0 `softening_epsilon`) en arrière-plan sans bloquer.
- **AND** le système SHALL NE PAS délivrer de certificat (Parcours A, préservation de l'élite des diplômes).

## 3. Tests
- TC1 : Source → COSMOS/APEX/BRAIN activés immédiatement (0$ attente). | TC2 : Filtre anti-NaN/anti-÷0 actif sans blocage. | TC3 : Zéro certificat délivré (Parcours A).

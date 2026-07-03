<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
B2B Creator Console ÉLIMINÉE. Conservée Enterprise Tier Phase 2.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎓 SCY-ACCREDITATION-ROADMAP — SPÉCIFICATION (SPEC)
**ID** : S12_B2B_ACCREDITATION_ROADMAP_SPEC · **Phase** : V2+ · **Réf** : PRD §2.6, §12.2

> **📌 RÉFÉRENCE CROISÉE** : La roadmap détaillée d'accréditation est dans **`scy_accreditation_roadmap.md`** (9KB). Ce fichier en est le résumé SDD.

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
L'**Accreditation Roadmap** définit le parcours de SCY Forge vers les accréditations officielles (Qualiopi, IACET, ECTS/CEU) pour donner une valeur légale et reconnue aux certifications Proof of Skill, notamment sur le Parcours B.

## 2. Requirements (RFC 2119)
- **GIVEN** La stratégie B2B ROI-driven (§2.6).
- **THEN** le système SHALL viser les accréditations : Qualiopi (France), IACET (CEU international), ECTS (universitaire).
- **AND** le Proof of Skill du Parcours B (comité QA PQS ≥ 88 + ARENA + SurveyJS) SHALL être aligné sur ces référentiels.
- **AND** le plan de bootstrapping ($0) SHALL démarrer par des pilotes gratuits 30j (PME/startups) pour financer les serveurs dédiés et accréditations.

## 3. Tests
- TC1 : Proof of Skill Parcours B aligné Qualiopi/IACET/ECTS. | TC2 : Bootstrapping $0 (pilotes gratuits → financement).

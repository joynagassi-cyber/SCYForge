<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
APEX/FSRS en MVP simplifié. SMI Calculator gardé, scheduler complet différé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎯 SCY-PERSONNALISATION-ADAPTATIVE — SPÉCIFICATION (SPEC)
**ID** : S05_PERSONNALISATION_SPEC · **Phase** : P1-P3 · **Réf** : PRD §7.5.19

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

## 1. Purpose
**Personnalisation Adaptative** : chronotype (heures optimales), ton de communication, langue par domaine, détection style d'apprentissage.

## 2. Features

### A — Chronotype (Phase 1)
- Calcul auto depuis `scy_apex_reviews` : `EXTRACT(HOUR) ... AVG(success_rate)` (0 LLM)
- Dashboard → « Votre moment idéal : 21h-23h 🌙 »
- Agent-07 rappels à l'heure optimale
- Opt-out possible

### B — Adaptation du Ton (Phase 1)
- Settings → Formel / Neutre / Décontracté
- T02 ToneSelector reçoit la préférence ; BRAIN adapte son registre
- $0 (paramètre prompt)

### C — Langue par Domaine (Phase 1)
- React → Anglais ; Marketing → Français ; ML → Anglais
- Settings par objectif ASCENT
- $0 (paramètre prompt)

### D — Détection Style Apprentissage (Phase 3 R&D)
- Auto-détection visuel/auditif/kinesthésique via patterns comportementaux
- Types cartes consommés, temps médias vs texte
- Output : sélection auto type dominant cartes NEURON-CHAINS

## 3. Tests
- TC1 : Chronotype calculé (heure optimale). | TC2 : Ton appliqué (Formel/Neutre/Décontracté). | TC3 : Langue par domaine. | TC4 : Style détecté (Phase 3).

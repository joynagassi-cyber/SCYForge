<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧬 SCY-RETENTION-SCIENCE — SPÉCIFICATION (SPEC)
**ID** : S03_RETENTION_SCIENCE_SPEC · **Phase** : P1 · **Réf** : PRD §4.2 (ASCENT-RET-001 à 009)

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
Consolidation des **7 protocoles de science de rétention** documentés dans le PRD, transverses aux agents ASCENT (ag04, ag05, ag06, ag07, ag08, ag10). Chacun est un mécanisme basé sur la recherche comportementale validée.

## 2. Les 7 Protocoles

### ASCENT-RET-001 — Flow State Estimator (Csikszentmihalyi)
- **Agent** : ag05 PERFORMANCE-ANALYZER
- `flow_zone = f(error_rate, response_time, session_duration, return_frequency)`
- **Anxiety Zone** (>35% erreurs) → signal ag06 réduire difficulté
- **Flow Zone** (15-30%) → maintenir le cap
- **Boredom Zone** (<10%) → signal ag06 augmenter difficulté / Fast-Track

### ASCENT-RET-002 — SDT Satisfaction Monitor (Self-Determination Theory)
- **Agent** : ag05
- Mesure continue des 3 besoins : Autonomie, Compétence, Relatedness
- SDT global < 0.4 pendant 14j → signal prioritaire DRIFT-GUARDIAN + CHRONICLE

### ASCENT-RET-003 — Drift Signals SHAP (TRIAD-Drop)
- **Agent** : ag07 (déjà couvert dans ag07 spec — 8 signaux SHAP)

### ASCENT-RET-004 — Habit Formation Engine J1-J30
- **Agent** : ag04 LEARNING-CONDUCTOR
- J1-J7 : sessions ≤ 10 cartes, heure fixe, anchor behavior (BJ Fogg)
- J8-J21 : 15-20 cartes + Variable Rewards (badges mystères 15%)
- J22-J30 : sessions normales + célébration « 21 jours = habitude neurologique »
- Tiny Session toujours disponible (« Juste 5 cartes, 3 min »)

### ASCENT-RET-005 — Weekly Proximal Goal (Goal Setting Theory)
- **Agent** : ag06 ADAPTIVE-ROUTER
- Chaque lundi → objectif proximal généré (+15% vs baseline, ajustable)
- Visible dashboard principal, célébration dimanche si atteint

### ASCENT-RET-006 — Soft Commitment Device (+37% rétention 12 mois)
- **Agent** : ag08
- J1 : « Je m'engage à maîtriser [Objectif] d'hui le [Date] »
- Email confirmation J1 + Weekly check-in dimanche + slider confiance hebdo

### ASCENT-RET-007 — Variable Reward System (Dopamine variable ratio)
- **Agent** : ag08 (déjà couvert dans ag08 spec)

### ASCENT-RET-008 — Metacognitive Prompt PRÉ-session (+15% outcomes)
- **Agent** : ag04
- Avant chaque session : « Sur ce concept, vous vous sentez à quel point confiant ? (1-5) »
- Alerte Dunning-Kruger si confiance >> performance réelle

### ASCENT-RET-009 — Weekly Proximal Goal (déjà RET-005, duplication PRD)

## 3. SDT Guard-Rails (obligatoires)
- **SDT-G1** : Jamais « Vous allez perdre votre streak » — dire « Votre parcours continue demain »
- **SDT-G2** : Leaderboards OPT-IN uniquement, jamais sur chemin critique
- **SDT-G3** : Streak Freeze = « protection du parcours » pas « sauvetage du score »
- **SDT-G4** : Toujours le POURQUOI d'un badge avant sa délivrance
- **SDT-G5** : Gamification qui contrôle = détruit motivation intrinsèque → bannir

## 4. Tests
- TC1 : Flow Zone (15-30% erreurs) maintenu. | TC2 : SDT < 0.4 (14j) → signal prioritaire. | TC3 : Habit Engine (J1-J7 tiny, J8-J21 variable rewards, J22-J30 normal). | TC4 : Proximal Goal lundi + célébration dimanche. | TC5 : Commitment device J1 + check-in. | TC6 : Metacognitive pré-session + Dunning-Kruger. | TC7 : SDT-G1 à G5 respectés.

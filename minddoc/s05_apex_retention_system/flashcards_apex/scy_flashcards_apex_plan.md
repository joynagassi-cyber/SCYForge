<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
APEX/FSRS en MVP simplifié. SMI Calculator gardé, scheduler complet différé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-FLASHCARDS-APEX — PLAN D'IMPLÉMENTATION (PLAN)
**ID** : S05_APEX_FLASHCARDS_PLAN

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

## Flux
```
[Nœud ASCENT + concepts clés (AGENT-03)]
   │
   ▼
[NEURON-CHAINS EPSILON : génération 12 cartes/nœud]
   ├── EPSILON-1 : B02 Définition, B04 Short Answer, B08 Cloze
   ├── EPSILON-2 : B05 Application
   ├── EPSILON-3 : B03 MCQ (distracteurs plausibles)
   ├── GAMMA-2   : B06 Analogie (Phase V2)
   └── B01 Exposition, B07 Teaching, B09 Image Occlusion, B10 Audio (Phase V2)
   │
   ▼
[Validation Zod + persistance scy_apex_cards (fsrs_state initial, state=New)]
   │
   ▼
[Consommation par scheduler_fsrs (planification) + session APEX]
   │
   ├── Leech (>8 lapses) → tag #leech + alternatives (B06/B01/C01/IMPRINT Cran5) + alerte DRIFT-GUARDIAN
   └── Gestion : suspend/bury/flag/edit/note + TTS (R) + deep link Reader Suite (D-OPT-002)
```
## Dépendances : NEURON-CHAINS EPSILON/GAMMA, fsrs 0.6, OpenAI TTS, Zod. Table : `scy_apex_cards`.
## Fichiers : `backend_rs/src/apex/cards/generator.rs`, `leech_detector.rs`, `card_manager.rs`.

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
BRAIN en MVP simplifié (BM25 FTS uniquement). Triple retrieval + live web différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ADVANCED-CHAT-GEN — PLAN / TÂCHES / TESTS
**ID** : S06_BRAIN_ADVANCED_CHAT_PLAN / TASKS / TESTS

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
[Requête utilisateur]
   │
   ├── Mode Normal ──► SCY-BRAIN (triple retrieval + RRF + SSE) ──► réponse claire/concise
   │
   └── Mode Agentique ──► APEX-AGENT + 18 tools NEURON-CHAINS
                            ├── livrables : PowerPoint G13 / rapports / veilles
                            ├── anti-hallucination 3 couches + score confiance/livrable
                            └── source : Base cumulative | Internet | Hybride
```
## Dépendances : Vercel AI SDK (SSE, UI générative), APEX-AGENT, 18 tools, triple retrieval. 
## Fichiers : `backend_ts/src/brain/chat/normal_mode.ts`, `agentique_mode.ts`, `livrable_generator.ts`.

## Tâches
- AC.1 : Coder le Mode Normal (SSE streaming, triple retrieval) (25 min).
- AC.2 : Coder le Mode Agentique (APEX-AGENT + livrables G13/rapports) (30 min).
- AC.3 : Coder le choix de source + score confiance/livrable (20 min).

## Tests
- TC1 : Mode Normal Q→R SSE. | TC2 : Mode Agentique livrable visualisable. | TC3 : 3 modes source. | TC4 : score confiance/livrable (anti-hallucination).

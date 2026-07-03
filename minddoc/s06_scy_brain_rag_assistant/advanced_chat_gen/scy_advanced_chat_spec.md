<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
BRAIN en MVP simplifié (BM25 FTS uniquement). Triple retrieval + live web différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 💬 SCY-ADVANCED-CHAT-GEN — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S06_BRAIN_ADVANCED_CHAT_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

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
Le **BRAIN Advanced Chat Gen** est un module distinct offrant un **chat agentique complet** avec deux modes. Il produit des **livrables visualisables** : fichiers, présentations PowerPoint interactives (G13), rapports détaillés, veilles technologiques approfondies — au-delà du simple Q→R du Professor AI.

---

## 2. Tech Stack & Dependencies
* **Mode Normal** : Interaction simple Q→R, réponses claires/concises/précises, moteur SCY-BRAIN (triple retrieval + RRF + SSE streaming).
* **Mode Agentique** : Pipeline d'agents autonomes (APEX-AGENT + 18 tools NEURON-CHAINS), livrables visualisables (PowerPoint G13, rapports, veilles).
* **Stack UI** : Vercel AI SDK (streaming texte premium, graphiques inline, sections encadrées, UI générative). Alternatives : LangGraph.js, Mastra, assistant-ui, CopilotKit.
* **Source** : choix utilisateur `Base cumulative seule (hors-ligne)` | `Internet seul (temps réel)` | `Hybride (optimal)`.
* **Anti-hallucination** : 3 couches + score confiance par livrable.

> **Rappel anti-hallucination** : Mode Agentique utilise les 18 tools NEURON-CHAINS (T07 SourceVerifier, T08 CitationTracker, T11 FactChecker). Score confiance par livrable. Aucune fabrication.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Mode Normal
#### Scénario : Q→R simple
- **GIVEN** Une requête rapide/factuelle.
- **THEN** le système SHALL répondre via SCY-BRAIN (triple retrieval + SSE streaming), de manière claire/concise/précise.

### Requirement : Mode Agentique
#### Scénario : Livrables visualisables
- **GIVEN** Une demande de livrable complexe (rapport, présentation, veille).
- **THEN** le système SHALL déclencher le pipeline APEX-AGENT + 18 tools NEURON-CHAINS.
- **AND** le système SHALL produire des livrables visualisables (PowerPoint G13, rapports détaillés, veilles).
- **AND** le système SHALL appliquer l'anti-hallucination 3 couches + score confiance par livrable.

### Requirement : Choix de Source
#### Scénario : Configuration de la connaissance
- **THEN** le système SHALL offrir 3 modes de source : Base cumulative (hors-ligne) | Internet (temps réel) | Hybride (défaut).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Livrable sans score confiance (anti-hallucination).
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens `design.md`.

---

## 5. Test cases & Validation
* **TC1 (Normal)** : Q→R clair/concis via SSE streaming.
* **TC2 (Agentique)** : Livrable visualisable (PowerPoint G13 / rapport) généré via APEX-AGENT + 18 tools.
* **TC3 (Source)** : 3 modes de source configurables.
* **TC4 (Confiance)** : Score confiance par livrable (anti-hallucination 3 couches).

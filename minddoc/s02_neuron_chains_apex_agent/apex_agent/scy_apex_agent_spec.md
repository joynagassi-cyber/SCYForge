<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧠 SCY-APEX-AGENT — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S02_NEURON_APEX_AGENT_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

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
Cette spécification définit le **APEX-AGENT** — le cerveau interne des NEURON-CHAINS (distinct de l'ASCENT-ORCHESTRATOR des 13 agents). Il pilote la génération documentaire via une **boucle ReAct** (Reason → Act → Observe) : il raisonne sur le type de document/ton optimaux, sélectionne les tools et chaînes, génère section par section, score chaque section, et décide de l'export ou de la réécriture.

---

## 2. Tech Stack & Dependencies
* **Framework** : Rust (Axum + Tokio), **Rig** (traits `CompletionModel`, `Tool` composables, D-OPT-057), **RRAG** (récupération hybride, D-OPT-058).
* **Orchestrateur custom** : `JoinSet` + `CancellationToken` Tokio (concurrence structurée, D-OPT-059) — exécution parallèle des chaînes avec SAGA fallback.
* **Boucle ReAct** : Reason (sélection type/ton/model/sources/budget) → Act (compression, génération section/section, scoring, fact-check) → Observe (décision export/réécriture/alerte).
* **Tools** : 18 tools natifs (T01-T18, voir `tools/`).
* **LLM** : LlmRouter + BudgetGuard (DeepSeek V4 défaut, Claude selon tier).
* **Tables** : `scy_documents`, `scy_chunks`, `scy_confidence_reports`, `scy_agent_decisions`.

> **Rappel anti-hallucination** : l'APEX-AGENT ne génère que sur la base des chunks RAG récupérés des sources ingérées (couche 1). Toute assertion est liée à une source (CitationTracker T08). Score confiance par section (≥ 85 = export, < 50 = alerte).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Boucle ReAct

#### Scénario : Génération d'un document
- **GIVEN** Une demande de génération (« Générer le contenu du nœud React Hooks — useEffect »).
- **WHEN** L'APEX-AGENT raisonne.
- **THEN** le système SHALL déterminer le type doc optimal (T01 DocTypeDetector), le ton (T02 ToneSelector), les sources RAG (T06 RAGRetriever, top-15), le budget tokens (T04 TokenBudgeter) et le modèle (T05 ModelRouter).
- **AND** le système SHALL agir : compresser (T09 PromptCompressor -60%), générer section par section (anti-dérive), scorer (T10 SectionScorer), fact-check (T11 FactChecker).
- **AND** le système SHALL observer : score ≥ 85 → export direct ; 70-84 → réécriture ciblée ; 45-69 → réécriture complète ; < 45 → alerte utilisateur.

---

### Requirement : Génération Section par Section (Anti-Dérive)

#### Scénario : NC-002
- **GIVEN** Un document multi-sections.
- **THEN** le système SHALL générer section par section (pas monolithique) pour permettre retry ciblé et cache intermédiaire.
- **AND** chaque section est scorée indépendamment (T10).

---

### Requirement : Orchestration Parallèle (Concurrence Structurée)

#### Scénario : D-OPT-059
- **GIVEN** Plusieurs chaînes à exécuter en parallèle (ex : fiches concepts + examen).
- **THEN** le système SHALL les faner via `JoinSet` Tokio avec `CancellationToken`.
- **AND** en cas d'échec d'une branche → annulation immédiate de toutes les autres (SAGA fallback, D-OPT-059).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Générer sans chunks RAG (ancrage source obligatoire, couche 1).
* 🚫 **FORBIDDEN** : Exporter un document avec score global < 50 (alerte obligatoire).
* 🚫 **SHALL NOT** : Dépasser le budget tokens (T04/T17 BudgetGuard).
* ⚠️ **MUST** : Tout output validé par Zod ; traçabilité dans `scy_agent_decisions`.

---

## 5. Test cases & Validation
* **TC1 (ReAct)** : Demande → raisonnement (type/ton/sources/budget/model) → génération → scoring → décision.
* **TC2 (Section/section)** : Document multi-sections généré section par section, chacune scorée.
* **TC3 (Parallèle)** : Chaînes parallèles via JoinSet + CancellationToken.
* **TC4 (SAGA)** : Échec d'une branche → annulation globale.
* **TC5 (Score)** : ≥85 export / 70-84 réécriture ciblée / <50 alerte.

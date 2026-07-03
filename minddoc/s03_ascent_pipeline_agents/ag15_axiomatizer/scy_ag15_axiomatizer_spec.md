<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag15_axiomatizer DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧬 SCY-AG15-AXIOMATIZER — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG15_AXIOMATIZER_SPEC  
**Décision d'architecture** : D-OPT-035 (SCY-AXIOM Synthesis Engine), D-OPT-033 (SCY-AXIOM DB), D-OPT-034 (Closed-Loop Learning)  
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
Cette spécification définit le comportement de l'**AGENT-15 : AXIOMATIZER (L'Axiomatiseur de Connaissances)**. Agent cognitif de méta-évolution s'exécutant en arrière-plan asynchrone côté serveur (Rust). Sa mission : capturer les traces de réussite procédurales (`scy_procedural_traces`), les abstraire et les fusionner en une **unique Loi ou Méthode Fondamentale** écrite dans `scy_axioms`, partagée de manière invisible et globale avec tous les utilisateurs. Une fois un Axiome validé, il **purge l'intégralité des micro-règles d'origine**, éradiquant l'inflation de micro-skills. C'est le **Moat d'Intelligence Collective** de SCY Forge.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (orchestration step asynchrone) + Rust (moteur de distillation Tokio, `JoinSet`/`CancellationToken` D-OPT-059).
* **Base d'axiomes** : `scy_axioms` (PostgreSQL Northflank) — lois fondamentales anonymisées.
* **Traces sources** : `scy_procedural_traces` — traces de réussite capturées depuis APEX/ASCENT.
* **Filtre PII strict** : anonymisation GDPR (D-OPT-029 k-anonymat, D-OPT-033 filtre PII) avant toute persistance.
* **LLM** : LlmRouter + BudgetGuard (distillation inductive, marche escalier) — tâche raisonnement, modèle adapté au tier.
* **Rig + RRAG** : traits composables pour l'abstraction (D-OPT-057/058).
* **Validation** : modèles **Zod** stricts (AxiomSchema).

> **Rappel anti-hallucination** : AXIOMATIZER distille UNIQUEMENT à partir de traces de réussite réelles et mesurées. Aucun axiome n'est inventé. Tout axiome est anonymisé (PII strippée) avant partage global — conformité GDPR absolue (D-OPT-033).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Capture & Abstraction des Traces de Réussite

#### Scénario : Distillation inductive (escalier)
- **GIVEN** Un ensemble de traces de réussite procédurales accumulées dans `scy_procedural_traces` (≥ seuil k, ex : 100 traces convergentes sur un même patron).
- **WHEN** AXIOMATIZER traite le lot (tâche asynchrone planifiée).
- **THEN** le système SHALL abstraire le patron commun via distillation inductive (marche escalier).
- **AND** le système SHALL produire une formulation de Loi/Méthode Fondamentale unique.
- **AND** le système SHALL valider la sortie par `AxiomSchema` (Zod).

---

### Requirement : Filtre PII & Anonymisation GDPR

#### Scénario : Partage global sécurisé
- **GIVEN** Un axiome candidat formulé.
- **WHEN** Le système prépare la persistance/partage global.
- **THEN** le système SHALL appliquer un filtre PII strict (D-OPT-033) supprimant tout identifiant personnel.
- **AND** le système SHALL appliquer un masque k-anonymat (k ≥ 10, D-OPT-029) sur les profils contribuant.
- **AND** le système SHALL NE JAMAIS persister de matière brute identifiable.

---

### Requirement : Persistance & Purge des Micro-Règles

#### Scénario : Consolidation et éradication de l'inflation
- **GIVEN** Un axiome validé et anonymisé.
- **WHEN** Le système consolide.
- **THEN** le système SHALL écrire l'axiome dans `scy_axioms` (partagé globalement, invisible).
- **AND** le système SHALL purger l'intégralité des micro-règles/traces locales d'origine qui ont servi à la synthèse.
- **AND** le système SHALL journaliser la consolidation (traçabilité, `scy_agent_decisions`).

---

### Requirement : Auto-Apprentissage Fermé (Closed-Loop Learning)

#### Scénario : Boucle Hermes (D-OPT-034)
- **GIVEN** De nouvelles compétences de procédures émergent des traces.
- **WHEN** Le cycle d'auto-apprentissage fermé s'exécute.
- **THEN** le système SHALL distiller ces compétences en fichiers Markdown locaux anonymisés.
- **AND** le système SHALL maintenir la boucle fermée (pas de fuite de données privées hors du périmètre GDPR).

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Inventer un axiome sans traces de réussite réelles convergentes (≥ seuil k).
* 🚫 **FORBIDDEN** : Persister/partager un axiome sans filtre PII + k-anonymat (GDPR, D-OPT-029/033).
* 🚫 **SHALL NOT** : Partager la matière brute des traces (uniquement l'axiome distillé anonymisé).
* 🚫 **SHALL NOT** : Conserver les micro-règles après consolidation d'un axiome (purge obligatoire).
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens `design.md`.
* ⚠️ **MUST** : Tout axiome validé par Zod ; exécution asynchrone (ne bloque pas l'UX).

---

## 5. Test cases & Validation
* **Test Case 1 (Distillation)** : 100 traces convergentes → 1 axiome formulé, validé Zod.
* **Test Case 2 (PII)** : Un axiome contenant un identifiant → rejeté/anonymousisé avant persistance.
* **Test Case 3 (k-anonymat)** : Profils contributeurs masqués (k ≥ 10).
* **Test Case 4 (Purge)** : Après consolidation, les micro-règles d'origine sont supprimées.
* **Test Case 5 (Partage global)** : L'axiome est accessible à tous les utilisateurs de manière invisible.
* **Test Case 6 (Async)** : La distillation ne bloque pas l'UX utilisateur (arrière-plan).
* **Test Case 7 (Aucune invention)** : Sans trace convergente (k < seuil), aucun axiome généré.

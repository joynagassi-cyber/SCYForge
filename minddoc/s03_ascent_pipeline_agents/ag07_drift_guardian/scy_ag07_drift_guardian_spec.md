<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛡️ SCY-AG07-DRIFT-GUARDIAN — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG07_DRIFT_GUARDIAN_SPEC  
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
Cette spécification définit le comportement de l'**AGENT-07 : DRIFT-GUARDIAN**. Sa mission est de **détecter précocement le risque d'abandon** et la dérive de l'utilisateur grâce à **8 signaux comportementaux** (inactivité, déclin de performance, sauts de nœuds, fatigue, etc.), puis de déclencher des **actions de ré-engagement ciblées**. Il vise l'objectif ASCENT Completion Rate > 70 % (vs < 15 % industrie).

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step, écoute continue).
* **Signaux** : 8 signaux de drift (inactivité prolongée, déclin SMI, sauts de prérequis, baisse de fréquence, échecs répétés, signaux de fatigue, désengagement COSMOS, feedback négatif).
* **Dépendances internes** : AGENT-05 (SMI), AGENT-08 (ré-engagement/gamification), AGENT-10 CHRONICLE (notifications).
* **Validation** : modèles **Zod** pour les alertes de drift.
* **EventBus** : `DriftDetected { signal_type, severity }`.
* **Observabilité** : DLQ (Dead Letter Queue) — l'Agent-07 est notifié des erreurs système.

> **Rappel anti-hallucination** : les signaux de drift sont calculés à partir de métriques comportementales réelles. Aucune alerte n'est générée sans seuil mesuré franchi.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Surveillance des 8 Signaux de Drift

#### Scénario : Détection d'inactivité et de déclin
- **GIVEN** L'activité de l'utilisateur surveillée en continu.
- **WHEN** Un signal franchit son seuil (ex : inactivité > N jours, déclin SMI > X %).
- **THEN** le système SHALL émettre `DriftDetected { signal_type, severity }`.
- **AND** le système SHALL calculer un score de risque d'abandon consolidé (agrégation des 8 signaux).

---

### Requirement : Actions de Ré-Engagement Ciblées

#### Scénario : Intervention préventive
- **GIVEN** Une alerte `DriftDetected` avec sévérité donnée.
- **WHEN** Le système réagit.
- **THEN** le système SHALL déclencher une action proportionnée : rappel via CHRONICLE (AGENT-10), micro-objectif (AGENT-08), simplification (AGENT-06).
- **AND** le système SHALL personnaliser l'intervention selon le type de signal (ex : échecs répétés → contenu plus simple ; inactivité → rappel motivant).

---

### Requirement : Surveillance des Erreurs Système (DLQ)

#### Scénario : Notification des incidents
- **GIVEN** Un événement échouant 3 fois (Dead Letter Queue).
- **WHEN** Le DLQ capture l'événement.
- **THEN** le système SHALL être notifié automatiquement.
- **AND** le système SHALL alerter l'administration/monitoring pour investigation.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Générer des alertes de drift sans seuil mesuré franchi (anti-faux-positifs).
* 🚫 **SHALL NOT** : Harceler l'utilisateur (limitation de fréquence des notifications).
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens de `design.md`.
* ⚠️ **MUST** : Alertes validées par **Zod**.

---

## 5. Test cases & Validation
* **Test Case 1 (Détection)** : Une inactivité > seuil émet `DriftDetected`.
* **Test Case 2 (Ré-engagement)** : Une alerte déclenche une action proportionnée et personnalisée.
* **Test Case 3 (Anti-spam)** : Les notifications sont limitées en fréquence.
* **Test Case 4 (DLQ)** : Un événement en DLQ notifie l'Agent-07.
* **Test Case 5 (Score consolidé)** : Le score de risque agrège correctement les 8 signaux.

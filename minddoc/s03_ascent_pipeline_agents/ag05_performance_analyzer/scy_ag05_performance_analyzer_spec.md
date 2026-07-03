<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📊 SCY-AG05-PERFORMANCE-ANALYZER — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG05_PERFORMANCE_ANALYZER_SPEC  
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
Cette spécification définit le comportement de l'**AGENT-05 : PERFORMANCE-ANALYZER**. Sa mission est de **recalculer en continu le SMI (Skill Mastery Index)** de l'utilisateur à partir des signaux de performance : révisions FSRS (ratings), scores d'exercices, complétion de nœuds, simulations ARENA. Il fournit la mesure multi-dimensionnelle objective de la compétence qui pilote toutes les décisions de la pipeline.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step).
* **Données d'entrée** : événements `CardReviewed`, `ExerciseCompleted`, `SessionEnded`, résultats ARENA (AGENT-11).
* **Modèle SMI** : calcul multi-dimensionnel (rétention, fluence, application, profondeur) — formules du moteur neuroscientifique (`s11`).
* **Analytics** : Polars + DuckDB (materialized views `mv_user_smi_summary`).
* **Validation** : modèles **Zod** pour les mises à jour SMI.
* **EventBus** : `NodeCompleted` (SMI seuil atteint).

> **Rappel anti-hallucination** : le SMI est calculé à partir de signaux réels mesurés (ratings FSRS, scores). Aucune note n'est inventée. Les formules sont celles du moteur neuroscientifique documenté (`s11`).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Recalcul Multi-Dimensionnel du SMI

#### Scénario : Mise à jour après révision
- **GIVEN** Un événement `CardReviewed { rating }` ou `ExerciseCompleted { score }`.
- **WHEN** Le PERFORMANCE-ANALYZER traite le signal.
- **THEN** le système SHALL recalculer le SMI du nœud concerné selon le modèle multi-dimensionnel (rétention FSRS + application + profondeur).
- **AND** le système SHALL persister le nouveau SMI dans `mfg_ascent_nodes`.
- **AND** le système SHALL mettre à jour la vue matérialisée `mv_user_smi_summary`.

---

### Requirement : Détection du Seuil de Compétence

#### Scénario : Validation d'un nœud
- **GIVEN** Un SMI de nœud recalculé.
- **WHEN** Le SMI atteint ou dépasse le seuil cible.
- **THEN** le système SHALL signaler au LEARNING-CONDUCTOR (AGENT-04) que le nœud est maîtrisé.
- **AND** le système SHALL émettre `NodeCompleted { smi_achieved }`.

---

### Requirement : Reporting Analytique

#### Scénario : Agrégation pour dashboards
- **GIVEN** Les données de performance accumulées.
- **WHEN** Un dashboard (COSMOS / console B2B) requiert le SMI global.
- **THEN** le système SHALL fournir le SMI agrégé par objectif, domaine et temps.
- **AND** le système SHALL exporter les analytics (Parquet via Polars) pour la recherche/debugging.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Inventer des scores de performance non mesurés.
* 🚫 **SHALL NOT** : Modifier les formules SMI (définies dans `s11`).
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens de `design.md`.
* ⚠️ **MUST** : Mises à jour validées par **Zod**.

---

## 5. Test cases & Validation
* **Test Case 1 (Recalcul)** : Un `CardReviewed` déclenche un recalcul SMI persisté.
* **Test Case 2 (Seuil)** : Un SMI ≥ seuil émet `NodeCompleted`.
* **Test Case 3 (Agrégation)** : Le SMI global reflète correctement les nœuds maîtrisés.
* **Test Case 4 (Export)** : Les analytics sont exportables en Parquet.

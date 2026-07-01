# SCYForge — Plan C de refactor des 13 agents ASCENT
## 02. Refactor détaillé des agents P0

## Périmètre P0
Agents qui définissent la vérité structurelle du produit :
- GOAL-INTERPRETER
- CONTENT-SCOUT
- DAG-ARCHITECT
- LEARNING-CONDUCTOR
- PERFORMANCE-ANALYZER
- SKILL-CERTIFIER
- ARENA

---

# 1. GOAL-INTERPRETER

## Cible
Devenir un **Goal Compiler**.

## Ce qui doit changer
- ne plus sortir un objectif “narratif” seulement,
- sortir un `GoalSpec` standard,
- résoudre le rôle cible via `RoleTaxonomyProvider`,
- extraire les refs domaine via `OntologyProvider`,
- anticiper le périmètre de preuve via `ProofRubricProvider`.

## Nouveau flux
1. prendre l’intent brut,
2. résoudre rôle + niveau,
3. mapper l’intent à des `domain_refs`,
4. générer `GoalSpec`,
5. proposer les premiers nœuds candidats.

## Done criteria
- aucun rôle cyber hardcodé,
- tout objectif a un `domainId`,
- tout objectif a un scope de maîtrise.

---

# 2. CONTENT-SCOUT

## Cible
Devenir un **Evidence Scout**.

## Ce qui doit changer
- arrêter de penser en “sources intéressantes”,
- penser en “preuves exploitables pour couvrir des nœuds de maîtrise”.

## Nouveau flux
1. récupérer corpus autorisés via `CorpusProvider`,
2. scorer les sources,
3. chunker et mapper aux refs domaine,
4. produire `CoverageMap`,
5. signaler les gaps.

## Done criteria
- chaque chunk est traçable à une source,
- chaque source a un trust tier,
- chaque gap est exprimé sur des refs ou nœuds, pas en prose vague.

---

# 3. DAG-ARCHITECT

## Cible
Devenir un **Mastery Graph Compiler**.

## Ce qui doit changer
- séparer graphe ontologique et graphe pédagogique,
- produire de vrais `MasteryNode`,
- attacher proof requirements et criticité.

## Nouveau flux
1. lire `GoalSpec`,
2. lire `EvidenceBundle` / coverage,
3. consulter ontologie et rôles,
4. compiler `MasteryNode[]`,
5. générer dépendances,
6. proposer `ProofPlan`.

## Done criteria
- chaque nœud a `masteryType`, `targetLevel`, `criticality`, `proofRequirementIds`,
- le DAG n’est pas une simple liste de concepts.

---

# 4. LEARNING-CONDUCTOR

## Cible
Devenir un **Intervention Policy Engine**.

## Ce qui doit changer
- piloter des interventions sur nœuds de maîtrise,
- arbitrer compréhension / pratique / simulation / révision / remédiation,
- cesser de raisonner comme un simple session planner.

## Nouveau flux
1. lire `MasteryState`,
2. lire `RetentionState`,
3. lire éligibilité scénario,
4. demander policy aux providers,
5. émettre `InterventionDecision`.

## Done criteria
- chaque intervention vise un nœud ou un gap explicite,
- le système peut ralentir un apprenant pour éviter l’illusion de maîtrise,
- les scénarios ne sont proposés qu’avec préconditions remplies.

---

# 5. PERFORMANCE-ANALYZER

## Cible
Devenir un **Evidence Aggregator**.

## Ce qui doit changer
- remplacer la logique score-only par une logique evidence-first,
- produire des `ProofRecord`,
- calculer des scores dimensionnels et des niveaux de confiance.

## Nouveau flux
1. ingérer résultats d’exercices / explications / scénarios / révisions,
2. scorer via `ProofRubricProvider`,
3. appliquer `ValidationGuardProvider`,
4. émettre `ProofRecord[]`,
5. consolider `MasteryState`.

## Done criteria
- aucun score critique sans traces de preuve,
- toute dimension est explicite,
- les erreurs éliminatoires sont prises en compte.

---

# 6. SKILL-CERTIFIER

## Cible
Devenir un **Readiness Verdict Engine**.

## Ce qui doit changer
- abandonner la certification globale floue,
- sortir un `ReadinessVerdict` borné,
- lier autonomie autorisée et zones bloquées.

## Nouveau flux
1. collecter `ProofRecord[]`,
2. récupérer `ReadinessPolicy`,
3. vérifier scénarios requis,
4. appliquer règles éliminatoires,
5. valider le verdict via `ValidationGuardProvider`,
6. émettre `ReadinessVerdict`.

## Done criteria
- tout verdict a `autonomyScope`, `blockedScope`, `confidence`, `evidenceRecordIds`,
- impossible de certifier sans preuves minimales.

---

# 7. ARENA

## Cible
Devenir un **Scenario Runtime** branché sur blueprints.

## Ce qui doit changer
- ne plus être piloté par scénarios implicites / prose libre,
- exécuter des `ScenarioBlueprint`,
- journaliser les décisions,
- produire des preuves scorables.

## Nouveau flux
1. sélectionner un `ScenarioBlueprint`,
2. instancier la session,
3. capturer les décisions de l’apprenant,
4. faire évoluer les branches,
5. scorer avec la rubric associée,
6. sortir `ProofRecord[]`.

## Done criteria
- aucun scénario critique sans blueprint,
- chaque session produit une `ScenarioTrace`,
- chaque résultat remonte dans le système de preuve.

---

# 8. Ordre interne P0 recommandé

1. GOAL-INTERPRETER
2. CONTENT-SCOUT
3. DAG-ARCHITECT
4. PERFORMANCE-ANALYZER
5. SKILL-CERTIFIER
6. LEARNING-CONDUCTOR
7. ARENA

### Pourquoi ce léger ordre ?
Parce que CONDUCTOR et ARENA deviennent bien meilleurs une fois que graph, preuves et policies existent déjà proprement.

---

# 9. Critère de fin P0

La phase P0 est finie quand :
- un objectif cyber peut être compilé proprement,
- un graphe de maîtrise cyber peut être généré,
- des preuves peuvent être capturées,
- un scénario ARENA peut être exécuté sur blueprint,
- un verdict borné peut être rendu.

Si ce n’est pas vrai, le cœur du produit n’est pas encore refactoré.
# SCYForge — Plan C de refactor des 13 agents ASCENT
## 05. Objets universels et migrations de données

## But du fichier

Décrire ce qu’il faut introduire au niveau des types, des persistences et des compatibilités transitoires.

---

# 1. Les objets universels à introduire officiellement

## Objets prioritaires
- `GoalSpec`
- `DomainReference`
- `MasteryNode`
- `ScenarioBlueprint`
- `ProofRecord`
- `ReadinessVerdict`

## Pourquoi eux d’abord
Parce que tout le refactor repose dessus.
Si ces objets ne vivent pas dans le cœur, les agents refactorés n’auront pas de langage commun.

---

# 2. Compatibilité transitoire

## Principe
Ne pas casser immédiatement les types existants.
Faire cohabiter :
- anciens objets,
- nouveaux objets,
- adapters de traduction.

## Exemple
- ancien `Node` → nouveau `MasteryNode`
- ancien score SMI → enrichi via `ProofRecord[]`
- ancien scénario prose → `ScenarioBlueprint`

---

# 3. Migrations de persistance à prévoir

## Table / stockage Goal
Ajouter :
- `domain_id`
- `target_role_ids`
- `target_level`
- `source_context_ids`

## Table / stockage Node
Ajouter ou dériver :
- `mastery_type`
- `criticality`
- `proof_requirement_ids`
- `failure_modes`
- `domain_ref_ids`

## Table / stockage Proof
Créer un stockage explicite :
- `proof_record_id`
- `evidence_type`
- `rubric_dimensions`
- `confidence`
- `source_ids`
- `scenario_id?`

## Table / stockage Verdict
Créer :
- `autonomy_scope`
- `blocked_scope`
- `confidence`
- `evidence_record_ids`

---

# 4. Migrations minimales par phase

## Phase 0
Types + adapters sans casser l’existant.

## Phase 1
Persister `MasteryNode` et `ProofRecord`.

## Phase 2
Persister `ReadinessVerdict` et `ScenarioTrace`.

## Phase 3
Aligner COSMOS / CHRONICLE / dashboards sur les nouveaux objets.

---

# 5. Règles de migration

## Règle 1
Tout nouvel objet doit être versionnable.

## Règle 2
Tout objet lié au domaine doit référencer `domainId` ou `domainRefIds`.

## Règle 3
Tout objet lié à une preuve doit référencer `sourceIds` si applicable.

## Règle 4
Aucune migration ne doit supprimer la capacité à rejouer ou relire l’historique ancien.

---

# 6. Tests de migration recommandés

- un ancien goal peut être converti en `GoalSpec`
- un ancien node peut être converti en `MasteryNode`
- un ancien scénario cyber peut être converti en `ScenarioBlueprint`
- un ancien score peut être encapsulé dans un `ProofRecord` minimal
- un verdict readiness peut être reconstruit à partir des preuves persistées

---

# 7. Critère de réussite

Cette couche est réussie quand les agents peuvent communiquer par objets universels sans conserver des formats parallèles comme vérité principale.

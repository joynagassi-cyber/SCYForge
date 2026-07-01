# SCYForge — Plan C de refactor des 13 agents ASCENT
## 01. Séquence globale de refactor

## But de ce fichier

Définir l’ordre de transformation réel.
Pas seulement ce qu’il faut faire, mais **dans quel ordre**, pourquoi, et avec quelles dépendances.

---

# 1. Vue macro

## Phase 0 — Préparation structurelle
Avant tout refactor d’agent, il faut figer :
- les objets universels,
- les interfaces des providers,
- le registry de résolution des packs,
- la politique de trace / audit.

Sans ça, refactorer les agents revient à déplacer du flou.

## Phase 1 — Refactor des agents qui définissent la vérité de compétence
Agents P0 :
- GOAL-INTERPRETER
- CONTENT-SCOUT
- DAG-ARCHITECT
- LEARNING-CONDUCTOR
- PERFORMANCE-ANALYZER
- SKILL-CERTIFIER
- ARENA

## Phase 2 — Stabilisation de la dynamique d’apprentissage
Agents P1 :
- ADAPTIVE-ROUTER
- DRIFT-GUARDIAN
- CHRONICLE
- BRAIN
- APEX / IMPRINT

## Phase 3 — Industrialisation explicabilité / rendu / discipline UX
Agents P2/P3 :
- VISUAL-CRITIC
- COGNITIVE-VALIDATOR
- COSMOS
- ENGAGEMENT-AMPLIFIER

## Phase 4 — Démonstration d’extensibilité
- compléter Cyber Pack,
- brancher mini `sales-lite`,
- prouver hot-swap pack → noyau intact.

---

# 2. Dépendances critiques

## Dépendance A
GOAL et DAG dépendent des objets universels et de `RoleTaxonomyProvider` + `OntologyProvider`.

## Dépendance B
PERFORMANCE et CERTIFIER dépendent de `ProofRubricProvider` et `ReadinessPolicy`.

## Dépendance C
ARENA dépend de `ScenarioBlueprint` et `DecisionScenarioProvider`.

## Dépendance D
DRIFT / APEX / ROUTER dépendent de `RetentionPolicyProvider`.

## Dépendance E
Tout le monde dépend à terme de `ValidationGuardProvider`.

---

# 3. Séquence concrète recommandée

## Étape 1 — Introduire les types noyau
À faire avant tout :
- créer les types communs,
- faire vivre les IDs, refs, versions,
- permettre la cohabitation avec les types existants.

### Livrables
- module types partagés,
- conversion adapters temporaires,
- schéma de persistance cible.

## Étape 2 — Introduire les interfaces providers sans encore tout migrer
Le but n’est pas que tout fonctionne.
Le but est que le noyau **puisse appeler** les contracts.

### Livrables
- interfaces TS/Rust,
- registry basique,
- stubs Cyber Pack pour tous les providers.

## Étape 3 — Refactor GOAL-INTERPRETER
Pourquoi en premier ?
Parce que toute la suite dépend d’un objectif proprement compilé.

## Étape 4 — Refactor CONTENT-SCOUT
Pourquoi si tôt ?
Parce qu’il alimente DAG et les scénarios en vérité exploitable.

## Étape 5 — Refactor DAG-ARCHITECT
Pourquoi maintenant ?
Parce qu’il transforme l’objectif en graphe de maîtrise, qui devient l’objet pivot du produit.

## Étape 6 — Refactor LEARNING-CONDUCTOR
Pourquoi après DAG ?
Parce qu’il doit orchestrer sur des `MasteryNode`, pas sur des morceaux de contenu.

## Étape 7 — Refactor PERFORMANCE-ANALYZER
Pourquoi ici ?
Parce qu’il faut commencer à produire des `ProofRecord` réels.

## Étape 8 — Refactor SKILL-CERTIFIER
Pourquoi après PERFORMANCE ?
Parce qu’un verdict sans nouvelles preuves est inutile.

## Étape 9 — Refactor ARENA
Pourquoi maintenant ?
Parce qu’après avoir refait graph + preuves + certification, ARENA devient enfin branchable proprement comme machine de décision validante.

## Étape 10 — Refactor ROUTER / DRIFT / APEX / BRAIN / CHRONICLE
Pourquoi après le cœur ?
Parce qu’ils dépendent de la nouvelle grammaire de vérité.

## Étape 11 — Refactor VISUAL / COSMOS / ENGAGEMENT
Pourquoi à la fin ?
Parce que ces couches doivent consommer un état propre, pas en créer un parallèle.

---

# 4. Quick wins intelligents

## Quick win 1
Introduire `MasteryNode` sans réécrire tout le DAG, en le produisant d’abord en parallèle des structures existantes.

## Quick win 2
Introduire `ProofRecord` dès PERFORMANCE, même si CERTIFIER n’est pas encore totalement migré.

## Quick win 3
Faire un `ValidationGuardProvider` minimal qui ne bloque d’abord que :
- certification sans scénario,
- claim sans source,
- verdict sans rubric.

## Quick win 4
Créer un `ScenarioBlueprint` minimal pour les 3 scénarios APT29 déjà rédigés.

---

# 5. Erreurs à éviter dans la séquence

## Erreur 1
Commencer par COSMOS ou la visualisation.

## Erreur 2
Essayer de refaire les 13 agents en même temps.

## Erreur 3
Vouloir rendre tout 100% agnostique avant d’avoir un cas cyber vraiment solide.

## Erreur 4
Refactorer le scoring sans refactorer la notion de preuve.

## Erreur 5
Refactorer ARENA sans avoir `ScenarioBlueprint` et `ProofRubric` prêts.

---

# 6. Gating criteria par phase

## Fin Phase 0
- objets universels présents,
- interfaces providers présentes,
- stubs cyber branchables,
- traces compatibles.

## Fin Phase 1
- agents P0 sortent des objets noyau,
- cyber pack alimente réellement leurs décisions,
- certification et scénarios reposent sur des rubrics et blueprints.

## Fin Phase 2
- rétention, drift, routing et tutoring consomment la nouvelle grammaire,
- boucle d’apprentissage stabilisée.

## Fin Phase 3
- l’UX et les visualisations ne mentent plus sur l’état système,
- l’explicabilité est industrialisée.

## Fin Phase 4
- mini second pack branché,
- preuve d’extensibilité démontrée.

---

# 7. Verdict

Le vrai ordre du refactor est :

> **types → providers → P0 truth agents → cyber pack hardening → P1 dynamics → P2/P3 rendering/governance → second pack proof**

Si tu inverses cet ordre, tu risques de construire de la sophistication sur du sable.

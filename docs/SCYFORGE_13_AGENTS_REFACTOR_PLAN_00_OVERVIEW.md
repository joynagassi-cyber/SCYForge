# SCYForge — Plan C de refactor des 13 agents ASCENT
## 00. Vue d’ensemble

## But du Plan C

Le but de ce plan n’est pas de redécrire l’architecture idéale.
Le but est de dire **comment transformer l’ASCENT actuel** en une plateforme où :
- les agents consomment des **contracts domaine**,
- le **Pack Cyber** devient le premier pack de vérité métier complet,
- le noyau reste agnostique,
- la preuve de compétence devient robuste,
- et l’extension à d’autres domaines ne demande pas une réécriture.

Ce plan est volontairement rédigé **sans dépendre de RecursiveMAS**.
RecursiveMAS sera un détail d’implémentation potentiellement utile plus tard, mais le refactor doit rester valable même sans lui.

---

# 1. Les objectifs du refactor

## Objectif 1 — Faire du noyau un moteur de maîtrise, pas un moteur de contenu
Le cœur doit orchestrer la transformation :
- savoir privé → compréhension,
- compréhension → pratique,
- pratique → rétention,
- rétention → maîtrise,
- maîtrise → preuve,
- preuve → autonomie bornée.

## Objectif 2 — Séparer explicitement le domaine du moteur
Les agents ne doivent plus dépendre d’un savoir métier implicite.
Ils doivent dépendre de :
- providers,
- objets universels,
- politiques runtime.

## Objectif 3 — Rendre le Pack Cyber “vrai premier pack”
Le Pack Cyber doit cesser d’être surtout un corpus / des docs.
Il doit devenir une implémentation quasi complète de la vérité métier.

## Objectif 4 — Préserver la crédibilité B2B
Le refactor doit améliorer :
- l’auditabilité,
- la traçabilité,
- la défendabilité des verdicts,
- la clarté des scopes d’autonomie.

---

# 2. Les artefacts sur lesquels le plan s’appuie

Ce plan s’appuie sur les documents déjà produits :
- `SCYFORGE_FEATURE_PATTERNING_ARCHITECTURE.md`
- `SCYFORGE_FEATURE_TO_PROVIDER_MATRIX.md`
- `SCYFORGE_DOMAIN_CONTRACTS_BLUEPRINT.md`
- `SCYFORGE_DOMAIN_PACK_CONTRACT.md`
- `packs/cyber/pack.manifest.json`

---

# 3. Structure du Plan C

Le plan est découpé en plusieurs fichiers pour garder de la précision :

1. **00 — Overview**
2. **01 — Séquence de refactor globale**
3. **02 — Refactor agents P0**
4. **03 — Refactor agents P1**
5. **04 — Refactor agents P2/P3**
6. **05 — Objets universels et migrations de données**
7. **06 — Plan d’implémentation MVP / cyber-ready / multi-domain-ready**

---

# 4. Les 3 états cibles successifs

## État A — Kernel discipliné
Les agents dépendent des bons ports et écrivent les bons objets.

## État B — Cyber-ready
Le Pack Cyber implémente réellement les contracts critiques.

## État C — Multi-domain-ready
Un second mini-pack peut se brancher sans réécriture.

---

# 5. Les 4 règles du refactor

## Règle 1
On ne commence pas par l’UI.
On commence par les objets et les interfaces.

## Règle 2
On ne commence pas par les features décoratives.
On commence par les agents qui définissent la vérité de compétence.

## Règle 3
On ne fait pas d’agnosticité abstraite vide.
Chaque abstraction doit être immédiatement testable avec le Pack Cyber.

## Règle 4
On ne casse pas la capacité produit pour prouver l’élégance architecture.
Le refactor doit rester incrémental.

---

# 6. Les grands chantiers

## Chantier A — Objets universels
- `GoalSpec`
- `DomainReference`
- `MasteryNode`
- `ScenarioBlueprint`
- `ProofRecord`
- `ReadinessVerdict`

## Chantier B — Providers
- ontologie,
- rôles,
- preuves,
- scénarios,
- rétention,
- garde-fous.

## Chantier C — Cerveau ASCENT
- goal compilation,
- graph compilation,
- orchestration,
- scoring,
- certification.

## Chantier D — Pack Cyber complet
- validation guards,
- policies de rétention,
- blueprints de scénarios,
- scopes d’autonomie.

---

# 7. Ordre stratégique

L’ordre juste est :
1. formaliser les objets,
2. brancher les contracts,
3. refactorer les agents P0,
4. compléter le Pack Cyber,
5. refactorer les agents P1,
6. industrialiser explicabilité / visualisation,
7. démontrer extensibilité avec un mini deuxième pack.

---

# 8. Critère de succès du Plan C

Le Plan C est réussi si, à la fin :
- GOAL, DAG, CONDUCTOR, PERFORMANCE, CERTIFIER et ARENA ne contiennent plus de vérité cyber codée en dur,
- le Pack Cyber fournit vraiment cette vérité,
- et un mini-pack secondaire peut être branché sur le même noyau.

---

# 9. Prochain fichier à lire

La suite opérable est :
- `SCYFORGE_13_AGENTS_REFACTOR_PLAN_01_SEQUENCE.md`

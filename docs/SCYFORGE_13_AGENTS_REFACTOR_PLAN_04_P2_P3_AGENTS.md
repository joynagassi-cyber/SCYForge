# SCYForge — Plan C de refactor des 13 agents ASCENT
## 04. Refactor détaillé des agents P2 / P3

## Périmètre P2 / P3
- VISUAL-CRITIC
- COGNITIVE-VALIDATOR
- COSMOS
- ENGAGEMENT-AMPLIFIER

---

# 1. VISUAL-CRITIC

## Cible
Devenir un **Visual Integrity Guard**.

## Ce qui doit changer
- ne pas juste valider l’esthétique ou la cohérence locale,
- garantir que le visuel ne ment pas sur la structure réelle.

## Dépendances
- `ValidationGuardProvider`
- `OntologyProvider`

## Done criteria
- toute relation visuelle affichée existe dans les données,
- les labels et regroupements sont cohérents avec l’ontologie,
- aucun schéma critique ne sort sans validation structurelle.

---

# 2. COGNITIVE-VALIDATOR

## Cible
Devenir un **Cognitive Fit Guard**.

## Ce qui doit changer
- adapter la présentation à la charge cognitive sans déformer la vérité métier.

## Dépendances
- `RoleTaxonomyProvider`
- `RetentionPolicyProvider`
- `ValidationGuardProvider`

## Done criteria
- toute simplification préserve les termes essentiels,
- la difficulté est calibrée par rôle et niveau,
- les visualisations et explications restent sûres dans les domaines sensibles.

---

# 3. COSMOS

## Cible
Devenir un **Knowledge Visual Runtime**.

## Ce qui doit changer
- cesser de fonctionner comme un univers graphique un peu parallèle,
- devenir un consommateur fidèle du `MasteryGraph`, de l’ontologie et des preuves.

## Dépendances
- `OntologyProvider`
- `RoleTaxonomyProvider`
- `CorpusProvider`

## Done criteria
- chaque vue COSMOS correspond à un objet ou une relation réelle du noyau,
- les statuts affichés viennent de `ProofState` / `MasteryState`,
- les couleurs / heatmaps ont une signification stable.

---

# 4. ENGAGEMENT-AMPLIFIER

## Cible
Devenir une **Motivation Layer sous contrôle**.

## Ce qui doit changer
- ne jamais piloter la progression,
- seulement renforcer l’effort utile et la persistance.

## Dépendances
- `RetentionPolicyProvider`
- `RoleTaxonomyProvider`

## Done criteria
- aucune récompense importante sans vraie preuve,
- pas de streaks ou badges basés sur activité vide,
- les milestones sont liés à des étapes de maîtrise.

---

# 5. Critère de fin P2/P3

La phase est finie quand :
- les vues et explications ne créent plus d’état fantôme,
- l’UI est fidèle à la vérité noyau,
- la motivation ne pollue pas la mesure,
- la couche de présentation industrialise la crédibilité au lieu de la maquiller.

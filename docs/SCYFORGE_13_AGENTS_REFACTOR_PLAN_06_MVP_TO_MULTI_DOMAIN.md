# SCYForge — Plan C de refactor des 13 agents ASCENT
## 06. Du MVP refactoré au cyber-ready puis au multi-domain-ready

## But du fichier

Définir les étapes de livraison réalistes.

---

# 1. Niveau 1 — MVP refactoré

## Objectif
Prouver que le noyau peut fonctionner proprement sur un sous-ensemble critique.

## Scope recommandé
- GOAL-INTERPRETER refactoré
- DAG-ARCHITECT refactoré
- PERFORMANCE-ANALYZER partiellement refactoré
- SKILL-CERTIFIER minimal
- 1 provider cyber réel par type critique

## Ce que le MVP doit savoir faire
- compiler un objectif cyber SOC,
- générer un graphe de maîtrise minimal,
- attacher des refs ATT&CK / rôle / preuve,
- produire des `ProofRecord` minimaux,
- sortir un verdict readiness minimal borné.

---

# 2. Niveau 2 — Cyber-ready

## Objectif
Rendre le premier wedge cyber réellement vendable comme système de transformation du savoir en autonomie prouvée.

## Scope recommandé
- tous les agents P0 refactorés,
- `ValidationGuardProvider` cyber proche du complet,
- `DecisionScenarioProvider` sur plusieurs scénarios,
- `RetentionPolicyProvider` cyber,
- ARENA branché sur blueprints,
- CHRONICLE et BRAIN alignés sur les nouveaux objets.

## Ce que le système doit savoir faire
- ingérer des corpus cyber privés,
- générer des nœuds de maîtrise crédibles,
- faire pratiquer via scénarios,
- mesurer la preuve,
- rendre un scope d’autonomie borné.

---

# 3. Niveau 3 — Multi-domain-ready

## Objectif
Prouver que le noyau n’est pas prisonnier du cyber.

## Scope recommandé
- mini-pack `sales-lite` ou autre pack thin slice,
- même noyau, même providers, mêmes objets,
- un ou deux scénarios de preuve,
- un rôle, un graphe, un verdict minimal.

## Ce que ce niveau prouve
- l’agnosticité réelle,
- la robustesse des contracts,
- la capacité de changer de niche sans réécrire le cerveau.

---

# 4. Ce qu’il ne faut pas faire avant la fin du niveau 2

- industrialiser une UX trop riche,
- lancer plusieurs domain packs complets,
- investir trop de temps dans les couches cosmétiques,
- prétendre au multi-domaine avec seulement des abstractions vides.

---

# 5. Définition de done par niveau

## MVP refactoré
- le cœur parle les nouveaux objets,
- cyber est branché au moins minimalement,
- le verdict readiness existe.

## Cyber-ready
- la preuve de compétence cyber est défendable,
- ARENA est branché sur scénarios réels,
- le manager peut voir où la recrue est autonome ou non.

## Multi-domain-ready
- un second pack minimal fonctionne sans réécriture du cœur,
- la démonstration d’extensibilité n’est plus seulement théorique.

---

# 6. Verdict final

Le bon chemin n’est pas :
- “faire tout le produit idéal d’un coup”,
- ni “faire un framework vide extensible”.

Le bon chemin est :

> **refactorer le noyau juste assez pour rendre le cyber extrêmement fort, puis utiliser un mini second pack pour prouver que ce noyau est vraiment universel.**

C’est ce chemin qui protège à la fois :
- la puissance du wedge,
- la cohérence architecture,
- et la crédibilité long terme de la plateforme.

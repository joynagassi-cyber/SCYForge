<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧠 SCY FORGE — SCY-BRAIN, PROFESSOR AI & ONBOARDING ASCENT
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

## Spécification Fonctionnelle : Clarification, Starter Evaluator, Professor AI & BRAIN Advanced Chat Gen

---

**Document ID** : SPEC-BRAIN-ONBOARDING-V1
**Date** : 2026-06-08
**Statut** : 🔵 SPÉCIFICATION DE RÉFÉRENCE
**Score Confiance** : 95%
**Périmètre** : Formalise les fonctionnalités d'entrée du parcours ASCENT (Clarification + Starter Evaluator), le rôle transversal du **Professor AI**, le **SCY-BRAIN** (RAG + suggestions de nœud), et le module **BRAIN Advanced Chat Gen** (chat agentique mode normal / mode agentique).
**Compléments** : Étend `scy_forge_prd.md §7.7`, `scy_forge_all_feature.md §7`, `scy_forge-ascent-explain.md §3 (Agent-01)`.

---

## Table des Matières

1. [Vue d'Ensemble — Le Parcours Utilisateur de Bout en Bout](#1-vue-densemble)
2. [Les Deux Modes Produit — Ascendant & Normal](#2-les-deux-modes-produit)
3. [Fonctionnalité 1 — Clarification (Intent Elucidator)](#3-clarification)
4. [Fonctionnalité 2 — Starter Evaluator (Évaluation de Niveau)](#4-starter-evaluator)
5. [Professor AI — L'IA Centrale Accompagnatrice](#5-professor-ai)
6. [SCY-BRAIN — Double Alimentation & Suggestions de Nœud](#6-scy-brain)
7. [BRAIN Advanced Chat Gen — Chat Agentique](#7-brain-advanced-chat-gen)
8. [Stack Technique — Vercel AI SDK & Alternatives](#8-stack-technique)
9. [Schéma Base de Données](#9-schéma-base-de-données)
10. [API & Événements Temps Réel](#10-api--événements)
11. [Coûts LLM & Garde-fous](#11-coûts-llm--garde-fous)
12. [Matrice de Traçabilité Exigences](#12-matrice-de-traçabilité)

---

## 1. Vue d'Ensemble

Le parcours d'un apprenant dans SCY Forge démarre par une **séquence d'onboarding intelligente** qui garantit que le système comprend précisément *qui* est l'utilisateur et *ce qu'il veut* avant de produire le moindre contenu. Cette séquence évite la confusion en aval et conditionne la personnalisation pédagogique de tout le parcours.

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                  PARCOURS UTILISATEUR — DE L'INTENTION À LA COMPÉTENCE         │
└──────────────────────────────────────────────────────────────────────────────┘

   ┌─────────────┐
   │  UTILISATEUR │  « Je veux maîtriser React »
   └──────┬──────┘
          │
          ▼
   ╔═══════════════════════════════════════════════════════════════════════╗
   ║  ÉTAPE 1 — CLARIFICATION (Intent Elucidator)                          ║
   ║  • Agent dédié à l'élucidation de l'intention                          ║
   ║  • Questions auto-générées, claires et directes                       ║
   ║  • Réponses par choix d'options numérotées (1 à 5)                    ║
   ║  • Plusieurs clarifications successives → compréhension mutuelle       ║
   ╚════════════════════════════════════╤══════════════════════════════════╝
                                        ▼
   ╔═══════════════════════════════════════════════════════════════════════╗
   ║  ÉTAPE 2 — STARTER EVALUATOR (Évaluation de Niveau)                   ║
   ║  • Questions stratégiques et ciblées                                  ║
   ║  • Classification : Débutant / Intermédiaire / Avancé / Expert        ║
   ║  • Détermine la présentation et l'adaptation du contenu               ║
   ╚════════════════════════════════════╤══════════════════════════════════╝
                                        ▼
   ╔═══════════════════════════════════════════════════════════════════════╗
   ║  ÉTAPE 3 — PIPELINE ASCENT (9 agents) + PROFESSOR AI                  ║
   ║  • Le Professor AI accompagne à CHAQUE niveau du parcours             ║
   ║  • Connaissance complète de la formation → vulgarisation adaptée      ║
   ║  • SCY-BRAIN : Q&A contextuel + 3 suggestions intelligentes/nœud      ║
   ╚════════════════════════════════════╤══════════════════════════════════╝
                                        ▼
                              ✅  COMPÉTENCE ATTEINTE

   ┌──────────────────────────────────────────────────────────────────────┐
   │  EN PARALLÈLE — BRAIN ADVANCED CHAT GEN (module distinct)             │
   │  • Mode Normal : Q&A simple, réponses concises                        │
   │  • Mode Agentique : pipeline d'agents autonomes (PPT, rapports, veille)│
   └──────────────────────────────────────────────────────────────────────┘
```

### 1.1 Positionnement dans l'Architecture Existante

| Fonctionnalité décrite | Correspondance SCY Forge v2 | Statut |
|------------------------|------------------------------|--------|
| **Clarification** | Extension d'**AGENT-01 GOAL-INTERPRETER** (questionnaire adaptatif) | 🆕 Formalisé ici |
| **Starter Evaluator** | Extension d'**AGENT-01** + auto-positionnement **SINKT** (Agent-03) | 🆕 Formalisé ici |
| **Professor AI** | Couche d'accompagnement transversale au-dessus de **SCY-BRAIN** + **LEARNING-CONDUCTOR** | 🆕 Formalisé ici |
| **SCY-BRAIN (double alim. + suggestions)** | Extension de **§7.7 SCY-BRAIN** (RAG triple retrieval) | 🔄 Étendu |
| **BRAIN Advanced Chat Gen** | Nouveau module agentique distinct (s'appuie sur **NEURON-CHAINS** + 18 tools) | 🆕 Module nouveau |
| **Mode Ascendant / Mode Normal** | Deux modes produit principaux | 🆕 Formalisé ici |

---

## 2. Les Deux Modes Produit

SCY Forge expose **deux modes principaux** que l'utilisateur perçoit clairement dès l'entrée dans le produit.

### 2.1 Mode Ascendant (ASCENT)

**Objectif** : Atteindre une **compétence** sur un objectif déclaré, via un parcours structuré et garanti par les 9 agents.

- Entrée par la séquence **Clarification → Starter Evaluator → Pipeline ASCENT**.
- Génère un DAG de compétences, des documents par nœud, des flashcards APEX, et certifie via Proof of Skill.
- Le **Professor AI** accompagne à chaque nœud.

### 2.2 Mode Normal (Ingestion)

**Objectif** : **Ingérer** des sources d'information variées et les transformer en livrables exploitables, sans nécessairement viser une certification.

- Dédié à l'ingestion de diverses sources (11 cores).
- Transforme le contenu en **documents structurés**, **cartes APEX** et **visualisations COSMOS pertinentes**.
- Permet de synthétiser de gros volumes de données et de les rendre compréhensibles et exploitables.

> **Note de cohérence** : Le terme « cartes Apex » de la description = les **flashcards APEX/FSRS** du système. Les « visualisations » = les **8 modes COSMOS**.

### 2.3 Sélecteur de Mode (UX)

```
╔══════════════════════════════════════════════════════════════════╗
║   BIENVENUE DANS SCY FORGE — QUE VOULEZ-VOUS FAIRE ?            ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║   ┌────────────────────────┐    ┌────────────────────────┐      ║
║   │  🚀  MODE ASCENDANT    │    │  📥  MODE NORMAL       │      ║
║   │                        │    │                        │      ║
║   │  Maîtriser un objectif │    │  Ingérer & transformer │      ║
║   │  Parcours garanti      │    │  des sources           │      ║
║   │  → Compétence certifiée│    │  → Docs + Cartes + Viz │      ║
║   └────────────────────────┘    └────────────────────────┘      ║
║                                                                  ║
║   Vous pourrez basculer entre les deux modes à tout moment.      ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 3. Clarification

### 3.1 Mission

Au **tout début** du processus ASCENT, un **agent dédié à la clarification** (l'« Intent Elucidator ») a pour rôle de **cerner et élucider précisément l'intention de l'utilisateur**. L'objectif est de **prévenir toute confusion ultérieure** dans le parcours.

### 3.2 Principes de Conception

| Principe | Détail |
|----------|--------|
| **Personne/Agent dédié** | Un sous-agent spécialisé de GOAL-INTERPRETER, focalisé uniquement sur l'élucidation. |
| **Questions auto-générées** | Générées dynamiquement à partir de l'intention brute (pas de questionnaire figé). |
| **Claires et directes** | Formulation simple, une idée par question, sans jargon. |
| **Options numérotées 1–5** | L'utilisateur choisit parmi une liste d'options numérotées de 1 à 5 (réponse rapide, faible friction). |
| **Clarifications successives** | Plusieurs tours de clarification s'enchaînent jusqu'à une **compréhension mutuelle optimale**. |
| **Affinage progressif** | Chaque réponse réduit l'espace d'ambiguïté et précise la demande. |

### 3.3 Algorithme de Clarification (Boucle)

```
┌────────────────────────────────────────────────────────────────────┐
│  BOUCLE DE CLARIFICATION — jusqu'à clarté suffisante                │
└────────────────────────────────────────────────────────────────────┘

1. PARSER l'intention brute (LLM Reasoning, ~1 appel)
2. CALCULER le score de clarté (0–100) sur les dimensions :
     • Objet (quoi)        • Niveau visé        • Portée/scope
     • Contexte d'usage    • Contraintes temps  • Style attendu
3. SI score_clarté ≥ SEUIL (défaut 80) → SORTIE → Starter Evaluator
   SINON :
     a. IDENTIFIER la dimension la plus ambiguë
     b. GÉNÉRER 1 question claire + 2 à 5 options numérotées (+ champ libre optionnel)
     c. ATTENDRE le choix utilisateur (timer auto-validation 30s → option par défaut)
     d. METTRE À JOUR le profil & l'objectif formalisé
     e. RETOUR à l'étape 2
4. GARDE-FOU : max 5 tours de clarification (évite la fatigue)
```

### 3.4 Exemple d'Interaction

```
🧭 CLARIFICATION (1/3)

« Quand tu dis "maîtriser React", quel est ton objectif final ? »

   1️⃣  Décrocher un poste de développeur front-end
   2️⃣  Construire mes propres projets perso / side-projects
   3️⃣  Ajouter React à mes compétences pour mon poste actuel
   4️⃣  Préparer un entretien technique précis
   5️⃣  Autre (préciser)…

   ⏱  Sans réponse, je choisis l'option 2 dans 30s.
```
```
🧭 CLARIFICATION (2/3)

« En combien de temps souhaites-tu y arriver ? »

   1️⃣  Le plus vite possible (intensif)
   2️⃣  ~1 mois          3️⃣  ~3 mois
   4️⃣  ~6 mois          5️⃣  Pas de contrainte de temps
```

### 3.5 Sortie

À la fin de la clarification, l'objectif est **formalisé** (titre, domaine, scope estimé, contexte, contrainte temps, style) et transmis au **Starter Evaluator**.

---

## 4. Starter Evaluator

### 4.1 Mission

Après la phase de clarifications successives, le système passe au **Starter Evaluator**. Cette fonctionnalité **évalue le niveau réel de l'apprenant** au moyen de **questions stratégiques et ciblées**, puis le **classe** dans l'une des catégories :

| Niveau | Description | Effet sur la présentation du contenu |
|--------|-------------|--------------------------------------|
| 🟢 **Débutant** | Aucune ou très faible base | Explications complètes, analogies ELI5 (T41), rythme progressif, nombreux exemples |
| 🟡 **Intermédiaire** | Bases acquises, lacunes ciblées | Rappels condensés, focus sur les concepts intermédiaires difficiles, exercices d'application |
| 🟠 **Avancé** | Solide maîtrise pratique | Contenu dense, edge cases, comparaisons, fast-track sur les bases |
| 🔴 **Expert** | Maîtrise approfondie | Survol express, contenu de pointe, validation par défis, skip massif de nœuds |

> **Importance** : cette classification est **capitale** — elle détermine *comment* l'information est présentée et adaptée, et donc l'efficacité pédagogique (« savoir à qui l'on s'adresse »).

### 4.2 Méthode d'Évaluation

```
┌────────────────────────────────────────────────────────────────────┐
│  STARTER EVALUATOR — évaluation adaptative ciblée                   │
└────────────────────────────────────────────────────────────────────┘

1. SOURCES PASSIVES (0 friction, 0 token) — exploitées d'abord :
     • COSMOS Knowledge Graph → SMI des concepts déjà maîtrisés
     • APEX/FSRS → historique de révisions (niveau réel)
     • BRAIN/RAG → connaissances existantes de l'utilisateur
2. QUESTIONS STRATÉGIQUES (si signaux passifs insuffisants) :
     • 3 à 7 questions ciblées, difficulté adaptative (IRT léger)
     • Mélange : auto-évaluation + 1–2 mini-défis de validation
     • Chaque réponse ajuste l'estimation de niveau en temps réel
3. CLASSIFICATION :
     • Mapping score → {Débutant, Intermédiaire, Avancé, Expert}
     • Intervalle de confiance ([Intermédiaire, p=0.82])
4. AUTO-POSITIONNEMENT (handoff vers Agent-03 / SINKT) :
     • Point d'entrée dans le DAG selon le niveau classé
```

### 4.3 Question Adaptative — Exemple

```
🎯 STARTER EVALUATOR — Évaluation de ton niveau React

« Lequel de ces extraits gère correctement un effet de bord
  au montage d'un composant ? »

   1️⃣  useEffect(() => fetchData(), [])
   2️⃣  useEffect(() => fetchData())
   3️⃣  useState(() => fetchData())
   4️⃣  componentDidMount(fetchData)
   5️⃣  Je ne sais pas encore

   → Réponse correcte/incorrecte ajuste immédiatement la difficulté
     de la question suivante.
```

### 4.4 Sortie

- Niveau classé + intervalle de confiance.
- Point d'entrée DAG (via SINKT).
- Profil pédagogique enrichi consommé par le **Professor AI** et tout le pipeline.

---

## 5. Professor AI

### 5.1 Rôle

Le **MDG-BRAIN** (SCY-BRAIN) est équipé du **Professor AI**, son **intelligence artificielle centrale** qui agit comme **guide et accompagnateur** de l'utilisateur tout au long de son parcours ASCENT.

> **Promesse** : à chaque niveau de cours, le BRAIN **connaît l'intégralité de la formation**, afin de pouvoir expliquer les **concepts difficiles / intermédiaires de manière simple et ludique**, en fonction du **niveau de l'apprenant**.

### 5.2 Caractéristiques Clés

| Capacité | Description |
|----------|-------------|
| **Orientation** | Guide l'utilisateur à travers les différentes fonctionnalités et optimise son expérience. |
| **Accompagnement continu** | Présent à **chaque nœud/niveau** du parcours ASCENT. |
| **Connaissance globale** | Conscience de **toute** la formation (DAG complet + contenus de tous les nœuds), pas seulement du nœud courant. |
| **Vulgarisation adaptative** | Explique les concepts difficiles **simplement et de façon ludique**, calibré sur le niveau (Débutant → Expert). |
| **Pédagogie par niveau** | Choisit le ton (ELI5 T41 → ELI PhD T42), la profondeur et les analogies selon la classification du Starter Evaluator. |

### 5.3 Position Architecturale

Le **Professor AI** est une **couche d'accompagnement** qui s'appuie sur les briques existantes :

```
┌────────────────────────────────────────────────────────────────┐
│                        PROFESSOR AI                            │
│  (persona + politique de vulgarisation adaptée au niveau)      │
├────────────────────────────────────────────────────────────────┤
│  Contexte consommé :                                           │
│   • Niveau apprenant (Starter Evaluator)                       │
│   • Nœud courant + DAG complet (ASCENT / Agent-03 & 04)        │
│   • SMI temps réel (Agent-05 PERFORMANCE-ANALYZER)            │
│   • Connaissances user (COSMOS KG + APEX)                       │
├────────────────────────────────────────────────────────────────┤
│  Moteurs sous-jacents :                                        │
│   • SCY-BRAIN (RAG triple retrieval + RRF)                     │
│   • LEARNING-CONDUCTOR (Agent-04) pour l'orchestration         │
│   • Tons éditoriaux T01–T50 (sélection auto par niveau)        │
└────────────────────────────────────────────────────────────────┘
```

### 5.4 Politique de Vulgarisation par Niveau

| Niveau apprenant | Ton par défaut | Stratégie d'explication |
|------------------|----------------|--------------------------|
| Débutant | T41 ELI5 / T18 Pédagogique Clair | Analogies du quotidien, pas de jargon, schémas, micro-étapes |
| Intermédiaire | T08 Didactique Progressif | Rappel rapide → concept → exemple appliqué → piège courant |
| Avancé | T03 Technique Précis | Densité élevée, edge cases, nuances, comparaisons |
| Expert | T42 ELI PhD / T07 Analytique Critique | Discussion d'état de l'art, hypothèses, limites |

---

## 6. SCY-BRAIN

### 6.1 Double Alimentation

Le BRAIN est alimenté par **deux sources complémentaires**, garantissant des réponses **précises, exhaustives et à jour** :

```
            ┌──────────────────────────────────────────┐
            │              SCY-BRAIN                    │
            │      (RAG triple retrieval + RRF)         │
            └───────────────┬──────────────┬───────────┘
                            │              │
        ┌───────────────────▼──┐     ┌─────▼─────────────────────┐
        │ 1. BASE DE CONNAIS-  │     │ 2. ACCÈS INTERNET DIRECT  │
        │    SANCES DU PROJET  │     │    (recherche temps réel) │
        │                      │     │                           │
        │ • Sources ingérées   │     │ • Élargit l'étendue des   │
        │ • Chunks RAG du nœud │     │   connaissances           │
        │ • COSMOS KG du projet │     │ • Informations fraîches   │
        │ • Réponses           │     │ • Compléments hors base   │
        │   contextualisées    │     │                           │
        └──────────────────────┘     └───────────────────────────┘
```

**Priorité 1 — Base de connaissances du projet** : lorsqu'un utilisateur interagit dans le cadre d'un projet, **toutes les informations pertinentes à ce projet sont immédiatement accessibles** et utilisées pour des **réponses contextualisées**.

**Priorité 2 — Internet** : accès direct au web pour **rechercher en temps réel** et **élargir l'étendue des connaissances**.

> La **double alimentation** (base interne + recherche web dynamique) garantit des réponses **précises, exhaustives et à jour**.

### 6.2 Suggestions Intelligentes — 3 Questions par Nœud

Une fois une question posée, le BRAIN **ne se contente pas de répondre** : il propose **3 suggestions intelligentes de questions complémentaires**, basées sur le **« nœud » (contexte actuel)** de l'utilisateur.

```
╔════════════════════════════════════════════════════════════════════╗
║  Q : « Pourquoi utiliser useEffect plutôt qu'un appel direct ? »   ║
╠════════════════════════════════════════════════════════════════════╣
║  R : useEffect synchronise des effets de bord avec le cycle de     ║
║      rendu… [réponse contextualisée + citations [1][2]]            ║
╠════════════════════════════════════════════════════════════════════╣
║  💡 POUR ALLER PLUS LOIN (basé sur ton nœud « React Hooks ») :     ║
║   → Comment éviter les boucles infinies dans useEffect ?          ║
║   → Quelle est la différence entre useEffect et useLayoutEffect ? ║
║   → Comment nettoyer un abonnement dans le cleanup ?              ║
╚════════════════════════════════════════════════════════════════════╝
```

**Génération des suggestions** :
- Basée sur le **nœud DAG courant** + les concepts voisins du **COSMOS KG** (traversée 2-hop).
- Anticipe les besoins → favorise une **découverte progressive** et **pertinente**.
- Coût maîtrisé : graph traversal + cosine local (0 token LLM majoritairement ; cf. tool **T16 DocSuggester**).

### 6.3 Source de Configuration du Mode de Connaissance

Le périmètre de connaissance interrogé par le BRAIN est configurable :

| Mode de connaissance | Base projet | Internet | Usage |
|----------------------|:-----------:|:--------:|-------|
| **Projet seul** | ✅ | ❌ | Réponses strictement contextualisées, hors-ligne possible |
| **Internet seul** | ❌ | ✅ | Informations temps réel, veille |
| **Hybride** | ✅ | ✅ | Approche optimale (recommandé par défaut) |

---

## 7. BRAIN Advanced Chat Gen

### 7.1 Description

**BRAIN Advanced Chat Gen** est un **module distinct et avancé** offrant un **chat agentique complet**, destiné aux utilisateurs cherchant une interaction plus poussée et autonome avec l'IA. Il propose **deux modes de fonctionnement**.

### 7.2 Mode Normal

| Caractéristique | Détail |
|-----------------|--------|
| **Interaction** | Simple et directe : l'utilisateur pose des questions, reçoit des réponses. |
| **Style de réponse** | **Claires, concises et précises**. |
| **Cas d'usage** | Requêtes rapides, informations factuelles. |
| **Moteur** | SCY-BRAIN (RAG triple retrieval + RRF + SSE streaming). |

### 7.3 Mode Agentique

En **mode agentique**, l'utilisateur accède à une **pipeline d'agents autonomes** capables de **générer une variété de contenus** :

```
┌────────────────────────────────────────────────────────────────────┐
│              BRAIN ADVANCED CHAT GEN — MODE AGENTIQUE               │
└────────────────────────────────────────────────────────────────────┘

   Requête utilisateur
          │
          ▼
   ┌──────────────┐   Planification (ReAct) — APEX-AGENT méta-orchestrateur
   │  PLANNER     │   → décompose la tâche, choisit les tools
   └──────┬───────┘
          ▼
   ┌──────────────────────────────────────────────────────────┐
   │  AGENTS AUTONOMES + 18 TOOLS NATIFS RUST (NEURON-CHAINS)  │
   │                                                          │
   │  Livrables possibles :                                   │
   │   • 📄 Fichiers visualisables                            │
   │   • 📊 Présentations PowerPoint interactives & rapides   │
   │   • 📑 Rapports détaillés                                │
   │   • 🔭 Veilles technologiques approfondies               │
   │                                                          │
   │  Anti-hallucination 3 couches + score de confiance      │
   └──────┬───────────────────────────────────────────────────┘
          ▼
   ┌──────────────┐   Sortie streamée (UI premium) + livrables téléchargeables
   │  RENDER      │
   └──────────────┘
```

**Livrables du mode agentique** :
- **Fichiers visualisables** (documents, diagrammes, visualisations).
- **Présentations PowerPoint interactives et rapides** (basées sur les informations apprises et analysées) — cf. type de document **G13 PowerPoint**.
- **Rapports détaillés** (cf. famille de docs A/D + B01 rapport).
- **Veilles technologiques approfondies**, s'appuyant sur une **base de connaissances cumulative** + l'accès Internet.

### 7.4 Choix de la Source de Connaissance (par l'utilisateur)

L'utilisateur choisit le **mode de fonctionnement des agents** :

| Option | Base cumulative | Internet | Résultat |
|--------|:---------------:|:--------:|----------|
| **Base seule** | ✅ | ❌ | Travail uniquement sur la base de connaissances cumulative, **sans connexion Internet** |
| **Internet seul** | ❌ | ✅ | Travail exclusif avec Internet → informations **temps réel** |
| **Hybride** | ✅ | ✅ | Combine les deux → **résultats optimaux** |

### 7.5 Mode Normal vs Mode Agentique — Synthèse

| Dimension | Mode Normal | Mode Agentique |
|-----------|-------------|----------------|
| Interaction | Q→R directe | Pipeline d'agents autonomes |
| Réponses | Claires, concises, précises | Livrables riches générés |
| Latence | Faible (streaming token) | Variable (tâche multi-étapes) |
| Livrables | Réponse texte + citations | Fichiers, PPT, rapports, veille |
| Source | RAG projet/hybride | Base cumulative / Internet / hybride (au choix) |
| Cas d'usage | Questions rapides, factuel | Production, analyse approfondie, veille |

---

## 8. Stack Technique

### 8.1 Vercel AI SDK (Kit Agentique — Choix Principal)

Pour ce niveau de développement, le **Vercel AI SDK** (« kit agentique de Vercel ») est retenu pour l'interface de chat :

- ✅ **Streaming de texte premium** dans une interface de chat.
- ✅ **Intégration directe de graphiques**, **sections encadrées** et autres éléments interactifs (Generative UI / RSC).
- ✅ Expérience utilisateur **riche et immersive**.
- ✅ Tool calling + streaming d'objets structurés (compatible mode agentique).

| Élément | Technologie |
|---------|-------------|
| Streaming chat | Vercel AI SDK (`ai`, `@ai-sdk/react` — `useChat`, `streamText`) |
| UI générative | Composants React encadrés, graphiques (Recharts) inline |
| Transport | SSE (réponses) + WebSocket (événements agents) |

### 8.2 Alternatives Envisagées

Des kits **plus performants** pourraient être envisagés s'ils répondent mieux aux exigences de **performance et d'interactivité** :

| Alternative | Atout | Quand l'envisager |
|-------------|-------|-------------------|
| **LangGraph / LangChain.js** | Graphes d'agents complexes, persistance d'état | Pipelines agentiques très ramifiés |
| **Mastra** | Framework agent TypeScript, workflows + outils | Orchestration typée + observabilité |
| **assistant-ui** | Composants chat avancés prêts à l'emploi | Accélérer l'UI agentique |
| **CopilotKit** | Copilot in-app + actions | Actions contextuelles dans l'app |

> **Objectif transverse** : une présentation des informations **fluide, esthétique et hautement fonctionnelle**. Le choix final sera arbitré sur des critères mesurables (latence de streaming, qualité de l'UI générative, coût d'intégration).

### 8.3 Aperçu Implémentation (Mode Normal — TypeScript)

```typescript
// app/api/brain/chat/route.ts — Mode Normal (RAG + streaming premium)
import { streamText } from 'ai';
import { openai } from '@ai-sdk/openai';
import { retrieveContext } from '@/lib/brain/rag'; // triple retrieval + RRF (backend Rust)

export async function POST(req: Request) {
  const { messages, projectId, knowledgeMode } = await req.json();
  // knowledgeMode: 'project' | 'internet' | 'hybrid'

  const context = await retrieveContext({
    query: messages.at(-1).content,
    projectId,
    knowledgeMode,        // pilote base projet / web / hybride
    topK: 10,             // après RRF fusion
  });

  const result = streamText({
    model: openai('gpt-4.1-mini'),
    system: buildProfessorSystemPrompt(context.learnerLevel), // ton adapté au niveau
    messages,
    // injection du contexte RAG + instruction citations inline [1],[2]
    experimental_providerMetadata: { context },
  });

  return result.toDataStreamResponse(); // streaming premium → useChat()
}
```

---

## 9. Schéma Base de Données

```sql
-- ── CLARIFICATION ────────────────────────────────────────────────────────
CREATE TABLE scy_clarification_sessions (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES scy_users(id),
    goal_id         UUID REFERENCES scy_ascent_goals(id),
    raw_intent      TEXT NOT NULL,
    clarity_score   REAL,                 -- 0–100
    rounds          INTEGER DEFAULT 0,    -- nb de tours de clarification
    formalized_goal JSONB,                -- objectif formalisé en sortie
    status          TEXT DEFAULT 'in_progress', -- in_progress | completed | aborted
    created_at      INTEGER NOT NULL
);

CREATE TABLE scy_clarification_questions (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    session_id      UUID NOT NULL REFERENCES scy_clarification_sessions(id),
    round_index     INTEGER NOT NULL,
    question_text   TEXT NOT NULL,
    options         JSONB NOT NULL,        -- [{n:1,label:"…"}, … max 5]
    target_dimension TEXT,                 -- objet | niveau | scope | contexte | temps | style
    selected_option INTEGER,               -- 1–5 (NULL si champ libre)
    free_text       TEXT,                  -- réponse libre optionnelle
    auto_validated  BOOLEAN DEFAULT false, -- timer 30s déclenché
    answered_at     INTEGER
);

-- ── STARTER EVALUATOR ────────────────────────────────────────────────────
CREATE TABLE scy_starter_evaluations (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES scy_users(id),
    goal_id         UUID REFERENCES scy_ascent_goals(id),
    level_classified TEXT NOT NULL,        -- debutant | intermediaire | avance | expert
    confidence      REAL,                  -- 0–1
    used_passive_signals BOOLEAN DEFAULT false, -- COSMOS/APEX/BRAIN exploités
    questions_asked INTEGER DEFAULT 0,
    dag_entry_node  UUID REFERENCES scy_ascent_nodes(id), -- SINKT
    evaluation_data JSONB,                 -- détail des réponses + scoring IRT
    created_at      INTEGER NOT NULL
);

-- ── BRAIN — SUGGESTIONS PAR NŒUD ─────────────────────────────────────────
CREATE TABLE scy_brain_suggestions (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES scy_users(id),
    node_id         UUID REFERENCES scy_ascent_nodes(id),  -- nœud/contexte courant
    source_query    TEXT,                  -- question d'origine
    suggestions     JSONB NOT NULL,        -- exactement 3 suggestions
    generated_by    TEXT DEFAULT 'graph',  -- graph | llm_mini
    clicked_index   INTEGER,               -- suggestion cliquée (analytics)
    created_at      INTEGER NOT NULL
);

-- ── BRAIN ADVANCED CHAT GEN ──────────────────────────────────────────────
CREATE TABLE scy_brain_chat_sessions (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES scy_users(id),
    mode            TEXT NOT NULL,         -- 'normal' | 'agentic'
    knowledge_mode  TEXT NOT NULL,         -- 'base' | 'internet' | 'hybrid'
    project_id      UUID,                  -- contexte projet si applicable
    created_at      INTEGER NOT NULL
);

CREATE TABLE scy_brain_chat_deliverables (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    session_id      UUID NOT NULL REFERENCES scy_brain_chat_sessions(id),
    deliverable_type TEXT NOT NULL,        -- 'file' | 'pptx' | 'report' | 'tech_watch'
    title           TEXT,
    storage_url     TEXT,
    confidence_score REAL,                 -- score anti-hallucination
    tokens_spent    INTEGER,
    created_at      INTEGER NOT NULL
);

-- Index
CREATE index idx_clar_sessions_user ON scy_clarification_sessions(user_id, created_at DESC);
CREATE index idx_starter_eval_user  ON scy_starter_evaluations(user_id, created_at DESC);
CREATE index idx_brain_sugg_node    ON scy_brain_suggestions(node_id, created_at DESC);
CREATE index idx_brain_chat_user    ON scy_brain_chat_sessions(user_id, created_at DESC);
```

---

## 10. API & Événements

### 10.1 Endpoints REST

```
POST /api/ascent/clarify            → Démarre/poursuit la boucle de clarification
     body: { intent?, session_id?, selected_option?, free_text? }
     resp: { session_id, clarity_score, next_question? , formalized_goal? }

POST /api/ascent/evaluate           → Lance/poursuit le Starter Evaluator
     body: { goal_id, session_id?, answer? }
     resp: { level_classified, confidence, next_question?, dag_entry_node? }

POST /api/brain/query               → Q&A BRAIN (RAG) + suggestions
     body: { query, node_id?, project_id?, knowledge_mode }
     resp: { answer, citations[], suggestions[3] }   // SSE pour la réponse

POST /api/brain/chat                → BRAIN Advanced Chat Gen
     body: { messages, mode: 'normal'|'agentic', knowledge_mode, project_id? }
     resp: stream (texte premium) + (mode agentique) deliverables[]
```

### 10.2 Événements WebSocket (extension de `WsMessage`)

```rust
pub enum WsMessage {
    // … (existants)
    ClarificationQuestion { session_id: Uuid, question: String, options: Vec<Opt> },
    ClarificationDone     { goal_id: Uuid, clarity_score: f32 },
    LevelClassified       { level: String, confidence: f32 },
    BrainSuggestions      { node_id: Uuid, suggestions: [String; 3] },
    AgenticStep           { step: String, tool: String, progress_percent: u8 },
    DeliverableReady      { kind: String, title: String, url: String, confidence: f32 },
}
```

---

## 11. Coûts LLM & Garde-fous

Cohérent avec la stratégie anti-goulot (`ANALYSE-COUTS-LLM-PIPELINE-AGENTIQUE.md`) :

| Composant | Mécanisme | Coût indicatif |
|-----------|-----------|----------------|
| **Clarification** | 1 appel parse + génération questions (mini) ; max 5 tours | ~$0.0003 / parcours |
| **Starter Evaluator** | Signaux passifs d'abord (0 token) ; questions mini si besoin | ~$0.0002 / parcours |
| **Suggestions de nœud (T16)** | Graph traversal + cosine local (0 token majoritaire) | ~$0 |
| **BRAIN Mode Normal** | RAG + 1 génération (ModelRouter T05, DeepSeek par défaut) | $0.0001–0.0003 / question |
| **BRAIN Mode Agentique** | Pipeline NEURON-CHAINS + 18 tools, BudgetGuard T17 | Variable, plafonné par quotas |

**Garde-fous** :
- ✅ `BudgetGuard (T17)` : alertes 80 % / throttle 95 % / stop 100 %.
- ✅ `SemanticCache (T18)` : ré-utilisation des réponses similaires (threshold 0.87).
- ✅ Quotas adaptatifs Free/Premium (cf. §15 features).
- ✅ Anti-hallucination 3 couches sur tous les livrables agentiques.

---

## 12. Matrice de Traçabilité

| # | Exigence (description utilisateur) | Section | Statut |
|---|-------------------------------------|---------|--------|
| R1 | Clarification au début d'ASCENT, agent dédié à l'élucidation | §3 | ✅ |
| R2 | Questions auto-générées, claires et directes | §3.2–3.4 | ✅ |
| R3 | Réponses par options numérotées 1 à 5 | §3.2, §9 | ✅ |
| R4 | Plusieurs clarifications successives | §3.3 | ✅ |
| R5 | Starter Evaluator évalue le niveau réel | §4 | ✅ |
| R6 | Questions stratégiques et ciblées | §4.2–4.3 | ✅ |
| R7 | Classification Débutant/Intermédiaire/Avancé/Expert | §4.1 | ✅ |
| R8 | Classification → adaptation de la présentation | §4.1, §5.4 | ✅ |
| R9 | Professor AI : IA centrale, guide & accompagnateur | §5 | ✅ |
| R10 | Accompagnement à chaque niveau ASCENT, connaissance globale | §5.2 | ✅ |
| R11 | Vulgarisation simple & ludique selon le niveau | §5.4 | ✅ |
| R12 | BRAIN alimenté par la base de connaissances du projet | §6.1 | ✅ |
| R13 | Accès direct Internet (temps réel) | §6.1 | ✅ |
| R14 | Double alimentation → réponses précises/exhaustives/à jour | §6.1 | ✅ |
| R15 | 3 suggestions de questions basées sur le nœud courant | §6.2 | ✅ |
| R16 | BRAIN Advanced Chat Gen — module distinct, chat agentique | §7 | ✅ |
| R17 | Mode normal : réponses claires, concises, précises | §7.2 | ✅ |
| R18 | Mode agentique : pipeline d'agents autonomes | §7.3 | ✅ |
| R19 | Génération fichiers visualisables, PPT, rapports, veille | §7.3 | ✅ |
| R20 | Choix base cumulative / Internet / hybride | §7.4, §6.3 | ✅ |
| R21 | Vercel AI SDK (streaming premium, graphiques, sections encadrées) | §8.1 | ✅ |
| R22 | Alternatives plus performantes envisageables | §8.2 | ✅ |
| R23 | Deux modes produit : Ascendant & Normal | §2 | ✅ |
| R24 | Mode normal : ingestion → docs structurés, cartes Apex, visualisations | §2.2 | ✅ |

---

**Document rédigé par** : Agent Mode — Arena.ai
**Date** : 2026-06-08
**Version** : 1.0
**Statut** : ✅ PRÊT POUR REVUE
**Documents liés** : `scy_forge_prd.md`, `scy_forge_all_feature.md`, `scy_forge-ascent-explain.md`, `scy_forge_neurochain_explain.md`, `ANALYSE-COUTS-LLM-PIPELINE-AGENTIQUE.md`

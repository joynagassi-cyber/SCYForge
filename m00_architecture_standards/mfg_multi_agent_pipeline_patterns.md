# 🏗️ PATTERNS MULTI-AGENTS EN PRODUCTION — MINDFORGE v3.5
## Guide d'Ingénierie pour le Codage, l'Optimisation, la Sécurité, le Contrôle des Coûts, la Qualité et la Résilience

**Document ID** : ARCH-MULTI-AGENT-PATTERNS-V3.5  
**Date** : 2026-06-12  
**Statut** : 🟢 INVARIANTS TECHNIQUES DE PRODUCTION IMMUABLES ET EXHAUSTIFS  

---

## 🧭 Introduction : Pourquoi les Patterns Multi-Agents ?

Faire collaborer de multiples séries d'agents autonomes (comme nos 13 agents d'**ASCENT**, nos 6 agents d'**`ASCENT-QA`**, et l'**APEX-AGENT**) introduit des problématiques complexes de non-déterminisme, de latence réseau, de dérive d'erreurs et de dérapages de coûts (Token Bleeding). 

Pour industrialiser ces processus et s'assurer qu'ils supportent des millions d'utilisateurs sans failles, MindForge s'appuie sur une charte stricte de **7 axes d'ingénierie de production** :

---

## 1. AXE CODAGE : Structure et typage des agents

* **Pattern 1 : Gestion d'État Découplée (State-First, Not Agent-First)** :  
  Il est interdit de faire transiter l'historique complet des conversations brutes d'agent en agent. Le système utilise un **Schéma d'État Unifié (Shared State Schema)**. Les agents agissent comme des fonctions pures qui lisent des tranches spécifiques de cet état et y écrivent des mutations typées, évitant l'inflation et la corruption de contexte.
* **Pattern 2 : Contrats d'Entrées/Sorties Stricts (Zod-to-Zod & Rust Structs)** :  
  Chaque transition et passage de relais d'agent à agent est validé par des contrats stricts (Zod côté TypeScript, structures typées côté Rust). Tout payload non conforme est rejeté avant exécution de l'agent récepteur.
* **Pattern 3 : Ports & Adapters (Hexagonal Decoupling)** :  
  Les définitions d'agents sont découplées de leurs protocoles de transport (HTTP, WebSocket, gRPC, CLI). Un agent peut être testé localement sans instancier de serveur.

---

## 2. AXE OPTIMISATION : Performance, Parallélisme et Latence

* **Pattern 4 : Parallélisation & Fan-Out Concurrente** :  
  Les agents dont les tâches sont indépendantes (ex : les 6 validateurs d'**`ASCENT-QA`** ou l'extraction parallèle de chapitres) doivent s'exécuter en parallèle via des runtimes asynchrones (`Promise.all` en Node.js, `tokio::spawn` en Rust), réduisant le temps d'exécution jusqu'à 80%.
* **Pattern 5 : Progressive Disclosure of Context (LOD)** :  
  Pour économiser la fenêtre de contexte, les compétences et les instructions de référence sont structurées en 3 niveaux :
  - *Niveau 0* : L'agent ne voit que la liste des noms et descriptions de compétences.
  - *Niveau 1* : L'agent charge le contenu complet de la compétence uniquement s'il en a besoin.
  - *Niveau 2* : L'agent charge les documents de référence spécifiques associés.
* **Pattern 6 : Lazy Evaluation & State Caching** :  
  L'état intermédiaire de chaque jalon d'apprentissage ou étape de SAGA est sauvegardé. En cas d'échec d'un agent en fin de pipeline, le traitement reprend au dernier jalon valide mis en cache, sans ré-exécuter le pipeline complet.

---

## 3. AXE SÉCURITÉ : Isolation et Protection des Données

* **Pattern 7 : Agent-Aware Access Control (MCP Access Isolation)** :  
  La sécurité n'est pas confiée aux prompts système de l'agent. Les autorisations d'outils et d'accès aux répertoires sont gérées et verrouillées au niveau du serveur de protocole **MCP (Model Context Protocol)**. Un agent de relecture de code ne peut pas appeler d'outils d'écritures en base de données relationnelle ; un agent d'ingestion ne peut pas exécuter de commande shell.
* **Pattern 8 : PII Stripping déterministe (Conformité RGPD)** :  
  Avant d'écrire toute mémoire, trace socratique ou compétence dans un dossier ou une base de données persistante, un analyseur local (regex + classification NER) purge systématiquement les noms, e-mails, adresses, et secrets.
* **Pattern 9 : Adversarial Prompt Guardrails** :  
  Toutes les requêtes utilisateur ou documentations ingérées sont filtrées en amont par des modèles légers de détection de prompt-injections (ex: injecter "Ignore les instructions précédentes") pour étouffer l'attaque à la source.

---

## 4. AXE RATIONALISATION DES COÛTS : Anti-Token Bleeding

* **Pattern 10 : Dynamic Model Routing (L'arbitrage de budget)** :  
  Utiliser des modèles légers et ultra-rapides pour les tâches d'aiguillages, de formatage ou de validation visuelle simple, et n'escalader vers les modèles denses de raisonnement (DeepSeek R1 ou Claude Opus) que pour les tâches d'analyses sémantiques ou d'expertises cliniques d'**`AGENT-16`**.
* **Pattern 11 : Prompt Caching Strategy** :  
  Tous les prompts système des Neuron-Chains doivent être statiques en tête du message et la donnée dynamique en queue, maximisant le Prompt Caching de l'API DeepSeek pour économiser 90% des coûts d'inputs.
* **Pattern 12 : Bounded Loop Execution & BudgetGuard** :  
  Toute boucle récursive d'agents (comme l'auto-correction ou l'évaluation) doit être bridée par un nombre maximal d'appels stricts (`MAX_LLM_CALLS = 10`) et surveillée en direct par `BudgetGuard T15` pour couper immédiatement l'exécution en cas de boucle infinie.

---

## 5. AXE QUALITÉ : Rigueur Pédagogique et Sémantique

* **Pattern 13 : Le Modèle Évaluateur-Optimiseur (Generator-Evaluator)** :  
  Le code ne confie jamais la génération et la validation au même agent. L'APEX-AGENT génère le contenu pédagogique, et l'expert virtuel **`AGENT-16 (SME)`** l'évalue contre une grille d'évaluation stricte issue des 10 commandements de sûreté. Si le score est rejeté, l'évaluateur renvoie des critiques socratiques structurées pour forcer la réécriture.
* **Pattern 14 : Alignement Constructif de Biggs (John Biggs)** :  
  Le validateur académique `QA-06` vérifie l'alignement structurel strict entre les objectifs sémantiques du cours et les questions de l'examen SurveyJS pour garantir la validité absolue de la certification Proof of Skill.

---

## 6. AXE RÉSILIENCE EN PRODUCTION : Tolérance aux Pannes SRE

* **Pattern 15 : Transactions Distribuées SAGA** :  
  Les processus multi-services d'ASCENT (écriture PostgreSQL, vectorisation Zilliz, caching local) s'exécutent au sein d'une transaction SAGA avec compensation automatique de nettoyage s'activant récursivement en arrière-plan en cas de panne réseau ou de rejet.
* **Pattern 16 : Outbox & Dead Letter Queue (DLQ)** :  
  Cohérence transactionnelle assurée. Tout événement FSRS ou progression locale est stocké dans la base PostgreSQL unifiée de manière atomique avant diffusion sur l'EventBus. En cas d'échec de synchronisation, les événements sont stockés en DLQ locale (IndexedDB WAL).
* **Pattern 17 : Bulkhead & Fault Isolation** :  
  Les files d'exécution et les pools de threads (Tokio) de nos agents sont cloisonnés de manière étanche. Si le service d'extraction de transcription YouTube subit une panne, il ne peut en aucun cas geler, ralentir ou bloquer les sessions de révisions de cartes de l'étudiant.

---

## 7. AXE RIGUEUR : Traçabilité et Métacognition

* **Pattern 18 : Trajectory Logging (Audit Trail complet)** :  
  Il est interdit de debugger des agents par des logs textuels informels. Toutes les décisions, les invites d'entrées, les arguments d'outils appelés, les latences p95, et les jetons réels consommés sont journalisés de manière structurée dans les tables d'audits d'Insforge (`mfg_agent_decisions`, `mfg_llm_spend_log`).
* **Pattern 19 : Méta-Axiomatisation (Induction & Curation)** :  
  Pour éviter le dérapage de mémorisation et le déclin d'erreurs (model collapse), l'agent **`AXIOMATIZER (AGENT-15)`** exécute une curation cyclique tous les 7 jours. Il synthétise les traces brutes réussies de cohortes d'élèves en Lois et Méthodes Fondamentales uniques, et purge l'intégralité du cache de micro-compétences d'origine.

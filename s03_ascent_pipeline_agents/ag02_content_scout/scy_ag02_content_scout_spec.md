# 🔍 SCY-AG02-CONTENT-SCOUT — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG02_CONTENT_SCOUT_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement de l'**AGENT-02 : CONTENT-SCOUT**. Sa mission est de **découvrir, sélectionner et classer automatiquement les meilleures sources** (parmi les 13 cores d'ingestion) pour chaque nœud de compétence du DAG produit par l'AGENT-03. Il équilibre **pertinence pédagogique, qualité et coût**, en privilégiant le cache mutualisé (`mfg_shared_content_cache`) pour maintenir le coût à $0,006/parcours.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step).
* **Découverte de sources** : requêtage des **13 cores d'ingestion** (YouTube, Web, Academic, Science, etc.) via leurs adaptateurs.
* **Routage de modèles** : LlmRouter + BudgetGuard (pour le classement/résumé).
* **Cache mutualisé** : `mfg_shared_content_cache` (priorisation absolue des sources déjà ingérées).
* **Validation** : modèles **Zod** pour la liste de sources classée.
* **EventBus** : `SourceIngested`, `IngestionFailed`.

> **Rappel anti-hallucination** : CONTENT-SCOUT n'invente jamais de sources ; il sélectionne parmi les résultats réels des cores d'ingestion et du cache. Aucune URL fictive n'est générée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Découverte Multi-Core par Nœud

#### Scénario : Sélection des sources pertinentes pour un nœud
- **GIVEN** Un nœud de compétence produit par l'AGENT-03 (ex : « Hooks React »).
- **WHEN** Le CONTENT-SCOUT traite le nœud.
- **THEN** le système SHALL interroger les cores d'ingestion pertinents (ex : YouTube, Web, Academic) pour découvrir des candidats.
- **AND** le système SHALL vérifier en priorité le `mfg_shared_content_cache` pour réutiliser des sources déjà ingérées (cache hit → $0).
- **AND** le système SHALL émettre des tâches d'ingestion asynchrones uniquement pour les sources nouvelles (miss).

---

### Requirement : Classement par Pertinence, Qualité et Coût

#### Scénario : Ordonnancement des candidats
- **GIVEN** Une liste de candidats sources pour un nœud.
- **WHEN** Le système classe les sources.
- **THEN** le système SHALL scorer chaque source sur : pertinence sémantique (embeddings), qualité pédagogique (heuristiques / LLM léger), et coût (préférence cache > local > API payante).
- **AND** le système SHALL produire une liste ordonnée validée par un schéma **Zod** (`SourceListSchema`).
- **AND** le système SHALL respecter le BudgetGuard (pas de sur-ingestion).

---

### Requirement : Gestion des Échecs d'Ingestion

#### Scénario : Résilience face aux sources défaillantes
- **GIVEN** Une source dont l'ingestion échoue (indisponible, bloquée).
- **WHEN** Un core renvoie une erreur.
- **THEN** le système SHALL capter l'événement `IngestionFailed`.
- **AND** le système SHALL rétrograder la source et passer à la suivante dans le classement.
- **AND** le système SHALL garantir qu'au moins une source valide est retenue par nœud (si disponible).

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Générer ou inventer des URLs/sources non retournées par un core réel.
* 🚫 **SHALL NOT** : Ré-ingérer une source déjà présente dans `mfg_shared_content_cache`.
* 🚫 **SHALL NOT** : Dépasser le budget alloué (BudgetGuard) pour la découverte d'un nœud.
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens de `design.md`.
* ⚠️ **MUST** : Tout retour est validé par **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (Découverte)** : Pour un nœud, au moins une source pertinente est sélectionnée parmi les cores.
* **Test Case 2 (Cache)** : Une source déjà en cache est réutilisée sans ré-ingestion ($0).
* **Test Case 3 (Classement)** : Les sources sont ordonnées par score (pertinence/qualité/coût).
* **Test Case 4 (Échec)** : Une source défaillante est rétrogradée et remplacée.
* **Test Case 5 (Budget)** : La découverte ne dépasse pas le BudgetGuard.

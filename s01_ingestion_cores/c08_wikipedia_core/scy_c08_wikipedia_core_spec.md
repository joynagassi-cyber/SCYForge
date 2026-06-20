# 🌐 SCY-WIKIPEDIA-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_WIKIPEDIA_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion Wikipédia (`c08_wikipedia_core`)** de SCY Forge. Le système doit être capable, à partir d'un titre d'article ou d'une URL Wikipédia, d'extraire le contenu encyclopédique structuré (résumé, sections, infobox) via la **MediaWiki Action API**, et d'en extraire le **graphe de wikiliens** (liens internes entre concepts) pour nourrir directement la base de connaissances COSMOS. L'API Wikipédia étant publique et gratuite, l'ingestion s'effectue à **coût d'infrastructure nul (0 $)**.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **MediaWiki Action API** (publique, gratuite) :
  - `https://{lang}.wikipedia.org/w/api.php?action=query&prop=extracts&explaintext=1` — résumé/extrait en texte brut (extension TextExtracts).
  - `...&prop=sections` — structure des sections de l'article (extension SectionExtractor).
  - `...&prop=links&pllimit=...` — liste des liens internes (pour le graphe de wikiliens).
  - `...&prop=categories` — catégories thématiques.
  - `generator=search` (gssearch) — recherche d'articles par mot-clé.
* **MediaWiki REST API** (alternative pour le HTML propre) :
  - `https://{lang}.wikipedia.org/api/rest_v1/page/html/{title}` — HTML complet de l'article.
* **Client HTTP** : `reqwest` (Rust) avec `User-Agent` descriptif (obligatoire selon la politique Wikimedia), rate limiting respectueux.
* **Nettoyage HTML** : `dom_smoothie` (core `c02_web_article_core`) pour la conversion HTML/Wikitext → Markdown.
* **Parsing** : `serde_json` pour les réponses paginées de l'Action API.

> **Rappel anti-hallucination** : tout composant listé ci-dessus est une dépendance réelle et vérifiable. La MediaWiki API est publique, gratuite et ne requiert aucune clé (uniquement un `User-Agent` descriptif obligatoire selon la User-Agent policy de Wikimedia). Aucune API tierce payante n'est autorisée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Résolution d'Article (Titre / URL / Recherche)

#### Scénario : Ingestion depuis un titre d'article
- **GIVEN** Un titre d'article Wikipédia (ex : `Reactoskopie`) et une langue cible (ex : `fr`).
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` lance l'ingestion.
- **THEN** le système SHALL résoudre le titre vers un identifiant de page via l'Action API.
- **AND** le système SHALL gérer la résolution canonique (redirections) pour pointer vers l'article final.
- **AND** le système SHALL rejeter les titres inexistants avec le code `ARTICLE_NOT_FOUND`.

#### Scénario : Recherche par mot-clé
- **GIVEN** Un mot-clé fourni par l'utilisateur.
- **WHEN** L'utilisateur recherche un article pertinent.
- **THEN** le système SHALL utiliser `generator=search` pour retourner les meilleurs résultats correspondants.
- **AND** le système SHALL permettre à l'utilisateur (ou à l'agent) de sélectionner l'article cible.

---

### Requirement : Extraction du Contenu Structuré

#### Scénario : Conversion en Markdown sémantique
- **GIVEN** Un article Wikipédia valide et résolu.
- **WHEN** Le système ingère l'article.
- **THEN** le système SHALL récupérer l'extrait via `prop=extracts` (résumé) et le HTML complet via l'API REST.
- **AND** le système SHALL convertir le contenu en Markdown sémantique via `dom_smoothie` (titres, paragraphes, listes, tableaux).
- **AND** le système SHALL extraire la structure des sections via `prop=sections` pour préserver la hiérarchie.
- **AND** le système SHALL extraire l'infobox (si présente) en tableau Markdown structuré.
- **AND** le système SHALL écrire le Markdown dans `mfg_project_sources` et indexer dans Zilliz.

---

### Requirement : Extraction du Graphe de Wikiliens (Knowledge Graph)

#### Scénario : Construction du graphe conceptuel
- **GIVEN** Un article Wikipédia valide.
- **WHEN** Le système extrait les wikiliens.
- **THEN** le système SHALL récupérer tous les liens internes via `prop=links` (avec pagination `plcontinue`).
- **AND** le système SHALL filtrer les liens vers les espaces de noms non pertinents (ex : `Catégorie:`, `Aide:`) selon configuration.
- **AND** le système SHALL créer des arêtes sémantiques dans COSMOS reliant l'article ingéré à chaque concept lié.
- **AND** le système SHALL calculer un poids d'arête basé sur la fréquence/contexte du lien.

---

### Requirement : Support Multilingue & Rétention

#### Scénario : Ingestion multilingue
- **GIVEN** Un titre d'article et une langue cible différente de l'anglais.
- **WHEN** L'utilisateur précise la langue (ex : `fr`, `es`, `de`).
- **THEN** le système SHALL cibler le sous-domaine Wikipédia approprié (`{lang}.wikipedia.org`).
- **AND** le système SHALL préserver la langue détectée dans les métadonnées pour le routage ultérieur.

#### Scénario : Dé-duplication par cache
- **GIVEN** Un article déjà indexé dans `mfg_shared_content_cache`.
- **WHEN** Une nouvelle ingestion du même article (même titre + langue + révision) est demandée.
- **THEN** le système SHALL comparer `page_id` + `last_rev_id` avec le cache.
- **AND** le système SHALL ignorer l'article si déjà à jour, sauf si une nouvelle révision est détectée.

---

### Requirement : Respect des Limites de l'API Wikimedia

#### Scénario : Bon citoyen de l'API
- **GIVEN** Plusieurs requêtes vers l'API Wikipédia.
- **WHEN** Le système émet des appels consécutifs.
- **THEN** le système SHALL inclure systématiquement un en-tête `User-Agent` descriptif.
- **AND** le système SHALL limiter le débit (200 requêtes/seconde max par hôte selon la politique).
- **AND** le système SHALL respecter les en-têtes de répartition de charge (`Retry-After` sur `429`/`503`).

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Émettre des requêtes sans en-tête `User-Agent` descriptif (rejet par Wikimedia).
* 🚫 **FORBIDDEN** : Dépasser 200 requêtes/seconde par hôte (politique API Wikimedia).
* 🚫 **SHALL NOT** : Ingestion en profondeur récursive non bornée du graphe de wikiliens (risque d'explosion combinatoire) — profondeur max configurable.
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens définis dans `design.md`.
* ⚠️ **MUST** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (Titre → Article)** : Un titre valide renvoie un Markdown structuré avec résumé, sections et infobox, score DRACO ≥ 85/100.
* **Test Case 2 (Graphe de wikiliens)** : L'extraction crée des arêtes COSMOS vers les concepts liés, avec filtrage des espaces de noms non pertinents.
* **Test Case 3 (Multilingue)** : Un article ingéré en `fr` cible `fr.wikipedia.org` et préserve la langue.
* **Test Case 4 (Dé-duplication)** : Un article déjà à jour (même `last_rev_id`) est sauté sans appel réseau.
* **Test Case 5 (Introuvable)** : Un titre inexistant renvoie `ARTICLE_NOT_FOUND` sans exception non gérée.

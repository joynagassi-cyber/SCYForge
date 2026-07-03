<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🐦 SCY-TWITTER-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_TWITTER_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Purpose
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion Twitter/X (`c07_twitter_core`)** de SCY Forge. Le système doit être capable, à partir d'un identifiant de tweet, d'un nom d'utilisateur ou d'une URL de thread, d'extraire les métadonnées, le contenu textuel, les médias et de **reconstruire récursivement les threads** (conversation complète) via la **Twitter API v2** (`conversation_id`). Le résultat est structuré en Markdown hiérarchique et indexé.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **API Twitter/X v2** (authentification Bearer Token stocké dans le gestionnaire de secrets) :
  - `GET /2/tweets/{id}` — récupération d'un tweet et de ses champs (`author_id`, `conversation_id`, `referenced_tweets`, `entities`).
  - `GET /2/users/by/username/{username}` — résolution `@username` → `user_id`.
  - `GET /2/tweets/search/recent` — recherche des réponses via filtre `conversation_id:{cid}` pour la reconstruction de thread.
  - Expansion des médias via le paramètre `expansions=attachments.media_keys` + `media.fields`.
* **Client HTTP** : `reqwest` (Rust) avec Bearer Token injecté depuis secrets, rate limiting + Circuit Breaker.
* **Parsing JSON** : `serde_json` pour les réponses paginées de l'API v2.
* **Nettoyage** : `dom_smoothie` non requis ici (contenu déjà textuel), mais extraction des URLs/médias via `entities`.

> **Rappel anti-hallucination** : tout composant listé ci-dessus est une dépendance réelle et vérifiable. La Twitter API v2 requiert un Bearer Token (gestion via secrets Northflank). Aucune API tierce de scraping non officielle n'est autorisée en première intention.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Résolution d'Identifiant (Tweet / Utilisateur / URL)

#### Scénario : Résolution d'une URL de tweet
- **GIVEN** Une URL de tweet valide (ex : `https://x.com/{user}/status/{id}`).
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` lance l'ingestion.
- **THEN** le système SHALL extraire l'identifiant de tweet depuis l'URL.
- **AND** le système SHALL appeler `GET /2/tweets/{id}` avec les champs appropriés.
- **AND** le système SHALL rejeter les tweets inexistants/supprimés avec le code `TWEET_NOT_FOUND`.

#### Scénario : Résolution d'un nom d'utilisateur
- **GIVEN** Un nom d'utilisateur (ex : `@username`).
- **WHEN** L'utilisateur demande l'ingestion du profil.
- **THEN** le système SHALL résoudre le nom en `user_id` via `GET /2/users/by/username/{username}`.
- **AND** le système SHALL récupérer les tweets récents de l'utilisateur.
- **AND** le système SHALL rejeter les utilisateurs inexistants avec le code `USER_NOT_FOUND`.

---

### Requirement : Reconstruction Récursive de Thread

#### Scénario : Reconstruction d'une conversation complète
- **GIVEN** Un tweet racine possédant un `conversation_id`.
- **WHEN** Le système reconstruit le thread.
- **THEN** le système SHALL rechercher toutes les réponses via `search/recent` avec le filtre `conversation_id:{cid}`.
- **AND** le système SHALL paginer via `next_token` jusqu'à épuisement ou limite configurable (profondeur max).
- **AND** le système SHALL ordonner chronologiquement les tweets par `created_at`.
- **AND** le système SHALL reconstruire la hiérarchie parent-enfant via `referenced_tweets` (type `replied_to`).
- **AND** le système SHALL structurer le thread en Markdown imbriqué avec auteur, horodatage et citations.

---

### Requirement : Extraction des Médias & Entités

#### Scénario : Capture des images, vidéos et liens
- **GIVEN** Un tweet contenant des pièces jointes multimédias.
- **WHEN** Le système ingère le tweet.
- **THEN** le système SHALL extraire les médias via `expansions=attachments.media_keys`.
- **AND** le système SHALL télécharger localement les images (pour OCR éventuel via Docling) si configuré.
- **AND** le système SHALL extraire les URL, hashtags et mentions depuis `entities`.
- **AND** le système SHALL écrire l'ensemble dans `mfg_project_sources` et indexer dans Zilliz.

---

### Requirement : Dé-duplication & Cache

#### Scénario : Évitement des ré-ingestions
- **GIVEN** Un tweet déjà indexé dans `mfg_shared_content_cache`.
- **WHEN** Une nouvelle ingestion du même tweet est demandée.
- **THEN** le système SHALL comparer le `tweet_id` avec le cache.
- **AND** le système SHALL ignorer le tweet si déjà présent, sauf si son contenu a été modifié (détection via `edit_history_tweet_ids`).

---

### Requirement : Respect des Limites de l'API

#### Scénario : Gestion du Rate Limiting
- **GIVEN** Plusieurs requêtes vers l'API Twitter v2.
- **WHEN** Le système approche de la limite de taux.
- **THEN** le système SHALL respecter les en-têtes `x-rate-limit-remaining` et `x-rate-limit-reset`.
- **AND** le système SHALL appliquer un backoff jusqu'au timestamp `reset`.
- **AND** le système SHALL ouvrir le Circuit Breaker en cas de `429` répétés.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Stocker le Bearer Token en clair. Il DOIT résider dans le gestionnaire de secrets (Northflank).
* 🚫 **FORBIDDEN** : Dépasser la profondeur de reconstruction configurée (protection anti-boucle sur conversations massives).
* 🚫 **SHALL NOT** : Utiliser des bibliothèques de scraping non officielles contournant les termes d'usage de l'API.
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens définis dans `design.md`.
* ⚠️ **MUST** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (URL → Tweet)** : Une URL de tweet valide renvoie un Markdown avec auteur, date et contenu textuel.
* **Test Case 2 (Thread)** : Un tweet racine avec réponses produit un thread Markdown hiérarchique complet (profondeur configurée).
* **Test Case 3 (Médias)** : Un tweet avec image génère une référence média téléchargée et un lien.
* **Test Case 4 (Dé-duplication)** : Un tweet déjà en cache est sauté sans nouvel appel API.
* **Test Case 5 (Introuvable)** : Un ID inexistant renvoie `TWEET_NOT_FOUND` sans exception non gérée.

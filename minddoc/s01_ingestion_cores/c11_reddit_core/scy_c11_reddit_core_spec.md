<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 👤 SCY-REDDIT-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_REDDIT_SPEC  
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
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion Reddit (`c11_reddit_core`)** de SCY Forge. Le système doit être capable, à partir d'une URL de post Reddit, d'un identifiant de post ou d'un subreddit, d'extraire les métadonnées du post (titre, auteur, corps, score) et de **reconstruire l'arbre complet des commentaires** (hiérarchie imbriquée) via la **crate Roux**. Le résultat est structuré en Markdown hiérarchique et indexé.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **API Reddit** via **crate Roux** (authentification OAuth, app credentials stockés dans secrets) :
  - `Subreddit.comments(article)` — arbre des commentaires d'un post.
  - `Subreddit.article(article)` — métadonnées du post.
  - Support de la pagination pour les threads massifs.
* **Authentification** : OAuth Reddit (client_id / client_secret / User-Agent descriptif, obligatoire selon la politique Reddit).
* **Parsing** : `serde_json` pour les structures JSON de l'API Reddit (Listing / Thing).
* **Nettoyage** : `dom_smoothie` (conversion du corps Markdown/HTML Reddit → Markdown propre).

> **Rappel anti-hallucination** : tout composant listé ci-dessus est une dépendance réelle et vérifiable. La crate Roux est un client Rust réel pour l'API Reddit. L'API Reddit nécessite des identifiants OAuth (stockés dans le gestionnaire de secrets). Aucune API tierce payante n'est autorisée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Résolution d'un Post Reddit

#### Scénario : Extraction d'un post et de ses métadonnées
- **GIVEN** Une URL de post Reddit valide (ex : `https://www.reddit.com/r/{sub}/comments/{id}/{slug}`).
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` lance l'ingestion.
- **THEN** le système SHALL parser l'URL pour extraire le subreddit et l'identifiant du post.
- **AND** le système SHALL récupérer les métadonnées du post via Roux (`Subreddit.article`) : titre, auteur, corps, score, nombre de commentaires, création.
- **AND** le système SHALL rejeter les posts supprimés/inexistants avec le code `REDDIT_POST_NOT_FOUND`.

---

### Requirement : Reconstruction de l'Arbre de Commentaires

#### Scénario : Extraction hiérarchique des commentaires
- **GIVEN** Un post Reddit valide.
- **WHEN** Le système reconstruit les commentaires.
- **THEN** le système SHALL récupérer l'arbre des commentaires via `Subreddit.comments(article)`.
- **AND** le système SHALL paginer pour les threads massifs (limitation du nombre de commentaires récupérés par requête).
- **AND** le système SHALL préserver la hiérarchie parent-enfant (réponses imbriquées).
- **AND** le système SHALL inclure l'auteur, le score et le corps de chaque commentaire.
- **AND** le système SHALL structurer l'ensemble en Markdown imbriqué (indentation par niveau de profondeur), avec profondeur max configurable.

---

### Requirement : Filtrage & Qualité

#### Scénario : Filtrage du bruit
- **GIVEN** Un post avec des commentaires de qualité variable.
- **WHEN** Le système structure les commentaires.
- **THEN** le système SHALL offrir un filtrage optionnel par score minimum (élimination des commentaires à faible valeur).
- **AND** le système SHALL marquer les commentaires supprimés (`[deleted]`/`[removed]`) sans les omettre silencieusement.
- **AND** le système SHALL calculer un score d'intégrité DRACO basé sur la complétude de l'arbre récupéré.

---

### Requirement : Dé-duplication & Cache

#### Scénario : Évitement des ré-ingestions
- **GIVEN** Un post déjà indexé dans `mfg_shared_content_cache`.
- **WHEN** Une nouvelle ingestion du même post est demandée.
- **THEN** le système SHALL comparer le `post_id` avec le cache.
- **AND** le système SHALL ignorer le post si déjà présent, sauf si le nombre de commentaires a significativement changé (ré-ingestion optionnelle).

---

### Requirement : Respect des Limites de l'API Reddit

#### Scénario : Conformité OAuth et rate limiting
- **GIVEN** Plusieurs requêtes vers l'API Reddit.
- **WHEN** Le système émet des appels consécutifs.
- **THEN** le système SHALL respecter la limite OAuth (60 requêtes/min).
- **AND** le système SHALL inclure un `User-Agent` descriptif obligatoire.
- **AND** le système SHALL appliquer un backoff sur `429` et ouvrir le Circuit Breaker en cas d'échecs répétés.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Stocker les identifiants OAuth Reddit en clair (gestionnaire de secrets obligatoire).
* 🚫 **FORBIDDEN** : Dépasser 60 requêtes/min (limite OAuth Reddit).
* 🚫 **SHALL NOT** : Reconstruire récursivement des arbres de profondeur non bornée (profondeur max configurable).
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens définis dans `design.md`.
* ⚠️ **MUST** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (Post + Arbre)** : Une URL de post valide produit un Markdown hiérarchique (post + arbre de commentaires imbriqué), score DRACO ≥ 80/100.
* **Test Case 2 (Hiérarchie)** : L'arbre préserve correctement la structure parent-enfant sur plusieurs niveaux de profondeur.
* **Test Case 3 (Filtrage)** : Le filtrage par score minimum élimine les commentaires sous le seuil tout en marquant les supprimés.
* **Test Case 4 (Dé-duplication)** : Un post déjà en cache est sauté sans appel API.
* **Test Case 5 (Introuvable)** : Un post supprimé renvoie `REDDIT_POST_NOT_FOUND` sans exception non gérée.

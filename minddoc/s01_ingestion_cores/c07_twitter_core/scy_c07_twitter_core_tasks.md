<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-TWITTER-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_TWITTER_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

Chaque tâche est conçue pour être codée en 15 à 30 minutes de manière unitaire et testable par nos agents de développement.

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

## 🧭 Liste des Tâches de Production

### 🚀 Tâche 7.1 : Coder le Client API v2 avec Bearer + Rate Limiting (Durée : 25 min)
* **Description** : Implémenter le client `reqwest` qui injecte le Bearer Token (depuis secrets), respecte les en-têtes `x-rate-limit-remaining`/`x-rate-limit-reset` et ouvre un Circuit Breaker sur `429` répétés.
* **Fichier de destination** : `backend_rs/src/cores/twitter/api_client.rs`
* **Critère de Succès** : Un appel valide renvoie un JSON de tweet ; un `429` déclenche un backoff jusqu'au `reset`.

### 🚀 Tâche 7.2 : Coder le Résolveur d'Identifiant (Durée : 20 min)
* **Description** : Coder la fonction qui parse une URL de tweet pour extraire le `tweet_id`, résout un `@username` en `user_id` via `/2/users/by/username`, et rejette les introuvables (`TWEET_NOT_FOUND`, `USER_NOT_FOUND`).
* **Fichier de destination** : `backend_rs/src/cores/twitter/identity.rs`
* **Critère de Succès** : `https://x.com/u/status/123` → `tweet_id=123` ; un username inexistant renvoie `Err(UserNotFound)`.

### 🚀 Tâche 7.3 : Coder la Reconstruction Récursive de Thread (Durée : 30 min)
* **Description** : Implémenter la recherche `search/recent` avec filtre `conversation_id:{cid}`, la pagination via `next_token`, la reconstruction hiérarchique via `referenced_tweets` (type `replied_to`) et le tri chronologique par `created_at`, avec profondeur max configurable.
* **Fichier de destination** : `backend_rs/src/cores/twitter/thread_reconstructor.rs`
* **Critère de Succès** : Un tweet racine avec 5 réponses produit un thread Markdown hiérarchique ordonné contenant les 5 réponses.

### 🚀 Tâche 7.4 : Coder l'Extraction des Médias & Entités (Durée : 25 min)
* **Description** : Implémenter l'extraction des médias via `expansions=attachments.media_keys` (téléchargement local optionnel pour OCR Docling) et des entités (URLs, hashtags, mentions) depuis le champ `entities`.
* **Fichier de destination** : `backend_rs/src/cores/twitter/media.rs`
* **Critère de Succès** : Un tweet avec image génère une référence média téléchargée et un tableau d'entités (urls, hashtags, mentions) complet.

### 🚀 Tâche 7.5 : Coder la Dé-duplication + Enqueue SAGA (Durée : 20 min)
* **Description** : Implémenter la comparaison `tweet_id` avec `mfg_shared_content_cache` (incluant vérification `edit_history_tweet_ids` pour détecter les tweets modifiés) et l'enqueue des tâches asynchrones dans `mfg_sync_queue`.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/twitterCore.ts`
* **Critère de Succès** : Un tweet déjà en cache est sauté ; un tweet modifié (nouvelle entrée dans `edit_history`) déclenche une ré-ingestion.

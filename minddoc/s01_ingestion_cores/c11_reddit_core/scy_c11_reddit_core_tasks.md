<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-REDDIT-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_REDDIT_TASKS  
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

### 🚀 Tâche 11.1 : Coder le Client Roux (OAuth + Rate Limiting) (Durée : 25 min)
* **Description** : Implémenter le client Roux avec authentification OAuth (identifiants depuis secrets), en-tête `User-Agent` descriptif, rate limiting préventif (≤ 60 req/min via `governor`) et Circuit Breaker sur `429` répétés.
* **Fichier de destination** : `backend_rs/src/cores/reddit/roux_client.rs`
* **Critère de Succès** : Un appel valide récupère les métadonnées d'un post ; un `429` déclenche un backoff.

### 🚀 Tâche 11.2 : Coder le Parseur d'URL Reddit (Durée : 15 min)
* **Description** : Coder la fonction qui parse une URL Reddit (`/r/{sub}/comments/{id}/{slug}`) pour extraire le subreddit et le `post_id`, et rejette les URL malformées.
* **Fichier de destination** : `backend_rs/src/cores/reddit/identity.rs`
* **Critère de Succès** : Une URL standard renvoie `(subreddit, post_id)` ; une URL invalide renvoie une erreur typée.

### 🚀 Tâche 11.3 : Coder la Reconstruction de l'Arbre de Commentaires (Durée : 30 min)
* **Description** : Implémenter la récupération paginée des commentaires via `Subreddit.comments(id)`, la reconstruction hiérarchique parent-enfant, l'inclusion auteur/score/corps, et la limitation de profondeur configurable.
* **Fichier de destination** : `backend_rs/src/cores/reddit/comment_tree.rs`
* **Critère de Succès** : Un post avec 20 commentaires répartis sur 3 niveaux produit un Markdown imbriqué respectant la hiérarchie.

### 🚀 Tâche 11.4 : Coder le Filtrage & Marquage (Durée : 20 min)
* **Description** : Implémenter le filtrage optionnel par score minimum, le marquage des commentaires supprimés (`[deleted]`/`[removed]`), et le calcul du score DRACO basé sur la complétude de l'arbre.
* **Fichier de destination** : `backend_rs/src/cores/reddit/comment_tree.rs`
* **Critère de Succès** : Les commentaires sous le seuil sont filtrés ; les supprimés sont marqués explicitement ; le score DRACO reflète la complétude.

### 🚀 Tâche 11.5 : Coder la Dé-duplication + Enqueue SAGA (Durée : 20 min)
* **Description** : Implémenter la comparaison `post_id` avec `mfg_shared_content_cache` (avec détection optionnelle de changement du nombre de commentaires) et l'enqueue des tâches asynchrones dans `mfg_sync_queue`.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/redditCore.ts`
* **Critère de Succès** : Un post déjà en cache est sauté sans appel API ; un post avec de nouveaux commentaires peut déclencher une ré-ingestion.

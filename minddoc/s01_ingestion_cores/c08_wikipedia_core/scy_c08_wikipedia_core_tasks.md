<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-WIKIPEDIA-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_WIKIPEDIA_TASKS  
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

### 🚀 Tâche 8.1 : Coder le Client MediaWiki avec User-Agent + Rate Limiting (Durée : 25 min)
* **Description** : Implémenter le client `reqwest` ciblant `{lang}.wikipedia.org/w/api.php`, injectant un `User-Agent` descriptif obligatoire et appliquant un rate limiting respectueux (≤ 200 req/s) avec backoff sur `429`/`503`.
* **Fichier de destination** : `backend_rs/src/cores/wiki/api_client.rs`
* **Critère de Succès** : Un appel `action=query&prop=extracts` renvoie un JSON valide avec en-tête `User-Agent` présent.

### 🚀 Tâche 8.2 : Coder le Résolveur d'Article (Durée : 20 min)
* **Description** : Implémenter la résolution d'un titre/URL/mot-clé vers une page canonique, avec gestion des redirections (`redirects=1`), recherche `generator=search`, et rejet `ARTICLE_NOT_FOUND`.
* **Fichier de destination** : `backend_rs/src/cores/wiki/resolver.rs`
* **Critère de Succès** : Un titre redirigé pointe vers l'article final ; un titre inexistant renvoie `Err(ArticleNotFound)`.

### 🚀 Tâche 8.3 : Coder l'Extraction de Contenu → Markdown (Durée : 30 min)
* **Description** : Implémenter l'extraction du résumé (`prop=extracts`), de la structure (`prop=sections`) et du HTML complet (API REST), puis la conversion en Markdown sémantique via `dom_smoothie`, incluant l'infobox en tableau.
* **Fichier de destination** : `backend_rs/src/cores/wiki/content_extractor.rs`
* **Critère de Succès** : Un article structuré renvoie un Markdown avec hiérarchie de sections, résumé et infobox, score DRACO ≥ 85/100.

### 🚀 Tâche 8.4 : Coder l'Extraction du Graphe de Wikiliens (Durée : 25 min)
* **Description** : Implémenter la récupération paginée des liens internes (`prop=links` + `plcontinue`), le filtrage des namespaces non pertinents, et la création des arêtes COSMOS avec poids basé sur la fréquence/contexte.
* **Fichier de destination** : `backend_rs/src/cores/wiki/wikilink_graph.rs`
* **Critère de Succès** : Un article avec 50 liens internes crée des arêtes COSMOS vers les concepts pertinents, en excluant les namespaces filtrés.

### 🚀 Tâche 8.5 : Coder la Dé-duplication + Support Multilingue (Durée : 20 min)
* **Description** : Implémenter la comparaison `page_id` + `last_rev_id` avec `mfg_shared_content_cache`, la détection de nouvelle révision, et le ciblage du sous-domaine linguistique (`{lang}.wikipedia.org`).
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/wikipediaCore.ts`
* **Critère de Succès** : Un article déjà à jour est sauté ; un article modifié (nouvelle révision) est ré-ingéré ; la langue est préservée dans les métadonnées.

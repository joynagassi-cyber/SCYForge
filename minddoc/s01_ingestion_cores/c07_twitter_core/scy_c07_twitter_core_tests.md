<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-TWITTER-CORE — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S01_INGESTION_TWITTER_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

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

## 1. Scénarios de Validation Unitaires

### 🧪 Test 7.1 : Résolution d'URL de Tweet
* **Pré-conditions** : Bearer Token configuré et client API opérationnel.
* **Input** : `https://x.com/{user}/status/{valid_id}`.
* **Règle d'Exécution** : Appeler `ingestTweet(url)`.
* **Post-conditions (Attendu)** :
  - Le `tweet_id` est extrait correctement.
  - Le Markdown produit contient l'auteur, la date et le contenu textuel.
  - Le score DRACO est ≥ 85/100.

### 🧪 Test 7.2 : Reconstruction de Thread Complet
* **Pré-conditions** : Un tweet racine avec au moins 5 réponses publiques.
* **Input** : URL du tweet racine.
* **Règle d'Exécution** : Appeler `reconstructThread(tweet_id)`.
* **Post-conditions (Attendu)** :
  - Le thread Markdown est hiérarchique et ordonné chronologiquement.
  - Toutes les réponses accessibles (dans la limite de profondeur) sont incluses.
  - La hiérarchie parent-enfant (`replied_to`) est respectée.

### 🧪 Test 7.3 : Extraction des Médias
* **Pré-conditions** : Un tweet contenant une image jointe.
* **Input** : `tweet_id` du tweet avec média.
* **Règle d'Exécution** : Appeler `extractMedia(tweet_id)`.
* **Post-conditions (Attendu)** :
  - Le média est référencé et téléchargé localement (si configuré).
  - Les entités (URLs, hashtags, mentions) sont extraites dans un tableau.

### 🧪 Test 7.4 : Dé-duplication par Cache
* **Pré-conditions** : Un tweet (`tweet_id: 12345`) déjà indexé dans `mfg_shared_content_cache` sans modification d'édition.
* **Input** : Nouvelle demande d'ingestion du tweet `12345`.
* **Règle d'Exécution** : Appeler `ingestTweet(...)`.
* **Post-conditions (Attendu)** :
  - Le tweet est sauté sans appel API.
  - Zéro coût en tokens et en requêtes.

### 🧪 Test 7.5 : Rejet d'un Tweet Introuvable
* **Pré-conditions** : Client API opérationnel.
* **Input** : Un `tweet_id` inexistant ou supprimé.
* **Règle d'Exécution** : Appeler `ingestTweet(...)`.
* **Post-conditions (Attendu)** :
  - Le système renvoie le code `TWEET_NOT_FOUND`.
  - Aucune exception non gérée n'est levée.

### 🧪 Test 7.6 : Respect du Rate Limiting
* **Pré-conditions** : Client API avec quota proche de la limite.
* **Input** : Une série de requêtes dépassant `x-rate-limit-remaining`.
* **Règle d'Exécution** : Appeler `batchIngest(...)`.
* **Post-conditions (Attendu)** :
  - Le système met en pause jusqu'au timestamp `x-rate-limit-reset`.
  - Aucune erreur `429` non gérée.

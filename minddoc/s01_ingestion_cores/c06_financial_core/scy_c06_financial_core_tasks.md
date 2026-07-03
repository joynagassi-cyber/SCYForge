<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-FINANCIAL-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_FINANCIAL_TASKS  
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

### 🚀 Tâche 6.1 : Coder le Résolveur Ticker → CIK (Durée : 20 min)
* **Description** : Implémenter la fonction qui charge le fichier officiel `company_tickers.json` de la SEC et résout un ticker (ex : `AAPL`) en CIK (ex : `0000320193`), avec rejet `UNKNOWN_TICKER` si absent.
* **Fichier de destination** : `backend_rs/src/cores/financial/ticker_resolver.rs`
* **Critère de Succès** : `AAPL` → `320193` ; un ticker invalide renvoie `Err(UnknownTicker)` sans panic.

### 🚀 Tâche 6.2 : Coder le Client HTTP SEC avec Rate Limiting (Durée : 30 min)
* **Description** : Implémenter le client `reqwest` avec token bucket (`governor`, max 10 req/s), en-tête `User-Agent` obligatoire, retry avec backoff exponentiel et Circuit Breaker sur `429`.
* **Fichier de destination** : `backend_rs/src/cores/financial/sec_client.rs`
* **Critère de Succès** : 15 requêtes consécutives ne dépassent jamais 10/seconde ; toutes incluent le `User-Agent` ; un `429` simulé déclenche un backoff.

### 🚀 Tâche 6.3 : Récupérer & Convertir les Filings (Durée : 25 min)
* **Description** : Coder la récupération de la liste des filings via `submissions/CIK{cik}.json`, le téléchargement des filings récents et leur conversion en Markdown (`dom_smoothie` pour HTML, `quick-xml` pour XML).
* **Fichier de destination** : `backend_rs/src/cores/financial/filings.rs`
* **Critère de Succès** : Pour un CIK valide, au moins un filing 10-K est téléchargé et converti en Markdown avec un score DRACO ≥ 85/100.

### 🚀 Tâche 6.4 : Parser les Faits Financiers XBRL → Tableaux Markdown (Durée : 30 min)
* **Description** : Coder le parsing de `companyfacts/CIK{cik}.json` pour extraire les concepts standards (revenus, résultat net, actifs totaux) et produire des tableaux Markdown comparatifs par exercice.
* **Fichier de destination** : `backend_rs/src/cores/financial/xbrl_facts.rs`
* **Critère de Succès** : Le tableau Markdown produit contient le chiffre d'affaires pour les 3 derniers exercices avec les bonnes unités.

### 🚀 Tâche 6.5 : Transcrire les Earnings Calls (Durée : 25 min)
* **Description** : Réutiliser le pipeline Whisper-tiny + pyannote du core `c03_podcast_core` pour transcrire et diariser un webcast audio d'earnings call (distinction présentation vs Q&A).
* **Fichier de destination** : `backend_rs/src/cores/financial/earnings.rs`
* **Critère de Succès** : Une URL audio d'earnings call renvoie un Markdown temporel diarisé avec identification d'au moins 2 locuteurs.

### 🚀 Tâche 6.6 : Coder la Dé-duplication + Enqueue SAGA (Durée : 20 min)
* **Description** : Implémenter la comparaison `accessionNumber` + `filingDate` avec `mfg_shared_content_cache` et l'enqueue de tâches asynchrones dans `mfg_sync_queue` pour les filings nouveaux ou modifiés.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/financialCore.ts`
* **Critère de Succès** : Un CIK dont 3 filings sont déjà en cache et non modifiés génère des tâches uniquement pour les nouveaux filings.

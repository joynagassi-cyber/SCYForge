<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-FINANCIAL-CORE — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S01_INGESTION_FINANCIAL_TESTS  
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

### 🧪 Test 6.1 : Résolution Ticker → CIK
* **Pré-conditions** : Le fichier `company_tickers.json` de la SEC est accessible.
* **Input** : Ticker `AAPL`.
* **Règle d'Exécution** : Appeler `resolveTickerToCik("AAPL")`.
* **Post-conditions (Attendu)** :
  - Le CIK retourné est `320193` (ou `0000320193` au format padded).
  - L'existence du CIK est validée via l'API `submissions`.

### 🧪 Test 6.2 : Rejet d'un Ticker Inconnu
* **Pré-conditions** : Le worker est opérationnel.
* **Input** : Ticker `ZZZNOTREAL`.
* **Règle d'Exécution** : Appeler `resolveTickerToCik("ZZZNOTREAL")`.
* **Post-conditions (Attendu)** :
  - Le système renvoie le code `UNKNOWN_TICKER`.
  - Aucune requête SEC EDGAR n'est émise au-delà de la résolution.

### 🧪 Test 6.3 : Récupération & Conversion d'un Filing 10-K
* **Pré-conditions** : Client SEC opérationnel avec rate limiting actif.
* **Input** : CIK d'Apple (`0000320193`).
* **Règle d'Exécution** : Appeler `ingestFilings(cik)`.
* **Post-conditions (Attendu)** :
  - Au moins un filing 10-K est téléchargé.
  - Le Markdown produit est structuré (titres, sections financières).
  - Le score DRACO est ≥ 85/100.
  - Les embeddings sont indexés dans Zilliz.

### 🧪 Test 6.4 : Extraction des Faits Financiers (XBRL)
* **Pré-conditions** : API `companyfacts` accessible.
* **Input** : CIK d'une entreprise avec données XBRL disponibles.
* **Règle d'Exécution** : Appeler `extractFinancialFacts(cik)`.
* **Post-conditions (Attendu)** :
  - Le tableau Markdown compare le chiffre d'affaires sur au moins 3 exercices.
  - Les unités monétaires sont correctes (ex : USD/shares).
  - Aucune valeur nulle inattendue n'apparaît sans annotation.

### 🧪 Test 6.5 : Respect du Rate Limiting SEC
* **Pré-conditions** : Client SEC configuré.
* **Input** : 15 requêtes consécutives vers `data.sec.gov`.
* **Règle d'Exécution** : Appeler `batchSecRequests()`.
* **Post-conditions (Attendu)** :
  - Aucune fenêtre d'1 seconde ne contient plus de 10 requêtes.
  - Chaque requête inclut l'en-tête `User-Agent`.
  - Aucune erreur `429` n'est reçue (throttling préventif).

### 🧪 Test 6.6 : Dé-duplication des Filings
* **Pré-conditions** : Un filing (`accessionNumber: 0000320193-26-...`, `filingDate: 2026-...`) déjà indexé dans `mfg_shared_content_cache`.
* **Input** : CIK dont ce filing fait partie des submissions.
* **Règle d'Exécution** : Appeler `ingestFilings(cik)`.
* **Post-conditions (Attendu)** :
  - Le filing déjà en cache est sauté (zéro téléchargement, zéro conversion).
  - Seuls les nouveaux filings génèrent des tâches d'ingestion.

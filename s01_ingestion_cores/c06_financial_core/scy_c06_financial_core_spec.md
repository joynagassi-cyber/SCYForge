# 📈 SCY-FINANCIAL-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_FINANCIAL_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion Financier (`c06_financial_core`)** de SCY Forge. Le système doit être capable d'extraire, de structurer et d'indexer des données financières publiques à partir des APIs **SEC EDGAR** : filings réglementaires (10-K, 10-Q, 8-K, S-1), faits financiers structurés (XBRL → JSON via l'API `data.sec.gov`), et transcriptions d'appels de résultats (*earnings calls*) via transcription locale. L'ingestion s'effectue à **coût d'infrastructure nul (0 $)** — SEC EDGAR étant une API publique gratuite.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **API SEC EDGAR** (publique, gratuite, aucun clé requise) :
  - `data.sec.gov/api/xbrl/companyfacts/CIK{cik}.json` — faits financiers structurés (chiffres clés sur plusieurs années).
  - `data.sec.gov/submissions/CIK{cik}.json` — liste des filings récents d'une entreprise.
  - `efts.sec.gov/LATEST/search-index?q=...` — recherche plein texte des filings.
* **Parsing XBRL/Financier** : `quick-xml` (crate Rust) pour les filings structurés, parsing du JSON `companyfacts` via `serde_json`.
* **Téléchargement documents** : `reqwest` pour récupérer les filings (HTML, XML, PDF).
* **Nettoyage HTML** : `dom_smoothie` (core `c02_web_article_core`) pour les filings HTML → Markdown.
* **Earnings calls audio** : `ffmpeg` + sidecar **Whisper-tiny** (ONNX INT8 / Candle) pour la transcription des webcasts audio (réutilisation du pipeline `c03_podcast_core`).
* **Résolution ticker → CIK** : table de mapping locale (SEC fournit `ticker.txt` officiel).

> **Rappel anti-hallucination** : tout composant listé ci-dessus est une dépendance réelle et vérifiable. SEC EDGAR ne requiert aucune clé API payante (uniquement un en-tête `User-Agent` descriptif, obligatoire selon la politique SEC). Aucune API financière payante (Bloomberg, Alpha Vantage premium) n'est autorisée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Résolution Ticker/Entreprise → CIK SEC

#### Scénario : Résolution à partir d'un ticker boursier
- **GIVEN** Un ticker boursier fourni par l'utilisateur (ex : `AAPL`, `MSFT`).
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` lance l'ingestion.
- **THEN** le système SHALL résoudre le ticker en identifiant CIK SEC via la table de mapping locale `ticker.txt` officielle.
- **AND** le système SHALL valider l'existence du CIK via l'API `submissions/CIK{cik}.json`.
- **AND** le système SHALL rejeter les tickers inconnus avec le code `UNKNOWN_TICKER`.

---

### Requirement : Ingestion des Filings Réglementaires

#### Scénario : Récupération et conversion des derniers filings
- **GIVEN** Un CIK SEC valide.
- **WHEN** L'utilisateur demande l'ingestion des filings.
- **THEN** le système SHALL appeler `submissions/CIK{cik}.json` pour lister les filings récents (10-K, 10-Q, 8-K).
- **AND** le système SHALL comparer chaque `accessionNumber` + `filingDate` avec la table `mfg_shared_content_cache` pour identifier les filings déjà indexés.
- **AND** le système SHALL télécharger les nouveaux filings (HTML/XML) et les convertir en Markdown via `dom_smoothie` ou `quick-xml`.
- **AND** le système SHALL écrire le Markdown et les métadonnées (type de filing, période, date) dans `mfg_project_sources` et indexer les embeddings dans Zilliz.

---

### Requirement : Ingestion des Faits Financiers Structurés (XBRL)

#### Scénario : Extraction des chiffres clés sur plusieurs années
- **GIVEN** Un CIK SEC valide.
- **WHEN** L'utilisateur demande les données financières structurées.
- **THEN** le système SHALL appeler `companyfacts/CIK{cik}.json`.
- **AND** le système SHALL extraire les concepts financiers standards (chiffre d'affaires, résultat net, actifs totaux, flux de trésorerie) pour chaque période fiscale disponible.
- **AND** le système SHALL structurer ces données en tableaux Markdown comparatifs (par exercice).
- **AND** le système SHALL écrire ces tableaux dans `mfg_project_sources`.

---

### Requirement : Transcription des Earnings Calls (Webcast Audio)

#### Scénario : Transcription d'un appel de résultats
- **GIVEN** Une URL de webcast audio d'un earnings call fournie par l'utilisateur.
- **WHEN** Le système télécharge l'audio.
- **THEN** le système SHALL convertir l'audio en WAV 16 kHz mono via `ffmpeg`.
- **AND** le système SHALL transmettre l'audio au sidecar **Whisper-tiny** local pour transcription.
- **AND** le système SHALL appliquer la diarization (pyannote) pour distinguer la direction des questions-réponses (Q&A).
- **AND** le système SHALL structurer la transcription en Markdown temporel `[hh:mm:ss] [Speaker N] Texte`.

---

### Requirement : Respect des Limites de Taux SEC (Rate Limiting)

#### Scénario : Conformité aux limites SEC
- **GIVEN** Plusieurs requêtes vers les APIs `data.sec.gov`.
- **WHEN** Le système émet des appels consécutifs.
- **THEN** le système SHALL respecter la limite de taux SEC (max 10 requêtes/seconde).
- **AND** le système SHALL inclure un en-tête `User-Agent` descriptif obligatoire (format `Nom Entreprise email@domaine`).
- **AND** le système SHALL appliquer un Circuit Breaker en cas de réception répétée de `429 Too Many Requests`.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Dépasser la limite de 10 requêtes/seconde vers SEC EDGAR (politique officielle SEC).
* 🚫 **FORBIDDEN** : Émettre des requêtes sans en-tête `User-Agent` (rejet automatique par SEC).
* 🚫 **SHALL NOT** : Appeler des APIs financières payantes (Bloomberg, Refinitiv, Alpha Vantage premium). Seul SEC EDGAR gratuit est autorisé.
* 🚫 **SHALL NOT** : Appeler des APIs de transcription cloud payantes pour les earnings calls. Le sidecar Whisper-tiny local est obligatoire.
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens définis dans `design.md`.
* ⚠️ **MUST** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (Résolution Ticker)** : Le ticker `AAPL` se résout en CIK `0000320193` et valide l'existence via l'API submissions.
* **Test Case 2 (Filings)** : L'ingestion d'un CIK valide renvoie au moins un filing 10-K en Markdown structuré avec un score DRACO ≥ 85/100.
* **Test Case 3 (Faits XBRL)** : L'extraction `companyfacts` produit un tableau Markdown comparatif du chiffre d'affaires sur les 3 derniers exercices.
* **Test Case 4 (Rate Limiting)** : 15 requêtes consécutives ne dépassent jamais 10/seconde et incluent systématiquement le `User-Agent`.
* **Test Case 5 (Ticker Inconnu)** : Un ticker invalide renvoie le code `UNKNOWN_TICKER` sans exception non gérée.

<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-FINANCIAL-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_FINANCIAL_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

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

## 1. Architecture du Flux de Données

```
 [Ticker boursier (ex: AAPL) ou CIK SEC]
                  │
                  ▼
     [Résolution ticker.txt → CIK]
                  │
            ┌─────┴──────┐
            ▼            ▼
     [CIK valide]   [Ticker inconnu] ──► UNKNOWN_TICKER
            │
            ▼
   [Mastra TS Ingestion Worker]
            │
            ├──► [Vérification mfg_shared_content_cache (accessionNumber+filingDate)] ──► Hit ──► (Fin)
            │
            └──► [Miss : Appels SEC EDGAR (reqwest + User-Agent + rate limit ≤10/s)]
                        │
          ┌─────────────┼──────────────────────┐
          ▼             ▼                      ▼
   [submissions.json]  [companyfacts.json]   [Webcast audio earnings]
   (liste filings)     (faits XBRL)          (URL fournie)
          │             │                      │
          ▼             ▼                      ▼
   [Téléchargement     [Parsing serde_json]   [ffmpeg WAV 16 kHz mono]
    filings HTML/XML]  → tableaux MD]            │
          │             │                      ▼
          ▼             │              [Sidecar Whisper-tiny]
   [dom_smoothie       │              + pyannote diarization]
    ou quick-xml]      │                      │
          │             │                      ▼
          └─────────────┼───────────────[Markdown temporel
                        ▼                diarisé]
            [Score d'intégrité DRACO]
                        │
                        ▼
        [Écriture PostgreSQL mfg_project_sources]
        [Indexation vectorielle Zilliz]
        [Arête sémantique COSMOS-MINDGRAPH → status: completed]
```

**Gestion du Rate Limiting SEC** :

```
 [Client HTTP reqwest]
        │
        ├──► [Token bucket : max 10 tokens/seconde]
        ├──► [En-tête User-Agent obligatoire injecté]
        ├──► [Réception 429 → backoff exponentiel + Circuit Breaker]
        └──► [Retry avec Idempotency Key]
```

---

## 2. Dépendances Techniques Strictes
* **APIs SEC EDGAR** (publiques, gratuites) :
  - `data.sec.gov/submissions/CIK{padded_cik}.json` — liste des filings.
  - `data.sec.gov/api/xbrl/companyfacts/CIK{padded_cik}.json` — faits financiers structurés.
  - `efts.sec.gov/LATEST/search-index?q=...` — recherche plein texte.
  - Mapping ticker → CIK : fichier officiel `www.sec.gov/files/company_tickers.json`.
* **Runtimes Rust** :
  - `reqwest` (client HTTP avec rate limiting + User-Agent).
  - `quick-xml` (parsing filings XML/XBRL).
  - `serde_json` (parsing des réponses JSON SEC).
  - `governor` (crate de rate limiting, token bucket).
* **Conversion** :
  - `dom_smoothie` (HTML filings → Markdown).
  - `ffmpeg` + sidecar **Whisper-tiny** ONNX INT8 (Candle) + pyannote (earnings calls audio, réutilisation `c03_podcast_core`).
* **Stockage** :
  - PostgreSQL (Northflank) : `mfg_project_sources`, `mfg_shared_content_cache`, `mfg_sync_queue`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/financialCore.ts`** : Orchestration Mastra TS (résolution ticker, vérification cache, enqueue SAGA).
- **`backend_rs/src/cores/financial/sec_client.rs`** : Client HTTP SEC EDGAR avec rate limiting (`governor`), User-Agent, retry + Circuit Breaker.
- **`backend_rs/src/cores/financial/ticker_resolver.rs`** : Résolution ticker → CIK via `company_tickers.json`.
- **`backend_rs/src/cores/financial/filings.rs`** : Téléchargement + conversion des filings (HTML/XML → Markdown).
- **`backend_rs/src/cores/financial/xbrl_facts.rs`** : Parsing `companyfacts.json` → tableaux Markdown comparatifs.
- **`backend_rs/src/cores/financial/earnings.rs`** : Transcription earnings calls (réutilise le pipeline Whisper/pyannote de `c03_podcast_core`).
- **`mfg_project_sources`** : Stockage du Markdown (filings, tableaux financiers, transcriptions).
- **`mfg_shared_content_cache`** : Dé-duplication par `accessionNumber` + `filingDate` (hash).
- **`mfg_sync_queue`** : File d'attente asynchrone SAGA pour les transcriptions longues.

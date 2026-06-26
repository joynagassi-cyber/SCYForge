# 🔍 SCY-WEB-SEARCH-ENGINE — SPÉCIFICATION V2 (FUSION c02 + Perplexica + Scrapling + dom_smoothie)
**ID Spécification** : S01_INGESTION_WEB_SEARCH_V2_SPEC  
**Statut** : 🔵 PROPOSITION (EN ATTENTE DE VALIDATION UTILISATEUR)  
**Remplace** : `scy_web_article_core_spec.md` (fusion étendue)  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Le **Web Search Engine** est l'évolution du `c02_web_article_core` en un **moteur de recherche web intelligent unifié**. Il fusionne 4 technologies en un pipeline unique et robuste :
1. **SearxNG** (méta-recherche, agrège 244 moteurs, $0 API) — pour **trouver** les sources
2. **Perplexica/Vane** (classification + reranking + citations) — pour **trier et comprendre**
3. **Scrapling** (scraping furtif, anti-bot) — pour **récupérer** le contenu des pages
4. **dom_smoothie** (Readability) — pour **nettoyer** et convertir en Markdown

Ce moteur résout le problème du c02 original : il ne savait **que scraper une URL connue**. Maintenant, il sait **chercher, trouver, scraper et nettoyer** automatiquement, le tout à **$0 d'API de recherche**.

---

## 2. Architecture du Pipeline Unifié

```
[Requête de recherche (requête Agent-02 / mot-clé / question)]
       │
       ▼
┌──────────────────────────────────────────────────────────┐
│  COUCHE 1 — SEARXNG (Méta-Recherche $0)                 │
│  Agrège 244 moteurs : Google, Bing, DuckDuckGo,         │
│  Wolfram Alpha, YouTube, Reddit, Scholar...              │
│  Retourne : top-20 URLs + snippets + métadonnées         │
└──────────────────────────────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────────────────────────┐
│  COUCHE 2 — PERPLEXICA (Classification + Reranking)      │
│  • Classification : la question nécessite-t-elle web ?   │
│  • Query Rewriting : reformulation en mots-clés optimaux │
│  • Focus Modes : All / Academic / YouTube / Reddit       │
│  • Embeddings reranking : top-5 sources les + pertinentes│
│  • Widget detection : calcul, weather, stock ?           │
└──────────────────────────────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────────────────────────┐
│  COUCHE 3 — SCRAPLING (Scraping Furtif)                  │
│  Pour chaque URL top-5 :                                 │
│  • CloakBrowser (contournement Cloudflare/Captcha)       │
│  • Récupération HTML brut (< 3s par page)                │
│  • Anti-bot, anti-paywall                                │
└──────────────────────────────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────────────────────────┐
│  COUCHE 4 — DOM_SMOOTHIE (Nettoyage + Markdown)          │
│  • Purge scripts/ads/nav/cookies/popups                  │
│  • Extraction corps principal + OpenGraph + auteurs      │
│  • Conversion HTML → Markdown GFM CommonMark              │
│  • Score d'épuration sémantique (DRACO ≥ 85)             │
└──────────────────────────────────────────────────────────┘
       │
       ▼
[Sources ingérées propres → mfg_project_sources + Zilliz embeddings]
[Prêtes pour NEURON-CHAINS → cours, cartes APEX, exercices]
```

---

## 3. Les 2 Modes de Fonctionnement

### Mode A — Recherche par Question (Discovery Mode)
L'agent CONTENT-SCOUT pose une question ou un sujet → le moteur cherche, trouve, scrape et ingère les meilleures sources automatiquement.

**Exemple** : Agent-02 a besoin de sources sur « useEffect cleanup React ».
→ SearxNG cherche → Perplexica reranke → Scrapling scrape les top-5 → dom_smoothie nettoie → 5 articles propres ingérés.

### Mode B — Ingestion d'URL Directe (Legacy Mode, conservé)
L'utilisateur fournit une URL directe → Scrapling scrape → dom_smoothie nettoie → ingestion.
(C'est le comportement original du c02, conservé pour compatibilité.)

---

## 4. Tech Stack & Dependencies

| Composant | Stack | Rôle | Coût |
|-----------|-------|------|------|
| **SearxNG** | Docker sidecar (Python, MIT) | Méta-recherche 244 moteurs | **$0** |
| **Perplexica/Vane** | Docker sidecar (Next.js, MIT) | Classification + reranking + citations | **$0** (ou mini LLM local) |
| **Scrapling** | Docker sidecar (déjà dans stack) | Scraping furtif CloakBrowser | **$0** |
| **dom_smoothie** | Rust crate (déjà dans stack) | Readability + Markdown | **$0** |
| **Embeddings reranking** | `text-embedding-3-small` ou Nomic local | Similarité sémantique sources | **$0** (local) ou ~$0.00002/1K |
| **LLM (classification)** | DeepSeek V4 via LlmRouter | Classification question + query rewriting | ~$0.0001 |

> **Rappel anti-hallucination** : SearxNG et Perplexica sont des projets open-source réels et vérifiés (MIT, activement maintenus). Aucune API de recherche payante (Serper, Brave, Tavily) n'est utilisée. Le coût total de recherche = $0.

---

## 5. Requirements & Scenarios (RFC 2119)

### Requirement : Recherche Multi-Moteur ($0)

#### Scénario : Discovery par question
- **GIVEN** Une question/sujet de recherche (depuis Agent-02 CONTENT-SCOUT).
- **WHEN** Le moteur de recherche est invoqué en Mode A.
- **THEN** le système SHALL interroger SearxNG (méta-recherche, 244 moteurs).
- **AND** le système SHALL récupérer top-20 URLs + snippets + métadonnées.
- **AND** le système SHALL NE PAS utiliser d'API de recherche payante ($0).

### Requirement : Classification + Reranking Perplexica

#### Scénario : Tri intelligent des sources
- **GIVEN** Les top-20 URLs brutes de SearxNG.
- **WHEN** Perplexica traite les résultats.
- **THEN** le système SHALL classifier la question (nécessite web ? widget ? réponse directe ?).
- **AND** le système SHALL appliquer le Focus Mode approprié (All / Academic / YouTube / Reddit / Wolfram).
- **AND** le système SHALL reformuler la requête en mots-clés optimaux (query rewriting).
- **AND** le système SHALL reranker les sources par similarité sémantique (embeddings).
- **AND** le système SHALL retourner les **top-5 sources** les plus pertinentes.

### Requirement : Scraping Furtif (Scrapling)

#### Scénario : Récupération du contenu
- **GIVEN** Les top-5 URLs sélectionnées par Perplexica.
- **WHEN** Scrapling traite chaque URL.
- **THEN** le système SHALL utiliser CloakBrowser (contournement Cloudflare/Captcha).
- **AND** le système SHALL récupérer le HTML brut (< 3s par page).
- **AND** le système SHALL gérer l'échec (paywall, page indisponible) sans crasher.

### Requirement : Nettoyage + Markdown (dom_smoothie)

#### Scénario : Conversion propre
- **GIVEN** Le HTML brut de Scrapling.
- **WHEN** dom_smoothie nettoie.
- **THEN** le système SHALL purger scripts/ads/nav/cookies/popups.
- **AND** le système SHALL extraire corps principal + OpenGraph + auteurs.
- **AND** le système SHALL convertir en Markdown GFM (score DRACO ≥ 85).
- **AND** le système SHALL écrire dans `mfg_project_sources` + indexer dans Zilliz.

### Requirement : Focus Modes (Recherche Spécialisée)

#### Scénario : Recherche ciblée
- **GIVEN** Un domaine de recherche (React, Machine Learning, médecine...).
- **THEN** le système SHALL offrir les Focus Modes :
  - **All** : recherche web générale (défaut)
  - **Academic** : papers scientifiques (Scholar, arXiv, PubMed)
  - **YouTube** : vidéos éducatives
  - **Reddit** : discussions communautaires
  - **Wolfram Alpha** : calculs et données
- **AND** le Focus Mode SHALL être sélectionnable par Agent-02 selon le type de nœud DAG.

### Requirement : Citations Sourcées

#### Scénario : Traçabilité des sources
- **THEN** chaque source ingérée SHALL conserver son URL d'origine.
- **AND** le système SHALL attacher les citations au système `citation_sourcing` (exposants [1][2] cliquables).
- **AND** le système SHALL lier chaque source à `scy_concept_provenance` (deep links).

### Requirement : Cache & Dé-duplication

#### Scénario : Optimisation
- **GIVEN** Une recherche déjà effectuée pour un sujet similaire.
- **THEN** le système SHALL vérifier `mfg_shared_content_cache` (par hash de requête).
- **AND** en cas de hit → réutiliser les sources existantes ($0 scraping).

---

## 6. Integration avec les Agents ASCENT

| Agent | Usage du Web Search Engine |
|-------|---------------------------|
| **AGENT-02 (CONTENT-SCOUT)** | Recherche automatique de sources pour chaque nœud du DAG (Mode A, top-5 sources par nœud) |
| **AGENT-14 (DET-SUGGESTER)** | Peut suggérer des recherches complémentaires (Gap Detection → « cherche ce prérequis manquant ») |
| **AGENT-18 (CONSCIOUS AGENT)** | Recherche le contexte marché 2026 (« compétences recherchées en [domaine] ») |
| **BRAIN (Professor AI)** | Mode « Internet » : répond aux questions de l'utilisateur en cherchant le web en live (voir spec BRAIN sidecar) |

---

## 7. Déploiement Docker (Northflank)

```yaml
# docker-compose.yml (extrait — sidecars Northflank)
services:
  # Sidecar 1 : SearxNG (méta-recherche $0)
  searxng:
    image: searxng/searxng:latest
    ports:
      - "8080:8080"  # interne seulement
    volumes:
      - ./searxng/settings.yml:/etc/searxng/settings.yml
    # settings.yml : JSON format enabled, Wolfram Alpha enabled

  # Sidecar 2 : Perplexica/Vane (classification + reranking)
  perplexica:
    image: itzcrazykns1337/vane:slim-latest
    ports:
      - "3001:3000"  # interne seulement
    environment:
      - SEARXNG_API_URL=http://searxng:8080
      # LLM : DeepSeek V4 (via OPENAI_BASE_URL) ou Ollama local
    volumes:
      - perplexica-data:/home/vane/data

  # Sidecar 3 : Scrapling (déjà déployé)
  scrapling:
    image: scy-forge/scrapling:latest
    ports:
      - "3002:3000"
```

---

## 8. Boundaries & Constraints
* 🚫 **FORBIDDEN** : API de recherche payante (Serper, Brave, Tavily) — SearxNG uniquement ($0).
* 🚫 **FORBIDDEN** : Stocker du HTML non nettoyé (dom_smoothie obligatoire avant persistance).
* 🚫 **SHALL NOT** : Scraper plus de 5 URLs par recherche (limite performance).
* ⚠️ **MUST** : SearxNG settings → JSON format + Wolfram Alpha enabled.
* ⚠️ **MUST** : Rate limiting sur SearxNG (respect des moteurs upstream).
* ⚠️ **MUST** : Circuit Breaker si SearxNG ou Perplexica indisponibles (fallback : URL directe Mode B).

---

## 9. Test cases & Validation
* **TC1 (Discovery)** : Question « useEffect cleanup » → SearxNG top-20 → Perplexica top-5 → Scrapling scrape → dom_smoothie Markdown → 5 sources ingérées.
* **TC2 ($0)** : Aucune API payante utilisée (SearxNG + Perplexica + Scrapling + dom_smoothie).
* **TC3 (Focus)** : Focus Academic → papers scientifiques prioritaires.
* **TC4 (Anti-bot)** : URL Medium protégée → Scrapling CloakBrowser → HTML récupéré.
* **TC5 (Nettoyage)** : HTML brut → Markdown GFM propre (DRACO ≥ 85, épuration > 95%).
* **TC6 (Cache)** : Re-recherche même sujet → hit cache ($0).
* **TC7 (Citations)** : Sources ingérées → citations [1][2] cliquables + deep links.
* **TC8 (Fallback)** : SearxNG down → Mode B (URL directe) toujours fonctionnel.
* **TC9 (Circuit Breaker)** : Perplexica down → reranking basique (cosine simple) fallback.

# 🌐 SCY-BRAIN-LIVE-WEB-SEARCH (Perplexica Sidecar) — SPÉCIFICATION (SPEC)
**ID Spécification** : S06_BRAIN_LIVE_WEB_SEARCH_SPEC  
**Statut** : 🔵 PROPOSITION (EN ATTENTE DE VALIDATION UTILISATEUR)  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
L'intégration **Perplexica Sidecar dans BRAIN** donne à l'assistant conversationnel (Professor AI + Chat Agentique) la capacité de **rechercher le web en temps réel** pour répondre aux questions de l'utilisateur avec des informations à jour, sourcées et citées — au-delà de ce qui est dans la base de connaissances personnelle (RAG hybride).

**Quand BRAIN utilise la KB personnelle** : questions sur les concepts appris, les nœuds ASCENT, le contenu ingéré.
**Quand BRAIN utilise Perplexica (web live)** : questions sur l'actualité, les nouveautés tech, les tendances marché, les comparatifs externes, tout ce qui n'est pas encore dans la KB.

---

## 2. Architecture

```
[Question utilisateur à BRAIN]
       │
       ▼
[BRAIN Router : Quelle source utiliser ?]
       │
       ├── Question sur contenu appris / nœud ASCENT ?
       │   └──► TRIPLE RETRIEVAL (KB personnelle : Dense + BM25 + Graph + RRF)
       │
       ├── Question sur actualité / nouveauté / externe ?
       │   └──► PERPLEXICA SIDECAR (web live)
       │            │
       │            ├── SearxNG (244 moteurs, $0)
       │            ├── Query Rewriting + Focus Mode
       │            ├── Scrapling (top-5 pages)
       │            ├── dom_smoothie (nettoyage)
       │            ├── Embeddings reranking
       │            └── Réponse + citations sourcées
       │
       └── Question hybride (appris + actualité) ?
           └──► HYBRIDE : KB personnelle + Perplexica web → fusion RRF
```

---

## 3. Les 3 Modes de Source BRAIN

Alignés avec le PRD §7.7 (« Mode de connaissance configurable ») :

| Mode | Source | Usage | Coût |
|------|--------|-------|------|
| **Base cumulative (hors-ligne)** | Triple Retrieval (KB personnelle) | Questions sur les concepts appris | $0 |
| **Internet seul (temps réel)** | Perplexica Sidecar (web live) | Questions sur actualité / externe | ~$0.001/recherche |
| **Hybride (défaut)** | KB + Perplexica → fusion RRF | Questions mixtes (appris + contexte) | ~$0.0005 |

L'utilisateur choisit son mode dans les paramètres BRAIN (défaut : Hybride).

---

## 4. Le Routing Intelligent

Le **BRAIN Router** décide automatiquement quelle source utiliser :

```rust
pub enum BrainSource {
    PersonalKB,      // Triple Retrieval (Dense + BM25 + Graph)
    WebLive,         // Perplexica Sidecar
    Hybrid,          // Les deux + fusion RRF
}

pub fn route_query(query: &str, context: &UserContext) -> BrainSource {
    // Si la question porte sur un nœud ASCENT actif ou un concept appris
    if query_mentions_active_node(query, context) {
        return BrainSource::PersonalKB;
    }

    // Si la question contient des mots-clés d'actualité ("2026", "nouveau", "dernier", "actuel")
    if query_requests_current_info(query) {
        return BrainSource::WebLive;
    }

    // Si la question est mixte
    return BrainSource::Hybrid; // défaut
}
```

---

## 5. Le Flux Perplexica Sidecar (WebLive)

```
[Question utilisateur → BRAIN Router → WebLive]
       │
       ▼
[Requête HTTP → Perplexica Sidecar : POST /api/search]
       │
       ├── Body : { query, focusMode, optimizationMode }
       │
       ▼
[Perplexica interne :]
   1. Query Rewriting (LLM : reformule en mots-clés)
   2. SearxNG (244 moteurs → top-20 URLs)
   3. Scrapling (scrape top-5 pages)
   4. dom_smoothie (nettoyage Markdown)
   5. Embeddings reranking (top sources)
   6. LLM Answer Generation (réponse + citations)
       │
       ▼
[Réponse Perplexica → BRAIN :]
   ├── answer_text (réponse avec citations inline [1][2])
   ├── sources[] (URL + titre + snippet pour chaque source)
   └── images[] / videos[] (si pertinents)
       │
       ▼
[BRAIN post-traitement :]
   ├── Application Charte Humilité (ton humble)
   ├── Socratic Progressive Prompting (max 2 paragraphes + question)
   ├── Thread-of-Thought (lien avec nœud actuel si pertinent)
   ├── Citations [1][2] formatées (CitationMark cliquable)
   └── Suggestions 3 questions complémentaires (T16)
       │
       ▼
[SSE Streaming → UI utilisateur :]
   ├── Réponse humble + citations sourcées + sources cliquables
   └── Deep links vers les sources web originales
```

---

## 6. Requirements & Scenarios (RFC 2119)

### Requirement : Routing Intelligent
- **GIVEN** Une question utilisateur à BRAIN.
- **WHEN** Le BRAIN Router évalue la source.
- **THEN** le système SHALL router vers PersonalKB (concepts appris), WebLive (actualité), ou Hybrid (mixte).
- **AND** le système SHALL respecter le mode configuré par l'utilisateur (KB seule / Web seul / Hybride défaut).

### Requirement : Recherche Web Live (Perplexica)
- **GIVEN** Une question routée vers WebLive.
- **WHEN** BRAIN appelle le Perplexica Sidecar.
- **THEN** le système SHALL envoyer `POST /api/search` à Perplexica.
- **AND** le système SHALL recevoir une réponse + sources citées.
- **AND** le système SHALL appliquer Focus Mode (All/Academic/YouTube/Reddit selon contexte).

### Requirement : Citations Sourcées + Deep Links
- **THEN** chaque affirmation issue du web SHALL être citée ([1][2]).
- **AND** chaque citation SHALL être cliquable (deep link vers la source web).
- **AND** la liste des sources SHALL être affichée sous la réponse (bibliographie).

### Requirement : Charte Humilité + Socratic Prompting
- **THEN** la réponse SHALL passer le `humility_filter` (charte CHRONICLE).
- **AND** la réponse SHALL respecter Socratic Progressive Prompting (max 2 paragraphes + question, D-OPT-022).
- **AND** la réponse SHALL faire le lien avec le contexte d'apprentissage si pertinent (Thread-of-Thought).

### Requirement : Mode Hybride (KB + Web)
- **GIVEN** Une question hybride (concept appris + actualité).
- **WHEN** Le mode Hybride est activé.
- **THEN** le système SHALL interroger PersonalKB ET Perplexica en parallèle.
- **AND** le système SHALL fusionner les résultats via RRF (k=60).
- **AND** les sources personnelles (ingérées) ET web (live) SHALL être distinguées visuellement (badges 📚 personnelle / 🌐 web).

### Requirement : Performance & Fallback
- **THEN** la recherche web live SHALL retourner en < 8 secondes (SLA).
- **AND** si Perplexica indisponible → fallback vers KB personnelle seule + message « Recherche web temporairement indisponible ».
- **AND** le BudgetGuard SHALL limiter les recherches web (max 50/jour Free, illimité Premium).

### Requirement : Anti-Hallucination Web
- **THEN** le système SHALL NE JAMAIS présenter une réponse web sans source citée.
- **AND** le système SHALL appliquer la couche 2 anti-hallucination (T08 CitationTracker + T11 FactChecker) sur les réponses web.
- **AND** si la source web contredit la KB personnelle → le système SHALL le signaler (« Tes sources disent X, mais le web dit Y. On vérifie ? »).

---

## 7. Déploiement

Le Perplexica Sidecar tourne en Docker sur Northflank (même conteneur que le Web Search Engine c02 — shared instance) :

```yaml
# Le Perplexica Sidecar est partagé entre :
# - c02 Web Search Engine (ingestion Agent-02)
# - BRAIN (recherche live Professor AI)

perplexica:
  image: itzcrazykns1337/vane:slim-latest
  environment:
    - SEARXNG_API_URL=http://searxng:8080
    - OPENAI_BASE_URL=https://api.deepseek.com  # ou Ollama local
  volumes:
    - perplexica-data:/home/vane/data
```

**Un seul sidecar Perplexica** sert à la fois l'ingestion (c02) et BRAIN (live search). Économie de ressources.

---

## 8. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Réponse web sans citation source (anti-hallucination obligatoire).
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Dépasser 50 recherches web/jour (Free tier) — BudgetGuard.
* ⚠️ **MUST** : Humility filter + Socratic Prompting sur toutes les réponses web.
* ⚠️ **MUST** : Distinction visuelle sources 📚 (personnelle) vs 🌐 (web).

---

## 9. Test cases & Validation
* **TC1 (Routing)** : Question concept appris → PersonalKB. Question actualité → WebLive. Question mixte → Hybrid.
* **TC2 (WebLive)** : « Quelles sont les nouveautés React 19 ? » → Perplexica → réponse + 5 sources citées.
* **TC3 (Citations)** : Chaque affirmation web a un [1] cliquable → deep link source.
* **TC4 (Humilité)** : Réponse passe humility_filter (pas de jugement, pas de condescendance).
* **TC5 (Hybrid)** : Question mixte → KB + Web fusionnés RRF + badges 📚/🌐.
* **TC6 (Performance)** : Recherche web < 8 secondes.
* **TC7 (Fallback)** : Perplexica down → KB seule + message.
* **TC8 (Budget)** : 51ème recherche Free → bloquée par BudgetGuard.
* **TC9 (Anti-hallucination)** : Réponse web sans source → rejetée. Contradiction KB/Web → signalée.
* **TC10 (Suggestions)** : 3 questions complémentaires après la réponse (T16).

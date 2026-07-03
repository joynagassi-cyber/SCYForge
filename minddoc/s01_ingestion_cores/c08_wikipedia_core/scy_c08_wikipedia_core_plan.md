<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-WIKIPEDIA-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_WIKIPEDIA_PLAN  
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
 [Titre d'article / URL Wikipédia / mot-clé + langue]
                 │
                 ▼
       [Résolution & recherche]
          ├── URL → extraction titre + langue
          ├── Titre direct → résolution canonique (redirections)
          └── Mot-clé → generator=search → sélection article
                 │
                 ▼
     [Mastra TS Ingestion Worker]
                 │
                 ├──► [Vérification mfg_shared_content_cache (page_id + last_rev_id)] ──► Hit + à jour ──► (Fin)
                 │
                 └──► [Miss / nouvelle révision : MediaWiki Action API (reqwest + User-Agent)]
                             │
              ┌──────────────┼───────────────────────────┐
              ▼              ▼                            ▼
   [prop=extracts]   [API REST page/html]         [prop=links (paginé)]
   (résumé texte)    (HTML complet)               (wikiliens → graphe)
              │              │                            │
              ▼              ▼                            ▼
        [prop=sections]  [dom_smoothie]            [Filtrage namespace]
        (hiérarchie)    (HTML → Markdown)          [Calcul poids d'arête]
              │              │                            │
              └──────────────┼────────────────────────────┘
                             ▼
                [Infobox → tableau Markdown]
                [Score d'intégrité DRACO]
                             │
                             ▼
        [Écriture PostgreSQL mfg_project_sources]
        [Arêtes sémantiques COSMOS (graphe de wikiliens)]
        [Indexation vectorielle Zilliz]
        [Arête COSMOS-MINDGRAPH → status: completed]
```

---

## 2. Dépendances Techniques Strictes
* **MediaWiki Action API** (publique, gratuite) :
  - `https://{lang}.wikipedia.org/w/api.php`
  - Paramètres clés : `action=query`, `prop=extracts|sections|links|categories`, `generator=search`, `redirects=1`.
  - Pagination des liens via `plcontinue`.
* **MediaWiki REST API** : `https://{lang}.wikipedia.org/api/rest_v1/page/html/{title}` (HTML propre complet).
* **Runtimes Rust** :
  - `reqwest` (client HTTP + `User-Agent` descriptif obligatoire).
  - `serde_json` (parsing réponses paginées).
  - `governor` (rate limiting respectueux : ≤ 200 req/s par hôte).
  - `dom_smoothie` (HTML → Markdown).
* **Stockage** :
  - PostgreSQL (Northflank) : `mfg_project_sources`, `mfg_shared_content_cache`, `mfg_sync_queue`.
  - COSMOS : graphe de connaissances (nœuds concepts + arêtes de wikiliens).

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/wikipediaCore.ts`** : Orchestration Mastra TS (résolution, cache, enqueue SAGA).
- **`backend_rs/src/cores/wiki/api_client.rs`** : Client HTTP MediaWiki (Action + REST, `User-Agent`, rate limiting).
- **`backend_rs/src/cores/wiki/resolver.rs`** : Résolution titre/URL/mot-clé → page canonique (gestion redirections).
- **`backend_rs/src/cores/wiki/content_extractor.rs`** : Extraction résumé, sections, infobox → Markdown (`dom_smoothie`).
- **`backend_rs/src/cores/wiki/wikilink_graph.rs`** : Extraction des liens internes paginés + construction des arêtes COSMOS (poids, filtrage namespace).
- **`mfg_project_sources`** : Stockage du Markdown encyclopédique et des métadonnées (langue, révision).
- **`mfg_shared_content_cache`** : Dé-duplication par `page_id` + `last_rev_id`.
- **`mfg_sync_queue`** : File d'attente asynchrone SAGA pour l'ingestion de grappes d'articles liés.

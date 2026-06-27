# SCY INTEGRATION HUB — Analyse Composio + Alternatives + Architecture d'Ingestion Multi-Plateformes

**ID** : S00_INTEGRATION_HUB · **Date** : 2026-06-27 · **Réf** : PRD §6.1-6.2, s01 ingestion cores (c05 Google Drive), DEPENDENCY_MANIFEST §Integrations

> **Objet** : Évaluer Composio (open source vs payant), identifier de meilleures alternatives, et définir comment les 18 agents SCY utilisent le hub d'intégration pour l'ingestion depuis Notion, Obsidian, Recall, NotebookLM, Anki, Evernote.

---

## 1. ANALYSE DU DÉPÔT GITHUB OFFICIEL DE COMPOSIO

**Dépôt** : [`github.com/composiohq/composio`](https://github.com/composiohq/composio) · **Site** : [composio.dev](https://composio.dev)

### 1.1 Ce qui est réellement « open source » chez Composio

| Composant | Licence | Statut réel |
|---|---|---|
| **SDK client Python** (`composio`, `composio_langchain`, `composio_openai`...) | MIT | ✅ Open source |
| **SDK client TypeScript** (`@composio/core`, `@composio/openai-agents`...) | MIT | ✅ Open source |
| **CLI** (`composio`) | MIT | ✅ Open source |
| **Catalogue de 1000+ toolkits** (définitions des outils) | ❌ **Propriétaire** | 🔒 Fermé — non auditable |
| **Runtime d'exécution des outils** (sandbox) | ❌ **Propriétaire** | 🔒 Fermé |
| **Stockage des credentials OAuth** | ❌ **Cloud Composio** | 🔒 Fermé, hébergé chez eux |
| **MCP Gateway (Tool Router)** | ❌ **Hosted** | 🔒 Serveur géré par Composio |

> **⚠️ Conclusion clé** : Composio **n'est PAS open source** au sens d'une plateforme. C'est un modèle **« open-SDK, closed-platform »**. Seuls les clients (SDK) sont MIT. Le cœur (catalogue, runtime, coffre-fort de credentials) est propriétaire et fermé. On ne peut **ni auditer, ni forker, ni étendre** un tool pré-construit.

### 1.2 Site composio.dev — ce qui est proposé

- **1000+ toolkits** pré-construits (Gmail, Slack, GitHub, Notion, Jira, HubSpot…)
- **OAuth managé** : Composio gère le flow OAuth + refresh automatiquement, tokens stockés côté serveur
- **MCP Gateway** (Tool Router) : expose les tools via Model Context Protocol, connectable à Claude, ChatGPT, Cursor, VS Code
- **Triggers** : webhooks sur événements externes (nouveau commit GitHub, message Slack…)
- **Providers** : OpenAI, Anthropic, LangChain, LlamaIndex, CrewAI, AutoGen, **Mastra** (notre stack TS), Vercel AI SDK

### 1.3 Tarification (2026)

| Plan | Prix | Volume |
|---|---|---|
| **Free / Hobby** | $0 | ~5 000 à 20 000 tool calls/mois (selon source), 60 req/min |
| **Growth** | $29/mois | 200 000 tool calls/mois |
| **Starter** | $99/mois | 100 000 calls + features |
| **Enterprise** | sur devis | volume + SSO + self-host (images fermées) |

> « La plupart des équipes en production dépassent le tier gratuit dès le premier mois d'usage réel. » ([Peliqan](https://peliqan.io/blog/composio-alternatives-competitors/))

---

## 2. LA SOLUTION OPEN SOURCE EST-ELLE IDÉALE ? LA PAYANTE ?

### 2.1 🔴 Le fait disqualifiant — incident de sécurité de mai 2026

> En **mai 2026**, Composio a subi une **faille de sécurité** : un attaquant a obtenu une **exécution de code arbitraire (RCE) dans le runtime sandbox**. Conséquence : **~10 242 credentials clients exposés** — dont **5 001 tokens OAuth GitHub** et **~5 241 clés API**. Composio a dû supprimer toutes les clés API existantes et obliger **chaque client à pivoter ses clés**. Comme Composio **ne pouvait pas révoquer les tokens de comptes connectés**, les clients ont dû **demander à leurs utilisateurs finaux de se ré-authentifier**. ([Nango](https://nango.dev/blog/best-open-source-api-integration-platforms-for-ai-agents))

**Pourquoi c'est critique pour SCY Forge** : notre PRD impose RLS multi-tenant, GDPR, AI Act EU, TLS 1.3, JWT, OAuth. **Stocker les credentials OAuth de nos utilisateurs (Google Drive, Notion, Evernote) dans un cloud tiers fermé qui vient d'être compromis est inacceptable** pour notre posture de sécurité. De plus, code fermé = **aucun audit possible** du correctif.

### 2.2 Verdict : ni l'un ni l'idéal

| Critère | Free/SDK | Payant (Growth $29) | Verdict SCY Forge |
|---|---|---|---|
| Code auditable | SDK seulement | SDK seulement | ❌ Cœur fermé |
| Self-host runtime | ❌ Enterprise only (images fermées) | ❌ Idem | ❌ Pas de souveraineté |
| Credentials chez qui | Cloud Composio | Cloud Composio | 🔴 Risque (faille mai 2026) |
| Coût à l'échelle | $0 (limité) | $29-99+/mois, croît au volume | ⚠️ Variable |
| Catalogue prêt | ✅ 1000+ | ✅ 1000+ | ✅ Seul vrai atout |
| MCP natif | ✅ Hosted | ✅ Hosted | ✅ Mais dépendant de leur cloud |
| GDPR/HIPAA | SOC 2, ISO 27001 | idem | ⚠️ Pas HIPAA clair |

> **Conclusion** : Composio est **excellent pour prototyper vite** (catalogue massif, OAuth zero-code), mais **non idéal pour SCY Forge en production** à cause (1) du cœur fermé non-auditable, (2) de l'impossibilité de self-host souverain, et surtout (3) de **l'incident de sécurité de mai 2026** sur le stockage centralisé de credentials.

---

## 3. ALTERNATIVES MEILLEURES QUE COMPOSIO

### 3.0 ⚡ Approfondissement demandé : Pipedream est-il plus avancé que Nango ?

Comparaison directe (sources : [skywork.ai](https://skywork.ai/skypage/en/pipedream-mcp-server-ai-guide-tools/1978340755696689152), [Peliqan](https://peliqan.io/blog/pipedream-alternatives/), [Nango](https://nango.dev/blog/pipedream-connect-alternatives/), [Integration Atlas](https://www.integrationatlas.com/compare/n8n-vs-pipedream/)) :

| Critère | Pipedream | Nango | Gagnant pour SCY Forge |
|---|---|---|---|
| **Catalogue** | 🏆 2 800-3 000 apps, 10 000+ tools | 800+ templates ouverts | Pipedream (largeur) |
| **MCP server** | 🏆 Mature, production-ready hosted | Built-in, self-host | Égal |
| **Polish / DX managé** | 🏆 Serverless, auto-scale | Code-first, plus d'ops | Pipedream (confort) |
| **Compliance cloud** | SOC 2 II, HIPAA (BAA), GDPR | SOC 2 II, GDPR, HIPAA | Égal |
| **Self-host credentials** | ❌ **NON** — le "self-host MCP" est une *implémentation de référence, non maintenue, non production* qui **route TOUJOURS l'auth via Pipedream Connect cloud** (US, AWS us-east-1). Le coffre-fort reste chez eux. | 🏆 **OUI** — runtime + credential vault dans **votre** PostgreSQL | **Nango** 🔑 |
| **Data residency** | AWS us-east-1 (US) uniquement ; EU = "sales conversation" | 🏆 Vous choisissez (Northflank EU) | **Nango** 🔑 |
| **Sync données pour RAG (ingestion)** | ❌ Triggers only, **pas de sync engine** | 🏆 Sync durable incrémental **2-way**, conçu pour nourrir des pipelines RAG | **Nango** 🔑🔑 |
| **Webhooks/Triggers** | ✅ Triggers | 🏆 High-throughput + syncs | Nango |
| **Code-first / extensible** | Code steps Node/Python | 🏆 Templates en code dans votre repo + AI coding agent builder | Nango |
| **White-label OAuth** | Connect (partiellement) | 🏆 Drop-in, marque SCY Forge | Nango |
| **Observabilité** | Basic | 🏆 OpenTelemetry + logs complets | Nango |
| **Licence** | Source Available (composants) | 🏆 Elastic License 2.0 (runtime + templates) | Nango |
| **Prix à l'échelle** | Credit-based, AI brûle les crédits | 🏆 Self-host = $0 API (+ serveur déjà couvert Northflank) | Nango |

**Le point décisif** : Pipedream est **plus avancé en largeur de catalogue et en polish managé**, MAIS :
1. Il **ne self-host PAS les credentials** — même son MCP "self-hosté" route l'auth via leur cloud US. Après l'incident Composio (mai 2026, 10 242 credentials compromis dans un cloud tiers fermé), confier nos credentials OAuth à un cloud US géré est inacceptable pour SCY Forge (GDPR/EU AI Act).
2. Il **n'a pas de sync engine** — or le cœur de SCY Forge est l'**ingestion continue** (AG-02 CONTENT-SCOUT doit sync Notion/Evernote → knowledge base). Nango est *conçu* pour ça (sync incrémental 2-way qui nourrit le RAG), Pipedream n'a que des triggers ponctuels.

**Verdict** : 🏆 **Nango reste le meilleur choix pour SCY Forge.** Pipedream gagne en largeur/confort mais perd sur les 2 critères qui comptent le plus ici : **souveraineté des credentials** et **sync d'ingestion**. Pipedream serait le bon choix pour un projet *managed-first, US, orienté actions ponctuelles* — ce n'est pas le profil de SCY Forge.

> Si la largeur de catalogue devenait critique plus tard (une app niche absente de Nango), on pourrait ajouter **Pipedream hosted MCP en lecture seule via `mcp.pipedream.com`** pour ce cas précis — **sans** y stocker de credentials (appel direct avec token que l'utilisateur fournit au runtime).

---

### 3.1 🥇 Recommandation : **Nango** comme hub principal

| Plateforme | Licence | Self-host | APIs | Auth managée | Sync/Webhooks | MCP | Idéal pour |
|---|---|---|---|---|---|---|---|
| **🥇 Nango** | Elastic 2.0 (**vraiment open**) | ✅ Free + Enterprise | 800+ (templates ouverts en code) | ✅ White-label, token refresh | ✅ Sync durable 2-way + webhooks | ✅ Built-in | **Souveraineté + agents + ingestion** |
| **🥈 Pipedream** | Composants OSS | ❌ (hosted) | 3 000 apps / 10 000+ tools | ✅ | ✅ Triggers | ✅ Mature (`mcp.pipedream.com`) | Prototypage riche, code-first |
| **🥉 Arcade.dev** | Framework MIT, engine fermé | ⚠️ VPC/on-prem Enterprise | ~112 first-party | ✅ Platform-managed | ❌ | ✅ Security-first | Gouvernance MCP stricte |
| **n8n** | Sustainable Use (fair-code) | ✅ Free illimité | 400+ (600+ nodes) | ✅ | ✅ | ✅ (n8n 2.0 AI nodes) | Workflows visuels self-host |
| **Activepieces** | **MIT** | ✅ Free | 300+ | ✅ | ✅ | ✅ (chaque piece = MCP) | License la plus permissive |
| Composio | SDK MIT, plateforme fermée | ❌ Enterprise | 1000+ | ✅ (cloud tiers) | ❌ | ✅ Hosted | Cataloge massif, rapide |

### 3.1 🥇 Recommandation : **Nango** comme hub principal

**Pourquoi Nango est supérieur à Composio pour SCY Forge** ([source](https://nango.dev/blog/composio-vs-nango/)) :

1. **Vraiment open source** (Elastic License 2.0) : runtime + credential store + 800+ templates en code dans **votre repo Git** → auditable, forkbale, extensible.
2. **Self-host gratuit** : vous hébergez le runtime → **credentials OAuth stockés CHEZ VOUS** (Northflank/PostgreSQL), pas chez un tiers. Conforme GDPR + souveraineté.
3. **Compliance** : SOC 2 Type II + **GDPR + HIPAA** (Composio n'a pas HIPAA clair).
4. **Au-delà du tool-call** : Nango fait aussi **sync de données durable (2-way) + webhooks + unified API** — parfait pour l'**ingestion continue** (ex. sync nouvelles notes Notion → SCY Forge automatiquement), pas seulement des actions ponctuelles.
5. **MCP server built-in** : expose vos tools custom via MCP aux 18 agents.
6. **White-label auth** : l'écran OAuth affiche **SCY Forge**, pas le nom de la plateforme → professionnel pour le B2B.
7. **Observabilité** : logs complets request/response + export OpenTelemetry (converge avec notre stack Axiom/Sentry).
8. **AI coding agent skill** : Claude Code/Cursor peuvent générer de nouvelles intégrations Nango directement.

**Tarif Nango** : Free tier (10 connexions, 100k syncs/mois) → usage-based. Self-host = $0 d'API + coût serveur (déjà couvert par Northflank).

### 3.2 Quand garder Composio (usage secondaire, ciblé)

- **Uniquement en lecture** pour quelques toolkits niche non couverts par Nango, **via leur MCP hosted**, **sans y stocker de credentials sensibles en écriture**.
- Phase de prototypage rapide (POC) avant migration vers Nango.
- **Jamais** comme coffre-fort principal de credentials.

---

## 4. ARCHITECTURE — COMMENT LES AGENTS UTILISENT LE HUB D'INTÉGRATION

### 4.1 Topologie globale

```
                        ┌─────────────────────────────────────────┐
                        │         SCY INTEGRATION HUB              │
                        │  (Nango self-hosté sur Northflank)       │
                        │                                          │
   Utilisateur ──OAuth──▶  Credential Vault (PostgreSQL chiffré)   │
   (Connect to X)         │  + 800+ templates ouverts (code Git)    │
                        │  + Sync Engine (2-way, webhooks)         │
                        │  + MCP Server (expose tools)             │
                        └───────────────┬──────────────────────────┘
                                        │ MCP / REST
                   ┌────────────────────┼────────────────────┐
                   ▼                    ▼                    ▼
          ┌────────────────┐  ┌──────────────────┐  ┌────────────────┐
          │  backend_ts    │  │   backend_rs     │  │   frontend     │
          │  (ASCENT 18    │  │  (Ingestion      │  │  (Connect UI   │
          │   agents via   │  │   Cores c01-c13) │  │   white-label  │
          │   Mastra)      │  │  → MapReduce L0-L4│  │   Nango)       │
          └────────────────┘  └──────────────────┘  └────────────────┘
                   │                    │
                   ▼                    ▼
          Actions agentiques     Ingestion de contenu
          (ex: "ajoute note     (Notion/Obsidian/Drive
           Notion", "crée       → chunks → concepts →
           deck Anki")          cartes FSRS)
```

### 4.2 Comment les 18 agents consomment le hub

| Agent | Rôle vis-à-vis du hub | Exemple d'usage |
|---|---|---|
| **AG-02 CONTENT-SCOUT** | 🔑 **Principal consommateur ingestion** | Découvre du contenu via Nango sync (nouvelles notes Notion, Evernote) → scoring → route vers NEURON-CHAINS |
| **AG-01 GOAL-INTERPRETER** | Connecte l'objectif utilisateur aux sources disponibles | « Apprends le trading » → suggère de connecter sources X/Y via le hub |
| **AG-04 LEARNING-CONDUCTOR** | Actions write-back | Crée des résumés dans Notion/Obsidian de l'utilisateur |
| **AG-09 SKILL-CERTIFIER** | Export de certificats | Pousse un badge PDF vers Notion / Evernote |
| **AG-10 CHRONICLE** | Conversation-native | WhatsApp/Telegram (via triggers Nango) pour rappels |
| **AG-16 HITL-PROXY-SME** | Import expertise SME | Récupère documents pro depuis Google Drive/Notion |

**Pattern d'appel unifié** : chaque agent appelle un tool standardisé exposé par le MCP Nango, ex. `integration.search(platform="notion", query="...")`, `integration.fetch(platform="evernote", id="...")`. Le hub injecte automatiquement les credentials OAuth de l'utilisateur (multi-tenant via `user_id`).

### 4.3 Exposition du hub — 3 surfaces

1. **MCP Server (runtime agents)** : le hub Nango expose un endpoint MCP consommé par `backend_ts` (Mastra) et `backend_rs` (ingestion). C'est le canal agentique principal.
2. **REST API (ingestion cores)** : les 13 cores d'ingestion (`scy-ingestion`) appellent le hub en REST pour puller du contenu brut → MapReduce L0-L4.
3. **White-label Connect UI (frontend)** : `frontend_react/settings/` intègre le composant Nango Connect (drop-in) → l'utilisateur connecte ses apps en 2 clics, écran brandé SCY Forge.

---

## 5. EXPOSITION POUR L'INGESTION — PAR PLATEFORME

Chaque plateforme a une nature différente. Voici la stratégie d'ingestion recommandée :

### 5.1 Notion ✅ — Intégration native complète

- **API officielle** : Notion API REST (OAuth2), complète et stable.
- **Via hub** : Nango template `notion` (existe) + toolkits Composio en secours.
- **Ingestion** : AG-02 sync les pages/databases → `c02_web_article_core` (Markdown natif Notion) → NEURON-CHAINS.
- **Statut** : 🟢 Trivial, out-of-the-box.

### 5.2 Evernote ✅ — API REST officielle

- **API officielle** : Evernote Cloud API (OAuth, REST).
- **Via hub** : Nango template (vérifier dispo) ou intégration directe dans `scy-ingestion` (crate `reqwest`).
- **Ingestion** : pull notes (HTML/ENML) → conversion Markdown → MapReduce.
- **Statut** : 🟢 Direct.

### 5.3 Anki ⚠️ — Desktop-only, deux voies

- **Voie A — AnkiConnect (live sync)** : plugin Anki qui expose un serveur HTTP sur `127.0.0.1:8765`. Permet CRUD decks/cartes. **Mais** : nécessite Anki Desktop lancé sur la machine de l'utilisateur → convient au **mode Desktop local** (WASM/SQLite), pas cloud.
- **Voie B — .apkg (fichier)** : import/export de paquets `.apkg` (format SM-2). **Déjà prévu** dans APEX/FSRS (`Import/Export Anki .apkg SM-2↔FSRS`, IMPLEMENTATION_ORDER Sprint 3).
- **Recommandation** : `.apkg` bidirectionnel comme défaut ($0, cross-platform) + AnkiConnect optionnel pour le mode Desktop live.
- **Statut** : 🟡 Spécial — pas un hub OAuth classique.

### 5.4 Obsidian 🔴 — Local-first, pas d'API cloud

- **Réalité** : Obsidian est **local-first**, **aucune API cloud officielle**. Obsidian Sync n'a **pas d'API** (chiffrement de bout en bout). ([forum Obsidian](https://forum.obsidian.md/t/is-there-are-rest-api-available/78627))
- **Voie A — File system (recommandée)** : le vault Obsidian = un dossier de fichiers Markdown sur le disque. Le **mode Desktop SCY Forge** lit directement ce dossier (watcher) → ingestion Markdown brut. C'est la voie la plus fiable.
- **Voie B — Local REST API plugin** : plugin communautaire exposant un serveur localhost + bridge MCP `mcp-obsidian` (7 outils : list, read, search, patch, append, delete). Convient au Desktop agent local.
- **Statut** : 🔴 Pas d'OAuth cloud — ingestion **Desktop-only via filesystem** ou plugin local.

### 5.5 NotebookLM 🔴 — Aucune API publique consommable

- **Réalité** : **Pas d'API publique consommateur**. Google n'a qu'une API **Enterprise** (Google Cloud, licence Gemini Enterprise/Education Premium, setup admin). L'ancien Podcast API est **déprécié**, plus d'allowlisting. ([source](https://web-clipper-for-notebooklm.com/blog/notebooklm-api))
- **Conséquence** : on **ne peut pas ingérer depuis ou vers NotebookLM** de façon programmatique fiable.
- **Recommandation** : **Ne pas intégrer NotebookLM comme source/cible**. Le traiter comme un **concurrent** (SCY Forge = alternative agentique supérieure : BRAIN RAG + COSMOS graphe + APEX FSRS). À la rigueur, accepter l'**upload manuel** d'exports NotebookLM par l'utilisateur.
- **Statut** : 🔴 Non intégrable — pivot stratégique (BRAIN le remplace).

### 5.6 Recall.ai ℹ️ — Catégorie différente (réunions)

- **Réalité** : Recall.ai est une **API de bot de réunion** (rejoint Zoom/Meet/Teams, enregistre, transcrit). Ce n'est pas un stockage de notes mais une **source audio/transcription**.
- **Intégration** : convient au **`c03_podcast_core`** (déjà prévu avec Whisper + diarization). Recall fournit la transcription → le core l'ingère comme un podcast/transcript.
- **Statut** : 🟡 Via c03 podcast core, non via le hub OAuth.

### 5.7 Synthèse — Matrice de faisabilité

| Plateforme | Hub OAuth ? | Voie d'ingestion | Effort | Core SCY |
|---|---|---|---|---|
| **Notion** | ✅ Oui | Nango/Composio + API REST | 🟢 Faible | c02 web article |
| **Google Drive** | ✅ Oui | Nango/Composio + Docling | 🟢 Faible | c05 (déjà prévu) |
| **Evernote** | ✅ Oui | API REST directe | 🟢 Faible | nouveau / c02 |
| **Anki** | ❌ Local | `.apkg` + AnkiConnect Desktop | 🟡 Moyen | APEX export |
| **Obsidian** | ❌ Local | Filesystem vault + plugin MCP | 🟡 Moyen | nouveau Desktop |
| **Recall.ai** | ✅ API key | c03 podcast core (transcriptions) | 🟡 Moyen | c03 (existant) |
| **NotebookLM** | ❌ Aucune | **Non intégrable** — pivot | 🔴 N/A | — (BRAIN remplace) |

---

## 6. DÉCISION ARCHITECTURALE PROPOSÉE (à valider)

> ⚠️ **Signalement avant action** : ceci contredit partiellement le `DEPENDENCY_MANIFEST` actuel qui liste `composio-core` comme intégrateur OAuth principal. Proposition de pivot.

| Aspect | Avant (manifeste actuel) | Proposition |
|---|---|---|
| Hub d'intégration principal | `composio-core` (cloud fermé) | **Nango** self-hosté (open, souverain) |
| Stockage credentials | Cloud Composio | **PostgreSQL SCY Forge** (chiffré, RLS) |
| MCP source principale | Composio Tool Router | **Nango MCP server** (built-in) |
| Composio | Rôle principal | Rôle **secondaire** (lecture seule, POC) |
| Obsidian / Anki | Non adressés | Cores Desktop dédiés (filesystem/AnkiConnect/.apkg) |
| NotebookLM | Non adressé | **Exclu** (pas d'API) — BRAIN = alternative |

### 6.1 Impact sur le code
- **`backend_rs/scy-ingestion`** : ajouter un module `integration_hub.rs` (client Nango REST/MCP).
- **`backend_ts`** : ajouter `src/integrations/` (wrapper Nango SDK pour les agents ASCENT).
- **`frontend_react/settings/`** : intégrer `ConnectComponent` Nango (white-label).
- **`docker/`** : ajouter sidecar `nango` (ou déployer sur Northflank).
- **`DEPENDENCY_MANIFEST`** : ajouter Nango, reclasser Composio en « secondaire/POC ».

### 6.2 Sources
- [Composio GitHub](https://github.com/composiohq/composio) · [composio.dev](https://composio.dev)
- [Nango vs Composio](https://nango.dev/blog/composio-vs-nango/) · [Best OSS platforms](https://nango.dev/blog/best-open-source-api-integration-platforms-for-ai-agents)
- [Peliqan — Composio alternatives](https://peliqan.io/blog/composio-alternatives-competitors/)
- [Incident sécurité Composio mai 2026](https://nango.dev/blog/composio-alternatives/)
- [NotebookLM API status](https://web-clipper-for-notebooklm.com/blog/notebooklm-api)
- [AnkiConnect](https://github.com/FooSoft/anki-connect) · [Obsidian Local REST API](https://forum.obsidian.md/t/is-there-are-rest-api-available/78627)

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 🏖️ COSMOS CYBER MODE — BEACHHEAD MVP

> **Révision pivot cyber** : 26 modes originaux réduits à **4 modes MVP**.
> Les 18 autres modes restent dans la codebase mais ne sont pas actifs pour le beachhead SOC.

### Modes retenus pour le MVP Cyber Beachhead

| Mode original | Nom MVP Cyber | Concept ATT&CK | Description |
|---------------|---------------|----------------|-------------|
| **Mode 04** (Roadmap) | **Mission Tree** | Tactic hierarchy | Hiérarchie des tactiques ATT&CK en arbre de mission navigable |
| **Mode 07** (Statistics) | **SMI Radar** | Mastery radar | Radar 5-dimensions de maîtrise des techniques |
| **Mode 09** (Concept Map) | **Threat Terrain** | Technique relationships | Carte des relations entre techniques ATT&CK (enables/requires/detected_by) |
| **Mode 22** (Semantic Zoom) | **Tactical Zoom** | Enterprise→Tactic→Technique→Sub-technique | Zoom sémantique navigable de l'échelle Enterprise vers le sub-technique |

**Réduction 26→4 modes** :
- 4 modes retenus et renommés pour le contexte cyber
- 18 modes en veille (code conservé, spec maintenue)
- **Mode 23 (3D Knowledge Space) → DEFERRED** (voir marqueur plus bas)
- 4 modes éliminés du MVP (fusionnés ou non essentiels au beachhead)

### Règles COSMOS Cyber Auto-Linking

Le moteur COSMOS applique automatiquement ces règles de liaison pour le contexte cyber :

```
EDR Alert → ATT&CK Technique → Playbook Step → Artifact Type
     ↓              ↓                  ↓               ↓
  [Alert ID]    [Tactic+Technique] [Runbook Step]  [File/Registry/Network]
```

**Règles de lien automatique** :
1. **EDR Alert → Technique** : Chaque alerte EDR est mappée vers la(les) technique(s) ATT&CK correspondante(s) via les signatures de l'EDR
2. **Technique → Playbook** : Chaque technique pointe vers les playbooks/runbooks de réponse associés
3. **Playbook → Artifact** : Chaque étape de playbook référence le type d'artefact attendu (fichier, clé registre, connexion réseau, processus)
4. **Gap Detection** : Signal de confiance primaire — si une prérequis technique n'est pas couverte par un playbook existant → **écart opérationnel identifié**

### Gap Detection — Signal de confiance primaire

```
Prérequis manquant = Operational Readiness Gap

Exemple :
  Technique ATT&CK T1059.001 (PowerShell) nécessite :
    ☐ Playbook "Détection PowerShell suspect"
    ☐ Règle Sigma associée
    ☐ Artefact de collecte (script de logging)
  
  Si ☐ non coché → GAP détecté → Action requise
```

**Métriques Gap Detection** :
- Nombre de gaps par tactic
- Couverture playbook par technique (%)
- Maturité opérationnelle globale (0-100)
- Temps moyen de résolution des gaps

<!-- DEFERRED BEYOND BEACHHEAD MVP -->
### Mode 23 — 3D Knowledge Space *(DEFERRED)*

**Description** : Espace sémantique 3D immersif (palais de mémoire). Moteur `three.js` optionnel Phase 3.
- Spécification complète : `s04_scy_cosmos_visualization_engine/scy_cosmos_modes_production_blueprint.md`
- Roadmap WebGPU : `s04_scy_cosmos_visualization_engine/engine_webgpu/`
<!-- /DEFERRED BEYOND BEACHHEAD MVP -->

---

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
PRD source de vérité — adapter pour cyber beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

  total_days INTEGER,
  total_study_hours REAL,
  nodes_completed INTEGER,
  total_exercises INTEGER,
  exercises_passed INTEGER,
  pass_rate REAL,
  cards_reviewed INTEGER,
  total_lapses INTEGER,
  max_streak_days INTEGER,
  teachback_sessions INTEGER,
  
  -- Exports
  pdf_url TEXT,
  badge_png_url TEXT,
  linkedin_badge_url TEXT,
  json_export JSONB,                  -- Machine-readable complet
  
  -- Suggestions suite
  next_goals_suggested JSONB,
  
  -- Timestamps
  earned_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL,
  
  -- Vérification publique
  is_public BOOLEAN DEFAULT true,
  public_data JSONB                   -- Données visibles sans compte
);
```

---

#### 7.6.3 PIVOTIQ — Réconciliation Multi-Sources Intelligente

**Phase** : V2  
**Document référence** : FEATURE-PIVOTIQ-V1  
**Position dans le pipeline** : Entre MapReduce L0-L3 et NEURON-CHAINS

```
INGESTION (11 Cores) → MapReduce L0-L3 → 🔷 PIVOTIQ → NEURON-CHAINS
```

**Problème résolu** : Quand l'utilisateur ingère plusieurs sources contradictoires sur le même sujet, le contenu brut transféré à NEURON-CHAINS contient des incohérences qui dégradent la qualité des documents générés. PIVOTIQ résout cela en amont.

---

**A — 4 Composants PIVOTIQ**

**Composant 1 — RRF Scorer**

Rank toutes les sources selon crédibilité + pertinence avant processing.

```rust
// Formule : score = source_weight / (k=60 + rank)
// Pondérations :
// Academic Papers : 1.5×
// Official Docs   : 1.3×
// Tutorials       : 1.0× (baseline)
// Forums          : 0.8×
// Blogs perso     : 0.6×

// Facteurs additionnels :
// Freshness : -10% par an d'obsolescence
// Citation count (papers académiques)
// Author reputation (H-index si disponible)
```

**Composant 2 — Contradiction Detector**

Comparaison pairwise (N×(N-1)/2) pour identifier les divergences factuelles.

```
Types de contradictions détectées :
├── Factual      : Valeurs numériques différentes (learning rate 0.01 vs 0.001)
├── Methodological: Approches incompatibles (Adam vs SGD)
├── Temporal     : Best practice 2022 obsolète en 2026
└── Scope        : Production vs recherche académique

Severity scoring :
├── Major   → severity > 0.7 (signalé clairement à l'user)
├── Moderate → 0.4 < severity ≤ 0.7 (note de nuance)
└── Minor   → ≤ 0.4 (variation acceptable, fusionnée)
```

**Composant 3 — Semantic Deduplicator**

Fusionne les contenus quasi-identiques pour éviter la redondance.

```
Seuils cosine similarity :
> 0.92 → MERGE automatique (même contenu)
0.75-0.92 → RELATED (lien créé, pas fusion)
< 0.75 → DISTINCT (contenus différents)

Économie : -20% appels LLM grâce à la déduplication
Multilingue : "Gradient descent" = "Descente de gradient" détecté
```

**Composant 4 — Unified Synthesizer**

Génère un document de synthèse structuré en 4 sections :

```markdown
## Synthèse Unifiée [Concept]

### 1. Consensus ⭐⭐⭐⭐⭐
Ce sur quoi toutes les sources s'accordent [refs]

### 2. Nuances ⭐⭐⭐
Variations mineures acceptables entre sources

### 3. Contradictions ⚠️
Divergences majeures + explication des raisons + résolution recommandée

### 4. Recommandations
Quelle source privilégier selon le contexte :
• Pour usage académique → [Source X]
• Pour implémentation pratique → [Source Y]
• Pour production → [Source Z]
```

---

**B — Déclenchement Automatique**

```rust
fn should_trigger_pivotiq(sources: &[Source]) -> bool {
    sources.len() >= 3                      // Au moins 3 sources
    && same_topic_cluster(sources, 0.6)     // Même sujet (cosine > 0.6)
    && diverse_source_types(sources, 2)     // Au moins 2 types différents
}
```

PIVOTIQ se déclenche automatiquement quand Agent-02 (CONTENT-SCOUT) ingère ≥3 sources sur le même sujet. L'utilisateur ne voit que le résultat final propre.

---

**C — Impact sur la qualité NEURON-CHAINS**

Sans PIVOTIQ → NEURON-CHAINS reçoit 5 sources avec contradictions → génère un document incohérent → score confiance bas (~65/100)

Avec PIVOTIQ → NEURON-CHAINS reçoit 1 synthèse unifiée propre + signalement contradictions → génère un document cohérent → score confiance élevé (~88/100)

---

**D — Performance**

| Phase | Temps | Coût LLM |
|-------|-------|---------|
| RRF Scoring | <100ms | $0 (calcul Rust pur) |
| Contradiction Detection | 5-10s | $0.0085 (5 paires en parallèle) |
| Deduplication | 1-2s | $0.001 (embeddings cachés 60%) |
| Unified Synthesis | 10-15s | $0.015 (1 appel LLM long context) |
| **TOTAL** | **~20-30s** | **$0.025 par topic** |

---

**E — Schéma BDD PIVOTIQ**

```sql
-- Résultats réconciliation
CREATE TABLE scy_pivotiq_results (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  topic_cluster TEXT NOT NULL,         -- Topic identifié
  source_ids UUID[] NOT NULL,          -- Sources traitées
  
  -- RRF Scoring
  ranked_sources JSONB NOT NULL,       -- [{source_id, score, rank, weight}]
  
  -- Contradictions
  contradictions_found JSONB NOT NULL, -- [{type, severity, source_a, source_b, explanation}]
  contradiction_count INTEGER DEFAULT 0,
  
  -- Déduplication
  duplicates_merged INTEGER DEFAULT 0,
  cost_savings_usd REAL,
  
  -- Synthèse
  unified_document_id UUID REFERENCES scy_documents(id),
  synthesis_quality_score REAL,
  
  processing_time_ms INTEGER,
  llm_cost_usd REAL,
  created_at INTEGER NOT NULL
);
```

### 7.7 Module SCY-BRAIN — RAG Intelligent

**Architecture Triple Retrieval + RRF :**

1. **Vector Similarity (Dense)** : pgvector cosinus 512D, top-k=20, cache embeddings 60% hit rate
2. **BM25 Full-Text (Sparse)** : Tantivy, stemming multilingue, phrase queries, faceted search
3. **Graph Traversal (Structured)** : COSMOS relations (is_a, prerequisite_of), 2-hop, PageRank

**RRF Fusion** : `RRF(doc) = Σ(1 / (k + rank_i))` avec k=60, top-10 final

**Phases RAG :**
- Phase 0 : Naive RAG (vector + generation)
- Phase 1 : HyDE (+15-20% recall) + KG RAG (+12% exact match)
- Phase 2 : Query Rewriting (3 reformulations) + Cross-Encoder Reranking

**Generation** :
- SSE Streaming (tokens progressifs)
- Contextual compression LongLLMLingua (4× compression)
- Citations inline [1], [2] avec liens sources
- Confidence scoring réponse (0-100%)
- Anti-hallucination : fact-check DELTA agents

**AUTO-GRAPH** : Connexions automatiques concepts (cosine similarity > 0.75)

**Double Alimentation du BRAIN** *(v2 — voir SPEC-BRAIN-ONBOARDING-V1)* :
- **Base de connaissances du projet** (priorité) : toutes les informations pertinentes au projet courant immédiatement accessibles → réponses contextualisées
- **Accès Internet direct** : recherche temps réel, élargissement de l'étendue des connaissances
- → Combinaison interne + web = réponses **précises, exhaustives et à jour**
- Mode de connaissance configurable : `Projet seul` | `Internet seul` | `Hybride` (défaut)

**Suggestions Intelligentes — 3 questions par nœud** *(v2)* :
- Après chaque réponse, le BRAIN propose **3 questions complémentaires** basées sur le **nœud (contexte) courant**
- Génération via graph traversal COSMOS (2-hop) + cosine local (tool T16 DocSuggester, 0 token majoritaire)
- Favorise une découverte progressive et pertinente

**Professor AI — IA centrale accompagnatrice** *(v2)* :
- Guide et accompagne l'utilisateur à **chaque niveau** du parcours ASCENT
- Connaissance globale de la formation (DAG complet + contenus de tous les nœuds)
- Vulgarisation **simple et ludique** des concepts difficiles, adaptée au niveau (Débutant → Expert)
- Sélection auto du ton (T41 ELI5 → T42 ELI PhD) selon la classification du Starter Evaluator

### 7.7bis Module BRAIN Advanced Chat Gen — Chat Agentique *(v2 — nouveau)*

Module distinct offrant un **chat agentique complet** avec deux modes :

**Mode Normal** :
- Interaction simple et directe (Q → R)
- Réponses **claires, concises et précises**
- Moteur : SCY-BRAIN (triple retrieval + RRF + SSE streaming)
- Idéal pour requêtes rapides et informations factuelles

**Mode Agentique** :
- Pipeline d'agents autonomes (APEX-AGENT + 18 tools NEURON-CHAINS)
- Livrables : **fichiers visualisables**, **présentations PowerPoint interactives** (G13), **rapports détaillés**, **veilles technologiques approfondies**
- Anti-hallucination 3 couches + score de confiance par livrable
- Choix de la source par l'utilisateur : `Base cumulative seule (hors-ligne)` | `Internet seul (temps réel)` | `Hybride (optimal)`

**Stack UI** : Vercel AI SDK (streaming texte premium, graphiques inline, sections encadrées, UI générative) ; alternatives envisagées : LangGraph.js, Mastra, assistant-ui, CopilotKit.

### 7.7ter Module Onboarding Gamifié

**Phase** : Phase 0 (mode guest) + Phase 1 (onboarding gamifié complet)

**Contexte** : Le TTFV (Time to First Value) <5min est une métrique critique (§11.1). L'onboarding gamifié réduit la friction d'inscription et maximise la conversion trial→signup. Pattern éprouvé : Duolingo (+40% rétention J7), Brilliant.

#### A — Mode Guest (Phase 0)
- ✅ Aucune inscription requise pour essayer SCY Forge
- ✅ L'utilisateur crée son premier objectif ASCENT ou importe une source sans compte
- ✅ Données temporaires stockées localStorage (UUID session anonyme)
- ✅ Capture email proposée APRÈS la première valeur vécue (non avant)
- ✅ Continuité garantie : si l'utilisateur crée un compte, son contenu guest migre automatiquement

#### B — Flow Onboarding Gamifié (Phase 1)

```
Étape 1 : Choix objectif (15 secondes)
  "Je veux apprendre ___" → [React] [Machine Learning] [Marketing] [Autre...]
  → Feedback immédiat : "Super ! 847 apprenants SCY Forge maîtrisent React"

Étape 2 : Niveau actuel (10 secondes)
  [Débutant complet] [Quelques bases] [Intermédiaire] [Avancé]

Étape 3 : Temps disponible (10 secondes)
  [15 min/jour] [30 min/jour] [1h/jour] [Plus]

Étape 4 : Premier succès (< 90 secondes)
  → SCY Forge génère instantanément :
    • 1 nœud ASCENT d'introduction
    • 3 cartes APEX sur le concept fondamental #1
    • 1 session révision de 3 cartes
  → L'utilisateur révise ses 3 premières cartes
  → Animation confetti + "Premier concept maîtrisé ! SMI : 45/100 🎉"

Étape 5 : Email capture (post-succès)
  "Sauvegardez votre progression et continuez votre parcours !"
  → [Créer compte gratuit] [Continuer en mode invité encore 5 min]
```

#### C — Progress Bar Onboarding
- ✅ Barre de progression visible dès la première action ("Étape 1/4")
- ✅ Pourcentage d'avancement du profil affiché
- ✅ Célébration visuelle à chaque étape (micro-animation)

#### D — Métriques Onboarding
| Métrique | Cible | Alerte |
|---------|-------|--------|
| Temps jusqu'à 1ère révision | < 2 min | > 5 min |
| Taux complétion onboarding | > 70% | < 50% |
| Conversion guest → compte | > 40% | < 25% |
| Rétention J7 (onboarding gamifié vs classique) | +20% | < +10% |

---

### 7.7quater Module Collaboration & Partage

**Phase** : Niveau 1 Phase 1, Niveau 2 Phase 3

#### Niveau 1 — Partage Simple de Decks/Parcours (Phase 1-2) ✅

**Description** : Lien UUID unique → lecture seule, sans compte requis pour consulter.

```
Fonctionnement :
→ Bouton "Partager" sur n'importe quel deck ou objectif ASCENT
→ Génère URL unique : scy_forge.app/shared/{uuid}
→ Destinataire voit le contenu en lecture seule (pas de révision, pas d'édition)
→ Bouton "Copier ce deck dans mon espace" (si destinataire a un compte)
→ Permissions : owner | link_only (lecture) | public (indexé)
→ Expiration optionnelle (7j / 30j / Jamais)
Délai implémentation : 2-3 jours dev
```

**Schéma BDD :**
```sql
CREATE TABLE scy_deck_shares (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  resource_type TEXT NOT NULL CHECK (resource_type IN ('deck','goal','document')),
  resource_id UUID NOT NULL,
  owner_id UUID NOT NULL REFERENCES scy_users(id),
  share_token TEXT UNIQUE NOT NULL,        -- Token URL unique
  visibility TEXT NOT NULL DEFAULT 'link_only', -- 'link_only' | 'public'
  allow_fork BOOLEAN DEFAULT true,         -- Autoriser copie dans espace perso
  view_count INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  expires_at INTEGER NULL                  -- NULL = jamais
);
CREATE INDEX idx_deck_shares_token ON scy_deck_shares(share_token);
```

#### Niveau 2 — Marketplace de Decks (Phase 3) ✅

**Description** : Repository public de decks/parcours partagés par la communauté. Moteur de croissance via network effects et SEO.

```
Features Marketplace :
✅ Décks/parcours "public" listables avec métadonnées (auteur, domaine, rating, nb forks)
✅ Recherche full-text (Tantivy existant)
✅ Fork → Copier en propriété personnelle (0 co-édition)
✅ Rating 1-5 étoiles + commentaires texte
✅ Catégories : Tech, Business, Académique, Langues, Sciences, Arts

Moteurs de croissance :
→ Network effect : plus de decks publics = plus d'utilisateurs attirés
→ SEO : "best React flashcards" → trafic organique
→ Viral loop : trouver deck → fork → améliorer → partager
→ User-generated content : 0 coût création contenu pour SCY Forge

Condition de lancement : >50 decks publics de qualité (seuil critique UX)
→ Phase 3 prototype côté équipe SCY Forge, Phase 4 lancement public
```

#### Niveau 3 — Commentaires Asynchrones (Phase 3)

Alternative légère à la co-édition temps-réel (CRDT écarté §14) :
- ✅ Commentaires/suggestions sur décks partagés
- ✅ Asynchrone (pas de WebSocket)
- ✅ Résout 80% du besoin collaboration avec 10% de la complexité CRDT

#### Niveau 4 — Sessions Groupe Live (Phase 3+ — User Research Requis)

**Stratégie décisionnelle** :
- Phase 3 : User research "Voulez-vous étudier ensemble en live ?" (survey in-app)
- IF 30%+ répondent oui → Phase 4 prototype WebSocket basique
- IF <5% → Backlog indéfini

---

### 7.8 Module SCY-IMPRINT — Transfert Cognitif Hybride & L'Empreinte Vocabulaire

**Description** : Premier système d'acquisition cognitif hybride (numérique $\rightarrow$ physique) du marché, alliant la distillation progressive sur 5 crans et l'écriture manuscrite intentionnelle pour graver définitivement les concepts complexes en mémoire à long terme.

**Déclenchement automatique** (Agent-04 LEARNING-CONDUCTOR) :
- Après 3 succès consécutifs sur un concept.
- SMI du concept $> 75\%$ pour la première fois.
- Fin d'un nœud complexe (complexity $\ge 4$).

**Composants du Système IMPRINT :**

#### A. CRE (Cognitive Register Engine) — 5 Crans Adaptatifs :
- Cran 1 : 200-300 mots (compression initiale).
- Cran 2 : 150-200 mots (élimination des redondances).
- Cran 3 : 100-120 mots (focus sur les insights).
- Cran 4 : 70-85 mots (noyau cognitif pur).
- Cran 5 : 50-65 mots (cristallisation finale, 5 à 7 insights).

#### B. Garniture Engine & Tree Renderer :
- **Garniture Engine** : Extraction de 5 à 7 insights essentiels (Miller's Law 7±2 chunks).
- **Tree Renderer** : Génération d'un arbre ASCII conceptuel reproductible manuscrit (max 3 niveaux, $< 5$ mots par nœud).

#### C. L'Empreinte Vocabulaire (IMPRINT Linguistics — NOUVELLE FEATURE v2.5) 🔴 CRITIQUE :
Pour le domaine de l'apprentissage linguistique et l'enrichissement intellectuel de l'apprenant, IMPRINT déploie un module de **mémorisation de vocabulaire d'élite** (10 mots complexes, rares et hautement stratégiques sélectionnés par l'IA) :
- **Le Protocole** : L'apprenant se voit présenter un lot de 10 mots essentiels choisis pour leur pertinence académique et leur complexité (ex: *Sérendipité*, *Éphémère*, *Sycophante*).
- **Fiche Étymologique Interactive** : Chaque mot s'accompagne de sa prononciation phonétique, de son étymologie historique détaillée (générée par la chaîne DELTA), et de sa définition précise.
- **Ancrage par Écriture Manuscrite (Friction Intentionnelle)** : Pour graver le mot en mémoire, l'apprenant doit dessiner et recopier dans son carnet physique l'arbre de dérivation étymologique généré par le `Tree Renderer` (reliant le mot à ses 3 synonymes et à sa phrase d'exemple contextuelle fournie par `GAMMA-3`).
- **Validation Active** : Le passage au mot suivant est verrouillé tant que l'apprenant n'a pas tapé de mémoire le synonyme exact ou complété le Cloze d'usage (Loi L4 du rappel actif).

#### D. Modal IMPRINT :
Friction intentionnelle stricte (interdiction de copier-coller, interdiction de télécharger le texte, case à cocher obligatoire : *"J'ai écrit à la main dans mon carnet"*).

**Fondation scientifique** : Mueller & Oppenheimer 2014 (l'écriture manuscrite surpasse le clavier pour l'intégration conceptuelle), Miller's Law, Effet de Génération, FSRS spacing.

### 7.9 Module Export Multi-Formats — 9 Formats

| Format | Technologie | Coût token | Features clés |
|--------|------------|------------|--------------|
| PDF | typst 0.11 + typst-pdf | ~500 tokens | Layout pro, TOC auto, PDF/A |
| DOCX | docx 0.4 | ~200 tokens | Éditable Word, styles |
| HTML | tera 1.x | ~100 tokens | CSS embedded, dark mode, responsive |
| Markdown | Native Rust | 0 tokens | GFM, frontmatter YAML |
| LaTeX | Templates + tera | ~200 tokens | BibTeX, formules, templates académiques |
| Anki .apkg | zip 2.1 + rusqlite | ~300 tokens | FSRS params, médias bundling |
| Excel .xlsx | rust_xlsxwriter | 0 tokens | Multi-onglets, formules |
| ZIP | zip 2.1 | 0 tokens | Bundle complet avec README |
| Notion CSV | csv 1.x | 0 tokens | Import-ready Notion Database |

### 7.10 Module Intégrations — 11 Services

**Tier 1 — MVP :**
- **Notion** : notion-client 0.9, OAuth, import/export bidirectionnel
- **Obsidian** : notify 6.x + pulldown-cmark 0.13, sync vault, wikilinks → graph
- **Anki** : zip 2.1 + rusqlite 0.31, import SM-2 + export FSRS .apkg
- **Readwise** : reqwest HTTP, sync différentiel, highlights → flashcards auto
- **Zotero** : OAuth 2.0, bibliothèque académique, annotations PDF

**Tier 2 — Post-MVP :**
- **Logseq** : Stack Obsidian réutilisée 70%, format outline
- **Evernote** : quick-xml 0.36, parser .enex, ENML → texte
- **Roam Research** : serde_json, blocs récursifs, références `[[Page]]`

**Formats Universels :**
- **PDF** : Stack 3 niveaux (pdf_oxide + pdfplumber + lopdf)
- **CSV** : csv 1.x, flashcards Anki/Quizlet
- **EPUB** : epub 2.x, chapitres + TOC + metadata Dublin Core

### 7.11 Module UX/UI — Features Interface

**Dashboard Accueil (D-003)** :
- Quick Actions Cards : Ajouter source, Réviser cartes, Continuer roadmap, BRAIN search
- Stats Widget : Cartes révisées/objectif, SMI moyen, streak, prochaine révision
- Activity Feed : Sources ingérées, concepts appris, milestones achievements
- AI Recommendations : Suggestions ASCENT-ORCHESTRATOR contextuelles

**Tags Hiérarchiques 3 Niveaux (D-001)** :
- Structure : Tech > Web > React (drill-down)
- Auto-suggestion ML (clustering sémantique)
- Multi-sélection AND/OR, drag & drop réorganisation

**Auto-Save Drafts (D-012)** :
- Dual storage : localStorage + PostgreSQL
- Debounce 2s, offline support, sync background, conflict resolution LWW

**Search Globale** : Hybrid Tantivy + pgvector, autocomplete 300ms, facets (source, tags, date, SMI)

**Notifications** :
- Types : Cards dues, Milestone, Ingestion, Erreur, Drift
- Channels : In-app toast, Push browser, Email optionnel
- Préférences granulaires

**Theme Dark/Light** : localStorage, system sync, smooth transition 200ms, WCAG AA both modes

**Keyboard Shortcuts** : Ctrl+K search, Ctrl+N source, Ctrl+R révision, 1-4 APEX feedback

**Responsive Design** : Mobile <600px, Tablet 600-900px, Desktop >900px

**Accessibility WCAG 2.1 AA** : Keyboard 100%, Screen readers ARIA, Contraste ≥4.5:1, Focus 2px

### 7.12 Module Infrastructure & Sécurité

**Sécurité** :
- JWT (access 1h, refresh 30j httpOnly) + OAuth Google/GitHub
- Rate Limiting : 10 ingestions/h Free, 100/h Premium
- Row Level Security (RLS) PostgreSQL — isolation native
- HTTPS/WSS TLS 1.3 + HSTS + CSP
- keyring 2.0 Desktop (OS keychain AES-256)
- Input validation : serde schemas (Rust) + Zod (TypeScript)
- SQL Injection : Parameterized queries uniquement
- GDPR : Export données, Delete Account cascade, Event Sourcing audit trail

**Plateformes :**
- Desktop : Electron 33 + Sidecar Rust + SQLite WAL (offline-first)
- Web : React 18 SPA, Vercel CDN, ISR, OAuth social
- Mobile : PWA Phase 0-1 (0 coût dev additionnel) → React Native hybride Phase 2+ (>5K users mobiles)

---

### 7.13 Module SCY-READER SUITE — Lecture Enrichie & Compréhension Immersive `[Rôle : Frontend & AI]`

**Phase** : File Viewer MVP Phase 0 | Web Viewer + Book Orchestrator Phase 1 | Reader Suite + Page Gallery Phase 2  
**Document référence** : SPEC-READER-SUITE-V1  
**Position pipeline** : Couche de consommation des fichiers (sources ingérées + fichiers générés NEURON-CHAINS)

```
SCY-READER SUITE — 4 Composants
├── FILE VIEWER          → Lire les fichiers sources ingérés (PDF, EPUB, MD, etc.)
├── WEB VIEWER           → Prévisualiser les fichiers GÉNÉRÉS par SCY Forge (read-only)
├── READER SUITE         → Comprendre en profondeur les fichiers générés (enrichissement IA)
├── BOOK ORCHESTRATOR    → Agent IA : 1 question de clarification → expérience optimale
└── PAGE GALLERY         → Aperçu visuel rapide de toutes les pages du document
```

---

#### 7.13.1 FILE VIEWER — Lecteur Natif Complet

**Description** : Lecteur intégré SCY Forge pour tous les formats d'ingestion, enrichi par les résumés et visualisations IA. Ce n'est pas un aperçu — c'est un lecteur complet, fidèle, navigable.

**Formats supportés :**

| Format | Technologie Frontend | Fonctionnalités |
|--------|---------------------|----------------|
| **PDF** | `@react-pdf-viewer/core` (PDF.js) | Navigation page, zoom, rotation, recherche full-text, annotations |
| **EPUB** | `epubjs` | Chapitres, TOC, typographie configurable, mode nuit |
| **Markdown** | `react-markdown` + `rehype-highlight` | GFM, code highlight, tables, images |
| **DOCX** | `mammoth.js` (DOCX→HTML) | Conversion fidèle styles Word |
| **HTML** | iframe sandboxé + DOMPurify | Rendu complet sécurisé |
| **TXT** | `<pre>` natif + coloration | Lecture simple, recherche |
| **LaTeX** | KaTeX + MathJax | Formules mathématiques rendues |
| **Jupyter (.ipynb)** | nbviewer adapté | Cellules code + output + markdown |
| **CSV / Excel** | `react-data-grid` | Tableau paginé, tri, filtre |
| **PPTX / Slides** | `reveal.js` | Navigation slides, mode présentateur |

**Layout File Viewer — Interface 3 panneaux :**

```
┌──────────────┬────────────────────────────────┬──────────────────────────┐
│  NAVIGATION  │      LECTEUR PRINCIPAL         │   ENRICHISSEMENT IA      │
│              │   (rendu fidèle + scrolling)   │                          │
│ 📋 TOC       │                                │ 📖 Résumé chapitre       │
│ 🔖 Signets  │   [CONTENU NATIF DU FICHIER]   │    (100-200 mots, pré-   │
│ 📝 Notes    │                                │     généré ingestion)    │
│ 🔍 Recherche │                                │ 💡 Concepts clés (NER)   │
│              │                                │    [SMI par concept]     │
│              │   [◀ Préc] Page X/N [Suiv ▶] │ 🕸️ Mini COSMOS inline     │
│              │                                │    [graphe chapitre]     │
│              │                                │ 🃏 Cartes APEX liées     │
│              │                                │ [+ Créer carte]          │
│              │                                │ [Ouvrir Reader Suite]    │
└──────────────┴────────────────────────────────┴──────────────────────────┘
```

**Sidebar Droite — Enrichissement IA :**
- ✅ **Résumé chapitre** : Pré-généré à l'ingestion (stocké `scy_chunks.summary`), mis à jour dynamiquement au changement de chapitre. Coût LLM : $0 (déjà calculé).
- ✅ **Concepts clés** : Extraits par GLiNER (NER local, $0). Clic → fiche COSMOS. Indicateur SMI coloré.
- ✅ **Mini COSMOS Inline** : Graphe local centré sur les 5-8 concepts du chapitre (cosmos.gl GPU). Clic → expand plein écran.
- ✅ **Cartes APEX liées** : Via `card.associated_concept` + cosine > 0.75. Bouton "+ Créer carte depuis sélection".
- ✅ **Annotations inline** : Surligner → [Créer carte] [Note] [Définir terme]

**Features lecteur core :**
- ✅ Navigation TOC cliquable, signets, recherche full-text avec surlignade
- ✅ Zoom 50-200% (PDF) / Taille police configurable (EPUB)
- ✅ Mode nuit (sync OS `prefers-color-scheme`)
- ✅ Progression lecture (% document lu, reprise automatique position)
- ✅ Sélection texte → actions contextuelles (Créer carte, Ajouter note, Définir)

---

#### 7.13.2 WEB VIEWER — Prévisualiseur Export (Read-Only)

**Description** : Prévisualiseur strictement read-only pour les fichiers générés par NEURON-CHAINS. Permet de voir le fichier avant de décider quoi en faire.

```
Interface :
┌─────────────────────────────────────────────────────────────────┐
│  📄 [Nom fichier généré]    Score confiance: 91/100 🟢          │
│  ─────────────────────────────────────────────────────────────── │
│  [RENDU COMPLET DU DOCUMENT — READ ONLY — PAS D'INTERACTION]   │
│  ─────────────────────────────────────────────────────────────── │
│  [⬇ PDF] [⬇ DOCX] [⬇ MD]  [📖 Ouvrir dans Reader Suite ▶]    │
└─────────────────────────────────────────────────────────────────┘
```

- ✅ Read-only strict (pas de sélection, pas de copie)
- ✅ Score confiance visible en en-tête (T12 ConfidenceCalc)
- ✅ Boutons téléchargement 9 formats (§7.9 Export existant)
- ✅ Bouton **"Ouvrir dans Reader Suite"** → transition vers §7.13.3
- ✅ Bouton **"Analyser avec Book Orchestrator"** → transition vers §7.13.4

---

#### 7.13.3 READER SUITE — Compréhension Enrichie

**Description** : Environnement de lecture immersive pour les fichiers générés par SCY Forge. Objectif : comprendre un document en profondeur en minimum de temps.

**4 Modes de Lecture :**

| Mode | Panneaux | Description | Usage |
|------|----------|-------------|-------|
| **Focus** | Centre uniquement | Lecture épurée, sans distraction | Lecture profonde |
| **Explore** | 3 panneaux visibles | Enrichissement IA maximal | Compréhension enrichie |
| **Sprint** | Résumés uniquement | Vue rapide 2-5 min | Survol rapide |
| **Review** | Document + APEX alternés | Révision active pendant lecture | Consolidation |

**Fonctionnalités Reader Suite :**

- ✅ **Résumés progressifs** : Par section (tooltip 50 mots au survol TOC) + résumé global "comprendre en 5 min" (bullet points hiérarchiques)
- ✅ **Insights IA contextuels (BRAIN)** : "Ce que vous devez retenir de cette section : [1-3 points clés]" — généré 1 seule fois, stocké en BDD
- ✅ **Graphiques COSMOS intégrés** : 1-3 visualisations sélectionnées par Book Orchestrator, scrollent avec le document
- ✅ **Notes par section** : Zone texte libre avec sauvegarde auto — BRAIN compile en insights consolidés en fin de session
- ✅ **SCY-IMPRINT Inline** : Section IMPRINT dans panneau droit, Cran 5 pré-généré proposé après lecture section clé
- ✅ **Estimation temps** : "12 min de lecture estimées" (word_count) + SMI avant/après estimé
- ✅ **Cartes APEX inline** : Révision rapide 3 cartes sans quitter Reader Suite (recommandation Agent-04 si SMI bas)

---

#### 7.13.4 BOOK ORCHESTRATOR — Agent de Clarification IA 🎭

**Description** : Agent IA qui détermine ce que l'utilisateur veut accomplir avec un document et orchestre les features SCY Forge les plus pertinentes. Une question → une expérience personnalisée.

**Déclenchement** :
- Première ouverture d'un document ingéré
- Bouton "Analyser avec IA" depuis File Viewer ou Web Viewer
- Depuis le Dashboard (liste des documents)

**Flux Orchestrateur :**

```
ÉTAPE 1 — Question de Clarification (UI statique, $0 LLM)
─────────────────────────────────────────────────────────
"Que voulez-vous faire avec [Titre] ?"

🗺️ Vue globale rapide       → Comprendre la structure en 2 min
🔍 Exploration approfondie  → Maîtriser le contenu en profondeur
🎯 Concept spécifique       → Extraire un point précis
🃏 Créer des révisions       → Générer des cartes APEX
📝 Prendre des notes        → Lecture + IMPRINT
⚡ Comprendre rapidement     → Résumé + Page Gallery
🤖 Laisser l'IA décider     → Orchestration automatique optimale

                    ↓
ÉTAPE 2 — Génération Expérience (< 500ms, algorithme Rust)
```

**Matrice Intention → Features Orchestrées (max 3 par intention) :**

| Intention | Feature 1 | Feature 2 | Feature 3 |
|-----------|-----------|-----------|-----------|
| **Vue globale** | Arbre TOC interactif | Mind Map M3 COSMOS | Timeline structure M6 |
| **Exploration** | Concept Map M9 COSMOS | Reader Suite Explore | BRAIN Résumé progressif |
| **Concept précis** | Sous-graphe COSMOS filtré | Cartes APEX du concept | BRAIN Question directe |
| **Créer révisions** | NEURON-CHAINS génération | APEX session immédiate | Teach-Back STUDENT AI |
| **Notes/IMPRINT** | Reader Suite Focus | IMPRINT Inline | Export notes PDF |
| **Comprendre vite** | Page Gallery | Sprint Mode Reader | Résumé global 1 page |
| **IA décide** | Analyse auto structure → 3 modes COSMOS optimaux | | |

**Règles Sélection Automatique ("IA Décide") :**

```rust
pub fn select_cosmos_modes(doc: &DocumentAnalysis) -> Vec<CosmosMode> {
    let mut modes = vec![];
    // Structure hiérarchique → Sunburst (S10)
    if doc.structure == Hierarchical && doc.chapter_count > 5 { modes.push(S10); }
    // Beaucoup de concepts → Concept Map (M9)
    if doc.concept_count > 20 { modes.push(M9); }
    // Document chronologique → Timeline (M6)
    if doc.has_timeline_markers { modes.push(M6); }
    // SMI bas → Radar lacunes (M7)
    if doc.user_smi_avg < 50.0 { modes.push(M7); }
    // Réseau dense → Knowledge Graph (M0)
    if doc.relation_count > 50 { modes.push(M0); }
    modes.truncate(3); // Maximum 3 modes
    modes
}
```

**Coût LLM Book Orchestrator :**
```
Question clarification     : $0.00 (UI statique)
Analyse structure document : $0.00 (algorithme Rust)
Sélection modes COSMOS      : $0.00 (règles déterministes)
Résumé global si demandé   : $0.002 (1 appel LLM, cacheable)
TOTAL                      : ~$0.002 max (souvent $0.00)
```

---

#### 7.13.5 PAGE GALLERY — Aperçu Visuel Rapide

**Description** : Vue miniatures de toutes les pages du document généré, permettant de scanner visuellement l'intégralité du contenu en quelques secondes. Analogie : feuilleter rapidement un livre physique.

```
Interface Page Gallery :
┌─────────────────────────────────────────────────────────────────┐
│  PAGE GALLERY — [Titre]  [20 pages]  [4 colonnes ▾] [Compact ▾]│
├─────────────────────────────────────────────────────────────────┤
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐       │
│  │  p.1 │ │  p.2 │ │  p.3 │ │  p.4 │ │  p.5 │ │  p.6 │       │
│  │[img] │ │[img] │ │[img] │ │[img] │ │[img] │ │[img] │       │
│  │Intro │ │Partie│ │ 1.1  │ │Exo 1 │ │ ...  │ │ ...  │       │
│  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘       │
│  Hover → tooltip titre section | Clic → ouvre Web Viewer page  │
├─────────────────────────────────────────────────────────────────┤
│  [Ouvrir Reader Suite ▶]  [Télécharger PDF]  [Book Orchestrator]│
└─────────────────────────────────────────────────────────────────┘
```

**Modes d'affichage :**
| Mode | Colonnes | Taille | Usage |
|------|----------|--------|-------|
| Large | 3 | 180×250px | Lecture détaillée |
| Normal | 4-5 | 130×180px | Standard |
| Compact | 6-8 | 90×125px | Scan rapide |
| Strip | 1 horizontal | Panoramique | Tactile |

**Génération miniatures :** PDF.js `renderPage()` → canvas → WebP 80% (côté client, $0)  
**Performance :** Virtual scroll `@tanstack/react-virtual` (déjà §6.2), lazy génération pages visibles + 2 suivantes, cache localStorage 24h.

---

#### 7.13.6 Stack Technique Reader Suite

**Nouvelles dépendances Frontend :**
```json
{
  "@react-pdf-viewer/core": "3.x",
  "@react-pdf-viewer/default-layout": "3.x",
  "pdfjs-dist": "4.x",
  "epubjs": "0.3.x",
  "mammoth": "1.x",
  "react-markdown": "9.x",
  "rehype-highlight": "7.x",
  "remark-gfm": "4.x",
  "html2canvas": "1.x",
  "katex": "0.16.x",
  "react-katex": "3.x"
}
```

**Bibliothèques existantes réutilisées :** `@tanstack/react-virtual`, `@cosmograph/cosmos`, `@antv/g6`, `recharts` — aucune duplication.

**Nouveaux endpoints API :**
```
GET  /api/reader/session/{source_id}           → Progression lecture
POST /api/reader/session/{source_id}/position  → Mise à jour position
POST /api/reader/annotations                   → Créer annotation
GET  /api/reader/annotations/{source_id}       → Lister annotations
GET  /api/book-orchestrator/analyze/{doc_id}   → Analyse + suggestions
POST /api/book-orchestrator/orchestrate        → Déclencher orchestration
GET  /api/reader-suite/session/{doc_id}        → Session Reader Suite
POST /api/reader-suite/notes                   → Sauvegarder notes
```

---

#### 7.13.7 Schéma BDD Reader Suite

```sql
-- Sessions File Viewer
CREATE TABLE scy_reader_sessions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  source_id UUID NOT NULL REFERENCES scy_sources(id),
  document_id UUID REFERENCES scy_documents(id),
  last_position JSONB NOT NULL DEFAULT '{}',     -- {page, chapter, scroll_percent}
  total_read_percent REAL DEFAULT 0.0,
  chapters_read TEXT[] DEFAULT '{}',
  time_spent_seconds INTEGER DEFAULT 0,
  opened_at INTEGER NOT NULL,
  last_activity_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL
);

-- Annotations File Viewer (highlights, notes, bookmarks)
CREATE TABLE scy_reader_annotations (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  source_id UUID NOT NULL REFERENCES scy_sources(id),
  annotation_type TEXT NOT NULL CHECK (annotation_type IN (
    'highlight','note','bookmark','card_link','definition'
  )),
  position JSONB NOT NULL,          -- {page, chapter, offset_start, offset_end}
  selected_text TEXT,
  note_content TEXT,
  color TEXT DEFAULT 'yellow',
  card_id UUID REFERENCES scy_apex_cards(id),
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- Historique Book Orchestrator
CREATE TABLE scy_book_orchestrations (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  source_id UUID REFERENCES scy_sources(id),
  document_id UUID REFERENCES scy_documents(id),
  user_intent TEXT NOT NULL,        -- 'global_view','deep_explore','specific_concept',
                                    -- 'create_reviews','take_notes','quick_understand','ai_decides'
  detected_structure TEXT,          -- 'linear','hierarchical','network'
  selected_features JSONB NOT NULL, -- [{feature, params, cosmos_modes}]
  cosmos_modes_suggested TEXT[],     -- Max 3 modes COSMOS
  orchestration_cost_usd REAL DEFAULT 0.0,
  created_at INTEGER NOT NULL
);

-- Sessions Reader Suite
CREATE TABLE scy_reader_suite_sessions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  document_id UUID NOT NULL REFERENCES scy_documents(id),
  read_mode TEXT NOT NULL DEFAULT 'explore', -- 'focus','explore','sprint','review'
  sections_read TEXT[] DEFAULT '{}',
  notes JSONB DEFAULT '[]',         -- [{section_id, content, created_at}]
  imprint_triggered BOOLEAN DEFAULT false,
  smi_before REAL,
  smi_after REAL,
  time_spent_seconds INTEGER DEFAULT 0,
  started_at INTEGER NOT NULL,
  ended_at INTEGER,
  created_at INTEGER NOT NULL
);

-- Page Gallery cache métadonnées
CREATE TABLE scy_page_gallery_cache (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  document_id UUID NOT NULL REFERENCES scy_documents(id),
  page_number INTEGER NOT NULL,
  section_title TEXT,
  thumbnail_storage_path TEXT,      -- Si pré-générée serveur (optionnel)
  created_at INTEGER NOT NULL,
  UNIQUE(document_id, page_number)
);

-- Partage Décks/Parcours (Niveau 1 Collaboration)
CREATE TABLE scy_deck_shares (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  resource_type TEXT NOT NULL CHECK (resource_type IN ('deck','goal','document')),
  resource_id UUID NOT NULL,
  owner_id UUID NOT NULL REFERENCES scy_users(id),
  share_token TEXT UNIQUE NOT NULL,
  visibility TEXT NOT NULL DEFAULT 'link_only',  -- 'link_only' | 'public'
  allow_fork BOOLEAN DEFAULT true,
  view_count INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  expires_at INTEGER NULL
);

-- Index Reader Suite
CREATE INDEX idx_reader_sessions_user ON scy_reader_sessions(user_id, source_id);
CREATE INDEX idx_reader_annotations_source ON scy_reader_annotations(user_id, source_id);
CREATE INDEX idx_book_orchestrations_user ON scy_book_orchestrations(user_id, created_at DESC);
CREATE INDEX idx_reader_suite_sessions_user ON scy_reader_suite_sessions(user_id, document_id);
CREATE INDEX idx_deck_shares_token ON scy_deck_shares(share_token);
CREATE INDEX idx_deck_shares_public ON scy_deck_shares(visibility, resource_type) WHERE visibility = 'public';
```

---

#### 7.13.8 Métriques de Succès Reader Suite

| Métrique | Cible | Mesure |
|---------|-------|--------|
| File Viewer adoption | >40% users ouvrent ≥1 fichier/mois | `scy_reader_sessions` |
| Temps lecture moyen | >8 min/session | `time_spent_seconds` |
| Annotations créées | >2 annotations/session | `scy_reader_annotations` |
| Book Orchestrator usage | >60% après ingestion | `scy_book_orchestrations` |
| Reader Suite → APEX | >30% sessions → révision | Funnel analytics |
| Page Gallery → Reader Suite | >50% Page Gallery → Reader Suite | Funnel analytics |

#### 7.13.9 Phases de Déploiement

| Phase | Composant | Fonctionnalités |
|-------|-----------|----------------|
| **MVP Phase 0** | File Viewer | PDF + MD + TXT, sidebar résumés, TOC navigation |
| **Phase 1** | File Viewer complet | EPUB + DOCX + HTML, annotations, Mini COSMOS sidebar |
| **Phase 1** | Web Viewer | Prévisualisation fichiers générés, bouton Reader Suite |
| **Phase 1** | Book Orchestrator | 7 intentions + orchestration ciblée + "IA décide" |
| **Phase 2** | Reader Suite | 4 modes (Focus/Explore/Sprint/Review), IMPRINT inline |
| **Phase 2** | Page Gallery | Miniatures lazy, 4 modes d'affichage |
| **Phase 3** | File Viewer avancé | Jupyter, PPTX, CSV/Excel interactif |
| **Phase 3** | Peer annotations | Annotations partagées sur décks publics (marketplace) |

---

## 8. Schéma Base de Données Complet `[Rôle : Backend & Data]`

### 8.1 Conventions Obligatoires
- Préfixe : `scy_` (toutes tables)
- IDs : UUID v7 (time-ordered, `gen_uuid_v7()`)
- Timestamps : INTEGER Unix (PAS DATETIME)
- Soft Delete : `deleted_at INTEGER NULL`
- Politique RLS sur toutes tables contenant `user_id`

### 8.2 Tables Core Existantes (PRD V1)

```sql
-- Utilisateurs
CREATE TABLE scy_users (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  email TEXT UNIQUE NOT NULL,
  tier TEXT NOT NULL DEFAULT 'free', -- 'free', 'premium', 'enterprise'
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
);

-- Sources ingérées
CREATE TABLE scy_sources (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  core_type TEXT NOT NULL, -- 'youtube', 'web', 'drive', 'podcast', etc.
  url TEXT NOT NULL,
  content_hash TEXT, -- Déduplication
  title TEXT,
  status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'processing', 'completed', 'failed'
  metadata JSONB, -- Core-specific metadata
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
);

-- Documents extraits
CREATE TABLE scy_documents (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  source_id UUID NOT NULL REFERENCES scy_sources(id),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  summary TEXT,
  json_cognitif JSONB, -- 8 dimensions
  json_cognitif_360 JSONB NULL, -- 12 dimensions EPSILON
  word_count INTEGER,
  processing_time_ms INTEGER,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
);

-- Chunks MapReduce
CREATE TABLE scy_chunks (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  document_id UUID NOT NULL REFERENCES scy_documents(id),
  chunk_index INTEGER NOT NULL,
  content TEXT NOT NULL,
  summary TEXT,
  token_count INTEGER,
  embedding VECTOR(512), -- pgvector
  created_at INTEGER NOT NULL
);

-- Concepts (nœuds COSMOS KG)
CREATE TABLE scy_concepts (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  name TEXT NOT NULL,
  definition TEXT,
  embedding VECTOR(512),
  smi_score REAL DEFAULT 0.0,
  complexity INTEGER CHECK (complexity BETWEEN 1 AND 5),
  domain_tags TEXT[],
  valid_from TIMESTAMP GENERATED ALWAYS AS ROW START, -- Temporal queries
  valid_to TIMESTAMP GENERATED ALWAYS AS ROW END,
  PERIOD FOR SYSTEM_TIME (valid_from, valid_to),
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
) WITH SYSTEM VERSIONING; -- Time-travel DB (Décision-007)

-- Relations concepts (arêtes COSMOS KG)
CREATE TABLE scy_concept_relations (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  source_concept_id UUID NOT NULL REFERENCES scy_concepts(id),
  target_concept_id UUID NOT NULL REFERENCES scy_concepts(id),
  relation_type TEXT NOT NULL, -- 'prerequisite', 'related', 'example_of', 'part_of', 'contradicts'
  weight REAL DEFAULT 1.0,
  auto_generated BOOLEAN DEFAULT false,
  created_at INTEGER NOT NULL,
  UNIQUE(source_concept_id, target_concept_id, relation_type)
);

-- Communities Louvain (clustering ML)
CREATE TABLE scy_concept_communities (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  name TEXT,
  concept_ids UUID[],
  level INTEGER,
  parent_community_id UUID REFERENCES scy_concept_communities(id),
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- Cartes révision APEX
CREATE TABLE scy_apex_cards (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  concept_id UUID REFERENCES scy_concepts(id),
  document_id UUID REFERENCES scy_documents(id),
  card_type TEXT NOT NULL, -- 'definition', 'mcq', 'example', 'analogy', 'application'
  front_content TEXT NOT NULL,
  back_content TEXT NOT NULL,
  mcq_options JSONB NULL,
  fsrs_state JSONB NOT NULL, -- {stability, difficulty, elapsed_days, scheduled_days}
  next_review_at INTEGER NOT NULL,
  total_reviews INTEGER DEFAULT 0,
  total_lapses INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
);

-- Sessions révision APEX
CREATE TABLE scy_apex_sessions (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  started_at INTEGER NOT NULL,
  ended_at INTEGER NULL,
  cards_reviewed INTEGER DEFAULT 0,
  cards_correct INTEGER DEFAULT 0,
  duration_seconds INTEGER,
  session_type TEXT, -- 'micro', 'standard', 'deep', 'marathon'
  created_at INTEGER NOT NULL
);

-- Reviews individuelles (Event Sourcing FSRS)
CREATE TABLE scy_apex_reviews (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  session_id UUID NOT NULL REFERENCES scy_apex_sessions(id),
  card_id UUID NOT NULL REFERENCES scy_apex_cards(id),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  rating TEXT NOT NULL, -- 'again', 'hard', 'good', 'easy'
  elapsed_seconds INTEGER,
  fsrs_state_before JSONB NOT NULL,
  fsrs_state_after JSONB NOT NULL,
  reviewed_at INTEGER NOT NULL
);

-- ASCENT Goals
CREATE TABLE scy_ascent_goals (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  title TEXT NOT NULL, -- Objectif formalisé
  raw_intent TEXT, -- Objectif en langage naturel original
  domain TEXT, -- 'tech', 'business', 'academic', 'spiritual', etc.
  description TEXT,
  scope_hours INTEGER,
  weekly_availability_hours REAL,
  current_level TEXT, -- 'beginner', 'intermediate', 'advanced', 'expert'
  learning_style TEXT, -- 'visual', 'hands-on', 'reading', 'mixed'
  status TEXT NOT NULL DEFAULT 'planning', -- 'planning', 'active', 'completed', 'abandoned'
  completion_percentage REAL DEFAULT 0.0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted_at INTEGER NULL
);

-- ASCENT DAG Nœuds
CREATE TABLE scy_ascent_nodes (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  goal_id UUID NOT NULL REFERENCES scy_ascent_goals(id),
  name TEXT NOT NULL,
  description TEXT,
  complexity INTEGER CHECK (complexity BETWEEN 1 AND 5),
  bloom_level TEXT, -- 'remember', 'understand', 'apply', 'analyze', 'evaluate', 'create'
  estimated_hours REAL,
  status TEXT NOT NULL DEFAULT 'locked', -- 'locked', 'available', 'in_progress', 'completed', 'skipped'
  smi_required REAL DEFAULT 70.0,
  smi_achieved REAL DEFAULT 0.0,
  -- Contenu généré par NEURON-CHAINS
  documents JSONB, -- [{doc_id, doc_type, confidence_score}]
  brain_chunks UUID[],
  learning_objectives TEXT[],
  key_concepts TEXT[],
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- ASCENT DAG Arêtes
CREATE TABLE scy_ascent_edges (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  source_node_id UUID NOT NULL REFERENCES scy_ascent_nodes(id),
  target_node_id UUID NOT NULL REFERENCES scy_ascent_nodes(id),
  dependency_type TEXT NOT NULL DEFAULT 'prerequisite', -- 'prerequisite', 'recommended', 'related'
  weight REAL DEFAULT 1.0,
  created_at INTEGER NOT NULL,
  UNIQUE(source_node_id, target_node_id)
);

-- ASCENT Exercices (Template Gold)
CREATE TABLE scy_ascent_exercises (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  node_id UUID NOT NULL REFERENCES scy_ascent_nodes(id),
  template_gold JSONB NOT NULL, -- {context, question, hint, solution, explanation, next_steps}
  difficulty INTEGER CHECK (difficulty BETWEEN 1 AND 5),
  completed BOOLEAN DEFAULT false,
  attempts INTEGER DEFAULT 0,
  score REAL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- Cache Stats SQLite TTL (Phase 0-1)
CREATE TABLE scy_stats_cache (
  cache_key TEXT PRIMARY KEY,

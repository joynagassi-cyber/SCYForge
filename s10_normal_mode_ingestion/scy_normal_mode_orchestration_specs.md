# 📥 MODE NORMAL (INGESTION-FIRST) — ORCHESTRATION & SPÉCIFICATIONS TECHNIQUES
## Architecture Système de l'Orchestrateur d'Ingestion à la Demande, de l'Agent Déterministe et du "Pack Neural par Défaut" Multi-Output

**Document ID** : SPEC-SCY-NORMAL-MODE-V2.6  
**Date** : 2026-06-12  
**Statut** : 🟢 SPÉCIFICATION TECHNIQUE COMPLÈTE & VALIDÉE  
**Périmètre** : Ingestion, routage, suggestions déterministes, génération par lots par défaut (Multi-Output) et traitement des consignes de formatage utilisateur (Custom Description).  
**Stack de Référence** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de Synthèse APEX) + Insforge PostgreSQL (Data) + Zilliz Cloud Serverless (RAG Vectoriel)

---

## 🧭 Table des Matières
1. [Vision Produit : Le Révolution du Mode Normal (Ingestion-First)](#1-vision)
2. [L'Orchestrateur Multi-Output (NORMAL-MODE-DEFAULT-ORCHESTRATOR)](#2-orchestrator)
3. [L'Agent Déterministe de Suggestions de Livrables (SUGGESTION-DETERMINISTIC-AGENT)](#3-suggestion-agent)
4. [La Consigne de Sortie Utilisateur (Custom Description Input)](#4-custom-description)
5. [Le "Pack Neural par Défaut" Généré Automatiquement](#5-default-pack)
6. [La Plomberie des 11 Cores d'Ingestion à la Demande](#6-11-cores)
7. [Schéma de Base de Données Unifié & Mappage (Insforge PostgreSQL)](#7-db-schema)
8. [L'Expérience Utilisateur (D-UX) & Allumage Neural Instantané](#8-ux-ignition)
9. [Garde-fous de Sûreté (Harmonist) & Télémétrie (Langfuse)](#9-safety)

---

## 1. Vision Produit : Le Révolution du Mode Normal (Ingestion-First) {#1-vision}

Alors que le **Mode Ascendant (ASCENT)** est une machine d'apprentissage structurée à long terme guidée par un objectif de certification (avec génération de DAG, de nodes de cours et de jalons temporels), le **Mode Normal** est conçu comme un outil de productivité immédiat, à la demande, axé sur **l'ingestion d'informations brutes et sa transformation instantanée en livrables exploitables**.

Pour maximiser la valeur perçue dès les 10 premières secondes (TTFV < 10s), le Mode Normal élimine la friction de configuration en introduisant :
- **Le Pack Neural par Défaut (Génération automatique multi-output)** : Dès l'ingestion d'une source, le système génère en tâche de fond une panoplie complète de ressources d'apprentissage et de synthèse avant même que l'utilisateur n'ait à exprimer une demande spécifique.
- **L'Agent Déterministe de Suggestions** : Analyse mécaniquement la nature de la source pour proposer exactement trois types de documents pertinents complémentaires à rédiger.
- **La Consigne Libre (Custom Description)** : Permet à l'utilisateur d'orienter finement le format ou le ton du document généré sur-mesure pour s'adapter à ses besoins métiers ("Je veux une checklist au format Markdown pour ingénieur DevOps", "Fais-en un comparatif financier en tableau").

---

## 2. L'Orchestrateur Multi-Output (NORMAL-MODE-DEFAULT-ORCHESTRATOR) {#2-orchestrator}

Le **NORMAL-MODE-DEFAULT-ORCHESTRATOR** s'exécute sur le backend Mastra TypeScript (Zeabur). Il supervise le cycle de vie de l'ingestion d'un document ou d'un lot de documents et coordonne de manière parallèle les appels vers le moteur Rust et les APIs d'ingestion.

```
                  [ SOURCE DE L'UTILISATEUR (Fichier, URL, Ticker...) ]
                                          │
                                          ▼
                [ PHASE 1 : INGESTION & PARSING PAR LES 11 CORES ]
                     Conversion instantanée en Markdown (Docling)
                                          │
                                          ▼
                  [ PHASE 2 : INDEXATION VECTORIELLE ET GRAPHE ]
               Stockage sémantique Zilliz et Graphe temporel Graphiti
                                          │
                                          ▼
               [ PHASE 3 : EVALUATION PAR L'AGENT DÉTERMINISTE ]
                   Sélection automatique de 3 livrables pertinents
                                          │
         ┌────────────────────────────────┴────────────────────────────────┐
         ▼ (Appels Parallèles Tokio / Rust APEX-AGENT : PACK NEURAL PAR DÉFAUT)
   ┌──────────────┐       ┌──────────────┐       ┌──────────────┐       ┌──────────────┐
   │  3 Documents │       │ 1 Visu COSMOS │       │ 1 Deck APEX  │       │ 1 IMPRINT V2 │
   │  Suggérés    │       │ (Tree/Concept│       │ (Flashcards  │       │ Pareto       │
   │  Rédigés     │       │  / Sunburst) │       │   FSRS 5.0)  │       │ Primer       │
   └──────┬───────┘       └──────┬───────┘       └──────┬───────┘       └──────┬───────┘
          │                      │                      │                      │
          └──────────────────────┼──────────────────────┘                      │
                                 ▼
         [ PORTAIL DE SÛRETÉ (Harmonist) & RENDU DANS L'UI PREMIUM ]
            (L'utilisateur explore le Pack et peut ensuite itérer en 
             saisissant une description courte personnalisée de sortie)
```

---

## 3. L'Agent Déterministe de Suggestions de Livrables (SUGGESTION-DETERMINISTIC-AGENT) {#3-suggestion-agent}

Pour éviter le coût d'un appel d'agent LLM probabiliste et garantir des temps de réponse instantanés (<5ms), SCY Forge intègre un **Agent Déterministe de Suggestion** (`AGENT-14 : DET-SUGGESTER`).

Cet agent prend en entrée les métadonnées de la source ingérée (par exemple : extension de fichier, type de Core d'ingestion, longueur, présence de blocs de code, structures financières, équations mathématiques LaTeX) et applique des règles déterministes strictes pour sélectionner **exactement 3 types de documents pertinents** parmi notre référentiel de formats de production :

### Matrice de Décision Déterministe :

| Profil Sémantique de la Source | Critère Technique Majeur | Suggestion #1 | Suggestion #2 | Suggestion #3 |
|--------------------------------|---------------------------|---------------|---------------|---------------|
| **Code / Répertoire logiciel** | Fichiers d'extensions `.rs`, `.ts`, `.json` etc. ou ingestion **Repomix**. | `G01` Manual de Developer Onboarding | `C01` Fiche de Référence d'APIs | `W01` Audit de Sûreté d'Architecture |
| **Papiers Académiques** | Provenance de l'**Academic Core** ou présence de DOI / Équations LaTeX. | `S01` Résumé Analytique Structuré | `G02` Dérivations des Formules Mathématiques | `W02` Synthèse Critique Critique de Littérature |
| **Vidéos & Podcasts** | Ingestion via **YouTube** ou **Podcast Cores** avec timestamps. | `S02` Synthèse Chronologique par Chapitres | `C02` Aide-Mémoire des Actions Clés | `G03` Guide d'Exploitation Technique |
| **Données Financières** | Provenance du **Financial Core** ou présence de chiffres denses. | `R01` Analyse Comparative des Performances | `S03` Briefing de Synthèse de Direction | `E01` Matrice des Risques & Opportunités |
| **Articles / Actus Web** | Ingestion via **Web/Article Core** ou **Twitter Core**. | `W03` Fiche de Veille Technologique Active | `C03` Glossaire de Terminologies Clés | `S01` Résumé Analytique Court |
| **Général par défaut** | Autres cas non classifiés. | `S01` Résumé Analytique Structuré | `C01` Cheat Sheet / Aide-mémoire | `G03` Guide d'Exploitation Technique |

```typescript
// backend_ts/src/normal_pipeline/agents/deterministicSuggester.ts
export interface SourceMetadata {
  coreType: string;
  hasCode: boolean;
  hasMath: boolean;
  hasFinance: boolean;
  contentLength: number;
}

export interface SuggestedDeliverable {
  code: string;
  name: string;
  description: string;
}

export class SuggestionDeterministicAgent {
  public suggest(meta: SourceMetadata): SuggestedDeliverable[] {
    if (meta.coreType === 'youtube' || meta.coreType === 'podcast') {
      return [
        { code: 'S02', name: 'Synthèse Chronologique par Chapitres', description: 'Reconstitution chronologique basée sur les chapitres temporels.' },
        { code: 'C02', name: 'Aide-Mémoire des Actions Clés', description: 'Checklist opérationnelle des actions concrètes mentionnées.' },
        { code: 'G03', name: "Guide d'Exploitation Technique", description: 'Manuel d\'application pratique étape par étape.' }
      ];
    }
    
    if (meta.hasCode || meta.coreType === 'repomix') {
      return [
        { code: 'G01', name: 'Manuel de Developer Onboarding', description: 'Explication globale de l\'architecture, du setup et des patterns.' },
        { code: 'C01', name: 'Fiche de Référence d\'APIs', description: 'Cheat sheet des méthodes, paramètres et exemples d\'appels.' },
        { code: 'W01', name: 'Audit de Sûreté d\'Architecture', description: 'Analyse des forces, faiblesses et des points de blocages potentiels.' }
      ];
    }

    if (meta.coreType === 'academic' || meta.hasMath) {
      return [
        { code: 'S01', name: 'Résumé Analytique Structuré', description: 'Synthèse rigoureuse de la méthodologie, des résultats et limites.' },
        { code: 'G02', name: 'Dérivations des Formules Mathématiques', description: 'Fiche d\'explication étape par étape de toutes les formules.' },
        { code: 'W02', name: 'Synthèse Critique de Littérature', description: 'Contextualisation du document par rapport aux connaissances établies.' }
      ];
    }

    if (meta.coreType === 'financial' || meta.hasFinance) {
      return [
        { code: 'R01', name: 'Analyse Comparative des Performances', description: 'Rapprochement des données chiffrées clés.' },
        { code: 'S03', name: 'Briefing de Synthèse de Direction', description: 'Note d\'information concise axée sur le ROI et l\'EBITDA.' },
        { code: 'E01', name: 'Matrice des Risques & Opportunités', description: 'Analyse SWOT financière déduite des rapports.' }
      ];
    }

    // Par défaut : Article Web ou divers
    return [
      { code: 'W03', name: 'Fiche de Veille Technologique Active', description: 'Fiche condensée pour l\'intégration en entreprise.' },
      { code: 'C03', name: 'Glossaire de Terminologies Clés', description: 'Définitions bioniques des concepts techniques introduits.' },
      { code: 'S01', name: 'Résumé Analytique Structuré', description: 'Synthèse structurée et actionnable du document.' }
    ];
  }
}
```

---

## 4. La Consigne de Sortie Utilisateur (Custom Description Input) {#4-custom-description}

Une fois le **Pack Neural par Défaut** généré, l'utilisateur a la possibilité de prendre le contrôle total de la génération pour l'itérer en fournissant une **courte description personnalisée de sortie** (ex: *"Je souhaite que ce résumé soit formaté sous forme de questions-réponses adaptées pour une FAQ de support client, avec un ton très chaleureux"*).

Cette consigne est capturée par le frontend React et envoyée à l'APEX-AGENT de la Neuro-Chain Rust. L'outil `StyleEnforcer (T14)` l'intègre dynamiquement dans le système de prompt de la Neuron-Chain choisie :

```rust
// backend_rust/src/neurochain/tools/style_enforcer.rs
pub struct StyleEnforcer;

impl StyleEnforcer {
    pub fn enforce_custom_instructions(
        base_prompt: &str, 
        custom_description: &str
    ) -> String {
        if custom_description.is_empty() {
            return base_prompt.to_string();
        }
        
        format!(
            "{}\n\n\
            === INSTRUCTION STRICTE DE FORMATAGE UTILISATEUR ===\n\
            L'utilisateur exige le respect absolu de la consigne de style/format de sortie suivante :\n\
            \"{}\"\n\
            Modifie la structure, le ton et le format de ton document pour honorer scrupuleusement cette demande.\n\
            ====================================================",
            base_prompt,
            custom_description
        )
    }
}
```

---

## 5. Le "Pack Neural par Défaut" Généré Automatiquement {#5-default-pack}

Au lieu d'attendre passivement une action de l'utilisateur, l'orchestrateur lance, dès la fin de l'ingestion, un job de traitement parallèle asynchrone pour produire le **Pack Neural par Défaut** :

1. **Les 3 Documents Suggestionnels** :
   Rédigés de manière concurrente en Rust par l'**APEX-AGENT** à l'aide de la Neuron-Chain activée (par exemple, *Alpha*, *Gamma* ou *Eta*) en injectant le contexte RAG compressé par `PromptCompressor (T07)`.
2. **Le Deck de Cartes APEX** :
   Un lot de 10 à 15 flashcards sémantiques (cloze-tests, définitions, derivations étymologiques) calculées à partir des concepts-clés et prêtes à être mémorisées dans le système **APEX/FSRS 5.0**.
3. **Une Visualisation Interactive COSMOS** :
   Un graphe de concepts sémantiques complet formaté en JSON. Le système choisit automatiquement le mode de rendu de **COSMOS v4** le plus adapté (TreeMap si données hiérarchiques, Novakian Concept Map si relations complexes, Sunburst si données segmentées chronologiquement).
4. **La Note d'Amorçage Cognitif IMPRINT v2** :
   Une fiche d'amorçage Pareto identifiant les 20% de concepts cardinaux à recopier manuellement pour armer le cerveau du lecteur avant de lire les documents complets.

Ces livrables sont sauvés sous forme d'entrées distinctes dans la table `scy_project_deliverables` avec un statut `pending` puis `completed` à mesure de la complétion des threads de génération Rust.

---

## 6. La Plomberie des 11 Cores d'Ingestion à la Demande {#6-11-cores}

L'ingestion se déroule selon la spécification de plomberie détaillée au paragraphe 3 du document d'ingénierie initial (`SPEC-SCY-NORMAL-MODE-V2.5`). 

Le parsing s'appuie sur le microservice **Docling** (IBM/Mozilla Docker) pour la conversion sémantique des documents textuels complexes, sur **Scrapling** pour la capture de pages web adaptatives, et sur **Whisper** pour l'extraction textuelle des flux multimédias (YouTube, TikTok, Podcasts).

---

## 7. Schéma de Base de Données Unifié & Mappage (Insforge PostgreSQL) {#7-db-schema}

Le schéma relationnel d'**Insforge PostgreSQL** s'enrichit pour supporter la description personnalisée, la journalisation des suggestions de l'agent déterministe et le statut de traitement par lots du Pack par Défaut :

```sql
-- == EXTENSION DU SCHÉMA BDD POUR LE MODE NORMAL ==

-- Projets d'Ingestion
CREATE TABLE scy_projects (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES scy_users(id),
    title           TEXT NOT NULL,
    description     TEXT,
    created_at      INTEGER NOT NULL,
    updated_at      INTEGER NOT NULL
);

-- Table des Sources d'Ingestion
CREATE TABLE scy_project_sources (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    project_id      UUID NOT NULL REFERENCES scy_projects(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES scy_users(id),
    core_type       TEXT NOT NULL,        -- 'youtube', 'web', 'academic', 'repomix'...
    source_title    TEXT NOT NULL,
    raw_input       TEXT NOT NULL,        -- URL, Chemin local ou Cloud ID
    parsed_content  TEXT NOT NULL,        -- Markdown structuré extrait par Docling
    metadata        JSONB,                -- Métadonnées de parsing (durée, hashtags, DOI, code_blocks)
    created_at      INTEGER NOT NULL
);

-- Table des Suggestions Déterministes de l'Agent-14
CREATE TABLE scy_project_suggestions (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    project_id      UUID NOT NULL REFERENCES scy_projects(id) ON DELETE CASCADE,
    suggested_code  TEXT NOT NULL,        -- 'G01', 'S01', 'C01'...
    suggested_name  TEXT NOT NULL,
    why_suggested   TEXT NOT NULL,        -- Justification déterministe de la matrice
    created_at      INTEGER NOT NULL
);

-- Table des Livrables du Pack par Défaut & Custom
CREATE TABLE scy_project_deliverables (
    id                  UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    project_id          UUID NOT NULL REFERENCES scy_projects(id) ON DELETE CASCADE,
    user_id             UUID NOT NULL REFERENCES scy_users(id),
    deliverable_type    TEXT NOT NULL,    -- 'suggested_doc', 'custom_doc', 'apex_cards', 'cosmos_map', 'imprint_primer'
    document_code       TEXT,             -- 'G01', 'S01', 'C01' si applicable (si suggested_doc ou custom_doc)
    title               TEXT NOT NULL,
    content             TEXT,             -- Contenu Markdown rédigé par APEX-AGENT (Rust)
    visualization_data  JSONB,            -- JSON du graphe de concepts pour COSMOS v4
    user_custom_description TEXT,         -- Consigne libre fournie par l'utilisateur (NULL si généré par défaut)
    
    -- Status & Sûreté
    status              TEXT NOT NULL DEFAULT 'pending', -- 'pending' | 'generating' | 'completed' | 'failed'
    confidence_score    INTEGER,          -- Score anti-hallucination par section (scy_confidence_reports)
    created_at          INTEGER NOT NULL,
    completed_at        INTEGER
);

-- Index pour accélérer le rendu des loteries de livrables
CREATE INDEX idx_proj_suggestions ON scy_project_suggestions(project_id);
CREATE INDEX idx_proj_deliverables_status ON scy_project_deliverables(project_id, status);
```

---

## 8. L'Expérience Utilisateur (D-UX) & Allumage Neural Instantané {#8-ux-ignition}

Le traitement simultané des livrables du **Pack par Défaut** bénéficie de la cinématique Premium de **L'Allumage Neural (The Neural Ignition Reveal)** :

```
[ ÉTAPE 1 — CONSTELLATION WEBGL (T+0s à T+2s) ]
  L'utilisateur glisse un fichier. Une grille tridimensionnelle de particules s'allume 
  en bleu nuit spatial (#0D0D15). Des flux de signaux parcourent les liaisons.

[ ÉTAPE 2 — ÉTINCELLE DES HUBS (T+2s à T+3s) ]
  L'Ingestion est complétée. L'Agent Déterministe dresse instantanément les 3 suggestions. 
  Les 3 hubs d'affichages jaillissent et s'éclairent en Ambre impérial (#D97706).

[ ÉTAPE 3 — CONDENSATION DES KNOWLEDGE CARDS (T+3s à T+6s) ]
  Les cartes de documents, le TreeMap COSMOS et le deck d'APEX se matérialisent avec 
  un Shimmer localisé de chargement, masquant les latences de rédaction de la Neuro-Chain Rust.

[ ÉTAPE 4 — STABILISATION & TRANSITION DU FLOU (T+6s) ]
  Le Shimmer s'estompe. Les labels et formules mathématiques LaTeX (compilés par KaTeX local) 
  passent d'un flou gaussien artistique à une netteté cristalline à 60 FPS sans clignotement.
```

### Le Panneau de Commande de Personnalisation :
À côté des onglets de consultation du Pack par Défaut se trouve un champ d'action rapide intitulé :  
⚡ **"Régénérer et Personnaliser"** :
* Un champ textuel épuré (place-holder : *"Décris en quelques mots le format ou le ton attendu..."*).
* Un menu déroulant permettant d'imposer un modèle LLM spécifique ou un ton via `ModelRouter (T05)` et `ToneSelector (T02)` de la Neuro-Chain.
* Au clic sur **"Générer"**, l'UI applique une transition cinématique glissante et déclenche de manière synchrone la rédaction sur-mesure d'un nouveau document `custom_doc` intégrant la consigne.

---

## 9. Garde-fous de Sûreté (Harmonist) & Télémétrie (Langfuse) {#9-safety}

Bien que le traitement s'effectue par lots, la charge de calcul et les coûts associés sont scrupuleusement maîtrisés pour conserver une tarification d'infrastructure à **0$** :

1. **Vérification d'Ancrage Factuel Double-Check (Rust DELTA)** :  
   Chaque document structuré du Pack par Défaut est validé en continu par l'outil `FactChecker (T11)` en Rust avant son inscription dans `scy_project_deliverables`. Si des contradictions ou hallucinations sont identifiées, l'APEX-AGENT ré-écrit le paragraphe déficient en tâche de fond de manière transparente.
2. **Contrôle d'Erreur de Schéma Géométrique COSMOS (TypeScript Harmonist)** :  
   La structure du graphe sémantique générée pour COSMOS est validée à l'aide de **Zod** par `AGENT-12` (VISUAL-CRITIC) au sein de la machine de traitement Mastra. Si la structure JSON présente un cycle incohérent, Harmonist rejette la transaction et déclenche un auto-retry ciblé, immunisant l'UI React contre tout bug visuel.
3. **Mousse Anti-Bruit & Cache Sémantique** :  
   Pour éviter de lancer 3 rédactions de documents distincts sur des sources volumineuses déjà traitées, la table `scy_llm_cache_meta` intercepte les requêtes de l'APEX-AGENT. Si un document équivalent existe, le système effectue une copie immédiate en base de données relationnelle en moins de 5ms avec 0 appel LLM et **0$ de dépenses**.
4. **Télémétrie de Coûts par Projet (Langfuse)** :  
   Chaque token d'input compressé par LLMLingua-2 et chaque token d'output généré par la Neuro-Chain pour le Pack par Défaut est consigné dans le tableau de bord d'observabilité open-core **Langfuse**, permettant à l'administrateur d'avoir un cockpit de rentabilité en direct.

---

## 🏁 Conclusion

Cette extension de spécification pour le **Mode Normal** dote SCY Forge d'une arme de productivité d'une puissance absolue. En combinant la vitesse instantanée de **l'Agent Déterministe**, la force de calcul parallèle du **Pack par Défaut (Multi-Output)**, et la flexibilité de la **Consigne Personnalisée (Custom Description)**, SCY Forge s'impose comme le compilateur de connaissances le plus performant du marché, tout en préservant une intégrité d'apprentissage de grade neuro-ergonomique.

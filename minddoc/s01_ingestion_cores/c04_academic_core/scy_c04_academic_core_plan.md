<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-C04-ACADEMIC-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_ACADEMIC_PLAN  
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
 [Fichier PDF / Lien arXiv] ──► [Mastra TS Ingestion Orchestrator]
                                              │
                    ┌─────────────────────────┴─────────────────────────┐
                    ▼                                                   ▼
       [Miss: Appel Docker Sidecar]                       [Extraction DOI & Références]
       [Conteneur Docling (Northflank)]                       [Regex Parser sur 2 premières pages]
                    │                                                   │
                    ▼                                                   ▼
       [Parsing structurel complet]                       [Requête API Crossref/Semantic Scholar]
       [Extraction KaTeX & Markdown]                                    │
                    │                                                   ▼
                    │                                     [Enrichissement des Métadonnées]
                    │                                     [Titre, Auteurs, Conf, Abstract]
                    │                                                   │
                    └─────────────────────────┬─────────────────────────┘
                                              ▼
                        [Vérification scy_shared_content_cache]
                                              │
                                              ▼
                        [Écriture PostgreSQL Table scy_project_sources]
                                              │
                                              ▼
                        [Création des arêtes de type CITES dans]
                        [       scy_cosmos_mindgraph_edges     ]
```

---

## 2. Dépendances Techniques Strictes
* **Environnement Serveur** :
  - **Docker Sidecar Docling** : Image `quay.io/sds_sandbox/docling:latest` configurée pour s'exécuter localement sur Northflank.
  - **Rust Core (Axum)** : Traitement rapide des expressions régulières de DOI et extraction de citations.
* **Packages Node.js (Mastra TS)** :
  - `@mastra/core` pour l'orchestration du workflow d'ingestion.
  - `zod` pour la validation stricte des schémas de réponse de Crossref et Semantic Scholar.
  - `arxiv-api` ou intégration HTTP directe pour la récupération des preprints d'arXiv.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/academicCore.ts`** : Fichier principal de l'orchestrateur de l'ingestion académique.
- **`backend_rust/src/ingestion/doi_resolver.rs`** : Moteur Rust de détection et de validation de regex DOI.
- **`scy_project_sources`** : Stockage du contenu Markdown extrait de l'article avec ses métadonnées résolues.
- **`scy_cosmos_mindgraph_edges`** : Table de stockage des relations de citation (`source_node_id` -> `target_node_id` avec type `CITES`).
- **`scy_shared_content_cache`** : Mise en cache des DOI résolus pour éviter des requêtes HTTP redondantes vers les APIs externes.

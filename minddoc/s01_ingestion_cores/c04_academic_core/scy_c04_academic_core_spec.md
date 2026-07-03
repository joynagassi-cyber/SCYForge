<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📥 SCY-C04-ACADEMIC-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_ACADEMIC_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin WHEN-THEN-AND) + Norme RFC 2119  

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

## 1. Purpose
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion Académique (`c04_academic_core`)** de SCY Forge. Le système doit être capable de traiter des publications scientifiques sous format PDF, d'extraire de façon fiable leurs métadonnées sémantiques, d'identifier et résoudre leurs identifiants DOIs (Digital Object Identifiers), et de cartographier leur graphe de citations pour modéliser le réseau de dépendances intellectuelles dans COSMOS.

---

## 2. Tech Stack & Dependencies
* **Framework d'Orchestration** : Mastra TypeScript (Orchestration des pipelines)
* **Moteur d'Extraction & Traitement** : Rust Axum (Moteur de calcul ultra-rapide)
* **Dépendances d'Extraction Physique** : **Docling** (Exécuté dans un conteneur sidecar Docker sur Northflank pour le parsing structurel des PDFs)
* **APIs de Résolution de Métadonnées (Fallback asynchrone gratuit)** : Crossref API, Semantic Scholar API, arXiv API (0$ Coût).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement: Ingestion de PDF Scientifique & Extraction Structurelle

#### Scénario : Traitement structurel d'un PDF via le sidecar Docling
- **GIVEN** Un fichier PDF académique ou un lien arXiv valide soumis par l'utilisateur.
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` initie le processus d'ingestion.
- **THEN** le système SHALL pousser le document PDF vers le conteneur sidecar local **Docling**.
- **AND** le conteneur Docling MUST parser la structure logique du PDF (sections, tableaux, formules LaTeX, figures).
- **AND** le système SHALL restituer le document sous forme de Markdown sémantique enrichi avec les notations mathématiques au format KaTeX propre (ex. `$E = mc^2$`).
- **AND** le système SHALL stocker ce Markdown nettoyé dans la table `scy_project_sources`.

---

### Requirement: Résolution de DOIs et Identification de Métadonnées

#### Scénario : Détection de DOI et enrichissement sémantique via Crossref / arXiv
- **GIVEN** Un document académique en cours d'ingestion.
- **WHEN** Le système analyse le texte pour extraire les métadonnées.
- **THEN** le système SHALL exécuter une expression régulière robuste pour identifier tout DOI (Digital Object Identifier) ou identifiant arXiv présent dans les 2 premières pages.
- **AND** si un DOI valide est extrait, le système SHALL interroger de manière asynchrone l'API ouverte de **Crossref** ou de **Semantic Scholar** pour récupérer l'enregistrement officiel : titre exact, liste complète des auteurs, date de publication précise, journal ou conférence, et abstract de l'éditeur.
- **AND** le système SHALL NOT faire échouer le pipeline complet si l'API externe est indisponible ou s'il y a un timeout réseau; le système SHALL alors utiliser le titre et les auteurs extraits directement par Docling.

---

### Requirement: Cartographie et Extraction du Graphe de Citations

#### Scénario : Construction des liens sémantiques de citation
- **GIVEN** Un papier académique traité avec succès.
- **WHEN** Les références bibliographiques du document sont extraites par le parseur de références de Docling.
- **THEN** le système SHALL tenter d'associer chaque référence identifiée à son DOI respectif.
- **AND** le système SHALL insérer chaque relation de citation sous forme d'arêtes dirigées dans la table `scy_cosmos_mindgraph_edges` reliant le nœud du document courant à ses documents référencés (nœuds cibles).
- **AND** le système SHALL s'assurer que si un nœud de document cité n'existe pas encore dans le système, un nœud squelette contenant les métadonnées de base est créé de manière transitoire.
- **AND** le système SHALL marquer l'arête sémantique avec le type relationnel `CITES` afin de permettre une visualisation de cascade de dépendances dans COSMOS.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Exécuter des appels de traitement et d'extraction de PDFs volumineux de manière synchrone sur le thread principal de l'UI. Tout traitement de PDF par Docling doit être asynchrone via la file `scy_sync_queue`.
* 🚫 **SHALL NOT** : Utiliser des services d'extraction de métadonnées ou de PDF payants (comme MathPix ou d'autres APIs commerciales). Tout doit s'exécuter localement sur le CPU du serveur ou via des APIs académiques gratuites.
* 🚫 **MANDATORY** : Filtrer et neutraliser tout script malveillant présent dans les métadonnées récupérées des APIs publiques avant de les sérialiser dans PostgreSQL.

---

## 5. Test cases & Validation
* **Test Case 1 (Happy Path - PDF avec DOI)** : Soumettre un PDF d'article d'intelligence artificielle avec un DOI valide. Valider que le Markdown final contient les équations KaTeX formatées, que le DOI est extrait et que les métadonnées récupérées sur Crossref écrasent le texte extrait par OCR avec un score de précision de 100%.
* **Test Case 2 (No DOI fallback)** : Soumettre un rapport de recherche informel ou un "preprint" sans DOI. S'assurer que le système extrait correctement le titre et les auteurs depuis la première page à l'aide de Docling, et qu'il crée le document dans `scy_project_sources` sans lever d'erreur bloquante.
* **Test Case 3 (Citation Mapping)** : Vérifier que l'extraction des références génère les arêtes de type `CITES` correspondantes dans `scy_cosmos_mindgraph_edges` et que la centralité s'ajuste dans COSMOS-MINDGRAPH.

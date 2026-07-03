<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-C04-ACADEMIC-CORE — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S01_INGESTION_ACADEMIC_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

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

## 1. Scénarios de Validation Unitaires

### 🧪 Test 1.1 : Validation du Pipeline d'Extraction Docling
* **Pré-conditions** : Le conteneur sidecar Docker de Docling est démarré et accessible sur `http://localhost:5001`.
* **Input** : Un fichier PDF d'exemple scientifique standard (`sample_paper.pdf`).
* **Règle d'Exécution** : Appeler la fonction `parsePdfWithDocling(fileBuffer)`.
* **Post-conditions (Attendu)** :
  - Le texte renvoyé est une chaîne Markdown valide contenant des balises de section H1/H2.
  - Les expressions mathématiques complexes sont préservées sous forme de blocs de texte compatibles avec KaTeX.
  - La structure des tableaux est correctement traduite au format Markdown.

### 🧪 Test 1.2 : Résilience du Résolveur de DOI et Mode Dégradé
* **Pré-conditions** : L'API de Crossref est simulée comme hors-ligne (timeout simulé de 3 secondes).
* **Input** : Un document avec un DOI valide `"10.1145/3038912.3052569"`.
* **Règle d'Exécution** : Appeler `resolveDoiMetadata()`.
* **Post-conditions (Attendu)** :
  - L'interception de l'erreur réseau s'effectue sans faire planter le pipeline d'ingestion.
  - Le système bascule en mode dégradé en utilisant les métadonnées textuelles locales extraites par Docling (titre et auteurs auto-détectés).
  - L'ingestion se termine avec le statut `processed_with_local_metadata`.

### 🧪 Test 1.3 : Extraction et Dé-duplication du Graphe de Citations
* **Pré-conditions** : Une arête de type `CITES` reliant le document `doc-A` au document `doc-B` existe déjà dans `scy_cosmos_mindgraph_edges`.
* **Input** : Ré-ingestion du document `doc-A` dont la section Références cite à nouveau `doc-B`.
* **Règle d'Exécution** : Appeler `buildCitationGraph()`.
* **Post-conditions (Attendu)** :
  - L'insertion SQL intercepte le doublon via une clause `ON CONFLICT DO NOTHING`.
  - Aucune erreur de clé primaire ou de contrainte d'unicité n'est levée.
  - Le graphe COSMOS-MINDGRAPH reste stable et cohérent.

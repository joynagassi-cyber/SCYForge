<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-EPUB-CORE — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S01_INGESTION_EPUB_TESTS  
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

### 🧪 Test 12.1 : Métadonnées & Conversion (Happy Path)
* **Pré-conditions** : Fichier `.epub` valide (ex : livre du domaine public).
* **Input** : Chemin du fichier EPUB.
* **Règle d'Exécution** : Appeler `ingestEpub(path)`.
* **Post-conditions (Attendu)** :
  - Les métadonnées (titre, auteur, langue) sont extraites de l'OPF.
  - Les chapitres Markdown sont produits dans l'ordre du spine.
  - Le score DRACO est ≥ 85/100.

### 🧪 Test 12.2 : Reconstruction de la TOC
* **Pré-conditions** : EPUB avec TOC multi-niveaux.
* **Input** : Chemin du fichier EPUB.
* **Règle d'Exécution** : Appeler `parseToc(path)`.
* **Post-conditions (Attendu)** :
  - La hiérarchie des chapitres est reconstruite avec le bon ordre.
  - Chaque entrée est mappée vers le bon document XHTML.

### 🧪 Test 12.3 : Extraction des Médias
* **Pré-conditions** : EPUB avec couverture et illustrations.
* **Input** : Chemin du fichier EPUB.
* **Règle d'Exécution** : Appeler `extractMedia(path)`.
* **Post-conditions (Attendu)** :
  - La couverture et les illustrations sont extraites.
  - Chaque image est référencée dans le chapitre Markdown correspondant.

### 🧪 Test 12.4 : Dé-duplication par Hash
* **Pré-conditions** : Un EPUB (hash `sha256:abc...`) déjà indexé dans `mfg_shared_content_cache`.
* **Input** : Nouvelle ingestion du même fichier (hash identique).
* **Règle d'Exécution** : Appeler `ingestEpub(path)`.
* **Post-conditions (Attendu)** :
  - Le fichier est sauté sans re-parsing.
  - Zéro coût CPU.

### 🧪 Test 12.5 : Rejet d'un EPUB DRM
* **Pré-conditions** : Fichier EPUB protégé par DRM Adobe.
* **Input** : Chemin du fichier EPUB DRM.
* **Règle d'Exécution** : Appeler `ingestEpub(path)`.
* **Post-conditions (Attendu)** :
  - Le système détecte `META-INF/encryption.xml`.
  - Le code `EPUB_DRM_PROTECTED` est renvoyé sans tentative de contournement.

### 🧪 Test 12.6 : Rejet d'un Fichier Invalide
* **Pré-conditions** : Un fichier non-EPUB renommé `.epub`.
* **Input** : Chemin du fichier corrompu.
* **Règle d'Exécution** : Appeler `ingestEpub(path)`.
* **Post-conditions (Attendu)** :
  - Le système renvoie le code `INVALID_EPUB`.
  - Aucune exception non gérée n'est levée.

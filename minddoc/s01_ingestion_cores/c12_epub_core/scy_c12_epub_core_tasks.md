<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-EPUB-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_EPUB_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

Chaque tâche est conçue pour être codée en 15 à 30 minutes de manière unitaire et testable par nos agents de développement.

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

## 🧭 Liste des Tâches de Production

### 🚀 Tâche 12.1 : Coder l'Ouverture EPUB + Détection DRM (Durée : 25 min)
* **Description** : Coder l'ouverture de l'EPUB via la crate `epub`, la détection du DRM (présence de `META-INF/encryption.xml`), et l'extraction des métadonnées OPF Dublin Core via `quick-xml`.
* **Fichier de destination** : `backend_rs/src/cores/epub/opener.rs`
* **Critère de Succès** : Un EPUB valide renvoie les métadonnées (titre, auteur, langue) ; un EPUB DRM renvoie `Err(EpubDrmProtected)` ; un fichier corrompu renvoie `Err(InvalidEpub)`.

### 🚀 Tâche 12.2 : Coder le Parsing de la Table des Matières (Durée : 25 min)
* **Description** : Coder le parsing de la TOC (NCX pour EPUB 2, NAV pour EPUB 3), la reconstruction de la hiérarchie des chapitres (titres + ordre + ancres) et le mapping vers les documents XHTML.
* **Fichier de destination** : `backend_rs/src/cores/epub/toc.rs`
* **Critère de Succès** : La TOC reconstruite reflète la hiérarchie des chapitres avec le bon ordre et les bonnes ancres XHTML.

### 🚀 Tâche 12.3 : Coder la Conversion XHTML → Markdown Chapitré (Durée : 30 min)
* **Description** : Coder le parcours du spine (ordre officiel), la conversion de chaque XHTML en Markdown via `dom_smoothie`, et la segmentation par chapitre selon la TOC.
* **Fichier de destination** : `backend_rs/src/cores/epub/chapter_converter.rs`
* **Critère de Succès** : Un EPUB de 5 chapitres produit 5 sections Markdown ordonnées, score DRACO ≥ 85/100.

### 🚀 Tâche 12.4 : Coder l'Extraction des Médias (Durée : 20 min)
* **Description** : Coder l'extraction des images de l'archive (couverture, illustrations) et leur association à la position dans le chapitre, avec références locales dans le Markdown.
* **Fichier de destination** : `backend_rs/src/cores/epub/media.rs`
* **Critère de Succès** : La couverture et les illustrations sont extraites et référencées correctement dans les chapitres Markdown.

### 🚀 Tâche 12.5 : Coder la Dé-duplication + Enqueue SAGA (Durée : 15 min)
* **Description** : Implémenter la comparaison du hash SHA-256 du fichier avec `mfg_shared_content_cache` et l'enqueue des tâches asynchrones dans `mfg_sync_queue` pour la conversion de gros EPUB.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/epubCore.ts`
* **Critère de Succès** : Un EPUB identique (même hash) est sauté ; un gros EPUB déclenche des tâches asynchrones par chapitre.

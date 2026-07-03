<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-SCIENCE-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_SCIENCE_TASKS  
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

### 🚀 Tâche 9.1 : Coder le Client arXiv (Métadonnées + Rate Limiting) (Durée : 25 min)
* **Description** : Implémenter le client `reqwest` qui interroge `export.arxiv.org/api/query?id_list={id}`, parse l'Atom XML via `quick-xml` (titre, auteurs, abstract, catégories, DOI), et applique le rate limiting arXiv (1 req / 3 s) avec `User-Agent`.
* **Fichier de destination** : `backend_rs/src/cores/science/arxiv_client.rs`
* **Critère de Succès** : Un identifiant arXiv valide renvoie un objet métadonnées complet ; un ID invalide renvoie `Err(ArxivNotFound)`.

### 🚀 Tâche 9.2 : Coder l'Extraction LaTeX Native (Source) (Durée : 30 min)
* **Description** : Coder le téléchargement du tarball `e-print/{id}`, sa décompression sécurisée (`flate2` + `tar`, avec seuil anti-bombe), la localisation du `.tex` principal et le parsing du texte + formules LaTeX natives.
* **Fichier de destination** : `backend_rs/src/cores/science/latex_extractor.rs`
* **Critère de Succès** : Un article avec source produit un Markdown avec formules `$$...$$` préservées exactement, score DRACO ≥ 88/100.

### 🚀 Tâche 9.3 : Coder le Fallback PDF (Docling) (Durée : 30 min)
* **Description** : Coder le téléchargement du PDF `pdf/{id}.pdf` et son traitement via Docling (texte + formules MathML + figures), avec signalement de confiance réduite (vs LaTeX natif) dans le score DRACO.
* **Fichier de destination** : `backend_rs/src/cores/science/pdf_fallback.rs`
* **Critère de Succès** : Un article sans source LaTeX est ingéré via PDF avec formules converties et score DRACO réduit annoté.

### 🚀 Tâche 9.4 : Coder l'Extraction Figures + Légendes + Tableaux (Durée : 25 min)
* **Description** : Coder l'extraction des figures (avec légendes `\caption{}`) et des tableaux de données depuis la source LaTeX ou via Docling, et leur conversion en références Markdown + tableaux.
* **Fichier de destination** : `backend_rs/src/cores/science/figures.rs`
* **Critère de Succès** : Les figures sont extraites avec légendes associées ; les tableaux sont convertis en Markdown.

### 🚀 Tâche 9.5 : Coder la Dé-duplication + Enqueue SAGA (Durée : 20 min)
* **Description** : Implémenter la comparaison `arxiv_id` + `version` avec `mfg_shared_content_cache`, la détection de nouvelle version, et l'enqueue des tâches asynchrones dans `mfg_sync_queue`.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/scienceCore.ts`
* **Critère de Succès** : Un article déjà à jour (même version) est sauté ; une nouvelle version (v1 → v2) déclenche une ré-ingestion.

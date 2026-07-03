<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-WEB-ARTICLE-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_WEB_TASKS  
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

### 🚀 Tâche 1.1 : Interfaçage avec le Microservice Scrapling (Durée : 20 min)
* **Description** : Coder l'appel HTTP REST POST vers l'instance locale Scrapling sous Docker pour récupérer le HTML d'une URL de site protégé.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/scraplingClient.ts`
* **Critères de Succès** : L'appel renvoie le code source HTML brut et le statut HTTP 200 en moins de 3 secondes sur Medium.

### 🚀 Tâche 1.2 : Coder le Filtre de Nettoyage DOM Smoothie (Durée : 25 min)
* **Description** : Coder la logique d'interfaçage avec `@mozilla/readability` pour analyser le HTML brut, identifier l'article principal et purger l'intégralité du superflu.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/domSmoothie.ts`
* **Critères de Succès** : Le retour d'appel extrait uniquement le corps d'article utile et le titre, rejetant les menus et bannières.

### 🚀 Tâche 1.3 : Sécurisation Anti-XSS et Extraction OpenGraph (Durée : 20 min)
* **Description** : Coder le nettoyeur sémantique d'AST HTML via `dompurify` et récupérer les balises OpenGraph pour extraire la vignette et la description de l'article.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/webMetadataSanitizer.ts`
* **Critères de Succès** : L'HTML extrait ne contient aucune balise de type script, et les métadonnées de l'article sont structurées en JSON.

### 🚀 Tâche 1.4 : Conversion en Markdown et Persistance (Durée : 25 min)
* **Description** : Convertir l'HTML assaini en Markdown CommonMark 0.31 propre et l'insérer dans la table relationnelle `scy_project_sources`.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/webArticleCore.ts`
* **Critères de Succès** : L'article est stocké proprement en base de données et l'arête de provenance sémantique est créée dans COSMOS-MINDGRAPH.

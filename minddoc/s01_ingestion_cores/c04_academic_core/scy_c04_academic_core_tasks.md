<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-C04-ACADEMIC-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_ACADEMIC_TASKS  
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

### 🚀 Tâche 1.1 : Setup de l'Intégration du Sidecar Docling (Durée : 25 min)
* **Description** : Coder l'appel HTTP TypeScript de l'adaptateur Mastra vers l'API locale du conteneur sidecar Docker de **Docling** pour convertir un PDF brut en Markdown structurel.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/doclingAdapter.ts`
* **Critère de Succès** : L'envoi d'un flux de PDF échantillon à l'adaptateur renvoie un corps de texte Markdown propre avec des sections structurées (`# Introduction`, etc.) en moins de 3,5 secondes.

### 🚀 Tâche 1.2 : Coder le Détecteur et Résolveur de DOI (Durée : 20 min)
* **Description** : Écrire la fonction de détection par expression régulière de DOI dans le texte extrait, et coder le client HTTP asynchrone interrogeant l'API publique de Crossref ou de Semantic Scholar.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/doiResolver.ts`
* **Critère de Succès** : Soumettre la chaîne `"10.1145/3038912.3052569"` renvoie un objet JSON contenant le titre officiel de l'article, les auteurs et la date de publication correcte.

### 🚀 Tâche 1.3 : Coder le Parseur et Cartographe de Références Bibliographiques (Durée : 30 min)
* **Description** : Implémenter l'analyse de la section "References" ou "Bibliography" du Markdown généré par Docling, extraire les citations et insérer les arêtes correspondantes de type `CITES` dans la base de données.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/citationGraphBuilder.ts`
* **Critère de Succès** : Une liste de 5 références textuelles produit 5 arêtes insérées ou reliées dans `scy_cosmos_mindgraph_edges` sans lever d'exception unique de doublon de clé.

### 🚀 Tâche 1.4 : Orchestrer le Flow Principal Mastra (Durée : 25 min)
* **Description** : Assembler les étapes dans le fichier d'orchestration principal d'ingestion académique de Mastra en gérant la mise en cache sémantique via `scy_shared_content_cache` et l'écriture dans `scy_project_sources`.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/academicCore.ts`
* **Critère de Succès** : L'exécution complète du workflow pour un PDF académique écrit les données structurées et met à jour le cache de manière transparente.

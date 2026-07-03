<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-YOUTUBE-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_YOUTUBE_TASKS  
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

### 🚀 Tâche 1.1 : Setup de l'Adaptateur Local `yt-dlp` (Durée : 20 min)
* **Description** : Coder la fonction Node.js enfant appelant le processus système `yt-dlp` pour extraire le JSON de métadonnées d'une URL de vidéo.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/ytDlpAdapter.ts`
* **Critère de Succès** : L'appel renvoie un objet JSON contenant `title`, `description`, et `thumbnail_url` en moins de 1,5 seconde.

### 🚀 Tâche 1.2 : Coder l'Extracteur de Sous-Titres Officiels (Durée : 25 min)
* **Description** : Coder l'interfaçage avec `youtube-transcript-api` pour télécharger la transcription temporelle dans la langue cible de l'utilisateur.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/transcriptExtractor.ts`
* **Critère de Succès** : L'appel de l'outil extrait un tableau d'objets de type `{text: string, start: number, duration: number}`.

### 🚀 Tâche 1.3 : Coder le Fallback de Transcription de Secours Whisper (Durée : 30 min)
* **Description** : Coder la logique d'extraction de flux audio via `ffmpeg` et d'appel du sidecar Whisper-tiny local en cas d'absence de sous-titres YouTube.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/whisperFallback.ts`
* **Critère de Succès** : La fonction télécharge l'audio, appelle Whisper-tiny CPU et retourne une transcription temporelle formatée en Markdown.

### 🚀 Tâche 1.4 : Intégrer l'Indexation de la Playlist (Durée : 25 min)
* **Description** : Coder la logique récursive d'extraction des IDs de vidéos d'une playlist et leur dé-duplication par rapport au cache sémantique `mfg_shared_content_cache`.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/playlistOrchestrator.ts`
* **Critère de Succès** : La soumission d'une playlist de 5 vidéos crée exactement 5 tâches d'ingestions asynchrones séparées et uniques.

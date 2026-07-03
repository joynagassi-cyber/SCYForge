<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-TIKTOK-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_TIKTOK_TASKS  
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

### 🚀 Tâche 10.1 : Coder le Scraper Scrapling + Extraction JSON Embarqué (Durée : 30 min)
* **Description** : Coder le scraping furtif d'une URL TikTok via Scrapling, l'extraction du JSON embarqué (SIGI_STATE / `_UNIVERSAL_DATA`) et la récupération des métadonnées (auteur, description, hashtags, musique, stats, URL vidéo).
* **Fichier de destination** : `backend_rs/src/cores/tiktok/scraper.rs`
* **Critère de Succès** : Une URL valide renvoie un objet métadonnées complet avec l'URL de la vidéo ; une vidéo supprimée renvoie `Err(TiktokUnavailable)`.

### 🚀 Tâche 10.2 : Coder le Repli Anti-Blocage + Circuit Breaker (Durée : 20 min)
* **Description** : Implémenter la rotation d'en-têtes `User-Agent`, le backoff exponentiel sur blocage, et l'ouverture du Circuit Breaker après N échecs, renvoyant `TIKTOK_BLOCKED`.
* **Fichier de destination** : `backend_rs/src/cores/tiktok/scraper.rs`
* **Critère de Succès** : Un blocage simulé répété déclenche `TIKTOK_BLOCKED` sans boucle infinie.

### 🚀 Tâche 10.3 : Coder le Téléchargement Vidéo + Extraction Audio (Durée : 25 min)
* **Description** : Coder le téléchargement de la vidéo via `yt-dlp` (ou HTTP direct) et l'extraction/conversion de l'audio en WAV 16 kHz mono via `ffmpeg` (`loudnorm`).
* **Fichier de destination** : `backend_rs/src/cores/tiktok/video_download.rs`
* **Critère de Succès** : Une vidéo valide produit un fichier WAV mono 16 kHz de durée correcte.

### 🚀 Tâche 10.4 : Coder la Transcription Whisper + Détection Parole (Durée : 30 min)
* **Description** : Coder l'appel au sidecar Whisper-tiny, la structuration de la transcription en Markdown temporel `[hh:mm:ss]`, et la détection de l'absence de parole (confiance < seuil) menant à l'annotation `audio_non_parlé`.
* **Fichier de destination** : `backend_rs/src/cores/tiktok/transcribe.rs`
* **Critère de Succès** : Une vidéo parlée renvoie un Markdown temporel ; une vidéo musicale renvoie des métadonnées uniquement avec annotation `audio_non_parlé`.

### 🚀 Tâche 10.5 : Coder la Dé-duplication + Enqueue SAGA (Durée : 20 min)
* **Description** : Implémenter la comparaison `video_id` avec `mfg_shared_content_cache` et l'enqueue des tâches asynchrones dans `mfg_sync_queue`.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/tiktokCore.ts`
* **Critère de Succès** : Une vidéo déjà en cache est sautée sans scraping ni transcription.

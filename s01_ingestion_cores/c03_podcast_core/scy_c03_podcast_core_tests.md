# 🧪 SCY-PODCAST-CORE — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S01_INGESTION_PODCAST_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

## 1. Scénarios de Validation Unitaires

### 🧪 Test 3.1 : Parsing RSS & Métadonnées du Show
* **Pré-conditions** : Le serveur dispose de la connectivité réseau et de `feed-rs` opérationnel.
* **Input** : Une URL de flux RSS de podcast publique valide.
* **Règle d'Exécution** : Appeler `parsePodcastFeed()`.
* **Post-conditions (Attendu)** :
  - Le `show_title` extrait est une chaîne non vide.
  - Le tableau `episodes[]` contient au moins un élément.
  - Chaque épisode possède une `enclosure_url`, un `guid` et une `pub_date` au format ISO.

### 🧪 Test 3.2 : Rejet d'un Flux Invalide (Garde de Sécurité)
* **Pré-conditions** : Le worker est opérationnel.
* **Input** : Une URL pointant vers une page HTML classique (non RSS) ou un flux RSS sans `<enclosure>` audio.
* **Règle d'Exécution** : Appeler `parsePodcastFeed()`.
* **Post-conditions (Attendu)** :
  - Le système renvoie une erreur typée `INVALID_PODCAST_FEED`.
  - Aucune ressource de transcription n'est consommée.
  - L'erreur est journalisée avec un Correlation ID et notifiée à l'Agent-07 DRIFT-GUARDIAN.

### 🧪 Test 3.3 : Transcription + Diarization (Happy Path)
* **Pré-conditions** : `ffmpeg`, le sidecar Whisper-tiny et pyannote sont disponibles localement.
* **Input** : Un épisode audio court (~2 min) contenant deux locuteurs.
* **Règle d'Exécution** : Appeler le pipeline complet `transcribeAndDiarize()`.
* **Post-conditions (Attendu)** :
  - Le document produit contient des blocs `[hh:mm:ss] [Speaker N] Texte`.
  - Au moins 2 locuteurs distincts sont identifiés.
  - ≥ 90 % des segments portent une étiquette de locuteur valide après fusion.
  - Le score d'intégrité DRACO est `≥ 85/100`.
  - L'arête sémantique dans COSMOS-MINDGRAPH passe à `status: completed`.

### 🧪 Test 3.4 : Dé-duplication du Cache (Zero-Bleeding Cost)
* **Pré-conditions** : Un épisode (`guid: ep-abc`, `enclosure_sha256: 0x9f...`) est déjà indexé dans `mfg_shared_content_cache`.
* **Input** : Un *show* de 3 épisodes dont `ep-abc`.
* **Règle d'Exécution** : Appeler `ingestShow()`.
* **Post-conditions (Attendu)** :
  - Le système crée des tâches d'ingestion uniquement pour les 2 nouveaux épisodes.
  - `ep-abc` est sauté de manière transparente, évitant tout téléchargement audio, transcription ou dépense CPU.

### 🧪 Test 3.5 : Ingestion depuis une URL Audio Directe
* **Pré-conditions** : Aucun flux RSS fourni.
* **Input** : Une URL directe vers un fichier `.mp3`.
* **Règle d'Exécution** : Appeler le wrapper d'ingestion principal du Core.
* **Post-conditions (Attendu)** :
  - Le système télécharge, convertit et transcrit l'audio.
  - Les métadonnées de *show* sont marquées `absentes` sans échec.
  - La transcription Markdown temporelle est produite normalement.

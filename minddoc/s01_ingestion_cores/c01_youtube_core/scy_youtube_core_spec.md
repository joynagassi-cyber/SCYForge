<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📥 SCY-YOUTUBE-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_YOUTUBE_SPEC  
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
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion YouTube (`c01_youtube_core`)** de SCY Forge. Le système doit être capable d'extraire, de structurer et d'indexer de manière entièrement automatique les métadonnées, chapitres, vignettes et transcriptions temporelles multilingues à partir de liens de vidéos ou de playlists YouTube individuelles.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **Dependencies** : `yt-dlp` (local CLI), `ffmpeg` (local CLI), `google-youtube3` (SDK), `whisper-tiny` (local sidecar).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement: Ingestion de Vidéo Unique & Transcriptions Temporelles

#### Scénario : Extraction des métadonnées et sous-titres officiels
- **GIVEN** Un lien URL de vidéo YouTube valide fourni par l'utilisateur.
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` lance le processus d'ingestion.
- **THEN** le système SHALL appeler l'instance locale de `yt-dlp` pour extraire : le titre, la chaîne, la date de publication, la vignette (thumbnail) et la description.
- **AND** le système SHALL tenter d'extraire les sous-titres officiels rédigés par l'auteur dans la langue d'apprentissage cible de l'utilisateur.
- **AND** le système SHALL structurer la transcription sous forme de blocs Markdown temporels de format `[hh:mm:ss] Texte sémantique`.
- **AND** le système SHALL écrire ces données dans la table `mfg_project_sources`.

#### Scénario : Secours par Transcription Locale (Whisper Fallback)
- **GIVEN** Une vidéo YouTube valide ne possédant **aucun sous-titre officiel ni auto-généré**.
- **WHEN** L'extracteur de sous-titres échoue à récupérer le texte.
- **THEN** le système SHALL télécharger l'audio brut de la vidéo en format MP3 à l'aide de `yt-dlp` et `ffmpeg`.
- **AND** le système MUST pousser cet audio vers la file d'attente locale `mfg_sync_queue` raccordée à notre sidecar **Whisper-tiny** local.
- **AND** le système SHALL NOT bloquer ou geler l'interface utilisateur, affichant un statut `transcribing` dans COSMOS.

---

### Requirement: Ingestion de Playlist Complète

#### Scénario : Extraction récursive et dé-duplication
- **GIVEN** Un lien URL de Playlist YouTube valide.
- **WHEN** L'utilisateur demande l'ingestion de la playlist.
- **THEN** le système SHALL appeler l'API YouTube Data v3 pour lister l'intégralité des identifiants de vidéos de la playlist.
- **AND** le système SHALL comparer chaque identifiant de vidéo avec la table `mfg_shared_content_cache` pour identifier les vidéos déjà indexées.
- **AND** le système SHALL ignorer et ne pas dépenser de jetons ou de CPU sur les vidéos déjà en cache.
- **AND** le système SHALL planifier des tâches d'ingestions d'arrière-plan asynchrones individuelles pour chaque nouvelle vidéo.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Lancer des processus d'ingestions synchrones sur l'API principale qui risquent de dépasser le timeout de 30 secondes. Tout traitement doit être asynchrone (SAGA).
* 🚫 **SHALL NOT** : Appeler des APIs de transcriptions tierces payantes. Toutes les transcriptions de secours doivent être gérées localement à coût nul par notre Whisper local.

---

## 5. Test cases & Validation
* **Test Case 1 (Happy Path)** : Valider qu'un lien URL standard renvoie un document Markdown structuré avec des horodatages `[00:01:23]` propres et un score d'intégrité DRACO $\ge 85/100$.
* **Test Case 2 (No Subtitle)** : Valider que la soumission d'une vidéo muette ou sans aucun sous-titre active la file d'attente Whisper sans planter.

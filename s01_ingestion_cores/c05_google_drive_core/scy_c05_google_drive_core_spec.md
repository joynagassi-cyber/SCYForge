# 💾 SCY-GOOGLE-DRIVE-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_GOOGLE_DRIVE_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion Google Drive (`c05_google_drive_core`)** de SCY Forge. Le système doit être capable, après autorisation OAuth utilisateur via **Composio**, d'énumérer, de télécharger, de convertir en Markdown sémantique et d'indexer le contenu de fichiers ou dossiers Google Drive (Docs, Sheets, Slides, PDF, images, etc.). L'ingestion prend en charge la **synchronisation incrémentale** (détection des modifications) et la **dé-duplication** — à coût d'infrastructure nul pour le parsing (Docling local en Docker).

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **Authentification OAuth** : **Composio** (handshake OAuth 2.0 Google Drive, gestion/rotation des jetons, multi-comptes). `Composio` gère intégralement le cycle de vie du jeton (refresh automatique).
* **API Google Drive** : `google-drive3` (crate Rust) pour l'énumération, le téléchargement et la surveillance des fichiers (`files.list`, `files.get`, `files.export`, `changes.list`).
* **Parsing multi-format** : **Docling** (conteneur Docker local) pour convertir PDF, DOCX, PPTX, XLSX, images (OCR) en Markdown propre. Réutilise `dom_smoothie` pour les exports HTML (Google Docs/Slides exportés en HTML).
* **Nettoyage HTML** : `dom_smoothie` (core `c02_web_article_core`) pour la conversion HTML → Markdown.
* **OCR** : Intégré à Docling (Tesseract / RapidOCR) pour les images et PDF scannés.

> **Rappel anti-hallucination** : tout composant listé ci-dessus est une dépendance réelle et vérifiable. Aucune API de conversion cloud payante n'est autorisée (pas de Google Docs API payante au-delà du quota gratuit).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Authentification OAuth via Composio & Handshake de Session

#### Scénario : Connexion sécurisée multi-comptes
- **GIVEN** Un utilisateur non encore connecté à Google Drive dans SCY Forge.
- **WHEN** L'utilisateur déclenche la connexion Google Drive.
- **THEN** le système SHALL initier le handshake OAuth 2.0 via **Composio** (scope `drive.readonly`).
- **AND** le système SHALL stocker de manière chiffrée le jeton d'accès et le jeton de rafraîchissement associés au compte utilisateur.
- **AND** le système SHALL gérer automatiquement l'expiration et le rafraîchissement du jeton sans intervention utilisateur.
- **AND** le système SHALL isoler strictement chaque compte (Row Level Security PostgreSQL par `user_id`).

#### Scénario : Réauthentification après révocation
- **GIVEN** L'utilisateur a révoqué l'accès Google Drive depuis son compte Google.
- **WHEN** Une opération d'ingestion tente d'utiliser le jeton expiré/révoqué.
- **THEN** le système SHALL détecter l'erreur `401 invalid_grant`.
- **AND** le système SHALL rejeter l'ingestion avec le code `DRIVE_AUTH_REVOKED` et notifier l'utilisateur (reconnexion requise).
- **AND** le système SHALL NOT réessayer indéfiniment (Circuit Breaker par compte).

---

### Requirement : Ingestion d'un Fichier Unique & Conversion Markdown

#### Scénario : Conversion d'un Google Doc / PDF / DOCX
- **GIVEN** Un identifiant de fichier Google Drive (`file_id`) valide et un jeton OAuth actif.
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` lance l'ingestion du fichier.
- **THEN** le système SHALL appeler `google-drive3` pour récupérer les métadonnées (`name`, `mimeType`, `modifiedTime`, `size`).
- **AND** le système SHALL télécharger le contenu natif (pour les fichiers binaires type PDF/DOCX) ou exporter au format approprié (Google Docs → HTML/ODT, Sheets → CSV, Slides → PDF).
- **AND** le système SHALL transmettre le fichier à **Docling** (Docker local) pour conversion en Markdown sémantique (tables, titres, listes, images OCR).
- **AND** le système SHALL nettoyer tout export HTML via `dom_smoothie`.
- **AND** le système SHALL écrire le Markdown, les métadonnées et la position source dans `mfg_project_sources` et indexer les embeddings dans Zilliz.

#### Scénario : OCR d'une image ou PDF scanné
- **GIVEN** Un fichier image (`.png`, `.jpg`) ou un PDF scanné sans couche de texte.
- **WHEN** Docling détecte l'absence de couche de texte extractible.
- **THEN** le système SHALL activer l'OCR intégré à Docling (Tesseract/RapidOCR).
- **AND** le système SHALL produire un Markdown contenant le texte reconnu avec un indicateur de confiance OCR.
- **AND** le système SHALL signaler un score d'intégrité DRACO réduit si la confiance OCR moyenne est `< 0.85`.

---

### Requirement : Ingestion d'un Dossier (Récursif) & Dé-duplication

#### Scénario : Énumération récursive et cache
- **GIVEN** Un identifiant de dossier Google Drive (`folder_id`) valide.
- **WHEN** L'utilisateur demande l'ingestion du dossier.
- **THEN** le système SHALL énumérer récursivement tous les fichiers du dossier et de ses sous-dossiers via `files.list` avec paramètre `q: '<folder_id>' in parents`.
- **AND** le système SHALL comparer chaque `file_id` + `modifiedTime` avec la table `mfg_shared_content_cache`.
- **AND** le système SHALL ignorer les fichiers déjà indexés et non modifiés (même `modifiedTime`).
- **AND** le système SHALL planifier des tâches d'ingestion asynchrones individuelles (file `mfg_sync_queue`) pour chaque fichier nouveau ou modifié.

---

### Requirement : Synchronisation Incrémentale (Watch Changes)

#### Scénario : Détection des modifications
- **GIVEN** Un dossier Google Drive déjà ingéré précédemment.
- **WHEN** Une tâche planifiée (cron) interroge les modifications via `changes.list` (startPageToken conservé).
- **THEN** le système SHALL récupérer la liste delta des fichiers modifiés, créés ou supprimés depuis la dernière synchronisation.
- **AND** le système SHALL déclencher une ré-ingestion uniquement pour les fichiers modifiés (`modifiedTime` changé).
- **AND** le système SHALL marquer comme `stale` (obsolète) les embeddings des fichiers supprimés sans suppression immédiate (rétention configurable).
- **AND** le système SHALL NOT ré-ingérer les fichiers non touchés.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Stocker des jetons OAuth en clair. Tout jeton DOIT être chiffré au repos (AES-256-GCM).
* 🚫 **FORBIDDEN** : Télécharger des fichiers dont la taille dépasse le seuil configuré (ex : 50 Mo par fichier) sans confirmation — protection anti-OOM.
* 🚫 **SHALL NOT** : Appeler des APIs de conversion cloud payantes. Toutes les conversions DOIVENT passer par Docling local.
* 🚫 **SHALL NOT** : Mélanger les données inter-comptes (RLS PostgreSQL strict par `user_id`).
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens définis dans `design.md`.
* ⚠️ **MUST** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (Happy Path Fichier)** : Un `file_id` pointant vers un Google Doc renvoie un Markdown structuré (titres, listes, tables) avec un score DRACO ≥ 85/100.
* **Test Case 2 (OCR)** : Une image de capture d'écran avec texte renvoie un Markdown contenant le texte reconnu et un indicateur de confiance OCR.
* **Test Case 3 (Dé-duplication Dossier)** : Un dossier contenant 5 fichiers dont 2 déjà en cache et non modifiés génère exactement 3 tâches d'ingestion.
* **Test Case 4 (Sync Incrémentale)** : Après modification d'un fichier dans Drive, seule la version modifiée est ré-ingérée ; les autres restent en cache.
* **Test Case 5 (Auth Révoquée)** : Un jeton révoqué déclenche le code `DRIVE_AUTH_REVOKED` sans boucle de réessai infinie.

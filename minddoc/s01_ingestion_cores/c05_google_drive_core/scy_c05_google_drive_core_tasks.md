<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-GOOGLE-DRIVE-CORE — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_GOOGLE_DRIVE_TASKS  
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

### 🚀 Tâche 5.1 : Intégrer le Handshake OAuth Composio (Durée : 30 min)
* **Description** : Coder l'intégration avec Composio pour le handshake OAuth 2.0 Google Drive (scope `drive.readonly`), incluant la génération de l'URL d'autorisation et le rappel (callback).
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/composioOauth.ts`
* **Critère de Succès** : Le flux renvoie une URL d'autorisation valide et, après callback, stocke un jeton chiffré (AES-256-GCM) associé au compte utilisateur.

### 🚀 Tâche 5.2 : Coder le Rafraîchissement & la Détection de Jeton Révoqué (Durée : 20 min)
* **Description** : Implémenter la rotation automatique du jeton (`refresh_token`) et la détection de l'erreur `401 invalid_grant` renvoyant le code `DRIVE_AUTH_REVOKED` avec Circuit Breaker par compte.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/composioOauth.ts`
* **Critère de Succès** : Un jeton expiré est rafraîchi sans intervention ; un jeton révoqué déclenche `DRIVE_AUTH_REVOKED` sans boucle de réessai.

### 🚀 Tâche 5.3 : Coder l'Énumération Récursive de Dossier (Durée : 25 min)
* **Description** : Implémenter l'énumération récursive des fichiers d'un `folder_id` via `google-drive3` (`files.list` avec `q: '<folder_id>' in parents`), en paginant les résultats.
* **Fichier de destination** : `backend_rs/src/cores/gdrive/list.rs`
* **Critère de Succès** : Un dossier de test contenant 10 fichiers répartis sur 2 niveaux renvoie la liste complète des 10 `file_id` avec métadonnées.

### 🚀 Tâche 5.4 : Coder le Téléchargement & l'Export par Type MIME (Durée : 25 min)
* **Description** : Coder la fonction de téléchargement binaire (PDF/DOCX/PPTX) et d'export Google (Docs → HTML, Sheets → CSV, Slides → PDF) selon le `mimeType` du fichier.
* **Fichier de destination** : `backend_rs/src/cores/gdrive/download.rs`
* **Critère de Succès** : Pour chaque type MIME testé, la fonction produit un fichier temporaire du bon format, en respectant le seuil de taille (refus > 50 Mo sans confirmation).

### 🚀 Tâche 5.5 : Intégrer le Pont Docling (Conversion + OCR) (Durée : 30 min)
* **Description** : Coder le client HTTP vers le conteneur Docling local qui reçoit un fichier binaire/HTML et renvoie un Markdown sémantique, avec activation automatique de l'OCR (Tesseract/RapidOCR) pour les images et PDF scannés.
* **Fichier de destination** : `backend_rs/src/cores/gdrive/docling_client.rs`
* **Critère de Succès** : Un PDF de 5 pages renvoie un Markdown avec titres et tables ; une image avec texte renvoie un Markdown OCR avec indicateur de confiance.

### 🚀 Tâche 5.6 : Coder la Dé-duplication Cache + Enqueue SAGA (Durée : 20 min)
* **Description** : Coder la logique de comparaison `file_id` + `modifiedTime` avec `mfg_shared_content_cache` et l'enqueue de tâches asynchrones dans `mfg_sync_queue` pour les fichiers nouveaux ou modifiés.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/googleDriveCore.ts`
* **Critère de Succès** : Un dossier de 5 fichiers dont 2 en cache et non modifiés génère exactement 3 tâches asynchrones.

### 🚀 Tâche 5.7 : Implémenter la Synchronisation Incrémentale (cron) (Durée : 30 min)
* **Description** : Coder la tâche planifiée qui lit `startPageToken` (table `mfg_gdrive_sync_state`), appelle `changes.list`, déclenche les ré-ingestions nécessaires et met à jour le token de page.
* **Fichier de destination** : `backend_rs/src/cores/gdrive/sync.rs`
* **Critère de Succès** : Après modification d'un fichier dans Drive, le prochain cycle cron détecte uniquement ce fichier modifié et marque comme `stale` les embeddings d'un fichier supprimé.

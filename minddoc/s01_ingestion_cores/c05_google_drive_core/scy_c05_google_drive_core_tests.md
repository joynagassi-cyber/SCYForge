<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-GOOGLE-DRIVE-CORE — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S01_INGESTION_GOOGLE_DRIVE_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

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

## 1. Scénarios de Validation Unitaires

### 🧪 Test 5.1 : Handshake OAuth & Chiffrement du Jeton
* **Pré-conditions** : Application Composio configurée avec le scope `drive.readonly`.
* **Input** : Un compte utilisateur déclenchant la connexion Google Drive.
* **Règle d'Exécution** : Appeler `initiateDriveOauth()`.
* **Post-conditions (Attendu)** :
  - Une URL d'autorisation valide est retournée.
  - Après callback, un jeton chiffré (AES-256-GCM) est stocké et associé au `user_id`.
  - Le jeton n'est jamais lisible en clair dans la base (vérification du cipher au repos).

### 🧪 Test 5.2 : Détection de Jeton Révoqué (Circuit Breaker)
* **Pré-conditions** : Un compte dont le jeton a été révoqué côté Google.
* **Input** : Une requête d'ingestion sur ce compte.
* **Règle d'Exécution** : Appeler le worker d'ingestion.
* **Post-conditions (Attendu)** :
  - Le système détecte `401 invalid_grant`.
  - Le code `DRIVE_AUTH_REVOKED` est renvoyé.
  - Le Circuit Breaker s'ouvre pour ce compte (pas de boucle de réessai infinie).
  - L'utilisateur est notifié (reconnexion requise).

### 🧪 Test 5.3 : Conversion Markdown d'un Google Doc (Happy Path)
* **Pré-conditions** : Jeton OAuth actif et Docling opérationnel.
* **Input** : Un `file_id` pointant vers un Google Doc structuré (titres, listes, table).
* **Règle d'Exécution** : Appeler le pipeline complet `ingestDriveFile()`.
* **Post-conditions (Attendu)** :
  - Le document Markdown produit conserve la structure (titres, listes, table).
  - Le score d'intégrité DRACO est ≥ 85/100.
  - Les embeddings sont indexés dans Zilliz.
  - L'arête sémantique COSMOS-MINDGRAPH passe à `status: completed`.

### 🧪 Test 5.4 : OCR d'une Image avec Texte
* **Pré-conditions** : Docling avec OCR activé (Tesseract/RapidOCR).
* **Input** : Un `file_id` pointant vers une image (`.png`) contenant du texte.
* **Règle d'Exécution** : Appeler `ingestDriveFile()`.
* **Post-conditions (Attendu)** :
  - Le Markdown produit contient le texte reconnu.
  - Un indicateur de confiance OCR moyen est fourni.
  - Si confiance < 0.85, le score DRACO est réduit en conséquence.

### 🧪 Test 5.5 : Dé-duplication de Dossier (Zero-Bleeding Cost)
* **Pré-conditions** : Deux fichiers (`file_id: doc-1`, `file_id: doc-2`) déjà indexés dans `mfg_shared_content_cache` avec un `modifiedTime` inchangé.
* **Input** : Un dossier de 5 fichiers contenant `doc-1` et `doc-2`.
* **Règle d'Exécution** : Appeler `ingestDriveFolder()`.
* **Post-conditions (Attendu)** :
  - Le système crée des tâches d'ingestion uniquement pour les 3 nouveaux fichiers.
  - `doc-1` et `doc-2` sont sautés de manière transparente (zéro téléchargement, zéro conversion Docling).

### 🧪 Test 5.6 : Synchronisation Incrémentale
* **Pré-conditions** : Un dossier déjà synchronisé ; `startPageToken` stocké dans `mfg_gdrive_sync_state`.
* **Input** : Modification d'un fichier et suppression d'un autre dans Drive entre deux cycles.
* **Règle d'Exécution** : Appeler `incrementalSync()`.
* **Post-conditions (Attendu)** :
  - Seul le fichier modifié est ré-ingéré (nouveau `modifiedTime`).
  - Les embeddings du fichier supprimé sont marqués `stale` (non supprimés immédiatement).
  - Les fichiers intacts ne déclenchent aucune ingestion.
  - `startPageToken` est mis à jour pour le prochain cycle.

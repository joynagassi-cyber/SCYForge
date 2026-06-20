# 📋 SCY-ANKI-IMPORT-EXPORT — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S01_INGESTION_ANKI_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

Chaque tâche est conçue pour être codée en 15 à 30 minutes de manière unitaire et testable par nos agents de développement.

---

## 🧭 Liste des Tâches de Production

### 🚀 Tâche 13.1 : Coder le Lecteur d'Archive .apkg (Durée : 20 min)
* **Description** : Coder la décompression de l'archive `.apkg` via la crate `zip`, la localisation de la base SQLite (`collection.anki2` ou `anki21`) et la lecture du fichier `media` (JSON mapping).
* **Fichier de destination** : `backend_rs/src/cores/anki/apkg_reader.rs`
* **Critère de Succès** : Un `.apkg` valide est décompressé, la base SQLite localisée et le mapping `media` parsé ; un fichier corrompu renvoie `Err(InvalidApkg)`.

### 🚀 Tâche 13.2 : Coder le Lecteur de Schéma Anki (Durée : 30 min)
* **Description** : Coder l'ouverture de `collection.anki2` via `rusqlite` et le parsing des tables `col` (notetypes + decks en JSON), `notes` (champs séparés par `\x1f`, tags, `mid`) et `cards` (`did`, `ord`, `due`).
* **Fichier de destination** : `backend_rs/src/cores/anki/schema_reader.rs`
* **Critère de Succès** : Pour un paquet de test, les notetypes, notes et cartes sont extraits avec une structure correcte.

### 🚀 Tâche 13.3 : Coder la Conversion Import → Cartes SCY Forge (Durée : 30 min)
* **Description** : Coder la conversion des notes+cards Anki en cartes SCY Forge (Basic/Cloze/custom), le nettoyage HTML via `dom_smoothie` (option), et l'extraction/référencement des médias.
* **Fichier de destination** : `backend_rs/src/cores/anki/importer.rs`
* **Critère de Succès** : Un paquet de 50 cartes Basic produit 50 cartes SCY Forge avec champs et tags ; un paquet Cloze préserve les trous `{{c1::...}}`.

### 🚀 Tâche 13.4 : Coder l'Écrivain .apkg (Export) (Durée : 30 min)
* **Description** : Coder la construction de `collection.anki2` (tables `col`/`notes`/`cards`/`revlog` via `rusqlite`) depuis des cartes SCY Forge, et l'empaquetage zip `.apkg` avec médias.
* **Fichier de destination** : `backend_rs/src/cores/anki/apkg_writer.rs`
* **Critère de Succès** : L'export `.apkg` produit est importable dans Anki Desktop sans erreur (round-trip).

### 🚀 Tâche 13.5 : Coder le Pont FSRS ↔ Anki (Échéances) (Durée : 20 min)
* **Description** : Coder la conversion des échéances FSRS (depuis `s05_apex_retention_system`) en `due` Anki (jour julien) à l'export, et inversement à l'import si préservation de la progression.
* **Fichier de destination** : `backend_rs/src/cores/anki/fsrs_bridge.rs`
* **Critère de Succès** : Une carte FSRS avec échéance J+3 produit un `due` Anki correspondant au bon jour julien.

### 🚀 Tâche 13.6 : Coder la Dé-duplication Import (Durée : 15 min)
* **Description** : Implémenter la comparaison du hash de contenu de chaque note avec `mfg_shared_content_cache` pour ignorer (ou fusionner) les cartes déjà présentes.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/cores/ankiCore.ts`
* **Critère de Succès** : Un import répété du même paquet n'ajoute pas de doublons.

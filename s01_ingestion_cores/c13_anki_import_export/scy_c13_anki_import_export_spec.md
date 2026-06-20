# 🃏 SCY-ANKI-IMPORT-EXPORT — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_ANKI_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 0. Frontière avec s05_apex_retention_system (Complémentarité)
* **`c13_anki_import_export`** (ce document) gère **uniquement la conversion de format Anki** : import de paquets `.apkg` → cartes SCY Forge, et export de cartes SCY Forge → paquet `.apkg`.
* **`s05_apex_retention_system`** gère la **logique métier des flashcards et la planification FSRS** (scheduling, rétention, scoring). Les deux sont complémentaires : c13 traduit, s05 planifie.

---

## 1. Purpose
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Import/Export Anki (`c13_anki_import_export`)** de SCY Forge. Le système doit être capable d'**importer** un paquet Anki `.apkg` (archive ZIP contenant une base SQLite `collection.anki2`/`anki21`) en cartes SCY Forge (notes, champs, tags, paquets), et d'**exporter** les cartes SCY Forge vers un paquet `.apkg` compatible Anki Desktop/Mobile. Opération **bidirectionnelle**, à coût nul (parsing local SQLite + zip).

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **Format `.apkg`** : archive ZIP contenant :
  - `collection.anki2` (ou `collection.anki21` versions récentes) — base de données SQLite.
  - `media` — fichier JSON mappant les indices numériques (0, 1, 2…) aux noms de fichiers média.
  - Fichiers média numérotés (images, audio).
* **Décompression/Compression** : crate `zip` (Rust) pour lire/écrire l'archive `.apkg`.
* **Base SQLite Anki** : `rusqlite` (Rust) pour lire/écrire `collection.anki2`. Schéma Anki officiel :
  - `col` — métadonnées collection (decks, models/notetypes en JSON, dconf).
  - `notes` — `id`, `mid` (modèle), `flds` (champs séparés par `\x1f`), `tags`.
  - `cards` — `id`, `nid` (note), `did` (paquet), `ord` (template), `due`, `type`, `queue`.
  - `revlog` — historique des révisions.
* **Conversion HTML** : `dom_smoothie` pour nettoyer le HTML des champs Anki (Anki stocke souvent le HTML) → Markdown ou conservation HTML selon préférence.

> **Rappel anti-hallucination** : tout composant listé ci-dessus est une dépendance réelle et vérifiable. Le format `.apkg` est publiquement documenté (archive ZIP + SQLite, schéma Anki open-source). Aucune API payante n'est utilisée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Import d'un Paquet Anki (.apkg)

#### Scénario : Extraction et conversion des notes/cartes
- **GIVEN** Un fichier `.apkg` valide fourni par l'utilisateur.
- **WHEN** L'utilisateur demande l'import.
- **THEN** le système SHALL décompresser l'archive `.apkg` via la crate `zip`.
- **AND** le système SHALL localiser et ouvrir la base SQLite (`collection.anki2` ou `anki21`) via `rusqlite`.
- **AND** le système SHALL extraire les notetypes (modèles) depuis la table `col` pour comprendre la structure des champs.
- **AND** le système SHALL extraire les `notes` (séparation des champs par `\x1f`, tags) et les `cards` (paquet `did`, ordre `ord`, échéance `due`).
- **AND** le système SHALL convertir chaque note/carte en carte SCY Forge (recto-verso ou cloze selon le notetype).
- **AND** le système SHALL nettoyer le HTML des champs via `dom_smoothie` (option configurable : Markdown ou HTML préservé).
- **AND** le système SHALL rejeter les fichiers corrompus avec le code `INVALID_APKG`.

#### Scénario : Import des médias
- **GIVEN** Un paquet `.apkg` contenant des fichiers média (images, audio).
- **WHEN** Le système importe le paquet.
- **THEN** le système SHALL lire le fichier `media` (mapping JSON indices → noms).
- **AND** le système SHALL extraire et stocker localement les fichiers média référencés par les cartes.
- **AND** le système SHALL mettre à jour les références média dans les cartes SCY Forge.

---

### Requirement : Export vers un Paquet Anki (.apkg)

#### Scénario : Construction d'un paquet compatible
- **GIVEN** Un ensemble de cartes SCY Forge sélectionnées (avec paquet/deck cible).
- **WHEN** L'utilisateur demande l'export.
- **THEN** le système SHALL créer une base SQLite `collection.anki2` via `rusqlite`.
- **AND** le système SHALL initialiser la table `col` avec les notetypes (modèles Basic/Cloze) et decks correspondants.
- **AND** le système SHALL convertir chaque carte SCY Forge en `note` (champs joints par `\x1f`) et `card` (`did`, `ord`, `due` mappé depuis FSRS si disponible).
- **AND** le système SHALL empaqueter la base + médias + fichier `media` dans une archive `.apkg` via la crate `zip`.
- **AND** le système SHALL produire un fichier `.apkg` importable dans Anki Desktop/Mobile sans erreur.

---

### Requirement : Gestion des Modèles de Cartes (Notetypes)

#### Scénario : Support des types courants
- **GIVEN** Un paquet contenant différents notetypes.
- **WHEN** Le système importe.
- **THEN** le système SHALL reconnaître les notetypes standards : Basic (recto-verso), Basic (and reversed card), Cloze.
- **AND** le système SHALL mapper les notetypes personnalisés vers une structure générique (champs nommés).
- **AND** le système SHALL préserver les templates (recto/verso) pour un rendu correct.

---

### Requirement : Dé-duplication & Synchronisation des Échéances

#### Scénario : Évitement des doublons à l'import
- **GIVEN** Un paquet dont certaines cartes sont déjà présentes dans SCY Forge (même hash de contenu).
- **WHEN** Le système importe.
- **THEN** le système SHALL comparer le hash du contenu de chaque note avec `mfg_shared_content_cache`.
- **AND** le système SHALL ignorer les cartes déjà existantes (ou fusionner selon préférence utilisateur).

#### Scénario : Export des échéances FSRS
- **GIVEN** Des cartes SCY Forge avec historique de révision FSRS.
- **WHEN** Le système exporte vers `.apkg`.
- **THEN** le système SHALL convertir l'échéance FSRS en `due` Anki (jour julien).
- **AND** le système SHALL optionnellement exporter l'historique `revlog` pour préserver la progression.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Décompresser des `.apkg` de taille non bornée (protection anti-bombe zip).
* 🚫 **SHALL NOT** : Perdre des données à l'import — les tags et médias DOIVENT être préservés.
* 🚫 **SHALL NOT** : Produire des `.apkg` incompatibles avec Anki Desktop (respect strict du schéma SQLite Anki).
* 🚫 **MUST NOT** : Modifier la palette de couleurs de l'interface hors des tokens définis dans `design.md`.
* ⚠️ **MUST** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.

---

## 5. Test cases & Validation
* **Test Case 1 (Import)** : Un `.apkg` valide de 50 cartes Basic produit 50 cartes SCY Forge avec champs et tags corrects.
* **Test Case 2 (Cloze)** : Un paquet Cloze est importé avec détection des trous `{{c1::...}}` préservés.
* **Test Case 3 (Médias)** : Les images/audio référencés sont extraits et stockés localement.
* **Test Case 4 (Export)** : Un export `.apkg` est importable dans Anki sans erreur (round-trip).
* **Test Case 5 (Dé-duplication)** : Les cartes déjà existantes sont ignorées à l'import répété.
* **Test Case 6 (Invalide)** : Un fichier corrompu renvoie `INVALID_APKG` sans exception non gérée.

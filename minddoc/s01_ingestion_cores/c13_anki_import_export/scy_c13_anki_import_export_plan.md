<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ANKI-IMPORT-EXPORT — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_ANKI_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

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

## 1. Architecture du Flux de Données — IMPORT

```
 [Fichier .apkg]
       │
       ▼
 [Mastra TS Worker]
       │
       ├──► [Vérification mfg_shared_content_cache (hash contenu)] ──► déjà présent ──► ignorer/fusionner
       │
       └──► [Décompression zip]
                   │
                   ▼
        [Localiser collection.anki2 / .anki21]
        [Lecture fichier media (JSON)]
                   │
                   ▼
        [rusqlite : ouverture SQLite]
                   │
          ┌────────┴────────┐
          ▼                 ▼
   [Table col :            [Table notes : flds (\x1f),
    notetypes + decks]      tags, mid]
          │                 │
          └────────┬────────┘
                   ▼
          [Table cards : did, ord, due]
                   │
                   ▼
        [Conversion notes+cards → cartes SCY Forge]
        [dom_smoothie : HTML → Markdown (option)]
        [Mapping notetypes : Basic / Cloze / custom]
                   │
                   ▼
        [Extraction médias (0,1,2,... → noms via media)]
        [Mise à jour références médias]
                   │
                   ▼
        [Écriture PostgreSQL mfg_project_sources]
        [Indexation vectorielle Zilliz]
```

## 1.bis Architecture du Flux — EXPORT

```
 [Cartes SCY Forge sélectionnées (+ deck cible)]
       │
       ▼
 [Mastra TS Worker]
       │
       ▼
 [Création collection.anki2 (rusqlite)]
       │
       ├──► [Table col : notetypes Basic/Cloze + decks]
       ├──► [Table notes : champs joints par \x1f + tags]
       ├──► [Table cards : did, ord, due (FSRS → jour julien)]
       └──► [Table revlog (optionnel : historique)]
       │
       ▼
 [Empaquetage : collection.anki2 + media + médias → zip .apkg]
       │
       ▼
 [Fichier .apkg téléchargeable, compatible Anki]
```

---

## 2. Dépendances Techniques Strictes
* **Archive** :
  - crate `zip` (lecture/écriture `.apkg`, seuil anti-bombe).
* **Base SQLite Anki** :
  - `rusqlite` (lecture/écriture `collection.anki2` / `anki21`).
  - Schéma Anki officiel : tables `col`, `notes`, `cards`, `revlog`.
* **Conversion** :
  - `dom_smoothie` (HTML champs Anki → Markdown, option configurable).
  - Mapping notetypes : Basic, Basic (reversed), Cloze (`{{c1::...}}`), générique custom.
* **Mapping échéance FSRS → Anki** :
  - Conversion `due` (jour julien Anki) depuis l'échéance FSRS (interaction `s05_apex_retention_system`).
* **Stockage** :
  - PostgreSQL (Northflank) : `mfg_project_sources`, `mfg_shared_content_cache`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/ankiCore.ts`** : Orchestration Mastra TS (import/export, dé-duplication).
- **`backend_rs/src/cores/anki/apkg_reader.rs`** : Décompression `.apkg` + localisation SQLite + lecture `media`.
- **`backend_rs/src/cores/anki/schema_reader.rs`** : Parsing `col`/`notes`/`cards` via `rusqlite` + mapping notetypes.
- **`backend_rs/src/cores/anki/importer.rs`** : Conversion notes+cards → cartes SCY Forge + extraction médias.
- **`backend_rs/src/cores/anki/apkg_writer.rs`** : Construction SQLite `collection.anki2` (col/notes/cards/revlog) + empaquetage zip.
- **`backend_rs/src/cores/anki/fsrs_bridge.rs`** : Conversion échéance FSRS ↔ `due` Anki (jour julien).
- **`mfg_project_sources`** : Stockage des cartes SCY Forge importées.
- **`mfg_shared_content_cache`** : Dé-duplication par hash du contenu de note.

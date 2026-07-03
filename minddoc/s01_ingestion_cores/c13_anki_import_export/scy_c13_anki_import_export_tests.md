<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-ANKI-IMPORT-EXPORT — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S01_INGESTION_ANKI_TESTS  
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

### 🧪 Test 13.1 : Import d'un Paquet Basic (Happy Path)
* **Pré-conditions** : Fichier `.apkg` valide contenant 50 cartes Basic.
* **Input** : Chemin du fichier `.apkg`.
* **Règle d'Exécution** : Appeler `importApkg(path)`.
* **Post-conditions (Attendu)** :
  - 50 cartes SCY Forge sont créées avec recto/verso et tags corrects.
  - Les champs HTML sont nettoyés (Markdown si configuré).
  - Les embeddings sont indexés dans Zilliz.

### 🧪 Test 13.2 : Import d'un Paquet Cloze
* **Pré-conditions** : Fichier `.apkg` avec notetype Cloze.
* **Input** : Chemin du fichier `.apkg`.
* **Règle d'Exécution** : Appeler `importApkg(path)`.
* **Post-conditions (Attendu)** :
  - Les trous `{{c1::...}}` sont détectés et préservés.
  - Le type Cloze est correctement mappé.

### 🧪 Test 13.3 : Import des Médias
* **Pré-conditions** : Paquet `.apkg` contenant des images référencées par les cartes.
* **Input** : Chemin du fichier `.apkg`.
* **Règle d'Exécution** : Appeler `importApkg(path)`.
* **Post-conditions (Attendu)** :
  - Les fichiers média sont extraits via le mapping `media`.
  - Les références média dans les cartes SCY Forge sont mises à jour (chemins locaux valides).

### 🧪 Test 13.4 : Export Round-Trip (.apkg)
* **Pré-conditions** : Un ensemble de cartes SCY Forge existantes.
* **Input** : Sélection de cartes + deck cible.
* **Règle d'Exécution** : Appeler `exportApkg(cards)` puis tenter la réimportation du fichier produit.
* **Post-conditions (Attendu)** :
  - Le `.apkg` est généré sans erreur.
  - La réimportation reproduit les cartes d'origine (round-trip cohérent).
  - Le fichier est compatible Anki Desktop (schéma SQLite valide).

### 🧪 Test 13.5 : Dé-duplication à l'Import
* **Pré-conditions** : Certaines cartes (même contenu) déjà présentes dans SCY Forge / `mfg_shared_content_cache`.
* **Input** : Paquet `.apkg` contenant ces cartes.
* **Règle d'Exécution** : Appeler `importApkg(path)`.
* **Post-conditions (Attendu)** :
  - Les cartes déjà existantes sont ignorées (ou fusionnées selon préférence).
  - Aucun doublon n'est créé.

### 🧪 Test 13.6 : Export des Échéances FSRS
* **Pré-conditions** : Cartes SCY Forge avec échéance FSRS (ex : J+3).
* **Input** : Export de ces cartes.
* **Règle d'Exécution** : Appeler `exportApkg(cards)`.
* **Post-conditions (Attendu)** :
  - Le champ `due` des cartes Anki correspond au jour julien correct (échéance +3 jours).

### 🧪 Test 13.7 : Rejet d'un Fichier Invalide
* **Pré-conditions** : Fichier non-`.apkg` ou corrompu.
* **Input** : Chemin du fichier invalide.
* **Règle d'Exécution** : Appeler `importApkg(path)`.
* **Post-conditions (Attendu)** :
  - Le système renvoie le code `INVALID_APKG`.
  - Aucune exception non gérée n'est levée.

# 📑 SCY-CITATION-SOURCING — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S02_NEURON_CITATION_SOURCING_SPEC  
**Phase** : MVP (cœur de confiance)  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Le **Sourcing / Citation Système** est la fonctionnalité transverse de **traçabilité des sources** dans tous les contenus générés par SCY Forge. Chaque assertion issue d'une source ingérée est annotée d'une **référence numérotée en exposant** (ex : « la fonction d'activation sigmoid ¹ »), affichée sous forme de **chiffre romain majuscule cliquable**. Au **survol**, une **prévisualisation (preview)** de la source s'affiche (titre, type 🎥📄🌐, extrait). Au **clic**, l'utilisateur est redirigé vers la **position exacte** dans la source originale (timestamp vidéo, page PDF, paragraphe web) via un **deep link** vers la Reader Suite.

Ce système s'applique **partout** :
- **Cours ASCENT** (documents pédagogiques générés)
- **Cartes APEX** (flashcards)
- **Réponses BRAIN** (Professor AI, chat)
- **Documents générés en Mode Normal**
- **Nœuds/arêtes COSMOS** (badge source + provenance)

---

## 2. Tech Stack & Dependencies
* **CitationTracker (T08)** : tool NEURON-CHAINS qui lie chaque assertion à une source (similarity assertion↔source, embeddings).
* **Table `scy_concept_provenance`** : `source_id`, `position` (page/timestamp/paragraph), `confidence` (D-COSMOS-019).
* **Deep Links (D-OPT-002)** : pointeur sémantique exact (source_id, page, offset/paragraphe, timestamp).
* **Rendu frontend** : composant `<CitationMark>` React — exposant cliquable + tooltip preview + navigation deep link.
* **Reader Suite** : destination du deep link (ouvre à la position exacte).
* **Types de sources** : 🎥 YouTube/TikTok/Podcast (timestamp), 📄 PDF/EPUB/DOCX (page/CFI), 🌐 Web (paragraphe/offset), ✍️ Academic (DOI/page), 🤖 IA-généré.

> **Rappel anti-hallucination** : chaque citation DOIT être reliée à une source réelle ingérée (T08 CitationTracker, similarity > 0.60). Aucune citation sans source. Anti-hallucination couche 1 (ancrage RAG) + couche 2 (cross-check).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Annotations de Citation dans les Documents Générés

#### Scénario : Assertion issue d'une source
- **GIVEN** Un document généré par NEURON-CHAINS (cours ASCENT, document Mode Normal, réponse BRAIN).
- **WHEN** Une assertion provient d'une source ingérée.
- **THEN** le système SHALL annoter l'assertion d'une **référence numérotée en exposant** (ex : « sigmoid ¹ »).
- **AND** le système SHALL numéroté les citations séquentiellement par document ([1], [2], [3]…).
- **AND** le système SHALL lier chaque citation à son entrée `scy_concept_provenance` (source_id + position exacte).

---

### Requirement : Prévisualisation au Survol (Hover Preview)

#### Scénario : Aperçu de la source
- **GIVEN** Une citation numérotée affichée dans un document.
- **WHEN** L'utilisateur survole le chiffre/exposant.
- **THEN** le système SHALL afficher un tooltip de prévisualisation contenant :
  - Le **type de source** (🎥📄🌐✍️🤖)
  - Le **titre** de la source
  - Un **extrait** du passage source (50-100 mots)
  - La **position** (timestamp / page / paragraphe)
- **AND** le tooltip SHALL apparaître en < 200ms (pré-chargé).

---

### Requirement : Clic → Deep Link vers la Position Exacte

#### Scénario : Navigation vers la source originale
- **GIVEN** Une citation numérotée.
- **WHEN** L'utilisateur clique dessus.
- **THEN** le système SHALL ouvrir la **Reader Suite** (ou le lecteur approprié) à la **position exacte** de la source :
  - 🎥 Vidéo → timestamp exact (ex : 01:23)
  - 📄 PDF/EPUB → page + CFI exact
  - 🌐 Web → paragraphe/offset surligné
- **AND** le passage source SHALL être **surligné** dans le lecteur.

---

### Requirement : Liste des Références en Bas de Document

#### Scénario : Bibliographie
- **GIVEN** Un document avec citations.
- **THEN** le système SHALL afficher une **liste numérotée des références** en bas du document.
- **AND** chaque référence SHALL inclure : numéro, type, titre, source originale (URL/DOI), date.
- **AND** chaque référence SHALL être cliquable (deep link).

---

### Requirement : Couverture Transverse

#### Scénario : Application partout
- **THEN** le système SHALL appliquer le sourcing dans :
  - ✅ Cours ASCENT (documents NEURON-CHAINS)
  - ✅ Cartes APEX (front/back + deep link D-OPT-002)
  - ✅ Réponses BRAIN (Professor AI, chat agentique)
  - ✅ Documents Mode Normal
  - ✅ Nœuds/arêtes COSMOS (badge source D-COSMOS-019)
- **AND** le **rapport de confiance** SHALL indiquer le % d'assertions citées (ex : « 173/180 assertions liées à une source (96%) »).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Assertion sans citation si une source existe (T08 obligatoire).
* 🚫 **FORBIDDEN** : Citation sans source réelle (anti-hallucination).
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens `design.md`.
* ⚠️ **MUST** : Tout citation validée (Zod) ; deep link testé ; preview < 200ms.

---

## 5. Test cases & Validation
* **TC1 (Annotation)** : Document généré → assertions annotées [1][2][3] en exposant.
* **TC2 (Preview)** : Survol [1] → tooltip (type + titre + extrait + position) < 200ms.
* **TC3 (Deep link vidéo)** : Clic [1] 🎥 → Reader Suite ouvre la vidéo au timestamp exact (surligné).
* **TC4 (Deep link PDF)** : Clic [2] 📄 → Reader Suite ouvre le PDF à la page exacte (surligné).
* **TC5 (Bibliographie)** : Liste numérotée des références en bas, cliquable.
* **TC6 (Transverse)** : Sourcing présent dans cours ASCENT + cartes APEX + BRAIN + Mode Normal + COSMOS.
* **TC7 (Rapport)** : % assertions citées affiché (cible 96%+).
* **TC8 (Anti-hallucination)** : Aucune citation sans source réelle (T08 similarity > 0.60).

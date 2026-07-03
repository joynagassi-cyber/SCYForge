<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
APEX/FSRS en MVP simplifié. SMI Calculator gardé, scheduler complet différé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🃏 SCY-FLASHCARDS-APEX — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S05_APEX_FLASHCARDS_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 0. Frontière avec scheduler_fsrs (Complémentarité)
* **flashcards_apex** (ce document) gère les **10 types de cartes** (B01-B10), leur contenu, génération et cycle de vie.
* **scheduler_fsrs** gère l'**algorithme FSRS 5.0** de planification (Stability/Difficulty/Retrievability, 4 états, feedback 4 niveaux). Les deux sont complémentaires.

---

## 1. Purpose
Cette spécification définit le comportement des **flashcards APEX** : les **10 types de cartes** (B01-B10) couvrant l'éventail pédagogique complet (exposition, définition, MCQ, short answer, application, analogie, teaching Feynman, cloze, image occlusion, audio). Chaque carte est liée à un concept/nœud, générée par NEURON-CHAINS (chaîne EPSILON), et consommée par le scheduler FSRS.

---

## 2. Tech Stack & Dependencies
* **Génération** : NEURON-CHAINS chaîne **EPSILON** (EPSILON-1 définitions/MCQ/short answer/cloze, EPSILON-2 application, EPSILON-3 MCQ distracteurs, GAMMA-2 analogies B06).
* **Algorithme** : `fsrs` 0.6 (Rust) — état FSRS attaché à chaque carte (cf. scheduler_fsrs).
* **TTS** : OpenAI TTS API (cartes B10 audio + lecture TTS étendue B01-B05).
* **Validation** : modèles **Zod**.
* **Table** : `scy_apex_cards` (card_type, front/back, mcq_options, cloze_template, media_urls, fsrs_state, leech/suspended/buried/flags/user_note).

> **Rappel anti-hallucination** : les cartes sont générées à partir des sources ingérées (EPSILON) et fact-checkées. Distracteurs MCQ = erreurs communes réelles (B03), pas aléatoires. Aucune carte inventée sans source.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Les 10 Types de Cartes (B01-B10)

#### Scénario : Génération des 5 types MVP (B01-B05)
- **GIVEN** Un nœud ASCENT avec concepts clés (AGENT-03 crée 12 cartes/nœud : 3×B02, 3×B03, 3×B04, 3×B05).
- **WHEN** EPSILON génère les cartes.
- **THEN** le système SHALL produire les types MVP : B01 Exposition, B02 Définition, B03 MCQ (distracteurs plausibles), B04 Short Answer, B05 Application.
- **AND** le système SHALL valider chaque carte par Zod et persister dans `scy_apex_cards`.

#### Scénario : 5 types avancés (B06-B10) Phase V2
- **GIVEN** Phase V2 active.
- **THEN** le système SHALL supporter B06 Analogie, B07 Teaching (Feynman, évalué par BRAIN), B08 Cloze, B09 Image Occlusion, B10 Audio (TTS+Whisper).

---

### Requirement : Leech Detection

#### Scénario : Carte problématique
- **GIVEN** Une carte avec > 8 lapses OU taux d'échec > 80% sur les 10 dernières révisions.
- **THEN** le système SHALL la tagger `#leech` (`is_leech = true`).
- **AND** le système SHALL suggérer des alternatives (B06 Analogie, B01 Exposition, C01 exercice facile, IMPRINT Cran 5 — D-OPT-052).
- **AND** le système SHALL alerter DRIFT-GUARDIAN si > 5 leeches simultanées.

---

### Requirement : Gestion Manuelle (Suspension/Bury/Flags/Edit)

#### Scénario : Actions de gestion
- **GIVEN** Une carte en session.
- **THEN** le système SHALL supporter Suspendre, Bury card, Bury siblings, Unsuspend, Delete (soft `deleted_at`), Edit, Flag (5 couleurs), Add note.

---

### Requirement : TTS Étendu + Deep Links

#### Scénario : Audio et provenance
- **THEN** le système SHALL fournir TTS pour B01-B05 (touche `R`, mode mains-libres) — D-OPT-002.
- **AND** le système SHALL lier chaque carte à un deep link sémantique (source_id, page, offset/timestamp) vers la Reader Suite — D-OPT-002.

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Inventer une carte sans source ; distracteurs MCQ aléatoires.
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens `design.md`.
* ⚠️ **MUST** : Validation Zod ; état FSRS non nul.

---

## 5. Test cases & Validation
* **TC1** : 12 cartes/nœud générées (B02/B03/B04/B05) validées Zod, persistées.
* **TC2** : MCQ B03 avec distracteurs plausibles (erreurs communes).
* **TC3** : Leech (>8 lapses) → tag + alternatives suggérées.
* **TC4** : Gestion (suspend/bury/flag/edit/note) fonctionnelle.
* **TC5** : TTS `R` sur B01-B05 ; deep link Reader Suite actif.
* **TC6** : B07 Teaching évalué par BRAIN (contribution Mirror SMI).

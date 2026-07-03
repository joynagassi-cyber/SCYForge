<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
IMPRINT ÉLIMINÉE. Contenu biblique incompatible avec cyber ops. Réécriture nécessaire.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📖 SCY-IMPRINT — PROTOCOLE DE MÉMORISATION DES VERSETS SÉCURISÉS (LEECHS)
**ID Spécification** : S07_IMPRINT_LEECH_VERSE_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PRODUCTION IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin WHEN-THEN-AND) + Norme RFC 2119  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | ELIMINATED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module est ÉLIMINÉ du beachhead**
• Conservé pour expansion future
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Purpose
Cette spécification définit l'implémentation de la fonctionnalité d'**empreinte profonde (IMPRINT)** appliquée de manière ciblée aux versets bibliques ou concepts spirituels identifiés comme très difficiles (bloquants) dans le système de révision APEX (FSRS). Elle fusionne la friction intentionnelle physique avec la visualisation active (*Hagah*) et l'écriture manuscrite pour vaincre l'amnésie et maximiser l'intégration.

---

## 2. Requirements & Scenarios (RFC 2119)

### Requirement: Déclenchement Automatique par Détection de Leech

#### Scénario : Verrouillage numérique et handoff vers l'empreinte profonde
* **GIVEN** Un utilisateur révisant ses cartes sur le module APEX.
* **WHEN** L'agent `LEARNING-CONDUCTOR (AGENT-04)` identifie un taux d'échec supérieur à **80% sur 10 révisions consécutives** sur une carte verset.
* **THEN** le système SHALL **verrouiller et bloquer** l'affichage numérique de cette carte sur APEX.
* **AND** le système SHALL présenter un message d'orientation socratique : *"Ce verset ne s'ancre pas. Passons à l'empreinte profonde (IMPRINT) pour l'écrire sur la table de votre cœur."*
* **AND** le système SHALL rediriger l'élève vers le module IMPRINT.

---

### Requirement: Protocole de Distillation en 5 Crans

#### Scénario : Compression progressive du verset
* **GIVEN** Un verset complexe (ex: Josué 1:8) en cours de traitement dans IMPRINT.
* **WHEN** Le système initialise le parcours d'empreinte.
* **THEN** l'apprenant SHALL exécuter les crans d'assimilation séquentiellement :
  - **Cran 1 (Contexte)** : Lire le verset de base 3 fois dans sa version complète avec le chapitre de contexte environnant pour saisir l'intention.
  - **Cran 3 (Insights)** : Identifier de manière déterministe les 5 à 7 mots-clés ou verbes d'actions (Garniture Engine).
  - **Cran 5 (Noyau Cognitif)** : Réduire sémantiquement le verset à sa structure minimale (50 à 65 mots) tout en préservant la vérité centrale.

---

### Requirement: Intégration de la Dimension Visuelle "Hagah be"

#### Scénario : Imagerie mentale et Tree Renderer ASCII
* **GIVEN** Le passage au Cran 3 d'IMPRINT.
* **WHEN** L'utilisateur interagit avec le tableau de bord de visualisation.
* **THEN** le système SHALL lui demander de décrire en une phrase l'image mentale ou la "scène" que le verset évoque pour lui (Double Codage).
* **AND** le système SHALL générer une structure spatiale ASCII de type **Tree Renderer** représentant le squelette logique du verset (Le sujet au centre, les promesses sur les branches, les conditions de la Loi aux racines).
* **AND** le système SHALL forcer l'élève à recopier cet arbre logique à la main.

---

### Requirement: Ancrage Linguistique et Étymologique

#### Scénario : Décomposition étymologique par la chaîne GAMMA-3
* **GIVEN** Un mot-clé identifié comme central (ex: *Hagah*).
* **WHEN** La chaîne de traitement sémantique de nuit **GAMMA-3** analyse le mot.
* **THEN** le système SHALL afficher l'étymologie racine exacte (en hébreu ou en grec), sa prononciation et ses trois synonymes théologiques.
* **AND** l'apprenant SHALL recopier à la main cette étymologie et ces synonymes pour former une trace mnésique sémantique stable.

---

### Requirement: La Phase de Friction Intentionnelle Manuscrite

#### Scénario : Écriture physique et déblocage actif
* **GIVEN** La phase d'écriture active d'IMPRINT.
* **WHEN** L'utilisateur consulte le texte du verset à l'écran.
* **THEN** le système SHALL **interdire et bloquer** tout copier-coller (le texte est rendu sous forme d'élément non sélectionnable).
* **AND** l'apprenant MUST recopier l'intégralité du verset et son "arbre de structure" ASCII dans son carnet d'études physique.
* **WHEN** L'utilisateur demande à débloquer le nœud.
* **THEN** le système SHALL NOT débloquer la carte dans APEX tant que :
  - L'élève n'a pas coché la case de validation *"J'ai écrit ce verset à la main"*.
  - L'élève n'a pas réussi à 100% un test de rappel de type **Cloze-test (B08)** généré sur-mesure sur ce concept.

---

### Requirement: Consolidation Nocturne par l'Rhythm & Sleep

#### Scénario : Récitation de fin de journée par l'agent CHRONICLE
* **GIVEN** Un exercice IMPRINT validé avec succès en journée.
* **WHEN** L'agent **CHRONICLE** (`AGENT-10`) détecte la fin de journée de l'utilisateur (30 min avant le coucher).
* **THEN** l'agent SHALL lui envoyer une notification lui suggérant une récitation orale rythmée du verset d'empreinte.
* **AND** l'agent SHALL lui rappeler de laisser son cerveau utiliser le sommeil lent profond pour transférer le verset de l'hippocampe vers le cortex.

---

## 3. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Autoriser le déblocage d'un nœud bloqué (Leech) d'un simple clic numérique sans la double validation (case d'écriture cochée + test de Cloze réussi à 100%).
* 🚫 **SHALL NOT** : Rendre le texte d'un verset difficile sélectionnable ou copiable à l'écran.

---

## 4. Test cases & Validation
* **Test Case 1 (Déclenchement)** : Valider que lorsqu'un nœud subit un taux d'échec de 81% sur les 10 dernières révisions FSRS, `LEARNING-CONDUCTOR` bascule immédiatement le nœud sous statut `leech_locked`.
* **Test Case 2 (Friction)** : Vérifier que toute tentative de sélection CSS ou de copier-coller (Cmd+C/Ctrl+C) sur l'élément de texte est interceptée et annulée à 100%.

# 🧠 SCY-ENGRAM-DECAY-VITALITY — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S11_ENGRAM_DECAY_VITALITY_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification régit le comportement du cycle de vie des connaissances de SCY Forge. Elle encadre le calcul dynamique du score de vitalité synaptique des nœuds d'apprentissage (Concepts COSMOS et cartes de cours ASCENT), leur transition vers l'état de dormance froide (**Cold Engram Vault**) lorsque la vitalité s'effondre en deçà du seuil critique, et le processus d'évaluation socratique par l'utilisateur pour leur **Résurrection Active**.

---

## 2. Tech Stack & Dependencies
* **Framework d'Orchestration** : Mastra TypeScript (Workflows de transition et gestion d'UI)
* **Moteur d'Évaluation Sémantique & Mathématique** : Rust Core (calcul vectoriel haute performance, similarité cosinus locale avec Candle/ONNX, et arithmétique de vitalité stabilisée contre les overflows)
* **Base de Données** : Northflank PostgreSQL (tables `scy_synaptic_vitality`, `scy_engram_vault`, `scy_forge_attempts`)

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement: Calcul Sécurisé de la Vitalité Sigmoïdale (ENGRAM)

#### Scénario : Recalcul quotidien de la vitalité d'un nœud d'apprentissage
- **GIVEN** Un nœud actif dans le graphe possédant un score de rétention APEX FSRS, un score de centralité de connexion et un score de mobilisation récente.
- **WHEN** Le cron de synchronisation quotidienne s'exécute ou lorsque le nœud est sollicité par l'utilisateur.
- **THEN** le système SHALL appliquer l'équation de vitalité sigmoïdale calibrée pour calculer la nouvelle vitalité $V_n(t)$ :
  $$V_n(t) = w_r \cdot R_n(t) + w_c \cdot C_n(t) + w_m \cdot M_n(t) - \text{declin\_sigmoidal}$$
- **AND** le déclin sigmoïdal MUST s'appuyer sur la formulation stabilisée :
  $$\text{declin\_sigmoidal} = \frac{{20.0}}{{1.0 + e^{\text{clip}(-0.05 \cdot (t - 60), -50.0, 50.0) }}}$$
- **AND** le système MUST s'assurer que le score final est strictement encadré entre `0.0` et `100.0` à l'aide de bornes d'écrêtage de sécurité.
- **AND** le système SHALL enregistrer le résultat mis à jour dans la table `scy_synaptic_vitality`.

---

### Requirement: Transition Automatique vers la Dormance Froide (Cold Engram Vault)

#### Scénario : Archivage actif d'un nœud à faible vitalité
- **GIVEN** Un nœud d'apprentissage actif dont le score de vitalité synaptique $V_n(t)$ s'effondre en deçà de **20.0 / 100**.
- **WHEN** Le cron quotidien de réévaluation de la santé cognitive s'exécute.
- **THEN** le système SHALL retirer le nœud du graphe sémantique actif COSMOS.
- **AND** le système SHALL exclure le nœud des requêtes RAG par défaut de l'assistant de chat BRAIN.
- **AND** le système SHALL déplacer le nœud et son payload de connaissances complet dans la table `scy_engram_vault`.
- **AND** le système MUST générer et stocker dans la table `scy_engram_vault` les 3 mots-clés sémantiques essentiels associés à ce nœud (keywords de reconstruction).

---

### Requirement: Workflow de Résurrection Active par l'Effort de Génération

#### Scénario : Tentative de réactivation réussie d'un engram dormant
- **GIVEN** Un engram en dormance froide stocké dans la table `scy_engram_vault`.
- **WHEN** L'utilisateur tente de restaurer volontairement ce nœud d'apprentissage.
- **THEN** le système SHALL lui présenter uniquement les 3 mots-clés contextuels de reconstruction enregistrés.
- **AND** l'utilisateur MUST rédiger une phrase ou un résumé conceptuel libre (Effort de Génération).
- **AND** le moteur Rust MUST calculer la similarité cosinus sémantique entre la réponse utilisateur et la description du nœud originel.
- **WHEN** Le score de similarité obtenu est supérieur ou égal à **70%** (`score >= 0.70`).
- **THEN** le système SHALL restaurer le nœud dans le graphe actif et réajuster sa vitalité synaptique de départ à **50.0**.
- **AND** le système SHALL supprimer l'entrée de la table `scy_engram_vault`.

#### Scénario : Échec de la tentative de réactivation
- **GIVEN** Un engram en dormance froide et une saisie utilisateur de piètre similarité.
- **WHEN** La similarité sémantique calculée est inférieure à **70%** (`score < 0.70`).
- **THEN** le système SHALL NOT restaurer le nœud.
- **AND** le système SHALL incrémenter le compteur de tentatives `attempts_count` dans la table `scy_engram_vault`.
- **AND** le système SHALL retourner un feedback socratique d'encouragement contenant un indice supplémentaire.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Permettre à l'utilisateur de réactiver un nœud en dormance par un simple clic sans validation cognitive active (aucun bouton d'activation passive).
* 🚫 **SHALL NOT** : Permettre à un nœud en dormance de polluer le contexte d'invite (prompt context) de l'assistant de chat BRAIN. L'isolation doit être absolue.
* 🚫 **MANDATORY** : Appliquer un écrêtage strict (`clip`) sur les paramètres d'exposants pour éliminer tout risque d'exception arithmetic `NaN` ou `Infinity` (anti-overflow/underflow).

---

## 5. Test cases & Validation
* **Test Case 1 (Calcul de vitalité)** : Valider que le déclin temporel sigmoïdal pour $t = 10$ jours applique une diminution minime, et pour $t = 90$ jours provoque une entrée stable en dormance.
* **Test Case 2 (Transition en dormance)** : Vérifier que lorsqu'un nœud passe sous le score de 20.0, il est retiré de la table active et archivé avec succès dans `scy_engram_vault`.
* **Test Case 3 (Résurrection validée)** : S'assurer qu'une tentative avec une similarité cosinus calculée de 75% réintègre le nœud avec une vitalité de 50.0.

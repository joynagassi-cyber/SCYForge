# 📋 SCY-AG16-TRUNK-VALIDATOR — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG16_TRUNK_VALIDATOR_TASKS
**Statut** : 🟡 BACKLOG D'ARCHITECTURE — NON DÉMARRÉ (aucun code tant que non autorisé explicitement)

> ⚠️ **RAPPEL** : ces tâches décrivent du travail **futur**. Aucune ligne de code ne sera écrite tant que le fondateur ne l'autorise pas explicitement. On est en phase ARCHITECTURE.

---

### 🚀 Tâche 16.1 : Modèle de représentation logique (Datalog-like)
* **Description** : Définir les prédicats (`tactic`, `technique`, `sub`, `requires`, `enables`, `observable`, `detects`, `mitigates`) et le format des règles de Horn `P1..P6` chargées depuis le DomainPack.
* **Fichier (cible)** : `backend_rs/src/ascent/trunk/logic_model.rs`
* **Critère de Succès** : Un tronc cyber (ex. Execution → T1059 → T1059.001) est exprimable en faits + règles.

### 🚀 Tâche 16.2 : Moteur Arbres de Beth borné
* **Description** : Construire l'arbre `T ∧ ¬kⱼ`, décomposer récursivement par connecteur, fermer les branches contradictoires ; respecter `Dmax`/`Bmax`.
* **Fichier (cible)** : `backend_rs/src/ascent/trunk/beth_tableau.rs`
* **Critère de Succès** : `proven` si toutes branches fermées ; `open` + principe manquant sinon ; `undecided_in_budget` si borne atteinte.

### 🚀 Tâche 16.3 : Scoreur formel
* **Description** : Calculer `Derivability` (proportion de `kⱼ` prouvés), `Irreducibility` (tests d'atomicité), `Consistency` (non-fermeture de `T` seul). Produit des trois.
* **Fichier (cible)** : `backend_rs/src/ascent/trunk/formal_scorer.rs`
* **Critère de Succès** : `Score_formel ∈ [0,1]` ; un facteur nul ⇒ score nul.

### 🚀 Tâche 16.4 : Scoreur tacite (heuristique)
* **Description** : Calculer les proxys `root_depth` (depuis AG03), `feynman_pass` (teach-back ASCENT), `sop_grounding` (PROV), `coverage` ; moyenne pondérée.
* **Fichier (cible)** : `backend_rs/src/ascent/trunk/tacit_scorer.rs`
* **Critère de Succès** : `Score_tacite ∈ [0,1]` ; aucune fausse preuve (proxys seulement).

### 🚀 Tâche 16.5 : Agrégation hybride + Zod
* **Description** : `foundationality = w_f·formel + w_t·tacite` ; sortie `FoundationalitySchema` (foundationality, breakdown formel/tacite, open_branches, proof_status par-k, proof_tree_ref).
* **Fichier (cible)** : `backend_ts/src/ascent/agents/ag16_trunk_validator.ts`
* **Critère de Succès** : Score validé Zod ; décomposition formel/tacite toujours présente.

### 🚀 Tâche 16.6 : Cache par tronc + invalidation bitemporelle
* **Description** : Mettre en cache le score par hash de `T` ; invalider sur changement de `T` (AG15) ou `K` ; fermer l'ancien score (bitemporel), ouvrir le nouveau.
* **Fichier (cible)** : `backend_ts/src/ascent/agents/ag16_trunk_validator.ts`
* **Critère de Succès** : Blending lit le score en cache (non bloquant) ; recalcul sur drift du tronc.

### 🚀 Tâche 16.7 : Journalisation + provenance (audit)
* **Description** : Journaliser l'arbre de preuve + score dans `scy_agent_decisions` ; attacher provenance W3C PROV (`wasDerivedFrom`).
* **Fichier (cible)** : `backend_ts/src/ascent/agents/ag16_trunk_validator.ts`
* **Critère de Succès** : Chaque score est auditable jusqu'à son arbre de preuve et ses sources.

### 🚀 Tâche 16.8 : Boucle de diagnostic vers AG15
* **Description** : Router `open_branches` (principes manquants) vers AG15-AXIOMATIZER pour enrichissement, ou marquer la connaissance comme `K_tacite`.
* **Fichier (cible)** : `backend_ts/src/ascent/agents/ag16_trunk_validator.ts`
* **Critère de Succès** : Une branche ouverte produit soit une demande d'axiome, soit un reclassement tacite.

---

*Backlog d'architecture. Aucun code écrit.*

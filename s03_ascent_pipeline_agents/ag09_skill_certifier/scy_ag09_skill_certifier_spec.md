# 🏆 SCY-AG09-SKILL-CERTIFIER — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG09_SKILL_CERTIFIER_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement de l'**AGENT-09 : SKILL-CERTIFIER**. Sa mission est de **valider et certifier la compétence** acquise par l'utilisateur en délivrant un **Proof of Skill** vérifiable et exportable. La certification combine une **évaluation théorique** (SMI global atteint, SurveyJS) et une **évaluation pratique** (simulation ARENA via AGENT-11), garantissant que la compétence est démontrée et pas seulement déclarée.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Workflow Step).
* **Évaluation théorique** : SMI global (AGENT-05) ≥ seuil + examen SurveyJS (`s05`).
* **Évaluation pratique** : simulation ARENA (AGENT-11) — roleplay Full-AI tout domaine.
* **Anti-hallucination** : validation cognitive (AGENT-13) des contenus d'examen.
* **Validation** : modèles **Zod** pour les certificats.
* **Persistence/Export** : `mfg_certificates`, export PDF/vérifiable (hash signé).

> **Rappel anti-hallucination** : la certification n'est délivrée que sur preuves mesurées (SMI + réussite pratique ARENA). Aucun certificat n'est généré sans validation double (théorique + pratique).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Évaluation Théorique

#### Scénario : Validation du socle théorique
- **GIVEN** Un utilisateur ayant terminé un objectif (tous les nœuds du DAG complétés).
- **WHEN** Le SKILL-CERTIFIER évalue.
- **THEN** le système SHALL vérifier que le SMI global atteint le seuil de certification (AGENT-05).
- **AND** le système SHALL administrer un examen théorique SurveyJS sur le domaine.
- **AND** le système SHALL exiger un score ≥ seuil pour valider la composante théorique.

---

### Requirement : Évaluation Pratique (ARENA)

#### Scénario : Simulation de compétence
- **GIVEN** La composante théorique validée.
- **WHEN** Le système évalue la pratique.
- **THEN** le système SHALL déclencher une simulation ARENA (AGENT-11) représentant un scénario réel du domaine.
- **AND** le système SHALL exiger une performance ≥ seuil sur la simulation pour valider la composante pratique.

---

### Requirement : Délivrance du Proof of Skill

#### Scénario : Certification et export
- **GIVEN** Les composantes théorique ET pratique validées.
- **WHEN** Le système certifie.
- **THEN** le système SHALL générer un **Proof of Skill** (SMI global + détails par dimension).
- **AND** le système SHALL signer le certificat (hash vérifiable) pour l'authenticité.
- **AND** le système SHALL permettre l'export (PDF, partage LinkedIn).
- **AND** le système SHALL émettre `GoalCompleted { user_id, goal_id }`.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Délivrer un certificat sans validation double (théorique + pratique).
* 🚫 **SHALL NOT** : Forger un SMI ou un résultat de simulation.
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens de `design.md`.
* ⚠️ **MUST** : Certificats validés par **Zod** et signés (hash).

---

## 5. Test cases & Validation
* **Test Case 1 (Théorique)** : Un SMI ≥ seuil + examen réussi valide la composante théorique.
* **Test Case 2 (Pratique)** : Une simulation ARENA réussie valide la composante pratique.
* **Test Case 3 (Certificat)** : Les deux composantes validées → Proof of Skill signé et exportable.
* **Test Case 4 (Refus)** : Une composante échouée → pas de certificat.
* **Test Case 5 (Vérifiabilité)** : Le hash signé du certificat est vérifiable.

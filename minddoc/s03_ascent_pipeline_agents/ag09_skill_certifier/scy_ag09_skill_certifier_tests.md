<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG09-SKILL-CERTIFIER — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG09_SKILL_CERTIFIER_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

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

### 🧪 Test 9.1 : Évaluation Théorique (Happy Path)
* **Pré-conditions** : SMI global ≥ seuil.
* **Input** : Examen SurveyJS réussi.
* **Attendu** : Composante théorique validée.

### 🧪 Test 9.2 : Évaluation Pratique ARENA
* **Pré-conditions** : Composante théorique validée.
* **Input** : Simulation ARENA réussie.
* **Attendu** : Composante pratique validée.

### 🧪 Test 9.3 : Délivrance du Proof of Skill
* **Pré-conditions** : Les deux composantes validées.
* **Attendu** : Certificat signé généré, persisté dans `mfg_certificates`, exportable.

### 🧪 Test 9.4 : Refus de Certification
* **Pré-conditions** : Une composante échouée (théorie ou pratique).
* **Attendu** : Aucun certificat délivré.

### 🧪 Test 9.5 : Vérifiabilité du Hash
* **Attendu** : Le hash signé du certificat peut être vérifié (intégrité confirmée).

### 🧪 Test 9.6 : GoalCompleted
* **Attendu** : La certification déclenche `GoalCompleted { user_id, goal_id }`.

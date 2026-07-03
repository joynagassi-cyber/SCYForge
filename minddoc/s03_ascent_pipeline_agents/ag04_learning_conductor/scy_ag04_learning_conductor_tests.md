<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG04-LEARNING-CONDUCTOR — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG04_LEARNING_CONDUCTOR_TESTS  
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

### 🧪 Test 4.1 : Génération de Contenu (NEURON-CHAINS)
* **Input** : Nœud + sources.
* **Exécution** : `learningConductorStep(node)`.
* **Attendu** : Documents pédagogiques générés, tracés vers les sources.

### 🧪 Test 4.2 : Session Active (Exercices + Flashcards)
* **Attendu** : Exercices et flashcards FSRS proposés ; `ExerciseCompleted` émis à la validation.

### 🧪 Test 4.3 : Planification de Rétention
* **Attendu** : `SessionEnded` émis avec durée et cartes ; révisions FSRS planifiées ; IMPRINT déclenché.

### 🧪 Test 4.4 : Validation & Déblocage
* **Pré-conditions** : Nœud au SMI cible (signal AGENT-05).
* **Attendu** : `NodeCompleted` émis ; nœuds dépendants débloqués.

### 🧪 Test 4.5 : Respect des Prérequis
* **Pré-conditions** : Nœud dont un prérequis n'est pas validé.
* **Attendu** : Le nœud n'est pas débloqué (`NodeUnlocked` non émis).

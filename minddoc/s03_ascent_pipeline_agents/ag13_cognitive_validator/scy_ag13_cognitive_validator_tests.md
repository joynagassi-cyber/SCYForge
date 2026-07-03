<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG13-COGNITIVE-VALIDATOR — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG13_COGNITIVE_VALIDATOR_TESTS  
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

### 🧪 Test 13.1 : Détection d'Aassertion Sans Source (Couche 1)
* **Input** : Document avec une assertion non tracée.
* **Attendu** : Assertion détectée et marquée `unverified`.

### 🧪 Test 13.2 : Détection de Contradiction (Couche 2)
* **Input** : Document contenant deux assertions contradictoires.
* **Attendu** : Contradiction détectée.

### 🧪 Test 13.3 : Recoupement Externe (Couche 3)
* **Input** : Fait non recoupable dans le référentiel.
* **Attendu** : Fait signalé comme non vérifié.

### 🧪 Test 13.4 : Score par Section + Blocage
* **Pré-conditions** : Une section sous le seuil (85).
* **Attendu** : Section bloquée ; renvoi à NEURON-CHAINS pour révision.

### 🧪 Test 13.5 : Gate Globale
* **Pré-conditions** : Score global < seuil.
* **Attendu** : Le document n'est pas présenté à l'utilisateur.

### 🧪 Test 13.6 : Rapport de Confiance
* **Attendu** : Un rapport (score + justifications) est généré et journalisé dans Langfuse.

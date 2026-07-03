<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG07-DRIFT-GUARDIAN — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG07_DRIFT_GUARDIAN_TESTS  
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

### 🧪 Test 7.1 : Détection d'Inactivité
* **Pré-conditions** : Inactivité simulée > seuil (N jours).
* **Attendu** : `DriftDetected { signal_type: "inactivity", severity }` émis.

### 🧪 Test 7.2 : Déclin de Performance
* **Pré-conditions** : Baisse de SMI > seuil.
* **Attendu** : Signal "decline" détecté et agrégé au score.

### 🧪 Test 7.3 : Ré-Engagement Personnalisé
* **Input** : Alerte "échecs répétés".
* **Attendu** : Action de simplification (AGENT-06) déclenchée (pas un rappel générique).

### 🧪 Test 7.4 : Anti-spam
* **Pré-conditions** : Alertes répétées rapprochées.
* **Attendu** : La fréquence des notifications est limitée.

### 🧪 Test 7.5 : DLQ
* **Pré-conditions** : Un événement échoue 3 fois.
* **Attendu** : L'Agent-07 est notifié via la DLQ.

### 🧪 Test 7.6 : Anti-Faux-Positifs
* **Pré-conditions** : Aucun seuil franchi.
* **Attendu** : Aucune alerte émise ; surveillance continue.

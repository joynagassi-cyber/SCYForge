<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-ENGINE-RECHARTS — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_RECHARTS_TESTS  
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

### 🧪 Test RC.1 : Statistics (M7) clic
* **Input** : Clic sur un pic d'oubli.
* **Attendu** : Les concepts concernés sont filtrés/affichés.

### 🧪 Test RC.2 : Statistics (M7) fallback
* **Input** : Agrégation DuckDB-WASM dépassant 5s.
* **Attendu** : Affichage d'un fallback statique neutre (circuit breaker).

### 🧪 Test RC.3 : Radar (M14) superposition
* **Attendu** : Polygone bleu (profil) + polygone cible (pointillés) superposés sur 5 axes.

### 🧪 Test RC.4 : Radar (M14) bornes
* **Attendu** : Toutes les valeurs des axes sont dans [0,100].

### 🧪 Test RC.5 : Radar (M14) clic sommet
* **Attendu** : Le clic sur un sommet ouvre les concepts responsables de la dimension.

### 🧪 Test RC.6 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

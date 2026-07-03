<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-LENS-SYSTEM — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_LENS_SYSTEM_TESTS  
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

### 🧪 Test LS.1 : Combinaison de Lentilles
* **Attendu** : Plusieurs lentilles activées simultanément fonctionnent ensemble.

### 🧪 Test LS.2 : Mise en Évidence des Relations
* **Attendu** : La lentille révèle les relations d'un concept et atténue le reste.

### 🧪 Test LS.3 : Similarité Sémantique
* **Attendu** : La lentille regroupe les concepts proches (embeddings).

### 🧪 Test LS.4 : Filtrage
* **Attendu** : Le filtrage masque les nœuds non correspondants ; relations visibles préservées.

### 🧪 Test LS.5 : Extensibilité
* **Attendu** : Une nouvelle lentille peut être ajoutée sans refonte.

### 🧪 Test LS.6 : Réversibilité & Palette
* **Attendu** : Les lentilles sont réversibles (données intactes) ; aucune couleur hors tokens `design.md`.

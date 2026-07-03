<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-ENGINE-TANSTACK-TABLE — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_TANSTACK_TABLE_TESTS  
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

### 🧪 Test TT.1 : Virtual Scroll
* **Input** : 10 000 concepts.
* **Attendu** : Affichage à 60 FPS sans charge GPU.

### 🧪 Test TT.2 : Tri Stabilité FSRS
* **Input** : Tri par Stabilité FSRS croissante.
* **Attendu** : Les concepts les plus proches de l'oubli apparaissent en haut.

### 🧪 Test TT.3 : Clic → Knowledge Card
* **Input** : Clic sur une ligne.
* **Attendu** : Un Drawer s'ouvre avec la Knowledge Card complète du concept.

### 🧪 Test TT.4 : Badge SMI
* **Attendu** : Les cellules SMI affichent un badge couleur (Rouge→Vert).

### 🧪 Test TT.5 : Compatibilité
* **Attendu** : Fonctionne sur liseuses e-ink et connexions bas débit (DOM pur).

### 🧪 Test TT.6 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

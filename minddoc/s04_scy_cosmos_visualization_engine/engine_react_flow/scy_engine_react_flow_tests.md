<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-ENGINE-REACT-FLOW — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_REACT_FLOW_TESTS  
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

### 🧪 Test RF.1 : Rendu du DAG (Happy Path)
* **Input** : DAG ASCENT valide.
* **Attendu** : Affichage layout dirigé dagre avec statuts corrects.

### 🧪 Test RF.2 : Mise à Jour Temps Réel
* **Input** : Événement `NodeCompleted`.
* **Attendu** : Le statut du nœud passe à complété ; les dépendants se débloquent.

### 🧪 Test RF.3 : Interactivité
* **Attendu** : Zoom/pan/mini-map/sélection fonctionnels ; détail affiché.

### 🧪 Test RF.4 : Goulots & Chemins Critiques
* **Attendu** : Les goulots cognitifs et chemins critiques sont mis en évidence.

### 🧪 Test RF.5 : Cohérence des Prérequis
* **Attendu** : Un nœud dont les prérequis ne sont pas validés reste verrouillé.

### 🧪 Test RF.6 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

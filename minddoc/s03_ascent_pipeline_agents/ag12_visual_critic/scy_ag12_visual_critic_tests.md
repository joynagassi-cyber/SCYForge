<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG12-VISUAL-CRITIC — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG12_VISUAL_CRITIC_TESTS  
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

### 🧪 Test 12.1 : Détection de Surcharge
* **Input** : Graphe dense (nœuds/arêtes > seuil).
* **Attendu** : Surcharge signalée + recommandation (regroupement/filtrage/fisheye).

### 🧪 Test 12.2 : Conformité des Couleurs
* **Input** : Rendu avec couleur hors tokens `design.md`.
* **Attendu** : Couleur rejetée.

### 🧪 Test 12.3 : Contraste WCAG
* **Input** : Contraste insuffisant.
* **Attendu** : Signalé comme non accessible.

### 🧪 Test 12.4 : Justesse Sémantique
* **Input** : Arête ne reflétant pas la vraie relation.
* **Attendu** : Détection via AGENT-13.

### 🧪 Test 12.5 : Recommandations COSMOS
* **Attendu** : Des ajustements concrets sont émis au moteur de rendu COSMOS.

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-ENGINE-NIVO — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S04_COSMOS_ENGINE_NIVO_TESTS  
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

### 🧪 Test NV.1 : Chord (M12)
* **Input** : Matrice 50×50.
* **Attendu** : Rendu correct ; survol met en valeur les rubans émanant de l'arc.

### 🧪 Test NV.2 : Sankey (M13)
* **Input** : Flux avec des flux mineurs < 2%.
* **Attendu** : Les flux mineurs sont fusionnés sous « Autres flux ».

### 🧪 Test NV.3 : Heatmap (M16)
* **Input** : Matrice avec similarité > 0.95.
* **Attendu** : Le `⚠️` de redondance s'affiche.

### 🧪 Test NV.4 : Circle Packing (M19)
* **Input** : Hiérarchie avec sous-bulles < 5px.
* **Attendu** : Les bulles trop petites sont masquées/floutées.

### 🧪 Test NV.5 : Lazy-Loading
* **Attendu** : nivo absent du bundle initial ; chargé uniquement à la visite d'un mode M12/M13/M16/M19.

### 🧪 Test NV.6 : Palette
* **Attendu** : Aucune couleur hors tokens `design.md`.

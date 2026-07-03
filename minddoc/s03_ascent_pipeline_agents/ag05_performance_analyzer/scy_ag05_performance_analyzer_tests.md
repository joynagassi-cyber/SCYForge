<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG05-PERFORMANCE-ANALYZER — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG05_PERFORMANCE_ANALYZER_TESTS  
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

### 🧪 Test 5.1 : Recalcul SMI (Happy Path)
* **Input** : `CardReviewed { rating: "good" }`.
* **Exécution** : `performanceAnalyzerStep(event)`.
* **Attendu** : SMI recalculé, borné [0,100], persisté dans `mfg_ascent_nodes`.

### 🧪 Test 5.2 : Détection de Seuil
* **Pré-conditions** : Nœud proche du seuil.
* **Input** : Signal faisant franchir le seuil.
* **Attendu** : `NodeCompleted { smi_achieved }` émis.

### 🧪 Test 5.3 : Agrégation SMI Global
* **Pré-conditions** : Plusieurs nœuds à différents SMI.
* **Attendu** : `mv_user_smi_summary` reflète correctement la moyenne/médiane et le compte de nœuds maîtrisés.

### 🧪 Test 5.4 : Export Parquet
* **Attendu** : L'export Parquet contient les colonnes attendues (domaine, type, lapses, stability).

### 🧪 Test 5.5 : Aucun Score Inventé
* **Attendu** : Le SMI n'augmente qu'avec des signaux réels mesurés ; sans signal, SMI inchangé.

<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag16_trunk_validator DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG16-TRUNK-VALIDATOR — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG16_TRUNK_VALIDATOR_TESTS
**Statut** : 🟡 CONTRAT DE TESTS D'ARCHITECTURE (aucun code — tests à implémenter après autorisation)

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

### 🧪 Test 16.1 : Dérivabilité (Happy Path)
* **Pré-conditions** : Tronc `T` cyber (Execution → T1059 → T1059.001), `k = detectable_by(sigma_4104)`, faits `executed/observable/detects` présents.
* **Règle d'Exécution** : Construire l'arbre de Beth `T ∧ ¬k`.
* **Post-conditions (Attendu)** : Toutes branches fermées (via P4 puis P5) → `k` = `proven` ; compte dans `Derivability`.

### 🧪 Test 16.2 : Branche Ouverte (Diagnostic)
* **Input** : `k' = detectable_by(sigma_xxxx)` pour une technique **sans** `observable(T,_)` dans `T`.
* **Attendu** : Branche ouverte → `k'` = `open` + `missing_principle = observable(T,_)` émis vers AG15.

### 🧪 Test 16.3 : Borne Anti Semi-Décidabilité
* **Pré-conditions** : Preuve dont la profondeur dépasse `Dmax`.
* **Attendu** : `undecided_in_budget` (ni `proven` ni `open`) ; jamais présenté comme prouvé.

### 🧪 Test 16.4 : Irréductibilité (Atomicité)
* **Input** : Un principe `pᵢ` dérivable des autres principes de `T`.
* **Attendu** : `Irreducibility` pénalisé (pᵢ non atomique → couche intermédiaire détectée).

### 🧪 Test 16.5 : Cohérence du Tronc
* **Input** : `T` contenant une contradiction (l'arbre de `T` seul se ferme).
* **Attendu** : `Consistency = 0` → `Score_formel = 0` (produit).

### 🧪 Test 16.6 : Transparence du Score Hybride
* **Attendu** : La sortie affiche `breakdown.formal` (derivability/irreducibility/consistency) ET `breakdown.tacit` (root_depth/feynman/sop/coverage) séparément. Jamais un agrégat opaque.

### 🧪 Test 16.7 : Non-Blocage du Pipeline
* **Pré-conditions** : `foundationality` faible (ex. 0.4).
* **Attendu** : Le pipeline génératif **continue** ; la Seed est marquée « fondation faible », pas interdite.

### 🧪 Test 16.8 : Aucune Invention
* **Attendu** : Aucune branche n'est fermée à l'aide d'un principe **absent** de `T`.

### 🧪 Test 16.9 : Cache & Invalidation Bitemporelle
* **Pré-conditions** : Score en cache pour `T`. AG15 ajoute un principe → `T'`.
* **Attendu** : Ancien score fermé (event time, non supprimé) ; nouveau score recalculé pour `T'`.

### 🧪 Test 16.10 : Auditabilité
* **Attendu** : Chaque score est traçable jusqu'à son `proof_tree_ref` et ses sources (PROV `wasDerivedFrom`).

---

*Contrat de tests d'architecture. Aucun code.*

<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag11_arena DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG11-ARENA — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG11_ARENA_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

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

### 🧪 Test 11.1 : Génération de Scénario (Happy Path)
* **Input** : Domaine + objectif.
* **Attendu** : Scénario réaliste généré avec grille d'évaluation mesurable.

### 🧪 Test 11.2 : Cohérence du Roleplay
* **Attendu** : Les agents-rôles restent cohérents et contextualisés sur plusieurs tours.

### 🧪 Test 11.3 : Scoring Pratique
* **Pré-conditions** : Session terminée.
* **Attendu** : Score produit selon la grille, validé par `ArenaScoreSchema`.

### 🧪 Test 11.4 : Seuil de Validation
* **Attendu** : Score ≥ seuil → composante pratique validée (AGENT-09) ; < seuil → échec.

### 🧪 Test 11.5 : Feedback Ciblé
* **Attendu** : Le feedback inclut points forts et axes d'amélioration.

### 🧪 Test 11.6 : Validation AGENT-13
* **Pré-conditions** : Scénario incohérent.
* **Attendu** : Régénération déclenchée (pas de scénario invalide utilisé).

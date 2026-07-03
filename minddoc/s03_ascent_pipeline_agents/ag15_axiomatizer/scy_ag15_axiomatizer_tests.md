<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag15_axiomatizer DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG15-AXIOMATIZER — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG15_AXIOMATIZER_TESTS  
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

### 🧪 Test 15.1 : Distillation (Happy Path)
* **Pré-conditions** : ≥ 100 traces convergentes dans `scy_procedural_traces`.
* **Règle d'Exécution** : Lancer la tâche de distillation.
* **Post-conditions (Attendu)** : 1 axiome formulé, validé par `AxiomSchema`.

### 🧪 Test 15.2 : Seuil k Non Atteint
* **Pré-conditions** : k < seuil (ex : 30 traces).
* **Attendu** : Aucun axiome généré (attente accumulation).

### 🧪 Test 15.3 : Filtre PII
* **Input** : Axiome candidat contenant un identifiant personnel.
* **Attendu** : Identifiant strippé avant persistance ; si non strippable → rejet (GDPR).

### 🧪 Test 15.4 : k-Anonymat
* **Attendu** : Les profils contributeurs sont masqués (k ≥ 10).

### 🧪 Test 15.5 : Purge des Micro-Règles
* **Pré-conditions** : Axiome consolidé.
* **Attendu** : Les micro-règles/traces d'origine sont supprimées.

### 🧪 Test 15.6 : Partage Global Invisible
* **Attendu** : L'axiome est accessible à tous les utilisateurs sans action de leur part.

### 🧪 Test 15.7 : Non-Blocage UX (Async)
* **Attendu** : La distillation en arrière-plan ne bloque pas l'expérience utilisateur.

### 🧪 Test 15.8 : Aucune Invention
* **Attendu** : Sans trace convergente, aucun axiome n'est inventé.

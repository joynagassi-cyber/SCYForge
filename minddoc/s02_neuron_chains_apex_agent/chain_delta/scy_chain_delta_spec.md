<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟠 SCY-CHAIN-DELTA — VALIDATION (SPEC)
**ID** : S02_NEURON_CHAIN_DELTA_SPEC · **Phase** : V1

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

## 1. Purpose
La chaîne **DELTA** valide le contenu généré : fact-checking (DELTA-1, Wikipedia/papers/RAG), audit de cohérence interne (DELTA-2, contradictions), validation des citations (DELTA-3, APA/MLA/Vancouver).

## 2. Agents
* **DELTA-1 Fact-Checker** : vérification assertions via Wikipedia, papers, RAG.
* **DELTA-2 Auditeur Cohérence** : détection contradictions internes.
* **DELTA-3 Validateur Citations** : formats APA/MLA/Vancouver.

## 3. Requirements (RFC 2119)
- **GIVEN** Les documents enrichis par GAMMA.
- **THEN** DELTA-1 SHALL fact-checker chaque assertion risquée (T11 FactChecker, retrieval RAG) : Verified → maintenu, Unsupported → réécrit/supprimé, Contradicted → supprimé.
- **AND** DELTA-2 SHALL détecter les contradictions internes.
- **AND** DELTA-3 SHALL valider les formats de citation (APA/MLA/Vancouver).

## 4. Tests
- **TC1** : Assertion unsupported → réécrite/supprimée avec note éditoriale.
- **TC2** : Contradiction interne détectée.
- **TC3** : Citations au bon format (APA/MLA/Vancouver).

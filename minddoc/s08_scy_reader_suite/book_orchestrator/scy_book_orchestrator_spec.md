<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎭 SCY-BOOK-ORCHESTRATOR — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S08_READER_BOOK_ORCHESTRATOR_SPEC  
**Phase** : Phase 1  
**Décision** : RS-003 (1 question clarification max), RS-004 (max 3 modes COSMOS)  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

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

## 1. Purpose
Cette spécification définit le **Book Orchestrator** — agent IA qui détermine ce que l'utilisateur veut accomplir avec un document et orchestre les features SCY Forge les plus pertinentes. **Une question de clarification → une expérience personnalisée** (coût ~$0.002 max, souvent $0).

---

## 2. Tech Stack & Dependencies
* **Question clarification** : UI statique 7 intentions ($0 LLM).
* **Analyse structure** : algorithme Rust ($0 LLM) — structure détectée, chapter_count, concept_count, has_timeline_markers, user_smi_avg, relation_count.
* **Sélection modes COSMOS** : règles déterministes Rust (`select_cosmos_modes`, $0).
* **Table** : `scy_book_orchestrations`.

> **Rappel anti-hallucination** : l'orchestration est déterministe (Rust, $0 LLM). La sélection des modes COSMOS suit des règles explicites basées sur l'analyse réelle du document.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Question de Clarification (7 intentions)
- **GIVEN** La première ouverture d'un document / bouton « Analyser avec IA ».
- **THEN** le système SHALL poser 1 question UI statique (7 intentions : Vue globale / Exploration / Concept précis / Créer révisions / Notes / Comprendre vite / IA décide).

### Requirement : Matrice Intention → Features (max 3)
- **GIVEN** L'intention choisie.
- **THEN** le système SHALL orchestrer max 3 features (matrice intention→features, RS-004 Miller's Law).

### Requirement : Sélection Auto (IA décide)
- **GIVEN** Intention « IA décide ».
- **THEN** le système SHALL analyser la structure et sélectionner max 3 modes COSMOS optimaux via règles déterministes (hiérarchique→Sunburst S10 ; concepts>20→Concept Map M9 ; chronologique→Timeline M6 ; SMI<50→Radar M7 ; réseau dense→KG M0).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Plus d'1 question de clarification (RS-003) / plus de 3 modes (RS-004).

---

## 5. Test cases & Validation
* **TC1** : 1 question (7 intentions) posée.
* **TC2** : Intention → max 3 features orchestrées.
* **TC3** : « IA décide » → max 3 modes COSMOS optimaux selon règles.
* **TC4** : Coût ≤ $0.002 (souvent $0).

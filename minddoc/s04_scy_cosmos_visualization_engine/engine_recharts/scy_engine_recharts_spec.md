<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📈 SCY-ENGINE-RECHARTS — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_ENGINE_RECHARTS_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

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

## 1. Purpose
Cette spécification définit le comportement du **moteur engine_recharts**, basé sur **recharts v2** (graphiques déclaratifs SVG légers). Il fournit les **graphiques statistiques et le radar multidimensionnel du SMI** : courbes de rétention, barres de performance (M7) et polygone radar 5 dimensions (M14). Moteur des modes M7 et M14.

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + **recharts v2** (`recharts`).
* **Rendu** : SVG déclaratif.
* **Données** : agrégations analytiques DuckDB-WASM (M7) ; 5 dimensions SMI d'AGENT-05 (M14).
* **Circuit breaker** : si une agrégation DuckDB-WASM dépasse 5s, fallback état neutre statique (D-RESILIENCE-005).
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : recharts est la librairie réelle désignée pour M7/M14. Palette stricte `design.md`. Les données proviennent des agrégations réelles (DuckDB-WASM, SMI AGENT-05).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Statistics (M7)

#### Scénario : Tour de contrôle métacognitive
- **GIVEN** Des agrégations analytiques (courbes de rétention, barres de performance, nuages de points).
- **WHEN** Le mode M7 est activé.
- **THEN** le système SHALL rendre les graphiques via recharts.
- **AND** le clic sur un point (ex : pic d'oubli) filtre les concepts concernés.
- **AND** si l'agrégation DuckDB-WASM dépasse 5s, le circuit breaker affiche un fallback statique neutre.

---

### Requirement : Radar Comparaison (M14)

#### Scénario : Profil SMI multidimensionnel
- **GIVEN** Les 5 dimensions du SMI (Rétention, Profondeur, Enseignement, Métacognition, Cohérence) calculées par AGENT-05.
- **WHEN** Le mode M14 est activé.
- **THEN** le système SHALL rendre le polygone translucide bleu (profil utilisateur) sur 5 axes radiaux.
- **AND** le système SHALL superposer un polygone cible (pointillés vert/rouge).
- **AND** le clic sur un sommet ouvre les concepts responsables de cette dimension.
- **AND** les valeurs des axes sont bornées [0,100] (dynamic snapping).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Afficher des données statistiques non issues des agrégations réelles (DuckDB-WASM) ou du SMI (AGENT-05).
* ⚠️ **MUST** : Validation Zod des données analytiques ; circuit breaker sur requête lente.

---

## 5. Test cases & Validation
* **Test Case 1 (M7)** : Clic sur un pic d'oubli filtre les concepts concernés.
* **Test Case 2 (M7 fallback)** : Agrégation > 5s → fallback statique neutre.
* **Test Case 3 (M14)** : Polygone bleu + polygone cible superposés.
* **Test Case 4 (M14 bornes)** : Les valeurs des axes sont dans [0,100].
* **Test Case 5 (M14 clic)** : Clic sur un sommet ouvre les concepts responsables.

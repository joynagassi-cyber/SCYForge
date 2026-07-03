<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧠 SCY-SYNAPTIC-COMPETITION-RIF — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S11_NEURO_SYNAPTIC_COMPETITION_RIF_SPEC  
**Décision d'architecture** : D-OPT-010 (Fail-Safe Gate de Compétition Synaptique RIF)  
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
Cette spécification définit la **Compétition Synaptique RIF** (Retrieval-Induced Forgetting) avec sa **Fail-Safe Gate** (D-OPT-010). Le RIF modélise l'oubli induit par la récupération (rappeler un concept peut inhiber ses concurrents). La **Fail-Safe Gate** intègre un seuil d'amortissement de **90%** sur l'inhibition compétitive lorsque la vitalité synaptique d'un concept descend sous **25/100**, neutralisant à 100% tout risque d'**avalanche ou cascade d'effondrement**.

---

## 2. Tech Stack & Dependencies
* **Vitalité synaptique** : `V_n(t)` — sigmoïde robuste amortie (D-OPT-009, moteur engram_decay_vitality).
* **RIF** : inhibition compétitive entre concepts sémantiquement proches lors du rappel.
* **Fail-Safe Gate** : seuil d'amortissement 90% si V < 25 (D-OPT-010).
* **Vault** : `scy_engram_vault` (archivage dormance à J90, D-OPT-009).
* **Rétention** : mesurée APEX FSRS.

> **Rappel anti-hallucination** : le RIF suit la théorie Retrieval-Induced Forgetting (Anderson 1994+). La Fail-Safe Gate est une formule déterministe (amortissement 90% sous V<25). Aucune cascade incontrôlée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Modélisation du RIF

#### Scénario : Inhibition compétitive
- **GIVEN** Le rappel actif d'un concept A (session APEX).
- **WHEN** Des concepts concurrents (sémantiquement proches) existent.
- **THEN** le système SHALL appliquer l'inhibition compétitive RIF sur les concurrents.
- **AND** le système SHALL moduler cette inhibition par la vitalité `V_n(t)` des concurrents.

---

### Requirement : Fail-Safe Gate (Anti-Avalanche)

#### Scénario : Concept en basse vitalité
- **GIVEN** Un concept concurrent dont la vitalité synaptique V < 25/100.
- **WHEN** L'inhibition RIF s'applique.
- **THEN** le système SHALL appliquer un amortissement de **90%** sur l'inhibition compétitive (D-OPT-010).
- **AND** le système SHALL neutraliser à 100% le risque d'avalanche / cascade d'effondrement.
- **AND** si V descend au seuil de dormance → archivage dans `scy_engram_vault` (J90, D-OPT-009).

---

### Requirement : Prerequisite Booster (Anti-Dormance Bloquante)

#### Scénario : Prérequis dormant
- **GIVEN** Un nœud requis (ancêtre) pour le nœud courant est en dormance sémantique (V < 20 dans le vault).
- **THEN** le système SHALL planifier automatiquement un booster de révision de ce prérequis **avant** la session d'étude active (D-OPT-023).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Permettre une avalanche/cascade d'effondrement (Fail-Safe Gate obligatoire, D-OPT-010).
* 🚫 **SHALL NOT** : Lancer une session d'étude dont un prérequis est dormant sans booster (D-OPT-023).

---

## 5. Test cases & Validation
* **TC1 (RIF)** : Rappel de A → inhibition compétitive sur concurrents, modulée par V.
* **TC2 (Fail-Safe)** : Concurrent V < 25 → amortissement 90% de l'inhibition (pas d'avalanche).
* **TC3 (Dormance)** : V seuil dormance → archivage `scy_engram_vault` (J90).
* **TC4 (Prerequisite Booster)** : Ancêtre dormant (V<20) → booster planifié avant session active.
* **TC5 (No cascade)** : Simulation stress — aucune cascade d'effondrement (Fail-Safe validé).

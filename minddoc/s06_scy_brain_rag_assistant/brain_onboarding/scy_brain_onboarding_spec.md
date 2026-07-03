<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
BRAIN en MVP simplifié (BM25 FTS uniquement). Triple retrieval + live web différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🚀 SCY-BRAIN-ONBOARDING — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S06_BRAIN_ONBOARDING_SPEC  
**Phase** : Phase 0 (Guest) + Phase 1 (gamifié)  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

> **📌 RÉFÉRENCE** : La spec détaillée d'onboarding/clarification/évaluation est dans **`s03_ascent_pipeline_agents/onboarding_flow/scy_brain_onboarding_spec.md`**. Ce kit couvre le flow gamifié (§7.7ter).

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
L'**Onboarding Gamifié** réduit la friction d'inscription et maximise la conversion trial→signup. **TTFV < 5min** est une métrique critique. Pattern éprouvé : Duolingo (+40% rétention J7), Brilliant.

---

## 2. Requirements & Scenarios (RFC 2119)

### Requirement : Mode Guest (Phase 0)
#### Scénario : Essai sans compte
- **THEN** le système SHALL permettre la création d'un premier objectif ASCENT ou l'import d'une source **sans inscription**.
- **AND** les données temporaires sont stockées en localStorage (UUID session anonyme).
- **AND** la capture email est proposée **APRÈS** la première valeur vécue.
- **AND** si l'utilisateur crée un compte, son contenu guest migre automatiquement.

### Requirement : Flow Onboarding Gamifié (Phase 1)
#### Scénario : 5 étapes (< 90s au premier succès)
- **Étape 1** (15s) : Choix objectif → feedback immédiat.
- **Étape 2** (10s) : Niveau actuel (Débutant→Avancé).
- **Étape 3** (10s) : Temps disponible (15min→1h+).
- **Étape 4** (<90s) : Premier succès — 1 nœud ASCENT + 3 cartes APEX + 1 session révision → animation confetti + « Premier concept maîtrisé ! SMI : 45/100 🎉 ».
- **Étape 5** : Email capture post-succès.

### Requirement : Progress Bar Onboarding
- **THEN** le système SHALL afficher une barre de progression dès la première action (« Étape 1/4 »).
- **AND** célébration visuelle à chaque étape (micro-animation).

---

## 3. Métriques Cibles
| Métrique | Cible | Alerte |
|---------|-------|--------|
| Temps jusqu'à 1ère révision | < 2 min | > 5 min |
| Taux complétion onboarding | > 70% | < 50% |
| Conversion guest → compte | > 40% | < 25% |
| Rétention J7 (gamifié vs classique) | +20% | < +10% |

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Demander l'email AVANT la première valeur vécue.
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens `design.md`.

---

## 5. Test cases & Validation
* **TC1 (Guest)** : Objectif créé sans compte ; migration auto à l'inscription.
* **TC2 (Flow)** : 5 étapes ; premier succès < 90s (confetti + SMI 45).
* **TC3 (Progress bar)** : Barre visible dès l'étape 1.
* **TC4 (Métriques)** : TTFV < 2min ; complétion > 70% ; conversion > 40%.

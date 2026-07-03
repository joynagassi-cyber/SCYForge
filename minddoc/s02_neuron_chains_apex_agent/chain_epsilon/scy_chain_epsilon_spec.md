<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-CHAIN-EPSILON — GÉNÉRATION DOCUMENTS (SPEC)
**ID** : S02_NEURON_CHAIN_EPSILON_SPEC · **Phase** : MVP

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
La chaîne **EPSILON** génère les livrables pédagogiques : flashcards (5 types MVP B01-B05), exercices (Template Gold 6 sections, 4 niveaux difficulté), et QCM (4 choix, distracteurs intelligents).

## 2. Agents
* **EPSILON-1 Cartes Révision** : 5 types MVP (B01 Exposition, B02 Définition, B03 MCQ, B04 Short Answer, B05 Application).
* **EPSILON-2 Exercices** : Template Gold (contexte, question, hint, solution, explication, next_steps), 4 niveaux difficulté.
* **EPSILON-3 QCM** : 4 choix (1 correcte, 3 distracteurs plausibles = erreurs communes réelles).

## 3. Requirements (RFC 2119)
### Cartes & Exercices
- **GIVEN** Les concepts/relations de BETA.
- **THEN** EPSILON-1 SHALL générer 12 cartes/nœud (3×B02, 3×B03, 3×B04, 3×B05).
- **AND** EPSILON-2 SHALL générer des exercices Template Gold (6 sections, 4 niveaux).
### QCM Distracteurs
- **AND** EPSILON-3 SHALL générer des QCM avec distracteurs plausibles (erreurs communes réelles, pas aléatoires).
- **AND** chaque livrable SHALL être validé par Zod et persité (`scy_apex_cards`, `scy_ascent_exercises`).

## 4. Boundaries
🚫 Distracteurs aléatoires (erreurs communes réelles obligatoires). 🚫 Cartes inventées sans source.

## 5. Tests
- **TC1** : 12 cartes/nœud générées (B02-B05) validées Zod.
- **TC2** : Exercices Template Gold (6 sections, 4 niveaux).
- **TC3** : QCM distracteurs plausibles (erreurs communes, pas aléatoires).

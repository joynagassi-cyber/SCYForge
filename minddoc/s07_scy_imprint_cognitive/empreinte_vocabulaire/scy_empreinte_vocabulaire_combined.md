<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
IMPRINT ÉLIMINÉE. Contenu biblique incompatible avec cyber ops. Réécriture nécessaire.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-EMPREINTE-VOCABULAIRE — PLAN / TÂCHES / TESTS
**ID** : S07_IMPRINT_EMPREINTE_VOCABULAIRE_PLAN / TASKS / TESTS
---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | ELIMINATED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module est ÉLIMINÉ du beachhead**
• Conservé pour expansion future
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## Flux : [domaine linguistique] → sélection 10 mots (IA) → fiche étymologique (phonétique/étymo DELTA/définition GAMMA-3) → Tree Renderer (dérivation + 3 synonymes + phrase) → écriture manuscrite → validation active (synonyme exact OU Cloze L4) → déverrouillage mot suivant.
## Dépendances : DELTA (étymologie), GAMMA-3 (définition/exemple), Tree Renderer, Cloze. 
## Fichiers : `backend_rs/src/imprint/vocab/word_selector.rs`, `etymology_card.rs`, `validation.rs`.
## Tâches : EV.1 Sélection 10 mots + fiche étymologique (25min) | EV.2 Validation active (synonyme/Cloze L4) (20min).
## Tests : TC1 10 mots | TC2 fiche étymologique | TC3 validation active verrouille progression.

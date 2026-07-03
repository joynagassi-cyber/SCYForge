<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
IMPRINT ÉLIMINÉE. Contenu biblique incompatible avec cyber ops. Réécriture nécessaire.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📖 SCY-EMPREINTE-VOCABULAIRE — SPÉCIFICATION (SPEC)
**ID** : S07_IMPRINT_EMPREINTE_VOCABULAIRE_SPEC · **Phase** : v2.5 🔴 CRITIQUE · **Réf** : PRD §7.8

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

## 1. Purpose
L'**Empreinte Vocabulaire** est un module de mémorisation de vocabulaire d'élite : l'IA sélectionne **10 mots complexes, rares et stratégiques** (ex : *Sérendipité*, *Éphémère*, *Sycophante*). Chaque mot s'accompagne d'une fiche étymologique interactive (prononciation phonétique, étymologie, définition) et exige un **ancrage par écriture manuscrite** (friction intentionnelle).

## 2. Requirements (RFC 2119)
- **GIVEN** Un domaine d'apprentissage linguistique.
- **THEN** le système SHALL sélectionner 10 mots complexes/rares/stratégiques.
- **AND** le système SHALL générer une fiche étymologique (phonétique, étymologie DELTA, définition GAMMA-3).
- **AND** le système SHALL exiger l'écriture manuscrite de l'arbre de dérivation étymologique (Tree Renderer) + 3 synonymes + phrase d'exemple.
- **AND** le passage au mot suivant SHALL être verrouillé tant que l'apprenant n'a pas tapé le synonyme exact ou complété le Cloze d'usage (rappel actif L4).

## 3. Tests
- TC1 : 10 mots sélectionnés (complexes/stratégiques). | TC2 : Fiche étymologique complète. | TC3 : Validation active (synonyme/Cloze) verrouille la progression.

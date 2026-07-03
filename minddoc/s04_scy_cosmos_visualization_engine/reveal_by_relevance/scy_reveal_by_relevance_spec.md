<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎯 SCY-REVEAL-BY-RELEVANCE — SPÉCIFICATION (SPEC)
**ID** : S04_COSMOS_REVEAL_BY_RELEVANCE_SPEC · **Décision** : D-OPP-005 · **Phase** : P2 · **Réf** : arch v4.5 D-OPP-005

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
Le **Reveal by Relevance** (D-OPP-005) filtre dynamiquement l'affichage COSMOS pour masquer le superflu et recentrer l'attention exclusive sur les **150 concepts les plus pertinents** par rapport au contexte de l'étudiant (requêtes récentes, cours actif). Toggle « 🎯 Vue Pertinente », recalcul max 1×/30s.

## 2. Requirements (RFC 2119)
- **GIVEN** Le graphe COSMOS complet + le contexte étudiant (cours actif, requêtes récentes).
- **WHEN** L'utilisateur active « 🎯 Vue Pertinente ».
- **THEN** le système SHALL masquer les concepts non pertinents.
- **AND** le système SHALL afficher uniquement les 150 concepts les plus pertinents (cosine + contexte).
- **AND** le recalcul SHALL être limité à 1×/30s (performance).

## 3. Tests
- TC1 : Toggle → 150 concepts pertinents affichés. | TC2 : Recalcul ≤ 1×/30s. | TC3 : Pertinence basée sur contexte (cours actif + requêtes).

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 💡 SCY-PRESCRIPTIVE-INSIGHTS — SPÉCIFICATION (SPEC)
**ID** : S04_COSMOS_PRESCRIPTIVE_INSIGHTS_SPEC · **Phase** : P1 · **Réf** : master_specs §E, §7.4.7 B

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
Les **Insights Prescriptifs Déterministes** affichent un maximum de **3 recommandations actionnables** simultanées (Miller's Law 7±2) dans un panel flottant bas-gauche. Règles Rust pures ($0 LLM) : gaps, révisions overdue, clusters faibles. Chaque insight : titre court + explication + CTA avec temps estimé.

## 2. Requirements (RFC 2119)
- **GIVEN** L'état du graphe COSMOS + l'état d'apprentissage (FSRS, SMI, gaps).
- **THEN** le système SHALL afficher max 3 insights (Miller's Law) dans un panel flottant bas-gauche.
- **AND** chaque insight SHALL avoir : titre court + explication + CTA + temps estimé.
- **AND** le système SHALL calculer les insights via règles Rust pures ($0 LLM).
- **AND** l'urgence visuelle 'critical' → toast rouge pulsant 5s.

## 3. Tests
- TC1 : Max 3 insights affichés. | TC2 : Chaque insight = titre + explication + CTA + temps. | TC3 : $0 LLM (règles Rust). | TC4 : 'critical' → toast rouge pulsant.

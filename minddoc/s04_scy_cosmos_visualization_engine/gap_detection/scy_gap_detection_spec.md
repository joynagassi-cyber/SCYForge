<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🔍 SCY-GAP-DETECTION-VISUEL — SPÉCIFICATION (SPEC)
**ID** : S04_COSMOS_GAP_DETECTION_SPEC · **Phase** : P0-P1 · **Réf** : PRD §7.4.3bis A, §7.4.7 A

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
La **Gap Detection Visuel** identifie les **concepts prérequis manquants** dans la base de l'utilisateur et les affiche en **pointillés rouges** dans COSMOS. CTA « Combler cette lacune » → déclenche Agent-02 CONTENT-SCOUT. Feature killer différenciante, coût nul (petgraph Rust).

## 2. Requirements (RFC 2119)
- **GIVEN** Le graphe COSMOS (arêtes `prerequisite_of`).
- **WHEN** Le système traverse le graphe (petgraph, $0).
- **THEN** le système SHALL identifier les nœuds prérequis absents de la base utilisateur.
- **AND** le système SHALL les afficher en **pointillés rouges** dans COSMOS.
- **AND** le système SHALL offrir un CTA « Combler cette lacune » → Agent-02 (ingestion source + NEURON-CHAINS).
- **AND** le système SHALL intégrer les gaps dans la décision de remédiation de l'Agent-06.

## 3. Tests
- TC1 : Prérequis manquant → pointillés rouges COSMOS. | TC2 : CTA « Combler » → Agent-02 ingestion. | TC3 : Agent-06 intègre les gaps.

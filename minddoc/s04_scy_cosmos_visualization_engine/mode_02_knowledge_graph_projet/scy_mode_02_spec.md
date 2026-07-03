<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-02 — KNOWLEDGE GRAPH PROJET (SPEC)
**ID** : S04_COSMOS_MODE_02_SPEC · **Mode** : M2 — L'Espace d'Étude · **Moteur** : `@antv/g6` v5 (D-RENDER-001)

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
Le **MODE 2** est la **vue d'étude principale** de SCY Forge : graphe local du projet actif (<50 000 nœuds) avec interactions riches (drag, hover, ajouts à la volée). L'apprenant purge ses révisions quotidiennes depuis le graphe.

## 2. Requirements (RFC 2119)
### Rendu du graphe projet
- **GIVEN** Un graphe Graphology du projet actif (store Zustand, D-DATA-001).
- **WHEN** M2 activé.
- **THEN** le système SHALL le rendre via G6 v5 (nœuds cercles, diamètre ∝ PageRank local, couleur ∝ SMI Rouge→Or).
- **AND** les arêtes directionnelles stylisées selon `EDGE_SEMANTIC_STYLES` (D-UX-006).
- **AND** auras rouges clignotantes sur les concepts en retard FSRS + badge `📅 Xj`.
### Clic du nœud
- **WHEN** un nœud est cliqué.
- **THEN** le système SHALL ouvrir la **Knowledge Card v2 complète** (5 couches) et masquer les nœuds non connectés au-delà de 2-hops.
### Résilience
- **GIVEN** >30 000 nœuds sur appareil LOW/COMPAT.
- **THEN** le système SHALL bloquer le rendu auto et proposer un filtre de réduction (PageRank élevé).
- **AND** les écouteurs G6 sont détruits au désassemblage (useG6Graph, D-RESILIENCE-003).
### FSRS
- Clic sur les nœuds en retard (auras rouges) → purger révisions quotidiennes depuis le graphe.

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. ⚠️ Validation Zod du graphe ; nettoyage des écouteurs G6.

## 4. Tests
- **TC1** : Graphe rendu (diamètre ∝ PageRank, couleur ∝ SMI, auras rouges retard FSRS).
- **TC2** : Clic → Knowledge Card v2 complète + masquage >2-hops.
- **TC3** : >30 000 nœuds LOW/COMPAT → blocage + filtre proposé.
- **TC4** : Aucune fuite mémoire (écouteurs G6 détruits).
- **TC5** : Palette `design.md`.

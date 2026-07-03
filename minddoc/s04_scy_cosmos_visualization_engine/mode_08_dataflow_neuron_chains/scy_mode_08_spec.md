<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-08 — DATAFLOW NEURON-CHAINS (SPEC)
**ID** : S04_COSMOS_MODE_08_SPEC · **Mode** : M8 — La Vue Pipeline · **Moteur** : `@xyflow/react` v12 (D-RENDER-001/004)

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
Le **MODE 8** affiche les **flux d'exécution en streaming** des agents NEURON-CHAINS (de l'ingestion brute vers la carte finale). Augmente le sentiment de contrôle et de confiance (Self-Determination Theory) — transparence de l'IA.

## 2. Requirements (RFC 2119)
### Rendu pipeline animé
- **GIVEN** Des événements d'exécution EventBus d'ingestion en streaming.
- **WHEN** M8 activé.
- **THEN** le système SHALL dessiner des boîtes d'agents actifs via React Flow (couleur ∝ statut : Gris=attente, Bleu clignotant=en cours, Vert=terminé).
- **AND** les arêtes sont des pipelines SVG animés où des bulles de données circulent en temps réel.
- **AND** badge affichant le nombre de jetons compressés et les temps de traitement par agent.
### Clic & résilience
- **WHEN** clic sur un agent.
- **THEN** le système SHALL afficher les logs temps réel de l'agent (transparence de la pensée IA).
- **GIVEN** Thread principal surchargé.
- **THEN** les animations de flux de particules sont désactivées pour préserver la fluidité.

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 Max 1000 nœuds (D-RENDER-004).

## 4. Tests
- **TC1** : Boîtes agents (couleur ∝ statut) + pipelines animés + badge jetons.
- **TC2** : Clic agent → logs temps réel.
- **TC3** : Surcharge thread → animations désactivées.
- **TC4** : Palette `design.md`.

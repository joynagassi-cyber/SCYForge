<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-00 — BASE KNOWLEDGE BASE (SPEC)
**ID Spécification** : S04_COSMOS_MODE_00_SPEC  
**Mode** : M0 — L'Espace Universel  
**Moteur** : `@cosmograph/cosmos` v3 (D-RENDER-001)  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

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
Le **MODE 0** offre la vue d'ensemble de **toute la base de connaissances** de l'utilisateur sous la forme d'un graphe massif (1M+ nœuds) rendu sur GPU. Il représente l'espace universel sémantique, source de toute navigation drill-down vers les modes locaux.

---

## 2. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu GPU Massif
#### Scénario : Affichage de l'espace universel
- **GIVEN** La base de connaissances complète (Float32Array typed arrays via `graphologyToCosmos`, D-DATA-004).
- **WHEN** Le MODE 0 est activé.
- **THEN** le système SHALL rendre le graphe via Cosmos v3 sur GPU à 60 FPS.
- **AND** les nœuds auront une taille ∝ PageRank global et une couleur ∝ domaine majeur.
- **AND** les arêtes seront fines semi-transparentes (opacity 0.1-0.3) pour éviter le hairball.

### Requirement : Comportement au Clic du Nœud
#### Scénario : Drill-down vers le graphe projet
- **GIVEN** Un nœud cliqué dans l'espace universel.
- **WHEN** L'utilisateur clique.
- **THEN** le système SHALL zoomer vers la coordonnée (x,y), suspendre Cosmos global, charger le graphe local via `useProjectGraphStore` et ouvrir une Knowledge Card simplifiée.

### Requirement : Rétention FSRS & Résilience
#### Scénario : Oubli sémantique visuel
- **GIVEN** Des concepts oubliés (retrievability FSRS R < 50%).
- **THEN** le système SHALL réduire leur opacité graduellement (estompe les zones délaissées).
#### Scénario : Fallbacks
- **GIVEN** Cosmos met > 10s à s'initialiser ou perte WebGL.
- **THEN** le système SHALL basculer vers `@antv/g6` Canvas limité aux 2000 nœuds les plus pertinents (D-RESILIENCE-001/002).

---

## 3. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`. Halos activables uniquement par zoom sémantique LOD 3.
* ⚠️ **MUST** : Cosmos v3 asynchrone (`await graph.ready` avant toute méthode, D-RENDER-003).

---

## 4. Test cases & Validation
* **TC1 (Rendu)** : 1M nœuds rendus à 60 FPS sur GPU.
* **TC2 (Clic)** : Le clic charge le graphe local projet + Knowledge Card simplifiée.
* **TC3 (FSRS)** : Les concepts R<50% sont estompés.
* **TC4 (Fallback init)** : Init > 10s → G6 Canvas 2000 nœuds.
* **TC5 (Palette)** : Aucune couleur hors tokens.

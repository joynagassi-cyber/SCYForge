<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🕸️ SCY-ENGINE-G6 — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_ENGINE_G6_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
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
Cette spécification définit le comportement du **moteur de rendu engine_g6**, basé sur **AntV G6 (v5)**. Il assure le **rendu 2D WebGL haute performance** de la coupe axiale horizontale du graphe de connaissances COSMOS : disposition force-dirigée, gestion des grands graphes (LOD, Barnes-Hut), et rendu interactif des nœuds/arêtes. C'est le moteur 2D principal de COSMOS.

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + **AntV G6 v5** (Graph API v5, layouts force-directed, renderer WebGL).
* **Performance** : LOD (Level of Detail), Barnes-Hut (approximation n-body), Object Pooling (réutilisation des objets graphiques).
* **Design** : tokens `design.md` (Noir d'encre, Violet profond, Bleu électrique actif, Émeraude consolidée).
* **Intégration** : consommation des données du graphe COSMOS (nœuds + arêtes + poids), écoute de l'EventBus `KnowledgeGraphUpdated`.

> **Rappel anti-hallucination** : la production **DOIT** utiliser AntV G6 v5 (la simulation Canvas HTML5 n'était qu'un outil de validation labo). Palette stricte `design.md` — pas de rouge ni de bleu fade non autorisés.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu 2D de la Coupe Axiale Horizontale

#### Scénario : Affichage du graphe de connaissances
- **GIVEN** Un graphe COSMOS (nœuds + arêtes + poids) mis à jour (`KnowledgeGraphUpdated`).
- **WHEN** Le moteur engine_g6 rend le graphe.
- **THEN** le système SHALL afficher la coupe axiale horizontale 2D via AntV G6 v5 (renderer WebGL).
- **AND** le système SHALL appliquer une disposition force-dirigée respectant l'enveloppe axiale polaire.
- **AND** le système SHALL respecter les tokens chromatiques `design.md`.

---

### Requirement : Performance sur les Grands Graphes

#### Scénario : Gestion de la charge
- **GIVEN** Un graphe de grande taille (milliers de nœuds).
- **WHEN** Le rendu est sollicité.
- **THEN** le système SHALL activer le LOD (simplification selon le niveau de zoom).
- **AND** le système SHALL utiliser Barnes-Hut pour l'approximation des forces n-body.
- **AND** le système SHALL appliquer l'Object Pooling pour limiter les allocations.
- **AND** le système SHALL maintenir ≥ 30 FPS (objectif 60 FPS).

---

### Requirement : Interactivité

#### Scénario : Navigation et sélection
- **GIVEN** Un graphe rendu.
- **WHEN** L'utilisateur interagit (zoom, pan, sélection de nœud).
- **THEN** le système SHALL fournir les contrôles de navigation fluides (zoom/pan).
- **AND** le système SHALL permettre la sélection d'un nœud et l'affichage de son détail.

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Utiliser la simulation Canvas HTML5 en production (AntV G6 v5 obligatoire).
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Bloquer le thread principal (rendu WebGL, animations optimisées).
* ⚠️ **MUST** : Validation des données graphe par **Zod** avant rendu.

---

## 5. Test cases & Validation
* **Test Case 1 (Rendu)** : Un graphe COSMOS s'affiche en 2D axial via G6 v5 avec la palette officielle.
* **Test Case 2 (Performance)** : 5 000 nœuds rendus à ≥ 30 FPS avec LOD + Barnes-Hut actifs.
* **Test Case 3 (Interactivité)** : Zoom/pan/sélection fluides.
* **Test Case 4 (Palette)** : Aucune couleur hors tokens.

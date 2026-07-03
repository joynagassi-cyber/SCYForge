<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🌐 SCY-ENGINE-THREEJS — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_ENGINE_THREEJS_SPEC  
**Décision d'architecture** : D-RENDER-009  
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
Cette spécification définit le comportement du **moteur engine_threejs**, basé sur **three.js** (~450KB lazy-loadé). Il assure le **rendu volumétrique 3D de l'espace sémantique** (mode M23) : sphères lumineuses flottantes, cylindres de force translucides, navigation orbitale. Ce mode optionnel (Phase 3) exploite la **mémoire spatiale** (palais de mémoire) pour doubler l'efficacité du rappel. Roadmap de migration **WebGPU** en Phase 3.

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + **three.js** (intégration via `OrbitControls`).
* **Rendu** : WebGL2 volumétrique 3D à 60 FPS.
* **GPU check** : obligatoire — le mode est masqué si WebGL2 indisponible ou pas de GPU dédié (fallback M2 Knowledge Graph 2D).
* **Lazy-loading** : three.js chargé à la demande uniquement si M23 visité + GPU check OK (D-RENDER-009).
* **Données** : coordonnées tridimensionnelles (x,y,z) sur 3 axes orthogonaux (Concret↔Abstrait, Théorique↔Pratique, Fondamental↔Avancé).
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : three.js est la librairie réelle désignée par D-RENDER-009 pour M23. Palette stricte `design.md`. Le mode n'est activé qu'après GPU check positif.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu Volumétrique 3D (M23)

#### Scénario : Espace sémantique immersif
- **GIVEN** Des coordonnées 3D (x,y,z) des concepts.
- **WHEN** Le mode M23 est activé (GPU check OK).
- **THEN** le système SHALL rendre les sphères lumineuses (couleur ∝ domaine, diamètre ∝ importance).
- **AND** le système SHALL tracer les cylindres de force translucides reliant les sphères.
- **AND** le système SHALL afficher les axes de coordonnées sémantiques 3D en arrière-plan.
- **AND** le système SHALL maintenir 60 FPS.

---

### Requirement : Navigation Orbitale & Fly-To

#### Scénario : Exploration spatiale
- **GIVEN** Un espace 3D rendu.
- **WHEN** L'utilisateur interagit.
- **THEN** le système SHALL fournir Orbit Controls (rotation, pan).
- **AND** le clic sur une sphère déclenche une animation fly-to positionnant la caméra face à la sphère.
- **AND** le système SHALL déployer la Knowledge Card en 3D après fly-to.

---

### Requirement : GPU Check & Fallback

#### Scénario : Appareil incompatible
- **GIVEN** Un appareil sans WebGL2 ou sans GPU dédié.
- **WHEN** Le système évalue la compatibilité.
- **THEN** le système SHALL masquer le mode M23 de l'interface.
- **AND** le système SHALL remplacer M23 par le Mode 2 (Knowledge Graph 2D).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Activer M23 sans GPU check préalable.
* 🚫 **FORBIDDEN** : Inclure three.js (~450KB) dans le bundle initial (lazy-loading D-RENDER-009).
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* ⚠️ **MUST** : Validation Zod des coordonnées 3D avant rendu.

---

## 5. Test cases & Validation
* **Test Case 1 (Rendu 3D)** : Sphères + cylindres + axes rendus à 60 FPS.
* **Test Case 2 (Fly-to)** : Le clic déclenche l'animation fly-to + Knowledge Card 3D.
* **Test Case 3 (GPU check négatif)** : M23 masqué, remplacé par M2.
* **Test Case 4 (Lazy-load)** : three.js absent du bundle initial.
* **Test Case 5 (Axes sémantiques)** : Les 3 axes orthogonaux sont visibles.

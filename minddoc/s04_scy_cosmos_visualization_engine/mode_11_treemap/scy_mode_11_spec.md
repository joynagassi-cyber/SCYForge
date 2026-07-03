<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-MODE-11 — TREEMAP CONCEPTUEL (SPEC)
**ID** : S04_COSMOS_MODE_11_SPEC · **Mode** : M11 — L'Allocation de Connaissance · **Moteur** : `@antv/g2` v5 (D-RENDER-006) · **UX** : D-UX-MODES-003

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
Le **MODE 11** compare la masse documentaire et la maîtrise des sous-domaines via des **rectangles imbriqués** (Squarify). Surface ∝ nombre de cartes APEX, couleur ∝ Stabilité FSRS (Rouge→Vert).

## 2. Requirements (RFC 2119)
### Rendu treemap
- **GIVEN** Un JSON d'arborescence multiniveau Graphology.
- **WHEN** M11 activé.
- **THEN** le système SHALL le rendre via G2 v5 (partition Squarify WASM, surface ∝ volume cartes).
- **AND** couleur rectangle ∝ Stabilité FSRS globale du sous-domaine (Rouge→Vert).
### Clic drill-down & labels
- **WHEN** double-clic sur un rectangle.
- **THEN** le système SHALL l'agrandir pour occuper le viewport, révélant ses sous-rectangles.
- **AND** labels clamping : label affiché uniquement si largeur/hauteur ≥ police min 10px, sinon icône `?`.
### Résilience & FSRS
- **GIVEN** Resize fenêtre.
- **THEN** recalcul Squarify debounce 150ms.
- FSRS : compare le temps passé vs stabilité FSRS (identifier points de friction).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 G2 dans bundle initial.

## 4. Tests
- **TC1** : Rectangles rendus (surface ∝ volume, couleur ∝ FSRS).
- **TC2** : Double-clic → drill-down révèle sous-rectangles.
- **TC3** : Labels clamping (police min 10px, sinon `?`).
- **TC4** : Resize → recalcul debounce 150ms.
- **TC5** : Palette `design.md`.

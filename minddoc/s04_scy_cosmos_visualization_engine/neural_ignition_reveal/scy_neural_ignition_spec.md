<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# ✨ SCY-NEURAL-IGNITION-REVEAL — SPÉCIFICATION (SPEC)
**ID** : S04_COSMOS_NEURAL_IGNITION_SPEC · **Phase** : P1 · **Réf** : master_specs §3, D-UX-002

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
Le **Neural Ignition Reveal** est la cinématique d'ouverture de COSMOS en 4 phases, éliminant tout temps d'attente perçu (TTFV < 1s). Remplace les spinners classiques par une séquence d'allumage neural progressive.

## 2. Les 4 Phases

| Phase | Timing | Description |
|-------|--------|-------------|
| **1. La Constellation** | 0-500ms | Fond sombre cognitif + micro-particules flottantes (bruit de fond cérébral, WebGL shader) |
| **2. L'Étincelle des Hubs** | 500-1500ms | Concepts majeurs (PageRank élevé) s'allument comme nébuleuses pulsantes + faisceaux laser de connexions |
| **3. La Condensation** | 1500-2500ms | Sous-concepts apparaissent organiquement le long des lignes de force (clusters Louvain) + dé-zoom fluide caméra |
| **4. La Stabilisation** | 2500-3000ms | Simulation physique s'amortit + labels apparaissent (flou→net ultra-premium) |

## 3. Requirements (RFC 2119)
- **GIVEN** L'ouverture de COSMOS.
- **THEN** le système SHALL exécuter les 4 phases séquentiellement (TTFV < 1s perçu).
- **AND** le système SHALL NE JAMAIS afficher de spinner blanc (D-UX-002, D-COSMOS-017 Progressive Rendering).
- **AND** Phase 2 SHALL ordonner par PageRank ; Phase 3 SHALL grouper par clusters Louvain.

## 4. Tests
- TC1 : 4 phases séquentielles (Constellation→Hubs→Condensation→Stabilisation). | TC2 : Aucun spinner blanc. | TC3 : Phase 2 = PageRank ; Phase 3 = Louvain. | TC4 : TTFV perçu < 1s.

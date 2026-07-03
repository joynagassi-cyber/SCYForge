<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎬 SCY-GENERATIVE-CANVAS-AI (FLOWSEEK) — SPÉCIFICATION (SPEC)
**ID** : S02_NEURON_FLOWSEEK_SPEC · **Phase** : V1 🔴 HAUTE · **Réf** : PRD §7.4.3bis H

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Purpose
Le **Generative-Canvas-AI (FlowSeek)** est un composant d'illustration dynamique et interactif s'intégrant aux **slides ASCENT** et **pages de cours**. Au lieu d'afficher une infographie statique, NEURON-CHAINS émet un flux JSON d'événements traduisant un concept (architecture, processus, arbre de décision). Le frontend **React Flow + elkjs** dessine et anime le graphe **en temps réel à 60 FPS** sous les yeux de l'apprenant à mesure que l'explication textuelle s'écrit — effet d'explication cinématique (coût serveur = 0$, elkjs local).

## 2. Synergie InfographicAI ↔ FlowSeek
| Dimension | InfographicAI (factuel/quantitatif) | FlowSeek (structurel/procédural) |
|-----------|-------------------------------------|----------------------------------|
| Rôle | Synthétiser données (barres, camemberts, matrices) | Visualiser flux, étapes, dépendances, architectures |
| Rendu | Canvas 2D / SVG (recharts/nivo) | React Flow + elkjs (graphe nodal animé) |
| Exemple | « Comparaison des 3 algorithmes » | « Chemin d'un paquet réseau à travers 4 services » |

## 3. Requirements (RFC 2119)
- **GIVEN** Un concept structurel/procédural dans un cours ASCENT ou une slide.
- **WHEN** NEURON-CHAINS génère l'explication.
- **THEN** le système SHALL émettre un flux JSON d'événements (nœuds + arêtes + labels).
- **AND** le frontend React Flow + elkjs SHALL dessiner et animer le graphe à 60 FPS au fil de l'explication.
- **AND** le calcul de coordonnées SHALL s'exécuter localement via elkjs (0$ serveur).

## 4. Tests
- TC1 : Concept → flux JSON événements → graphe animé 60 FPS en temps réel. | TC2 : elkjs local (0$ serveur). | TC3 : Synergie avec InfographicAI (factuel vs structurel).

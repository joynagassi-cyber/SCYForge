# 🎭 SCY-COSMOS-ADAPTIVE-UX — SPÉCIFICATION (SPEC)
**ID** : S04_COSMOS_ADAPTIVE_UX_SPEC · **Décisions** : D-UX-004, D-UX-005, D-UX-007 · **Phase** : P1

## 1. Purpose
Le **COSMOS Adaptive UX** consolide les 3 features d'adaptation de l'interface COSMOS au profil et au comportement de l'utilisateur : **Persona Adaptive Interface** (3 modes expertise), **Behavioral Progressive Disclosure** (révélation au hover), et **Exploration Trail** (historique de navigation).

## 2. Les 3 Features

### A — Persona Adaptive Interface (D-UX-004)
3 modes d'expertise adaptant l'interface COSMOS :
| Mode | Profil | Comportement |
|------|--------|-------------|
| **Discoverer** | Novice | Max 50 nœuds affichés, aide contextuelle, labels forcés, tooltips ELI5 |
| **Analyst** | Intermédiaire | Max 300 nœuds, filtres avancés, pas de tooltips intrusifs |
| **Explorer** | Expert | Sans limite de nœuds, toutes features débloquées, raccourcis complets |
- Détection auto via Starter Evaluator / comportement observé
- Upgrade progressif possible (notification « Vous semblez prêt pour le mode Analyst »)

### B — Behavioral Progressive Disclosure (D-UX-005)
- L'information détaillée n'est révélée qu'au clic ou lors de **stationnements prolongés** (hover > 1.5s).
- L'espace visuel reste épuré par défaut (pas de surcharge).
- Exemples : badges de confiance apparaissent au survol, métadonnées FSRS au stationnement, actions rapides au clic droit.

### C — Exploration Trail (D-UX-007)
- Historique de navigation dans le graphe (max 10 étapes).
- Barre bas du graphe : breadcrumb visuel des nœuds visités.
- Permet de revenir en arrière (flèche ← → comme un navigateur web).
- Persistance session (reprise après fermeture).

## 3. Requirements (RFC 2119)
- **A** : Le système SHALL adapter l'interface selon le mode expertise (Discoverer ≤50 nœuds / Analyst ≤300 / Explorer illimité).
- **B** : Le système SHALL révéler l'info détaillée uniquement au clic ou hover > 1.5s.
- **C** : Le système SHALL maintenir un historique de navigation (max 10 étapes + breadcrumb).

## 4. Tests
- TC1 : Discoverer → max 50 nœuds + tooltips ELI5. | TC2 : Upgrade progressif notifié. | TC3 : Hover > 1.5s → métadonnées révélées. | TC4 : Exploration Trail 10 étapes + breadcrumb + flèches ← →. | TC5 : Persistance session.

# 🔀 SCY-MULTI-VIEW-TOGGLES — SPÉCIFICATION (SPEC)
**ID** : S02_NEURON_MULTI_VIEW_TOGGLES_SPEC · **Phase** : V1 🔴 CRITIQUE · **Réf** : PRD §7.4.3bis I

## 1. Purpose
Le **Moteur de Rendu Technique Multi-Vues** (inspiré Notion) permet à l'utilisateur de basculer le format d'affichage de tout bloc technique généré par l'IA en **1 clic**. L'apprenant n'est jamais bloqué : s'il ne comprend pas l'équation mathématique, il bascule sur l'explication sémantique ou le schéma visuel.

## 2. Les Vues Combinables (toggle à 50+ styles)
Pour tout bloc technique :
- **Vue Mathématique** : formule LaTeX compilée (KaTeX, 60 FPS, $0 serveur)
- **Vue Sémantique** : explication textuelle (ELI5 → ELI PhD selon niveau)
- **Vue Code** : script Python/Rust d'application (Shiki/Prism coloration + bouton [▶ Exécuter] WASM local)
- **Vue Graphique** : micro-coordonnée COSMOS
- **Vue Diagramme** : Mermaid.js ou AntV Infographic

## 3. Requirements (RFC 2119)
- **GIVEN** Un bloc technique généré (équation, algorithme, processus).
- **WHEN** L'utilisateur clique sur le menu de basculement.
- **THEN** le système SHALL permettre de basculer entre les vues (Math ↔ Sémantique ↔ Code ↔ Graphique ↔ Diagramme) en 1 clic.
- **AND** la Vue Mathématique SHALL compiler le LaTeX via KaTeX (60 FPS, $0).
- **AND** la Vue Code SHALL offrir un bouton [▶ Exécuter] (WASM local, résultat en direct).
- **AND** le système SHALL respecter la loi L7 (Contrôle perçu) et le Double Codage.

## 4. Tests
- TC1 : Basculement Math ↔ Sémantique ↔ Code ↔ Graphique ↔ Diagramme en 1 clic. | TC2 : KaTeX LaTeX compilé 60 FPS. | TC3 : [▶ Exécuter] WASM → résultat en direct.

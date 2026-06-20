# 🟡 SCY-CHAIN-ZETA — RÉVISION QUALITÉ (SPEC)
**ID** : S02_NEURON_CHAIN_ZETA_SPEC · **Phase** : V2

## 1. Purpose
La chaîne **ZETA** révise la qualité rédactionnelle : harmonisation stylistique (ZETA-1, terminologie cohérente), optimisation de clarté (ZETA-2, simplification jargon), et adaptation des tons (ZETA-3, application 50 tons T01-T50 mappés sur 5 régimes).

## 2. Agents
* **ZETA-1 Harmoniseur Style** : terminologie cohérente sur tout le document.
* **ZETA-2 Optimiseur Clarté** : simplification, réduction jargon.
* **ZETA-3 Adaptateur Tons** : application 50 tons (T01-T50) mappés sur 5 régimes éditoriaux (cf. `scy_cosmos_document_synthesis_specs.md`).

## 3. Requirements (RFC 2119)
- **GIVEN** Les documents validés par DELTA.
- **THEN** ZETA-1 SHALL harmoniser la terminologie ; ZETA-2 SHALL simplifier le jargon ; ZETA-3 SHALL appliquer le ton sélectionné (T14 StyleEnforcer).
- **AND** le StyleEnforcer SHALL injecter le gabarit XML (squelette + régime de ton) pour garantir la qualité sur petits modèles.

## 4. Tests
- **TC1** : Terminologie cohérente sur tout le document.
- **TC2** : Jargon simplifié (clarté optimisée).
- **TC3** : Ton appliqué correctement (T14 StyleEnforcer + gabarit XML).

# 🟠 SCY-CHAIN-GAMMA — ENRICHISSEMENT (SPEC)
**ID** : S02_NEURON_CHAIN_GAMMA_SPEC · **Phase** : V1

## 1. Purpose
La chaîne **GAMMA** enrichit le contenu généré : contexte historique/applications réelles (GAMMA-1), analogies pédagogiques (GAMMA-2), exemples concrets/contre-exemples/edge cases (GAMMA-3).

## 2. Agents
* **GAMMA-1 Contextualiseur** : histoire du concept, applications réelles.
* **GAMMA-2 Générateur Analogies** : métaphores pédagogiques (cartes B06).
* **GAMMA-3 Créateur Exemples** : cas concrets, contre-exemples, edge cases.

## 3. Requirements (RFC 2119)
- **GIVEN** Les documents/cards générés par EPSILON.
- **THEN** GAMMA-1 SHALL ajouter contexte (historique, applications) ; GAMMA-2 SHALL générer analogies (B06) ; GAMMA-3 SHALL créer exemples + contre-exemples + edge cases.
- **AND** tout enrichissement SHALL être tracé vers une source (anti-hallucination couche 1).

## 4. Tests
- **TC1** : Contexte historique/applications ajouté et tracé.
- **TC2** : Analogies B06 générées.
- **TC3** : Exemples + contre-exemples + edge cases pertinents.

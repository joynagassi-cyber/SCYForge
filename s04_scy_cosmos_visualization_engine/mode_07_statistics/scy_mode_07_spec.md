# 🟢 SCY-MODE-07 — STATISTICS (SPEC)
**ID** : S04_COSMOS_MODE_07_SPEC · **Mode** : M7 — La Vue de Performance · **Moteur** : `recharts` v2

## 1. Purpose
Le **MODE 7** est la **tour de contrôle métacognitive** : courbes de rétention, barres de performance, nuages de points. L'apprenant visualise objectivement sa mémorisation et la décroissance de l'oubli théorique.

## 2. Requirements (RFC 2119)
### Rendu analytique
- **GIVEN** Des agrégations analytiques DuckDB-WASM.
- **WHEN** M7 activé.
- **THEN** le système SHALL rendre barres/courbes/nuages via recharts.
- **AND** indicateurs de réussite globale en en-tête.
### Clic & résilience
- **WHEN** clic sur un point (ex : pic d'oubli un mardi).
- **THEN** le système SHALL filtrer les concepts concernés par cette statistique.
- **GIVEN** Agrégation DuckDB-WASM > 5s.
- **THEN** le circuit breaker interrompt et affiche un fallback neutre statique (D-RESILIENCE-005).

## 3. Boundaries
- 🚫 Couleurs hors tokens `design.md`. 🚫 Données non issues des agrégations réelles. ⚠️ Circuit breaker.

## 4. Tests
- **TC1** : Graphiques rendus (barres/courbes/nuages, indicateurs en-tête).
- **TC2** : Clic point → filtre concepts concernés.
- **TC3** : Agrégation >5s → fallback statique neutre.
- **TC4** : Palette `design.md`.

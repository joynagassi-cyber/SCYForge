# 🛡️ SCY-ANTI-HALLUCINATION — 3 COUCHES + SCORE CONFIANCE (SPEC)
**ID** : S02_NEURON_ANTI_HALLUCINATION_SPEC · **Décision** : NC-003 (Prévention > guérition)

## 1. Purpose
Le système anti-hallucination garantit que tout contenu généré est **ancré dans les sources ingérées**, **cross-checké**, et **scoré**. Objectif : <1% hallucinations, score moyen ≥ 85/100.

## 2. Les 3 Couches

### Couche 1 — Ancrage RAG Strict (Prévention)
- Tout prompt de génération contient UNIQUEMENT des chunks récupérés des sources ingérées (similarity > 0.70).
- Instruction système : « N'écris QUE ce qui est dans le contexte fourni. »
- Sources vérifiées : reliability_score > 0.60 (T07 SourceVerifier).

### Couche 2 — Cross-Check Multi-Agents (Détection)
- T08 CitationTracker : lie chaque phrase à une source (similarity assertion↔source). Seuil < 0.60 → `HallucinationRisk::High`.
- T11 FactChecker : vérifie assertions High-risk via nouveau retrieval RAG. Verified → maintenu / Unsupported → réécrit ou supprimé avec note / Contradicted → supprimé.

### Couche 3 — Scoring Probabiliste (Quantification)
- T10 SectionScorer : dimension anti-hallucination (0-100).
- T12 ConfidenceCalc : score global + pénalités assertions non vérifiées.
- Seuils : ≥85 export / 70-84 réécriture ciblée / 50-69 complète / <50 alerte.

## 3. Requirements (RFC 2119)
- **GIVEN** Tout contenu généré.
- **THEN** le système SHALL appliquer les 3 couches (prévention → détection → quantification).
- **AND** le système SHALL produire un rapport de confiance par section + global (`scy_confidence_reports`).

## 4. Tests
- **TC1** : Assertion sans source (similarity < 0.60) → marquée High-risk.
- **TC2** : Assertion unsupported → réécrite/supprimée avec note éditoriale.
- **TC3** : Score confiance par section calculé ; rapport généré (`scy_confidence_reports`).
- **TC4** : Score < 50 → alerte utilisateur ; ≥ 85 → export.
- **TC5** : Taux hallucination < 1% sur corpus test.

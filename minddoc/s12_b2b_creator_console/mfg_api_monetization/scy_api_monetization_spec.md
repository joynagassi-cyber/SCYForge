<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
B2B Creator Console ÉLIMINÉE. Conservée Enterprise Tier Phase 2.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 💰 SCY-API-MONETIZATION — SPÉCIFICATION (SPEC)
**ID** : S12_B2B_API_MONETIZATION_SPEC · **Phase** : V2+ · **Réf** : PRD §12, `scy_api_monetization_specs.md`

> **📌 RÉFÉRENCE CROISÉE** : Les specs de monétisation API sont dans **`scy_api_monetization_specs.md`** (2.4KB). Ce fichier en est le résumé SDD.

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | ELIMINATED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module est ÉLIMINÉ du beachhead**
• Conservé pour expansion future
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Purpose
Le module **API Monetization (MFG API)** permet aux entreprises tierces et créateurs d'accéder aux fonctionnalités SCY Forge via une API payante (ingestion, génération NEURON-CHAINS, COSMOS, APEX) selon un modèle de facturation à l'usage (usage-based pricing).

## 2. Requirements (RFC 2119)
- **GIVEN** Un partenaire B2B avec une clé API.
- **THEN** le système SHALL exposer les endpoints SCY Forge (ingestion, génération, COSMOS, APEX) via API authentifiée.
- **AND** le système SHALL facturer à l'usage (tokens LLM, appels API, ingestion).
- **AND** le système SHALL appliquer le rate limiting et les quotas par tier (Free/Lite/Pro/Ultra).
- **AND** le BudgetGuard SHALL surveiller la consommation par clé API.

## 3. Tests
- TC1 : Endpoints API accessibles (clé API authentifiée). | TC2 : Facturation à l'usage correcte. | TC3 : Rate limiting + quotas par tier. | TC4 : BudgetGuard par clé API.

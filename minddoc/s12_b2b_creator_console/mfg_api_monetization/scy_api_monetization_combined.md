<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
B2B Creator Console ÉLIMINÉE. Conservée Enterprise Tier Phase 2.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-API-MONETIZATION — PLAN / TÂCHES / TESTS
**ID** : S12_B2B_API_MONETIZATION_PLAN / TASKS / TESTS
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

## Flux : [partenaire B2B + clé API] → endpoints SCY Forge (ingestion/génération/COSMOS/APEX) → auth API + rate limiting/quotas par tier → facturation à l'usage (tokens/appels/ingestion) → BudgetGuard par clé API.
## Référence : `scy_api_monetization_specs.md`.
## Dépendances : BudgetGuard, rate limiting, facturation usage-based. 
## Fichiers : `backend_ts/src/b2b/api/api_gateway.ts`, `usage_billing.ts`, `api_rate_limiter.ts`.
## Tâches : AM.1 Endpoints API + auth clé API (25min) | AM.2 Facturation à l'usage + quotas tier (25min) | AM.3 BudgetGuard par clé API (20min).
## Tests : TC1 endpoints auth | TC2 facturation usage | TC3 rate limiting+quotas | TC4 BudgetGuard/clé.

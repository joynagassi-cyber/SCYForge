<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Standards architecturaux — ajouter section beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 💎 SCY-PRICING-TIERS — SPÉCIFICATION (SPEC)
**ID** : S00_PRICING_TIERS_SPEC · **Phase** : MVP · **Réf** : PRD §10.2 Mécanisme 7, §10.4

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
Système de **4 tiers d'abonnement** avec **ségrégation stricte des modèles LLM** et quotas, garantissant des marges positives à chaque niveau.

## 2. Les 4 Tiers

| Tier | Prix | Modèles autorisés | Quotas clés | Marge LLM |
|------|------|-------------------|-------------|-----------|
| **Free** | 0 $/mois | DeepSeek V4 Flash/Pro uniquement (modèles fermés **interdits**) | 3 docs/mois, 15 BRAIN/jour, 1 parcours (max 5 nœuds) | ~0.018 $/user (couvert freemium) |
| **Lite** | 5 $/mois | + Claude Sonnet 4.6 (bridé). **Pas d'Opus 4.8** | 10 docs/mois, 50 BRAIN/jour, 2 parcours (max 8 nœuds) | >96% (~9.62 $ net) |
| **Pro** | 15 $/mois | + Claude Opus 4.8 (DAG/AGENT-16/QA uniquement) + Claude Sonnet 4.6 + DeepSeek Pro | 50 docs/mois, chat illimité, 5 parcours (max 15 nœuds), 3 ARENA/mois, CHRONICLE | >89% (~17.84 $ net) |
| **Ultra** | 45 $/mois | Claude Opus 4.8 (toutes tâches) + Sonnet + DeepSeek Pro | Illimité tout + priorisation calcul Northflank | >90% (~40.50 $ net) |

## 3. Ségrégation des Modèles (Critique)
- **Free** : DeepSeek V4 Flash/Pro UNIQUEMENT. Claude Sonnet/Opus = **strictement interdits et désactivés**.
- **Lite** : Claude Sonnet 4.6 (quotas restrictifs). Claude Opus 4.8 = inaccessible.
- **Pro** : Claude Opus 4.8 réservé DAG + AGENT-16 + comité QA. Claude Sonnet 4.6 pour écriture/remédiations.
- **Ultra** : Claude Opus 4.8 pour toutes tâches de calcul/réflexion.

## 4. Requirements (RFC 2119)
- **THEN** le système SHALL interdire l'accès aux modèles fermés pour le Free tier (DeepSeek uniquement).
- **AND** le système SHALL appliquer les quotas par tier (docs/parcours/nœuds/BRAIN/ARENA).
- **AND** le BudgetGuard SHALL surveiller la consommation par tier.
- **AND** le système SHALL maintenir une marge brute LLM > 89% sur tous les tiers payants.

## 5. Tests
- TC1 : Free → Claude désactivé (DeepSeek uniquement). | TC2 : Lite → Sonnet accessible, Opus bloqué. | TC3 : Pro → Opus réservé DAG/AGENT-16/QA. | TC4 : Quotas par tier respectés. | TC5 : Marge > 89% (Pro/Ultra).

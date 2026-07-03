<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-AG12-VISUAL-CRITIC — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG12_VISUAL_CRITIC_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

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

## 1. Flux de Données de l'Agent

```
 [Rendu COSMOS / figure / infographie]
                 │
                 ▼
   [Step Mastra : visualCriticStep]
                 │
        ┌────────┼─────────────┬──────────────┐
        ▼         ▼             ▼              ▼
  [Métriques   [Conformité    [Contraste     [Justesse
   lisibilité   tokens         WCAG]          sémantique
   (densité,    design.md]                    AGENT-13]
   chevauch.) ]
        │         │             │              │
        └────────┬─────────────┴──────────────┘
                 ▼
   [Critique visuelle (Zod VisualCritiqueSchema)]
                 │
        ┌────────┴────────┐
        ▼                 ▼
  [Défauts détectés     [Rendu conforme
   → recommandations    → validation]
   → ajustements COSMOS]
```

---

## 2. Dépendances Techniques Strictes
* **Métriques visuelles** : densité, chevauchements, lisibilité labels, contraste.
* **Tokens design** : `design.md` (palette officielle).
* **WCAG** : vérification de contraste.
* **AGENT-13** : justesse sémantique.
* **Zod** : `VisualCritiqueSchema`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag12_visual_critic.ts`** : Step Mastra (critique visuelle).
- **`backend_ts/src/ascent/visual/readability_metrics.ts`** : Métriques de lisibilité (densité, chevauchements).
- **`backend_ts/src/ascent/visual/design_compliance.ts`** : Conformité tokens + WCAG.
- **`backend_ts/src/ascent/schemas/visual_critique_schema.ts`** : Schéma Zod.

# 🛠️ SCY-AG12-VISUAL-CRITIC — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG12_VISUAL_CRITIC_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

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

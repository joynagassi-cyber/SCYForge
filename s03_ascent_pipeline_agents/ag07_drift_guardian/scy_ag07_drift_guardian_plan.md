# 🛠️ SCY-AG07-DRIFT-GUARDIAN — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG07_DRIFT_GUARDIAN_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données de l'Agent

```
 [Métriques comportementales continues]
 (session, SMI AG05, fréquence, échecs, COSMOS engagement)
                 │
                 ▼
   [Évaluation des 8 signaux de drift]
                 │
        ┌────────┴────────────┐
        ▼                     ▼
  [Seuil franchi ?]     [Aucun signal]
        │                     │
        ▼                     ▼
  [DriftDetected           (continuer surveillance)
   { signal_type, severity }]
        │
        ▼
  [Score de risque consolidé (agrégation)]
        │
   ┌────┴─────┬──────────┬─────────────┐
   ▼          ▼          ▼             ▼
 [CHRONICLE  [AGENT-08   [AGENT-06     [Rate-limit
  rappel]    micro-obj]  simplif.]     anti-spam]

 [Écoute parallèle : DLQ → notification erreurs système]
```

---

## 2. Dépendances Techniques Strictes
* **Signaux** : 8 signaux (inactivité, déclin SMI, sauts prérequis, baisse fréquence, échecs répétés, fatigue, désengagement COSMOS, feedback négatif).
* **Agents partenaires** : AGENT-05, AGENT-08, AGENT-10, AGENT-06.
* **DLQ** : Dead Letter Queue (capture des événements échoués).
* **Zod** : `DriftAlertSchema`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag07_drift_guardian.ts`** : Step Mastra (surveillance + ré-engagement).
- **`backend_ts/src/ascent/drift/signal_evaluator.ts`** : Évaluation des 8 signaux + score consolidé.
- **`backend_ts/src/ascent/schemas/drift_alert_schema.ts`** : Schéma Zod des alertes.
- **`scy_outbox` / DLQ** : Notifications d'erreurs.

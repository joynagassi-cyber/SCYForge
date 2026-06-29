# SCY Forge — WDS-4 UX Design — Batch 08 : Harmonist / Normal Mode / Neuroscience / PivotIQ (SC-055 → SC-062)
_Phase WDS-4_
_Source WDS-3 : `design-artifacts/C-UX-Scenarios/batch-08-harmonist-normal-neuro-pivotiq.md`_

---

## Vue UX globale — Harmonist / Normal Mode / Neuroscience / PivotIQ
Ces 4 sous-systèmes ont en commun d’être des **modes experts ou de supervision** :
- **Harmonist** : qualité / conformité
- **Normal Mode / Orchestrator** : exécution standard
- **Neuroscience Engine** : lecture neurocognitive
- **PivotIQ** : feature pivot / reconciliation

Leur UX doit rester **lisible sans expertise préalable** : progression visible, diagnostic clair, undo/retry explicite.

---

## SC-055 — Harmonist : lancer un audit qualité
### Wireframe
```
┌──────────────────────────────────────┐
│ Harmonist                            │
│                                      │
│ [Lancer un audit]                    │
│ Cibles : Dernier ingest              │
│                                      │
│ ▸ Scan concepts      100% • 12s     │
│ ▸ Vérification doublons 45% • 8s    │
└──────────────────────────────────────┘
```

---

## SC-056 — Harmonist : consulter un rapport d’anomalies
### Wireframe
```
┌──────────────────────────────────────┐
│ Harmonist — Rapport                  │
│                                      │
│ 3 anomalies                          │
│ - Concept dupliqué (§2.1 / §4.3)    │
│ - Référence manquante                │
│ - Structure incohérente              │
│                                      │
│ [Ignorer] [Corriger] [Relancer]      │
└──────────────────────────────────────┘
```

---

## SC-057 — Harmonist : corriger une anomalie guidée
### Wireframe
```
┌──────────────────────────────────────┐
│ Harmonist — Correction               │
│                                      │
│ Anomalie : Duplication §2.1 / §4.3   │
│                                      │
│ [Garder la version A]  [Fusionner]   │
│ [Supprimer la duplication]           │
└──────────────────────────────────────┘
```

---

## SC-058 — Normal Mode : lancer un traitement standard
### Wireframe
```
┌──────────────────────────────────────┐
│ Normal Mode                          │
│                                      │
│ Source : corpus_2026-06              │
│ Mode : Standard                      │
│                                      │
│ [Lancer]                             │
└──────────────────────────────────────┘
```

---

## SC-059 — Normal Mode : suivre l’orchestration
### Wireframe
```
┌──────────────────────────────────────┐
│ Normal Mode — Orchestration          │
│                                      │
│ ▸ Ingestion   Terminé   • 14s        │
│ ▸ Génération  En cours  • 37%        │
│ ▸ Validation  En attente             │
│                                      │
│ [Pause] [Arrêter]                    │
└──────────────────────────────────────┘
```

---

## SC-060 — Neurosciences : afficher un profil cognitif
### Wireframe
```
┌──────────────────────────────────────┐
│ Neurosciences                        │
│                                      │
│ Mémoire      78%                     │
│ Attention    64%                     │
│ Rigidité     41%                     │
│                                      │
│ [Comparer] [Exporter]                │
└──────────────────────────────────────┘
```

---

## SC-061 — Neurosciences : simuler un changement de mode
### Wireframe
```
┌──────────────────────────────────────┐
│ Neurosciences — Simulation           │
│                                      │
│ Mode cible : Focus profond            │
│                                      │
│ Impact estimé :                      │
│ - Mémoire +8%                        │
│ - Attention +3%                      │
│                                      │
│ [Appliquer] [Annuler]                │
└──────────────────────────────────────┘
```

---

## SC-062 — PivotIQ : relancer une feature pivot
### Wireframe
```
┌──────────────────────────────────────┐
│ PivotIQ                              │
│                                      │
│ Dernier pivot : Data ingestion       │
│ Statut : À valider                   │
│                                      │
│ [Relancer] [Modifier] [Revenir]      │
└──────────────────────────────────────┘
```

---

## Séquence UX résumée
1. Harmonist : détection corrective
2. Normal Mode : exécution standard
3. Neurosciences : lecture / simulation cognitive
4. PivotIQ : pivot/rollback explicite

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../C-UX-Scenarios/batch-08-harmonist-normal-neuro-pivotiq.md` | WDS-3 | Sources SC-055→SC-062 |
| `.../D-UX-Design/batch-08-harmonist-normal-neuro-pivotiq.md` | WDS-4 | Spécifications UX |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

# SCY Forge — WDS-4 UX Design — Batch 06 : ASCENT (SC-043 → SC-050)
_Phase WDS-4_
_Source WDS-3 : `design-artifacts/C-UX-Scenarios/wds3-strategic-context.md`_

---

## Vue UX globale — ASCENT

ASCENT est un **orchestrateur visuel** d’agents.  
L’utilisateur supervise, configure et lit les logs sans jamais toucher au runtime.

### États applicatifs
- Idle : pas de pipeline
- Draft : pipeline configuré mais non lancé
- Running : exécution en cours (streaming logs + progression)
- Succeeded / Failed : états finaux avec relecture possible

---

## SC-043 — Ouvrir ASCENT depuis le Dashboard
### Wireframe
```
┌──────────────────────────────────────┐
│ Dashboard                            │
│                                      │
│ Dernière orchestration : #A18        │
│                                      │
│ [Ouvrir ASCENT]                      │
└──────────────────────────────────────┘
```

---

## SC-044 — Configurer une chaîne simple d’agents
### Wireframe
```
┌──────────────────────────────────────┐
│ ASCENT — Pipeline                    │
│                                      │
│ [Ingestor] → [Parser] → [Indexer]   │
│                                      │
│ [Ajouter un agent]  [Réinitialiser]  │
└──────────────────────────────────────┘
```

---

## SC-045 — Visualiser l’exécution d’un pipeline
### Wireframe
```
┌──────────────────────────────────────┐
│ ASCENT — Exécution                   │
│                                      │
│ ▸ Ingestor       Terminé    • 18s   │
│ ▸ Parser         En cours   • 42%   │
│ ▸ Indexer        En attente • —     │
│                                      │
│ [Voir les logs] [Arrêter]            │
└──────────────────────────────────────┘
```

---

## SC-046 — Consulter les logs d’un agent
### Wireframe
```
┌──────────────────────────────────────┐
│ ASCENT — Logs                        │
│                                      │
│ 14:02:01 INFO  Extraction OK         │
│ 14:02:02 INFO  Chunk #12 créé        │
│ 14:02:03 WARN  Retry #1              │
│                                      │
│ [Copier] [Filtrer] [Télécharger]     │
└──────────────────────────────────────┘
```

---

## SC-047 — Gérer un échec pipeline
### Wireframe
```
┌──────────────────────────────────────┐
│ ASCENT — Échec                       │
│                                      │
│ ⚠ Parser a échoué (timeout 30s)     │
│                                      │
│ [Relancer] [Ignorer] [Modifier config]│
│ [Voir les logs]                      │
└──────────────────────────────────────┘
```

---

## SC-048 — Planifier un pipeline récurrent
### Wireframe
```
┌──────────────────────────────────────┐
│ ASCENT — Planification               │
│                                      │
│ Pipeline : Reporting hebdo           │
│ Récurrence : [Hebdomadaire ▼]       │
│ Jour : [Lundi]                       │
│ Heure : 06:00                        │
│                                      │
│ [Enregistrer]                        │
└──────────────────────────────────────┘
```

---

## SC-049 — Activer les notifications ASCENT
### Wireframe
```
┌──────────────────────────────────────┐
│ ASCENT — Notifications               │
│                                      │
│ Succès  [x]                          │
│ Échec   [x]                          │
│ Slack   [ ]                          │
│ Email   [x]                          │
│                                      │
│ [Enregistrer]                        │
└──────────────────────────────────────┘
```

---

## SC-050 — Basculer vers le mode expert ASCENT
### Wireframe
```
┌──────────────────────────────────────┐
│ ASCENT — Mode expert                 │
│                                      │
│ Variables contexte  [JSON ▼]        │
│ Retry policy       [3 ▼]            │
│ Timeout            [30s ▼]          │
│ Fallback           [Aucun ▼]        │
│                                      │
│ [Prévisualiser] [Lancer]             │
└──────────────────────────────────────┘
```

---

## Séquence résumée ASCENT

1. Ouvrir ASCENT
2. Configurer pipeline (SC-044)
3. Lancer / suivre (SC-045)
4. Consulter logs (SC-046)
5. Gérer échec (SC-047)
6. Planifier / notifier (SC-048 / SC-049)
7. Basculer expert (SC-050)

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../C-UX-Scenarios/batch-06-ascent.md` | WDS-3 | Sources SC-043→SC-050 |
| `.../D-UX-Design/batch-06-ascent.md` | WDS-4 | Spécifications UX |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

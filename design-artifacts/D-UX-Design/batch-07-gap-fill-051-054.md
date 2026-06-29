# SCY Forge — WDS-4 UX Design — Batch 07 : Gap fill SC-051 → SC-054
_Phase WDS-4_
_Source WDS-3 : `design-artifacts/C-UX-Scenarios/batch-07-gap-fill-051-054.md`_

---

## Vue globale — Bloc Administrer / Collaborer / Notifier / Exporter

Ce groupe comble le manque entre ASCENT (SC-050) et Harmonist/Normal/Neuro/PivotIQ (SC-055).  
Il couvre 4 scénarios transversaux : administration, collaboration, notifications et export.

### États partagés
- Notifications : unread / read / snoozed
- Collaborations : pending / accepted / revoked
- Exports : queued / downloading / failed

---

## SC-051 — Administrer les préférences administrateur
### Wireframe
```
┌──────────────────────────────────────┐
│ Admin — Préférences                  │
│                                      │
│ [ ] Double authentification          │
│ [ ] Journalisation étendue           │
│ [ ] Mode maintenance                 │
│                                      │
│ [Enregistrer]                        │
└──────────────────────────────────────┘
```

---

## SC-052 — Gérer les accès collaborateurs
### Wireframe
```
┌──────────────────────────────────────┐
│ Admin — Collaborateurs               │
│                                      │
│ julien@co.io  Éditeur   [Révoquer]   │
│ marie@co.io   Lecteur   [Révoquer]   │
│                                      │
│ [+ Inviter]                          │
└──────────────────────────────────────┘
```

---

## SC-053 — Recevoir une notification système push
### Wireframe
```
┌──────────────────────────────────────┐
│ 🔔 Notifications                     │
│                                      │
│ Pipeline terminé    2 min            │
│ Mise à jour dispo   3j              │
│                                      │
│ [Tout archiver]                      │
└──────────────────────────────────────┘
```

---

## SC-054 — Exporter un dataset pour analyse externe
### Wireframe
```
┌──────────────────────────────────────┐
│ Admin — Export                       │
│                                      │
│ Format : [CSV ▼]                     │
│ Période : [30j ▼]                    │
│                                      │
│ [Exporter]                           │
└──────────────────────────────────────┘
```

---

## Séquence UX
1. Paramétrer les droits / préférences (SC-051)
2. Collaborer / révoquer (SC-052)
3. Notifier / archiver (SC-053)
4. Exporter / analyser (SC-054)

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../C-UX-Scenarios/batch-07-gap-fill-051-054.md` | WDS-3 | Sources SC-051→SC-054 |
| `.../D-UX-Design/batch-07-gap-fill-051-054.md` | WDS-4 | Spécifications UX |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

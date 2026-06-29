# SCY Forge — WDS-4 UX Design — Batch 09 : B2B / ARENA / FINANCE SUITE (SC-063 → SC-070)
_Phase WDS-4_
_Source WDS-3 : `design-artifacts/C-UX-Scenarios/batch-09-b2b-arena-finance.md`_

---

## Vue UX globale — B2B / Arena / Finance Suite

Ces trois sous-systèmes partagent une logique **admin / monétaire / compétitive** :
- **B2B Creator Console** : gestion d’équipe, billing, analytics
- **ARENA** : compétition, classements, défis
- **Finance Suite** : tableaux financiers, KPIs, reconciliation

Leur UX doit être **compacte et dense** : beaucoup d’information, peu d’espace, actions rapides.

---

## SC-063 — B2B : créer un espace équipe
### Wireframe
```
┌──────────────────────────────────────┐
│ B2B — Nouvel espace                  │
│                                      │
│ Nom : Acme Corp                      │
│ Rôle : [Admin ▼]                     │
│ Membres : + Inviter                  │
│                                      │
│ [Créer]                              │
└──────────────────────────────────────┘
```

---

## SC-064 — B2B : inviter des membres
### Wireframe
```
┌──────────────────────────────────────┐
│ B2B — Invitations                    │
│                                      │
│ julien@co.io  Admin   ✓ Actif       │
│ marie@co.io   Éditeur ⏱ En attente  │
│                                      │
│ [+ Inviter]  [Renvoyer] [Révoquer]   │
└──────────────────────────────────────┘
```

---

## SC-065 — B2B : gérer les rôles et permissions
### Wireframe
```
┌──────────────────────────────────────┐
│ B2B — Rôles                         │
│                                      │
│ Admin   : 3                          │
│ Éditeur : 5                          │
│ Lecteur : 12                         │
│                                      │
│ [Créer un rôle] [Modifier]           │
└──────────────────────────────────────┘
```

---

## SC-066 — ARENA : rejoindre un défi
### Wireframe
```
┌──────────────────────────────────────┐
│ ARENA — Défis                       │
│                                      │
│ 🔥 Défi flashcards #42              │
│    Durée : 30 min  •  124 joueurs   │
│                                      │
│ [Rejoindre]                          │
└──────────────────────────────────────┘
```

---

## SC-067 — ARENA : afficher le classement
### Wireframe
```
┌──────────────────────────────────────┐
│ ARENA — Classement                  │
│                                      │
│ 1. Alice   2 840 pts                 │
│ 2. Bob     2 640 pts                 │
│ 3. Vous    2 480 pts                 │
│                                      │
│ [Rejouer] [Défier un ami]            │
└──────────────────────────────────────┘
```

---

## SC-068 — Finance Suite : synthèse financière
### Wireframe
```
┌──────────────────────────────────────┐
│ Finance — Synthèse                   │
│                                      │
│ Revenue      124 000 €  ↑ 12%       │
│ Marge        38%        ↓ 2%        │
│ Burn         18 000 €  =             │
│                                      │
│ [Exporter] [Détailler]               │
└──────────────────────────────────────┘
```

---

## SC-069 — Finance Suite : rapprochement
### Wireframe
```
┌──────────────────────────────────────┐
│ Finance — Rapprochement             │
│                                      │
│ 142 items                             │
│ ████████████████████░░  89% match    │
│ 15 écarts                            │
│                                      │
│ [Forcer la correspondance]           │
└──────────────────────────────────────┘
```

---

## SC-070 — Finance Suite : exporter un reporting
### Wireframe
```
┌──────────────────────────────────────┐
│ Finance — Export                     │
│                                      │
│ Format : [PDF ▼]                     │
│ Période : [Mois en cours ▼]         │
│                                      │
│ [Exporter]                           │
└──────────────────────────────────────┘
```

---

## Séquence UX résumée
1. B2B : espace → membres → rôles
2. ARENA : défi → classement → replay
3. Finance : synthèse → rapprochement → export

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../C-UX-Scenarios/batch-09-b2b-arena-finance.md` | WDS-3 | Sources SC-063→SC-070 |
| `.../D-UX-Design/batch-09-b2b-arena-finance.md` | WDS-4 | Spécifications UX |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

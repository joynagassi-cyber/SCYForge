# SCY Forge — WDS-4 UX Design — Batch 04 : COSMOS / BRAIN (SC-023 → SC-032)
_Phase WDS-4_
_Source : `design-artifacts/C-UX-Scenarios/wds3-strategic-context.md`_

---

## Vue globale UX — COSMOS / BRAIN

COSMOS est une **surface visuelle d’exploration** ; BRAIN est un **mode de dialogue** superposé.  
Tous deux partagent un contrat d’accès depuis le Dashboard :
- CXC « Visualiser » → COSMOS
- CXC « Discuter » → BRAIN (modale)

### États partagés
- Idle : aucun graphe actif
- Loading : chargement embedding / layout
- Interactive : graphe navigable, node sélectionnable ou filtre actif
- Overlay BRAIN : ouverture / fermeture par modale

---

## SC-023 — Ouvrir COSMOS depuis le Dashboard
### Wireframe
```
┌──────────────────────────────────────┐
│ Dashboard                            │
│                                      │
│ Dernières cartes                 CTA │
│ → COSMOS Visualiser                  │
└──────────────────────────────────────┘
```

---

## SC-024 — Choisir une lentille COSMOS
### Wireframe
```
┌───────────────────────────────┐
│ Lentilles      Rechercher 🔍  │
│ • Chronologique               │
│ • Conceptuelle                │
│ • Sociale                     │
│ • Pédagogique                 │
│ • Emotionnelle …              │
└───────────────────────────────┘
```

---

## SC-025 — Créer un DAG conceptuel
### Wireframe
```
┌──────────────────────────────────────┐
│ COSMOS — Conceptuel                  │
│                                      │
│  [Node A] ─── [Node B]              │
│      │           │                   │
│    [Node C] ─── [Node D]            │
│                                      │
│ [ Ajouter un node ]  [Vue liste]    │
└──────────────────────────────────────┘
```

---

## SC-026 — Filtrer et explorer un graphe
### Wireframe
```
┌──────────────────────────────────────┐
│ COSMOS — Filtres                     │
│                                      │
│  Recherche  +  Tags  +  Dates       │
│                                      │
│  ┌────────────────────────────────┐  │
│  │  Graphe filtré                 │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

---

## SC-027 — Partager un visuel COSMOS
### Wireframe
```
┌──────────────────────────────────────┐
│ COSMOS — Partage                     │
│                                      │
│ [Copier le lien] [Exporter PNG]      │
│ [Générer embed]                      │
└──────────────────────────────────────┘
```

---

## SC-028 — Naviguer dans une timeline cognitive
### Wireframe
```
┌──────────────────────────────────────┐
│ COSMOS — Timeline                    │
│                                      │
│ 2026-01  2026-03  2026-06  2026-09  │
│  ░▓▒░▒░  ▓░░▓░  ░▓░▓░░             │
│  [↑] Zoom  [→] Avancer               │
└──────────────────────────────────────┘
```

---

## SC-029 — Annoter un noeud / concept
### Wireframe
```
┌──────────────────────────────────────┐
│ COSMOS — Annotation                  │
│                                      │
│ Concept : "Event Stream"             │
│ +--------------------------+         │
│ | Note personnelle...      |         │
│ +--------------------------+         │
│                                      │
│ [Enregistrer]                        │
└──────────────────────────────────────┘
```

---

## SC-030 — Basculer entre modes COSMOS
### Wireframe
```
┌──────────────────────────────────────┐
│ Modes        Chrono     Conceptuel   │
│              Tags       Social       │
│                                      │
│  Zone active du mode retenu          │
└──────────────────────────────────────┘
```

---

## SC-031 — Ouvrir BRAIN (modale)
### Wireframe
```
┌──────────────────────────────────────┐
│ COSMOS + BRAIN                       │
│                                      │
│ ┌────────────────────────────────┐   │
│ │ Graphe COSMOS                  │   │
│ │                      ┌────────┐│   │
│ │                      │ BRAIN  ││   │
│ │                      │ Chat…  ││   │
│ │                      └────────┘│   │
│ └────────────────────────────────┘   │
└──────────────────────────────────────┘
```

---

## SC-032 — Poser une question à BRAIN liée au graphe
### Wireframe
```
┌────────────────┐
│ BRAIN          │
│ +-------------------------+        │
│ | Quels concepts          │        │
│ | influencent X ?         │        │
│ +-------------------------+        │
│                                    │
│ Réponse : 3 concepts relevés …     │
│ [Voir dans COSMOS]                 │
└──────────────────────────────────────┘
```

---

## Séquence résumée COSMOS / BRAIN

1. CXC « Visualiser » → COSMOS
2. Choix lentille (1 clic)
3. Navigation / filtres / annotation
4. BRAIN en modale à tout moment
5. BRAIN peut renvoyer un contexte dans COSMOS

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../C-UX-Scenarios/batch-04-cosmos-brain.md` | WDS-3 | Sources SC-023→SC-032 |
| `.../D-UX-Design/batch-04-cosmos-brain.md` | WDS-4 | Spécifications UX |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

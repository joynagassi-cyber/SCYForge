# SCY Forge — WDS-4 UX Design — Batch 05 : READER / IMPRINT / CHRONICLE (SC-033 → SC-042)
_Phase WDS-4_
_Source WDS-3 : `design-artifacts/C-UX-Scenarios/wds3-strategic-context.md`_

---

## Vue UX globale — Reader / Imprint / Chronicle

Trois modes de consultation/diagnostic partagent un modèle d’interface **page unique** avec barre d’outils persistante :
- **Reader** : consommation focalisée (split lecture + outils)
- **Imprint** : profilage cognitif (visualisation métrique)
- **Chronicle** : historique + notifications (flux chronologique inverse)

> Contrainte : le layout doit pouvoir basculer de Reader vers Imprint/Chronicle sans perte de contexte (état conservé dans Zustand).

---

## SC-033 — Ouvrir un document dans Reader
### Wireframe
```
┌──────────────────────────────────────┐
│ ← Retour   Reader   [Imprimer] [⚙]  │
├──────────────────────────────────────┤
│ Contenu                              │
│                                      │
│ Texte du document…                   │
│                                      │
│ ──────── Sélection ────────         │
│ Surligner  •  Note  •  Lien          │
└──────────────────────────────────────┘
```

---

## SC-034 — Utiliser les outils de lecture (annotations)
### Wireframe
```
┌──────────────────────────────────────┐
│ Reader — Outils                      │
│                                      │
│ Aucune annotation                    │
│ [Créer une note]                     │
│                                      │
│ + Surligner + Glossaire + Recherche  │
└──────────────────────────────────────┘
```

---

## SC-035 — Rechercher dans un document
### Wireframe
```
┌──────────────────────────────────────┐
│ Reader — Recherche                   │
│ 🔍  ___________________  23/184      │
│                                      │
│ · Résultats…                         │
│   — Occurrence 1                     │
│   — Occurrence 2                     │
└──────────────────────────────────────┘
```

---

## SC-036 — Accéder au glossaire / définitions
### Wireframe
```
┌──────────────────────────────────────┐
│ Reader — Glossaire                   │
│ A | B | C                            │
│                                      │
│ API  Application Programming…        │
│ ...                                  │
└──────────────────────────────────────┘
```

---

## SC-037 — Afficher les métadonnées du document
### Wireframe
```
┌──────────────────────────────────────┐
│ Reader — Métadonnées                 │
│                                      │
│ Titre : ...                          │
│ Auteur : ...                         │
│ Tags : ...                           │
│ Source : ...                         │
└──────────────────────────────────────┘
```

---

## SC-038 — Consulter son profil cognitif Imprint
### Wireframe
```
┌──────────────────────────────────────┐
│ Imprint — Profil                     │
│                                      │
│ Stabilité   78%                      │
│ Vitesse     64%                      │
│ Rétention   89%                      │
│                                      │
│ [Historique] [Comparer] [Exporter]   │
└──────────────────────────────────────┘
```

---

## SC-039 — Comparer deux profils Imprint
### Wireframe
```
┌──────────────────────────────────────┐
│ Imprint — Comparaison                │
│                                      │
│ Semaine 24 vs Semaine 25             │
│ Stabilité  +6%                       │
│ Vitesse    -2%                       │
└──────────────────────────────────────┘
```

---

## SC-040 — Recevoir et gérer une notification Chronicle
### Wireframe
```
┌──────────────────────────────────────┐
│ Chronicle                            │
│                                      │
│ Session APEX terminée  • 2h         │
│ Nouveau deck créé      • 1j         │
│ Ingest terminé         • 3j         │
│                                      │
│ [Tout marquer comme lu]              │
└──────────────────────────────────────┘
```

---

## SC-041 — Filtrer le flux Chronicle
### Wireframe
```
┌──────────────────────────────────────┐
│ Chronicle — Filtres                  │
│                                      │
│ [Tous] [APEX] [INGEST] [B2B]        │
│                                      │
│ Items filtrés                       │
└──────────────────────────────────────┘
```

---

## SC-042 — Archiver / exporter un historique
### Wireframe
```
┌──────────────────────────────────────┐
│ Chronicle — Export                   │
│                                      │
│ [CSV] [JSON] [PDF]                   │
│ Période : [7j ▼]                     │
│                                      │
│ [Exporter]                           │
└──────────────────────────────────────┘
```

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../C-UX-Scenarios/batch-05-reader-imprint-chronicle.md` | WDS-3 | Scénarios sources SC-033→SC-042 |
| `.../D-UX-Design/batch-05-reader-imprint-chronicle.md` | WDS-4 | Spécifications UX |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

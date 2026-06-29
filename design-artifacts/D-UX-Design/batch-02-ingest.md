# SCY Forge — WDS-4 UX Design — Batch 02 : INGEST (SC-009 → SC-016)
_Phase WDS-4_
_Source : `design-artifacts/C-UX-Scenarios/wds3-strategic-context.md`_
_Contexte établi dans le batch 01 (Auth + Dashboard)_

---

## Vue globale UX — INGEST

INGEST est un **sous-système** du Dashboard dont la responsabilité est unique : transformer une source en flux ingérable sans jamais demander à l’utilisateur de configurer un connecteur manuellement.  
L’UX repose sur 3 piliers :
1. **Zéro décision d’intégration** : l’utilisateur exprime un « quoi », pas un « comment »
2. **Feedback déterminant immédiat** : upload détecté, taille estimée, temps de traitement, mode cible
3. **Règle des deux clics** entre Dashboard → INGEST → Lancement

### États applicatifs INGEST
- Empty : aucun flux actif
- Selecting source : catalogue ouvert
- Ingesting : progression visible, annulable, reprise
- Completed : résultat exploitable (COSMOS / APEX / BRAIN / READER)
- Failed : diagnostic court, bouton d’action, pas de stack trace par défaut

### Hiérarchie d’information
1. Contexte « Pourquoi j’ingère » (objectif choisi lors du onboarding)
2. Liste chronologique inverse des ingests récents
3. Procédure de lancement rapide (CXC principal)

---

## SC-009 — Lancer un ingest depuis le dashboard (streaming)

### Wireframe (textuel)
```
┌──────────────────────────────────────┐
│ Dashboard                            │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ + Nouvel ingest                 │ │
│ └──────────────────────────────────┘ │
│                                      │
│ 📄 data.csv        22 min • 140 Mo   │
│ 🔗 Notion DB       4h 12 • Terminé   │
│ ▶  YouTube         En cours • 64%   │
│    [Pause] [Annuler]                 │
└──────────────────────────────────────┘
```

### Composants
- `scy-list` pour les flux récents
- `scy-badge` statut (En cours, Terminé, Échec)
- `scy-btn-primary` CTA « + Nouvel ingest »

### Interaction
- Le CTA doit ouvrir le catalogue en moins de 2 clics depuis n’importe quel état INGEST.

---

## SC-010 — Choisir le mode d’ingestion (source unique)

### Wireframe
```
┌──────────────────────────────────────┐
│ INGEST — Choisir une source          │
│ ┌────────┐ ┌────────┐ ┌────────┐   │
│ │  CSV  │ │  PDF  │ │YouTube │   │
│ └────────┘ └────────┘ └────────┘   │
│ ┌────────┐ ┌────────┐ ┌────────┐   │
│ │Notion │ │Obsidian│ │Audio  │   │
│ └────────┘ └────────┘ └────────┘   │
└──────────────────────────────────────┘
```

### Composants
- Grille de `scy-card` avec icône + légende
- Sélection visuelle immédiate (bordure + ombre)

---

## SC-011 — Importer depuis un fichier local

### Wireframe
```
┌──────────────────────────────────────┐
│ INGEST — Fichier local               │
│                                      │
│   Glissez vos fichiers ici           │
│   ou [Parcourir]                     │
│                                      │
│   CSV, PDF, TXT, EPUB, ZIP          │
│   Max 2 Go par fichier               │
└──────────────────────────────────────┘
```

### Composants
- `scy-drop-zone` (custom)
- `scy-btn-secondary` « Parcourir »

---

## SC-012 — Configurer les paramètres d’extraction

### Wireframe
```
┌──────────────────────────────────────┐
│ INGEST — Paramètres                  │
│                                      │
│ Langue principale    [FR ▼]          │
│ OCR       [ ] Activer                │
│ Sourdeline[ ] Activer               │
│ Mode de chunking  [Auto ▼]          │
│                                      │
│ [ Annuler ]    [ Lancer l'ingest ]   │
└──────────────────────────────────────┘
```

### Composants
- `scy-form`, `scy-select`, `scy-toggle`

---

## SC-013 — Suivre la progression en temps réel

### Wireframe
```
┌──────────────────────────────────────┐
│ INGEST — data.csv                    │
│ ████████████████░░░░  64%            │
│ Étape 3/7 — Extraction + imbrication │
│  ~ 4 min restantes                   │
│                                       │
│ [Pause]  [Annuler]                   │
└──────────────────────────────────────┘
```

### Composants
- `scy-progress` + message d’étape

---

## SC-014 — Annuler / reprendre un ingest

### Wireframe
```
┌──────────────────────────────────────┐
│ INGEST — Annulation confirmée        │
│                                      │
│ L'ingest a été interrompu.           │
│ 63% traité.                          │
│                                      │
│ [Revenir à la liste]  [Reprendre]    │
└──────────────────────────────────────┘
```

---

## SC-015 — Recevoir une notification d’ingest terminé

### Conception
- Toast `scy-toast-success` dans le coin supérieur droit
- Badge de notification dans la sidebar
- Bouton d’action directe : « Ouvrir le résultat »

---

## SC-016 — Gérer les erreurs (fichier corrompu / quota)

### Wireframe
```
┌──────────────────────────────────────┐
│ INGEST — Erreur                      │
│                                      │
│ ⚠ Impossible de traiter archive.zip  │
│ Motif : archive protégée par mot de │
│ passe.                               │
│                                      │
│ [Télécharger le log]  [Réessayer]    │
└──────────────────────────────────────┘
```

### Composants
- `scy-alert-error`
- `scy-btn-secondary` et `scy-btn-primary`

---

## Séquence résumée INGEST (happy path)

1. Dashboard → CTA « Nouvel ingest » (SC-009, 1 clic)
2. Catalogue source (SC-010, 2ᵉ clic)
3. Sélection puis confirmation (SC-011 / SC-012)
4. Streaming progression (SC-013)
5. Notification de fin (SC-015)
6. Gestion d’erreur si besoin (SC-016)

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../C-UX-Scenarios/batch-02-ingest.md` | WDS-3 | Scénarios sources SC-009→SC-016 |
| `.../D-UX-Design/batch-02-ingest.md` | WDS-4 | Spécifications UX |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

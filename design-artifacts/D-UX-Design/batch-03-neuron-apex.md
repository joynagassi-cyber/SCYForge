# SCY Forge — WDS-4 UX Design — Batch 03 : NEURON-CHAINS / APEX (SC-017 → SC-022)
_Phase WDS-4_
_Source : `design-artifacts/C-UX-Scenarios/wds3-strategic-context.md`_

---

## Vue globale UX — NEURON-CHAINS / APEX

NEURON-CHAINS génère la matière. APEX la transforme en cartes révisables.  
L’utilisateur ne navigue pas entre les deux : il **déclenche** NEURON et **consomme** dans APEX.

### États partagés
- Draft : matière brute non convertie
- Generating : NEURON en cours
- Ready : cartes APEX disponibles
- Reviewing : session en cours (FSRS)
- Completed : retour dans COSMOS / ASCENT

### Règle d’or
> Génération d’une carte ne doit jamais bloquer l’interface principale.  
> L’état « Generating » est isolé et temps réel ; l’utilisateur peut continuer d’explorer.

---

## SC-017 — Déclarer un objectif d’apprentissage

### Wireframe (textuel)
```
┌──────────────────────────────────────┐
│ Dashboard                            │
│ ┌─────+--------------+               │
│ │ TXT │              │               │
│ │[Pdf]| + Nouvel     │               │
│ │[Web]| objectif     │               │
│ └─────+--------------+               │
│                                      │
└──────────────────────────────────────┘
```

### Composants
- `scy-card` pour les raccourcis source
- `scy-btn-primary` CTA principal

---

## SC-018 — Choisir un mode de génération NEURON

### Wireframe
```
┌──────────────────────────────────────┐
│ NEURON — Choisir le mode             │
│ ┌────────────┐ ┌────────────┐       │
│ │ Concept map│ │ Flashcards │       │
│ └────────────┘ └────────────┘       │
│ ┌────────────┐ ┌────────────┐       │
│ │ Résumé     │ │ Quiz auto  │       │
│ └────────────┘ └────────────┘       │
└──────────────────────────────────────┘
```

---

## SC-019 — Lancer la génération et suivre le streaming

### Wireframe
```
┌──────────────────────────────────────┐
│ NEURON — Génération                  │
│ ▰▰▰▰▱▱▱▱▱▱  42%                     │
│ Extraction + structuration           │
│ ~ 2 min restantes                    │
│                                       │
│ [Masquer]  [Annuler]                 │
└──────────────────────────────────────┘
```

---

## SC-020 — Valider / modifier le résultat NEURON

### Wireframe
```
┌──────────────────────────────────────┐
│ NEURON — Aperçu                      │
│                                      │
│   Cartes générées : 47               │
│   Risque de duplication : faible     │
│                                      │
│   [Tout valider]  [Réviser manuel.]  │
└──────────────────────────────────────┘
```

---

## SC-021 — Transformer NEURON en deck APEX

### Wireframe
```
┌──────────────────────────────────────┐
│ APEX — Nouveau deck                  │
│                                      │
│ Nom : Data Engineering               │
│ Source : NEURON #47 cartes           │
│ Algorithme : FSRS-4                  │
│                                      │
│ [Créer le deck]                      │
└──────────────────────────────────────┘
```

---

## SC-022 — Réviser dans APEX (session)

### Wireframe
```
┌──────────────────────────────────────┐
│ APEX — Session #12                   │
│  ▸ 14/47 cartes                       │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ Q : Qu’est-ce qu’un event stream?│ │
│ │ [Montrer la réponse]             │ │
│ └──────────────────────────────────┘ │
│                                      │
│ [Facile] [Difficile] [Oublié]        │
└──────────────────────────────────────┘
```

---

## Séquence résumée NEURON / APEX

1. Définir l’objectif (SC-017)
2. Choisir le mode génération (SC-018)
3. Lancer et monitorer (SC-019)
4. Valider / éditer (SC-020)
5. Convertir en deck APEX (SC-021)
6. Réviser (SC-022)

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../C-UX-Scenarios/batch-03-neuron-apex.md` | WDS-3 | Scénarios sources SC-017→SC-022 |
| `.../D-UX-Design/batch-03-neuron-apex.md` | WDS-4 | Spécifications UX |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

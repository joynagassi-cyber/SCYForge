# SCY Forge — WDS-8 Evolution — Batch 01 : Hypothèses détaillées
_Phase WDS-8_
_Source : `design-artifacts/H-Evolution/wds8-strategic-context.md`_

---

## H-01 — Dark-first devient la norme marché

### État actuel
WDS-7 déjà dark-first. Reader et APEX (lecture longue) doivent être validés.

### Actions T1
- Audit contrastes sur Reader (focus : texte long, annotations colorées)
- Mesurer `axe` violations sur pages APEX session
- Valider mode clair optionnel

### Décision
Maintenir mode clair disponible ; ne pas supprimer.

### Indicateur
0 violation WCAG 2.1 AA sur Reader + APEX

---

## H-02 — COSMOS absorbe de nouveaux modes de visualisation

### État actuel
26 modes documentés WDS-3. Objectif 40 d’ici T3.

### Actions T2
- Refonte LensSelector : pagination + grouping par famille
- Ajout filtre recherche dans LensSelector
- Benchmark : G6 vs Cosmograph pour modes lourds (DAG)

### Décision
26 modes visibles ; 40 avec overflow + recherche.

### Indicateur
Temps de chargement mode < 2s ; 0 mode inaccessible en 2 clics.

---

## H-03 — B2B devient un produit à part entière

### État actuel
Module B2B Creator Console + Finance Suite. MRR cible $50K à M6.

### Actions T2
- Créer thème B2B dérivé (même tokens SCY, palette épurée)
- Séparer clairement les路由 menu (sidebar B2B vs autonome)
- Ajout billing, team management, analytics B2B

### Décision
Thème dérivé strict ; pas de rupture de tokens WDS-7.

### Indicateur
MRR ≥ $50K à M6 ; 0 régression UX sur version autonome.

---

## H-04 — Mobile-first devient dominant pour l’ingestion

### État actuel
INGEST desktop-first. Upload fichier, OCR, extraction.

### Actions T2
- Repenser INGEST en mobile-first
- Upload caméra natif (React Native / Capacitor si applicable)
- OCR natif (Web API / Tesseract)
- Tester sur iOS Safari / Android Chrome

### Décision
Mobile-first INGEST ; desktop reste environnement révision longue (APEX).

### Indicateur
Temps upload mobile < 3s ; 0 erreur de parsing sur fichiers caméra.

---

## H-05 — L’IA générative modifie la librairie de prompts

### État actuel
WDS-6 documente 87 prompts/assets. Pas de registry版本.

### Actions T2
- Créer `design-artifacts/F-Assets/prompts-registry.md`
- Versionner chaque prompt (date, modèle, seed, évaluation)
- Mettre en place review trimestrielle des prompts

### Décision
Registry obligatoire ; prompts gelés par version.

### Indicateur
100% prompts documentés avec métadonnées (modèle, date, évaluation).

---

## H-06 — Le design system peut être open-sourcé partiellement

### État actuel
WDS-7 tokens + primitives propriétaires (SCY).

### Actions T3
- Identifier primitives génériques (button, input, card, modal, toast, select, toggle)
- Extraire en package npm `@scyforge/design-system`
- Ouvrir repository public (licence MIT pour primitives, fermé pour composants métier)

### Décision
Ouvrir uniquement primitives génériques ; composants métier restent fermés.

### Indicateur
Package npm publié ; documentation publique ; 0 fuite de branding SCY dans primitives.

---

## Timeline consolidée

```
2026 Q3 (T1)
├── H-01 : Audit contrastes Reader + APEX
├── H-03 : Cadrage thème B2B dérivé
└── H-05 : Mise en place prompts registry

2026 Q4 (T2)
├── H-02 : Refonte LensSelector (pagination + grouping)
├── H-03 : Thème B2B implémenté
├── H-04 : Mobile-first INGEST (v1)
└── H-05 : Registry prompts opérationnel

2027 Q1 (T3)
├── H-02 : 40 modes COSMOS opérationnels
├── H-04 : OCR natif + upload caméra
└── H-06 : Package npm primitives publié

2027 Q2 (T4)
├── H-06 : API tokens + primitives documentée
└── Design system ouvert (plugins)
```

---

## Traçabilité WDS-8

| Fichier | Phase | Rôle |
|---------|-------|------|
| `design-artifacts/H-Evolution/wds8-strategic-context.md` | WDS-8 | Contexte et vision |
| `design-artifacts/H-Evolution/batch-01-hypotheses.md` | WDS-8 | Hypothèses détaillées |
| `design-artifacts/C-UX-Scenarios/wds3-strategic-context.md` | WDS-3 | Source de vérité scénarios |

> WDS-8 cloturé une fois les hypotheses validées avec le comité design + produit.

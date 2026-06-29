# SCY Forge — WDS-8 STRATEGIC CONTEXT
_Étape 08 — Evolution & Vision long terme_
_Source : `design-artifacts/C-UX-Scenarios/wds3-strategic-context.md`_
_Version : 1.0_

---

## 1. Résumé exécutif

**WDS-8** documente les hypothèses d’évolution du design system et de l’UX SCY Forge sur 12 à 18 mois. Il ne remplace pas la roadmap produit ; il complète le WDS par une couche **design-stratégique**.

---

## 2. Vision design à 12 mois

| Trimestre | Objectif design | Indicateur |
|-----------|-----------------|------------|
| T0 (maintenant) | Fondations WDS gelées (steps 01 à 07) | Livrables WDS-1 à WDS-7 publiés |
| T1 (+3 mois) | Convergence tokens + composants frontend | 100% des composants conformes WDS-7 |
| T2 (+6 mois) | Adaptive layout (mobile / tablet / desktop) | Breakpoints stables, aucun layout cassé |
| T3 (+9 mois) | Personnalisation visuelle par persona | Widgets configurables par profil |
| T4 (+12 mois) | Design system ouvert (plugins) | API tokens + primitives documentée |

---

## 3. Hypothèses d’évolution

### H-01 — Dark-first devient la norme marché
- **Contexte** : adoption croissante du dark mode par défaut dans les outils productivité
- **Implication design** : WDS-7 déjà aligné ; valider contrastes sur outils de lecture longue (Reader)
- **Risque** : accessibilité en mode clair sous-estimée
- **Décision** : maintenir le mode clair comme option ; ne jamais supprimer

### H-02 — COSMOS absorbe de nouveaux modes de visualisation
- **Contexte** : 26 modes aujourd’hui ; objectif 40 d’ici T3
- **Implication design** : le LensSelector doit scale ; prévoir pagination + grouping
- **Risque** : overload cognitif utilisateur
- **Décision** : garder 26 modes visibles ; les modes avancés vont dans un overflow + recherche

### H-03 — B2B devient un produit à part entière
- **Contexte** : MRR cible $50K à M6
- **Implication design** : créer un **thème B2B** dérivé du SCY tokens (même base, palette épurée)
- **Risque** : divergence visuelle avec la version autonome
- **Décision** : thème dérivé strict ; pas de rupture de tokens

### H-04 — Mobile-first devient dominant pour l’ingestion
- **Contexte** : usage nomade des apprenants
- **Implication design** : repenser INGEST en mobile-first ; upload caméra, OCR natif
- **Risque** : complexité de maintenance 3 breakpoints
- **Décision** : mobile-first INGEST ; desktop reste l’environnement de révision longue (APEX)

### H-05 — L’IA générative modifie la librairie de prompts
- **Contexte** : WDS-6 documente les prompts ; l’IA évolue vite
- **Implication design** : les prompts doivent être versionnés ; prévoir un registry
- **Risque** : assets inconsistants entre versions de modèle
- **Décision** : `design-artifacts/F-Assets/prompts-registry.md` à créer en T2

### H-06 — Le design system peut être open-sourcé partiellement
- **Contexte** : SCY Forge vise un écosystème
- **Implication design** : certaines primitives peuvent être extraites en package npm
- **Risque** : perte de contrôle branding
- **Décision** : ouvrir uniquement les primitives génériques (button, input, card) ; garder les composants métier fermés

---

## 4. Roadmap WDS-8

```
WDS-8 — EVOLUTION
═══════════════════════════════════════════════════════════

 Phase            WDS Skill          Deliverable                     Statut
 ─────────────────────────────────────────────────────────────
 [TERMINÉ]    WDS-1 Product Brief  product-brief.md                ✅
 [TERMINÉ]    WDS-2 Trigger Map    trigger-map.md                  ✅
 [TERMINÉ]    WDS-3 Scenarios      87 scénarios outlines            ✅
 [TERMINÉ]    WDS-4 UX Design      87 scénarios UX                 ✅
 [TERMINÉ]    WDS-5 Copywriting    87 scénarios copy               ✅
 [TERMINÉ]    WDS-6 Assets         87 scenarios_assets             ✅
 [TERMINÉ]    WDS-7 Design System  tokens + primitives              ✅
 [EN COURS]   WDS-8 Evolution      roadmap + hypotheses            🔄
```

---

## 5. Gouvernance WDS-8

1. Chaque hypothèse H-n est **revisitée tous les trimestres**
2. Les décisions associées sont tracées dans ce fichier
3. Les changements majeurs de design system passent par une **PR dédiée WDS-7**
4. Les modifications de scope WDS passent par un **alignement équipe design + produit**

---

## 6. Références

| Document | Chemin |
|----------|--------|
| WDS-3 Strategic Context | `design-artifacts/C-UX-Scenarios/wds3-strategic-context.md` |
| WDS-4 Strategic Context | `design-artifacts/D-UX-Design/wds4-strategic-context.md` |
| WDS-5 Strategic Context | `design-artifacts/E-Copywriting/wds5-strategic-context.md` |
| WDS-6 Strategic Context | `design-artifacts/F-Assets/wds6-strategic-context.md` |
| WDS-7 Tokens | `design-artifacts/D-Design-System/tokens.css` |
| Design System source | `minddoc/s00_design/scy_design_system.md` |

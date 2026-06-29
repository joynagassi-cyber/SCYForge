# SCY Forge — WDS-4 UX Design — Batch 10 : Final (SC-071 → SC-087)
_Phase WDS-4_
_Source WDS-3 : `design-artifacts/C-UX-Scenarios/batch-10-final.md`_

---

## Vue UX globale — Final (System / Settings / Patterns transversaux)

Ce dernier batch regroupe les scénarios résiduels : flux système, settings, états limites et pain points globaux.

---

## SC-071 — Traiter un message système critique
### Wireframe
```
┌──────────────────────────────────────┐
│ ⚠ Attention                          │
│                                      │
│ Stockage à 92%. Actions requises.    │
│                                      │
│ [Voir le détail] [Archiver]          │
└──────────────────────────────────────┘
```

---

## SC-072 — Valider un consentement RGPD
### Wireframe
```
┌──────────────────────────────────────┐
│ Consentements                        │
│                                      │
│ ☐ Analytiques                        │
│ ☐ Emails                             │
│ ☐ Partenaires                        │
│                                      │
│ [Enregistrer]                        │
└──────────────────────────────────────┘
```

---

## SC-073 — Choisir sa langue / région
### Wireframe
```
┌──────────────────────────────────────┐
│ Langue et région                     │
│                                      │
│ Langue : [Français ▼]               │
│ Fuseau : [Europe/Paris ▼]           │
│ Formats : [JJ/MM/AAAA ▼]            │
└──────────────────────────────────────┘
```

---

## SC-074 — Personnaliser le thème
### Wireframe
```
┌──────────────────────────────────────┐
│ Apparence                            │
│                                      │
│ Thème : [Sombre ▼]                  │
│ Taille police : [M ▼]               │
│ Contrasté : [ ]                      │
│                                      │
│ [Prévisualiser]                      │
└──────────────────────────────────────┘
```

---

## SC-075 — Gérer les intégrations / connecteurs
### Wireframe
```
┌──────────────────────────────────────┐
│ Intégrations                         │
│                                      │
│ Notion   Connecté  [Déconnecter]    │
│ YouTube  Connecté  [Configurer]     │
│ Slack    Absent    [+ Connecter]    │
└──────────────────────────────────────┘
```

---

## SC-076 — Visualiser l’état des services système
### Wireframe
```
┌──────────────────────────────────────┐
│ Système — Health                     │
│                                      │
│ API        ✔                         │
│ Redis      ✔                         │
│ Workers    ⚠ Latence 320ms          │
│                                      │
│ [Actualiser]                         │
└──────────────────────────────────────┘
```

---

## SC-077 — Naviguer en mode dégradé (offline)
### Wireframe
```
┌──────────────────────────────────────┐
│ 🟡 Mode dégradé                      │
│                                      │
│ Certaines données sont indisponibles │
│ hors-ligne.                          │
│                                      │
│ [Réessayer] [Voir le cache]          │
└──────────────────────────────────────┘
```

---

## SC-078 — Gérer un conflit de version (ingest)
### Wireframe
```
┌──────────────────────────────────────┐
│ Conflit                              │
│                                      │
│ Deux versions du même document.      │
│                                      │
│ [Conserver A] [Conserver B] [Fusion] │
└──────────────────────────────────────┘
```

---

## SC-079 — Basculer vers le compte invité
### Wireframe
```
┌──────────────────────────────────────┐
│ Compte invité                        │
│                                      │
│ Session limitée (30 minutes).        │
│ Aucune donnée sauvegardée.           │
│                                      │
│ [Continuer] [Se connecter]           │
└──────────────────────────────────────┘
```

---

## SC-080 — Réaliser un premier onboarding en 2 minutes
### Wireframe
```
┌──────────────────────────────────────┐
│ Onboarding                           │
│                                      │
│ 1/3 — Domaine                        │
│ [________________]                   │
│                                      │
│ [Passer] [Continuer]                 │
└──────────────────────────────────────┘
```

---

## SC-081 — Quitter un flux en cours
### Wireframe
```
┌──────────────────────────────────────┐
│ Quitter ?                            │
│                                      │
│ La génération sera interrompue.      │
│                                      │
│ [Annuler] [Quitter]                  │
└──────────────────────────────────────┘
```

---

## SC-082 — Recevoir une aide contextuelle
### Wireframe
```
┌──────────────────────────────────────┐
│ Aide — Calques                       │
│                                      │
│ Qu’est-ce qu’un ingesteur ?         │
│ → Court texte explicatif             │
│                                      │
│ [Compris]                            │
└──────────────────────────────────────┘
```

---

## SC-083 — Activer un mode d’accessibilité
### Wireframe
```
┌──────────────────────────────────────┐
│ Accessibilité                        │
│                                      │
│ [x] Réduction des animations         │
│ [ ] Lecteur d’écran optimisé        │
│ [ ] Contrastes élevés                │
└──────────────────────────────────────┘
```

---

## SC-084 — Déclarer un bug / feedback
### Wireframe
```
┌──────────────────────────────────────┐
│ Feedback                             │
│                                      │
│ Catégorie : [Bug ▼]                 │
│ +------------------------+           │
│ | Description...         |           │
│ +------------------------+           │
│                                      │
│ [Envoyer]                            │
└──────────────────────────────────────┘
```

---

## SC-085 — S’authentifier par SSO / OAuth
### Wireframe
```
┌──────────────────────────────────────┐
│ Connexion                            │
│                                      │
│ [Google] [GitHub] [Microsoft]        │
│                                      │
│ ou email / mot de passe              │
└──────────────────────────────────────┘
```

---

## SC-086 — Restaurer une session récente
### Wireframe
```
┌──────────────────────────────────────┐
│ Reprendre                            │
│                                      │
│ Dernière session                     │
│ Dashboard → APEX → Cartes            │
│                                      │
│ [Reprendre] [Nouvelle session]       │
└──────────────────────────────────────┘
```

---

## SC-087 — Migrer / exporter ses données
### Wireframe
```
┌──────────────────────────────────────┐
│ Données                              │
│                                      │
│ Format : [JSON ▼]                    │
│ Portée : [Tout ▼]                    │
│                                      │
│ [Exporter]  [Importer]               │
└──────────────────────────────────────┘
```

---

## Séquence UX résumée

| Tranche | Scénarios | Focus |
|---------|-----------|-------|
| SC-071 → SC-075 | Système + RGPD + Langue + Thème + Intégrations | Paramétrage / maintenance |
| SC-076 → SC-081 | Health / offline / conflit / invité / onboarding / abandon | Résilience UX |
| SC-082 → SC-087 | Aide / accessibilité / feedback / SSO / reprise / migration | Parachèvement / confiance |

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../C-UX-Scenarios/batch-10-final.md` | WDS-3 | Sources SC-071→SC-087 |
| `.../D-UX-Design/batch-10-final.md` | WDS-4 | Spécifications UX |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

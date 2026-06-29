# SCY Forge — WDS-4 UX Design — Batch 01 : Auth + Dashboard
_Périmètre : SC-001 → SC-008_
_Méthode : Whiteport Design System — WDS-4_
_Source : `design-artifacts/C-UX-Scenarios/` + `minddoc/s00_design/scy_design_system.md`_

---

## Hypothèse d’ensemble

Le design Auth/Dashboard est une entrée unique :
- **1 seul état d’authentification** : connecté / non connecté
- **1 seul layout de dashboard** qui absorbe tous les cas d’usage (Autonomous Learner, B2B Creator, Finance Analyst, Knowledge Guardian)
- **1 seul pattern d’accès** vers le reste de l’application : sidebar + command palette + breadcrumb

> Principe directeur : _ne pas créer d’états fantômes (ex : “dashboard élève” vs “dashboard admin”) mais des **configurations de widgets** superposées._

---

## État global d’interface — Auth/Dashboard

### États possibles
1. Non authentifié → `AuthShell`
2. Authentifié, profil incomplet → `OnboardingShell`
3. Authentifié, profil complet → `DashboardShell`

### Transitions autorisées
- Non authentifié → authentifié : login / signup / magic link / OAuth
- Authentifié → non authentifié : logout
- Profil incomplet → complet : onboarding wizard

### Side effects métier
- Login → ouvre session EventBus, hydrate store Zustand, charge préférences, reporte `last_login_at`
- Logout → purge session, ferme websockets, revient à l’état neutre

---

## Composants partagés Auth

### AuthShell
| Élément | Règle |
|---------|-------|
| Logo | Coin haut gauche, lien vers `/` |
| Toggle thème | Coin haut droit, persiste dans `localStorage` + profil |
| Container | Centré verticalement et horizontalement |
| États | idle / loading / error / success |
| CTA | `scy-btn-primary`, taille `md`, pleine largeur du formulaire |

### Liaison avec les scénarios
- SC-001 → formulaire email/mot de passe (AuthShell)
- SC-002 → création de compte (AuthShell)
- SC-003 → onboarding wizard (OnboardingShell)
- SC-004 → réinitialisation (AuthShell)
- SC-005 → choix de méthode d’authentification alternative (AuthShell)

---

## Composants partagés Dashboard

### DashboardShell
| Élément | Règle |
|---------|-------|
| Sidebar | 64px repliée, 260px étendue ; navigation groupée par rôle ; icônes obligatoires |
| Topbar | breadcrumb + barre de recherche globale + bouton “nouvelle action” + avatar + notifications |
| Zone centrale | grille responsive, widgets empilables, drag & drop optionnel (v2) |
| Zone droite | context panel optionnel selon module courant (ex : aide, métadonnées) |

### Widget contract (interface)
```
Widget {
  id: string
  title?: string
  size: 'sm' | 'md' | 'lg' | 'full'
  priority: number
  refreshInterval?: number
  actions?: Array<{ label: string; intent: 'primary' | 'secondary'; route?: string }>
}
```

### Liaison avec les scénarios
- SC-006 → vue d’ensemble personnalisée (DashboardShell)
- SC-007 → navigation cross-module (DashboardShell)
- SC-008 → état vide / fallback (DashboardShell)

---

## Accessibilité globale Auth/Dashboard

- Navigation clavier 100% fonctionnelle (tabulation logique)
- Chaque état `aria-busy="true"` pendant loadings < 2s
- Messages d’erreur associés via `aria-describedby`
- Thème sombre validé pour contraste 4.5:1 minimum (textes) et 3:1 (UI)

---

## Design tokens réutilisés (extraits)

- `scy-bg-primary` : fond AuthShell et DashboardShell
- `scy-bg-card` : conteneurs Auth et widgets
- `scy-border-default` : séparations Auth
- `scy-text-primary` / `scy-text-secondary` : hiérarchie textuelle
- `scy-accent-primary` : CTA Auth
- `scy-focus-visible` : contour de focus accessible

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../C-UX-Scenarios/wds3-strategic-context.md` | WDS-3 | Source de vérité des scénarios 001→008 |
| `.../D-UX-Design/wds4-strategic-context.md` | WDS-4 | Contexte et principes UX globaux |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |

> Règle : tous les composants UI introduits dans ce fichier doivent consommer exclusivement les tokens WDS-7.

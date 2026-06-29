# SCY Forge — Design System (WDS-7)

## Source de vérité

Ce dossier capital ise directement sur la spec existante :

- `mindoc/s00_design/scy_design_system.md`
- `mindoc/s00_design/scy_experience_design.md`

Aucune couleur, règle de composition ou primitive n’a été ajoutée hors de ces documents.

## Fichiers

| Fichier | Usage |
|---------|-------|
| `tokens.css` | CSS custom properties pour Tailwind / apps web |
| `tokens.ts` | Constantes TypeScript pour React / backend TS |
| `primitives.md` | Inventaire des primitives UI à implémenter dans `frontend_react/src/components/ui/` |

## Convention

- Toutes les valeurs proviennent de la spec SCY Forge (dark-first).
- Aucun surclassement local sans traçabilité vers `mindoc/`.
- Palette figée jusqu’à la revue WDS-8 (évolution produit).

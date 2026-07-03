# 🗺️ index : DAG DISPLAY MODES — Les 3 Vues du DAG ASCENT

Ce répertoire documente les **3 vues complémentaires d'affichage** du DAG ASCENT généré. Chaque vue offre une perspective différente sur le parcours d'apprentissage. L'utilisateur bascule entre les 3 via un sélecteur.

## 📁 Les 3 Vues

| Vue | Perspective | Question répondue | Moteur |
|-----|-------------|-------------------|--------|
| 📋 **Kanban Board** | Statut d'avancement | « Qu'est-ce que je fais maintenant ? » | React Flow / Kanban custom |
| 🌳 **Arbre Hiérarchique** | Structure thématique | « Comment mon savoir s'organise-t-il ? » | G6 Radial Tree / Indented |
| ⏱️ **Timeline** | Durée & calendrier | « Combien de temps et selon quel calendrier ? » | Gantt custom SVG |

## 🔗 Vue existante (COSMOS)
- **Mode 4 Roadmap ASCENT** (React Flow dagre) : la 4ᵉ vue réseau classique du DAG. Les 3 nouvelles vues sont complémentaires.

## 📁 Fichiers
- `kanban_board/scy_dag_kanban_spec.md` — Vue Kanban (colonnes statut/jalons)
- `thematic_tree/scy_dag_thematic_tree_spec.md` — Vue Arbre (thème → sous-thème → nœud)
- `timeline_view/scy_dag_timeline_spec.md` — Vue Timeline (Gantt chronologique + ETA)
- `scy_dag_views_overview.md` — Synthèse + sélecteur + matrice de bascule

## 🎛️ Sélecteur de Vue
L'utilisateur dispose d'un sélecteur (tabs ou dropdown) pour basculer entre les vues :
```
[📋 Kanban] [🌳 Arbre] [⏱️ Timeline] [🕸️ Réseau (Mode 4)]
```
- La bascule est instantanée (< 500ms, mêmes données DAG).
- L'état de la vue active est persisté en session.
- Le nœud sélectionné reste sélectionné à travers les vues (cohérence navigation).

# 🎛️ SCY-DAG-VIEWS — SYNTHÈSE & MATRICE DE BASCULE

## 1. Les 4 Vues du DAG (3 nouvelles + Mode 4 existant)

| # | Vue | Perspective | Use case principal | Moteur |
|---|-----|-------------|-------------------|--------|
| 1 | 📋 **Kanban** | Statut | « Je veux voir ce qui est dispo maintenant » | React Flow / custom |
| 2 | 🌳 **Arbre** | Thématique | « Je veux comprendre la structure de mon apprentissage » | G6 / custom tree |
| 3 | ⏱️ **Timeline** | Chronologique | « Je veux planifier mon calendrier » | Gantt SVG custom |
| 4 | 🕸️ **Réseau** (Mode 4) | Topologique | « Je veux voir les dépendances en graphe » | React Flow dagre |

## 2. Matrice de Complémentarité

| Information | Kanban | Arbre | Timeline | Réseau |
|-------------|--------|-------|----------|--------|
| Statut (Verrouillé/Dispo/En cours/Complété) | ✅★★★ | ✅★ | ✅★ | ✅★★ |
| SMI par nœud | ✅★★ | ✅★★ | ✅★ | ✅★★★ |
| Dépendances (prérequis) | ✅★ | ✅★ | ✅★★ (flèches) | ✅★★★ |
| Durée / calendrier | ❌ | ❌ | ✅★★★ | ❌ |
| Organisation thématique | ✅★ | ✅★★★ | ❌ | ✅★ |
| Charge cognitive (FSRS overlay) | ❌ | ❌ | ✅★★★ | ❌ |
| ETA dynamique | ❌ | ❌ | ✅★★★ | ❌ |
| Vue d'ensemble synthétique | ✅★★★ | ✅★★ | ✅★★ | ✅★ |

## 3. Sélecteur de Vue (UI)
```
┌──────────────────────────────────────────────────────────┐
│  🎯 React Developer — 8 semaines — SMI 62/100 — 25%     │
│  ──────────────────────────────────────────────────────  │
│  [📋 Kanban] [🌳 Arbre] [⏱️ Timeline] [🕸️ Réseau]      │
│  ──────────────────────────────────────────────────────  │
│                                                          │
│              [CONTENU DE LA VUE SÉLECTIONNÉE]            │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

## 4. Règles de Cohérence Trans-Vues
- **Nœud sélectionné** : reste sélectionné à travers les bascules.
- **Données source unique** : `scy_ascent_nodes` + `scy_ascent_edges` (pas de duplication).
- **Mise à jour temps réel** : EventBus `NodeCompleted`/`NodeUnlocked` → toutes les vues synchronisées.
- **Persistance** : vue active + état expand/collapse mémorisés en session.
- **Bascule < 500ms** : pas de rechargement, juste changement de renderer.

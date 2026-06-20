# 📋 SCY-DAG-VIEW-KANBAN — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_DAG_VIEW_KANBAN_SPEC  
**Statut** : 🔵 PROPOSITION (EN ATTENTE DE VALIDATION UTILISATEUR)  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Le **Board Kanban** est l'une des 3 vues d'affichage du DAG ASCENT généré. Il présente les nœuds de compétence sous forme de **cartes organisées en colonnes**, offrant une vue d'ensemble synthétique et actionnable du parcours. Inspiré des boards Trello/Notion Kanban, adapté au contexte d'apprentissage.

---

## 2. Structure du Board

### Les colonnes (par statut du nœud DAG)

| Colonne | Couleur token | Contenu | Interaction |
|---------|---------------|---------|-------------|
| **🔒 Verrouillé** | Gris opaque | Nœuds dont les prérequis ne sont pas validés (SMI < 70) | Lecture seule (pas de drag) |
| **▶️ Disponible** | Bleu électrique | Nœuds débloqués, prêts à être étudiés | Clic → démarrer session |
| **⚡ En cours** | Bleu translucide + halo | Nœud(s) actif(s) d'apprentissage (Zone Proximale de Développement) | Clic → reprendre session |
| **✅ Complété** | Vert émeraude + or | Nœuds validés (SMI ≥ seuil) | Clic → revoir / réviser |

### La carte Kanban (contenu de chaque nœud)
```
┌─────────────────────────────────────┐
│ 🎯 [Nom du nœud]          [Bloom 3] │
│ ─────────────────────────────────── │
│ 📊 SMI : ████████░░ 78/100          │
│ ⏱️ Effort estimé : ~4h              │
│ 📚 3 documents · 12 cartes · 5 exos │
│ 🔗 Prérequis : Hooks, State (✅)    │
│ ─────────────────────────────────── │
│ [▶ Démarrer]  [📖 Détails]          │
└─────────────────────────────────────┘
```

### Colonne alternative (par jalon macro — Dynamic Graph Splitting)
Quand le DAG utilise le Dynamic Graph Splitting (D-OPT-005), les colonnes peuvent représenter les **jalons macro** :
- Jalon 1 « Fondamentaux » | Jalon 2 « Intermédiaire » | Jalon 3 « Avancé »
- Chaque colonne contient les nœuds concrets du jalon (5-8 nœuds)

---

## 3. Tech Stack & Dependencies
* **Framework** : React 18 + **React Flow** (`@xyflow/react` v12) ou composant Kanban custom.
* **Alternative** : `@hello-pangea/dnd` (drag & drop) si drag utilisateur autorisé.
* **Layout** : colonnes CSS Grid/Flexbox, cartes virtualisées (`@tanstack/react-virtual` si > 50 nœuds).
* **Données** : `scy_ascent_nodes` (statut, SMI, effort, bloom_level, prereqs).
* **Design** : tokens `design.md` (Noir d'encre, Violet profond, Bleu électrique, Émeraude, Or).

> **Rappel anti-hallucination** : le Kanban reflète les données RÉELLES du DAG (statuts, SMI, prérequis). L'ordre des nœuds respecte l'ordre topologique du DAG (le drag utilisateur ne modifie PAS l'ordre pédagogique — il est déterministe).

---

## 4. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu Kanban par Statut

#### Scénario : Affichage du board
- **GIVEN** Un DAG ASCENT généré (`scy_ascent_nodes`).
- **WHEN** L'utilisateur sélectionne la vue Kanban.
- **THEN** le système SHALL afficher les nœuds en cartes organisées en 4 colonnes (Verrouillé / Disponible / En cours / Complété).
- **AND** chaque carte SHALL afficher : nom, Bloom level, SMI (jauge), effort estimé, nombre de docs/cartes/exos, prérequis (avec statut ✅/🔒).
- **AND** le système SHALL respecter les tokens `design.md`.

#### Scénario : Colonne par jalon macro
- **GIVEN** Un DAG avec Dynamic Graph Splitting (D-OPT-005, 3-5 jalons).
- **WHEN** L'utilisateur bascule en mode « groupement par jalon ».
- **THEN** le système SHALL réorganiser les colonnes par jalon macro (Jalon 1 / Jalon 2 / ...).
- **AND** chaque colonne SHALL contenir uniquement les nœuds concrets de ce jalon.

---

### Requirement : Interactions Cartes

#### Scénario : Clic sur une carte
- **GIVEN** Une carte Kanban affichée.
- **WHEN** L'utilisateur clique sur une carte Disponible ou En cours.
- **THEN** le système SHALL ouvrir le Bottom Sheet (cours, exercices NEURON-CHAINS, Teach-Back).
- **AND** si Disponible → bouton « ▶ Démarrer » lance la session.
- **AND** si En cours → bouton « ⚡ Reprendre » reprend la session.

#### Scénario : Carte verrouillée
- **WHEN** L'utilisateur clique sur une carte Verrouillée.
- **THEN** le système SHALL afficher les prérequis manquants (Gap Detection, nœuds en rouge).
- **AND** le système SHALL proposer un CTA « Combler cette lacune » → Agent-02.

---

### Requirement : Mise à Jour Temps Réel

#### Scénario : Transition de statut
- **GIVEN** Un nœud en cours d'étude.
- **WHEN** Le SMI atteint le seuil (SMI ≥ 70 via Agent-05).
- **THEN** le système SHALL déplacer la carte de « En cours » → « Complété » avec animation fluide.
- **AND** le système SHALL débloquer les cartes dépendantes (Verrouillé → Disponible) avec animation.

---

### Requirement : Filtres & Vue d'Ensemble

#### Scénario : Synthèse du parcours
- **THEN** le système SHALL afficher un en-tête de synthèse : nombre total de nœuds, % complété, SMI global, temps estimé restant.
- **AND** le système SHALL offrir un filtre par domaine/sous-thème.

---

## 5. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Le drag utilisateur NE DOIT PAS modifier l'ordre pédagogique du DAG (l'ordre topologique est déterministe, fixé par Agent-03).
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Afficher un nœud Disponible dont les prérequis ne sont pas validés.
* ⚠️ **MUST** : Synchronisation temps réel avec EventBus (`NodeCompleted`, `NodeUnlocked`).

---

## 6. Test cases & Validation
* **TC1 (Board)** : DAG → 4 colonnes (Verrouillé/Disponible/En cours/Complété), cartes avec SMI/effort/prérequis.
* **TC2 (Jalons)** : Bascule groupement par jalon macro → colonnes = jalons.
* **TC3 (Clic)** : Carte Disponible → Bottom Sheet + Démarrer. Carte Verrouillée → prérequis manquants + CTA.
* **TC4 (Temps réel)** : SMI ≥ 70 → carte passe En cours → Complété (animation) ; dépendantes débloquées.
* **TC5 (Synthèse)** : En-tête % complété + SMI global + temps restant.
* **TC6 (Filtres)** : Filtre par domaine/sous-thème.

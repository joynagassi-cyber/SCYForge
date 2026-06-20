# 🗒️ SCY-ENGINE-TANSTACK-TABLE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_ENGINE_TANSTACK_TABLE_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit le comportement du **moteur engine_tanstack_table**, basé sur **TanStack Table v8** couplé à **`@tanstack/react-virtual`** (virtual scrolling). Il fournit la **vue tableur des concepts** (mode M5) : lignes de concepts, colonnes d'attributs sémantiques (Nom, Domaine, SMI, Stabilité FSRS, Difficulté, Date), tri, filtre, pagination infinie à 60 FPS sans charge GPU. S'exécute sur 100% des navigateurs, y compris liseuses e-ink.

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + **TanStack Table v8** (`@tanstack/react-table`) + **`@tanstack/react-virtual`**.
* **Rendu** : DOM virtualisé (react-window/react-virtual), aucune charge GPU.
* **Données** : array d'objets JSON plats représentant les attributs des concepts en base.
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : TanStack Table v8 est la librairie réelle désignée pour M5. Palette stricte `design.md`. Aucune colonne/score inventé — les données proviennent de la base de concepts réelle.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Vue Tableur Virtualisée (M5)

#### Scénario : Affichage des concepts en grille
- **GIVEN** Un array de concepts avec attributs (Nom, Domaine, SMI, Stabilité FSRS, Difficulté, Date).
- **WHEN** Le mode M5 est activé.
- **THEN** le système SHALL afficher les concepts en lignes via TanStack Table v8.
- **AND** le système SHALL utiliser le virtual scrolling pour un nombre infini de lignes à 60 FPS.
- **AND** chaque cellule SMI affiche un badge couleur (Rouge→Vert).

---

### Requirement : Tri & Filtre

#### Scénario : Identification des faiblesses mémorielles
- **GIVEN** La table affichée.
- **WHEN** L'utilisateur trie par Stabilité FSRS croissante.
- **THEN** le système SHALL réordonner les lignes (concepts les plus proches de l'oubli en haut).
- **AND** le système SHALL permettre le filtrage par domaine/SMI.

---

### Requirement : Clic & Knowledge Card

#### Scénario : Accès au détail
- **GIVEN** Une ligne de concept.
- **WHEN** L'utilisateur clique sur la ligne.
- **THEN** le système SHALL ouvrir un panneau latéral coulissant (Drawer) affichant la Knowledge Card complète du concept.

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Afficher des données non issues de la base de concepts réelle.
* ⚠️ **MUST** : Validation Zod des attributs avant rendu ; virtual scrolling obligatoire pour la performance.

---

## 5. Test cases & Validation
* **Test Case 1 (Virtual scroll)** : 10 000 concepts affichés à 60 FPS.
* **Test Case 2 (Tri FSRS)** : Le tri par Stabilité FSRS croissante met les concepts proches de l'oubli en haut.
* **Test Case 3 (Clic)** : Le clic ouvre le Drawer avec la Knowledge Card.
* **Test Case 4 (Badge SMI)** : Les cellules SMI affichent le badge couleur Rouge→Vert.
* **Test Case 5 (Compatibilité)** : Fonctionne sur liseuses e-ink / connexions bas débit.

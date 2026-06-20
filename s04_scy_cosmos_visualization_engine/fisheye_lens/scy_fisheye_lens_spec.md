# 🔭 SCY-FISHEYE-LENS — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_FISHEYE_LENS_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 0. Frontière avec lens_system (Complémentarité)
* **fisheye_lens** (ce document) est une **technique géométrique spécifique** de focus+context : distorsion agrandissant la région focalisée tout en conservant le contexte global visible.
* **lens_system** est le **framework extensible** orchestrant tous les types de lentilles (fisheye, filtrage, mise en évidence, lentilles sémantiques). fisheye_lens est l'une des lentilles du lens_system.

---

## 1. Purpose
Cette spécification définit le comportement de la **fisheye lens** de COSMOS. Elle applique une **distorsion focus+context** sur le graphe de connaissances : la zone sous le curseur (focus) est agrandie pour révéler le détail, tandis que le reste du graphe (contexte) reste visible mais compressé. Cela permet l'exploration détaillée sans perdre la vue d'ensemble.

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + AntV G6 v5 (plugin fisheye) ou transformation géométrique personnalisée.
* **Mathématique** : distorsion fisheye (fonction de déplacement radial, ex : `r' = r * (d + 1) / (d/r + 1)`).
* **Design** : tokens `design.md`.

> **Rappel anti-hallucination** : la fisheye lens est une technique de visualisation d'information bien établie (Furnas 1986). Palette stricte `design.md`.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Distorsion Focus+Context

#### Scénario : Exploration détaillée
- **GIVEN** Un graphe COSMOS rendu (engine_g6).
- **WHEN** L'utilisateur active la fisheye lens sur une région.
- **THEN** le système SHALL agrandir la région focalisée (détail accru).
- **AND** le système SHALL conserver le contexte global visible (compressé).
- **AND** le système SHALL déplacer dynamiquement le focus selon le curseur.

---

### Requirement : Performance Fluide

#### Scénario : Déplacement du focus
- **GIVEN** La fisheye lens active.
- **WHEN** Le curseur se déplace.
- **THEN** le système SHALL recalculer la distorsion en temps réel.
- **AND** le système SHALL maintenir une animation fluide (≥ 30 FPS).

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Masquer entièrement le contexte (le principe focus+context exige un contexte visible).
* ⚠️ **MUST** : La distorsion doit rester réversible/navigationnable.

---

## 5. Test cases & Validation
* **Test Case 1 (Focus+Context)** : La région focalisée est agrandie ; le contexte reste visible.
* **Test Case 2 (Dynamisme)** : Le focus suit le curseur en temps réel (≥ 30 FPS).
* **Test Case 3 (Palette)** : Aucune couleur hors tokens.

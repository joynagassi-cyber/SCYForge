# 🖼️ SCY-PAGE-GALLERY — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S08_READER_PAGE_GALLERY_SPEC  
**Phase** : Phase 2  
**Décision** : RS-005 (miniatures côté client PDF.js, $0 serveur)  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 1. Purpose
Cette spécification définit la **Page Gallery** — vue miniatures de toutes les pages d'un document généré, permettant de scanner visuellement l'intégralité du contenu en quelques secondes (feuilleter un livre physique).

---

## 2. Tech Stack & Dependencies
* **Génération miniatures** : PDF.js `renderPage()` → canvas → WebP 80% côté client ($0 serveur, RS-005).
* **Performance** : virtual scroll `@tanstack/react-virtual` (déjà dans la stack), lazy génération pages visibles + 2 suivantes, cache localStorage 24h.
* **Modes d'affichage** : Large (3 colonnes, 180×250px) / Normal (4-5, 130×180px) / Compact (6-8, 90×125px) / Strip (1 horizontal, panoramique tactile).
* **Table** : `scy_page_gallery_cache`.

> **Rappel anti-hallucination** : les miniatures sont générées côté client à partir du PDF réel (PDF.js). $0 serveur. Aucune fabrication.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Miniatures Virtualisées
- **GIVEN** Un document généré (N pages).
- **THEN** le système SHALL générer les miniatures via PDF.js `renderPage()` → WebP côté client.
- **AND** le système SHALL utiliser le virtual scroll (lazy pages visibles + 2 suivantes).
- **AND** le système SHALL cacher 24h en localStorage.

### Requirement : 4 Modes d'Affichage
- **THEN** le système SHALL offrir Large / Normal / Compact / Strip (tactile).

### Requirement : Interactions
- **WHEN** hover miniature → tooltip titre section ; clic → ouvre Web Viewer à la page.
- **AND** boutons « Ouvrir Reader Suite » / « Télécharger PDF » / « Book Orchestrator ».

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Génération serveur des miniatures (côté client obligatoire, RS-005 $0).

---

## 5. Test cases & Validation
* **TC1** : Miniatures générées côté client (PDF.js WebP, $0 serveur).
* **TC2** : Virtual scroll (pages visibles + 2 suivantes, cache 24h).
* **TC3** : 4 modes d'affichage disponibles.
* **TC4** : Hover tooltip ; clic → Web Viewer page.

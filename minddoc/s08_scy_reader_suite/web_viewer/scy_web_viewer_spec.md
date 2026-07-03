<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🌐 SCY-WEB-VIEWER — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S08_READER_WEB_VIEWER_SPEC  
**Phase** : Phase 1  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Purpose
Cette spécification définit le **Web Viewer** — prévisualiseur **read-only strict** pour les fichiers **générés** par NEURON-CHAINS. Permet de voir le fichier avant de décider quoi en faire (flow naturel vers Reader Suite / Book Orchestrator / export).

---

## 2. Tech Stack & Dependencies
* **Rendu** : read-only strict (pas de sélection, pas de copie).
* **Score confiance** : visible en en-tête (T12 ConfidenceCalc).
* **Export** : boutons téléchargement 9 formats (§7.9).
* **Transitions** : boutons « Ouvrir dans Reader Suite » + « Analyser avec Book Orchestrator ».

> **Rappel anti-hallucination** : le Web Viewer affiche le score confiance réel (T12) ; read-only strict garantit l'intégrité du fichier généré.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Prévisualisation Read-Only
- **GIVEN** Un fichier généré par NEURON-CHAINS.
- **WHEN** L'utilisateur l'ouvre dans le Web Viewer.
- **THEN** le système SHALL l'afficher en read-only strict (pas de sélection/copie).
- **AND** le système SHALL afficher le score confiance en en-tête (T12).

### Requirement : Actions de Sortie
- **THEN** le système SHALL offrir les boutons d'export (9 formats).
- **AND** le système SHALL offrir « Ouvrir dans Reader Suite » et « Analyser avec Book Orchestrator ».

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Autoriser la sélection/copie (read-only strict).

---

## 5. Test cases & Validation
* **TC1** : Fichier généré affiché read-only (pas de sélection/copie).
* **TC2** : Score confiance (T12) visible en en-tête.
* **TC3** : Export 9 formats disponible.
* **TC4** : Transitions Reader Suite + Book Orchestrator fonctionnelles.

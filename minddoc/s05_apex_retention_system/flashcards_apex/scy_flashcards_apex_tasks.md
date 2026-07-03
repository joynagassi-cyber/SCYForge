<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
APEX/FSRS en MVP simplifié. SMI Calculator gardé, scheduler complet différé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-FLASHCARDS-APEX — TÂCHES (TASKS)
**ID** : S05_APEX_FLASHCARDS_TASKS

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

### Tâche FC.1 : Coder la génération EPSILON des 5 types MVP (30 min)
* **Fichier** : `backend_rs/src/apex/cards/generator.rs`
* **Description** : Génération B01-B05 via EPSILON (distracteurs MCQ plausibles B03), 12 cartes/nœud, validation Zod, persistance `scy_apex_cards`.
* **Critère** : 12 cartes/nœud validées et persistées.

### Tâche FC.2 : Coder la Leech Detection + alternatives (25 min)
* **Fichier** : `backend_rs/src/apex/cards/leech_detector.rs`
* **Description** : Détection >8 lapses / >80% échec → tag #leech + suggestions alternatives (B06/B01/C01/IMPRINT) + alerte DRIFT-GUARDIAN si >5.
* **Critère** : Leech détectée + alternatives proposées.

### Tâche FC.3 : Coder la gestion manuelle (suspend/bury/flag/edit/note) (25 min)
* **Fichier** : `backend_rs/src/apex/cards/card_manager.rs`
* **Description** : Suspendre, Bury card/siblings, Unsuspend, Delete soft, Edit, Flag (5 couleurs), Add note.
* **Critère** : Toutes les actions de gestion fonctionnelles.

### Tâche FC.4 : Intégrer TTS + Deep Links Reader Suite (20 min)
* **Fichier** : `backend_rs/src/apex/cards/card_manager.rs`
* **Description** : TTS étendu B01-B05 (touche R, mains-libres) + deep link sémantique (source/page/offset) vers Reader Suite (D-OPT-002).
* **Critère** : TTS `R` actif ; deep link ouvre Reader Suite à la position exacte.

<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-BOOK-ORCHESTRATOR — PLAN (PLAN)
**ID** : S08_READER_BOOK_ORCHESTRATOR_PLAN · **Décisions** : RS-003, RS-004

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

## Flux
```
[Première ouverture document / bouton Analyser IA]
   │
   ▼
[ÉTAPE 1 — Question clarification UI statique (7 intentions, $0)]
   │
   ▼
[ÉTAPE 2 — Analyse structure doc (Rust, $0) + sélection features/modes (règles déterministes)]
   ├── Vue globale → Arbre TOC + MindMap M3 + Timeline M6
   ├── Exploration → Concept Map M9 + Reader Suite Explore + BRAIN résumé
   ├── Concept précis → Sous-graphe COSMOS + cartes APEX + BRAIN Q directe
   ├── Créer révisions → NEURON-CHAINS + APEX + Teach-Back
   ├── Notes/IMPRINT → Reader Suite Focus + IMPRINT inline + Export notes
   ├── Comprendre vite → Page Gallery + Sprint Mode + Résumé 1 page
   └── IA décide → select_cosmos_modes (max 3) : hiérarchique→S10, >20 concepts→M9, chrono→M6, SMI<50→M7, dense→M0
   │
   ▼
[Persistance scy_book_orchestrations (user_intent, selected_features, cosmos_modes)]
```
## Dépendances : Rust (analyse structure + règles), EventBus. Table : `scy_book_orchestrations`.
## Fichiers : `backend_rs/src/reader/book_orchestrator/structure_analyzer.rs`, `mode_selector.rs`.

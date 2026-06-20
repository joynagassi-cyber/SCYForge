# 🛠️ SCY-CITATION-SOURCING — PLAN / TÂCHES / TESTS
**ID** : S02_NEURON_CITATION_SOURCING_PLAN / TASKS / TESTS · **Décisions** : D-OPT-002, D-COSMOS-019

## Flux de génération des citations
```
[NEURON-CHAINS génère une assertion]
   │
   ▼
[T08 CitationTracker : similarity assertion↔source (>0.60)]
   │
   ├── similarity < 0.60 → marquée HallucinationRisk::High (couche 2 anti-hallucination)
   │
   ▼ (similarity ≥ 0.60)
[Lien scy_concept_provenance : source_id + position (page/timestamp/paragraph) + confidence]
   │
   ▼
[Annotation exposant [N] dans le document (numérotation séquentielle)]
   │
   ▼
[Rendu frontend <CitationMark> : exposant cliquable + preview tooltip + deep link]
```

## Flux de rendu frontend (CitationMark)
```
[Exposant [1] dans le texte]
   │
   ├── survol (hover) → tooltip preview (<200ms, pré-chargé)
   │     ├── type source (🎥📄🌐✍️🤖)
   │     ├── titre source
   │     ├── extrait (50-100 mots)
   │     └── position (timestamp/page/paragraphe)
   │
   └── clic → deep link Reader Suite
         ├── 🎥 vidéo → timestamp exact (surligné)
         ├── 📄 PDF/EPUB → page + CFI (surligné)
         └── 🌐 web → paragraphe/offset (surligné)

[Bas du document → bibliographie numérotée (cliquable)]
```

## Dépendances : T08 CitationTracker, `scy_concept_provenance`, Reader Suite, React (CitationMark). 
## Fichiers : 
- `backend_rs/src/neurochain/citation/tracker.rs` (T08)
- `backend_rs/src/neurochain/citation/provenance_linker.rs` (lien position exacte)
- `frontend_react/src/components/CitationMark.tsx` (exposant + tooltip + deep link)
- `frontend_react/src/components/Bibliography.tsx` (liste références bas de document)

## Tâches
- CS.1 : Coder T08 CitationTracker (similarity assertion↔source >0.60) (25 min)
- CS.2 : Coder le lien provenance (source_id + position exacte page/timestamp/paragraph) (20 min)
- CS.3 : Coder CitationMark React (exposant cliquable + hover preview <200ms) (30 min)
- CS.4 : Coder le deep link Reader Suite (timestamp/page/paragraphe surligné) (25 min)
- CS.5 : Coder la bibliographie numérotée bas de document (20 min)
- CS.6 : Intégration transverse (cours ASCENT + cartes APEX + BRAIN + Mode Normal + COSMOS) (25 min)

## Tests
- TC1 : assertions annotées [1][2][3]. | TC2 : hover preview <200ms. | TC3 : clic 🎥→timestamp exact. | TC4 : clic 📄→page exacte. | TC5 : bibliographie cliquable. | TC6 : transverse (5 surfaces). | TC7 : % assertions citées (96%+). | TC8 : anti-hallucination (aucune citation sans source).

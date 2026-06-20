# 🛠️ SCY-DEEP-LINKS-UNIFIED — PLAN / TÂCHES / TESTS
**ID** : S08_DEEP_LINKS_UNIFIED_PLAN / TASKS / TESTS · **Décisions** : D-OPT-002, D-COSMOS-019

## Architecture transverse
```
[5 surfaces : Carte APEX | Nœud COSMOS | Citation cours | Document Mode Normal | Réponse BRAIN]
   │
   ▼ (clic sur deep link / badge / exposant [N])
[scy_concept_provenance : source_id + position (timestamp/page/CFI/paragraph)]
   │
   ▼
[Reader Suite ouverte à la position EXACTE]
   ├── 🎥 vidéo → timestamp (ex ?t=83) surligné
   ├── 📄 PDF/EPUB → page + CFI surligné
   ├── 🌐 web → paragraphe/offset surligné
   └── ✍️ academic → DOI + page
   │
   ▼
[Retour contexte préservé (retour à l'élément d'origine)]
```
## Dépendances : `scy_concept_provenance`, Reader Suite, CitationMark. 
## Fichiers : `frontend_react/src/reader/DeepLinkNavigator.ts`, intégration dans APEX/COSMOS/citations/BRAIN.
## Tâches : DL.1 Coder le DeepLinkNavigator (résolution provenance → position) (25min) | DL.2 Intégrer les 5 surfaces (APEX/COSMOS/cours/normal/BRAIN) (30min) | DL.3 Coder le retour contexte (15min).
## Tests : TC1 carte→Reader | TC2 nœud→Reader | TC3 citation→Reader | TC4 vidéo timestamp | TC5 PDF page+CFI | TC6 retour contexte.

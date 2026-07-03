<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-DEEP-LINKS-UNIFIED — PLAN / TÂCHES / TESTS
**ID** : S08_DEEP_LINKS_UNIFIED_PLAN / TASKS / TESTS · **Décisions** : D-OPT-002, D-COSMOS-019

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

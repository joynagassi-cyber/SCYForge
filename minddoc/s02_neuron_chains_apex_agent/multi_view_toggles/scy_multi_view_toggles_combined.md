<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-MULTI-VIEW-TOGGLES — PLAN / TÂCHES / TESTS
**ID** : S02_NEURON_MULTI_VIEW_TOGGLES_PLAN / TASKS / TESTS · **Réf** : PRD §7.4.3bis I

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

## Flux : [bloc technique généré] → menu basculement (toggle 50+ styles) → Vue Math (KaTeX 60FPS $0) ↔ Vue Sémantique (ELI5→PhD) ↔ Vue Code (Shiki/Prism + [▶ Exécuter] WASM) ↔ Vue Graphique (COSMOS micro) ↔ Vue Diagramme (Mermaid/AntV).
## Dépendances : KaTeX, Shiki/Prism, WASM runtime, Mermaid.js, COSMOS. 
## Fichiers : `frontend_react/src/components/MultiViewBlock.tsx`, `views/math_view.tsx`, `code_view.tsx`, `semantic_view.tsx`.
## Tâches : MV.1 Coder le toggle multi-vues (25min) | MV.2 Coder Vue Math KaTeX + Vue Code [▶ Exécuter] WASM (30min) | MV.3 Intégrer Vue Graphique + Diagramme Mermaid (20min).
## Tests : TC1 basculement 1 clic | TC2 KaTeX 60FPS | TC3 [▶ Exécuter] WASM résultat direct.

<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-FLOWSEEK — PLAN / TÂCHES / TESTS
**ID** : S02_NEURON_FLOWSEEK_PLAN / TASKS / TESTS · **Réf** : PRD §7.4.3bis H

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

## Flux : [concept structurel cours/slide] → NEURON-CHAINS émet flux JSON (nœuds+arêtes+labels) → frontend React Flow + elkjs dessine+anime 60 FPS en temps réel (coordonnées locales elkjs, 0$ serveur).
## Dépendances : React Flow (@xyflow/react), elkjs (Web Worker), NEURON-CHAINS streaming JSON. 
## Fichiers : `backend_rs/src/neurochain/flowseek/event_emitter.rs`, `frontend_react/src/components/GenerativeCanvas.tsx`.
## Tâches : FS.1 Coder l'émetteur JSON événements (NEURON-CHAINS) (25min) | FS.2 Coder le canvas React Flow + elkjs animé 60 FPS (30min) | FS.3 Intégrer dans slides ASCENT + pages cours (20min).
## Tests : TC1 graphe animé 60 FPS temps réel | TC2 elkjs local 0$ | TC3 synergie InfographicAI.

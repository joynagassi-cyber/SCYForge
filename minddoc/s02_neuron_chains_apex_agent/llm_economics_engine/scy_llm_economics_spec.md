<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 💰 SCY-LLM-ECONOMICS-ENGINE — SPÉCIFICATION (SPEC)
**ID** : S02_LLM_ECONOMICS_SPEC · **Décisions** : D-OPT-003 (Prompt Caching), D-OPT-004 (Batch API), Mécanisme 8 + 9 · **Phase** : MVP

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
Le **LLM Economics Engine** consolide les optimisations de coût LLM spécifiques aux providers : **Prompt Caching** (Anthropic/DeepSeek, -90% sur tokens système statiques) et **Batch API** (DeepSeek, -50% sur génération asynchrone). Maintient le coût à $0.006/parcours.

## 2. Les Optimisations Provider-Side

### D-OPT-003 — DeepSeek Prompt Caching (-90%)
- DeepSeek met en cache les tokens système (longs prompts statiques NEURON-CHAINS).
- Réduction de **-90%** sur ces tokens.
- **Règles de design** :
  1. Contenu STATIQUE en premier (instructions système, exemples, documents stables).
  2. Cohérence absolue — une seule virgule modifiée = cache invalidé.
  3. Privilégier les longs prompts système (>1000 tokens statiques).
- **Taux utilisation cache** : ~100% sur appels récurrents NEURON-CHAINS.
- À 10K appels/mois : -$54/mois d'économie.

### D-OPT-004 — DeepSeek Batch API (-50%)
- API Batch asynchrone pour génération de documents en tâche de fond.
- Remise de **-50%** vs tarif temps réel.
- **Usage** : AGENT-03 génère le premier jalon actif (synchrone) pendant que le reste est pré-généré en Batch asynchrone en arrière-plan.
- Couplé au Dynamic Graph Splitting (D-OPT-005) pour réduire TTFV.

### Mécanisme 9 — Stop Condition Streaming (-20%)
- Pour les appels avec extraction courte (titre, classification, 1er concept).
- Arrêter le stream dès que l'info est extraite (`stream.abort()`).
- Économie : -20% tokens output sur extractions courtes.

## 3. Requirements (RFC 2119)
- **D-OPT-003** : Les prompts système NEURON-CHAINS SHALL être structurés (statique en tête, dynamique en queue) pour maximiser le cache DeepSeek (-90%).
- **D-OPT-004** : Les générations de documents en arrière-plan SHALL utiliser la Batch API DeepSeek (-50%).
- **Mécanisme 9** : Les extractions courtes SHALL abort le stream dès extraction (-20%).

## 4. Tests
- TC1 : Prompt structuré → cache hit ~100% (-90% tokens système). | TC2 : Batch API asynchrone (-50%). | TC3 : Stream abort après extraction (-20%). | TC4 : Coût total ≤ $0.006/parcours.

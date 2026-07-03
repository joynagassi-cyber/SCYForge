<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-CHAIN-ALPHA — TÂCHES (TASKS)
**ID** : S02_NEURON_CHAIN_ALPHA_TASKS
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

### Tâche AL.1 : Coder ALPHA-1 Extracteur Brut (20 min)
* **Fichier** : `alpha/extractor.rs` · **Critère** : DOM/OCR/transcription → texte propre.
### Tâche AL.2 : Coder ALPHA-2 Chunker parallèle (25 min)
* **Fichier** : `alpha/chunker.rs` · **Critère** : Chunks 500-2000 tok overlap 10%, parallélisation tokio 10-50.
### Tâche AL.3 : Coder ALPHA-3 Résumeur L1/L2/L3 (25 min)
* **Fichier** : `alpha/summarizer.rs` · **Critère** : Résumés multi-niveaux + embeddings persistés `scy_chunks`.

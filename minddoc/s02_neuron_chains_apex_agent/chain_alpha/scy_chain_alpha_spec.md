<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🟢 SCY-CHAIN-ALPHA — EXTRACTION & SYNTHÈSE (SPEC)
**ID** : S02_NEURON_CHAIN_ALPHA_SPEC · **Phase** : MVP · **Décision** : NC-009 (Pipeline Pattern MapReduce L0-L4)

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
La chaîne **ALPHA** transforme le contenu source brut (DOM, OCR, transcription) en chunks sémantiques (500-2000 tokens, overlap 10%) puis en résumés multi-niveaux (L1=5 lignes, L2=2 paragraphes, L3=1 page). C'est l'étape fondatrice du pipeline MapReduce.

## 2. Agents
* **ALPHA-1 Extracteur Brut** : extraction contenu (DOM, OCR Docling, transcription audio).
* **ALPHA-2 Chunker Intelligent** : chunking sémantique (500-2000 tokens, overlap 10%), parallélisation 10-50 chunks (tokio async).
* **ALPHA-3 Résumeur Multi-Niveaux** : L1 (5 lignes), L2 (2 paragraphes), L3 (1 page synthèse).

## 3. Requirements (RFC 2119)
### Extraction & Chunking
- **GIVEN** Un contenu source brut ingéré.
- **THEN** ALPHA-1 SHALL extraire le texte propre ; ALPHA-2 SHALL chunker sémantiquement (500-2000 tokens, overlap 10%) en parallèle (tokio).
### Résumés Multi-Niveaux
- **THEN** ALPHA-3 SHALL produire L1/L2/L3 pour chaque chunk et la synthèse globale.
- **AND** chaque chunk + résumé SHALL être persisté dans `scy_chunks` (embedding VECTOR(512)).

## 4. Boundaries
🚫 Couleurs hors tokens `design.md`. ⚠️ Validation Zod des chunks/résumés.

## 5. Tests
- **TC1** : Source brute → chunks 500-2000 tokens (overlap 10%) en parallèle.
- **TC2** : Résumés L1/L2/L3 produits + embeddings persistés `scy_chunks`.
- **TC3** : Parallélisation 10-50 chunks sans blocage.

<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📑 SCY-CITATION-SOURCING — SPÉCIFICATION (SPEC)
**ID** : S02_NEURON_CITATION_SOURCING_SPEC · **Phase** : MVP · **Réf** : PRD §7.7, D-OPT-002, D-COSMOS-019

Voir `index.md` pour la spécification complète (requirements RFC 2119, test cases).

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

## Résumé
Système de sourcing transverse : chaque assertion issue d'une source ingérée est annotée d'un **chiffre majuscule en exposant cliquable** ([1][2]…). Au survol → **preview** de la source (type 🎥📄🌐, titre, extrait, position). Au clic → **deep link** vers la Reader Suite à la **position exacte** (timestamp vidéo / page PDF / paragraphe web). Bibliographie numérotée en bas de document.

## Application transverse
Cours ASCENT ✅ | Cartes APEX ✅ | Réponses BRAIN ✅ | Documents Mode Normal ✅ | Nœuds COSMOS ✅

## Stack : T08 CitationTracker, `scy_concept_provenance`, `<CitationMark>` React, Reader Suite, D-OPT-002 deep links.

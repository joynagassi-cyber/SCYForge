# 📑 SCY-CITATION-SOURCING — SPÉCIFICATION (SPEC)
**ID** : S02_NEURON_CITATION_SOURCING_SPEC · **Phase** : MVP · **Réf** : PRD §7.7, D-OPT-002, D-COSMOS-019

Voir `index.md` pour la spécification complète (requirements RFC 2119, test cases).

## Résumé
Système de sourcing transverse : chaque assertion issue d'une source ingérée est annotée d'un **chiffre majuscule en exposant cliquable** ([1][2]…). Au survol → **preview** de la source (type 🎥📄🌐, titre, extrait, position). Au clic → **deep link** vers la Reader Suite à la **position exacte** (timestamp vidéo / page PDF / paragraphe web). Bibliographie numérotée en bas de document.

## Application transverse
Cours ASCENT ✅ | Cartes APEX ✅ | Réponses BRAIN ✅ | Documents Mode Normal ✅ | Nœuds COSMOS ✅

## Stack : T08 CitationTracker, `scy_concept_provenance`, `<CitationMark>` React, Reader Suite, D-OPT-002 deep links.

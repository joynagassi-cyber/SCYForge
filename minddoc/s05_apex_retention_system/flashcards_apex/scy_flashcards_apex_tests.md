<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
APEX/FSRS en MVP simplifié. SMI Calculator gardé, scheduler complet différé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-FLASHCARDS-APEX — TESTS
---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

**ID** : S05_APEX_FLASHCARDS_TESTS

- **TC1** : 12 cartes/nœud générées (B02/B03/B04/B05), validées Zod, persistées dans `scy_apex_cards` (state=New).
- **TC2** : MCQ B03 avec distracteurs plausibles (erreurs communes réelles, pas aléatoires).
- **TC3** : Carte >8 lapses → tag #leech + alternatives (B06/B01/C01/IMPRINT Cran5) ; >5 leeches → alerte DRIFT-GUARDIAN.
- **TC4** : Gestion suspend/bury/flag/edit/note fonctionnelle.
- **TC5** : TTS `R` sur B01-B05 (mode mains-libres) ; deep link Reader Suite à la position exacte.
- **TC6** : B07 Teaching évalué par BRAIN → contribution dimension Mirror du SMI.
- **TC7** : Aucune carte inventée sans source (traçabilité EPSILON).

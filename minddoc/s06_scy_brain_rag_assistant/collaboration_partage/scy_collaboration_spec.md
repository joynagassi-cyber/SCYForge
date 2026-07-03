<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
BRAIN en MVP simplifié (BM25 FTS uniquement). Triple retrieval + live web différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🤝 SCY-COLLABORATION-PARTAGE — SPÉCIFICATION (SPEC)
**ID** : S06_COLLABORATION_SPEC · **Phase** : N1 P1, N2 P3, N3 P3, N4 P3+ · **Réf** : PRD §7.7quater, COL-001/002/003

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

## 1. Purpose
Module **Collaboration & Partage** — du partage simple read-only (Phase 1) au marketplace communautaire (Phase 3), commentaires asynchrones et sessions groupe live.

## 2. Les 4 Niveaux

### Niveau 1 — Partage Lien UUID Read-Only (Phase 1-2) ✅ COL-001
- Bouton « Partager » sur deck/objectif ASCENT → URL unique `scy_forge.app/shared/{uuid}`
- Destinataire voit en lecture seule (pas révision/édition)
- Bouton « Copier ce deck dans mon espace » (si compte)
- Permissions : owner | link_only | public. Expiration optionnelle (7j/30j/Jamais)
- Table `scy_deck_shares` (share_token, visibility, allow_fork, expires_at)

### Niveau 2 — Marketplace de Decks (Phase 3) COL-002
- Repository public de decks/parcours (métadonnées : auteur, domaine, rating, nb forks)
- Recherche full-text (Tantivy), Fork → copie personnelle
- Rating 1-5 ★ + commentaires texte
- Catégories : Tech, Business, Académique, Langues, Sciences, Arts
- Network effect + SEO + viral loop. Condition lancement : >50 decks qualité

### Niveau 3 — Commentaires Asynchrones (Phase 3)
- Commentaires/suggestions sur decks partagés (async, pas WebSocket)
- Résout 80% du besoin collaboration avec 10% de la complexité CRDT

### Niveau 4 — Sessions Groupe Live (Phase 3+, user research)
- IF 30%+ répondent « oui » (survey in-app) → Phase 4 prototype WebSocket
- IF <5% → Backlog indéfini

## 3. Requirements (RFC 2119)
- **N1** : Partage génère URL UUID lecture seule ; fork possible si compte.
- **N2** : Marketplace listable, recherchable, forkable, ratable.
- **N3** : Commentaires async sur decks publics.

## 4. Tests
- TC1 : URL UUID générée, lecture seule, expiration. | TC2 : Fork copie le deck. | TC3 : Marketplace recherche + rating + catégorie. | TC4 : Commentaire async posté.

<!--
BEACHHEAD PIVOT v2.0 — ELIMINATED
IMPRINT ÉLIMINÉE. Contenu biblique incompatible avec cyber ops. Réécriture nécessaire.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧠 SCY-CRE-ENGINE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID** : S07_IMPRINT_CRE_ENGINE_SPEC · **Phase** : V1 · **Réf** : PRD §7.8

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | ELIMINATED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module est ÉLIMINÉ du beachhead**
• Conservé pour expansion future
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Purpose
Le **CRE (Cognitive Register Engine)** distille progressivement un concept complexe sur **5 crans adaptatifs**, de 200-300 mots (Cran 1, compression initiale) à 50-65 mots (Cran 5, cristallisation finale de 5 à 7 insights selon Miller's Law 7±2). Objectif : ancrer durablement en mémoire à long terme par distillation sémantique progressive.

## 2. Les 5 Crans
| Cran | Mots | Rôle |
|------|------|------|
| Cran 1 | 200-300 | Compression initiale |
| Cran 2 | 150-200 | Élimination redondances |
| Cran 3 | 100-120 | Focus insights |
| Cran 4 | 70-85 | Noyau cognitif pur |
| Cran 5 | 50-65 | Cristallisation finale (5-7 insights, Miller's Law) |

## 3. Requirements (RFC 2119)
- **GIVEN** Un concept complexe (déclenché par Agent-04 : 3 succès consécutifs OU SMI > 75% OU fin nœud complexity ≥ 4).
- **THEN** le système SHALL distiller sur 5 crans (200-300 → 50-65 mots).
- **AND** le Cran 5 SHALL contenir 5-7 insights essentiels (Miller's Law 7±2).
- **AND** chaque cran SHALL être validé par Zod et persisté (`scy_imprint_registers`).

## 4. Tests
- TC1 : 5 crans produits (200-300 → 50-65 mots). | TC2 : Cran 5 = 5-7 insights. | TC3 : Déclenchement correct (3 succès / SMI>75 / complexité≥4).

<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag16_trunk_validator DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-AG16-TRUNK-VALIDATOR — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG16_TRUNK_VALIDATOR_PLAN
**Statut** : 🟡 PLAN D'ARCHITECTURE — EN ATTENTE DE VALIDATION FONDATEUR (aucun code)

---

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

## 1. Flux de Données de l'Agent

```
 [Tronc candidat T = {p₁…pₙ}]            [Connaissance K du sous-arbre]
   (depuis AG15-AXIOMATIZER + DomainPack)   (depuis AG03-DAG-ARCHITECT : topologie, root_depth)
                 │                                    │
                 └──────────────┬─────────────────────┘
                                ▼
              [Partition K = K_formel ⊎ K_tacite]
                 │                          │
                 ▼ (formalisable)           ▼ (tacite)
   ┌─────────────────────────────┐   ┌────────────────────────────────┐
   │ MOTEUR ARBRES DE BETH        │   │ HEURISTIQUE TACITE             │
   │ pour chaque kⱼ ∈ K_formel :  │   │ proxys de fondationnalité :    │
   │  - supposer T ∧ ¬kⱼ          │   │  root_depth (LCA)              │
   │  - décomposer (≤ Dmax,Bmax)  │   │  feynman_pass (teach-back)     │
   │  - fermeture branches ?      │   │  sop_grounding (PROV)          │
   │    ├─ toutes fermées→proven  │   │  coverage                      │
   │    ├─ ouverte→open+manquant  │   └────────────────────────────────┘
   │    └─ borne→undecided        │                  │
   └─────────────────────────────┘                  │
        │                                            │
        ▼                                            ▼
   Score_formel =                              Score_tacite =
   Derivability·Irreducibility·Consistency     moy_pondérée(proxys)
        │                                            │
        └──────────────┬─────────────────────────────┘
                       ▼
       foundationality = w_f·Score_formel + w_t·Score_tacite
                       │
        ┌──────────────┼───────────────────────────┐
        ▼              ▼                            ▼
 [branches ouvertes  [Validation Zod          [Journalisation
  → AG15 enrichir     FoundationalitySchema]   scy_agent_decisions
  OU marquer tacite]      │                     + arbre de preuve (audit)]
                          ▼
              [→ Moteur génératif : pondère feasibility(Seed)]
```

---

## 2. Décisions de runtime (tranchées dans ce plan)

| Question | Décision | Justification |
|---|---|---|
| **Synchrone vs async** | **Async avec cache par tronc** | La preuve Beth peut être coûteuse ; on pré-calcule la fondationnalité d'un tronc et on la met en cache (clé = hash du tronc `T`). Le blending lit le score en cache (non bloquant). Recalcul déclenché si `T` change. |
| **Granularité du déclenchement** | **Par sous-arbre (Living Node)**, à la demande du moteur génératif | Le tronc est défini au niveau d'un Living Node ; granularité naturelle. Évite de recalculer tout le STB. |
| **Affichage `undecided_in_budget`** | **Statut distinct, neutre** (« preuve non conclue dans le budget », ni succès ni échec) | Transparence investisseur : on ne maquille pas une preuve inachevée en échec ni en succès. |
| **Invalidation du cache** | Sur changement de `T` (nouveau principe d'AG15) ou de `K` (nouvelle feuille) | Bitemporel : ancien score fermé (non supprimé), nouveau score ouvert. |

---

## 3. Composants logiques (architecture, pas implémentation)

| Composant | Rôle | Localisation cible (future) |
|---|---|---|
| `beth_tableau` | construit et ferme l'arbre de Beth (décomposition bornée) | `backend_rs/src/ascent/trunk/beth_tableau.rs` |
| `formal_scorer` | Derivability · Irreducibility · Consistency | `backend_rs/src/ascent/trunk/formal_scorer.rs` |
| `tacit_scorer` | proxys heuristiques (root_depth, feynman, sop, coverage) | `backend_rs/src/ascent/trunk/tacit_scorer.rs` |
| `foundationality` | agrégation hybride + Zod | `backend_ts/src/ascent/agents/ag16_trunk_validator.ts` |
| `proof_journal` | journalise arbre de preuve + score (audit, PROV) | `backend_ts/src/ascent/agents/ag16_trunk_validator.ts` |

> ⚠️ Ces fichiers sont **cibles d'architecture**. **Aucun n'est créé tant que le fondateur n'autorise pas explicitement le codage.**

---

## 4. Dépendances pipeline
- **Amont** : AG15-AXIOMATIZER (principes du tronc), AG03-DAG-ARCHITECT (topologie/`root_depth`), DomainPack contract (règles de Horn `P1..P6`).
- **Aval** : Moteur génératif (pondère `feasibility` de la Seed), AG09-SKILL-CERTIFIER (cite la fondationnalité comme preuve), AG10-CHRONICLE (audit).
- **Parallèle** : AG13-COGNITIVE-VALIDATOR (vérité source — complémentaire, pas redondant).

---

*Plan d'architecture. Aucun code.*

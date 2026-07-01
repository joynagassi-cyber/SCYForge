# 🌳 SCY-AG16-TRUNK-VALIDATOR — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG16_TRUNK_VALIDATOR_SPEC
**Statut** : 🟡 SPÉCIFICATION D'ARCHITECTURE — EN ATTENTE DE VALIDATION FONDATEUR (aucun code)
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119

---

## 1. Purpose
Cette spécification définit le comportement de l'**AGENT-16 : TRUNK-VALIDATOR (Le Validateur de Tronc)**. Sa mission : **prouver, par les Arbres de Beth (tableaux sémantiques)**, que la connaissance `K` d'un sous-arbre est **dérivable** d'un tronc candidat `T` (premiers principes), et émettre un **score de fondationnalité hybride ∈ [0,1] NON bloquant**, accompagné du **diagnostic des branches ouvertes** (premiers principes manquants).

> Le TRUNK-VALIDATOR transforme « je crois que c'est le tronc » en « c'est **prouvé dérivable jusqu'aux atomes** ». Il est le garant que l'on reconstruit/innove sur une base réellement fondatrice.

**Fondation théorique réelle** : Arbres de Beth, méthode de théorie de la démonstration d'Evert Willem Beth (1908–1964) — procédure de décision pour le calcul propositionnel, semi-décidable au premier ordre (Church) [Evert Willem Beth](https://en.wikipedia.org/wiki/Evert_Willem_Beth), [Méthode des tableaux](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_tableaux).

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (orchestration step) + Rust (moteur de tableaux de Beth, décomposition récursive bornée).
* **Représentation logique** : **Datalog-like** (faits + règles de Horn), terminaison garantie ; FOL borné en repli (quantificateurs sur domaine fini). Cf. `docs/SCYFORGE_BETH_LOGICAL_REPRESENTATION_CYBER.md`.
* **Source du tronc `T`** : axiomes/principes issus de **AG15-AXIOMATIZER** + contrat DomainPack (`docs/SCYFORGE_DOMAIN_PACK_CONTRACT.md`).
* **Source de la connaissance `K`** : semantic tree / Living Node (via **AG03-DAG-ARCHITECT** pour la topologie & `root_depth`).
* **Score hybride** : partie formelle (preuve Beth) + partie tacite (heuristique), pondérées et **affichées séparément**.
* **Bornes anti semi-décidabilité** : `Dmax` (profondeur), `Bmax` (branches).
* **Journalisation** : `scy_agent_decisions` + arbre de preuve attaché (audit) ; provenance W3C PROV.
* **Validation** : modèles **Zod** stricts (`FoundationalitySchema`).

> **Rappel anti-hallucination** : AG16 ne prouve QUE sur des principes/faits réellement fournis (tronc `T` ancré). Il n'invente aucun premier principe. Une preuve non terminée dans le budget est marquée `undecided_in_budget` — JAMAIS présentée comme prouvée.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Preuve de Dérivabilité par Arbres de Beth

#### Scénario : Prouver T ⊢ k
- **GIVEN** Un tronc candidat `T = {p₁…pₙ}` et un élément de connaissance `kⱼ ∈ K`.
- **WHEN** Le TRUNK-VALIDATOR construit l'arbre de Beth pour `T ∧ ¬kⱼ`.
- **THEN** le système SHALL décomposer récursivement jusqu'aux atomes (ou borne `Dmax`).
- **AND** si **toutes les branches se ferment** (contradiction), le système SHALL marquer `kⱼ` comme `proven` (dérivable du tronc).
- **AND** si une **branche reste ouverte**, le système SHALL marquer `kⱼ` comme `open` ET émettre le **premier principe manquant** associé.
- **AND** si la borne `Dmax`/`Bmax` est atteinte avant fermeture, le système SHALL marquer `kⱼ` comme `undecided_in_budget` (ni prouvé, ni réfuté).

---

### Requirement : Score de Fondationnalité Hybride (NON bloquant)

#### Scénario : Calcul du score
- **GIVEN** Les résultats de preuve sur `K_formel` et les proxys sur `K_tacite`.
- **WHEN** Le système agrège.
- **THEN** le système SHALL calculer `Score_formel = Derivability · Irreducibility · Consistency` (produit).
- **AND** le système SHALL calculer `Score_tacite` = moyenne pondérée de (`root_depth`, `feynman_pass`, `sop_grounding`, `coverage`).
- **AND** le système SHALL produire `foundationality = w_f·Score_formel + w_t·Score_tacite`, avec `w_f + w_t = 1`.
- **AND** le système SHALL **afficher la décomposition complète** (formel vs tacite) — JAMAIS un score agrégé opaque.
- **AND** le système SHALL être **NON bloquant** : il émet un score, il ne barre aucune route.

---

### Requirement : Irréductibilité & Cohérence du Tronc

#### Scénario : Atomicité des premiers principes
- **GIVEN** Le tronc `T`.
- **WHEN** Le système teste chaque `pᵢ`.
- **THEN** le système SHALL tenter de dériver `pᵢ` des autres principes ; cette dérivation **DOIT échouer** pour que `pᵢ` soit jugé irréductible (atomique).
- **AND** le système SHALL vérifier que l'arbre de `T` seul **ne se ferme PAS** (sinon `T` est auto-contradictoire → `Consistency = 0`).

---

### Requirement : Diagnostic des Branches Ouvertes

#### Scénario : Pointer le principe manquant
- **GIVEN** Une ou plusieurs branches ouvertes.
- **WHEN** Le système conclut.
- **THEN** le système SHALL retourner `open_branches = [{ missing_principle, affected_knowledge }]`.
- **AND** le système SHALL transmettre ce diagnostic à **AG15-AXIOMATIZER** (enrichir le tronc) OU marquer la connaissance concernée comme `K_tacite`.

---

### Requirement : Alimentation du Moteur Génératif

#### Scénario : Modulation de la viabilité de la Seed
- **GIVEN** Un score de fondationnalité calculé pour un tronc d'origine.
- **WHEN** Le moteur génératif produit une Seed depuis ce tronc.
- **THEN** le système SHALL pondérer `feasibility(seed)` par la `foundationality` du tronc.
- **AND** une Seed issue d'un tronc faiblement fondé SHALL être marquée « fondation faible » — **pas interdite**, pondérée.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Inventer un premier principe non fourni par `T` pour fermer une branche.
* 🚫 **FORBIDDEN** : Présenter `undecided_in_budget` comme `proven`.
* 🚫 **SHALL NOT** : Agir comme une gate **bloquante** (AG16 émet un score, jamais un verdict barrant — c'est le rôle d'AG13).
* 🚫 **SHALL NOT** : Masquer la part tacite (heuristique) derrière la part formelle (prouvée) — décomposition toujours visible.
* 🚫 **MUST NOT** : Dépasser les bornes `Dmax`/`Bmax` (garantie de terminaison).
* ⚠️ **MUST** : Tout score validé par Zod ; arbre de preuve journalisé pour audit.

---

## 5. Démarcation vs agents voisins (anti-confusion)
| Agent | Question répondue | Nature | Bloquant ? |
|---|---|---|---|
| **AG13 COGNITIVE-VALIDATOR** | « cette assertion est-elle vraie/traçable à une source ? » | vérification anti-hallucination | **OUI** |
| **AG15 AXIOMATIZER** | « quel axiome abstrait ces traces de réussite ? » | induction | non (async) |
| **AG16 TRUNK-VALIDATOR** | « cette connaissance se déduit-elle des premiers principes ? » | **déduction (Beth)** | **NON (score)** |

> Une assertion peut être *vraie* (AG13 ok) mais *non fondée sur le tronc* (AG16 score bas) → signal qu'il manque un premier principe. **Les trois sont nécessaires et non redondants.**

---

## 6. Test cases & Validation (résumé — détail dans TESTS)
* **TC1 (Happy path)** : `T ⊢ k` toutes branches fermées → `proven` ; compte dans Derivability.
* **TC2 (Branche ouverte)** : connaissance sans observable dans `T` → `open` + principe manquant émis.
* **TC3 (Borne)** : preuve dépassant `Dmax` → `undecided_in_budget` (pas `proven`).
* **TC4 (Irréductibilité)** : `pᵢ` dérivable d'autres principes → `Irreducibility` pénalisé.
* **TC5 (Cohérence)** : `T` auto-contradictoire → `Consistency = 0` → `Score_formel = 0`.
* **TC6 (Hybride transparent)** : score affiche formel ET tacite séparément.
* **TC7 (Non bloquant)** : score bas ne barre pas le pipeline (Seed marquée « fondation faible »).
* **TC8 (Aucune invention)** : aucune branche fermée par un principe absent de `T`.

---

*Spécification d'architecture. Aucun code.*
*Réf. : `docs/SCYFORGE_BETH_TRUNK_VALIDATOR.md`, `docs/SCYFORGE_BETH_LOGICAL_REPRESENTATION_CYBER.md`, `docs/SCYFORGE_BETH_ASCENT_AGENT_COUPLING.md`.*

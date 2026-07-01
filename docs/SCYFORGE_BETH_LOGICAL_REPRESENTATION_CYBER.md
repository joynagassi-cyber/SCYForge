# SCYForge — Représentation logique des premiers principes cyber pour les Arbres de Beth

> **Statut** : architecture. **Aucun code.**
> **But** : définir COMMENT formaliser un tronc cyber (ATT&CK) en formules logiques exploitables par
> le **Beth Trunk Validator** (cf. `SCYFORGE_BETH_TRUNK_VALIDATOR.md`), pour prouver `T ⊢ K`.
> **Décision score** : **score hybride** — partie formalisable = preuve Beth ; partie tacite =
> heuristique séparée pondérée ; le score final combine les deux **explicitement**.
> **Ancrage données réelles** : `packs/cyber/ontology/cyber_semantic_tree.json` (14 troncs, 20 branches,
> 130 feuilles) + `attack_density.json` (SigmaHQ). Exemple fil rouge : tronc **Execution → T1059 → T1059.001 PowerShell**.

---

## 1. Le choix du langage logique (et pourquoi)

| Option | Décidabilité | Expressivité | Verdict SCYForge |
|---|---|---|---|
| Calcul propositionnel | **décidable** (Beth = procédure de décision effective) [5](https://en.wikipedia.org/wiki/Evert_Willem_Beth) | faible (pas de variables) | ✅ **noyau** : facts atomiques |
| Logique 1er ordre (FOL) | **semi-décidable** (Church) [5](https://en.wikipedia.org/wiki/Evert_Willem_Beth) | forte (quantificateurs, relations) | ⚠️ utile mais à **borner** |
| **Datalog** (FOL sans fonctions, négation stratifiée) | **décidable**, terminaison garantie | relations + règles récursives | ✅ **cœur recommandé** |

**Décision** : représenter les premiers principes cyber en **Datalog-like** (faits + règles Horn), que l'on **traduit en formules** soumises à l'Arbre de Beth. Datalog donne la **terminaison garantie** (pas d'explosion de l'indécidable FOL) tout en gardant la puissance des relations (`technique`, `tactic`, `requires`, `enables`). On reste donc dans la zone **où Beth se termine et donne une vraie preuve**.

> Règle d'or : **on ne formalise PAS toute la cyber**. On formalise le **squelette structurel** du tronc (relations entre tactiques/techniques/prérequis). Le savoir tacite (jugement d'analyste, contexte SOP) reste **hors-logique** → traité par l'heuristique du score hybride (§5).

---

## 2. Le vocabulaire logique du tronc cyber

### 2.1 Prédicats de base (atomes)
```
   tactic(X)                 X est une tactique ATT&CK            ex: tactic(execution)
   technique(T, X)           T est une technique de la tactique X ex: technique(t1059, execution)
   sub(S, T)                 S est une sous-technique de T        ex: sub(t1059_001, t1059)
   requires(T, C)            T requiert la capacité/condition C   ex: requires(t1059_001, interpreter_present)
   enables(T, U)             réussir T rend U possible            ex: enables(initial_access, execution)
   observable(T, O)          T produit l'observable O             ex: observable(t1059_001, ps_scriptblock_log)
   detects(R, O)             la règle R détecte l'observable O    ex: detects(sigma_4104, ps_scriptblock_log)
   mitigates(M, T)           la mitigation M contre T             ex: mitigates(constrained_language, t1059_001)
```

### 2.2 Les premiers principes (le TRONC = règles Horn fondatrices)
Ce sont les **axiomes** `T` que Beth utilise comme prémisses. Exemples (premiers principes du domaine cyber, pas inventés — dérivés de la structure ATT&CK kill-chain) :

```
P1  (chaîne)      enables(X, Y) ∧ achieved(X)  →  reachable(Y)
P2  (héritage)    sub(S, T) ∧ technique(T, X)  →  technique(S, X)
P3  (prérequis)   technique(T, _) ∧ requires(T, C) ∧ ¬satisfied(C)  →  ¬executable(T)
P4  (observabilité) executed(T) ∧ observable(T, O)  →  emitted(O)
P5  (détection)   emitted(O) ∧ detects(R, O)  →  detectable_by(R)
P6  (défense)     mitigates(M, T) ∧ active(M)  →  ¬executable(T)
```

> **Ces 6 règles + les faits ATT&CK = le tronc candidat `T`.** L'enjeu du BTV : **prouver que toute la connaissance opérationnelle K** (« PowerShell malveillant est détectable par la règle Sigma 4104 », « bloquer l'interpréteur empêche T1059.001 », etc.) **se dérive de ce tronc**.

---

## 3. Exemple fil rouge : prouver `T ⊢ K` sur PowerShell (T1059.001)

**Données réelles** : `cyber_semantic_tree.json` → tronc **Execution** (criticité 1.0) → branche **T1059** *Command and Scripting Interpreter* (1.0) → feuille **T1059.001 PowerShell** (1.0).

### 3.1 La connaissance à dériver (un `kⱼ`)
```
   k :  detectable_by(sigma_4104)
        « L'exécution PowerShell observée est détectable par la règle Sigma 4104. »
```

### 3.2 Faits du tronc mobilisés
```
   sub(t1059_001, t1059)                 technique(t1059, execution)
   executed(t1059_001)                   observable(t1059_001, ps_scriptblock_log)
   detects(sigma_4104, ps_scriptblock_log)
```

### 3.3 La preuve par Arbre de Beth (réfutation)
On veut prouver `T ⊢ k`. Méthode Beth : on suppose `T ∧ ¬k`, on décompose, on cherche la fermeture de **toutes** les branches [5](https://en.wikipedia.org/wiki/Evert_Willem_Beth), [1](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_tableaux).

```
   [hypothèse de réfutation]  ¬detectable_by(sigma_4104)        ← ¬k
   [P4 sur executed(t1059_001) ∧ observable(...)]  emitted(ps_scriptblock_log)
   [P5 sur emitted(...) ∧ detects(sigma_4104,...)]  detectable_by(sigma_4104)
   ─────────────────────────────────────────────────────────────
   contradiction :  detectable_by(sigma_4104)  ∧  ¬detectable_by(sigma_4104)
   → branche FERMÉE
```
Toutes les branches se ferment → **`T ⊢ k` est prouvé** → cette connaissance est **engendrée par le tronc**. ✅ Elle compte dans `Derivability`.

### 3.4 Cas d'une branche OUVERTE (le diagnostic utile)
Soit `k' : detectable_by(sigma_xxxx)` pour une technique **sans observable déclaré** dans le tronc (`observable(T, _)` absent). L'Arbre de Beth ne peut pas fermer la branche → **branche ouverte** → `T ⊬ k'`.
> **Diagnostic** : il manque un premier principe (ou un fait `observable(...)`). Le BTV signale **exactement** ce trou. → On enrichit le tronc, ou on classe `k'` comme **tacite** (passe à l'heuristique §5).

---

## 4. Gérer le semi-décidable : bornes et garde-fous

FOL pur est indécidable (Church) → un Arbre de Beth peut **ne pas terminer** [5](https://en.wikipedia.org/wiki/Evert_Willem_Beth). Garde-fous :

| Garde-fou | Mécanisme |
|---|---|
| **Datalog par défaut** | pas de symboles de fonction → terminaison garantie |
| **Borne de profondeur** `Dmax` | au-delà, on **arrête** et on renvoie un score **partiel** (preuve non conclue ≠ preuve fausse) |
| **Borne de branches** `Bmax` | limite la ramification pour les gros sous-arbres |
| **Quantificateurs bornés** | si FOL nécessaire, instancier sur un **domaine fini** (les techniques du sous-arbre, pas l'univers) |

> Une preuve **non terminée dans la borne** ne pénalise pas comme une preuve **échouée** : le score distingue `proven / open / undecided-in-budget`.

---

## 5. Score HYBRIDE : formalisable (Beth) + tacite (heuristique)

Conformément à ta décision, le score final **combine explicitement** les deux parts.

```
   Foundationality_hybride(T, K)
        =  w_f · Score_formel(T, K_formel)        ← preuve Beth (§2–4)
         + w_t · Score_tacite(K_tacite)           ← heuristique (ci-dessous)

   avec  w_f + w_t = 1,  pondérations = part de K réellement dans chaque registre
```

### 5.1 Partition de la connaissance
```
   K  =  K_formel   (exprimable en prédicats §2.1 → soumis à Beth)
       ⊎ K_tacite   (jugement, contexte SOP, heuristiques d'analyste → hors-logique)
```

### 5.2 Score formel (déjà défini dans le BTV)
```
   Score_formel = Derivability · Irreducibility · Consistency     (produit, cf. BTV §3)
```

### 5.3 Score tacite (heuristique, transparent)
Pour le savoir non formalisable, on **n'invente pas une preuve** — on mesure des **proxys de fondationnalité** observables :

| Proxy | Intuition | Source de signal |
|---|---|---|
| `root_depth` (profondeur LCA) | un savoir tacite rattaché profondément au tronc commun est mieux fondé | topologie du semantic tree (`SCYFORGE_GENERATIVE_ENGINE_MATH_FORMALIZATION.md`) |
| `feynman_pass` | l'analyste sait le **réexpliquer sans buter** (test Feynman des uploads) | teach-back / ASCENT |
| `sop_grounding` | le savoir est **ancré sur un document/SOP interne** identifié | provenance W3C PROV |
| `coverage` | proportion de K_tacite reliée à au moins un principe du tronc | graphe |

```
   Score_tacite = moyenne_pondérée(root_depth_norm, feynman_pass, sop_grounding, coverage)
```

### 5.4 Transparence (non-négociable)
Le score affiche **toujours** la décomposition :
```
   Foundationality = 0.78
     ├─ formel (w_f=0.6) : 0.85   [Derivability 0.91 · Irreducibility 0.97 · Consistency 1.0]
     └─ tacite (w_t=0.4) : 0.67   [root_depth 0.7 · feynman 0.6 · sop 0.8 · coverage 0.55]
     ⚠ 3 branches ouvertes signalées (premiers principes manquants : observable(t1110,_), …)
```
> On **ne masque jamais** la part prouvée derrière la part heuristique. Un investisseur/auditeur voit ce qui est **démontré** vs ce qui est **estimé**.

---

## 6. Pourquoi cette représentation tient (et ce qu'elle n'est pas)

- ✅ **Datalog = terminaison** → Beth donne de **vraies preuves** sur le squelette ATT&CK, pas des promesses.
- ✅ **Score hybride transparent** → on ne sur-vend pas : le formalisable est prouvé, le tacite est estimé et **affiché comme tel**.
- ✅ **Ancré sur données réelles** (T1059.001, Sigma) → pas une démo jouet.
- ❌ Ce n'est **pas** un moteur de détection (ce n'est pas un SIEM/règle Sigma). C'est un **validateur de fondationnalité du savoir**.
- ❌ Beth prouve la **dérivabilité logique**, pas la **vérité empirique** des faits ATT&CK (ceux-ci viennent de MITRE, ancrés par provenance).

---

## 7. Questions ouvertes (avant ingénierie)

1. **Source des règles Horn `P1..P6`** : figées par le DomainPack cyber, ou apprises/raffinées par un agent ?
2. **Calibration `w_f / w_t`** : fixe par domaine, ou fonction de la part réellement formalisée de K ?
3. **`Dmax / Bmax`** : valeurs par défaut et politique de dégradation gracieuse.
4. **Couplage ASCENT** : quel agent exécute le tableau de Beth et publie le score (piste : extension de l'AXIOMATIZER, qui manipule déjà des axiomes) — *objet du prochain doc si tu valides cette direction*.

---

*Document d'architecture. Aucun code.*
*Fondation réelle : Arbres de Beth [5](https://en.wikipedia.org/wiki/Evert_Willem_Beth), [1](https://fr.wikipedia.org/wiki/M%C3%A9thode_des_tableaux), [3](https://helios2.mi.parisdescartes.fr/~gk/NumLog/CM/NL_CM10.pdf).*
*Données cyber réelles : `packs/cyber/ontology/cyber_semantic_tree.json`, `attack_density.json` (SigmaHQ), hiérarchie MITRE ATT&CK STIX.*
*Réf. internes : `SCYFORGE_BETH_TRUNK_VALIDATOR.md`, `SCYFORGE_GENERATIVE_ENGINE_MATH_FORMALIZATION.md`.*

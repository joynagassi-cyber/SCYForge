# SCYFORGE — DOMAIN PACK CONTRACT

## Le contrat d'extensibilité : comment SCYForge change de niche sans souffrir

> **Document ID** : ARCH-DOMAIN-PACK-CONTRACT-V1
> **Date** : 2026-06-29
> **Statut** : 🔴 FONDEMENT ARCHITECTURAL — À LIRE AVANT TOUTE TRANSFORMATION DE CORPUS
> **Décision** : `arch_model = Domain Pack (plugin)` — le cœur reste domain-agnostic ; chaque niche est un pack chargeable.
> **Promesse** : *« Passer de la cyber à la médecine, au droit ou à l'aviation = ajouter un Domain Pack. Zéro réécriture du cœur. »*

---

## 0. Pourquoi ce document existe (le piège du monopole de niche)

Un monopole de niche est une force — mais il peut devenir un **piège architectural** : si la connaissance cyber est codée *en dur* dans le cœur, alors chaque nouvelle niche (médecine, droit, finance, aviation, industrie...) coûtera une **réécriture**. On gagnerait une niche et on perdrait la scalabilité multi-niches.

**Règle d'or de ce contrat :**

> **Le cœur de SCYForge ne sait RIEN de la cybersécurité. Il sait apprendre, retenir, simuler, prouver — sur N'IMPORTE QUEL domaine. Tout ce qui est « cyber » vit dans un Domain Pack, à l'extérieur du cœur, derrière une frontière nette.**

C'est l'application directe de l'**architecture hexagonale** déjà adoptée par le projet (ports/adapters) : le Domain Pack est un **adapter de domaine**. Le cœur expose des **ports** ; un Domain Pack les **implémente** pour une niche donnée.

Preuve que le cœur est déjà agnostique : dans `backend_rs/crates/scy-shared/src/types.rs`, les types fondateurs (`Goal`, `Node`, `Concept`, cartes FSRS...) **ne contiennent aucune notion de cyber**. Ce contrat formalise et protège cette frontière.

---

## 1. La frontière cœur / domaine (la ligne à ne jamais franchir)

```
┌──────────────────────────────────────────────────────────────────────┐
│                      CŒUR SCYFORGE (domain-agnostic)                   │
│  Ne connaît AUCUN domaine. Sait seulement transformer objectif→preuve. │
│                                                                        │
│  • ASCENT (13 agents)      • APEX / FSRS (rétention)                   │
│  • NEURON-CHAINS (génér.)  • COSMOS (visualisation)                    │
│  • BRAIN (Q&A)             • IMPRINT (mémorisation)                     │
│  • Ingestion cores         • EventBus / orchestration Mastra           │
│  • SMI / Proof-of-Skill engine (barème abstrait)                       │
│                                                                        │
│   ▲ consomme des PORTS (interfaces abstraites), jamais du cyber        │
└───┼────────────────────────────────────────────────────────────────────┘
    │  ports (interfaces de domaine)
┌───┴────────────────────────────────────────────────────────────────────┐
│                          DOMAIN PACK (adapter)                          │
│  Tout le savoir spécifique à UNE niche. Chargeable / remplaçable.       │
│                                                                         │
│  CYBER PACK   │  MEDICAL PACK  │  LAW PACK  │  AVIATION PACK  │  ...     │
│  (ontologie,  │  (ontologie    │  ...       │  ...            │          │
│   corpus,     │   médicale,    │            │                 │          │
│   scénarios,  │   protocoles,  │            │                 │          │
│   barèmes)    │   cas clin.)   │            │                 │          │
└─────────────────────────────────────────────────────────────────────────┘
```

**Ce qui peut traverser la frontière :** uniquement des structures abstraites (concept, nœud, relation, objectif, scénario, critère de preuve), jamais des concepts métier nommés en dur dans le cœur.

**Test de violation (à appliquer à toute PR) :** *si je grep le mot « ATT&CK », « SOC », « Sigma », « CVE » dans le code du cœur et que ça matche → violation du contrat.* Ces termes ne doivent exister QUE dans le Cyber Pack.

---

## 2. Anatomie d'un Domain Pack (les 7 ports)

Un Domain Pack implémente 7 ports. Chaque port répond à une question que le cœur pose, sans savoir lui-même y répondre pour un domaine donné.

| # | Port (interface) | Question posée par le cœur | Ce que le pack fournit | Agent ASCENT consommateur |
|---|---|---|---|---|
| 1 | **OntologyProvider** | « Quels sont les concepts du domaine et comment se relient-ils ? » | Une ontologie (taxonomie + relations), une clé de jointure pivot | `DAG-ARCHITECT (Ag-03)` |
| 2 | **CorpusProvider** | « Où trouver la matière première fiable ? » | Sources rares/asymétriques + métadonnées de confiance | `CONTENT-SCOUT (Ag-02)` |
| 3 | **RoleTaxonomyProvider** | « Quels rôles/postes existent et que doivent-ils maîtriser ? » | Rôles → sous-graphes de compétences requis | `GOAL-INTERPRETER (Ag-01)` |
| 4 | **DecisionScenarioProvider** | « Quelles décisions sous pression doit-on savoir prendre ? » | Scénarios branchés + arbres de décision | `ARENA (Ag-11)` |
| 5 | **ProofRubricProvider** | « Comment prouver la maîtrise dans ce domaine ? » | Barèmes, critères, seuils de certification | `SKILL-CERTIFIER (Ag-09)` |
| 6 | **RetentionPolicyProvider** | « Qu'est-ce qui est critique à ne jamais oublier ? » | Pondérations FSRS, concepts vitaux, fréquence min. | `APEX/FSRS`, `IMPRINT` |
| 7 | **ValidationGuardProvider** | « Comment savoir qu'une sortie IA est correcte/sûre ici ? » | Règles de validation domaine, faits non négociables | `COGNITIVE-VALIDATOR (Ag-13)`, `VISUAL-CRITIC (Ag-12)` |

> Un Domain Pack **complet** implémente les 7 ports. Un pack **minimal viable** (MVP) peut n'en fournir que 1, 2, 4 et 5 (ontologie, corpus, scénarios, preuve) ; les autres ont des **valeurs par défaut neutres** fournies par le cœur.

---

## 3. Schéma de manifeste d'un Domain Pack

Chaque pack se déclare par un manifeste (`pack.manifest.json` / table `scy_domain_pack`) que le cœur charge dynamiquement :

```jsonc
{
  "pack_id": "cyber",                    // identifiant stable, slug
  "version": "1.0.0",                    // semver — le cœur vérifie la compat
  "display_name": "Cybersécurité — Blue Team / SOC",
  "core_api_version": ">=1.0 <2.0",      // contrat de compatibilité avec le cœur
  "pivot_ontology": "mitre_attack",      // clé de jointure du domaine
  "provides": {                          // quels ports sont implémentés
    "ontology": true,
    "corpus": true,
    "role_taxonomy": true,
    "decision_scenarios": true,
    "proof_rubric": true,
    "retention_policy": true,
    "validation_guard": true
  },
  "entrypoints": {                       // adapters concrets (TS/Rust)
    "ontology": "packs/cyber/ontology/index",
    "corpus": "packs/cyber/corpus/index",
    "scenarios": "packs/cyber/scenarios/index",
    "rubric": "packs/cyber/rubric/index"
  },
  "data_sovereignty": "tenant_isolated", // données privées clients → jamais partagées entre tenants
  "license": "proprietary"
}
```

**Règle de compatibilité :** le cœur expose une `core_api_version`. Un pack déclare la plage qu'il supporte. Tant que le cœur respecte le semver, **un pack continue de fonctionner sans modification** lors des montées de version du cœur — c'est la garantie « pas de souffrance ».

---

## 4. Modèle de données : neutre dans le cœur, qualifié dans le pack

Le cœur stocke des entités **abstraites** ; le domaine n'ajoute que des **références** et des **attributs étiquetés**, jamais de colonnes en dur.

| Entité cœur (existe déjà) | Champ neutre | Extension par le pack (sans modifier le cœur) |
|---|---|---|
| `Node` | `title`, `summary`, `confidence` | `node.domain_refs[]` → ex. `{ "ontology": "mitre_attack", "id": "T1059" }` |
| `Concept` | `label`, `definition` | `concept.tags[]`, `concept.criticality` (depuis RetentionPolicy) |
| `Goal` | `title`, `description` | `goal.role_ref` → ex. `soc_analyst_l1` (depuis RoleTaxonomy) |
| *(nouveau, générique)* `Scenario` | `prompt`, `branches[]`, `scoring` | rempli par DecisionScenarioProvider |
| *(nouveau, générique)* `ProofCriterion` | `dimension`, `threshold` | rempli par ProofRubricProvider |

Le mécanisme `domain_refs[]` (un sac de paires `{ontology, id}`) est **la clé de l'extensibilité** : le cœur ne sait pas ce qu'est `T1059`, il sait juste qu'un nœud porte une référence vers une ontologie nommée. Demain, un nœud médical portera `{ "ontology": "icd11", "id": "1A00" }` — **même code cœur, autre pack**.

---

## 5. Cycle de vie d'un pack (chargement, isolation, données privées)

```
1. REGISTER   → le manifeste est validé (semver, ports, signature)
2. LOAD       → le cœur instancie les adapters déclarés
3. BIND       → les agents ASCENT résolvent leurs ports via le pack actif
4. RUN        → un tenant choisit un pack ; ASCENT s'exécute dessus
5. LEARN      → les données privées du tenant (erreurs, postmortems, feedback)
                enrichissent le pack POUR CE TENANT UNIQUEMENT (isolation)
6. UPGRADE    → nouveau semver du cœur → packs compatibles continuent sans patch
```

**Souveraineté des données (critique pour le moat) :** la couche 5 du moat (données privées clients) vit dans un espace `tenant_isolated`. Le **corpus public** d'un pack est partagé ; les **données privées** d'un tenant ne le sont **jamais**. C'est ce qui rend le flywheel non copiable (cf. `SCYFORGE_RARE_RESOURCE_MOAT_MAP.md` § 6).

---

## 6. Comment l'extensibilité se prouve concrètement

Pour valider que le contrat n'est pas théorique, le **Cyber Pack** doit être implémenté *comme s'il était un pack parmi d'autres*, et on doit pouvoir esquisser un **2e pack fictif** (ex. « medical-mini ») qui implémente les mêmes 7 ports avec d'autres données — sans toucher une ligne du cœur. Si c'est possible, l'extensibilité est démontrée.

| Port | Instance CYBER | Instance MEDICAL (preuve d'agnosticité) |
|---|---|---|
| OntologyProvider | MITRE ATT&CK (techniques/tactiques) | ICD-11 / SNOMED (diagnostics) |
| CorpusProvider | OTRF, Sigma, MITRE Emulation, CISA | guidelines HAS, protocoles, cas cliniques |
| RoleTaxonomy | Analyste SOC L1/L2, Threat Hunter, IR | Infirmier, urgentiste, anesthésiste |
| DecisionScenario | « Alerte EDR à 3h du matin → triage » | « Patient en détresse → protocole » |
| ProofRubric | Triage correct + escalade + faux positifs | Diagnostic + décision + sécurité patient |
| RetentionPolicy | TTPs critiques jamais oubliés | Posologies critiques jamais oubliées |
| ValidationGuard | Pas de conseil offensif hors scope | Pas de conseil médical dangereux |

**Même cœur. Même ASCENT. Deux mondes.** C'est ça, « ne pas souffrir en changeant de niche ».

---

## 7. Règles de gouvernance du contrat (non négociables)

1. **Aucun terme métier dans le cœur.** (`grep` interdit : ATT&CK, SOC, Sigma, CVE, ICD, etc. dans `scy-shared` / agents core.)
2. **Le cœur ne dépend jamais d'un pack ; les packs dépendent du cœur.** (Sens de dépendance unidirectionnel.)
3. **Tout pack implémente au minimum 4 ports** (ontology, corpus, scenarios, rubric) ; le reste a des défauts neutres.
4. **Semver strict** : montée mineure/patch du cœur = aucun pack cassé.
5. **Isolation tenant** sur les données privées : jamais de fuite inter-tenant ni inter-pack.
6. **Le pivot d'ontologie est obligatoire** : chaque pack déclare sa clé de jointure (ATT&CK pour cyber).

---

## 8. Conséquence directe pour le travail en cours

La transformation des ressources rares cyber (ThreatHunter-Playbook, Sigma, MITRE Emulation, CISA) ne se fait **pas** « dans SCYForge » au sens vague — elle se fait **dans le Cyber Pack**, en remplissant les 7 ports ci-dessus. Concrètement :

- l'**ontologie** cyber → `OntologyProvider` (pivot ATT&CK) → livrable `SCYFORGE_CYBER_ONTOLOGY.md`
- les **corpus** raffinés → `CorpusProvider` → livrable `SCYFORGE_FOUNDER_CORPUS.md`
- les **rôles** SOC → `RoleTaxonomyProvider`
- les **scénarios** (MITRE Emulation) → `DecisionScenarioProvider`
- les **barèmes** → `ProofRubricProvider`

Ainsi, chaque heure investie dans la cyber **respecte la frontière** et reste réutilisable comme patron pour la niche suivante.

---

*Fin du contrat. Le cœur transforme ; le pack qualifie. Changer de niche = changer de pack.*

# SCYForge — Rapport évolutif : recherche, consolidation & modélisation de feature

> **Statut** : 🟢 Document vivant — v0.11
> **Rôle de ce document** : agent de recherche + consolidation + modélisation + transformation.
> **Périmètre** : SaaS existant (SCYForge, verticale d'entrée Cyber / SOC / blue team).
> **Méthode** : (1) consolidation de ton corpus interne, (2) recherche externe / état de l'art, (3) modélisation de la feature innovante.
> **Mise à jour** : chaque itération ajoute une entrée dans le §9 Journal de version.

---

## 0. Comment lire ce document

Il est structuré pour évoluer sans se réécrire :

| Section | Nature | Change souvent ? |
|---|---|---|
| §1 Consolidation | ce que TON corpus dit déjà | rarement (socle) |
| §2 Recherche externe | état de l'art + chiffres marché | à chaque veille |
| §3 Synthèse / tension | où corpus et marché se rencontrent | moyen |
| §4 Feature innovante | modélisation de la feature | souvent (cœur) |
| §5 Modèle de données | contrats, objets, flux | souvent |
| §6 Métriques de preuve | comment on prouve que ça marche | moyen |
| §7 Risques | ce qui peut casser | moyen |
| §8 Prochaines actions | backlog vivant | à chaque tour |
| §9 Journal de version | historique | à chaque tour |

---

## 1. Consolidation du corpus interne (ce que tes docs affirment)

### 1.1 Identité produit
SCYForge n'est **pas** un LMS, ni un chatbot documentaire, ni une plateforme de labs, ni un SOAR. C'est une **infrastructure de maîtrise opérationnelle** : elle transforme le savoir interne d'une organisation (SOP, playbooks, runbooks, postmortems, KB, politiques, workflows d'escalade) en **autonomie prouvée**.

### 1.2 Le principe d'architecture central (le plus important)
Séparation stricte entre :
- un **noyau cognitif invariant** (« comment fabriquer la maîtrise ») — ne sait rien de la cyber en dur ;
- des **Domain Packs** (« ce que signifie être compétent dans ce métier ») — injectent la vérité métier.

Chaque feature = **Kernel Capability + Domain Contract + Domain Artifact + Runtime Policy**.

Les 11 primitives du noyau (invariantes tous domaines) :
1. Déclarer un objectif → 2. Le décomposer en graphe de maîtrise → 3. Ingérer/normaliser des sources privées → 4. Construire une représentation exploitable → 5. Diagnostiquer le niveau réel → 6. Choisir la meilleure intervention suivante → 7. Créer une expérience active → 8. Mesurer compréhension/rétention/jugement/exécution → 9. Détecter dérives, illusions de compétence, oublis → 10. Produire une preuve de compétence défendable → 11. Boucler jusqu'à l'autonomie.

### 1.3 La thèse cognitive (le vrai différenciateur)
Les produits d'apprentissage assistés par IA optimisent la fluidité, la satisfaction immédiate, la vitesse perçue, la densité de contenu, la réduction de friction. **SCYForge optimise l'inverse utile** : structuration, récupération active, consolidation, jugement, preuve, autonomie.

Règle noyau : *ce qui semble plus agréable n'est pas forcément ce qui produit la maîtrise* → le runtime doit parfois **protéger l'apprenant contre sa préférence pour la passivité**.

Formalisé par 5 **Cognitive Runtime Policies** :
1. `OutputPressurePolicy` — surveille l'accumulation d'input sans output ; force rappel / teachback / application.
2. `CognitiveFrictionPolicy` — introduit de la friction utile (desirable difficulty).
3. `ConsolidationWindowPolicy` — impose fenêtres de consolidation / repos.
4. `SparringPolicy` — l'IA devient contradicteur / évaluateur, pas juste assistant.
5. `SemanticTreePriorityPolicy` — protège le « tronc sémantique » (fondamentaux) avant les branches.

### 1.4 Moat (défendabilité)
Corpus interne unique par client + graphes de compétence contextuels + historique d'apprentissage/performance + intégration au workflow d'onboarding + coût de sortie élevé une fois la logique de maîtrise encodée.

### 1.5 Contrainte fondateur (cadrage business)
Trésorerie pré-levée < 5 k€. Décision stratégique validée par ton mémo : **aucune certification payante** (SOC 2, ISO, certifs perso) avant preuve de demande. Le goulot réel = **MVP solide + 2–3 design partners + une page de chiffres** (protocole A/B mesurant le time-to-autonomy).

---

## 2. Recherche externe / état de l'art (veille)

### 2.1 Sciences de l'apprentissage — ta thèse est validée par la littérature
- La **récupération active** (retrieval practice) surpasse systématiquement la relecture pour la rétention et le transfert de concepts complexes.
- La **répétition espacée** améliore la durabilité via consolidation neuronale.
- Ces deux leviers sont des **« desirable difficulties »** : ils demandent un effort mental réel, et c'est précisément cet effort qui produit l'apprentissage durable.
- Efficacité modulée par : qualité du feedback, effort de récupération, complexité du matériel.

→ **Conclusion** : tes `OutputPressurePolicy` et `CognitiveFrictionPolicy` ne sont pas un pari — elles opérationnalisent un consensus scientifique que la quasi-totalité des LMS ignore en pratique.

### 2.2 Marché SOC / onboarding cyber — le problème est chiffré et réel
- Former un analyste SOC junior jusqu'à l'**indépendance complète prend 4 à 9 mois** (ramp-up moyen > 6 mois).
- Le sujet 2025 n'est plus le manque de têtes mais un **désalignement de compétences** : 52–59 % des dirigeants citent des lacunes critiques de capacités.
- L'onboarding est désormais vu comme une **stratégie de mitigation du risque** : une formation insuffisante est directement liée à des temps de présence (dwell time) plus longs, des alertes ratées et des coûts de breach accrus.

→ **Conclusion** : ton wedge (réduire le time-to-autonomy des recrues SOC) attaque une douleur mesurable, budgétée et reliée au risque — donc « must-solve », pas « nice-to-have ».

### 2.3 Paysage concurrentiel (upskilling piloté par IA)
- Les plateformes 2025 (Cornerstone, Spire.AI, Skillsoft, Degreed, Perceptyx, AccelIQ…) adoptent des **knowledge graphs** pour mapper skills/rôles/objectifs et dépasser le simple « taux de complétion de cours ».
- Elles font de l'inférence de compétence temps réel et des parcours adaptatifs.
- **MAIS** : elles restent orientées *contenu générique* + *mobilité interne RH*. Aucune ne part du **corpus opérationnel privé** de l'équipe pour produire une **preuve d'autonomie défendable au niveau du poste**, et aucune n'assume une posture **anti-passivité** (elles optimisent l'engagement, pas la friction utile).

→ **Espace blanc** : « corpus privé → maîtrise prouvée par rôle » avec un runtime qui force l'output. C'est ton angle non-occupé.

---

## 3. Synthèse : la tension productive

| Le marché fait | SCYForge fait |
|---|---|
| Contenu générique | Corpus interne réel du client |
| Complétion de cours | Preuve d'autonomie par rôle |
| Optimise l'engagement / la fluidité | Optimise la friction utile / l'effort de récupération |
| Knowledge graph RH (skills ↔ jobs) | Graphe de maîtrise contextuel (concepts ↔ décisions ↔ preuve) |
| « L'employé a suivi X heures » | « La recrue sait décider correctement dans NOTRE environnement » |

Le point de rencontre corpus × marché = **une feature qui matérialise, de façon mesurable et vendable, la promesse "de la doc interne à l'autonomie prouvée".**

---

## 4. La feature : **ASCENT** — le moteur de maîtrise (13 agents)

> ✅ **Correction de nommage (v0.2)** : ce que la v0.1 appelait « Autonomy Proof Loop » **est ASCENT**. ASCENT n'est pas une nouvelle feature à inventer : c'est **la couche cognitive existante** de SCYForge, le « moteur de maîtrise » qui transforme *objectif → preuve d'autonomie*. Cette section modélise ASCENT tel qu'il est dans ton corpus, pas une invention.

### 4.1 Définition (ancrée corpus)
**ASCENT = l'orchestration de 13 agents domain-agnostiques** qui exécutent les 11 primitives du noyau. ASCENT **ne contient aucun terme cyber en dur** : chaque agent résout sa « vérité métier » en appelant un **provider du Domain Pack** actif (règle d'or du pivot : grep « MITRE / SOC / Sigma / CVE » dans ASCENT = violation de contrat).

Cycle de vie du savoir qu'ASCENT pilote sur le Semantic Tree : **Plant → Graft → Test → Myelinate** (planter le tronc 80/20 → greffer sur nœud solide → faire *reconstruire* la branche par active recall → consolider par répétition espacée jusqu'au seuil de maîtrise SMI ≥ 0.70).

### 4.2 Les 13 agents ASCENT → provider consommé → vérité cyber

| # | Agent ASCENT | Rôle noyau (agnostique) | Provider du pack consommé | Vérité Cyber injectée | Prio |
|---|---|---|---|---|---|
| Ag-01 | **GOAL-INTERPRETER** | rôle/objectif → sous-graphe requis | `RoleTaxonomyProvider` | SOC L1/L2/L3, DFIR, Detection Eng. | P0 |
| Ag-02 | **CONTENT-SCOUT** | trouver la matière première fiable | `CorpusProvider` | SOP, playbooks, postmortems, Sigma, CISA IR | P0 |
| Ag-03 | **DAG-ARCHITECT** | compiler le graphe de maîtrise (tronc→branches→feuilles) | `OntologyProvider` | 14 troncs ATT&CK, criticité = densité Sigma | P0 |
| Ag-04 | **LEARNING-CONDUCTOR** | orchestrer la trajectoire d'apprentissage | `RoleTaxonomy` + `RetentionPolicy` | séquençage par rôle | P0 |
| Ag-05 | **PERFORMANCE-ANALYZER** | diagnostiquer le niveau réel (pas déclaré) | `ProofRubricProvider` | barèmes de jugement SOC | P0 |
| Ag-09 | **SKILL-CERTIFIER** | émettre la preuve d'autonomie bornée/auditée | `ProofRubric` + `ValidationGuard` | autonomie par classe d'alertes, proof records | P0 |
| Ag-11 | **ARENA** | mettre sous pression via décisions branchées | `DecisionScenarioProvider` | scénario APT29 (79 steps, 3 branches) | P0 |
| Ag-06 | **ADAPTIVE-ROUTER** | router remédiation par perf/confusion/fatigue | `RetentionPolicy` + `DecisionScenario` | remédiation faux positifs, complexité triage | P1 |
| Ag-07 | **DRIFT-GUARDIAN** | détecter oubli / dérive / illusion de compétence | `RetentionPolicy` | half-life des procédures critiques | P1 |
| Ag-10 | **CHRONICLE** | capitaliser incidents/postmortems dans la KB | `CorpusProvider` | greffe d'incidents réels du tenant | P1 |
| Ag-08 | **BRAIN** | Q&A ancré source (MVP : BM25 FTS) | `CorpusProvider` | réponses grounded corpus interne | P1 |
| Ag-12 | **VISUAL-CRITIC** | critiquer la qualité des représentations | `ValidationGuardProvider` | cohérence visuelle vs vérité métier | P2 |
| Ag-13 | **COGNITIVE-VALIDATOR** | garder la sécurité/justesse des sorties IA | `ValidationGuardProvider` | faits non négociables, anti-hallucination | P2 |

> Note : APEX/FSRS (rétention/répétition espacée) et COSMOS (visualisation) sont des **modules du noyau** couplés à ASCENT, pas des agents ASCENT au sens strict.

### 4.3 ASCENT gouverné par les 5 Cognitive Runtime Policies
Les policies s'appliquent transversalement aux agents (mapping corpus) :
- `OutputPressurePolicy` → GOAL, DAG, ADAPTIVE-ROUTER, SKILL-CERTIFIER (force rappel/teachback/application).
- `CognitiveFrictionPolicy` → friction utile calibrée dans ARENA / PERFORMANCE-ANALYZER.
- `ConsolidationWindowPolicy` → APEX/FSRS + LEARNING-CONDUCTOR (fenêtres de repos).
- `SparringPolicy` → SKILL-CERTIFIER / ARENA (l'IA devient contradicteur/évaluateur).
- `SemanticTreePriorityPolicy` → DAG-ARCHITECT + ADAPTIVE-ROUTER (protéger le tronc avant les feuilles).

### 4.4 Découpage 4 couches (patron SCYForge, appliqué à ASCENT)
- **Kernel Capability** : les 13 agents + orchestration Plant/Graft/Test/Myelinate (aucune connaissance cyber).
- **Domain Contract** : les 9 providers (`Ontology`, `Corpus`, `RoleTaxonomy`, `DecisionScenario`, `ProofRubric`, `RetentionPolicy`, `ValidationGuard`, `PackConfigProvider`, `PackJsonSchemaProvider`).
- **Domain Artifact (Cyber Pack v0.2)** : ATT&CK, SigmaHQ, scénarios APT29, rubriques SOC, garde-fous.
- **Runtime Policy** : source-grounding obligatoire, pas de certif sans scénario branché, seuils de friction par niveau/risque, SMI ≥ 0.70.

### 4.5 Le test de vérité (à ne jamais violer)
> « Si je retire totalement le Pack Cyber, est-ce qu'ASCENT garde sa structure, son contrat et son sens ? » — Si oui = plateforme. Si non = solution de niche déguisée. **C'est le critère d'acceptation de toute modélisation d'ASCENT.**

### 4.6 Le Domain Pack est un **MÉDIATEUR**, pas le curriculum (principe fondateur, v0.6)

> ⚠️ **Correction de cadrage majeure.** Jusqu'ici les docs pouvaient laisser croire que le Cyber Pack *définit ce que la recrue doit apprendre*. **C'est faux et dangereux.** On ne décide pas de ce qu'on enseigne à la recrue : **la vérité pédagogique (« quoi maîtriser ») appartient à l'entreprise** et nous est fournie **explicitement**. Le Domain Pack est le **médiateur** qui permet d'amener la recrue à maîtriser *ce qui existe réellement dans son entreprise*.

**Les deux sources de vérité, à ne jamais confondre :**

| | **Vérité pédagogique — « QUOI »** | **Vérité de médiation — « COMMENT structurer »** |
|---|---|---|
| **Détenteur** | **L'entreprise** (fournie explicitement) | **Le Domain Pack** (notre apport) |
| **Nature** | Docs, SOP, playbooks, postmortems, politiques, périmètre d'autonomie autorisé, définition locale du « bien fait » | Ontologie ATT&CK, grammaire de tronc/branches/feuilles, rubriques génériques, garde-fous, formule de priorité |
| **Autorité** | **Autoritative et non négociable** — on ne peut pas apprendre à la recrue ce qu'on veut | **Contextuelle** — donne un cadre solide, aligne, désambiguïse |
| **Si conflit** | **L'entreprise gagne toujours** | le pack s'efface / signale l'écart, il ne substitue jamais |

**Ce que le médiateur fait concrètement (sa vraie valeur) :**
1. **Ancrer** — donner un référentiel solide et à jour (ATT&CK, familles d'alerte, cadres NIST/NIS2) pour *lire* et *classer* les documents de l'entreprise.
2. **Aligner** — mapper les SOP/playbooks/incidents internes sur une structure de maîtrise cohérente (tronc → branches → feuilles décisionnelles).
3. **Combler intelligemment** — repérer les trous du corpus interne et proposer un échafaudage public *à valider*, jamais l'imposer comme vérité.
4. **Traduire en preuve** — transformer « voici nos docs » en « voici un parcours de maîtrise mesurable et une preuve d'autonomie bornée ».

**Formule** : *Pack (contexte solide + alignement) × Corpus entreprise (vérité du quoi) → parcours de maîtrise déterministe → preuve d'autonomie.* Sans corpus entreprise, le pack ne produit **aucun** curriculum : il n'a rien à aligner.

**Implications à respecter partout :**
- Le `CorpusProvider` traite les **documents de l'entreprise comme source primaire autoritative** ; les sources publiques (Sigma, CISA…) ne sont qu'un **échafaudage de médiation** (cf. §R4 dans l'ontologie).
- Dans le `seed_hash`, le `corpus_snapshot_id` **est celui du tenant** : deux entreprises = deux vérités = deux arbres, même pack.
- L'`OntologyProvider` est une **grille d'alignement**, pas la liste des choses à savoir. La liste vient du corpus entreprise projeté sur cette grille.
- Le test de vérité §4.5 se double d'un **test de médiation** : *« Si je retire le corpus de l'entreprise, reste-t-il un curriculum ? »* → **Non, et c'est voulu.** Le pack ne fabrique pas de savoir, il **médie** le savoir de l'entreprise.

---

## 5. Modèle de données ASCENT (esquisse à durcir)

Objets pivots (à réconcilier avec `RCL_IMPLEMENTATION_BACKLOG`, `SEMANTIC_TREE_INFRASTRUCTURE` et les tables `scy_*` du PIVOT_ARCHITECTURE §6). Le `MasteryNode` ci-dessous = projection applicative du `scy_tree_edges` + `scy_learner_node_states` ; l'`AutonomyProof` = sortie de SKILL-CERTIFIER (Ag-09) :

```ts
// Le tronc + branches de maîtrise, contextualisés au corpus client
interface MasteryNode {
  id: string
  role: "SOC_L1" | "SOC_L2" | string   // via RoleTaxonomyProvider
  concept: string
  trunkPriority: number                 // SemanticTreePriorityPolicy
  sources: SourceRef[]                  // grounding obligatoire
  parents: string[]                     // graphe, pas arbre strict
}

// Une situation de décision générée depuis le corpus
interface DecisionScenario {
  id: string
  nodeIds: string[]
  prompt: string
  expectedJudgment: RubricRef           // ProofRubricProvider
  frictionLevel: number                 // CognitiveFrictionPolicy
  requiresOutputType: "recall" | "teachback" | "application" | "decision"
}

// Trace mesurée d'un passage de la boucle
interface AutonomyTrace {
  userId: string
  scenarioId: string
  outputProduced: boolean               // OutputPressurePolicy
  judgmentScore: number
  competenceIllusionFlag: boolean       // écart confiance ↔ performance
  consolidationDue: Date                // ConsolidationWindowPolicy
}

// Preuve défendable par rôle (l'output vendable)
interface AutonomyProof {
  userId: string
  role: string
  coverage: number                      // couverture pondérée [0..1] : Σ score(N) / Σ score_max(N) — R1 trunkPriority × R2 skill_era × R3 fidelityCoeff (D9, ARENA §12)
  judgmentReliability: number
  evidence: AutonomyTrace[]
  issuedAt: Date
}
```

---

## 6. Métriques de preuve (la « page de chiffres »)

Cibles à instrumenter dès le MVP / pilote A/B :
- **Time-to-autonomy** : jours avant premier seuil d'autonomie (vs baseline 4–9 mois marché).
- **Time-to-first-correct-escalation**.
- **Taux de rétention** des procédures critiques à J+7 / J+30 (répétition espacée).
- **Réduction des interruptions seniors** (charge de mentoring).
- **Écart illusion de compétence** : confiance déclarée − performance réelle (doit décroître).
- **Conformité aux playbooks** dans les décisions simulées.

Protocole : cohorte A (onboarding actuel) vs cohorte B (SCYForge) sur corpus réel du design partner.

---

## 7. Risques (à surveiller)

| Risque | Source | Mitigation |
|---|---|---|
| Perçu comme un LMS / chatbot | corpus §13 | démo centrée preuve d'autonomie, pas contenu |
| Friction mal dosée → abandon | policies §1.3 | frictionLevel adaptatif par niveau/risque |
| Ingestion documentaire réelle sous-estimée | corpus §13 | commencer sur un sous-corpus étroit (1 rôle) |
| Concurrents upskilling descendent vers le poste | veille §2.3 | verrouiller le « corpus privé → preuve » + moat historique |
| Vente bloquée sur la sécurité | mémo fundraising | Trust Package gratuit + déploiement isolé/VPC comme argument |

---

## 8. Prochaines actions (backlog vivant)

- [x] ~~Confirmer la feature d'ancrage~~ → **c'est ASCENT** (13 agents), §4 recadré en v0.2.
- [ ] **TOI** : valider le mapping des 13 agents §4.2 (Ag-06/07/08/10 sont déduits — confirme les numéros exacts DRIFT-GUARDIAN / ADAPTIVE-ROUTER / BRAIN / CHRONICLE).
- [ ] Confirmer **SOC L1** comme rôle unique de départ MVP + périmètre du sous-arbre (6 tactiques ATT&CK core ?).
- [ ] Choisir le sous-ensemble d'agents **P0** réellement dans le MVP 28 jours (GOAL, CONTENT, DAG, CONDUCTOR, PERF, CERTIFIER, ARENA).
- [ ] Définir les seuils chiffrés des 5 policies (ratios output/input, fenêtres consolidation, niveaux de friction).
- [ ] Rédiger le protocole A/B design-partner (baseline 4–9 mois + instrumentation §6).
- [ ] Réconcilier `MasteryNode`/`AutonomyProof` §5 avec les tables `scy_*` du PIVOT_ARCHITECTURE §6.

---

## 10. Les 13 agents couvrent-ils TOUT le chemin vers l'autonomie ?

> Question : ASCENT couvre-t-il l'objectif d'autonomie de bout en bout, ou y a-t-il des trous ? **Réponse courte : le noyau couvre parfaitement la *production cognitive* de la maîtrise, mais l'autonomie *opérationnelle réelle* a 3 zones sous-couvertes.** Ce ne sont pas des défauts d'ASCENT — ce sont des extensions à décider consciemment.

### 10.1 Ce qui est couvert (fort)
Les 11 primitives + 13 agents ferment la boucle cognitive : objectif → graphe → ingestion → diagnostic réel → intervention → expérience active → mesure jugement → détection dérive/illusion → preuve → reboucle. C'est complet et défendable.

### 10.2 Les 3 zones sous-couvertes (mes propositions)

| # | Zone aveugle | Pourquoi ça bloque l'autonomie *réelle* | Proposition |
|---|---|---|---|
| G1 | **Pont simulation → réel** | ASCENT prouve le jugement *en scénario*. L'autonomie = tenir sur de vrais tickets, dans le vrai SIEM/EDR/SOAR. Le transfert n'est pas garanti. | **`SupervisedLiveBridge`** : phase OJT encadrée (shadow → live gardé → autonome), branchée sur `DecisionScenarioProvider` mais alimentée par des alertes réelles anonymisées du tenant. |
| G2 | **Enveloppe d'autonomie explicite** | L'autonomie n'est pas binaire : « autonome sur phishing/EDR L1, escalade le reste ». Aujourd'hui c'est implicite dans SKILL-CERTIFIER. | Faire de l'**Autonomy Envelope** un objet de 1re classe (§5) : périmètre autorisé par rôle × classe d'alerte × niveau de risque. La preuve certifie *un périmètre*, pas « autonome » en absolu. |
| G3 | **Boucle de résultat réel (outcome loop)** | On mesure le jugement simulé, mais : la décision réelle de la recrue était-elle bonne (vrai/faux positif en prod) ? Sans ce retour, la preuve dérive de la réalité. | **`OutcomeFeedbackPolicy`** (6ᵉ policy candidate) : réinjecte le verdict terrain (postmortem, QA senior, résultat de l'escalade) via CHRONICLE pour recalibrer les barèmes. |

### 10.3 Zones tacites (à surveiller, pas forcément à coder tout de suite)
- **Savoir social** : à qui parler, ton d'une escalade, normes d'équipe (partiellement hors corpus explicite).
- **Muscle memory outillage** : maîtrise gestuelle des consoles réelles (simulable plus tard).

→ **Recommandation** : garder les 13 agents comme noyau, traiter **G1/G2/G3 comme la vraie frontière d'innovation** vers l'autonomie *opérationnelle*. G2 (Autonomy Envelope) est le plus urgent car il rend la preuve vendable et honnête.

---

## 11. Le « Loop Engineering » est-il utile ici ? — Oui, c'est même le bon cadre

Le Loop Engineering (concevoir explicitement des boucles de feedback imbriquées, avec critères d'entrée/sortie mesurables) est **doublement pertinent** pour SCYForge :

1. **La pédagogie EST une boucle** (primitive 11 : « boucler jusqu'à l'autonomie »).
2. **Le métier cyber EST une boucle** : le SOC vit en **OODA** (Observe → Orient → Decide → Act) et en cycle NIST (Detect → Respond → Recover). Apprendre la cyber = apprendre à exécuter une boucle sous pression.

Cet alignement rare (la forme de la pédagogie = la forme du métier) est un **atout de design** à exploiter. Le Loop Engineering structure l'autonomie en **4 boucles imbriquées** avec des critères déterministes :

| Boucle | Portée | Cycle | Critère de sortie (déterministe) |
|---|---|---|---|
| **Micro** | une interaction | output forcé → feedback | ratio output/input ≥ seuil (`OutputPressurePolicy`) |
| **Méso** | une compétence | Plant → Graft → Test → Myelinate | SMI du nœud ≥ 0.70 |
| **Macro** | un rôle | parcours sur le sous-arbre du rôle | `coverage(pack) ≥ 0.80` (pondéré D9 : R1 criticité × R2 skill_era × R3 fidélité L1..L4) + enveloppe validée |
| **Outcome** | le réel | décision réelle → verdict terrain → recalibrage | écart preuve↔réalité sous tolérance (G3) |

→ **Conclusion** : n'appelle pas ça une « feature » à part, mais adopte le Loop Engineering comme **grammaire de conception** transverse. Il donne exactement les « critères solides et déterministes » que tu cherches pour l'arborisation (§12).

---

## 12. Pilier 1 — Modélisation du Cyber Domain Pack (orienté autonomisation)

> Objectif de cette section : consolider la cyber en profondeur et **modéliser le Cyber Pack** de sorte que l'arborisation et la naissance des seeds soient **déterministes et impactantes**. Rappel du contrat (`DOMAIN_PACK_CONTRACT`) : tout le cyber vit ici, derrière les 7 ports ; le cœur n'en sait rien.

### 12.1 La logique métier de la cybersécurité (le modèle mental à injecter)
La cyber défensive s'organise autour du **NIST CSF 2.0** : **Govern → Identify → Protect → Detect → Respond → Recover**. Le SOC (cœur de ta niche d'entrée) occupe surtout **Detect + Respond**. Chaîne de valeur opérationnelle : *signal → alerte → triage → investigation → décision (faux positif / escalade / réponse) → confinement → postmortem → amélioration de détection*. C'est une **boucle** (cf. §11), ce qui valide l'alignement pédagogie/métier.

### 12.2 Règles globales à connaître (les invariants du domaine)
- **Frameworks pivots** : MITRE ATT&CK (pivot d'ontologie — 14 tactiques, techniques/sous-techniques), NIST CSF 2.0, ISO 27001, Sigma (détection agnostique).
- **Régulation (surtout marché EU)** : NIS2, DORA (finance), RGPD — imposent détection/réponse/notification → **budget de conformité = moteur d'achat**.
- **Principes non négociables** : moindre privilège, chaîne de conservation des preuves (chain of custody), séparation détection/réponse, ne jamais casser une investigation en cours, escalade selon severité, pas de conseil offensif hors scope (→ `ValidationGuard`).

### 12.3 Les rôles — dans ET hors des entreprises « cyber »
C'est un point clé pour ton `RoleTaxonomyProvider` : **qui emploie des agents cyber ?**

**A. Prestataires cyber (l'agent EST le produit)**
- **MSSP** (monitoring opérationnel, large) et **MDR** (détection/réponse profonde). Ils forment des L1 en volume → **douleur d'onboarding maximale, ROI SCYForge le plus direct.**

**B. Entreprises non-cyber avec SOC interne (l'agent est un centre de coût / mitigation de risque)**
- Finance, santé, industrie, retail. SOC interne = **8–12 analystes min. pour du 24/7** ; souvent modèle **hybride** (L1 externalisé MDR, L2/L3 investigation gardés en interne pour la résidence des données réglementées).

**Rôles à modéliser (ATT&CK-ancrés)** : SOC L1 (triage), SOC L2 (investigation), SOC L3 / Threat Hunter, DFIR, Detection Engineer, CTI analyst, SOC manager. **Cible d'entrée = SOC L1** (volume de recrues + douleur mesurée 4–9 mois).

#### 12.3.1 Décision validée — les DEUX cibles (MSSP/MDR **et** SOC interne régulé)
> ✅ **Validé (v0.4)** : SCYForge adresse les deux segments. Ils partagent **le même rôle-noyau (SOC L1) et le même sous-arbre ATT&CK** — donc la modélisation du pack ne double PAS. Ce qui change, c'est le *moteur d'achat*, le *corpus d'ancrage* et l'*Autonomy Envelope* (§10 G2). Un seul Cyber Pack, deux « profils de déploiement ».

| Axe | Profil MSSP/MDR | Profil SOC interne régulé |
|---|---|---|
| Moteur d'achat | Marge / capacité à former des L1 en volume | Conformité (NIS2/DORA) + rétention/risque |
| Rôle-noyau | SOC L1 (identique) | SOC L1 (identique) |
| Corpus d'ancrage | playbooks standardisés multi-clients | SOP internes + contraintes sectorielles (finance/santé) |
| Autonomy Envelope | large, orienté débit de tickets | plus stricte, orientée séparation des données / audit |
| ProofRubric | vitesse + volume + exactitude | traçabilité + conformité + exactitude |
| Séquencement | **Segment amorce** (douleur onboarding maximale, cycle de vente court) | **Segment d'expansion** (ticket plus gros, cycle plus long, réutilise le même pack) |

→ **Implication modélisation** : garder le noyau du pack strictement commun ; externaliser les différences dans **deux jeux de valeurs de providers** (`ProofRubric`, `ValidationGuard`, `Corpus`, `RoleTaxonomy` bornée par l'Envelope) — jamais dans deux arbres distincts. C'est un test direct de la règle « retirer le pack ne casse pas le noyau » appliquée à l'intérieur même du pack.

### 12.4 Le remplissage des 7 ports pour le Cyber Pack

| Port | Instance Cyber (contenu déterministe) | Source rare / corpus |
|---|---|---|
| **Ontology** | MITRE ATT&CK (pivot `mitre_attack`) : tactiques → techniques → sous-techniques | STIX ATT&CK officiel |
| **Corpus** | SOP/playbooks du tenant + Sigma HQ + MITRE Emulation + CISA IR + ThreatHunter-Playbook | privé (tenant) + public raffiné |
| **RoleTaxonomy** | SOC L1/L2/L3, Threat Hunter, DFIR, Detection Eng., CTI → sous-graphes requis | NICE/SFIA + réalité terrain |
| **DecisionScenario** | « Alerte EDR 3h du matin → triage », phishing, escalade, faux positif | MITRE Emulation (ex. APT29) |
| **ProofRubric** | triage correct + escalade justifiée + taux faux positifs + respect playbook | barèmes SOC |
| **RetentionPolicy** | TTPs critiques jamais oubliés (pondération FSRS par criticité) | fréquence d'incident × impact |
| **ValidationGuard** | pas de conseil offensif hors scope ; faits ATT&CK non négociables | garde-fous domaine |

### 12.5 Arborisation : du tronc aux feuilles (déterministe)
```
SEED (rôle + objectif + pivot + ancrage corpus)
season │
       ▼
TRONC   = le 80/20 vital du SOC L1 (jamais faux) — protégé par SemanticTreePriorityPolicy
  ├─ BRANCHES = tactiques ATT&CK pertinentes au rôle (Initial Access, Execution, C2, Exfiltration…)
  │    ├─ SOUS-BRANCHES = techniques (T1566 Phishing, T1059 Scripting…)
  │    │    └─ FEUILLES = détection (Sigma) + décision de triage + action de réponse
```
**Règle d'arborisation** : une branche/feuille n'existe QUE si elle porte une **décision réelle** que la recrue doit savoir prendre. Sinon c'est de la trivia, pas de l'autonomie.

### 12.6 Critères d'un seed valide (déterministe ET impactant)
C'est le cœur de ta demande. Un seed n'est accepté (« naissance ») que s'il satisfait **les 7 critères** — sinon il est rejeté par un `SeedValidator` (parallèle au BETH Trunk Validator) :

| # | Critère | Rend le résultat… | Test de rejet |
|---|---|---|---|
| C1 | **Grounded** : chaque nœud trace vers ≥ 1 source | déterministe | un nœud sans `sources[]` → rejet |
| C2 | **Pivot-anchored** : chaque nœud porte un `domain_ref` ATT&CK | reproductible / joignable | un nœud sans `{ontology:"mitre_attack", id}` → rejet |
| C3 | **Criticality-weighted** : `trunkPriority` calculé (densité Sigma × fréquence incident × impact métier) | impactant | priorité non calculable → rejet |
| C4 | **Decision-bearing** : chaque feuille mappe ≥ 1 décision réelle | orienté autonomie | feuille sans décision → dégradée en annexe |
| C5 | **Provable** : chaque nœud gate a une rubrique mesurable | certifiable | pas de `ProofCriterion` → ne peut pas gater l'autonomie |
| C6 | **Bounded** : le seed fixe rôle × classe d'alerte (pas « toute la cyber ») | livrable / testable | scope non borné → rejet |
| C7 | **Reproducible** : même seed + même corpus → même arbre (versionné) | déterministe | génération non déterministe → rejet |

→ Ces 7 critères sont la **définition de « solide »** que tu cherchais : ils transforment la génération d'arbre d'un acte créatif flou en un **pipeline validable et rejouable**.

### 12.8 Les DEUX jeux de valeurs de providers (recherche v0.5, ancrée veille)

> **But** : livrer la spec concrète des 2 profils de déploiement (§12.3.1). Règle d'or maintenue : **un seul arbre de maîtrise (tronc SOC L1 + sous-arbre ATT&CK identique)**. Ce qui varie = **des VALEURS injectées dans 4 providers**, jamais la structure. On peut retirer le profil régulé sans casser le pack : c'est le test « pack dans le pack ».
>
> Chaque profil est un objet de configuration versionné (`profile_ref`) résolu au moment du `seed`. Les chiffres ci-dessous sont des **défauts sourcés** (veille 2025-2026), à faire valider par un SOC manager design partner (chantier R5).

#### 12.8.1 `ProofRubricProvider` — barèmes de jugement (ce qui compte comme « bien fait »)

Le rôle-noyau (triage correct + escalade justifiée + respect playbook) est **commun**. Les **poids** et les **seuils de gate d'autonomie** diffèrent.

| Dimension de preuve | Profil **MSSP/MDR** (débit) | Profil **SOC interne régulé** (traçabilité) | Source veille |
|---|---|---|---|
| Exactitude du verdict (FP/TP/escalade) | poids **élevé** — gate ≥ 90 % sur classe d'alerte | poids **élevé** — gate ≥ 95 % (le coût d'une erreur = notification réglementaire fausse) | DORA : éviter fausse notif [rigueur forensique] |
| Vitesse (time-to-triage) | poids **fort** — cible **< 5 min** MTTT, capacité **20–35 alertes/quart 8 h** | poids **modéré** — cible **time-to-classify < 2 h** (fenêtre réglementaire, pas la course au débit) | MTTT < 5 min / cap. 20–35 par quart ; DORA time-to-classify < 2 h |
| Volume soutenable | poids **fort** — < 50 alertes actionnables/jour/analyste | non-gaté (le régulé optimise la qualité de dossier, pas le volume) | cible cloud-native < 50/j |
| Qualité de la justification / dossier | poids **modéré** (motif d'escalade présent) | poids **très élevé** — arbre de preuve « pourquoi ce verdict » + chaîne de conservation intacte | GDPR art.22 + evidence trees + human-oversight logs |
| Complétude d'audit (log signé/horodaté) | optionnel | **obligatoire, gate bloquant** — pas de log signé ⇒ pas de certification | logs digitally signed & timestamped |

**Implication** : même `ProofRubric`, deux vecteurs de poids `w_accuracy / w_speed / w_volume / w_justification / w_audit`. Le régulé **remonte** `w_justification` et `w_audit` et **rend `w_audit` bloquant** ; le MSSP **remonte** `w_speed` et `w_volume`.

#### 12.8.2 `ValidationGuardProvider` — garde-fous non négociables

Base commune (faits ATT&CK non négociables, pas de conseil offensif hors scope, ne jamais casser une investigation en cours). Le régulé **ajoute des interdits**, il n'en retire aucun.

| Garde-fou | MSSP/MDR | SOC interne régulé |
|---|---|---|
| Faits ATT&CK non négociables | ✅ | ✅ |
| Pas de conseil offensif hors scope | ✅ | ✅ |
| **Séparation détection / réponse** | recommandée | **stricte, imposée** (séparation des rôles auditée) |
| **Résidence / traitement des données** | tolérance multi-tenant | **où la donnée est traitée ET accédée** (pas seulement stockée) — refus si le contexte sort du périmètre autorisé | 
| **Traçabilité de l'action IA** | log léger | **chemin d'oversight humain + log du raisonnement autonome obligatoire** |
| **Rétention / droit à l'oubli** | politique standard | **conservation 5–7 ans + crypto-shredding** (destruction de clé, audit trail immuable préservé) |

*Sources : data residency = processing+access ; human-oversight paths + logs of autonomous reasoning ; conservation 5–7 ans + crypto-shredding.*

#### 12.8.3 `CorpusProvider` — matière première d'ancrage

Même socle public raffiné ; le **mix privé/sectoriel** change.

| Couche corpus | MSSP/MDR | SOC interne régulé |
|---|---|---|
| Public agnostique | **SigmaHQ (> 3 000 règles, 3 catégories : generic / threat-hunting / emerging)**, MITRE Emulation, CISA IR playbooks, Threat Hunter Playbook | idem |
| Playbooks | **standardisés multi-clients** (réutilisables, orientés couverture large) | **SOP internes + contraintes sectorielles** (finance/santé), non partageables |
| Contexte réglementaire injecté | minimal | **NIS2 / DORA / GDPR** comme faits d'ancrage (délais de notif, obligations de preuve) |
| Validation du corpus | pySigma / Sigma CLI pour normaliser vers le SIEM cible | idem + revue conformité avant greffe (Ag-10 CHRONICLE) |

*Sources : SigmaHQ 3 000+ règles & catégories, pySigma/Sigma CLI, Threat Hunter Playbook.*

#### 12.8.4 `RoleTaxonomy` bornée par l'**Autonomy Envelope** (ébauche G2)

Le rôle est **SOC L1 dans les deux cas**. Ce qui change = le **périmètre d'action autonome autorisé** (l'enveloppe), exprimé par `classe d'alerte × niveau de risque → mode`.

| Classe d'alerte / risque | MSSP/MDR (large, orienté débit) | SOC interne régulé (strict, orienté audit) |
|---|---|---|
| FP évident / bruit connu | **auto-close autonome** | auto-close autonome **avec log signé** |
| TP faible sévérité, playbook clair | **remédiation autonome** | remédiation **assistée** (validation humaine tracée) |
| TP moyenne sévérité | escalade autonome | escalade **obligatoire + oversight humain loggé** |
| Haute sévérité / incident majeur | escalade + notification interne | **escalade + horloge réglementaire** (DORA 4 h / NIS2 24 h) déclenchée |
| Donnée réglementée / hors résidence | triage autorisé | **refus/handoff** (ValidationGuard bloque) |

> **Note** : l'enveloppe régulée est un **sur-ensemble de contraintes**, pas un arbre différent. La spec formelle (structure de données `AutonomyEnvelope`, transitions shadow→gardé→autonome) reste le **chantier R3**. Ici on a fixé les **bornes métier** qui l'alimenteront.

#### 12.8.5 Ce que ça implique pour l'implémentation (pour ton agent de travail)

- **Aucune duplication d'arbre** : `OntologyProvider`, `DAG-ARCHITECT`, tronc SOC L1 restent mono-instance.
- **4 providers deviennent `profile-aware`** : ils prennent un `profile_ref ∈ {mssp_mdr, regulated_internal}` et renvoient des valeurs différentes. Contrat inchangé, valeurs injectées.
- **Le gate d'autonomie (Ag-09 SKILL-CERTIFIER)** lit le vecteur de poids `ProofRubric` **du profil** + l'`AutonomyEnvelope` du profil. Un même niveau de perf peut certifier chez MSSP et rester « assisté » en régulé — c'est voulu et honnête.

### 12.7 Actions Pilier 1 (recherche/consolidation restante)
- [ ] Formaliser le **tronc SOC L1** : lister les 15–25 nœuds « jamais faux » (candidat livrable `SCYFORGE_CYBER_ONTOLOGY.md`).
- [ ] Cartographier les **tactiques ATT&CK** réellement pertinentes pour L1 (probablement 6–8 sur 14).
- [ ] Écrire le **SeedValidator** (C1–C7) comme contrat, en miroir du BETH Trunk Validator.
- [x] ~~Décider cible d'entrée~~ → **les deux validées** (MSSP/MDR = amorce, SOC interne régulé = expansion), un seul pack à 2 profils de déploiement (§12.3.1).
- [x] ~~Définir les **2 jeux de valeurs de providers**~~ → **fait en §12.8** (ProofRubric / ValidationGuard / Corpus / RoleTaxonomy bornée par l'Envelope), sans dupliquer l'arbre.
- [ ] Spécifier l'**Autonomy Envelope** (§10 G2) pour chaque profil : périmètre autorisé par classe d'alerte × risque. → *ébauche des bornes en §12.8.4, spec complète = chantier R3.*

---

## 13. Autonomy Envelope — spec formelle (chantier recherche R3, gap G2)

> **But** : faire de l'Autonomy Envelope un **objet de 1re classe** (résout G2 §10.2). La preuve d'autonomie ne dit jamais « autonome » en absolu — elle certifie **un périmètre borné** : *ce rôle est autonome sur telles classes d'alerte à tel niveau de risque, et escalade/handoff le reste*. Les **bornes métier** ont été posées en §12.8.4 ; ici on donne la **structure de données + les transitions + les gates**.

### 13.1 Le modèle mental : une grille, pas un booléen
L'enveloppe est une **matrice `classe d'alerte × niveau de risque`**, chaque cellule portant un **mode d'autonomie** courant. La progression se fait **cellule par cellule** : une recrue peut être `autonomous` sur *phishing/faible* tout en restant `shadow` sur *ransomware/critique*. C'est ça, « l'autonomie bornée et honnête ».

### 13.2 Les 4 modes (échelle d'autonomie par cellule)
| Mode | Sens | Qui décide | Trace requise |
|---|---|---|---|
| `shadow` | la recrue observe / propose, un senior exécute | senior | proposition loggée |
| `guarded` | la recrue agit, validation humaine **avant** effet | recrue + validateur | validation tracée |
| `autonomous` | la recrue agit seule dans cette cellule | recrue | note de triage rejouable |
| `handoff` | interdit à ce rôle — escalade/transfert obligatoire | escalade | motif de handoff |

> Le mode `handoff` n'est **pas** un échec : c'est une **borne de conception** (ex. donnée réglementée hors résidence en profil régulé → `handoff` permanent, cf. §12.8.4).

### 13.3 Structure de données
```ts
type AutonomyMode = "shadow" | "guarded" | "autonomous" | "handoff"

// Une cellule = l'unité d'autonomie certifiable
interface EnvelopeCell {
  alertClass: string        // ex. "phishing", "edr_malware", "brute_force", "c2_beaconing"
  riskLevel: "low" | "medium" | "high" | "critical"
  mode: AutonomyMode
  ceilingMode: AutonomyMode // plafond autorisé par le profil (borne dure, cf. §12.8.4)
  gate: RubricRef           // seuils à franchir pour monter d'un cran (ProofRubric du profil)
  evidence: string[]        // AutonomyTrace ids ayant justifié le mode courant
}

// L'enveloppe = projection rôle × profil, bornée par le déploiement
interface AutonomyEnvelope {
  userId: string
  role: string                    // via RoleTaxonomyProvider
  profileRef: "mssp_mdr" | "regulated_internal"  // §12.8 : le profil borne les plafonds
  cells: EnvelopeCell[]
  computedAt: Date
}
```
> `AutonomyProof` (§5) devient **une projection de l'enveloppe** : `coverage` = couverture pondérée `Σ score(N) / Σ score_max(N)` (D9 — R1 criticité, R2 skill_era, R3 fidélité atteinte), calculée sur les cellules du tronc en `autonomous` ou `guarded`. La preuve **liste explicitement les cellules** (« autonome phishing≤high, edr_malware≤medium ; guarded le reste »). Un même niveau de performance peut dépasser le seuil `≥ 0.80` chez MSSP/MDR et rester sous seuil en profil régulé si les nœuds à fort `w_audit` sont encore en `shadow` — c'est voulu et honnête.

### 13.4 Les transitions (comment une cellule progresse)
La montée est **monotone et gatée**, la descente est **automatique sur dérive** :
```
shadow ──[gate franchi + N passages]──▶ guarded ──[gate + 0 erreur critique]──▶ autonomous
   ▲                                                                                  │
   └──────────────── DRIFT-GUARDIAN (Ag-07) : dérive / illusion de compétence ────────┘
                     OutcomeFeedbackPolicy (G3) : verdict terrain négatif → rétrograde
```
- **Montée** : gérée par `SKILL-CERTIFIER (Ag-09)`, qui lit le **vecteur de poids `ProofRubric` du profil** (§12.8.1) + les traces. Jamais au-dessus de `ceilingMode`.
- **Descente** : `DRIFT-GUARDIAN (Ag-07)` rétrograde une cellule si demi-vie dépassée / illusion de compétence ; la future `OutcomeFeedbackPolicy` (G3) rétrograde sur verdict terrain réel négatif.
- **Borne profil** : en régulé, `ceilingMode` de « TP moyenne sévérité » = `guarded` (oversight humain loggé obligatoire) même si la perf justifierait `autonomous` — voulu et honnête (§12.8.4).

### 13.5 Ce que ça débloque
- **Vente honnête** : on ne survend pas « analyste autonome », on livre une **carte d'autonomie** vérifiable et signée.
- **Pont vers G1** (`SupervisedLiveBridge`) : `shadow → guarded → autonomous` est **exactement** le rail de l'OJT encadré sur alertes réelles.
- **Alignement médiateur (§4.6)** : les classes d'alerte et les plafonds proviennent du **corpus/politique de l'entreprise**, pas d'un défaut générique — le pack ne fait qu'outiller la grille.

### 13.6 Reste à durcir (R3 → design partner)
- [ ] Valider la liste des `alertClass` du tronc SOC L1 avec le corpus entreprise (projection §4.6).
- [ ] Fixer `N passages` et la fenêtre anti-illusion par mode (lié aux seuils des 5 policies).
- [ ] Décider si `OutcomeFeedbackPolicy` (G3) entre au MVP ou reste post-MVP pour la descente automatique.

---

## 14. COSMOS — le 20 % de visualisations qui produit 80 % de la compréhension (chantier recherche)

> **Ce qu'est COSMOS** (rappel §4.3) : le **module de visualisation du noyau**, couplé à ASCENT (comme APEX/FSRS l'est pour la rétention). Ce n'est pas un agent ASCENT au sens strict — c'est la **couche de représentation** qui rend visibles la maîtrise, l'attaque et la décision.
> **Objectif de ce chantier** : sélectionner le **petit nombre de visualisations à très fort levier** pour 4 effets cognitifs — **compréhension, analogie, ancrage, rétention** — pour notre cas d'usage (recrue SOC L1).

### 14.1 Ancrage recherche (ce que dit la science + le terrain 2026)
- **Réalité SOC 2026** : bascule vers des opérations *AI-centric*, volume d'alertes ingérable, l'analyste passe de l'investigation manuelle à **l'oversight et la décision** ; +500 % de workflows orchestrés (SOAR). *Frein n°1 = manque de confiance/visibilité, pas la technique.* → **COSMOS doit rendre visible la décision et la confiance, pas empiler des métriques.**
- **Théorie du double codage / charge cognitive** (Mayer, Paivio) : la mémoire traite le **verbal et le visuel** sur deux canaux distincts à capacité limitée. Présenter texte + image *correspondants et simultanés*, éliminer le décoratif → **meilleure rétention et transfert**. → chaque visuel COSMOS doit **coupler un mot-clé et une forme**, jamais décorer.
- **Visualisation cyber = modèle mental séquentiel** : décomposer une intrusion en **entités (nœuds)** et **actions (arêtes)** transforme des alertes isolées en **kill chain lisible** ; donne un **vocabulaire partagé** pour prioriser.
- **Loi de Pareto appliquée à ATT&CK** : ~**20 % des techniques couvrent ~89 % des attaques réelles**. → la sélection Pareto n'est pas qu'un principe de design, c'est **déjà la structure du domaine**.

### 14.2 La règle de sélection (comment on tranche le 20 %)
Un visuel entre dans le noyau COSMOS **seulement s'il sert ≥ 3 des 4 effets** :
| Effet | Question de test |
|---|---|
| **Compréhension** | rend-il un concept abstrait *immédiatement* lisible ? |
| **Analogie** | active-t-il un modèle mental familier (carte, arbre, chronologie, jauge) ? |
| **Ancrage** | relie-t-il le nouveau savoir à une structure stable et répétée ? |
| **Rétention** | est-il *ré-exposé* dans le temps (couplable à APEX/FSRS) ? |

### 14.3 Le noyau : 6 visualisations (le 20 % à polir en priorité)

| # | Visualisation | Ce qu'elle montre | Analogie / modèle mental | Effets servis |
|---|---|---|---|---|
| **V1** | **Arbre de maîtrise (Mastery Tree)** | tronc SOC L1 → branches ATT&CK → feuilles décisionnelles, coloré par niveau de maîtrise | *arbre de compétences* (RPG) / carte de métro | Compréhension · Ancrage · Rétention |
| **V2** | **Kill chain / graphe d'attaque** | entités (nœuds) + actions (arêtes) d'un incident, déroulé par phase | *fil d'enquête* sur tableau de liège | Compréhension · Analogie |
| **V3** | **Timeline de corrélation** | alertes ordonnées chronologiquement, regroupement des événements liés | *frise chronologique* / relevé bancaire | Compréhension · Analogie |
| **V4** | **Heatmap ATT&CK (tactiques × techniques)** | couverture / activité, avec le 20 %/89 % mis en avant, code couleur multi-phase | *carte de chaleur météo* | Ancrage · Compréhension |
| **V5** | **Carte d'autonomie (Envelope grid)** | matrice `classe d'alerte × risque → mode` (shadow/guarded/autonomous/handoff), cf. §13 | *tableau de bord de permis* (ce que j'ai le droit de conduire) | Ancrage · Rétention |
| **V6** | **Jauge de décision & confiance** | verdict rendu + niveau de confiance + preuve associée (rejouable) | *cadran / feu tricolore* | Compréhension · Rétention |

> **Pourquoi ces 6 et pas d'autres** : V1 et V5 sont les **structures stables ré-exposées** (ancrage/rétention, couplage APEX/FSRS) ; V2/V3 sont les **récits d'incident** (compréhension via séquence) ; V4 branche la priorité sur le fait Pareto du domaine ; V6 répond directement au **frein 2026 (confiance/visibilité de la décision)**. Tout le reste (camemberts de volume, compteurs BAU, gauges cosmétiques) est **hors noyau** : haute fréquence, faible transfert.

### 14.4 Principes de polissage (comment améliorer les 6)
- **Double codage systématique** : chaque nœud/phase porte *un libellé court + une forme/couleur* cohérents d'un visuel à l'autre (même palette de sévérité partout).
- **Une intention par vue** : ne jamais mélanger « comprendre l'incident » (V2/V3) et « où j'en suis » (V1/V5). Séparer BAU vs menace multi-phase (principe SOC 2026).
- **Ré-exposition programmée** : V1, V4, V5 sont ré-affichés aux intervalles FSRS pour transformer la vue en **trace mémoire** (pas juste un dashboard).
- **Progression, pas score brut** : COSMOS montre le **delta de maîtrise** (avant/après), plus mémorable qu'une note absolue (effet de génération).
- **Zéro décor** : bannir dégradés/formes décoratives — chaque pixel doit porter du sens (charge cognitive extrinsèque minimale).
- **Cohérence médiateur (§4.6)** : les libellés (classes d'alerte, phases, outils) viennent du **corpus entreprise**, pas de valeurs génériques — COSMOS *affiche la vérité du tenant*, il ne l'invente pas.

### 14.5 Reste à durcir (design partner)
- [ ] Valider les 6 avec 2-3 recrues + 1 mentor (test de compréhension à froid : « lis cette vue en 10 s »).
- [ ] Décider le couplage exact **V1/V4/V5 ↔ APEX/FSRS** (quels intervalles de ré-exposition).
- [ ] Prototyper V2 (graphe d'attaque) avec une lib éprouvée (pas de SVG à la main) et brancher `SCN-*` (§10 ontologie) comme jeux de données déterministes.
- [ ] Définir la palette de sévérité unique partagée par les 6 (contrainte de cohérence double-codage).

---

## 15. COSMOS v5 — Bibliothèque de visualisations + grammaire « intention → viz » (chantier recherche R6)

> **Recadrage majeur (ta décision, v0.8).** On **abandonne** le modèle « plugin COSMOS à N modes figés » (26 modes / 4 en MVP) **comme cadre final**. Raison : on ne peut pas énumérer à l'avance *toutes* les visualisations qu'un apprenant voudra pour comprendre un concept. À la place :
>
> **COSMOS devient un moteur de rendu générique + une bibliothèque de visualisations indexée + un sélecteur « intention explicative → viz ».** Quand l'apprenant veut comprendre quelque chose, l'agent **ne génère pas une image statique par IA** (plate, non fidèle aux données, non professionnelle) : il **choisit la visualisation mathématiquement correcte** dans la bibliothèque, la **rend réellement** avec la stack, en **capture un aperçu inline**, et fournit **un bouton « ouvrir la viz interactive »**.
>
> **Ce que ce recadrage ne casse pas** : les 26 modes (§ architecture v4.5) ne sont **pas jetés** — ils deviennent les **presets d'amorçage** de la bibliothèque, et les **6 viz noyau (§14)** restent les entrées prioritaires du domaine cyber. On ne recrée rien : on **indexe** ce que la stack sait déjà produire.

### 15.1 Pourquoi ce pivot est correct (et pas une contradiction)
- **La génération d'image IA est statique** : elle *dessine* un graphe, elle ne le *calcule* pas. Aucune fidélité aux données du tenant, aucune interaction, aucun zoom/drill-down, aucune ré-exposition FSRS. Pour une entreprise, c'est un poster, pas un outil.
- **La stack sait déjà tout rendre** : le vrai travail n'est pas de coder des viz, c'est (1) **cataloguer** ce que chaque moteur produit avec ses contraintes, et (2) **écrire la couche de sélection** « intention + forme des données → viz ». C'est ça l'IP réelle, pas les 26 modes.
- **Cohérence médiateur (§4.6)** : la viz affiche **la vérité du tenant** (données réelles projetées), jamais un visuel générique inventé.

### 15.2 Catalogue exhaustif de la stack (veille 2026, sourcé — zéro invention)

> Règle : une entrée de bibliothèque = **un type de viz réalisable par un moteur réel de la stack**, avec ses bornes. Les capacités ci-dessous sont vérifiées sur les docs/dépôts officiels de chaque moteur.

| Moteur | Rôle (borne dure) | Ce qu'il produit réellement (catalogue vérifié) | Capacité |
|---|---|---|---|
| **cosmos.gl / Cosmograph** | node-link GPU massif | force-directed multi-millions de nœuds, clustering GPU, cross-filtering, timeline, layout temps réel (données en `Float32Array`) | 1M+ nœuds |
| **@antv/g6 v5** | node-link (graphes relationnels) | **20+ layouts** : force, dagre (DAG), tree (compact-box, mindmap, dendrogram, indented), circular, radial, grid ; workers/WASM/GPU | < 50K nœuds |
| **@antv/g2 v5** | grammaire statistique + hiérarchie | **marks** : interval, rect, line, point, area, cell, box, boxplot, **heatmap**, density, **gauge**, liquid, link, polygon, range, **sankey**, **chord**, **tree**, **treemap**, **pack** ; transforms (binX/binY/stack) | 100K points |
| **nivo** | dataviz React déclaratif | **40+ composants** : Bar, Line, Area(Bump), BoxPlot, Bullet, Bump, Calendar, **Chord**, Choropleth, **CirclePacking**, Funnel, GeoMap, **HeatMap**, Icicle, Marimekko, **Network**, **ParallelCoordinates**, Pie, PolarBar, **Radar**, RadialBar, **Sankey**, ScatterPlot, Stream, **Sunburst**, SwarmPlot, TimeRange, **Tree**, **TreeMap**, **Voronoi**, Waffle (rendu SVG/HTML/Canvas) | < 50K points |
| **@xyflow/react v12 (React Flow)** | **DAG / flux structurés uniquement** | node-based UI : flowcharts, roadmaps, pipelines, argument maps ; nœuds = composants React custom, hooks `useNodeConnections`/`useNodesData` | < 1K nœuds |
| **d3 v7** | contrôle bas niveau (fallback) | `d3-hierarchy` (tree, cluster, **pack**, **treemap**, **partition**/icicle/sunburst), `d3-force` (force-directed), **chord**, **sankey**, **parallel coordinates**, **arc**, **edge bundling**, **voronoi** | ~5K nœuds |
| **recharts v2** | statistiques simples React | LineChart, BarChart, AreaChart, ComposedChart, **RadarChart**, RadialBarChart (courbes monotone/linear/step) | agrégats |
| **three.js / r3f-forcegraph** | node-link 3D immersif (R&D) | graphe force-directed 3D, mode DAG, géométries custom nœuds/liens, zoom/pan/drag/expand | ~10K nœuds |

> **Invariants de routage (repris de l'architecture v4.5, à ne jamais violer)** : React Flow = **DAGs seulement** (jamais un Knowledge Graph) ; G6 ≠ G2 (node-link vs statistique/hiérarchie, même écosystème AntV) ; Cosmograph = uniquement si GPU détecté, sinon fallback G6 Canvas ; d3 = dernier recours quand aucun renderer déclaratif ne couvre le type.

### 15.3 Le modèle de métadonnées d'une entrée (`VizSpec`)
Chaque viz de la bibliothèque est un objet indexable — c'est ce qui rend la sélection **déterministe** au lieu de créative :

```ts
type DataShape =
  | "network"          // nœuds + arêtes, non hiérarchique
  | "dag"              // graphe orienté acyclique (flux, roadmap)
  | "hierarchy"        // arbre / taxonomie (parent → enfants)
  | "matrix"           // relations n×n (corrélation, co-occurrence)
  | "flow"             // volumes transférés entre étapes
  | "timeseries"       // événements/valeurs ordonnés dans le temps
  | "multivariate"     // entités × N attributs comparables
  | "sequence"         // ordre linéaire d'éléments
  | "geospatial"       // coordonnées / régions

type ExplanatoryIntent =
  | "show_structure"       // « comment c'est organisé »
  | "show_relationships"   // « qu'est-ce qui est lié à quoi »
  | "show_flow"            // « comment ça circule / se transforme »
  | "show_sequence"        // « dans quel ordre ça s'est passé »
  | "compare"              // « qui est fort/faible où »
  | "show_distribution"    // « où se concentre la masse »
  | "show_hierarchy"       // « quoi contient quoi »
  | "show_causality"       // « qu'est-ce qui cause quoi (boucles) »
  | "show_state"           // « où j'en suis / verdict + confiance »

interface VizSpec {
  id: string                       // ex. "attack-graph", "mastery-tree"
  label: string                    // libellé lisible (langue tenant)
  engine: "cosmos" | "g6" | "g2" | "nivo" | "reactflow" | "d3" | "recharts" | "three"
  dataShapes: DataShape[]          // formes de données acceptées
  intents: ExplanatoryIntent[]     // intentions explicatives servies
  cognitiveEffects: ("comprehension" | "analogy" | "anchoring" | "retention")[]  // §14.2
  maxNodes: number                 // borne dure du moteur
  requiresGPU?: boolean            // cosmograph / three
  fallbackId?: string              // viz de repli si contrainte non remplie
  interactive: boolean             // supporte le bouton « ouvrir viz »
  corePriority?: 1 | 2 | 3         // 1 = une des 6 viz noyau §14
}
```

### 15.4 La grammaire « intention → viz » (le vrai cœur)
La sélection est une **fonction pure** `(intent, dataShape, constraints) → VizSpec`, pas un choix créatif. Priorité de résolution :

1. **Filtrer** la bibliothèque par `intent ∈ VizSpec.intents` **ET** `dataShape ∈ VizSpec.dataShapes`.
2. **Écarter** les viz dont `maxNodes < taille du jeu` ou `requiresGPU && !gpu`.
3. **Classer** les candidates : `corePriority` (les 6 viz noyau §14 gagnent) → puis nb d'`cognitiveEffects` servis (≥ 3, règle §14.2) → puis coût de bundle.
4. **Résoudre les fallbacks** : si la gagnante saute (GPU absent, trop de nœuds), suivre `fallbackId`.

**Table de correspondance de référence (intention × forme → viz gagnante, avec repli) :**

| Intention explicative | Forme de données | Viz gagnante (moteur) | Fallback | Viz noyau §14 |
|---|---|---|---|---|
| `show_relationships` | network | Knowledge/Attack Graph (**G6**) → Cosmograph si massif | G6 Canvas | **V2** |
| `show_flow` | dag | Roadmap / Pipeline (**React Flow**) | d3 sankey | — |
| `show_flow` | flow | Sankey / Alluvial (**nivo/G2**) | d3 sankey | — |
| `show_sequence` | timeseries | Correlation Timeline (**custom/recharts**) | nivo TimeRange | **V3** |
| `show_sequence` | sequence | Arc Diagram (**d3/G6**) | d3 arc | — |
| `show_hierarchy` | hierarchy | Sunburst / Treemap (**G2**) → nivo fallback | nivo sunburst | **V1** (tree) |
| `show_structure` | hierarchy | Mastery Tree (**G6 tree**) | nivo tree | **V1** |
| `compare` | multivariate | Radar (**recharts**) / Parallel Coord. (**d3**) | recharts radar | — |
| `show_distribution` | matrix | **Heatmap** ATT&CK (nivo/G2) | nivo heatmap | **V4** |
| `show_causality` | network+loops | Causal Loop Diagram (**G6**) | d3 force | — |
| `show_state` | multivariate | Decision & Confidence Gauge (**G2 gauge/recharts**) | recharts | **V6** |
| `show_state` | matrix | Autonomy Envelope grid (**custom/nivo heatmap**) | nivo heatmap | **V5** |
| `show_relationships` | network (3D, R&D) | 3D Knowledge Space (**three**) | G6 (2D) | — |

### 15.5 Le flow runtime (ce que voit l'apprenant)
```
Apprenant : « je veux comprendre comment l'attaque phishing a mené au ransomware »
   │
   ▼
[1] Agent classe l'intention → show_sequence + show_relationships ; dataShape = network+timeseries
[2] Sélecteur (§15.4) → gagnante = Attack Graph (V2, G6) + Timeline (V3) en vue liée
[3] COSMOS RÉEL rend la viz avec les données du tenant (pas d'image IA)
[4] Capture (screenshot serveur/canvas) affichée INLINE dans le fil de réponse
[5] Bouton « Ouvrir la visualisation interactive » → viz complète (zoom, drill, hover, replay)
```
- **Jamais** de `GenerateImage` pour un concept qui a une viz mathématique dans la bibliothèque. L'image IA est réservée aux illustrations non-données (métaphores, décor pédagogique explicitement demandé).
- **Ancrage FSRS** : la viz rendue est ré-exposable (§14.4) — l'aperçu inline devient une trace mémoire, pas un one-shot.

### 15.6 Réconciliation avec l'existant
- **26 modes (archi v4.5)** → **presets** de la bibliothèque : chaque mode = un `VizSpec` pré-rempli. Rien n'est perdu, tout devient interrogeable par la grammaire.
- **6 viz noyau (§14)** → entrées `corePriority: 1` : elles **gagnent** la sélection dès qu'elles sont éligibles (domaine cyber = leur terrain).
- **Auto-Suggest (D-MODES-004, Rust)** → devient l'implémentation de référence de `select(intent, dataShape)` : même logique, généralisée à toute la bibliothèque au lieu de 26 cas.

### 15.7 Reste à durcir (R6 → implémentation)
- [x] Écrire le **registre `VizSpec[]`** complet (§15.8 — 90 entrées indexées, les 6 noyau en `core:1`).
- [ ] Implémenter `select()` comme fonction pure testable (mirror de D-MODES-004) + jeux de tests intention→viz.
- [ ] Spécifier le **service de capture inline** (canvas/serveur) et le contrat du bouton « ouvrir viz ».
- [ ] Décider la frontière exacte **viz de bibliothèque vs image IA** (liste blanche d'usages d'image générative).
- [ ] Prototyper le flow complet sur V2 (Attack Graph, G6) avec un `SCN-*` déterministe (§10 ontologie).

### 15.8 Registre `VizSpec[]` — les 90 entrées indexées une par une

> Format compact (schéma §15.3). Champs : `id`, `eng` (moteur), `shp` (dataShapes), `int` (intents), `fx` (cognitiveEffects : C=comprehension, A=analogy, N=anchoring, R=retention), `max` (maxNodes), `gpu`, `core` (1 = viz noyau §14), `fb` (fallbackId). **Zéro invention** : chaque `id` correspond à une primitive réellement produite par son moteur (§15.2).

```ts
// ── Cosmograph / cosmos.gl (node-link GPU massif) ───────────────────────────
{ id:"cosmograph-force",    eng:"cosmos",   shp:["network"],                int:["show_relationships"],            fx:["C","N"],       max:1_000_000, gpu:true, fb:"g6-force" }
{ id:"cosmograph-timeline", eng:"cosmos",   shp:["timeseries","network"],   int:["show_sequence"],                 fx:["C","R"],       max:1_000_000, gpu:true, fb:"correlation-timeline" }

// ── AntV G6 v5 (node-link, 20+ layouts) ─────────────────────────────────────
{ id:"g6-force",            eng:"g6",       shp:["network"],                int:["show_relationships"],            fx:["C","N"],       max:50_000, fb:"nivo-network" }
{ id:"attack-graph",        eng:"g6",       shp:["network","dag"],          int:["show_relationships","show_causality"], fx:["C","A","N","R"], max:50_000, core:1, fb:"cosmograph-force" } // V2 noyau
{ id:"knowledge-graph",     eng:"g6",       shp:["network"],                int:["show_relationships","show_structure"], fx:["C","N","R"], max:50_000, core:1, fb:"cosmograph-force" } // V2 noyau
{ id:"g6-dagre-dag",        eng:"g6",       shp:["dag"],                    int:["show_flow","show_sequence"],     fx:["C"],           max:20_000, fb:"reactflow-pipeline" }
{ id:"mastery-tree",        eng:"g6",       shp:["hierarchy"],              int:["show_structure","show_hierarchy"], fx:["C","A","N","R"], max:20_000, core:1, fb:"nivo-tree" } // V1 noyau (g6 compact-box)
{ id:"g6-tree-mindmap",     eng:"g6",       shp:["hierarchy"],              int:["show_structure"],                fx:["C","A"],       max:20_000, fb:"nivo-tree" }
{ id:"g6-tree-dendrogram",  eng:"g6",       shp:["hierarchy"],              int:["show_hierarchy"],                fx:["C"],           max:20_000, fb:"d3-cluster" }
{ id:"g6-tree-indented",    eng:"g6",       shp:["hierarchy"],              int:["show_structure"],                fx:["C"],           max:20_000, fb:"nivo-icicle" }
{ id:"g6-circular",         eng:"g6",       shp:["network"],                int:["show_relationships"],            fx:["C"],           max:20_000, fb:"nivo-chord" }
{ id:"g6-radial",           eng:"g6",       shp:["network","hierarchy"],    int:["show_structure"],                fx:["C","A"],       max:20_000, fb:"nivo-network" }
{ id:"g6-grid",             eng:"g6",       shp:["network"],                int:["compare"],                       fx:["C"],           max:20_000, fb:"nivo-heatmap" }
{ id:"g6-fruchterman",      eng:"g6",       shp:["network"],                int:["show_relationships"],            fx:["C"],           max:20_000, fb:"g6-force" }
{ id:"g6-combo",            eng:"g6",       shp:["network","hierarchy"],    int:["show_structure","show_relationships"], fx:["C","N"], max:20_000, fb:"nivo-network" }
{ id:"causal-loop",         eng:"g6",       shp:["network"],                int:["show_causality"],                fx:["C","A","R"],   max:5_000,  fb:"d3-force" }
{ id:"arc-diagram",         eng:"g6",       shp:["sequence","network"],     int:["show_sequence","show_relationships"], fx:["C"],       max:5_000,  fb:"d3-arc" }

// ── AntV G2 v5 (grammaire statistique + hiérarchie) ─────────────────────────
{ id:"g2-interval-bar",     eng:"g2",       shp:["multivariate"],           int:["compare"],                       fx:["C"],           max:100_000, fb:"recharts-bar" }
{ id:"g2-rect",             eng:"g2",       shp:["matrix"],                 int:["show_distribution"],             fx:["C"],           max:100_000, fb:"nivo-heatmap" }
{ id:"g2-line",             eng:"g2",       shp:["timeseries"],             int:["show_sequence"],                 fx:["C"],           max:100_000, fb:"recharts-line" }
{ id:"g2-point-scatter",    eng:"g2",       shp:["multivariate"],           int:["show_distribution","compare"],   fx:["C"],           max:100_000, fb:"nivo-scatterplot" }
{ id:"g2-area",             eng:"g2",       shp:["timeseries"],             int:["show_sequence"],                 fx:["C"],           max:100_000, fb:"recharts-area" }
{ id:"g2-cell",             eng:"g2",       shp:["matrix"],                 int:["show_distribution"],             fx:["C"],           max:100_000, fb:"nivo-heatmap" }
{ id:"g2-box",              eng:"g2",       shp:["multivariate"],           int:["show_distribution","compare"],   fx:["C"],           max:100_000, fb:"nivo-boxplot" }
{ id:"attack-heatmap",      eng:"g2",       shp:["matrix"],                 int:["show_distribution","compare"],   fx:["C","A","N","R"], max:100_000, core:1, fb:"nivo-heatmap" } // V4 noyau (ATT&CK)
{ id:"g2-density",          eng:"g2",       shp:["multivariate"],           int:["show_distribution"],             fx:["C"],           max:100_000, fb:"nivo-swarmplot" }
{ id:"decision-gauge",      eng:"g2",       shp:["multivariate"],           int:["show_state"],                    fx:["C","N","R"],   max:100,    core:1, fb:"recharts-radialbar" } // V6 noyau
{ id:"g2-liquid",           eng:"g2",       shp:["multivariate"],           int:["show_state"],                    fx:["C","N"],       max:100,    fb:"recharts-radialbar" }
{ id:"g2-link",             eng:"g2",       shp:["network"],                int:["show_relationships"],            fx:["C"],           max:50_000, fb:"nivo-network" }
{ id:"g2-polygon",          eng:"g2",       shp:["geospatial"],             int:["show_distribution"],             fx:["C"],           max:50_000, fb:"nivo-choropleth" }
{ id:"g2-range",            eng:"g2",       shp:["timeseries"],             int:["show_state"],                    fx:["C"],           max:100_000, fb:"recharts-area" }
{ id:"g2-sankey",           eng:"g2",       shp:["flow"],                   int:["show_flow"],                     fx:["C","A"],       max:5_000,  fb:"nivo-sankey" }
{ id:"g2-chord",            eng:"g2",       shp:["matrix","network"],       int:["show_relationships"],            fx:["C","A"],       max:2_000,  fb:"nivo-chord" }
{ id:"g2-tree",             eng:"g2",       shp:["hierarchy"],              int:["show_hierarchy","show_structure"], fx:["C"],         max:20_000, fb:"nivo-tree" }
{ id:"g2-treemap",          eng:"g2",       shp:["hierarchy"],              int:["show_hierarchy","compare"],      fx:["C","N"],       max:20_000, fb:"nivo-treemap" }
{ id:"g2-pack",             eng:"g2",       shp:["hierarchy"],              int:["show_hierarchy"],                fx:["C","A"],       max:20_000, fb:"nivo-circlepacking" }
{ id:"g2-sunburst",         eng:"g2",       shp:["hierarchy"],              int:["show_hierarchy","show_structure"], fx:["C","A","N"], max:20_000, fb:"nivo-sunburst" }

// ── nivo (dataviz React déclaratif, 31 composants) ──────────────────────────
{ id:"nivo-bar",            eng:"nivo",     shp:["multivariate"],           int:["compare"],                       fx:["C"],           max:50_000, fb:"recharts-bar" }
{ id:"nivo-line",           eng:"nivo",     shp:["timeseries"],             int:["show_sequence"],                 fx:["C"],           max:50_000, fb:"recharts-line" }
{ id:"nivo-area-bump",      eng:"nivo",     shp:["timeseries"],             int:["show_sequence","compare"],       fx:["C"],           max:50_000, fb:"nivo-line" }
{ id:"nivo-boxplot",        eng:"nivo",     shp:["multivariate"],           int:["show_distribution"],             fx:["C"],           max:50_000, fb:"g2-box" }
{ id:"nivo-bullet",         eng:"nivo",     shp:["multivariate"],           int:["show_state","compare"],          fx:["C"],           max:100,    fb:"recharts-bar" }
{ id:"nivo-bump",           eng:"nivo",     shp:["timeseries"],             int:["show_sequence","compare"],       fx:["C"],           max:5_000,  fb:"nivo-line" }
{ id:"nivo-calendar",       eng:"nivo",     shp:["timeseries"],             int:["show_distribution","show_sequence"], fx:["C","N"],   max:5_000,  fb:"nivo-heatmap" }
{ id:"nivo-chord",          eng:"nivo",     shp:["matrix","network"],       int:["show_relationships"],            fx:["C","A"],       max:2_000,  fb:"g2-chord" }
{ id:"nivo-choropleth",     eng:"nivo",     shp:["geospatial"],             int:["show_distribution","compare"],   fx:["C","N"],       max:5_000,  fb:"nivo-geomap" }
{ id:"nivo-circlepacking",  eng:"nivo",     shp:["hierarchy"],              int:["show_hierarchy"],                fx:["C","A"],       max:20_000, fb:"g2-pack" }
{ id:"nivo-funnel",         eng:"nivo",     shp:["flow","sequence"],        int:["show_flow","show_sequence"],     fx:["C","A"],       max:100,    fb:"nivo-bar" }
{ id:"nivo-geomap",         eng:"nivo",     shp:["geospatial"],             int:["show_distribution"],             fx:["C"],           max:5_000,  fb:"g2-polygon" }
{ id:"nivo-heatmap",        eng:"nivo",     shp:["matrix"],                 int:["show_distribution","compare"],   fx:["C","N"],       max:50_000, fb:"g2-rect" }
{ id:"nivo-icicle",         eng:"nivo",     shp:["hierarchy"],              int:["show_hierarchy","show_structure"], fx:["C"],         max:20_000, fb:"d3-partition-icicle" }
{ id:"nivo-marimekko",      eng:"nivo",     shp:["multivariate"],           int:["compare","show_distribution"],   fx:["C"],           max:5_000,  fb:"g2-treemap" }
{ id:"nivo-network",        eng:"nivo",     shp:["network"],                int:["show_relationships"],            fx:["C"],           max:50_000, fb:"g6-force" }
{ id:"nivo-parallelcoords", eng:"nivo",     shp:["multivariate"],           int:["compare"],                       fx:["C","A"],       max:5_000,  fb:"d3-parallel" }
{ id:"nivo-pie",            eng:"nivo",     shp:["multivariate"],           int:["show_distribution"],             fx:["C"],           max:100,    fb:"recharts-bar" }
{ id:"nivo-polarbar",       eng:"nivo",     shp:["multivariate"],           int:["compare"],                       fx:["C"],           max:100,    fb:"recharts-radar" }
{ id:"nivo-radar",          eng:"nivo",     shp:["multivariate"],           int:["compare","show_state"],          fx:["C","A"],       max:100,    fb:"recharts-radar" }
{ id:"nivo-radialbar",      eng:"nivo",     shp:["multivariate"],           int:["show_state","compare"],          fx:["C"],           max:100,    fb:"recharts-radialbar" }
{ id:"nivo-sankey",         eng:"nivo",     shp:["flow"],                   int:["show_flow"],                     fx:["C","A"],       max:5_000,  fb:"d3-sankey" }
{ id:"nivo-scatterplot",    eng:"nivo",     shp:["multivariate"],           int:["show_distribution","compare"],   fx:["C"],           max:50_000, fb:"g2-point-scatter" }
{ id:"nivo-stream",         eng:"nivo",     shp:["timeseries"],             int:["show_sequence","show_flow"],     fx:["C"],           max:5_000,  fb:"nivo-area-bump" }
{ id:"nivo-sunburst",       eng:"nivo",     shp:["hierarchy"],              int:["show_hierarchy","show_structure"], fx:["C","A","N"], max:20_000, fb:"g2-sunburst" }
{ id:"nivo-swarmplot",      eng:"nivo",     shp:["multivariate"],           int:["show_distribution"],             fx:["C"],           max:5_000,  fb:"g2-density" }
{ id:"nivo-timerange",      eng:"nivo",     shp:["timeseries"],             int:["show_distribution","show_sequence"], fx:["C","N"],   max:5_000,  fb:"nivo-calendar" }
{ id:"nivo-tree",           eng:"nivo",     shp:["hierarchy"],              int:["show_structure","show_hierarchy"], fx:["C","A"],     max:20_000, fb:"d3-hierarchy-tree" }
{ id:"nivo-treemap",        eng:"nivo",     shp:["hierarchy"],              int:["show_hierarchy","compare"],      fx:["C","N"],       max:20_000, fb:"g2-treemap" }
{ id:"nivo-voronoi",        eng:"nivo",     shp:["multivariate","geospatial"], int:["show_distribution"],          fx:["C"],           max:5_000,  fb:"d3-voronoi" }
{ id:"nivo-waffle",         eng:"nivo",     shp:["multivariate"],           int:["show_distribution","show_state"], fx:["C","N"],      max:100,    fb:"nivo-pie" }

// ── React Flow v12 (DAG / flux structurés UNIQUEMENT) ───────────────────────
{ id:"reactflow-flowchart", eng:"reactflow", shp:["dag"],                   int:["show_flow","show_sequence"],     fx:["C","A"],       max:1_000,  fb:"g6-dagre-dag" }
{ id:"reactflow-roadmap",   eng:"reactflow", shp:["dag"],                   int:["show_flow","show_sequence"],     fx:["C","A","R"],   max:1_000,  fb:"g6-dagre-dag" }
{ id:"reactflow-pipeline",  eng:"reactflow", shp:["dag"],                   int:["show_flow"],                     fx:["C"],           max:1_000,  fb:"g6-dagre-dag" }
{ id:"reactflow-argmap",    eng:"reactflow", shp:["dag"],                   int:["show_causality","show_structure"], fx:["C","A"],     max:1_000,  fb:"g6-dagre-dag" }

// ── d3 v7 (bas niveau — dernier recours) ────────────────────────────────────
{ id:"d3-hierarchy-tree",   eng:"d3",       shp:["hierarchy"],              int:["show_structure"],                fx:["C"],           max:5_000,  fb:"nivo-tree" }
{ id:"d3-cluster",          eng:"d3",       shp:["hierarchy"],              int:["show_hierarchy"],                fx:["C"],           max:5_000,  fb:"g6-tree-dendrogram" }
{ id:"d3-pack",             eng:"d3",       shp:["hierarchy"],              int:["show_hierarchy"],                fx:["C"],           max:5_000,  fb:"nivo-circlepacking" }
{ id:"d3-treemap",          eng:"d3",       shp:["hierarchy"],              int:["show_hierarchy","compare"],      fx:["C"],           max:5_000,  fb:"nivo-treemap" }
{ id:"d3-partition-icicle", eng:"d3",       shp:["hierarchy"],              int:["show_hierarchy","show_structure"], fx:["C"],         max:5_000,  fb:"nivo-icicle" }
{ id:"d3-partition-sunburst", eng:"d3",     shp:["hierarchy"],              int:["show_hierarchy"],                fx:["C","A"],       max:5_000,  fb:"nivo-sunburst" }
{ id:"d3-force",            eng:"d3",       shp:["network"],                int:["show_relationships"],            fx:["C"],           max:5_000,  fb:"g6-force" }
{ id:"d3-chord",            eng:"d3",       shp:["matrix","network"],       int:["show_relationships"],            fx:["C"],           max:1_000,  fb:"nivo-chord" }
{ id:"d3-sankey",           eng:"d3",       shp:["flow"],                   int:["show_flow"],                     fx:["C"],           max:2_000,  fb:"nivo-sankey" }
{ id:"d3-arc",              eng:"d3",       shp:["sequence","network"],     int:["show_sequence"],                 fx:["C"],           max:2_000,  fb:"arc-diagram" }
{ id:"d3-edge-bundling",    eng:"d3",       shp:["network","hierarchy"],    int:["show_relationships"],            fx:["C"],           max:5_000,  fb:"g6-radial" }
{ id:"d3-parallel",         eng:"d3",       shp:["multivariate"],           int:["compare"],                       fx:["C","A"],       max:5_000,  fb:"nivo-parallelcoords" }
{ id:"d3-voronoi",          eng:"d3",       shp:["multivariate","geospatial"], int:["show_distribution"],          fx:["C"],           max:5_000,  fb:"nivo-voronoi" }

// ── recharts v2 (statistiques simples React) ────────────────────────────────
{ id:"recharts-line",       eng:"recharts", shp:["timeseries"],             int:["show_sequence"],                 fx:["C"],           max:5_000,  fb:"nivo-line" }
{ id:"recharts-bar",        eng:"recharts", shp:["multivariate"],           int:["compare"],                       fx:["C"],           max:5_000,  fb:"nivo-bar" }
{ id:"recharts-area",       eng:"recharts", shp:["timeseries"],             int:["show_sequence"],                 fx:["C"],           max:5_000,  fb:"nivo-line" }
{ id:"correlation-timeline",eng:"recharts", shp:["timeseries","sequence"],  int:["show_sequence"],                 fx:["C","A","N","R"], max:5_000, core:1, fb:"nivo-timerange" } // V3 noyau
{ id:"recharts-composed",   eng:"recharts", shp:["timeseries","multivariate"], int:["show_sequence","compare"],    fx:["C"],           max:5_000,  fb:"nivo-line" }
{ id:"recharts-radar",      eng:"recharts", shp:["multivariate"],           int:["compare","show_state"],          fx:["C","A"],       max:100,    fb:"nivo-radar" }
{ id:"recharts-radialbar",  eng:"recharts", shp:["multivariate"],           int:["show_state"],                    fx:["C"],           max:100,    fb:"nivo-radialbar" }
{ id:"autonomy-envelope",   eng:"recharts", shp:["matrix"],                 int:["show_state","show_distribution"], fx:["C","N","R"],  max:100,    core:1, fb:"nivo-heatmap" } // V5 noyau (grille classe×risque)

// ── three.js / r3f-forcegraph (node-link 3D immersif — R&D) ─────────────────
{ id:"three-force-3d",      eng:"three",    shp:["network"],                int:["show_relationships"],            fx:["C","A","N"],   max:10_000, gpu:true, fb:"g6-force" }
{ id:"three-dag-3d",        eng:"three",    shp:["dag"],                    int:["show_flow","show_relationships"], fx:["C","A"],      max:10_000, gpu:true, fb:"reactflow-pipeline" }
```

**Bilan du registre : 90 entrées** (Cosmograph 2 · G6 16 · G2 21 · nivo 31 · React Flow 4 · d3 13 · recharts 8 · three 2). Les **6 viz noyau (§14)** sont marquées `core:1` : `mastery-tree` (V1), `attack-graph`+`knowledge-graph` (V2), `correlation-timeline` (V3), `attack-heatmap` (V4), `autonomy-envelope` (V5), `decision-gauge` (V6). Chaque entrée a un `fb` (repli) garantissant qu'aucune contrainte GPU/taille ne casse le rendu.

---

## 16. Le Semantic Tree — différenciateur zéro-to-one, spec MVP complète (R7)

> **Statut : DÉCISIONS CLOSES — prêt pour implémentation.** La discussion a tranché les trois axes ouverts. Cette section est la spec définitive. Le fichier source complet est `docs/SCYFORGE_SEMANTIC_TREE_INFRASTRUCTURE.md`.

### 16.0 Ce qu'est le Semantic Tree (récapitulatif de convergence)

Le Semantic Tree n'est **pas** une viz parmi 90. C'est l'**infrastructure** du produit — le substrat de données dont COSMOS est une projection (§15, 8 projections possibles). Il répond à trois questions simultanément, chacune obligatoire :

| Objectif | Registre | Source |
|---|---|---|
| **Apprendre** le chemin (quoi avant quoi) | Prerequisite graph orienté | Arêtes `prereq` bloquantes |
| **Comprendre** le sens (pourquoi ce lien) | Concept map Novak (arêtes étiquetées) | Arêtes `relates / contradicts / supersedes` |
| **Retenir** l'état courant | Skill tree motivationnel | État FSRS par nœud, capstones, progression visible |

Règle §14.2 appliquée en dur : les **4 effets cognitifs** (compréhension, analogie, ancrage, rétention) doivent tous être servis — pas 3.

### 16.1 Structure de données — DAG enraciné sémantique

Le Semantic Tree est un **DAG enraciné** : un backbone arborescent (tronc → branches → feuilles) **+ des lianes transverses typées**. Ce n'est pas un arbre strict (multi-parent autorisé) ni un DAG général.

```ts
// Nœud
interface STNode {
  id:           string                          // UUID stable
  kind:         "concept" | "skill" | "capstone"
  label:        string
  pillar:       string                          // tactique ATT&CK → couleur
  depth:        number                          // distance à la racine
  owner_kind:   "domain_pack" | "org" | "learner"
  // État FSRS (projection learner uniquement)
  fsrs_state?:  "unseen" | "learning" | "mastered" | "due"
  confidence?:  number                          // 0.0 → 1.0
  // Temporel (Graphiti/Zep)
  valid_at:     string                          // ISO 8601
  expired_at?:  string
}

// Arête
interface STEdge {
  source:       string
  target:       string
  kind:         "prereq" | "relates" | "contradicts" | "supersedes"
  weight:       number                          // force de la dépendance 0→1
  label?:       string                          // ex. "exploite", "détecte", "atténue"
  // Temporel (Graphiti/Zep)
  valid_at:     string
  expired_at?:  string
}
```

**Les trois instances (`owner_kind`)** : `domain_pack` (l'ontologie cyber objective), `org` (alignement tenant), `learner` (projection maîtrisée de l'arbre d'org). Un seul substrat, trois lectures.

### 16.2 La 4e dimension — Graphiti / Zep (DÉCISION CLOSE)

**Graphiti (Zep)** est le substrate temporel. Chaque nœud et chaque arête porte `valid_at` / `expired_at` nativement. Ce n'est pas une couche d'affichage ajoutée — c'est le modèle de données.

Conséquence pour la viz : un **scrubber temporel** (slider horodaté) rejoue la croissance de l'arbre. En reculant dans le temps :
- Les nœuds `expired_at < t` s'éteignent progressivement.
- Les arêtes `supersedes` deviennent visibles (elles relient l'ancien concept au nouveau).
- Les greffes horodatées se "dégreffent" visuellement (animation inverse de croissance).

**Valeur pédagogique** : l'apprenant voit que le domaine cyber *évolue* — qu'une technique de 2022 a été supersedée, et comprend *pourquoi* le nouveau concept existe.

### 16.3 Esthétique — fusion botanique × numérique (DÉCISION CLOSE)

**Champ lexical** : botanique (tronc, branches, feuilles, greffe, élagage, anneaux de croissance). **Rendu** : cyber-organique — jamais du bois, jamais du naturel mou. La fusion est la suivante :

| Élément botanique | Rendu cyber-numérique |
|---|---|
| Tronc / branches | Câbles lumineux (fiber optic bézier), géométrie précise |
| Feuilles / nœuds | Formes géométriques (hexagones, cristaux, circuits) — pas de ronds génériques |
| Croissance / greffe | Animation de propagation lumineuse le long de la branche (pas un fondu) |
| Anneaux de croissance | Couche temporelle — activée par le scrubber (§16.2) |
| Bioluminescence | Halo d'état FSRS : couleur froide = non vu, couleur chaude = maîtrisé, pulsation = à réviser |

**Règle absolue** : chaque effet visuel porte une information (double codage §14.2). Aucune lumière, aucune animation, aucune particule qui n'encode pas de données.

### 16.4 Stack de rendu — arbitrage final (DÉCISION CLOSE)

**React Three Fiber (Three.js) est le renderer principal du MVP.** Un arbre 2D classique (G6, React Flow) ne peut pas rendre la fusion botanique × numérique à la qualité attendue. L'architecture est hybride :

```
d3-hierarchy (layout calc)
    ↓  positions x/y/z des nœuds
React Three Fiber (rendu 3D)
    ↓  câbles bézier 3D, nœuds géométriques, halos FSRS, animations
Graphiti / Zep (substrate temporel)
    ↓  nœuds/arêtes avec valid_at/expired_at → scrubber
```

| Rôle | Outil | Justification |
|---|---|---|
| **Calcul de layout** | d3-hierarchy + dagre | Positions DAG propres, profondeur, multi-parent ; d3 ne rend rien, il calcule |
| **Rendu 3D cyber-organique** | React Three Fiber + @react-three/drei | Câbles bézier 3D, géométries custom, shaders FSRS, animations spring |
| **Substrate temporel** | Graphiti (Zep) | `valid_at`/`expired_at` natifs → scrubber sans couche d'affichage manuelle |
| **Interactions riches (nœud-carte)** | React portals dans R3F | Jauges FSRS, bouton «ouvrir viz», preview de build — en HTML sur canvas 3D |
| **Fallback 2D** | AntV G6 | Si WebGL indisponible ou nœuds > 50K, rendu 2D professionnel avec arêtes étiquetées |

### 16.5 Lianes — stratégie de visibilité (DÉCISION CLOSE)

| Type d'arête | Visible par défaut | Rendu | Logique |
|---|---|---|---|
| `prereq` | **Toujours** | Câble épais, orienté, couleur du pilier cible | Ossature — jamais masquée |
| `relates` | **Au survol du nœud** | Câble fin, tiret, couleur neutre | Contexte — visible quand pertinent |
| `contradicts` | **Toggle couche** (désactivé par défaut) | Câble rouge pulsant | Avancé — activé volontairement |
| `supersedes` | **Scrubber temporel uniquement** | Visible seulement quand la dimension temporelle est active | Chronologique — lié à §16.2 |

Logique : au repos, seule la structure de prérequis est lisible. L'apprenant découvre le contexte, les contradictions et l'histoire progressivement — jamais un graphe saturé d'emblée.

### 16.6 Grammaire visuelle — double codage complet

Chaque canal visuel encode **exactement une information** :

| Canal visuel | Information encodée | Effet cognitif |
|---|---|---|
| **Position / profondeur** | Niveau de prérequis (racine = fondamentaux) | *Apprendre* le chemin |
| **Couleur du nœud** | Pilier / tactique ATT&CK (constant sur toutes les viz §14) | *Ancrer* par famille |
| **Halo / bioluminescence** | État FSRS (`unseen`→froid / `learning`→tiède / `mastered`→chaud / `due`→pulsation) | *Retenir* : trace mémoire ré-exposable |
| **Forme géométrique** | Kind du nœud (`concept`=hexagone / `skill`=cristal / `capstone`=circuit) | *Analogie* stable |
| **Épaisseur du câble** | Force de la dépendance (`weight` 0→1) | *Comprendre* l'importance |
| **Étiquette d'arête** | Sens sémantique (`exploite`, `détecte`, `atténue`, `supersedes`…) | *Comprendre* la relation |
| **Animation de croissance** | Greffe horodatée (nouveau nœud débloqué) | *Rétention* par événement |
| **Opacité du nœud** | Accessibilité (prérequis non satisfaits → nœud estompé) | *Apprendre* le prochain pas |

### 16.7 Interactions MVP obligatoires

- **Construction progressive** : `confidence` gouverne l'accès aux enfants (contrainte du modèle, pas astuce UX). L'apprenant ne *peut pas* voir 300 nœuds — il voit son tronc maîtrisé + la frontière greffable.
- **Zoom sémantique** : vue macro (piliers) → méso (compétences) → micro (nœud-carte : jauge FSRS + bouton «ouvrir viz» COSMOS → une des 90 viz §15.8).
- **Survol = preview de build** : prérequis manquants surlignés + liste des nœuds que ce concept débloque.
- **Chemin recommandé** : surlignage du prochain nœud greffable (prérequis satisfaits) — calculé par `select()` §15.4.
- **Scrubber temporel** : slider horodaté qui rejoue la croissance de l'arbre (§16.2 — Graphiti/Zep).
- **Filtrage** : par pilier ATT&CK, par état FSRS, par «chemin critique vers cet objectif».
- **Greffe** : sélectionner un nœud estompé + confirmer → propagation lumineuse + état FSRS initialisé.

### 16.8 Registre VizSpec — entrée `semantic-tree` (ajout au §15.8)

```ts
{ id:"semantic-tree", eng:"three", shp:["dag","hierarchy"], int:["show_structure","show_relationships","show_causality"], fx:["C","A","N","R"], max:50_000, gpu:true, core:1, fb:"g6-combo" }
```

Moteur mis à jour : `three` (R3F), fallback `g6-combo` (2D, WebGL absent).

### 16.9 Todos R7 → implémentation (ordonnés)

- [ ] **R7.1** — Spécifier le schéma SQL/Graphiti complet du nœud + arête (aligné sur l'ontologie §10 + `valid_at`/`expired_at`).
- [ ] **R7.2** — Prototype layout : d3-hierarchy + dagre sur un vrai sous-arbre ATT&CK (20–30 nœuds, multi-parent), vérifier lisibilité avant de passer au rendu 3D.
- [ ] **R7.3** — Prototype R3F : câbles bézier 3D, hexagones/cristaux/circuits, halos FSRS, animation de greffe. Pas de données réelles — structure fixe.
- [ ] **R7.4** — Intégration Graphiti/Zep : brancher `valid_at`/`expired_at` sur le scrubber temporel, tester le replay de croissance.
- [ ] **R7.5** — Connecter `select()` (§15.4) au chemin recommandé + aux boutons «ouvrir viz» des nœuds-cartes.
- [ ] **R7.6** — Définir le mapping FSRS → canal visuel (halo/bioluminescence) partagé avec les 6 viz noyau §14 (contrainte de cohérence).

---

## 9. Journal de version

- **v0.11** — **Alignement D9 (couverture pondérée par règles).** Trois points mis à jour : (1) `AutonomyProof.coverage` §5 redéfini de `% du tronc maîtrisé` (comptage) à `Σ score(N) / Σ score_max(N)` — R1 `trunkPriority` (poids ×1.0..×3.0), R2 `skill_era` (+20% si `new_2026`), R3 fidélité atteinte (L1=0.25..L4=1.0). (2) Critère de sortie boucle Macro §11 mis à jour : `coverage(pack) ≥ 0.80` pondéré D9. (3) `AutonomyProof` §13 aligné : le seuil ≥ 0.80 peut être franchi chez MSSP/MDR tout en restant sous seuil en profil régulé si les nœuds à fort `w_audit` sont encore en `shadow`. Formule complète et constantes (R1/R2/R3) vivent dans `SCYFORGE_ARENA_SIMULATION_ENGINE.md §12`.
- **v0.10** — **Semantic Tree : spec MVP complète, toutes décisions closes (§16).** Trois axes tranchés en discussion : (A) Esthétique = **fusion botanique × numérique** — champ lexical botanique (tronc/branches/feuilles/greffe), rendu **cyber-organique** (câbles bézier lumineux fiber optic, nœuds géométriques hexagone/cristal/circuit, bioluminescence FSRS, animation de propagation à la greffe) — jamais de rendu naturel mou. (B) Lianes = stratégie de visibilité par couche : `prereq` toujours visible (ossature), `relates` au survol, `contradicts` toggle, `supersedes` scrubber temporel seulement. (C) **4e dimension = Graphiti/Zep** : substrate temporel natif (`valid_at`/`expired_at` sur nœuds + arêtes), scrubber qui rejoue la croissance de l'arbre, rend visible l'évolution du domaine cyber. **Stack de rendu MVP** (DÉCISION CLOSE) : **React Three Fiber** renderer principal (fusion botanique/numérique impossible en 2D), **d3-hierarchy + dagre** pour le calcul de layout DAG (positions uniquement), **React portals** pour nœuds-cartes HTML riches (jauge FSRS, bouton «ouvrir viz»), **fallback AntV G6** si WebGL absent. Grammaire visuelle à double codage complet (8 canaux, chacun encode exactement une info). Entrée `semantic-tree` ajoutée au registre §15.8 (`eng:"three"`, `core:1`, `fb:"g6-combo"`). Todos R7 ordonnés (R7.1 schéma SQL/Graphiti → R7.2 proto layout d3 → R7.3 proto R3F → R7.4 intégration Graphiti → R7.5 connect select() → R7.6 mapping FSRS→canal visuel).
- **v0.9** — **Registre `VizSpec[]` complet (§15.8, 90 entrées) + Semantic Tree comme différenciateur zéro-to-one (§16).** Indexation une par une des 90 viz réalisables par la stack (Cosmograph 2 · G6 16 · G2 21 · nivo 31 · React Flow 4 · d3 13 · recharts 8 · three 2), chacune avec dataShapes/intents/effets cognitifs/maxNodes/fallback ; les 6 viz noyau §14 marquées `core:1`. **§16 (R7) : le Semantic Tree n'est pas une viz parmi 90** — veille sourcée distinguant skill tree (motivation), concept map Novak (arêtes étiquetées = sens), prerequisite graph (dépendances orientées) → **fusion des trois = DAG sémantique** (pas un arbre strict : multi-parent). Conséquence dure : forme = `dag`, ce qui **exclut sunburst/treemap/icicle** en vue principale. **Choix moteur arbitré (sourcé)** : **G6 recommandé** (layouts DAG/radial natifs, collapse/expand, arêtes étiquetées, perfs), **fallback React Flow + ELK** si nœuds = cartes UI riches (jauges FSRS), d3-hierarchy = helper de layout seulement. Grammaire visuelle à double codage (position→prérequis, arête étiquetée→sens, couleur→pilier ATT&CK, halo→état FSRS, forme→type, épaisseur→force de dépendance) + interactions obligatoires (construction progressive, zoom sémantique, survol=preview de build, filtrage, chemin recommandé via `select()`). Todos R7 posés (entrée `semantic-tree`, schéma DAG aligné ontologie §10, proto G6 vs RF+ELK, mapping FSRS→canal, algo chemin recommandé).
- **v0.8** — **Recadrage COSMOS v5 : bibliothèque de viz + grammaire « intention → viz » (§15), fin du modèle « N modes figés ».** Décision fondateur : on ne peut pas énumérer toutes les viz utiles à l'avance → COSMOS devient **moteur de rendu générique + bibliothèque indexée (`VizSpec`) + sélecteur pur `(intent, dataShape, constraints) → viz`**. L'agent **rend la viz réelle** (données tenant) puis **capture inline + bouton « ouvrir viz interactive »**, au lieu de générer une **image IA statique** (rejetée : non fidèle, non interactive, non professionnelle). **Catalogue exhaustif de la stack sourcé (veille 2026)** : cosmos.gl/Cosmograph (1M+ GPU), G6 v5 (20+ layouts node-link), G2 v5 (marks statistiques + hiérarchie : sunburst/treemap/pack/heatmap/sankey/chord/gauge), nivo (40+ composants), React Flow v12 (DAGs only), d3 v7 (bas niveau : parallel coord./arc/edge bundling/voronoi), recharts v2 (radar/line/bar), three.js/r3f-forcegraph (3D R&D). Invariants de routage repris de l'archi v4.5 (React Flow = DAG only, G6 ≠ G2, Cosmograph si GPU, d3 = dernier recours). Modèle `VizSpec` (engine/dataShapes/intents/cognitiveEffects/maxNodes/fallback/corePriority) + table de correspondance intention×forme→viz avec repli. **Réconciliation** : les 26 modes deviennent des **presets** de la bibliothèque, les 6 viz noyau (§14) = entrées `corePriority:1`, l'Auto-Suggest Rust (D-MODES-004) = implémentation de référence de `select()`. Todos R6 posés (registre VizSpec, select() testable, service de capture, frontière viz/image IA, proto V2).
- **v0.7** — **Chantier recherche COSMOS : le 20 % de visualisations à fort levier (§14).** COSMOS identifié dans les docs comme module de visualisation du noyau (§4.3). Veille 2026 ancrée : SOC *AI-centric*, frein = confiance/visibilité (pas la technique) ; double codage / charge cognitive (Mayer, Paivio) ; visualisation cyber = modèle mental séquentiel (nœuds/arêtes) ; Pareto ATT&CK 20 %/89 %. Règle de sélection posée (un visuel entre au noyau s'il sert ≥ 3 des 4 effets : compréhension/analogie/ancrage/rétention). **Noyau = 6 visualisations** : V1 Arbre de maîtrise, V2 Kill chain/graphe d'attaque, V3 Timeline de corrélation, V4 Heatmap ATT&CK, V5 Carte d'autonomie (Envelope §13), V6 Jauge décision & confiance. Principes de polissage (double codage, une intention/vue, ré-exposition FSRS, progression vs score, zéro décor, cohérence médiateur §4.6). Todos design partner listés.
- **v0.6** — **Principe fondateur : le Domain Pack est un MÉDIATEUR, pas le curriculum (§4.6)** + **chantier R3 : spec formelle de l'Autonomy Envelope (§13)**. §4.6 sépare deux vérités : la vérité pédagogique (« quoi maîtriser ») appartient à l'entreprise et est fournie explicitement (autoritative, non négociable) ; le pack détient la vérité de médiation (« comment structurer/aligner ») — ancrer, aligner, combler, traduire en preuve. Conséquences propagées : `CorpusProvider` = docs entreprise en source primaire, `corpus_snapshot_id` = tenant, `OntologyProvider` = grille d'alignement, + « test de médiation » (retirer le corpus entreprise ⇒ plus de curriculum, et c'est voulu). §13 : `AutonomyEnvelope` comme objet de 1re classe (matrice classe d'alerte × risque → mode ∈ {shadow, guarded, autonomous, handoff}), structure de données, transitions monotones gatées (montée par SKILL-CERTIFIER, descente par DRIFT-GUARDIAN + future OutcomeFeedbackPolicy), plafonds `ceilingMode` bornés par le profil (§12.8.4). `AutonomyProof` redéfini comme projection de l'enveloppe. Résout G2 ; alimente G1 (rail shadow→autonomous).
- **v0.5** — **Chantier recherche R2 : les 2 jeux de valeurs de providers (§12.8).** Spec ancrée sur veille web 2025-2026 : `ProofRubric` (vecteur de poids `accuracy/speed/volume/justification/audit` — MSSP remonte vitesse+volume, régulé remonte justification+audit et rend l'audit bloquant), `ValidationGuard` (le régulé ajoute séparation détection/réponse stricte, résidence traitement+accès, oversight IA loggé, rétention 5–7 ans + crypto-shredding), `Corpus` (socle SigmaHQ 3 000+ règles commun ; playbooks standardisés vs SOP sectorielles + NIS2/DORA/GDPR injectés), et `RoleTaxonomy` bornée par une **ébauche d'Autonomy Envelope** (classe d'alerte × risque → mode, avec horloge réglementaire DORA 4 h / NIS2 24 h). Chiffres sourcés (MTTT < 5 min, 20–35 alertes/quart, time-to-classify < 2 h). Action §12.7 « 2 jeux de providers » cochée ; bornes métier de l'Envelope posées pour alimenter le chantier R3.
- **v0.4** — **Décision cible validée : les deux segments.** §12.3.1 ajouté : MSSP/MDR (amorce) + SOC interne régulé (expansion) partagent le même rôle-noyau SOC L1 et le même sous-arbre ATT&CK → **un seul Cyber Pack, deux profils de déploiement** (différences externalisées dans 2 jeux de valeurs de providers : ProofRubric, ValidationGuard, Corpus, Envelope — jamais 2 arbres). Actions §12.7 mises à jour (spécifier les 2 profils + l'Autonomy Envelope par profil).
- **v0.3** — **Pilier 1 (Cyber Domain Pack) + cadrage autonomie.** §10 : analyse de couverture des 13 agents vs autonomie *opérationnelle* → 3 zones aveugles (G1 pont sim→réel, G2 Autonomy Envelope, G3 boucle de résultat réel) + propositions. §11 : adoption du **Loop Engineering** comme grammaire de conception (4 boucles imbriquées micro/méso/macro/outcome avec critères déterministes), justifiée par l'alignement pédagogie=OODA/NIST. §12 : recherche cyber de fond (NIST CSF 2.0, ATT&CK 14 tactiques, NIS2/DORA, MSSP/MDR vs SOC interne 8–12 analystes) + modélisation du remplissage des 7 ports + arborisation tronc→feuilles + **7 critères de seed déterministe/impactant (C1–C7)** et proposition d'un `SeedValidator`.
- **v0.2** — **Recadrage feature** : la feature s'appelle **ASCENT** (elle existe déjà dans le corpus, ce n'était pas à inventer). §4 réécrit à partir du PIVOT_ARCHITECTURE + DOMAIN_PACK_CONTRACT + FEATURE_TO_PROVIDER_MATRIX : définition d'ASCENT (13 agents domain-agnostiques), tableau des 13 agents → provider consommé → vérité cyber → priorité (P0–P2), mapping des 5 Cognitive Runtime Policies sur les agents, cycle Plant/Graft/Test/Myelinate, et le test de vérité (« retirer le pack cyber »). §5 relié aux tables `scy_*`. Backlog §8 mis à jour.
- **v0.1** — Consolidation initiale du corpus (blueprint, cognitive runtime policies, feature patterning, fundraising/cert). Recherche externe : sciences de l'apprentissage (retrieval practice, spaced repetition, desirable difficulties), marché SOC onboarding (4–9 mois time-to-autonomy, 52–59 % skills gap), paysage upskilling IA (knowledge graphs, espace blanc « corpus privé → preuve »). Première modélisation (nommée provisoirement « Autonomy Proof Loop », renommée ASCENT en v0.2) + modèle de données + métriques.

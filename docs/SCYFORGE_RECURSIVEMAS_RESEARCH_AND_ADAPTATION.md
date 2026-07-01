# SCYForge — Recherche Deep sur RecursiveMAS et adaptation à SCYForge

## Périmètre de ce document

Ce document fait **uniquement** le travail demandé sur RecursiveMAS :
1. lire la page projet officielle,
2. collecter les éléments du papier arXiv et des usages pratiques,
3. distinguer ce qui est **réellement transférable** à SCYForge,
4. proposer une stratégie d’adaptation à **la communication entre agents ASCENT**,
5. sans mélanger cela avec le Plan C de refactor produit.

Autrement dit :
- ici on traite **l’innovation de communication / récursion multi-agent** ;
- dans les docs Plan C, on traitera **le refactor des 13 agents** sans dépendre de RecursiveMAS.

---

# 1. Ce qu’est RecursiveMAS, précisément

RecursiveMAS est un framework de **multi-agent recursion en espace latent**. Au lieu de faire collaborer les agents par échanges textuels classiques, il fait circuler des **états latents** entre agents et entre tours de récursion, grâce à un module léger appelé **RecursiveLink**. L’idée centrale est de traiter l’ensemble du système multi-agent comme un **graphe de calcul récursif unifié** en espace latent [1](https://recursivemas.github.io/) [2](https://arxiv.org/abs/2604.25917).

La page officielle résume 3 gains majeurs observés :
- **+8,3%** de gain moyen de précision,
- **1,2× à 2,4×** de speedup d’inférence,
- **34,6% à 75,6%** de réduction de tokens par rapport à des MAS textuels équivalents [1](https://recursivemas.github.io/) [2](https://arxiv.org/abs/2604.25917).

La promesse forte n’est pas juste “aller plus vite”.
La vraie promesse est :

> faire de la collaboration multi-agent une **boucle récursive optimisable**, au lieu d’une succession coûteuse de messages textuels.

---

# 2. Les briques conceptuelles exactes

## 2.1 RecursiveLink

Le papier et la page projet décrivent **RecursiveLink** comme un module léger résiduel à deux couches, avec deux usages :

### A. Inner Link
Il replie les états cachés de fin de couche d’un agent vers son propre espace d’entrée pour produire des **latent thoughts** sans décoder de tokens intermédiaires [1](https://recursivemas.github.io/) [2](https://arxiv.org/abs/2604.25917).

### B. Outer Link
Il projette les états cachés d’un agent vers l’espace d’entrée d’un autre agent, y compris entre agents **hétérogènes** de tailles / familles différentes [1](https://recursivemas.github.io/) [2](https://arxiv.org/abs/2604.25917).

### Pourquoi c’est important
Parce que dans un MAS textuel :
1. Agent A pense,
2. décode sa pensée en texte,
3. Agent B relit ce texte,
4. le ré-encode,
5. puis pense à son tour.

RecursiveMAS enlève cette “taxe textuelle” pour les tours intermédiaires.

---

## 2.2 Récursion système

Après passage chez le dernier agent, la représentation latente est **réinjectée** au premier agent pour un nouveau round de raffinage. Seul le **dernier round** produit du texte final [1](https://recursivemas.github.io/) [2](https://arxiv.org/html/2604.25917v1).

Ce point est critique :
RecursiveMAS n’est pas juste du “latent handoff” linéaire.
C’est une **boucle récursive fermée**.

---

## 2.3 Inner–Outer Loop Training

Le papier propose un schéma d’optimisation en deux temps :

### Inner loop
Warm-start par agent pour aligner la génération de latent thoughts avec la distribution d’embeddings de la bonne réponse [1](https://recursivemas.github.io/).

### Outer loop
Déroulage complet du système sur `n` tours de récursion, puis optimisation end-to-end sur la perte de sortie finale avec un signal de crédit partagé sur l’ensemble de la boucle [1](https://recursivemas.github.io/) [2](https://arxiv.org/abs/2604.25917).

### Point important pour nous
Cette partie **suppose accès aux états cachés et possibilité d’entraînement differentiable**.
C’est là que commence la différence entre :
- **ce que le papier fait**,
- et **ce que SCYForge peut adopter à court terme**.

---

# 3. Les résultats empiriques réellement rapportés

## 3.1 Résultats globaux
Sur 9 benchmarks couvrant math, science, médecine, recherche et code, RecursiveMAS bat des baselines single-agent, multi-agent et récursives textuelles, avec en moyenne **+8,3% de gain de précision**, **1,2×–2,4× de speedup** et **34,6%–75,6% de réduction de tokens** [1](https://recursivemas.github.io/) [2](https://arxiv.org/abs/2604.25917).

## 3.2 Patterns de collaboration supportés
La page officielle montre 4 styles :
- **Sequential**,
- **Mixture**,
- **Distillation**,
- **Deliberation** [1](https://recursivemas.github.io/) [3](https://github.com/RecursiveMAS/RecursiveMAS).

## 3.3 Effet de profondeur récursive
Les performances montent quand la profondeur de récursion augmente, alors qu’un équivalent **Recursive-TextMAS** tend à plafonner ou régresser, tandis que le gain de temps et la baisse de tokens s’accentuent avec `r` [1](https://recursivemas.github.io/) [2](https://arxiv.org/html/2604.25917v1).

## 3.4 Coût d’entraînement rapporté
La page officielle indique qu’avec seulement **~13,12M paramètres entraînables (0,31%)**, RecursiveMAS obtient la meilleure précision moyenne, avec mémoire GPU et coût estimé inférieurs aux alternatives LoRA et full SFT dans leur protocole [1](https://recursivemas.github.io/) [2](https://arxiv.org/html/2604.25917v1).

---

# 4. Pourquoi c’est intellectuellement important pour SCYForge

SCYForge est déjà pensé comme un produit à **13 agents spécialisés**. Donc la question n’est pas :

> “Est-ce que SCYForge est multi-agent ?”

La réponse est déjà oui.

La vraie question est :

> “Comment réduire le coût, la latence et la perte de signal informationnel dans les échanges entre agents ASCENT ?”

RecursiveMAS est intéressant parce qu’il affirme que le goulot d’étranglement principal du MAS n’est pas seulement la qualité des rôles, mais aussi le **médium de communication** [1](https://recursivemas.github.io/) [2](https://arxiv.org/abs/2604.25917).

Et ça, pour SCYForge, c’est extrêmement pertinent.

Pourquoi ?
Parce que chez toi, les agents s’échangent :
- objectifs,
- structures de graphe,
- coverage maps,
- scénarios,
- signaux de drift,
- scores de preuve,
- plans d’intervention,
- traces d’apprentissage.

Si tout cela reste du texte libre ou du JSON peu structuré, tu paies déjà une **taxe de sérialisation cognitive**.

---

# 5. Ce qu’il ne faut surtout pas mal comprendre

## 5.1 SCYForge ne peut pas adopter RecursiveMAS “tel quel” tout de suite

Le papier suppose :
- accès aux **hidden states** des modèles,
- capacité de passer ces états entre modèles,
- parfois entraînement léger de modules de projection,
- environnement de recherche / GPU local / modèles ouverts [2](https://arxiv.org/abs/2604.25917) [3](https://github.com/RecursiveMAS/RecursiveMAS).

Or SCYForge aujourd’hui est architecturé autour :
- d’agents orchestrés,
- probablement souvent via APIs ou couches d’abstraction agentiques,
- et d’objets métier / pipelines, pas de liens latents entraînés entre modèles.

Donc :

> **tu ne dois pas confondre inspiration architecturale et adoption littérale.**

## 5.2 Le bon move n’est pas “on remplace tout par du latent handoff”

Pour SCYForge, le produit vend :
- de l’auditabilité,
- de la preuve,
- de la traçabilité,
- de l’explicabilité B2B.

Or les échanges latents purs sont précisément **moins interprétables** que des messages structurés.
Un bon article d’analyse souligne d’ailleurs que la communication latente mangera une partie du travail multi-agent, **mais pas les zones qui touchent à la gouvernance, l’audit ou la revue humaine** [5](https://ai.rundatarun.io/ai-development-agents/recursive-mas-latent-space-agent-communication).

Pour SCYForge, ça tombe pile sur la bonne frontière.

---

# 6. La bonne lecture stratégique pour SCYForge

RecursiveMAS n’est pas une invitation à rendre SCYForge opaque.
C’est une invitation à faire apparaître une **architecture de communication à deux vitesses**.

## Couche 1 — Fast internal agentic channel
Canal interne compact, itératif, récursif, à faible coût, non destiné à l’audit humain.

## Couche 2 — Auditable semantic trace
Canal externe / persistant / gouverné, destiné à :
- l’explication,
- le ledger,
- la preuve,
- le manager,
- la certification,
- la conformité.

### Traduction simple
À l’intérieur, les agents peuvent collaborer avec des représentations plus denses et plus compressées.
À l’extérieur, SCYForge doit continuer à produire des objets explicables.

C’est exactement le bon compromis pour toi.

---

# 7. Modèle d’adaptation recommandé pour SCYForge

Je recommande de ne **pas** viser une implémentation “true latent RecursiveMAS” comme premier move.
Je recommande un modèle en **3 paliers**.

---

## Palier 1 — Pseudo-RecursiveMAS sémantique

### Principe
On garde des APIs / agents standards, mais on remplace les messages libres par un **canal de handoff compact, typed, récursif et non narratif**.

### Ce que ça veut dire
Au lieu que les agents se passent :
- des paragraphes,
- des prompts complets,
- des résumés verbeux,

ils se passent des objets compacts comme :
- `GoalStateDelta`
- `CoverageDelta`
- `MasteryGraphDelta`
- `ScenarioEligibilitySignal`
- `ProofGapVector`
- `InterventionProposal`
- `DriftRiskVector`

### Bénéfice
Tu réduis déjà :
- la verbosité inter-agent,
- le coût token,
- la latence,
- la dérive sémantique,
- la perte d’information métier.

### Point fondamental
Ce n’est pas latent au sens papier.
Mais c’est **structurellement homologue** à RecursiveMAS :

> on remplace le texte discursif inter-agent par une représentation compacte récurrente.

Et ça, tu peux l’implémenter beaucoup plus tôt.

---

## Palier 2 — Recursive state loop au niveau noyau

### Principe
On introduit une **boucle récursive de raffinement d’état**, non pas sur des hidden states, mais sur des **state bundles noyau**.

Par exemple, pour une session ASCENT :
1. GOAL produit un `GoalState`.
2. CONTENT enrichit en `EvidenceState`.
3. DAG compile un `MasteryGraphState`.
4. PERFORMANCE / ROUTER / VALIDATOR évaluent.
5. Le système reboucle avec un `SystemRefinementState`.

### Résultat
On obtient déjà une forme de :
- récursion inter-agent,
- raffinement progressif,
- amélioration par rounds,
- sans dépendre d’un accès latent interne au modèle.

### Nom recommandé chez SCYForge
Je te recommande un nom explicite comme :

> **Recursive Cognitive State Loop (RCSL)**

C’est plus honnête que de prétendre faire RecursiveMAS full-stack dès maintenant.

---

## Palier 3 — Latent bridge expérimental local

### Principe
Plus tard, sur un sous-système précis, tu peux tester une vraie version inspirée de RecursiveMAS avec modèles ouverts locaux.

### Les meilleurs candidats chez SCYForge
Pas tout ASCENT d’un coup.
Seulement certains sous-circuits très coûteux et très internes, par exemple :

#### A. GOAL → DAG → VALIDATOR
pour compiler plus vite un graphe de maîtrise à partir d’un objectif.

#### B. CONTENT → ONTOLOGY → SCENARIO
pour transformer les corpus cyber en scénarios et nœuds de preuve.

#### C. PERFORMANCE → ROUTER → CERTIFIER
pour raffiner l’état de maîtrise et le verdict readiness.

### Pourquoi ces sous-circuits
Parce qu’ils ont :
- forte densité d’échanges,
- besoin de cohérence forte,
- peu de besoin d’explicabilité à chaque micro-pas,
- mais besoin d’explicabilité sur le résultat final.

---

# 8. Où RecursiveMAS colle le mieux à SCYForge

## 8.1 Le pattern Sequential
RecursiveMAS montre qu’un pattern **Planner → Critic → Solver** séquentiel récursif fonctionne bien [1](https://recursivemas.github.io/) [2](https://arxiv.org/html/2604.25917v1).

Chez SCYForge, tu as déjà des circuits analogues :
- GOAL-INTERPRETER,
- DAG-ARCHITECT,
- COGNITIVE-VALIDATOR,
- VISUAL-CRITIC,
- PERFORMANCE-ANALYZER.

### Adaptation évidente
Créer un **loop séquentiel de compilation** :
- Agent 1 : formulation / cadrage,
- Agent 2 : critique structurelle,
- Agent 3 : compilation finale,
- boucle de 2–3 rounds max.

C’est probablement l’adaptation la plus naturelle.

---

## 8.2 Le pattern Mixture
RecursiveMAS supporte un pattern mélange d’experts + summarizer [1](https://recursivemas.github.io/) [3](https://github.com/RecursiveMAS/RecursiveMAS).

Chez SCYForge, ça colle très bien à :
- spécialiste ontologie,
- spécialiste corpus,
- spécialiste scénarios,
- spécialiste proof rubric,
- puis agrégateur.

### Cas cyber très fort
Pour un onboarding SOC L1, tu pourrais faire collaborer :
- un spécialiste ATT&CK,
- un spécialiste Sigma / détection,
- un spécialiste IR / procédure,
- un spécialiste pédagogie / mastery graph,
- puis un agent de synthèse qui génère le plan de maîtrise.

Ça, c’est très SCYForge-compatible.

---

## 8.3 Le pattern Distillation
RecursiveMAS montre un pattern Expert ↔ Learner pour améliorer un petit modèle tout en gardant de l’efficacité [1](https://recursivemas.github.io/) [3](https://github.com/RecursiveMAS/RecursiveMAS).

Chez SCYForge, c’est intéressant à 2 niveaux :

### A. Niveau système
Un agent “expert” coûteux construit la structure ou les scénarios, un agent “learner” moins coûteux exécute la majorité des cas standards.

### B. Niveau produit
Ça colle métaphoriquement à ton produit lui-même :
- expert senior interne,
- recrue SOC,
- transfert structuré vers autonomie.

### Opportunité très concrète
Le pattern de distillation pourrait inspirer un moteur où :
- les premiers design partners utilisent pipeline “expert-heavy”,
- puis SCYForge apprend à externaliser des politiques plus légères pour les cas fréquents.

---

## 8.4 Le pattern Deliberation avec outils
RecursiveMAS montre que la récursion latente reste utile même en configuration avec outils [1](https://recursivemas.github.io/) [3](https://github.com/RecursiveMAS/RecursiveMAS).

C’est important pour toi parce que SCYForge n’est pas purement conversationnel.
Il orchestre aussi :
- retrieval,
- graphes,
- scoring,
- simulations,
- policies,
- potentiellement code et règles.

Donc l’adaptation à SCYForge doit être pensée comme :

> **recursive orchestration over tool-using agents**, pas juste dialogue entre prompts.

---

# 9. Cas d’usage SCYForge où RecursiveMAS a le plus de valeur

## Cas 1 — Compilation du Mastery Graph à partir d’un corpus cyber privé
Problème actuel potentiel :
- beaucoup d’échanges,
- risque de résumés textuels redondants,
- difficulté à préserver les signaux rares.

### Apport inspiré RecursiveMAS
- boucle compacte Ontology ↔ Corpus ↔ Graph ↔ Validator,
- plusieurs rounds de raffinement,
- réduction de la “taxe textuelle” interne.

## Cas 2 — Génération d’un scénario ARENA crédible et scoré
Problème actuel potentiel :
- besoin de cohérence entre signaux, décisions, rubric, erreurs critiques.

### Apport
- specialist mixture,
- boucle de critique et raffinement,
- sortie finale textuelle uniquement au dernier moment.

## Cas 3 — Calcul d’un verdict readiness borné
Problème actuel potentiel :
- le verdict doit agréger beaucoup de signaux, sans bruit narratif.

### Apport
- état de preuve compact,
- rounds d’agrégation / critique / validation,
- exposition textuelle seulement en fin de pipeline.

## Cas 4 — Remédiation adaptative
Problème actuel potentiel :
- beaucoup de micro-décisions coûteuses si tout est verbalisé.

### Apport
- boucle Router ↔ Performance ↔ Retention ↔ Validator sur état compact,
- possibilité de multi-round refinement avant intervention visible.

---

# 10. Ce qu’il faut conserver en texte chez SCYForge

Très important : tout ne doit pas devenir compact ou pseudo-latent.

Il faut garder en texte / objets explicables :
- les traces de preuve,
- les justifications de verdict,
- les explications au manager,
- les certificats et scopes d’autonomie,
- les scénarios exportables,
- les feedbacks apprenant,
- l’audit trail.

### Formule de design
Je te recommande cette formule :

> **communication interne dense, sortie externe sparse et explicable**.

Ou plus opérationnellement :

> **compress inside, justify outside**.

C’est probablement la meilleure façon de capter la valeur de RecursiveMAS sans tuer la gouvernance de SCYForge.

---

# 11. Architecture d’adaptation recommandée pour SCYForge

## 11.1 Nouveau concept : Agent Communication Substrate

Créer une couche transversale dédiée, par exemple :

> `Agent Communication Substrate (ACS)`

Cette couche ne remplace pas les agents.
Elle remplace **la manière dont ils se parlent**.

### Ses modes

#### Mode A — `text_trace`
Message explicite, lisible, utile pour audit / debug / UI.

#### Mode B — `structured_compact`
Objet compact, typé, non narratif, optimisé pour coordination.

#### Mode C — `recursive_state`
Bundle de state passé et raffiné sur plusieurs rounds.

#### Mode D — `latent_bridge_experimental`
À très long terme, pour sous-systèmes locaux avec open models.

---

## 11.2 Objet pivot recommandé : `AgentStatePacket`

```ts
interface AgentStatePacket {
  packetId: string;
  workflowId: string;
  round: number;
  senderAgent: string;
  receiverAgent: string;
  packetMode: 'text_trace' | 'structured_compact' | 'recursive_state';
  goalId?: string;
  nodeIds?: string[];
  domainRefIds?: string[];
  payload: Record<string, unknown>;
  confidence?: number;
  traceRefs?: string[];
  createdAt: string;
}
```

### Intuition
Ce n’est pas du latent réel.
Mais c’est le premier vrai support d’une communication **non bavarde, récursive, versionnable**.

---

## 11.3 Primitive de boucle recommandée : `RecursiveRoundController`

```ts
interface RecursiveRoundController {
  runRound(input: RecursiveWorkflowState): Promise<RecursiveWorkflowState>;
  shouldContinue(state: RecursiveWorkflowState): boolean;
  finalize(state: RecursiveWorkflowState): Promise<FinalizedAgentOutcome>;
}
```

### Usage
- exécuter 2–3 rounds max,
- stopper si convergence,
- stopper si gain marginal trop faible,
- stopper si validation garde-fous échoue.

---

# 12. Risques d’implémentation dans SCYForge

## Risque 1 — sur-fétichiser le latent
Le papier est brillant, mais le “latent” n’est pas une religion produit.
Ce qui compte, c’est le **ratio signal/coût**.

## Risque 2 — perdre la gouvernance
Un système purement opaque est incompatible avec ton ambition B2B readiness / proof-of-skill.

## Risque 3 — essayer de tout convertir d’un coup
Mauvaise idée.
Il faut commencer par un **micro-circuit interne**.

## Risque 4 — confondre compression et intelligence
Un message compact mal défini peut être pire qu’un texte clair.
La structuration doit être bonne.

## Risque 5 — ignorer l’observabilité
Toute expérimentation “RecursiveMAS-inspired” doit garder une shadow trace textuelle ou structurée pour debug.

---

# 13. Recommandation de mise en œuvre réaliste pour SCYForge

## Étape 1 — Ne pas faire de latent, faire du compact structuré
Créer un protocole de handoff inter-agent compact entre 3 agents pilotes :
- GOAL-INTERPRETER
- DAG-ARCHITECT
- COGNITIVE-VALIDATOR

## Étape 2 — Ajouter des rounds récursifs courts
Exécuter 2 ou 3 tours de raffinement avec critère de convergence.

## Étape 3 — Mesurer
Comparer contre le mode textuel actuel sur :
- latence,
- coût tokens,
- cohérence du graphe,
- taux de correction du validator,
- qualité perçue du plan final.

## Étape 4 — Étendre au pipeline scénario
Ensuite seulement :
- CONTENT-SCOUT
- ONTOLOGY / VALIDATION
- ARENA blueprint generation

## Étape 5 — Envisager un bridge plus profond
Uniquement si :
- tu passes sur des modèles ouverts locaux,
- tu as un vrai bénéfice démontré,
- tu peux contenir la complexité infra.

---

# 14. Verdict stratégique

RecursiveMAS est **hautement pertinent** pour SCYForge, mais pas comme gadget de recherche.
Il est pertinent parce qu’il te donne un langage beaucoup plus précis pour résoudre un vrai problème :

> comment faire collaborer des agents spécialisés sans payer à chaque hop un coût cognitif, tokenique et sémantique absurde ?

Mais il faut l’adapter avec discipline.

La bonne adaptation à SCYForge n’est pas :
- “tout latent”,
- “tout opaque”,
- “on copie le papier”.

La bonne adaptation est :

> **une communication interne récursive, compacte, typée et itérative, avec une couche externe de preuve et d’audit explicable.**

C’est ça la version SCYForge-native de RecursiveMAS.

---

# 15. Décision recommandée

## Décision court terme
Oui, il faut intégrer l’idée RecursiveMAS dans SCYForge.

## Mais sous la forme de
### **SCYForge Recursive Communication Layer (RCL)**
avec 3 niveaux :
1. `structured_compact handoff`
2. `recursive state refinement`
3. `latent bridge experimental` plus tard

## Pourquoi
Parce que ça te permet :
- d’adopter le principe fort maintenant,
- sans attendre une infra de recherche lourde,
- sans perdre l’auditabilité B2B,
- et sans retarder le refactor des agents.

---

# Sources
- RecursiveMAS project page officielle [1](https://recursivemas.github.io/)
- arXiv abstract officiel [2](https://arxiv.org/abs/2604.25917)
- arXiv HTML détaillé [3](https://arxiv.org/html/2604.25917v1)
- GitHub officiel RecursiveMAS [4](https://github.com/RecursiveMAS/RecursiveMAS)
- Analyse production / gouvernance sur communication latente [5](https://ai.rundatarun.io/ai-development-agents/recursive-mas-latent-space-agent-communication)
- VentureBeat summary sur speed/token gains [6](https://venturebeat.com/orchestration/how-recursivemas-speeds-up-multi-agent-inference-by-2-4x-and-reduces-token-usage-by-75)
- Taxonomie des protocoles de communication d’agents LLM [7](https://arxiv.org/abs/2606.19135)
- Survey communication patterns / MCP [8](https://arxiv.org/pdf/2506.05364)
- Recursive Agent Harnesses comme angle complémentaire sur la récursion agentique avec outils [9](https://arxiv.org/html/2606.13643)
- MAS² comme référence sur récursion au niveau conception de MAS [10](https://arxiv.org/abs/2509.24323)

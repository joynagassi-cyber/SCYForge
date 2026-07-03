# SCYForge — Validation court terme ASCENT + Semantic Tree + GFE

> **Statut** : IN_MVP / protocole de validation court terme  
> **But** : valider le noyau `ASCENT + Semantic Tree + GFE` sans les 11 cores, sans multi-domaine, sans COSMOS complet.  
> **Horizon** : première preuve utilisable en démo/pilote, pas architecture finale.

---

## 1. Decision de cadrage

La validation court terme ne cherche pas à prouver toute la plateforme. Elle cherche à prouver une boucle unique :

```
Domain Pack pre-cure
  -> Semantic Tree SOC L1
  -> ASCENT choisit et evalue une intervention
  -> ARENA produit une trace de decision
  -> GFE observe l'arbre et propose des Seeds dormantes
```

Le produit est credible a court terme si cette boucle montre trois choses :

1. **ASCENT transforme un role en preuve de maitrise**, pas en contenu generique.
2. **Semantic Tree est le substrat unique**, pas une simple visualisation.
3. **GFE produit de la nouveaute filtree**, pas du texte libre ni des suggestions non verifiables.

---

## 2. Non-objectifs immediats

Ces elements sont explicitement hors validation court terme :

- Les 11/13 ingestion cores generiques.
- NEURON-CHAINS complet et tools T01-T18.
- COSMOS 26 modes ou catalogue VizSpec complet.
- Multi-tenant avance, multi-domaine, B2B creator console.
- FSRS 5.0 complet.
- Germination automatique des Seeds GFE.
- Certification commerciale ou claim "autonome" en production.

Le court terme accepte un corpus pre-cure et des scenarios preconstruits. Cela reduit le bruit et force la validation du noyau.

---

## 3. Slice de validation

| Dimension | Choix court terme |
|---|---|
| Domaine | Cyber beachhead |
| Role | SOC L1 uniquement |
| Corpus | Pack pre-cure : ontologie + quelques sources + 1 scenario hero |
| Arbre | Sous-arbre SOC L1, racine ATT&CK/blue-team, 15 a 30 noeuds utiles |
| Scenario | 1 scenario ARENA-lite, decisionnel, avec rubric explicite |
| Evaluation | Decision trace + score rubric + statut par noeud |
| GFE | Mode observatoire : Seeds scorees, stockees, non germees |
| Interface | Vue arbre + progression + scenario + rapport de preuve minimal |

---

## 4. Hypotheses falsifiables

### H1 — ASCENT

**Hypothese.** Un objectif de role SOC L1 peut etre compile en parcours de maitrise et en preuve exploitable sans generer un cours.

**Preuve minimale.**

- `GoalSpec` resolu vers un role et un perimetre.
- `MasteryGraph` produit avec noeuds prouvables, pas seulement themes.
- `InterventionDecision` pointe vers un noeud precis et une action.
- `ScenarioTrace` contient les decisions observees.
- `ReadinessVerdict` est borne : role, classe d'alerte, risque, preuves, limites.

**Refutation.**

- Le systeme produit surtout du contenu a lire.
- Le score final est global et non borne.
- Le scenario n'a pas de rubric ni de trace decisionnelle.

### H2 — Semantic Tree

**Hypothese.** Le Semantic Tree peut servir de source de verite unique pour le role, l'etat apprenant, le scenario et la preuve.

**Preuve minimale.**

- Un `SemanticTree` peut etre charge depuis le pack.
- Les noeuds ont `confidence`, `depth`, `metadata` et relations typees.
- `Plant`, `Graft`, `Test`, `Prune`, `Myelinate` existent au niveau contrat ou prototype.
- Le gating `tronc avant feuilles` est applique : un enfant n'est pas accessible si le parent n'est pas maitrise.
- La vue front lit l'etat de l'arbre, elle ne maintient pas un etat parallele.

**Refutation.**

- L'arbre sert seulement de diagramme.
- Les scenarios et les scores vivent hors arbre.
- La progression visuelle peut depasser la maitrise prouvee.

### H3 — GFE

**Hypothese.** Le GFE peut generer des Seeds utiles a partir du Semantic Tree sans polluer le parcours de maitrise.

**Preuve minimale.**

- Chaque Seed a deux parents dans l'arbre.
- Chaque Seed a un score L1-L4 : distance, pont logique, nouveaute, alignement Vision Helm.
- Chaque Seed a un statut : `pollinated`, `dormant`, `viable`, `rejected`.
- Aucune Seed ne modifie l'arbre sans validation humaine.
- Le systeme distingue clairement "idee interessante" et "nouvelle branche plantable".

**Refutation.**

- Le GFE produit du texte generatif sans provenance.
- Les Seeds sont promues sans reviewer.
- Le score de nouveaute ne verifie pas l'absence du lien initial.

---

## 5. Agents ASCENT a garder pour le MVP de validation

On ne valide pas les 13 agents en profondeur. On valide la chaine fonctionnelle minimale :

| Agent / fonction | Role dans la preuve | Sortie attendue |
|---|---|---|
| GOAL-INTERPRETER | Role brut -> objectif borne | `GoalSpec` |
| DAG-ARCHITECT | Objectif -> graphe de maitrise | `MasteryGraph` |
| LEARNING-CONDUCTOR | Choix de la prochaine action | `InterventionDecision` |
| PERFORMANCE-ANALYZER | Agrege les traces | `MasteryState` |
| SKILL-CERTIFIER | Verdict borne | `ReadinessVerdict` |
| ARENA | Produit l'epreuve active | `ScenarioTrace` |

Les autres agents peuvent rester simules, stubbes ou non inclus tant que leur absence ne casse pas la boucle.

---

## 6. Donnees minimales a produire

```ts
interface GoalSpec {
  roleId: string
  targetScope: string[]
  proofBoundary: string
}

interface MasteryNode {
  id: string
  label: string
  parentIds: string[]
  proofRequirement: string
  confidence: number
  locked: boolean
}

interface ScenarioTrace {
  scenarioId: string
  nodeIds: string[]
  decisions: DecisionEvent[]
  rubricScore: number
}

interface ReadinessVerdict {
  roleId: string
  scope: string
  mode: "not_ready" | "shadow" | "guarded" | "autonomous"
  evidenceRefs: string[]
  limitations: string[]
}

interface Seed {
  id: string
  parentA: string
  parentB: string
  status: "pollinated" | "dormant" | "viable" | "rejected"
  scores: {
    distance: number
    bridge: number
    novelty: number
    helmAlignment: number
    viability: number
  }
  reviewerNote?: string
}
```

---

## 7. Criteres de sortie

La validation court terme est reussie si :

- Un manager peut voir la valeur en moins de 30 minutes.
- Un role SOC L1 charge un sous-arbre lisible et borne.
- Un apprenant ne peut pas ouvrir une feuille verrouillee par un parent non maitrise.
- Un scenario produit une trace de decisions et un verdict borne.
- Une preuve relie `GoalSpec`, `MasteryNode`, `ScenarioTrace` et `ReadinessVerdict`.
- Le GFE produit au moins 3 Seeds dormantes avec parents, scores et justification.
- Aucune Seed ne modifie l'arbre sans validation humaine.

La validation echoue si :

- La demo ressemble a un chatbot ou a un LMS.
- L'arbre est joli mais non contraignant.
- Le verdict de maitrise est global, vague ou non auditable.
- Le GFE produit des idees sans provenance, sans score, ou sans statut.

---

## 8. Ordre d'implementation recommande

1. **Semantic Tree en premier** : charger un sous-arbre fixe SOC L1, appliquer le gating et exposer l'etat.
2. **ASCENT-lite ensuite** : compiler objectif -> noeuds -> intervention -> verdict borne.
3. **ARENA-lite** : une epreuve decisionnelle qui ecrit une `ScenarioTrace`.
4. **GFE observatoire** : generer et scorer des Seeds, sans germination.
5. **Front de validation** : une vue qui montre l'arbre, le noeud actif, la trace et les Seeds.

Ce sequenceur force l'infrastructure cognitive avant l'interface et evite de construire une couche visuelle sans preuve.

---

## 9. Ajustements scientifiques obligatoires

- Toute progression doit etre liee a une action observable, pas a une lecture.
- Le score doit separer memoire, jugement, justification et respect du processus.
- La confiance affichee doit etre inferieure ou egale a la maitrise prouvee.
- Un resultat simule ne doit jamais etre vendu comme transfert reel.
- Le GFE est un prefiltre d'innovation ; seul un reviewer humain peut transformer une Seed en branche plantable.

---

## 10. Definition de la promesse court terme

Promesse validee si on peut dire :

> "A partir d'un pack cyber pre-cure, SCYForge construit un arbre de maitrise SOC L1, force une progression tronc-avant-feuilles, mesure une decision sous scenario, produit un verdict borne, puis detecte des pistes d'innovation dormantes sans polluer l'arbre."

Cette promesse est suffisamment forte pour une demo et suffisamment limitee pour rester defendable.

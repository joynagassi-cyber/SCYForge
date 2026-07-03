# SCYFORGE — ARENA Simulation Engine (power-up)

> **Statut** : v0.5 — document vivant (recherche + modélisation). Chantier **R7 / axe ARENA**.
> **Portée** : modéliser *comment* Ag-11 (ARENA) met la recrue sous pression, en s'appuyant sur l'existant du marché cyber, **sans jamais construire une plateforme de cybersécurité** et **sans violer la règle d'or du pivot** (aucun terme cyber en dur dans ARENA — cf. rapport §4.1 / §4.5).
> **Ancrages** : rapport §4.2 (Ag-11 ARENA, `DecisionScenarioProvider`), §4.3 (`CognitiveFrictionPolicy`, `SparringPolicy`), §4.5 (test de vérité), §6 (rubriques), §10 ontologie (5 scénarios `SCN-*`), Ag-06 ADAPTIVE-ROUTER.

---

## 0. Décisions verrouillées (session courante)

| # | Décision | Statut |
|---|---|---|
| D1 | **Échelle de fidélité L1→L4** (chaque nœud reçoit sa meilleure modalité, **zéro trou**) plutôt qu'un binaire 80/20. | ✅ retenu |
| D2 | **L4 (live-fire) inclus au MVP** — mais par **wrapping d'existant** (API), jamais par construction d'infra. | ✅ retenu |
| D3 | Le "80% de couverture" devient la **cible L3+** (vraie simulation) ; L1/L2 garantissent le **plancher 100%** (tout nœud reste testable). | ✅ retenu |
| D4 | **L4 pleinement validé** : les 5 scénarios `SCN-*` visent le live-fire, pas seulement un chemin vertical. L'intégration L4 doit être **unifiée** (un seul adaptateur, pas du sur-mesure par scénario). | ✅ retenu |
| D5 | L'intégration L4 passe par une **couche d'adaptation unique** (`RangeAdapter`) + des **recettes de range** déclaratives fournies par le pack. Simple, personnalisable, réutilisable par tout secteur. | ✅ retenu |
| D6 | **Socle L4 100% open-source validé** (Q-A5 tranchée). On assemble un écosystème open-source ; aucun range commercial pour le MVP. | ✅ retenu |
| D7 | **Scope du MVP = sous-ensemble SOC L1** de la taxonomie des compétences (§11). Les domaines hors SOC L1 (Cloud, sécurité IA/LLM, Zero Trust/IAM, GRC, AppSec) = **horizon d'expansion** (autres packs / post-MVP), pas abandonnés. La taxonomie reste **entière** comme référentiel ; c'est le MVP qui est scopé, pas la vision. | ✅ retenu |
| D8 | **La taxonomie des compétences 2026 est le cahier des charges employeur.** Elle n'est pas une liste de référence académique : ce sont les compétences que les entreprises recherchent chez leurs recrues en 2026. Elle est donc le **référentiel de marché** contre lequel SCYFORGE mesure sa couverture, la temporalité de son Semantic Tree (`skill_era`), et son positionnement commercial. | ✅ retenu |
| D9 | **La couverture « 80% » est pondérée par règles, pas par comptage de nœuds** (§12). Trois règles : R1 criticité marché (`trunkPriority` → poids ×1.0..×3.0), R2 nouveauté 2026 (`skill_era` → +20%), R3 fidélité atteinte (L1=0.25 / L2=0.50 / L3=0.85 / L4=1.0). La formule est **data-driven** (constantes dans le pack) et pilotée par ADAPTIVE-ROUTER (Ag-06). | ✅ retenu |

---

## 1. Le problème, reformulé

Tu ne connais pas la cybersécurité et tu ne veux **pas** bâtir une plateforme de simulation cyber. Objectif long terme : **s'étendre à tous les secteurs**. Donc la stratégie n'est pas « coder des simulations », mais :

1. **Cartographier** les moteurs/plateformes cyber existants (open-source + commerciaux).
2. **Wrapper** le plus complet / combiner plusieurs pour viser **~80% des tests** qu'une entreprise voudrait pour évaluer une recrue.
3. Là où on ne couvre pas en simulation → **fallback IA (Teach-Student) + mini-exams scénarisés (QCM)** pilotés par l'agent ARENA.

**Reformulation en une phrase :** ARENA n'*héberge* pas les simulations, il **route chaque nœud décisionnel vers la meilleure modalité disponible** et **comble les trous par de l'IA**. C'est un *power-up* d'orchestration, pas une infra de sécurité.

---

## 2. Principe d'architecture non négociable

> **ARENA (Ag-11) reste agnostique.** Grep `MITRE / Caldera / Sigma / SIEM / SOC` dans le code d'ARENA = **violation de contrat** (règle d'or, rapport §4.1).

Conséquence directe : les moteurs cyber ne se branchent **jamais** dans ARENA. Ils se branchent dans les **providers du Domain Pack**. ARENA ne connaît que des **abstractions de fidélité**.

```
KERNEL (agnostique)                 DOMAIN CONTRACT (ports)            CYBER PACK (artefacts)
──────────────────                  ────────────────────────          ─────────────────────
Ag-11 ARENA                         DecisionScenarioProvider    ◄──    SCN-* (§10) + adversaires
  └─ SimulationFidelityRouter  ───► ProofRubricProvider         ◄──    rubriques §6
       (choisit L1..L4)             OntologyProvider            ◄──    ATT&CK B1-B6
                                    [NOUVEAU] LiveRangeProvider  ◄──    wrappers Caldera / K8s range
                                    [NOUVEAU] AssessmentProvider ◄──    gabarits QCM / teachback
```

**Ce qui rend le power-up scalable à tous les secteurs :** l'échelle L1→L4 et le `SimulationFidelityRouter` sont de l'**infra agnostique**. Seul le *contenu* de chaque barreau vient du pack. Médecine / finance / juridique → on swap le pack, **ARENA et l'échelle ne bougent pas** (test de vérité §4.5 respecté).

---

## 3. L'échelle de fidélité L1→L4 (cœur du modèle)

Chaque **nœud décisionnel** du tronc (critère C4 : « porte au moins une décision ») reçoit la **modalité la plus haute disponible**. Fidélité décroissante, coût décroissant, disponibilité croissante :

| Niveau | Nom | Ce que la recrue fait | D'où vient le contenu | Coût / infra | Dispo |
|---|---|---|---|---|---|
| **L4** | **Live-fire** | Agit dans un vrai stack (SIEM/EDR + adversaire réel) | `LiveRangeProvider` (wrapper Caldera + range éphémère) | Élevé (conteneurs/K8s) | Partielle |
| **L3** | **Scénario déterministe** | Suit un arbre de décision scripté, rejouable | `DecisionScenarioProvider` → `SCN-*` (§10, **déjà faits**) | Faible (JSON/état) | Bonne |
| **L2** | **Sim IA branchée** | Dialogue/décisions dans un récit généré, ancré corpus | Agent ARENA + `CorpusProvider` + `SparringPolicy` | Faible (LLM) | Totale |
| **L1** | **QCM / mini-exam** | Répond à des questions scénarisées | `AssessmentProvider` (nœud + rubrique → items) | Très faible | **Toujours** |

### 3.1 Règle de routage (agnostique)
```
pour un nœud N :
  fidélité_visée = ADAPTIVE-ROUTER(Ag-06)  // selon perf / confusion / fatigue / risque
  modalité = SimulationFidelityRouter.resolve(N, fidélité_visée)
             = max niveau réellement offert par les providers pour N, ≤ fidélité_visée
  # L1 est le plancher garanti → aucun nœud sans test
```
- **80% = part des nœuds atteignant L3+** (objectif de couverture « vraie simulation »).
- **100% = plancher L1** : même un nœud sans scénario ni range reste **testable** (QCM + teachback).
- **Zéro trou** : le trou de simulation n'est jamais un trou d'évaluation.

### 3.2 Qui choisit le niveau ?
- **ADAPTIVE-ROUTER (Ag-06)** : monte la fidélité quand la maîtrise progresse ; redescend en remédiation.
- **`CognitiveFrictionPolicy`** : calibre la difficulté *dans* le niveau (injects plus durs, temps plus court).
- **`SparringPolicy`** : en L2, l'IA devient contradicteur/évaluateur.
- **`SemanticTreePriorityPolicy`** : les nœuds ★★★★★ du tronc sont prioritaires pour atteindre L3/L4.

---

## 4. Cartographie du marché (recherche R7-ARENA)

Le paysage se range en **4 familles**, qui s'alignent presque 1:1 sur l'échelle L1→L4 — d'où la pertinence du wrapping.

| Famille | Exemples repérés | Mappe sur | Ce qu'on en fait |
|---|---|---|---|
| **Cyber ranges live-fire** | Cyberbit, Immersive Labs, Hack The Box (Threat Range), RangeForce | **L4** | Wrapper commercial (cher, différé au-delà du pilote). |
| **Adversary emulation** | MITRE **Caldera** (agent, chaîné, **API REST v2**), **Atomic Red Team** (tests atomiques mappés ATT&CK) | **L4** (moteur de vérité) | **Socle L4 recommandé** : open-source, mappé ATT&CK, pilotable par API. |
| **Stacks SOC open-source** | Advanced/Autonomous SOC Lab (OpenSearch + Caldera + Wazuh/Velociraptor) | **L4** (télémétrie) | Fournit le SIEM que la recrue interroge pendant l'emulation. |
| **Provisioning éphémère** | Guacamole (SSH/VNC/RDP navigateur), EDURange Cloud, K3s controller-worker | **L4** (accès) | Range jetable par session, accès navigateur, détruit après. |
| **Training scénarisé + IA** | SOC Training Simulator (mentor socratique + scénarios), TryHackMe | **L2/L3** | Inspiration pour nos `SCN-*` et le teachback IA. |

### 4.1 Choix d'intégration L4 pour le MVP (wrapping, pas construction)
- **Moteur d'adversaire** : **MITRE Caldera** via **API REST v2** (`POST /api/v2/operations`, `PATCH … state=running`). Headless, dockerisable, résultats récupérables → parfait pour piloter depuis le `LiveRangeProvider`.
- **Télémétrie / SIEM** : **OpenSearch** (ou Wazuh) que la recrue interroge → produit les « injects » réels.
- **Accès navigateur éphémère** : **Guacamole** + range K3s jetable (patterns EDURange / controller-worker).
- **Vérité ATT&CK** : **Atomic Red Team** pour les techniques atomiques mappées aux tactiques B1-B6 (§10 ontologie).

> ✅ **Q-A1 tranchée (D4) : L4 pleinement validé.** Les 5 scénarios `SCN-*` visent le live-fire. Pour tenir cela **sans exploser l'infra ni multiplier le sur-mesure**, l'intégration passe par **une seule couche d'adaptation** (`RangeAdapter`) et des **recettes de range déclaratives** (§10). Le coût n'est plus « 5 intégrations » mais « 1 adaptateur + 5 recettes de données ». C'est ce qui rend L4 **simple, unifié et réutilisable par tout secteur**.

---

## 5. Contrats de providers (ports à ajouter / préciser)

### 5.1 `DecisionScenarioProvider` (existant — L3)
Déjà alimenté par les 5 `SCN-*` (§10). Rien à changer côté noyau. Reste : projeter injects/valeurs attendues sur les SOP réelles du tenant (principe médiateur §4.6).

### 5.2 `LiveRangeProvider` (NOUVEAU — L4) — *esquisse agnostique*
```ts
interface LiveRangeProvider {
  // agnostique : "capability" décrit ce que le nœud exige, pas de terme cyber
  supports(nodeId: string, capability: DecisionCapability): boolean
  provision(sessionId: string, nodeId: string): Promise<RangeHandle>   // wrap: spin-up range + adversaire
  observe(handle: RangeHandle): AsyncIterable<Inject>                  // wrap: télémétrie SIEM → injects
  submitAction(handle: RangeHandle, action: LearnerAction): ActionOutcome
  teardown(handle: RangeHandle): Promise<void>                         // provisionner → détruire
}
```
Le **Cyber Pack** implémente ce port en appelant Caldera/OpenSearch/Guacamole. Le noyau ne voit que `RangeHandle`, `Inject`, `LearnerAction`, `ActionOutcome` — **zéro terme cyber**.

### 5.3 `AssessmentProvider` (NOUVEAU — L1/L2) — *esquisse agnostique*
```ts
interface AssessmentProvider {
  buildQuiz(nodeId: string, rubric: ProofRubricRef): QuizSpec          // L1 : nœud + rubrique → items
  buildBranchedSim(nodeId: string, corpusRef): BranchedSimSpec         // L2 : récit ancré corpus
  gradeTeachback(response, rubric: ProofRubricRef): TeachbackVerdict   // Teach-Student AI
}
```
> **Anti-triche / anti-illusion de compétence** : L1/L2 doivent produire des items **non triviaux** (distracteurs plausibles issus des pièges des `SCN-*`, ex. « clôturer sur c'est juste un doc »). Sinon la gate d'autonomie devient un QCM cadeau. **À concevoir (Q-A2).**

---

## 6. Traçabilité vers la preuve d'autonomie (§6 + §13)

Quel que soit le niveau L1→L4, la sortie d'ARENA doit alimenter les **mêmes dimensions de rubrique** (§6) pour rester comparable :

| Dimension §6 | L4 live-fire | L3 scénario | L2 sim IA | L1 QCM |
|---|---|---|---|---|
| Exactitude verdict | actions réelles observées | branche choisie | choix narratif | réponse |
| Justesse escalade | escalade dans le stack | branche escalade | décision IA | réponse |
| Traçabilité | logs range rejouables | trace scénario | transcript | — (faible) |
| Tenue sous pression | chrono réel + bruit | chrono scénario | friction IA | temps limité |

> **Règle de certification (rapport §4.4)** : *pas de certif sans scénario branché.* Donc une cellule d'`Autonomy Envelope` ne passe `autonomous` que si elle a été testée **au moins en L3** ; L1/L2 seuls → plafond `guarded`. `SCN-ESCAL-05` reste le **scénario-plafond** (§10, note gate). **À confirmer (Q-A3).**

---

## 7. Impact déterminisme (`seed_hash`, C7)

- **L1/L3** sont déterministes par construction (mêmes items/injects ⇒ même arbre).
- **L2 (IA)** et **L4 (live-fire)** sont **stochastiques**. Pour préserver la rejouabilité :
  - **L2** : figer `temperature`, prompt, et `corpus_snapshot_id` dans une trace ; le verdict est rejouable, la génération non. → introduire un `arena_run_id` distinct du `seed_hash`.
  - **L4** : figer l'`adversary_id` Caldera + seed d'environnement ; logguer le run comme **proof record** (pas comme arbre).
- **À trancher (Q-A4)** : le `seed_hash` couvre-t-il seulement la *structure de l'arbre* (déterministe) et non les *runs ARENA* (traçés séparément) ? Proposition : **oui** — arbre déterministe, runs auditables.

---

## 10. Modèle d'intégration L4 unifié (simple · personnalisé · réutilisable)

> Objectif de cette section : montrer **comment** brancher le live-fire de façon **simple**, **personnalisée SCYFORGE**, **unifiée**, et **capable de porter l'objectif multi-secteurs** — sans construire d'infra cyber.

### 10.1 Le principe : *un adaptateur, des recettes*
Le piège serait d'intégrer chaque scénario/outil à la main (5 scénarios × N outils = explosion). On l'évite avec **deux briques seulement** :

1. **`RangeAdapter`** — **une seule** couche de code, agnostique, qui parle le protocole SCYFORGE (`provision / observe / submitAction / teardown`). Écrite **une fois**.
2. **Range Recipe** — un **fichier déclaratif** (données, pas de code) par scénario, qui décrit *quel adversaire, quelle télémétrie, quelles cibles*. Fournie **par le pack**.

```
                    ┌───────────────────────────────────────────┐
   ARENA (Ag-11) ──►│  LiveRangeProvider  (port du contrat)      │
   agnostique       │        │                                    │
                    │        ▼                                    │
                    │  RangeAdapter  ← écrit UNE fois, agnostique │
                    │        │  lit une "Range Recipe" (déclaratif)│
                    └────────┼────────────────────────────────────┘
                             ▼
        ┌──────────────┬──────────────┬─────────────────┐
        │  Caldera     │  OpenSearch   │  Guacamole/K3s   │   ← moteurs existants (wrappés)
        │ (adversaire) │ (télémétrie)  │ (accès éphémère) │
        └──────────────┴──────────────┴─────────────────┘
```

**Pourquoi c'est simple :** on n'écrit qu'**un** adaptateur. Ajouter un scénario L4 = écrire **une recette** (déclaratif), pas du code. Ajouter un secteur = fournir de nouvelles recettes, l'adaptateur ne bouge pas.

### 10.2 La Range Recipe (personnalisation SCYFORGE, sans terme cyber côté noyau)
La recette est **la seule chose que le pack fournit**. Elle mappe un nœud du tronc → un environnement live-fire. Exemple (Cyber Pack) :

```yaml
# recipe: SCN-EDR-03 (pack cyber) — donnée déclarative, vit DANS le pack
range_recipe:
  node_id: "B3-lateral-movement"          # nœud du tronc (ontologie §10)
  fidelity: L4
  adversary:                               # → Caldera
    profile_ref: "caldera://adversary/discovery-lateral"
    seed: "$arena_run_id"                  # déterminisme L4 (cf. §7)
  telemetry:                               # → OpenSearch / Wazuh
    source_ref: "opensearch://index/edr-*"
    inject_rules_ref: "sigma://lateral-movement"
  access:                                  # → Guacamole / K3s
    template_ref: "range://soc-workstation-min"
    ttl_minutes: 45                        # provisionner → détruire
  expected_signals:                        # projeté sur rubrique §6, PAS de verdict en dur
    - maps_to_rubric_dim: "justesse_escalade"
    - maps_to_rubric_dim: "traçabilité"
```

- Le **noyau** ne lit jamais ce YAML : il reçoit du `RangeAdapter` des objets abstraits (`Inject`, `ActionOutcome`).
- Les `*_ref` (`caldera://`, `sigma://`, `opensearch://`) restent **confinés au pack** → **règle d'or respectée**.
- Le mapping `expected_signals → rubrique §6` garantit que L4 alimente **les mêmes dimensions** que L1-L3 (comparabilité, §6).

### 10.3 Cycle de vie unifié d'un run L4 (identique pour les 5 scénarios)
```
1. ADAPTIVE-ROUTER(Ag-06) vise L4 pour le nœud N
2. LiveRangeProvider.provision(session, N)
     └─ RangeAdapter lit la Recipe(N) → spin-up: Caldera op + OpenSearch + Guacamole (TTL)
3. observe() : télémétrie → flux d'Inject abstraits → ARENA applique CognitiveFrictionPolicy
4. submitAction(action) : action recrue → ActionOutcome (agnostique)
5. À la clôture : trace → proof record (rubrique §6) + arena_run_id (§7)
6. teardown() : destruction garantie du range (coût maîtrisé, isolement)
```
**Un seul cycle** couvre les 5 scénarios : ce qui change entre eux, c'est **la recette**, jamais le code du cycle.

### 10.4 Comment ce modèle porte l'objectif SCYFORGE (multi-secteurs)
| Exigence SCYFORGE | Réponse du modèle |
|---|---|
| **Simple** | 1 adaptateur écrit une fois ; nouveaux scénarios = fichiers déclaratifs. |
| **Personnalisé** | La Range Recipe encode le contexte SCYFORGE (nœud du tronc, rubrique, TTL, seed). |
| **Unifié** | Même port `LiveRangeProvider`, même cycle de vie, même sortie rubrique pour L1→L4. |
| **Multi-secteurs** | Médecine/finance → nouveau pack = nouvelles recettes (`sim://`, `emr://`…). Noyau + adaptateur inchangés. |
| **Sans construire d'infra** | On **wrappe** Caldera/OpenSearch/Guacamole ; SCYFORGE n'héberge pas la sécurité, il l'orchestre. |

### 10.5 Ce que ça impose comme travail réel (honnête)
- Écrire **un** `RangeAdapter` robuste (provision/teardown fiables, timeouts, nettoyage garanti même en cas d'échec).
- Définir le **schéma de Range Recipe** (le durcir comme un port, §7 ontologie).
- Écrire **5 recettes** (une par `SCN-*`) — déclaratif, faisable incrémentalement.
- Isolement réseau + quotas (un range jetable ne doit jamais toucher la prod tenant).

---

## 11. Cahier des charges employeur 2026 — Taxonomie compétences & inventaire outils open-source

> **Statut de cette section : acquis de recherche validés et verrouillés (D8).**
> La taxonomie n'est pas une liste académique : ce sont les compétences que les entreprises rechercheront activement chez leurs recrues en 2026. Elle est le **référentiel de marché** de SCYFORGE — la vérité externe contre laquelle on mesure la couverture, on calibre la temporalité du Semantic Tree, et on construit le positionnement commercial.
> L'inventaire d'outils fournit **le contenu des recettes L4** (§10). **Aucun de ces outils n'entre dans le noyau** — ils vivent dans le Cyber Pack derrière `RangeAdapter`.

### 11.1 Ce que ça valide dans le modèle
- **Référentiel de couverture réel** : le « 80% » se mesure désormais contre un signal marché concret, pas au doigt mouillé. On sait exactement ce qu'on couvre et ce qu'on ne couvre pas encore.
- **Temporalité du Semantic Tree** : la distinction « nouvelles 2026 » vs « traditionnelles toujours requises » alimente directement `skill_era: traditional | new_2026`, `valid_at`, et pondère `trunkPriority`. Les nœuds « nouvelle 2026 » ont une priorité élevée car ils reflètent ce que le marché valorise **maintenant**.
- **Scope MVP protégé, vision intacte** : le Cyber Pack démarre sur SOC L1 (domaine 4 + adversaire domaine 6) — non parce que les autres domaines ne comptent pas, mais parce que **le MVP doit prouver la valeur sur un sous-ensemble ciblé avant de s'étendre**. Les 4 autres domaines (Cloud, IA/ML, Zero Trust/IAM, GRC) sont des **packs futurs planifiés**, pas des non-priorités. La taxonomie reste entière comme cap (D7/D8).
- **Gabarit de recherche multi-secteurs** : cette même démarche (identifier le cahier des charges employeur du secteur → mapper sur l'échelle L1→L4 → sélectionner le stack open-source ou wrapper) s'applique à chaque nouveau secteur (médecine, finance, juridique). C'est la preuve que la méthode est scalable.

### 11.2 Les 6 domaines de compétences → mapping SCYFORGE
> La colonne « Statut » indique où on commence, pas ce qu'on valorise. Tous les domaines sont dans le cahier des charges employeur 2026 — ils auront tous un pack.

| # | Domaine (2026) | Signal marché 2026 | Statut SCYFORGE |
|---|---|---|---|
| 4 | **Détection menaces & réponse incident** (SIEM/EDR/XDR, tri, DFIR) | Compétence socle, demandée partout, traditionnelle + nouvelle (IA-assistée) | **Cyber Pack MVP** — aligné sur l'ontologie §10, tactiques B1-B6. Point de départ naturel. |
| 6 | **Hacking éthique / pentest** (Red Team, ATT&CK) | Très demandé, certifications (OSCP, CEH) valorisées | **MVP côté adversaire** : génère l'attaque que la recrue détecte. Côté « recrue pentester » = **Pentest Pack post-MVP**. |
| 3 | **Zero Trust & IAM** | Nouvellement critique (fragmentation Cloud, identité comme périmètre) | **IAM Pack post-MVP**. Apparaît comme contexte dans les scénarios SOC L1 MVP. |
| 1 | **Sécurité Cloud / hybride** (CNAPP, CSPM, multicloud) | Forte croissance demande, compétence « nouvelle 2026 » la plus citée | **Cloud Pack post-MVP**. Domaine à fort `trunkPriority` pour les nœuds `new_2026`. |
| 2 | **IA & ML** (securing AI, prompt injection, LLM red-teaming) | Compétence émergente, premium salarial en 2026 | **AI Security Pack post-MVP**. Nœuds `skill_era: new_2026` à `valid_at` récent. |
| 5 | **GRC** (NIS 2, DORA, risque tiers, conformité) | Demandé dans les grandes entreprises et secteurs réglementés | **GRC Pack post-MVP**. Couvert principalement en L1/L2 (QCM + teachback) ; peu de live-fire nécessaire. |

### 11.3 Inventaire outils open-source → couche L4 + statut MVP
Tous derrière `RangeAdapter` (§10). Statut = ce qu'on wrappe **maintenant** vs **plus tard**.

| Outil open-source | Rôle dans une Range Recipe | Barreau | Statut |
|---|---|---|---|
| **MITRE Caldera** | Moteur d'adversaire (opérations chaînées, API REST v2) | L4 adversaire | 🟢 **MVP** (socle) |
| **OpenSearch / ELK** | Centralisation & requête des logs (le SIEM que la recrue interroge) | L4 télémétrie | 🟢 **MVP** (socle) |
| **Wazuh** | EDR/XDR — détections sur endpoints, alertes à trier | L4 détection | 🟢 **MVP** (socle) |
| **Ansible** | Provisioning auto des vulnérabilités / configs cibles | L4 setup | 🟢 **MVP** (rend les recettes réelles) |
| **OpenTofu / Terraform** | IaC : monter/détruire la topologie (cycle provision→teardown) | L4 orchestration | 🟢 **MVP** (cycle §10.3) |
| **Docker / K3s** | Conteneurs = range jetable à faible coût | L4 accès | 🟢 **MVP** (au lieu de VM lourdes) |
| **Apache Guacamole** | Accès navigateur éphémère (SSH/VNC/RDP) au range | L4 accès | 🟢 **MVP** |
| **OWASP Juice Shop** | Cible web vulnérable prête à l'emploi | L4 cible | 🟢 **MVP** (cible bon marché, haute valeur) |
| **Vulnerable-AD** | Active Directory truffé de failles, déployable en 1 script | L4 cible | 🟢 **MVP** |
| **Atomic Red Team** | Tests atomiques mappés ATT&CK (complète Caldera) | L4 adversaire | 🟡 **Post-MVP proche** |
| **Zeek + Suricata** | NIDS — détection réseau (élargit la surface de détection) | L4 télémétrie | 🟡 **Post-MVP** |
| **OPNsense / pfSense** | Pare-feu virtuel, segmentation réseau du labo | L4 isolement | 🟡 **Post-MVP** (MVP = NetworkPolicy K8s) |
| **Proxmox VE** | Hyperviseur VM complet | L4 infra lourde | 🔴 **Post-MVP** (MVP = conteneurs) |
| **PurpleSharp** | Simulation d'attaques Windows/AD propres | L4 adversaire spécialisé | 🔴 **Post-MVP** |
| **Garak** | Attaques par injection de prompt / vulnérabilité LLM | domaine 2 (IA) | 🔴 **Post-MVP** (hors SOC L1) |
| **DefectDojo** | Orchestration AppSec / DevSecOps | domaine 6 étendu | 🔴 **Post-MVP** (hors SOC L1) |
| **Kubescape** | Posture de sécurité Kubernetes | domaine 1 (cloud) | 🔴 **Post-MVP** (hors SOC L1) |

### 11.4 Le « stack MVP » minimal mais complet (vertical L4 prouvable)
> **9 outils suffisent** pour un L4 réel et honnête sur SOC L1 :
> **Caldera** (attaque) → sur cibles **Juice Shop / Vulnerable-AD** montées par **OpenTofu + Ansible** dans **Docker/K3s**, télémétrie vers **OpenSearch + Wazuh**, accès recrue via **Guacamole**.

Ce vertical prouve à lui seul les 5 recettes `SCN-*` (§10.3) : on ne change que la Range Recipe. Tout le reste (Proxmox, OPNsense, Zeek, PurpleSharp, Garak, DefectDojo, Kubescape) **enrichit la fidélité ou étend le scope** mais n'est **pas requis** pour livrer L4.

### 11.5 Ce que la taxonomie change dans le reste du modèle
- **Mesure du « 80% » (Q-A6)** : dénominateur pour le MVP = nœuds SOC L1 (domaine 4 + adversaire domaine 6). La couverture totale sur les 6 domaines = **la vision long terme**, mesurable pack par pack.
- **Semantic Tree** : marquer chaque nœud `skill_era: traditional | new_2026` + `market_domain: detection | cloud | iam | ai_security | grc | pentest` → alimente `valid_at`, pondère `trunkPriority`, et servira de filtre par pack.
- **Feuille de route packs** : la taxonomie fixe **6 packs planifiés** (Cyber/SOC L1, Pentest, IAM, Cloud, AI Security, GRC), chacun avec son propre inventaire d'outils, ses recettes L4, et son propre dénominateur de couverture.
- **Positionnement commercial** : chaque pack couvre un **domaine de recrutement réel en 2026**. SCYFORGE ne vend pas de la formation abstraite — il couvre ce que les DRH et RSSI paient pour évaluer.
- **Gabarit multi-secteurs** : la démarche (cahier des charges employeur → mapping L1→L4 → stack tools → recettes) est réplicable à chaque nouveau secteur (médecine, finance, juridique) avec la même rigueur.

---

## 12. Modèle de pondération de couverture par règles (Q-A6)

> **Décision (D9) : la couverture « 80% » est pondérée par règles, pas par comptage de nœuds.**
> Raison : un nœud ★★★★★ `new_2026` couvert en L4 n'est pas équivalent à un nœud ★ `traditional` couvert en L1 (QCM). La pondération reflète le signal employeur (D8) et la fidélité réelle atteinte (D1).

### 12.1 Les trois règles de pondération

Chaque règle s'appuie sur une dimension **déjà présente** dans l'ontologie ou le Semantic Tree — aucune dimension inventée pour ce modèle.

| Règle | Dimension source | Effet | Justification |
|---|---|---|---|
| **R1 — Criticité marché** | `trunkPriority` ★ (1→5) | Multiplie le poids du nœud de ×1.0 (★) à ×3.0 (★★★★★) | Un nœud critique (★★★★★) validé en L3+ vaut 3× plus qu'un nœud marginal (★). Reflète directement le cahier des charges employeur (D8). |
| **R2 — Nouveauté 2026** | `skill_era: new_2026` | +20% sur le poids final du nœud | Les compétences émergentes sont sur-pondérées : elles correspondent au différentiel salarial que le marché paie en 2026. Un nœud `traditional` prend le coefficient 1.0. |
| **R3 — Fidélité atteinte** | barreau L1..L4 (D1) | Coefficient de fidélité : L1=0.25 / L2=0.50 / L3=0.85 / L4=1.0 | La couverture n'est pas binaire. Être couvert en L1 (QCM) ne vaut pas 100% d'un nœud — c'est honnête et évite d'afficher un faux « 80% » gonflépar des QCM. |

### 12.2 Formule de score d'un nœud

$$\text{weight}(N) = \left(\frac{\text{trunkPriority}(N)}{5} \times 2 + 1\right) \times \left(1 + 0.2 \cdot \mathbb{1}[\text{skill\_era}(N) = \text{new\_2026}]\right)$$

$$\text{score}(N) = \text{weight}(N) \times \text{fidelityCoeff}(N)$$

$$\text{score\_max}(N) = \text{weight}(N) \times 1.0 \quad \text{(barreau L4 = fidélité pleine)}$$

Où `fidelityCoeff` :

| Barreau | Coefficient | Interprétation |
|---|---|---|
| L1 — QCM / mini-exam | 0.25 | Testé théoriquement, non simulé. |
| L2 — Sim IA branchée | 0.50 | Simulé par l'agent, sans environnement réel. |
| L3 — Scénario déterministe (`SCN-*`) | 0.85 | Simulé avec scénario scripté, sans live-fire. |
| L4 — Live-fire (`RangeAdapter`) | 1.00 | Fidélité maximale, environnement réel. |

### 12.3 Formule de couverture pondérée d'un pack

$$\text{coverage}(\text{pack}) = \frac{\displaystyle\sum_{N \in \text{pack}} \text{score}(N)}{\displaystyle\sum_{N \in \text{pack}} \text{score\_max}(N)}$$

**Seuil cible MVP** : `coverage(Cyber Pack) ≥ 0.80`

Ce seuil se lit ainsi : « 80% du poids marché des compétences SOC L1 est couvert à une fidélité pondérée — en tenant compte de la criticité, de la nouveauté 2026, et du barreau réellement atteint. »

### 12.4 Exemple illustratif (3 nœuds)

| Nœud | `trunkPriority` | `skill_era` | Barreau atteint | weight | fidelityCoeff | score | score_max |
|---|---|---|---|---|---|---|---|
| `B3-lateral-movement` | ★★★★★ (5) | `new_2026` | L4 (live-fire) | (5/5×2+1)×1.2 = **3.6** | 1.00 | **3.6** | 3.6 |
| `B1-alert-triage` | ★★★ (3) | `traditional` | L3 (SCN-*) | (3/5×2+1)×1.0 = **2.2** | 0.85 | **1.87** | 2.2 |
| `B6-escalation` | ★★ (2) | `traditional` | L1 (QCM) | (2/5×2+1)×1.0 = **1.8** | 0.25 | **0.45** | 1.8 |
| **Total** | — | — | — | **7.6** | — | **5.92** | **7.6** |

**coverage = 5.92 / 7.6 = 0.779 → 77.9%** — en dessous de 80%, la recette L4 de `B6-escalation` est à prioriser pour franchir le seuil.

### 12.5 Où vivent les règles dans l'architecture

- Les règles R1/R2/R3 sont **des données** (constantes configurables dans le pack), pas du code en dur dans ARENA.
- **`SimulationFidelityRouter`** (noyau ARENA) appelle `CoverageEvaluator(pack)` → lit les poids et coefficients → retourne le score de couverture.
- **ADAPTIVE-ROUTER (Ag-06)** utilise `coverage(pack)` pour **prioriser** les prochains nœuds à monter en fidélité : les nœuds dont le delta `score_max - score` est le plus élevé passent en tête de queue.
- Le tableau de bord recrue/formateur voit `coverage(pack)` en temps réel — pas un comptage de nœuds, mais une **mesure de valeur marché couverte**.

### 12.6 Ce que ce modèle garantit
- **Honnêteté** : un pack à 80% de QCM n'affiche pas 80% de couverture — il affiche ~20% (poids L1=0.25).
- **Alignement marché** : les entreprises (D8) ont une lecture directe de ce que SCYFORGE couvre dans leur cahier des charges employeur.
- **Pilotage** : on sait toujours **quel nœud, si upgradé en fidélité, rapporte le plus** de points de couverture → priorisation rationnelle des recettes à écrire.
- **Extensibilité** : pour un nouveau pack (médecine, finance), on réinitialise le calcul avec les nœuds et `trunkPriority` du nouveau pack. Les formules ne changent pas.

---

## 8. Questions ouvertes (à arbitrer ensemble)

- [x] **Q-A1** — ~~L4 au MVP : chemin vertical ou 5 scénarios ?~~ **TRANCHÉE (D4)** : L4 pleinement validé, les 5 scénarios ; tenu via adaptateur unique + recettes déclaratives (§10).
- [ ] **Q-A2** — Générateur L1/L2 : comment garantir des items non triviaux (réutiliser les « pièges » des `SCN-*` comme distracteurs) ?
- [ ] **Q-A3** — Gate de certification : confirmer « `autonomous` exige ≥ L3 ; L1/L2 → plafond `guarded` ».
- [ ] **Q-A4** — Déterminisme : `seed_hash` = structure d'arbre uniquement, `arena_run_id` pour les runs L2/L4 ?
- [x] **Q-A5** — ~~Socle L4 open-source ou commercial ?~~ **TRANCHÉE (D6)** : 100% open-source. Stack MVP = 9 outils (§11.4) ; aucun range commercial.
- [x] **Q-A6** — ~~Mesure du « 80% » : comptage ou pondération ?~~ **TRANCHÉE (D9)** : pondération par règles (R1 criticité, R2 nouveauté 2026, R3 fidélité atteinte). Formule en §12. Piloté par ADAPTIVE-ROUTER.

---

## 9. Prochaines étapes proposées

1. Trancher Q-A1..Q-A6 (surtout Q-A1 et Q-A5, qui dimensionnent l'infra L4).
2. Figer les interfaces `LiveRangeProvider` et `AssessmentProvider` (les durcir comme les 7 ports existants, §7 ontologie).
3. Spécifier le **chemin vertical L4** de démonstration (ex. `SCN-EDR-03` bout-en-bout via Caldera).
4. Définir le générateur L1/L2 (mapping nœud → items, réutilisation des pièges `SCN-*`).

---

### Journal
- **v0.1** — création : échelle de fidélité L1→L4 (D1), L4 au MVP par wrapping (D2), plancher 100% / cible 80% (D3) ; cartographie marché ; esquisses `LiveRangeProvider` + `AssessmentProvider` ; 6 questions ouvertes.
- **v0.2** — **L4 pleinement validé** (D4) ; **modèle d'intégration L4 unifié** (D5, §10) : *un adaptateur (`RangeAdapter`), des recettes déclaratives (Range Recipe)* ; cycle de vie unique pour les 5 scénarios ; Q-A1 tranchée ; démonstration simple/personnalisé/unifié/multi-secteurs.
- **v0.3** — **acquis recrue intégrés & validés** (§11) : taxonomie compétences 2026 (6 domaines, nouvelles vs traditionnelles) + inventaire outils open-source. **Socle L4 100% open-source** (D6, Q-A5 tranchée). **Scope MVP = SOC L1** (D7). Sélection MVP (9 outils, §11.4) vs post-MVP ; la taxonomie devient dénominateur du « 80% » et gabarit de recherche multi-secteurs.
- **v0.5** — **Modèle de pondération de couverture par règles** (D9, §12) : 3 règles (R1 criticité `trunkPriority`, R2 nouveauté `skill_era`, R3 fidélité L1..L4) ; formule `coverage(pack)` data-driven ; pilotage par ADAPTIVE-ROUTER (Ag-06) ; exemple illustratif 3 nœuds ; Q-A6 tranchée. Toutes les questions ouvertes A1..A6 sont maintenant fermées.
- **v0.4** — **Statut de la taxonomie rehaussé** (D8) : elle est le **cahier des charges employeur 2026**, signal marché réel, pas une liste académique. Reframing §11 complet. **6 packs planifiés** (Cyber/SOC L1, Pentest, IAM, Cloud, AI Security, GRC) — chacun couvre un domaine de recrutement réel. §11.2 : chaque domaine nommé comme pack futur avec son propre chemin L1→L4. §11.5 : positionnement commercial ancré marché.

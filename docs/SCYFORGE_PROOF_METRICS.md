# SCYForge — Métriques de Preuve

## Autonomisation des recrues & Moteur d'innovation/exploration

> **Objet.** Ce document définit les métriques *falsifiables* que SCYForge doit atteindre pour prouver deux thèses :
> - **Thèse A — Autonomisation** : nous rendons une nouvelle recrue autonome sur son rôle, plus vite et de façon mesurable, avec transfert prouvé du simulé vers le réel.
> - **Thèse B — Moteur d'innovation** : au-delà de l'onboarding, la plateforme génère de l'exploration et de la nouveauté exploitable pour l'entreprise (nouveaux gestes, nouvelles hypothèses, nouveaux angles de détection/décision).
>
> Règle d'or (héritée du SeedValidator §12.6) : **aucune métrique de vanité**. Chaque chiffre doit être auditable, attribuable à un individu/rôle, et refuser le faux positif pédagogique (réussir un QCM ≠ être autonome).

---

## 0. Cadre de lecture

| Niveau de preuve | Ce qu'il démontre | Statut visé pilote |
|---|---|---|
| **P0 — Instrumentable** | La métrique est captée proprement | Semaine 1 |
| **P1 — Sim** | Le résultat tient *en scénario* (arène D9) | Semaine 4 |
| **P2 — Transfert** | Le résultat tient *sur le réel* du tenant (G1) | Semaine 8–12 |
| **P3 — Durable** | Le résultat tient *dans le temps* (pas de régression) | Post-pilote |

> Une thèse n'est **prouvée** qu'à P2. P1 est nécessaire mais **non suffisant** : c'est le piège classique du "simulateur qui note bien mais ne transfère pas".

---

## THÈSE A — Autonomisation des recrues

### A0. Activation Beachhead (gates du pivot) — le go/no-go produit

**Hérité de PIVOT_ARCHITECTURE §1, §5, §9.2.** Avant même de prouver l'autonomie (P2), le MVP doit franchir les gates d'activation que le pivot fixe comme critère unique de valeur perçue : *« le SOC Manager constate la valeur en < 30 min »*. Ce sont des métriques P0/P1 — nécessaires mais pas suffisantes.

| Métrique | Définition (source pivot) | Cible | Tue le MVP si… |
|---|---|---|---|
| **TTFV** (Time-To-First-Value) | Onboarding : org créée → rôle sélectionné → sous-arbre affiché (§9.2 Journey 1) | **< 5 min** | > 15 min |
| **Time-to-Perceived-Value** | Manager charge le pack → voit arbre + progression + 1 scénario jouable | **< 30 min** | > 60 min |
| **Complétion APT29** | % beta users terminant le scénario hero (§5 règle de décision) | **> 70%** | < 40% |
| **Franchissement de seuil** | % recrues atteignant SMI ≥ **0.70** (seuil pack-défini, tronc-avant-feuilles) sur ≥ 1 tronc | **≥ 60%** en pilote | proche de 0 |

> Ces gates valident que le produit **s'active** ; A1–A4 valident qu'il **tient sa promesse**. Ne jamais confondre activation et preuve d'autonomie.

### A1. Time-to-Autonomy (TTA) — métrique reine

**Définition.** Nombre de jours ouvrés entre J0 (arrivée recrue) et le moment où l'analyste atteint le **seuil d'autonomie** sur son rôle : décisions correctes en autonomie sur un flux réel, sans escalade injustifiée ni supervision bloquante.

| Métrique | Baseline marché (§2.2) | Cible SCYForge | Preuve requise |
|---|---|---|---|
| TTA médian (SOC L1) | **4 à 9 mois** | **≤ 8 semaines** | P2 |
| TTA p90 (queue lente) | non mesuré chez le client | **≤ 12 semaines** | P2 |
| Réduction TTA vs cohorte témoin | — | **≥ 40%** | P2 |

> **Falsifiable** : si le pilote montre une réduction < 20% vs témoin, la Thèse A est **réfutée** pour ce tenant. On ne négocie pas ce chiffre.

### A2. Autonomy Envelope (par rôle) — voir §13

Projection de l'autonomie réelle : ce que la recrue peut faire **seule**, vs sous supervision, vs pas encore.

| Métrique | Cible | Preuve |
|---|---|---|
| % de la surface du rôle en "autonome sans supervision" | **≥ 70%** à sortie de pilote | P2 |
| % de faux "autonome" détectés (l'enveloppe se rétracte au réel) | **≤ 10%** | P2 |
| Stabilité de l'enveloppe (rétractation semaine/semaine) | **< 5%** après S8 | P3 |

### A3. Transfert Sim → Réel (G1) — le risque existentiel

C'est LA métrique qui valide ou tue le produit. Elle compare la performance en arène (P1) à la performance sur les vraies alertes du tenant (P2).

| Métrique | Cible | Interprétation |
|---|---|---|
| **Transfer Ratio** = perf_réel / perf_sim | **≥ 0.80** | Sous 0.65 → le simulateur ne prédit pas le réel → pivot obligatoire |
| Décisions correctes sur alertes réelles (rôle L1) | **≥ 85%** | Mesuré contre verdict analyste senior |
| Faux "prêt" (validé en sim, échoue en réel) | **≤ 10%** | Coût de crédibilité maximal |
| Délai sim→premier ticket réel réussi | **≤ 5 jours** | Vitesse de transfert |

> **Sans P2 sur G1, aucune autre métrique ne compte.** C'est le point de contrôle n°1 du pilote.

### A4. Anti-passivité (runtime de friction utile — §2.3)

Prouve que l'apprentissage est actif, pas de la complétion de contenu.

| Métrique | Cible |
|---|---|
| Ratio décisions prises / contenu consommé | **≥ 1.5** (plus d'action que de lecture) |
| Taux d'auto-correction après feedback (sans re-explication) | **≥ 60%** |
| Décroissance du taux d'escalade injustifiée (S1 → S8) | **≥ 50%** |

---

## THÈSE B — Moteur d'innovation & d'exploration (Generative Forest Engine)

> **Cadrage canonique (PIVOT_ARCHITECTURE §9bis).** Le « moteur d'innovation » n'est pas un ajout ad hoc : c'est le **3ème pilier** de SCYForge, le **Generative Forest Engine (GFE)** — *« Le fruit, on le mange. La graine, on la plante. »* Le GFE croise des branches éloignées du savoir privé (ATT&CK au beachhead) pour produire des **Seeds** plantables. Sur le beachhead M0–M36, il opère en **mode observatoire** (§9bis.9) : la pollinisation intra-domaine tourne, les Seeds sont **stockées et scorées mais pas germinées** avant validation. Ces métriques prouvent que le GFE produit de la nouveauté *souveraine et non-copiable*, pas du bruit.

### B1. Pollinisation & génération de Seeds (conditions L1–L4)

Toute Seed doit satisfaire les **4 conditions de fécondité** simultanément (§9bis.3) : distance suffisante (L1), pont logique (L2), lien nouveau (L3), alignement Vision Helm (L4). On mesure le rendement de ce filtre, pas le volume brut.

| Métrique | Définition (GFE) | Cible |
|---|---|---|
| **Seed Yield** | Seeds satisfaisant L1–L4 / croisements tentés | **≥ 10%** (le reste = bruit filtré, sain) |
| **Seed Viability moyenne** | `Viability = feasibility × alignment × non_redundancy × resource_fit` | **≥ 0.60** sur les Seeds retenues |
| **Novelty (L3 strict)** | % Seeds dont le lien A↔B est *absent* du KG initial | **100%** (par construction — sinon rappel, pas création) |
| **Alignement Vision Helm (L4)** | `align(Seed, H) ≥ τ` sur axes cyber = [DetectionRate, ResponseVelocity, Coverage, Compliance, FalsePositiveRate] (§9bis.9) | **≥ τ** pour 100% des Seeds VIABLE |

> Distinction clé (héritée §6) : une Seed n'a de valeur que **validée par un senior** comme exploitable. Le score GFE (Viability/Fecundity) est un *pré-filtre*, pas un verdict. Sans validation humaine → DORMANT, pas VIABLE.

### B1bis. Contrôles scientifiques du GFE — éviter le faux "innovant"

Le GFE ne doit pas seulement produire des idées plausibles. Il doit prouver que la Seed vient d'un raisonnement par **premiers principes** sur le Semantic Tree, et qu'elle bat des baselines simples.

| Contrôle | Définition | Cible |
|---|---|---|
| **First-Principle Grounding Rate** | % Seeds avec parenthood complet, chemin vers tronc/invariant, et split `formel` vs `tacite` explicite | **≥ 80%** des Seeds VIABLE |
| **Baseline Lift** | taux d'acceptation senior du GFE / taux d'acceptation senior d'un baseline random, near-node ou co-occurrence ATT&CK simple | **≥ 2.0×** |
| **False Viable Rate** | Seeds marquées VIABLE par le système mais rejetées par senior comme redondantes, non actionnables ou mal fondées | **≤ 15%** |
| **Decision-Bearing Rate** | Seeds acceptées qui produisent une décision testable : règle, scénario, runbook, arbre de hunting ou changement de posture | **≥ 70%** |
| **External Novelty Check** | absence de duplication évidente dans le corpus pack + corpus org + sources publiques consultées après génération | **100%** des Seeds candidates à germination |
| **Time-Slice Hit Rate** | sur corpus historique coupé à T, % Seeds qui anticipent ou reconstruisent une amélioration observée en T+Δ | **≥ 20%** en benchmark historique |

**Baselines obligatoires** : random pair pollination, paires proches dans l'arbre, co-occurrence ATT&CK simple, résumé/RAG type NotebookLM, et proposition humaine rapide. Sans comparaison, on ne prouve pas l'innovation ; on prouve seulement que le système sait écrire une proposition plausible.

**Séparation des rôles** : le générateur de Seed ne valide jamais sa propre Seed. Le minimum crédible est : GFE propose, `ValidationGuard` vérifie la source et les bornes, AG16/Beth ou Datalog estime la fondationnalité, puis un senior métier tranche l'utilité.

### B2. Exploration de l'espace de décision (couverture ATT&CK / rôle)

Prouve que le moteur *étend* la surface couverte, pas seulement qu'il l'entretient — la contrepartie « exploration » de la pollinisation.

| Métrique | Cible | Lien |
|---|---|---|
| Couverture pondérée du pack (poids marché) | **69% → 81%** | mesure §PACK_COVERAGE |
| Nouveaux nœuds `new_2026` explorés / trimestre | **≥ 2** promus L1→L3 | ontologie §9 |
| Seeds inter-tactiques testées en arène (ex: Reconnaissance ⊕ Exfiltration → IoC canaux inhabituels, §9bis.9) | **≥ 3 / trimestre** | D9 branched-sims |

### B3. Cycle de vie des Seeds & germination (l'effet volant d'inertie)

Le vrai moteur d'innovation est le cycle POLLINATED → VIABLE → GERMINATING → NEW SUBTREE (§9bis.7), couplé à la boucle corpus. Les recrues explorent → le GFE polliniste → les Seeds validées **germent** en nouveaux sous-arbres → les cohortes suivantes partent de plus haut. **Règle GFE : aucune Seed n'est détruite** — une Seed stérile aujourd'hui (DORMANT) peut germer demain (réveil bitemporel).

| Métrique | Définition (GFE) | Cible | Preuve |
|---|---|---|---|
| **Germination Rate** | Seeds VIABLE → NEW SUBTREE validé / Seeds VIABLE | **≥ 20%** (post-mode-observatoire) | P2 |
| **Fecundity réalisée** | sous-arbres réellement produits / `potential_subtrees` estimé | **≥ 0.30** | P2 |
| Temps de cycle (POLLINATED → SOP/sous-arbre mis à jour) | latence pollinisation → valeur | **≤ 30 jours** | P2 |
| TTA de la cohorte N+1 vs cohorte N (effet cumulatif) | pente d'apprentissage inter-cohorte | **−10% par cohorte** | P3 |

> **Falsifiable** : si la pente TTA inter-cohorte ne décroît pas **et** que le Germination Rate reste à 0 hors mode observatoire, il n'y a **pas** de moteur d'innovation — juste un outil d'onboarding statique. La Thèse B repose sur ces deux signaux conjoints.

---

## THÈSE C — Le Semantic Tree comme infrastructure (le moat composé)

> **Cadrage canonique (SEMANTIC_TREE_INFRASTRUCTURE §5, §6, §9).** Les Thèses A et B opèrent toutes deux sur **un seul substrat** : le Semantic Tree. Une Seed qui germine (B3) **est** une greffe sur l'arbre ; une recrue autonome (A) **est** une projection `Learner` maîtrisée de l'arbre `Organization`. Cette thèse prouve que l'arbre est une *infrastructure* (ce qu'on ne peut plus retirer sans tout casser), pas une feature — donc que le moat **se creuse dans le temps**.

### C1. Accumulation composée — le taux de greffe (anti-« arbre figé »)

Le risque n°1 de l'infrastructure (§9) : *un arbre qui ne se greffe pas est un LMS déguisé*. On mesure que l'arbre d'organisation **grossit en permanence** avec la vie du tenant.

| Métrique | Définition (source arbre) | Cible | Tue la thèse si… |
|---|---|---|---|
| **Taux de greffe / semaine** | greffes horodatées (incident, règle Sigma, post-mortem) rattachées à un nœud existant, par org | **≥ 5 / semaine** en pilote | ≈ 0 (arbre mort) |
| Ratio greffe rattachée vs orpheline | % de greffes correctement suspendues à un parent mûr (pas « en l'air ») | **≥ 90%** | greffes majoritairement orphelines |
| Anneaux de croissance actifs (`supersedes`) | versionnements datés d'un savoir remplacé (Graphiti/Zep) | **≥ 1 / mois** | jamais de supersession = savoir amnésique |

### C2. Valeur privée irréductible — Diff(org) − Diff(pack)

Le moat exact (§4.3) : *la valeur privée = l'arbre de l'org moins l'arbre du pack canonique.* C'est ce que personne ne peut copier car c'est l'histoire opérationnelle de *ce* tenant.

| Métrique | Définition | Cible |
|---|---|---|
| **Delta souverain** = |nœuds+arêtes(org)| − |nœuds+arêtes(pack)| | masse de savoir privé greffé au-delà du pack public | **croissance monotone** mois/mois |
| Part des décisions d'arène issues de greffons privés (vs pack public) | % scénarios ancrés sur l'histoire réelle du tenant | **≥ 40%** à M3 | 
| Coût de reconstitution estimé (proxy du coût de sortie) | greffes datées non reproductibles ailleurs | **croissant** = moat qui se creuse |

> **Falsifiable** : si Delta souverain est plat, l'org n'ajoute aucune valeur privée → SCYForge n'est qu'un renderer du pack public → **pas de moat**. La défendabilité repose entièrement sur cette pente positive.

### C3. Bench anti-wrapper (Thiel Q1) & anti-illusion

Deux garde-fous du §9 : l'arbre doit être construit **10× mieux** qu'un humain, et la seule mesure qui compte est la maîtrise **prouvée par test**, jamais la couverture visuelle.

| Métrique | Cible | Interprétation |
|---|---|---|
| Temps de construction d'un arbre cyber validé (SCYForge vs expert manuel) | **≤ 1/10** du temps expert | sous 3× → simple wrapper LLM, moat faible |
| Justesse de l'arbre auto-construit (validé senior) | **≥ 90%** des nœuds/arêtes acceptés sans correction | < 70% → l'humain refait tout |
| Écart maîtrise **prouvée-par-test** vs couverture **visuelle** affichée | **suivi ≥ 0** (jamais gonfler le visuel) | un bel arbre affiché ≠ arbre dans la tête |

---

## Tableau de bord unique (ce qu'on regarde chaque semaine)

| # | Métrique | Cible | Niveau | Tue le projet si… |
|---|---|---|---|---|
| 0 | **Time-to-Perceived-Value** (gate pivot) | < 30 min | P0 | > 60 min |
| 1 | **Transfer Ratio (G1)** | ≥ 0.80 | P2 | < 0.65 |
| 2 | TTA médian SOC L1 | ≤ 8 sem. | P2 | réduction < 20% vs témoin |
| 3 | % surface rôle autonome | ≥ 70% | P2 | < 50% |
| 4 | **Seed Yield** (L1–L4) + Viability moyenne | ≥ 10% / ≥ 0.60 | P1→P2 | ≈ 0 Seed viable |
| 5 | Pente TTA inter-cohorte | −10%/cohorte | P3 | plate ou positive |
| 6 | Couverture pondérée pack | 81% | P1 | plafonne < 70% |
| 7 | **Taux de greffe / semaine** (arbre vivant) | ≥ 5 | P1→P2 | ≈ 0 (arbre figé) |
| 8 | **Delta souverain** Diff(org)−Diff(pack) | croissance monotone | P2→P3 | plat (pas de moat) |

---

## Protocole de preuve (90 jours, 1 design partner)

0. **S1 — Franchir l'activation (A0).** Vérifier les gates du pivot sur le tenant : TTFV < 5 min, valeur perçue < 30 min, APT29 jouable. Sans activation, rien à mesurer ensuite.
1. **S1 — Instrumenter (P0).** Câbler les 7 métriques du tableau de bord sur un tenant MSSP/MDR réel. Établir la **cohorte témoin** (recrues onboardées à l'ancienne).
2. **S2–S4 — Prouver en sim (P1).** 1 rôle (SOC L1), 1 classe d'alerte, 5 scénarios hero, ~69% de couverture. GFE en **mode observatoire** : Transfer Ratio *prédit* + Seed Yield/Viability mesurés (Seeds stockées, non germinées).
3. **S2–S4 — Bench GFE contrôlé.** Sur le même corpus, comparer GFE contre random pairs, near-node pairs, co-occurrence ATT&CK simple, résumé/RAG et proposition humaine rapide. Revue senior aveugle : le reviewer ne sait pas quelle méthode a produit la Seed.
4. **S5–S8 — Prouver le transfert (P2).** Basculer sur les vraies alertes. **Point de contrôle G1** : si Transfer Ratio < 0.65 → arrêt et pivot, on ne continue pas.
5. **S9–S12 — Prouver la boucle (P2→P3).** Mesurer TTA réel vs témoin, valider les premières Seeds avec un senior (VIABLE), amorcer la cohorte N+1 pour capter la pente inter-cohorte, et suivre le **taux de greffe** + le **Delta souverain** (l'arbre du tenant doit visiblement diverger du pack public).

---

## Ce que ce document engage

- **On ne contractualise le "80% de couverture" et le profil régulé qu'après validation P2 de G1.** L'ordre est non négociable : transfert d'abord, échelle ensuite.
- **Toute métrique non atteinte à son niveau P visé est un signal de pivot, pas un chiffre à masquer.** La crédibilité en due diligence vient de métriques qui *peuvent* échouer.
- La Thèse A (autonomisation) est la **preuve de survie**. La Thèse B (moteur d'innovation / GFE) est la **preuve de valeur durable**. La Thèse C (arbre-infrastructure) est la **preuve de défendabilité** — c'est elle qui explique pourquoi un concurrent ne peut pas simplement recopier A et B.
- **Les trois thèses partagent un seul substrat.** Une Seed germée (B) est une greffe (C) ; une recrue autonome (A) est une projection maîtrisée de l'arbre. Il n'y a pas trois produits à prouver, mais **trois vues d'un seul invariant** : le Semantic Tree. Si l'arbre ne vit pas (C1 plat), ni A ni B ne peuvent tenir dans le temps.

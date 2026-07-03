<!--
ARCHIVE — RÉFÉRENCE HISTORIQUE
Cette architecture "Plugin Cyber" a été abandonnée au profit de COSMOS v5.
Le signal utile (8 Use Case Intentions C1-C8, bindings STB, orchestration agents) a été recyclé dans COSMOS v5 comme "Use Case Intentions" du domain pack.
Ne pas utiliser ce document comme référence d'architecture active.
Date d'archivage : 2026-07-02
-->

# SCYForge — COSMOS Plugin Infrastructure (B) : le Plugin CYBER [ARCHIVÉ]

> **Statut** : architecture. **Aucun code.** Document B de 3 (A=noyau, B=Plugin Cyber, C=Arborisation KG & Insights).
> **Dépend de** : le Contrat de Plugin défini dans le Doc A (§3).

---

## 0. Positionnement : ce que ce plugin N'EST PAS

> **Directive fondateur (à graver)** :
> *« Nous ne sommes pas positionnés sur la vente de formation de cybersécurité en général. Nous
> n'apprenons pas à nos clients à faire de la cybersécurité — d'autres le font déjà. Nous nous
> concentrons sur la création de valeur orientée compréhension / rétention / mémorisation des
> concepts techniques, métiers, rôles, disciplines et règles strictes de l'entreprise, ancrée sur
> ses SOP et documents internes. »*

| ❌ Ce que le Plugin Cyber NE fait PAS | ✅ Ce qu'il fait |
|---|---|
| Enseigner la cybersécurité générique | Faire **comprendre/retenir/maîtriser** *le savoir interne* de l'entreprise |
| Vendre des cours ATT&CK | Utiliser ATT&CK comme **ossature** pour structurer les SOP internes |
| Du contenu de formation tout fait | De la **transformation** du corpus interne (SOP, runbooks, règles maison) en maîtrise |
| Awareness / phishing simulation | **Readiness opérationnelle** : agir sous pression à partir du savoir de *cette* entreprise |

> **La matière première du Plugin Cyber = les SOP et documents internes du client.**
> ATT&CK/Sigma ne sont pas le *contenu* à apprendre ; ce sont le **squelette de référence** sur lequel on **greffe et structure** le savoir propre de l'entreprise.

---

## 1. Ce que le Plugin Cyber déclare (les 6 éléments du contrat — Doc A §3.1)

### 1.1 Ontologie sectorielle
- **Squelette de référence** : MITRE ATT&CK (tactiques → techniques → sous-techniques). Corpus réel déjà dans le repo : **697 techniques, 475 sous-techniques**.
- **Greffe interne** : chaque concept/règle/rôle interne de l'entreprise se **rattache** à un nœud ATT&CK via la clé de jointure `attack.tXXXX`.

### 1.2 Source de criticité (le 80/20)
- **Densité de règles SigmaHQ** (corpus réel : 3136 règles scannées) → pondère quelles techniques comptent le plus.
- Top réel déjà calculé (`cyber_semantic_tree.json`) : `T1059` (scripting) = 1.000, `T1218` = 0.754, `T1027` = 0.486, `T1574` = 0.447, `T1112` = 0.436.
- **Surcouche entreprise** : la criticité finale = densité Sigma **× pertinence interne** (ce que l'entreprise rencontre vraiment dans ses SOP/incidents).

### 1.3 Matrice d'intentions cyber — `(problème métier, but) → visualisation`
C'est le cœur du plugin. **Chaque visualisation répond à un use case interne précis**, jamais à un concept aléatoire.

| # | Use case interne (problème réel) | But | Mode(s) noyau composé(s) | Données |
|---|---|---|---|---|
| C1 | « Une recrue doit comprendre NOTRE périmètre en 1 min » | Onboarding express défendable | **Sunburst** sur le STB org | STB org (tronc=mission SOC, feuilles=SOP) |
| C2 | « Où sont nos angles faibles de détection ? » | Prioriser l'effort 80/20 | **Treemap** densité Sigma × SMI équipe | densité + couverture interne |
| C3 | « Comment se déroule l'attaque que nous avons subie ? » | Comprendre une kill-chain réelle | **Sankey / Dataflow** | chaîne d'incident interne mappée ATT&CK |
| C4 | « Quel rôle fait quoi, et qui dépend de qui ? » | Clarifier rôles & disciplines internes | **Concept Map / Arc Diagram** | taxonomie de rôles interne |
| C5 | « D'où vient cette règle interne, qu'a-t-elle engendré ? » | Ouvrir un Nœud Vivant | **Nœud-arbre** (fondation SOP + dérivés datés) | STB org, anneaux de croissance |
| C6 | « Mon équipe est-elle prête sur la tactique X ? » | Mesurer la readiness | **Radar SMI** par tactique | SMI par sous-arbre |
| C7 | « Quelles règles strictes ne doivent JAMAIS être violées ? » | Ancrer les non-négociables | **Heatmap criticité × conformité** | règles internes critiques |
| C8 | « Comment cet incident se relie-t-il à nos procédures ? » | Relier incident ↔ SOP | **Hierarchical Edge Bundling** | incidents ↔ SOP internes |

> Ces 8 intentions sont la **v1 du Plugin Cyber**. Elles sont **intentionnelles** : chacune résout un problème SOC/blue-team concret, ancré sur le savoir interne.

### 1.4 Bindings de modes (comment un mode lit le STB cyber)
Convention partagée par tous les modes cyber :
- **nœud** = technique/sous-technique ATT&CK **ou** concept/règle interne greffé,
- **couleur** = SMI (rouge 0 → or 100),
- **taille / poids** = criticité (densité Sigma × pertinence interne),
- **profondeur** = strate de l'arbre (tronc=tactique, branche=technique, feuille=SOP/incident),
- **horodatage** = anneau de croissance (quand la connaissance a été greffée).

### 1.5 Règles d'orchestration (quel agent déclenche quelle visu)
| Contexte runtime | Agent déclencheur | Visualisation choisie |
|---|---|---|
| Début d'onboarding | GOAL-INTERPRETER | C1 Sunburst (vue 1 min) |
| Exercice sous pression | ARENA | C3 Sankey kill-chain |
| Après une session de révision | PERFORMANCE-ANALYZER | C6 Radar SMI |
| Détection d'une zone faible | DRIFT-GUARDIAN | C2 Treemap angles faibles |
| Consultation d'une règle interne | LEARNING-CONDUCTOR | C5 Nœud Vivant |

### 1.6 Scénarios de pression
- **APT29 Emulation** (corpus réel : 79 étapes) → parcours guidé d'une branche critique sous pression dans ARENA.
- Scénarios dérivés des **incidents internes** du client (greffés au fil du temps).

---

## 2. Le wedge : onboarding / autonomie des recrues SOC & blue team

Le Plugin Cyber sert d'abord **l'autonomie des recrues** à partir du savoir interne :
1. la recrue voit le **STB org** (C1) → comprend le périmètre en 1 min,
2. ASCENT lui fait **reconstruire** les branches critiques (active recall, pas relecture),
3. ARENA l'éprouve **sous pression** sur des scénarios internes (C3),
4. SKILL-CERTIFIER **prouve** la maîtrise (SMI ≥ 70) sur les sous-arbres critiques.

> Résultat : une recrue **opérationnelle plus vite**, autonome sur le savoir *de cette entreprise* — pas un certifié générique.

---

## 3. Pourquoi ce plugin est un moat (pas un cours)

| | Formation cyber classique | Plugin Cyber SCYForge |
|---|---|---|
| Matière | contenu générique | **SOP & documents internes** du client |
| Sortie | un certificat générique | **maîtrise prouvée du savoir interne** |
| Durée de vie | périme vite | **croît** avec l'entreprise (greffes datées) |
| Copiable ? | oui (même cours partout) | **non** : l'arbre interne est unique à l'entreprise |

> Le concurrent peut copier ATT&CK et Sigma (publics). Il **ne peut pas** copier le STB org du client — c'est *son* histoire, *ses* incidents, *ses* règles.

---

## 4. Extension vers le secteur #2 (Santé/Finance régulé) — preuve d'architecture

Le Plugin Cyber **ne contient aucune ligne de moteur**. Pour le secteur #2, on **réutilise le noyau** et on déclare un nouveau plugin :
- ontologie : référentiels de conformité (au lieu d'ATT&CK),
- criticité : poids réglementaire / risque (au lieu de densité Sigma),
- matrice d'intentions : use cases régulés (au lieu de SOC),
- mêmes modes noyau (Sunburst, Treemap, Radar…), **bindings différents**.

> **Test du moat** : brancher le Plugin Régulé ne doit RIEN casser dans le Plugin Cyber. Si c'est vrai, l'architecture est visionnaire, pas verticale.

---

## 5. Questions ouvertes pour B (à trancher avant code)

1. **Liste définitive des intentions cyber** : fige-t-on les 8 (C1–C8) en v1, ou en ajoute/retire-t-on ?
2. **Pertinence interne** : comment mesure-t-on le « × pertinence interne » de la criticité (fréquence dans les SOP ? incidents ? déclaration manuelle d'un RSSI) ?
3. **Greffe SOP** : ingestion automatique des SOP → mapping ATT&CK auto, ou validation humaine obligatoire au départ ?
4. **Règles strictes (C7)** : a-t-on besoin d'un type de nœud spécial « non-négociable » dans le STB ?

---

*Document B. Voir Doc A (noyau & contrat) et Doc C (arborisation KG & insights).*
*Données ancrées sur corpus réels : MITRE ATT&CK STIX (697/475), SigmaHQ (3136 règles), APT29 (79 étapes).*

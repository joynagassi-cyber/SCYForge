<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Standards architecturaux — ajouter section beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🏗️ SCY FORGE ARCHITECTURAL BLUEPRINT MASTER (v3.5)
**Document ID** : ARCH-BLUEPRINT-MASTER-V3.5  
**Date** : 2026-06-12  
**Statut** : 🟢 INVARIANTS TECHNIQUES DE PRODUCTION IMMUABLES ET EXHAUSTIFS  
**Auteurs** : Master Architect Team & MIA Auto-Researcher  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 🧭 Table des Matières
1. [Introduction : La Constitution de Production de SCY Forge](#1-intro)
2. [Section 1 : Les 22 Décisions Fondamentales d'Architecture](#2-fondamentales)
3. [Section 1bis : Pivot Cyber Beachhead — Décisions de Révision](#2bis-pivot)
4. [Section 1ter : Generative Forest Engine (GFE) — Le Moteur de Créativité Générative](#2ter-gfe)
5. [Section 2 : Les 15 Patterns de Résilience et Robustesse SRE](#3-resilience)
6. [Section 3 : ASCENT Pipeline Plan C — 13 Agents Génériques](#4-ascent)
7. [Section 4 : COSMOS 4 Modes Cyber](#5-cosmos)
8. [Section 5 : NEURON-CHAINS — DIFFÉRÉ Post-MVP (B2C)](#6-neuron)
9. [Section 6 : APIs, Intégrations et Stratégie LLM](#7-opt)

---

## 1. Introduction : La Constitution de Production de SCY Forge {#1-intro}

**ATTENTION AGENT DE DÉVELOPPEMENT IA :**  
Ce document est la **référence suprême et immuable** régissant l'intégralité du code source de SCY Forge v3.5. Il fige chaque patron de conception, chaque constante physique et chaque règle de résilience. Vous devez vous y conformer de manière stricte, sans aucune omission, substitution ou hallucination. Tout écart entraînera le rejet immédiat du commit lors des vérifications de sûreté Harmonist.

---

## 2. Section 1 : Les 18 Décisions Fondamentales d'Architecture {#2-fondamentales}

| ID | Patron / Décision | Spécification Technique & Règle d'Implémentation | Phase |
|---|---|---|---|
| **D-001** | **Architecture Hexagonale** | Séparation hermétique : `Domain` (règles et mathématiques pures, 0 dépendance), `Ports` (interfaces TypeScript/Rust), et `Adapters` (Axum, sqlx, Mastra, UI). | MVP |
| **D-002** | **CQRS Léger** | Séparation des flux d'écriture transactionnels (Commands via sqlx) et des flux de lecture rapides (Queries via cache sémantique `scy_llm_cache_meta` ou cache partagé). | MVP |
| **D-003** | **Event Sourcing ciblé** | Appliqué aux modules d'Ingestion et d'APEX FSRS : les mutations d'états de mémorisation sont enregistrées comme un flux d'événements immuables et rejouables. | MVP |
| **D-004** | **Monolithe Unifié** | Déploiement sous forme d'un processus unique (Single-Process Monolith) où le serveur Node.js/TS (Mastra) et le moteur de calcul Rust cohabitent localement (appel par IPC, socket UNIX ou bindings FFI), éliminant toute complexité de microservices ou latence réseau. | MVP |
| **D-005** | **Repository Pattern** | Utilisation de traits génériques en Rust (`pub trait Repository<T>`) pour encapsuler l'accès aux données PostgreSQL Northflank, facilitant le mock pour les tests. | MVP |
| **D-006** | **GraphQL + DataLoader** | Pour l'exploration relationnelle de concepts, regroupement des requêtes N+1 via un mécanisme de traitement par lots (batching) et de mise en cache temporaire. | MVP |
| **D-007** | **Temporal Queries PG** | Utilisation d'historiques temporels sur Northflank PostgreSQL pour permettre de rejouer et de visualiser l'état de la base de connaissances de l'étudiant à n'importe quelle date passée. | V1 |
| **D-008** | **Unit of Work Pattern** | Tout cas d'utilisation (Use Case) modifiant l'état d'apprentissage s'exécute au sein d'une transaction de base de données PostgreSQL atomique et isolée. | MVP |
| **D-009** | **Pipeline MapReduce L0-L4**| La synthèse documentaire de NEURON-CHAINS s'exécute de façon séquentielle de L0 (brute) à L4 (export final) avec retry et cache sur chaque segment. | MVP |
| **D-010** | **Observer Pattern / EventBus**| Découplage total des 18 agents ASCENT : communication asynchrone par messages via un EventBus local/cloud de production. (13 agents IN_MVP + 5 agents POST_MVP : AG14-LiveKit Voice, AG15-Gaming/Dual, AG16-Social Recruiting, AG17-Analytics Pipeline, AG18-Advanced Orchestration). | MVP |
| **D-011** | **Typestate Pattern ASCENT**| Représentation des états de la machine à états de cours (`Locked`, `Ready`, `Studying`, `Mastered`) sous forme de types Rust stricts, empêchant les transitions invalides à la compilation. | MVP |
| **D-012** | **Distributed Tracing** | Intégration de traces OpenTelemetry exportées en direct vers le cockpit d'observabilité open-core **Langfuse** sous Docker. | V1 |
| **D-013** | **Polars + DuckDB Analytics**| Pour le calcul lourd d'analytics de cohorte en tâche de fond, utilisation de Polars/DuckDB in-memory sans surcharger Northflank PostgreSQL. | V1 |
| **D-014** | **SAGA Pattern Workflows** | Orchestration distribuée des processus d'onboarding sur Mastra TypeScript, appliquant des compensations de nettoyage en cas d'échec ou de rejet d'agent. | Phase 3 |
| **D-015** | **ISR Dashboard** | Régénération statique incrémentale du tableau de bord de progression pour des temps d'affichage instantanés (<10ms). | MVP |
| **D-016** | **Specification Pattern** | Utilisation de filtres de requêtes composables et typés en Rust pour extraire les cartes APEX dues selon des critères d'urgences variables. | V1 |
| **D-017** | **Reactive Streams** | Gestion de la pression de retour (Backpressure) lors de l'ingestion massive de flux (transcriptions de vidéos ou de fils Reddit) pour éviter la saturation mémoire. | MVP |
| **D-018** | **Observability as Code** | Toutes les métriques d'apprentissage, d'accès et d'erreurs logiques d'agents sont structurées et typées, interdisant les logs de texte libre non structurés. | MVP |
| **D-019** | **DCID — Domain Contract Interface Definition** | Le core SCYForge est **agnostic au domaine métier**. Le trait `SemanticTreeProvider` (Rust) est le **seul pont** entre le core et les domain packs (cyber, finance, santé). Aucun terme métier cyber/medical/finance n'existe dans le core. | MVP |
| **D-020** | **Domain Pack Contract** | Chaque domain pack implémente **9 providers canoniques** : `SemanticTreeProvider` (PRIMARY, obligatoire), `OntologyProvider`, `CorpusProvider`, `RoleTaxonomyProvider`, `DecisionScenarioProvider`, `ProofRubricProvider`, `RetentionPolicyProvider`, `ValidationGuardProvider`, **`PackConfigProvider`**, **`PackJsonSchemaProvider`**. **Frontière claire** : `ValidationGuardProvider` = garde-fous non négociables (binaire : INTERDIT/AUTORISÉ) ; `ProofRubricProvider` = critères d'évaluation graduels (score pondéré sur dimensions). Les 2 derniers gèrent : (1) la config pack-définie (mastery thresholds, SMI weights, Helm axes, criticality formula), (2) la validation optionnelle du JSONB custom (None = accept-all, pas de rejet). | Phase 2 |
| **D-021** | **Generative Forest Engine (GFE)** | **3ème pilier** de SCY Forge. Produit des Seeds (extensions, reconversions, innovations) via Pollination + Seed + Germination. Sur le cyber beachhead M0-M36 : mode observatoire (pollinisation intra-domaine MITRE, Seeds stockées, pas de germination auto). Post-MVP M36+ : mode expansion (cross-pollination inter-STB + germination auto). Métaphore : forêt générative gouvernée par un Vision Helm. Documents fondateurs : `SCYFORGE_GENERATIVE_TREE_POLLINATION_SEED.md`, `SCYFORGE_GENERATIVE_ENGINE_LOGICAL_MODEL.md`, `SCYFORGE_GENERATIVE_ENGINE_MATH_FORMALIZATION.md`. | MVP (observatoire) |
| **D-022** | **Seed Traceability (PROV + Bitemporal)** | Toute Seed est traçable via W3C PROV-DM (`wasDerivedFrom`, `wasGeneratedBy`) + bitemporel (event time + ingestion time). La lignée est immuable → décision incontestable. Inclut : machine à états (POLLINATED → VIABLE → GERMINATING / DORMANT), 4 conditions L1-L4, scoring Viability/Fecundity/PlantScore. | MVP (observatoire) |
| **D-023** | **Domain Pack = Médiateur, pas Curriculum** | Le Domain Pack ne définit PAS ce que l'apprenant doit savoir (ça appartient à l'entreprise). Il est le **médiateur** qui structure, aligne et traduit le savoir de l'entreprise en parcours de maîtrise mesurable. Deux sources de vérité : (1) QUOI = documents de l'entreprise (source primaire authoritative), (2) COMMENT = le pack (ontologie, grammaire arbre/feuilles, rubriques, garde-fous). Si conflit → l'entreprise gagne. Sans corpus entreprise → pas de curriculum. Test de médiation : « Si je retire le corpus de l'entreprise, reste-t-il un curriculum ? » → Non, et c'est voulu. | MVP |
| **D-024** | **Principe Fondateur — Extensibilité par Conception** | **Le core est un squelette générique sans mémoire métier ; la connaissance, les règles et les seuils vivent dans les packs.** Aucun terme métier, aucune règle de domaine, aucun seuil (mastery_threshold, weights, helm_axes, criticality_formula) n'est hardcodé dans le core. L'absence de config pack → `MissingPackConfig` error, jamais de fallback silencieux. Un nouveau domaine = un nouveau pack, **zéro réécriture du noyau**. Ce principe surpasse toutes les décisions D-001 à D-022 en cas de conflit. | MVP |
| **D-025** | **Loop Engineering — Grammaire de Conception Transverse** | L'autonomie est structurée en 4 boucles imbriquées : Micro (output/input ≥ seuil), Méso (Plant→Graft→Test→Myelinate ; SMI ≥ threshold), Macro (coverage ≥ 0.80 + enveloppe validée), Outcome (écart preuve↔réalité sous tolérance). Chaque agent ASCENT opère dans au moins une boucle. | MVP |
| **D-026** | **Cognitive Runtime Policies — Protection de l'Apprenant** | 5 policies traversent ASCENT et le Semantic Tree : OutputPressurePolicy, CognitiveFrictionPolicy, ConsolidationWindowPolicy, SparringPolicy, SemanticTreePriorityPolicy. Tous les seuils sont pack-définis via `PackConfigProvider`. Aucun seuil hardcodé dans le core. Events : `OutputPressureApplied`, `FrictionAdjusted`, `ConsolidationWindowStarted`, `SparringModeActivated`, `SemanticTreePriorityEnforced`. | MVP |

---

## 2bis. Pivot Cyber Beachhead — Décisions de Révision {#2bis-pivot}

> **[PIVOT-BEACHHEAD v2.0 — 2026-07-01]** Cette section fige les décisions de révision architecturales issues du pivot Cyber SOC/Blue-Team.
> Toute décision future qui contredit cette section est une **violation du contrat d'architecture**.

### 2bis.1 Features DIFFÉRÉES — Court Terme (B2B SOC/Cyber) vs Long Terme (B2C Grand Public)

> **[PIVOT]** Rien n'est éliminé. Toutes les features sont **reclassées** selon le marché cible et le timeline.
> Le B2B SOC/Cyber est le **court terme** (M0-M36). Le B2C est le **long terme** (M36+).

#### Court Terme (B2B SOC/Cyber) — IN_MVP ou Phase 2/3

| Feature | Statut court terme | Raison |
|---------|-------------------|--------|
| **Semantic Tree + DCID** | ✅ IN_MVP | Core agnostic, pont domain packs |
| **Domain Pack Cyber (MITRE)** | ✅ IN_MVP | Contenu pré-généré, $0 LLM |
| **ASCENT Plan C (18 agents)** | ✅ IN_MVP (13 agents) + POST_MVP (5 agents AG14-18) | Refactorisé via SemanticTreeProvider. AG14-LiveKit Voice, AG15-Gaming/Dual, AG16-Social Recruiting, AG17-Analytics Pipeline, AG18-Advanced Orchestration = POST_MVP |
| **COSMOS V5 (VizSpec catalog)** | ✅ IN_MVP | Moteur de rendu intégré + catalog VizSpec[] (90 entrées). 6 viz noyau, intentions Use Case du domain pack. Architecture Plugin abandonnée (voir audit_incoherences.md) |
| **APEX B11-B14** | ✅ IN_MVP | Cartes cyber (IOC, Kill Chain, Chain-of-Custody) |
| **Tactical AI** | ✅ IN_MVP | DeepSeek V4 Free ($0) |
| **SOC Manager Dashboard** | ✅ IN_MVP | Coverage, Gap Detection, Readiness Report |
| **Role-Based Onboarding** | ✅ IN_MVP | SOC L1/L2/DFIR en <5min |
| **Proof of Skill cert** | ✅ IN_MVP | Manager sign-off workflow |
| **COSMOS Mode 3D** | Phase 2 | 4 modes 2D suffisent MVP |
| **COSMOS modes 22 autres** | Phase 3 | 26 modes → 4 puis expansion |
| **FSRS scheduler avancé** | Phase 2 | Simplifié SM-2-like pour MVP |
| **BRAIN RAG triples** | Phase 2 | BM25 seulement pour MVP |
| **Sector Pack Builder** | Phase 1 (Corporate) | RSSI ajoute règles HDS/PCI-DSS/NIS2 |
| **Phishing Simulator** | Phase 1 (Corporate) | Formation tous-employés |
| **Compliance Mapping** | Phase 1 (Corporate) | MITRE → contrôles sectoriels |

#### Long Terme (B2C Grand Public) — M36+

| Feature | Statut long terme | Marché B2C |
|---------|-------------------|-----------|
| **Normal Mode** (consumer ingestion) | ✅ B2C | Étudiant, professionnel, autodidacte — ingestion libre |
| **B2B Creator Console** | ✅ B2C → B2B2C | Créateurs de contenu (formateurs, auteurs) publient des parcours |
| **Finance Suite** (Yahoo Finance, etc.) | ✅ B2C | Investisseur retail, trader, étudiant finance |
| **IMPRINT** (registres cognitifs) | ✅ B2C | Mémorisation profonde pour étudiants, chercheurs |
| **NEURON-CHAINS** (7 chaînes LLM) | ✅ B2C | Génération de contenu à la volée pour apprenants individuels |
| **ARENA** (roleplay Full-AI générique) | ✅ B2C | Pratique conversationnelle : négociation, prise de parole, entretien |
| **CHRONICLE** (coéquipier quotidien) | ✅ B2C | Accompagnement quotidien pour apprenants grand public |
| **11 Ingestion Cores** (YouTube, Reddit, etc.) | ✅ B2C | Sources infinies pour apprenants individuels |
| **Reader Suite + IMPRINT inline** | ✅ B2C | Lecture enrichie pour étudiants |
| **Stripe consumer billing** | ✅ B2C | Free/Lite/Pro/Ultra tiers pour consommateurs |
| **BRAIN triple retrieval** | ✅ B2C | RAG avancé pour questions libres |

> **Principe** : Le B2C n'est JAMAIS éliminé. Il est **repoussé** car :
> 1. Le B2B SOC/Cyber a une douleur plus urgente et un ACV plus élevé
> 2. Le B2C nécessite NEURON-CHAINS + ingestion cores → $0 LLM en B2B pré-généré, mais nécessaire en B2C
> 3. Le B2C est le **mass market** qui validera la scale et le brand SCY Forge

### 2bis.3 DCID — Invariants Deux Marchés

| Invariant | Règle | Violation = |
|-----------|-------|------------|
| **Core agnostic** | Le cœur Rust/TS ne contient **aucun terme métier cyber en dur** (pas de "MITRE", "SOC", "Sigma", "CVE") | Arrêt build |
| **Pack isolation** | Tout contenu cyber vit dans `packs/cyber/` | Arrêt build |
| **SemanticTreeProvider** | Seul trait pont entre core et packs | Violation contrat DCID |
| **MASTERY_THRESHOLD** | **Pack-défini uniquement**. Le core ne connaît aucun seuil. Absence de config → `MissingPackConfig` error, jamais de fallback silencieux. Le pack cyber définit 0.70 | Violation contrat DCID (D-024) |
| **Pack ingestion = $0 LLM** | Toute ingestion de pack NE nécessite pas d'appel LLM | Violation budget |
| **Role subtree mandatory** | Tout learner DOIT avoir un role_subtree avant onboarding | Violation RBAC |
| **RLS par organization_id** | Toutes les tables filter par `organization_id` | Fuite cross-tenant |
| **Sector pack = MITRE + rules** | Un sector pack = MITRE ATT&CK + règles sectorielles (HDS, PCI-DSS, NIS2) injectées via DCID | Violation monopole sectoriel |

### 2bis.4 Pricing — Deux Marchés Cumulés

| Tier | Prix/an | Cible Pure-Player | Cible Corporate | Inclus |
|------|---------|-------------------|-----------------|--------|
| **Trial** | 0 $ (30j) | 5 analysts | 3 analysts | 1 pack MITRE, 1 secteur |
| **Team** | 5 000 $ | 5-20 analysts | 5 analysts | MITRE + 1 secteur, Manager dashboard |
| **Enterprise** | 25 000 $ | 20-100 analysts | 50+ analysts | Multi-pack, SSO/SAML, analytics avancés |
| **Industry** | 50 000 $+ | — | RSSI + tous employés | Custom sector pack + B2B2C deployment |
| **Government** | Custom | Secteur public | Secteur public | On-prem, FedRAMP, custom ontology |

> **MRR cible M6** : 50 K$ (100 SOCs × 5 analysts avg × mix Trial/Team/Enterprise)
> **MRR cible M18** : 200 K$ (ajout Corporate : 20 entreprises × 25K$ Industry tier)

### 2bis.5 Personas Cyber Beachhead (Seules autorisées)

| ID | Persona | Rôle | Tactics Core | Phase |
|----|---------|------|-------------|-------|
| **P-SOC1** | SOC Analyst L1 | Monitoring, alert triage, IOC identification | 6 tactics (TA0001-TA0006) | MVP |
| **P-SOC2** | SOC Analyst L2 | Threat hunting, incident response, playbook execution | 10 tactics (TA0001-TA0010) | MVP |
| **P-DFIR** | Digital Forensic Investigator | Forensic analysis, chain-of-custody, malware analysis | 14 tactics (all) | MVP |
| **P-SEL** | Security Enablement Lead | Team training, gap analysis, readiness reporting | All + manager view | MVP |
| **P-RSSI** *(PEAK)* | RSSI / Security Manager (corporate non-tech) | Former équipe minuscule + prouver compliance | All + sector rules | Phase 1 |
| **P-JUNIOR** *(PEAK)* | Junior Cyber Analyst (corporate non-tech) | Autonomie rapide sans mentor senior | role_subtree adapté | Phase 1 |
| **P-ITM** *(PEAK)* | IT Manager avec sécurité (non-cyber) | Comprendre et appliquer règles sécurité | Subtree compliance-only | Phase 1 |

> Toute persona générique (Étudiant Tech, Professionnel Veille, etc.) est **éliminée** du beachhead.
> Les personas PEAK-OPPORTUNITY (P-RSSI, P-JUNIOR, P-ITM) sont le **multiplicateur x10** — corporate non-tech (banques, hôpitaux, usines, retail).

---

## 1ter. Generative Forest Engine (GFE) — Le Moteur de Créativité Générative {#2ter-gfe}

> **[PIVOT-GFE]** SCY Forge ne fait PAS « un moteur d'insights de plus ». Elle produit des **graines plantables**, pas des insights.
> Le GFE est le **troisième pilier** de SCY Forge : après le Semantic Tree (Pilier 1) et l'ASCENT Pipeline (Pilier 2), la Forêt Générative permet à l'entreprise de **créer du nouveau** à partir de son savoir privé.

### D-021 — Generative Forest Engine (GFE) — 3 Pilier

| ID | Décision | Spécification | Phase |
|---|---|---|---|
| **D-021** | **GFE — 3ème pilier** | SCY Forge produit des **graines plantables** (extensions, reconversions, innovations) à partir du savoir privé de l'entreprise. Pas des insights. Métaphore : une forêt générative (STB) qui se pollinise et sème de nouveaux arbres, gouvernée par un cap (Vision Helm). Sur beachhead M0-M36 : mode observatoire (pollinisation intra-domaine MITRE, Seeds stockées). Post-MVP M36+ : mode expansion (cross-pollination inter-STB + germination auto). Documents fondateurs : `SCYFORGE_GENERATIVE_TREE_POLLINATION_SEED.md`, `SCYFORGE_GENERATIVE_ENGINE_LOGICAL_MODEL.md`, `SCYFORGE_GENERATIVE_ENGINE_MATH_FORMALIZATION.md`. | MVP (observatoire) |
| **D-022** | **Seed Traceability** | Toute Seed est traçable via **W3C PROV-DM** (`wasDerivedFrom`, `wasGeneratedBy`) + **bitemporel** (event time + ingestion time). La lignée est immuable → décision incontestable. Inclut : machine à états (POLLINATED → VIABLE → GERMINATING / DORMANT), 4 conditions L1-L4, scoring Viability/Fecundity/PlantScore. | MVP (observatoire) |

### D-023 — Domain Pack = Médiateur, pas Curriculum

> **Principe fondateur** : le Domain Pack ne définit PAS ce que l'apprenant doit savoir. C'est l'entreprise qui détient la vérité pédagogique. Le pack est le **médiateur** qui structure, aligne et traduit le savoir de l'entreprise en parcours de maîtrise mesurable.

| ID | Décision | Spécification | Phase |
|---|---|---|---|
| **D-023** | **Domain Pack = Médiateur** | Deux sources de vérité : (1) **QUOI** = documents de l'entreprise (SOP, playbooks, postmortems, politiques) — source primaire authoritative ; (2) **COMMENT** = le pack (ontologie, grammaire arbre/feuilles, rubriques, garde-fous). Si conflit → l'entreprise gagne. Sans corpus entreprise → pas de curriculum. Le `CorpusProvider` traite les docs entreprise comme source #1 ; les sources publiques (Sigma, CISA…) ne sont qu'un **échafaudage de médiation**. Le `seed_hash` inclut `corpus_snapshot_id` pour garantir que deux entreprises avec le même pack produisent deux arbres différents. | MVP |

### D-024 — Principe Fondateur — Extensibilité par Conception

> **Le core est un squelette générique sans mémoire métier ; la connaissance, les règles et les seuils vivent dans les packs.**

| ID | Décision | Spécification | Phase |
|---|---|---|---|
| **D-024** | **Extensibilité par Conception** | Aucun terme métier, aucune règle de domaine, aucun seuil (mastery_threshold, weights, helm_axes, criticality_formula) n'est hardcodé dans le core. L'absence de config pack → `MissingPackConfig` error, jamais de fallback silencieux. Un nouveau domaine = un nouveau pack, **zéro réécriture du noyau**. Ce principe surpasse toutes les décisions D-001 à D-022 en cas de conflit. | MVP |

### Documents fondateurs GFE (à lire avant tout codage GFE)

| Document | Contenu | Statut |
|----------|---------|--------|
| `docs/SCYFORGE_GENERATIVE_TREE_POLLINATION_SEED.md` | Concept : Pollination + Seed, biologie générative, méthode 4 passes par secteur | ✅ Fondateur |
| `docs/SCYFORGE_GENERATIVE_ENGINE_LOGICAL_MODEL.md` | Modélisation logique : nomenclature anglaise, opérateur Pollination, anatomie Seed, Viability/Fecundity, Vision Helm, traçabilité PROV | ✅ Logique |
| `docs/SCYFORGE_GENERATIVE_ENGINE_MATH_FORMALIZATION.md` | Formalisation mathématique : distance hybride, seuils, fonction de viabilité, émergence endogène (SME + Blending + Link Prediction) | ✅ Math |

### Nomenclature canonique (code, API, docs investisseurs)

| Concept FR | Nom anglais canonique | Alias court | Définition |
|---|---|---|---|
| Arbre sémantique | **Semantic Tree** / **Knowledge Tree** | `STB` | structure dirigée tronc→branches→feuilles |
| Arborisation | **Arborization** | `ARBOR` | transformer un graphe plat (KG) en arbre dirigé |
| Nœud vivant | **Living Node** | — | nœud = fondation + dérivés datés (mini-arbre) |
| Fondation du nœud | **Rootstock** | — | la racine immuable d'une connaissance |
| Dérivés datés | **Growth Rings** | — | anneaux de croissance horodatés |
| Pollinisation | **Pollination** (opérateur : *Pollinator*) | `POLL` | croisement fécondant entre branches éloignées |
| Pollinisation intra-domaine | **Self-Pollination** | — | croisement à l'intérieur d'un même STB sectoriel |
| Pollinisation inter-domaine | **Cross-Pollination** | `XPOLL` | croisement entre STB sectoriels différents |
| Graine | **Seed** | — | résultat génératif, contient un arbre en puissance |
| Viabilité de la graine | **Seed Viability** | — | probabilité qu'une graine germe en valeur réelle |
| Fécondité | **Fecundity** | — | potentiel génératif (combien d'arbres une graine peut produire) |
| Germination | **Germination** | — | déploiement d'une graine en nouveau sous-arbre |
| Gouvernail de vision | **Vision Helm** | `HELM` | encapsule la vision ; aligne tout le système |
| Moteur génératif global | **Generative Forest Engine** | `GFE` | l'ensemble : arborize → pollinate → seed → germinate |

### L'opérateur Pollination (modèle logique)

```
Pollination( source_A , source_B , context ) → Seed | ∅
```

**4 conditions de fécondité** (toutes nécessaires) :

| # | Condition | Logique | Pourquoi |
|---|---|---|---|
| **L1** | **Distance suffisante** | `distance(A,B) ≥ θ_min` | trop proches = redondance |
| **L2** | **Compatibilité non nulle** | `∃ pont logique entre A et B` | trop éloignés sans pont = bruit |
| **L3** | **Nouveauté** | lien A↔B **n'existe pas déjà** dans le KG | sinon c'est un rappel, pas une création |
| **L4** | **Alignement Vision** | `align(A⊕B, Vision Helm) ≥ τ` | graine non alignée = stérile |

**Sweet spot** : zone féconde = `θ_min ≤ distance ≤ θ_max` avec pont logique.

### Anatomie d'une Seed (5 composants logiques)

```
SEED
├─ ① CORE PROPOSITION  : l'idée/décision/méthode neuve (le "quoi")
├─ ② PARENTHOOD        : (source_A, source_B) qui l'ont engendrée (le "d'où")
├─ ③ POTENTIAL TREE    : l'arbre en puissance qu'elle peut déployer (le "vers quoi")
├─ ④ VIABILITY PROFILE : viability + fecundity (le "peut-elle germer ?")
└─ ⑤ PROVENANCE        : la lignée datée immuable (le "comment le prouver")
```

**Viability** = `feasibility × alignment × non_redundancy × resource_fit`
**Fecundity** = `potential_subtrees × strategic_reach`
**PlantScore** = `Viability^γ × Fecundity^(1−γ)` (γ = curseur prudence/ambition)

### Vision Helm — Le gouvernail

| Encodage | Forme | Usage |
|----------|-------|-------|
| **Vecteur pondéré** `h ∈ ℝᵏ` | k axes stratégiques pondérés | calcul rapide `align()` (filtre temps-réel) |
| **Graphe d'objectifs** `G_H` | objectifs → sous-objectifs → KPIs | raisonnement, traçabilité, explicabilité |

`align(x, H) = cos( proj(x), h ) ∈ [−1, 1] → renormalisé [0,1]`

Le Helm gouverne tout : Arborization, Pollination (L4), ASCENT/recrues, COSMOS.

### Émergence endogène — Le cœur du 0→1

3 mécanismes combinés (indépendants d'Internet) :

```
SAVOIR PRIVÉ (STB + KG bitemporel)
     │
 ① SME → candidats par analogie structurelle (paires A,B à Π élevé)
     │
 ② BLENDING → fusionne en structure émergente (Seed candidate)
     │
 ③ LINK-PREDICTION → score la plausibilité du lien latent + nouveauté
     │
 FILTRE : conditions L1–L4 + Viability + align(H)
     │
 SEED viable (endogène, datée, prouvée) ──► germination
     │
 (optionnel) RESEARCH AGENT Internet → CONTEXTUALISE / valide nouveauté externe
```

Internet n'intervient qu'**après** la génération, jamais pour générer. La créativité naît de la structure du savoir privé → **non-copiable**.

| Mécanisme | Base scientifique | Rôle dans GFE |
|-----------|-------------------|---------------|
| **SME (Gentner)** | Structure-Mapping Theory | Trouve paires éloignées au sens mais identiques en structure relationnelle |
| **Blending (Fauconnier-Turner)** | Conceptual Blending (4 espaces) | Fusionne 2 inputs → structure émergente absente des inputs |
| **Link Prediction (Swanson/node2vec)** | Literature-Based Discovery | Prédit liens latents plausibles sur le graphe privé |

### Cycle de vie d'une Seed (machine à états)

```
   POLLINATED ──(viability ≥ seuil)──► VIABLE ──(plantée)──► GERMINATING ──► NEW SUBTREE
        │                                  │
        └──(stérile)──► DORMANT ◄──────────┘ (rétrogradée si contexte change)
        DORMANT ──(contexte favorable plus tard)──► VIABLE   (réveil bitemporel)
```

Aucune graine n'est détruite. **Dormant ≠ mort** : une graine stérile aujourd'hui peut germer demain.

### D-025 — Loop Engineering — Grammaire de Conception Transverse

> **Principe** : l'autonomie est structurée en **4 boucles imbriquées** avec des critères de sortie déterministes. Ce n'est pas une feature à part : c'est la grammaire de conception qui donne les critères solides pour l'arborisation.

| Boucle | Portée | Critère de sortie (déterministe) |
|---|---|---|
| **Micro** | une interaction | ratio output/input ≥ seuil (`OutputPressurePolicy`) |
| **Méso** | une compétence | Plant → Graft → Test → Myelinate ; SMI du nœud ≥ `pack_config.mastery_threshold` |
| **Macro** | un rôle | `coverage(pack) ≥ 0.80` (pondéré D9 : R1 criticité × R2 skill_era × R3 fidélité) + enveloppe validée |
| **Outcome** | le réel | écart preuve↔réalité sous tolérance (`OutcomeFeedbackPolicy` G3) |

**Règle d'or** : chaque agent ASCENT (Ag-01 à Ag-13) opère dans au moins une de ces boucles. La sortie d'une boucle alimente l'entrée de la suivante.

### D-026 — Cognitive Runtime Policies — Protection de l'Apprenant

> **Principe** : le runtime doit parfois **protéger l'apprenant contre sa préférence pour la passivité**. 5 policies traversent les agents ASCENT et le Semantic Tree.

| Policy | Rôle | Agents concernés | Seuil pack-défini |
|---|---|---|---|
| **OutputPressurePolicy** | Surveille l'accumulation d'input sans output ; force rappel / teachback / application | GOAL, DAG, ADAPTIVE-ROUTER, SKILL-CERTIFIER | ratio output/input ≥ 1.5 |
| **CognitiveFrictionPolicy** | Introduit de la friction utile (desirable difficulty) calibrée | ARENA, PERFORMANCE-ANALYZER | frictionLevel par niveau/risque |
| **ConsolidationWindowPolicy** | Impose fenêtres de consolidation / repos | APEX/FSRS, LEARNING-CONDUCTOR | fenêtre pack-définie |
| **SparringPolicy** | L'IA devient contradicteur/évaluateur, pas juste assistant | SKILL-CERTIFIER, ARENA | mode activé/désactivé par pack |
| **SemanticTreePriorityPolicy** | Protège le tronc sémantique avant les branches | DAG-ARCHITECT, ADAPTIVE-ROUTER | tronc-avant-feuilles, toujours |

**Règle d'or** : aucune policy n'a de seuil hardcodé dans le core. Tous les seuils sont fournis par `PackConfigProvider`. Absence → `MissingPackConfig` error.

**EventBus events** : `OutputPressureApplied`, `FrictionAdjusted`, `ConsolidationWindowStarted`, `SparringModeActivated`, `SemanticTreePriorityEnforced`.

---

## 3. Section 3 : ASCENT Pipeline Plan C — 13 Agents Génériques {#4-ascent}

> **[PIVOT-BEACHHEAD + GFE]** Les 13 agents ASCENT sont refactorisés pour consommer des `SemanticTreeProvider` contracts (DCID D-019).
> Le GFE est intégré comme 3ème pilier : les Seeds produites par pollinisation alimentent l'ASCENT Pipeline (Germination → nouveaux objectifs d'apprentissage).
> Référence : PRD Part 2 § "Plan C — Refactor 13 agents" + § "GFE Integration".

### 3.1 Vue d'Ensemble du Pipeline

```
[Goal-Interpreter] → [Content-Scout] → [DAG-Architect] → [Learning-Conductor]
                                                       ↓
                    [Performance-Analyzer] ← [Adaptive-Router] ← [Validation-Guard]
                       ↓                    ↓
              [Certification-Service]    [BudgetGuard]
```

> **[PIVOT]** : Agents éliminés du MVP :
> - **AGENT-08** (CHRONICLE) → Remplacé par Tactical AI inline hints
> - **AGENT-10** (Scenario-Generator LLM) → Remplacé par scenarios pré-générés dans pack
> - **AGENT-11** (ARENA Orchestrator) → Remplacé par évaluation automatisée
> - **AGENT-15** (AXIOMATIZER) → Différé (contenu statique = pas de dérive)
> - **AGENT-16** (SME Expert) → Remplacé par MITRE ATT&CK source-of-truth
> - **AGENT-17** (QA Comité) → Remplacé par ValidationGuardProvider
> - **AGENT-18** (Content-Writer) → Remplacé par ingestion pack pré-construit

### 3.2 SemanticTreeProvider — Le Seul Pont DCID

```rust
/// Trait unique entre le core SCYForge et les domain packs.
/// Le core ne connaît RIEN de MITRE, SOC, Sigma, CVE.
pub trait SemanticTreeProvider {
    /// Crée un arbre sémantique depuis un ontology_ref (ex: "MITRE-ATT&CK-v14.1")
    fn plant_tree(&self, ontology_ref: &str) -> Result<SemanticTree, Error>;
    
    /// Greffe un nœud avec ses prérequis (DAG edges)
    fn graft_node(&self, tree_id: TreeId, node: TreeNode, prereqs: Vec<NodeId>) -> Result<(), Error>;
    
    /// Teste un nœud (évaluation automatisée)
    fn test_node(&self, tree_id: TreeId, node_id: NodeId) -> Result<Evaluation, Error>;
    
    /// Élague un nœud obsolète (Supersedes)
    fn prune_node(&self, tree_id: TreeId, node_id: NodeId) -> Result<(), Error>;
    
    /// Myéline un nœud (marque comme mastery ≥ threshold)
    fn myelinate_node(&self, tree_id: TreeId, learner_id: LearnerId, node_id: NodeId) -> Result<(), Error>;
}
```

**Règle d'or** : Si un agent appelle `cyber_graft_technique()` directement → **violation du contrat DCID**.
Tout appel DOIT passer par `SemanticTreeProvider::graft_node()`.

### 3.3 Patterns de Découplage (EventBus)

Tous les agents communiquent via l'EventBus (D-010). Zéro appel direct inter-agents.

```rust
// Exemple : Agent-04 (Learning-Conductor) ne connaît pas Agent-05 (Performance-Analyzer)
// Il publie un événement, et le router le dispatch
event_bus.publish(TreeOpGrafted { tree_id, node_id, prereqs }).await?;
// Agent-05 souscrit à TreeOpGrafted et calcule le SMI
```

**Événements obligatoires** (voir SEQUENCE_DIAGRAMS.md pour la liste complète) :
- `TreeOpPlanted` : Nouvel arbre créé (pack ingestion)
- `TreeOpGrafted` : Nœud greffé (prereqs ajoutés)
- `TreeOpTested` : Nœud évalué (scenario complété)
- `TreeOpMyelinated` : Nœud maîtrisé (SMI ≥ pack_config.mastery_threshold)
- `ScenarioEvaluated` : Évaluation scenario terminée
- `MasteryUpdated` : Score maîtrise recalculé
- `GapDetected` : Lacune identifiée (mastery < threshold)

---

| ID | Pattern de Résilience | Spécification d'Implémentation & Règle de Sûreté | Phase |
|---|---|---|---|
| **ARC-001** | **Circuit Breaker (3 états)** | Appliqué aux appels d'APIs LLM (DeepSeek). Bascule de `Closed` (normal) à `Open` (panne, fallback immédiat) si le taux d'erreur dépasse 15%, évitant les blocages. | MVP |
| **ARC-002** | **Idempotency Keys (UUID v7)** | Toutes les requêtes d'écritures sémantiques ou de synchronisation locale portent une clé UUID v7 unique avec un TTL de 24h, garantissant zéro duplication. | MVP |
| **ARC-003** | **Timeout 3 Niveaux** | Limite d'exécution stricte : **5s** pour les appels d'APIs sémantiques, **30s** pour les opérations de bases de données, et **60s** pour les synthèses complexes. | MVP |
| **ARC-004** | **Dead Letter Queue (DLQ)** | Tout événement de mémorisation FSRS ou de progression qui échoue à la synchronisation est poussé dans une table DLQ locale/serveur pour ré-essai ultérieur. | MVP |
| **ARC-005** | **Bulkhead (Sémaphores)** | Isolation étanche des ressources d'exécution sur le backend Rust (via les sémaphores Tokio). Une panne d'ingestion (Core) ne peut pas geler les révisions d'APEX. | MVP+ |
| **ARC-006** | **Graceful Shutdown (5 phases)**| Au redémarrage d'un serveur ou conteneur Docker, phase de vidange (Drain) des files d'attente sur 30s avant déconnexion, garantissant zéro perte d'état. | MVP |
| **ARC-007** | **Outbox Pattern** | Les écritures en base de données et l'enregistrement de l'événement dans `scy_outbox` s'exécutent de manière atomique au sein de la même transaction PostgreSQL. | MVP+ |
| **ARC-008** | **Materialized Views PG** | Utilisation de 4 vues matérialisées sur Northflank PostgreSQL pour accélérer de 80% les requêtes d'analytics de cohorte ou d'historiques FSRS. | V1 |
| **ARC-009** | **Health Checks (3 niveaux)** | Exposition des routes techniques de diagnostic d'état `/live` (Liveness), `/ready` (Readiness), et `/deep` (Vérification des connexions Northflank et Zilliz). | MVP |
| **ARC-010** | **Feature Flags** | Déploiement progressif des nouveaux modes SCY-COSMOS ou d'agents de manière graduelle (5% $	o$ 25% $	o$ 100% des utilisateurs) par configuration dynamique. | V1 |
| **ARC-011** | **Blue/Green Deployment** | Déploiement Northflank / Vercel sans interruption de service avec possibilité de rollback instantané en moins de 2 minutes. | V1 |
| **ARC-012** | **Property-Based Testing** | Utilisation du crate Rust `proptest` pour simuler des millions de combinaisons d'entrées d'intervalles FSRS et valider l'absence de NaN. | MVP+ |
| **ARC-013** | **Chaos Engineering** | Injection planifiée de 4 scénarios de pannes (déconnexion PostgreSQL, ralentissement Zilliz, crash API) pour valider l'auto-réparation de notre file locale. | V2 |
| **ARC-014** | **Strangler Fig Pattern** | Migration progressive des micro-services existants de la version v2 vers la version v3 sans interrompre le trafic utilisateur. | V1 |
| **ARC-015** | **Anti-Corruption Layer (ACL)** | Tout appel d'API de service tiers (Composio, YouTube, Twitter) passe par une classe d'isolation pour protéger notre Domaine de toute fuite de modèle. | MVP |

---

## 4. Section 3 : Les Spécifications Techniques d'ASCENT Pipeline v2 {#4-ascent}

* **`AP-001` : 13 Agents Autonomes** : Découplage total des responsabilités d'apprentissage. Chaque agent (de 01 à 13) s'exécute dans un contexte isolé géré par Mastra TS.
* **`AP-002` : EventBus central** : Communication asynchrone par événements d'agents (zéro appel direct), permettant d'ajouter ou d'éditer un agent sans refactoring du reste de la pipeline.
* **`AP-003` : Déterminisme à 70%** : Toutes les décisions d'SMI, de ré-aiguillage d'apprentissage ou de suspension de cours sont gérées par des règles logicielles Rust/TS déterministes strictes, limitant l'appel LLM au strict nécessaire.
* **`AP-004` : Typestate machine** : Impossible de faire transiter un nœud d'apprentissage vers un état invalide ou d'autoriser une révision non due.
* **`AP-005` : SharedContentCache** : Les cours, résumés et fiches concepts générés pour des objectifs sémantiquement similaires sont mutualisés en cache global, réduisant de 80% à 99% les coûts d'appels LLM récurrents pour la communauté.
* **`AP-006` : BudgetGuard** : Télémétrie de coût en direct connectée à l'API de LiteLLM, appliquant un mode économie automatique (déclassement sémantique vers un LLM moins coûteux) si le budget mensuel de l'utilisateur est consommé à 80%.

---

## 5. Section 4 : Les Spécifications Techniques de NEURON-CHAINS v2 {#5-neuron}

* **`NC-001` : 18 Outils natifs Rust (Axum)** : Exécution de toutes les requêtes RAG, de validation, de compression de prompts et de fact-checking dans le moteur Rust compilé pour une latence <1ms et 0$ d'infrastructure.
* **`NC-002` : Génération Section par Section** : La rédaction d'un résumé ou d'un guide s'effectue paragraphe par paragraphe. Cela évite la dérive sémantique du LLM et permet d'exécuter un retry ciblé uniquement sur la section rejetée en cas d'échec.
* **`NC-003` : Anti-Hallucination 3 Couches** :
  - *Couche 1 : Ancrage RAG Strict* (Prévention, Zilliz Cloud).
  - *Couche 2 : Cross-Check Multi-Agents* (Détection DELTA).
  - *Couche 3 : Scoring Probabiliste par Section* (Quantification dans `scy_confidence_reports`).
* **`NC-005` : LLMLingua-2 local** : Compression sémantique de prompt s'exécutant localement via Candle ONNX (0$ de coût).
* **`NC-006` : LanceDB in-process** : Gestion du cache sémantique rapide des embeddings en local pour une latence <2ms (0$ de licence).

---

## 6. L'Architecture Visuelle de Rendu SCY-COSMOS v4.5 {#6-scy_cosmos_visualization_engine}

* **`FLY-010` : Rendu Bi-Moteur (G6 & G2)** : Utilisation d'**AntV G6 (v5)** pour le rendu de graphes topologiques relationnels complexes, et d'**AntV G2 (v5)** pour le rendu statistique et hiérarchique (Treemaps, Sunbursts) afin d'assurer l'optimisation maximale de chaque affichage.
* **`FLY-016` : HiDPI + Font Stack Universel** : Rendu des constellations avec une netteté absolue pour les écrans Retina, et intégration d'une fonction de troncature des étiquettes de texte compatible CJK (Chinois, Japonais, Coréen) et Emojis pour éviter les décalages de boîtes de détection.
* **`FLY-019` : Progressive Rendering en 4 Phases** : Bannissement complet de toute forme de "spinner blanc de chargement". Les éléments du graphe apparaissent progressivement : 
  1. *WebGL Constellation* $	o$ 2. *Étincelle des Hubs* $	o$ 3. *Condensation des Knowledge Cards avec Shimmer localisé* $	o$ 4. *Stabilisation finale du flou sémantique*.
* **`FLY-020` : Learning-Aware Graph (SMI intégré)** : Intégration de l'indice SMI de mémorisation réelle de l'étudiant directement au sein des nœuds du graphe de SCY-COSMOS sous forme d'une aura électro-lumineuse, matérialisant visuellement les concepts maîtrisés et ceux en danger d'oubli (FSRS).
* **`FLY-021` : Source-Linked Nodes** : Chaque concept tracé dans la constellation porte un identifiant de liaison sémantique direct permettant d'un clic de sauter vers le document source d'origine ouvert dans la **Reader Suite**.
* **`FLY-022` : Persistent GPU Buffers** : Les coordonnées physiques du graphe 3D ou 2D ne sont jamais ré-uploadées sur le GPU lors des interactions de pan, de zoom ou de translation, multipliant les performances de rendu par 120.

---

## 7. Les Compléments d'Optimisation, Neurosciences et API (MIA v3.5) {#7-opt}

Ces invariants de pointe ont été testés, validés et auto-optimisés de manière autonome par l'architecture agentique **MIA** :

### A. Équations de Résilience Mathématique :
* **`D-OPT-009` : Sigmoïde de Vitalité Robust (ENGRAM)** :  
  L'oubli actif d'ENGRAM est lissé par une équation sigmoïdale robuste de déclin temporel empêchant les chutes brutales de vitalité durant les premières semaines, assurant une dormance de mémoire froide à J90 précise.
* **`D-OPT-010` : Fail-Safe Gate Anti-Avalanche** :  
  Seuil d'alerte sémantique à $25.0/100$ de vitalité. Tout concept franchissant ce seuil d'oubli voit la force de suppression compétitive du *Retrieval-Induced Forgetting* (RIF) amortie de 90%, neutralisant à 100% tout risque de cascade de mort sémantique du graphe.
* **`D-OPT-011` : Approximation de Barnes-Hut ($O(N \log N)$)** :  
  Remplacement de la complexité quadratique de Verlet $O(N^2)$ par l'approximation spatiale de **Barnes-Hut** s'exécutant sur un arbre de partitionnement Quadtree récursif pour la constellation 2D/3D, permettant d'afficher des millions de nœuds sur mobile.
* **`D-OPT-012` : Softening Epsilon d'Anti-NaN** :  
  Ajout d'une constante de lissage de sûreté $\epsilon = 10^{-6}$ au dénominateur du calcul des forces de répulsion pour éliminer à 100% les divisions par zéro et les coordonnées de type `NaN` lors de superpositions de nœuds.
* **`D-OPT-018` : Lazy Physics Suspension** :  
  Suspension complète des calculs physiques de Verlet du graphe dès que la vitesse de déplacement des nœuds descend sous `0.05` pixel/frame, ramenant l'utilisation CPU à **0%** et préservant la batterie mobile.
* **`D-OPT-019` : Quadtree Object Pooling** :  
  Réutilisation obligatoire d'un pool statique de structures QuadtreeNode pré-alloués en mémoire (`Memory Pool`) pour éliminer tout temps de pause du ramasse-miettes (Garbage Collection) lors de simulations volumineuses.
* **`D-OPT-022` : Socratic Progressive Prompting** :  
  Le Professor AI limite ses réponses à un maximum de 2 paragraphes socratiques par turn et doit obligatoirement terminer par une question ciblée de rappel actif, stimulant l'auto-découverte et économisant 40% de tokens d'output.
* **`D-OPT-026` : Offline-First Local Sync Queue** :  
  Gère les déconnexions du réseau par un mécanisme d'IndexedDB local se synchronisant par lots asynchrones dès le retour du réseau (table `scy_sync_queue` sur Northflank PostgreSQL).
* **`D-OPT-029` : GDPR Anonymization (k-anonymat)** :  
  Masquage de la console d'administration Créateur par un filtre de k-anonymat ($k \ge 10$), protégeant la vie privée et les textes des conversations privées des élèves.
* **`D-OPT-031` : Persistent IndexedDB WAL\n* **`D-OPT-032` : ASCENT-QA Validation Board** :  \n  Intégrer un sous-pipeline d'audit pédagogique de 6 agents (SME, Curriculum Designer, etc.) évaluant à coût de licence nul (0$) de manière asynchrone le contenu généré avant de débloquer l'éligibilité à la certification Proof of Skill (seuil de validation PQS >= 88/100).
* **`D-OPT-033` : DRACO-Based Research Evaluation** :  \n  Soumettre de manière asynchrone chaque livrable de recherche produit à une évaluation d'intégrité de type LLM-as-judge basée sur le benchmark **DRACO** de Perplexity AI (Février 2026) mesurant la véracité, la profondeur, le style et l'ancrage.
* **`D-OPT-034` : Metacognitive Self-Learning Loop** :  \n  Coder la boucle fermée de création de compétences (*procedural skills*) inspirée de **Hermes Agent** (Nous Research, 2026). Le système filtre déterministement toutes les données personnelles (PII Stripping) avant d'enregistrer la compétence pour respecter le RGPD.
* **`D-OPT-035` : SCY-AXIOM Synthesis Engine** :  \n  Remplacer les micro-skills locaux par un système d'escalier inductif géré par l'agent `AXIOMATIZER (AGENT-15)`. Il synthétise les traces réussies de cohortes en "Lois Fondamentales" uniques d'arrière-plan, partagées de manière invisible et globale avec tous les utilisateurs de SCY Forge (Moat d'Intelligence Collective).
* **`D-OPT-036` : SME HITL-Proxy Agent** :  \n  Implémenter l'agent `HITL-PROXY-SME (AGENT-16)` simulant un expert humain sceptique de classe mondiale (Mayo Clinic, MIT, etc.) pour auditer la rigueur scientifique des cursus auto-générés et d'alignement d'examens d'ASCENT.
* **`D-OPT-037` : Dual Student Pathway Split** :  \n  Séparer la machine à états d'apprentissage en deux parcours : Parcours A (Assimilation Active - sans certificat, mais conservant 100% de la complexité d'audit PQS >= 88/100 et d'exactitude de l'expert) et Parcours B (Accréditation Certifiante - avec certificat, exigeant examen SurveyJS, session ARENA et SMI >= 85).
* **`D-OPT-038` : Hybrid Scientific Verification Engine** :  \n  Intégrer une double couche de vérification mathématique et physique avancée : Niveau 1 (local, 0$ coût, résolvant 95% des tâches via l'instance open-source locale **SageMath** et le crate `symengine`/`uom`) et Niveau 2 (cloud, repli d'API **Wolfram Alpha** géré en Mode Batch financé par marge Premium).
* **`D-OPT-043` : MindGraph MCP Server** :  \n  Développer un serveur Model Context Protocol (MCP) local co-localisé au monolithe unifié. Il permet aux agents d'interroger `COSMOS-MINDGRAPH` via un outil unique `query-mindgraph` s'appuyant sur des requêtes SQL récursives CTE hyper-rapides, réduisant de 4.5x la consommation de tokens.
* **`D-OPT-048` : Boost Sommeil (Chronicle)** :  \n  L'agent `CHRONICLE (AGENT-10)` planifie automatiquement une micro-révision de 2 minutes des concepts complexes juste avant le coucher de l'utilisateur pour cibler ces synapses pour la consolidation hippocampale nocturne.
* **`D-OPT-049` : Interleaved Adaptive Routing** :  \n  L'agent `ADAPTIVE-ROUTER (AGENT-06)` impose de manière déterministe un entrelacement (70% domaine cible, 30% connexes/maîtrisés) pour briser l'habituation cognitive du cortex visuel.
* **`D-OPT-050` : STUDENT-AI Teach-Back Diagnostics** :  \n  Si l'étudiant obtient un score de Teach-Back < 40%, `STUDENT-AI` diagnostique si la faille est sémantique ou logique, forçant la génération d'une fiche d'analogie de remédiation (Carte B06).
* **`D-OPT-051` : FSRS Stability Gate before ARENA** :  \n  Verrouiller l'accès aux simulations d'ARENA (Bloom >= 4) tant que la stabilité cognitive FSRS des concepts requis n'est pas >= 3.0 jours, assurant des bases mémorielles saines.
* **`D-OPT-052` : Leech-Blocking Cran-5 IMPRINT** :  \n  Pour les cartes marquées comme 'Leech' (difficiles), bloquer la révision numérique classique et forcer une session d'écriture manuscrite IMPRINT de Cran 5 (50-65 mots) pour ancrer la mémoire motrice.
* **`D-OPT-053` : Hippocampal Spatial Zoom (COSMOS)** :  \n  Intégration du mode 'Semantic Zoom Graph' (COSMOS Mode 22) forçant l'élève à naviguer spatialement entre le micro-concept et la galaxie globale, stimulant les cellules de lieu de l'hippocampe.
* **`D-OPT-054` : Dunning-Kruger Calibration** :  \n  Si la confiance déclarée de l'élève est élevée mais son recall FSRS est bas, l'agent `DRIFT-GUARDIAN (AGENT-07)` force une session Teach-Back immédiate pour briser l'illusion de savoir.
* **`D-OPT-055` : Tiny Habit Re-entry Protocol** :  \n  En cas d'absence > 3 jours, masquer le backlog total de cartes en retard et présenter exclusivement un 'Mode Minimal' de 3 cartes prioritaires pour éliminer le stress de surcharge.
* **`D-OPT-056` : STUDENT-AI Socratic Teach-Back** :  \n  Optimisation de la session Teach-Back pour les concepts spirituels et avancés (Hagah). L'IA élève adopte un rôle d'interlocuteur socratique calibré sur l'SMI de l'élève, exigeant la verbalisation d'imageries mentales, d'analyses contrastives et d'applications pratiques (Bloom 3), ré-ajustant directement la stabilité FSRS.
** :  
  La file de synchronisation locale est stockée sous forme de journal de transactions persistantes (Write-Ahead Log ou WAL) dans l'IndexedDB locale du navigateur, garantissant l'auto-réparation en cas de crash batterie ou de fermeture d'onglet.

### B. Double Rendu Cérébral de SCY-COSMOS v4.5 :
- **Rendu 2D Horizontal Axial (SCY-COSMOS Mode 25)** : Géré par **AntV G6 (v5) / Cosmos** (WebGL). Rendu de la coupe du dessus symétrique divisée par la fissure longitudinale centrale, modélisée en polaire par :
  $$r(	heta) = R_0 \cdot \left( 1 + 0.12 \cdot \cos(2	heta) - 0.04 \cdot \cos(4	heta) 
ight) \cdot \left( 1 - 0.08 \cdot |\sin(	heta)|^4 
ight)$$
- **Rendu 3D Volume Matérialisé (SCY-COSMOS Mode 26)** : Géré par **Three.js** dans React 18 (via OrbitControls et perspective projection). Projette la base de connaissances complète sous forme d'une sphère de particules cérébrale tridimensionnelle en rotation orbitale libre, avec application d'un tri de profondeur (Z-Buffering sémantique) pour estomper les concepts à l'arrière-plan et faire scintiller l'avant-plan.

---

*Tout code rédigé par un agent développeur doit se conformer à cette bible d'architecture. Lisez et intégrez ces invariants de manière systématique avant chaque session de codage.*

<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
PRD source de vérité — adapter pour cyber beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

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

stepsCompleted: ["Step 1: Validate Prerequisites and Extract Requirements", "Step 2: Design Epics and Stories"]
inputDocuments: ["uploads/scy_forge_prd.md", "uploads/scy_forge_prd_neuro_consolidation_blueprint.md", "uploads/design.md", "uploads/experience.md", "uploads/scy_forge_optimized_neuro_mathematics.md", "uploads/scy_forge_brain_graph_rendering_specs.md"]
---

# SCY Forge v3.5 - Epic Breakdown

## Overview
Ce document fournit la décomposition complète des exigences et des décisions architecturales de SCY Forge v3.5 en Épiques (Epics) et récits utilisateurs (User Stories) prêts pour l'implémentation directe et sans hallucination par nos agents de développement.

---

## Requirements Inventory

### Functional Requirements
* **FR-INFRA-01** : PostgreSQL RLS multi-tenant (SaaS) avec 10 tables cyber + 6 legacy tables.
* **FR-PACK-01** : Ingestion MITRE ATT&CK STIX 2.1 → Semantic Tree (14 tactics, 20 branches, 130 techniques).
* **FR-PACK-02** : Generation automatique de Role Subtrees (SOC L1: 6 tactics, SOC L2: 10 tactics, DFIR: 14 tactics).
* **FR-ASCENT-01** : SemanticTreeProvider trait (DCID) — pont générique entre core et domain packs.
* **FR-ASCENT-02** : ASCENT Plan C — 13 agents refactorisés consommant SemanticTreeProvider contracts.
* **FR-COSMOS-01** : COSMOS 4 modes cyber (Mission Tree, SMI Radar, Threat Terrain, Tactical Zoom).
* **FR-APEX-01** : APEX Retention — B11 (IOC), B12 (Kill Chain), B13 (Chain-of-Custody), B14 (Artifact Correlation).
* **FR-TACTICAL-01** : Tactical AI (chat contextuel + hints) — DeepSeek V4 Free ($0).
* **FR-MANAGER-01** : SOC Manager Dashboard — Coverage, Gap Detection, Team Readiness Report.
* **FR-CERT-01** : Proof of Skill certificates — manager sign-off workflow.
* **FR-CORPORATE-01** : Sector Pack Builder — RSSI ajoute règles sectorielles (HDS, PCI-DSS, NIS2) à MITRE.
* **FR-CORPORATE-02** : Compliance Mapping — mapping automatique MITRE → contrôles sectoriels.
* **FR-CORPORATE-03** : Corporate onboarding — RSSI déploie équipe cyber interne (non-tech) en <30 min.
* **FR-B2B2C-01** : Phishing Simulator — formation tous-employés aux règles d'or sécurité.

### NonFunctional Requirements
* **NFR-SCALE-01** : Support de millions de nœuds ($10^6$ nœuds) en production via l'algorithme de partitionnement spatial **Barnes-Hut (O(N log N))** s'exécutant sur un Quadtree.
* **NFR-PERF-01** : Élimination des pauses de Garbage Collection par le recyclage de structures (`Object Pooling`) et suspension physique de Verlet si stabilisation.
* **NFR-RESIL-01** : Résilience réseau hors-ligne via une file `scy_sync_queue` stockée en local dans l'IndexedDB sécurisée par un journal de transactions (WAL).
* **NFR-MATH-01** : Protection anti-NaN via une constante de softening $\epsilon = 10^{-6}$ et anti-overflow d'exposants de vitalité.

### Additional Requirements (Architecture & Tech)
* **ARCH-001** : Double-moteur d'orchestration (Mastra TS sur Northflank pour l'expérience, Rust Axum pour les calculs physiques lourds et le RAG).
* **ARCH-002** : Ingestion sémantique via **Docling Docker** (0$ infrastructure) et vectorisation isolée sur **Zilliz Cloud Serverless** (`partition_key = tenant_id`).

### UX Design Requirements (DESIGN & EXPERIENCE)
* **UX-DR-01** : Utilisation exclusive de la **Palette Chromatique Spatiale** (Noir d'encre `#020205`, Violet profond `#1E1B4B`, Bleu électrique `#2563EB`, Émeraude consolidée `#10B981`, Or impérial `#D97706`).
* **UX-DR-02** : Cinématique d'allumage en 4 phases (The Neural Ignition Reveal) avec skeleton shimmer localisé masquant la latence.

---

[PIVOT-BEACHHEAD v2.0 + GFE] Ce document est mis à jour pour le Cyber SOC/Blue-Team MVP + Generative Forest Engine.
8 épiques cyber (dont Epic 8 GFE mode observatoire). Features éliminées: B2B Creator Console, 11 ingestion cores, IMPRINT, NEURON-CHAINS, CHRONICLE, ARENA.
Features différées: Normal Mode, Finance Suite, COSMOS 3D, GAMMA chain, B2B Creator Console.
Features reclassées B2C long terme: NEURON-CHAINS, ARENA, CHRONICLE, IMPRINT, Normal Mode, Finance Suite, B2B Creator Console.

---

## Epic List (Beachhead v2.0 + GFE)
1. **Epic 1 : Noyau Infrastructure, Base de Données et Sûreté (Northflank + PostgreSQL + Zilliz)**
2. **Epic 2 : Domain Pack Ingestion — Cyber MITRE ATT&CK** *(pivot: remplace NEURON-CHAINS + 11 cores)*
3. **Epic 3 : Semantic Tree & ASCENT Plan C** *(pivot: remplace moteur ENGRAM/Barnes-Hut)*
4. **Epic 4 : COSMOS 4 Modes Cyber** *(pivot: 26 modes → 4 modes SOC-native)*
5. **Epic 5 : SOC Manager Console & RBAC** *(pivot: remplace B2B Creator Console)*
6. **Epic 6 : Tactical AI + APEX B11-B14 Cards** *(pivot: STUDENT AI → Tactical AI, cartes cyber)*
7. **Epic 7 : Role-Based Onboarding & Certification** *(NOUVEAU: SOC L1/L2/DFIR onboarding)*
8. **Epic 8 : Generative Forest Engine (GFE) — Mode Observatoire** *(NOUVEAU: pollinisation intra-domaine MITRE + Seeds + Vision Helm + interface Seed Explorer)*

---

## Epic 1 : Noyau Infrastructure, Base de Données et Sûreté

Cette Épique pose les fondations de la persistance relationnelle, de l'isolation vectorielle et de la surveillance de nos marges de tokens.

### Story 1.1 : Initialisation de la Base Relationnelle (Northflank PostgreSQL)
**En tant que** Développeur Backend,  
**Je veux** instancier les tables SQL consolidées sur Northflank avec règles de Row Level Security (RLS),  
**Afin que** les données sémantiques et d'apprentissages soient stockées de manière hermétique par `tenant_id`.

* **Critères d'Acceptation :**
  - **Given** Une instance active d'Northflank PostgreSQL.
  - **When** J'exécute le script DDL consolidé contenant `scy_users`, `scy_synaptic_vitality` et `scy_project_deliverables`.
  - **Then** Les tables sont créées sans erreurs et les index d'optimisations sont actifs.
  - **And** Toutes les requêtes `SELECT` ou `UPDATE` filtrent de manière déterministe via la politique RLS `tenant_id`.

---

## Epic 1 : Noyau Infrastructure, Base de Données et Sûreté

Cette Épique pose les fondations de la persistance relationnelle, de l'isolation vectorielle et de la surveillance de nos marges de tokens.

### Story 1.1 : Initialisation de la Base Relationnelle (Northflank PostgreSQL)
**En tant que** Développeur Backend,
**Je veux** instancier les tables SQL consolidées sur Northflank avec règles de Row Level Security (RLS),
**Afin que** les données sémantiques et d'apprentissages soient stockées de manière hermétique par `organization_id`.

* **Critères d'Acceptation :**
  - Given Une instance active d'Northflank PostgreSQL avec extension pgvector.
  - When J'exécute le script DDL consolidé (migration `001_init_cyber_beachhead`) contenant les 10 tables cyber + 6 tables legacy.
  - Then Les tables sont créées sans erreurs : `scy_users`, `scy_organizations`, `scy_domain_packs`, `scy_semantic_trees`, `scy_semantic_tree_nodes`, `scy_tree_edges`, `scy_role_subtrees`, `scy_learner_node_states`, `scy_scenario_instances`, `scy_mastery_evaluations`, `scy_tree_operations`.
  - And Toutes les requêtes SELECT/UPDATE filtrent via RLS `organization_id` (pas de fuite cross-tenant).
  - And Les indexes critiques sont actifs (tree_nodes, learner_states, scenario_instances).

### Story 1.2 : Vector Index Zilliz Cloud (Pack Embeddings MITRE)
**En tant que** Développeur Backend,
**Je veux** indexer les embeddings des nodes MITRE ATT&CK dans Zilliz Cloud Serverless,
**Afin que** la recherche sémantique de Tactical AI retourne des résultats <100ms.

* **Critères d'Acceptation :**
  - Given Le pack MITRE ATT&CK ingéré (130 nodes techniques).
  - When Je vectorise chaque node (label + description) avec embeddings 384D.
  - Then Zilliz retourne top-5 similar nodes en p95 <100ms.
  - And BM25 FTS (SQLite/PostgreSQL) complète vector search pour hybrid retrieval.

### Story 1.3 : BudgetGuard LLM Monitoring
**En tant que** SOC Manager,
**Je veux** un dashboard temps réel des coûts LLM par organisation,
**Afin que** le budget Tactical AI ne dépasse pas 150$/mois.

* **Critères d'Acceptation :**
  - Given Un organization avec 5 analysts en activité.
  - When Les appels Tactical AI sont consommés.
  - Then Le dashboard affiche coût courant vs plafond 150$/mois.
  - And À 100%, le Tactical AI bascule en mode lecture seule (pas de génération).
  - And Alertes à 50% (warning) et 100% (blocage) via webhook.

---

## Epic 2 : Domain Pack Ingestion — MITRE ATT&CK Cyber *(IN_MVP — PIVOT)*

**[PIVOT-BEACHHEAD]** Cet epic remplace les 11 ingestion cores génériques + NEURON-CHAINS.
Tout le contenu cyber est **pré-généré** (MITRE ATT&CK STIX, NIST CSF, Sigma rules) au moment de l'onboarding de la SOC.
Zéro appel LLM pour la navigation, les parcours ou les évaluations.

### Story 2.1 : MITRE ATT&CK STIX Ingestion
**En tant que** System Admin SCY Forge,
**Je veux** ingérer la base MITRE ATT&CK STIX 2.1 (14 tactiques, 20 branches, 130 techniques),
**Afin que** le Semantic Tree du pack Cyber soit peuplé automatiquement.

* **Critères d'Acceptation :**
  - Given La STIX bundle MITRE ATT&CK téléchargée (format JSON).
  - When J'exécute `pack-ingest cyber mitre-attack-v14.1`.
  - Then Les tables `scy_domain_packs`, `scy_semantic_trees`, `scy_semantic_tree_nodes`, `scy_tree_edges` sont peuplées (14 trunks, 20 branches, 130 leaves, 153 edges).
  - And Le graphe est valide (pas d'edge orpheline, pas de cycle, root = "Enterprise").
  - And Ingested en <30 minutes (monitoring progress).

### Story 2.2 : Role Subtree Generation (SOC L1/L2/DFIR/SEL)
**En tant que** SOC Manager,
**Je veux** que le système génère automatiquement les sous-arbres par rôle (SOC L1: 6 tactics, SOC L2: 10 tactics, DFIR: 14 tactics),
**Afin que** chaque learner voie uniquement les nœuds pertinents à son poste.

* **Critères d'Acceptation :**
  - Given Le Semantic Tree MITRE complet (14 tactics).
  - When Je sélectionne le rôle "SOC L1" pour l'organisation "Acme Corp".
  - Then Le subtree contient exactement 6 tactiques (Initial Access, Execution, Persistence, Privilege Escalation, Defense Evasion, Credential Access).
  - And Le subtree est stocké dans `scy_role_subtrees` avec mastery_threshold = 0.70.
  - And La NodeState pour chaque learner est initialisée (mastery=0.0, exposure=0).

### Story 2.3 : Pack Validation & Integrity Guard
**En tant que** System Admin,
**Je veux** que le ValidationGuardProvider vérifie l'intégrité du pack avant activation,
**Afin que** les organizations ne reçoivent jamais un pack MITRE corrompu ou incomplet.

* **Critères d'Acceptation :**
  - Given Un pack MITRE avec une edge manquante (Tactic → Technique orpheline).
  - When Le ValidationGuardProvider exécute `validate_pack_integrity()`.
  - Then Le pack est rejeté avec rapport d'erreur (node_id orphelin, edge_kind invalide).
  - And Le pack passe si toutes les edges sont valides et tous les nodes ont au moins 1 edge.

---

## Epic 3 : Semantic Tree & ASCENT Plan C *(IN_MVP — PIVOT)*

**[PIVOT-BEACHHEAD]** Cet epic remplace le Moteur ENGRAM/Barnes-Hut + Constellation 2D/3D (différée au Mode 23).
Le Semantic Tree est un **DAG pondéré** — calculs Rust purs, $0 LLM.
13 agents ASCENT refactorisés via le trait `SemanticTreeProvider` (DCID).

### Story 3.1 : SemanticTreeProvider Trait (DCID Bridge)
**En tant que** Développeur Rust,
**Je veux** implémenter le trait `SemanticTreeProvider` comme pont unique entre le core et les domain packs,
**Afin que** les 13 agents ASCENT consomment des contrats génériques sans savoir que MITRE ATT&CK existe.

* **Critères d'Acceptation :**
  - Given Un trait Rust `SemanticTreeProvider` avec méthodes `plant_tree()`, `graft_node()`, `test_node()`, `prune_node()`, `myelinate_node()`.
  - When L'Agent-04 (Learning-Conductor) appelle `tree_provider.graft_node(node_id, prereq_ids)`.
  - Then Le trait fonctionne avec n'importe quel domain pack (MITRE, Finance, Medical) sans modification du core.
  - And Le pack Cyber implémente le trait avec la logique MITRE ATT&CK.

### Story 3.2 : ASCENT Plan C — Agent Refactor
**En tant que** Architecte Backend,
**Je veux** refactoriser les 13 agents ASCENT pour qu'ils consomment les SemanticTreeProvider contracts,
**Afin que** le pipeline ASCENT soit agnostic au domaine métier.

* **Critères d'Acceptation :**
  - Given Les 13 agents (Goal-Interpreter, Content-Scout, DAG-Architect, Learning-Conductor, Performance-Analyzer, Adaptive-Router, etc.).
  - When Chaque agent consomme `SemanticTreeProvider::graft_node()` au lieu de `cyber_graft_technique()`.
  - Then Les agents fonctionnent avec n'importe quel domain pack (MITRE, Finance, etc.).
  - And Le pipeline complet ASCENT fonctionne pour SOC L1 (MITRE) et pourrait fonctionner pour Finance demain.

### Story 3.3 : Gap Detection Engine (SMI-based)
**En tant que** SOC Manager,
**Je veux** un moteur de détection de lacunes basé sur les SMI par nœud sémantique,
**Afin que** je puisse identifier les compétences manquantes de mon équipe avant un incident.

* **Critères d'Acceptation :**
  - Given Une équipe de 5 analysts avec mastery scores par nœud MITRE.
  - When Le Performance-Analyzer calcule les gaps (mastery < 0.70 sur tactiques critiques).
  - Then Le dashboard affiche : gaps par analyste, gaps par tactic, recommandations de rattrapage.
  - And Exportable en PDF (SOC Manager brief — Proof of Gap).

* **Critères d'Acceptation :**
  - **Given** L'intégration de Three.js et OrbitControls dans React 18.
  - **When** L'utilisateur clique et glisse sa souris pour orbiter autour de sa base de connaissances globale.
  - **Then** Le cerveau s'oriente de manière tridimensionnelle en direct.
  - **And** Les nœuds d'arrière-plan subissent le Z-Buffering sémantique (taille et opacité atténuées de moitié) tandis que les nœuds d'avant-plan rayonnent avec éclat.

---

## Epic 4 : COSMOS 4 Modes Cyber *(IN_MVP — PIVOT)*

**[PIVOT-BEACHHEAD]** COSMOS passe de 26 modes génériques à **4 modes SOC-native**.
Mode 3D (23) différé post-MVP.

### Story 4.1 : Mode Mission Tree (Vue Hiérarchique)
**En tant que** SOC Analyst,
**Je veux** voir le Semantic Tree MITRE ATT&CK en vue hiérarchique (tactics → techniques),
**Afin que** je comprenne ma progression dans le cadre d'une mission SOC.

* **Critères d'Acceptation :**
  - Given Un Semantic Tree MITRE avec 14 tactics racines.
  - When J'ouvre le Mode Mission Tree.
  - Then Je vois 14 troncs colorés par tactic, avec branches (techniques) et feuilles (sub-techniques).
  - And Les nœuds mastered (≥0.70) sont verts, en-progress sont jaunes, non-commencés sont gris.

### Story 4.2 : Mode SMI Radar (Performance Globale)
**En tant que** SOC Manager,
**Je veux** un radar SMI montrant la maîtrise de chaque analyste par tactic,
**Afin que** je voie instantanément les gaps d'équipe.

* **Critères d'Acceptation :**
  - Given 5 analysts avec mastery scores par nœud MITRE.
  - When J'ouvre le SMI Radar.
  - Then Je vois 14 axes (tactics) avec scores par analyste (0.0-1.0).
  - And Les zones rouges (<0.50) sont mises en évidence avec recommandations de rattrapage.

### Story 4.3 : Mode Threat Terrain (Auto-Linking IOCs)
**En tant que** SOC Analyst,
**Je veux** un mode qui auto-linke mes alertes EDR aux nœuds MITRE + playbooks,
**Afin que** je comprenne immédiatement la technique et la parade associée.

* **Critères d'Acceptation :*
  - Given Une alerte EDR avec IOC "T1566.001" (Spearphishing Attachment).
  - When J'ouvre Threat Terrain.
  - Then Le système auto-linke : IOC → T1566 → Tactic "Initial Access" → Playbook "Phishing Response" → Scénarios associés.
  - And Le lien est affiché en <500ms.

### Story 4.4 : Mode Tactical Zoom (Niveau Opérationnel)
**En tant que** SOC Analyst,
**Je veux** zoomer sur un nœud MITRE précis pour voir les détails (CVE, Sigma rules, playbook),
**Afin que** je puisse agir immédiatement sur une technique.

* **Critères d'Acceptation :*
  - Given Un nœud "T1566.001" sélectionné.
  - When J'ouvre Tactical Zoom.
  - Then Je vois : description MITRE, platforms affectées, CVE associés, Sigma rules, playbook de réponse, scenarios d'évaluation associés.
  - And Un bouton "Lancer Évaluation" permet de tester ma maîtrise de ce nœud.

### Story 4.5 **[DEFERRED]** : Mode 3D Threat Terrain
*[PIVOT-BEACHHEAD — DEFERRED]* Mode 3D interactif (Three.js) → Phase 2+.
Raison : 4 modes 2D suffisent pour MVP. Mode 3D nécessite WebGL complexe + Barnes-Hut physics (déjà différé).

---

## Epic 6 : Tactical AI + APEX B11-B14 Cards *(IN_MVP — PIVOT)*

**[PIVOT-BEACHHEAD]** STUDENT AI → **Tactical AI** (chat SOC contextuel).
Nouvelles cartes APEX cyber : B11 (IOC Identification), B12 (Kill Chain Mapping), B13 (Chain-of-Custody), B14 (Artifact Correlation).
DeepSeek V4 Free ($0) pour le Tactical AI live.

### Story 6.1 : Tactical AI Chat (DeepSeek V4 Free)
**En tant que** SOC Analyst,
**Je veux** un chat contextuel (Tactical AI) qui répond à mes questions sur les techniques MITRE, les playbooks et les IOCs,
**Afin que** je puisse agir vite sans chercher dans la documentation.

* **Critères d'Acceptation :*
  - Given Une alerte EDR avec technique "T1566.001".
  - When Je demande au Tactical AI "Comment répondre à T1566.001 ?".
  - Then Le Tactical AI retourne : description MITRE + playbook associé + IOCs à chercher + Sigma rules.
  - And La réponse est générée en <2s via DeepSeek V4 Free ($0).
  - And Le contexte est lié au Semantic Tree (pas de hallucination sur des techniques non-ingérées).

### Story 6.2 : APEX Card Type B11 — IOC Identification
**En tant que** SOC Analyst,
**Je veux** des cartes APEX dédiées à l'identification d'IOCs (IP, domain, hash),
**Afin que** je retienne les patterns de détection d'indicateurs.

* **Critères d'Acceptation :*
  - Given Un scénario d'évaluation avec IOC "185.220.101.34".
  - When Je révise la carte B11.
  - Then La carte affiche : IOC type → contexte → origine → action à prendre.
  - And FSRS scheduling appliqué (intervalle adaptative selon performance).

### Story 6.3 : APEX Card Type B12 — Kill Chain Mapping
**En tant que** SOC Analyst,
**Je veux** des cartes APEX qui me font mapper un IOC à sa phase de kill chain MITRE,
**Afin que** je comprenne la timeline d'une attaque.

* **Critères d'Acceptation :*
  - Given Un IOC "Cobalt Strike beacon" à mapper.
  - When Je révise la carte B12.
  - Then La carte affiche la kill chain (7 phases) avec le IOC placé dans la bonne phase.
  - And Les prérequis (phases précédentes) sont vérifiés avant révélation.

### Story 6.4 : APEX Card B13 — Chain-of-Custody
**En tant que** SOC Analyst,
**Je veux** des cartes APEX pour la documentation chaîne de custody (forensique),
**Afin que** je sache documenter les preuves de manière recevable en tribunal.

* **Critères d'Acceptation :*
  - Given Un scénario DFIR avec artifact "malware.exe".
  - When Je révise la carte B13.
  - Then La carte affiche : steps de préservation + hash verification + timestamps + autorités de custody.
  - And La carte est évaluable en scénario DFIR.

### Story 6.5 : APEX Card B14 — Artifact Correlation
**En tant que** SOC Analyst,
**Je veux** des cartes APEX pour la corrélation d'artefacts cross-sources (EDR + SIEM + OSINT),
**Afin que** je puisse relier un IOC à des événements multiples.

* **Critères d'Acceptation :*
  - Given Des artifacts "185.220.101.34" (EDR) + "malware.exe" (SIEM) + " phishing email" (OSINT).
  - When Je révise la carte B14.
  - Then La carte affiche : artifact → sources → corrélation → timeline → action recommandée.

---

## Epic 7 : Role-Based Onboarding & Certification *(IN_MVP — PIVOT)*

**[PIVOT-BEACHHEAD]** Onboarding SOC en **<5 minutes** (SOC L1) avec role subtree.
Certification Proof of Skill cyber-native (pas certificate générique).

### Story 7.1 : Role-Based Onboarding Flow (SOC L1 < 5min)
**En tant que** SOC Manager,
**Je veux** créer mon organisation + importer mes analysts + assigner leurs roles,
**Afin que** chaque analyste soit opérationnel en <5 minutes.

* **Critères d'Acceptation :*
  - Given Le pack MITRE ATT&CK ingéré dans l'organisation "Acme Corp".
  - When Je crée l'org + j'ajoute "alice@acme.com" avec role "SOC L1".
  - Then Alice reçoit un email d'invitation + son Semantic Tree SOC L1 (6 tactics) est prêt.
  - And Alice peut commencer son premier scénario en <5min après clic sur le lien.

### Story 7.2 : SOC L2 & DFIR Extended Onboarding
**En tant que** SOC Manager,
**Je veux** assigner des roles plus avancés (SOC L2, DFIR) avec plus de tactics,
**Afin que** les analystes expérimentés bénéficient d'un onboarding adapté.

* **Critères d'Acceptation :*
  - Given Un analyste "bob@acme.com" avec role "DFIR".
  - When Bob se connecte pour la première fois.
  - Then Bob voit 14 tactics (toutes les tactiques MITRE + focus DFIR).
  - And Le mastery threshold est ajusté à 0.70 (identique pour tous les roles).
  - And Le temps estimé d'onboarding est affiché (~40h pour DFIR).

### Story 7.3 : Proof of Skill — Certificate Cyber
**En tant que** SOC Manager,
**Je veux** générer un certificat Proof of Skill quand un analyste atteint mastery ≥ 0.70,
**Afin que** je puisse prouver la compétence de mon équipe.

* **Critères d'Acceptation :*
  - Given Alice (SOC L1) avec mastery ≥ 0.70 sur 4/6 tactics.
  - When Alice complète le scénario d'évaluation final.
  - Then Un certificat PDF est généré : "SCY Forge — SOC L1 Certified — Mastery 0.85/1.0".
  - And Le certificat contient : nom, org, date, tactics couverts, score SMI, verification URL.
  - And Le SOC Manager peut exporter un "Team Readiness Report" avec tous les certificats.

### Story 7.4 : Certification Manager Workflow (Sign-off)
**En tant que** SOC Manager,
**Je veux** valider ou rejeter les certifications de mon équipe,
**Afin que** la certification Proof of Skill ait une valeur métier (pas auto-signée).

* **Critères d'Acceptation :*
  - Given Alice a soumis son évaluation finale (score 0.82/1.0).
  - When Bob (SOC Manager) ouvre le workflow de certification.
  - Then Bob voit : score, temps passé, gaps restants, recommandations.
  - And Bob peut : (1) Approuver → certificat émis, (2) Rejeter → feedback envoyé à Alice, (3) Demander révision.

## Epic 5 : SOC Manager Console & RBAC *(IN_MVP — PIVOT)*

**[PIVOT-BEACHHEAD]** Cet epic remplace la Console Créateur Élite (B2B Creator Console — **ÉLIMINÉE**).
La SOC Manager Console est orientée **gestion d'équipe** (RBAC + Coverage + Gap Detection), pas création de contenu.

### Story 5.1 : SOC Manager Dashboard — Coverage & Gap Detection
**En tant que** SOC Manager,
**Je veux** un dashboard montrant la couverture MITRE de mon équipe + les gaps de maîtrise,
**Afin que** je sache où former mon équipe avant un incident.

* **Critères d'Acceptation :*
  - Given 5 analysts avec roles SOC L1/L2/DFIR.
  - When J'ouvre le Manager Dashboard.
  - Then Je vois : coverage % par tactic, gaps >0.30 par analyste, recommandations de parcours, export PDF "Team Readiness Report".
  - And Le dashboard est filtré par organization_id (RLS).

### Story 5.2 : RBAC — Role-Based Access Control
**En tant que** System Admin,
**Je veux** que chaque utilisateur voie uniquement les données de son organization + son role subtree,
**Afin que** les données SOC soient strictement isolées.

* **Critères d'Acceptation :*
  - Given Un user "alice@acme.com" avec role "SOC L1" dans org "Acme Corp".
  - When Alice se connecte.
  - Then Alice ne voit que les 6 tactics SOC L1 (pas DFIR tactics).
  - And Alice ne voit aucun data d'une autre organization (RLS PostgreSQL).
  - And Le SOC Manager "bob@acme.com" voit toutes les données de Acme Corp.

### Story 5.3 : Offboarding & Data Deletion
**En tant que** SOC Manager,
**Je veux** supprimer un analyste de mon organization + exporter ses données,
**Afin que** la conformité RGPD soit respectée.

* **Critères d'Acceptation :*
  - Given Un learner "alice@acme.com" dans org "Acme Corp".
  - When Je clique "Offboard Alice".
  - Then Toutes les données d'Alice sont supprimées (anonymisées) dans les 24h.
  - And Un export PDF de son parcours + mastery scores est généré avant deletion.

7. **Epic 7 : Role-Based Onboarding & Certification** *(NOUVEAU: SOC L1/L2/DFIR onboarding)*
8. **Epic 8 : Generative Forest Engine (GFE) — Mode Observatoire** *(NOUVEAU: pollinisation intra-domaine MITRE + Seeds + Vision Helm + interface Seed Explorer)*

---

## Epic 8 : Generative Forest Engine (GFE) — Mode Observatoire *(IN_MVP — PIVOT)*

**[D-021 — D-022]** Le GFE est le **3ème pilier** de SCY Forge. Sur le cyber beachhead M0-M36, il fonctionne en **mode observatoire** : pollinisation intra-domaine sur le Semantic Tree MITRE ATT&CK pour produire des Seeds de nouveaux scenarios d'entraînement.

**Ce que fait l'Epic 8** :
- Implémente le SemanticTreeProvider trait complet (plant_tree, graft_node, test_node, prune_node, myelinate_node)
- Construit l'arborization du KG MITRE en Semantic Tree dirigé
- Opère la pollinisation intra-domaine (conditions L1-L4) entre tactiques MITRE éloignées
- Produit des Seeds avec scoring Viability/Fecundity/PlantScore
- Configure le Vision Helm Cyber (axes : DetectionRate, ResponseVelocity, Coverage, Compliance, FalsePositiveRate)
- Interface Seed Explorer : le SOC Manager voit les Seeds générées, leur score et peut valider leur germination

**Ce qui est différé post-MVP** :
- Cross-pollination inter-STB (MITRE + secteurs HDS/PCI-DSS/NIS2)
- Germination automatique (Seeds → nouveaux sous-arbres de formation)
- Blending + Link Prediction + SME (mécanismes d'émergence endogène)

### Story 8.1 : SemanticTreeProvider Trait — Le Seul Pont DCID

**En tant que** Architecte Core,
**Je veux** un trait générique `SemanticTreeProvider` qui est le **seul pont** entre le core SCYForge et les domain packs,
**Afin que** le cœur ne contienne AUCUN terme métier cyber en dur.

* **Critères d'Acceptation :*
  - Given Le crate `scy-shared` contient le trait `SemanticTreeProvider`.
  - When Un agent ASCENT appelle `provider.plant_tree("MITRE-ATT&CK-v14.1")`.
  - Then Le core ne référence aucun terme MITRE/SOC/Sigma/CVE.
  - And Le trait expose 5 méthodes : `plant_tree`, `graft_node`, `test_node`, `prune_node`, `myelinate_node`.
  - And Chaque méthode retourne un `TreeOpResult` avec event ID pour EventBus.

### Story 8.2 : Arborization — KG MITRE → Semantic Tree Dirigé

**En tant que** Backend Engineer,
**Je veux** transformer le Knowledge Graph plat MITRE ATT&CK (STIX) en un Semantic Tree dirigé (tronc→branches→feuilles),
**Afin que** l'arbre respecte la structure d'apprentissage : tronc = tactiques (80/20), branches = sous-domaines, feuilles = concepts opérables.

* **Critères d'Acceptation :*
  - Given Le Domain Pack Cyber v0.2 est chargé (14 tactiques, 20 branches, 130 techniques).
  - When L'arborization s'exécute via `SemanticTreeProvider::plant_tree`.
  - Then 14 troncs sont créés (un par tactic ATT&CK).
  - And Les edges sont classifiés par `EdgeKind` : Trunk, Branch, Leaf, Prereq, Relates, Contradicts, Supersedes.
  - And Le OwnerKind est `DomainPack` (propriété du pack, pas de l'utilisateur).

### Story 8.3 : Pollination Intra-Domaine — Conditions L1-L4

**En tant que** AI Engineer,
**Je veux** un opérateur `Pollination(A, B, context)` qui teste les 4 conditions de fécondité avant de produire une Seed,
**Afin que** les Seeds générées soient viables et alignées avec la Vision Helm.

* **Critères d'Acceptation :*
  - Given Deux tactiques MITRE éloignées (ex: TA0043 "Reconnaissance" + TA0010 "Exfiltration").
  - When L'opérateur `Pollination` évalue le croisement.
  - Then L1 vérifie `distance(A,B) ≥ θ_min` (≥ 0.40).
  - And L2 vérifie ∃ pont logique entre A et B.
  - And L3 vérifie que le lien A↔B n'existe pas déjà dans le KG.
  - And L4 vérifie `align(A⊕B, VisionHelm) ≥ τ` (≥ 0.60 pour beachhead).
  - And Si les 4 conditions sont satisfaites → Seed créée. Sinon → ∅ (stérile).

### Story 8.4 : Seed Scoring — Viability + Fecundity + PlantScore

**En tant que** AI Engineer,
**Je veux** scorer chaque Seed avec 3 métriques : Viability, Fecundity et PlantScore,
**Afin que** le SOC Manager puisse prioriser les Seeds les plus prometteuses.

* **Critères d'Acceptation :*
  - Given Une Seed candidate est produite par Pollination.
  - When Le scoring s'exécute.
  - Then `Viability = feasibility × alignment × non_redundancy × resource_fit` (∈ [0,1]).
  - And `Fecundity = potential_subtrees × strategic_reach` (∈ [0,1]).
  - And `PlantScore = Viability^γ × Fecundity^(1−γ)` avec γ = 0.6 (prudence pour beachhead).
  - And Les Seeds avec PlantScore < 0.40 sont classées DORMANT.

### Story 8.5 : Vision Helm — Configuration Cyber

**En tant que** Architecte Core,
**Je veux** un Vision Helm configurable par domaine pack,
**Afin que** l'alignement des Seeds et la priorisation ASCENT soient gouvernés par les objectifs stratégiques du client.

* **Critères d'Acceptation :*
  - Given Le Domain Pack Cyber est chargé.
  - When Le Vision Helm est configuré.
  - Then Le vecteur h ∈ ℝ⁵ = [DetectionRate, ResponseVelocity, Coverage, Compliance, FalsePositiveRate].
  - And Le graphe d'objectifs G_H est créé : "Auto SOC L1" → "Master 6 tactics" → "APT29 scenario" → KPIs.
  - And `align(x, H) = cos(proj(x), h)` est utilisable par tous les agents (ASCENT, GFE, COSMOS).

### Story 8.6 : Seed Explorer Interface — SOC Manager Visualize Seeds

**En tant que** SOC Manager (P-SEL),
**Je veux** une interface "Seed Explorer" qui me montre les Seeds générées par le GFE avec leur score et leur provenance,
**Afin que** je puisse valider manuellement les Seeds prometteuses et les transformer en scenarios d'entraînement.

* **Critères d'Acceptation :*
  - Given 15 Seeds ont été produites par pollinisation intra-domaine.
  - When J'ouvre le Seed Explorer dans le Manager Dashboard.
  - Then Je vois : Seed ID, Core Proposition, ParentA/ParentB, PlantScore, Viability, Fecundity, Statut (POLLINATED/VIABLE/DORMANT).
  - And Je peux filtrer par statut, score minimum, tactic source.
  - And Je peux valider une Seed → elle passe au statut GERMINATING → un nouveau scenario ARENA est créé.
  - And Je peux archiver une Seed → elle passe au statut DORMANT (réveil possible plus tard).

### Story 8.7 : Traceabilité Seed — W3C PROV-DM + Bitemporel

**En tant que** Architecte Core,
**Je veux** que toute Seed soit traçable selon W3C PROV-DM avec double temporalité (event time + ingestion time),
**Afin que** la provenance de chaque Seed soit immuable et auditable.

* **Critères d'Acceptation :*
  - Given Une Seed est créée par Pollination(TA0043, TA0010, ctx).
  - When La Seed est persistée.
  - Then `wasDerivedFrom(TA0043, TA0010)` est enregistré (parenthood immuable).
  - And `wasGeneratedBy(agent_gfe_id)` est enregistré.
  - And Deux timestamps sont stockés : event_time (création Seed) + ingestion_time (découverte dans le KG).
  - And La Seed ne peut PAS être modifiée après création (append-only).

### Story 8.8 **[POST-MVP]** : Cross-Pollination Inter-STB (MITRE + Secteurs)

*[PIVOT-BEACHHEAD — POST-MVP M36+]* La cross-pollination entre STB sectoriels (MITRE + HDS/PCI-DSS/NIS2) est **différée**.
Raison : Nécessite des sector packs complets pas encore disponibles au MVP.
Active quand : 3+ clients corporate PEAK ont des sector packs déployés.

---

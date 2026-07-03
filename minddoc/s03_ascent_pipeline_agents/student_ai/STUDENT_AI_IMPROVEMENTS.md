# SCYForge — STUDENT AI : Moteur d'Évaluation Cognitive & Teach-Back

> **Statut** : architecture active. **Aucun code.**
> **Source** : rapport d'amélioration utilisateur (2026-07-02) + sceau de validation humaine.
> **Intégration** : ce module est un **consumer du noyau ASCENT** (comme APEX, COSMOS, BRAIN). Il ne contient aucune logique métier autonome — tout passe par les providers DCID.

---

## 0. Vision globale

STUDENT AI est la **couche d'évaluation cognitive réversible** de SCYForge.

Contrairement aux tuteurs IA traditionnels qui évaluent les réponses d'un utilisateur, STUDENT AI évalue la **qualité de sa compréhension à travers l'enseignement** (teach-back). Cette inversion du paradigme est l'un des différenciateurs les plus forts de SCYForge.

L'objectif des 9 améliorations n'est pas de modifier cette philosophie, mais de la rendre plus robuste scientifiquement, plus difficile à reproduire, et plus précise dans l'analyse cognitive.

---

## 1. Positionnement architectural

STUDENT AI est un **module du noyau ASCENT**, pas un agent séparé. Il est consommé par :

| Module ASCENT | Ce qu'il consomme de STUDENT AI |
|---|---|
| **Ag-05 PERFORMANCE-ANALYZER** | SMI, MSS, profondeur conceptuelle, profiles d'explication |
| **Ag-09 SKILL-CERTIFIER** | AutonomyProof incluant les dimensions STUDENT AI |
| **Ag-11 ARENA** | friction adaptative basée sur le profil cognitif |
| **Ag-07 DRIFT-GUARDIAN** | détection dérive sur MSS et profondeur |
| **COSMOS** | visualisations V5/V6 intégrant les scores STUDENT AI |

### 1.1 Les 9 améliorations intégrées au scope architectural

| # | Amélioration | Composant architectural | Statut |
|---|---|---|---|
| **P1** | **Mental Structure Score (MSS)** | Nouveau score cognitif dans `LearnerNodeState` + `MasteryEvaluation` | IN_MVP |
| **P2** | **Profondeur conceptuelle (0-7)** | Remplace couverture binaire dans `SemanticNode` + `LearnerNodeState` | IN_MVP |
| **P3** | **Séparation pédagogique/LLM** | `PedagogicalStrategyResolver` (déterministe) → LLM ne fait que rédiger | IN_MVP |
| **P4** | **Boucle métacognition** | `MetacognitionPrompt` injecté dans `DecisionScenarioProvider` | IN_MVP |
| **P5** | **Visualisation graphique du rapport** | COSMOS V5 = vue concepts solides/fragiles/liens/zones isolées | IN_MVP |
| **P6** | **Recalibration FSRS étendue** | `FSRSRust` étendu : difficulty, confidence, priorité pédagogique, remédiation | IN_MVP |
| **P7** | **Profils d'explication** | `ExplanationProfile` stocké dans `LearnerState` (6 profils) | IN_MVP |
| **P8** | **Mode Présentation** | Nouveau `ScenarioFormat` : `presentation` (5 critères d'évaluation) | POST_MVP |
| **P9** | **Intelligence collective Teach-Back** | `CHRONICLE` Ag-10 agrège données anonymisées → insights globaux | POST_MVP |

---

## 2. Les 9 améliorations détaillées

### 2.1 P1 — Mental Structure Score (MSS)

**Problème** : le moteur sait détecter les concepts présents/absents, mais pas comment la connaissance est organisée dans l'esprit de l'utilisateur.

**Solution** : créer un score MSS qui évalue :
- ordre logique des explications ;
- hiérarchie des idées ;
- causalité ;
- dépendances entre concepts ;
- capacité à construire un raisonnement progressif.

**Intégration** :
- `MSS` devient une nouvelle dimension de `MasteryEvaluation` (côte à côte avec `SMI`).
- Calculé par `PERFORMANCE-ANALYZER (Ag-05)` à partir des traces `AutonomyTrace`.
- MSS ∈ [0.0, 1.0], seuil de maîtrise ≥ 0.60 (pack-défini).
- Affiché dans COSMOS V5 (Mastery Tree) comme overlay de structure.

**Formula (métrique composite)** :
```
MSS = w1·ordre_logique + w2·hiérarchie + w3·causalité + w4·dépendances + w5·raisonnement_progressif
```
Poids par défaut (pack-définis) : w1=0.20, w2=0.20, w3=0.25, w4=0.20, w5=0.15.

---

### 2.2 P2 — Profondeur conceptuelle (niveaux 0-7)

**Problème** : un concept est binaire (présent/absent). Insuffisant pour mesurer la compréhension.

**Solution** : chaque concept dispose d'un niveau de maîtrise :

| Niveau | Label | Signification |
|---|---|---|
| 0 | **Absent** | Le concept n'est pas connu |
| 1 | **Cit(o)** | Simplement cité dans une explication |
| 2 | **Défini** | Peut donner une définition |
| 3 | **Expliqué** | Peut expliquer le mécanisme |
| 4 | **Relié** | Peut le relier à d'autres concepts |
| 5 | **Illustré** | Peut donner un exemple concret |
| 6 | **Justifié** | Peut justifier pourquoi c'est vrai/important |
| 7 | **Réutilisé** | Peut le réutiliser spontanément dans un nouveau contexte |

**Intégration** :
- `conceptDepth[N]` = niveau 0-7 dans `LearnerNodeState`.
- Remplace le booléen `present/absent` dans `ConceptCoverage`.
- Alimente le `SemanticTreePriorityPolicy` : les nœuds à profondeur basse sont prioritaires pour le grafting.
- Affiché dans COSMOS V1 (Mastery Tree) comme profondeur de couleur.

---

### 2.3 P3 — Séparation pédagogique/LLM

**Problème** : aujourd'hui `Analyse → LLM → Question`. La pédagogie dépend du modèle.

**Solution** : introduire une couche intermédiaire déterministe :

```
Analyse
  ↓
Classification exacte du problème
  ↓
Sélection d'une stratégie pédagogique (déterministe)
  ↓
Le LLM ne fait que rédiger la question
```

**Stratégies pédagogiques** (déterministes, codées dans `PedagogicalStrategyResolver`) :

| Stratégie | Quand l'utiliser | Exemple |
|---|---|---|
| **Clarification** | Concept flou/mal défini | « Peux-tu définir X plus précisément ? » |
| **Contraste** | Deux concepts confondus | « Quelle est la différence entre X et Y ? » |
| **Curiosité** | Manque de motivation | « Pourquoi penses-tu que X fonctionne comme ça ? » |
| **Contre-exemple** | Connaissance trop générale | « Donne un cas où X ne s'applique pas. » |
| **Cas limite** | Compréhension superficielle | « Que se passe-t-il si X est poussé à l'extrême ? » |
| **Reformulation** | Vérifier la compréhension | « Explique-moi X comme si j'avais 10 ans. » |
| **Analogie** | Concept abstrait | « X ressemble à Y parce que… » |

**Intégration** :
- `PedagogicalStrategyResolver` = service Rust pur ($0 LLM).
- Le LLM (DeepSeek V4 Free / Claude Premium) ne fait que **rédiger** la question dans la langue et le style de l'utilisateur.
- La stratégie est loggée dans `AutonomyTrace` pour audit pédagogique.

---

### 2.4 P4 — Boucle métacognition

**Problème** : pas de boucle de réflexion sur sa propre compréhension après une session.

**Solution** : après chaque session d'évaluation, ajouter une question de métacognition :

> « Si tu devais refaire cette explication maintenant, qu'est-ce que tu changerais ? »

**Intégration** :
- `MetacognitionPrompt` injecté automatiquement dans `DecisionScenarioProvider`.
- La réponse est analysée par `PERFORMANCE-ANALYZER` pour détecter :
  - les zones de doute conscient (gap identification) ;
  - les faux sentiments de maîtrise (illusion de compétence).
- Les réponses alimentent le `MetacognitionLog` dans `scy_learner_node_states`.
- Couplé à `DRIFT-GUARDIAN (Ag-07)` : une métacognition négative récurrente sur un nœud → flagged for review.

---

### 2.5 P5 — Visualisation graphique du rapport (COSMOS V5)

**Problème** : le rapport actuel est très textuel. L'utilisateur doit *lire* sa compréhension au lieu de la *voir*.

**Solution** : COSMOS V5 rend visibles immédiatement :
- les concepts solides (nœuds verts, haute profondeur) ;
- les concepts fragiles (nœuds rouges, faible profondeur) ;
- les liens entre concepts (lianes KG) ;
- les zones isolées (îlots sans connexion au tronc).

**Intégration** :
- COSMOS V1 (Mastery Tree) = vue principale, couleurs = SMI, profondeur = conceptDepth.
- COSMOS V4 (Heatmap) = vue gaps, rouge = concepts absents/fragiles.
- COSMOS V5 (Envelope Grid) = vue autonomie par cellule.
- Overlay MSS : les nœuds avec haute MSS sont mis en évidence (anneau de confiance).
- Mode rapport = export PDF avec les 4 vues COSMOS captures.

---

### 2.6 P6 — Recalibration FSRS étendue

**Problème** : aujourd'hui, seul `stability` est ajusté. Les autres paramètres FSRS sont statiques.

**Solution** : ajuster également :
- **difficulty** (D) : difficulté propre du concept (densité Sigma, criticité) ;
- **confidence** : niveau de confiance déclaré par l'apprenant vs performance réelle ;
- **priorité pédagogique** : ordre d'apprentissage basé sur les gaps détectés ;
- **besoin de remédiation** : flag automatique quand MSS < seuil sur un nœud tronc.

**Intégration** :
- `FSRSRust` étendu avec 4 paramètres ajustables par `PERFORMANCE-ANALYZER`.
- `confidence` = double signal : (a) déclaré par l'apprenant (teach-back Q), (b) mesuré par performance (scénario). L'écart = illusion de compétence.
- `remediationFlag` = nouveau champ dans `scy_learner_node_states`, calculé après chaque évaluation.
- `PriorityPolicy` lit les flags de remédiation pour prioriser le grafting/reconstruction.

**Formula (effet de l'explication sur FSRS)** :
```
Δstability = f(MSS, conceptDepth, explanationProfile)
Δdifficulty = f(feedbackQuality, cognitiveFriction)
Δconfidence = performance_reelle − confiance_declarée (doit décroître)
```

---

### 2.7 P7 — Profils d'explication

**Problème** : le moteur ne reconnaît pas le style naturel d'explication de l'utilisateur.

**Solution** : reconnaître 6 profils d'explication :

| Profil | Caractéristique | Exemple |
|---|---|---|
| **Pédagogique** | Structure progressive, exemples didactiques | « D'abord, on définit X… Ensuite, Y… » |
| **Scientifique** | Précision terminologique, formulation rigoureuse | « La variance σ² est définie par… » |
| **Intuitif** | Analogies, métaphores, pas de jargon | « C'est comme un tuyau qui… » |
| **Analogies** | Recours systématique aux comparaisons | « X fonctionne comme Y parce que… » |
| **Exemples** | Illustration par cas concrets avant théorie | « Prenons l'exemple de… » |
| **Raisonnement** | Enchaînement logique déductif | « Si A alors B, car… » |

**Intégration** :
- `ExplanationProfile` = type dans `LearnerState` (calculé après 3+ teach-backs).
- Détecté par `PERFORMANCE-ANALYZER` via analyse de patterns linguistiques (LLM léger) + features结构lles ( longueur, connecteurs logiques, ratio métaphores ).
- Le profil指导 `PedagogicalStrategyResolver` : un profile "intuitif" recoit plus d'analogies ; un profile "scientifique" recoit plus de contre-exemples.
- Exporté dans `AutonomyProof` pour le certificat.

---

### 2.8 P8 — Mode Présentation (POST_MVP)

**Problème** : la discussion teach-back ne mesure pas la capacité à présenter oralement, compétence critique en environnement professionnel.

**Solution** : un mode « Présentation » où l'utilisateur dispose de 5 minutes pour présenter un sujet devant un public virtuel. L'IA n'interrompt que quand quelque chose devient difficile à suivre.

**Critères d'évaluation** :

| Critère | Poids | Mesuré par |
|---|---|---|
| Qualité de la structure | 25% | Organisation du discours (intro/développement/conclusion) |
| Fluidité | 20% | Filler words, hésitations, transitions |
| Persuasion | 20% | Capacité à convaincre (arguments, exemples) |
| Pédagogie | 20% | Adaptation au public, clarté des explications |
| Précision | 10% | Exactitude des faits et concepts |
| Gestion des questions | 5% | Réponses aux interruptions |

**Intégration** :
- POST_MVP (après validation P2 Transfer Ratio).
- Nouveau `ScenarioFormat` : `presentation`.
- Alimenté par `BRAIN (Ag-08)` pour la génération du public virtuel.
- Évalué par `SKILL-CERTIFIER (Ag-09)` avec `PresentationRubricProvider`.

---

### 2.9 P9 — Intelligence collective Teach-Back (POST_MVP)

**Problème** : les données Teach-Back sont anonymisées mais non exploitées collectivement.

**Solution** : exploiter les données anonymisées pour détecter :
- les concepts systématiquement mal compris ;
- les analogies les plus efficaces ;
- les exemples qui fonctionnent le mieux ;
- les nœuds ASCENT trop difficiles ;
- les cartes APEX mal conçues.

**Intégration** :
- `CHRONICLE (Ag-10)` agrège les Teach-Back anonymisés dans `KnowledgeBase`.
- `INSIGHTS ENGINE` (Ag-12 ou extension) détecte les patterns globaux.
- Les insights alimentent :
  - `AdaptiveRouter` pour prioriser les concepts difficiles ;
  - `DAG-ARCHITECT` pour restructurer les branches ;
  - `DomainPack` pour améliorer les scénarios ARENA.
- Chaque session Teach-Back améliore progressivement tout le système.

**Règle d'or** : anonymisation stricte. Aucune identification individuelle ne quitte le tenant.

---

## 3. Flux d'intégration dans ASCENT

### 3.1 Flux Teach-Back (P1-P7 IN_MVP)

```
Apprenant termine un nœud (SMI ≥ threshold)
    │
    ▼
PERFORMANCE-ANALYZER (Ag-05)
    │   ├── Calcule MSS (P1)
    │   ├── Calcule conceptDepth[N] (P2)
    │   ├── Applique PedagogicalStrategyResolver (P3)
    │   ├── Injecte MetacognitionPrompt (P4)
    │   └── Calcule FSRS étendu (P6) + ExplanationProfile (P7)
    │
    ▼
AutonomyTrace { mss, conceptDepth, strategy, metacognition, fsrsExtended, profile }
    │
    ▼
SKILL-CERTIFIER (Ag-09)
    │   └── AutonomyProof inclut MSS + profondeur + profil
    │
    ▼
COSMOS (visualisation)
    │   ├── V1 : Mastery Tree avec overlay MSS (P5)
    │   ├── V4 : Heatmap gaps (P5)
    │   └── V5 : Envelope grid (P5)
```

### 3.2 Flux P8-P9 (POST_MVP)

```
P8 — Mode Présentation
  BRAIN (Ag-08) → génère public virtuel
  → ScenarioFormat "presentation" → ARENA (Ag-11)
  → SKILL-CERTIFIER avec PresentationRubricProvider
  → COSMOS V6 (Jauge de présentation)

P9 — Intelligence Collective
  CHRONICLE (Ag-10) → agrège Teach-Back anonymisés
  → INSIGHTS ENGINE → détecte patterns globaux
  → AdaptiveRouter + DAG-ARCHITECT + DomainPack (amélioration)
```

---

## 4. Structure de données

### 4.1 Extensions `LearnerNodeState`

```rust
pub struct LearnerNodeState {
    // ... champs existants ...
    
    // P1 — Mental Structure Score
    pub mss: Option<f32>,                    // ∈ [0.0, 1.0], None = pas encore évalué
    
    // P2 — Profondeur conceptuelle
    pub concept_depth: u8,                   // ∈ [0..7], 0 = absent, 7 = réutilisé spontanément
    
    // P6 — FSRS étendu
    pub difficulty: Option<f32>,             // difficulté propre du concept
    pub confidence_declared: Option<f32>,    // confiance déclarée par l'apprenant
    pub confidence_measured: Option<f32>,    // confiance mesurée par performance
    pub remediation_flag: bool,              // true = MSS < seuil sur nœud tronc
    
    // P7 — Profil d'explication
    pub explanation_profile: Option<ExplanationProfile>, // détecté après 3+ teach-backs
}

pub enum ExplanationProfile {
    Pedagogique,
    Scientifique,
    Intuitif,
    Analogies,
    Exemples,
    Raisonnement,
}
```

### 4.2 Extensions `MasteryEvaluation`

```rust
pub struct MasteryEvaluation {
    // ... champs existants ...
    
    // P1 — MSS
    pub mss_score: Option<f32>,
    pub mss_components: Option<MssComponents>, // 5 sous-scores
    
    // P2 — Profondeur conceptuelle
    pub concept_depths: std::collections::HashMap<Uuid, u8>, // node_id → depth
    
    // P6 — FSRS étendu
    pub fsrs_extended: Option<FsrsExtended>,
    
    // P7 — Profil
    pub explanation_profile: Option<ExplanationProfile>,
}

pub struct MssComponents {
    pub ordre_logique: f32,
    pub hierarchie: f32,
    pub causalite: f32,
    pub dependances: f32,
    pub raisonnement_progressif: f32,
}

pub struct FsrsExtended {
    pub stability: f32,          // existant
    pub difficulty: f32,         // P6 — nouveau
    pub confidence: f32,         // P6 — nouveau
    pub priorite_pedagogique: f8,// P6 — nouveau (0.0-1.0)
}
```

### 4.3 Extensions `AutonomyTrace` (log d'apprentissage)

```rust
pub struct AutonomyTrace {
    // ... champs existants ...
    
    // P1 — MSS
    pub mss: Option<f32>,
    
    // P3 — Stratégie pédagogique
    pub pedagogical_strategy: Option<PedagogicalStrategy>,
    
    // P4 — Métacognition
    pub metacognition_response: Option<String>,    // texte brut
    pub metacognition_gap_detected: Option<bool>,   // dérive détectée
    
    // P6 — FSRS étendu
    pub fsrs_extended: Option<FsrsExtended>,
}
```

---

## 5. Matrice IN_MVP vs POST_MVP

| Amélioration | Statut | Composant | Coût estimé |
|---|---|---|---|
| P1 — MSS | IN_MVP | Nouveau score + calcul Ag-05 | Moyen (analyse texte) |
| P2 — Profondeur conceptuelle | IN_MVP | Remplace booléen par u8 | Faible (données) |
| P3 — Séparation pédagogique/LLM | IN_MVP | PedResolver ($0) + prompt template | Faible (logique) |
| P4 — Boucle métacognition | IN_MVP | Prompt injection + analyse | Faible (prompt + parsing) |
| P5 — Visualisation rapport | IN_MVP | COSMOS V5 overlays | Faible (frontend) |
| P6 — Recalibration FSRS étendue | IN_MVP | Extension FSRSRust | Moyen (algorithme) |
| P7 — Profils d'explication | IN_MVP | Détection + stockage + guide stratégie | Moyen (LLM léger) |
| P8 — Mode Présentation | POST_MVP | Nouveau format scénario + rubrique | Élevé (scénarisation) |
| P9 — Intelligence collective | POST_MVP | Ag-10 CHRONICLE extension + insights | Élevé (agrégation) |

---

## 6. Impact sur les composants existants

| Composant existant | Impact |
|---|---|
| `SemanticTreePriorityPolicy` | Lit `conceptDepth` pour prioriser les nœuds à profondeur basse |
| `FSRSRust` | Étendu avec difficulty, confidence, priorité, remédiation (P6) |
| `PerformanceAnalyzer (Ag-05)` | Calcule MSS (P1) + conceptDepth (P2) + profiles (P7) |
| `DecisionScenarioProvider` | Injecte MetacognitionPrompt (P4) |
| `SKILL-CERTIFIER (Ag-09)` | AutonomyProof inclut MSS + profondeur + profil (P1, P2, P7) |
| `DRIFT-GUARDIAN (Ag-07)` | Détecte dérive sur MSS et conceptDepth (P1, P2) |
| `CHRONICLE (Ag-10)` | Agrège Teach-Back anonymisés (P9 — POST_MVP) |
| `COSMOS` | V1 overlay MSS, V4 heatmap gaps, V5 envelope avec profondeur (P5) |
| `BRAIN (Ag-08)` | Génère public virtuel Mode Présentation (P8 — POST_MVP) |

---

## 7. Ce qui n'est PAS touché

- La philosophie Teach-Back (évaluer par l'enseignement) reste **intacte**.
- ASCENT ne change pas de structure.
- Aucun terme métier cyber n'est ajouté au noyau.
- Aucune dépendance payante (P1-P7 sont $0 LLM avec DeepSeek V4 Free).

---

*STUDENT AI — Module architectural intégré au noyau ASCENT. 9 améliorations documentées, 7 IN_MVP, 2 POST_MVP.*
*Source : rapport d'amélioration utilisateur (2026-07-02), sceau de validation humaine.*

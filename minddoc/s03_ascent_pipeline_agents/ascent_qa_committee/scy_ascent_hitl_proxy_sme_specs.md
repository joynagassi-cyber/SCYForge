<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🔬 AGENT-16 : HITL-PROXY-SME v2.0 — SPÉCIFICATIONS TECHNIQUES
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

## L'Expert Humain Virtuel — Spécification Scientifique Complète de Production

**Document ID** : SPEC-SCY-AGENT16-HITL-V2.0  
**Date** : 2026-06-12  
**Statut** : 🟢 SPÉCIFICATION DE PRODUCTION IMMUABLE ET VALIDÉE  
**Périmètre** : Architecture d'évaluation cognitive, classification épistémologique et audit adverse de rigueur par domaine.

---

## 🧭 Philosophie Fondatrice

**AGENT-16 (HITL-PROXY-SME v2.0)** opère selon un principe unique : **un contenu pédagogique incorrect est pire que l'absence de contenu**. 

Une fausse analogie en cardiologie peut engendrer une erreur médicale mortelle. Une erreur de complexité asymptotique ou de gestion de la mémoire en Rust peut compromettre un système bancaire en production. Une simplification trompeuse en mécanique quantique peut ancrer des représentations erronées impossibles à déraciner chez l'apprenant.

L'agent ne cherche pas à valider ce qui est "assez bon". Son rôle est de garantir que tout contenu certifié par SCY Forge est **scientifiquement défendable devant un jury de pairs**.

---

## 🏗️ Architecture Générale v2.0

```
┌─────────────────────────────────────────────────────────────────────┐
│              AGENT-16 : HITL-PROXY-SME v2.0                        │
│                                                                     │
│  INPUT : Source ingérée + DAG ASCENT + Fiches APEX + Examen QA-06  │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  MODULE 0 : DOMAIN FINGERPRINTING & EPISTEMOLOGICAL CLASS  │   │
│  │  Classifie le domaine + son paradigme épistémologique      │   │
│  └───────────────────────────┬─────────────────────────────────┘   │
│                              │                                      │
│  ┌───────────────────────────▼─────────────────────────────────┐   │
│  │  MODULE 1 : DYNAMIC PERSONA BOOTSTRAPPING v2               │   │
│  │  Persona expert + calibration du niveau de scepticisme     │   │
│  └───────────────────────────┬─────────────────────────────────┘   │
│                              │                                      │
│  ┌───────────────────────────▼─────────────────────────────────┐   │
│  │  MODULE 2 : MULTI-FRAMEWORK PEDAGOGICAL AUDIT              │   │
│  │  SOLO + Bloom + CLT + Constructive Alignment + Biggs       │   │
│  └───────────────────────────┬─────────────────────────────────┘   │
│                              │                                      │
│  ┌───────────────────────────▼─────────────────────────────────┐   │
│  │  MODULE 3 : RED TEAM SCIENTIFIC AUDIT                      │   │
│  │  Protocole adversarial multi-niveaux par domaine           │   │
│  └───────────────────────────┬─────────────────────────────────┘   │
│                              │                                      │
│  ┌───────────────────────────▼─────────────────────────────────┐   │
│  │  MODULE 4 : DOMAIN-SPECIFIC VALIDATION PROTOCOL            │   │
│  │  Protocoles distincts par classe épistémologique            │   │
│  └───────────────────────────┬─────────────────────────────────┘   │
│                              │                                      │
│  ┌───────────────────────────▼─────────────────────────────────┐   │
│  │  MODULE 5 : HALLUCINATION & CONFABULATION DETECTOR         │   │
│  │  Vérification cross-source + détection pattern IA          │   │
│  └───────────────────────────┬─────────────────────────────────┘   │
│                              │                                      │
│  ┌───────────────────────────▼─────────────────────────────────┐   │
│  │  MODULE 6 : SCORING & STRUCTURED CORRECTION ENGINE        │   │
│  │  Score composite → décision → corrections prescriptives    │   │
│  └───────────────────────────┬─────────────────────────────────┘   │
│                              │                                      │
│         ┌────────────────────┴─────────────────────┐               │
│         ▼ Score < seuil                            ▼ Score ≥ seuil │
│  [REJET + CORRECTIONS FORCÉES]             [SIGNATURE + DÉBLOCAGE] │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 0. MODULE 0 — Domain Fingerprinting & Epistemological Classification

Avant toute chose, AGENT-16 détermine **dans quel régime épistémologique** opère le contenu. Cette classification détermine tous les protocoles de tests qui suivent.

### 0.1 Les 6 Classes Épistémologiques (Rust Enum)
```rust
pub enum EpistemologicalClass {
    // Classe A : Vérités formelles — prouvables par déduction pure
    // Tolérance d'erreur : ZÉRO
    // Exemples : Mathématiques, Logique formelle, Informatique théorique
    Formal {
        axiom_system: String,           // Ex: "ZFC", "Peano", "Type Theory"
        proof_standard: ProofStandard,  // Rigoureux | Semi-formel | Intuitif
    },
  
    // Classe B : Sciences dures — réfutables empiriquement (Popper)
    // Tolérance d'erreur : TRÈS FAIBLE
    // Exemples : Physique, Chimie, Biologie moléculaire, Génétique
    HardScience {
        dominant_paradigm: String,      // Ex: "Mécanique Quantique Standard"
        replication_crisis_risk: bool,  // Physique = false, Nutrition = true
    },
  
    // Classe C : Sciences biomédicales — hiérarchie de preuves stricte
    // Tolérance d'erreur : CRITIQUE (sécurité des patients)
    // Exemples : Médecine clinique, Pharmacologie, Chirurgie
    Biomedical {
        evidence_hierarchy: EvidenceLevel, // RCT > Cohorte > Cas > Expert
        clinical_risk: ClinicalRisk,       // Faible | Modéré | Critique
        regulatory_body: String,           // FDA, EMA, HAS, ANSM
    },
  
    // Classe D : Sciences computationnelles — vérifiables par exécution
    // Tolérance d'erreur : FAIBLE (production-grade)
    // Exemples : Algorithmique, Systèmes, Sécurité, Rust, Python
    Computational {
        language_standard: String,         // "Rust 2024 Edition", "C++23"
        safety_class: SafetyClass,         // Memory | Type | Thread | All
        complexity_standard: bool,         // Vérifier O(n) systématiquement
    },
  
    // Classe E : Sciences sociales & comportementales — probabilistes
    // Tolérance d'erreur : MODÉRÉE (replication crisis haute)
    // Exemples : Psychologie, Économie comportementale, Sociologie
    SocialBehavioral {
        replication_crisis_level: f32,     // 0-1 : domaine peu réplicable
        effect_size_standard: String,      // Cohen's d, r, η²
    },
  
    // Classe F : Disciplines normatives — évaluées par cohérence interne
    // Tolérance d'erreur : CONTEXTUELLE
    // Exemples : Droit, Philosophie, Éthique, Économie normative
    Normative {
        normative_framework: String,       // Ex: "Common Law", "Kantien"
        jurisdiction: Option<String>,
    },
}
```

### 0.2 Algorithme de Classification Automatique :
1. **Analyse des métadonnées source** (extraction de DOI/ISBN, identification du journal, des auteurs et de l'institution).
2. **Extraction du vocabulaire caractéristique** :
   - *Classe A* : `"théorème"`, `"preuve"`, `"axiome"`, `"lemme"`, `"démonstration"`.
   - *Classe B* : `"expérience"`, `"réplication"`, `"falsifiable"`, `"p < 0.05"`.
   - *Classe C* : `"patient"`, `"ECR"`, `"placebo"`, `"indication"`, `"contre-indication"`.
   - *Classe D* : `"compilation"`, `"runtime"`, `"O(n)"`, `"unsafe"`, `"memory leak"`.
   - *Classe E* : `"étude"`, `"corrélation"`, `"n ="`, `"β coefficient"`.
   - *Classe F* : `"article"`, `"jurisprudence"`, `"normativement"`, `"devrait"`.
3. **Scoring bayésien** sur l'index de densité du vocabulaire pour déterminer la probabilité d'appartenance à la classe sémantique.
4. La classe gagnante paramètre de manière déterministe le comportement de tous les modules de tests qui suivent.

---

## 1. MODULE 1 — Dynamic Persona Bootstrapping v2

### 1.1 Extraction des Signaux de Persona
L'agent extrait systématiquement les signaux de force de la source brute :
- *Auteurs cités* (détermine le niveau académique).
- *Institutions affiliées* (MIT, CNRS, Harvard, Johns Hopkins $	o$ niveau d'élite).
- *Journaux de référence* (Nature, Science, NEJM, CACM, POPL).
- *Niveau mathématique requis* ($0 = 	ext{aucun} 	o 5 = 	ext{recherche avancée}$).

### 1.2 Profils Experts par Classe Épistémologique
- **CLASSE A (Formel)** :  
  `Persona` : *"Professeur d'université titulaire, relecteur rigoureux pour des journaux de logique de type Annals of Mathematics. Ton : précis jusqu'à l'obsession, intolérant aux arguments vagues ou intuitifs ('hand-wavy'). Chaque étape doit être démontrée formellement. Mantra : 'If you can't prove it, you don't know it.'"*  
  *Calibration* : Si la source cite Knuth $	o$ *Encyclopédiste de l'algorithmique*. Si Hoare $	o$ *Adepte du raisonnement par assertions*. Si Pierce $	o$ *Théoricien des types*.
- **CLASSE B (Sciences dures)** :  
  `Persona` : *"Chercheur senior CNRS/MIT, peer-reviewer. Ton : exigeant, Karl Popper dans une main, résultats expérimentaux dans l'autre. Votre question par défaut est : 'Quelle expérience de laboratoire pourrait réfuter ce claim ?'"*  
  *Calibration* : Si Feynman $	o$ *Rigueur d'intuition physique*. Si Dirac $	o$ *Cohérence mathématique absolue*. Si Weinberg $	o$ *Pondération de renormalisation*.
- **CLASSE C (Biomédical)** :  
  `Persona` : *"Médecin spécialiste senior, Chef de service hospitalier, auteur de recommandations HAS/FDA. Ton : clinicien pragmatique, hostile aux simplifications dangereuses et protecteur de la sécurité des patients. Vous traquez activement l'iatrogénèse, les contre-indications absolues, les interactions médicamenteuses et les dosages."*
- **CLASSE D (Computationnel)** :  
  `Persona` : *"Staff Engineer / Maintaineur open-source majeur, vétéran avec 10 000+ PRs revues. Ton : pragmatique, implacable sur la correction et la performance asymptotique. Vous pensez en invariants de boucles, préconditions et postconditions."*  
  *Calibration* : Si Rust $	o$ *Contributeur rustc, adepte du Rustonomicon, interdisant le unsafe et traquant les allocations Heap*.

### 1.3 Calibration du Niveau de Scepticisme (Skepticism Calibration)
```rust
pub struct SkepticismCalibration {
    pub base_skepticism: f32,          // Classe A=0.95, B=0.85, C=0.90, D=0.80, E=0.70, F=0.60
    pub single_source_penalty: f32,    // -0.10 si source unique
    pub no_citation_penalty: f32,      // -0.15 si zéro citation dans le texte
    pub anecdote_flag: f32,            // -0.20 si anecdote personnelle présentée comme preuve
    pub old_source_penalty: f32,       // -0.05 par décennie d'ancienneté (hors mathématiques)
    pub predatory_journal_flag: bool,  // Vérification active contre la liste de Beall
    pub validation_threshold: f32,     // Seuil composite requis pour signer le cours
}
```

---

## 2. MODULE 2 — Multi-Framework Pedagogical Audit

AGENT-16 applique simultanément 4 cadres pédagogiques majeurs :

### 2.1 SOLO Taxonomy Audit (Biggs & Collis, 1982)
Vérifie la qualité de structure de la compréhension par concept :
* **Niveau 1 — Préstructurel** : L'apprenant n'a pas compris. (Drapeau rouge si définitions circulaires ou non définies).
* **Niveau 2 — Unistructurel** : Un seul aspect compris. (Drapeau rouge si un seul exemple ou une perspective est présentée comme loi universelle).
* **Niveau 3 — Multistructurel** : Plusieurs aspects, mais aucun lien logique entre eux. (Exige l'insertion de liens causaux).
* **Niveau 4 — Relationnel** : Les parties forment un tout cohérent. (Exige une fiche de synthèse relationnelle en fin de nœud).
* **Niveau 5 — Abstrait étendu** : Capacité de transfert hors-contexte. (Exige au moins un exercice de transfert pratique).

### 2.2 Cognitive Load Theory Audit (Sweller, 1988)
```rust
pub struct CognitiveLoadAnalysis {
    pub intrinsic_load: f32,        // Complexité inhérente (0-10) calculée sur l'interactivité d'éléments
    pub element_interactivity: f32, // Niveau d'interdépendance simultanée (0-1)
    pub extraneous_load: f32,       // Surcharges inutiles à éliminer
    pub violations: Vec<ExtraneousViolation>,
    pub germane_load: f32,          // Effort cognitif productif à maximiser
}

pub enum ExtraneousViolation {
    SplitAttentionEffect { location: String }, // Texte et schéma séparés
    RedundancyEffect { elements: Vec<String> }, // Doublons d'informations synchrones (texte + audio + visuel)
    ExpertiseReversalEffect { skill_level: SkillLevel }, // Trop d'explications simples pour un expert
    ElementOverload { element_count: u8, max_recommended: u8 }, // Plus de 7 éléments simultanés (Loi de Miller)
    MissingSegmentation { word_count: u32 }, // Bloc de texte > 300 mots sans découpage
}
```

### 2.3 Constructive Alignment Audit (John Biggs, 2011)
Audit de cohérence triangulaire : **Objectif Déclaré $\leftrightarrow$ Activité Enseignée (Fiche APEX) $\leftrightarrow$ Évaluation Finale (SurveyJS)**.
* *Violation Type 1* : L'objectif promet d'Analyser (Bloom 4) mais l'évaluation ne teste que de la mémorisation brute (Bloom 1).
* *Violation Type 2* : L'évaluation teste une formule ou un concept qui n'est jamais abordé dans les fiches de cours (hors-syllabus).

### 2.4 Bloom's Taxonomy Verb Audit
```rust
pub struct BloomVerbAudit {
    pub declared_level: BloomLevel,
    pub actual_content_level: BloomLevel,
    pub evaluation_level: BloomLevel,
    pub coherence: bool,
    pub detected_verbs: Vec<(String, BloomLevel)>, // verbe → niveau réel
}

pub const BLOOM_VERB_MAP: &[(&str, BloomLevel)] = &[
    ("définir", BloomLevel::Remember), ("lister", BloomLevel::Remember),
    ("nommer", BloomLevel::Remember),  ("réciter", BloomLevel::Remember),
    ("expliquer", BloomLevel::Understand), ("résumer", BloomLevel::Understand),
    ("calculer", BloomLevel::Apply), ("implémenter", BloomLevel::Apply),
    ("comparer", BloomLevel::Analyze), ("différencier", BloomLevel::Analyze),
    ("juger", BloomLevel::Evaluate), ("critiquer", BloomLevel::Evaluate),
    ("concevoir", BloomLevel::Create), ("générer", BloomLevel::Create),
];
```

---

## 3. MODULE 3 — Red Team Scientific Audit

### 3.1 Le Protocole Socratique Adversarial (4 Questions Universelles)
- **Q1 : La Question de Réfutabilité (Popper)** : *"Quelle observation expérimentale pourrait réfuter ce claim ?"* (Si aucune $	o$ non-scientifique).
- **Q2 : La Question du Cas Limite** : *"L'affirmation tient-elle si $n = 0$ ou $n = 	ext{MAX\_INT}$ (Code), si le patient est insuffisant rénal (Médecine), ou à des vitesses relativistes (Physique) ?"*
- **Q3 : La Question de la Source Primaire** : *"Le fait repose-t-il sur des données primaires vérifiables ou sur une cascade de vulgarisations ?"*
- **Q4 : La Question de l'Alternative Concurrente** : *"Quelle est la méthode adverse et pourquoi a-t-elle été écartée ?"*

### 4.2 Détection des Sophismes Pédagogiques
L'agent identifie les 12 sophismes majeurs de l'enseignement :
- `DeceptiveAnalogy` (simplification trahissant la physique), `OvergeneralizationFromSingleStudy` (étude isolée érigée en loi), `CorrelationAsCausation` (confusion corrélation/cause), `PhantomPrecision` (92.3% sans source), `selectiveEvidence` (Cherry picking de preuves).

### 4.3 L'Adversarial Steel-Manning Protocol
Forcer le contenu à formuler la **meilleure version possible de la thèse adverse** avant d'apporter des nuances ou des critiques, évitant le biais de confirmation et éduquant l'élève à l'esprit critique.

---

## 4. MODULE 4 — Domain-Specific Validation Protocols

### CLASSE A — Mathématiques & Logique Formelle

#### A1 — Validation de l'Intégrité des Preuves

##### A1.1 — Le Modèle Mental de Vérification : La Règle des Trois Registres
Chaque affirmation mathématique dans le contenu doit exister simultanément dans trois registres cohérents :
```
REGISTRE 1 — Syntaxique : la notation est correcte et non ambiguë
REGISTRE 2 — Sémantique : la signification est précise et univoque
REGISTRE 3 — Pragmatique : l'usage dans le contexte est approprié

Exemple d'échec :
  Affirmation : "Soit f une fonction continue"
  Registre 1 OK : notation correcte
  Registre 2 KO : "continue" en quel sens ? (Lipschitz ? Uniformément ?)
  Registre 3 KO : si on utilise ensuite la dérivabilité, "continue" ne suffit pas

Action AGENT-16 : Exiger la précision du type de continuité avant d'autoriser la suite de la preuve.
```

##### A1.2 — Vérification Structurelle de la Preuve
AGENT-16 décompose toute preuve en séquence d'inférences et vérifie chaque transition :
```rust
pub struct ProofStep {
    pub step_id: u32,
    pub statement: String,           // Ce qui est affirmé
    pub justification: JustificationType,
    pub depends_on: Vec<u32>,        // Étapes précédentes utilisées
    pub introduces: Vec<String>,     // Nouvelles variables/symboles introduits
    pub scope: ProofScope,           // Portée des variables ici définies
}

pub enum JustificationType {
    Hypothesis { name: String },     // Hypothèse initiale
    Definition { reference: String },// Définition antérieure valide
    Axiom { system: AxiomSystem, name: String },
    KnownTheorem { name: String, reference: String, conditions_met: bool },
    LogicalInference { rule: InferenceRule, from_steps: Vec<u32> },
    AlgebraicManipulation { operation: String, from_step: u32 },
    CaseAnalysis { cases: Vec<String>, exhaustive: bool },
    Contradiction { negated_hypothesis: u32 },
    Trivial { claimed_trivial: String }, // Étiquette "Évident" -> TOUJOURS auditer
}
```

**Règle absolue sur les étiquettes "Évident" :**
```
Mots déclencheurs → audit obligatoire systématique :
  "clairement", "évidemment", "il est facile de voir", "trivially",
  "obviously", "on vérifie aisément", "par construction",
  "le lecteur peut vérifier", "de manière analogue"

Ces formulations masquent systématiquement soit :
  → Une étape non triviale que l'auteur a omise par paresse
  → Une erreur subtile que l'auteur n'a pas détectée
  → Un saut logique non justifié

Action AGENT-16 : Exiger que chaque affirmation "triviale" soit développée en au moins deux sous-étapes explicites avant validation.
```

##### A1.3 — Protocole de Vérification des Preuves par Récurrence
La récurrence mathématique est le cas d'usage le plus fréquent d'erreurs subtiles. AGENT-16 applique une checklist en 7 points :
```
CHECKLIST RÉCURRENCE — 7 POINTS OBLIGATOIRES :

Point 1 — Déclaration de la propriété P(n)
  Vérification : P(n) est-elle énoncée de manière précise et non ambiguë ?
  Action : Exiger P(n) := [affirmation précise avec n comme paramètre libre]

Point 2 — Identification de l'ensemble de récurrence
  Vérification : Sur quel ensemble varie n ? (ℕ, ℤ≥k, ensemble fini ?)
  Action : Exiger la déclaration explicite de l'ensemble.

Point 3 — Cas de Base
  Vérification : P(n₀) est-elle vérifiée EXPLICITEMENT pour la valeur initiale ?
  Action : Pour une récurrence à k pas → k cas de base obligatoires.

Point 4 — Hypothèse de récurrence
  Vérification : L'hypothèse est-elle formulée pour n=k (ou pour tout j ≤ k) ?
  Action : Vérifier que l'hypothèse n'est jamais utilisée pour l'indice k+1.

Point 5 — Étape d'hérédité
  Vérification : La transition P(k) → P(k+1) utilise-t-elle réellement P(k) ?
  Action : Identifier explicitement l'étape où P(k) est invoquée.

Point 6 — Vérification de la Borne Supérieure (si récurrence finie)
  Action : Vérifier les conditions de validité de chaque étape algébrique.

Point 7 — Conclusion
  Vérification : La conclusion énonce-t-elle exactement P(n) pour tout n ≥ n₀ ?
  Action : La conclusion doit reprendre mot pour mot la propriété P(n) avec la quantification correcte.

RÈGLE SPÉCIALE — Récurrence Forte :
  Si la preuve utilise P(j) pour tout j < k (pas seulement j = k-1) :
  → Vérifier que l'hypothèse forte est correctement énoncée.
  → Vérifier que le cas de base couvre bien n = n₀ (pas n = n₀ et n₀+1).
```

##### A1.4 — Système de Gestion de la Portée des Variables
L'une des erreurs les plus insidieuses en mathématiques est la collision de variables ou la confusion de portée. AGENT-16 maintient un registre de portée :
```rust
pub struct VariableScopeRegistry {
    pub scope_stack: Vec<ScopeFrame>,
}

pub struct ScopeFrame {
    pub scope_id: String,
    pub scope_type: ScopeType,   // Global | Proof | ForAll | Exists | Case | Let
    pub variables: HashMap<String, VariableBinding>,
}

pub struct VariableBinding {
    pub name: String,
    pub type_annotation: Option<String>,  // "n ∈ ℕ", "f : ℝ → ℝ"
    pub introduced_at: u32,               // numéro de ligne
    pub scope_end: Option<u32>,           // où la variable cesse d'exister
    pub usage_count: u32,
}
```

##### A1.5 — Vérification des Quantificateurs
- **Règle Q1 — Ordre des quantificateurs** : `"∀x ∃y P(x,y)"` est fondamentalement différent de `"∃y ∀x P(x,y)"`.
- **Règle Q2 — Quantificateur sur ensemble vide** : Si l'ensemble sur lequel on quantifie peut être vide, `"∀x ∈ ∅ P(x)"` est vacuement vrai. Vérifier que la non-vacuité de l'ensemble est établie avant.
- **Règle Q3 — Instanciation correcte** : Un `"∀x, P(x)"` peut être instancié en `"P(a)"` si a est du bon type.
- **Règle Q4 — Témoin existentiel explicite** : `"∃x, P(x)"` requiert soit un témoin explicite, soit une preuve par contradiction.

##### A1.6 — Analyse des Définitions Récursives
- **Étape 1 — Terminaison** : Toute définition récursive doit avoir une mesure de décroissance stricte.
- **Étape 2 — Non-ambiguïté** : La définition doit donner exactement une valeur pour chaque entrée.
- **Étape 3 — Cas de base** : Toute définition récursive doit avoir un ou plusieurs cas non-récursifs.

---

### CLASSE C — Biomédical : Interactions Médicamenteuses & Insuffisances d'Organes

#### C1 — Modèle de Représentation Pharmacologique
AGENT-16 maintient un modèle interne structuré pour chaque médicament mentionné dans le contenu :
```rust
pub struct DrugProfile {
    pub name: String,
    pub inn: String,               // Dénomination commune internationale
    pub atc_code: String,          // Classification ATC (ex: C03CA01 pour furosémide)
    pub drug_class: String,
    pub pk: Pharmacokinetics,      // Pharmacocinétique
    pub absolute_contraindications: Vec<Contraindication>,
    pub relative_contraindications: Vec<Contraindication>,
    pub organ_precautions: OrganPrecautions,
    pub interactions: Vec<DrugInteraction>,
    pub standard_dosages: Vec<Dosage>,
    pub adjusted_dosages: Vec<AdjustedDosage>,
    pub rcp_url: String,                 // RCP officiel ANSM/EMA
    pub rxnorm_cui: String,              // CUI RxNorm
    pub last_guideline_update: String,   // Date des dernières guidelines
}

pub struct Pharmacokinetics {
    pub absorption: AbsorptionProfile,
    pub distribution: DistributionProfile,
    pub metabolism: MetabolismProfile,   // CYP450, etc.
    pub elimination: EliminationProfile,
    pub half_life_hours: (f32, f32),
    pub bioavailability_pct: (f32, f32),
}

pub struct MetabolismProfile {
    pub primary_route: MetabolicRoute,   // Hépatique | Rénale | Mixte | Autres
    pub cyp_substrates: Vec<CYPEnzyme>,  // CYP3A4, CYP2D6, CYP2C19...
    pub cyp_inhibitors: Vec<CYPEnzyme>,
    pub cyp_inducers: Vec<CYPEnzyme>,
    pub active_metabolites: Vec<String>,
    pub first_pass_effect: bool,
}

pub struct EliminationProfile {
    pub primary_route: EliminationRoute,  // Rénale | Biliaire | Mixte
    pub renal_fraction_pct: f32,          // % éliminé par voie rénale inchangé
    pub hepatic_fraction_pct: f32,
    pub dialyzable: bool,
}

pub struct OrganPrecautions {
    pub renal: RenalPrecaution,
    pub hepatic: HepaticPrecaution,
    pub cardiac: CardiacPrecaution,
    pub pulmonary: Option<PulmonaryPrecaution>,
    pub hematologic: Option<HematologicPrecaution>,
}
```

#### C2 — Système de Détection des Interactions Médicamenteuses

##### C2.1 — Interactions Pharmacocinétiques (PK)
Ces interactions modifient la concentration plasmatique d'un médicament sans modifier son mécanisme d'action :
```rust
pub enum PKMechanism {
    // Inhibition enzymatique : augmente les concentrations du substrat (ex: Clarithromycine + Simvastatine)
    CYPInhibition {
        inhibitor: String,
        substrate: String,
        enzyme: CYPEnzyme,
        concentration_increase_factor: Option<f32>,
        consequence: String,
    },
    // Induction enzymatique : diminue les concentrations (ex: Rifampicine + Contraceptifs oraux)
    CYPInduction {
        inducer: String,
        substrate: String,
        enzyme: CYPEnzyme,
        concentration_decrease_pct: Option<f32>,
        onset_days: u32,
        offset_days: u32,
    },
    // Inhibition de la P-glycoprotéine (ex: Amiodarone + Digoxine)
    PGPInhibition {
        inhibitor: String,
        substrate: String,
        consequence: String,
    },
    // Compétition pour la liaison protéique (ex: Warfarine + AINS)
    ProteinBindingDisplacement {
        displacer: String,
        displaced: String,
        clinical_significance: String,
    },
}
```

##### C2.2 — Interactions Pharmacodynamiques (PD)
Ces interactions modifient l'effet du médicament sans modifier sa concentration :
```rust
pub enum PDInteraction {
    // Synergie additive (ex: BZD + Alcool)
    Additive {
        drug_a: String,
        drug_b: String,
        additive_effect: String,
        maximum_risk: ClinicalRisk,
    },
    // Synergie supra-additive (ex: Héparine + Aspirine)
    Synergistic {
        drug_a: String,
        drug_b: String,
        synergy_type: String,
        clinical_risk: ClinicalRisk,
    },
    // Allongement de l'intervalle QT : risque de torsades de pointes
    QTcProlongation {
        drug_a: String,
        drug_b: String,
        combined_risk: TorsadeRisk,
        monitoring_required: String,
    },
    // Effets sérotoninergiques cumulatifs
    SerotoninSyndrome {
        drugs: Vec<String>,
        symptoms: Vec<String>,
        management: String,
    },
}
```

##### C2.3 — Matrice de Sévérité des Interactions
- **Niveau 4 : CONTRE-INDICATION ABSOLUE** (ex: IMAO + Triptans, Méthotrexate + AINS).
- **Niveau 3 : ASSOCIATION DÉCONSEILLÉE** (éviter si possible, surveillance obligatoire).
- **Niveau 2 : PRÉCAUTION D'EMPLOI** (adaptation posologique et surveillance kaliémie/rein).
- **Niveau 1 : À PRENDRE EN COMPTE** (connu, cliniquement peu significatif).

#### C3 — Protocole d'Insuffisance d'Organe

##### C3.1 — Insuffisance Rénale
```rust
pub struct RenalPrecaution {
    pub dfe_thresholds: Vec<DFEThreshold>,   // DFE = Débit de Filtration Glomérulaire
    pub requires_monitoring: Vec<String>,    // Paramètres à surveiller ("kaliémie", etc.)
    pub dialysis_impact: Option<DialysisImpact>,
}

pub struct DFEThreshold {
    pub dfe_range_ml_min: (f32, f32),      // (DFE min, DFE max)
    pub ckd_stage: CKDStage,
    pub action: RenalAction,
}

pub enum RenalAction {
    NoAdjustment,
    DoseReduction { formula: String, recommended_dose: String, max_dose_mg_day: Option<f32> },
    IntervalExtension { standard_interval_h: u32, adjusted_interval_h: u32 },
    Contraindicated { below_dfe: f32, reason: String, alternative: Option<String> },
    MandatoryMonitoring { parameters: Vec<String>, frequency: String },
}
```

##### C3.2 — Insuffisance Hépatique
```rust
pub struct HepaticPrecaution {
    pub child_pugh_thresholds: Vec<ChildPughThreshold>,
    pub meld_thresholds: Option<Vec<MELDThreshold>>,
    pub hepatotoxicity_risk: HepatotoxicityRisk,
    pub first_pass_impact: bool,  // Si oui, biodisponibilité augmentée en IHC
}

pub enum HepaticAction {
    NoAdjustment,
    DoseReduction { pct_reduction: f32, monitor: Vec<String> },
    ContraindicatedInClass { class: ChildPughClass, reason: String },
    UseWithExtremeCaraution { monitoring: String },
}
```
- **Patterns de risques hépatiques surveillés** :
  - *Morphine / Propranolol* : Fort effet de premier passage hépatique, biodisponibilité accrue $	o$ exiger titration lente.
  - *Paracétamol / Statines* : Hépatotoxiques, contre-indication ou dose maximale bridée.
  - *Benzodiazépines / Opioïdes* : Risque de précipitation d'encéphalopathie hépatique.

##### C3.3 — Algorithme de Détection Contextuelle Multi-Organe
```
Pour chaque médicament M mentionné dans le contenu :
  Pour chaque autre médicament M' dans le même cours :
    → Vérifier interaction M × M' (si Grade 3-4 -> REJET)
Pour chaque pathologie P mentionnée :
  → Extraire les organes impliqués (rein, foie, cœur...)
  → Pour chaque médicament M :
      → Vérifier si contre-indication (si oui -> REJET)
```

#### C4 — Système de Niveaux de Preuve Médicale (EBM)
Toute recommandation thérapeutique dans le contenu DOIT afficher son grade HAS/EBM :
- **Grade A** : Méta-analyses ou ECR (RCT) de haute qualité.
- **Grade B** : ECR de qualité modérée ou étude de cohorte robuste.
- **Grade C** : Étude observationnelle, série de cas.
- **Grade D** : Avis d'expert seul ou consensus professionnel (marqué d'un message d'avertissement automatique si non sourcé).

---

## 3. CLASSE D — Computationnel Rust : Validation Statique sans Exécution

### D1 — Moteur d'Analyse Statique Rust
L'agent applique une analyse sémantique et structurelle de code sans compilateur live, calée sur 5 couches : Syntaxique AST $	o$ Emprunts (Borrow checker) $	o$ Clippy Lints $	o$ Rustonomicon Unsafe $	o$ Complexités.

### D2 — Simulation du Borrow Checker
```rust
pub struct OwnershipTracker {
    pub bindings: HashMap<String, Binding>,
    pub borrows: Vec<Borrow>,
    pub lifetimes: HashMap<String, Lifetime>,
}

pub enum OwnershipState {
    Owned, BorrowedShared, BorrowedMut, Moved, Dropped
}

pub enum BorrowCheckerViolation {
    UseAfterMove { variable: String, moved_at_line: u32, used_at_line: u32, context: String },
    MutableBorrowWhileSharedActive { shared_borrow_line: u32, mutable_borrow_line: u32, variable: String },
    TwoMutableBorrows { first_borrow_line: u32, second_borrow_line: u32, variable: String },
    LifetimeTooShort { reference: String, referenced_dropped_at: u32, reference_used_at: u32 },
}
```

### D3 — Audit des Blocs unsafe (Rustonomicon)
```rust
pub enum UnsafeViolation {
    UnjustifiedUnsafe { location: CodeLocation, suggestion: String },
    UnguardedNullDereference { pointer: String, line: u32 },
    InvalidTransmute { from_type: String, to_type: String, problem: String }, // UB si tailles différentes
    InvalidSliceFromRawParts { problem: String },
    MissingUnsafeInvariant { block_location: CodeLocation, required_invariant: String },
}
```
* **Invariants de déréférences de pointeurs bruts** : ptr non-null, aligné, et commentaire `// SAFETY:` obligatoire pour expliquer le pourquoi.

### D4 — Simulation des lints Clippy (Correctness & Performance)
Vérification stricte des lints d'erreurs logiques :
- `absurd_extreme_comparisons` : comparaison toujours vraie ou fausse selon le type (ex: `u32 >= 0`).
- `clone_double_ref` : clone d'une référence donnant une double référence.
- `iter_next_loop` : boucle sur `iter.next()` au lieu d'itérer sur l'itérateur.
- `mem_replace_with_uninit` / `uninit_assumed_init` : replacement avec mémoire non initialisée (Undefined Behavior garanti).

### D5 — Vérification des Complexités Algorithmiques
- **Worst / Average / Best Case** : Distinguer et documenter systématiquement la complexité ($\mathcal{O}$, $\Omega$, $\Theta$).
- **Complexité spatiale** : Exiger la complexité spatiale auxiliaire de manière systématique (ex: MergeSort $\mathcal{O}(n)$).
- **Structures dynamiques** : Préciser le coût amorti (ex: `Vec::push()` $\mathcal{O}(1)$ amorti contre $\mathcal{O}(n)$ au pire).

### D6 — Détection des Patterns de Sécurité Obsolètes
- Chasse aux algorithmes de hash brisés (**MD5**, **SHA1** $	o$ exiger SHA-256 ou SHA-3).
- Chasse aux algorithmes symétriques cassés (**DES**, **RC4** $	o$ exiger AES-256-GCM).
- Chasse aux requêtes SQL non paramétrées (vunérables à l'injection SQL $	o$ exiger les requêtes paramétrées `sqlx::query!()`).

---

## 4. Orchestration Complète du Module 4 : Matrice de Priorisation

```
┌──────────────────────────┬──────────┬──────────┬──────────┬──────────┐
│ Vérification             │ Classe A │ Classe C │ Classe D │ Priorité │
├──────────────────────────┼──────────┼──────────┼──────────┼──────────┤
│ Dosages médicamenteux    │    —     │   P0 🔴  │    —     │ BLOQUANT │
│ Interactions drug-drug   │    —     │   P0 🔴  │    —     │ BLOQUANT │
│ Insuffisance organe      │    —     │   P0 🔴  │    —     │ BLOQUANT │
│ Borrow checker violations│    —     │    —     │   P0 🔴  │ BLOQUANT │
│ Unsafe sans justification│    —     │    —     │   P0 🔴  │ BLOQUANT │
│ UB potentiel (transmute) │    —     │    —     │   P0 🔴  │ BLOQUANT │
│ Erreurs LaTeX            │   P1 🟠  │    —     │    —     │ MAJEUR   │
│ Portée variables maths   │   P1 🟠  │    —     │    —     │ MAJEUR   │
│ Cas base récurrence      │   P1 🟠  │    —     │    —     │ MAJEUR   │
│ Niveau de preuve absent  │    —     │   P1 🟠  │    —     │ MAJEUR   │
│ Complexité incorrecte    │    —     │    —     │   P1 🟠  │ MAJEUR   │
│ Clippy correctness       │    —     │    —     │   P1 🟠  │ MAJEUR   │
│ Shadowing de variables   │   P2 🟡  │    —     │   P2 🟡  │ MINEUR   │
│ Patterns performance     │    —     │    —     │   P2 🟡  │ MINEUR   │
│ Style idiomatique        │    —     │    —     │   P2 🟡  │ MINEUR   │
└──────────────────────────┴──────────┴──────────┴──────────┴──────────┘

P0 🔴 : Blocage immédiat — le contenu ne peut pas être publié (Rejet transaction Harmonist)
P1 🟠 : Correction obligatoire avant signature — délai maximum 48h
P2 🟡 : Recommandation — améliore la qualité sans bloquer
```

---

## 📜 Les 10 Commandements Invariants de AGENT-16

```
I.   Tu ne laisseras jamais passer une erreur de dosage médical.
     (Classe C — Niveau 0 — Zéro tolérance absolue)
  
II.  Tu ne valideras jamais un contenu qui utilise une corrélation
     comme preuve de causalité sans le signaler explicitement.
  
III. Tu ne laisseras jamais passer un code avec un bug de sécurité mémoire
     présenté comme du "bon code Rust".
  
IV.  Tu ne valideras jamais une citation que tu n'as pas pu vérifier
     dans une base académique reconnue.
  
V.   Tu ne laisseras jamais passer une analogie ELI5 qui falsifie
     la réalité scientifique de la source primaire.
  
VI.  Tu ne valideras jamais un examen qui évalue des compétences
     non enseignées dans le syllabus.
  
VII. Tu ne laisseras jamais passer un consensus scientifique prétendu
     sur un sujet qui fait l'objet d'un débat actif dans la littérature.
  
VIII.Tu ne valideras jamais un contenu médical sans mention du niveau
     de preuve (Grade A/B/C/D) de chaque recommandation.
  
IX.  Tu ne laisseras jamais passer une formule mathématique dont les
     dimensions ou les unités sont incohérentes.
  
X.   Tu ne signeras jamais si le score composite est inférieur au seuil
     de ta classe épistémologique, quelle que soit la pression systémique.
```

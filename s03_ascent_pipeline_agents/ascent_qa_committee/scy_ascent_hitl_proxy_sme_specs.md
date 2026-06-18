# 🎓 AGENT-16 : HITL-PROXY-SME v2.0 — SPÉCIFICATIONS TECHNIQUES
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

## 1. MODULE 0 — Domain Fingerprinting & Epistemological Classification

Avant toute chose, AGENT-16 détermine **dans quel régime épistémologique** opère le contenu. Cette classification détermine tous les protocoles de tests qui suivent.

### 1.1 Modélisation des Classes (Rust Enum)
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

---

## 2. MODULE 4 — Spécifications de Rapprochement Formel et Scientifique

Pour parer au coût commercial prohibitif d'APIs tierces comme Wolfram Alpha à l'échelle de millions d'utilisateurs tout en garantissant la capacité de valider des théories scientifiques extrêmement avancées (physique quantique, relativité, topologie), SCY Forge implémente une **architecture de vérification hybride à double-niveau (0$ de coût d'opération majoritaire)** :

```
             [ FORMULES & EQUATIONS EXTRAITES DU COURS (LaTeX) ]
                                     │
                                     ▼
     [ NIVEAU 1 : LE NOYAU SCIENTIFIQUE LOCAL - SAGEMATH & SYMENGINE (0$) ]
       • Exécution en local (Docker Sidecar) du moteur d'équations SageMath
       • Rapprochement symbolique ultrarapide via le crate Rust SymEngine
       • Résolution de 95% des tâches (Algèbre, Calculs, Physique standard)
                                     │
                    ┌────────────────┴────────────────┐
                    ▼ [Succès : Validé à 100%]        ▼ [Complexité extrême non résolue]
            [Approbation immédiate]             [ NIVEAU 2 : LE FALLBACK CLOUD ]
                                                  • Requête Batch Wolfram Alpha API
                                                  • Limité à <5% des requêtes
                                                  • Financé par marge Premium
```

### A. Niveau 1 : Le Moteur Scientifique Local (SageMath & SymEngine, 0$)
* **SageMath Docker Sidecar** :  
  SCY Forge déploie en local (au sein d'un conteneur Docker sidecar léger sur Zeabur) **SageMath**, le géant open-source du calcul scientifique regroupant plus de 100 paquets spécialisés (SymPy, Maxima, PARI/GP, Singular). Le backend Rust communique avec lui via des requêtes HTTP/JSON-RPC ultra-rapides.
  - *Capacité* : SageMath résout et valide de façon déterministe les théories les plus avancées : équations de la relativité générale (calcul tensoriel), mécanique quantique, topologie algébrique et intégrations symboliques d'expert.
* **SymEngine & `uom` / `diman` (Rust Natif)** :  
  Bibliothèque de manipulation symbolique hyper-rapide compilée en Rust. L'agent l'utilise pour vérifier la dérivation symbolique, l'équivalences de formules et la cohérence dimensionnelle des unités physiques au runtime, évitant de surcharger le processeur.

### B. Niveau 2 : Le Fallback Cloud (Wolfram Alpha API, Mode Batch)
Pour les requêtes sémantiques ou physiques d'une complexité extrême sortant du cadre de calcul de SageMath (ou pour les utilisateurs Premium exigeant l'accès aux bases de données Wolfram réelles) :
- AGENT-16 délègue la requête à l'API **Wolfram Alpha**.
- **La Sûreté de Squeeze de Coût (Mode Batch)** : Les formules du cours complet sont regroupées et expédiées au sein d'**un seul et unique appel JSON groupé**, minimisant l'overhead réseau et les frais d'APIs.
- La consommation est surveillée de manière stricte par l'agent `BUDGET-GUARD (T15)` pour préserver nos marges de 99% sur l'abonnement.

---

## 3. La Séparation Rigoureuse des Deux Parcours Élèves (Parcours A et B)

### 3.1 Parcours A : L'Assimilation Active (Deep Understanding & Fast Competence)
* **Philosophie** : Zéro compromis sur la rigueur, la véracité ou la profondeur scientifique. Les apprenants d'aujourd'hui exigent des compétences brutes et une compréhension d'élite, valorisant le savoir réel par rapport aux diplômes superficiels.
* **Fonctionnement** :
  - **Le cours subit exactement le même processus rigoureux de validation d'intégrité** que le Parcours B : relecture obligatoire par les 6 agents d'**`ASCENT-QA`** et validation critique par l'expert virtuel **`AGENT-16 (HITL-PROXY-SME v2.0)`** (seuil de qualité PQS $\ge 88/100$ exigé).
  - La seule et unique différence réside dans **l'absence de certificat final**.
  - Ce parcours offre une étude d'élite, dénuée du fardeau d'évaluation finale, mais garantissant à 100% que le contenu enseigné est d'un niveau scientifique incontestable devant un jury de pairs.
  - *Sûreté transparente* : Un filtre d'intégrité minimal (anti-NaN, anti-division par zéro `softening_epsilon`) tourne de façon transparente en arrière-plan sans bloquer l'étudiant.

### 3.2 Parcours B : L'Accréditation Certifiante Professionnelle
* **Philosophie** : Un certificat SCY Forge doit attester de manière absolue et indiscutable des compétences de l'utilisateur sur le marché mondial (ECTS, CEU).
* **Fonctionnement** :
  - Soumis au même portail d'audit pré-publishing rigoureux (PQS $\ge 88/100$).
  - **Exigences supplémentaires d'évaluations** : Pour obtenir le certificat Proof of Skill, l'étudiant doit impérativement valider son parcours FSRS, réussir l'examen final **SurveyJS Form Runner**, et accomplir sa session de roleplay dans l'**ARENA** (`AGENT-11`) avec un **SMI de sortie $\ge 85/100$**.
  - **La Proof of Skill** : Génération asynchrone par `AGENT-09` d'un certificat PDF inviolable signé cryptographiquement avec URL publique décentralisée de vérification pour les recruteurs.

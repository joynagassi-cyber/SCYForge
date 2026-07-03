<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎓 PIPELINE DE VALIDATION PÉDAGOGIQUE ASCENT-QA — SCY FORGE v3.5
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

## Spécification de la Couche d'Audit Éditorial, d'Intégrité du Savoir et de Garantie de Certification

**Document ID** : SPEC-SCY-ASCENT-QA-PIPELINE-V1.0  
**Date** : 2026-06-12  
**Statut** : 🔵 PROPOSITION D'ARCHITECTURE PÉDAGOGIQUE (EN ATTENTE D'ITÉRATION UTILISATEUR)  
**Périmètre** : Nouvelle couche de sûreté agentique intégrée au sein d'ASCENT pour auditer, calibrer et valider l'intégrité de formations auto-générées avant d'autoriser l'octroi d'une certification.  
**Invariance** : Aucune modification n'est apportée aux fichiers de production existants du workspace pour ce tour de conception.

---

## 🧭 Table des Matières
1. [La Problématique de la Certification Automatisée : La Sûreté Académique](#1-problem)
2. [Audit des Agents ASCENT Existants face aux Rôles de Sûreté](#2-existing-audit)
3. [Le Pipeline de Validation Pédagogique "ASCENT-QA" (6 Rôles Spécialisés)](#3-qa-pipeline)
4. [L'Algorithme de l'Alignement Constructif (Constructive Alignment Loop)](#4-constructive-alignment)
5. [Le Calcul du Score de Qualité Pédagogique (PQS)](#5-pqs-formula)
6. [Schémas de Base de Données de Traçabilité (Northflank PostgreSQL)](#6-db-schema)

---

## 1. La Problématique de la Certification Automatisée : La Sûreté Académique {#1-problem}

Délivrer une certification (Proof of Skill) à un utilisateur ayant suivi un contenu auto-ingéré pose un **défi de crédibilité majeur**. Si un utilisateur fournit à SCY Forge un PDF biaisé, une vidéo YouTube incomplète ou un fil d'informations superficiel, l'auto-génération classique va synthétiser un cours reflétant ces mêmes lacunes. Autoriser une certification sur un tel matériel détruit la valeur académique de SCY Forge et le décrédibilise face à des géants reconnus et encadrés comme Coursera, Udemy ou des cursus universitaires certifiants (ECTS/CEU).

Pour "dormir tranquille" et s'assurer que chaque certificat délivré atteste d'une **maîtrise réelle, rigoureuse et équivalente à une formation professionnelle certifiée**, nous introduisons la couche **`ASCENT-QA`** :
- **Le Principe de Barrière** : Aucun nœud d'apprentissage auto-généré ne peut être débloqué pour l'étude active s'il n'a pas été préalablement validé et signé électroniquement par un **Comité Pédagogique d'Agents experts**.
- **La Rigueur d'Alignement** : Le contenu du cours et l'examen final (SurveyJS) sont audités ensemble pour s'assurer qu'ils mesurent précisément les compétences visées (principe du *Constructive Alignment*).

---

## 2. Audit des Agents ASCENT Existants face aux Rôles de Sûreté {#2-existing-audit}

Avant d'ajouter de nouveaux agents, analysons comment nos 13 agents ASCENT actuels abordent cette problématique et quelles sont leurs limites :

* **`AGENT-03 : DAG-ARCHITECT`** :  
  * *Rôle actuel* : Construit l'arborescence des nœuds (DAG) et sélectionne les Bloom Levels.
  * *Limite* : Il se focalise sur la structure du chemin d'apprentissage, pas sur la véracité scientifique, la rigueur technique ou l'intégrité rédactionnelle des Knowledge Cards associées.
* **`AGENT-09 : SKILL-CERTIFIER`** :  
  * *Rôle actuel* : Génère les questionnaires d'examens (SurveyJS) et compile le certificat PDF final.
  * *Limite* : Il évalue l'élève à partir du contenu généré, mais il n'audite pas si le contenu d'origine ingéré est suffisant ou corrompu.
* **`AGENT-12 : VISUAL-CRITIC`** & **`AGENT-13 : COGNITIVE-VALIDATOR`** :  
  * *Rôles actuels* : Portes de validations d'intégrité visuelle des schémas (0 cycle) et calibrage de la charge cognitive des phrases selon l'SMI de l'utilisateur.
  * *Limite* : Ils agissent comme des gardiens de "dernière frame" avant l'affichage dans l'UI, mais ils n'ont pas la hauteur de vue didactique pour ré-ordonner un programme, identifier une lacune de syllabus ou fact-checker des lignes de codes face à des standards mondiaux.

**Conclusion** : Il manque un **Comité Éditorial Pédagogique Asynchrone** capable d'agir en amont de l'apprentissage comme un collège de professeurs titulaires.

---

## 3. Le Pipeline de Validation Pédagogique "ASCENT-QA" (6 Rôles Spécialisés) {#3-qa-pipeline}

Pour structurer la génération, nous spécifions **6 sous-agents de validation pédagogique** qui s'exécutent de manière asynchrone (SAGA de production) dès que l'ingestion brute d'un document est complétée :

```
             [ MATIÈRE BRUTE INGÉRÉE ET PARSÉE (Docling) ]
                                   │
                                   ▼
          [ ÉTAPE 1 : CONSTRUIRE LE SYLLABUS ET LE COURS (Rust) ]
                                   │
                                   ▼
        [ ÉTAPE 2 : LE PIPELINE DE PORTAIL DE VALIDATION "ASCENT-QA" ]
          ├── QA-01 : Curriculum Designer (Rigueur de progression)
          ├── QA-02 : Subject Matter Expert (Exactitude technique)
          ├── QA-03 : Alignment Orchestrator (Couverture CEU/Syllabus)
          ├── QA-04 : Cognitive Load Guarantor (Format & Accessibilité)
          ├── QA-05 : Rigorous Content Validator (Calcul du score PQS)
          └── QA-06 : Academic Certifier (Alignement Cours ↔ Examen SurveyJS)
                                   │
                   ┌───────────────┴───────────────┐
                   ▼ [Rejet : PQS < 88/100]        ▼ [Approuvé : PQS ≥ 88]
            [SAGA Compensation /             [Signature électronique &
             Restauration & Réécriture]       Déblocage d'étude active]
```

### 3.1 Spécifications des 6 Rôles d'Audit Pédagogique :

1. **`QA-AGENT-01 : THE SENIOR CURRICULUM DESIGNER` (L'Ingénieur Pédagogique Senior)** :
   - *Ethos & Expertise* : Expert en ingénierie de la formation et taxonomies d'apprentissages (Bloom, Gagne).
   - *Rôle* : Audite la cohérence et l'équilibre du DAG de compétences. Vérifie que la transition entre les nœuds est progressive et qu'il n'y a pas de "sauts conceptuels" impossibles pour un élève débutant.
2. **`QA-AGENT-02 : THE SUBJECT MATTER EXPERT` (L'Expert Technique de Domaine)** :
   - *Ethos & Expertise* : Scientifique titulaire ou ingénieur principal distingué dans le domaine ciblé.
   - *Rôle* : Fact-checke rigoureusement chaque définition, équation LaTeX et exemple de code concret généré par rapport aux sources de vérité primaires et aux standards mondiaux. Élimine les approximations et les hallucinations techniques.
3. **`QA-AGENT-03 : THE ALIGNMENT ORCHESTRATOR` (L'Orchestrateur d'Accréditations)** :
   - *Ethos & Expertise* : Responsable d'accréditations universitaires et professionnelles (CFA, AWS, CEU/ECTS).
   - *Rôle* : Vérifie que le programme auto-généré couvre **100% du syllabus requis** pour la certification visée. Si l'ingestion d'origine a omis un point obligatoire du référentiel d'examen, il ordonne une recherche complémentaire autonome via `AGENT-02` (CONTENT-SCOUT).
4. **`QA-AGENT-04 : THE COGNITIVE LOAD GUARANTOR` (Le Garant de l'Accessibilité)** :
   - *Ethos & Expertise* : Psychologue cogniticien spécialiste des théories de Sweller (charge cognitive) et de Miller.
   - *Rôle* : Audite la densité des fiches concepts (Knowledge Cards) et des exercices. Force le respect de la règle d'accessibilité verticale "1 idée = 1 bloc" et s'assure de la présence d'analogies ELI5 claires pour les notions particulièrement abstraites.
5. **`QA-AGENT-05 : THE RIGOROUS CONTENT VALIDATOR` (L'Auditeur Sémantique)** :
   - *Ethos & Expertise* : Éditeur en chef, relecteur de publications scientifiques.
   - *Rôle* : Parcourt le texte et les exercices générés section-par-section. Évalue la clarté syntaxique, vérifie qu'il n'y a pas de broken-markdown ou d'équations LaTeX mal formées, et calcule le **Score de Qualité Pédagogique (PQS)** global.
6. **`QA-AGENT-06 : THE ACADEMIC CERTIFIER` (Le Garant de l'Alignement Constructif)** :
   - *Ethos & Expertise* : Inspecteur académique, expert du principe de John Biggs (Constructive Alignment).
   - *Rôle* : Audite simultanément les leçons générées et l'examen final (SurveyJS). Vérifie que l'évaluation finale mesure exclusivement et fidèlement les compétences enseignées dans le cours, sans introduire de pièges hors-sujet ou de questions non couvertes dans les Knowledge Cards.

---

## 4. L'Algorithme de l'Alignement Constructif (Constructive Alignment Loop) {#4-constructive-alignment}

Pour qu'une certification ait une valeur indiscutable, il est crucial d'appliquer l'**Alignement Constructif** de Biggs : **ce qui est évalué doit correspondre à ce qui est enseigné, et ce qui est enseigné doit correspondre à la compétence visée**.

Le pipeline `ASCENT-QA` applique une boucle algorithmique de rétroaction sémantique stricte :

```typescript
// features/s03_ascent_pipeline_agents/scy_ascent_qa_alignment.ts
import { Agent } from '@mastra/core';
import { z } from 'zod';

// Définition du schéma d'audit d'alignement constructif de l'Agent QA-06
export const ConstructiveAlignmentSchema = z.object({
  aligned: z.boolean(),
  alignment_score: z.number().min(0).max(100),
  mismatched_objectives: z.array(z.object({
    objective_id: z.string(),
    description: z.string(),
    remediation_required: z.string() // ex: "L'examen pose une question sur la formule X, mais le cours n'enseigne pas l'étape de dérivation."
  })),
  remediation_code: z.string().optional()
});

export const academicCertifierAgent = new Agent({
  id: 'qa-06-academic-certifier-agent',
  model: 'deepseek/deepseek-chat',
  instructions: `Tu es le garant de l'alignement constructif de John Biggs. 
  Tu dois relire le cours généré (Knowledge Cards) et le projet d'examen final (SurveyJS Schema).
  Vérifie que :
  1. Chaque question de l'examen évalue un objectif pédagogique explicitement couvert dans le cours.
  2. Le niveau de difficulté de l'évaluation correspond exactement au niveau de Bloom fixé.
  Rejette la transaction (aligned = false) au moindre écart et décris précisément la remédiation.`,
  outputs: {
    schema: ConstructiveAlignmentSchema
  }
});
```

---

## 5. Le Calcul du Score de Qualité Pédagogique (PQS) {#5-pqs-formula}

Le **Pedagogical Quality Score (PQS)** $S_{\text{pqs}} \in [0, 100]$ détermine si le cours est digne de débloquer l'accès à une certification officielle SCY Forge.

#### L'Équation Globale du PQS :
$$S_{\text{pqs}} = w_d \cdot S_{\text{design}} + w_e \cdot S_{\text{expert}} + w_a \cdot S_{\text{align}} + w_c \cdot S_{\text{cognitive}}$$

Où :
* $S_{\text{design}} \in [0, 100]$ : Score de structure du parcours (attribué par `QA-01`).
* $S_{\text{expert}} \in [0, 100]$ : Score de véracité et d'exactitude scientifique (attribué par `QA-02`).
* $S_{\text{align}} \in [0, 100]$ : Score d'alignement constructif cours-examen (attribué par `QA-06`).
* $S_{\text{cognitive}} \in [0, 100]$ : Score d'accessibilité et de charge cognitive (attribué par `QA-04`).
* Pondérations standards : $w_d = 0.2$, $w_e = 0.3$, $w_a = 0.3$, $w_c = 0.2$.

#### Le Seuil de Sûreté (Garantie de Qualité) :
- **Si $S_{\text{pqs}} \ge 88/100$** : Le Comité Pédagogique valide le contenu. Le cours est débloqué pour l'étude active et l'étudiant est officiellement éligible à la certification finale Proof of Skill.
- **Si $S_{\text{pqs}} < 88/100$** : La transaction d'ouverture du cours est rejetée de manière mécanique par le protocole d'**Harmonist**. Le rapport d'échec du PQS et les critiques d'alignement socratiques sont renvoyés à l'APEX-AGENT de la Neuro-Chain Rust pour forcer une réécriture et une restructuration automatique ciblée du matériel pédagogique.

---

## 6. Schémas de Base de Données de Traçabilité (Northflank PostgreSQL) {#6-db-schema}

Pour consigner de manière transparente les décisions de notre Comité d'agents et rassurer les certificateurs externes, de nouvelles tables d'audits sont planifiées sur **Northflank PostgreSQL** :

```sql
-- == PIPELINE DE PORTAIL DE VALIDATION PÉDAGOGIQUE ASCENT-QA ==

-- Table centrale des sessions d'audits pédagogiques
CREATE TABLE scy_course_qa_audits (
    id                  UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    node_id             UUID NOT NULL,       -- Référence polymorphique au nœud ou projet étudié
    global_pqs_score    INTEGER NOT NULL,    -- Score PQS final (0-100)
    is_approved         BOOLEAN NOT NULL DEFAULT false, -- True si PQS >= 88
    
    -- Détail des sous-scores du Comité d'agents
    design_score        INTEGER NOT NULL,    -- QA-01
    expert_score        INTEGER NOT NULL,    -- QA-02
    alignment_score     INTEGER NOT NULL,    -- QA-06
    cognitive_score     INTEGER NOT NULL,    -- QA-04
    
    created_at          INTEGER NOT NULL,
    completed_at        INTEGER
);

-- Journal des critiques détaillées par agent d'audit
CREATE TABLE scy_qa_agent_reviews (
    id                  UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    audit_id            UUID NOT NULL REFERENCES scy_course_qa_audits(id) ON DELETE CASCADE,
    agent_code          TEXT NOT NULL,       -- 'QA-01' à 'QA-06'
    assigned_score      INTEGER NOT NULL,    -- Score individuel (0-100)
    critical_findings   TEXT NOT NULL,       -- Liste des lacunes ou approximations identifiées
    remediation_prompt  TEXT NOT NULL,       -- Consignes de corrections directes pour la Neuro-Chain
    created_at          INTEGER NOT NULL
);

-- Table des vérifications d'alignement constructif (John Biggs)
CREATE TABLE scy_constructive_alignment_checks (
    id                  UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    audit_id            UUID NOT NULL REFERENCES scy_course_qa_audits(id) ON DELETE CASCADE,
    question_index      INTEGER NOT NULL,    -- Index de la question de l'examen SurveyJS
    target_objective_id TEXT NOT NULL,       -- Objectif pédagogique du cours visé
    is_aligned          BOOLEAN NOT NULL DEFAULT true,
    mismatch_details    TEXT,
    created_at          INTEGER NOT NULL
);

-- Index pour la console de modération administrative
CREATE INDEX idx_qa_audits_node ON scy_course_qa_audits(node_id);
CREATE INDEX idx_qa_reviews_audit ON scy_qa_agent_reviews(audit_id, agent_code);
```

---

## 🏁 Conclusion & Prochaines Étapes

Cette spécification pour la couche **`ASCENT-QA`** érige une barrière d'intégrité pédagogique d'une rigueur absolue. Elle élimine définitivement les craintes liées à l'automatisation en s'assurant que chaque formation auto-générée subit un **audit de pair-review multi-agents aussi strict (voire supérieur) que les comités de relecture des grandes plateformes mondiales**.

*Note : Conformément à vos consignes de sécurité et d'itération, aucune modification n'a été apportée aux documents d'origines. Ce plan d'ingénierie est ouvert à l'analyse et à l'affinement avant toute implémentation concrète.*

**Que pensez-vous de l'architecture de cette boucle d'alignement constructif et des 6 rôles de notre Comité Pédagogique ? Souhaitez-vous que nous y apportions des modifications ou des affinements ?**
